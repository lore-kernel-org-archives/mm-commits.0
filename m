From: akpm@linux-foundation.org
Subject: [merged] drivers-platform-x86-sony-laptopc-fix-scancodes.patch removed from -mm tree
Date: Wed, 14 Mar 2012 14:24:40 -0700
Message-ID: <20120314212440.88F1CA076E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:58917 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761389Ab2CNVYm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Mar 2012 17:24:42 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id i8so95996laa.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Mar 2012 14:24:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: john@calvaedi.com, dtor@mail.ru, john@calva.com, malattia@linux.it, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/platform/x86/sony-laptop.c: fix scancodes
has been removed from the -mm tree.  Its filename was
     drivers-platform-x86-sony-laptopc-fix-scancodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: John Hughes <john@calva.com>
Cc: Mattia Dongili <malattia@linux.it>
Cc: Matthew Garrett <mjg@redhat.com>
Acked-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/laptops/sony-laptop.txt |    5 +++++
 drivers/platform/x86/sony-laptop.c    |   16 +++++++++++-----
 2 files changed, 16 insertions(+), 5 deletions(-)

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
+	int scancode = -1;
 
 	if (event == SONYPI_EVENT_FNKEY_RELEASED ||
 			event == SONYPI_EVENT_ANYBUTTON_RELEASED) {
@@ -380,8 +381,9 @@ static void sony_laptop_report_input_eve
 			dprintk("sony_laptop_report_input_event, event not known: %d\n", event);
 			break;
 		}
-		if (sony_laptop_input_index[event] != -1) {
-			kp.key = sony_laptop_input_keycode_map[sony_laptop_input_index[event]];
+		scancode = sony_laptop_input_index[event];
+		if (scancode != -1) {
+			kp.key = sony_laptop_input_keycode_map[scancode];
 			if (kp.key != KEY_UNKNOWN)
 				kp.dev = key_dev;
 		}
@@ -389,9 +391,13 @@ static void sony_laptop_report_input_eve
 	}
 
 	if (kp.dev) {
+		/*
+		 * If we have a scancode we emit it so we can always remap the
+		 * key
+		 */
+		if (scancode != -1)
+			input_event(kp.dev, EV_MSC, MSC_SCAN, scancode);
 		input_report_key(kp.dev, kp.key, 1);
-		/* we emit the scancode so we can always remap the key */
-		input_event(kp.dev, EV_MSC, MSC_SCAN, event);
 		input_sync(kp.dev);
 
 		/* schedule key release */
@@ -466,7 +472,7 @@ static int sony_laptop_setup_input(struc
 	jog_dev->name = "Sony Vaio Jogdial";
 	jog_dev->id.bustype = BUS_ISA;
 	jog_dev->id.vendor = PCI_VENDOR_ID_SONY;
-	key_dev->dev.parent = &acpi_device->dev;
+	jog_dev->dev.parent = &acpi_device->dev;
 
 	input_set_capability(jog_dev, EV_KEY, BTN_MIDDLE);
 	input_set_capability(jog_dev, EV_REL, REL_WHEEL);
_

Patches currently in -mm which might be from john@calvaedi.com are

linux-next.patch

