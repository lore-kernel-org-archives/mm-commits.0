From: akpm@linux-foundation.org
Subject: - drivers-scsi-lpfc-lpfc_scsic-kmalloc-memset-conversion-to-kzalloc.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:13:27 -0700
Message-ID: <200708201913.l7KJDRU4018442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52001 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754019AbXHTTVK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:21:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, James.Smart@Emulex.Com, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/lpfc/lpfc_scsi.c: kmalloc + memset conversion to kzalloc
has been removed from the -mm tree.  Its filename was
     drivers-scsi-lpfc-lpfc_scsic-kmalloc-memset-conversion-to-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/scsi/lpfc/lpfc_scsi.c: kmalloc + memset conversion to kzalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/lpfc/lpfc_scsi.c | 42769 -> 42721 (-48 bytes)
 drivers/scsi/lpfc/lpfc_scsi.o | 191332 -> 191240 (-92 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Acked-by: James Smart <James.Smart@Emulex.Com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/lpfc/lpfc_scsi.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/scsi/lpfc/lpfc_scsi.c~drivers-scsi-lpfc-lpfc_scsic-kmalloc-memset-conversion-to-kzalloc drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c~drivers-scsi-lpfc-lpfc_scsic-kmalloc-memset-conversion-to-kzalloc
+++ a/drivers/scsi/lpfc/lpfc_scsi.c
@@ -202,10 +202,9 @@ lpfc_new_scsi_buf(struct lpfc_vport *vpo
 	dma_addr_t pdma_phys;
 	uint16_t iotag;
 
-	psb = kmalloc(sizeof(struct lpfc_scsi_buf), GFP_KERNEL);
+	psb = kzalloc(sizeof(struct lpfc_scsi_buf), GFP_KERNEL);
 	if (!psb)
 		return NULL;
-	memset(psb, 0, sizeof (struct lpfc_scsi_buf));
 
 	/*
 	 * Get memory from the pci pool to map the virt space to pci bus space
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
git-alsa.patch
fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch
git-powerpc.patch
git-dvb.patch
drivers-input-serio-gscps2c-kmalloc-memset-conversion-to-kzalloc.patch
git-mmc.patch
drivers-mmc-core-busc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-hostc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-mmc_opsc-kmalloc-memset-conversion-to-kzalloc.patch
git-mtd.patch
mtd-add-module-license-to-mtdbdi.patch
git-netdev-all.patch
git-scsi-misc.patch
drivers-message-fusion-mptctlc-mostly-kmalloc-memset-conversion-to-kzalloc.patch
message-fusion-remove-redundant-memset.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
include-asm-m32r-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch
doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch
fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch
fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
