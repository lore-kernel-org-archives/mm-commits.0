From: akpm@osdl.org
Subject: - scsi-lpfc-error-path-fix.patch removed from -mm tree
Date: Sun, 07 Jan 2007 00:01:00 -0800
Message-ID: <200701070801.l07810rS013240@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41120 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932502AbXAGIBJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 03:01:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, James.Bottomley@steeleye.com, James.Smart@Emulex.Com, mm-commits@vger.kernel.org


The patch titled
     scsi: lpfc error path fix
has been removed from the -mm tree.  Its filename was
     scsi-lpfc-error-path-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: scsi: lpfc error path fix
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Add kmalloc failure check and fix the loop on error path.  Without the
patch pool element at index [0] will not be freed.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: <james.smart@emulex.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/lpfc/lpfc_mem.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/lpfc/lpfc_mem.c~scsi-lpfc-error-path-fix drivers/scsi/lpfc/lpfc_mem.c
--- a/drivers/scsi/lpfc/lpfc_mem.c~scsi-lpfc-error-path-fix
+++ a/drivers/scsi/lpfc/lpfc_mem.c
@@ -56,6 +56,9 @@ lpfc_mem_alloc(struct lpfc_hba * phba)
 
 	pool->elements = kmalloc(sizeof(struct lpfc_dmabuf) *
 					 LPFC_MBUF_POOL_SIZE, GFP_KERNEL);
+	if (!pool->elements)
+		goto fail_free_lpfc_mbuf_pool;
+
 	pool->max_count = 0;
 	pool->current_count = 0;
 	for ( i = 0; i < LPFC_MBUF_POOL_SIZE; i++) {
@@ -82,10 +85,11 @@ lpfc_mem_alloc(struct lpfc_hba * phba)
  fail_free_mbox_pool:
 	mempool_destroy(phba->mbox_mem_pool);
  fail_free_mbuf_pool:
-	while (--i)
+	while (i--)
 		pci_pool_free(phba->lpfc_mbuf_pool, pool->elements[i].virt,
 						 pool->elements[i].phys);
 	kfree(pool->elements);
+ fail_free_lpfc_mbuf_pool:
 	pci_pool_destroy(phba->lpfc_mbuf_pool);
  fail_free_dma_buf_pool:
 	pci_pool_destroy(phba->lpfc_scsi_dma_buf_pool);
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

ppc-cs4218_tdm-remove-extra-brace.patch
mips-dbg_io-stray-brackets-fix.patch
git-mtd.patch
net-ifb-error-path-loop-fix.patch
git-scsi-rc-fixes.patch
scsi-sic7xxx-stray-bracket-fix.patch
scsi-53c7xx-brackets-fix.patch
usb-usbmixer-error-path-fix.patch
