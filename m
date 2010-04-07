From: akpm@linux-foundation.org
Subject: + lis3-add-skeletons-for-interrupt-handlers.patch added to -mm tree
Date: Wed, 07 Apr 2010 14:20:20 -0700
Message-ID: <201004072120.o37LKKkZ007972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752835Ab0DGVVI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 17:21:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samu.p.onkalo@nokia.com, daniel@caiaq.de, eric.piel@tremplin-utc.net, pavel@ucw.cz


The patch titled
     lis3: add skeletons for interrupt handlers
has been added to the -mm tree.  Its filename is
     lis3-add-skeletons-for-interrupt-handlers.patch

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
Subject: lis3: add skeletons for interrupt handlers
From: Samu Onkalo <samu.p.onkalo@nokia.com>

Original lis3 driver didn't provide interrupt handler(s) for click or
threshold event handling.  This patch adds threaded handlers for one or
two interrupt lines for 8 bit device.  Actual content for interrupt
handling is provided in the separate patch.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Tested-by: Daniel Mack <daniel@caiaq.de>
Acked-by: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lis3lv02d.c |   87 ++++++++++++++++++++++++++----------
 include/linux/lis3lv02d.h |    1 
 2 files changed, 65 insertions(+), 23 deletions(-)

diff -puN drivers/hwmon/lis3lv02d.c~lis3-add-skeletons-for-interrupt-handlers drivers/hwmon/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3-add-skeletons-for-interrupt-handlers
+++ a/drivers/hwmon/lis3lv02d.c
@@ -251,6 +251,9 @@ EXPORT_SYMBOL_GPL(lis3lv02d_poweron);
 
 static irqreturn_t lis302dl_interrupt(int irq, void *dummy)
 {
+	if (!test_bit(0, &lis3_dev.misc_opened))
+		goto out;
+
 	/*
 	 * Be careful: on some HP laptops the bios force DD when on battery and
 	 * the lid is closed. This leads to interrupts as soon as a little move
@@ -260,44 +263,35 @@ static irqreturn_t lis302dl_interrupt(in
 
 	wake_up_interruptible(&lis3_dev.misc_wait);
 	kill_fasync(&lis3_dev.async_queue, SIGIO, POLL_IN);
+out:
+	if (lis3_dev.whoami == WAI_8B && lis3_dev.idev &&
+	    lis3_dev.idev->input->users)
+		return IRQ_WAKE_THREAD;
 	return IRQ_HANDLED;
 }
 
-static int lis3lv02d_misc_open(struct inode *inode, struct file *file)
+static irqreturn_t lis302dl_interrupt_thread1_8b(int irq, void *data)
 {
-	int ret;
+	return IRQ_HANDLED;
+}
 
+static irqreturn_t lis302dl_interrupt_thread2_8b(int irq, void *data)
+{
+	return IRQ_HANDLED;
+}
+
+static int lis3lv02d_misc_open(struct inode *inode, struct file *file)
+{
 	if (test_and_set_bit(0, &lis3_dev.misc_opened))
 		return -EBUSY; /* already open */
 
 	atomic_set(&lis3_dev.count, 0);
-
-	/*
-	 * The sensor can generate interrupts for free-fall and direction
-	 * detection (distinguishable with FF_WU_SRC and DD_SRC) but to keep
-	 * the things simple and _fast_ we activate it only for free-fall, so
-	 * no need to read register (very slow with ACPI). For the same reason,
-	 * we forbid shared interrupts.
-	 *
-	 * IRQF_TRIGGER_RISING seems pointless on HP laptops because the
-	 * io-apic is not configurable (and generates a warning) but I keep it
-	 * in case of support for other hardware.
-	 */
-	ret = request_irq(lis3_dev.irq, lis302dl_interrupt, IRQF_TRIGGER_RISING,
-			  DRIVER_NAME, &lis3_dev);
-
-	if (ret) {
-		clear_bit(0, &lis3_dev.misc_opened);
-		printk(KERN_ERR DRIVER_NAME ": IRQ%d allocation failed\n", lis3_dev.irq);
-		return -EBUSY;
-	}
 	return 0;
 }
 
 static int lis3lv02d_misc_release(struct inode *inode, struct file *file)
 {
 	fasync_helper(-1, file, 0, &lis3_dev.async_queue);
-	free_irq(lis3_dev.irq, &lis3_dev);
 	clear_bit(0, &lis3_dev.misc_opened); /* release the device */
 	return 0;
 }
@@ -434,6 +428,11 @@ EXPORT_SYMBOL_GPL(lis3lv02d_joystick_ena
 
 void lis3lv02d_joystick_disable(void)
 {
+	if (lis3_dev.irq)
+		free_irq(lis3_dev.irq, &lis3_dev);
+	if (lis3_dev.pdata && lis3_dev.pdata->irq2)
+		free_irq(lis3_dev.pdata->irq2, &lis3_dev);
+
 	if (!lis3_dev.idev)
 		return;
 
@@ -524,6 +523,7 @@ EXPORT_SYMBOL_GPL(lis3lv02d_remove_fs);
 static void lis3lv02d_8b_configure(struct lis3lv02d *dev,
 				struct lis3lv02d_platform_data *p)
 {
+	int err;
 	int ctrl2 = p->hipass_ctrl;
 
 	if (p->click_flags) {
@@ -554,6 +554,18 @@ static void lis3lv02d_8b_configure(struc
 	}
 	/* Configure hipass filters */
 	dev->write(dev, CTRL_REG2, ctrl2);
+
+	if (p->irq2) {
+		err = request_threaded_irq(p->irq2,
+					NULL,
+					lis302dl_interrupt_thread2_8b,
+					IRQF_TRIGGER_RISING |
+					IRQF_ONESHOT,
+					DRIVER_NAME, &lis3_dev);
+		if (err < 0)
+			printk(KERN_ERR DRIVER_NAME
+				"No second IRQ. Limited functionality\n");
+	}
 }
 
 /*
@@ -562,6 +574,9 @@ static void lis3lv02d_8b_configure(struc
  */
 int lis3lv02d_init_device(struct lis3lv02d *dev)
 {
+	int err;
+	irq_handler_t thread_fn;
+
 	dev->whoami = lis3lv02d_read_8(dev, WHO_AM_I);
 
 	switch (dev->whoami) {
@@ -616,6 +631,32 @@ int lis3lv02d_init_device(struct lis3lv0
 		goto out;
 	}
 
+	/*
+	 * The sensor can generate interrupts for free-fall and direction
+	 * detection (distinguishable with FF_WU_SRC and DD_SRC) but to keep
+	 * the things simple and _fast_ we activate it only for free-fall, so
+	 * no need to read register (very slow with ACPI). For the same reason,
+	 * we forbid shared interrupts.
+	 *
+	 * IRQF_TRIGGER_RISING seems pointless on HP laptops because the
+	 * io-apic is not configurable (and generates a warning) but I keep it
+	 * in case of support for other hardware.
+	 */
+	if (dev->whoami == WAI_8B)
+		thread_fn = lis302dl_interrupt_thread1_8b;
+	else
+		thread_fn = NULL;
+
+	err = request_threaded_irq(dev->irq, lis302dl_interrupt,
+				thread_fn,
+				IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+				DRIVER_NAME, &lis3_dev);
+
+	if (err < 0) {
+		printk(KERN_ERR DRIVER_NAME "Cannot get IRQ\n");
+		goto out;
+	}
+
 	if (misc_register(&lis3lv02d_misc_device))
 		printk(KERN_ERR DRIVER_NAME ": misc_register failed\n");
 out:
diff -puN include/linux/lis3lv02d.h~lis3-add-skeletons-for-interrupt-handlers include/linux/lis3lv02d.h
--- a/include/linux/lis3lv02d.h~lis3-add-skeletons-for-interrupt-handlers
+++ a/include/linux/lis3lv02d.h
@@ -67,6 +67,7 @@ struct lis3lv02d_platform_data {
 	/* Limits for selftest are specified in chip data sheet */
 	s16 st_min_limits[3]; /* min pass limit x, y, z */
 	s16 st_max_limits[3]; /* max pass limit x, y, z */
+	int irq2;
 };
 
 #endif /* __LIS3LV02D_H_ */
_

Patches currently in -mm which might be from samu.p.onkalo@nokia.com are

lis3-add-missing-constants-for-8bit-device.patch
lis3-separate-configuration-function-for-8-bit-device.patch
lis3-introduce-platform-data-for-second-ff-wu-unit.patch
lis3-add-skeletons-for-interrupt-handlers.patch
lis3-interrupt-handlers-for-8bit-wakeup-and-click-events.patch
lis3-setup-poll-interval-limits.patch

