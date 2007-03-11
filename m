From: akpm@linux-foundation.org
Subject: + pata_ali-remove-all-the-crap-again-and-switch-to.patch added to -mm tree
Date: Sun, 11 Mar 2007 01:28:12 -0800
Message-ID: <200703110928.l2B9SCWH008726@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41145 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbXCKJ2W (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 05:28:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     pata_ali: remove all the crap again and switch to cable_detect method
has been added to the -mm tree.  Its filename is
     pata_ali-remove-all-the-crap-again-and-switch-to.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_ali: remove all the crap again and switch to cable_detect method
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_ali.c |   74 +++++----------------------------------
 1 file changed, 11 insertions(+), 63 deletions(-)

diff -puN drivers/ata/pata_ali.c~pata_ali-remove-all-the-crap-again-and-switch-to drivers/ata/pata_ali.c
--- a/drivers/ata/pata_ali.c~pata_ali-remove-all-the-crap-again-and-switch-to
+++ a/drivers/ata/pata_ali.c
@@ -34,7 +34,7 @@
 #include <linux/dmi.h>
 
 #define DRV_NAME "pata_ali"
-#define DRV_VERSION "0.7.3"
+#define DRV_VERSION "0.7.4"
 
 /*
  *	Cable special cases
@@ -90,61 +90,6 @@ static int ali_c2_cable_detect(struct at
 }
 
 /**
- *	ali_early_error_handler	-	reset for eary chip
- *	@ap: ATA port
- *	@deadline: deadline jiffies for the operation
- *
- *	Handle the reset callback for the later chips with cable detect
- */
-
-static int ali_c2_pre_reset(struct ata_port *ap, unsigned long deadline)
-{
-	ap->cbl = ali_c2_cable_detect(ap);
-	return ata_std_prereset(ap, deadline);
-}
-
-static void ali_c2_error_handler(struct ata_port *ap)
-{
-	ata_bmdma_drive_eh(ap, ali_c2_pre_reset,
-			       ata_std_softreset, NULL,
-			       ata_std_postreset);
-}
-
-/**
- *	ali_early_cable_detect	-	cable detection
- *	@ap: ATA port
- *
- *	Perform cable detection for older chipsets. This turns out to be
- *	rather easy to implement
- */
-
-static int ali_early_cable_detect(struct ata_port *ap)
-{
-	return ATA_CBL_PATA40;
-}
-
-/**
- *	ali_early_probe_init	-	reset for early chip
- *	@ap: ATA port
- *	@deadline: deadline jiffies for the operation
- *
- *	Handle the reset callback for the early (pre cable detect) chips.
- */
-
-static int ali_early_pre_reset(struct ata_port *ap, unsigned long deadline)
-{
-	ap->cbl = ali_early_cable_detect(ap);
-	return ata_std_prereset(ap, deadline);
-}
-
-static void ali_early_error_handler(struct ata_port *ap)
-{
-	return ata_bmdma_drive_eh(ap, ali_early_pre_reset,
-				     ata_std_softreset, NULL,
-				     ata_std_postreset);
-}
-
-/**
  *	ali_20_filter		-	filter for earlier ALI DMA
  *	@ap: ALi ATA port
  *	@adev: attached device
@@ -153,7 +98,7 @@ static void ali_early_error_handler(stru
  *	fix that later on. Also ensure we do not do UDMA on WDC drives
  */
 
-static unsigned long ali_20_filter(const struct ata_port *ap, struct ata_device *adev, unsigned long mask)
+static unsigned long ali_20_filter(struct ata_device *adev, unsigned long mask)
 {
 	char model_num[ATA_ID_PROD_LEN + 1];
 	/* No DMA on anything but a disk for now */
@@ -162,7 +107,7 @@ static unsigned long ali_20_filter(const
 	ata_id_c_string(adev->id, model_num, ATA_ID_PROD, sizeof(model_num));
 	if (strstr(model_num, "WDC"))
 		return mask &= ~ATA_MASK_UDMA;
-	return ata_pci_default_filter(ap, adev, mask);
+	return ata_pci_default_filter(adev, mask);
 }
 
 /**
@@ -316,7 +261,6 @@ static void ali_set_dmamode(struct ata_p
 
 /**
  *	ali_lock_sectors	-	Keep older devices to 255 sector mode
- *	@ap: ATA port
  *	@adev: Device
  *
  *	Called during the bus probe for each device that is found. We use
@@ -368,8 +312,9 @@ static struct ata_port_operations ali_ea
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= ali_early_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
@@ -404,8 +349,9 @@ static struct ata_port_operations ali_20
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= ali_early_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -442,8 +388,9 @@ static struct ata_port_operations ali_c2
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= ali_c2_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ali_c2_cable_detect,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -479,8 +426,9 @@ static struct ata_port_operations ali_c5
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= ali_c2_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ali_c2_cable_detect,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
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
