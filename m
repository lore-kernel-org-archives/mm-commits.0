From: akpm@linux-foundation.org
Subject: - rtc-update-to-class-device-removal-patches.patch removed from -mm tree
Date: Tue, 08 May 2007 19:54:18 -0700
Message-ID: <200705090254.l492sI5l009789@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032281AbXEICyb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:54:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     rtc: update to class device removal patches
has been removed from the -mm tree.  Its filename was
     rtc-update-to-class-device-removal-patches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc: update to class device removal patches
From: David Brownell <david-b@pacbell.net>

Fix a goof in the revised classdev support for RTCs: make sure the /dev
node info is ready before the device is registered, not after.  Otherwise
the /sys/class/rtc/rtcN/dev attribute won't be created and then udev won't
have the information it needs to create the /dev/rtcN node.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c    |    2 ++
 drivers/rtc/rtc-core.h |    5 +++++
 drivers/rtc/rtc-dev.c  |    5 ++++-
 3 files changed, 11 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/class.c~rtc-update-to-class-device-removal-patches drivers/rtc/class.c
--- a/drivers/rtc/class.c~rtc-update-to-class-device-removal-patches
+++ a/drivers/rtc/class.c
@@ -156,6 +156,8 @@ struct rtc_device *rtc_device_register(c
 	strlcpy(rtc->name, name, RTC_DEVICE_NAME_SIZE);
 	snprintf(rtc->dev.bus_id, BUS_ID_SIZE, "rtc%d", id);
 
+	rtc_dev_prepare(rtc);
+
 	err = device_register(&rtc->dev);
 	if (err)
 		goto exit_kfree;
diff -puN drivers/rtc/rtc-core.h~rtc-update-to-class-device-removal-patches drivers/rtc/rtc-core.h
--- a/drivers/rtc/rtc-core.h~rtc-update-to-class-device-removal-patches
+++ a/drivers/rtc/rtc-core.h
@@ -2,6 +2,7 @@
 
 extern void __init rtc_dev_init(void);
 extern void __exit rtc_dev_exit(void);
+extern void rtc_dev_prepare(struct rtc_device *rtc);
 extern void rtc_dev_add_device(struct rtc_device *rtc);
 extern void rtc_dev_del_device(struct rtc_device *rtc);
 
@@ -15,6 +16,10 @@ static inline void rtc_dev_exit(void)
 {
 }
 
+static inline void rtc_dev_prepare(struct rtc_device *rtc)
+{
+}
+
 static inline void rtc_dev_add_device(struct rtc_device *rtc)
 {
 }
diff -puN drivers/rtc/rtc-dev.c~rtc-update-to-class-device-removal-patches drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~rtc-update-to-class-device-removal-patches
+++ a/drivers/rtc/rtc-dev.c
@@ -396,7 +396,7 @@ static const struct file_operations rtc_
 
 /* insertion/removal hooks */
 
-void rtc_dev_add_device(struct rtc_device *rtc)
+void rtc_dev_prepare(struct rtc_device *rtc)
 {
 	if (!rtc_devt)
 		return;
@@ -418,7 +418,10 @@ void rtc_dev_add_device(struct rtc_devic
 
 	cdev_init(&rtc->char_dev, &rtc_dev_fops);
 	rtc->char_dev.owner = rtc->owner;
+}
 
+void rtc_dev_add_device(struct rtc_device *rtc)
+{
 	if (cdev_add(&rtc->char_dev, rtc->dev.devt, 1))
 		printk(KERN_WARNING "%s: failed to add char device %d:%d\n",
 			rtc->name, MAJOR(rtc_devt), rtc->id);
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
use-common-cpu_is_xxx-macros-on-at91-and-avr32.patch
atmel_spi-remove-unnecessary-and-wrong-ifdefs.patch
