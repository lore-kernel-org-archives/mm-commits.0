From: akpm@linux-foundation.org
Subject: + drivers-platform-x86-sony-laptopc-fix-scancodes.patch added to -mm tree
Date: Thu, 17 Nov 2011 15:52:27 -0800
Message-ID: <201111172352.pAHNqRHL011392@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:54486 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab1KQXwd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2011 18:52:33 -0500
Received: by wwe5 with SMTP id 5so55431wwe.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2011 15:52:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: john@calvaedi.com, dtor@mail.ru, john@calva.com, malattia@linux.it, mjg@redhat.com


The patch titled
     Subject: drivers/platform/x86/sony-laptop.c: fix scancodes
has been added to the -mm tree.  Its filename is
     drivers-platform-x86-sony-laptopc-fix-scancodes.patch

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
From: John Hughes <john@calvaedi.com>
Subject: drivers/platform/x86/sony-laptop.c: fix scancodes

The scancodes returned by the sony-laptop driver for function keys did not
match the scancodes used to remap keys.  Also, since the scancode was sent
to the input subsystem after the mapped keysym the /lib/udev/keymap
utility was confused about which scancode to report for which keysym.

This patch fixes the driver so the correct scancode is shown for each key.
 It also adds to the documentation a description of where to find the
scancodes.

Before the patch FN/E returned scancode 0x1B, but to remap scancode 0x14
had to be used.

Signed-off-by: John Hughes <john@calva.com>
Cc: Mattia Dongili <malattia@linux.it>
Cc: Matthew Garrett <mjg@redhat.com>
Acked-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/laptops/sony-laptop.txt |    5 +++++
 drivers/platform/x86/sony-laptop.c    |    9 +++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff -puN Documentation/laptops/sony-laptop.txt~drivers-platform-x86-sony-laptopc-fix-scancodes Documentation/laptops/sony-laptop.txt
--- a/Documentation/laptops/sony-laptop.txt~drivers-platform-x86-sony-laptopc-fix-scancodes
+++ a/Documentation/laptops/sony-laptop.txt
@@ -17,6 +17,11 @@ subsystem. See the logs of acpid or /pro
 devices are created by the driver. Additionally, loading the driver with the
 debug option will report all events in the kernel log.
 
+The "scancodes" passed to the input system (that can be remapped with udev)
+are indexes to the table "sony_laptop_input_keycode_map" in the sony-laptop.c
+module.  For example the "FN/E" key combination (EJECTCD on some models)
+generates the scancode 20 (0x14).
+
 Backlight control:
 ------------------
 If your laptop model supports it, you will find sysfs files in the
diff -puN drivers/platform/x86/sony-laptop.c~drivers-platform-x86-sony-laptopc-fix-scancodes drivers/platform/x86/sony-laptop.c
--- a/drivers/platform/x86/sony-laptop.c~drivers-platform-x86-sony-laptopc-fix-scancodes
+++ a/drivers/platform/x86/sony-laptop.c
@@ -347,6 +347,7 @@ static void sony_laptop_report_input_eve
 	struct input_dev *jog_dev = sony_laptop_input.jog_dev;
 	struct input_dev *key_dev = sony_laptop_input.key_dev;
 	struct sony_laptop_keypress kp = { NULL };
+	int scancode;
 
 	if (event == SONYPI_EVENT_FNKEY_RELEASED ||
 			event == SONYPI_EVENT_ANYBUTTON_RELEASED) {
@@ -380,8 +381,8 @@ static void sony_laptop_report_input_eve
 			dprintk("sony_laptop_report_input_event, event not known: %d\n", event);
 			break;
 		}
-		if (sony_laptop_input_index[event] != -1) {
-			kp.key = sony_laptop_input_keycode_map[sony_laptop_input_index[event]];
+		if ((scancode = sony_laptop_input_index[event]) != -1) {
+			kp.key = sony_laptop_input_keycode_map[scancode];
 			if (kp.key != KEY_UNKNOWN)
 				kp.dev = key_dev;
 		}
@@ -389,9 +390,9 @@ static void sony_laptop_report_input_eve
 	}
 
 	if (kp.dev) {
-		input_report_key(kp.dev, kp.key, 1);
 		/* we emit the scancode so we can always remap the key */
-		input_event(kp.dev, EV_MSC, MSC_SCAN, event);
+		input_event(kp.dev, EV_MSC, MSC_SCAN, scancode);
+		input_report_key(kp.dev, kp.key, 1);
 		input_sync(kp.dev);
 
 		/* schedule key release */
_
Subject: Subject: drivers/platform/x86/sony-laptop.c: fix scancodes

Patches currently in -mm which might be from john@calvaedi.com are

drivers-platform-x86-sony-laptopc-fix-scancodes.patch

