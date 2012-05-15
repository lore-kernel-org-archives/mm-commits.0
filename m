From: akpm@linux-foundation.org
Subject: + mm-memcg-apply-add-del_page-to-lruvec.patch added to -mm tree
Date: Tue, 15 May 2012 15:39:31 -0700
Message-ID: <20120515223931.285D6A0444@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:59085 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966244Ab2EOWjc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 May 2012 18:39:32 -0400
Received: by yhgm50 with SMTP id m50so22046yhg.1
        for <mm-commits@vger.kernel.org>; Tue, 15 May 2012 15:39:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, khlebnikov@openvz.org, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: mm/memcg: apply add/del_page to lruvec
has been added to the -mm tree.  Its filename is
     mm-memcg-apply-add-del_page-to-lruvec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/memcg: apply add/del_page to lruvec

Take lruvec further: pass it instead of zone to add_page_to_lru_list() and
del_page_from_lru_list(); and pagevec_lru_move_fn() pass lruvec down to
its target functions.

This cleanup eliminates a swathe of cruft in memcontrol.c, including
mem_cgroup_lru_add_list(), mem_cgroup_lru_del_list() and
mem_cgroup_lru_move_lists() - which never actually touched the lists.

In their place, mem_cgroup_page_lruvec() to decide the lruvec, previously
a side-effect of add, and mem_cgroup_update_lru_size() to maintain the
lru_size stats.

Whilst these are simplifications in their own right, the goal is to bring
the evaluation of lruvec next to the spin_locking of the lrus, in
preparation for a future patch.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   32 ++---------
 include/linux/mm_inline.h  |   20 +++---
 include/linux/swap.h       |    4 -
 mm/compaction.c            |    5 +
 mm/huge_memory.c           |    8 +-
 mm/memcontrol.c            |  101 ++++++++---------------------------
 mm/swap.c                  |   86 ++++++++++++++---------------
 mm/vmscan.c                |   47 +++++++++-------
 8 files changed, 122 insertions(+), 181 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcg-apply-add-del_page-to-lruvec include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcg-apply-add-del_page-to-lruvec
+++ a/include/linux/memcontrol.h
@@ -64,11 +64,7 @@ extern int mem_cgroup_cache_charge(struc
 					gfp_t gfp_mask);
 
 struct lruvec *mem_cgroup_zone_lruvec(struct zone *, struct mem_cgroup *);
-struct lruvec *mem_cgroup_lru_add_list(struct zone *, struct page *,
-				       enum lru_list);
-void mem_cgroup_lru_del_list(struct page *, enum lru_list);
-struct lruvec *mem_cgroup_lru_move_lists(struct zone *, struct page *,
-					 enum lru_list, enum lru_list);
+struct lruvec *mem_cgroup_page_lruvec(struct page *, struct zone *);
 
 /* For coalescing uncharge for reducing memcg' overhead*/
 extern void mem_cgroup_uncharge_start(void);
@@ -123,8 +119,7 @@ int mem_cgroup_inactive_anon_is_low(stru
 int mem_cgroup_inactive_file_is_low(struct lruvec *lruvec);
 int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
 unsigned long mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list);
-struct zone_reclaim_stat*
-mem_cgroup_get_reclaim_stat_from_page(struct page *page);
+void mem_cgroup_update_lru_size(struct lruvec *, enum lru_list, int);
 extern void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
 					struct task_struct *p);
 extern void mem_cgroup_replace_page_cache(struct page *oldpage,
@@ -251,21 +246,8 @@ static inline struct lruvec *mem_cgroup_
 	return &zone->lruvec;
 }
 
-static inline struct lruvec *mem_cgroup_lru_add_list(struct zone *zone,
-						     struct page *page,
-						     enum lru_list lru)
-{
-	return &zone->lruvec;
-}
-
-static inline void mem_cgroup_lru_del_list(struct page *page, enum lru_list lru)
-{
-}
-
-static inline struct lruvec *mem_cgroup_lru_move_lists(struct zone *zone,
-						       struct page *page,
-						       enum lru_list from,
-						       enum lru_list to)
+static inline struct lruvec *mem_cgroup_page_lruvec(struct page *page,
+						    struct zone *zone)
 {
 	return &zone->lruvec;
 }
@@ -346,10 +328,10 @@ mem_cgroup_get_lru_size(struct lruvec *l
 	return 0;
 }
 
-static inline struct zone_reclaim_stat*
-mem_cgroup_get_reclaim_stat_from_page(struct page *page)
+static inline void
+mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
+			      int increment)
 {
-	return NULL;
 }
 
 static inline void
diff -puN include/linux/mm_inline.h~mm-memcg-apply-add-del_page-to-lruvec include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~mm-memcg-apply-add-del_page-to-lruvec
+++ a/include/linux/mm_inline.h
@@ -21,22 +21,22 @@ static inline int page_is_file_cache(str
 	return !PageSwapBacked(page);
 }
 
-static __always_inline void
-add_page_to_lru_list(struct zone *zone, struct page *page, enum lru_list lru)
+static __always_inline void add_page_to_lru_list(struct page *page,
+				struct lruvec *lruvec, enum lru_list lru)
 {
-	struct lruvec *lruvec;
-
-	lruvec = mem_cgroup_lru_add_list(zone, page, lru);
+	int nr_pages = hpage_nr_pages(page);
+	mem_cgroup_update_lru_size(lruvec, lru, nr_pages);
 	list_add(&page->lru, &lruvec->lists[lru]);
-	__mod_zone_page_state(zone, NR_LRU_BASE + lru, hpage_nr_pages(page));
+	__mod_zone_page_state(lruvec_zone(lruvec), NR_LRU_BASE + lru, nr_pages);
 }
 
-static __always_inline void
-del_page_from_lru_list(struct zone *zone, struct page *page, enum lru_list lru)
+static __always_inline void del_page_from_lru_list(struct page *page,
+				struct lruvec *lruvec, enum lru_list lru)
 {
-	mem_cgroup_lru_del_list(page, lru);
+	int nr_pages = hpage_nr_pages(page);
+	mem_cgroup_update_lru_size(lruvec, lru, -nr_pages);
 	list_del(&page->lru);
-	__mod_zone_page_state(zone, NR_LRU_BASE + lru, -hpage_nr_pages(page));
+	__mod_zone_page_state(lruvec_zone(lruvec), NR_LRU_BASE + lru, -nr_pages);
 }
 
 /**
diff -puN include/linux/swap.h~mm-memcg-apply-add-del_page-to-lruvec include/linux/swap.h
--- a/include/linux/swap.h~mm-memcg-apply-add-del_page-to-lruvec
+++ a/include/linux/swap.h
@@ -225,8 +225,8 @@ extern unsigned int nr_free_pagecache_pa
 /* linux/mm/swap.c */
 extern void __lru_cache_add(struct page *, enum lru_list lru);
 extern void lru_cache_add_lru(struct page *, enum lru_list lru);
-extern void lru_add_page_tail(struct zone* zone,
-			      struct page *page, struct page *page_tail);
+extern void lru_add_page_tail(struct page *page, struct page *page_tail,
+			      struct lruvec *lruvec);
 extern void activate_page(struct page *);
 extern void mark_page_accessed(struct page *);
 extern void lru_add_drain(void);
diff -puN mm/compaction.c~mm-memcg-apply-add-del_page-to-lruvec mm/compaction.c
--- a/mm/compaction.c~mm-memcg-apply-add-del_page-to-lruvec
+++ a/mm/compaction.c
@@ -227,6 +227,7 @@ isolate_migratepages_range(struct zone *
 	unsigned long nr_scanned = 0, nr_isolated = 0;
 	struct list_head *migratelist = &cc->migratepages;
 	isolate_mode_t mode = 0;
+	struct lruvec *lruvec;
 
 	/*
 	 * Ensure that there are not too many pages isolated from the LRU
@@ -328,6 +329,8 @@ isolate_migratepages_range(struct zone *
 		if (cc->mode != COMPACT_SYNC)
 			mode |= ISOLATE_ASYNC_MIGRATE;
 
+		lruvec = mem_cgroup_page_lruvec(page, zone);
+
 		/* Try isolate the page */
 		if (__isolate_lru_page(page, mode) != 0)
 			continue;
@@ -335,7 +338,7 @@ isolate_migratepages_range(struct zone *
 		VM_BUG_ON(PageTransCompound(page));
 
 		/* Successfully isolated */
-		del_page_from_lru_list(zone, page, page_lru(page));
+		del_page_from_lru_list(page, lruvec, page_lru(page));
 		list_add(&page->lru, migratelist);
 		cc->nr_migratepages++;
 		nr_isolated++;
diff -puN mm/huge_memory.c~mm-memcg-apply-add-del_page-to-lruvec mm/huge_memory.c
--- a/mm/huge_memory.c~mm-memcg-apply-add-del_page-to-lruvec
+++ a/mm/huge_memory.c
@@ -1231,10 +1231,13 @@ static void __split_huge_page_refcount(s
 {
 	int i;
 	struct zone *zone = page_zone(page);
+	struct lruvec *lruvec;
 	int tail_count = 0;
 
 	/* prevent PageLRU to go away from under us, and freeze lru stats */
 	spin_lock_irq(&zone->lru_lock);
+	lruvec = mem_cgroup_page_lruvec(page, zone);
+
 	compound_lock(page);
 	/* complete memcg works before add pages to LRU */
 	mem_cgroup_split_huge_fixup(page);
@@ -1309,13 +1312,12 @@ static void __split_huge_page_refcount(s
 		BUG_ON(!PageDirty(page_tail));
 		BUG_ON(!PageSwapBacked(page_tail));
 
-
-		lru_add_page_tail(zone, page, page_tail);
+		lru_add_page_tail(page, page_tail, lruvec);
 	}
 	atomic_sub(tail_count, &page->_count);
 	BUG_ON(atomic_read(&page->_count) <= 0);
 
-	__dec_zone_page_state(page, NR_ANON_TRANSPARENT_HUGEPAGES);
+	__mod_zone_page_state(zone, NR_ANON_TRANSPARENT_HUGEPAGES, -1);
 	__mod_zone_page_state(zone, NR_ANON_PAGES, HPAGE_PMD_NR);
 
 	ClearPageCompound(page);
diff -puN mm/memcontrol.c~mm-memcg-apply-add-del_page-to-lruvec mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-apply-add-del_page-to-lruvec
+++ a/mm/memcontrol.c
@@ -1056,7 +1056,7 @@ EXPORT_SYMBOL(mem_cgroup_count_vm_event)
 /**
  * mem_cgroup_zone_lruvec - get the lru list vector for a zone and memcg
  * @zone: zone of the wanted lruvec
- * @mem: memcg of the wanted lruvec
+ * @memcg: memcg of the wanted lruvec
  *
  * Returns the lru list vector holding pages for the given @zone and
  * @mem.  This can be the global zone lruvec, if the memory controller
@@ -1089,19 +1089,11 @@ struct lruvec *mem_cgroup_zone_lruvec(st
  */
 
 /**
- * mem_cgroup_lru_add_list - account for adding an lru page and return lruvec
- * @zone: zone of the page
+ * mem_cgroup_page_lruvec - return lruvec for adding an lru page
  * @page: the page
- * @lru: current lru
- *
- * This function accounts for @page being added to @lru, and returns
- * the lruvec for the given @zone and the memcg @page is charged to.
- *
- * The callsite is then responsible for physically linking the page to
- * the returned lruvec->lists[@lru].
+ * @zone: zone of the page
  */
-struct lruvec *mem_cgroup_lru_add_list(struct zone *zone, struct page *page,
-				       enum lru_list lru)
+struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct zone *zone)
 {
 	struct mem_cgroup_per_zone *mz;
 	struct mem_cgroup *memcg;
@@ -1114,7 +1106,7 @@ struct lruvec *mem_cgroup_lru_add_list(s
 	memcg = pc->mem_cgroup;
 
 	/*
-	 * Surreptitiously switch any uncharged page to root:
+	 * Surreptitiously switch any uncharged offlist page to root:
 	 * an uncharged page off lru does nothing to secure
 	 * its former mem_cgroup from sudden removal.
 	 *
@@ -1122,65 +1114,35 @@ struct lruvec *mem_cgroup_lru_add_list(s
 	 * under page_cgroup lock: between them, they make all uses
 	 * of pc->mem_cgroup safe.
 	 */
-	if (!PageCgroupUsed(pc) && memcg != root_mem_cgroup)
+	if (!PageLRU(page) && !PageCgroupUsed(pc) && memcg != root_mem_cgroup)
 		pc->mem_cgroup = memcg = root_mem_cgroup;
 
 	mz = page_cgroup_zoneinfo(memcg, page);
-	/* compound_order() is stabilized through lru_lock */
-	mz->lru_size[lru] += 1 << compound_order(page);
 	return &mz->lruvec;
 }
 
 /**
- * mem_cgroup_lru_del_list - account for removing an lru page
- * @page: the page
- * @lru: target lru
- *
- * This function accounts for @page being removed from @lru.
+ * mem_cgroup_update_lru_size - account for adding or removing an lru page
+ * @lruvec: mem_cgroup per zone lru vector
+ * @lru: index of lru list the page is sitting on
+ * @nr_pages: positive when adding or negative when removing
  *
- * The callsite is then responsible for physically unlinking
- * @page->lru.
+ * This function must be called when a page is added to or removed from an
+ * lru list.
  */
-void mem_cgroup_lru_del_list(struct page *page, enum lru_list lru)
+void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
+				int nr_pages)
 {
 	struct mem_cgroup_per_zone *mz;
-	struct mem_cgroup *memcg;
-	struct page_cgroup *pc;
+	unsigned long *lru_size;
 
 	if (mem_cgroup_disabled())
 		return;
 
-	pc = lookup_page_cgroup(page);
-	memcg = pc->mem_cgroup;
-	VM_BUG_ON(!memcg);
-	mz = page_cgroup_zoneinfo(memcg, page);
-	/* huge page split is done under lru_lock. so, we have no races. */
-	VM_BUG_ON(mz->lru_size[lru] < (1 << compound_order(page)));
-	mz->lru_size[lru] -= 1 << compound_order(page);
-}
-
-/**
- * mem_cgroup_lru_move_lists - account for moving a page between lrus
- * @zone: zone of the page
- * @page: the page
- * @from: current lru
- * @to: target lru
- *
- * This function accounts for @page being moved between the lrus @from
- * and @to, and returns the lruvec for the given @zone and the memcg
- * @page is charged to.
- *
- * The callsite is then responsible for physically relinking
- * @page->lru to the returned lruvec->lists[@to].
- */
-struct lruvec *mem_cgroup_lru_move_lists(struct zone *zone,
-					 struct page *page,
-					 enum lru_list from,
-					 enum lru_list to)
-{
-	/* XXX: Optimize this, especially for @from == @to */
-	mem_cgroup_lru_del_list(page, from);
-	return mem_cgroup_lru_add_list(zone, page, to);
+	mz = container_of(lruvec, struct mem_cgroup_per_zone, lruvec);
+	lru_size = mz->lru_size + lru;
+	*lru_size += nr_pages;
+	VM_BUG_ON((long)(*lru_size) < 0);
 }
 
 /*
@@ -1273,24 +1235,6 @@ int mem_cgroup_inactive_file_is_low(stru
 	return (active > inactive);
 }
 
-struct zone_reclaim_stat *
-mem_cgroup_get_reclaim_stat_from_page(struct page *page)
-{
-	struct page_cgroup *pc;
-	struct mem_cgroup_per_zone *mz;
-
-	if (mem_cgroup_disabled())
-		return NULL;
-
-	pc = lookup_page_cgroup(page);
-	if (!PageCgroupUsed(pc))
-		return NULL;
-	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
-	smp_rmb();
-	mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
-	return &mz->lruvec.reclaim_stat;
-}
-
 #define mem_cgroup_from_res_counter(counter, member)	\
 	container_of(counter, struct mem_cgroup, member)
 
@@ -2533,6 +2477,7 @@ static void __mem_cgroup_commit_charge(s
 {
 	struct page_cgroup *pc = lookup_page_cgroup(page);
 	struct zone *uninitialized_var(zone);
+	struct lruvec *lruvec;
 	bool was_on_lru = false;
 	bool anon;
 
@@ -2555,8 +2500,9 @@ static void __mem_cgroup_commit_charge(s
 		zone = page_zone(page);
 		spin_lock_irq(&zone->lru_lock);
 		if (PageLRU(page)) {
+			lruvec = mem_cgroup_zone_lruvec(zone, pc->mem_cgroup);
 			ClearPageLRU(page);
-			del_page_from_lru_list(zone, page, page_lru(page));
+			del_page_from_lru_list(page, lruvec, page_lru(page));
 			was_on_lru = true;
 		}
 	}
@@ -2574,9 +2520,10 @@ static void __mem_cgroup_commit_charge(s
 
 	if (lrucare) {
 		if (was_on_lru) {
+			lruvec = mem_cgroup_zone_lruvec(zone, pc->mem_cgroup);
 			VM_BUG_ON(PageLRU(page));
 			SetPageLRU(page);
-			add_page_to_lru_list(zone, page, page_lru(page));
+			add_page_to_lru_list(page, lruvec, page_lru(page));
 		}
 		spin_unlock_irq(&zone->lru_lock);
 	}
diff -puN mm/swap.c~mm-memcg-apply-add-del_page-to-lruvec mm/swap.c
--- a/mm/swap.c~mm-memcg-apply-add-del_page-to-lruvec
+++ a/mm/swap.c
@@ -47,13 +47,15 @@ static DEFINE_PER_CPU(struct pagevec, lr
 static void __page_cache_release(struct page *page)
 {
 	if (PageLRU(page)) {
-		unsigned long flags;
 		struct zone *zone = page_zone(page);
+		struct lruvec *lruvec;
+		unsigned long flags;
 
 		spin_lock_irqsave(&zone->lru_lock, flags);
+		lruvec = mem_cgroup_page_lruvec(page, zone);
 		VM_BUG_ON(!PageLRU(page));
 		__ClearPageLRU(page);
-		del_page_from_lru_list(zone, page, page_off_lru(page));
+		del_page_from_lru_list(page, lruvec, page_off_lru(page));
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
 	}
 }
@@ -202,11 +204,12 @@ void put_pages_list(struct list_head *pa
 EXPORT_SYMBOL(put_pages_list);
 
 static void pagevec_lru_move_fn(struct pagevec *pvec,
-				void (*move_fn)(struct page *page, void *arg),
-				void *arg)
+	void (*move_fn)(struct page *page, struct lruvec *lruvec, void *arg),
+	void *arg)
 {
 	int i;
 	struct zone *zone = NULL;
+	struct lruvec *lruvec;
 	unsigned long flags = 0;
 
 	for (i = 0; i < pagevec_count(pvec); i++) {
@@ -220,7 +223,8 @@ static void pagevec_lru_move_fn(struct p
 			spin_lock_irqsave(&zone->lru_lock, flags);
 		}
 
-		(*move_fn)(page, arg);
+		lruvec = mem_cgroup_page_lruvec(page, zone);
+		(*move_fn)(page, lruvec, arg);
 	}
 	if (zone)
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
@@ -228,16 +232,13 @@ static void pagevec_lru_move_fn(struct p
 	pagevec_reinit(pvec);
 }
 
-static void pagevec_move_tail_fn(struct page *page, void *arg)
+static void pagevec_move_tail_fn(struct page *page, struct lruvec *lruvec,
+				 void *arg)
 {
 	int *pgmoved = arg;
 
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
 		enum lru_list lru = page_lru_base_type(page);
-		struct lruvec *lruvec;
-
-		lruvec = mem_cgroup_lru_move_lists(page_zone(page),
-						   page, lru, lru);
 		list_move_tail(&page->lru, &lruvec->lists[lru]);
 		(*pgmoved)++;
 	}
@@ -276,35 +277,30 @@ void rotate_reclaimable_page(struct page
 	}
 }
 
-static void update_page_reclaim_stat(struct zone *zone, struct page *page,
+static void update_page_reclaim_stat(struct lruvec *lruvec,
 				     int file, int rotated)
 {
-	struct zone_reclaim_stat *reclaim_stat;
-
-	reclaim_stat = mem_cgroup_get_reclaim_stat_from_page(page);
-	if (!reclaim_stat)
-		reclaim_stat = &zone->lruvec.reclaim_stat;
+	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
 
 	reclaim_stat->recent_scanned[file]++;
 	if (rotated)
 		reclaim_stat->recent_rotated[file]++;
 }
 
-static void __activate_page(struct page *page, void *arg)
+static void __activate_page(struct page *page, struct lruvec *lruvec,
+			    void *arg)
 {
-	struct zone *zone = page_zone(page);
-
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
 		int file = page_is_file_cache(page);
 		int lru = page_lru_base_type(page);
-		del_page_from_lru_list(zone, page, lru);
 
+		del_page_from_lru_list(page, lruvec, lru);
 		SetPageActive(page);
 		lru += LRU_ACTIVE;
-		add_page_to_lru_list(zone, page, lru);
-		__count_vm_event(PGACTIVATE);
+		add_page_to_lru_list(page, lruvec, lru);
 
-		update_page_reclaim_stat(zone, page, file, 1);
+		__count_vm_event(PGACTIVATE);
+		update_page_reclaim_stat(lruvec, file, 1);
 	}
 }
 
@@ -341,7 +337,7 @@ void activate_page(struct page *page)
 	struct zone *zone = page_zone(page);
 
 	spin_lock_irq(&zone->lru_lock);
-	__activate_page(page, NULL);
+	__activate_page(page, mem_cgroup_page_lruvec(page, zone), NULL);
 	spin_unlock_irq(&zone->lru_lock);
 }
 #endif
@@ -408,11 +404,13 @@ void lru_cache_add_lru(struct page *page
 void add_page_to_unevictable_list(struct page *page)
 {
 	struct zone *zone = page_zone(page);
+	struct lruvec *lruvec;
 
 	spin_lock_irq(&zone->lru_lock);
+	lruvec = mem_cgroup_page_lruvec(page, zone);
 	SetPageUnevictable(page);
 	SetPageLRU(page);
-	add_page_to_lru_list(zone, page, LRU_UNEVICTABLE);
+	add_page_to_lru_list(page, lruvec, LRU_UNEVICTABLE);
 	spin_unlock_irq(&zone->lru_lock);
 }
 
@@ -437,11 +435,11 @@ void add_page_to_unevictable_list(struct
  * be write it out by flusher threads as this is much more effective
  * than the single-page writeout from reclaim.
  */
-static void lru_deactivate_fn(struct page *page, void *arg)
+static void lru_deactivate_fn(struct page *page, struct lruvec *lruvec,
+			      void *arg)
 {
 	int lru, file;
 	bool active;
-	struct zone *zone = page_zone(page);
 
 	if (!PageLRU(page))
 		return;
@@ -454,13 +452,13 @@ static void lru_deactivate_fn(struct pag
 		return;
 
 	active = PageActive(page);
-
 	file = page_is_file_cache(page);
 	lru = page_lru_base_type(page);
-	del_page_from_lru_list(zone, page, lru + active);
+
+	del_page_from_lru_list(page, lruvec, lru + active);
 	ClearPageActive(page);
 	ClearPageReferenced(page);
-	add_page_to_lru_list(zone, page, lru);
+	add_page_to_lru_list(page, lruvec, lru);
 
 	if (PageWriteback(page) || PageDirty(page)) {
 		/*
@@ -470,19 +468,17 @@ static void lru_deactivate_fn(struct pag
 		 */
 		SetPageReclaim(page);
 	} else {
-		struct lruvec *lruvec;
 		/*
 		 * The page's writeback ends up during pagevec
 		 * We moves tha page into tail of inactive.
 		 */
-		lruvec = mem_cgroup_lru_move_lists(zone, page, lru, lru);
 		list_move_tail(&page->lru, &lruvec->lists[lru]);
 		__count_vm_event(PGROTATED);
 	}
 
 	if (active)
 		__count_vm_event(PGDEACTIVATE);
-	update_page_reclaim_stat(zone, page, file, 0);
+	update_page_reclaim_stat(lruvec, file, 0);
 }
 
 /*
@@ -582,6 +578,7 @@ void release_pages(struct page **pages, 
 	int i;
 	LIST_HEAD(pages_to_free);
 	struct zone *zone = NULL;
+	struct lruvec *lruvec;
 	unsigned long uninitialized_var(flags);
 
 	for (i = 0; i < nr; i++) {
@@ -609,9 +606,11 @@ void release_pages(struct page **pages, 
 				zone = pagezone;
 				spin_lock_irqsave(&zone->lru_lock, flags);
 			}
+
+			lruvec = mem_cgroup_page_lruvec(page, zone);
 			VM_BUG_ON(!PageLRU(page));
 			__ClearPageLRU(page);
-			del_page_from_lru_list(zone, page, page_off_lru(page));
+			del_page_from_lru_list(page, lruvec, page_off_lru(page));
 		}
 
 		list_add(&page->lru, &pages_to_free);
@@ -643,8 +642,8 @@ EXPORT_SYMBOL(__pagevec_release);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /* used by __split_huge_page_refcount() */
-void lru_add_page_tail(struct zone* zone,
-		       struct page *page, struct page *page_tail)
+void lru_add_page_tail(struct page *page, struct page *page_tail,
+		       struct lruvec *lruvec)
 {
 	int uninitialized_var(active);
 	enum lru_list lru;
@@ -653,7 +652,8 @@ void lru_add_page_tail(struct zone* zone
 	VM_BUG_ON(!PageHead(page));
 	VM_BUG_ON(PageCompound(page_tail));
 	VM_BUG_ON(PageLRU(page_tail));
-	VM_BUG_ON(NR_CPUS != 1 && !spin_is_locked(&zone->lru_lock));
+	VM_BUG_ON(NR_CPUS != 1 &&
+		  !spin_is_locked(&lruvec_zone(lruvec)->lru_lock));
 
 	SetPageLRU(page_tail);
 
@@ -682,20 +682,20 @@ void lru_add_page_tail(struct zone* zone
 		 * Use the standard add function to put page_tail on the list,
 		 * but then correct its position so they all end up in order.
 		 */
-		add_page_to_lru_list(zone, page_tail, lru);
+		add_page_to_lru_list(page_tail, lruvec, lru);
 		list_head = page_tail->lru.prev;
 		list_move_tail(&page_tail->lru, list_head);
 	}
 
 	if (!PageUnevictable(page))
-		update_page_reclaim_stat(zone, page_tail, file, active);
+		update_page_reclaim_stat(lruvec, file, active);
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-static void __pagevec_lru_add_fn(struct page *page, void *arg)
+static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec,
+				 void *arg)
 {
 	enum lru_list lru = (enum lru_list)arg;
-	struct zone *zone = page_zone(page);
 	int file = is_file_lru(lru);
 	int active = is_active_lru(lru);
 
@@ -706,8 +706,8 @@ static void __pagevec_lru_add_fn(struct 
 	SetPageLRU(page);
 	if (active)
 		SetPageActive(page);
-	add_page_to_lru_list(zone, page, lru);
-	update_page_reclaim_stat(zone, page, file, active);
+	add_page_to_lru_list(page, lruvec, lru);
+	update_page_reclaim_stat(lruvec, file, active);
 }
 
 /*
diff -puN mm/vmscan.c~mm-memcg-apply-add-del_page-to-lruvec mm/vmscan.c
--- a/mm/vmscan.c~mm-memcg-apply-add-del_page-to-lruvec
+++ a/mm/vmscan.c
@@ -1031,6 +1031,7 @@ static unsigned long isolate_lru_pages(u
 
 	for (scan = 0; scan < nr_to_scan && !list_empty(src); scan++) {
 		struct page *page;
+		int nr_pages;
 
 		page = lru_to_page(src);
 		prefetchw_prev_lru_page(page, src, flags);
@@ -1039,9 +1040,10 @@ static unsigned long isolate_lru_pages(u
 
 		switch (__isolate_lru_page(page, mode)) {
 		case 0:
-			mem_cgroup_lru_del_list(page, lru);
+			nr_pages = hpage_nr_pages(page);
+			mem_cgroup_update_lru_size(lruvec, lru, -nr_pages);
 			list_move(&page->lru, dst);
-			nr_taken += hpage_nr_pages(page);
+			nr_taken += nr_pages;
 			break;
 
 		case -EBUSY:
@@ -1093,15 +1095,16 @@ int isolate_lru_page(struct page *page)
 
 	if (PageLRU(page)) {
 		struct zone *zone = page_zone(page);
+		struct lruvec *lruvec;
 
 		spin_lock_irq(&zone->lru_lock);
+		lruvec = mem_cgroup_page_lruvec(page, zone);
 		if (PageLRU(page)) {
 			int lru = page_lru(page);
-			ret = 0;
 			get_page(page);
 			ClearPageLRU(page);
-
-			del_page_from_lru_list(zone, page, lru);
+			del_page_from_lru_list(page, lruvec, lru);
+			ret = 0;
 		}
 		spin_unlock_irq(&zone->lru_lock);
 	}
@@ -1155,9 +1158,13 @@ putback_inactive_pages(struct lruvec *lr
 			spin_lock_irq(&zone->lru_lock);
 			continue;
 		}
+
+		lruvec = mem_cgroup_page_lruvec(page, zone);
+
 		SetPageLRU(page);
 		lru = page_lru(page);
-		add_page_to_lru_list(zone, page, lru);
+		add_page_to_lru_list(page, lruvec, lru);
+
 		if (is_active_lru(lru)) {
 			int file = is_file_lru(lru);
 			int numpages = hpage_nr_pages(page);
@@ -1166,7 +1173,7 @@ putback_inactive_pages(struct lruvec *lr
 		if (put_page_testzero(page)) {
 			__ClearPageLRU(page);
 			__ClearPageActive(page);
-			del_page_from_lru_list(zone, page, lru);
+			del_page_from_lru_list(page, lruvec, lru);
 
 			if (unlikely(PageCompound(page))) {
 				spin_unlock_irq(&zone->lru_lock);
@@ -1314,30 +1321,32 @@ shrink_inactive_list(unsigned long nr_to
  * But we had to alter page->flags anyway.
  */
 
-static void move_active_pages_to_lru(struct zone *zone,
+static void move_active_pages_to_lru(struct lruvec *lruvec,
 				     struct list_head *list,
 				     struct list_head *pages_to_free,
 				     enum lru_list lru)
 {
+	struct zone *zone = lruvec_zone(lruvec);
 	unsigned long pgmoved = 0;
 	struct page *page;
+	int nr_pages;
 
 	while (!list_empty(list)) {
-		struct lruvec *lruvec;
-
 		page = lru_to_page(list);
+		lruvec = mem_cgroup_page_lruvec(page, zone);
 
 		VM_BUG_ON(PageLRU(page));
 		SetPageLRU(page);
 
-		lruvec = mem_cgroup_lru_add_list(zone, page, lru);
+		nr_pages = hpage_nr_pages(page);
+		mem_cgroup_update_lru_size(lruvec, lru, nr_pages);
 		list_move(&page->lru, &lruvec->lists[lru]);
-		pgmoved += hpage_nr_pages(page);
+		pgmoved += nr_pages;
 
 		if (put_page_testzero(page)) {
 			__ClearPageLRU(page);
 			__ClearPageActive(page);
-			del_page_from_lru_list(zone, page, lru);
+			del_page_from_lru_list(page, lruvec, lru);
 
 			if (unlikely(PageCompound(page))) {
 				spin_unlock_irq(&zone->lru_lock);
@@ -1443,8 +1452,8 @@ static void shrink_active_list(unsigned 
 	 */
 	reclaim_stat->recent_rotated[file] += nr_rotated;
 
-	move_active_pages_to_lru(zone, &l_active, &l_hold, lru);
-	move_active_pages_to_lru(zone, &l_inactive, &l_hold, lru - LRU_ACTIVE);
+	move_active_pages_to_lru(lruvec, &l_active, &l_hold, lru);
+	move_active_pages_to_lru(lruvec, &l_inactive, &l_hold, lru - LRU_ACTIVE);
 	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, -nr_taken);
 	spin_unlock_irq(&zone->lru_lock);
 
@@ -3237,6 +3246,7 @@ void check_move_unevictable_pages(struct
 			zone = pagezone;
 			spin_lock_irq(&zone->lru_lock);
 		}
+		lruvec = mem_cgroup_page_lruvec(page, zone);
 
 		if (!PageLRU(page) || !PageUnevictable(page))
 			continue;
@@ -3246,11 +3256,8 @@ void check_move_unevictable_pages(struct
 
 			VM_BUG_ON(PageActive(page));
 			ClearPageUnevictable(page);
-			__dec_zone_state(zone, NR_UNEVICTABLE);
-			lruvec = mem_cgroup_lru_move_lists(zone, page,
-						LRU_UNEVICTABLE, lru);
-			list_move(&page->lru, &lruvec->lists[lru]);
-			__inc_zone_state(zone, NR_INACTIVE_ANON + lru);
+			del_page_from_lru_list(page, lruvec, LRU_UNEVICTABLE);
+			add_page_to_lru_list(page, lruvec, lru);
 			pgrescued++;
 		}
 	}
_
Subject: Subject: mm/memcg: apply add/del_page to lruvec

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
mm-remove-swap-token-code.patch
mm-vmscan-remove-lumpy-reclaim.patch
mm-vmscan-do-not-stall-on-writeback-during-memory-compaction.patch
mm-vmscan-remove-reclaim_mode_t.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check-fix.patch
mm-fork-fix-overflow-in-vma-length-when-copying-mmap-on-clone.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
bug-introduce-build_bug_on_invalid-macro.patch
bug-completely-remove-code-generated-by-disabled-vm_bug_on.patch
shmem-replace-page-if-mapping-excludes-its-zone.patch
tmpfs-enable-nosec-optimization.patch
tmpfs-optimize-clearing-when-writing.patch
tmpfs-support-fallocate-falloc_fl_punch_hole.patch
mm-fs-route-madv_remove-to-falloc_fl_punch_hole.patch
mm-fs-remove-truncate_range.patch
tmpfs-support-fallocate-preallocation.patch
tmpfs-undo-fallocation-on-failure.patch
tmpfs-quit-when-fallocate-fills-memory.patch
tmpfs-support-seek_data-and-seek_hole.patch
memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch
memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch
memcg-swap-use-mem_cgroup_uncharge_swap.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
memcg-add-mlock-statistic-in-memorystat.patch
memcg-add-mlock-statistic-in-memorystat-fix.patch
mm-vmscan-store-priority-in-struct-scan_control.patch
mm-add-link-from-struct-lruvec-to-struct-zone.patch
mm-vmscan-push-lruvec-pointer-into-isolate_lru_pages.patch
mm-vmscan-push-zone-pointer-into-shrink_page_list.patch
mm-vmscan-remove-update_isolated_counts.patch
mm-vmscan-push-lruvec-pointer-into-putback_inactive_pages.patch
mm-vmscan-replace-zone_nr_lru_pages-with-get_lruvec_size.patch
mm-vmscan-push-lruvec-pointer-into-inactive_list_is_low.patch
mm-vmscan-push-lruvec-pointer-into-shrink_list.patch
mm-vmscan-push-lruvec-pointer-into-get_scan_count.patch
mm-vmscan-push-lruvec-pointer-into-should_continue_reclaim.patch
mm-vmscan-kill-struct-mem_cgroup_zone.patch
mm-memcg-get_lru_size-not-get_lruvec_size.patch
mm-trivial-cleanups-in-vmscanc.patch
mm-memcg-apply-add-del_page-to-lruvec.patch
mm-huge_memoryc-use-lockdep_assert_held.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-use-is_err_or_null.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
prio_tree-debugging-patch.patch

