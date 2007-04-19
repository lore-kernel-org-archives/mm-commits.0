From: akpm@linux-foundation.org
Subject: - ata_generic-remove-all-the-crud-again-and-use-cable.patch removed from -mm tree
Date: Thu, 19 Apr 2007 13:02:24 -0700
Message-ID: <200704192002.l3JK2Odk029382@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767012AbXDSUGN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 16:06:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ata_generic: remove all the crud again and use cable methods
has been removed from the -mm tree.  Its filename was
     ata_generic-remove-all-the-crud-again-and-use-cable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ata_generic: remove all the crud again and use cable methods
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ata_generic.c |   33 ++-------------------------------
 1 file changed, 2 insertions(+), 31 deletions(-)

diff -puN drivers/ata/ata_generic.c~ata_generic-remove-all-the-crud-again-and-use-cable drivers/ata/ata_generic.c
--- a/drivers/ata/ata_generic.c~ata_generic-remove-all-the-crud-again-and-use-cable
+++ a/drivers/ata/ata_generic.c
@@ -33,36 +33,6 @@
  */
 
 /**
- *	generic_pre_reset		-	probe begin
- *	@ap: ATA port
- *	@deadline: deadline jiffies for the operation
- *
- *	Set up cable type and use generic probe init
- */
-
-static int generic_pre_reset(struct ata_port *ap, unsigned long deadline)
-{
-	ap->cbl = ATA_CBL_PATA80;
-	return ata_std_prereset(ap, deadline);
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
@@ -145,8 +115,9 @@ static struct ata_port_operations generi
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= generic_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_unknown,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
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
