From: akpm@linux-foundation.org
Subject: + rtc-rtc-interfaces-dont-use-class_device.patch added to -mm tree
Date: Thu, 01 Mar 2007 02:01:12 -0800
Message-ID: <200703011001.l21A1CuH010037@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37405 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964795AbXCAKBo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 05:01:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, gregkh@suse.de


The patch titled
     rtc: rtc interfaces don't use class_device
has been added to the -mm tree.  Its filename is
     rtc-rtc-interfaces-dont-use-class_device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc: rtc interfaces don't use class_device
From: David Brownell <david-b@pacbell.net>

This patch removes class_device from the programming interface that the RTC
framework exposes to the rest of the kernel.  Now an rtc_device is passed,
which is more type-safe and streamlines all the relevant code.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Acked-By: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/hctosys.c        |   14 ++---
 drivers/rtc/interface.c      |   78 +++++++++++++++------------------
 drivers/rtc/rtc-at91rm9200.c |    2 
 drivers/rtc/rtc-cmos.c       |   12 ++---
 drivers/rtc/rtc-core.h       |    2 
 drivers/rtc/rtc-dev.c        |   27 +++++------
 drivers/rtc/rtc-ds1553.c     |    2 
 drivers/rtc/rtc-omap.c       |    4 -
 drivers/rtc/rtc-pl031.c      |    2 
 drivers/rtc/rtc-proc.c       |   19 ++++----
 drivers/rtc/rtc-s3c.c        |    4 -
 drivers/rtc/rtc-sa1100.c     |    4 -
 drivers/rtc/rtc-sh.c         |    6 +-
 drivers/rtc/rtc-sysfs.c      |   18 ++++---
 drivers/rtc/rtc-test.c       |    6 +-
 drivers/rtc/rtc-vr41xx.c     |    4 -
 include/linux/rtc.h          |   33 ++++++-------
 17 files changed, 119 insertions(+), 118 deletions(-)

diff -puN drivers/rtc/hctosys.c~rtc-rtc-interfaces-dont-use-class_device drivers/rtc/hctosys.c
--- a/drivers/rtc/hctosys.c~rtc-rtc-interfaces-dont-use-class_device
+++ a/drivers/rtc/hctosys.c
@@ -26,15 +26,15 @@ static int __init rtc_hctosys(void)
 {
 	int err;
 	struct rtc_time tm;
-	struct class_device *class_dev = rtc_class_open(CONFIG_RTC_HCTOSYS_DEVICE);
+	struct rtc_device *rtc = rtc_class_open(CONFIG_RTC_HCTOSYS_DEVICE);
 
-	if (class_dev == NULL) {
+	if (rtc == NULL) {
 		printk("%s: unable to open rtc device (%s)\n",
 			__FILE__, CONFIG_RTC_HCTOSYS_DEVICE);
 		return -ENODEV;
 	}
 
-	err = rtc_read_time(class_dev, &tm);
+	err = rtc_read_time(rtc, &tm);
 	if (err == 0) {
 		err = rtc_valid_tm(&tm);
 		if (err == 0) {
@@ -46,7 +46,7 @@ static int __init rtc_hctosys(void)
 
 			do_settimeofday(&tv);
 
-			dev_info(class_dev->dev,
+			dev_info(rtc->class_dev.dev,
 				"setting the system clock to "
 				"%d-%02d-%02d %02d:%02d:%02d (%u)\n",
 				tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
@@ -54,14 +54,14 @@ static int __init rtc_hctosys(void)
 				(unsigned int) tv.tv_sec);
 		}
 		else
-			dev_err(class_dev->dev,
+			dev_err(rtc->class_dev.dev,
 				"hctosys: invalid date/time\n");
 	}
 	else
-		dev_err(class_dev->dev,
+		dev_err(rtc->class_dev.dev,
 			"hctosys: unable to read the hardware clock\n");
 
-	rtc_class_close(class_dev);
+	rtc_class_close(rtc);
 
 	return 0;
 }
diff -puN drivers/rtc/interface.c~rtc-rtc-interfaces-dont-use-class_device drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc-rtc-interfaces-dont-use-class_device
+++ a/drivers/rtc/interface.c
@@ -13,10 +13,9 @@
 
 #include <linux/rtc.h>
 
-int rtc_read_time(struct class_device *class_dev, struct rtc_time *tm)
+int rtc_read_time(struct rtc_device *rtc, struct rtc_time *tm)
 {
 	int err;
-	struct rtc_device *rtc = to_rtc_device(class_dev);
 
 	err = mutex_lock_interruptible(&rtc->ops_lock);
 	if (err)
@@ -28,7 +27,7 @@ int rtc_read_time(struct class_device *c
 		err = -EINVAL;
 	else {
 		memset(tm, 0, sizeof(struct rtc_time));
-		err = rtc->ops->read_time(class_dev->dev, tm);
+		err = rtc->ops->read_time(rtc->class_dev.dev, tm);
 	}
 
 	mutex_unlock(&rtc->ops_lock);
@@ -36,10 +35,9 @@ int rtc_read_time(struct class_device *c
 }
 EXPORT_SYMBOL_GPL(rtc_read_time);
 
-int rtc_set_time(struct class_device *class_dev, struct rtc_time *tm)
+int rtc_set_time(struct rtc_device *rtc, struct rtc_time *tm)
 {
 	int err;
-	struct rtc_device *rtc = to_rtc_device(class_dev);
 
 	err = rtc_valid_tm(tm);
 	if (err != 0)
@@ -54,17 +52,16 @@ int rtc_set_time(struct class_device *cl
 	else if (!rtc->ops->set_time)
 		err = -EINVAL;
 	else
-		err = rtc->ops->set_time(class_dev->dev, tm);
+		err = rtc->ops->set_time(rtc->class_dev.dev, tm);
 
 	mutex_unlock(&rtc->ops_lock);
 	return err;
 }
 EXPORT_SYMBOL_GPL(rtc_set_time);
 
-int rtc_set_mmss(struct class_device *class_dev, unsigned long secs)
+int rtc_set_mmss(struct rtc_device *rtc, unsigned long secs)
 {
 	int err;
-	struct rtc_device *rtc = to_rtc_device(class_dev);
 
 	err = mutex_lock_interruptible(&rtc->ops_lock);
 	if (err)
@@ -73,11 +70,11 @@ int rtc_set_mmss(struct class_device *cl
 	if (!rtc->ops)
 		err = -ENODEV;
 	else if (rtc->ops->set_mmss)
-		err = rtc->ops->set_mmss(class_dev->dev, secs);
+		err = rtc->ops->set_mmss(rtc->class_dev.dev, secs);
 	else if (rtc->ops->read_time && rtc->ops->set_time) {
 		struct rtc_time new, old;
 
-		err = rtc->ops->read_time(class_dev->dev, &old);
+		err = rtc->ops->read_time(rtc->class_dev.dev, &old);
 		if (err == 0) {
 			rtc_time_to_tm(secs, &new);
 
@@ -89,7 +86,8 @@ int rtc_set_mmss(struct class_device *cl
 			 */
 			if (!((old.tm_hour == 23 && old.tm_min == 59) ||
 				(new.tm_hour == 23 && new.tm_min == 59)))
-				err = rtc->ops->set_time(class_dev->dev, &new);
+				err = rtc->ops->set_time(rtc->class_dev.dev,
+						&new);
 		}
 	}
 	else
@@ -101,10 +99,9 @@ int rtc_set_mmss(struct class_device *cl
 }
 EXPORT_SYMBOL_GPL(rtc_set_mmss);
 
-int rtc_read_alarm(struct class_device *class_dev, struct rtc_wkalrm *alarm)
+int rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 {
 	int err;
-	struct rtc_device *rtc = to_rtc_device(class_dev);
 
 	err = mutex_lock_interruptible(&rtc->ops_lock);
 	if (err)
@@ -116,7 +113,7 @@ int rtc_read_alarm(struct class_device *
 		err = -EINVAL;
 	else {
 		memset(alarm, 0, sizeof(struct rtc_wkalrm));
-		err = rtc->ops->read_alarm(class_dev->dev, alarm);
+		err = rtc->ops->read_alarm(rtc->class_dev.dev, alarm);
 	}
 
 	mutex_unlock(&rtc->ops_lock);
@@ -124,10 +121,9 @@ int rtc_read_alarm(struct class_device *
 }
 EXPORT_SYMBOL_GPL(rtc_read_alarm);
 
-int rtc_set_alarm(struct class_device *class_dev, struct rtc_wkalrm *alarm)
+int rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 {
 	int err;
-	struct rtc_device *rtc = to_rtc_device(class_dev);
 
 	err = mutex_lock_interruptible(&rtc->ops_lock);
 	if (err)
@@ -138,7 +134,7 @@ int rtc_set_alarm(struct class_device *c
 	else if (!rtc->ops->set_alarm)
 		err = -EINVAL;
 	else
-		err = rtc->ops->set_alarm(class_dev->dev, alarm);
+		err = rtc->ops->set_alarm(rtc->class_dev.dev, alarm);
 
 	mutex_unlock(&rtc->ops_lock);
 	return err;
@@ -147,16 +143,14 @@ EXPORT_SYMBOL_GPL(rtc_set_alarm);
 
 /**
  * rtc_update_irq - report RTC periodic, alarm, and/or update irqs
- * @class_dev: the rtc's class device
+ * @rtc: the rtc device
  * @num: how many irqs are being reported (usually one)
  * @events: mask of RTC_IRQF with one or more of RTC_PF, RTC_AF, RTC_UF
  * Context: in_interrupt(), irqs blocked
  */
-void rtc_update_irq(struct class_device *class_dev,
+void rtc_update_irq(struct rtc_device *rtc,
 		unsigned long num, unsigned long events)
 {
-	struct rtc_device *rtc = to_rtc_device(class_dev);
-
 	spin_lock(&rtc->irq_lock);
 	rtc->irq_data = (rtc->irq_data + (num << 8)) | events;
 	spin_unlock(&rtc->irq_lock);
@@ -171,40 +165,43 @@ void rtc_update_irq(struct class_device 
 }
 EXPORT_SYMBOL_GPL(rtc_update_irq);
 
-struct class_device *rtc_class_open(char *name)
+struct rtc_device *rtc_class_open(char *name)
 {
-	struct class_device *class_dev = NULL,
-				*class_dev_tmp;
+	struct class_device *class_dev_tmp;
+	struct rtc_device *rtc = NULL;
 
 	down(&rtc_class->sem);
 	list_for_each_entry(class_dev_tmp, &rtc_class->children, node) {
 		if (strncmp(class_dev_tmp->class_id, name, BUS_ID_SIZE) == 0) {
-			class_dev = class_device_get(class_dev_tmp);
+			class_dev_tmp = class_device_get(class_dev_tmp);
+			if (class_dev_tmp)
+				rtc = to_rtc_device(class_dev_tmp);
 			break;
 		}
 	}
 
-	if (class_dev) {
-		if (!try_module_get(to_rtc_device(class_dev)->owner))
-			class_dev = NULL;
+	if (rtc) {
+		if (!try_module_get(rtc->owner)) {
+			class_device_put(class_dev_tmp);
+			rtc = NULL;
+		}
 	}
 	up(&rtc_class->sem);
 
-	return class_dev;
+	return rtc;
 }
 EXPORT_SYMBOL_GPL(rtc_class_open);
 
-void rtc_class_close(struct class_device *class_dev)
+void rtc_class_close(struct rtc_device *rtc)
 {
-	module_put(to_rtc_device(class_dev)->owner);
-	class_device_put(class_dev);
+	module_put(rtc->owner);
+	class_device_put(&rtc->class_dev);
 }
 EXPORT_SYMBOL_GPL(rtc_class_close);
 
-int rtc_irq_register(struct class_device *class_dev, struct rtc_task *task)
+int rtc_irq_register(struct rtc_device *rtc, struct rtc_task *task)
 {
 	int retval = -EBUSY;
-	struct rtc_device *rtc = to_rtc_device(class_dev);
 
 	if (task == NULL || task->func == NULL)
 		return -EINVAL;
@@ -220,9 +217,8 @@ int rtc_irq_register(struct class_device
 }
 EXPORT_SYMBOL_GPL(rtc_irq_register);
 
-void rtc_irq_unregister(struct class_device *class_dev, struct rtc_task *task)
+void rtc_irq_unregister(struct rtc_device *rtc, struct rtc_task *task)
 {
-	struct rtc_device *rtc = to_rtc_device(class_dev);
 
 	spin_lock_irq(&rtc->irq_task_lock);
 	if (rtc->irq_task == task)
@@ -231,11 +227,10 @@ void rtc_irq_unregister(struct class_dev
 }
 EXPORT_SYMBOL_GPL(rtc_irq_unregister);
 
-int rtc_irq_set_state(struct class_device *class_dev, struct rtc_task *task, int enabled)
+int rtc_irq_set_state(struct rtc_device *rtc, struct rtc_task *task, int enabled)
 {
 	int err = 0;
 	unsigned long flags;
-	struct rtc_device *rtc = to_rtc_device(class_dev);
 
 	if (rtc->ops->irq_set_state == NULL)
 		return -ENXIO;
@@ -246,17 +241,16 @@ int rtc_irq_set_state(struct class_devic
 	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
 
 	if (err == 0)
-		err = rtc->ops->irq_set_state(class_dev->dev, enabled);
+		err = rtc->ops->irq_set_state(rtc->class_dev.dev, enabled);
 
 	return err;
 }
 EXPORT_SYMBOL_GPL(rtc_irq_set_state);
 
-int rtc_irq_set_freq(struct class_device *class_dev, struct rtc_task *task, int freq)
+int rtc_irq_set_freq(struct rtc_device *rtc, struct rtc_task *task, int freq)
 {
 	int err = 0;
 	unsigned long flags;
-	struct rtc_device *rtc = to_rtc_device(class_dev);
 
 	if (rtc->ops->irq_set_freq == NULL)
 		return -ENXIO;
@@ -267,7 +261,7 @@ int rtc_irq_set_freq(struct class_device
 	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
 
 	if (err == 0) {
-		err = rtc->ops->irq_set_freq(class_dev->dev, freq);
+		err = rtc->ops->irq_set_freq(rtc->class_dev.dev, freq);
 		if (err == 0)
 			rtc->irq_freq = freq;
 	}
diff -puN drivers/rtc/rtc-at91rm9200.c~rtc-rtc-interfaces-dont-use-class_device drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~rtc-rtc-interfaces-dont-use-class_device
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -263,7 +263,7 @@ static irqreturn_t at91_rtc_interrupt(in
 
 		at91_sys_write(AT91_RTC_SCCR, rtsr);	/* clear status reg */
 
-		rtc_update_irq(&rtc->class_dev, 1, events);
+		rtc_update_irq(rtc, 1, events);
 
 		pr_debug("%s(): num=%ld, events=0x%02lx\n", __FUNCTION__,
 			events >> 8, events & 0x000000FF);
diff -puN drivers/rtc/rtc-cmos.c~rtc-rtc-interfaces-dont-use-class_device drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-rtc-interfaces-dont-use-class_device
+++ a/drivers/rtc/rtc-cmos.c
@@ -189,7 +189,7 @@ static int cmos_set_alarm(struct device 
 	CMOS_WRITE(rtc_control, RTC_CONTROL);
 	rtc_intr = CMOS_READ(RTC_INTR_FLAGS);
 	if (rtc_intr)
-		rtc_update_irq(&cmos->rtc->class_dev, 1, rtc_intr);
+		rtc_update_irq(cmos->rtc, 1, rtc_intr);
 
 	/* update alarm */
 	CMOS_WRITE(hrs, RTC_HOURS_ALARM);
@@ -208,7 +208,7 @@ static int cmos_set_alarm(struct device 
 		CMOS_WRITE(rtc_control, RTC_CONTROL);
 		rtc_intr = CMOS_READ(RTC_INTR_FLAGS);
 		if (rtc_intr)
-			rtc_update_irq(&cmos->rtc->class_dev, 1, rtc_intr);
+			rtc_update_irq(cmos->rtc, 1, rtc_intr);
 	}
 
 	spin_unlock_irq(&rtc_lock);
@@ -288,7 +288,7 @@ cmos_rtc_ioctl(struct device *dev, unsig
 	CMOS_WRITE(rtc_control, RTC_CONTROL);
 	rtc_intr = CMOS_READ(RTC_INTR_FLAGS);
 	if (rtc_intr)
-		rtc_update_irq(&cmos->rtc->class_dev, 1, rtc_intr);
+		rtc_update_irq(cmos->rtc, 1, rtc_intr);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return 0;
 }
@@ -457,7 +457,7 @@ cmos_do_probe(struct device *dev, struct
 	if (is_valid_irq(rtc_irq))
 		retval = request_irq(rtc_irq, cmos_interrupt, IRQF_DISABLED,
 				cmos_rtc.rtc->class_dev.class_id,
-				&cmos_rtc.rtc->class_dev);
+				cmos_rtc.rtc);
 	if (retval < 0) {
 		dev_dbg(dev, "IRQ %d is already in use\n", rtc_irq);
 		goto cleanup1;
@@ -542,7 +542,7 @@ static int cmos_suspend(struct device *d
 	spin_unlock_irq(&rtc_lock);
 
 	if (irqstat)
-		rtc_update_irq(&cmos->rtc->class_dev, 1, irqstat);
+		rtc_update_irq(cmos->rtc, 1, irqstat);
 
 	/* ACPI HOOK:  enable ACPI_EVENT_RTC when (tmp & RTC_AIE)
 	 * ... it'd be best if we could do that under rtc_lock.
@@ -575,7 +575,7 @@ static int cmos_resume(struct device *de
 		tmp = CMOS_READ(RTC_INTR_FLAGS);
 		spin_unlock_irq(&rtc_lock);
 		if (tmp)
-			rtc_update_irq(&cmos->rtc->class_dev, 1, tmp);
+			rtc_update_irq(cmos->rtc, 1, tmp);
 	}
 
 	pr_debug("%s: resume, ctrl %02x\n",
diff -puN drivers/rtc/rtc-core.h~rtc-rtc-interfaces-dont-use-class_device drivers/rtc/rtc-core.h
--- a/drivers/rtc/rtc-core.h~rtc-rtc-interfaces-dont-use-class_device
+++ a/drivers/rtc/rtc-core.h
@@ -1,3 +1,5 @@
+extern int rtc_interface_register(struct class_interface *intf);
+
 #ifdef CONFIG_RTC_INTF_DEV
 
 extern void __init rtc_dev_init(void);
diff -puN drivers/rtc/rtc-dev.c~rtc-rtc-interfaces-dont-use-class_device drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~rtc-rtc-interfaces-dont-use-class_device
+++ a/drivers/rtc/rtc-dev.c
@@ -31,7 +31,7 @@ static int rtc_dev_open(struct inode *in
 	if (!(mutex_trylock(&rtc->char_lock)))
 		return -EBUSY;
 
-	file->private_data = &rtc->class_dev;
+	file->private_data = rtc;
 
 	err = ops->open ? ops->open(rtc->class_dev.dev) : 0;
 	if (err == 0) {
@@ -60,7 +60,7 @@ static void rtc_uie_task(struct work_str
 	int num = 0;
 	int err;
 
-	err = rtc_read_time(&rtc->class_dev, &tm);
+	err = rtc_read_time(rtc, &tm);
 
 	local_irq_disable();
 	spin_lock(&rtc->irq_lock);
@@ -78,7 +78,7 @@ static void rtc_uie_task(struct work_str
 	}
 	spin_unlock(&rtc->irq_lock);
 	if (num)
-		rtc_update_irq(&rtc->class_dev, num, RTC_UF | RTC_IRQF);
+		rtc_update_irq(rtc, num, RTC_UF | RTC_IRQF);
 	local_irq_enable();
 }
 static void rtc_uie_timer(unsigned long data)
@@ -120,7 +120,7 @@ static int set_uie(struct rtc_device *rt
 	struct rtc_time tm;
 	int err;
 
-	err = rtc_read_time(&rtc->class_dev, &tm);
+	err = rtc_read_time(rtc, &tm);
 	if (err)
 		return err;
 	spin_lock_irq(&rtc->irq_lock);
@@ -209,8 +209,7 @@ static int rtc_dev_ioctl(struct inode *i
 		unsigned int cmd, unsigned long arg)
 {
 	int err = 0;
-	struct class_device *class_dev = file->private_data;
-	struct rtc_device *rtc = to_rtc_device(class_dev);
+	struct rtc_device *rtc = file->private_data;
 	const struct rtc_class_ops *ops = rtc->ops;
 	struct rtc_time tm;
 	struct rtc_wkalrm alarm;
@@ -251,7 +250,7 @@ static int rtc_dev_ioctl(struct inode *i
 
 	/* try the driver's ioctl interface */
 	if (ops->ioctl) {
-		err = ops->ioctl(class_dev->dev, cmd, arg);
+		err = ops->ioctl(rtc->class_dev.dev, cmd, arg);
 		if (err != -ENOIOCTLCMD)
 			return err;
 	}
@@ -263,7 +262,7 @@ static int rtc_dev_ioctl(struct inode *i
 
 	switch (cmd) {
 	case RTC_ALM_READ:
-		err = rtc_read_alarm(class_dev, &alarm);
+		err = rtc_read_alarm(rtc, &alarm);
 		if (err < 0)
 			return err;
 
@@ -283,11 +282,11 @@ static int rtc_dev_ioctl(struct inode *i
 		alarm.time.tm_wday = -1;
 		alarm.time.tm_yday = -1;
 		alarm.time.tm_isdst = -1;
-		err = rtc_set_alarm(class_dev, &alarm);
+		err = rtc_set_alarm(rtc, &alarm);
 		break;
 
 	case RTC_RD_TIME:
-		err = rtc_read_time(class_dev, &tm);
+		err = rtc_read_time(rtc, &tm);
 		if (err < 0)
 			return err;
 
@@ -299,7 +298,7 @@ static int rtc_dev_ioctl(struct inode *i
 		if (copy_from_user(&tm, uarg, sizeof(tm)))
 			return -EFAULT;
 
-		err = rtc_set_time(class_dev, &tm);
+		err = rtc_set_time(rtc, &tm);
 		break;
 
 	case RTC_IRQP_READ:
@@ -309,7 +308,7 @@ static int rtc_dev_ioctl(struct inode *i
 
 	case RTC_IRQP_SET:
 		if (ops->irq_set_freq)
-			err = rtc_irq_set_freq(class_dev, rtc->irq_task, arg);
+			err = rtc_irq_set_freq(rtc, rtc->irq_task, arg);
 		break;
 
 #if 0
@@ -335,11 +334,11 @@ static int rtc_dev_ioctl(struct inode *i
 		if (copy_from_user(&alarm, uarg, sizeof(alarm)))
 			return -EFAULT;
 
-		err = rtc_set_alarm(class_dev, &alarm);
+		err = rtc_set_alarm(rtc, &alarm);
 		break;
 
 	case RTC_WKALM_RD:
-		err = rtc_read_alarm(class_dev, &alarm);
+		err = rtc_read_alarm(rtc, &alarm);
 		if (err < 0)
 			return err;
 
diff -puN drivers/rtc/rtc-ds1553.c~rtc-rtc-interfaces-dont-use-class_device drivers/rtc/rtc-ds1553.c
--- a/drivers/rtc/rtc-ds1553.c~rtc-rtc-interfaces-dont-use-class_device
+++ a/drivers/rtc/rtc-ds1553.c
@@ -203,7 +203,7 @@ static irqreturn_t ds1553_rtc_interrupt(
 		events |= RTC_UF;
 	else
 		events |= RTC_AF;
-	rtc_update_irq(&pdata->rtc->class_dev, 1, events);
+	rtc_update_irq(pdata->rtc, 1, events);
 	return IRQ_HANDLED;
 }
 
diff -puN drivers/rtc/rtc-omap.c~rtc-rtc-interfaces-dont-use-class_device drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-rtc-interfaces-dont-use-class_device
+++ a/drivers/rtc/rtc-omap.c
@@ -124,7 +124,7 @@ static void rtc_wait_not_busy(void)
 	/* now we have ~15 usec to read/write various registers */
 }
 
-static irqreturn_t rtc_irq(int irq, void *class_dev)
+static irqreturn_t rtc_irq(int irq, void *rtc)
 {
 	unsigned long		events = 0;
 	u8			irq_data;
@@ -141,7 +141,7 @@ static irqreturn_t rtc_irq(int irq, void
 	if (irq_data & OMAP_RTC_STATUS_1S_EVENT)
 		events |= RTC_IRQF | RTC_UF;
 
-	rtc_update_irq(class_dev, 1, events);
+	rtc_update_irq(rtc, 1, events);
 
 	return IRQ_HANDLED;
 }
diff -puN drivers/rtc/rtc-pl031.c~rtc-rtc-interfaces-dont-use-class_device drivers/rtc/rtc-pl031.c
--- a/drivers/rtc/rtc-pl031.c~rtc-rtc-interfaces-dont-use-class_device
+++ a/drivers/rtc/rtc-pl031.c
@@ -51,7 +51,7 @@ static irqreturn_t pl031_interrupt(int i
 {
 	struct rtc_device *rtc = dev_id;
 
-	rtc_update_irq(&rtc->class_dev, 1, RTC_AF);
+	rtc_update_irq(rtc, 1, RTC_AF);
 
 	return IRQ_HANDLED;
 }
diff -puN drivers/rtc/rtc-proc.c~rtc-rtc-interfaces-dont-use-class_device drivers/rtc/rtc-proc.c
--- a/drivers/rtc/rtc-proc.c~rtc-rtc-interfaces-dont-use-class_device
+++ a/drivers/rtc/rtc-proc.c
@@ -16,18 +16,21 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 
+#include "rtc-core.h"
+
+
 static struct class_device *rtc_dev = NULL;
 static DEFINE_MUTEX(rtc_lock);
 
 static int rtc_proc_show(struct seq_file *seq, void *offset)
 {
 	int err;
-	struct class_device *class_dev = seq->private;
-	const struct rtc_class_ops *ops = to_rtc_device(class_dev)->ops;
+	struct rtc_device *rtc = seq->private;
+	const struct rtc_class_ops *ops = rtc->ops;
 	struct rtc_wkalrm alrm;
 	struct rtc_time tm;
 
-	err = rtc_read_time(class_dev, &tm);
+	err = rtc_read_time(rtc, &tm);
 	if (err == 0) {
 		seq_printf(seq,
 			"rtc_time\t: %02d:%02d:%02d\n"
@@ -36,7 +39,7 @@ static int rtc_proc_show(struct seq_file
 			tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday);
 	}
 
-	err = rtc_read_alarm(class_dev, &alrm);
+	err = rtc_read_alarm(rtc, &alrm);
 	if (err == 0) {
 		seq_printf(seq, "alrm_time\t: ");
 		if ((unsigned int)alrm.time.tm_hour <= 24)
@@ -74,19 +77,19 @@ static int rtc_proc_show(struct seq_file
 	seq_printf(seq, "24hr\t\t: yes\n");
 
 	if (ops->proc)
-		ops->proc(class_dev->dev, seq);
+		ops->proc(rtc->class_dev.dev, seq);
 
 	return 0;
 }
 
 static int rtc_proc_open(struct inode *inode, struct file *file)
 {
-	struct class_device *class_dev = PDE(inode)->data;
+	struct rtc_device *rtc = PDE(inode)->data;
 
 	if (!try_module_get(THIS_MODULE))
 		return -ENODEV;
 
-	return single_open(file, rtc_proc_show, class_dev);
+	return single_open(file, rtc_proc_show, rtc);
 }
 
 static int rtc_proc_release(struct inode *inode, struct file *file)
@@ -118,7 +121,7 @@ static int rtc_proc_add_device(struct cl
 
 			ent->proc_fops = &rtc_proc_fops;
 			ent->owner = rtc->owner;
-			ent->data = class_dev;
+			ent->data = rtc;
 
 			dev_dbg(class_dev->dev, "rtc intf: proc\n");
 		}
diff -puN drivers/rtc/rtc-s3c.c~rtc-rtc-interfaces-dont-use-class_device drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-rtc-interfaces-dont-use-class_device
+++ a/drivers/rtc/rtc-s3c.c
@@ -50,7 +50,7 @@ static irqreturn_t s3c_rtc_alarmirq(int 
 {
 	struct rtc_device *rdev = id;
 
-	rtc_update_irq(&rdev->class_dev, 1, RTC_AF | RTC_IRQF);
+	rtc_update_irq(rdev, 1, RTC_AF | RTC_IRQF);
 	return IRQ_HANDLED;
 }
 
@@ -58,7 +58,7 @@ static irqreturn_t s3c_rtc_tickirq(int i
 {
 	struct rtc_device *rdev = id;
 
-	rtc_update_irq(&rdev->class_dev, tick_count++, RTC_PF | RTC_IRQF);
+	rtc_update_irq(rdev, tick_count++, RTC_PF | RTC_IRQF);
 	return IRQ_HANDLED;
 }
 
diff -puN drivers/rtc/rtc-sa1100.c~rtc-rtc-interfaces-dont-use-class_device drivers/rtc/rtc-sa1100.c
--- a/drivers/rtc/rtc-sa1100.c~rtc-rtc-interfaces-dont-use-class_device
+++ a/drivers/rtc/rtc-sa1100.c
@@ -93,7 +93,7 @@ static irqreturn_t sa1100_rtc_interrupt(
 	if (rtsr & RTSR_HZ)
 		events |= RTC_UF | RTC_IRQF;
 
-	rtc_update_irq(&rtc->class_dev, 1, events);
+	rtc_update_irq(rtc, 1, events);
 
 	if (rtsr & RTSR_AL && rtc_periodic_alarm(&rtc_alarm))
 		rtc_update_alarm(&rtc_alarm);
@@ -119,7 +119,7 @@ static irqreturn_t timer1_interrupt(int 
 	 */
 	OSSR = OSSR_M1;	/* clear match on timer1 */
 
-	rtc_update_irq(&rtc->class_dev, rtc_timer1_count, RTC_PF | RTC_IRQF);
+	rtc_update_irq(rtc, rtc_timer1_count, RTC_PF | RTC_IRQF);
 
 	if (rtc_timer1_count == 1)
 		rtc_timer1_count = (rtc_freq * ((1<<30)/(TIMER_FREQ>>2)));
diff -puN drivers/rtc/rtc-sh.c~rtc-rtc-interfaces-dont-use-class_device drivers/rtc/rtc-sh.c
--- a/drivers/rtc/rtc-sh.c~rtc-rtc-interfaces-dont-use-class_device
+++ a/drivers/rtc/rtc-sh.c
@@ -104,7 +104,7 @@ static irqreturn_t sh_rtc_interrupt(int 
 
 	writeb(tmp, rtc->regbase + RCR1);
 
-	rtc_update_irq(&rtc->rtc_dev->class_dev, 1, events);
+	rtc_update_irq(&rtc->rtc_dev, 1, events);
 
 	spin_unlock(&rtc->lock);
 
@@ -139,7 +139,7 @@ static irqreturn_t sh_rtc_alarm(int irq,
 
 		rtc->rearm_aie = 1;
 
-		rtc_update_irq(&rtc->rtc_dev->class_dev, 1, events);
+		rtc_update_irq(&rtc->rtc_dev, 1, events);
 	}
 
 	spin_unlock(&rtc->lock);
@@ -153,7 +153,7 @@ static irqreturn_t sh_rtc_periodic(int i
 
 	spin_lock(&rtc->lock);
 
-	rtc_update_irq(&rtc->rtc_dev->class_dev, 1, RTC_PF | RTC_IRQF);
+	rtc_update_irq(&rtc->rtc_dev, 1, RTC_PF | RTC_IRQF);
 
 	spin_unlock(&rtc->lock);
 
diff -puN drivers/rtc/rtc-sysfs.c~rtc-rtc-interfaces-dont-use-class_device drivers/rtc/rtc-sysfs.c
--- a/drivers/rtc/rtc-sysfs.c~rtc-rtc-interfaces-dont-use-class_device
+++ a/drivers/rtc/rtc-sysfs.c
@@ -12,6 +12,9 @@
 #include <linux/module.h>
 #include <linux/rtc.h>
 
+#include "rtc-core.h"
+
+
 /* device attributes */
 
 static ssize_t rtc_sysfs_show_name(struct class_device *dev, char *buf)
@@ -25,7 +28,7 @@ static ssize_t rtc_sysfs_show_date(struc
 	ssize_t retval;
 	struct rtc_time tm;
 
-	retval = rtc_read_time(dev, &tm);
+	retval = rtc_read_time(to_rtc_device(dev), &tm);
 	if (retval == 0) {
 		retval = sprintf(buf, "%04d-%02d-%02d\n",
 			tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday);
@@ -40,7 +43,7 @@ static ssize_t rtc_sysfs_show_time(struc
 	ssize_t retval;
 	struct rtc_time tm;
 
-	retval = rtc_read_time(dev, &tm);
+	retval = rtc_read_time(to_rtc_device(dev), &tm);
 	if (retval == 0) {
 		retval = sprintf(buf, "%02d:%02d:%02d\n",
 			tm.tm_hour, tm.tm_min, tm.tm_sec);
@@ -55,7 +58,7 @@ static ssize_t rtc_sysfs_show_since_epoc
 	ssize_t retval;
 	struct rtc_time tm;
 
-	retval = rtc_read_time(dev, &tm);
+	retval = rtc_read_time(to_rtc_device(dev), &tm);
 	if (retval == 0) {
 		unsigned long time;
 		rtc_tm_to_time(&tm, &time);
@@ -94,7 +97,7 @@ rtc_sysfs_show_wakealarm(struct class_de
 	 * REVISIT maybe we should require RTC implementations to
 	 * disable the RTC alarm after it triggers, for uniformity.
 	 */
-	retval = rtc_read_alarm(dev, &alm);
+	retval = rtc_read_alarm(to_rtc_device(dev), &alm);
 	if (retval == 0 && alm.enabled) {
 		rtc_tm_to_time(&alm.time, &alarm);
 		retval = sprintf(buf, "%lu\n", alarm);
@@ -109,11 +112,12 @@ rtc_sysfs_set_wakealarm(struct class_dev
 	ssize_t retval;
 	unsigned long now, alarm;
 	struct rtc_wkalrm alm;
+	struct rtc_device *rtc = to_rtc_device(dev);
 
 	/* Only request alarms that trigger in the future.  Disable them
 	 * by writing another time, e.g. 0 meaning Jan 1 1970 UTC.
 	 */
-	retval = rtc_read_time(dev, &alm.time);
+	retval = rtc_read_time(rtc, &alm.time);
 	if (retval < 0)
 		return retval;
 	rtc_tm_to_time(&alm.time, &now);
@@ -124,7 +128,7 @@ rtc_sysfs_set_wakealarm(struct class_dev
 		 * entirely prevent that here, without even the minimal
 		 * locking from the /dev/rtcN api.
 		 */
-		retval = rtc_read_alarm(dev, &alm);
+		retval = rtc_read_alarm(rtc, &alm);
 		if (retval < 0)
 			return retval;
 		if (alm.enabled)
@@ -141,7 +145,7 @@ rtc_sysfs_set_wakealarm(struct class_dev
 	}
 	rtc_time_to_tm(alarm, &alm.time);
 
-	retval = rtc_set_alarm(dev, &alm);
+	retval = rtc_set_alarm(rtc, &alm);
 	return (retval < 0) ? retval : n;
 }
 static const CLASS_DEVICE_ATTR(wakealarm, S_IRUGO | S_IWUSR,
diff -puN drivers/rtc/rtc-test.c~rtc-rtc-interfaces-dont-use-class_device drivers/rtc/rtc-test.c
--- a/drivers/rtc/rtc-test.c~rtc-rtc-interfaces-dont-use-class_device
+++ a/drivers/rtc/rtc-test.c
@@ -101,11 +101,11 @@ static ssize_t test_irq_store(struct dev
 	retval = count;
 	local_irq_disable();
 	if (strncmp(buf, "tick", 4) == 0)
-		rtc_update_irq(&rtc->class_dev, 1, RTC_PF | RTC_IRQF);
+		rtc_update_irq(rtc, 1, RTC_PF | RTC_IRQF);
 	else if (strncmp(buf, "alarm", 5) == 0)
-		rtc_update_irq(&rtc->class_dev, 1, RTC_AF | RTC_IRQF);
+		rtc_update_irq(rtc, 1, RTC_AF | RTC_IRQF);
 	else if (strncmp(buf, "update", 6) == 0)
-		rtc_update_irq(&rtc->class_dev, 1, RTC_UF | RTC_IRQF);
+		rtc_update_irq(rtc, 1, RTC_UF | RTC_IRQF);
 	else
 		retval = -EINVAL;
 	local_irq_enable();
diff -puN drivers/rtc/rtc-vr41xx.c~rtc-rtc-interfaces-dont-use-class_device drivers/rtc/rtc-vr41xx.c
--- a/drivers/rtc/rtc-vr41xx.c~rtc-rtc-interfaces-dont-use-class_device
+++ a/drivers/rtc/rtc-vr41xx.c
@@ -275,7 +275,7 @@ static irqreturn_t elapsedtime_interrupt
 
 	rtc2_write(RTCINTREG, ELAPSEDTIME_INT);
 
-	rtc_update_irq(&rtc->class_dev, 1, RTC_AF);
+	rtc_update_irq(rtc, 1, RTC_AF);
 
 	return IRQ_HANDLED;
 }
@@ -291,7 +291,7 @@ static irqreturn_t rtclong1_interrupt(in
 	rtc1_write(RTCL1LREG, count);
 	rtc1_write(RTCL1HREG, count >> 16);
 
-	rtc_update_irq(&rtc->class_dev, 1, RTC_PF);
+	rtc_update_irq(rtc, 1, RTC_PF);
 
 	return IRQ_HANDLED;
 }
diff -puN include/linux/rtc.h~rtc-rtc-interfaces-dont-use-class_device include/linux/rtc.h
--- a/include/linux/rtc.h~rtc-rtc-interfaces-dont-use-class_device
+++ a/include/linux/rtc.h
@@ -4,7 +4,7 @@
  * service. It is used with both the legacy mc146818 and also  EFI
  * Struct rtc_time and first 12 ioctl by Paul Gortmaker, 1996 - separated out
  * from <linux/mc146818rtc.h> to this file for 2.4 kernels.
- * 
+ *
  * Copyright (C) 1999 Hewlett-Packard Co.
  * Copyright (C) 1999 Stephane Eranian <eranian@hpl.hp.com>
  */
@@ -13,7 +13,7 @@
 
 /*
  * The struct used to pass data via the following ioctl. Similar to the
- * struct tm in <time.h>, but it needs to be here so that the kernel 
+ * struct tm in <time.h>, but it needs to be here so that the kernel
  * source is self contained, allowing cross-compiles, etc. etc.
  */
 
@@ -50,7 +50,7 @@ struct rtc_wkalrm {
  *   pll_value*pll_posmult/pll_clock
  * -ve pll_value means clock will run slower by
  *   pll_value*pll_negmult/pll_clock
- */ 
+ */
 
 struct rtc_pll_info {
 	int pll_ctrl;       /* placeholder for fancier control */
@@ -174,29 +174,28 @@ extern struct rtc_device *rtc_device_reg
 					struct device *dev,
 					const struct rtc_class_ops *ops,
 					struct module *owner);
-extern void rtc_device_unregister(struct rtc_device *rdev);
-extern int rtc_interface_register(struct class_interface *intf);
+extern void rtc_device_unregister(struct rtc_device *rtc);
 
-extern int rtc_read_time(struct class_device *class_dev, struct rtc_time *tm);
-extern int rtc_set_time(struct class_device *class_dev, struct rtc_time *tm);
-extern int rtc_set_mmss(struct class_device *class_dev, unsigned long secs);
-extern int rtc_read_alarm(struct class_device *class_dev,
+extern int rtc_read_time(struct rtc_device *rtc, struct rtc_time *tm);
+extern int rtc_set_time(struct rtc_device *rtc, struct rtc_time *tm);
+extern int rtc_set_mmss(struct rtc_device *rtc, unsigned long secs);
+extern int rtc_read_alarm(struct rtc_device *rtc,
 			struct rtc_wkalrm *alrm);
-extern int rtc_set_alarm(struct class_device *class_dev,
+extern int rtc_set_alarm(struct rtc_device *rtc,
 				struct rtc_wkalrm *alrm);
-extern void rtc_update_irq(struct class_device *class_dev,
+extern void rtc_update_irq(struct rtc_device *rtc,
 			unsigned long num, unsigned long events);
 
-extern struct class_device *rtc_class_open(char *name);
-extern void rtc_class_close(struct class_device *class_dev);
+extern struct rtc_device *rtc_class_open(char *name);
+extern void rtc_class_close(struct rtc_device *rtc);
 
-extern int rtc_irq_register(struct class_device *class_dev,
+extern int rtc_irq_register(struct rtc_device *rtc,
 				struct rtc_task *task);
-extern void rtc_irq_unregister(struct class_device *class_dev,
+extern void rtc_irq_unregister(struct rtc_device *rtc,
 				struct rtc_task *task);
-extern int rtc_irq_set_state(struct class_device *class_dev,
+extern int rtc_irq_set_state(struct rtc_device *rtc,
 				struct rtc_task *task, int enabled);
-extern int rtc_irq_set_freq(struct class_device *class_dev,
+extern int rtc_irq_set_freq(struct rtc_device *rtc,
 				struct rtc_task *task, int freq);
 
 typedef struct rtc_task {
_

Patches currently in -mm which might be from david-b@pacbell.net are

rtc_cmos-oops-fix.patch
parport-is-an-orphan.patch
git-avr32.patch
git-md-accel.patch
8250-make-probing-for-txen-bug-a-config-option.patch
blackfin-on-chip-rtc-controller-driver.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-rtc-interfaces-dont-use-class_device.patch
rtc-simplified-rtc-sysfs-attribute-handling.patch
rtc-simplified-proc-driver-rtc-handling.patch
rtc-remove-rest-of-class_device.patch
rtc-suspend-resume-restores-system-clock.patch
