From: akpm@linux-foundation.org
Subject: - pata_serverworks-cable-detect-and-comment-fix.patch removed from -mm tree
Date: Wed, 07 Mar 2007 15:46:45 -0800
Message-ID: <200703072346.l27NkjDJ013363@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39174 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945920AbXCGXrH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 18:47:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     pata_serverworks: cable detect and comment fix
has been removed from the -mm tree.  Its filename was
     pata_serverworks-cable-detect-and-comment-fix.patch

This patch was dropped because an updated version will be merged

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
pcmcia-spot-slave-decode-flaws-for-testing.patch
pata_platform-set-a-cable-type-which-to-set.patch
pata_qdi-set-cable-type.patch
pata_sl82c105-missing-methods-cable.patch
pata_isapnp-set-cable-type.patch
pata_legacy-fix-missing-methods-and-add-cable-types.patch
pata_sc1200-set-cable-type-add-freeze-thaw-methods.patch
pata_winbond-set-cable-type.patch
ata_piix-remove-ugly-layering-violation.patch
pata_mpc52xx-cable-detect.patch
pata_mpiix-cable-detect-method.patch
pata_ns87410-cable-detect-method.patch
pata_oldpiix-cable-detect.patch
pata_opti-cable-detect.patch
pata_pcmcia-cable-detect.patch
pata_triflex-cable-detect.patch
pata_cmd640-multiple-updates.patch
pata_serverworks-cable-detect-and-comment-fix.patch
pata_sis-clean-up-using-cable_detect-methods.patch
pata_via-use-cable_detect-method.patch
pata_hpt366-cable-detect-methods.patch
pata_atiixp-switch-to-cable_detect-method-with-correct.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
dilnetpc-fix-warning.patch
resend-iphase-64bit-cleanup.patch
serial-suppress-rts-assertion-with-disabled-crtscts.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
z85230-fix-fifo-handling.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
tty-clarify-documentation-of-write.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
