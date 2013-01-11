From: akpm@linux-foundation.org
Subject: + mm-compaction-partially-revert-capture-of-suitable-high-order-page.patch added to -mm tree
Date: Fri, 11 Jan 2013 13:16:41 -0800
Message-ID: <20130111211641.B725E820050@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:44896 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab3AKVQm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Jan 2013 16:16:42 -0500
Received: by mail-ye0-f202.google.com with SMTP id r9so272149yen.3
        for <mm-commits@vger.kernel.org>; Fri, 11 Jan 2013 13:16:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, davem@davemloft.net, eric.dumazet@gmail.com, normalperson@yhbt.net, stable@vger.kernel.org


The patch titled
     Subject: mm: compaction: partially revert capture of suitable high-order page
has been added to the -mm tree.  Its filename is
     mm-compaction-partially-revert-capture-of-suitable-high-order-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: compaction: partially revert capture of suitable high-order page

Eric Wong reported on 3.7 and 3.8-rc2 that ppoll() got stuck when waiting
for POLLIN on a local TCP socket.  It was easier to trigger if there was
disk IO and dirty pages at the same time and he bisected it to commit
1fb3f8ca "mm: compaction: capture a suitable high-order page immediately
when it is made available".

The intention of that patch was to improve high-order allocations under
memory pressure after changes made to reclaim in 3.6 drastically hurt THP
allocations but the approach was flawed.  For Eric, the problem was that
page->pfmemalloc was not being cleared for captured pages leading to a
poor interaction with swap-over-NFS support causing the packets to be
dropped.  However, I identified a few more problems with the patch
including the fact that it can increase contention on zone->lock in some
cases which could result in async direct compaction being aborted early.

In retrospect the capture patch took the wrong approach.  What it should
have done is mark the pageblock being migrated as MIGRATE_ISOLATE if it
was allocating for THP and avoided races that way.  While the patch was
showing to improve allocation success rates at the time, the benefit is
marginal given the relative complexity and it should be revisited from
scratch in the context of the other reclaim-related changes that have
taken place since the patch was first written and tested.  This patch
partially reverts commit 1fb3f8ca "mm: compaction: capture a suitable
high-order page immediately when it is made available".

Reported-and-tested-by: Eric Wong <normalperson@yhbt.net>
Tested-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    4 -
 include/linux/mm.h         |    1 
 mm/compaction.c            |   92 ++++-------------------------------
 mm/internal.h              |    1 
 mm/page_alloc.c            |   35 +++----------
 5 files changed, 23 insertions(+), 110 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-partially-revert-capture-of-suitable-high-order-page include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-partially-revert-capture-of-suitable-high-order-page
+++ a/include/linux/compaction.h
@@ -22,7 +22,7 @@ extern int sysctl_extfrag_handler(struct
 extern int fragmentation_index(struct zone *zone, unsigned int order);
 extern unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *mask,
-			bool sync, bool *contended, struct page **page);
+			bool sync, bool *contended);
 extern int compact_pgdat(pg_data_t *pgdat, int order);
 extern void reset_isolation_suitable(pg_data_t *pgdat);
 extern unsigned long compaction_suitable(struct zone *zone, int order);
@@ -75,7 +75,7 @@ static inline bool compaction_restarting
 #else
 static inline unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *nodemask,
-			bool sync, bool *contended, struct page **page)
+			bool sync, bool *contended)
 {
 	return COMPACT_CONTINUE;
 }
diff -puN include/linux/mm.h~mm-compaction-partially-revert-capture-of-suitable-high-order-page include/linux/mm.h
--- a/include/linux/mm.h~mm-compaction-partially-revert-capture-of-suitable-high-order-page
+++ a/include/linux/mm.h
@@ -455,7 +455,6 @@ void put_pages_list(struct list_head *pa
 
 void split_page(struct page *page, unsigned int order);
 int split_free_page(struct page *page);
-int capture_free_page(struct page *page, int alloc_order, int migratetype);
 
 /*
  * Compound pages have a destructor function.  Provide a
diff -puN mm/compaction.c~mm-compaction-partially-revert-capture-of-suitable-high-order-page mm/compaction.c
--- a/mm/compaction.c~mm-compaction-partially-revert-capture-of-suitable-high-order-page
+++ a/mm/compaction.c
@@ -816,6 +816,7 @@ static isolate_migrate_t isolate_migrate
 static int compact_finished(struct zone *zone,
 			    struct compact_control *cc)
 {
+	unsigned int order;
 	unsigned long watermark;
 
 	if (fatal_signal_pending(current))
@@ -850,22 +851,16 @@ static int compact_finished(struct zone 
 		return COMPACT_CONTINUE;
 
 	/* Direct compactor: Is a suitable page free? */
-	if (cc->page) {
-		/* Was a suitable page captured? */
-		if (*cc->page)
+	for (order = cc->order; order < MAX_ORDER; order++) {
+		struct free_area *area = &zone->free_area[order];
+
+		/* Job done if page is free of the right migratetype */
+		if (!list_empty(&area->free_list[cc->migratetype]))
+			return COMPACT_PARTIAL;
+
+		/* Job done if allocation would set block type */
+		if (cc->order >= pageblock_order && area->nr_free)
 			return COMPACT_PARTIAL;
-	} else {
-		unsigned int order;
-		for (order = cc->order; order < MAX_ORDER; order++) {
-			struct free_area *area = &zone->free_area[cc->order];
-			/* Job done if page is free of the right migratetype */
-			if (!list_empty(&area->free_list[cc->migratetype]))
-				return COMPACT_PARTIAL;
-
-			/* Job done if allocation would set block type */
-			if (cc->order >= pageblock_order && area->nr_free)
-				return COMPACT_PARTIAL;
-		}
 	}
 
 	return COMPACT_CONTINUE;
@@ -921,60 +916,6 @@ unsigned long compaction_suitable(struct
 	return COMPACT_CONTINUE;
 }
 
-static void compact_capture_page(struct compact_control *cc)
-{
-	unsigned long flags;
-	int mtype, mtype_low, mtype_high;
-
-	if (!cc->page || *cc->page)
-		return;
-
-	/*
-	 * For MIGRATE_MOVABLE allocations we capture a suitable page ASAP
-	 * regardless of the migratetype of the freelist is is captured from.
-	 * This is fine because the order for a high-order MIGRATE_MOVABLE
-	 * allocation is typically at least a pageblock size and overall
-	 * fragmentation is not impaired. Other allocation types must
-	 * capture pages from their own migratelist because otherwise they
-	 * could pollute other pageblocks like MIGRATE_MOVABLE with
-	 * difficult to move pages and making fragmentation worse overall.
-	 */
-	if (cc->migratetype == MIGRATE_MOVABLE) {
-		mtype_low = 0;
-		mtype_high = MIGRATE_PCPTYPES;
-	} else {
-		mtype_low = cc->migratetype;
-		mtype_high = cc->migratetype + 1;
-	}
-
-	/* Speculatively examine the free lists without zone lock */
-	for (mtype = mtype_low; mtype < mtype_high; mtype++) {
-		int order;
-		for (order = cc->order; order < MAX_ORDER; order++) {
-			struct page *page;
-			struct free_area *area;
-			area = &(cc->zone->free_area[order]);
-			if (list_empty(&area->free_list[mtype]))
-				continue;
-
-			/* Take the lock and attempt capture of the page */
-			if (!compact_trylock_irqsave(&cc->zone->lock, &flags, cc))
-				return;
-			if (!list_empty(&area->free_list[mtype])) {
-				page = list_entry(area->free_list[mtype].next,
-							struct page, lru);
-				if (capture_free_page(page, cc->order, mtype)) {
-					spin_unlock_irqrestore(&cc->zone->lock,
-									flags);
-					*cc->page = page;
-					return;
-				}
-			}
-			spin_unlock_irqrestore(&cc->zone->lock, flags);
-		}
-	}
-}
-
 static int compact_zone(struct zone *zone, struct compact_control *cc)
 {
 	int ret;
@@ -1054,9 +995,6 @@ static int compact_zone(struct zone *zon
 				goto out;
 			}
 		}
-
-		/* Capture a page now if it is a suitable size */
-		compact_capture_page(cc);
 	}
 
 out:
@@ -1069,8 +1007,7 @@ out:
 
 static unsigned long compact_zone_order(struct zone *zone,
 				 int order, gfp_t gfp_mask,
-				 bool sync, bool *contended,
-				 struct page **page)
+				 bool sync, bool *contended)
 {
 	unsigned long ret;
 	struct compact_control cc = {
@@ -1080,7 +1017,6 @@ static unsigned long compact_zone_order(
 		.migratetype = allocflags_to_migratetype(gfp_mask),
 		.zone = zone,
 		.sync = sync,
-		.page = page,
 	};
 	INIT_LIST_HEAD(&cc.freepages);
 	INIT_LIST_HEAD(&cc.migratepages);
@@ -1110,7 +1046,7 @@ int sysctl_extfrag_threshold = 500;
  */
 unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *nodemask,
-			bool sync, bool *contended, struct page **page)
+			bool sync, bool *contended)
 {
 	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
 	int may_enter_fs = gfp_mask & __GFP_FS;
@@ -1136,7 +1072,7 @@ unsigned long try_to_compact_pages(struc
 		int status;
 
 		status = compact_zone_order(zone, order, gfp_mask, sync,
-						contended, page);
+						contended);
 		rc = max(status, rc);
 
 		/* If a normal allocation would succeed, stop compacting */
@@ -1192,7 +1128,6 @@ int compact_pgdat(pg_data_t *pgdat, int 
 	struct compact_control cc = {
 		.order = order,
 		.sync = false,
-		.page = NULL,
 	};
 
 	return __compact_pgdat(pgdat, &cc);
@@ -1203,7 +1138,6 @@ static int compact_node(int nid)
 	struct compact_control cc = {
 		.order = -1,
 		.sync = true,
-		.page = NULL,
 	};
 
 	return __compact_pgdat(NODE_DATA(nid), &cc);
diff -puN mm/internal.h~mm-compaction-partially-revert-capture-of-suitable-high-order-page mm/internal.h
--- a/mm/internal.h~mm-compaction-partially-revert-capture-of-suitable-high-order-page
+++ a/mm/internal.h
@@ -135,7 +135,6 @@ struct compact_control {
 	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
 	struct zone *zone;
 	bool contended;			/* True if a lock was contended */
-	struct page **page;		/* Page captured of requested size */
 };
 
 unsigned long
diff -puN mm/page_alloc.c~mm-compaction-partially-revert-capture-of-suitable-high-order-page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-partially-revert-capture-of-suitable-high-order-page
+++ a/mm/page_alloc.c
@@ -1384,14 +1384,8 @@ void split_page(struct page *page, unsig
 		set_page_refcounted(page + i);
 }
 
-/*
- * Similar to the split_page family of functions except that the page
- * required at the given order and being isolated now to prevent races
- * with parallel allocators
- */
-int capture_free_page(struct page *page, int alloc_order, int migratetype)
+static int __isolate_free_page(struct page *page, unsigned int order)
 {
-	unsigned int order;
 	unsigned long watermark;
 	struct zone *zone;
 	int mt;
@@ -1399,7 +1393,6 @@ int capture_free_page(struct page *page,
 	BUG_ON(!PageBuddy(page));
 
 	zone = page_zone(page);
-	order = page_order(page);
 	mt = get_pageblock_migratetype(page);
 
 	if (mt != MIGRATE_ISOLATE) {
@@ -1408,7 +1401,7 @@ int capture_free_page(struct page *page,
 		if (!zone_watermark_ok(zone, 0, watermark, 0, 0))
 			return 0;
 
-		__mod_zone_freepage_state(zone, -(1UL << alloc_order), mt);
+		__mod_zone_freepage_state(zone, -(1UL << order), mt);
 	}
 
 	/* Remove page from free list */
@@ -1416,11 +1409,7 @@ int capture_free_page(struct page *page,
 	zone->free_area[order].nr_free--;
 	rmv_page_order(page);
 
-	if (alloc_order != order)
-		expand(zone, page, alloc_order, order,
-			&zone->free_area[order], migratetype);
-
-	/* Set the pageblock if the captured page is at least a pageblock */
+	/* Set the pageblock if the isolated page is at least a pageblock */
 	if (order >= pageblock_order - 1) {
 		struct page *endpage = page + (1 << order) - 1;
 		for (; page < endpage; page += pageblock_nr_pages) {
@@ -1431,7 +1420,7 @@ int capture_free_page(struct page *page,
 		}
 	}
 
-	return 1UL << alloc_order;
+	return 1UL << order;
 }
 
 /*
@@ -1449,10 +1438,9 @@ int split_free_page(struct page *page)
 	unsigned int order;
 	int nr_pages;
 
-	BUG_ON(!PageBuddy(page));
 	order = page_order(page);
 
-	nr_pages = capture_free_page(page, order, 0);
+	nr_pages = __isolate_free_page(page, order);
 	if (!nr_pages)
 		return 0;
 
@@ -2136,8 +2124,6 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	bool *contended_compaction, bool *deferred_compaction,
 	unsigned long *did_some_progress)
 {
-	struct page *page = NULL;
-
 	if (!order)
 		return NULL;
 
@@ -2149,16 +2135,12 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	current->flags |= PF_MEMALLOC;
 	*did_some_progress = try_to_compact_pages(zonelist, order, gfp_mask,
 						nodemask, sync_migration,
-						contended_compaction, &page);
+						contended_compaction);
 	current->flags &= ~PF_MEMALLOC;
 
-	/* If compaction captured a page, prep and use it */
-	if (page) {
-		prep_new_page(page, order, gfp_mask);
-		goto got_page;
-	}
-
 	if (*did_some_progress != COMPACT_SKIPPED) {
+		struct page *page;
+
 		/* Page migration frees to the PCP lists but we want merging */
 		drain_pages(get_cpu());
 		put_cpu();
@@ -2168,7 +2150,6 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 				alloc_flags & ~ALLOC_NO_WATERMARKS,
 				preferred_zone, migratetype);
 		if (page) {
-got_page:
 			preferred_zone->compact_blockskip_flush = false;
 			preferred_zone->compact_considered = 0;
 			preferred_zone->compact_defer_shift = 0;
_

Patches currently in -mm which might be from mgorman@suse.de are

linux-next.patch
mm-migrate-check-page_count-of-thp-before-migrating.patch
mm-migrate-check-page_count-of-thp-before-migrating-accounting-fix.patch
mm-compaction-fix-echo-1-compact_memory-return-error-issue.patch
mm-use-aligned-zone-start-for-pfn_to_bitidx-calculation.patch
mm-thp-acquire-the-anon_vma-rwsem-for-write-during-split.patch
mm-compaction-partially-revert-capture-of-suitable-high-order-page.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mm-compaction-do-not-accidentally-skip-pageblocks-in-the-migrate-scanner.patch
mm-huge_memory-use-new-hashtable-implementation.patch
mmksm-use-new-hashtable-implementation.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-avoid-calling-pgdat_balanced-needlessly.patch
mm-memmap_init_zone-performance-improvement.patch

