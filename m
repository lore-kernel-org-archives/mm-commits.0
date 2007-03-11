From: akpm@linux-foundation.org
Subject: + pata_amd-remove-all-the-crud-and-restore-the-cable-detect.patch added to -mm tree
Date: Sun, 11 Mar 2007 01:28:16 -0800
Message-ID: <200703110928.l2B9SG0c008736@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41150 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbXCKJ20 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 05:28:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     pata_amd: remove all the crud and restore the cable detect method again
has been added to the -mm tree.  Its filename is
     pata_amd-remove-all-the-crud-and-restore-the-cable-detect.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_amd: remove all the crud and restore the cable detect method again
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_amd.c |   98 +++++++++++++++++++--------------------
 1 file changed, 48 insertions(+), 50 deletions(-)

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
@@ -119,33 +119,25 @@ static void timing_setup(struct ata_port
 }
 
 /**
- *	amd_probe_init		-	cable detection
+ *	amd_probe_init		-	perform reset handling
  *	@ap: ATA port
  *	@deadline: deadline jiffies for the operation
  *
- *	Perform cable detection. The BIOS stores this in PCI config
- *	space for us.
+ *	Reset sequence checking enable bits to see which ports are
+ *	active.
  */
 
 static int amd_pre_reset(struct ata_port *ap, unsigned long deadline)
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
-
-	pci_read_config_byte(pdev, 0x42, &ata66);
-	if (ata66 & bitmask[ap->port_no])
-		ap->cbl = ATA_CBL_PATA80;
-	else
-		ap->cbl = ATA_CBL_PATA40;
 	return ata_std_prereset(ap, deadline);
 
 }
@@ -157,27 +149,15 @@ static void amd_error_handler(struct ata
 				      ata_std_postreset);
 }
 
-static int amd_early_pre_reset(struct ata_port *ap, unsigned long deadline)
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
-	return ata_std_prereset(ap, deadline);
-}
-
-static void amd_early_error_handler(struct ata_port *ap)
-{
-	ata_bmdma_drive_eh(ap, amd_early_pre_reset,
-			       ata_std_softreset, NULL,
-			       ata_std_postreset);
+	u8 ata66;
+	pci_read_config_byte(pdev, 0x42, &ata66);
+	if (ata66 & bitmask[ap->port_no])
+		return ATA_CBL_PATA80;
+	return ATA_CBL_PATA40;
 }
 
 /**
@@ -241,6 +221,7 @@ static void amd133_set_dmamode(struct at
 /**
  *	nv_probe_init	-	cable detection
  *	@ap: ATA port
+ *	@deadline: deadline jiffies for the operation
  *
  *	Perform cable detection. The BIOS stores this in PCI config
  *	space for us.
@@ -248,31 +229,14 @@ static void amd133_set_dmamode(struct at
 
 static int nv_pre_reset(struct ata_port *ap, unsigned long deadline)
 {
-	static const u8 bitmask[2] = {0x03, 0x0C};
 	static const struct pci_bits nv_enable_bits[] = {
 		{ 0x50, 1, 0x02, 0x02 },
 		{ 0x50, 1, 0x01, 0x01 }
 	};
 
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u8 ata66;
-	u16 udma;
-
 	if (!pci_test_config_bits(pdev, &nv_enable_bits[ap->port_no]))
 		return -ENOENT;
-
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
 	return ata_std_prereset(ap, deadline);
 }
 
@@ -282,6 +246,29 @@ static void nv_error_handler(struct ata_
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
@@ -354,8 +341,9 @@ static struct ata_port_operations amd33_
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= amd_early_error_handler,
+	.error_handler	= amd_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -388,8 +376,9 @@ static struct ata_port_operations amd66_
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= amd_early_error_handler,
+	.error_handler	= amd_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_unknown,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -424,6 +413,7 @@ static struct ata_port_operations amd100
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= amd_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_unknown,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -458,6 +448,7 @@ static struct ata_port_operations amd133
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= amd_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= amd_cable_detect,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -492,6 +483,7 @@ static struct ata_port_operations nv100_
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= nv_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= nv_cable_detect,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -526,6 +518,7 @@ static struct ata_port_operations nv133_
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= nv_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= nv_cable_detect,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -645,6 +638,11 @@ static int amd_init_one(struct pci_dev *
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

git-libata-all.patch
expose-set_mode-method-so-it-can-be-wrapped.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
ata_generic-remove-all-the-crud-again-and-use-cable.patch
pata_ali-remove-all-the-crap-again-and-switch-to.patch
pata_amd-remove-all-the-crud-and-restore-the-cable-detect.patch
pata_artop-remove-all-the-crud-again-and-restore-the-cable.patch
pata_atiixp-restore-the-cable-method.patch
pata_cmd64x-restore-cable-method.patch
pata_cs5520-re-remove-crap-and-switch-to-cable-detect.patch
pata_cs5530-re-remove-all-the-crap-and-switch-back-to-the.patch
pata_cs5535-re-remove-all-the-crap-and-switch-to-the-cable.patch
pata_cypress-re-remove-all-the-crap-and-switch-back-to.patch
pata_efar-switch-back-to-cable-methods.patch
pata_hpt366-switch-back-to-cable-method-again.patch
pata_hpt3x3-switch-back-to-cable-method-and-re-remove-all.patch
pata_isapnp-put-cable-type-back.patch
pata_it8213-switch-to-cable-method-again.patch
pata_it821x-switch-back-to-cable-detect-and-re-remove-all.patch
pata_ixp4xx_cf-restore-cable-type-method.patch
pata_legacy-restore-cable-methods.patch
pata_marvell-restore-cable-methods-and-reapply-lost-bug.patch
pata_mpc52xx-restore-cable-method.patch
pata_mpiix-restore-cable-type-method.patch
pata_netcell-re-remove-all-the-crud.patch
pata_ns87410-restore-cable-detect-method.patch
pata_oldpiix-restore-cable-method-re-correct-comments.patch
pata_opti-restore-cable-method.patch
pata_pcmcia-restore-cable-reporting.patch
pata_pdc202xx_old-re-remove-crap-restore-cable-methods.patch
pata_qdi-restore-cable-detect.patch
pata_serverworks-re-remove-crap-restore-cable-detect.patch
pata_sil680-restore-cable-detect-methods.patch
pata_sis-restore-cable-method-re-perform-crapectory.patch
pata_sl82c105-restore-cable-detect-method.patch
pata_via-restore-cable-detect.patch
pata_winbond-restore-cable-method.patch
sata_via-use-cable-detect-methods.patch
libata-acpi-try-and-stop-all-the-non-pci-devices-crashing.patch
libata-acpi-add-infrastructure-for-drivers-to-use.patch
pata_optidma-rework-for-cable-detect-and-to-remove.patch
pata_pdc2027x-restore-various-updates-done-on-the-driver.patch
pata_acpi-restore-driver.patch
ata_piix-remove-ugly-layering-violation.patch
pata_cmd640-multiple-updates.patch
dilnetpc-fix-warning.patch
resend-iphase-64bit-cleanup.patch
pci_module_init-convertion-in-tmscsimc.patch
z85230-fix-fifo-handling.patch
tty-clarify-documentation-of-write.patch
