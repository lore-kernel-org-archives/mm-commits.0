From: akpm@linux-foundation.org
Subject: + page-allocator-split-per-cpu-list-into-one-list-per-migrate-type.patch added to -mm tree
Date: Tue, 01 Sep 2009 14:14:41 -0700
Message-ID: <200909012114.n81LEgoo013263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755185AbZIAVPt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Sep 2009 17:15:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, cl@linux-foundation.org, minchan.kim@gmail.com, npiggin@suse.de, penberg@cs.helsinki.fi


The patch titled
     page-allocator: split per-cpu list into one-list-per-migrate-type
has been added to the -mm tree.  Its filename is
     page-allocator-split-per-cpu-list-into-one-list-per-migrate-type.patch

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
Subject: page-allocator: split per-cpu list into one-list-per-migrate-type
From: Mel Gorman <mel@csn.ul.ie>

The following two patches remove searching in the page allocator fast-path
by maintaining multiple free-lists in the per-cpu structure.  At the time
the search was introduced, increasing the per-cpu structures would waste a
lot of memory as per-cpu structures were statically allocated at
compile-time.  This is no longer the case.

The patches are as follows. They are based on mmotm-2009-08-27.

Patch 1 adds multiple lists to struct per_cpu_pages, one per
	migratetype that can be stored on the PCP lists.

Patch 2 notes that the pcpu drain path check empty lists multiple times. The
	patch reduces the number of checks by maintaining a count of free
	lists encountered. Lists containing pages will then free multiple
	pages in batch

The patches were tested with kernbench, netperf udp/tcp, hackbench and
sysbench.  The netperf tests were not bound to any CPU in particular and
were run such that the results should be 99% confidence that the reported
results are within 1% of the estimated mean.  sysbench was run with a
postgres background and read-only tests.  Similar to netperf, it was run
multiple times so that it's 99% confidence results are within 1%.  The
patches were tested on x86, x86-64 and ppc64 as

x86:	Intel Pentium D 3GHz with 8G RAM (no-brand machine)
	kernbench	- No significant difference, variance well within noise
	netperf-udp	- 1.34% to 2.28% gain
	netperf-tcp	- 0.45% to 1.22% gain
	hackbench	- Small variances, very close to noise
	sysbench	- Very small gains

x86-64:	AMD Phenom 9950 1.3GHz with 8G RAM (no-brand machine)
	kernbench	- No significant difference, variance well within noise
	netperf-udp	- 1.83% to 10.42% gains
	netperf-tcp	- No conclusive until buffer >= PAGE_SIZE
				4096	+15.83%
				8192	+ 0.34% (not significant)
				16384	+ 1%
	hackbench	- Small gains, very close to noise
	sysbench	- 0.79% to 1.6% gain

ppc64:	PPC970MP 2.5GHz with 10GB RAM (it's a terrasoft powerstation)
	kernbench	- No significant difference, variance well within noise
	netperf-udp	- 2-3% gain for almost all buffer sizes tested
	netperf-tcp	- losses on small buffers, gains on larger buffers
			  possibly indicates some bad caching effect.
	hackbench	- No significant difference
	sysbench	- 2-4% gain



This patch:

Currently the per-cpu page allocator searches the PCP list for pages of
the correct migrate-type to reduce the possibility of pages being
inappropriate placed from a fragmentation perspective.  This search is
potentially expensive in a fast-path and undesirable.  Splitting the
per-cpu list into multiple lists increases the size of a per-cpu structure
and this was potentially a major problem at the time the search was
introduced.  These problem has been mitigated as now only the necessary
number of structures is allocated for the running system.

This patch replaces a list search in the per-cpu allocator with one list
per migrate type.  The potential snag with this approach is when bulk
freeing pages.  We round-robin free pages based on migrate type which has
little bearing on the cache hotness of the page and potentially checks
empty lists repeatedly in the event the majority of PCP pages are of one
type.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Nick Piggin <npiggin@suse.de>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    5 +
 mm/page_alloc.c        |  106 +++++++++++++++++++++------------------
 2 files changed, 63 insertions(+), 48 deletions(-)

diff -puN include/linux/mmzone.h~page-allocator-split-per-cpu-list-into-one-list-per-migrate-type include/linux/mmzone.h
--- a/include/linux/mmzone.h~page-allocator-split-per-cpu-list-into-one-list-per-migrate-type
+++ a/include/linux/mmzone.h
@@ -38,6 +38,7 @@
 #define MIGRATE_UNMOVABLE     0
 #define MIGRATE_RECLAIMABLE   1
 #define MIGRATE_MOVABLE       2
+#define MIGRATE_PCPTYPES      3 /* the number of types on the pcp lists */
 #define MIGRATE_RESERVE       3
 #define MIGRATE_ISOLATE       4 /* can't allocate from here */
 #define MIGRATE_TYPES         5
@@ -169,7 +170,9 @@ struct per_cpu_pages {
 	int count;		/* number of pages in the list */
 	int high;		/* high watermark, emptying needed */
 	int batch;		/* chunk size for buddy add/remove */
-	struct list_head list;	/* the list of pages */
+
+	/* Lists of pages, one per migrate type stored on the pcp-lists */
+	struct list_head lists[MIGRATE_PCPTYPES];
 };
 
 struct per_cpu_pageset {
diff -puN mm/page_alloc.c~page-allocator-split-per-cpu-list-into-one-list-per-migrate-type mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-split-per-cpu-list-into-one-list-per-migrate-type
+++ a/mm/page_alloc.c
@@ -522,7 +522,7 @@ static inline int free_pages_check(struc
 }
 
 /*
- * Frees a list of pages. 
+ * Frees a number of pages from the PCP lists
  * Assumes all pages on list are in same zone, and of same order.
  * count is the number of pages to free.
  *
@@ -532,23 +532,36 @@ static inline int free_pages_check(struc
  * And clear the zone's pages_scanned counter, to hold off the "all pages are
  * pinned" detection logic.
  */
-static void free_pages_bulk(struct zone *zone, int count,
-					struct list_head *list, int order)
+static void free_pcppages_bulk(struct zone *zone, int count,
+					struct per_cpu_pages *pcp)
 {
+	int migratetype = 0;
+
 	spin_lock(&zone->lock);
 	zone_clear_flag(zone, ZONE_ALL_UNRECLAIMABLE);
 	zone->pages_scanned = 0;
 
-	__mod_zone_page_state(zone, NR_FREE_PAGES, count << order);
+	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
 	while (count--) {
 		struct page *page;
+		struct list_head *list;
+
+		/*
+		 * Remove pages from lists in a round-robin fashion. This spinning
+		 * around potentially empty lists is bloody awful, alternatives that
+		 * don't suck are welcome
+		 */
+		do {
+			if (++migratetype == MIGRATE_PCPTYPES)
+				migratetype = 0;
+			list = &pcp->lists[migratetype];
+		} while (list_empty(list));
 
-		VM_BUG_ON(list_empty(list));
 		page = list_entry(list->prev, struct page, lru);
 		/* have to delete it as __free_one_page list manipulates */
 		list_del(&page->lru);
-		trace_mm_page_pcpu_drain(page, order, page_private(page));
-		__free_one_page(page, zone, order, page_private(page));
+		trace_mm_page_pcpu_drain(page, 0, migratetype);
+		__free_one_page(page, zone, 0, migratetype);
 	}
 	spin_unlock(&zone->lock);
 }
@@ -974,7 +987,7 @@ void drain_zone_pages(struct zone *zone,
 		to_drain = pcp->batch;
 	else
 		to_drain = pcp->count;
-	free_pages_bulk(zone, to_drain, &pcp->list, 0);
+	free_pcppages_bulk(zone, to_drain, pcp);
 	pcp->count -= to_drain;
 	local_irq_restore(flags);
 }
@@ -1000,7 +1013,7 @@ static void drain_pages(unsigned int cpu
 
 		pcp = &pset->pcp;
 		local_irq_save(flags);
-		free_pages_bulk(zone, pcp->count, &pcp->list, 0);
+		free_pcppages_bulk(zone, pcp->count, pcp);
 		pcp->count = 0;
 		local_irq_restore(flags);
 	}
@@ -1066,6 +1079,7 @@ static void free_hot_cold_page(struct pa
 	struct zone *zone = page_zone(page);
 	struct per_cpu_pages *pcp;
 	unsigned long flags;
+	int migratetype;
 	int wasMlocked = __TestClearPageMlocked(page);
 
 	kmemcheck_free_shadow(page, 0);
@@ -1083,21 +1097,39 @@ static void free_hot_cold_page(struct pa
 	kernel_map_pages(page, 1, 0);
 
 	pcp = &zone_pcp(zone, get_cpu())->pcp;
-	set_page_private(page, get_pageblock_migratetype(page));
+	migratetype = get_pageblock_migratetype(page);
+	set_page_private(page, migratetype);
 	local_irq_save(flags);
 	if (unlikely(wasMlocked))
 		free_page_mlock(page);
 	__count_vm_event(PGFREE);
 
+	/*
+	 * We only track unmovable, reclaimable and movable on pcp lists.
+	 * Free ISOLATE pages back to the allocator because they are being
+	 * offlined but treat RESERVE as movable pages so we can get those
+	 * areas back if necessary. Otherwise, we may have to free
+	 * excessively into the page allocator
+	 */
+	if (migratetype >= MIGRATE_PCPTYPES) {
+		if (unlikely(migratetype == MIGRATE_ISOLATE)) {
+			free_one_page(zone, page, 0, migratetype);
+			goto out;
+		}
+		migratetype = MIGRATE_MOVABLE;
+	}
+
 	if (cold)
-		list_add_tail(&page->lru, &pcp->list);
+		list_add_tail(&page->lru, &pcp->lists[migratetype]);
 	else
-		list_add(&page->lru, &pcp->list);
+		list_add(&page->lru, &pcp->lists[migratetype]);
 	pcp->count++;
 	if (pcp->count >= pcp->high) {
-		free_pages_bulk(zone, pcp->batch, &pcp->list, 0);
+		free_pcppages_bulk(zone, pcp->batch, pcp);
 		pcp->count -= pcp->batch;
 	}
+
+out:
 	local_irq_restore(flags);
 	put_cpu();
 }
@@ -1155,46 +1187,24 @@ again:
 	cpu  = get_cpu();
 	if (likely(order == 0)) {
 		struct per_cpu_pages *pcp;
+		struct list_head *list;
 
 		pcp = &zone_pcp(zone, cpu)->pcp;
+		list = &pcp->lists[migratetype];
 		local_irq_save(flags);
-		if (!pcp->count) {
-			pcp->count = rmqueue_bulk(zone, 0,
-					pcp->batch, &pcp->list,
-					migratetype, cold);
-			if (unlikely(!pcp->count))
-				goto failed;
-		}
-
-		/* Find a page of the appropriate migrate type */
-		if (cold) {
-			list_for_each_entry_reverse(page, &pcp->list, lru)
-				if (page_private(page) == migratetype)
-					break;
-		} else {
-			list_for_each_entry(page, &pcp->list, lru)
-				if (page_private(page) == migratetype)
-					break;
-		}
-
-		/* Allocate more to the pcp list if necessary */
-		if (unlikely(&page->lru == &pcp->list)) {
-			int get_one_page = 0;
-
+		if (list_empty(list)) {
 			pcp->count += rmqueue_bulk(zone, 0,
-					pcp->batch, &pcp->list,
+					pcp->batch, list,
 					migratetype, cold);
-			list_for_each_entry(page, &pcp->list, lru) {
-				if (get_pageblock_migratetype(page) !=
-					    MIGRATE_ISOLATE) {
-					get_one_page = 1;
-					break;
-				}
-			}
-			if (!get_one_page)
+			if (unlikely(list_empty(list)))
 				goto failed;
 		}
 
+		if (cold)
+			page = list_entry(list->prev, struct page, lru);
+		else
+			page = list_entry(list->next, struct page, lru);
+
 		list_del(&page->lru);
 		pcp->count--;
 	} else {
@@ -3045,6 +3055,7 @@ static int zone_batchsize(struct zone *z
 static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)
 {
 	struct per_cpu_pages *pcp;
+	int migratetype;
 
 	memset(p, 0, sizeof(*p));
 
@@ -3052,7 +3063,8 @@ static void setup_pageset(struct per_cpu
 	pcp->count = 0;
 	pcp->high = 6 * batch;
 	pcp->batch = max(1UL, 1 * batch);
-	INIT_LIST_HEAD(&pcp->list);
+	for (migratetype = 0; migratetype < MIGRATE_PCPTYPES; migratetype++)
+		INIT_LIST_HEAD(&pcp->lists[migratetype]);
 }
 
 /*
@@ -3244,7 +3256,7 @@ static int __zone_pcp_update(void *data)
 		pcp = &pset->pcp;
 
 		local_irq_save(flags);
-		free_pages_bulk(zone, pcp->count, &pcp->list, 0);
+		free_pcppages_bulk(zone, pcp->count, pcp);
 		setup_pageset(pset, batch);
 		local_irq_restore(flags);
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

