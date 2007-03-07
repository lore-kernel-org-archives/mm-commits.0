From: akpm@linux-foundation.org
Subject: + pata_sis-clean-up-using-cable_detect-methods.patch added to -mm tree
Date: Wed, 07 Mar 2007 13:08:54 -0800
Message-ID: <200703072108.l27L8sx3009101@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57653 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992580AbXCGVJU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 16:09:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jeff@garzik.org


The patch titled
     pata_sis: clean up using cable_detect methods
has been added to the -mm tree.  Its filename is
     pata_sis-clean-up-using-cable_detect-methods.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_sis: clean up using cable_detect methods
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This changeset revolves around the fact that all the SiS controllers have the
same enable bits, but differing cable detection methods.  Previously that
meant each type had its own error_handler methods.  Instead we can now
implement different ->cable_detect methods and share a single error_handler
which does the filtering by enable bits.

In addition we had some auto const arrays that should be static const.  I'm
not sure if gcc already treats them intelligently but adding the static will
make sure.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_sis.c |  109 ++++++++++-----------------------------
 1 files changed, 29 insertions(+), 80 deletions(-)

diff -puN drivers/ata/pata_sis.c~pata_sis-clean-up-using-cable_detect-methods drivers/ata/pata_sis.c
--- a/drivers/ata/pata_sis.c~pata_sis-clean-up-using-cable_detect-methods
+++ a/drivers/ata/pata_sis.c
@@ -35,7 +35,7 @@
 #include "sis.h"
 
 #define DRV_NAME	"pata_sis"
-#define DRV_VERSION	"0.5.0"
+#define DRV_VERSION	"0.5.1"
 
 struct sis_chipset {
 	u16 device;			/* PCI host ID */
@@ -86,106 +86,55 @@ static int sis_port_base(struct ata_devi
 }
 
 /**
- *	sis_133_pre_reset	-	check for 40/80 pin
+ *	sis_133_cable_detect	-	check for 40/80 pin
  *	@ap: Port
  *
  *	Perform cable detection for the later UDMA133 capable
  *	SiS chipset.
  */
 
-static int sis_133_pre_reset(struct ata_port *ap)
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
-	return ata_std_prereset(ap);
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
  *
  *	Perform cable detection on the UDMA66, UDMA100 and early UDMA133
  *	SiS IDE controllers.
  */
 
-static int sis_66_pre_reset(struct ata_port *ap)
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
-	return ata_std_prereset(ap);
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
  *
  *	Set up cable type and use generic probe init
  */
 
-static int sis_old_pre_reset(struct ata_port *ap)
+static int sis_pre_reset(struct ata_port *ap)
 {
 	static const struct pci_bits sis_enable_bits[] = {
 		{ 0x4aU, 1U, 0x02UL, 0x02UL },	/* port 0 */
@@ -194,27 +143,23 @@ static int sis_old_pre_reset(struct ata_
 
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 
-	if (!pci_test_config_bits(pdev, &sis_enable_bits[ap->port_no])) {
-		ata_port_disable(ap);
-		ata_port_printk(ap, KERN_INFO, "port disabled. ignoring.\n");
-		return 0;
-	}
-	ap->cbl = ATA_CBL_PATA40;
+	if (!pci_test_config_bits(pdev, &sis_enable_bits[ap->port_no]))
+		return -ENOENT;
 	return ata_std_prereset(ap);
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
@@ -494,7 +439,7 @@ static void sis_133_early_set_dmamode (s
 	int drive_pci = sis_port_base(adev);
 	u16 timing;
 
-	const u16 udma_bits[]  = { 0x8F00, 0x8A00, 0x8700, 0x8500, 0x8300, 0x8200, 0x8100};
+	static const u16 udma_bits[]  = { 0x8F00, 0x8A00, 0x8700, 0x8500, 0x8300, 0x8200, 0x8100};
 
 	pci_read_config_word(pdev, drive_pci, &timing);
 
@@ -531,8 +476,8 @@ static void sis_133_set_dmamode (struct 
 	u32 reg54;
 
 	/* bits 4- cycle time 8 - cvs time */
-	const u32 timing_u100[] = { 0x6B0, 0x470, 0x350, 0x140, 0x120, 0x110, 0x000 };
-	const u32 timing_u133[] = { 0x9F0, 0x6A0, 0x470, 0x250, 0x230, 0x220, 0x210 };
+	static const u32 timing_u100[] = { 0x6B0, 0x470, 0x350, 0x140, 0x120, 0x110, 0x000 };
+	static const u32 timing_u133[] = { 0x9F0, 0x6A0, 0x470, 0x250, 0x230, 0x220, 0x210 };
 
 	/* If bit 14 is set then the registers are mapped at 0x70 not 0x40 */
 	pci_read_config_dword(pdev, 0x54, &reg54);
@@ -595,8 +540,9 @@ static const struct ata_port_operations 
 
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
-	.error_handler		= sis_133_error_handler,
+	.error_handler		= sis_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.cable_detect		= sis_133_cable_detect,
 
 	.bmdma_setup		= ata_bmdma_setup,
 	.bmdma_start		= ata_bmdma_start,
@@ -628,8 +574,9 @@ static const struct ata_port_operations 
 
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
-	.error_handler		= sis_66_error_handler,
+	.error_handler		= sis_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.cable_detect		= sis_66_cable_detect,
 
 	.bmdma_setup		= ata_bmdma_setup,
 	.bmdma_start		= ata_bmdma_start,
@@ -661,9 +608,9 @@ static const struct ata_port_operations 
 
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
-	.error_handler		= sis_66_error_handler,
+	.error_handler		= sis_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
-
+	.cable_detect		= sis_66_cable_detect,
 
 	.bmdma_setup		= ata_bmdma_setup,
 	.bmdma_start		= ata_bmdma_start,
@@ -692,10 +639,11 @@ static const struct ata_port_operations 
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
@@ -728,8 +676,9 @@ static const struct ata_port_operations 
 
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
-	.error_handler		= sis_old_error_handler,
+	.error_handler		= sis_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.cable_detect		= ata_cable_40wire,
 
 	.bmdma_setup		= ata_bmdma_setup,
 	.bmdma_start		= ata_bmdma_start,
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
expose-set_mode-method-so-it-can-be-wrapped.patch
acpi-driver-support-for-pata.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
pata_platform-set-a-cable-type-which-to-set.patch
pata_qdi-set-cable-type.patch
pata_sl82c105-missing-methods-cable.patch
ata_generic-remove-lots-of-code-using-the-new-cable_detect.patch
pata_ali-remove-lots-of-code-by-using-the-cable_detect.patch
pata_cs55x0-clean-up-by-using-the-cable_detect-method.patch
pata_cypress-clean-up-by-using-cable_detect-method.patch
pata_isapnp-set-cable-type.patch
pata_ixp4xx_cf-set-cable-type.patch
pata_legacy-fix-missing-methods-and-add-cable-types.patch
pata_netcell-remove-lots-of-crud-by-using-the-cable-method.patch
pata_radisys-switch-to-cable-method-to-cleanup-code.patch
pata_sc1200-set-cable-type-add-freeze-thaw-methods.patch
pata_rz1000-remove-lots-of-crap-by-using-cable-method.patch
pata_winbond-set-cable-type.patch
pata_cmd64x-various-fixes.patch
pata_hpt3x3-clean-up-by-using-cable-method.patch
ata_piix-remove-ugly-layering-violation.patch
pata_artop-cable-detect-methods.patch
pata_cs5535-cable-detect.patch
pata_hpt3x2n-cable-detect-handling-needs-work.patch
pata_it821x-clean-up-by-using-cable-methods.patch
pata_mpc52xx-cable-detect.patch
pata_mpiix-cable-detect-method.patch
pata_ns87410-cable-detect-method.patch
pata_oldpiix-cable-detect.patch
pata_opti-cable-detect.patch
pata_pcmcia-cable-detect.patch
pata_pdc202xx_old-cable-detect-clean-up.patch
pata_sil680-cable-detect.patch
pata_triflex-cable-detect.patch
sata_via-cable-detection.patch
pata_cmd640-multiple-updates.patch
pata_efar-switch-to-cable_detect-method.patch
pata_it8213-cable-detect.patch
pata_marvell-cable-and-reset-fixes.patch
pata_serverworks-cable-detect-and-comment-fix.patch
pata_sis-clean-up-using-cable_detect-methods.patch
pata_via-use-cable_detect-method.patch
pata_hpt366-cable-detect-methods.patch
pata_atiixp-switch-to-cable_detect-method-with-correct.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
dilnetpc-fix-warning.patch
resend-iphase-64bit-cleanup.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
tty-clarify-documentation-of-write.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
