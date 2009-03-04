From: akpm@linux-foundation.org
Subject: + input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch added to -mm tree
Date: Wed, 04 Mar 2009 13:45:33 -0800
Message-ID: <200903042145.n24LjYoc006189@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756962AbZCDVqI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2009 16:46:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mamurph@cs.clemson.edu, dtor@mail.ru


The patch titled
     input: Documentation/input/xpad.txt: Update for new  driver functionality
has been added to the -mm tree.  Its filename is
     input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: Documentation/input/xpad.txt: Update for new  driver functionality
From: Mike Murphy <mamurph@cs.clemson.edu>

Update to Documentation/input/xpad.txt to describe new driver
functionality in this patchset.

Signed-off-by: Mike Murphy <mamurph@cs.clemson.edu>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/input/xpad.txt |  237 +++++++++++++++++++++++++--------
 1 file changed, 186 insertions(+), 51 deletions(-)

diff -puN Documentation/input/xpad.txt~input-documentation-input-xpadtxt-update-for-new-driver-functionality Documentation/input/xpad.txt
--- a/Documentation/input/xpad.txt~input-documentation-input-xpadtxt-update-for-new-driver-functionality
+++ a/Documentation/input/xpad.txt
@@ -1,17 +1,19 @@
 xpad - Linux USB driver for X-Box gamepads
 
-This is the very first release of a driver for X-Box gamepads.
-Basically, this was hacked away in just a few hours, so don't expect
-miracles.
-
-In particular, there is currently NO support for the rumble pack.
-You won't find many ff-aware linux applications anyway.
+This is an updated version of the Xbox gamepad driver, which supports original
+Xbox controllers, Xbox 360 wired controllers, and Xbox 360 wireless controllers
+via the "Wireless Gaming Receiver for Windows" adapter from Microsoft.
+
+Rumble effects are supported by this version of the driver. You need a game
+capable of producing ff effects, and the /dev/input/event* interface
+corresponding to the controller you are using needs to be WRITABLE by your
+user account.
 
 
 0. Notes
 --------
 
-Driver updated for kernel 2.6.17.11. (Based on a patch for 2.6.11.4.)
+Driver updated for kernel 2.6.28.7.
 
 The number of buttons/axes reported varies based on 3 things:
 - if you are using a known controller
@@ -33,18 +35,19 @@ With a normal controller, the directiona
 The jstest-program from joystick-1.2.15 (jstest-version 2.1.0) will report 8
 axes and 10 buttons.
 
-All 8 axes work, though they all have the same range (-32768..32767)
-and the zero-setting is not correct for the triggers (I don't know if that
-is some limitation of jstest, since the input device setup should be fine. I
-didn't have a look at jstest itself yet).
+All 8 axes work. By default, the stick axes report values from -32767 to
+32767, while the triggers report values from 0 to 32767. Prior versions
+of this driver reported -32767 to 32767 for the triggers; this behavior
+can be restored via the sysfs interface (see below).
 
 All of the 10 buttons work (in digital mode). The six buttons on the
 right side (A, B, X, Y, black, white) are said to be "analog" and
 report their values as 8 bit unsigned, not sure what this is good for.
+(For the Xbox 360 controllers, these are now simply digital buttons.)
 
-I tested the controller with quake3, and configuration and
-in game functionality were OK. However, I find it rather difficult to
-play first person shooters with a pad. Your mileage may vary.
+This version of the driver has been tested mostly with game emulators for
+legacy console systems. While it "should" work with any games, your mileage
+may vary.
 
 
 0.2 Xbox Dance Pads
@@ -65,7 +68,17 @@ of buttons, see section 0.3 - Unknown Co
 I've tested this with Stepmania, and it works quite well.
 
 
-0.3 Unknown Controllers
+0.3 Wireless Guitars
+--------------------
+
+I have tested a RedOctane wireless guitar and have found it to work with
+this driver. All events, except for the acclerometer, are reported as buttons.
+Acclerometer inputs are reported as axes for both vertical and horizontal
+displacement of the guitar itself; however, the horizontal displacement
+sensor is extremely sensitive and might be useless in practice.
+
+
+0.4 Unknown Controllers
 ----------------------
 If you have an unknown xbox controller, it should work just fine with
 the default settings.
@@ -73,19 +86,13 @@ the default settings.
 HOWEVER if you have an unknown dance pad not listed below, it will not
 work UNLESS you set "dpad_to_buttons" to 1 in the module configuration.
 
-PLEASE, if you have an unknown controller, email Dom <binary1230@yahoo.com> with
-a dump from /proc/bus/usb and a description of the pad (manufacturer, country,
-whether it is a dance pad or normal controller) so that we can add your pad
-to the list of supported devices, ensuring that it will work out of the
-box in the future.
-
 
-1. USB adapter
---------------
+1. USB adapter for ORIGINAL Xbox Controllers
+--------------------------------------------
 
-Before you can actually use the driver, you need to get yourself an
-adapter cable to connect the X-Box controller to your Linux-Box. You
-can buy these online fairly cheap, or build your own.
+Before you can actually use the driver with an ORIGINAL Xbox controller, you
+need to get yourself an adapter cable to connect the X-Box controller to
+your Linux-Box. You can buy these online fairly cheap, or build your own.
 
 Such a cable is pretty easy to build. The Controller itself is a USB
 compound device (a hub with three ports for two expansion slots and
@@ -102,29 +109,55 @@ original one. You can buy an extension c
 you can still use the controller with your X-Box, if you have one ;)
 
 
-2. Driver Installation
+2. Xbox 360 Controllers
+-----------------------
+
+For Xbox 360 WIRED controllers (i.e. ones that come with a permanently attached
+USB cable), you need only plug in the controller, and you're ready to play. The
+LED ring display on the controller will illuminate 1-4 in response to which
+joystick device (/dev/input/js1 to /dev/input/js4) the controller is attached.
+The LED display will "wrap" around for /dev/input/js5 and higher.
+
+For Xbox 360 WIRELESS controllers, you need to purchase a "Wireless Gaming
+Receiver for Windows" adapter* from Microsoft (about $20 in the US at the time
+of this writing). Up to 4 wireless devices (controllers, guitars, etc.) can
+be connected to a single "Wireless Gaming Receiver" -- just push the button
+on the gaming receiver until the light on it blinks, then push the connect
+button on the wireless controller until the leds show a circling pattern.
+Once you make this connection, the controller will remember the receiver and
+automatically reconnect to it, provided you don't associate the controller
+with a different receiver or an actual Xbox 360.
+
+When a wireless 360 device is connected, the LED ring on the controller will
+illuminate 1-4 in response to the "slot" on the wireless receiver to which
+the device connects. The first device to connect will attach to slot 1, the
+second to slot 2, and so forth. If you remove the batteries, then re-power
+the controllers in a different order, you can change which controller
+connects to which slot.
+
+To power off a wireless controller, remove the battery pack. EVEN THOUGH A
+WIRELESS CONTROLLER MAY GO INTO "STANDBY" MODE (no led display), it may STILL
+DRAW POWER FROM THE BATTERIES.
+
+* Contrary to what might seem like a good idea, you CANNOT turn a wireless
+360 controller into a wired controller. The "Play and Charge" cable ONLY
+PROVIDES POWER to the controller, NOT a connection interface. The controller
+still connects wirelessly, and so you still need a wireless receiver. Yes,
+the "Play and Charge" cable will show up in lsusb and has a basic descriptor
+on the bus, but there is no actual device to which to connect (I tried
+modifying the driver to recognize it and wound up with a null pointer oops).
+
+
+3. Driver Installation
 ----------------------
 
-Once you have the adapter cable and the controller is connected, you need
-to load your USB subsystem and should cat /proc/bus/usb/devices.
-There should be an entry like the one at the end [4].
-
-Currently (as of version 0.0.6), the following devices are included:
- original Microsoft XBOX controller (US), vendor=0x045e, product=0x0202
- smaller  Microsoft XBOX controller (US), vendor=0x045e, product=0x0289
- original Microsoft XBOX controller (Japan), vendor=0x045e, product=0x0285
- InterAct PowerPad Pro (Germany), vendor=0x05fd, product=0x107a
- RedOctane Xbox Dance Pad (US), vendor=0x0c12, product=0x8809
-
-The driver should work with xbox pads not listed above as well, however
-you will need to do something extra for dance pads to work.
-
-If you have a controller not listed above, see 0.3 - Unknown Controllers
-
-If you compiled and installed the driver, test the functionality:
-> modprobe xpad
-> modprobe joydev
-> jstest /dev/js0
+On a modern Linux system, the xpad driver should be loaded automatically.
+You may need to make some userspace modifications to prevent X11 from picking
+up your controller as a pointer device, and you might also need to set
+permissions on /dev/input/js* and /dev/input/event* to enable reading (and
+writing, if you want rumble effects) by your user account.
+
+See: http://cirg.cs.clemson.edu/~mamurph/pub/xpad
 
 If you're using a normal controller, there should be a single line showing
 18 inputs (8 axes, 10 buttons), and its values should change if you move
@@ -133,8 +166,102 @@ show 20 inputs (6 axes, 14 buttons).
 
 It works? Voila, you're done ;)
 
+Well, almost: there is now a sysfs interface for making changes to default
+behaviors on the fly.
+
+
+4. SysFs Interface
+------------------
+
+With this version of the xpad driver, there is a sysfs interface for making
+changes and adjustments. The interface is documented in
+Documentation/ABI/testing/game_device-sysfs-interface.
+
+For reading and making changes to the adjustable parameters (below), look
+for a game_device directory in /sys/class/input/input* (there will be one
+of these directories for each wired xpad device, and four such directories
+with each wireless receiver).
+
+
+5. Adjustments
+--------------
+
+A number of parameters can be adjusted via the sysfs interface, which are
+documented below. First, however, we present a few concepts:
+
+1. The range of an axis is 0 to 32767. Positive and negative values represent
+   the DIRECTION in which the axis is deflected. All adjustable parameters
+   deal with absolute magnitude, so they use positive numbers.
+
+2. Xbox and Xbox 360 controllers are "radial axis" controllers. That is, the
+   analog sticks are constrained (by the plastic of the stick opening) to a
+   circular range, such that x**2 + y**2 <= 1 for all input values x and y.
+   This behavior contrasts to PC joysticks and older console controllers,
+   which had a "square axis" that kept the x and y values independent of one
+   another.
 
-3. Thanks
+
+* Dead Zones
+  ----------
+
+  A dead zone is a region around the center of the stick in which all inputs
+  are ignored. They help to combat sticks that do not center perfectly, at the
+  expense of reduced sensitivity. By default, the dead zones for both sticks
+  are set at 8192 (out of a range from 0 to 31743; the controller reports a
+  maximum absolute value of 32767).
+
+  Dead zones can be set per-stick by adjusting the left_dead_zone and
+  right_dead_zone values in sysfs.
+
+
+* Stick Limits (Square Axis Mapping)
+  ----------------------------------
+
+  Stick limits allow the radial axes of the controller sticks to be mapped to
+  square axes, for better performance in older games or emulators. This mapping
+  occurs by inscribing a square inside the circle defined by the plastic
+  housing of the controller. By default, the stick limits are set to 32767,
+  which causes the plastic to take precedence, resulting in a radial axis.
+
+  Recall that x**2 + y**2 <= 1 for all x and y in a radial axis. Thus, the
+  largest square that can be inscribed inside the circle is one whose corners
+  have |x| = |y| (absolute values to ignore direction). Thus, solving for
+  x = y, we have 2 * (x ** 2) = 1, or x = sqrt(1/2), which works out to around
+  0.707. Multiplying by the maximum output of the controller (32767) gives
+  a stick limit of 23170 for the size of the maximum inscribed square.
+
+  Unfortunately, hardware variations do exist between controllers, so a smaller
+  stick limit by needed to achieve the desired square axis effect. In all
+  cases, the driver will enforce the limitation that the stick limit must be
+  greater than the size of the dead zone plus 1024.
+
+  Stick limits can be set per-stick by adjusting the left_stick_limit and
+  right_stick_limit values in sysfs.
+
+
+* Rumble Enable/Disable
+  ---------------------
+
+  Rumble effects can be disabled for a controller by setting the rumble_enable
+  value in sysfs.
+
+
+* Full Trigger Axes
+  -----------------
+
+  By default, both the left and right triggers will report 0 when not
+  depressed, increasing to 32767 when depressed fully. In many cases, this
+  behavior will be the desired behavior, as the game will see the axis as
+  non-deflected when the trigger is not pressed.
+
+  However, older versions of the driver mapped the triggers to full axes,
+  such that -32767 was reported for a non-depressed trigger, increasing to
+  32767 when depressed fully. This behavior might be desired by some users,
+  and it can be re-enabled on a per-trigger basis by setting the
+  left_trigger_full_axis and right_trigger_full_axis values in sysfs.
+
+
+6. Thanks
 ---------
 
 I have to thank ITO Takayuki for the detailed info on his site
@@ -144,15 +271,19 @@ His useful info and both the usb-skeleto
 (Greg Kroah-Hartmann; Vojtech Pavlik) helped a lot in rapid prototyping
 the basic functionality.
 
+Thanks to Oliver Neukum, Greg Kroah-Hartmann, and Frederic Weisbecker for
+their assistance with the wireless 360 and sysfs enhancements.
 
-4. References
+
+7. References
 -------------
 
 1. http://euc.jp/periphs/xbox-controller.ja.html (ITO Takayuki)
 2. http://xpad.xbox-scene.com/
 3. http://www.xboxhackz.com/Hackz-Reference.htm
+4. http://pingus.seul.org/~grumbel/xboxdrv/
 
-4. /proc/bus/usb/devices - dump from InterAct PowerPad Pro (Germany):
+8. /proc/bus/usb/devices - dump from InterAct PowerPad Pro (Germany):
 
 T:  Bus=01 Lev=03 Prnt=04 Port=00 Cnt=01 Dev#=  5 Spd=12  MxCh= 0
 D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=32 #Cfgs=  1
@@ -162,7 +293,7 @@ I:  If#= 0 Alt= 0 #EPs= 2 Cls=58(unk. ) 
 E:  Ad=81(I) Atr=03(Int.) MxPS=  32 Ivl= 10ms
 E:  Ad=02(O) Atr=03(Int.) MxPS=  32 Ivl= 10ms
 
-5. /proc/bus/usb/devices - dump from Redoctane Xbox Dance Pad (US):
+9. /proc/bus/usb/devices - dump from Redoctane Xbox Dance Pad (US):
 
 T:  Bus=01 Lev=02 Prnt=09 Port=00 Cnt=01 Dev#= 10 Spd=12  MxCh= 0
 D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
@@ -181,3 +312,7 @@ Marko Friedemann <mfr@bmx-chemnitz.de>
 Dominic Cerquetti <binary1230@yahoo.com>
 2005-03-19
  - added stuff for dance pads, new d-pad->axes mappings
+
+Mike Murphy <mamurph@cs.clemson.edu>
+2009-02-28
+- added sysfs interface and wireless 360 support
_

Patches currently in -mm which might be from mamurph@cs.clemson.edu are

input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
input-documentation-abi-testing-game_device-sysfs-interface-document-game_device-interface-added-to-xpad-driver.patch

