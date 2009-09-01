From: akpm@linux-foundation.org
Subject: + page-allocator-maintain-rolling-count-of-pages-to-free-from-the-pcp.patch added to -mm tree
Date: Tue, 01 Sep 2009 14:14:45 -0700
Message-ID: <200909012114.n81LEkJY013272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755212AbZIAVPu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Sep 2009 17:15:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, cl@linux-foundation.org, minchan.kim@gmail.com, npiggin@suse.de, penberg@cs.helsinki.fi


The patch titled
     page-allocator: maintain rolling count of pages to free from the PCP
has been added to the -mm tree.  Its filename is
     page-allocator-maintain-rolling-count-of-pages-to-free-from-the-pcp.patch

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
Subject: page-allocator: maintain rolling count of pages to free from the PCP
From: Mel Gorman <mel@csn.ul.ie>

When round-robin freeing pages from the PCP lists, empty lists may be
encountered.  In the event one of the lists has more pages than another,
there may be numerous checks for list_empty() which is undesirable.  This
patch maintains a count of pages to free which is incremented when empty
lists are encountered.  The intention is that more pages will then be
freed from fuller lists than the empty ones reducing the number of empty
list checks in the free path.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc:  Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff -puN mm/page_alloc.c~page-allocator-maintain-rolling-count-of-pages-to-free-from-the-pcp mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-maintain-rolling-count-of-pages-to-free-from-the-pcp
+++ a/mm/page_alloc.c
@@ -536,32 +536,37 @@ static void free_pcppages_bulk(struct zo
 					struct per_cpu_pages *pcp)
 {
 	int migratetype = 0;
+	int batch_free = 0;
 
 	spin_lock(&zone->lock);
 	zone_clear_flag(zone, ZONE_ALL_UNRECLAIMABLE);
 	zone->pages_scanned = 0;
 
 	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
-	while (count--) {
+	while (count) {
 		struct page *page;
 		struct list_head *list;
 
 		/*
-		 * Remove pages from lists in a round-robin fashion. This spinning
-		 * around potentially empty lists is bloody awful, alternatives that
-		 * don't suck are welcome
+		 * Remove pages from lists in a round-robin fashion. A batch_free
+		 * count is maintained that is incremented when an empty list is
+		 * encountered. This is so more pages are freed off fuller lists
+		 * instead of spinning excessively around empty lists
 		 */
 		do {
+			batch_free++;
 			if (++migratetype == MIGRATE_PCPTYPES)
 				migratetype = 0;
 			list = &pcp->lists[migratetype];
 		} while (list_empty(list));
 
-		page = list_entry(list->prev, struct page, lru);
-		/* have to delete it as __free_one_page list manipulates */
-		list_del(&page->lru);
-		trace_mm_page_pcpu_drain(page, 0, migratetype);
-		__free_one_page(page, zone, 0, migratetype);
+		do {
+			page = list_entry(list->prev, struct page, lru);
+			/* must delete as __free_one_page list manipulates */
+			list_del(&page->lru);
+			__free_one_page(page, zone, 0, migratetype);
+			trace_mm_page_pcpu_drain(page, 0, migratetype);
+		} while (--count && --batch_free && !list_empty(list));
 	}
 	spin_unlock(&zone->lock);
 }
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
memory-hotplug-update-zone-pcp-at-memory-online.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
memory-hotplug-exclude-isolated-page-from-pco-page-alloc.patch
memory-hotplug-make-pages-from-movable-zone-always-isolatable.patch
memory-hotplug-alloc-page-from-other-node-in-memory-online.patch
memory-hotplug-migrate-swap-cache-page.patch
hugetlb-balance-freeing-of-huge-pages-across-nodes.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix.patch
hugetlb-clean-up-and-update-huge-pages-documentation.patch
hugetlb-restore-interleaving-of-bootmem-huge-pages.patch
mm-clean-up-page_remove_rmap.patch
mm-update-alloc_flags-after-oom-killer-has-been-called.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback.patch
page-allocator-remove-dead-function-free_cold_page.patch
tracing-page-allocator-add-trace-events-for-page-allocation-and-page-freeing.patch
tracing-page-allocator-add-trace-events-for-anti-fragmentation-falling-back-to-other-migratetypes.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists-fix.patch
tracing-page-allocator-add-a-postprocessing-script-for-page-allocator-related-ftrace-events.patch
tracing-documentation-add-a-document-describing-how-to-do-some-performance-analysis-with-tracepoints.patch
tracing-documentation-add-a-document-on-the-kmem-tracepoints.patch
mm-drop-unneeded-double-negations.patch
page-allocator-limit-the-number-of-migrate_reserve-pageblocks-per-zone.patch
memory-hotplug-fix-updating-of-num_physpages-for-hot-plugged-memory.patch
mm-also-use-alloc_large_system_hash-for-the-pid-hash-table.patch
vmscan-move-pgdeactivate-modification-to-shrink_active_list.patch
hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-example.patch
page-allocator-split-per-cpu-list-into-one-list-per-migrate-type.patch
page-allocator-maintain-rolling-count-of-pages-to-free-from-the-pcp.patch
add-debugging-aid-for-memory-initialisation-problems.patch

