import 'dart:io' show Platform;

import 'package:bitsdojo_window_linux/bitsdojo_window_linux.dart';
import 'package:bitsdojo_window_macos/bitsdojo_window_macos.dart';
import 'package:bitsdojo_window_platform_interface/bitsdojo_window_platform_interface.dart';
import 'package:bitsdojo_window_platform_interface/method_channel_bitsdojo_window.dart';
import 'package:bitsdojo_window_windows/bitsdojo_window_windows.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';

bool _platformInstanceNeedsInit = true;

void initPlatformInstance() {
  if (!kIsWeb) {
    if (BitsdojoWindowPlatform.instance is MethodChannelBitsdojoWindow) {
      if (Platform.isWindows) {
        BitsdojoWindowPlatform.instance = BitsdojoWindowWindows();
      } else if (Platform.isMacOS) {
        BitsdojoWindowPlatform.instance = BitsdojoWindowMacOS();
      } else if (Platform.isLinux) {
        BitsdojoWindowPlatform.instance = BitsdojoWindowLinux();
      }
    }
  } else {
    BitsdojoWindowPlatform.instance = BitsdojoWindowPlatformNotImplemented();
  }
}

BitsdojoWindowPlatform get _platform {
  final needsInit = _platformInstanceNeedsInit;
  if (needsInit) {
    initPlatformInstance();
    _platformInstanceNeedsInit = false;
  }
  return BitsdojoWindowPlatform.instance;
}

void doWhenWindowReady(VoidCallback callback) {
  _platform.doWhenWindowReady(callback);
}

DesktopWindow? get appWindow =>
    !kIsWeb && (Platform.isLinux || Platform.isMacOS || Platform.isWindows)
        ? _platform.appWindow
        : null;