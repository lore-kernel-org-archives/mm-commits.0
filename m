From: akpm@linux-foundation.org
Subject: - input-fix-hp680-driver-to-work-again.patch removed from -mm tree
Date: Mon, 10 Mar 2008 12:54:44 -0700
Message-ID: <200803101954.m2AJsiN5002611@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756009AbYCJTyy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 15:54:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristoffer.ericson@gmail.com, dtor@mail.ru, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     input: fix hp680 driver to work again
has been removed from the -mm tree.  Its filename was
     input-fix-hp680-driver-to-work-again.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: fix hp680 driver to work again
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>

Fix the touchscreen for the HP Jornada 6xx platform.  Previously this driver
needed tsdev to translate /dev/input/event1 into tslib understandable data. 
When tsdev got removed it therefore stopped working.  With this patch applied
it communicates with tslib directly.  We also upgrade the driver into an
platform driver to get it inline with rest of hp6xx drivers.

Signed-off-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/hp680_ts_input.c |  142 +++++++++++--------
 1 file changed, 85 insertions(+), 57 deletions(-)

diff -puN drivers/input/touchscreen/hp680_ts_input.c~input-fix-hp680-driver-to-work-again drivers/input/touchscreen/hp680_ts_input.c
--- a/drivers/input/touchscreen/hp680_ts_input.c~input-fix-hp680-driver-to-work-again
+++ a/drivers/input/touchscreen/hp680_ts_input.c
@@ -1,7 +1,16 @@
+/*
+ * Platform driver for the HP Jornada 620/660/680/690 Touchscreen.
+ *
+ * Copyright 2008 Kristoffer Ericson <kristoffer.ericson@gmail.com>
+ *  Copyright ...-2007 Andriy Skulysh <askulysh@image.kiev.ua>
+ */
 #include <linux/input.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/workqueue.h>
+
 #include <asm/io.h>
 #include <asm/delay.h>
 #include <asm/adc.h>
@@ -9,24 +18,18 @@
 
 #define MODNAME "hp680_ts_input"
 
-#define HP680_TS_ABS_X_MIN	40
-#define HP680_TS_ABS_X_MAX	950
-#define HP680_TS_ABS_Y_MIN	80
-#define HP680_TS_ABS_Y_MAX	910
-
-#define	PHDR	0xa400012e
-#define SCPDR	0xa4000136
-
-static void do_softint(struct work_struct *work);
+#define	PHDR	0xa400012e	/* PORT H  DATA REGISTER */
+#define SCPDR	0xa4000136	/* PORT SC DATA REGISTER */
 
-static struct input_dev *hp680_ts_dev;
+struct input_dev *dev;
+static void do_softint(struct delayed_work *work);
 static DECLARE_DELAYED_WORK(work, do_softint);
 
-static void do_softint(struct work_struct *work)
+static void do_softint(struct delayed_work *work)
 {
-	int absx = 0, absy = 0;
 	u8 scpdr;
 	int touched = 0;
+	int x, y;
 
 	if (ctrl_inb(PHDR) & PHDR_TS_PEN_DOWN) {
 		scpdr = ctrl_inb(SCPDR);
@@ -35,7 +38,7 @@ static void do_softint(struct work_struc
 		ctrl_outb(scpdr, SCPDR);
 		udelay(30);
 
-		absy = adc_single(ADC_CHANNEL_TS_Y);
+		y = adc_single(ADC_CHANNEL_TS_Y);
 
 		scpdr = ctrl_inb(SCPDR);
 		scpdr |= SCPDR_TS_SCAN_Y;
@@ -43,7 +46,7 @@ static void do_softint(struct work_struc
 		ctrl_outb(scpdr, SCPDR);
 		udelay(30);
 
-		absx = adc_single(ADC_CHANNEL_TS_X);
+		x = adc_single(ADC_CHANNEL_TS_X);
 
 		scpdr = ctrl_inb(SCPDR);
 		scpdr |= SCPDR_TS_SCAN_X;
@@ -54,76 +57,101 @@ static void do_softint(struct work_struc
 	}
 
 	if (touched) {
-		input_report_key(hp680_ts_dev, BTN_TOUCH, 1);
-		input_report_abs(hp680_ts_dev, ABS_X, absx);
-		input_report_abs(hp680_ts_dev, ABS_Y, absy);
+		input_report_abs(dev, ABS_X, x);
+		input_report_abs(dev, ABS_Y, y);
+		input_report_abs(dev, ABS_PRESSURE, 1);
+		input_report_key(dev, BTN_TOUCH, 1);
+		input_sync(dev);
 	} else {
-		input_report_key(hp680_ts_dev, BTN_TOUCH, 0);
+		input_report_abs(dev, ABS_PRESSURE, 0);
+		input_report_key(dev, BTN_TOUCH, 0);
+		input_sync(dev);
 	}
-
-	input_sync(hp680_ts_dev);
 	enable_irq(HP680_TS_IRQ);
 }
 
-static irqreturn_t hp680_ts_interrupt(int irq, void *dev)
+static irqreturn_t hp680_ts_interrupt(int irq, void *pdev)
 {
 	disable_irq_nosync(irq);
 	schedule_delayed_work(&work, HZ / 20);
-
 	return IRQ_HANDLED;
 }
 
-static int __init hp680_ts_init(void)
+static int __init jornada680_ts_probe(struct platform_device *pdev)
 {
-	int err;
+	int error;
 
-	hp680_ts_dev = input_allocate_device();
-	if (!hp680_ts_dev)
-		return -ENOMEM;
-
-	hp680_ts_dev->evbit[0] = BIT_MASK(EV_ABS) | BIT_MASK(EV_KEY);
-	hp680_ts_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
-
-	input_set_abs_params(hp680_ts_dev, ABS_X,
-		HP680_TS_ABS_X_MIN, HP680_TS_ABS_X_MAX, 0, 0);
-	input_set_abs_params(hp680_ts_dev, ABS_Y,
-		HP680_TS_ABS_Y_MIN, HP680_TS_ABS_Y_MAX, 0, 0);
-
-	hp680_ts_dev->name = "HP Jornada touchscreen";
-	hp680_ts_dev->phys = "hp680_ts/input0";
-
-	if (request_irq(HP680_TS_IRQ, hp680_ts_interrupt,
-			IRQF_DISABLED, MODNAME, 0) < 0) {
-		printk(KERN_ERR "hp680_touchscreen.c: Can't allocate irq %d\n",
-		       HP680_TS_IRQ);
-		err = -EBUSY;
-		goto fail1;
+	dev = input_allocate_device();
+
+	if (!dev) {
+		printk(KERN_INFO "ts: failed to allocate device\n");
+		error = -ENODEV;
+		return error;
 	}
 
-	err = input_register_device(hp680_ts_dev);
-	if (err)
+	dev->name = "HP Jornada 6xx Touchscreen";
+	dev->phys = "jornadats/input0";
+	dev->id.bustype = BUS_HOST;
+	dev->dev.parent = &pdev->dev;
+	dev->evbit[0] = BIT_MASK(EV_ABS) | BIT_MASK(EV_KEY);
+	dev->absbit[0] = BIT_MASK(ABS_X) | BIT_MASK(ABS_Y) | BIT_MASK(ABS_PRESSURE);
+	dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
+
+	input_set_abs_params(dev, ABS_X, 40, 950, 0, 0);
+	input_set_abs_params(dev, ABS_Y, 80, 910, 0, 0);
+
+	printk(KERN_INFO "ts: registering device\n");
+	error = input_register_device(dev);
+	if (error)
 		goto fail2;
 
+	error = request_irq(HP680_TS_IRQ, hp680_ts_interrupt,
+			IRQF_DISABLED, "HP6xx Touchscreen Driver", NULL);
+
+	if (error) {
+		printk(KERN_INFO "ts: Unable to aquire irq %d\n", HP680_TS_IRQ);
+		error = -ENODEV;
+		goto fail3;
+	}
+
 	return 0;
 
- fail2:	free_irq(HP680_TS_IRQ, NULL);
-	cancel_delayed_work(&work);
-	flush_scheduled_work();
- fail1:	input_free_device(hp680_ts_dev);
-	return err;
+fail3:
+		input_unregister_device(dev);
+fail2:
+		input_free_device(dev);
+	return error;
 }
 
-static void __exit hp680_ts_exit(void)
+static int __devexit jornada680_ts_remove(struct platform_device *pdev)
 {
-	free_irq(HP680_TS_IRQ, NULL);
 	cancel_delayed_work(&work);
 	flush_scheduled_work();
-	input_unregister_device(hp680_ts_dev);
+	free_irq(HP680_TS_IRQ, pdev);
+	input_unregister_device(dev);
+	return 0;
+}
+
+static struct platform_driver jornada680_ts_driver = {
+	.probe	= jornada680_ts_probe,
+	.remove	= jornada680_ts_remove,
+	.driver = {
+		.name = "jornada_ts",
+	},
+};
+
+static int __devinit hp680_ts_init(void)
+{
+	return platform_driver_register(&jornada680_ts_driver);
 }
 
+static void __exit hp680_ts_exit(void)
+{
+	platform_driver_unregister(&jornada680_ts_driver);
+}
 module_init(hp680_ts_init);
 module_exit(hp680_ts_exit);
 
-MODULE_AUTHOR("Andriy Skulysh, askulysh@image.kiev.ua");
-MODULE_DESCRIPTION("HP Jornada 680 touchscreen driver");
+MODULE_AUTHOR("Kristoffer Ericson <Kristoffer.Ericson@gmail.com>");
+MODULE_DESCRIPTION("HP Jornada 620/660/680/690 touchscreen platform driver");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from kristoffer.ericson@gmail.com are

git-alsa.patch
input-fix-hp680-driver-to-work-again.patch

