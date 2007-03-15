From: akpm@linux-foundation.org
Subject: - pata_opti-restore-cable-method.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:57:59 -0800
Message-ID: <200703152157.l2FLvxX4027687@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42446 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbXCOV6S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:58:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pata_opti: restore cable method
has been removed from the -mm tree.  Its filename was
     pata_opti-restore-cable-method.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_opti: restore cable method
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_opti.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/ata/pata_opti.c~pata_opti-restore-cable-method drivers/ata/pata_opti.c
--- a/drivers/ata/pata_opti.c~pata_opti-restore-cable-method
+++ a/drivers/ata/pata_opti.c
@@ -34,7 +34,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_opti"
-#define DRV_VERSION "0.2.8"
+#define DRV_VERSION "0.2.9"
 
 enum {
 	READ_REG	= 0,	/* index of Read cycle timing register */
@@ -62,8 +62,6 @@ static int opti_pre_reset(struct ata_por
 
 	if (!pci_test_config_bits(pdev, &opti_enable_bits[ap->port_no]))
 		return -ENOENT;
-
-	ap->cbl = ATA_CBL_PATA40;
 	return ata_std_prereset(ap, deadline);
 }
 
@@ -199,6 +197,7 @@ static struct ata_port_operations opti_p
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= opti_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
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
