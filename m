From: akpm@linux-foundation.org
Subject: + rtc-update-to-class-device-removal-patches.patch added to -mm tree
Date: Wed, 11 Apr 2007 14:14:47 -0700
Message-ID: <200704112114.l3BLElb2014536@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32884 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbXDKVPD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 17:15:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net


The patch titled
     rtc: update to class device removal patches
has been added to the -mm tree.  Its filename is
     rtc-update-to-class-device-removal-patches.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -395,7 +395,7 @@ static const struct file_operations rtc_
 
 /* insertion/removal hooks */
 
-void rtc_dev_add_device(struct rtc_device *rtc)
+void rtc_dev_prepare(struct rtc_device *rtc)
 {
 	if (!rtc_devt)
 		return;
@@ -417,7 +417,10 @@ void rtc_dev_add_device(struct rtc_devic
 
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

omap_cf-oops-on-suspend-fix.patch
doc-gpiotxt-describes-open-drain-emulation.patch
make-proc-acpi-wakeup-more-useful.patch
update-documentation-driver-model-platformtxt.patch
at91_cf-minor-fix.patch
scsi-newstyle-hotplug-coldplug-support.patch
usb-gadget-rndis-fix-struct-rndis_packet_msg_type.patch
fix-hotplug-for-legacy-platform-drivers.patch
fix-hotplug-for-legacy-platform-drivers-update.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
init-dma-masks-in-pnp_dev.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
char-cs5535_gpio-add-module_device_table.patch
parport-dev-driver-model-support.patch
parport-dev-driver-model-support-powerpc-fix.patch
layered-parport-code-uses-parport-dev.patch
pnpacpi-sets-pnpdev-devarchdata.patch
pnpacpi-sets-pnpdev-devarchdata-fix.patch
minor-spi_butterfly-cleanup.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-rtc-interfaces-dont-use-class_device.patch
rtc-simplified-rtc-sysfs-attribute-handling.patch
rtc-simplified-proc-driver-rtc-handling.patch
rtc-remove-rest-of-class_device.patch
rtc-suspend-resume-restores-system-clock.patch
rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch
rtc-update-to-class-device-removal-patches.patch
rtc-kconfig-cleanup.patch
rtc-cmos-wakeup-interface.patch
acpi-wakeup-hooks-for-rtc-cmos.patch
