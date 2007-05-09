From: akpm@linux-foundation.org
Subject: - rtc-simplified-rtc-sysfs-attribute-handling.patch removed from -mm tree
Date: Tue, 08 May 2007 19:54:05 -0700
Message-ID: <200705090254.l492s5ue009766@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032257AbXEICyX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:54:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     rtc: simplified rtc sysfs attribute handling
has been removed from the -mm tree.  Its filename was
     rtc-simplified-rtc-sysfs-attribute-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc: simplified rtc sysfs attribute handling
From: David Brownell <david-b@pacbell.net>

This simplifies the RTC sysfs support by removing the class_interface that
hooks it into the rtc core.  If it's configured, then sysfs support is now
part of the RTC core, and is never a separate module.

It's another step towards being able to remove "struct class_device".

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Acked-By: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig     |    2 
 drivers/rtc/Makefile    |    2 
 drivers/rtc/class.c     |    3 +
 drivers/rtc/rtc-core.h  |   14 ++++++
 drivers/rtc/rtc-sysfs.c |   87 ++++++++++----------------------------
 5 files changed, 42 insertions(+), 66 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-simplified-rtc-sysfs-attribute-handling drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-simplified-rtc-sysfs-attribute-handling
+++ a/drivers/rtc/Kconfig
@@ -48,7 +48,7 @@ comment "RTC interfaces"
 	depends on RTC_CLASS
 
 config RTC_INTF_SYSFS
-	tristate "sysfs"
+	boolean "sysfs"
 	depends on RTC_CLASS && SYSFS
 	default RTC_CLASS
 	help
diff -puN drivers/rtc/Makefile~rtc-simplified-rtc-sysfs-attribute-handling drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-simplified-rtc-sysfs-attribute-handling
+++ a/drivers/rtc/Makefile
@@ -12,8 +12,8 @@ obj-$(CONFIG_RTC_CLASS)		+= rtc-core.o
 rtc-core-y			:= class.o interface.o
 
 rtc-core-$(CONFIG_RTC_INTF_DEV)	+= rtc-dev.o
+rtc-core-$(CONFIG_RTC_INTF_SYSFS) += rtc-sysfs.o
 
-obj-$(CONFIG_RTC_INTF_SYSFS)	+= rtc-sysfs.o
 obj-$(CONFIG_RTC_INTF_PROC)	+= rtc-proc.o
 
 obj-$(CONFIG_RTC_DRV_CMOS)	+= rtc-cmos.o
diff -puN drivers/rtc/class.c~rtc-simplified-rtc-sysfs-attribute-handling drivers/rtc/class.c
--- a/drivers/rtc/class.c~rtc-simplified-rtc-sysfs-attribute-handling
+++ a/drivers/rtc/class.c
@@ -89,6 +89,7 @@ struct rtc_device *rtc_device_register(c
 		goto exit_kfree;
 
 	rtc_dev_add_device(rtc);
+	rtc_sysfs_add_device(rtc);
 
 	dev_info(dev, "rtc core: registered %s as %s\n",
 			rtc->name, rtc->class_dev.class_id);
@@ -123,6 +124,7 @@ void rtc_device_unregister(struct rtc_de
 		/* remove innards of this RTC, then disable it, before
 		 * letting any rtc_class_open() users access it again
 		 */
+		rtc_sysfs_del_device(rtc);
 		rtc_dev_del_device(rtc);
 		class_device_unregister(&rtc->class_dev);
 		rtc->ops = NULL;
@@ -147,6 +149,7 @@ static int __init rtc_init(void)
 		return PTR_ERR(rtc_class);
 	}
 	rtc_dev_init();
+	rtc_sysfs_init(rtc_class);
 	return 0;
 }
 
diff -puN drivers/rtc/rtc-core.h~rtc-simplified-rtc-sysfs-attribute-handling drivers/rtc/rtc-core.h
--- a/drivers/rtc/rtc-core.h~rtc-simplified-rtc-sysfs-attribute-handling
+++ a/drivers/rtc/rtc-core.h
@@ -15,3 +15,17 @@ extern void rtc_dev_del_device(struct rt
 #define rtc_dev_del_device(r)	do{}while(0)
 
 #endif
+
+#ifdef CONFIG_RTC_INTF_SYSFS
+
+extern void __init rtc_sysfs_init(struct class *);
+extern void rtc_sysfs_add_device(struct rtc_device *rtc);
+extern void rtc_sysfs_del_device(struct rtc_device *rtc);
+
+#else
+
+#define rtc_sysfs_init(c)	do{}while(0)
+#define rtc_sysfs_add_device(r)	do{}while(0)
+#define rtc_sysfs_del_device(r)	do{}while(0)
+
+#endif
diff -puN drivers/rtc/rtc-sysfs.c~rtc-simplified-rtc-sysfs-attribute-handling drivers/rtc/rtc-sysfs.c
--- a/drivers/rtc/rtc-sysfs.c~rtc-simplified-rtc-sysfs-attribute-handling
+++ a/drivers/rtc/rtc-sysfs.c
@@ -21,7 +21,6 @@ static ssize_t rtc_sysfs_show_name(struc
 {
 	return sprintf(buf, "%s\n", to_rtc_device(dev)->name);
 }
-static CLASS_DEVICE_ATTR(name, S_IRUGO, rtc_sysfs_show_name, NULL);
 
 static ssize_t rtc_sysfs_show_date(struct class_device *dev, char *buf)
 {
@@ -36,7 +35,6 @@ static ssize_t rtc_sysfs_show_date(struc
 
 	return retval;
 }
-static CLASS_DEVICE_ATTR(date, S_IRUGO, rtc_sysfs_show_date, NULL);
 
 static ssize_t rtc_sysfs_show_time(struct class_device *dev, char *buf)
 {
@@ -51,7 +49,6 @@ static ssize_t rtc_sysfs_show_time(struc
 
 	return retval;
 }
-static CLASS_DEVICE_ATTR(time, S_IRUGO, rtc_sysfs_show_time, NULL);
 
 static ssize_t rtc_sysfs_show_since_epoch(struct class_device *dev, char *buf)
 {
@@ -67,21 +64,15 @@ static ssize_t rtc_sysfs_show_since_epoc
 
 	return retval;
 }
-static CLASS_DEVICE_ATTR(since_epoch, S_IRUGO, rtc_sysfs_show_since_epoch, NULL);
 
-static struct attribute *rtc_attrs[] = {
-	&class_device_attr_name.attr,
-	&class_device_attr_date.attr,
-	&class_device_attr_time.attr,
-	&class_device_attr_since_epoch.attr,
-	NULL,
+static struct class_device_attribute rtc_attrs[] = {
+	__ATTR(name, S_IRUGO, rtc_sysfs_show_name, NULL),
+	__ATTR(date, S_IRUGO, rtc_sysfs_show_date, NULL),
+	__ATTR(time, S_IRUGO, rtc_sysfs_show_time, NULL),
+	__ATTR(since_epoch, S_IRUGO, rtc_sysfs_show_since_epoch, NULL),
+	{ },
 };
 
-static struct attribute_group rtc_attr_group = {
-	.attrs = rtc_attrs,
-};
-
-
 static ssize_t
 rtc_sysfs_show_wakealarm(struct class_device *dev, char *buf)
 {
@@ -157,71 +148,39 @@ static const CLASS_DEVICE_ATTR(wakealarm
  * suspend-to-disk.  So: no attribute unless that side effect is possible.
  * (Userspace may disable that mechanism later.)
  */
-static inline int rtc_does_wakealarm(struct class_device *class_dev)
+static inline int rtc_does_wakealarm(struct rtc_device *rtc)
 {
-	struct rtc_device *rtc;
-
-	if (!device_can_wakeup(class_dev->dev))
+	if (!device_can_wakeup(rtc->class_dev.dev))
 		return 0;
-	rtc = to_rtc_device(class_dev);
 	return rtc->ops->set_alarm != NULL;
 }
 
 
-static int rtc_sysfs_add_device(struct class_device *class_dev,
-					struct class_interface *class_intf)
+void rtc_sysfs_add_device(struct rtc_device *rtc)
 {
 	int err;
 
-	dev_dbg(class_dev->dev, "rtc intf: sysfs\n");
+	/* not all RTCs support both alarms and wakeup */
+	if (!rtc_does_wakealarm(rtc))
+		return;
 
-	err = sysfs_create_group(&class_dev->kobj, &rtc_attr_group);
+	err = class_device_create_file(&rtc->class_dev,
+				&class_device_attr_wakealarm);
 	if (err)
-		dev_err(class_dev->dev, "failed to create %s\n",
-				"sysfs attributes");
-	else if (rtc_does_wakealarm(class_dev)) {
-		/* not all RTCs support both alarms and wakeup */
-		err = class_device_create_file(class_dev,
-					&class_device_attr_wakealarm);
-		if (err) {
-			dev_err(class_dev->dev, "failed to create %s\n",
-					"alarm attribute");
-			sysfs_remove_group(&class_dev->kobj, &rtc_attr_group);
-		}
-	}
-
-	return err;
+		dev_err(rtc->class_dev.dev, "failed to create "
+				"alarm attribute, %d",
+				err);
 }
 
-static void rtc_sysfs_remove_device(struct class_device *class_dev,
-				struct class_interface *class_intf)
+void rtc_sysfs_del_device(struct rtc_device *rtc)
 {
-	if (rtc_does_wakealarm(class_dev))
-		class_device_remove_file(class_dev,
+	/* REVISIT did we add it successfully? */
+	if (rtc_does_wakealarm(rtc))
+		class_device_remove_file(&rtc->class_dev,
 				&class_device_attr_wakealarm);
-	sysfs_remove_group(&class_dev->kobj, &rtc_attr_group);
 }
 
-/* interface registration */
-
-static struct class_interface rtc_sysfs_interface = {
-	.add = &rtc_sysfs_add_device,
-	.remove = &rtc_sysfs_remove_device,
-};
-
-static int __init rtc_sysfs_init(void)
+void __init rtc_sysfs_init(struct class *rtc_class)
 {
-	return rtc_interface_register(&rtc_sysfs_interface);
+	rtc_class->class_dev_attrs = rtc_attrs;
 }
-
-static void __exit rtc_sysfs_exit(void)
-{
-	class_interface_unregister(&rtc_sysfs_interface);
-}
-
-subsys_initcall(rtc_sysfs_init);
-module_exit(rtc_sysfs_exit);
-
-MODULE_AUTHOR("Alessandro Zummo <a.zummo@towertech.it>");
-MODULE_DESCRIPTION("RTC class sysfs interface");
-MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
use-common-cpu_is_xxx-macros-on-at91-and-avr32.patch
atmel_spi-remove-unnecessary-and-wrong-ifdefs.patch
