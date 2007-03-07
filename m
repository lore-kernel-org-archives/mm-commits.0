From: akpm@linux-foundation.org
Subject: + pata_serverworks-cable-detect-and-comment-fix.patch added to -mm tree
Date: Wed, 07 Mar 2007 13:08:52 -0800
Message-ID: <200703072108.l27L8q3L009098@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57657 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992583AbXCGVJV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 16:09:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jeff@garzik.org


The patch titled
     pata_serverworks: cable detect and comment fix
has been added to the -mm tree.  Its filename is
     pata_serverworks-cable-detect-and-comment-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_serverworks: cable detect and comment fix
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

- Switch to cable_detect method
- Correct name of driver in initial comments

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_serverworks.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff -puN drivers/ata/pata_serverworks.c~pata_serverworks-cable-detect-and-comment-fix drivers/ata/pata_serverworks.c
--- a/drivers/ata/pata_serverworks.c~pata_serverworks-cable-detect-and-comment-fix
+++ a/drivers/ata/pata_serverworks.c
@@ -1,5 +1,5 @@
 /*
- * ata-serverworks.c 	- Serverworks PATA for new ATA layer
+ * pata_serverworks.c 	- Serverworks PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
  *			  Alan Cox <alan@redhat.com>
  *
@@ -137,14 +137,14 @@ static struct sv_cable_table cable_detec
 };
 
 /**
- *	serverworks_pre_reset		-	cable detection
+ *	serverworks_cable_detect	-	cable detection
  *	@ap: ATA port
  *
  *	Perform cable detection according to the device and subvendor
  *	identifications
  */
 
-static int serverworks_pre_reset(struct ata_port *ap) {
+static int serverworks_cable_detect(struct ata_port *ap) {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	struct sv_cable_table *cb = cable_detect;
 
@@ -152,8 +152,7 @@ static int serverworks_pre_reset(struct 
 		if (cb->device == pdev->device &&
 		    (cb->subvendor == pdev->subsystem_vendor ||
 		      cb->subvendor == PCI_ANY_ID)) {
-			ap->cbl = cb->cable_detect(ap);
-			return ata_std_prereset(ap);
+			return cb->cable_detect(ap);
 		}
 		cb++;
 	}
@@ -162,11 +161,6 @@ static int serverworks_pre_reset(struct 
 	return -1;	/* kill compiler warning */
 }
 
-static void serverworks_error_handler(struct ata_port *ap)
-{
-	return ata_bmdma_drive_eh(ap, serverworks_pre_reset, ata_std_softreset, NULL, ata_std_postreset);
-}
-
 /**
  *	serverworks_is_csb	-	Check for CSB or OSB
  *	@pdev: PCI device to check
@@ -339,8 +333,9 @@ static struct ata_port_operations server
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= serverworks_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= serverworks_cable_detect,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -374,8 +369,9 @@ static struct ata_port_operations server
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= serverworks_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= serverworks_cable_detect,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
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
