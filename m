From: akpm@linux-foundation.org
Subject: - libata-check-for-an-support-update.patch removed from -mm tree
Date: Mon, 25 Jun 2007 15:47:44 -0700
Message-ID: <200706252247.l5PMli9U012899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47126 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752537AbXFYWrv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 18:47:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristen.c.accardi@intel.com, mm-commits@vger.kernel.org


The patch titled
     libata: check for AN support (update)
has been removed from the -mm tree.  Its filename was
     libata-check-for-an-support-update.patch

This patch was dropped because my copy is out of date

------------------------------------------------------
Subject: libata: check for AN support (update)
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Modify ata_dev_set_AN to take a second argument 'enable'.  This
boolean indicates to the function whether SETFEATURES_SATA_ENABLE
or SETFEATURES_SATA_DISABLE should be passed to the device.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-check-for-an-support-update drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-check-for-an-support-update
+++ a/drivers/ata/libata-core.c
@@ -70,7 +70,7 @@ const unsigned long sata_deb_timing_long
 static unsigned int ata_dev_init_params(struct ata_device *dev,
 					u16 heads, u16 sectors);
 static unsigned int ata_dev_set_xfermode(struct ata_device *dev);
-static unsigned int ata_dev_set_AN(struct ata_device *dev);
+static unsigned int ata_dev_set_AN(struct ata_device *dev, u8 enable);
 static void ata_dev_xfermask(struct ata_device *dev);
 
 unsigned int ata_print_id = 1;
@@ -1976,7 +1976,7 @@ int ata_dev_configure(struct ata_device 
 		if ((ap->flags & ATA_FLAG_AN) && ata_id_has_AN(id)) {
 			int err;
 			/* issue SET feature command to turn this on */
-			err = ata_dev_set_AN(dev);
+			err = ata_dev_set_AN(dev, SETFEATURES_SATA_ENABLE);
 			if (err)
 				ata_dev_printk(dev, KERN_ERR,
 						"unable to set AN, err %x\n",
@@ -3981,6 +3981,7 @@ static unsigned int ata_dev_set_xfermode
 /**
  *	ata_dev_set_AN - Issue SET FEATURES - SATA FEATURES
  *	@dev: Device to which command will be sent
+ *	@enable: Whether to enable or disable the feature
  *
  *	Issue SET FEATURES - SATA FEATURES command to device @dev
  *	on port @ap with sector count set to indicate Asynchronous
@@ -3992,7 +3993,7 @@ static unsigned int ata_dev_set_xfermode
  *	RETURNS:
  *	0 on success, AC_ERR_* mask otherwise.
  */
-static unsigned int ata_dev_set_AN(struct ata_device *dev)
+static unsigned int ata_dev_set_AN(struct ata_device *dev, u8 enable)
 {
 	struct ata_taskfile tf;
 	unsigned int err_mask;
@@ -4002,7 +4003,7 @@ static unsigned int ata_dev_set_AN(struc
 
 	ata_tf_init(dev, &tf);
 	tf.command = ATA_CMD_SET_FEATURES;
-	tf.feature = SETFEATURES_SATA_ENABLE;
+	tf.feature = enable;
 	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
 	tf.protocol = ATA_PROT_NODATA;
 	tf.nsect = SATA_AN;
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

git-acpi.patch
libata-check-for-an-support-update.patch
scsi-expose-an-to-user-space.patch
libata-expose-an-to-user-space.patch
scsi-save-disk-in-scsi_device.patch
libata-send-event-when-an-received.patch
cpci_hotplug-convert-to-use-the-kthread-api.patch
