From: akpm@linux-foundation.org
Subject: [merged] page-allocator-do-not-disable-interrupts-in-free_page_mlock.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:34:09 -0700
Message-ID: <200906171834.n5HIY9B3032619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760026AbZFQSej (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:34:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, Lee.Schermerhorn@hp.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, penberg@cs.h


The patch titled
     page allocator: do not disable interrupts in free_page_mlock()
has been removed from the -mm tree.  Its filename was
     page-allocator-do-not-disable-interrupts-in-free_page_mlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: do not disable interrupts in free_page_mlock()
From: Mel Gorman <mel@csn.ul.ie>

free_page_mlock() tests and clears PG_mlocked using locked versions of the
bit operations.  If set, it disables interrupts to update counters and
this happens on every page free even though interrupts are disabled very
shortly afterwards a second time.  This is wasteful.

This patch splits what free_page_mlock() does.  The bit check is still
made.  However, the update of counters is delayed until the interrupts are
disabled and the non-lock version for clearing the bit is used.  One
potential weirdness with this split is that the counters do not get
updated if the bad_page() check is triggered but a system showing bad
pages is getting screwed already.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |   11 +++--------
 mm/page_alloc.c |    8 +++++++-
 2 files changed, 10 insertions(+), 9 deletions(-)

diff -puN mm/internal.h~page-allocator-do-not-disable-interrupts-in-free_page_mlock mm/internal.h
--- a/mm/internal.h~page-allocator-do-not-disable-interrupts-in-free_page_mlock
+++ a/mm/internal.h
@@ -157,14 +157,9 @@ static inline void mlock_migrate_page(st
  */
 static inline void free_page_mlock(struct page *page)
 {
-	if (unlikely(TestClearPageMlocked(page))) {
-		unsigned long flags;
-
-		local_irq_save(flags);
-		__dec_zone_page_state(page, NR_MLOCK);
-		__count_vm_event(UNEVICTABLE_MLOCKFREED);
-		local_irq_restore(flags);
-	}
+	__ClearPageMlocked(page);
+	__dec_zone_page_state(page, NR_MLOCK);
+	__count_vm_event(UNEVICTABLE_MLOCKFREED);
 }
 
 #else /* CONFIG_HAVE_MLOCKED_PAGE_BIT */
diff -puN mm/page_alloc.c~page-allocator-do-not-disable-interrupts-in-free_page_mlock mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-do-not-disable-interrupts-in-free_page_mlock
+++ a/mm/page_alloc.c
@@ -495,7 +495,6 @@ static inline void __free_one_page(struc
 
 static inline int free_pages_check(struct page *page)
 {
-	free_page_mlock(page);
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
 		(page_count(page) != 0)  |
@@ -552,6 +551,7 @@ static void __free_pages_ok(struct page 
 	unsigned long flags;
 	int i;
 	int bad = 0;
+	int clearMlocked = PageMlocked(page);
 
 	for (i = 0 ; i < (1 << order) ; ++i)
 		bad += free_pages_check(page + i);
@@ -567,6 +567,8 @@ static void __free_pages_ok(struct page 
 	kernel_map_pages(page, 1 << order, 0);
 
 	local_irq_save(flags);
+	if (unlikely(clearMlocked))
+		free_page_mlock(page);
 	__count_vm_events(PGFREE, 1 << order);
 	free_one_page(page_zone(page), page, order,
 					get_pageblock_migratetype(page));
@@ -1013,6 +1015,7 @@ static void free_hot_cold_page(struct pa
 	struct zone *zone = page_zone(page);
 	struct per_cpu_pages *pcp;
 	unsigned long flags;
+	int clearMlocked = PageMlocked(page);
 
 	if (PageAnon(page))
 		page->mapping = NULL;
@@ -1028,7 +1031,10 @@ static void free_hot_cold_page(struct pa
 
 	pcp = &zone_pcp(zone, get_cpu())->pcp;
 	local_irq_save(flags);
+	if (unlikely(clearMlocked))
+		free_page_mlock(page);
 	__count_vm_event(PGFREE);
+
 	if (cold)
 		list_add_tail(&page->lru, &pcp->list);
 	else
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
page_alloc-oops-when-setting-percpu_pagelist_fraction.patch
memcg-fix-lru-rotation-in-isolate_pages.patch
add-debugging-aid-for-memory-initialisation-problems.patch

