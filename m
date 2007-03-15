From: akpm@linux-foundation.org
Subject: - pata_pdc202xx_old-re-remove-crap-restore-cable-methods.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:58:03 -0800
Message-ID: <200703152158.l2FLw3Da027694@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42443 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbXCOV6Q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:58:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pata_pdc202xx_old: re-remove crap, restore cable methods
has been removed from the -mm tree.  Its filename was
     pata_pdc202xx_old-re-remove-crap-restore-cable-methods.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_pdc202xx_old: re-remove crap, restore cable methods
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_pdc202xx_old.c |   43 +++++-------------------------
 1 file changed, 8 insertions(+), 35 deletions(-)

diff -puN drivers/ata/pata_pdc202xx_old.c~pata_pdc202xx_old-re-remove-crap-restore-cable-methods drivers/ata/pata_pdc202xx_old.c
--- a/drivers/ata/pata_pdc202xx_old.c~pata_pdc202xx_old-re-remove-crap-restore-cable-methods
+++ a/drivers/ata/pata_pdc202xx_old.c
@@ -22,46 +22,17 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_pdc202xx_old"
-#define DRV_VERSION "0.4.0"
+#define DRV_VERSION "0.4.2"
 
-/**
- *	pdc2024x_pre_reset		-	probe begin
- *	@ap: ATA port
- *	@deadline: deadline jiffies for the operation
- *
- *	Set up cable type and use generic probe init
- */
-
-static int pdc2024x_pre_reset(struct ata_port *ap, unsigned long deadline)
-{
-	ap->cbl = ATA_CBL_PATA40;
-	return ata_std_prereset(ap, deadline);
-}
-
-
-static void pdc2024x_error_handler(struct ata_port *ap)
-{
-	ata_bmdma_drive_eh(ap, pdc2024x_pre_reset, ata_std_softreset, NULL, ata_std_postreset);
-}
-
-
-static int pdc2026x_pre_reset(struct ata_port *ap, unsigned long deadline)
+static int pdc2026x_cable_detect(struct ata_port *ap)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u16 cis;
 
 	pci_read_config_word(pdev, 0x50, &cis);
 	if (cis & (1 << (10 + ap->port_no)))
-		ap->cbl = ATA_CBL_PATA80;
-	else
-		ap->cbl = ATA_CBL_PATA40;
-
-	return ata_std_prereset(ap, deadline);
-}
-
-static void pdc2026x_error_handler(struct ata_port *ap)
-{
-	ata_bmdma_drive_eh(ap, pdc2026x_pre_reset, ata_std_softreset, NULL, ata_std_postreset);
+		return ATA_CBL_PATA80;
+	return ATA_CBL_PATA40;
 }
 
 /**
@@ -292,8 +263,9 @@ static struct ata_port_operations pdc202
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= pdc2024x_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -326,8 +298,9 @@ static struct ata_port_operations pdc202
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= pdc2026x_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= pdc2026x_cable_detect,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= pdc2026x_bmdma_start,
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
