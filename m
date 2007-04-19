From: akpm@linux-foundation.org
Subject: - pata_cypress-re-remove-all-the-crap-and-switch-back-to.patch removed from -mm tree
Date: Thu, 19 Apr 2007 13:02:26 -0700
Message-ID: <200704192002.l3JK2QTe029385@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766992AbXDSUCl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 16:02:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pata_cypress: re-remove all the crap and switch back to cable method
has been removed from the -mm tree.  Its filename was
     pata_cypress-re-remove-all-the-crap-and-switch-back-to.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_cypress: re-remove all the crap and switch back to cable method
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_cypress.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff -puN drivers/ata/pata_cypress.c~pata_cypress-re-remove-all-the-crap-and-switch-back-to drivers/ata/pata_cypress.c
--- a/drivers/ata/pata_cypress.c~pata_cypress-re-remove-all-the-crap-and-switch-back-to
+++ a/drivers/ata/pata_cypress.c
@@ -41,17 +41,6 @@ enum {
 	CY82_INDEX_TIMEOUT	= 0x32
 };
 
-static int cy82c693_pre_reset(struct ata_port *ap, unsigned long deadline)
-{
-	ap->cbl = ATA_CBL_PATA40;
-	return ata_std_prereset(ap, deadline);
-}
-
-static void cy82c693_error_handler(struct ata_port *ap)
-{
-	ata_bmdma_drive_eh(ap, cy82c693_pre_reset, ata_std_softreset, NULL, ata_std_postreset);
-}
-
 /**
  *	cy82c693_set_piomode	-	set initial PIO mode data
  *	@ap: ATA interface
@@ -156,8 +145,9 @@ static struct ata_port_operations cy82c6
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= cy82c693_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
_

Patches currently in -mm which might be from alan@redhat.com are

origin.patch
git-libata-all.patch
libata-acpi-add-infrastructure-for-drivers-to-use.patch
libata-acpi-add-infrastructure-for-drivers-to-use-fix.patch
pata_acpi-restore-driver.patch
pata_acpi-restore-driver-fix.patch
pata_acpi-restore-driver-fix-2.patch
pata_hpt37x-further-small-fixes.patch
pata_hpt3x2n-add-hpt371n-support-and-other-bits.patch
spin_lock_unlocked-cleanup-in-drivers-ata-pata_winbondc.patch
pcmcia-irq-probe-can-be-done-without-risking-an-irq-storm.patch
pci_module_init-convertion-in-tmscsimc.patch
tty-clarify-documentation-of-write.patch
tty-i386-x86_64-arbitary-speed-support.patch
apm-fix-incorrect-comment.patch
revoke-special-mmap-handling.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
