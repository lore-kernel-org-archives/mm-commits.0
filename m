From: akpm@linux-foundation.org
Subject: - pata_sil680-restore-cable-detect-methods.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:58:07 -0800
Message-ID: <200703152158.l2FLw7kM027700@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42450 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbXCOV6V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:58:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pata_sil680: restore cable detect methods
has been removed from the -mm tree.  Its filename was
     pata_sil680-restore-cable-detect-methods.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_sil680: restore cable detect methods
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_sil680.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN drivers/ata/pata_sil680.c~pata_sil680-restore-cable-detect-methods drivers/ata/pata_sil680.c
--- a/drivers/ata/pata_sil680.c~pata_sil680-restore-cable-detect-methods
+++ a/drivers/ata/pata_sil680.c
@@ -33,7 +33,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_sil680"
-#define DRV_VERSION "0.4.5"
+#define DRV_VERSION "0.4.6"
 
 /**
  *	sil680_selreg		-	return register base
@@ -91,22 +91,16 @@ static int sil680_cable_detect(struct at
 		return ATA_CBL_PATA40;
 }
 
-static int sil680_pre_reset(struct ata_port *ap, unsigned long deadline)
-{
-	ap->cbl = sil680_cable_detect(ap);
-	return ata_std_prereset(ap, deadline);
-}
-
 /**
  *	sil680_bus_reset	-	reset the SIL680 bus
  *	@ap: ATA port to reset
+*	@classes:
  *	@deadline: deadline jiffies for the operation
  *
  *	Perform the SIL680 housekeeping when doing an ATA bus reset
  */
 
-static int sil680_bus_reset(struct ata_port *ap,unsigned int *classes,
-			    unsigned long deadline)
+static int sil680_bus_reset(struct ata_port *ap, unsigned int *classes, unsigned long deadline)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	unsigned long addr = sil680_selreg(ap, 0);
@@ -121,7 +115,7 @@ static int sil680_bus_reset(struct ata_p
 
 static void sil680_error_handler(struct ata_port *ap)
 {
-	ata_bmdma_drive_eh(ap, sil680_pre_reset, sil680_bus_reset, NULL, ata_std_postreset);
+	ata_bmdma_drive_eh(ap, ata_std_prereset, sil680_bus_reset, NULL, ata_std_postreset);
 }
 
 /**
@@ -259,6 +253,7 @@ static struct ata_port_operations sil680
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= sil680_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= sil680_cable_detect,
 
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
