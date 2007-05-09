From: akpm@linux-foundation.org
Subject: - rtc-simplified-proc-driver-rtc-handling.patch removed from -mm tree
Date: Tue, 08 May 2007 19:54:07 -0700
Message-ID: <200705090254.l492s7PV009770@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032239AbXEICyW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:54:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     rtc: simplified /proc/driver/rtc handling
has been removed from the -mm tree.  Its filename was
     rtc-simplified-proc-driver-rtc-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc: simplified /proc/driver/rtc handling
From: David Brownell <david-b@pacbell.net>

This simplifies the RTC procfs support by removing the class_interface that
hooks it into the rtc core.  If it's configured, then sysfs support is now
part of the RTC core, and is never a separate module.

It also removes the class_interface hook, now that its last remaining user is
gone.  (That API is usable only with a "struct class_device".)

It's another step towards being able to remove "struct class_device".

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Acked-By: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig    |    2 -
 drivers/rtc/Makefile   |    3 --
 drivers/rtc/class.c    |    9 +-----
 drivers/rtc/rtc-core.h |   14 +++++++++-
 drivers/rtc/rtc-proc.c |   51 +++------------------------------------
 5 files changed, 20 insertions(+), 59 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-simplified-proc-driver-rtc-handling drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-simplified-proc-driver-rtc-handling
+++ a/drivers/rtc/Kconfig
@@ -59,7 +59,7 @@ config RTC_INTF_SYSFS
 	  will be called rtc-sysfs.
 
 config RTC_INTF_PROC
-	tristate "proc"
+	boolean "proc"
 	depends on RTC_CLASS && PROC_FS
 	default RTC_CLASS
 	help
diff -puN drivers/rtc/Makefile~rtc-simplified-proc-driver-rtc-handling drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-simplified-proc-driver-rtc-handling
+++ a/drivers/rtc/Makefile
@@ -12,10 +12,9 @@ obj-$(CONFIG_RTC_CLASS)		+= rtc-core.o
 rtc-core-y			:= class.o interface.o
 
 rtc-core-$(CONFIG_RTC_INTF_DEV)	+= rtc-dev.o
+rtc-core-$(CONFIG_RTC_INTF_PROC) += rtc-proc.o
 rtc-core-$(CONFIG_RTC_INTF_SYSFS) += rtc-sysfs.o
 
-obj-$(CONFIG_RTC_INTF_PROC)	+= rtc-proc.o
-
 obj-$(CONFIG_RTC_DRV_CMOS)	+= rtc-cmos.o
 obj-$(CONFIG_RTC_DRV_X1205)	+= rtc-x1205.o
 obj-$(CONFIG_RTC_DRV_ISL1208)	+= rtc-isl1208.o
diff -puN drivers/rtc/class.c~rtc-simplified-proc-driver-rtc-handling drivers/rtc/class.c
--- a/drivers/rtc/class.c~rtc-simplified-proc-driver-rtc-handling
+++ a/drivers/rtc/class.c
@@ -90,6 +90,7 @@ struct rtc_device *rtc_device_register(c
 
 	rtc_dev_add_device(rtc);
 	rtc_sysfs_add_device(rtc);
+	rtc_proc_add_device(rtc);
 
 	dev_info(dev, "rtc core: registered %s as %s\n",
 			rtc->name, rtc->class_dev.class_id);
@@ -126,6 +127,7 @@ void rtc_device_unregister(struct rtc_de
 		 */
 		rtc_sysfs_del_device(rtc);
 		rtc_dev_del_device(rtc);
+		rtc_proc_del_device(rtc);
 		class_device_unregister(&rtc->class_dev);
 		rtc->ops = NULL;
 		mutex_unlock(&rtc->ops_lock);
@@ -134,13 +136,6 @@ void rtc_device_unregister(struct rtc_de
 }
 EXPORT_SYMBOL_GPL(rtc_device_unregister);
 
-int rtc_interface_register(struct class_interface *intf)
-{
-	intf->class = rtc_class;
-	return class_interface_register(intf);
-}
-EXPORT_SYMBOL_GPL(rtc_interface_register);
-
 static int __init rtc_init(void)
 {
 	rtc_class = class_create(THIS_MODULE, "rtc");
diff -puN drivers/rtc/rtc-core.h~rtc-simplified-proc-driver-rtc-handling drivers/rtc/rtc-core.h
--- a/drivers/rtc/rtc-core.h~rtc-simplified-proc-driver-rtc-handling
+++ a/drivers/rtc/rtc-core.h
@@ -1,5 +1,3 @@
-extern int rtc_interface_register(struct class_interface *intf);
-
 #ifdef CONFIG_RTC_INTF_DEV
 
 extern void __init rtc_dev_init(void);
@@ -16,6 +14,18 @@ extern void rtc_dev_del_device(struct rt
 
 #endif
 
+#ifdef CONFIG_RTC_INTF_PROC
+
+void rtc_proc_add_device(struct rtc_device *rtc);
+void rtc_proc_del_device(struct rtc_device *rtc);
+
+#else
+
+#define rtc_proc_add_device(r)	do{}while(0)
+#define rtc_proc_del_device(r)	do{}while(0)
+
+#endif
+
 #ifdef CONFIG_RTC_INTF_SYSFS
 
 extern void __init rtc_sysfs_init(struct class *);
diff -puN drivers/rtc/rtc-proc.c~rtc-simplified-proc-driver-rtc-handling drivers/rtc/rtc-proc.c
--- a/drivers/rtc/rtc-proc.c~rtc-simplified-proc-driver-rtc-handling
+++ a/drivers/rtc/rtc-proc.c
@@ -19,9 +19,6 @@
 #include "rtc-core.h"
 
 
-static struct class_device *rtc_dev = NULL;
-static DEFINE_MUTEX(rtc_lock);
-
 static int rtc_proc_show(struct seq_file *seq, void *offset)
 {
 	int err;
@@ -106,62 +103,22 @@ static const struct file_operations rtc_
 	.release	= rtc_proc_release,
 };
 
-static int rtc_proc_add_device(struct class_device *class_dev,
-					struct class_interface *class_intf)
+void rtc_proc_add_device(struct rtc_device *rtc)
 {
-	mutex_lock(&rtc_lock);
-	if (rtc_dev == NULL) {
+	if (rtc->id == 0) {
 		struct proc_dir_entry *ent;
 
-		rtc_dev = class_dev;
-
 		ent = create_proc_entry("driver/rtc", 0, NULL);
 		if (ent) {
-			struct rtc_device *rtc = to_rtc_device(class_dev);
-
 			ent->proc_fops = &rtc_proc_fops;
 			ent->owner = rtc->owner;
 			ent->data = rtc;
-
-			dev_dbg(class_dev->dev, "rtc intf: proc\n");
 		}
-		else
-			rtc_dev = NULL;
 	}
-	mutex_unlock(&rtc_lock);
-
-	return 0;
 }
 
-static void rtc_proc_remove_device(struct class_device *class_dev,
-					struct class_interface *class_intf)
+void rtc_proc_del_device(struct rtc_device *rtc)
 {
-	mutex_lock(&rtc_lock);
-	if (rtc_dev == class_dev) {
+	if (rtc->id == 0)
 		remove_proc_entry("driver/rtc", NULL);
-		rtc_dev = NULL;
-	}
-	mutex_unlock(&rtc_lock);
-}
-
-static struct class_interface rtc_proc_interface = {
-	.add = &rtc_proc_add_device,
-	.remove = &rtc_proc_remove_device,
-};
-
-static int __init rtc_proc_init(void)
-{
-	return rtc_interface_register(&rtc_proc_interface);
 }
-
-static void __exit rtc_proc_exit(void)
-{
-	class_interface_unregister(&rtc_proc_interface);
-}
-
-subsys_initcall(rtc_proc_init);
-module_exit(rtc_proc_exit);
-
-MODULE_AUTHOR("Alessandro Zummo <a.zummo@towertech.it>");
-MODULE_DESCRIPTION("RTC class proc interface");
-MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
use-common-cpu_is_xxx-macros-on-at91-and-avr32.patch
atmel_spi-remove-unnecessary-and-wrong-ifdefs.patch
