From: akpm@linux-foundation.org
Subject: - pata_netcell-re-remove-all-the-crud.patch removed from -mm tree
Date: Wed, 04 Apr 2007 19:00:08 -0700
Message-ID: <200704050200.l352084P004792@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38002 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017AbXDECAQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 4 Apr 2007 22:00:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pata_netcell: re-remove all the crud
has been removed from the -mm tree.  Its filename was
     pata_netcell-re-remove-all-the-crud.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_netcell: re-remove all the crud
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_netcell.c |   31 +++----------------------------
 1 file changed, 3 insertions(+), 28 deletions(-)

diff -puN drivers/ata/pata_netcell.c~pata_netcell-re-remove-all-the-crud drivers/ata/pata_netcell.c
--- a/drivers/ata/pata_netcell.c~pata_netcell-re-remove-all-the-crud
+++ a/drivers/ata/pata_netcell.c
@@ -16,33 +16,7 @@
 #include <linux/ata.h>
 
 #define DRV_NAME	"pata_netcell"
-#define DRV_VERSION	"0.1.6"
-
-/**
- *	netcell_probe_init	-	check for 40/80 pin
- *	@ap: Port
- *
- *	Cables are handled by the RAID controller. Report 80 pin.
- */
-
-static int netcell_pre_reset(struct ata_port *ap)
-{
-	ap->cbl = ATA_CBL_PATA80;
-	return ata_std_prereset(ap);
-}
-
-/**
- *	netcell_probe_reset - Probe specified port on PATA host controller
- *	@ap: Port to probe
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void netcell_error_handler(struct ata_port *ap)
-{
-	return ata_bmdma_drive_eh(ap, netcell_pre_reset, ata_std_softreset, NULL, ata_std_postreset);
-}
+#define DRV_VERSION	"0.1.7"
 
 /* No PIO or DMA methods needed for this device */
 
@@ -81,8 +55,9 @@ static const struct ata_port_operations 
 
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
-	.error_handler		= netcell_error_handler,
+	.error_handler		= ata_bmdma_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.cable_detect		= ata_cable_80wire,
 
 	/* BMDMA handling is PCI ATA format, use helpers */
 	.bmdma_setup		= ata_bmdma_setup,
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
