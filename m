From: akpm@linux-foundation.org
Subject: + touchscreen-fujitsu-touchscreen-driver-rev3.patch added to -mm tree
Date: Thu, 12 Jul 2007 15:07:30 -0700
Message-ID: <200707122207.l6CM7UiL006650@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47138 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758940AbXGLWHu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jul 2007 18:07:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@linux-foundation.org, dtor@mail.ru


The patch titled
     touchscreen: Fujitsu touchscreen driver (rev3)
has been added to the -mm tree.  Its filename is
     touchscreen-fujitsu-touchscreen-driver-rev3.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: touchscreen: Fujitsu touchscreen driver (rev3)
From: Stephen Hemminger <shemminger@linux-foundation.org>

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/fujitsu_ts.c |   36 +++++++++--------------
 1 files changed, 15 insertions(+), 21 deletions(-)

diff -puN drivers/input/touchscreen/fujitsu_ts.c~touchscreen-fujitsu-touchscreen-driver-rev3 drivers/input/touchscreen/fujitsu_ts.c
--- a/drivers/input/touchscreen/fujitsu_ts.c~touchscreen-fujitsu-touchscreen-driver-rev3
+++ a/drivers/input/touchscreen/fujitsu_ts.c
@@ -26,15 +26,9 @@ MODULE_LICENSE("GPL");
 
 #define FUJITSU_LENGTH 5
 
-#define X_AXIS_MIN	90
-#define X_AXIS_MAX	4000
-#define Y_AXIS_MIN	185
-#define Y_AXIS_MAX	4000
-
 /*
  * Per-touchscreen data.
  */
-
 struct fujitsu {
 	struct input_dev *dev;
 	struct serio *serio;
@@ -44,9 +38,13 @@ struct fujitsu {
 };
 
 /*
- * Decode serial data
+ * Decode serial data (5 bytes per packet)
+ * First byte
+ * 1 C 0 0 R S S S
+ * Where C is 1 while in calibration mode (which we don't use)
+ * R is 1 when no coordinate corection was done.
+ * S are button state
  */
-
 static irqreturn_t fujitsu_interrupt(struct serio *serio,
 				     unsigned char data, unsigned int flags)
 {
@@ -55,7 +53,7 @@ static irqreturn_t fujitsu_interrupt(str
 
 	if (fujitsu->idx == 0) {
 		/* resync skip until start of frame */
-		if (!(data & 0x80))
+		if ((data & 0xf8) != 0x80)
 			return IRQ_HANDLED;
 	} else {
 		/* resync skip garbage */
@@ -83,7 +81,6 @@ static irqreturn_t fujitsu_interrupt(str
 /*
  * fujitsu_disconnect() is the opposite of fujitsu_connect()
  */
-
 static void fujitsu_disconnect(struct serio *serio)
 {
 	struct fujitsu *fujitsu = serio_get_drvdata(serio);
@@ -101,7 +98,6 @@ static void fujitsu_disconnect(struct se
  * new serio device that supports the Fujitsu protocol and registers it
  * as input device.
  */
-
 static int fujitsu_connect(struct serio *serio, struct serio_driver *drv)
 {
 	struct fujitsu *fujitsu;
@@ -129,8 +125,8 @@ static int fujitsu_connect(struct serio 
 	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
 	input_dev->keybit[LONG(BTN_TOUCH)] = BIT(BTN_TOUCH);
 
-	input_set_abs_params(input_dev, ABS_X, X_AXIS_MIN, X_AXIS_MAX, 0, 0);
-	input_set_abs_params(input_dev, ABS_Y, Y_AXIS_MIN, Y_AXIS_MAX, 0, 0);
+	input_set_abs_params(input_dev, ABS_X, 0, 4096, 0, 0);
+	input_set_abs_params(input_dev, ABS_Y, 0, 4096, 0, 0);
 	serio_set_drvdata(serio, fujitsu);
 
 	err = serio_open(serio, drv);
@@ -143,9 +139,12 @@ static int fujitsu_connect(struct serio 
 
 	return 0;
 
- fail3:	serio_close(serio);
- fail2:	serio_set_drvdata(serio, NULL);
- fail1:	input_free_device(input_dev);
+ fail3:
+	serio_close(serio);
+ fail2:
+	serio_set_drvdata(serio, NULL);
+ fail1:
+	input_free_device(input_dev);
 	kfree(fujitsu);
 	return err;
 }
@@ -153,7 +152,6 @@ static int fujitsu_connect(struct serio 
 /*
  * The serio driver structure.
  */
-
 static struct serio_device_id fujitsu_serio_ids[] = {
 	{
 		.type	= SERIO_RS232,
@@ -177,10 +175,6 @@ static struct serio_driver fujitsu_drv =
 	.disconnect	= fujitsu_disconnect,
 };
 
-/*
- * The functions for inserting/removing us as a module.
- */
-
 static int __init fujitsu_init(void)
 {
 	return serio_register_driver(&fujitsu_drv);
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

origin.patch
git-acpi.patch
touchscreen-fujitsu-touchscreen-driver.patch
touchscreen-fujitsu-touchscreen-driver-rev3.patch
git-netdev-all.patch
git-net.patch
pci-x-pci-express-read-control-interfaces-myrinet.patch
pci-x-pci-express-read-control-interfaces-mthca.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
pci-x-pci-express-read-control-interfaces-qla2xxx.patch
