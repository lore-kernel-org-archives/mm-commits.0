From: akpm@linux-foundation.org
Subject: + mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch added to -mm tree
Date: Mon, 22 Nov 2010 12:06:31 -0800
Message-ID: <201011222006.oAMK6VET006898@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757454Ab0KVUHW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Nov 2010 15:07:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, apw@shadowen.org, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     mm: migration: allow migration to operate asynchronously and avoid synchronous compaction in the faster path
has been added to the -mm tree.  Its filename is
     mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch

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
Subject: mm: migration: allow migration to operate asynchronously and avoid synchronous compaction in the faster path
From: Mel Gorman <mel@csn.ul.ie>

Migration synchronously waits for writeback if the initial passes fails. 
Callers of memory compaction do not necessarily want this behaviour if the
caller is latency sensitive or expects that synchronous migration is not
going to have a significantly better success rate.

This patch adds a sync parameter to migrate_pages() allowing the caller to
indicate if wait_on_page_writeback() is allowed within migration or not. 
For reclaim/compaction, try_to_compact_pages() is first called
asynchronously, direct reclaim runs and then try_to_compact_pages() is
called synchronously as there is a greater expectation that it'll succeed.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |   10 ++++++----
 include/linux/migrate.h    |   12 ++++++++----
 mm/compaction.c            |   14 ++++++++++----
 mm/memory-failure.c        |    3 ++-
 mm/memory_hotplug.c        |    3 ++-
 mm/mempolicy.c             |    4 ++--
 mm/migrate.c               |   22 +++++++++++++---------
 mm/page_alloc.c            |   21 +++++++++++++++------
 mm/vmscan.c                |    3 ++-
 9 files changed, 60 insertions(+), 32 deletions(-)

diff -puN include/linux/compaction.h~mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path include/linux/compaction.h
--- a/include/linux/compaction.h~mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path
+++ a/include/linux/compaction.h
@@ -21,10 +21,11 @@ extern int sysctl_extfrag_handler(struct
 
 extern int fragmentation_index(struct zone *zone, unsigned int order);
 extern unsigned long try_to_compact_pages(struct zonelist *zonelist,
-			int order, gfp_t gfp_mask, nodemask_t *mask);
+			int order, gfp_t gfp_mask, nodemask_t *mask,
+			bool sync);
 extern unsigned long compaction_suitable(struct zone *zone, int order);
 extern unsigned long compact_zone_order(struct zone *zone, int order,
-						gfp_t gfp_mask);
+						gfp_t gfp_mask, bool sync);
 
 /* Do not skip compaction more than 64 times */
 #define COMPACT_MAX_DEFER_SHIFT 6
@@ -57,7 +58,8 @@ static inline bool compaction_deferred(s
 
 #else
 static inline unsigned long try_to_compact_pages(struct zonelist *zonelist,
-			int order, gfp_t gfp_mask, nodemask_t *nodemask)
+			int order, gfp_t gfp_mask, nodemask_t *nodemask,
+			bool sync)
 {
 	return COMPACT_CONTINUE;
 }
@@ -68,7 +70,7 @@ static inline unsigned long compaction_s
 }
 
 extern unsigned long compact_zone_order(struct zone *zone, int order,
-						gfp_t gfp_mask)
+						gfp_t gfp_mask, bool sync)
 {
 	return 0;
 }
diff -puN include/linux/migrate.h~mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path include/linux/migrate.h
--- a/include/linux/migrate.h~mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path
+++ a/include/linux/migrate.h
@@ -13,9 +13,11 @@ extern void putback_lru_pages(struct lis
 extern int migrate_page(struct address_space *,
 			struct page *, struct page *);
 extern int migrate_pages(struct list_head *l, new_page_t x,
-			unsigned long private, int offlining);
+			unsigned long private, int offlining,
+			bool sync);
 extern int migrate_huge_pages(struct list_head *l, new_page_t x,
-			unsigned long private, int offlining);
+			unsigned long private, int offlining,
+			bool sync);
 
 extern int fail_migrate_page(struct address_space *,
 			struct page *, struct page *);
@@ -33,9 +35,11 @@ extern int migrate_huge_page_move_mappin
 
 static inline void putback_lru_pages(struct list_head *l) {}
 static inline int migrate_pages(struct list_head *l, new_page_t x,
-		unsigned long private, int offlining) { return -ENOSYS; }
+		unsigned long private, int offlining,
+		bool sync) { return -ENOSYS; }
 static inline int migrate_huge_pages(struct list_head *l, new_page_t x,
-		unsigned long private, int offlining) { return -ENOSYS; }
+		unsigned long private, int offlining,
+		bool sync) { return -ENOSYS; }
 
 static inline int migrate_prep(void) { return -ENOSYS; }
 static inline int migrate_prep_local(void) { return -ENOSYS; }
diff -puN mm/compaction.c~mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path mm/compaction.c
--- a/mm/compaction.c~mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path
+++ a/mm/compaction.c
@@ -33,6 +33,7 @@ struct compact_control {
 	unsigned long nr_migratepages;	/* Number of pages to migrate */
 	unsigned long free_pfn;		/* isolate_freepages search base */
 	unsigned long migrate_pfn;	/* isolate_migratepages search base */
+	bool sync;			/* Synchronous migration */
 
 	/* Account for isolated anon and file pages */
 	unsigned long nr_anon;
@@ -456,7 +457,8 @@ static int compact_zone(struct zone *zon
 
 		nr_migrate = cc->nr_migratepages;
 		migrate_pages(&cc->migratepages, compaction_alloc,
-						(unsigned long)cc, 0);
+				(unsigned long)cc, 0,
+				cc->sync);
 		update_nr_listpages(cc);
 		nr_remaining = cc->nr_migratepages;
 
@@ -483,7 +485,8 @@ static int compact_zone(struct zone *zon
 }
 
 unsigned long compact_zone_order(struct zone *zone,
-						int order, gfp_t gfp_mask)
+						int order, gfp_t gfp_mask,
+						bool sync)
 {
 	struct compact_control cc = {
 		.nr_freepages = 0,
@@ -491,6 +494,7 @@ unsigned long compact_zone_order(struct 
 		.order = order,
 		.migratetype = allocflags_to_migratetype(gfp_mask),
 		.zone = zone,
+		.sync = sync,
 	};
 	INIT_LIST_HEAD(&cc.freepages);
 	INIT_LIST_HEAD(&cc.migratepages);
@@ -506,11 +510,13 @@ int sysctl_extfrag_threshold = 500;
  * @order: The order of the current allocation
  * @gfp_mask: The GFP mask of the current allocation
  * @nodemask: The allowed nodes to allocate from
+ * @sync: Whether migration is synchronous or not
  *
  * This is the main entry point for direct page compaction.
  */
 unsigned long try_to_compact_pages(struct zonelist *zonelist,
-			int order, gfp_t gfp_mask, nodemask_t *nodemask)
+			int order, gfp_t gfp_mask, nodemask_t *nodemask,
+			bool sync)
 {
 	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
 	int may_enter_fs = gfp_mask & __GFP_FS;
@@ -534,7 +540,7 @@ unsigned long try_to_compact_pages(struc
 								nodemask) {
 		int status;
 
-		status = compact_zone_order(zone, order, gfp_mask);
+		status = compact_zone_order(zone, order, gfp_mask, sync);
 		rc = max(status, rc);
 
 		/* If a normal allocation would succeed, stop compacting */
diff -puN mm/memory-failure.c~mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path mm/memory-failure.c
--- a/mm/memory-failure.c~mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path
+++ a/mm/memory-failure.c
@@ -1413,7 +1413,8 @@ int soft_offline_page(struct page *page,
 		LIST_HEAD(pagelist);
 
 		list_add(&page->lru, &pagelist);
-		ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL, 0);
+		ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL,
+								0, true);
 		if (ret) {
 			pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
 				pfn, ret, page->flags);
diff -puN mm/memory_hotplug.c~mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path
+++ a/mm/memory_hotplug.c
@@ -714,7 +714,8 @@ do_migrate_range(unsigned long start_pfn
 			goto out;
 		}
 		/* this function returns # of failed pages */
-		ret = migrate_pages(&source, hotremove_migrate_alloc, 0, 1);
+		ret = migrate_pages(&source, hotremove_migrate_alloc, 0,
+								1, true);
 		if (ret)
 			putback_lru_pages(&source);
 	}
diff -puN mm/mempolicy.c~mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path mm/mempolicy.c
--- a/mm/mempolicy.c~mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path
+++ a/mm/mempolicy.c
@@ -935,7 +935,7 @@ static int migrate_to_node(struct mm_str
 		return PTR_ERR(vma);
 
 	if (!list_empty(&pagelist)) {
-		err = migrate_pages(&pagelist, new_node_page, dest, 0);
+		err = migrate_pages(&pagelist, new_node_page, dest, 0, true);
 		if (err)
 			putback_lru_pages(&pagelist);
 	}
@@ -1155,7 +1155,7 @@ static long do_mbind(unsigned long start
 
 		if (!list_empty(&pagelist)) {
 			nr_failed = migrate_pages(&pagelist, new_vma_page,
-						(unsigned long)vma, 0);
+						(unsigned long)vma, 0, true);
 			if (nr_failed)
 				putback_lru_pages(&pagelist);
 		}
diff -puN mm/migrate.c~mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path mm/migrate.c
--- a/mm/migrate.c~mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path
+++ a/mm/migrate.c
@@ -612,7 +612,7 @@ static int move_to_new_page(struct page 
  * to the newly allocated page in newpage.
  */
 static int unmap_and_move(new_page_t get_new_page, unsigned long private,
-			struct page *page, int force, int offlining)
+			struct page *page, int force, int offlining, bool sync)
 {
 	int rc = 0;
 	int *result = NULL;
@@ -663,7 +663,7 @@ static int unmap_and_move(new_page_t get
 	BUG_ON(charge);
 
 	if (PageWriteback(page)) {
-		if (!force)
+		if (!force || !sync)
 			goto uncharge;
 		wait_on_page_writeback(page);
 	}
@@ -808,7 +808,7 @@ move_newpage:
  */
 static int unmap_and_move_huge_page(new_page_t get_new_page,
 				unsigned long private, struct page *hpage,
-				int force, int offlining)
+				int force, int offlining, bool sync)
 {
 	int rc = 0;
 	int *result = NULL;
@@ -822,7 +822,7 @@ static int unmap_and_move_huge_page(new_
 	rc = -EAGAIN;
 
 	if (!trylock_page(hpage)) {
-		if (!force)
+		if (!force || !sync)
 			goto out;
 		lock_page(hpage);
 	}
@@ -890,7 +890,8 @@ out:
  * Return: Number of pages not migrated or error code.
  */
 int migrate_pages(struct list_head *from,
-		new_page_t get_new_page, unsigned long private, int offlining)
+		new_page_t get_new_page, unsigned long private, int offlining,
+		bool sync)
 {
 	int retry = 1;
 	int nr_failed = 0;
@@ -910,7 +911,8 @@ int migrate_pages(struct list_head *from
 			cond_resched();
 
 			rc = unmap_and_move(get_new_page, private,
-						page, pass > 2, offlining);
+						page, pass > 2, offlining,
+						sync);
 
 			switch(rc) {
 			case -ENOMEM:
@@ -939,7 +941,8 @@ out:
 }
 
 int migrate_huge_pages(struct list_head *from,
-		new_page_t get_new_page, unsigned long private, int offlining)
+		new_page_t get_new_page, unsigned long private, int offlining,
+		bool sync)
 {
 	int retry = 1;
 	int nr_failed = 0;
@@ -955,7 +958,8 @@ int migrate_huge_pages(struct list_head 
 			cond_resched();
 
 			rc = unmap_and_move_huge_page(get_new_page,
-					private, page, pass > 2, offlining);
+					private, page, pass > 2, offlining,
+					sync);
 
 			switch(rc) {
 			case -ENOMEM:
@@ -1088,7 +1092,7 @@ set_status:
 	err = 0;
 	if (!list_empty(&pagelist)) {
 		err = migrate_pages(&pagelist, new_page_node,
-				(unsigned long)pm, 0);
+				(unsigned long)pm, 0, true);
 		if (err)
 			putback_lru_pages(&pagelist);
 	}
diff -puN mm/page_alloc.c~mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path mm/page_alloc.c
--- a/mm/page_alloc.c~mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path
+++ a/mm/page_alloc.c
@@ -1807,7 +1807,8 @@ static struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	int migratetype, unsigned long *did_some_progress)
+	int migratetype, unsigned long *did_some_progress,
+	bool sync_migration)
 {
 	struct page *page;
 
@@ -1815,7 +1816,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 		return NULL;
 
 	*did_some_progress = try_to_compact_pages(zonelist, order, gfp_mask,
-								nodemask);
+						nodemask, sync_migration);
 	if (*did_some_progress != COMPACT_SKIPPED) {
 
 		/* Page migration frees to the PCP lists but we want merging */
@@ -1851,7 +1852,8 @@ static inline struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	int migratetype, unsigned long *did_some_progress)
+	int migratetype, unsigned long *did_some_progress,
+	bool sync_migration)
 {
 	return NULL;
 }
@@ -1993,6 +1995,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	unsigned long pages_reclaimed = 0;
 	unsigned long did_some_progress;
 	struct task_struct *p = current;
+	bool sync_migration = false;
 
 	/*
 	 * In the slowpath, we sanity check order to avoid ever trying to
@@ -2055,14 +2058,19 @@ rebalance:
 	if (test_thread_flag(TIF_MEMDIE) && !(gfp_mask & __GFP_NOFAIL))
 		goto nopage;
 
-	/* Try direct compaction */
+	/*
+	 * Try direct compaction. The first pass is asynchronous. Subsequent
+	 * attempts after direct reclaim are synchronous
+	 */
 	page = __alloc_pages_direct_compact(gfp_mask, order,
 					zonelist, high_zoneidx,
 					nodemask,
 					alloc_flags, preferred_zone,
-					migratetype, &did_some_progress);
+					migratetype, &did_some_progress,
+					sync_migration);
 	if (page)
 		goto got_pg;
+	sync_migration = true;
 
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order,
@@ -2126,7 +2134,8 @@ rebalance:
 					zonelist, high_zoneidx,
 					nodemask,
 					alloc_flags, preferred_zone,
-					migratetype, &did_some_progress);
+					migratetype, &did_some_progress,
+					sync_migration);
 		if (page)
 			goto got_pg;
 	}
diff -puN mm/vmscan.c~mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path mm/vmscan.c
--- a/mm/vmscan.c~mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path
+++ a/mm/vmscan.c
@@ -2370,7 +2370,8 @@ loop_again:
 			 * would ordinarily call try_to_compact_pages()
 			 */
 			if (sc.order > PAGE_ALLOC_COSTLY_ORDER)
-				compact_zone_order(zone, sc.order, sc.gfp_mask);
+				compact_zone_order(zone, sc.order, sc.gfp_mask,
+							false);
 
 			if (!zone_watermark_ok_safe(zone, order,
 					high_wmark_pages(zone), end_zone, 0)) {
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
mm-remove-call-to-find_vma-in-pagewalk-for-non-hugetlbfs.patch
mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-update.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix-set_pgdat_percpu_threshold-dont-use-for_each_online_cpu.patch
writeback-io-less-balance_dirty_pages.patch
writeback-consolidate-variable-names-in-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages-fix.patch
writeback-prevent-duplicate-balance_dirty_pages_ratelimited-calls.patch
writeback-account-per-bdi-accumulated-written-pages.patch
writeback-bdi-write-bandwidth-estimation.patch
writeback-bdi-write-bandwidth-estimation-fix.patch
writeback-show-bdi-write-bandwidth-in-debugfs.patch
writeback-quit-throttling-when-bdi-dirty-pages-dropped-low.patch
writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch
writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
vmscan-factor-out-kswapd-sleeping-logic-from-kswapd.patch
mm-compaction-add-trace-events-for-memory-compaction-activity.patch
mm-vmscan-convert-lumpy_mode-into-a-bitmask.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch
mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode.patch
add-debugging-aid-for-memory-initialisation-problems.patch

