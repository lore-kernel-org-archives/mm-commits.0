From: akpm@linux-foundation.org
Subject: [merged] mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:44:57 -0800
Message-ID: <201101142247.p0EMllnW005034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752860Ab1ANWsN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:48:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, aarcange@redhat.com, apw@shadowen.org, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: migration: allow migration to operate asynchronously and avoid synchronous compaction in the faster path
has been removed from the -mm tree.  Its filename was
     mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: build/merge fix]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |   10 ++++++----
 include/linux/migrate.h    |   12 ++++++++----
 mm/compaction.c            |   14 ++++++++++----
 mm/memory-failure.c        |    8 +++++---
 mm/memory_hotplug.c        |    3 ++-
 mm/mempolicy.c             |    4 ++--
 mm/migrate.c               |   22 +++++++++++++---------
 mm/page_alloc.c            |   21 +++++++++++++++------
 mm/vmscan.c                |    3 ++-
 9 files changed, 63 insertions(+), 34 deletions(-)

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
 
 static inline unsigned long compact_zone_order(struct zone *zone, int order,
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
@@ -455,7 +456,8 @@ static int compact_zone(struct zone *zon
 
 		nr_migrate = cc->nr_migratepages;
 		migrate_pages(&cc->migratepages, compaction_alloc,
-						(unsigned long)cc, 0);
+				(unsigned long)cc, 0,
+				cc->sync);
 		update_nr_listpages(cc);
 		nr_remaining = cc->nr_migratepages;
 
@@ -482,7 +484,8 @@ static int compact_zone(struct zone *zon
 }
 
 unsigned long compact_zone_order(struct zone *zone,
-						int order, gfp_t gfp_mask)
+						int order, gfp_t gfp_mask,
+						bool sync)
 {
 	struct compact_control cc = {
 		.nr_freepages = 0,
@@ -490,6 +493,7 @@ unsigned long compact_zone_order(struct 
 		.order = order,
 		.migratetype = allocflags_to_migratetype(gfp_mask),
 		.zone = zone,
+		.sync = sync,
 	};
 	INIT_LIST_HEAD(&cc.freepages);
 	INIT_LIST_HEAD(&cc.migratepages);
@@ -505,11 +509,13 @@ int sysctl_extfrag_threshold = 500;
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
@@ -533,7 +539,7 @@ unsigned long try_to_compact_pages(struc
 								nodemask) {
 		int status;
 
-		status = compact_zone_order(zone, order, gfp_mask);
+		status = compact_zone_order(zone, order, gfp_mask, sync);
 		rc = max(status, rc);
 
 		/* If a normal allocation would succeed, stop compacting */
diff -puN mm/memory-failure.c~mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path mm/memory-failure.c
--- a/mm/memory-failure.c~mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path
+++ a/mm/memory-failure.c
@@ -1290,9 +1290,10 @@ static int soft_offline_huge_page(struct
 	/* Keep page count to indicate a given hugepage is isolated. */
 
 	list_add(&hpage->lru, &pagelist);
-	ret = migrate_huge_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL, 0);
+	ret = migrate_huge_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL, 0,
+				true);
 	if (ret) {
-			putback_lru_pages(&pagelist);
+		putback_lru_pages(&pagelist);
 		pr_debug("soft offline: %#lx: migration failed %d, type %lx\n",
 			 pfn, ret, page->flags);
 		if (ret > 0)
@@ -1413,7 +1414,8 @@ int soft_offline_page(struct page *page,
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
@@ -733,7 +733,8 @@ do_migrate_range(unsigned long start_pfn
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
@@ -614,7 +614,7 @@ static int move_to_new_page(struct page 
  * to the newly allocated page in newpage.
  */
 static int unmap_and_move(new_page_t get_new_page, unsigned long private,
-			struct page *page, int force, int offlining)
+			struct page *page, int force, int offlining, bool sync)
 {
 	int rc = 0;
 	int *result = NULL;
@@ -682,7 +682,7 @@ static int unmap_and_move(new_page_t get
 	BUG_ON(charge);
 
 	if (PageWriteback(page)) {
-		if (!force)
+		if (!force || !sync)
 			goto uncharge;
 		wait_on_page_writeback(page);
 	}
@@ -827,7 +827,7 @@ move_newpage:
  */
 static int unmap_and_move_huge_page(new_page_t get_new_page,
 				unsigned long private, struct page *hpage,
-				int force, int offlining)
+				int force, int offlining, bool sync)
 {
 	int rc = 0;
 	int *result = NULL;
@@ -841,7 +841,7 @@ static int unmap_and_move_huge_page(new_
 	rc = -EAGAIN;
 
 	if (!trylock_page(hpage)) {
-		if (!force)
+		if (!force || !sync)
 			goto out;
 		lock_page(hpage);
 	}
@@ -909,7 +909,8 @@ out:
  * Return: Number of pages not migrated or error code.
  */
 int migrate_pages(struct list_head *from,
-		new_page_t get_new_page, unsigned long private, int offlining)
+		new_page_t get_new_page, unsigned long private, int offlining,
+		bool sync)
 {
 	int retry = 1;
 	int nr_failed = 0;
@@ -929,7 +930,8 @@ int migrate_pages(struct list_head *from
 			cond_resched();
 
 			rc = unmap_and_move(get_new_page, private,
-						page, pass > 2, offlining);
+						page, pass > 2, offlining,
+						sync);
 
 			switch(rc) {
 			case -ENOMEM:
@@ -958,7 +960,8 @@ out:
 }
 
 int migrate_huge_pages(struct list_head *from,
-		new_page_t get_new_page, unsigned long private, int offlining)
+		new_page_t get_new_page, unsigned long private, int offlining,
+		bool sync)
 {
 	int retry = 1;
 	int nr_failed = 0;
@@ -974,7 +977,8 @@ int migrate_huge_pages(struct list_head 
 			cond_resched();
 
 			rc = unmap_and_move_huge_page(get_new_page,
-					private, page, pass > 2, offlining);
+					private, page, pass > 2, offlining,
+					sync);
 
 			switch(rc) {
 			case -ENOMEM:
@@ -1107,7 +1111,7 @@ set_status:
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
@@ -1812,7 +1812,8 @@ static struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	int migratetype, unsigned long *did_some_progress)
+	int migratetype, unsigned long *did_some_progress,
+	bool sync_migration)
 {
 	struct page *page;
 	struct task_struct *tsk = current;
@@ -1822,7 +1823,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 
 	tsk->flags |= PF_MEMALLOC;
 	*did_some_progress = try_to_compact_pages(zonelist, order, gfp_mask,
-								nodemask);
+						nodemask, sync_migration);
 	tsk->flags &= ~PF_MEMALLOC;
 	if (*did_some_progress != COMPACT_SKIPPED) {
 
@@ -1859,7 +1860,8 @@ static inline struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	int migratetype, unsigned long *did_some_progress)
+	int migratetype, unsigned long *did_some_progress,
+	bool sync_migration)
 {
 	return NULL;
 }
@@ -2001,6 +2003,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	unsigned long pages_reclaimed = 0;
 	unsigned long did_some_progress;
 	struct task_struct *p = current;
+	bool sync_migration = false;
 
 	/*
 	 * In the slowpath, we sanity check order to avoid ever trying to
@@ -2063,14 +2066,19 @@ rebalance:
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
@@ -2134,7 +2142,8 @@ rebalance:
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
@@ -2377,7 +2377,8 @@ loop_again:
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

origin.patch
linux-next.patch
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
thp-add-pagetranscompound.patch
add-debugging-aid-for-memory-initialisation-problems.patch

