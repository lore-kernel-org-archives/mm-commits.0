From: akpm@linux-foundation.org
Subject: - pata_it821x-switch-back-to-cable-detect-and-re-remove-all.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:57:43 -0800
Message-ID: <200703152157.l2FLvhFd027662@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42405 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbXCOV5z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:57:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pata_it821x: switch back to cable detect and re-remove all the crap
has been removed from the -mm tree.  Its filename was
     pata_it821x-switch-back-to-cable-detect-and-re-remove-all.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_it821x: switch back to cable detect and re-remove all the crap
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_it821x.c |   34 +++++-----------------------------
 1 file changed, 5 insertions(+), 29 deletions(-)

diff -puN drivers/ata/pata_it821x.c~pata_it821x-switch-back-to-cable-detect-and-re-remove-all drivers/ata/pata_it821x.c
--- a/drivers/ata/pata_it821x.c~pata_it821x-switch-back-to-cable-detect-and-re-remove-all
+++ a/drivers/ata/pata_it821x.c
@@ -80,7 +80,7 @@
 
 
 #define DRV_NAME "pata_it821x"
-#define DRV_VERSION "0.3.4"
+#define DRV_VERSION "0.3.6"
 
 struct it821x_dev
 {
@@ -113,32 +113,6 @@ struct it821x_dev
 static int it8212_noraid;
 
 /**
- *	it821x_pre_reset	-	probe
- *	@ap: ATA port
- *	@deadline: deadline jiffies for the operation
- *
- *	Set the cable type
- */
-
-static int it821x_pre_reset(struct ata_port *ap, unsigned long deadline)
-{
-	ap->cbl = ATA_CBL_PATA80;
-	return ata_std_prereset(ap, deadline);
-}
-
-/**
- *	it821x_error_handler	-	probe/reset
- *	@ap: ATA port
- *
- *	Set the cable type and trigger a probe
- */
-
-static void it821x_error_handler(struct ata_port *ap)
-{
-	return ata_bmdma_drive_eh(ap, it821x_pre_reset, ata_std_softreset, NULL, ata_std_postreset);
-}
-
-/**
  *	it821x_program	-	program the PIO/MWDMA registers
  *	@ap: ATA port
  *	@adev: Device to program
@@ -667,8 +641,9 @@ static struct ata_port_operations it821x
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= it821x_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_unknown,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -703,8 +678,9 @@ static struct ata_port_operations it821x
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= it821x_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_unknown,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= it821x_passthru_bmdma_start,
_

Patches currently in -mm which might be from alan@redhat.com are

origin.patch
git-libata-all.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
ata_generic-remove-all-the-crud-again-and-use-cable.patch
pata_ali-remove-all-the-crap-again-and-switch-to.patch
pata_amd-remove-all-the-crud-and-restore-the-cable-detect.patch
pata_cs5535-re-remove-all-the-crap-and-switch-to-the-cable.patch
pata_cypress-re-remove-all-the-crap-and-switch-back-to.patch
pata_netcell-re-remove-all-the-crud.patch
pata_qdi-restore-cable-detect.patch
pata_sl82c105-restore-cable-detect-method.patch
pata_winbond-restore-cable-method.patch
libata-acpi-add-infrastructure-for-drivers-to-use.patch
pata_optidma-rework-for-cable-detect-and-to-remove.patch
pata_pdc2027x-restore-various-updates-done-on-the-driver.patch
pata_acpi-restore-driver.patch
resend-iphase-64bit-cleanup.patch
pci_module_init-convertion-in-tmscsimc.patch
tty-clarify-documentation-of-write.patch
tty-i386-x86_64-arbitary-speed-support.patch
