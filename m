From: akpm@osdl.org
Subject: - i2o-more-error-checking.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:01:19 -0800
Message-ID: <200612072301.kB7N1J1k029750@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51541 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163758AbWLGXBi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:01:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, Markus.Lidel@shadowconnect.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     I2O: more error checking
has been removed from the -mm tree.  Its filename was
     i2o-more-error-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: I2O: more error checking
From: Jeff Garzik <jeff@garzik.org>

i2o_scsi: handle sysfs failure

i2o_device:
* convert i2o_device_add() to return integer error code
  rather than pointer.  Fortunately -nobody- checks the return code of
  this function, so changing has nil impact.
* handle errors thrown by device_register()

More work in i2o_device remains.

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/message/i2o/device.c   |   19 ++++++++++++-------
 drivers/message/i2o/i2o_scsi.c |   12 +++++++++---
 2 files changed, 21 insertions(+), 10 deletions(-)

diff -puN drivers/message/i2o/device.c~i2o-more-error-checking drivers/message/i2o/device.c
--- a/drivers/message/i2o/device.c~i2o-more-error-checking
+++ a/drivers/message/i2o/device.c
@@ -214,18 +214,17 @@ static struct i2o_device *i2o_device_all
  *	Allocate a new I2O device and initialize it with the LCT entry. The
  *	device is appended to the device list of the controller.
  *
- *	Returns a pointer to the I2O device on success or negative error code
- *	on failure.
+ *	Returns zero on success, or a -ve errno.
  */
-static struct i2o_device *i2o_device_add(struct i2o_controller *c,
-					 i2o_lct_entry * entry)
+static int i2o_device_add(struct i2o_controller *c, i2o_lct_entry *entry)
 {
 	struct i2o_device *i2o_dev, *tmp;
+	int rc;
 
 	i2o_dev = i2o_device_alloc();
 	if (IS_ERR(i2o_dev)) {
 		printk(KERN_ERR "i2o: unable to allocate i2o device\n");
-		return i2o_dev;
+		return PTR_ERR(i2o_dev);
 	}
 
 	i2o_dev->lct_data = *entry;
@@ -236,7 +235,9 @@ static struct i2o_device *i2o_device_add
 	i2o_dev->iop = c;
 	i2o_dev->device.parent = &c->device;
 
-	device_register(&i2o_dev->device);
+	rc = device_register(&i2o_dev->device);
+	if (rc)
+		goto err;
 
 	list_add_tail(&i2o_dev->list, &c->devices);
 
@@ -270,7 +271,11 @@ static struct i2o_device *i2o_device_add
 
 	pr_debug("i2o: device %s added\n", i2o_dev->device.bus_id);
 
-	return i2o_dev;
+	return 0;
+
+err:
+	kfree(i2o_dev);
+	return rc;
 }
 
 /**
diff -puN drivers/message/i2o/i2o_scsi.c~i2o-more-error-checking drivers/message/i2o/i2o_scsi.c
--- a/drivers/message/i2o/i2o_scsi.c~i2o-more-error-checking
+++ a/drivers/message/i2o/i2o_scsi.c
@@ -220,7 +220,7 @@ static int i2o_scsi_probe(struct device 
 	u32 id = -1;
 	u64 lun = -1;
 	int channel = -1;
-	int i;
+	int i, rc;
 
 	i2o_shost = i2o_scsi_get_host(c);
 	if (!i2o_shost)
@@ -304,14 +304,20 @@ static int i2o_scsi_probe(struct device 
 		return PTR_ERR(scsi_dev);
 	}
 
-	sysfs_create_link(&i2o_dev->device.kobj, &scsi_dev->sdev_gendev.kobj,
-			  "scsi");
+	rc = sysfs_create_link(&i2o_dev->device.kobj,
+			       &scsi_dev->sdev_gendev.kobj, "scsi");
+	if (rc)
+		goto err;
 
 	osm_info("device added (TID: %03x) channel: %d, id: %d, lun: %ld\n",
 		 i2o_dev->lct_data.tid, channel, le32_to_cpu(id),
 		 (long unsigned int)le64_to_cpu(lun));
 
 	return 0;
+
+err:
+	scsi_remove_device(scsi_dev);
+	return rc;
 };
 
 static const char *i2o_scsi_info(struct Scsi_Host *SChost)
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
git-acpi.patch
git-cpufreq.patch
drm-handle-pci_enable_device-failure.patch
git-input.patch
git-libata-all.patch
pata_cs5530-suspend-resume-support-tweak.patch
pata_sil680-suspend-resume-tidy.patch
initializer-entry-defined-twice-in-pata_rz1000.patch
ata_piix-ide-mode-sata-patch-for-intel-ich9.patch
pata_it8213-add-new-driver-for-the-it8213-card.patch
git-mtd.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
8139too-force-media-setting-fix.patch
tulip-fix-shutdown-dma-irq-race.patch
git-ioat.patch
via-sb600-sata-quirk.patch
git-pciseg.patch
pci-device-ensure-sysdata-initialised-v2.patch
mpt-fusion-handle-pci-layer-error-on-resume.patch
usb-fix-ohcih-over-use-warnings.patch
isdn-fix-warnings.patch
atyfb-rivafb-minor-fixes.patch
md-conditionalize-some-code.patch
user-of-the-jiffies-rounding-patch-ata-subsystem.patch
e1000-printk-warning-fixes.patch
git-gccbug.patch

