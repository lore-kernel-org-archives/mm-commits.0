From: akpm@linux-foundation.org
Subject: + pata_sis-restore-cable-method-re-perform-crapectory.patch added to -mm tree
Date: Sun, 11 Mar 2007 01:30:27 -0800
Message-ID: <200703110930.l2B9URYB008856@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41269 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbXCKJah (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 05:30:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     pata_sis: restore cable method, re-perform crapectory, restore bug fixes
has been added to the -mm tree.  Its filename is
     pata_sis-restore-cable-method-re-perform-crapectory.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_sis: restore cable method, re-perform crapectory, restore bug fixes
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_sis.c |  111 ++++++++++-----------------------------
 1 file changed, 29 insertions(+), 82 deletions(-)

diff -puN drivers/ata/pata_sis.c~pata_sis-restore-cable-method-re-perform-crapectory drivers/ata/pata_sis.c
--- a/drivers/ata/pata_sis.c~pata_sis-restore-cable-method-re-perform-crapectory
+++ a/drivers/ata/pata_sis.c
@@ -35,7 +35,7 @@
 #include "sis.h"
 
 #define DRV_NAME	"pata_sis"
-#define DRV_VERSION	"0.5.0"
+#define DRV_VERSION	"0.5.1"
 
 struct sis_chipset {
 	u16 device;			/* PCI host ID */
@@ -86,109 +86,56 @@ static int sis_port_base(struct ata_devi
 }
 
 /**
- *	sis_133_pre_reset	-	check for 40/80 pin
+ *	sis_133_cable_detect	-	check for 40/80 pin
  *	@ap: Port
- *	@deadline: deadline jiffies for the operation
  *
  *	Perform cable detection for the later UDMA133 capable
  *	SiS chipset.
  */
 
-static int sis_133_pre_reset(struct ata_port *ap, unsigned long deadline)
+static int sis_133_cable_detect(struct ata_port *ap)
 {
-	static const struct pci_bits sis_enable_bits[] = {
-		{ 0x4aU, 1U, 0x02UL, 0x02UL },	/* port 0 */
-		{ 0x4aU, 1U, 0x04UL, 0x04UL },	/* port 1 */
-	};
-
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u16 tmp;
 
-	if (!pci_test_config_bits(pdev, &sis_enable_bits[ap->port_no]))
-		return -ENOENT;
-
 	/* The top bit of this register is the cable detect bit */
 	pci_read_config_word(pdev, 0x50 + 2 * ap->port_no, &tmp);
 	if ((tmp & 0x8000) && !sis_short_ata40(pdev))
-		ap->cbl = ATA_CBL_PATA40;
-	else
-		ap->cbl = ATA_CBL_PATA80;
-
-	return ata_std_prereset(ap, deadline);
+		return ATA_CBL_PATA40;
+	return ATA_CBL_PATA80;
 }
 
 /**
- *	sis_error_handler - Probe specified port on PATA host controller
- *	@ap: Port to probe
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void sis_133_error_handler(struct ata_port *ap)
-{
-	ata_bmdma_drive_eh(ap, sis_133_pre_reset, ata_std_softreset, NULL, ata_std_postreset);
-}
-
-
-/**
- *	sis_66_pre_reset	-	check for 40/80 pin
+ *	sis_66_cable_detect	-	check for 40/80 pin
  *	@ap: Port
- *	@deadline: deadline jiffies for the operation
  *
  *	Perform cable detection on the UDMA66, UDMA100 and early UDMA133
  *	SiS IDE controllers.
  */
 
-static int sis_66_pre_reset(struct ata_port *ap, unsigned long deadline)
+static int sis_66_cable_detect(struct ata_port *ap)
 {
-	static const struct pci_bits sis_enable_bits[] = {
-		{ 0x4aU, 1U, 0x02UL, 0x02UL },	/* port 0 */
-		{ 0x4aU, 1U, 0x04UL, 0x04UL },	/* port 1 */
-	};
-
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u8 tmp;
 
-	if (!pci_test_config_bits(pdev, &sis_enable_bits[ap->port_no])) {
-		ata_port_disable(ap);
-		ata_port_printk(ap, KERN_INFO, "port disabled. ignoring.\n");
-		return 0;
-	}
 	/* Older chips keep cable detect in bits 4/5 of reg 0x48 */
 	pci_read_config_byte(pdev, 0x48, &tmp);
 	tmp >>= ap->port_no;
 	if ((tmp & 0x10) && !sis_short_ata40(pdev))
-		ap->cbl = ATA_CBL_PATA40;
-	else
-		ap->cbl = ATA_CBL_PATA80;
-
-	return ata_std_prereset(ap, deadline);
+		return ATA_CBL_PATA40;
+	return ATA_CBL_PATA80;
 }
 
-/**
- *	sis_66_error_handler - Probe specified port on PATA host controller
- *	@ap: Port to probe
- *	@classes:
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void sis_66_error_handler(struct ata_port *ap)
-{
-	ata_bmdma_drive_eh(ap, sis_66_pre_reset, ata_std_softreset, NULL, ata_std_postreset);
-}
 
 /**
- *	sis_old_pre_reset		-	probe begin
+ *	sis_pre_reset		-	probe begin
  *	@ap: ATA port
  *	@deadline: deadline jiffies for the operation
  *
  *	Set up cable type and use generic probe init
  */
 
-static int sis_old_pre_reset(struct ata_port *ap, unsigned long deadline)
+static int sis_pre_reset(struct ata_port *ap, unsigned long deadline)
 {
 	static const struct pci_bits sis_enable_bits[] = {
 		{ 0x4aU, 1U, 0x02UL, 0x02UL },	/* port 0 */
@@ -197,27 +144,23 @@ static int sis_old_pre_reset(struct ata_
 
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 
-	if (!pci_test_config_bits(pdev, &sis_enable_bits[ap->port_no])) {
-		ata_port_disable(ap);
-		ata_port_printk(ap, KERN_INFO, "port disabled. ignoring.\n");
-		return 0;
-	}
-	ap->cbl = ATA_CBL_PATA40;
+	if (!pci_test_config_bits(pdev, &sis_enable_bits[ap->port_no]))
+		return -ENOENT;
 	return ata_std_prereset(ap, deadline);
 }
 
 
 /**
- *	sis_old_error_handler - Probe specified port on PATA host controller
+ *	sis_error_handler - Probe specified port on PATA host controller
  *	@ap: Port to probe
  *
  *	LOCKING:
  *	None (inherited from caller).
  */
 
-static void sis_old_error_handler(struct ata_port *ap)
+static void sis_error_handler(struct ata_port *ap)
 {
-	ata_bmdma_drive_eh(ap, sis_old_pre_reset, ata_std_softreset, NULL, ata_std_postreset);
+	ata_bmdma_drive_eh(ap, sis_pre_reset, ata_std_softreset, NULL, ata_std_postreset);
 }
 
 /**
@@ -497,7 +440,7 @@ static void sis_133_early_set_dmamode (s
 	int drive_pci = sis_port_base(adev);
 	u16 timing;
 
-	const u16 udma_bits[]  = { 0x8F00, 0x8A00, 0x8700, 0x8500, 0x8300, 0x8200, 0x8100};
+	static const u16 udma_bits[]  = { 0x8F00, 0x8A00, 0x8700, 0x8500, 0x8300, 0x8200, 0x8100};
 
 	pci_read_config_word(pdev, drive_pci, &timing);
 
@@ -534,8 +477,8 @@ static void sis_133_set_dmamode (struct 
 	u32 reg54;
 
 	/* bits 4- cycle time 8 - cvs time */
-	const u32 timing_u100[] = { 0x6B0, 0x470, 0x350, 0x140, 0x120, 0x110, 0x000 };
-	const u32 timing_u133[] = { 0x9F0, 0x6A0, 0x470, 0x250, 0x230, 0x220, 0x210 };
+	static const u32 timing_u100[] = { 0x6B0, 0x470, 0x350, 0x140, 0x120, 0x110, 0x000 };
+	static const u32 timing_u133[] = { 0x9F0, 0x6A0, 0x470, 0x250, 0x230, 0x220, 0x210 };
 
 	/* If bit 14 is set then the registers are mapped at 0x70 not 0x40 */
 	pci_read_config_dword(pdev, 0x54, &reg54);
@@ -598,8 +541,9 @@ static const struct ata_port_operations 
 
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
-	.error_handler		= sis_133_error_handler,
+	.error_handler		= sis_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.cable_detect		= sis_133_cable_detect,
 
 	.bmdma_setup		= ata_bmdma_setup,
 	.bmdma_start		= ata_bmdma_start,
@@ -631,8 +575,9 @@ static const struct ata_port_operations 
 
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
-	.error_handler		= sis_66_error_handler,
+	.error_handler		= sis_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.cable_detect		= sis_66_cable_detect,
 
 	.bmdma_setup		= ata_bmdma_setup,
 	.bmdma_start		= ata_bmdma_start,
@@ -664,9 +609,9 @@ static const struct ata_port_operations 
 
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
-	.error_handler		= sis_66_error_handler,
+	.error_handler		= sis_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
-
+	.cable_detect		= sis_66_cable_detect,
 
 	.bmdma_setup		= ata_bmdma_setup,
 	.bmdma_start		= ata_bmdma_start,
@@ -695,10 +640,11 @@ static const struct ata_port_operations 
 	.check_status		= ata_check_status,
 	.exec_command		= ata_exec_command,
 	.dev_select		= ata_std_dev_select,
+	.cable_detect		= sis_66_cable_detect,
 
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
-	.error_handler		= sis_66_error_handler,
+	.error_handler		= sis_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
 
 	.bmdma_setup		= ata_bmdma_setup,
@@ -731,8 +677,9 @@ static const struct ata_port_operations 
 
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
-	.error_handler		= sis_old_error_handler,
+	.error_handler		= sis_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.cable_detect		= ata_cable_40wire,
 
 	.bmdma_setup		= ata_bmdma_setup,
 	.bmdma_start		= ata_bmdma_start,
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
