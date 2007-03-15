From: akpm@linux-foundation.org
Subject: - pata_cs5530-re-remove-all-the-crap-and-switch-back-to-the.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:57:31 -0800
Message-ID: <200703152157.l2FLvVeu027644@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42380 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbXCOV5n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:57:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pata_cs5530: re-remove all the crap and switch back to the cable method
has been removed from the -mm tree.  Its filename was
     pata_cs5530-re-remove-all-the-crap-and-switch-back-to-the.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_cs5530: re-remove all the crap and switch back to the cable method
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_cs5530.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff -puN drivers/ata/pata_cs5530.c~pata_cs5530-re-remove-all-the-crap-and-switch-back-to-the drivers/ata/pata_cs5530.c
--- a/drivers/ata/pata_cs5530.c~pata_cs5530-re-remove-all-the-crap-and-switch-back-to-the
+++ a/drivers/ata/pata_cs5530.c
@@ -160,18 +160,6 @@ static unsigned int cs5530_qc_issue_prot
 	return ata_qc_issue_prot(qc);
 }
 
-static int cs5530_pre_reset(struct ata_port *ap, unsigned long deadline)
-{
-	ap->cbl = ATA_CBL_PATA40;
-	return ata_std_prereset(ap, deadline);
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
@@ -213,8 +201,9 @@ static struct ata_port_operations cs5530
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= cs5530_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= cs5530_qc_issue_prot,
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
