From: akpm@linux-foundation.org
Subject: + pata_cmd64x-restore-cable-method.patch added to -mm tree
Date: Sun, 11 Mar 2007 01:28:28 -0800
Message-ID: <200703110928.l2B9SSnc008745@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41160 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbXCKJ2h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 05:28:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     pata_cmd64x: restore cable method
has been added to the -mm tree.  Its filename is
     pata_cmd64x-restore-cable-method.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_cmd64x: restore cable method
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_cmd64x.c |   34 +++++++++-------------------------
 1 file changed, 9 insertions(+), 25 deletions(-)

diff -puN drivers/ata/pata_cmd64x.c~pata_cmd64x-restore-cable-method drivers/ata/pata_cmd64x.c
--- a/drivers/ata/pata_cmd64x.c~pata_cmd64x-restore-cable-method
+++ a/drivers/ata/pata_cmd64x.c
@@ -75,13 +75,7 @@ enum {
 	DTPR1		= 0x7C
 };
 
-static int cmd64x_pre_reset(struct ata_port *ap, unsigned long deadline)
-{
-	ap->cbl = ATA_CBL_PATA40;
-	return ata_std_prereset(ap, deadline);
-}
-
-static int cmd648_pre_reset(struct ata_port *ap, unsigned long deadline)
+static int cmd648_cable_detect(struct ata_port *ap)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u8 r;
@@ -89,21 +83,8 @@ static int cmd648_pre_reset(struct ata_p
 	/* Check cable detect bits */
 	pci_read_config_byte(pdev, BMIDECSR, &r);
 	if (r & (1 << ap->port_no))
-		ap->cbl = ATA_CBL_PATA80;
-	else
-		ap->cbl = ATA_CBL_PATA40;
-
-	return ata_std_prereset(ap, deadline);
-}
-
-static void cmd64x_error_handler(struct ata_port *ap)
-{
-	return ata_bmdma_drive_eh(ap, cmd64x_pre_reset, ata_std_softreset, NULL, ata_std_postreset);
-}
-
-static void cmd648_error_handler(struct ata_port *ap)
-{
-	ata_bmdma_drive_eh(ap, cmd648_pre_reset, ata_std_softreset, NULL, ata_std_postreset);
+		return ATA_CBL_PATA80;
+	return ATA_CBL_PATA40;
 }
 
 /**
@@ -304,8 +285,9 @@ static struct ata_port_operations cmd64x
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= cmd64x_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -338,8 +320,9 @@ static struct ata_port_operations cmd646
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= cmd64x_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -372,8 +355,9 @@ static struct ata_port_operations cmd648
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= cmd648_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= cmd648_cable_detect,
 
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
