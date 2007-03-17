From: akpm@linux-foundation.org
Subject: - pata_pdc2027x-restore-various-updates-done-on-the-driver.patch removed from -mm tree
Date: Fri, 16 Mar 2007 17:47:53 -0700
Message-ID: <200703170049.l2H0nkGL025720@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45148 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992472AbXCQAtz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Mar 2007 20:49:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pata_pdc2027x: restore various updates done on the driver
has been removed from the -mm tree.  Its filename was
     pata_pdc2027x-restore-various-updates-done-on-the-driver.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: pata_pdc2027x: restore various updates done on the driver
From: Alan Cox <alan@redhat.com>

- Use of cable_detect method
- ata_pci_default_filter needed on PATA100 ops
- Filter for UDMA 133 errata from vendor (not enabled in this diff but
added ready)

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_pdc2027x.c |   46 ++++++++++++++++++++++++++--------
 1 file changed, 36 insertions(+), 10 deletions(-)

diff -puN drivers/ata/pata_pdc2027x.c~pata_pdc2027x-restore-various-updates-done-on-the-driver drivers/ata/pata_pdc2027x.c
--- a/drivers/ata/pata_pdc2027x.c~pata_pdc2027x-restore-various-updates-done-on-the-driver
+++ a/drivers/ata/pata_pdc2027x.c
@@ -35,7 +35,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_pdc2027x"
-#define DRV_VERSION	"0.8"
+#define DRV_VERSION	"0.8ac1"
 #undef PDC_DEBUG
 
 #ifdef PDC_DEBUG
@@ -66,8 +66,10 @@ static int pdc2027x_init_one(struct pci_
 static void pdc2027x_error_handler(struct ata_port *ap);
 static void pdc2027x_set_piomode(struct ata_port *ap, struct ata_device *adev);
 static void pdc2027x_set_dmamode(struct ata_port *ap, struct ata_device *adev);
-static void pdc2027x_post_set_mode(struct ata_port *ap);
 static int pdc2027x_check_atapi_dma(struct ata_queued_cmd *qc);
+static unsigned long pdc2027x_mode_filter(struct ata_device *adev, unsigned long mask);
+static int pdc2027x_cable_detect(struct ata_port *ap);
+static int pdc2027x_set_mode(struct ata_port *ap, struct ata_device **r_failed);
 
 /*
  * ATA Timing Tables based on 133MHz controller clock.
@@ -146,6 +148,7 @@ static struct scsi_host_template pdc2027
 
 static struct ata_port_operations pdc2027x_pata100_ops = {
 	.port_disable		= ata_port_disable,
+	.mode_filter		= ata_pci_default_filter,
 
 	.tf_load		= ata_tf_load,
 	.tf_read		= ata_tf_read,
@@ -166,6 +169,7 @@ static struct ata_port_operations pdc202
 	.thaw			= ata_bmdma_thaw,
 	.error_handler		= pdc2027x_error_handler,
 	.post_internal_cmd 	= ata_bmdma_post_internal_cmd,
+	.cable_detect		= pdc2027x_cable_detect,
 
 	.irq_handler		= ata_interrupt,
 	.irq_clear		= ata_bmdma_irq_clear,
@@ -261,7 +265,7 @@ static inline void __iomem *dev_mmio(str
 }
 
 /**
- *	pdc2027x_pata_cbl_detect - Probe host controller cable detect info
+ *	pdc2027x_pata_cable_detect - Probe host controller cable detect info
  *	@ap: Port for which cable detect info is desired
  *
  *	Read 80c cable indicator from Promise extended register.
@@ -270,7 +274,7 @@ static inline void __iomem *dev_mmio(str
  *	LOCKING:
  *	None (inherited from caller).
  */
-static void pdc2027x_cbl_detect(struct ata_port *ap)
+static int pdc2027x_cable_detect(struct ata_port *ap)
 {
 	u32 cgcr;
 
@@ -281,13 +285,10 @@ static void pdc2027x_cbl_detect(struct a
 
 	PDPRINTK("No cable or 80-conductor cable on port %d\n", ap->port_no);
 
-	ap->cbl = ATA_CBL_PATA80;
-	return;
-
+	return ATA_CBL_PATA80;
 cbl40:
 	printk(KERN_INFO DRV_NAME ": 40-conductor cable detected on port %d\n", ap->port_no);
-	ap->cbl = ATA_CBL_PATA40;
-	ap->udma_mask &= ATA_UDMA_MASK_40C;
+	return ATA_CBL_PATA40;
 }
 
 /**
@@ -315,7 +316,6 @@ static int pdc2027x_prereset(struct ata_
 	/* Check whether port enabled */
 	if (!pdc2027x_port_enabled(ap))
 		return -ENOENT;
-	pdc2027x_cbl_detect(ap);
 	return ata_std_prereset(ap, deadline);
 }
 
@@ -335,6 +335,32 @@ static void pdc2027x_error_handler(struc
 }
 
 /**
+ *	pdc2720x_mode_filter	-	mode selection filter
+ *	@adev: ATA device
+ *	@mask: list of modes proposed
+ *
+ *	Block UDMA on devices that cause trouble with this controller.
+ */
+
+static unsigned long pdc2027x_mode_filter(struct ata_device *adev, unsigned long mask)
+{
+	unsigned char model_num[ATA_ID_PROD_LEN + 1];
+	struct ata_device *pair = ata_dev_pair(adev);
+
+	if (adev->class != ATA_DEV_ATA || adev->devno == 0 || pair == NULL)
+		return ata_pci_default_filter(adev, mask);
+
+	/* Check for slave of a Maxtor at UDMA6 */
+	ata_id_c_string(pair->id, model_num, ATA_ID_PROD,
+			  ATA_ID_PROD_LEN + 1);
+	/* If the master is a maxtor in UDMA6 then the slave should not use UDMA 6 */
+	if(strstr(model_num, "Maxtor") == 0 && pair->dma_mode == XFER_UDMA_6)
+		mask &= ~ (1 << (6 + ATA_SHIFT_UDMA));
+
+	return ata_pci_default_filter(adev, mask);
+}
+
+/**
  *	pdc2027x_set_piomode - Initialize host controller PATA PIO timings
  *	@ap: Port to configure
  *	@adev: um
_

Patches currently in -mm which might be from alan@redhat.com are

git-libata-all.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
ata_generic-remove-all-the-crud-again-and-use-cable.patch
pata_ali-remove-all-the-crap-again-and-switch-to.patch
pata_amd-remove-all-the-crud-and-restore-the-cable-detect.patch
pata_cs5535-re-remove-all-the-crap-and-switch-to-the-cable.patch
pata_cypress-re-remove-all-the-crap-and-switch-back-to.patch
pata_netcell-re-remove-all-the-crud.patch
pata_qdi-restore-cable-detect.patch
pata_sl82c105-restore-cable-detect-method.patch
pata_winbond-restore-cable-method.patch
libata-acpi-add-infrastructure-for-drivers-to-use.patch
pata_optidma-rework-for-cable-detect-and-to-remove.patch
pata_pdc2027x-restore-various-updates-done-on-the-driver.patch
pata_acpi-restore-driver.patch
resend-iphase-64bit-cleanup.patch
pci_module_init-convertion-in-tmscsimc.patch
tty-clarify-documentation-of-write.patch
tty-i386-x86_64-arbitary-speed-support.patch
revoke-special-mmap-handling.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
