From: akpm@linux-foundation.org
Subject: - vmscan-use-an-indexed-array-for-lru-variables.patch removed from -mm tree
Date: Wed, 11 Jun 2008 12:45:53 -0700
Message-ID: <200806111945.m5BJjra3014529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751527AbYFKTq1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 15:46:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, lee.schermerhorn@hp.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: Use an indexed array for LRU variables
has been removed from the -mm tree.  Its filename was
     vmscan-use-an-indexed-array-for-lru-variables.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: Use an indexed array for LRU variables
From: Christoph Lameter <clameter@sgi.com>

Currently we are defining explicit variables for the inactive and active
list.  An indexed array can be more generic and avoid repeating similar
code in several places in the reclaim code.

We are saving a few bytes in terms of code size:

Before:

   text    data     bss     dec     hex filename
4097753  573120 4092484 8763357  85b7dd vmlinux

After:

   text    data     bss     dec     hex filename
4097729  573120 4092484 8763333  85b7c5 vmlinux

Having an easy way to add new lru lists may ease future work on the
reclaim code.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   17 +---
 include/linux/mm_inline.h  |   33 ++++++---
 include/linux/mmzone.h     |   17 +++-
 mm/memcontrol.c            |  115 ++++++++++++---------------------
 mm/page_alloc.c            |    9 +-
 mm/swap.c                  |    2 
 mm/vmscan.c                |  120 ++++++++++++++++-------------------
 mm/vmstat.c                |    3 
 8 files changed, 146 insertions(+), 170 deletions(-)

diff -puN include/linux/memcontrol.h~vmscan-use-an-indexed-array-for-lru-variables include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~vmscan-use-an-indexed-array-for-lru-variables
+++ a/include/linux/memcontrol.h
@@ -69,10 +69,8 @@ extern void mem_cgroup_note_reclaim_prio
 extern void mem_cgroup_record_reclaim_priority(struct mem_cgroup *mem,
 							int priority);
 
-extern long mem_cgroup_calc_reclaim_active(struct mem_cgroup *mem,
-				struct zone *zone, int priority);
-extern long mem_cgroup_calc_reclaim_inactive(struct mem_cgroup *mem,
-				struct zone *zone, int priority);
+extern long mem_cgroup_calc_reclaim(struct mem_cgroup *mem, struct zone *zone,
+					int priority, enum lru_list lru);
 
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 static inline void page_reset_bad_cgroup(struct page *page)
@@ -159,14 +157,9 @@ static inline void mem_cgroup_record_rec
 {
 }
 
-static inline long mem_cgroup_calc_reclaim_active(struct mem_cgroup *mem,
-					struct zone *zone, int priority)
-{
-	return 0;
-}
-
-static inline long mem_cgroup_calc_reclaim_inactive(struct mem_cgroup *mem,
-					struct zone *zone, int priority)
+static inline long mem_cgroup_calc_reclaim(struct mem_cgroup *mem,
+					struct zone *zone, int priority,
+					enum lru_list lru)
 {
 	return 0;
 }
diff -puN include/linux/mm_inline.h~vmscan-use-an-indexed-array-for-lru-variables include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~vmscan-use-an-indexed-array-for-lru-variables
+++ a/include/linux/mm_inline.h
@@ -1,40 +1,51 @@
 static inline void
+add_page_to_lru_list(struct zone *zone, struct page *page, enum lru_list l)
+{
+	list_add(&page->lru, &zone->list[l]);
+	__inc_zone_state(zone, NR_INACTIVE + l);
+}
+
+static inline void
+del_page_from_lru_list(struct zone *zone, struct page *page, enum lru_list l)
+{
+	list_del(&page->lru);
+	__dec_zone_state(zone, NR_INACTIVE + l);
+}
+
+static inline void
 add_page_to_active_list(struct zone *zone, struct page *page)
 {
-	list_add(&page->lru, &zone->active_list);
-	__inc_zone_state(zone, NR_ACTIVE);
+	add_page_to_lru_list(zone, page, LRU_ACTIVE);
 }
 
 static inline void
 add_page_to_inactive_list(struct zone *zone, struct page *page)
 {
-	list_add(&page->lru, &zone->inactive_list);
-	__inc_zone_state(zone, NR_INACTIVE);
+	add_page_to_lru_list(zone, page, LRU_INACTIVE);
 }
 
 static inline void
 del_page_from_active_list(struct zone *zone, struct page *page)
 {
-	list_del(&page->lru);
-	__dec_zone_state(zone, NR_ACTIVE);
+	del_page_from_lru_list(zone, page, LRU_ACTIVE);
 }
 
 static inline void
 del_page_from_inactive_list(struct zone *zone, struct page *page)
 {
-	list_del(&page->lru);
-	__dec_zone_state(zone, NR_INACTIVE);
+	del_page_from_lru_list(zone, page, LRU_INACTIVE);
 }
 
 static inline void
 del_page_from_lru(struct zone *zone, struct page *page)
 {
+	enum lru_list l = LRU_INACTIVE;
+
 	list_del(&page->lru);
 	if (PageActive(page)) {
 		__ClearPageActive(page);
-		__dec_zone_state(zone, NR_ACTIVE);
-	} else {
-		__dec_zone_state(zone, NR_INACTIVE);
+		l = LRU_ACTIVE;
 	}
+	__dec_zone_state(zone, NR_INACTIVE + l);
 }
 
diff -puN include/linux/mmzone.h~vmscan-use-an-indexed-array-for-lru-variables include/linux/mmzone.h
--- a/include/linux/mmzone.h~vmscan-use-an-indexed-array-for-lru-variables
+++ a/include/linux/mmzone.h
@@ -81,8 +81,8 @@ struct zone_padding {
 enum zone_stat_item {
 	/* First 128 byte cacheline (assuming 64 bit words) */
 	NR_FREE_PAGES,
-	NR_INACTIVE,
-	NR_ACTIVE,
+	NR_INACTIVE,	/* must match order of LRU_[IN]ACTIVE */
+	NR_ACTIVE,	/*  "     "     "   "       "         */
 	NR_ANON_PAGES,	/* Mapped anonymous pages */
 	NR_FILE_MAPPED,	/* pagecache pages mapped into pagetables.
 			   only modified from process context */
@@ -107,6 +107,13 @@ enum zone_stat_item {
 #endif
 	NR_VM_ZONE_STAT_ITEMS };
 
+enum lru_list {
+	LRU_INACTIVE,	/* must match order of NR_[IN]ACTIVE */
+	LRU_ACTIVE,	/*  "     "     "   "       "        */
+	NR_LRU_LISTS };
+
+#define for_each_lru(l) for (l = 0; l < NR_LRU_LISTS; l++)
+
 struct per_cpu_pages {
 	int count;		/* number of pages in the list */
 	int high;		/* high watermark, emptying needed */
@@ -251,10 +258,8 @@ struct zone {
 
 	/* Fields commonly accessed by the page reclaim scanner */
 	spinlock_t		lru_lock;	
-	struct list_head	active_list;
-	struct list_head	inactive_list;
-	unsigned long		nr_scan_active;
-	unsigned long		nr_scan_inactive;
+	struct list_head	list[NR_LRU_LISTS];
+	unsigned long		nr_scan[NR_LRU_LISTS];
 	unsigned long		pages_scanned;	   /* since last reclaim */
 	unsigned long		flags;		   /* zone flags, see below */
 
diff -puN mm/memcontrol.c~vmscan-use-an-indexed-array-for-lru-variables mm/memcontrol.c
--- a/mm/memcontrol.c~vmscan-use-an-indexed-array-for-lru-variables
+++ a/mm/memcontrol.c
@@ -32,6 +32,7 @@
 #include <linux/fs.h>
 #include <linux/seq_file.h>
 #include <linux/vmalloc.h>
+#include <linux/mm_inline.h>
 
 #include <asm/uaccess.h>
 
@@ -85,22 +86,13 @@ static s64 mem_cgroup_read_stat(struct m
 /*
  * per-zone information in memory controller.
  */
-
-enum mem_cgroup_zstat_index {
-	MEM_CGROUP_ZSTAT_ACTIVE,
-	MEM_CGROUP_ZSTAT_INACTIVE,
-
-	NR_MEM_CGROUP_ZSTAT,
-};
-
 struct mem_cgroup_per_zone {
 	/*
 	 * spin_lock to protect the per cgroup LRU
 	 */
 	spinlock_t		lru_lock;
-	struct list_head	active_list;
-	struct list_head	inactive_list;
-	unsigned long count[NR_MEM_CGROUP_ZSTAT];
+	struct list_head	lists[NR_LRU_LISTS];
+	unsigned long		count[NR_LRU_LISTS];
 };
 /* Macro for accessing counter */
 #define MEM_CGROUP_ZSTAT(mz, idx)	((mz)->count[(idx)])
@@ -227,7 +219,7 @@ page_cgroup_zoneinfo(struct page_cgroup 
 }
 
 static unsigned long mem_cgroup_get_all_zonestat(struct mem_cgroup *mem,
-					enum mem_cgroup_zstat_index idx)
+					enum lru_list idx)
 {
 	int nid, zid;
 	struct mem_cgroup_per_zone *mz;
@@ -289,11 +281,9 @@ static void __mem_cgroup_remove_list(str
 			struct page_cgroup *pc)
 {
 	int from = pc->flags & PAGE_CGROUP_FLAG_ACTIVE;
+	int lru = !!from;
 
-	if (from)
-		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_ACTIVE) -= 1;
-	else
-		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_INACTIVE) -= 1;
+	MEM_CGROUP_ZSTAT(mz, lru) -= 1;
 
 	mem_cgroup_charge_statistics(pc->mem_cgroup, pc->flags, false);
 	list_del(&pc->lru);
@@ -302,37 +292,35 @@ static void __mem_cgroup_remove_list(str
 static void __mem_cgroup_add_list(struct mem_cgroup_per_zone *mz,
 				struct page_cgroup *pc)
 {
-	int to = pc->flags & PAGE_CGROUP_FLAG_ACTIVE;
+	int lru = LRU_INACTIVE;
+
+	if (pc->flags & PAGE_CGROUP_FLAG_ACTIVE)
+		lru += LRU_ACTIVE;
+
+	MEM_CGROUP_ZSTAT(mz, lru) += 1;
+	list_add(&pc->lru, &mz->lists[lru]);
 
-	if (!to) {
-		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_INACTIVE) += 1;
-		list_add(&pc->lru, &mz->inactive_list);
-	} else {
-		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_ACTIVE) += 1;
-		list_add(&pc->lru, &mz->active_list);
-	}
 	mem_cgroup_charge_statistics(pc->mem_cgroup, pc->flags, true);
 }
 
 static void __mem_cgroup_move_lists(struct page_cgroup *pc, bool active)
 {
-	int from = pc->flags & PAGE_CGROUP_FLAG_ACTIVE;
 	struct mem_cgroup_per_zone *mz = page_cgroup_zoneinfo(pc);
+	int lru = LRU_INACTIVE;
 
-	if (from)
-		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_ACTIVE) -= 1;
-	else
-		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_INACTIVE) -= 1;
+	if (pc->flags & PAGE_CGROUP_FLAG_ACTIVE)
+		lru += LRU_ACTIVE;
 
-	if (active) {
-		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_ACTIVE) += 1;
+	MEM_CGROUP_ZSTAT(mz, lru) -= 1;
+
+	if (active)
 		pc->flags |= PAGE_CGROUP_FLAG_ACTIVE;
-		list_move(&pc->lru, &mz->active_list);
-	} else {
-		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_INACTIVE) += 1;
+	else
 		pc->flags &= ~PAGE_CGROUP_FLAG_ACTIVE;
-		list_move(&pc->lru, &mz->inactive_list);
-	}
+
+	lru = !!active;
+	MEM_CGROUP_ZSTAT(mz, lru) += 1;
+	list_move(&pc->lru, &mz->lists[lru]);
 }
 
 int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem)
@@ -401,8 +389,8 @@ long mem_cgroup_reclaim_imbalance(struct
 {
 	unsigned long active, inactive;
 	/* active and inactive are the number of pages. 'long' is ok.*/
-	active = mem_cgroup_get_all_zonestat(mem, MEM_CGROUP_ZSTAT_ACTIVE);
-	inactive = mem_cgroup_get_all_zonestat(mem, MEM_CGROUP_ZSTAT_INACTIVE);
+	active = mem_cgroup_get_all_zonestat(mem, LRU_ACTIVE);
+	inactive = mem_cgroup_get_all_zonestat(mem, LRU_INACTIVE);
 	return (long) (active / (inactive + 1));
 }
 
@@ -433,28 +421,17 @@ void mem_cgroup_record_reclaim_priority(
  * (see include/linux/mmzone.h)
  */
 
-long mem_cgroup_calc_reclaim_active(struct mem_cgroup *mem,
-				   struct zone *zone, int priority)
+long mem_cgroup_calc_reclaim(struct mem_cgroup *mem, struct zone *zone,
+					int priority, enum lru_list lru)
 {
-	long nr_active;
+	long nr_pages;
 	int nid = zone->zone_pgdat->node_id;
 	int zid = zone_idx(zone);
 	struct mem_cgroup_per_zone *mz = mem_cgroup_zoneinfo(mem, nid, zid);
 
-	nr_active = MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_ACTIVE);
-	return (nr_active >> priority);
-}
-
-long mem_cgroup_calc_reclaim_inactive(struct mem_cgroup *mem,
-					struct zone *zone, int priority)
-{
-	long nr_inactive;
-	int nid = zone->zone_pgdat->node_id;
-	int zid = zone_idx(zone);
-	struct mem_cgroup_per_zone *mz = mem_cgroup_zoneinfo(mem, nid, zid);
+	nr_pages = MEM_CGROUP_ZSTAT(mz, lru);
 
-	nr_inactive = MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_INACTIVE);
-	return (nr_inactive >> priority);
+	return (nr_pages >> priority);
 }
 
 unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
@@ -473,14 +450,11 @@ unsigned long mem_cgroup_isolate_pages(u
 	int nid = z->zone_pgdat->node_id;
 	int zid = zone_idx(z);
 	struct mem_cgroup_per_zone *mz;
+	int lru = !!active;
 
 	BUG_ON(!mem_cont);
 	mz = mem_cgroup_zoneinfo(mem_cont, nid, zid);
-	if (active)
-		src = &mz->active_list;
-	else
-		src = &mz->inactive_list;
-
+	src = &mz->lists[lru];
 
 	spin_lock(&mz->lru_lock);
 	scan = 0;
@@ -798,7 +772,7 @@ int mem_cgroup_shrink_usage(struct mm_st
 #define FORCE_UNCHARGE_BATCH	(128)
 static void mem_cgroup_force_empty_list(struct mem_cgroup *mem,
 			    struct mem_cgroup_per_zone *mz,
-			    int active)
+			    enum lru_list lru)
 {
 	struct page_cgroup *pc;
 	struct page *page;
@@ -806,10 +780,7 @@ static void mem_cgroup_force_empty_list(
 	unsigned long flags;
 	struct list_head *list;
 
-	if (active)
-		list = &mz->active_list;
-	else
-		list = &mz->inactive_list;
+	list = &mz->lists[lru];
 
 	spin_lock_irqsave(&mz->lru_lock, flags);
 	while (!list_empty(list)) {
@@ -857,11 +828,10 @@ static int mem_cgroup_force_empty(struct
 		for_each_node_state(node, N_POSSIBLE)
 			for (zid = 0; zid < MAX_NR_ZONES; zid++) {
 				struct mem_cgroup_per_zone *mz;
+				enum lru_list l;
 				mz = mem_cgroup_zoneinfo(mem, node, zid);
-				/* drop all page_cgroup in active_list */
-				mem_cgroup_force_empty_list(mem, mz, 1);
-				/* drop all page_cgroup in inactive_list */
-				mem_cgroup_force_empty_list(mem, mz, 0);
+				for_each_lru(l)
+					mem_cgroup_force_empty_list(mem, mz, l);
 			}
 	}
 	ret = 0;
@@ -948,9 +918,9 @@ static int mem_control_stat_show(struct 
 		unsigned long active, inactive;
 
 		inactive = mem_cgroup_get_all_zonestat(mem_cont,
-						MEM_CGROUP_ZSTAT_INACTIVE);
+						LRU_INACTIVE);
 		active = mem_cgroup_get_all_zonestat(mem_cont,
-						MEM_CGROUP_ZSTAT_ACTIVE);
+						LRU_ACTIVE);
 		cb->fill(cb, "active", (active) * PAGE_SIZE);
 		cb->fill(cb, "inactive", (inactive) * PAGE_SIZE);
 	}
@@ -995,6 +965,7 @@ static int alloc_mem_cgroup_per_zone_inf
 {
 	struct mem_cgroup_per_node *pn;
 	struct mem_cgroup_per_zone *mz;
+	enum lru_list l;
 	int zone, tmp = node;
 	/*
 	 * This routine is called against possible nodes.
@@ -1015,9 +986,9 @@ static int alloc_mem_cgroup_per_zone_inf
 
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		mz = &pn->zoneinfo[zone];
-		INIT_LIST_HEAD(&mz->active_list);
-		INIT_LIST_HEAD(&mz->inactive_list);
 		spin_lock_init(&mz->lru_lock);
+		for_each_lru(l)
+			INIT_LIST_HEAD(&mz->lists[l]);
 	}
 	return 0;
 }
diff -puN mm/page_alloc.c~vmscan-use-an-indexed-array-for-lru-variables mm/page_alloc.c
--- a/mm/page_alloc.c~vmscan-use-an-indexed-array-for-lru-variables
+++ a/mm/page_alloc.c
@@ -3367,6 +3367,7 @@ static void __paginginit free_area_init_
 	for (j = 0; j < MAX_NR_ZONES; j++) {
 		struct zone *zone = pgdat->node_zones + j;
 		unsigned long size, realsize, memmap_pages;
+		enum lru_list l;
 
 		size = zone_spanned_pages_in_node(nid, j, zones_size);
 		realsize = size - zone_absent_pages_in_node(nid, j,
@@ -3418,10 +3419,10 @@ static void __paginginit free_area_init_
 		zone->prev_priority = DEF_PRIORITY;
 
 		zone_pcp_init(zone);
-		INIT_LIST_HEAD(&zone->active_list);
-		INIT_LIST_HEAD(&zone->inactive_list);
-		zone->nr_scan_active = 0;
-		zone->nr_scan_inactive = 0;
+		for_each_lru(l) {
+			INIT_LIST_HEAD(&zone->list[l]);
+			zone->nr_scan[l] = 0;
+		}
 		zap_zone_vm_stats(zone);
 		zone->flags = 0;
 		if (!size)
diff -puN mm/swap.c~vmscan-use-an-indexed-array-for-lru-variables mm/swap.c
--- a/mm/swap.c~vmscan-use-an-indexed-array-for-lru-variables
+++ a/mm/swap.c
@@ -117,7 +117,7 @@ static void pagevec_move_tail(struct pag
 			spin_lock(&zone->lru_lock);
 		}
 		if (PageLRU(page) && !PageActive(page)) {
-			list_move_tail(&page->lru, &zone->inactive_list);
+			list_move_tail(&page->lru, &zone->list[LRU_INACTIVE]);
 			pgmoved++;
 		}
 	}
diff -puN mm/vmscan.c~vmscan-use-an-indexed-array-for-lru-variables mm/vmscan.c
--- a/mm/vmscan.c~vmscan-use-an-indexed-array-for-lru-variables
+++ a/mm/vmscan.c
@@ -817,10 +817,10 @@ static unsigned long isolate_pages_globa
 					int active)
 {
 	if (active)
-		return isolate_lru_pages(nr, &z->active_list, dst,
+		return isolate_lru_pages(nr, &z->list[LRU_ACTIVE], dst,
 						scanned, order, mode);
 	else
-		return isolate_lru_pages(nr, &z->inactive_list, dst,
+		return isolate_lru_pages(nr, &z->list[LRU_INACTIVE], dst,
 						scanned, order, mode);
 }
 
@@ -971,10 +971,7 @@ static unsigned long shrink_inactive_lis
 			VM_BUG_ON(PageLRU(page));
 			SetPageLRU(page);
 			list_del(&page->lru);
-			if (PageActive(page))
-				add_page_to_active_list(zone, page);
-			else
-				add_page_to_inactive_list(zone, page);
+			add_page_to_lru_list(zone, page, PageActive(page));
 			if (!pagevec_add(&pvec, page)) {
 				spin_unlock_irq(&zone->lru_lock);
 				__pagevec_release(&pvec);
@@ -1142,8 +1139,8 @@ static void shrink_active_list(unsigned 
 	int pgdeactivate = 0;
 	unsigned long pgscanned;
 	LIST_HEAD(l_hold);	/* The pages which were snipped off */
-	LIST_HEAD(l_inactive);	/* Pages to go onto the inactive_list */
-	LIST_HEAD(l_active);	/* Pages to go onto the active_list */
+	LIST_HEAD(l_active);
+	LIST_HEAD(l_inactive);
 	struct page *page;
 	struct pagevec pvec;
 	int reclaim_mapped = 0;
@@ -1195,7 +1192,7 @@ static void shrink_active_list(unsigned 
 		VM_BUG_ON(!PageActive(page));
 		ClearPageActive(page);
 
-		list_move(&page->lru, &zone->inactive_list);
+		list_move(&page->lru, &zone->list[LRU_INACTIVE]);
 		mem_cgroup_move_lists(page, false);
 		pgmoved++;
 		if (!pagevec_add(&pvec, page)) {
@@ -1225,7 +1222,7 @@ static void shrink_active_list(unsigned 
 		SetPageLRU(page);
 		VM_BUG_ON(!PageActive(page));
 
-		list_move(&page->lru, &zone->active_list);
+		list_move(&page->lru, &zone->list[LRU_ACTIVE]);
 		mem_cgroup_move_lists(page, true);
 		pgmoved++;
 		if (!pagevec_add(&pvec, page)) {
@@ -1245,65 +1242,64 @@ static void shrink_active_list(unsigned 
 	pagevec_release(&pvec);
 }
 
+static unsigned long shrink_list(enum lru_list l, unsigned long nr_to_scan,
+	struct zone *zone, struct scan_control *sc, int priority)
+{
+	if (l == LRU_ACTIVE) {
+		shrink_active_list(nr_to_scan, zone, sc, priority);
+		return 0;
+	}
+	return shrink_inactive_list(nr_to_scan, zone, sc);
+}
+
 /*
  * This is a basic per-zone page freer.  Used by both kswapd and direct reclaim.
  */
 static unsigned long shrink_zone(int priority, struct zone *zone,
 				struct scan_control *sc)
 {
-	unsigned long nr_active;
-	unsigned long nr_inactive;
+	unsigned long nr[NR_LRU_LISTS];
 	unsigned long nr_to_scan;
 	unsigned long nr_reclaimed = 0;
+	enum lru_list l;
 
 	if (scan_global_lru(sc)) {
 		/*
 		 * Add one to nr_to_scan just to make sure that the kernel
 		 * will slowly sift through the active list.
 		 */
-		zone->nr_scan_active +=
-			(zone_page_state(zone, NR_ACTIVE) >> priority) + 1;
-		nr_active = zone->nr_scan_active;
-		zone->nr_scan_inactive +=
-			(zone_page_state(zone, NR_INACTIVE) >> priority) + 1;
-		nr_inactive = zone->nr_scan_inactive;
-		if (nr_inactive >= sc->swap_cluster_max)
-			zone->nr_scan_inactive = 0;
-		else
-			nr_inactive = 0;
-
-		if (nr_active >= sc->swap_cluster_max)
-			zone->nr_scan_active = 0;
-		else
-			nr_active = 0;
+		for_each_lru(l) {
+			zone->nr_scan[l] += (zone_page_state(zone,
+					NR_INACTIVE + l)  >> priority) + 1;
+			nr[l] = zone->nr_scan[l];
+			if (nr[l] >= sc->swap_cluster_max)
+				zone->nr_scan[l] = 0;
+			else
+				nr[l] = 0;
+		}
 	} else {
 		/*
 		 * This reclaim occurs not because zone memory shortage but
 		 * because memory controller hits its limit.
 		 * Then, don't modify zone reclaim related data.
 		 */
-		nr_active = mem_cgroup_calc_reclaim_active(sc->mem_cgroup,
-					zone, priority);
+		nr[LRU_ACTIVE] = mem_cgroup_calc_reclaim(sc->mem_cgroup,
+					zone, priority, LRU_ACTIVE);
 
-		nr_inactive = mem_cgroup_calc_reclaim_inactive(sc->mem_cgroup,
-					zone, priority);
+		nr[LRU_INACTIVE] = mem_cgroup_calc_reclaim(sc->mem_cgroup,
+					zone, priority, LRU_INACTIVE);
 	}
 
-
-	while (nr_active || nr_inactive) {
-		if (nr_active) {
-			nr_to_scan = min(nr_active,
+	while (nr[LRU_ACTIVE] || nr[LRU_INACTIVE]) {
+		for_each_lru(l) {
+			if (nr[l]) {
+				nr_to_scan = min(nr[l],
 					(unsigned long)sc->swap_cluster_max);
-			nr_active -= nr_to_scan;
-			shrink_active_list(nr_to_scan, zone, sc, priority);
-		}
+				nr[l] -= nr_to_scan;
 
-		if (nr_inactive) {
-			nr_to_scan = min(nr_inactive,
-					(unsigned long)sc->swap_cluster_max);
-			nr_inactive -= nr_to_scan;
-			nr_reclaimed += shrink_inactive_list(nr_to_scan, zone,
-								sc);
+				nr_reclaimed += shrink_list(l, nr_to_scan,
+							zone, sc, priority);
+			}
 		}
 	}
 
@@ -1820,6 +1816,7 @@ static unsigned long shrink_all_zones(un
 {
 	struct zone *zone;
 	unsigned long nr_to_scan, ret = 0;
+	enum lru_list l;
 
 	for_each_zone(zone) {
 
@@ -1829,28 +1826,25 @@ static unsigned long shrink_all_zones(un
 		if (zone_is_all_unreclaimable(zone) && prio != DEF_PRIORITY)
 			continue;
 
-		/* For pass = 0 we don't shrink the active list */
-		if (pass > 0) {
-			zone->nr_scan_active +=
-				(zone_page_state(zone, NR_ACTIVE) >> prio) + 1;
-			if (zone->nr_scan_active >= nr_pages || pass > 3) {
-				zone->nr_scan_active = 0;
+		for_each_lru(l) {
+			/* For pass = 0 we don't shrink the active list */
+			if (pass == 0 && l == LRU_ACTIVE)
+				continue;
+
+			zone->nr_scan[l] +=
+				(zone_page_state(zone, NR_INACTIVE + l)
+								>> prio) + 1;
+			if (zone->nr_scan[l] >= nr_pages || pass > 3) {
+				zone->nr_scan[l] = 0;
 				nr_to_scan = min(nr_pages,
-					zone_page_state(zone, NR_ACTIVE));
-				shrink_active_list(nr_to_scan, zone, sc, prio);
+					zone_page_state(zone,
+							NR_INACTIVE + l));
+				ret += shrink_list(l, nr_to_scan, zone,
+								sc, prio);
+				if (ret >= nr_pages)
+					return ret;
 			}
 		}
-
-		zone->nr_scan_inactive +=
-			(zone_page_state(zone, NR_INACTIVE) >> prio) + 1;
-		if (zone->nr_scan_inactive >= nr_pages || pass > 3) {
-			zone->nr_scan_inactive = 0;
-			nr_to_scan = min(nr_pages,
-				zone_page_state(zone, NR_INACTIVE));
-			ret += shrink_inactive_list(nr_to_scan, zone, sc);
-			if (ret >= nr_pages)
-				return ret;
-		}
 	}
 
 	return ret;
diff -puN mm/vmstat.c~vmscan-use-an-indexed-array-for-lru-variables mm/vmstat.c
--- a/mm/vmstat.c~vmscan-use-an-indexed-array-for-lru-variables
+++ a/mm/vmstat.c
@@ -679,7 +679,8 @@ static void zoneinfo_show_print(struct s
 		   zone->pages_low,
 		   zone->pages_high,
 		   zone->pages_scanned,
-		   zone->nr_scan_active, zone->nr_scan_inactive,
+		   zone->nr_scan[LRU_ACTIVE],
+		   zone->nr_scan[LRU_INACTIVE],
 		   zone->spanned_pages,
 		   zone->present_pages);
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
linux-next.patch
git-unionfs.patch
git-pekka.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
add-a-helper-function-to-test-if-an-object-is-on-the-stack.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
mm-migratec-should-include-linux-syscallsh.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
page-flags-record-page-flag-overlays-explicitly.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
vmallocinfo-add-numa-information.patch
vmallocinfo-add-numa-information-fix.patch
cputopology-always-define-cpu-topology-information.patch
cputopology-always-define-cpu-topology-information-cleanup.patch
memcg-better-migration-handling.patch
mm-speculative-page-references-hugh-fix3.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
mm-allocpercpuc-make-4-functions-static.patch
reiser4.patch
page-owner-tracking-leak-detector.patch

