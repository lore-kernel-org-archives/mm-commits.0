From: akpm@linux-foundation.org
Subject: - maple-add-driver-for-sega-dreamcast-controller-update.patch removed from -mm tree
Date: Mon, 10 Mar 2008 03:04:53 -0700
Message-ID: <200803101004.m2AA4rcp011066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751028AbYCJKFR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 06:05:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrian@newgolddream.dyndns.info, adrian@mcmen.demon.co.uk, dtor@mail.ru, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     input: support maple controller on SEGA Dreamcast
has been removed from the -mm tree.  Its filename was
     maple-add-driver-for-sega-dreamcast-controller-update.patch

This patch was dropped because it was folded into maple-add-driver-for-sega-dreamcast-controller.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: support maple controller on SEGA Dreamcast
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>

This adds support for the maple controller (as a joystick) on the SEGA
Dreamcast.

I've adjusted the polling rate for the controller in comparison to
earlier patches and the high rate of polling was locking out hotplugging
updates.

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/joystick/maplecontrol.c |   68 +++++++-----------------
 1 file changed, 22 insertions(+), 46 deletions(-)

diff -puN drivers/input/joystick/maplecontrol.c~maple-add-driver-for-sega-dreamcast-controller-update drivers/input/joystick/maplecontrol.c
--- a/drivers/input/joystick/maplecontrol.c~maple-add-driver-for-sega-dreamcast-controller-update
+++ a/drivers/input/joystick/maplecontrol.c
@@ -25,10 +25,6 @@ struct dc_pad {
 	int open;
 };
 
-static void dc_pad_callback_idle(struct mapleq *mq)
-{
-}
-
 static void dc_pad_callback(struct mapleq *mq)
 {
 	unsigned short buttons;
@@ -37,7 +33,7 @@ static void dc_pad_callback(struct maple
 	struct input_dev *dev = pad->dev;
 	unsigned char *res = mq->recvbuf;
 
-	buttons = ~*(unsigned short *)(res+8);
+	buttons = ~cpu_to_le16(*(unsigned short *)(res + 8));
 
 	input_report_abs(dev, ABS_HAT0Y,
 			 (buttons & 0x0010 ? -1:0) + (buttons & 0x0020 ? 1:0));
@@ -65,30 +61,6 @@ static void dc_pad_callback(struct maple
 	input_report_abs(dev, ABS_RY,    res[15]);
 }
 
-static int dc_pad_open(struct input_dev *dev)
-{
-	struct dc_pad *pad = dev->private;
-	if (!pad->open)
-		maple_getcond_callback(pad->mdev, dc_pad_callback, HZ/50,
-			MAPLE_FUNC_CONTROLLER);
-	pad->open++;
-	return 0;
-
-}
-
-static void dc_pad_close(struct input_dev *dev)
-{
-	struct dc_pad *pad = dev->private;
-
-	pad->open--;
-	if (pad->open)
-		return;
-
-	/* Almost never call something that does nothing */
-	maple_getcond_callback(pad->mdev, dc_pad_callback_idle, 0xFFFFFFFF,
-		MAPLE_FUNC_CONTROLLER);
-}
-
 static int dc_pad_connect(struct maple_device *mdev)
 {
 	int i, error;
@@ -111,13 +83,15 @@ static int dc_pad_connect(struct maple_d
 	};
 
 	pad = kzalloc(sizeof(struct dc_pad), GFP_KERNEL);
-	if (!pad)
-		return -ENOMEM;
+	if (!pad){
+		error = ENOMEM;
+		goto fail_nomem_1;
+	}
 
 	dev = input_allocate_device();
 	if (!dev) {
-		kfree(pad);
-		return -ENOMEM;
+		error = ENOMEM;
+		goto fail_nomem_2;
 	}
 
 	pad->dev = dev;
@@ -126,17 +100,17 @@ static int dc_pad_connect(struct maple_d
 
 	for (i = 0; i < 32; i++)
 		if (data & (1<<i) && btn_bit[i] >= 0)
-			pad->dev->keybit[BTN_JOYSTICK/32] |= BIT(btn_bit[i]);
+			pad->dev->keybit[BIT_WORD(BTN_JOYSTICK)] |= BIT_MASK(btn_bit[i]);
 
 	if (pad->dev->keybit[BTN_JOYSTICK/32])
-		pad->dev->evbit[0] |= BIT(EV_KEY);
+		pad->dev->evbit[0] |= BIT_MASK(EV_KEY);
 
 	for (i = 0; i < 32; i++)
 		if (data & (1<<i) && abs_bit[i] >= 0)
-			pad->dev->absbit[0] |= BIT(abs_bit[i]);
+			pad->dev->absbit[0] |= BIT_MASK(abs_bit[i]);
 
 	if (pad->dev->absbit[0])
-		pad->dev->evbit[0] |= BIT(EV_ABS);
+		pad->dev->evbit[0] |= BIT_MASK(EV_ABS);
 
 	for (i = ABS_X; i <= ABS_BRAKE; i++) {
 		pad->dev->absmax[i] = 255;
@@ -152,8 +126,6 @@ static int dc_pad_connect(struct maple_d
 		pad->dev->absflat[i] = 0;
 	}
 
-	pad->dev->open = dc_pad_open;
-	pad->dev->close = dc_pad_close;
 	pad->dev->private = pad;
 	pad->dev->event = NULL;
 	pad->dev->dev.parent = &mdev->dev;
@@ -162,16 +134,20 @@ static int dc_pad_connect(struct maple_d
 	input_set_drvdata(dev, pad);
 
 	error = input_register_device(pad->dev);
-	if (error) {
-		input_free_device(pad->dev);
-		kfree(pad);
-		return -error;
-	}
+	if (error)
+		goto fail_register;
 
-	maple_getcond_callback(mdev, dc_pad_callback_idle, 0xFFFFFFFF,
+	maple_getcond_callback(mdev, dc_pad_callback, HZ/10,
 		MAPLE_FUNC_CONTROLLER);
 
-	return 0;
+	return error;
+
+fail_register:
+	input_free_device(pad->dev);
+fail_nomem_2:
+	kfree(pad);
+fail_nomem_1:
+	return -error;
 }
 
 static void dc_pad_disconnect(struct maple_device *mdev)
_

Patches currently in -mm which might be from adrian@newgolddream.dyndns.info are

maple-allow-removal-and-reinsertion-of-keyboard-driver-module.patch
maple-add-driver-for-sega-dreamcast-controller.patch
maple-add-driver-for-sega-dreamcast-controller-update.patch
maple-add-driver-for-sega-dreamcast-controller-update-checkpatch-fixes.patch

