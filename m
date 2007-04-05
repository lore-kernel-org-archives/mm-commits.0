From: akpm@linux-foundation.org
Subject: - pata_amd-remove-all-the-crud-and-restore-the-cable-detect.patch removed from -mm tree
Date: Wed, 04 Apr 2007 18:51:41 -0700
Message-ID: <200704050151.l351pfer004640@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37756 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbXDEBvv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 4 Apr 2007 21:51:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pata_amd: remove all the crud and restore the cable detect method again
has been removed from the -mm tree.  Its filename was
     pata_amd-remove-all-the-crud-and-restore-the-cable-detect.patch

This patch was dropped because jeff changes broke it

------------------------------------------------------
Subject: pata_amd: remove all the crud and restore the cable detect method again
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_amd.c |   95 +++++++++++++++++++--------------------
 1 file changed, 48 insertions(+), 47 deletions(-)

diff -puN drivers/ata/pata_amd.c~pata_amd-remove-all-the-crud-and-restore-the-cable-detect drivers/ata/pata_amd.c
--- a/drivers/ata/pata_amd.c~pata_amd-remove-all-the-crud-and-restore-the-cable-detect
+++ a/drivers/ata/pata_amd.c
@@ -25,7 +25,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_amd"
-#define DRV_VERSION "0.2.8"
+#define DRV_VERSION "0.3.8"
 
 /**
  *	timing_setup		-	shared timing computation and load
@@ -119,32 +119,25 @@ static void timing_setup(struct ata_port
 }
 
 /**
- *	amd_probe_init		-	cable detection
+ *	amd_probe_init		-	perform reset handling
  *	@ap: ATA port
  *
- *	Perform cable detection. The BIOS stores this in PCI config
- *	space for us.
+ *	Reset sequence checking enable bits to see which ports are
+ *	active.
  */
 
 static int amd_pre_reset(struct ata_port *ap)
 {
-	static const u32 bitmask[2] = {0x03, 0x0C};
 	static const struct pci_bits amd_enable_bits[] = {
 		{ 0x40, 1, 0x02, 0x02 },
 		{ 0x40, 1, 0x01, 0x01 }
 	};
 
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u8 ata66;
 
 	if (!pci_test_config_bits(pdev, &amd_enable_bits[ap->port_no]))
 		return -ENOENT;
 
-	pci_read_config_byte(pdev, 0x42, &ata66);
-	if (ata66 & bitmask[ap->port_no])
-		ap->cbl = ATA_CBL_PATA80;
-	else
-		ap->cbl = ATA_CBL_PATA40;
 	return ata_std_prereset(ap);
 
 }
@@ -156,28 +149,16 @@ static void amd_error_handler(struct ata
 				      ata_std_postreset);
 }
 
-static int amd_early_pre_reset(struct ata_port *ap)
+static int amd_cable_detect(struct ata_port *ap)
 {
+	static const u32 bitmask[2] = {0x03, 0x0C};
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	static struct pci_bits amd_enable_bits[] = {
-		{ 0x40, 1, 0x02, 0x02 },
-		{ 0x40, 1, 0x01, 0x01 }
-	};
-
-	if (!pci_test_config_bits(pdev, &amd_enable_bits[ap->port_no]))
-		return -ENOENT;
-
-	/* No host side cable detection */
-	ap->cbl = ATA_CBL_PATA80;
-	return ata_std_prereset(ap);
-
-}
+	u8 ata66;
 
-static void amd_early_error_handler(struct ata_port *ap)
-{
-	ata_bmdma_drive_eh(ap, amd_early_pre_reset,
-			       ata_std_softreset, NULL,
-			       ata_std_postreset);
+	pci_read_config_byte(pdev, 0x42, &ata66);
+	if (ata66 & bitmask[ap->port_no])
+		return ATA_CBL_PATA80;
+	return ATA_CBL_PATA40;
 }
 
 /**
@@ -241,37 +222,23 @@ static void amd133_set_dmamode(struct at
 /**
  *	nv_probe_init	-	cable detection
  *	@ap: ATA port
+ *	@deadline: deadline jiffies for the operation
  *
  *	Perform cable detection. The BIOS stores this in PCI config
  *	space for us.
  */
 
 static int nv_pre_reset(struct ata_port *ap) {
-	static const u8 bitmask[2] = {0x03, 0x0C};
 	static const struct pci_bits nv_enable_bits[] = {
 		{ 0x50, 1, 0x02, 0x02 },
 		{ 0x50, 1, 0x01, 0x01 }
 	};
 
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u8 ata66;
-	u16 udma;
 
 	if (!pci_test_config_bits(pdev, &nv_enable_bits[ap->port_no]))
 		return -ENOENT;
 
-	pci_read_config_byte(pdev, 0x52, &ata66);
-	if (ata66 & bitmask[ap->port_no])
-		ap->cbl = ATA_CBL_PATA80;
-	else
-		ap->cbl = ATA_CBL_PATA40;
-
-	/* We now have to double check because the Nvidia boxes BIOS
-	   doesn't always set the cable bits but does set mode bits */
-
-	pci_read_config_word(pdev, 0x62 - 2 * ap->port_no, &udma);
-	if ((udma & 0xC4) == 0xC4 || (udma & 0xC400) == 0xC400)
-		ap->cbl = ATA_CBL_PATA80;
 	return ata_std_prereset(ap);
 }
 
@@ -281,6 +248,29 @@ static void nv_error_handler(struct ata_
 			       ata_std_softreset, NULL,
 			       ata_std_postreset);
 }
+
+static int nv_cable_detect(struct ata_port *ap)
+{
+	static const u8 bitmask[2] = {0x03, 0x0C};
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u8 ata66;
+	u16 udma;
+	int cbl;
+
+	pci_read_config_byte(pdev, 0x52, &ata66);
+	if (ata66 & bitmask[ap->port_no])
+		cbl = ATA_CBL_PATA80;
+	else
+		cbl = ATA_CBL_PATA40;
+
+ 	/* We now have to double check because the Nvidia boxes BIOS
+ 	   doesn't always set the cable bits but does set mode bits */
+ 	pci_read_config_word(pdev, 0x62 - 2 * ap->port_no, &udma);
+ 	if ((udma & 0xC4) == 0xC4 || (udma & 0xC400) == 0xC400)
+		cbl = ATA_CBL_PATA80;
+	return cbl;
+}
+
 /**
  *	nv100_set_piomode	-	set initial PIO mode data
  *	@ap: ATA interface
@@ -353,8 +343,9 @@ static struct ata_port_operations amd33_
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= amd_early_error_handler,
+	.error_handler	= amd_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -387,8 +378,9 @@ static struct ata_port_operations amd66_
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= amd_early_error_handler,
+	.error_handler	= amd_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_unknown,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -423,6 +415,7 @@ static struct ata_port_operations amd100
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= amd_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_unknown,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -457,6 +450,7 @@ static struct ata_port_operations amd133
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= amd_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= amd_cable_detect,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -491,6 +485,7 @@ static struct ata_port_operations nv100_
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= nv_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= nv_cable_detect,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -525,6 +520,7 @@ static struct ata_port_operations nv133_
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= nv_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= nv_cable_detect,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -644,6 +640,11 @@ static int amd_init_one(struct pci_dev *
 	if (type == 1 && rev > 0x7)
 		type = 2;
 
+#if defined(CONFIG_ATA_ACPI)
+	/* Prefer the ACPI driver for Nvidia hardware */
+	if (pdev->vendor == PCI_VENDOR_ID_NVIDIA && ata_pata_acpi_present(pdev))
+		return -ENODEV;
+#endif
 	/* Check for AMD7411 */
 	if (type == 3)
 		/* FIFO is broken */
_

Patches currently in -mm which might be from alan@redhat.com are

origin.patch
git-libata-all.patch
ata_generic-remove-all-the-crud-again-and-use-cable.patch
pata_amd-remove-all-the-crud-and-restore-the-cable-detect.patch
pata_cypress-re-remove-all-the-crap-and-switch-back-to.patch
pata_netcell-re-remove-all-the-crud.patch
pata_qdi-restore-cable-detect.patch
pata_sl82c105-restore-cable-detect-method.patch
pata_winbond-restore-cable-method.patch
libata-acpi-add-infrastructure-for-drivers-to-use.patch
libata-acpi-add-infrastructure-for-drivers-to-use-fix.patch
pata_optidma-rework-for-cable-detect-and-to-remove.patch
pata_acpi-restore-driver.patch
pata_acpi-restore-driver-fix.patch
libata-misc-minor-merge-fixups.patch
pata_hpt37x-further-small-fixes.patch
pata_hpt3x2n-add-hpt371n-support-and-other-bits.patch
pata_pdc2027x-bring-into-line-with-changes-add-the-mode.patch
pci_module_init-convertion-in-tmscsimc.patch
tty-clarify-documentation-of-write.patch
tty-i386-x86_64-arbitary-speed-support.patch
revoke-special-mmap-handling.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
