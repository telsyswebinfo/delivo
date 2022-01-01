import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:zomox_driver/config/Palette.dart';
import 'package:zomox_driver/config/app_string.dart';
import 'package:zomox_driver/config/prefConstatnt.dart';
import 'package:zomox_driver/const/preference.dart';
import 'package:zomox_driver/localization/localization_constant.dart';
import 'package:zomox_driver/model/login_model.dart';
import 'package:zomox_driver/model/setting_model.dart';
import 'package:zomox_driver/retrofit/Retrofit_Api.dart';
import 'package:zomox_driver/retrofit/base_model.dart';
import 'package:zomox_driver/retrofit/network_api.dart';
import 'package:zomox_driver/retrofit/server_error.dart';
import 'package:zomox_driver/screens/Authentication/RegisterScreen.dart';
import 'package:zomox_driver/screens/Profile/UploadDocumentScreen.dart';
import '../Profile/DeliveryZoneScreen.dart';
import 'ForgotPasswordScreen.dart';
import '../HomePageScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool? rememberMe = false;

  bool _isHidden = true;
  String? verify = "";
  int? id = 0;
  String? drivingLicense = "";
  String? documentImg = "";
  String? documentType = "";

  String? deviceToken = "";

  @override
  void initState() {
    super.initState();
    callApiSetting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(
            new FocusNode(),
          );
        },
        child: Form(
          key: formKey,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.zero,
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.45,
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        'assets/images/splashscreen_back.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      height: 400,
                      width: MediaQuery.of(context).size.width,
                      // color: Colors.red,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                            child: TextFormField(
                              style: TextStyle(color: Palette.loginHead),
                              controller: this.emailController,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                  borderSide: BorderSide(color: Palette.loginHead, width: 2.0),
                                ),
                                border: UnderlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                  borderSide: BorderSide(color: Palette.loginHead, width: 2.0),
                                ),
                                labelText: getTranslated(context, login_label_name).toString(),
                                labelStyle: TextStyle(color: Palette.loginHead),
                              ),
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return getTranslated(context, login_name_validator_1).toString();
                                }
                                if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                                  return getTranslated(context, login_name_validator_2).toString();
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: TextFormField(
                              obscureText: _isHidden,
                              style: TextStyle(color: Palette.loginHead),
                              controller: this.passwordController,
                              decoration: InputDecoration(
                                suffix: InkWell(
                                  onTap: _togglePasswordView,
                                  child: Icon(
                                    _isHidden ? Icons.visibility : Icons.visibility_off,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                  borderSide: BorderSide(color: Palette.loginHead, width: 2.0),
                                ),
                                border: UnderlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                  borderSide: BorderSide(color: Palette.loginHead, width: 2.0),
                                ),
                                labelText: getTranslated(context, login_label_password).toString(),
                                labelStyle: TextStyle(color: Palette.loginHead),
                              ),
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return getTranslated(context, login_password_validator_1).toString();
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      child: Checkbox(
                                        checkColor: Palette.white,
                                        activeColor: Palette.loginHead,
                                        value: this.rememberMe,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            this.rememberMe = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Text(
                                      getTranslated(context, remember_me).toString(),
                                      style: TextStyle(color: Palette.loginHead, fontSize: 15),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ForgotPasswordScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    getTranslated(context, forgot_password).toString(),
                                    style: TextStyle(color: Palette.loginHead, fontSize: 15),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: MaterialButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  callApiLogin();
                                }
                              },
                              color: Palette.loginHead,
                              height: 50.0,
                              minWidth: double.infinity,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Text(
                                getTranslated(context, login_button).toString(),
                                style: TextStyle(color: Palette.white, fontSize: 16.0),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  getTranslated(context, login_an_account).toString(),
                                  style: TextStyle(color: Palette.loginHead, fontSize: 14.0),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                        builder: (context) => RegisterScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    " " + getTranslated(context, login_Signup).toString(),
                                    style: TextStyle(color: Palette.loginHead, fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<BaseModel<LoginModel>> callApiLogin() async {
    Map<String, dynamic> body = {
      "email": emailController.text.toString(),
      "password": passwordController.text.toString(),
      "device_token": deviceToken,
    };
    log('body: $body');
    LoginModel response;
    try {
      response = await RestClient(RetroApi().dioData()).loginRequest(body);
      setState(() {
        log('response: $response');
        if (response.success == true) {
          log('success: $response.success');
          id = response.data!.id;
          verify = response.data!.isVerified;
          drivingLicense = response.data!.drivingLicense;
          documentImg = response.data!.documentImg;
          documentType = response.data!.documentType;

          SharedPreferenceHelper.setString(Preferences.auth_token, response.data!.token!);
          SharedPreferenceHelper.setString(Preferences.driverStatus, response.data!.isOnline.toString());
          SharedPreferenceHelper.setString(Preferences.driverName, response.data!.name.toString());
          SharedPreferenceHelper.setString(Preferences.driverPhoneNo, response.data!.phone.toString());
          SharedPreferenceHelper.setString(Preferences.driverPhoneCode, response.data!.phoneCode.toString());
          SharedPreferenceHelper.setString(Preferences.driverEmail, response.data!.email.toString());
          SharedPreferenceHelper.setString(Preferences.owner_id, response.data!.ownerId.toString());
          SharedPreferenceHelper.setString(Preferences.notification, response.data!.notification.toString());

          if (response.data!.drivingLicense == null && response.data!.documentImg == null && response.data!.documentType == null) {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => UploadDocumentScreen(),
              ),
            );
          } else if (response.data!.deliveryZoneId == null) {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => DeliveryZoneScreen(),
              ),
            );
          } else {
            SharedPreferenceHelper.setBoolean(Preferences.is_logged_in, true);
            Navigator.pushReplacement(
              context,
              new MaterialPageRoute(
                builder: (context) => HomePageScreen(),
              ),
            );
          }
          Fluttertoast.showToast(
            msg: 'Login Successfully',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        } else {
          log('success: "1');
          Fluttertoast.showToast(
            msg: '${response.msg!}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      });
    } catch (error, stacktrace) {
      log('stacktrace: $stacktrace');
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<SettingModel>> callApiSetting() async {
    SettingModel response;
    setState(() {});
    try {
      log('success: "1');
      response = await RestClient(RetroApi().dioData()).settingRequest();
      setState(() {
        getOneSingleToken(response.data!.driverAppId);
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<void> getOneSingleToken(appId) async {
    try {
      OneSignal.shared.consentGranted(true);
      OneSignal.shared.setAppId(appId);
      OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
      await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
      OneSignal.shared.promptLocationPermission();
      await OneSignal.shared.getDeviceState().then((value) {
        return SharedPreferenceHelper.setString(Preferences.device_token, value!.userId!);
      });
    } catch (e) {
      print("error${e.toString()}");
    }

    setState(() {
      deviceToken = SharedPreferenceHelper.getString(Preferences.device_token);
    });
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
