From: akpm@linux-foundation.org
Subject: [merged] page-allocator-get-the-pageblock-migratetype-without-disabling-interrupts.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:34:23 -0700
Message-ID: <200906171834.n5HIYNa5000451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760038AbZFQSev (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:34:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, Lee.Schermerhorn@hp.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, penberg@cs.h


The patch titled
     page allocator: get the pageblock migratetype without disabling interrupts
has been removed from the -mm tree.  Its filename was
     page-allocator-get-the-pageblock-migratetype-without-disabling-interrupts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: get the pageblock migratetype without disabling interrupts
From: Mel Gorman <mel@csn.ul.ie>

Local interrupts are disabled when freeing pages to the PCP list.  Part of
that free checks what the migratetype of the pageblock the page is in but
it checks this with interrupts disabled and interupts should never be
disabled longer than necessary.  This patch checks the pagetype with
interrupts enabled with the impact that it is possible a page is freed to
the wrong list when a pageblock changes type.  As that block is now
already considered mixed from an anti-fragmentation perspective, it's not
of vital importance.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~page-allocator-get-the-pageblock-migratetype-without-disabling-interrupts mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-get-the-pageblock-migratetype-without-disabling-interrupts
+++ a/mm/page_alloc.c
@@ -1030,6 +1030,7 @@ static void free_hot_cold_page(struct pa
 	kernel_map_pages(page, 1, 0);
 
 	pcp = &zone_pcp(zone, get_cpu())->pcp;
+	set_page_private(page, get_pageblock_migratetype(page));
 	local_irq_save(flags);
 	if (unlikely(clearMlocked))
 		free_page_mlock(page);
@@ -1039,7 +1040,6 @@ static void free_hot_cold_page(struct pa
 		list_add_tail(&page->lru, &pcp->list);
 	else
 		list_add(&page->lru, &pcp->list);
-	set_page_private(page, get_pageblock_migratetype(page));
 	pcp->count++;
 	if (pcp->count >= pcp->high) {
 		free_pages_bulk(zone, pcp->batch, &pcp->list, 0);
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
page_alloc-oops-when-setting-percpu_pagelist_fraction.patch
memcg-fix-lru-rotation-in-isolate_pages.patch
add-debugging-aid-for-memory-initialisation-problems.patch

