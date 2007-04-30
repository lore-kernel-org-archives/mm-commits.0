From: akpm@linux-foundation.org
Subject: - scsi-newstyle-hotplug-coldplug-support.patch removed from -mm tree
Date: Mon, 30 Apr 2007 14:39:01 -0700
Message-ID: <200704302139.l3ULd18g015527@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423706AbXD3Vj6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 17:39:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, James.Bottomley@steeleye.com, dbrownell@users.sourceforge.net, mjt@tls.msk.ru, mm-commits@vger.kernel.org


The patch titled
     SCSI newstyle hotplug/coldplug support
has been removed from the -mm tree.  Its filename was
     scsi-newstyle-hotplug-coldplug-support.patch

This patch was dropped because other scsi changes trashed it

------------------------------------------------------
Subject: SCSI newstyle hotplug/coldplug support
From: David Brownell <david-b@pacbell.net>

This teaches scsi devices how to support "new style" hotplug/coldplug:
using a modalias sysfs attribute for coldplug, and MODALIAS environment
variable for hotplug.

It also updates the CH, SD, SR, and ST drivers with the aliases needed to
drive them by that mechanism.  (Older OnStream devices use OSST not ST;
left for someone else to sort out.  SG seems best loaded by KMOD.)

Using this, I've seen pure new-style hotplugging drive the loading of all
the relevant driver modules for usb storage devices: host controller,
usb-storage, scsi core, sd_mod.  Previously, sd_mod never loaded.  (Except
when using the obsolete old-style hotplug scripts ...  which are unusable
on ~100 BogoMIPS embedded systems that only run busybox, but may have no
options for lots of external storage other than USB.) Yep, this is a LOT
faster too.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ch.c         |    1 +
 drivers/scsi/scsi_sysfs.c |   23 +++++++++++++++++++++++
 drivers/scsi/sd.c         |    4 ++++
 drivers/scsi/sr.c         |    2 ++
 drivers/scsi/st.c         |    1 +
 5 files changed, 31 insertions(+)

diff -puN drivers/scsi/ch.c~scsi-newstyle-hotplug-coldplug-support drivers/scsi/ch.c
--- a/drivers/scsi/ch.c~scsi-newstyle-hotplug-coldplug-support
+++ a/drivers/scsi/ch.c
@@ -38,6 +38,7 @@ MODULE_DESCRIPTION("device driver for sc
 MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org>");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_CHARDEV_MAJOR(SCSI_CHANGER_MAJOR);
+MODULE_ALIAS("scsi:type-08");		/* TYPE_MEDIUM_CHANGER */
 
 static int init = 1;
 module_param(init, int, 0444);
diff -puN drivers/scsi/scsi_sysfs.c~scsi-newstyle-hotplug-coldplug-support drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c~scsi-newstyle-hotplug-coldplug-support
+++ a/drivers/scsi/scsi_sysfs.c
@@ -277,6 +277,18 @@ static int scsi_bus_match(struct device 
 	return (sdp->inq_periph_qual == SCSI_INQ_PQ_CON)? 1: 0;
 }
 
+/* for hotplug support: modprobe $MODALIAS */
+static int scsi_uevent(struct device *dev, char **envp, int num_envp,
+		char *buffer, int buffer_size)
+{
+	struct scsi_device *sdp = to_scsi_device(dev);
+
+	envp[0] = buffer;
+	snprintf(buffer, buffer_size, "MODALIAS=scsi:type-%02x", (u8)sdp->type);
+	envp[1] = NULL;
+	return 0;
+}
+
 static int scsi_bus_suspend(struct device * dev, pm_message_t state)
 {
 	struct device_driver *drv = dev->driver;
@@ -332,6 +344,7 @@ static int scsi_bus_resume(struct device
 struct bus_type scsi_bus_type = {
         .name		= "scsi",
         .match		= scsi_bus_match,
+	.uevent		= scsi_uevent,
 	.suspend	= scsi_bus_suspend,
 	.resume		= scsi_bus_resume,
 };
@@ -571,6 +584,15 @@ show_sdev_iostat(iorequest_cnt);
 show_sdev_iostat(iodone_cnt);
 show_sdev_iostat(ioerr_cnt);
 
+/* for coldplug support: modprobe $(cat .../modalias) */
+static ssize_t
+show_modalias(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	return snprintf(buf, 20, "scsi:type-%02x\n", (u8)sdev->type);
+}
+static DEVICE_ATTR(modalias, S_IRUGO, show_modalias, NULL);
 
 /* Default template for device attributes.  May NOT be modified */
 static struct device_attribute *scsi_sysfs_sdev_attrs[] = {
@@ -590,6 +612,7 @@ static struct device_attribute *scsi_sys
 	&dev_attr_iorequest_cnt,
 	&dev_attr_iodone_cnt,
 	&dev_attr_ioerr_cnt,
+	&dev_attr_modalias,
 	NULL
 };
 
diff -puN drivers/scsi/sd.c~scsi-newstyle-hotplug-coldplug-support drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~scsi-newstyle-hotplug-coldplug-support
+++ a/drivers/scsi/sd.c
@@ -241,6 +241,10 @@ static struct scsi_driver sd_template = 
 	.issue_flush		= sd_issue_flush,
 };
 
+MODULE_ALIAS("scsi:type-00");		/* TYPE_DISK */
+MODULE_ALIAS("scsi:type-07");		/* TYPE_MOD */
+MODULE_ALIAS("scsi:type-0e");		/* TYPE_RBC */
+
 /*
  * Device no to disk mapping:
  * 
diff -puN drivers/scsi/sr.c~scsi-newstyle-hotplug-coldplug-support drivers/scsi/sr.c
--- a/drivers/scsi/sr.c~scsi-newstyle-hotplug-coldplug-support
+++ a/drivers/scsi/sr.c
@@ -62,6 +62,8 @@
 MODULE_DESCRIPTION("SCSI cdrom (sr) driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_CDROM_MAJOR);
+MODULE_ALIAS("scsi:type-04");		/* TYPE_WORM */
+MODULE_ALIAS("scsi:type-05");		/* TYPE_ROM */
 
 #define SR_DISKS	256
 
diff -puN drivers/scsi/st.c~scsi-newstyle-hotplug-coldplug-support drivers/scsi/st.c
--- a/drivers/scsi/st.c~scsi-newstyle-hotplug-coldplug-support
+++ a/drivers/scsi/st.c
@@ -89,6 +89,7 @@ MODULE_AUTHOR("Kai Makisara");
 MODULE_DESCRIPTION("SCSI tape (st) driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_CHARDEV_MAJOR(SCSI_TAPE_MAJOR);
+MODULE_ALIAS("scsi:type-01");		/* TYPE_TAPE */
 
 /* Set 'perm' (4th argument) to 0 to disable module_param's definition
  * of sysfs parameters (which module_param doesn't yet support).
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
power-management-implement-pm_opsvalid-for-everybody-fix.patch
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
at91_cf-minor-fix.patch
scsi-newstyle-hotplug-coldplug-support.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
kconfig-mentioneds-hibernation-not-just-swsusp.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
init-dma-masks-in-pnp_dev.patch
rtc-add-rtc-rs5c313-driver.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
char-cs5535_gpio-add-module_device_table.patch
parport-dev-driver-model-support.patch
layered-parport-code-uses-parport-dev.patch
pnpacpi-sets-pnpdev-devarchdata.patch
fix-hotplug-for-legacy-platform-drivers.patch
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
workaround-rtc-related-acpi-table-bugs.patch
revert-rtc-add-rtc_merge_alarm.patch
remove-rtc_alm_set-mode-bugs.patch
