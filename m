From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-rename-_count-field-of-the-struct-page-to-_refcount-fix6.patch removed
 from -mm tree
Date: Thu, 19 May 2016 16:42:42 -0700
Message-ID: <573e4f72.Ac5LDFR7ypN5fOny%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbcESXmn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 19:42:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, davem@davemloft.net, iamjoonsoo.kim@lge.com, manish.chopra@qlogic.com, saeedm@mellanox.com, tariqt@mellanox.com, yuval.mintz@qlogic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rename-_count-field-of-the-struct-page-to-_refcount-fix6
has been removed from the -mm tree.  Its filename was
     mm-rename-_count-field-of-the-struct-page-to-_refcount-fix6.patch

This patch was dropped because it was folded into mm-rename-_count-field-of-the-struct-page-to-_refcount.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: mm-rename-_count-field-of-the-struct-page-to-_refcount-fix6

sync ethernet driver changes with -mm's
mm-rename-_count-field-of-the-struct-page-to-_refcount.patch

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Manish Chopra <manish.chopra@qlogic.com>
Cc: Yuval Mintz <yuval.mintz@qlogic.com>
Cc: Tariq Toukan <tariqt@mellanox.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c |   20 +++++++-------
 drivers/net/ethernet/qlogic/qede/qede_main.c    |    4 +-
 2 files changed, 12 insertions(+), 12 deletions(-)

diff -puN drivers/net/ethernet/mellanox/mlx5/core/en_rx.c~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix6 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix6
+++ a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -433,8 +433,8 @@ static int mlx5e_alloc_rx_fragmented_mpw
 	for (i = 0; i < MLX5_MPWRQ_PAGES_PER_WQE; i++) {
 		if (unlikely(mlx5e_alloc_and_map_page(rq, wi, i)))
 			goto err_unmap;
-		atomic_add(mlx5e_mpwqe_strides_per_page(rq),
-			   &wi->umr.dma_info[i].page->_count);
+		page_ref_add(wi->umr.dma_info[i].page,
+			     mlx5e_mpwqe_strides_per_page(rq));
 		wi->skbs_frags[i] = 0;
 	}
 
@@ -452,8 +452,8 @@ err_unmap:
 	while (--i >= 0) {
 		dma_unmap_page(rq->pdev, wi->umr.dma_info[i].addr, PAGE_SIZE,
 			       PCI_DMA_FROMDEVICE);
-		atomic_sub(mlx5e_mpwqe_strides_per_page(rq),
-			   &wi->umr.dma_info[i].page->_count);
+		page_ref_sub(wi->umr.dma_info[i].page,
+			     mlx5e_mpwqe_strides_per_page(rq));
 		put_page(wi->umr.dma_info[i].page);
 	}
 	dma_unmap_single(rq->pdev, wi->umr.mtt_addr, mtt_sz, PCI_DMA_TODEVICE);
@@ -477,8 +477,8 @@ void mlx5e_free_rx_fragmented_mpwqe(stru
 	for (i = 0; i < MLX5_MPWRQ_PAGES_PER_WQE; i++) {
 		dma_unmap_page(rq->pdev, wi->umr.dma_info[i].addr, PAGE_SIZE,
 			       PCI_DMA_FROMDEVICE);
-		atomic_sub(mlx5e_mpwqe_strides_per_page(rq) - wi->skbs_frags[i],
-			   &wi->umr.dma_info[i].page->_count);
+		page_ref_sub(wi->umr.dma_info[i].page,
+			mlx5e_mpwqe_strides_per_page(rq) - wi->skbs_frags[i]);
 		put_page(wi->umr.dma_info[i].page);
 	}
 	dma_unmap_single(rq->pdev, wi->umr.mtt_addr, mtt_sz, PCI_DMA_TODEVICE);
@@ -527,8 +527,8 @@ static int mlx5e_alloc_rx_linear_mpwqe(s
 	 */
 	split_page(wi->dma_info.page, MLX5_MPWRQ_WQE_PAGE_ORDER);
 	for (i = 0; i < MLX5_MPWRQ_PAGES_PER_WQE; i++) {
-		atomic_add(mlx5e_mpwqe_strides_per_page(rq),
-			   &wi->dma_info.page[i]._count);
+		page_ref_add(&wi->dma_info.page[i],
+			     mlx5e_mpwqe_strides_per_page(rq));
 		wi->skbs_frags[i] = 0;
 	}
 
@@ -551,8 +551,8 @@ void mlx5e_free_rx_linear_mpwqe(struct m
 	dma_unmap_page(rq->pdev, wi->dma_info.addr, rq->wqe_sz,
 		       PCI_DMA_FROMDEVICE);
 	for (i = 0; i < MLX5_MPWRQ_PAGES_PER_WQE; i++) {
-		atomic_sub(mlx5e_mpwqe_strides_per_page(rq) - wi->skbs_frags[i],
-			   &wi->dma_info.page[i]._count);
+		page_ref_sub(&wi->dma_info.page[i],
+			mlx5e_mpwqe_strides_per_page(rq) - wi->skbs_frags[i]);
 		put_page(&wi->dma_info.page[i]);
 	}
 }
diff -puN drivers/net/ethernet/qlogic/qede/qede_main.c~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix6 drivers/net/ethernet/qlogic/qede/qede_main.c
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix6
+++ a/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1036,7 +1036,7 @@ static int qede_fill_frag_skb(struct qed
 		/* Incr page ref count to reuse on allocation failure
 		 * so that it doesn't get freed while freeing SKB.
 		 */
-		atomic_inc(&current_bd->data->_count);
+		page_ref_inc(current_bd->data);
 		goto out;
 	}
 
@@ -1487,7 +1487,7 @@ static int qede_rx_int(struct qede_fastp
 				 * freeing SKB.
 				 */
 
-				atomic_inc(&sw_rx_data->data->_count);
+				page_ref_inc(sw_rx_data->data);
 				rxq->rx_alloc_errors++;
 				qede_recycle_rx_bd_ring(rxq, edev,
 							fp_cqe->bd_num);
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-rename-_count-field-of-the-struct-page-to-_refcount.patch

