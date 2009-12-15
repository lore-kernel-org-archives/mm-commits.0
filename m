From: akpm@linux-foundation.org
Subject: [merged] vmalloc-adjust-gfp-mask-passed-on-nested-vmalloc-invocation.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:51:30 -0800
Message-ID: <200912152151.nBFLpUOr015104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51903 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761154AbZLOVwH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:52:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JBeulich@novell.com, hugh.dickins@tiscali.co.uk, jbeulich@novell.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     vmalloc(): adjust gfp mask passed on nested vmalloc() invocation
has been removed from the -mm tree.  Its filename was
     vmalloc-adjust-gfp-mask-passed-on-nested-vmalloc-invocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmalloc(): adjust gfp mask passed on nested vmalloc() invocation
From: "Jan Beulich" <JBeulich@novell.com>

- avoid wasting more precious resources (DMA or DMA32 pools), when
  being called through vmalloc_32{,_user}()
- explicitly allow using high memory here even if the outer allocation
  request doesn't allow it

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/vmalloc.c~vmalloc-adjust-gfp-mask-passed-on-nested-vmalloc-invocation mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-adjust-gfp-mask-passed-on-nested-vmalloc-invocation
+++ a/mm/vmalloc.c
@@ -1411,6 +1411,7 @@ static void *__vmalloc_area_node(struct 
 {
 	struct page **pages;
 	unsigned int nr_pages, array_size, i;
+	gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
 
 	nr_pages = (area->size - PAGE_SIZE) >> PAGE_SHIFT;
 	array_size = (nr_pages * sizeof(struct page *));
@@ -1418,13 +1419,11 @@ static void *__vmalloc_area_node(struct 
 	area->nr_pages = nr_pages;
 	/* Please note that the recursion is strictly bounded. */
 	if (array_size > PAGE_SIZE) {
-		pages = __vmalloc_node(array_size, 1, gfp_mask | __GFP_ZERO,
+		pages = __vmalloc_node(array_size, 1, nested_gfp|__GFP_HIGHMEM,
 				PAGE_KERNEL, node, caller);
 		area->flags |= VM_VPAGES;
 	} else {
-		pages = kmalloc_node(array_size,
-				(gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO,
-				node);
+		pages = kmalloc_node(array_size, nested_gfp, node);
 	}
 	area->pages = pages;
 	area->caller = caller;
_

Patches currently in -mm which might be from JBeulich@novell.com are

origin.patch
linux-next.patch
mm-vmallocc-dont-use-vmalloc_end.patch
fix-section-mismatch-in-early-ehci-dbgp.patch
dma-mapping-fix-off-by-one-error-in-dma_capable.patch

