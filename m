From: akpm@linux-foundation.org
Subject: + page-allocator-do-not-disable-interrupts-in-free_page_mlock.patch added to -mm tree
Date: Thu, 23 Apr 2009 16:08:12 -0700
Message-ID: <200904232308.n3NN8CT7009742@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35082 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760661AbZDWXNa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 19:13:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, a.p.zijlstra@chello.nl, cl@linux-foundation.org, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, penberg@cs.helsinki.fi


The patch titled
     page allocator: do not disable interrupts in free_page_mlock()
has been added to the -mm tree.  Its filename is
     page-allocator-do-not-disable-interrupts-in-free_page_mlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -499,7 +499,6 @@ static inline void __free_one_page(struc
 
 static inline int free_pages_check(struct page *page)
 {
-	free_page_mlock(page);
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
 		(page_count(page) != 0)  |
@@ -556,6 +555,7 @@ static void __free_pages_ok(struct page 
 	unsigned long flags;
 	int i;
 	int bad = 0;
+	int clearMlocked = PageMlocked(page);
 
 	for (i = 0 ; i < (1 << order) ; ++i)
 		bad += free_pages_check(page + i);
@@ -571,6 +571,8 @@ static void __free_pages_ok(struct page 
 	kernel_map_pages(page, 1 << order, 0);
 
 	local_irq_save(flags);
+	if (unlikely(clearMlocked))
+		free_page_mlock(page);
 	__count_vm_events(PGFREE, 1 << order);
 	free_one_page(page_zone(page), page, order,
 					get_pageblock_migratetype(page));
@@ -1017,6 +1019,7 @@ static void free_hot_cold_page(struct pa
 	struct zone *zone = page_zone(page);
 	struct per_cpu_pages *pcp;
 	unsigned long flags;
+	int clearMlocked = PageMlocked(page);
 
 	if (PageAnon(page))
 		page->mapping = NULL;
@@ -1032,7 +1035,10 @@ static void free_hot_cold_page(struct pa
 
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

vmscan-low-order-lumpy-reclaim-also-should-use-pageout_io_sync.patch
page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid.patch
page-allocator-check-only-once-if-the-zonelist-is-suitable-for-the-allocation.patch
page-allocator-break-up-the-allocator-entry-point-into-fast-and-slow-paths.patch
page-allocator-move-check-for-disabled-anti-fragmentation-out-of-fastpath.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-calculate-the-migratetype-for-allocation-only-once.patch
page-allocator-calculate-the-alloc_flags-for-allocation-only-once.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
page-allocator-inline-__rmqueue_smallest.patch
page-allocator-inline-buffered_rmqueue.patch
page-allocator-inline-__rmqueue_fallback.patch
page-allocator-do-not-call-get_pageblock_migratetype-more-than-necessary.patch
page-allocator-do-not-disable-interrupts-in-free_page_mlock.patch
page-allocator-do-not-setup-zonelist-cache-when-there-is-only-one-node.patch
page-allocator-do-not-check-for-compound-pages-during-the-page-allocator-sanity-checks.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark.patch
page-allocator-update-nr_free_pages-only-as-necessary.patch
page-allocator-get-the-pageblock-migratetype-without-disabling-interrupts.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths.patch
page-allocator-slab-use-nr_online_nodes-to-check-for-a-numa-platform.patch
add-debugging-aid-for-memory-initialisation-problems.patch

