From: akpm@linux-foundation.org
Subject: - pata_cs55x0-clean-up-by-using-the-cable_detect-method.patch removed from -mm tree
Date: Sun, 04 Mar 2007 23:31:35 -0800
Message-ID: <200703050731.l257VZKX012721@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34454 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbXCEHbu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 02:31:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pata_cs55x0: clean up by using the cable_detect method
has been removed from the -mm tree.  Its filename was
     pata_cs55x0-clean-up-by-using-the-cable_detect-method.patch

This patch was dropped because it needs libata-cable-detection-fixes.patch

------------------------------------------------------
Subject: pata_cs55x0: clean up by using the cable_detect method
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_cs5520.c |   15 ++-------------
 drivers/ata/pata_cs5530.c |   15 ++-------------
 2 files changed, 4 insertions(+), 26 deletions(-)

diff -puN drivers/ata/pata_cs5520.c~pata_cs55x0-clean-up-by-using-the-cable_detect-method drivers/ata/pata_cs5520.c
--- a/drivers/ata/pata_cs5520.c~pata_cs55x0-clean-up-by-using-the-cable_detect-method
+++ a/drivers/ata/pata_cs5520.c
@@ -139,18 +139,6 @@ static void cs5520_set_piomode(struct at
 	cs5520_set_timings(ap, adev, adev->pio_mode);
 }
 
-
-static int cs5520_pre_reset(struct ata_port *ap)
-{
-	ap->cbl = ATA_CBL_PATA40;
-	return ata_std_prereset(ap);
-}
-
-static void cs5520_error_handler(struct ata_port *ap)
-{
-	return ata_bmdma_drive_eh(ap, cs5520_pre_reset, ata_std_softreset, NULL, ata_std_postreset);
-}
-
 static struct scsi_host_template cs5520_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -184,8 +172,9 @@ static struct ata_port_operations cs5520
 
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
-	.error_handler		= cs5520_error_handler,
+	.error_handler		= ata_bmdma_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.cable_detect		= ata_cable_40wire,
 
 	.bmdma_setup		= ata_bmdma_setup,
 	.bmdma_start		= ata_bmdma_start,
diff -puN drivers/ata/pata_cs5530.c~pata_cs55x0-clean-up-by-using-the-cable_detect-method drivers/ata/pata_cs5530.c
--- a/drivers/ata/pata_cs5530.c~pata_cs55x0-clean-up-by-using-the-cable_detect-method
+++ a/drivers/ata/pata_cs5530.c
@@ -160,18 +160,6 @@ static unsigned int cs5530_qc_issue_prot
 	return ata_qc_issue_prot(qc);
 }
 
-static int cs5530_pre_reset(struct ata_port *ap)
-{
-	ap->cbl = ATA_CBL_PATA40;
-	return ata_std_prereset(ap);
-}
-
-static void cs5530_error_handler(struct ata_port *ap)
-{
-	return ata_bmdma_drive_eh(ap, cs5530_pre_reset, ata_std_softreset, NULL, ata_std_postreset);
-}
-
-
 static struct scsi_host_template cs5530_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -211,8 +199,9 @@ static struct ata_port_operations cs5530
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= cs5530_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= cs5530_qc_issue_prot,
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
cyclades-return-closing_wait.patch
git-libata-all.patch
libata-warn-if-speed-limited-due-to-40-wire-cable-v2.patch
expose-set_mode-method-so-it-can-be-wrapped.patch
acpi-driver-support-for-pata.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
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
pata_qdi-fix-initialisation.patch
pata_cmd640-cmd640-pci-support.patch
libata-kconfig-update-the-various-experimentality-levels.patch
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
