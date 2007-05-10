From: akpm@linux-foundation.org
Subject: + libata-check-for-an-support.patch added to -mm tree
Date: Wed, 09 May 2007 22:12:21 -0700
Message-ID: <200705100512.l4A5CL2i012727@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755157AbXEJFM3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 01:12:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristen.c.accardi@intel.com


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

This patch series implements Asynchronous Notification (AN) for SATA ATAPI
devices as defined in SATA 2.5 and AHCI 1.1 and higher.  Drives which support
this feature will send a notification when new media is inserted and removed,
preventing the need for user space to poll for new media.  This support is
exposed to user space via a flag that will be set in
/sys/block/sr*/capability_flags.  If the flag is set, user space can disable
polling for the new media, and the genhd driver will send a KOBJ_CHANGE event
with the envp set to MEDIA_CHANGE_EVENT=1.

Note that this patch only implements support for directly attached drives - AN
with drives attached to a port multiplier requires additional changes.


This patch:

Check to see if an ATAPI device supports Asynchronous Notification.  If so,
enable it.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
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
@@ -329,14 +329,15 @@ static const struct ata_port_operations 
 static const struct ata_port_info ahci_port_info[] = {
 	/* board_ahci */
 	{
-		.flags		= AHCI_FLAG_COMMON,
+		.flags		= AHCI_FLAG_COMMON | ATA_FLAG_AN,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
 		.port_ops	= &ahci_ops,
 	},
 	/* board_ahci_pi */
 	{
-		.flags		= AHCI_FLAG_COMMON | AHCI_FLAG_HONOR_PI,
+		.flags		= AHCI_FLAG_COMMON | AHCI_FLAG_HONOR_PI |
+				  ATA_FLAG_AN,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
 		.port_ops	= &ahci_ops,
diff -puN drivers/ata/libata-core.c~libata-check-for-an-support drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-check-for-an-support
+++ a/drivers/ata/libata-core.c
@@ -71,6 +71,7 @@ const unsigned long sata_deb_timing_long
 static unsigned int ata_dev_init_params(struct ata_device *dev,
 					u16 heads, u16 sectors);
 static unsigned int ata_dev_set_xfermode(struct ata_device *dev);
+static unsigned int ata_dev_set_AN(struct ata_device *dev);
 static void ata_dev_xfermask(struct ata_device *dev);
 
 unsigned int ata_print_id = 1;
@@ -1956,6 +1957,22 @@ int ata_dev_configure(struct ata_device 
 		}
 		dev->cdb_len = (unsigned int) rc;
 
+		/*
+		 * check to see if this ATAPI device supports
+		 * Asynchronous Notification
+		 */
+		if ((ap->flags & ATA_FLAG_AN) && ata_id_has_AN(id)) {
+			int err;
+			/* issue SET feature command to turn this on */
+			err = ata_dev_set_AN(dev);
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
@@ -3883,6 +3900,42 @@ static unsigned int ata_dev_set_xfermode
 }
 
 /**
+ *	ata_dev_set_AN - Issue SET FEATURES - SATA FEATURES
+ *                       with sector count set to indicate
+ *                       Asynchronous Notification feature
+ *	@dev: Device to which command will be sent
+ *
+ *	Issue SET FEATURES - SATA FEATURES command to device @dev
+ *	on port @ap.
+ *
+ *	LOCKING:
+ *	PCI/etc. bus probe sem.
+ *
+ *	RETURNS:
+ *	0 on success, AC_ERR_* mask otherwise.
+ */
+static unsigned int ata_dev_set_AN(struct ata_device *dev)
+{
+	struct ata_taskfile tf;
+	unsigned int err_mask;
+
+	/* set up set-features taskfile */
+	DPRINTK("set features - SATA features\n");
+
+	ata_tf_init(dev, &tf);
+	tf.command = ATA_CMD_SET_FEATURES;
+	tf.feature = SETFEATURES_SATA_ENABLE;
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
@@ -204,6 +204,12 @@ enum {
 
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
@@ -318,6 +324,9 @@ struct ata_taskfile {
 #define ata_id_queue_depth(id)	(((id)[75] & 0x1f) + 1)
 #define ata_id_removeable(id)	((id)[0] & (1 << 7))
 #define ata_id_has_dword_io(id)	((id)[50] & (1 << 0))
+#define ata_id_has_AN(id)	\
+	( (((id)[76] != 0x0000) && ((id)[76] != 0xffff)) && \
+	  ((id)[78] & (1 << 5)) )
 #define ata_id_iordy_disable(id) ((id)[49] & (1 << 10))
 #define ata_id_has_iordy(id) ((id)[49] & (1 << 9))
 #define ata_id_u32(id,n)	\
diff -puN include/linux/libata.h~libata-check-for-an-support include/linux/libata.h
--- a/include/linux/libata.h~libata-check-for-an-support
+++ a/include/linux/libata.h
@@ -136,6 +136,7 @@ enum {
 	ATA_DFLAG_CDB_INTR	= (1 << 2), /* device asserts INTRQ when ready for CDB */
 	ATA_DFLAG_NCQ		= (1 << 3), /* device supports NCQ */
 	ATA_DFLAG_FLUSH_EXT	= (1 << 4), /* do FLUSH_EXT instead of FLUSH */
+	ATA_DFLAG_AN		= (1 << 5), /* device supports Async notification */
 	ATA_DFLAG_CFG_MASK	= (1 << 8) - 1,
 
 	ATA_DFLAG_PIO		= (1 << 8), /* device limited to PIO mode */
@@ -174,6 +175,7 @@ enum {
 	ATA_FLAG_SETXFER_POLLING= (1 << 14), /* use polling for SETXFER */
 	ATA_FLAG_IGN_SIMPLEX	= (1 << 15), /* ignore SIMPLEX */
 	ATA_FLAG_NO_IORDY	= (1 << 16), /* controller lacks iordy */
+	ATA_FLAG_AN		= (1 << 17), /* controller supports AN */
 
 	/* The following flag belongs to ap->pflags but is kept in
 	 * ap->flags because it's referenced in many LLDs and will be
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

origin.patch
acpi-dock-cleanup-the-uid-patch.patch
acpi-dock-fix-opps-after-dock-driver-fails-to-initialize.patch
acpi-dock-use-dynamically-allocated-platform-device.patch
acpi-dock-add-immediate_undock-option.patch
acpi-dock-unsuppress-uevents.patch
acpi-dock-send-envp-with-uevent.patch
acpi-bay-unsuppress-uevents.patch
libata-check-for-an-support.patch
genhd-expose-an-to-user-space.patch
scsi-expose-an-to-user-space.patch
libata-expose-an-to-user-space.patch
genhd-send-async-notification-on-media-change.patch
scsi-save-disk-in-scsi_device.patch
libata-send-event-when-an-received.patch
cpci_hotplug-convert-to-use-the-kthread-api.patch
