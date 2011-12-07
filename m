From: akpm@linux-foundation.org
Subject: + sony-laptop-fix-scancodes.patch added to -mm tree
Date: Wed, 07 Dec 2011 15:18:16 -0800
Message-ID: <201112072318.pB7NIGuX013148@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:41207 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab1LGXST (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Dec 2011 18:18:19 -0500
Received: by ggnp2 with SMTP id p2so132031ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Dec 2011 15:18:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: john@calvaedi.com, dan.carpenter@oracle.com, john@Calva.COMjohn@Calva.COM, malattia@linux.it, mjg@redhat.com


The patch titled
     Subject: sony-laptop: fix scancodes
has been added to the -mm tree.  Its filename is
     sony-laptop-fix-scancodes.patch

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
Subject: sony-laptop: fix scancodes

The scancodes returned by the sony-laptop driver for function keys did not
match the scancodes used to remap keys.  Also, since the scancode was sent
to the input subsystem after the mapped keysym the /lib/udev/keymap
utility was confused about which scancode to report for which keysym.

This patch fixes the driver so the correct scancode is shown for each key.
 It also adds to the documentation a description of where to find the
scancodes.

Signed-off-by: John Hughes <john@calva.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mattia Dongili <malattia@linux.it>
Cc: John Hughes <john@Calva.COM>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/laptops/sony-laptop.txt |    5 +++++
 drivers/platform/x86/sony-laptop.c    |   13 ++++++++-----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff -puN Documentation/laptops/sony-laptop.txt~sony-laptop-fix-scancodes Documentation/laptops/sony-laptop.txt
--- a/Documentation/laptops/sony-laptop.txt~sony-laptop-fix-scancodes
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
diff -puN drivers/platform/x86/sony-laptop.c~sony-laptop-fix-scancodes drivers/platform/x86/sony-laptop.c
--- a/drivers/platform/x86/sony-laptop.c~sony-laptop-fix-scancodes
+++ a/drivers/platform/x86/sony-laptop.c
@@ -347,6 +347,7 @@ static void sony_laptop_report_input_eve
 	struct input_dev *jog_dev = sony_laptop_input.jog_dev;
 	struct input_dev *key_dev = sony_laptop_input.key_dev;
 	struct sony_laptop_keypress kp = { NULL };
+	int scancode = -1;
 
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
@@ -389,9 +390,11 @@ static void sony_laptop_report_input_eve
 	}
 
 	if (kp.dev) {
+		/* if we have a scancode we emit it so we can always
+                   remap the key */
+		if (scancode != -1)
+			input_event(kp.dev, EV_MSC, MSC_SCAN, scancode);
 		input_report_key(kp.dev, kp.key, 1);
-		/* we emit the scancode so we can always remap the key */
-		input_event(kp.dev, EV_MSC, MSC_SCAN, event);
 		input_sync(kp.dev);
 
 		/* schedule key release */
@@ -466,7 +469,7 @@ static int sony_laptop_setup_input(struc
 	jog_dev->name = "Sony Vaio Jogdial";
 	jog_dev->id.bustype = BUS_ISA;
 	jog_dev->id.vendor = PCI_VENDOR_ID_SONY;
-	key_dev->dev.parent = &acpi_device->dev;
+	jog_dev->dev.parent = &acpi_device->dev;
 
 	input_set_capability(jog_dev, EV_KEY, BTN_MIDDLE);
 	input_set_capability(jog_dev, EV_REL, REL_WHEEL);
_
Subject: Subject: sony-laptop: fix scancodes

Patches currently in -mm which might be from john@calvaedi.com are

sony-laptop-fix-scancodes.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch

