From: akpm@linux-foundation.org
Subject: [merged] ib-mthca-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch removed from -mm tree
Date: Wed, 24 Jun 2009 12:10:57 -0700
Message-ID: <200906241910.n5OJAv2R011144@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758480AbZFXTLT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 15:11:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     IB/mthca: replace dma_sync_single with dma_sync_single_for_cpu
has been removed from the -mm tree.  Its filename was
     ib-mthca-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: IB/mthca: replace dma_sync_single with dma_sync_single_for_cpu
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This replaces dma_sync_single() with dma_sync_single_for_cpu() because
dma_sync_single() is an obsolete API; include/linux/dma-mapping.h says:

/* Backwards compat, remove in 2.7.x */
#define dma_sync_single		dma_sync_single_for_cpu
#define dma_sync_sg		dma_sync_sg_for_cpu

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/mthca/mthca_mr.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/infiniband/hw/mthca/mthca_mr.c~ib-mthca-replace-dma_sync_single-with-dma_sync_single_for_cpu drivers/infiniband/hw/mthca/mthca_mr.c
--- a/drivers/infiniband/hw/mthca/mthca_mr.c~ib-mthca-replace-dma_sync_single-with-dma_sync_single_for_cpu
+++ a/drivers/infiniband/hw/mthca/mthca_mr.c
@@ -355,7 +355,8 @@ static void mthca_arbel_write_mtt_seg(st
 	for (i = 0; i < list_len; ++i)
 		mtts[i] = cpu_to_be64(buffer_list[i] | MTHCA_MTT_FLAG_PRESENT);
 
-	dma_sync_single(&dev->pdev->dev, dma_handle, list_len * sizeof (u64), DMA_TO_DEVICE);
+	dma_sync_single_for_cpu(&dev->pdev->dev, dma_handle,
+				list_len * sizeof (u64), DMA_TO_DEVICE);
 }
 
 int mthca_write_mtt(struct mthca_dev *dev, struct mthca_mtt *mtt,
@@ -807,8 +808,8 @@ int mthca_arbel_map_phys_fmr(struct ib_f
 		fmr->mem.arbel.mtts[i] = cpu_to_be64(page_list[i] |
 						     MTHCA_MTT_FLAG_PRESENT);
 
-	dma_sync_single(&dev->pdev->dev, fmr->mem.arbel.dma_handle,
-			list_len * sizeof(u64), DMA_TO_DEVICE);
+	dma_sync_single_for_cpu(&dev->pdev->dev, fmr->mem.arbel.dma_handle,
+				list_len * sizeof(u64), DMA_TO_DEVICE);
 
 	fmr->mem.arbel.mpt->key    = cpu_to_be32(key);
 	fmr->mem.arbel.mpt->lkey   = cpu_to_be32(key);
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch

