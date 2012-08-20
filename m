From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch removed from -mm tree
Date: Mon, 20 Aug 2012 15:58:04 -0700
Message-ID: <20120820225804.DA8D5100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:38908 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab2HTW6H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 18:58:07 -0400
Received: by obbwc20 with SMTP id wc20so4126017obb.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 15:58:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, minchan@kernel.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: capture a suitable high-order page immediately when it is made available
has been removed from the -mm tree.  Its filename was
     mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: compaction: capture a suitable high-order page immediately when it is made available

While compaction is migrating pages to free up large contiguous blocks for
allocation it races with other allocation requests that may steal these
blocks or break them up.  This patch alters direct compaction to capture a
suitable free page as soon as it becomes available to reduce this race. 
It uses similar logic to split_free_page() to ensure that watermarks are
still obeyed.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    4 -
 include/linux/mm.h         |    1 
 mm/compaction.c            |   88 ++++++++++++++++++++++++++++++-----
 mm/internal.h              |    1 
 mm/page_alloc.c            |   63 ++++++++++++++++++-------
 5 files changed, 128 insertions(+), 29 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available
+++ a/include/linux/compaction.h
@@ -22,7 +22,7 @@ extern int sysctl_extfrag_handler(struct
 extern int fragmentation_index(struct zone *zone, unsigned int order);
 extern unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *mask,
-			bool sync);
+			bool sync, struct page **page);
 extern int compact_pgdat(pg_data_t *pgdat, int order);
 extern unsigned long compaction_suitable(struct zone *zone, int order);
 
@@ -64,7 +64,7 @@ static inline bool compaction_deferred(s
 #else
 static inline unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *nodemask,
-			bool sync)
+			bool sync, struct page **page)
 {
 	return COMPACT_CONTINUE;
 }
diff -puN include/linux/mm.h~mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available include/linux/mm.h
--- a/include/linux/mm.h~mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available
+++ a/include/linux/mm.h
@@ -442,6 +442,7 @@ void put_pages_list(struct list_head *pa
 
 void split_page(struct page *page, unsigned int order);
 int split_free_page(struct page *page);
+int capture_free_page(struct page *page, int alloc_order, int migratetype);
 
 /*
  * Compound pages have a destructor function.  Provide a
diff -puN mm/compaction.c~mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available mm/compaction.c
--- a/mm/compaction.c~mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available
+++ a/mm/compaction.c
@@ -50,6 +50,59 @@ static inline bool migrate_async_suitabl
 	return is_migrate_cma(migratetype) || migratetype == MIGRATE_MOVABLE;
 }
 
+static void compact_capture_page(struct compact_control *cc)
+{
+	unsigned long flags;
+	int mtype, mtype_low, mtype_high;
+
+	if (!cc->page || *cc->page)
+		return;
+
+	/*
+	 * For MIGRATE_MOVABLE allocations we capture a suitable page ASAP
+	 * regardless of the migratetype of the freelist is is captured from.
+	 * This is fine because the order for a high-order MIGRATE_MOVABLE
+	 * allocation is typically at least a pageblock size and overall
+	 * fragmentation is not impaired. Other allocation types must
+	 * capture pages from their own migratelist because otherwise they
+	 * could pollute other pageblocks like MIGRATE_MOVABLE with
+	 * difficult to move pages and making fragmentation worse overall.
+	 */
+	if (cc->migratetype == MIGRATE_MOVABLE) {
+		mtype_low = 0;
+		mtype_high = MIGRATE_PCPTYPES;
+	} else {
+		mtype_low = cc->migratetype;
+		mtype_high = cc->migratetype + 1;
+	}
+
+	/* Speculatively examine the free lists without zone lock */
+	for (mtype = mtype_low; mtype < mtype_high; mtype++) {
+		int order;
+		for (order = cc->order; order < MAX_ORDER; order++) {
+			struct page *page;
+			struct free_area *area;
+			area = &(cc->zone->free_area[order]);
+			if (list_empty(&area->free_list[mtype]))
+				continue;
+
+			/* Take the lock and attempt capture of the page */
+			spin_lock_irqsave(&cc->zone->lock, flags);
+			if (!list_empty(&area->free_list[mtype])) {
+				page = list_entry(area->free_list[mtype].next,
+							struct page, lru);
+				if (capture_free_page(page, cc->order, mtype)) {
+					spin_unlock_irqrestore(&cc->zone->lock,
+									flags);
+					*cc->page = page;
+					return;
+				}
+			}
+			spin_unlock_irqrestore(&cc->zone->lock, flags);
+		}
+	}
+}
+
 /*
  * Isolate free pages onto a private freelist. Caller must hold zone->lock.
  * If @strict is true, will abort returning 0 on any invalid PFNs or non-free
@@ -587,7 +640,6 @@ static unsigned long start_free_pfn(stru
 static int compact_finished(struct zone *zone,
 			    struct compact_control *cc)
 {
-	unsigned int order;
 	unsigned long watermark;
 
 	if (fatal_signal_pending(current))
@@ -630,14 +682,22 @@ static int compact_finished(struct zone 
 		return COMPACT_CONTINUE;
 
 	/* Direct compactor: Is a suitable page free? */
-	for (order = cc->order; order < MAX_ORDER; order++) {
-		/* Job done if page is free of the right migratetype */
-		if (!list_empty(&zone->free_area[order].free_list[cc->migratetype]))
-			return COMPACT_PARTIAL;
-
-		/* Job done if allocation would set block type */
-		if (order >= pageblock_order && zone->free_area[order].nr_free)
+	if (cc->page) {
+		/* Was a suitable page captured? */
+		if (*cc->page)
 			return COMPACT_PARTIAL;
+	} else {
+		unsigned int order;
+		for (order = cc->order; order < MAX_ORDER; order++) {
+			struct free_area *area = &zone->free_area[cc->order];
+			/* Job done if page is free of the right migratetype */
+			if (!list_empty(&area->free_list[cc->migratetype]))
+				return COMPACT_PARTIAL;
+
+			/* Job done if allocation would set block type */
+			if (cc->order >= pageblock_order && area->nr_free)
+				return COMPACT_PARTIAL;
+		}
 	}
 
 	return COMPACT_CONTINUE;
@@ -759,6 +819,9 @@ static int compact_zone(struct zone *zon
 				goto out;
 			}
 		}
+
+		/* Capture a page now if it is a suitable size */
+		compact_capture_page(cc);
 	}
 
 out:
@@ -771,7 +834,7 @@ out:
 
 static unsigned long compact_zone_order(struct zone *zone,
 				 int order, gfp_t gfp_mask,
-				 bool sync)
+				 bool sync, struct page **page)
 {
 	struct compact_control cc = {
 		.nr_freepages = 0,
@@ -780,6 +843,7 @@ static unsigned long compact_zone_order(
 		.migratetype = allocflags_to_migratetype(gfp_mask),
 		.zone = zone,
 		.sync = sync,
+		.page = page,
 	};
 	INIT_LIST_HEAD(&cc.freepages);
 	INIT_LIST_HEAD(&cc.migratepages);
@@ -801,7 +865,7 @@ int sysctl_extfrag_threshold = 500;
  */
 unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *nodemask,
-			bool sync)
+			bool sync, struct page **page)
 {
 	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
 	int may_enter_fs = gfp_mask & __GFP_FS;
@@ -821,7 +885,7 @@ unsigned long try_to_compact_pages(struc
 								nodemask) {
 		int status;
 
-		status = compact_zone_order(zone, order, gfp_mask, sync);
+		status = compact_zone_order(zone, order, gfp_mask, sync, page);
 		rc = max(status, rc);
 
 		/* If a normal allocation would succeed, stop compacting */
@@ -876,6 +940,7 @@ int compact_pgdat(pg_data_t *pgdat, int 
 	struct compact_control cc = {
 		.order = order,
 		.sync = false,
+		.page = NULL,
 	};
 
 	return __compact_pgdat(pgdat, &cc);
@@ -886,6 +951,7 @@ static int compact_node(int nid)
 	struct compact_control cc = {
 		.order = -1,
 		.sync = true,
+		.page = NULL,
 	};
 
 	return __compact_pgdat(NODE_DATA(nid), &cc);
diff -puN mm/internal.h~mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available mm/internal.h
--- a/mm/internal.h~mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available
+++ a/mm/internal.h
@@ -130,6 +130,7 @@ struct compact_control {
 	int order;			/* order a direct compactor needs */
 	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
 	struct zone *zone;
+	struct page **page;		/* Page captured of requested size */
 };
 
 unsigned long
diff -puN mm/page_alloc.c~mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available
+++ a/mm/page_alloc.c
@@ -1379,16 +1379,11 @@ void split_page(struct page *page, unsig
 }
 
 /*
- * Similar to split_page except the page is already free. As this is only
- * being used for migration, the migratetype of the block also changes.
- * As this is called with interrupts disabled, the caller is responsible
- * for calling arch_alloc_page() and kernel_map_page() after interrupts
- * are enabled.
- *
- * Note: this is probably too low level an operation for use in drivers.
- * Please consult with lkml before using this in your driver.
+ * Similar to the split_page family of functions except that the page
+ * required at the given order and being isolated now to prevent races
+ * with parallel allocators
  */
-int split_free_page(struct page *page)
+int capture_free_page(struct page *page, int alloc_order, int migratetype)
 {
 	unsigned int order;
 	unsigned long watermark;
@@ -1410,10 +1405,11 @@ int split_free_page(struct page *page)
 	rmv_page_order(page);
 	__mod_zone_page_state(zone, NR_FREE_PAGES, -(1UL << order));
 
-	/* Split into individual pages */
-	set_page_refcounted(page);
-	split_page(page, order);
+	if (alloc_order != order)
+		expand(zone, page, alloc_order, order,
+			&zone->free_area[order], migratetype);
 
+	/* Set the pageblock if the captured page is at least a pageblock */
 	if (order >= pageblock_order - 1) {
 		struct page *endpage = page + (1 << order) - 1;
 		for (; page < endpage; page += pageblock_nr_pages) {
@@ -1424,7 +1420,35 @@ int split_free_page(struct page *page)
 		}
 	}
 
-	return 1 << order;
+	return 1UL << order;
+}
+
+/*
+ * Similar to split_page except the page is already free. As this is only
+ * being used for migration, the migratetype of the block also changes.
+ * As this is called with interrupts disabled, the caller is responsible
+ * for calling arch_alloc_page() and kernel_map_page() after interrupts
+ * are enabled.
+ *
+ * Note: this is probably too low level an operation for use in drivers.
+ * Please consult with lkml before using this in your driver.
+ */
+int split_free_page(struct page *page)
+{
+	unsigned int order;
+	int nr_pages;
+
+	BUG_ON(!PageBuddy(page));
+	order = page_order(page);
+
+	nr_pages = capture_free_page(page, order, 0);
+	if (!nr_pages)
+		return 0;
+
+	/* Split into individual pages */
+	set_page_refcounted(page);
+	split_page(page, order);
+	return nr_pages;
 }
 
 /*
@@ -2104,7 +2128,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	bool *deferred_compaction,
 	unsigned long *did_some_progress)
 {
-	struct page *page;
+	struct page *page = NULL;
 
 	if (!order)
 		return NULL;
@@ -2116,10 +2140,16 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 
 	current->flags |= PF_MEMALLOC;
 	*did_some_progress = try_to_compact_pages(zonelist, order, gfp_mask,
-						nodemask, sync_migration);
+					nodemask, sync_migration, &page);
 	current->flags &= ~PF_MEMALLOC;
-	if (*did_some_progress != COMPACT_SKIPPED) {
 
+	/* If compaction captured a page, prep and use it */
+	if (page) {
+		prep_new_page(page, order, gfp_mask);
+		goto got_page;
+	}
+
+	if (*did_some_progress != COMPACT_SKIPPED) {
 		/* Page migration frees to the PCP lists but we want merging */
 		drain_pages(get_cpu());
 		put_cpu();
@@ -2129,6 +2159,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 				alloc_flags & ~ALLOC_NO_WATERMARKS,
 				preferred_zone, migratetype);
 		if (page) {
+got_page:
 			preferred_zone->compact_considered = 0;
 			preferred_zone->compact_defer_shift = 0;
 			if (order >= preferred_zone->compact_order_failed)
_

Patches currently in -mm which might be from mgorman@suse.de are

linux-next.patch
mm-hugetlbfs-correctly-populate-shared-pmd.patch
mm-hugetlbfs-correctly-populate-shared-pmd-fix.patch
alpha-redefine-atomic_init-and-atomic64_init-to-drop-the-casts.patch
netvm-check-for-page-==-null-when-propagating-the-skb-pfmemalloc-flag.patch
mm-correct-page-pfmemalloc-to-fix-deactivate_slab-regression.patch
mm-have-order-0-compaction-start-near-a-pageblock-with-free-pages-v2.patch
mm-compaction-abort-async-compaction-if-locks-are-contended-or-taking-too-long-v2.patch
mm-remove-__gfp_no_kswapd.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-have-order-0-compaction-start-near-a-pageblock-with-free-pages.patch
mm-compaction-abort-async-compaction-if-locks-are-contended-or-taking-too-long.patch

