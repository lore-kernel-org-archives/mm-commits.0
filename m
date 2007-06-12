From: akpm@linux-foundation.org
Subject: - sata_promise-use-tf-interface-for-polling-nodata-commands.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:57:11 -0700
Message-ID: <200706121857.l5CIvBMB018451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50210 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753707AbXFLS5a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 14:57:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, jeff@garzik.org, mikpe@it.uu.se, mm-commits@vger.kernel.org


The patch titled
     sata_promise: use TF interface for polling NODATA commands
has been removed from the -mm tree.  Its filename was
     sata_promise-use-tf-interface-for-polling-nodata-commands.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sata_promise: use TF interface for polling NODATA commands
From: Tejun Heo <htejun@gmail.com>

sata_promise uses two different command modes - packet and TF.  Packet mode
is intelligent low-overhead mode while TF is the same old taskfile
interface.  As with other advanced interface (ahci/sil24),
ATA_TFLAG_POLLING has no effect in packet mode.  However, PIO commands are
issued using TF interface in polling mode, so pdc_interrupt() considers
interrupts spurious if ATA_TFLAG_POLLING is set.

This is broken for polling NODATA commands because command is issued using
packet mode but the interrupt handler ignores it due to ATA_TFLAG_POLLING. 
Fix pdc_qc_issue_prot() such that ATA/ATAPI NODATA commands are issued
using TF interface if ATA_TFLAG_POLLING is set.

This patch fixes detection failure introduced by polling SETXFERMODE.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Mikael Pettersson <mikpe@it.uu.se>
Acked-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_promise.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/ata/sata_promise.c~sata_promise-use-tf-interface-for-polling-nodata-commands drivers/ata/sata_promise.c
--- a/drivers/ata/sata_promise.c~sata_promise-use-tf-interface-for-polling-nodata-commands
+++ a/drivers/ata/sata_promise.c
@@ -784,9 +784,12 @@ static unsigned int pdc_qc_issue_prot(st
 		if (qc->dev->flags & ATA_DFLAG_CDB_INTR)
 			break;
 		/*FALLTHROUGH*/
+	case ATA_PROT_NODATA:
+		if (qc->tf.flags & ATA_TFLAG_POLLING)
+			break;
+		/*FALLTHROUGH*/
 	case ATA_PROT_ATAPI_DMA:
 	case ATA_PROT_DMA:
-	case ATA_PROT_NODATA:
 		pdc_packet_start(qc);
 		return 0;
 
@@ -800,7 +803,7 @@ static unsigned int pdc_qc_issue_prot(st
 static void pdc_tf_load_mmio(struct ata_port *ap, const struct ata_taskfile *tf)
 {
 	WARN_ON (tf->protocol == ATA_PROT_DMA ||
-		 tf->protocol == ATA_PROT_NODATA);
+		 tf->protocol == ATA_PROT_ATAPI_DMA);
 	ata_tf_load(ap, tf);
 }
 
@@ -808,7 +811,7 @@ static void pdc_tf_load_mmio(struct ata_
 static void pdc_exec_command_mmio(struct ata_port *ap, const struct ata_taskfile *tf)
 {
 	WARN_ON (tf->protocol == ATA_PROT_DMA ||
-		 tf->protocol == ATA_PROT_NODATA);
+		 tf->protocol == ATA_PROT_ATAPI_DMA);
 	ata_exec_command(ap, tf);
 }
 
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
git-libata-all.patch
pata_acpi-restore-driver.patch
libata-implement-ata_wait_after_reset.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
git-scsi-misc.patch
update-documentation-block-barriertxt.patch
block-drop-unnecessary-bvec-rewinding-from-flush_dry_bio_endio.patch
dma-mapping-prevent-dma-dependent-code-from-linking-on.patch
lib-add-idr_for_each.patch
lib-add-idr_for_each-fix.patch
lib-add-idr_remove_all.patch
