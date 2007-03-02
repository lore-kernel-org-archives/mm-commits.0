From: akpm@linux-foundation.org
Subject: + pata_cmd64x-various-fixes.patch added to -mm tree
Date: Thu, 01 Mar 2007 18:25:43 -0800
Message-ID: <200703020225.l222PhSb030003@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35777 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422779AbXCBCZx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 21:25:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk


The patch titled
     pata_cmd64x - various fixes
has been added to the -mm tree.  Its filename is
     pata_cmd64x-various-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_cmd64x - various fixes
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This driver still needs more work but for the moment

- It's a CMD not ATI driver
- Clean up code by using cable method

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_cmd64x.c |   36 ++++++++++--------------------------
 1 files changed, 10 insertions(+), 26 deletions(-)

diff -puN drivers/ata/pata_cmd64x.c~pata_cmd64x-various-fixes drivers/ata/pata_cmd64x.c
--- a/drivers/ata/pata_cmd64x.c~pata_cmd64x-various-fixes
+++ a/drivers/ata/pata_cmd64x.c
@@ -1,5 +1,5 @@
 /*
- * pata_cmd64x.c 	- ATI PATA for new ATA layer
+ * pata_cmd64x.c 	- CMD64x PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
  *			  Alan Cox <alan@redhat.com>
  *
@@ -75,13 +75,7 @@ enum {
 	DTPR1		= 0x7C
 };
 
-static int cmd64x_pre_reset(struct ata_port *ap)
-{
-	ap->cbl = ATA_CBL_PATA40;
-	return ata_std_prereset(ap);
-}
-
-static int cmd648_pre_reset(struct ata_port *ap)
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
-	return ata_std_prereset(ap);
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
@@ -302,8 +283,9 @@ static struct ata_port_operations cmd64x
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= cmd64x_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -336,8 +318,9 @@ static struct ata_port_operations cmd646
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= cmd64x_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -370,8 +353,9 @@ static struct ata_port_operations cmd648
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= cmd648_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= cmd648_cable_detect,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

cyclades-return-closing_wait.patch
libata-warn-if-speed-limited-due-to-40-wire-cable-v2.patch
expose-set_mode-method-so-it-can-be-wrapped.patch
acpi-driver-support-for-pata.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
libata-cable-detection-fixes.patch
libata-dev_config-does-not-need-ap-and-adev-passing.patch
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
libata-fix-hopefully-all-the-remaining-problems-with.patch
resend-iphase-64bit-cleanup.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
tty-clarify-documentation-of-write.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
