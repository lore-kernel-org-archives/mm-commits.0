From: akpm@linux-foundation.org
Subject: + dma-debug-fix-incorrect-pfn-calculation.patch added to -mm tree
Date: Wed, 27 Sep 2017 12:57:19 -0700
Message-ID: <59cc029f.eWo8/dfC7HQDoMc6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56688 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751136AbdI0T5U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2017 15:57:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miles.chen@mediatek.com, hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/dma-debug.c: fix incorrect pfn calculation
has been added to the -mm tree.  Its filename is
     dma-debug-fix-incorrect-pfn-calculation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-debug-fix-incorrect-pfn-calculation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-debug-fix-incorrect-pfn-calculation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Link: http://lkml.kernel.org/r/1506484087-1177-1-git-send-email-miles.chen@mediatek.com
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN lib/dma-debug.c~dma-debug-fix-incorrect-pfn-calculation lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-fix-incorrect-pfn-calculation
+++ a/lib/dma-debug.c
@@ -1497,7 +1497,8 @@ void debug_dma_alloc_coherent(struct dev
 
 	entry->type      = dma_debug_coherent;
 	entry->dev       = dev;
-	entry->pfn	 = page_to_pfn(virt_to_page(virt));
+	entry->pfn	 = is_vmalloc_addr(virt) ? vmalloc_to_pfn(virt) :
+						page_to_pfn(virt_to_page(virt));
 	entry->offset	 = offset_in_page(virt);
 	entry->size      = size;
 	entry->dev_addr  = dma_addr;
@@ -1513,7 +1514,8 @@ void debug_dma_free_coherent(struct devi
 	struct dma_debug_entry ref = {
 		.type           = dma_debug_coherent,
 		.dev            = dev,
-		.pfn		= page_to_pfn(virt_to_page(virt)),
+		.pfn		= is_vmalloc_addr(virt) ? vmalloc_to_pfn(virt) :
+						page_to_pfn(virt_to_page(virt)),
 		.offset		= offset_in_page(virt),
 		.dev_addr       = addr,
 		.size           = size,
_

Patches currently in -mm which might be from miles.chen@mediatek.com are

dma-debug-fix-incorrect-pfn-calculation.patch
checkpatch-support-function-pointers-for-unnamed-function-definition-arguments.patch

