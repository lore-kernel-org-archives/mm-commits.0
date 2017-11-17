From: akpm@linux-foundation.org
Subject: [folded-merged] dma-debug-fix-incorrect-pfn-calculation-v4.patch
 removed from -mm tree
Date: Fri, 17 Nov 2017 15:09:34 -0800
Message-ID: <5a0f6c2e.SHC41xAPHJ1cSPp5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53464 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759870AbdKQXJg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:09:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miles.chen@mediatek.com, hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-debug-fix-incorrect-pfn-calculation-v4
has been removed from the -mm tree.  Its filename was
     dma-debug-fix-incorrect-pfn-calculation-v4.patch

This patch was dropped because it was folded into dma-debug-fix-incorrect-pfn-calculation.patch

------------------------------------------------------
From: Miles Chen <miles.chen@mediatek.com>
Subject: dma-debug-fix-incorrect-pfn-calculation-v4

Link: http://lkml.kernel.org/r/1510872972-23919-1-git-send-email-miles.chen@mediatek.com
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff -puN lib/dma-debug.c~dma-debug-fix-incorrect-pfn-calculation-v4 lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-fix-incorrect-pfn-calculation-v4
+++ a/lib/dma-debug.c
@@ -1495,15 +1495,22 @@ void debug_dma_alloc_coherent(struct dev
 	if (!entry)
 		return;
 
+	/* handle vmalloc and linear addresses */
+	if (!is_vmalloc_addr(virt) && !virt_to_page(virt))
+		return;
+
 	entry->type      = dma_debug_coherent;
 	entry->dev       = dev;
-	entry->pfn	 = is_vmalloc_addr(virt) ? vmalloc_to_pfn(virt) :
-						page_to_pfn(virt_to_page(virt));
 	entry->offset	 = offset_in_page(virt);
 	entry->size      = size;
 	entry->dev_addr  = dma_addr;
 	entry->direction = DMA_BIDIRECTIONAL;
 
+	if (is_vmalloc_addr(virt))
+		entry->pfn = vmalloc_to_pfn(virt);
+	else
+		entry->pfn = page_to_pfn(virt_to_page(virt));
+
 	add_dma_entry(entry);
 }
 EXPORT_SYMBOL(debug_dma_alloc_coherent);
@@ -1514,14 +1521,21 @@ void debug_dma_free_coherent(struct devi
 	struct dma_debug_entry ref = {
 		.type           = dma_debug_coherent,
 		.dev            = dev,
-		.pfn		= is_vmalloc_addr(virt) ? vmalloc_to_pfn(virt) :
-						page_to_pfn(virt_to_page(virt)),
 		.offset		= offset_in_page(virt),
 		.dev_addr       = addr,
 		.size           = size,
 		.direction      = DMA_BIDIRECTIONAL,
 	};
 
+	/* handle vmalloc and linear addresses */
+	if (!is_vmalloc_addr(virt) && !virt_to_page(virt))
+		return;
+
+	if (is_vmalloc_addr(virt))
+		ref.pfn = vmalloc_to_pfn(virt);
+	else
+		ref.pfn = page_to_pfn(virt_to_page(virt));
+
 	if (unlikely(dma_debug_disabled()))
 		return;
 
_

Patches currently in -mm which might be from miles.chen@mediatek.com are

dma-debug-fix-incorrect-pfn-calculation.patch
checkpatch-support-function-pointers-for-unnamed-function-definition-arguments.patch

