From: akpm@linux-foundation.org
Subject: - pata_cs55x0-clean-up-by-using-the-cable_detect-method.patch removed from -mm tree
Date: Wed, 07 Mar 2007 15:38:59 -0800
Message-ID: <200703072338.l27NcxgL013061@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39012 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965758AbXCGXo2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 18:44:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pata_cs55x0: clean up by using the cable_detect method
has been removed from the -mm tree.  Its filename was
     pata_cs55x0-clean-up-by-using-the-cable_detect-method.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: pata_cs55x0: clean up by using the cable_detect method
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_cs5520.c |    3 ++-
 drivers/ata/pata_cs5530.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/ata/pata_cs5520.c~pata_cs55x0-clean-up-by-using-the-cable_detect-method drivers/ata/pata_cs5520.c
--- a/drivers/ata/pata_cs5520.c~pata_cs55x0-clean-up-by-using-the-cable_detect-method
+++ a/drivers/ata/pata_cs5520.c
@@ -186,8 +186,9 @@ static struct ata_port_operations cs5520
 
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
@@ -213,8 +213,9 @@ static struct ata_port_operations cs5530
 
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

git-libata-all.patch
expose-set_mode-method-so-it-can-be-wrapped.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
pata_platform-set-a-cable-type-which-to-set.patch
pata_qdi-set-cable-type.patch
pata_sl82c105-missing-methods-cable.patch
pata_cs55x0-clean-up-by-using-the-cable_detect-method.patch
pata_cypress-clean-up-by-using-cable_detect-method.patch
pata_isapnp-set-cable-type.patch
pata_ixp4xx_cf-set-cable-type.patch
pata_legacy-fix-missing-methods-and-add-cable-types.patch
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
