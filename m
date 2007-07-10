From: akpm@linux-foundation.org
Subject: - joydevc-automatic-re-calibration.patch removed from -mm tree
Date: Mon, 09 Jul 2007 22:05:21 -0700
Message-ID: <200707100505.l6A55LB4006850@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34863 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052AbXGJFGA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jul 2007 01:06:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rengolin@gmail.com, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     joydev.c automatic re-calibration
has been removed from the -mm tree.  Its filename was
     joydevc-automatic-re-calibration.patch

This patch was dropped because it was nacked

------------------------------------------------------
Subject: joydev.c automatic re-calibration
From: "Renato Golin" <rengolin@gmail.com>

Add the automatic recalibration feature without spoiling previously
calibrated devices.  It's a fix for those joysticks that report faulty
range, specially Saitek Cyborg Evo Force.

File: drivers/input/joydev.c
Fix:

- extracted code from joydev_connect to method
  joydev_calculate_correction to be able to call it from both joydev_event
  upon recalibration and joydev_connect during first connection.

- on joydev_connect check ranges and zero calibration if found out of range

- on joydev_event, every time found out of range, update min/max and
  recalculate the correction

Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/joydev.c |   41 +++++++++++++++++++++++++++++++--------
 1 files changed, 33 insertions(+), 8 deletions(-)

diff -puN drivers/input/joydev.c~joydevc-automatic-re-calibration drivers/input/joydev.c
--- a/drivers/input/joydev.c~joydevc-automatic-re-calibration
+++ a/drivers/input/joydev.c
@@ -54,6 +54,8 @@ struct joydev {
 	__u8 absmap[ABS_MAX + 1];
 	__u8 abspam[ABS_MAX + 1];
 	__s16 abs[ABS_MAX + 1];
+	__s16 absmin[ABS_MAX + 1];
+	__s16 absmax[ABS_MAX + 1];
 };
 
 struct joydev_client {
@@ -68,6 +70,19 @@ struct joydev_client {
 
 static struct joydev *joydev_table[JOYDEV_MINORS];
 
+static void joydev_calculate_correction(int min, int max, int axis, struct joydev *joydev)
+{
+	int t, j = joydev->abspam[axis];
+	int flat = joydev->handle.dev->absflat[j];
+
+	joydev->corr[axis].coef[0] = (max + min) / 2 - flat;
+	joydev->corr[axis].coef[1] = (max + min) / 2 + flat;
+	if (!(t = ((max - min) / 2 - 2 * flat)))
+		return;
+	joydev->corr[axis].coef[2] = (1 << 29) / t;
+	joydev->corr[axis].coef[3] = (1 << 29) / t;
+}
+
 static int joydev_correct(int value, struct js_corr *corr)
 {
 	switch (corr->type) {
@@ -104,6 +119,14 @@ static void joydev_event(struct input_ha
 		case EV_ABS:
 			event.type = JS_EVENT_AXIS;
 			event.number = joydev->absmap[code];
+			/* recalibration if needed */
+			if (value < joydev->absmin[code]) {
+				joydev->absmin[code] = value;
+				joydev_calculate_correction(value, joydev->absmax[code], code, joydev);
+			} else if (value > joydev->absmax[code]) {
+				joydev->absmax[code] = value;
+				joydev_calculate_correction(joydev->absmin[code], value, code, joydev);
+			}
 			event.value = joydev_correct(value, joydev->corr + event.number);
 			if (event.value == joydev->abs[event.number])
 				return;
@@ -491,7 +514,7 @@ static int joydev_connect(struct input_h
 			  const struct input_device_id *id)
 {
 	struct joydev *joydev;
-	int i, j, t, minor;
+	int i, j, minor;
 	int error;
 
 	for (minor = 0; minor < JOYDEV_MINORS && joydev_table[minor]; minor++);
@@ -538,19 +561,21 @@ static int joydev_connect(struct input_h
 
 	for (i = 0; i < joydev->nabs; i++) {
 		j = joydev->abspam[i];
-		if (dev->absmax[j] == dev->absmin[j]) {
+		joydev->absmin[i] = dev->absmin[j];
+		joydev->absmax[i] = dev->absmax[j];
+		if (joydev->absmax[i] == joydev->absmin[i]) {
 			joydev->corr[i].type = JS_CORR_NONE;
 			joydev->abs[i] = dev->abs[j];
 			continue;
 		}
 		joydev->corr[i].type = JS_CORR_BROKEN;
 		joydev->corr[i].prec = dev->absfuzz[j];
-		joydev->corr[i].coef[0] = (dev->absmax[j] + dev->absmin[j]) / 2 - dev->absflat[j];
-		joydev->corr[i].coef[1] = (dev->absmax[j] + dev->absmin[j]) / 2 + dev->absflat[j];
-		if (!(t = ((dev->absmax[j] - dev->absmin[j]) / 2 - 2 * dev->absflat[j])))
-			continue;
-		joydev->corr[i].coef[2] = (1 << 29) / t;
-		joydev->corr[i].coef[3] = (1 << 29) / t;
+
+		if (dev->abs[j] > joydev->absmax[i] || dev->abs[j] < joydev->absmin[i]) {
+			printk("Joydev: Bad axis range, recalibrating automatically\n");
+			joydev_calculate_correction(0, 0, i, joydev);
+		} else
+			joydev_calculate_correction(joydev->absmin[i], joydev->absmax[i], i, joydev);
 
 		joydev->abs[i] = joydev_correct(dev->abs[j], joydev->corr + i);
 	}
_

Patches currently in -mm which might be from rengolin@gmail.com are

joydevc-automatic-re-calibration.patch
