From: akpm@linux-foundation.org
Subject: [folded] drivers-platform-x86-sony-laptopc-fix-scancodes-v2.patch removed from -mm tree
Date: Tue, 10 Jan 2012 15:38:36 -0800
Message-ID: <20120110233836.E54A71E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:59908 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab2AJXih (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 18:38:37 -0500
Received: by yenm5 with SMTP id m5so18361yen.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 15:38:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: john@calvaedi.com, dan.carpenter@oracle.com, john@Calva.COM, john@calva.com, malattia@linux.it, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-platform-x86-sony-laptopc-fix-scancodes-v2
has been removed from the -mm tree.  Its filename was
     drivers-platform-x86-sony-laptopc-fix-scancodes-v2.patch

This patch was dropped because it was folded into drivers-platform-x86-sony-laptopc-fix-scancodes.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: John Hughes <john@calvaedi.com>
Subject: drivers-platform-x86-sony-laptopc-fix-scancodes-v2

Signed-off-by: John Hughes <john@calva.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mattia Dongili <malattia@linux.it>
Cc: John Hughes <john@Calva.COM>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/sony-laptop.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/platform/x86/sony-laptop.c~drivers-platform-x86-sony-laptopc-fix-scancodes-v2 drivers/platform/x86/sony-laptop.c
--- a/drivers/platform/x86/sony-laptop.c~drivers-platform-x86-sony-laptopc-fix-scancodes-v2
+++ a/drivers/platform/x86/sony-laptop.c
@@ -347,7 +347,7 @@ static void sony_laptop_report_input_eve
 	struct input_dev *jog_dev = sony_laptop_input.jog_dev;
 	struct input_dev *key_dev = sony_laptop_input.key_dev;
 	struct sony_laptop_keypress kp = { NULL };
-	int scancode;
+	int scancode = -1;
 
 	if (event == SONYPI_EVENT_FNKEY_RELEASED ||
 			event == SONYPI_EVENT_ANYBUTTON_RELEASED) {
@@ -391,8 +391,10 @@ static void sony_laptop_report_input_eve
 	}
 
 	if (kp.dev) {
-		/* we emit the scancode so we can always remap the key */
-		input_event(kp.dev, EV_MSC, MSC_SCAN, scancode);
+		/* if we have a scancode we emit it so we can always
+                   remap the key */
+		if (scancode != -1)
+			input_event(kp.dev, EV_MSC, MSC_SCAN, scancode);
 		input_report_key(kp.dev, kp.key, 1);
 		input_sync(kp.dev);
 
@@ -468,7 +470,7 @@ static int sony_laptop_setup_input(struc
 	jog_dev->name = "Sony Vaio Jogdial";
 	jog_dev->id.bustype = BUS_ISA;
 	jog_dev->id.vendor = PCI_VENDOR_ID_SONY;
-	key_dev->dev.parent = &acpi_device->dev;
+	jog_dev->dev.parent = &acpi_device->dev;
 
 	input_set_capability(jog_dev, EV_KEY, BTN_MIDDLE);
 	input_set_capability(jog_dev, EV_REL, REL_WHEEL);
_

Patches currently in -mm which might be from john@calvaedi.com are

drivers-platform-x86-sony-laptopc-fix-scancodes.patch
drivers-platform-x86-sony-laptopc-fix-scancodes-v2-checkpatch-fixes.patch

