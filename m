From: akpm@linux-foundation.org
Subject: + sata_via-cable-detection.patch added to -mm tree
Date: Wed, 07 Mar 2007 13:08:42 -0800
Message-ID: <200703072108.l27L8gDF009080@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57650 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992576AbXCGVJS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 16:09:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jeff@garzik.org


The patch titled
     sata_via: cable detection
has been added to the -mm tree.  Its filename is
     sata_via-cable-detection.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sata_via: cable detection
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Because the sata_via driver handles PATA and SATA ports on the 6421 it also
ends up with duplicated chunks of code that can be eliminated using the
cable_detect method.  Generally SATA drivers don't need/want this as they are
set correctly by libata simply because they declare themselves as SATA.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_via.c |   35 ++++++++---------------------------
 1 files changed, 8 insertions(+), 27 deletions(-)

diff -puN drivers/ata/sata_via.c~sata_via-cable-detection drivers/ata/sata_via.c
--- a/drivers/ata/sata_via.c~sata_via-cable-detection
+++ a/drivers/ata/sata_via.c
@@ -78,8 +78,7 @@ static u32 svia_scr_read (struct ata_por
 static void svia_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val);
 static void svia_noop_freeze(struct ata_port *ap);
 static void vt6420_error_handler(struct ata_port *ap);
-static void vt6421_sata_error_handler(struct ata_port *ap);
-static void vt6421_pata_error_handler(struct ata_port *ap);
+static int vt6421_pata_cable_detect(struct ata_port *ap);
 static void vt6421_set_pio_mode(struct ata_port *ap, struct ata_device *adev);
 static void vt6421_set_dma_mode(struct ata_port *ap, struct ata_device *adev);
 static int vt6421_port_start(struct ata_port *ap);
@@ -172,8 +171,9 @@ static const struct ata_port_operations 
 
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
-	.error_handler		= vt6421_pata_error_handler,
+	.error_handler		= ata_bmdma_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.cable_detect		= vt6421_pata_cable_detect,
 
 	.irq_handler		= ata_interrupt,
 	.irq_clear		= ata_bmdma_irq_clear,
@@ -203,8 +203,9 @@ static const struct ata_port_operations 
 
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
-	.error_handler		= vt6421_sata_error_handler,
+	.error_handler		= ata_bmdma_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.cable_detect		= ata_cable_sata,
 
 	.irq_handler		= ata_interrupt,
 	.irq_clear		= ata_bmdma_irq_clear,
@@ -330,35 +331,15 @@ static void vt6420_error_handler(struct 
 				  NULL, ata_std_postreset);
 }
 
-static int vt6421_pata_prereset(struct ata_port *ap)
+static int vt6421_pata_cable_detect(struct ata_port *ap)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u8 tmp;
 
 	pci_read_config_byte(pdev, PATA_UDMA_TIMING, &tmp);
 	if (tmp & 0x10)
-		ap->cbl = ATA_CBL_PATA40;
-	else
-		ap->cbl = ATA_CBL_PATA80;
-	return 0;
-}
-
-static void vt6421_pata_error_handler(struct ata_port *ap)
-{
-	return ata_bmdma_drive_eh(ap, vt6421_pata_prereset, ata_std_softreset,
-				  NULL, ata_std_postreset);
-}
-
-static int vt6421_sata_prereset(struct ata_port *ap)
-{
-	ap->cbl = ATA_CBL_SATA;
-	return 0;
-}
-
-static void vt6421_sata_error_handler(struct ata_port *ap)
-{
-	return ata_bmdma_drive_eh(ap, vt6421_sata_prereset, ata_std_softreset,
-				  NULL, ata_std_postreset);
+		return ATA_CBL_PATA40;
+	return ATA_CBL_PATA80;
 }
 
 static void vt6421_set_pio_mode(struct ata_port *ap, struct ata_device *adev)
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
dilnetpc-fix-warning.patch
