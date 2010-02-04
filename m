From: akpm@linux-foundation.org
Subject: + lis3-interrupt-handlers-for-8bit-wakeup-and-click-events.patch added to -mm tree
Date: Thu, 04 Feb 2010 10:56:20 -0800
Message-ID: <201002041856.o14IuKPB015392@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757747Ab0BDS5D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2010 13:57:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samu.p.onkalo@nokia.com, Eric.Piel@tremplin-utc.net, pavel@ucw.cz


The patch titled
     lis3: interrupt handlers for 8bit wakeup and click events
has been added to the -mm tree.  Its filename is
     lis3-interrupt-handlers-for-8bit-wakeup-and-click-events.patch

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
Subject: lis3: interrupt handlers for 8bit wakeup and click events
From: Samu Onkalo <samu.p.onkalo@nokia.com>

Content for the 8bit device threaded interrupt handlers.  Depending on the
interrupt line and chip configuration, either click or wakeup / freefall
handler is called.  In case of click, BTN_ event is sent via input device.
 In case of wakeup or freefall, input device ABS_ events are updated
immediatelly.

It is still possible to configure interrupt line 1 for fast freefall
detection and use the second line either for click or threshold based
interrupts.  Or both lines can be used for click / threshold interrupts.

Polled input device can be set to stopped state and still get coordinate
updates via input device using interrupt based method.  Polled mode and
interrupt mode can also be used parallel.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: Eric Piel <Eric.Piel@tremplin-utc.net>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lis3lv02d.c |   90 ++++++++++++++++++++++++++++++------
 include/linux/lis3lv02d.h |    2 
 2 files changed, 79 insertions(+), 13 deletions(-)

diff -puN drivers/hwmon/lis3lv02d.c~lis3-interrupt-handlers-for-8bit-wakeup-and-click-events drivers/hwmon/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3-interrupt-handlers-for-8bit-wakeup-and-click-events
+++ a/drivers/hwmon/lis3lv02d.c
@@ -121,11 +121,9 @@ static void lis3lv02d_get_xyz(struct lis
 	int position[3];
 	int i;
 
-	mutex_lock(&lis3->mutex);
 	position[0] = lis3->read_data(lis3, OUTX);
 	position[1] = lis3->read_data(lis3, OUTY);
 	position[2] = lis3->read_data(lis3, OUTZ);
-	mutex_unlock(&lis3->mutex);
 
 	for (i = 0; i < 3; i++)
 		position[i] = (position[i] * lis3->scale) / LIS3_ACCURACY;
@@ -274,6 +272,19 @@ static void lis3lv02d_joystick_close(str
 	lis3lv02d_remove_users(&lis3_dev);
 }
 
+static void lis3lv02d_joystick_poll(struct input_polled_dev *pidev)
+{
+	int x, y, z;
+
+	mutex_lock(&lis3_dev.mutex);
+	lis3lv02d_get_xyz(&lis3_dev, &x, &y, &z);
+	input_report_abs(pidev->input, ABS_X, x);
+	input_report_abs(pidev->input, ABS_Y, y);
+	input_report_abs(pidev->input, ABS_Z, z);
+	input_sync(pidev->input);
+	mutex_unlock(&lis3_dev.mutex);
+}
+
 static irqreturn_t lis302dl_interrupt(int irq, void *dummy)
 {
 	if (!test_bit(0, &lis3_dev.misc_opened))
@@ -295,13 +306,71 @@ out:
 	return IRQ_HANDLED;
 }
 
+static void lis302dl_interrupt_handle_click(struct lis3lv02d *lis3)
+{
+	struct input_dev *dev = lis3->idev->input;
+	u8 click_src;
+
+	mutex_lock(&lis3->mutex);
+	lis3->read(lis3, CLICK_SRC, &click_src);
+
+	if (click_src & CLICK_SINGLE_X) {
+		input_report_key(dev, BTN_X, 1);
+		input_report_key(dev, BTN_X, 0);
+	}
+
+	if (click_src & CLICK_SINGLE_Y) {
+		input_report_key(dev, BTN_Y, 1);
+		input_report_key(dev, BTN_Y, 0);
+	}
+
+	if (click_src & CLICK_SINGLE_Z) {
+		input_report_key(dev, BTN_Z, 1);
+		input_report_key(dev, BTN_Z, 0);
+	}
+	input_sync(dev);
+	mutex_unlock(&lis3->mutex);
+}
+
+static void lis302dl_interrupt_handle_ff_wu(struct lis3lv02d *lis3)
+{
+	u8 wu1_src;
+	u8 wu2_src;
+
+	lis3->read(lis3, FF_WU_SRC_1, &wu1_src);
+	lis3->read(lis3, FF_WU_SRC_2, &wu2_src);
+
+	wu1_src = wu1_src & FF_WU_SRC_IA ? wu1_src : 0;
+	wu2_src = wu2_src & FF_WU_SRC_IA ? wu2_src : 0;
+
+	/* joystick poll is internally protected by the lis3->mutex. */
+	if (wu1_src || wu2_src)
+		lis3lv02d_joystick_poll(lis3_dev.idev);
+}
+
 static irqreturn_t lis302dl_interrupt_thread1_8b(int irq, void *data)
 {
+
+	struct lis3lv02d *lis3 = data;
+
+	if ((lis3->pdata->irq_cfg & LIS3_IRQ1_MASK) == LIS3_IRQ1_CLICK)
+		lis302dl_interrupt_handle_click(lis3);
+	else
+		lis302dl_interrupt_handle_ff_wu(lis3);
+
 	return IRQ_HANDLED;
 }
 
 static irqreturn_t lis302dl_interrupt_thread2_8b(int irq, void *data)
 {
+
+	struct lis3lv02d *lis3 = data;
+
+	if ((lis3->pdata->irq_cfg & LIS3_IRQ2_MASK) == LIS3_IRQ2_CLICK)
+		lis302dl_interrupt_handle_click(lis3);
+	else
+		lis302dl_interrupt_handle_ff_wu(lis3);
+
 	return IRQ_HANDLED;
 }
 
@@ -401,17 +470,6 @@ static struct miscdevice lis3lv02d_misc_
 	.fops    = &lis3lv02d_misc_fops,
 };
 
-static void lis3lv02d_joystick_poll(struct input_polled_dev *pidev)
-{
-	int x, y, z;
-
-	lis3lv02d_get_xyz(&lis3_dev, &x, &y, &z);
-	input_report_abs(pidev->input, ABS_X, x);
-	input_report_abs(pidev->input, ABS_Y, y);
-	input_report_abs(pidev->input, ABS_Z, z);
-	input_sync(pidev->input);
-}
-
 int lis3lv02d_joystick_enable(void)
 {
 	struct input_dev *input_dev;
@@ -445,6 +503,10 @@ int lis3lv02d_joystick_enable(void)
 	input_set_abs_params(input_dev, ABS_Y, -max_val, max_val, fuzz, flat);
 	input_set_abs_params(input_dev, ABS_Z, -max_val, max_val, fuzz, flat);
 
+	input_set_capability(input_dev, EV_KEY, BTN_X);
+	input_set_capability(input_dev, EV_KEY, BTN_Y);
+	input_set_capability(input_dev, EV_KEY, BTN_Z);
+
 	err = input_register_polled_device(lis3_dev.idev);
 	if (err) {
 		input_free_polled_device(lis3_dev.idev);
@@ -493,7 +555,9 @@ static ssize_t lis3lv02d_position_show(s
 	if (lis3_dev.active == 0)
 		return -ENODATA;
 
+	mutex_lock(&lis3_dev.mutex);
 	lis3lv02d_get_xyz(&lis3_dev, &x, &y, &z);
+	mutex_unlock(&lis3_dev.mutex);
 	return sprintf(buf, "(%d,%d,%d)\n", x, y, z);
 }
 
diff -puN include/linux/lis3lv02d.h~lis3-interrupt-handlers-for-8bit-wakeup-and-click-events include/linux/lis3lv02d.h
--- a/include/linux/lis3lv02d.h~lis3-interrupt-handlers-for-8bit-wakeup-and-click-events
+++ a/include/linux/lis3lv02d.h
@@ -25,12 +25,14 @@ struct lis3lv02d_platform_data {
 #define LIS3_IRQ1_FF_WU_12	(3 << 0)
 #define LIS3_IRQ1_DATA_READY	(4 << 0)
 #define LIS3_IRQ1_CLICK		(7 << 0)
+#define LIS3_IRQ1_MASK		(7 << 0)
 #define LIS3_IRQ2_DISABLE	(0 << 3)
 #define LIS3_IRQ2_FF_WU_1	(1 << 3)
 #define LIS3_IRQ2_FF_WU_2	(2 << 3)
 #define LIS3_IRQ2_FF_WU_12	(3 << 3)
 #define LIS3_IRQ2_DATA_READY	(4 << 3)
 #define LIS3_IRQ2_CLICK		(7 << 3)
+#define LIS3_IRQ2_MASK		(7 << 3)
 #define LIS3_IRQ_OPEN_DRAIN	(1 << 6)
 #define LIS3_IRQ_ACTIVE_LOW	(1 << 7)
 	unsigned char irq_cfg;
_

Patches currently in -mm which might be from samu.p.onkalo@nokia.com are

lis3-add-missing-constants-for-8bit-device.patch
lis3-separate-configuration-function-for-8-bit-device.patch
lis3-introduce-platform-data-for-second-ff-wu-unit.patch
lis3-power-control-for-the-chip.patch
lis3-add-skeletons-for-interrupt-handlers.patch
lis3-interrupt-handlers-for-8bit-wakeup-and-click-events.patch

