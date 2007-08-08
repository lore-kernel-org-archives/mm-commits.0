From: akpm@linux-foundation.org
Subject: + libata-check-for-an-support.patch added to -mm tree
Date: Wed, 08 Aug 2007 12:24:58 -0700
Message-ID: <200708081924.l78JOwRM026511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35729 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752214AbXHHTZM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Aug 2007 15:25:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristen.c.accardi@intel.com, James.Bottomley@steeleye.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     libata: check for AN support
has been added to the -mm tree.  Its filename is
     libata-check-for-an-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: check for AN support
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Check to see if an ATAPI device supports Asynchronous Notification.  If so,
enable it.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ahci.c        |    5 ++-
 drivers/ata/libata-core.c |   53 ++++++++++++++++++++++++++++++++++++
 include/linux/ata.h       |    9 ++++++
 include/linux/libata.h    |    2 +
 4 files changed, 67 insertions(+), 2 deletions(-)

diff -puN drivers/ata/ahci.c~libata-check-for-an-support drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~libata-check-for-an-support
+++ a/drivers/ata/ahci.c
@@ -348,14 +348,15 @@ static const struct ata_port_operations 
 static const struct ata_port_info ahci_port_info[] = {
 	/* board_ahci */
 	{
-		.flags		= AHCI_FLAG_COMMON,
+		.flags		= AHCI_FLAG_COMMON | ATA_FLAG_AN,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
 	/* board_ahci_pi */
 	{
-		.flags		= AHCI_FLAG_COMMON | AHCI_FLAG_HONOR_PI,
+		.flags		= AHCI_FLAG_COMMON | AHCI_FLAG_HONOR_PI |
+				  ATA_FLAG_AN,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
diff -puN drivers/ata/libata-core.c~libata-check-for-an-support drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-check-for-an-support
+++ a/drivers/ata/libata-core.c
@@ -70,6 +70,7 @@ const unsigned long sata_deb_timing_long
 static unsigned int ata_dev_init_params(struct ata_device *dev,
 					u16 heads, u16 sectors);
 static unsigned int ata_dev_set_xfermode(struct ata_device *dev);
+static unsigned int ata_dev_set_AN(struct ata_device *dev, u8 enable);
 static void ata_dev_xfermask(struct ata_device *dev);
 static unsigned long ata_dev_blacklisted(const struct ata_device *dev);
 
@@ -1974,6 +1975,22 @@ int ata_dev_configure(struct ata_device 
 		}
 		dev->cdb_len = (unsigned int) rc;
 
+		/*
+		 * check to see if this ATAPI device supports
+		 * Asynchronous Notification
+		 */
+		if ((ap->flags & ATA_FLAG_AN) && ata_id_has_AN(id)) {
+			int err;
+			/* issue SET feature command to turn this on */
+			err = ata_dev_set_AN(dev, SETFEATURES_SATA_ENABLE);
+			if (err)
+				ata_dev_printk(dev, KERN_ERR,
+						"unable to set AN, err %x\n",
+						err);
+			else
+				dev->flags |= ATA_DFLAG_AN;
+		}
+
 		if (ata_id_cdb_intr(dev->id)) {
 			dev->flags |= ATA_DFLAG_CDB_INTR;
 			cdb_intr_string = ", CDB intr";
@@ -4002,6 +4019,42 @@ static unsigned int ata_dev_set_xfermode
 }
 
 /**
+ *	ata_dev_set_AN - Issue SET FEATURES - SATA FEATURES
+ *	@dev: Device to which command will be sent
+ *	@enable: Whether to enable or disable the feature
+ *
+ *	Issue SET FEATURES - SATA FEATURES command to device @dev
+ *	on port @ap with sector count set to indicate Asynchronous
+ *	Notification feature
+ *
+ *	LOCKING:
+ *	PCI/etc. bus probe sem.
+ *
+ *	RETURNS:
+ *	0 on success, AC_ERR_* mask otherwise.
+ */
+static unsigned int ata_dev_set_AN(struct ata_device *dev, u8 enable)
+{
+	struct ata_taskfile tf;
+	unsigned int err_mask;
+
+	/* set up set-features taskfile */
+	DPRINTK("set features - SATA features\n");
+
+	ata_tf_init(dev, &tf);
+	tf.command = ATA_CMD_SET_FEATURES;
+	tf.feature = enable;
+	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
+	tf.protocol = ATA_PROT_NODATA;
+	tf.nsect = SATA_AN;
+
+	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0);
+
+	DPRINTK("EXIT, err_mask=%x\n", err_mask);
+	return err_mask;
+}
+
+/**
  *	ata_dev_init_params - Issue INIT DEV PARAMS command
  *	@dev: Device to which command will be sent
  *	@heads: Number of heads (taskfile parameter)
diff -puN include/linux/ata.h~libata-check-for-an-support include/linux/ata.h
--- a/include/linux/ata.h~libata-check-for-an-support
+++ a/include/linux/ata.h
@@ -217,6 +217,12 @@ enum {
 
 	SETFEATURES_SPINUP	= 0x07, /* Spin-up drive */
 
+	SETFEATURES_SATA_ENABLE = 0x10, /* Enable use of SATA feature */
+	SETFEATURES_SATA_DISABLE = 0x90, /* Disable use of SATA feature */
+
+	/* SETFEATURE Sector counts for SATA features */
+	SATA_AN			= 0x05,  /* Asynchronous Notification */
+
 	/* ATAPI stuff */
 	ATAPI_PKT_DMA		= (1 << 0),
 	ATAPI_DMADIR		= (1 << 2),	/* ATAPI data dir:
@@ -353,6 +359,9 @@ struct ata_taskfile {
 #define ata_id_queue_depth(id)	(((id)[75] & 0x1f) + 1)
 #define ata_id_removeable(id)	((id)[0] & (1 << 7))
 #define ata_id_has_dword_io(id)	((id)[50] & (1 << 0))
+#define ata_id_has_AN(id)	\
+	( (((id)[76] != 0x0000) && ((id)[76] != 0xffff)) && \
+	  ((id)[78] & (1 << 5)) )
 #define ata_id_iordy_disable(id) ((id)[49] & (1 << 10))
 #define ata_id_has_iordy(id) ((id)[49] & (1 << 11))
 #define ata_id_u32(id,n)	\
diff -puN include/linux/libata.h~libata-check-for-an-support include/linux/libata.h
--- a/include/linux/libata.h~libata-check-for-an-support
+++ a/include/linux/libata.h
@@ -140,6 +140,7 @@ enum {
 	ATA_DFLAG_ACPI_PENDING	= (1 << 5), /* ACPI resume action pending */
 	ATA_DFLAG_ACPI_FAILED	= (1 << 6), /* ACPI on devcfg has failed */
 	ATA_DFLAG_IPM		= (1 << 7), /* device supports IPM */
+	ATA_DFLAG_AN		= (1 << 8), /* device supports AN */
 	ATA_DFLAG_CFG_MASK	= (1 << 12) - 1,
 
 	ATA_DFLAG_PIO		= (1 << 8), /* device limited to PIO mode */
@@ -178,6 +179,7 @@ enum {
 	ATA_FLAG_IGN_SIMPLEX	= (1 << 15), /* ignore SIMPLEX */
 	ATA_FLAG_NO_IORDY	= (1 << 16), /* controller lacks iordy */
 	ATA_FLAG_ACPI_SATA	= (1 << 17), /* need native SATA ACPI layout */
+	ATA_FLAG_AN		= (1 << 18), /* controller supports AN */
 
 	/* The following flag belongs to ap->pflags but is kept in
 	 * ap->flags because it's referenced in many LLDs and will be
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

git-libata-all.patch
alpm-store-interrupt-value.patch
alpm-enable-link-power-management-for-ata-drivers.patch
alpm-enable-aggressive-link-power-management-for-ahci-controllers.patch
libata-check-for-an-support.patch
scsi-expose-an-support-to-user-space.patch
libata-expose-an-to-user-space.patch
libata-send-event-when-an-received.patch
acpiphp_ibm-add-missing-n.patch
cpqphp_ctrlc-remove-dead-code.patch
acpi-bay-send-envp-with-uevent-fix.patch
acpi-dock-send-key=value-pair-instead-of-plain-value.patch
