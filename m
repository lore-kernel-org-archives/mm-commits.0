From: akpm@linux-foundation.org
Subject: - pata_serverworks-re-remove-crap-restore-cable-detect.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:58:05 -0800
Message-ID: <200703152158.l2FLw50f027697@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42456 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbXCOV6Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:58:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pata_serverworks: re-remove crap, restore cable detect
has been removed from the -mm tree.  Its filename was
     pata_serverworks-re-remove-crap-restore-cable-detect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_serverworks: re-remove crap, restore cable detect
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_serverworks.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff -puN drivers/ata/pata_serverworks.c~pata_serverworks-re-remove-crap-restore-cable-detect drivers/ata/pata_serverworks.c
--- a/drivers/ata/pata_serverworks.c~pata_serverworks-re-remove-crap-restore-cable-detect
+++ a/drivers/ata/pata_serverworks.c
@@ -1,5 +1,5 @@
 /*
- * ata-serverworks.c 	- Serverworks PATA for new ATA layer
+ * pata_serverworks.c 	- Serverworks PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
  *			  Alan Cox <alan@redhat.com>
  *
@@ -137,16 +137,14 @@ static struct sv_cable_table cable_detec
 };
 
 /**
- *	serverworks_pre_reset		-	cable detection
+ *	serverworks_cable_detect	-	cable detection
  *	@ap: ATA port
- *	@deadline: deadline jiffies for the operation
  *
  *	Perform cable detection according to the device and subvendor
  *	identifications
  */
 
-static int serverworks_pre_reset(struct ata_port *ap, unsigned long deadline)
-{
+static int serverworks_cable_detect(struct ata_port *ap) {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	struct sv_cable_table *cb = cable_detect;
 
@@ -154,8 +152,7 @@ static int serverworks_pre_reset(struct 
 		if (cb->device == pdev->device &&
 		    (cb->subvendor == pdev->subsystem_vendor ||
 		      cb->subvendor == PCI_ANY_ID)) {
-			ap->cbl = cb->cable_detect(ap);
-			return ata_std_prereset(ap, deadline);
+			return cb->cable_detect(ap);
 		}
 		cb++;
 	}
@@ -164,11 +161,6 @@ static int serverworks_pre_reset(struct 
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
@@ -341,8 +333,9 @@ static struct ata_port_operations server
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= serverworks_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= serverworks_cable_detect,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -376,8 +369,9 @@ static struct ata_port_operations server
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= serverworks_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= serverworks_cable_detect,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
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
