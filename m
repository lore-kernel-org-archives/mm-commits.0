From: akpm@linux-foundation.org
Subject: + ata_generic-remove-lots-of-code-using-the-new-cable_detect.patch added to -mm tree
Date: Thu, 01 Mar 2007 18:25:19 -0800
Message-ID: <200703020225.l222PJcY029962@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35740 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422741AbXCBCZj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 21:25:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     ata_generic: Remove lots of code using the new cable_detect method
has been added to the -mm tree.  Its filename is
     ata_generic-remove-lots-of-code-using-the-new-cable_detect.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ata_generic: Remove lots of code using the new cable_detect method
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

(And correct the cable type to unknown while we are at it)

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ata_generic.c |   32 ++------------------------------
 1 files changed, 2 insertions(+), 30 deletions(-)

diff -puN drivers/ata/ata_generic.c~ata_generic-remove-lots-of-code-using-the-new-cable_detect drivers/ata/ata_generic.c
--- a/drivers/ata/ata_generic.c~ata_generic-remove-lots-of-code-using-the-new-cable_detect
+++ a/drivers/ata/ata_generic.c
@@ -33,35 +33,6 @@
  */
 
 /**
- *	generic_pre_reset		-	probe begin
- *	@ap: ATA port
- *
- *	Set up cable type and use generic probe init
- */
-
-static int generic_pre_reset(struct ata_port *ap)
-{
-	ap->cbl = ATA_CBL_PATA80;
-	return ata_std_prereset(ap);
-}
-
-
-/**
- *	generic_error_handler - Probe specified port on PATA host controller
- *	@ap: Port to probe
- *	@classes:
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-
-static void generic_error_handler(struct ata_port *ap)
-{
-	ata_bmdma_drive_eh(ap, generic_pre_reset, ata_std_softreset, NULL, ata_std_postreset);
-}
-
-/**
  *	generic_set_mode	-	mode setting
  *	@ap: interface to set up
  *	@unused: returned device on error
@@ -142,8 +113,9 @@ static struct ata_port_operations generi
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= generic_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_unknown,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
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
