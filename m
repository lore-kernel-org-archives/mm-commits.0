From: akpm@linux-foundation.org
Subject: - pata_via-restore-cable-detect.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:58:11 -0800
Message-ID: <200703152158.l2FLwBfh027709@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42458 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbXCOV6Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:58:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pata_via: restore cable detect
has been removed from the -mm tree.  Its filename was
     pata_via-restore-cable-detect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_via: restore cable detect
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_via.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff -puN drivers/ata/pata_via.c~pata_via-restore-cable-detect drivers/ata/pata_via.c
--- a/drivers/ata/pata_via.c~pata_via-restore-cable-detect
+++ a/drivers/ata/pata_via.c
@@ -62,7 +62,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_via"
-#define DRV_VERSION "0.2.1"
+#define DRV_VERSION "0.3.1"
 
 /*
  *	The following comes directly from Vojtech Pavlik's ide/pci/via82cxxx
@@ -135,16 +135,23 @@ static const struct via_isa_bridge {
  */
 
 static int via_cable_detect(struct ata_port *ap) {
+	const struct via_isa_bridge *config = ap->host->private_data;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u32 ata66;
 
+	/* Early chips are 40 wire */
+	if ((config->flags & VIA_UDMA) < VIA_UDMA_66)
+		return ATA_CBL_PATA40;
+	/* UDMA 66 chips have only drive side logic */
+	else if((config->flags & VIA_UDMA) < VIA_UDMA_100)
+		return ATA_CBL_PATA_UNK;
+	/* UDMA 100 or later */
 	pci_read_config_dword(pdev, 0x50, &ata66);
 	/* Check both the drive cable reporting bits, we might not have
 	   two drives */
 	if (ata66 & (0x10100000 >> (16 * ap->port_no)))
 		return ATA_CBL_PATA80;
-	else
-		return ATA_CBL_PATA40;
+	return ATA_CBL_PATA40;
 }
 
 static int via_pre_reset(struct ata_port *ap, unsigned long deadline)
@@ -156,22 +163,10 @@ static int via_pre_reset(struct ata_port
 			{ 0x40, 1, 0x02, 0x02 },
 			{ 0x40, 1, 0x01, 0x01 }
 		};
-
 		struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-
 		if (!pci_test_config_bits(pdev, &via_enable_bits[ap->port_no]))
 			return -ENOENT;
 	}
-
-	if ((config->flags & VIA_UDMA) >= VIA_UDMA_100)
-		ap->cbl = via_cable_detect(ap);
-	/* The UDMA66 series has no cable detect so do drive side detect */
-	else if ((config->flags & VIA_UDMA) < VIA_UDMA_66)
-		ap->cbl = ATA_CBL_PATA40;
-	else
-		ap->cbl = ATA_CBL_PATA_UNK;
-
-
 	return ata_std_prereset(ap, deadline);
 }
 
@@ -327,6 +322,7 @@ static struct ata_port_operations via_po
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= via_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= via_cable_detect,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -362,6 +358,7 @@ static struct ata_port_operations via_po
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= via_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= via_cable_detect,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
_

Patches currently in -mm which might be from alan@redhat.com are

origin.patch
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
