From: akpm@linux-foundation.org
Subject: - rtc-remove-sys-class-rtc-dev.patch removed from -mm tree
Date: Tue, 08 May 2007 19:53:59 -0700
Message-ID: <200705090253.l492rxMw009757@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032262AbXEICyX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:54:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, bunk@stusta.de, dbrownell@users.sourceforge.net, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     rtc: remove /sys/class/rtc-dev/*
has been removed from the -mm tree.  Its filename was
     rtc-remove-sys-class-rtc-dev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc: remove /sys/class/rtc-dev/*
From: David Brownell <david-b@pacbell.net>

This simplifies the /dev support by removing a superfluous class_device (the
/sys/class/rtc-dev stuff) and the class_interface that hooks it into the rtc
core.  Accordingly, if it's configured then /dev support is now part of the
RTC core, and is never a separate module.

It's another step towards being able to remove "struct class_device".

[bunk@stusta.de: drivers/rtc/rtc-dev.c should #include "rtc-core.h"]
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Acked-By: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig    |    2 
 drivers/rtc/Makefile   |    3 -
 drivers/rtc/class.c    |    8 ++
 drivers/rtc/rtc-core.h |   15 +++++
 drivers/rtc/rtc-dev.c  |  106 +++++++--------------------------------
 include/linux/rtc.h    |    1 
 6 files changed, 46 insertions(+), 89 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-remove-sys-class-rtc-dev drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-remove-sys-class-rtc-dev
+++ a/drivers/rtc/Kconfig
@@ -71,7 +71,7 @@ config RTC_INTF_PROC
 	  will be called rtc-proc.
 
 config RTC_INTF_DEV
-	tristate "dev"
+	boolean "dev"
 	depends on RTC_CLASS
 	default RTC_CLASS
 	help
diff -puN drivers/rtc/Makefile~rtc-remove-sys-class-rtc-dev drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-remove-sys-class-rtc-dev
+++ a/drivers/rtc/Makefile
@@ -11,9 +11,10 @@ obj-$(CONFIG_RTC_HCTOSYS)	+= hctosys.o
 obj-$(CONFIG_RTC_CLASS)		+= rtc-core.o
 rtc-core-y			:= class.o interface.o
 
+rtc-core-$(CONFIG_RTC_INTF_DEV)	+= rtc-dev.o
+
 obj-$(CONFIG_RTC_INTF_SYSFS)	+= rtc-sysfs.o
 obj-$(CONFIG_RTC_INTF_PROC)	+= rtc-proc.o
-obj-$(CONFIG_RTC_INTF_DEV)	+= rtc-dev.o
 
 obj-$(CONFIG_RTC_DRV_CMOS)	+= rtc-cmos.o
 obj-$(CONFIG_RTC_DRV_X1205)	+= rtc-x1205.o
diff -puN drivers/rtc/class.c~rtc-remove-sys-class-rtc-dev drivers/rtc/class.c
--- a/drivers/rtc/class.c~rtc-remove-sys-class-rtc-dev
+++ a/drivers/rtc/class.c
@@ -16,6 +16,9 @@
 #include <linux/kdev_t.h>
 #include <linux/idr.h>
 
+#include "rtc-core.h"
+
+
 static DEFINE_IDR(rtc_idr);
 static DEFINE_MUTEX(idr_lock);
 struct class *rtc_class;
@@ -85,6 +88,8 @@ struct rtc_device *rtc_device_register(c
 	if (err)
 		goto exit_kfree;
 
+	rtc_dev_add_device(rtc);
+
 	dev_info(dev, "rtc core: registered %s as %s\n",
 			rtc->name, rtc->class_dev.class_id);
 
@@ -118,6 +123,7 @@ void rtc_device_unregister(struct rtc_de
 		/* remove innards of this RTC, then disable it, before
 		 * letting any rtc_class_open() users access it again
 		 */
+		rtc_dev_del_device(rtc);
 		class_device_unregister(&rtc->class_dev);
 		rtc->ops = NULL;
 		mutex_unlock(&rtc->ops_lock);
@@ -140,11 +146,13 @@ static int __init rtc_init(void)
 		printk(KERN_ERR "%s: couldn't create class\n", __FILE__);
 		return PTR_ERR(rtc_class);
 	}
+	rtc_dev_init();
 	return 0;
 }
 
 static void __exit rtc_exit(void)
 {
+	rtc_dev_exit();
 	class_destroy(rtc_class);
 }
 
diff -puN /dev/null drivers/rtc/rtc-core.h
--- /dev/null
+++ a/drivers/rtc/rtc-core.h
@@ -0,0 +1,15 @@
+#ifdef CONFIG_RTC_INTF_DEV
+
+extern void __init rtc_dev_init(void);
+extern void __exit rtc_dev_exit(void);
+extern void rtc_dev_add_device(struct rtc_device *rtc);
+extern void rtc_dev_del_device(struct rtc_device *rtc);
+
+#else
+
+#define rtc_dev_init()		do{}while(0)
+#define rtc_dev_exit()		do{}while(0)
+#define rtc_dev_add_device(r)	do{}while(0)
+#define rtc_dev_del_device(r)	do{}while(0)
+
+#endif
diff -puN drivers/rtc/rtc-dev.c~rtc-remove-sys-class-rtc-dev drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~rtc-remove-sys-class-rtc-dev
+++ a/drivers/rtc/rtc-dev.c
@@ -13,8 +13,8 @@
 
 #include <linux/module.h>
 #include <linux/rtc.h>
+#include "rtc-core.h"
 
-static struct class *rtc_dev_class;
 static dev_t rtc_devt;
 
 #define RTC_DEV_MAX 16 /* 16 RTCs should be enough for everyone... */
@@ -397,17 +397,18 @@ static const struct file_operations rtc_
 
 /* insertion/removal hooks */
 
-static int rtc_dev_add_device(struct class_device *class_dev,
-				struct class_interface *class_intf)
+void rtc_dev_add_device(struct rtc_device *rtc)
 {
-	int err = 0;
-	struct rtc_device *rtc = to_rtc_device(class_dev);
+	if (!rtc_devt)
+		return;
 
 	if (rtc->id >= RTC_DEV_MAX) {
-		dev_err(class_dev->dev, "too many RTCs\n");
-		return -EINVAL;
+		pr_debug("%s: too many RTC devices\n", rtc->name);
+		return;
 	}
 
+	rtc->class_dev.devt = MKDEV(MAJOR(rtc_devt), rtc->id);
+
 	mutex_init(&rtc->char_lock);
 	spin_lock_init(&rtc->irq_lock);
 	init_waitqueue_head(&rtc->irq_queue);
@@ -419,99 +420,32 @@ static int rtc_dev_add_device(struct cla
 	cdev_init(&rtc->char_dev, &rtc_dev_fops);
 	rtc->char_dev.owner = rtc->owner;
 
-	if (cdev_add(&rtc->char_dev, MKDEV(MAJOR(rtc_devt), rtc->id), 1)) {
-		dev_err(class_dev->dev,
-			"failed to add char device %d:%d\n",
+	if (cdev_add(&rtc->char_dev, rtc->class_dev.devt, 1))
+		printk(KERN_WARNING "%s: failed to add char device %d:%d\n",
+			rtc->name, MAJOR(rtc_devt), rtc->id);
+	else
+		pr_debug("%s: dev (%d:%d)\n", rtc->name,
 			MAJOR(rtc_devt), rtc->id);
-		return -ENODEV;
-	}
-
-	rtc->rtc_dev = class_device_create(rtc_dev_class, NULL,
-						MKDEV(MAJOR(rtc_devt), rtc->id),
-						class_dev->dev, "rtc%d", rtc->id);
-	if (IS_ERR(rtc->rtc_dev)) {
-		dev_err(class_dev->dev, "cannot create rtc_dev device\n");
-		err = PTR_ERR(rtc->rtc_dev);
-		goto err_cdev_del;
-	}
-
-	dev_dbg(class_dev->dev, "rtc intf: dev (%d:%d)\n",
-		MAJOR(rtc->rtc_dev->devt),
-		MINOR(rtc->rtc_dev->devt));
-
-	return 0;
-
-err_cdev_del:
-
-	cdev_del(&rtc->char_dev);
-	return err;
 }
 
-static void rtc_dev_remove_device(struct class_device *class_dev,
-					struct class_interface *class_intf)
+void rtc_dev_del_device(struct rtc_device *rtc)
 {
-	struct rtc_device *rtc = to_rtc_device(class_dev);
-
-	if (rtc->rtc_dev) {
-		dev_dbg(class_dev->dev, "removing char %d:%d\n",
-			MAJOR(rtc->rtc_dev->devt),
-			MINOR(rtc->rtc_dev->devt));
-
-		class_device_unregister(rtc->rtc_dev);
+	if (rtc->class_dev.devt)
 		cdev_del(&rtc->char_dev);
-	}
 }
 
-/* interface registration */
-
-static struct class_interface rtc_dev_interface = {
-	.add = &rtc_dev_add_device,
-	.remove = &rtc_dev_remove_device,
-};
-
-static int __init rtc_dev_init(void)
+void __init rtc_dev_init(void)
 {
 	int err;
 
-	rtc_dev_class = class_create(THIS_MODULE, "rtc-dev");
-	if (IS_ERR(rtc_dev_class))
-		return PTR_ERR(rtc_dev_class);
-
 	err = alloc_chrdev_region(&rtc_devt, 0, RTC_DEV_MAX, "rtc");
-	if (err < 0) {
+	if (err < 0)
 		printk(KERN_ERR "%s: failed to allocate char dev region\n",
 			__FILE__);
-		goto err_destroy_class;
-	}
-
-	err = rtc_interface_register(&rtc_dev_interface);
-	if (err < 0) {
-		printk(KERN_ERR "%s: failed to register the interface\n",
-			__FILE__);
-		goto err_unregister_chrdev;
-	}
-
-	return 0;
-
-err_unregister_chrdev:
-	unregister_chrdev_region(rtc_devt, RTC_DEV_MAX);
-
-err_destroy_class:
-	class_destroy(rtc_dev_class);
-
-	return err;
 }
 
-static void __exit rtc_dev_exit(void)
+void __exit rtc_dev_exit(void)
 {
-	class_interface_unregister(&rtc_dev_interface);
-	class_destroy(rtc_dev_class);
-	unregister_chrdev_region(rtc_devt, RTC_DEV_MAX);
+	if (rtc_devt)
+		unregister_chrdev_region(rtc_devt, RTC_DEV_MAX);
 }
-
-subsys_initcall(rtc_dev_init);
-module_exit(rtc_dev_exit);
-
-MODULE_AUTHOR("Alessandro Zummo <a.zummo@towertech.it>");
-MODULE_DESCRIPTION("RTC class dev interface");
-MODULE_LICENSE("GPL");
diff -puN include/linux/rtc.h~rtc-remove-sys-class-rtc-dev include/linux/rtc.h
--- a/include/linux/rtc.h~rtc-remove-sys-class-rtc-dev
+++ a/include/linux/rtc.h
@@ -145,7 +145,6 @@ struct rtc_device
 	const struct rtc_class_ops *ops;
 	struct mutex ops_lock;
 
-	struct class_device *rtc_dev;
 	struct cdev char_dev;
 	struct mutex char_lock;
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
use-common-cpu_is_xxx-macros-on-at91-and-avr32.patch
atmel_spi-remove-unnecessary-and-wrong-ifdefs.patch
