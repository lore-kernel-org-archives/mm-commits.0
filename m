From: akpm@linux-foundation.org
Subject: [patch 03/94] lib/dma-debug.c: fix incorrect pfn
 calculation
Date: Fri, 17 Nov 2017 15:26:19 -0800
Message-ID: <20171117232619.br_QxkUxL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55170 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423240AbdKQX0V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:26:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hch@lst.de, m.szyprowski@samsung.com, miles.chen@mediatek.com, mm-commits@vger.kernel.org, robin.murphy@arm.com, torvalds@linux-foundation.org

From: Miles Chen <miles.chen@mediatek.com>
Subject: lib/dma-debug.c: fix incorrect pfn calculation

dma-debug reports the following warning:

[name:panic&]WARNING: CPU: 3 PID: 298 at kernel-4.4/lib/dma-debug.c:604
debug _dma_assert_idle+0x1a8/0x230()
DMA-API: cpu touching an active dma mapped cacheline [cln=0x00000882300]
CPU: 3 PID: 298 Comm: vold Tainted: G        W  O    4.4.22+ #1
Hardware name: MT6739 (DT)
Call trace:
[<ffffff800808acd0>] dump_backtrace+0x0/0x1d4
[<ffffff800808affc>] show_stack+0x14/0x1c
[<ffffff800838019c>] dump_stack+0xa8/0xe0
[<ffffff80080a0594>] warn_slowpath_common+0xf4/0x11c
[<ffffff80080a061c>] warn_slowpath_fmt+0x60/0x80
[<ffffff80083afe24>] debug_dma_assert_idle+0x1a8/0x230
[<ffffff80081dca9c>] wp_page_copy.isra.96+0x118/0x520
[<ffffff80081de114>] do_wp_page+0x4fc/0x534
[<ffffff80081e0a14>] handle_mm_fault+0xd4c/0x1310
[<ffffff8008098798>] do_page_fault+0x1c8/0x394
[<ffffff800808231c>] do_mem_abort+0x50/0xec

I found that debug_dma_alloc_coherent() and debug_dma_free_coherent()
assume that dma_alloc_coherent() always returns a linear address.  However
it's possible that dma_alloc_coherent() returns a non-linear address.  In
this case, page_to_pfn(virt_to_page(virt)) will return an incorrect pfn. 
If the pfn is valid and mapped as a COW page, we will hit the warning when
doing wp_page_copy().

Fix this by calculating pfn for linear and non-linear addresses.

[miles.chen@mediatek.com: v4]
  Link: http://lkml.kernel.org/r/1510872972-23919-1-git-send-email-miles.chen@mediatek.com
Link: http://lkml.kernel.org/r/1506484087-1177-1-git-send-email-miles.chen@mediatek.com
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff -puN lib/dma-debug.c~dma-debug-fix-incorrect-pfn-calculation lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-fix-incorrect-pfn-calculation
+++ a/lib/dma-debug.c
@@ -1495,14 +1495,22 @@ void debug_dma_alloc_coherent(struct dev
 	if (!entry)
 		return;
 
+	/* handle vmalloc and linear addresses */
+	if (!is_vmalloc_addr(virt) && !virt_to_page(virt))
+		return;
+
 	entry->type      = dma_debug_coherent;
 	entry->dev       = dev;
-	entry->pfn	 = page_to_pfn(virt_to_page(virt));
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
@@ -1513,13 +1521,21 @@ void debug_dma_free_coherent(struct devi
 	struct dma_debug_entry ref = {
 		.type           = dma_debug_coherent,
 		.dev            = dev,
-		.pfn		= page_to_pfn(virt_to_page(virt)),
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
