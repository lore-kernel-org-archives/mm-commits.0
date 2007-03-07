From: akpm@linux-foundation.org
Subject: + pata_atiixp-switch-to-cable_detect-method-with-correct.patch added to -mm tree
Date: Wed, 07 Mar 2007 13:09:00 -0800
Message-ID: <200703072109.l27L904U009110@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57693 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992584AbXCGVJ3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 16:09:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jeff@garzik.org


The patch titled
     pata_atiixp: switch to cable_detect method (with correct patch)
has been added to the -mm tree.  Its filename is
     pata_atiixp-switch-to-cable_detect-method-with-correct.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_atiixp: switch to cable_detect method (with correct patch)
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Lets try attaching the right patch file this time

Not clear we should keep this ugly BIOS mode hack, but for now it can stay. 
Possibly an ACPI based solution will work, or just doing drive side detection
now that is hopefully fixed.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_atiixp.c |   28 ++++++++++++++++------------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff -puN drivers/ata/pata_atiixp.c~pata_atiixp-switch-to-cable_detect-method-with-correct drivers/ata/pata_atiixp.c
--- a/drivers/ata/pata_atiixp.c~pata_atiixp-switch-to-cable_detect-method-with-correct
+++ a/drivers/ata/pata_atiixp.c
@@ -22,7 +22,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_atiixp"
-#define DRV_VERSION "0.4.4"
+#define DRV_VERSION "0.4.5"
 
 enum {
 	ATIIXP_IDE_PIO_TIMING	= 0x40,
@@ -35,23 +35,13 @@ enum {
 
 static int atiixp_pre_reset(struct ata_port *ap)
 {
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	static const struct pci_bits atiixp_enable_bits[] = {
 		{ 0x48, 1, 0x01, 0x00 },
 		{ 0x48, 1, 0x08, 0x00 }
 	};
-	u8 udma;
-
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	if (!pci_test_config_bits(pdev, &atiixp_enable_bits[ap->port_no]))
 		return -ENOENT;
-
-	/* Hack from drivers/ide/pci. Really we want to know how to do the
-	   raw detection not play follow the bios mode guess */
-	pci_read_config_byte(pdev, ATIIXP_IDE_UDMA_MODE + ap->port_no, &udma);
-	if ((udma & 0x07) >= 0x04 || (udma & 0x70) >= 0x40)
-		ap->cbl = ATA_CBL_PATA80;
-	else
-		ap->cbl = ATA_CBL_PATA40;
 	return ata_std_prereset(ap);
 }
 
@@ -60,6 +50,19 @@ static void atiixp_error_handler(struct 
 	ata_bmdma_drive_eh(ap, atiixp_pre_reset, ata_std_softreset, NULL,   ata_std_postreset);
 }
 
+static int atiixp_cable_detect(struct ata_port *ap)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u8 udma;
+
+	/* Hack from drivers/ide/pci. Really we want to know how to do the
+	   raw detection not play follow the bios mode guess */
+	pci_read_config_byte(pdev, ATIIXP_IDE_UDMA_MODE + ap->port_no, &udma);
+	if ((udma & 0x07) >= 0x04 || (udma & 0x70) >= 0x40)
+		return  ATA_CBL_PATA80;
+	return ATA_CBL_PATA40;
+}
+
 /**
  *	atiixp_set_pio_timing	-	set initial PIO mode data
  *	@ap: ATA interface
@@ -245,6 +248,7 @@ static struct ata_port_operations atiixp
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= atiixp_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= atiixp_cable_detect,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= atiixp_bmdma_start,
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
