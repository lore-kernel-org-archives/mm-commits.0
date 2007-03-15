From: akpm@linux-foundation.org
Subject: - sata_via-use-cable-detect-methods.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:58:13 -0800
Message-ID: <200703152158.l2FLwD2j027713@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42460 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbXCOV60 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:58:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     sata_via: use cable detect methods
has been removed from the -mm tree.  Its filename was
     sata_via-use-cable-detect-methods.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sata_via: use cable detect methods
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_via.c |   35 ++++++++---------------------------
 1 file changed, 8 insertions(+), 27 deletions(-)

diff -puN drivers/ata/sata_via.c~sata_via-use-cable-detect-methods drivers/ata/sata_via.c
--- a/drivers/ata/sata_via.c~sata_via-use-cable-detect-methods
+++ a/drivers/ata/sata_via.c
@@ -78,8 +78,7 @@ static u32 svia_scr_read (struct ata_por
 static void svia_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val);
 static void svia_noop_freeze(struct ata_port *ap);
 static void vt6420_error_handler(struct ata_port *ap);
-static void vt6421_sata_error_handler(struct ata_port *ap);
-static void vt6421_pata_error_handler(struct ata_port *ap);
+static int vt6421_pata_cable_detect(struct ata_port *ap);
 static void vt6421_set_pio_mode(struct ata_port *ap, struct ata_device *adev);
 static void vt6421_set_dma_mode(struct ata_port *ap, struct ata_device *adev);
 static int vt6421_port_start(struct ata_port *ap);
@@ -172,8 +171,9 @@ static const struct ata_port_operations 
 
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
-	.error_handler		= vt6421_pata_error_handler,
+	.error_handler		= ata_bmdma_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.cable_detect		= vt6421_pata_cable_detect,
 
 	.irq_handler		= ata_interrupt,
 	.irq_clear		= ata_bmdma_irq_clear,
@@ -203,8 +203,9 @@ static const struct ata_port_operations 
 
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
-	.error_handler		= vt6421_sata_error_handler,
+	.error_handler		= ata_bmdma_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.cable_detect		= ata_cable_sata,
 
 	.irq_handler		= ata_interrupt,
 	.irq_clear		= ata_bmdma_irq_clear,
@@ -331,35 +332,15 @@ static void vt6420_error_handler(struct 
 				  NULL, ata_std_postreset);
 }
 
-static int vt6421_pata_prereset(struct ata_port *ap, unsigned long deadline)
+static int vt6421_pata_cable_detect(struct ata_port *ap)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u8 tmp;
 
 	pci_read_config_byte(pdev, PATA_UDMA_TIMING, &tmp);
 	if (tmp & 0x10)
-		ap->cbl = ATA_CBL_PATA40;
-	else
-		ap->cbl = ATA_CBL_PATA80;
-	return 0;
-}
-
-static void vt6421_pata_error_handler(struct ata_port *ap)
-{
-	return ata_bmdma_drive_eh(ap, vt6421_pata_prereset, ata_std_softreset,
-				  NULL, ata_std_postreset);
-}
-
-static int vt6421_sata_prereset(struct ata_port *ap, unsigned long deadline)
-{
-	ap->cbl = ATA_CBL_SATA;
-	return 0;
-}
-
-static void vt6421_sata_error_handler(struct ata_port *ap)
-{
-	return ata_bmdma_drive_eh(ap, vt6421_sata_prereset, ata_std_softreset,
-				  NULL, ata_std_postreset);
+		return ATA_CBL_PATA40;
+	return ATA_CBL_PATA80;
 }
 
 static void vt6421_set_pio_mode(struct ata_port *ap, struct ata_device *adev)
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
