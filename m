From: akpm@linux-foundation.org
Subject: - pata_ali-remove-all-the-crap-again-and-switch-to.patch removed from -mm tree
Date: Wed, 04 Apr 2007 19:00:05 -0700
Message-ID: <200704050200.l35205vw004783@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38000 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916AbXDECAO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 4 Apr 2007 22:00:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pata_ali: remove all the crap again and switch to cable_detect method
has been removed from the -mm tree.  Its filename was
     pata_ali-remove-all-the-crap-again-and-switch-to.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_ali: remove all the crap again and switch to cable_detect method
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_ali.c |   68 +++++----------------------------------
 1 file changed, 9 insertions(+), 59 deletions(-)

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
@@ -90,59 +90,6 @@ static int ali_c2_cable_detect(struct at
 }
 
 /**
- *	ali_early_error_handler	-	reset for eary chip
- *	@ap: ATA port
- *
- *	Handle the reset callback for the later chips with cable detect
- */
-
-static int ali_c2_pre_reset(struct ata_port *ap)
-{
-	ap->cbl = ali_c2_cable_detect(ap);
-	return ata_std_prereset(ap);
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
- *
- *	Handle the reset callback for the early (pre cable detect) chips.
- */
-
-static int ali_early_pre_reset(struct ata_port *ap)
-{
-	ap->cbl = ali_early_cable_detect(ap);
-	return ata_std_prereset(ap);
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
@@ -314,7 +261,6 @@ static void ali_set_dmamode(struct ata_p
 
 /**
  *	ali_lock_sectors	-	Keep older devices to 255 sector mode
- *	@ap: ATA port
  *	@adev: Device
  *
  *	Called during the bus probe for each device that is found. We use
@@ -366,8 +312,9 @@ static struct ata_port_operations ali_ea
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= ali_early_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
@@ -402,8 +349,9 @@ static struct ata_port_operations ali_20
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= ali_early_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -440,8 +388,9 @@ static struct ata_port_operations ali_c2
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= ali_c2_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ali_c2_cable_detect,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -477,8 +426,9 @@ static struct ata_port_operations ali_c5
 
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

origin.patch
git-libata-all.patch
ata_generic-remove-all-the-crud-again-and-use-cable.patch
pata_cypress-re-remove-all-the-crap-and-switch-back-to.patch
libata-acpi-add-infrastructure-for-drivers-to-use.patch
libata-acpi-add-infrastructure-for-drivers-to-use-fix.patch
pata_acpi-restore-driver.patch
pata_acpi-restore-driver-fix.patch
libata-misc-minor-merge-fixups.patch
pata_hpt37x-further-small-fixes.patch
pata_hpt3x2n-add-hpt371n-support-and-other-bits.patch
pata_pdc2027x-bring-into-line-with-changes-add-the-mode.patch
pci_module_init-convertion-in-tmscsimc.patch
tty-clarify-documentation-of-write.patch
tty-i386-x86_64-arbitary-speed-support.patch
revoke-special-mmap-handling.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
