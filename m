From: akpm@linux-foundation.org
Subject: + rtc-remove-rest-of-class_device.patch added to -mm tree
Date: Thu, 01 Mar 2007 02:01:34 -0800
Message-ID: <200703011001.l21A1YEt010046@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37435 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964797AbXCAKBx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 05:01:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, gregkh@suse.de


The patch titled
     rtc: remove rest of class_device
has been added to the -mm tree.  Its filename is
     rtc-remove-rest-of-class_device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc: remove rest of class_device
From: David Brownell <david-b@pacbell.net>

Finish converting the RTC framework so it no longer uses class_device.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Acked-By: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c     |   22 +++++++++++-----------
 drivers/rtc/hctosys.c   |    6 +++---
 drivers/rtc/interface.c |   34 +++++++++++++++++-----------------
 drivers/rtc/rtc-cmos.c  |   12 ++++++------
 drivers/rtc/rtc-dev.c   |   14 +++++++-------
 drivers/rtc/rtc-omap.c  |    8 ++++----
 drivers/rtc/rtc-proc.c  |    2 +-
 drivers/rtc/rtc-sysfs.c |   38 +++++++++++++++++++++++---------------
 include/linux/rtc.h     |    4 ++--
 9 files changed, 74 insertions(+), 66 deletions(-)

diff -puN drivers/rtc/class.c~rtc-remove-rest-of-class_device drivers/rtc/class.c
--- a/drivers/rtc/class.c~rtc-remove-rest-of-class_device
+++ a/drivers/rtc/class.c
@@ -23,9 +23,9 @@ static DEFINE_IDR(rtc_idr);
 static DEFINE_MUTEX(idr_lock);
 struct class *rtc_class;
 
-static void rtc_device_release(struct class_device *class_dev)
+static void rtc_device_release(struct device *dev)
 {
-	struct rtc_device *rtc = to_rtc_device(class_dev);
+	struct rtc_device *rtc = to_rtc_device(dev);
 	mutex_lock(&idr_lock);
 	idr_remove(&rtc_idr, rtc->id);
 	mutex_unlock(&idr_lock);
@@ -73,18 +73,18 @@ struct rtc_device *rtc_device_register(c
 	rtc->ops = ops;
 	rtc->owner = owner;
 	rtc->max_user_freq = 64;
-	rtc->class_dev.dev = dev;
-	rtc->class_dev.class = rtc_class;
-	rtc->class_dev.release = rtc_device_release;
+	rtc->dev.parent = dev;
+	rtc->dev.class = rtc_class;
+	rtc->dev.release = rtc_device_release;
 
 	mutex_init(&rtc->ops_lock);
 	spin_lock_init(&rtc->irq_lock);
 	spin_lock_init(&rtc->irq_task_lock);
 
 	strlcpy(rtc->name, name, RTC_DEVICE_NAME_SIZE);
-	snprintf(rtc->class_dev.class_id, BUS_ID_SIZE, "rtc%d", id);
+	snprintf(rtc->dev.bus_id, BUS_ID_SIZE, "rtc%d", id);
 
-	err = class_device_register(&rtc->class_dev);
+	err = device_register(&rtc->dev);
 	if (err)
 		goto exit_kfree;
 
@@ -93,7 +93,7 @@ struct rtc_device *rtc_device_register(c
 	rtc_proc_add_device(rtc);
 
 	dev_info(dev, "rtc core: registered %s as %s\n",
-			rtc->name, rtc->class_dev.class_id);
+			rtc->name, rtc->dev.bus_id);
 
 	return rtc;
 
@@ -120,7 +120,7 @@ EXPORT_SYMBOL_GPL(rtc_device_register);
  */
 void rtc_device_unregister(struct rtc_device *rtc)
 {
-	if (class_device_get(&rtc->class_dev) != NULL) {
+	if (get_device(&rtc->dev) != NULL) {
 		mutex_lock(&rtc->ops_lock);
 		/* remove innards of this RTC, then disable it, before
 		 * letting any rtc_class_open() users access it again
@@ -128,10 +128,10 @@ void rtc_device_unregister(struct rtc_de
 		rtc_sysfs_del_device(rtc);
 		rtc_dev_del_device(rtc);
 		rtc_proc_del_device(rtc);
-		class_device_unregister(&rtc->class_dev);
+		device_unregister(&rtc->dev);
 		rtc->ops = NULL;
 		mutex_unlock(&rtc->ops_lock);
-		class_device_put(&rtc->class_dev);
+		put_device(&rtc->dev);
 	}
 }
 EXPORT_SYMBOL_GPL(rtc_device_unregister);
diff -puN drivers/rtc/hctosys.c~rtc-remove-rest-of-class_device drivers/rtc/hctosys.c
--- a/drivers/rtc/hctosys.c~rtc-remove-rest-of-class_device
+++ a/drivers/rtc/hctosys.c
@@ -46,7 +46,7 @@ static int __init rtc_hctosys(void)
 
 			do_settimeofday(&tv);
 
-			dev_info(rtc->class_dev.dev,
+			dev_info(rtc->dev.parent,
 				"setting the system clock to "
 				"%d-%02d-%02d %02d:%02d:%02d (%u)\n",
 				tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
@@ -54,11 +54,11 @@ static int __init rtc_hctosys(void)
 				(unsigned int) tv.tv_sec);
 		}
 		else
-			dev_err(rtc->class_dev.dev,
+			dev_err(rtc->dev.parent,
 				"hctosys: invalid date/time\n");
 	}
 	else
-		dev_err(rtc->class_dev.dev,
+		dev_err(rtc->dev.parent,
 			"hctosys: unable to read the hardware clock\n");
 
 	rtc_class_close(rtc);
diff -puN drivers/rtc/interface.c~rtc-remove-rest-of-class_device drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc-remove-rest-of-class_device
+++ a/drivers/rtc/interface.c
@@ -27,7 +27,7 @@ int rtc_read_time(struct rtc_device *rtc
 		err = -EINVAL;
 	else {
 		memset(tm, 0, sizeof(struct rtc_time));
-		err = rtc->ops->read_time(rtc->class_dev.dev, tm);
+		err = rtc->ops->read_time(rtc->dev.parent, tm);
 	}
 
 	mutex_unlock(&rtc->ops_lock);
@@ -52,7 +52,7 @@ int rtc_set_time(struct rtc_device *rtc,
 	else if (!rtc->ops->set_time)
 		err = -EINVAL;
 	else
-		err = rtc->ops->set_time(rtc->class_dev.dev, tm);
+		err = rtc->ops->set_time(rtc->dev.parent, tm);
 
 	mutex_unlock(&rtc->ops_lock);
 	return err;
@@ -70,11 +70,11 @@ int rtc_set_mmss(struct rtc_device *rtc,
 	if (!rtc->ops)
 		err = -ENODEV;
 	else if (rtc->ops->set_mmss)
-		err = rtc->ops->set_mmss(rtc->class_dev.dev, secs);
+		err = rtc->ops->set_mmss(rtc->dev.parent, secs);
 	else if (rtc->ops->read_time && rtc->ops->set_time) {
 		struct rtc_time new, old;
 
-		err = rtc->ops->read_time(rtc->class_dev.dev, &old);
+		err = rtc->ops->read_time(rtc->dev.parent, &old);
 		if (err == 0) {
 			rtc_time_to_tm(secs, &new);
 
@@ -86,7 +86,7 @@ int rtc_set_mmss(struct rtc_device *rtc,
 			 */
 			if (!((old.tm_hour == 23 && old.tm_min == 59) ||
 				(new.tm_hour == 23 && new.tm_min == 59)))
-				err = rtc->ops->set_time(rtc->class_dev.dev,
+				err = rtc->ops->set_time(rtc->dev.parent,
 						&new);
 		}
 	}
@@ -113,7 +113,7 @@ int rtc_read_alarm(struct rtc_device *rt
 		err = -EINVAL;
 	else {
 		memset(alarm, 0, sizeof(struct rtc_wkalrm));
-		err = rtc->ops->read_alarm(rtc->class_dev.dev, alarm);
+		err = rtc->ops->read_alarm(rtc->dev.parent, alarm);
 	}
 
 	mutex_unlock(&rtc->ops_lock);
@@ -134,7 +134,7 @@ int rtc_set_alarm(struct rtc_device *rtc
 	else if (!rtc->ops->set_alarm)
 		err = -EINVAL;
 	else
-		err = rtc->ops->set_alarm(rtc->class_dev.dev, alarm);
+		err = rtc->ops->set_alarm(rtc->dev.parent, alarm);
 
 	mutex_unlock(&rtc->ops_lock);
 	return err;
@@ -167,22 +167,22 @@ EXPORT_SYMBOL_GPL(rtc_update_irq);
 
 struct rtc_device *rtc_class_open(char *name)
 {
-	struct class_device *class_dev_tmp;
+	struct device *dev;
 	struct rtc_device *rtc = NULL;
 
 	down(&rtc_class->sem);
-	list_for_each_entry(class_dev_tmp, &rtc_class->children, node) {
-		if (strncmp(class_dev_tmp->class_id, name, BUS_ID_SIZE) == 0) {
-			class_dev_tmp = class_device_get(class_dev_tmp);
-			if (class_dev_tmp)
-				rtc = to_rtc_device(class_dev_tmp);
+	list_for_each_entry(dev, &rtc_class->devices, node) {
+		if (strncmp(dev->bus_id, name, BUS_ID_SIZE) == 0) {
+			dev = get_device(dev);
+			if (dev)
+				rtc = to_rtc_device(dev);
 			break;
 		}
 	}
 
 	if (rtc) {
 		if (!try_module_get(rtc->owner)) {
-			class_device_put(class_dev_tmp);
+			put_device(dev);
 			rtc = NULL;
 		}
 	}
@@ -195,7 +195,7 @@ EXPORT_SYMBOL_GPL(rtc_class_open);
 void rtc_class_close(struct rtc_device *rtc)
 {
 	module_put(rtc->owner);
-	class_device_put(&rtc->class_dev);
+	put_device(&rtc->dev);
 }
 EXPORT_SYMBOL_GPL(rtc_class_close);
 
@@ -241,7 +241,7 @@ int rtc_irq_set_state(struct rtc_device 
 	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
 
 	if (err == 0)
-		err = rtc->ops->irq_set_state(rtc->class_dev.dev, enabled);
+		err = rtc->ops->irq_set_state(rtc->dev.parent, enabled);
 
 	return err;
 }
@@ -261,7 +261,7 @@ int rtc_irq_set_freq(struct rtc_device *
 	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
 
 	if (err == 0) {
-		err = rtc->ops->irq_set_freq(rtc->class_dev.dev, freq);
+		err = rtc->ops->irq_set_freq(rtc->dev.parent, freq);
 		if (err == 0)
 			rtc->irq_freq = freq;
 	}
diff -puN drivers/rtc/rtc-cmos.c~rtc-remove-rest-of-class_device drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-remove-rest-of-class_device
+++ a/drivers/rtc/rtc-cmos.c
@@ -420,7 +420,7 @@ cmos_do_probe(struct device *dev, struct
 			goto cleanup0;
 		}
 	}
-	rename_region(ports, cmos_rtc.rtc->class_dev.class_id);
+	rename_region(ports, cmos_rtc.rtc->dev.bus_id);
 
 	spin_lock_irq(&rtc_lock);
 
@@ -456,7 +456,7 @@ cmos_do_probe(struct device *dev, struct
 
 	if (is_valid_irq(rtc_irq))
 		retval = request_irq(rtc_irq, cmos_interrupt, IRQF_DISABLED,
-				cmos_rtc.rtc->class_dev.class_id,
+				cmos_rtc.rtc->dev.bus_id,
 				cmos_rtc.rtc);
 	if (retval < 0) {
 		dev_dbg(dev, "IRQ %d is already in use\n", rtc_irq);
@@ -469,7 +469,7 @@ cmos_do_probe(struct device *dev, struct
 	 */
 
 	pr_info("%s: alarms up to one %s%s\n",
-			cmos_rtc.rtc->class_dev.class_id,
+			cmos_rtc.rtc->dev.bus_id,
 			is_valid_irq(rtc_irq)
 				?  (cmos_rtc.mon_alrm
 					? "year"
@@ -511,7 +511,7 @@ static void __exit cmos_do_remove(struct
 	rename_region(cmos->iomem, NULL);
 
 	if (is_valid_irq(cmos->irq))
-		free_irq(cmos->irq, &cmos_rtc.rtc->class_dev);
+		free_irq(cmos->irq, cmos_rtc.rtc);
 
 	rtc_device_unregister(cmos_rtc.rtc);
 
@@ -549,7 +549,7 @@ static int cmos_suspend(struct device *d
 	 */
 
 	pr_debug("%s: suspend%s, ctrl %02x\n",
-			cmos_rtc.rtc->class_dev.class_id,
+			cmos_rtc.rtc->dev.bus_id,
 			(tmp & RTC_AIE) ? ", alarm may wake" : "",
 			tmp);
 
@@ -579,7 +579,7 @@ static int cmos_resume(struct device *de
 	}
 
 	pr_debug("%s: resume, ctrl %02x\n",
-			cmos_rtc.rtc->class_dev.class_id,
+			cmos_rtc.rtc->dev.bus_id,
 			cmos->suspend_ctrl);
 
 
diff -puN drivers/rtc/rtc-dev.c~rtc-remove-rest-of-class_device drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~rtc-remove-rest-of-class_device
+++ a/drivers/rtc/rtc-dev.c
@@ -33,7 +33,7 @@ static int rtc_dev_open(struct inode *in
 
 	file->private_data = rtc;
 
-	err = ops->open ? ops->open(rtc->class_dev.dev) : 0;
+	err = ops->open ? ops->open(rtc->dev.parent) : 0;
 	if (err == 0) {
 		spin_lock_irq(&rtc->irq_lock);
 		rtc->irq_data = 0;
@@ -179,7 +179,7 @@ rtc_dev_read(struct file *file, char __u
 	if (ret == 0) {
 		/* Check for any data updates */
 		if (rtc->ops->read_callback)
-			data = rtc->ops->read_callback(rtc->class_dev.dev,
+			data = rtc->ops->read_callback(rtc->dev.parent,
 						       data);
 
 		if (sizeof(int) != sizeof(long) &&
@@ -250,7 +250,7 @@ static int rtc_dev_ioctl(struct inode *i
 
 	/* try the driver's ioctl interface */
 	if (ops->ioctl) {
-		err = ops->ioctl(rtc->class_dev.dev, cmd, arg);
+		err = ops->ioctl(rtc->dev.parent, cmd, arg);
 		if (err != -ENOIOCTLCMD)
 			return err;
 	}
@@ -370,7 +370,7 @@ static int rtc_dev_release(struct inode 
 	clear_uie(rtc);
 #endif
 	if (rtc->ops->release)
-		rtc->ops->release(rtc->class_dev.dev);
+		rtc->ops->release(rtc->dev.parent);
 
 	mutex_unlock(&rtc->char_lock);
 	return 0;
@@ -405,7 +405,7 @@ void rtc_dev_add_device(struct rtc_devic
 		return;
 	}
 
-	rtc->class_dev.devt = MKDEV(MAJOR(rtc_devt), rtc->id);
+	rtc->dev.devt = MKDEV(MAJOR(rtc_devt), rtc->id);
 
 	mutex_init(&rtc->char_lock);
 	spin_lock_init(&rtc->irq_lock);
@@ -418,7 +418,7 @@ void rtc_dev_add_device(struct rtc_devic
 	cdev_init(&rtc->char_dev, &rtc_dev_fops);
 	rtc->char_dev.owner = rtc->owner;
 
-	if (cdev_add(&rtc->char_dev, rtc->class_dev.devt, 1))
+	if (cdev_add(&rtc->char_dev, rtc->dev.devt, 1))
 		printk(KERN_WARNING "%s: failed to add char device %d:%d\n",
 			rtc->name, MAJOR(rtc_devt), rtc->id);
 	else
@@ -428,7 +428,7 @@ void rtc_dev_add_device(struct rtc_devic
 
 void rtc_dev_del_device(struct rtc_device *rtc)
 {
-	if (rtc->class_dev.devt)
+	if (rtc->dev.devt)
 		cdev_del(&rtc->char_dev);
 }
 
diff -puN drivers/rtc/rtc-omap.c~rtc-remove-rest-of-class_device drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-remove-rest-of-class_device
+++ a/drivers/rtc/rtc-omap.c
@@ -399,7 +399,7 @@ static int __devinit omap_rtc_probe(stru
 		goto fail;
 	}
 	platform_set_drvdata(pdev, rtc);
-	class_set_devdata(&rtc->class_dev, mem);
+	dev_set_devdata(&rtc->dev, mem);
 
 	/* clear pending irqs, and set 1/second periodic,
 	 * which we'll use instead of update irqs
@@ -418,13 +418,13 @@ static int __devinit omap_rtc_probe(stru
 
 	/* handle periodic and alarm irqs */
 	if (request_irq(omap_rtc_timer, rtc_irq, IRQF_DISABLED,
-			rtc->class_dev.class_id, &rtc->class_dev)) {
+			rtc->dev.bus_id, rtc)) {
 		pr_debug("%s: RTC timer interrupt IRQ%d already claimed\n",
 			pdev->name, omap_rtc_timer);
 		goto fail0;
 	}
 	if (request_irq(omap_rtc_alarm, rtc_irq, IRQF_DISABLED,
-			rtc->class_dev.class_id, &rtc->class_dev)) {
+			rtc->dev.bus_id, rtc)) {
 		pr_debug("%s: RTC alarm interrupt IRQ%d already claimed\n",
 			pdev->name, omap_rtc_alarm);
 		goto fail1;
@@ -481,7 +481,7 @@ static int __devexit omap_rtc_remove(str
 	free_irq(omap_rtc_timer, rtc);
 	free_irq(omap_rtc_alarm, rtc);
 
-	release_resource(class_get_devdata(&rtc->class_dev));
+	release_resource(dev_get_devdata(&rtc->dev));
 	rtc_device_unregister(rtc);
 	return 0;
 }
diff -puN drivers/rtc/rtc-proc.c~rtc-remove-rest-of-class_device drivers/rtc/rtc-proc.c
--- a/drivers/rtc/rtc-proc.c~rtc-remove-rest-of-class_device
+++ a/drivers/rtc/rtc-proc.c
@@ -74,7 +74,7 @@ static int rtc_proc_show(struct seq_file
 	seq_printf(seq, "24hr\t\t: yes\n");
 
 	if (ops->proc)
-		ops->proc(rtc->class_dev.dev, seq);
+		ops->proc(rtc->dev.parent, seq);
 
 	return 0;
 }
diff -puN drivers/rtc/rtc-sysfs.c~rtc-remove-rest-of-class_device drivers/rtc/rtc-sysfs.c
--- a/drivers/rtc/rtc-sysfs.c~rtc-remove-rest-of-class_device
+++ a/drivers/rtc/rtc-sysfs.c
@@ -17,12 +17,16 @@
 
 /* device attributes */
 
-static ssize_t rtc_sysfs_show_name(struct class_device *dev, char *buf)
+static ssize_t
+rtc_sysfs_show_name(struct device *dev, struct device_attribute *attr,
+		char *buf)
 {
 	return sprintf(buf, "%s\n", to_rtc_device(dev)->name);
 }
 
-static ssize_t rtc_sysfs_show_date(struct class_device *dev, char *buf)
+static ssize_t
+rtc_sysfs_show_date(struct device *dev, struct device_attribute *attr,
+		char *buf)
 {
 	ssize_t retval;
 	struct rtc_time tm;
@@ -36,7 +40,9 @@ static ssize_t rtc_sysfs_show_date(struc
 	return retval;
 }
 
-static ssize_t rtc_sysfs_show_time(struct class_device *dev, char *buf)
+static ssize_t
+rtc_sysfs_show_time(struct device *dev, struct device_attribute *attr,
+		char *buf)
 {
 	ssize_t retval;
 	struct rtc_time tm;
@@ -50,7 +56,9 @@ static ssize_t rtc_sysfs_show_time(struc
 	return retval;
 }
 
-static ssize_t rtc_sysfs_show_since_epoch(struct class_device *dev, char *buf)
+static ssize_t
+rtc_sysfs_show_since_epoch(struct device *dev, struct device_attribute *attr,
+		char *buf)
 {
 	ssize_t retval;
 	struct rtc_time tm;
@@ -65,7 +73,7 @@ static ssize_t rtc_sysfs_show_since_epoc
 	return retval;
 }
 
-static struct class_device_attribute rtc_attrs[] = {
+static struct device_attribute rtc_attrs[] = {
 	__ATTR(name, S_IRUGO, rtc_sysfs_show_name, NULL),
 	__ATTR(date, S_IRUGO, rtc_sysfs_show_date, NULL),
 	__ATTR(time, S_IRUGO, rtc_sysfs_show_time, NULL),
@@ -74,7 +82,8 @@ static struct class_device_attribute rtc
 };
 
 static ssize_t
-rtc_sysfs_show_wakealarm(struct class_device *dev, char *buf)
+rtc_sysfs_show_wakealarm(struct device *dev, struct device_attribute *attr,
+		char *buf)
 {
 	ssize_t retval;
 	unsigned long alarm;
@@ -98,7 +107,8 @@ rtc_sysfs_show_wakealarm(struct class_de
 }
 
 static ssize_t
-rtc_sysfs_set_wakealarm(struct class_device *dev, const char *buf, size_t n)
+rtc_sysfs_set_wakealarm(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t n)
 {
 	ssize_t retval;
 	unsigned long now, alarm;
@@ -139,7 +149,7 @@ rtc_sysfs_set_wakealarm(struct class_dev
 	retval = rtc_set_alarm(rtc, &alm);
 	return (retval < 0) ? retval : n;
 }
-static const CLASS_DEVICE_ATTR(wakealarm, S_IRUGO | S_IWUSR,
+static DEVICE_ATTR(wakealarm, S_IRUGO | S_IWUSR,
 		rtc_sysfs_show_wakealarm, rtc_sysfs_set_wakealarm);
 
 
@@ -150,7 +160,7 @@ static const CLASS_DEVICE_ATTR(wakealarm
  */
 static inline int rtc_does_wakealarm(struct rtc_device *rtc)
 {
-	if (!device_can_wakeup(rtc->class_dev.dev))
+	if (!device_can_wakeup(rtc->dev.parent))
 		return 0;
 	return rtc->ops->set_alarm != NULL;
 }
@@ -164,10 +174,9 @@ void rtc_sysfs_add_device(struct rtc_dev
 	if (!rtc_does_wakealarm(rtc))
 		return;
 
-	err = class_device_create_file(&rtc->class_dev,
-				&class_device_attr_wakealarm);
+	err = device_create_file(&rtc->dev, &dev_attr_wakealarm);
 	if (err)
-		dev_err(rtc->class_dev.dev, "failed to create "
+		dev_err(rtc->dev.parent, "failed to create "
 				"alarm attribute, %d",
 				err);
 }
@@ -176,11 +185,10 @@ void rtc_sysfs_del_device(struct rtc_dev
 {
 	/* REVISIT did we add it successfully? */
 	if (rtc_does_wakealarm(rtc))
-		class_device_remove_file(&rtc->class_dev,
-				&class_device_attr_wakealarm);
+		device_remove_file(&rtc->dev, &dev_attr_wakealarm);
 }
 
 void __init rtc_sysfs_init(struct class *rtc_class)
 {
-	rtc_class->class_dev_attrs = rtc_attrs;
+	rtc_class->dev_attrs = rtc_attrs;
 }
diff -puN include/linux/rtc.h~rtc-remove-rest-of-class_device include/linux/rtc.h
--- a/include/linux/rtc.h~rtc-remove-rest-of-class_device
+++ a/include/linux/rtc.h
@@ -136,7 +136,7 @@ struct rtc_task;
 
 struct rtc_device
 {
-	struct class_device class_dev;
+	struct device dev;
 	struct module *owner;
 
 	int id;
@@ -168,7 +168,7 @@ struct rtc_device
 	unsigned int uie_timer_active:1;
 #endif
 };
-#define to_rtc_device(d) container_of(d, struct rtc_device, class_dev)
+#define to_rtc_device(d) container_of(d, struct rtc_device, dev)
 
 extern struct rtc_device *rtc_device_register(const char *name,
 					struct device *dev,
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
