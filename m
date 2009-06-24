From: akpm@linux-foundation.org
Subject: [merged] txx9dmac-use-dma_unmap_single-if-dma_compl_srcdest_unmap_single-was-set.patch removed from -mm tree
Date: Wed, 24 Jun 2009 12:11:01 -0700
Message-ID: <200906241911.n5OJB1AL011319@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758155AbZFXTLQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 15:11:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, dan.j.williams@intel.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     txx9dmac: use dma_unmap_single if DMA_COMPL_{SRC,DEST}_UNMAP_SINGLE was set
has been removed from the -mm tree.  Its filename was
     txx9dmac-use-dma_unmap_single-if-dma_compl_srcdest_unmap_single-was-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: txx9dmac: use dma_unmap_single if DMA_COMPL_{SRC,DEST}_UNMAP_SINGLE was set
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

This patch does not change actual behaviour since dma_unmap_page is just
an alias of dma_unmap_single on MIPS.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/txx9dmac.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN drivers/dma/txx9dmac.c~txx9dmac-use-dma_unmap_single-if-dma_compl_srcdest_unmap_single-was-set drivers/dma/txx9dmac.c
--- a/drivers/dma/txx9dmac.c~txx9dmac-use-dma_unmap_single-if-dma_compl_srcdest_unmap_single-was-set
+++ a/drivers/dma/txx9dmac.c
@@ -432,23 +432,27 @@ txx9dmac_descriptor_complete(struct txx9
 	list_splice_init(&txd->tx_list, &dc->free_list);
 	list_move(&desc->desc_node, &dc->free_list);
 
-	/*
-	 * We use dma_unmap_page() regardless of how the buffers were
-	 * mapped before they were submitted...
-	 */
 	if (!ds) {
 		dma_addr_t dmaaddr;
 		if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
 			dmaaddr = is_dmac64(dc) ?
 				desc->hwdesc.DAR : desc->hwdesc32.DAR;
-			dma_unmap_page(chan2parent(&dc->chan), dmaaddr,
-				       desc->len, DMA_FROM_DEVICE);
+			if (txd->flags & DMA_COMPL_DEST_UNMAP_SINGLE)
+				dma_unmap_single(chan2parent(&dc->chan),
+					dmaaddr, desc->len, DMA_FROM_DEVICE);
+			else
+				dma_unmap_page(chan2parent(&dc->chan),
+					dmaaddr, desc->len, DMA_FROM_DEVICE);
 		}
 		if (!(txd->flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
 			dmaaddr = is_dmac64(dc) ?
 				desc->hwdesc.SAR : desc->hwdesc32.SAR;
-			dma_unmap_page(chan2parent(&dc->chan), dmaaddr,
-				       desc->len, DMA_TO_DEVICE);
+			if (txd->flags & DMA_COMPL_SRC_UNMAP_SINGLE)
+				dma_unmap_single(chan2parent(&dc->chan),
+					dmaaddr, desc->len, DMA_TO_DEVICE);
+			else
+				dma_unmap_page(chan2parent(&dc->chan),
+					dmaaddr, desc->len, DMA_TO_DEVICE);
 		}
 	}
 
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
linux-next.patch
serial_txx9-use-container_of-instead-of-direct-cast.patch

