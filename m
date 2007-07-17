From: akpm@linux-foundation.org
Subject: - ibmasm-miscellaneous-fixes.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:02:48 -0700
Message-ID: <200707172302.l6HN2mqO011623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37395 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936543AbXGQXQj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dtor@insightbb.com, dtor@mail.ru, masbock@us.ibm.com, vernux@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     IBMASM: miscellaneous fixes
has been removed from the -mm tree.  Its filename was
     ibmasm-miscellaneous-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IBMASM: miscellaneous fixes
From: Dmitry Torokhov <dtor@insightbb.com>

IBMASM: miscellaneous fixes

Fix some minor issues, such as:
 - properly set up ID of keyboard device (was mixed up with mouse)
 - constify translation tables
 - change some variables to #defines
 - set up input device's parent to form proper sysfs hierarchy
 - minor formatting changes

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Cc: Vernon Mauery <vernux@us.ibm.com>
Cc: Max Asbock <masbock@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/ibmasm/remote.c |   37 ++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff -puN drivers/misc/ibmasm/remote.c~ibmasm-miscellaneous-fixes drivers/misc/ibmasm/remote.c
--- a/drivers/misc/ibmasm/remote.c~ibmasm-miscellaneous-fixes
+++ a/drivers/misc/ibmasm/remote.c
@@ -28,11 +28,10 @@
 #include "ibmasm.h"
 #include "remote.h"
 
-static int xmax = 1600;
-static int ymax = 1200;
+#define MOUSE_X_MAX	1600
+#define MOUSE_Y_MAX	1200
 
-
-static unsigned short xlate_high[XLATE_SIZE] = {
+static const unsigned short xlate_high[XLATE_SIZE] = {
 	[KEY_SYM_ENTER & 0xff] = KEY_ENTER,
 	[KEY_SYM_KPSLASH & 0xff] = KEY_KPSLASH,
 	[KEY_SYM_KPSTAR & 0xff] = KEY_KPASTERISK,
@@ -81,7 +80,8 @@ static unsigned short xlate_high[XLATE_S
 	[KEY_SYM_NUM_LOCK & 0xff] = KEY_NUMLOCK,
 	[KEY_SYM_SCR_LOCK & 0xff] = KEY_SCROLLLOCK,
 };
-static unsigned short xlate[XLATE_SIZE] = {
+
+static const unsigned short xlate[XLATE_SIZE] = {
 	[NO_KEYCODE] = KEY_RESERVED,
 	[KEY_SYM_SPACE] = KEY_SPACE,
 	[KEY_SYM_TILDE] = KEY_GRAVE,        [KEY_SYM_BKTIC] = KEY_GRAVE,
@@ -133,19 +133,16 @@ static unsigned short xlate[XLATE_SIZE] 
 	[KEY_SYM_Z] = KEY_Z,                [KEY_SYM_z] = KEY_Z,
 };
 
-static char remote_mouse_name[] = "ibmasm RSA I remote mouse";
-static char remote_keybd_name[] = "ibmasm RSA I remote keyboard";
-
 static void print_input(struct remote_input *input)
 {
 	if (input->type == INPUT_TYPE_MOUSE) {
 		unsigned char buttons = input->mouse_buttons;
 		dbg("remote mouse movement: (x,y)=(%d,%d)%s%s%s%s\n",
 			input->data.mouse.x, input->data.mouse.y,
-			(buttons)?" -- buttons:":"",
-			(buttons & REMOTE_BUTTON_LEFT)?"left ":"",
-			(buttons & REMOTE_BUTTON_MIDDLE)?"middle ":"",
-			(buttons & REMOTE_BUTTON_RIGHT)?"right":""
+			(buttons) ? " -- buttons:" : "",
+			(buttons & REMOTE_BUTTON_LEFT) ? "left " : "",
+			(buttons & REMOTE_BUTTON_MIDDLE) ? "middle " : "",
+			(buttons & REMOTE_BUTTON_RIGHT) ? "right" : ""
 		      );
 	} else {
 		dbg("remote keypress (code, flag, down):"
@@ -180,7 +177,7 @@ static void send_keyboard_event(struct i
 		key = xlate_high[code & 0xff];
 	else
 		key = xlate[code];
-	input_report_key(dev, key, (input->data.keyboard.key_down) ? 1 : 0);
+	input_report_key(dev, key, input->data.keyboard.key_down);
 	input_sync(dev);
 }
 
@@ -228,20 +225,22 @@ int ibmasm_init_remote_input_dev(struct 
 	mouse_dev->id.vendor = pdev->vendor;
 	mouse_dev->id.product = pdev->device;
 	mouse_dev->id.version = 1;
+	mouse_dev->dev.parent = sp->dev;
 	mouse_dev->evbit[0]  = BIT(EV_KEY) | BIT(EV_ABS);
 	mouse_dev->keybit[LONG(BTN_MOUSE)] = BIT(BTN_LEFT) |
 		BIT(BTN_RIGHT) | BIT(BTN_MIDDLE);
 	set_bit(BTN_TOUCH, mouse_dev->keybit);
-	mouse_dev->name = remote_mouse_name;
-	input_set_abs_params(mouse_dev, ABS_X, 0, xmax, 0, 0);
-	input_set_abs_params(mouse_dev, ABS_Y, 0, ymax, 0, 0);
+	mouse_dev->name = "ibmasm RSA I remote mouse";
+	input_set_abs_params(mouse_dev, ABS_X, 0, MOUSE_X_MAX, 0, 0);
+	input_set_abs_params(mouse_dev, ABS_Y, 0, MOUSE_Y_MAX, 0, 0);
 
-	mouse_dev->id.bustype = BUS_PCI;
+	keybd_dev->id.bustype = BUS_PCI;
 	keybd_dev->id.vendor = pdev->vendor;
 	keybd_dev->id.product = pdev->device;
-	mouse_dev->id.version = 2;
+	keybd_dev->id.version = 2;
+	keybd_dev->dev.parent = sp->dev;
 	keybd_dev->evbit[0]  = BIT(EV_KEY);
-	keybd_dev->name = remote_keybd_name;
+	keybd_dev->name = "ibmasm RSA I remote keyboard";
 
 	for (i = 0; i < XLATE_SIZE; i++) {
 		if (xlate_high[i])
_

Patches currently in -mm which might be from dtor@insightbb.com are

origin.patch
git-dvb.patch
git-input.patch
hdaps-switch-to-using-input-polldev.patch
applesmc-switch-to-using-input-polldev.patch
ams-switch-to-using-input-polldev.patch
