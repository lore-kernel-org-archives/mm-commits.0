From: akpm@linux-foundation.org
Subject: + mm-collect-lru-list-heads-into-struct-lruvec.patch added to -mm tree
Date: Tue, 08 Nov 2011 13:39:43 -0800
Message-ID: <201111082139.pA8LdhYh008777@hpaq1.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:10238 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab1KHVkn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2011 16:40:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jweiner@redhat.com, bsingharora@gmail.com, gthelen@google.com, hch@infradead.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, mhocko@suse.cz, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, riel@redhat.com, walken@google.com, yinghan@google.com


The patch titled
     Subject: mm: collect LRU list heads into struct lruvec
has been added to the -mm tree.  Its filename is
     mm-collect-lru-list-heads-into-struct-lruvec.patch

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
From: Johannes Weiner <jweiner@redhat.com>
Subject: mm: collect LRU list heads into struct lruvec

Having a unified structure with a LRU list set for both global zones and
per-memcg zones allows to keep that code simple which deals with LRU lists
and does not care about the container itself.

Once the per-memcg LRU lists directly link struct pages, the isolation
function and all other list manipulations are shared between the memcg
case and the global LRU case.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Ying Han <yinghan@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    2 +-
 include/linux/mmzone.h    |   10 ++++++----
 mm/memcontrol.c           |   17 +++++++----------
 mm/page_alloc.c           |    2 +-
 mm/swap.c                 |   11 +++++------
 mm/vmscan.c               |   10 +++++-----
 6 files changed, 25 insertions(+), 27 deletions(-)

diff -puN include/linux/mm_inline.h~mm-collect-lru-list-heads-into-struct-lruvec include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~mm-collect-lru-list-heads-into-struct-lruvec
+++ a/include/linux/mm_inline.h
@@ -33,7 +33,7 @@ __add_page_to_lru_list(struct zone *zone
 static inline void
 add_page_to_lru_list(struct zone *zone, struct page *page, enum lru_list l)
 {
-	__add_page_to_lru_list(zone, page, l, &zone->lru[l].list);
+	__add_page_to_lru_list(zone, page, l, &zone->lruvec.lists[l]);
 }
 
 static inline void
diff -puN include/linux/mmzone.h~mm-collect-lru-list-heads-into-struct-lruvec include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-collect-lru-list-heads-into-struct-lruvec
+++ a/include/linux/mmzone.h
@@ -159,6 +159,10 @@ static inline int is_unevictable_lru(enu
 	return (l == LRU_UNEVICTABLE);
 }
 
+struct lruvec {
+	struct list_head lists[NR_LRU_LISTS];
+};
+
 /* Mask used at gathering information at once (see memcontrol.c) */
 #define LRU_ALL_FILE (BIT(LRU_INACTIVE_FILE) | BIT(LRU_ACTIVE_FILE))
 #define LRU_ALL_ANON (BIT(LRU_INACTIVE_ANON) | BIT(LRU_ACTIVE_ANON))
@@ -358,10 +362,8 @@ struct zone {
 	ZONE_PADDING(_pad1_)
 
 	/* Fields commonly accessed by the page reclaim scanner */
-	spinlock_t		lru_lock;	
-	struct zone_lru {
-		struct list_head list;
-	} lru[NR_LRU_LISTS];
+	spinlock_t		lru_lock;
+	struct lruvec		lruvec;
 
 	struct zone_reclaim_stat reclaim_stat;
 
diff -puN mm/memcontrol.c~mm-collect-lru-list-heads-into-struct-lruvec mm/memcontrol.c
--- a/mm/memcontrol.c~mm-collect-lru-list-heads-into-struct-lruvec
+++ a/mm/memcontrol.c
@@ -132,10 +132,7 @@ struct mem_cgroup_reclaim_iter {
  * per-zone information in memory controller.
  */
 struct mem_cgroup_per_zone {
-	/*
-	 * spin_lock to protect the per cgroup LRU
-	 */
-	struct list_head	lists[NR_LRU_LISTS];
+	struct lruvec		lruvec;
 	unsigned long		count[NR_LRU_LISTS];
 
 	struct mem_cgroup_reclaim_iter reclaim_iter[DEF_PRIORITY + 1];
@@ -995,7 +992,7 @@ void mem_cgroup_rotate_reclaimable_page(
 	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
 	smp_rmb();
 	mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
-	list_move_tail(&pc->lru, &mz->lists[lru]);
+	list_move_tail(&pc->lru, &mz->lruvec.lists[lru]);
 }
 
 void mem_cgroup_rotate_lru_list(struct page *page, enum lru_list lru)
@@ -1013,7 +1010,7 @@ void mem_cgroup_rotate_lru_list(struct p
 	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
 	smp_rmb();
 	mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
-	list_move(&pc->lru, &mz->lists[lru]);
+	list_move(&pc->lru, &mz->lruvec.lists[lru]);
 }
 
 void mem_cgroup_add_lru_list(struct page *page, enum lru_list lru)
@@ -1043,7 +1040,7 @@ void mem_cgroup_add_lru_list(struct page
 	/* huge page split is done under lru_lock. so, we have no races. */
 	MEM_CGROUP_ZSTAT(mz, lru) += 1 << compound_order(page);
 	SetPageCgroupAcctLRU(pc);
-	list_add(&pc->lru, &mz->lists[lru]);
+	list_add(&pc->lru, &mz->lruvec.lists[lru]);
 }
 
 /*
@@ -1241,7 +1238,7 @@ unsigned long mem_cgroup_isolate_pages(u
 
 	BUG_ON(!mem_cont);
 	mz = mem_cgroup_zoneinfo(mem_cont, nid, zid);
-	src = &mz->lists[lru];
+	src = &mz->lruvec.lists[lru];
 
 	scan = 0;
 	list_for_each_entry_safe_reverse(pc, tmp, src, lru) {
@@ -3628,7 +3625,7 @@ static int mem_cgroup_force_empty_list(s
 
 	zone = &NODE_DATA(node)->node_zones[zid];
 	mz = mem_cgroup_zoneinfo(memcg, node, zid);
-	list = &mz->lists[lru];
+	list = &mz->lruvec.lists[lru];
 
 	loop = MEM_CGROUP_ZSTAT(mz, lru);
 	/* give some margin against EBUSY etc...*/
@@ -4724,7 +4721,7 @@ static int alloc_mem_cgroup_per_zone_inf
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		mz = &pn->zoneinfo[zone];
 		for_each_lru(l)
-			INIT_LIST_HEAD(&mz->lists[l]);
+			INIT_LIST_HEAD(&mz->lruvec.lists[l]);
 		mz->usage_in_excess = 0;
 		mz->on_tree = false;
 		mz->mem = memcg;
diff -puN mm/page_alloc.c~mm-collect-lru-list-heads-into-struct-lruvec mm/page_alloc.c
--- a/mm/page_alloc.c~mm-collect-lru-list-heads-into-struct-lruvec
+++ a/mm/page_alloc.c
@@ -4366,7 +4366,7 @@ static void __paginginit free_area_init_
 
 		zone_pcp_init(zone);
 		for_each_lru(l)
-			INIT_LIST_HEAD(&zone->lru[l].list);
+			INIT_LIST_HEAD(&zone->lruvec.lists[l]);
 		zone->reclaim_stat.recent_rotated[0] = 0;
 		zone->reclaim_stat.recent_rotated[1] = 0;
 		zone->reclaim_stat.recent_scanned[0] = 0;
diff -puN mm/swap.c~mm-collect-lru-list-heads-into-struct-lruvec mm/swap.c
--- a/mm/swap.c~mm-collect-lru-list-heads-into-struct-lruvec
+++ a/mm/swap.c
@@ -236,7 +236,7 @@ static void pagevec_move_tail_fn(struct 
 
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
 		enum lru_list lru = page_lru_base_type(page);
-		list_move_tail(&page->lru, &zone->lru[lru].list);
+		list_move_tail(&page->lru, &zone->lruvec.lists[lru]);
 		mem_cgroup_rotate_reclaimable_page(page);
 		(*pgmoved)++;
 	}
@@ -480,7 +480,7 @@ static void lru_deactivate_fn(struct pag
 		 * The page's writeback ends up during pagevec
 		 * We moves tha page into tail of inactive.
 		 */
-		list_move_tail(&page->lru, &zone->lru[lru].list);
+		list_move_tail(&page->lru, &zone->lruvec.lists[lru]);
 		mem_cgroup_rotate_reclaimable_page(page);
 		__count_vm_event(PGROTATED);
 	}
@@ -654,7 +654,6 @@ void lru_add_page_tail(struct zone* zone
 	int active;
 	enum lru_list lru;
 	const int file = 0;
-	struct list_head *head;
 
 	VM_BUG_ON(!PageHead(page));
 	VM_BUG_ON(PageCompound(page_tail));
@@ -674,10 +673,10 @@ void lru_add_page_tail(struct zone* zone
 		}
 		update_page_reclaim_stat(zone, page_tail, file, active);
 		if (likely(PageLRU(page)))
-			head = page->lru.prev;
+			__add_page_to_lru_list(zone, page_tail, lru,
+					       page->lru.prev);
 		else
-			head = &zone->lru[lru].list;
-		__add_page_to_lru_list(zone, page_tail, lru, head);
+			add_page_to_lru_list(zone, page_tail, lru);
 	} else {
 		SetPageUnevictable(page_tail);
 		add_page_to_lru_list(zone, page_tail, LRU_UNEVICTABLE);
diff -puN mm/vmscan.c~mm-collect-lru-list-heads-into-struct-lruvec mm/vmscan.c
--- a/mm/vmscan.c~mm-collect-lru-list-heads-into-struct-lruvec
+++ a/mm/vmscan.c
@@ -1250,8 +1250,8 @@ static unsigned long isolate_pages_globa
 		lru += LRU_ACTIVE;
 	if (file)
 		lru += LRU_FILE;
-	return isolate_lru_pages(nr, &z->lru[lru].list, dst, scanned, order,
-								mode, file);
+	return isolate_lru_pages(nr, &z->lruvec.lists[lru], dst,
+				 scanned, order, mode, file);
 }
 
 /*
@@ -1630,7 +1630,7 @@ static void move_active_pages_to_lru(str
 		VM_BUG_ON(PageLRU(page));
 		SetPageLRU(page);
 
-		list_move(&page->lru, &zone->lru[lru].list);
+		list_move(&page->lru, &zone->lruvec.lists[lru]);
 		mem_cgroup_add_lru_list(page, lru);
 		pgmoved += hpage_nr_pages(page);
 
@@ -3447,7 +3447,7 @@ retry:
 		enum lru_list l = page_lru_base_type(page);
 
 		__dec_zone_state(zone, NR_UNEVICTABLE);
-		list_move(&page->lru, &zone->lru[l].list);
+		list_move(&page->lru, &zone->lruvec.lists[l]);
 		mem_cgroup_move_lists(page, LRU_UNEVICTABLE, l);
 		__inc_zone_state(zone, NR_INACTIVE_ANON + l);
 		__count_vm_event(UNEVICTABLE_PGRESCUED);
@@ -3456,7 +3456,7 @@ retry:
 		 * rotate unevictable list
 		 */
 		SetPageUnevictable(page);
-		list_move(&page->lru, &zone->lru[LRU_UNEVICTABLE].list);
+		list_move(&page->lru, &zone->lruvec.lists[LRU_UNEVICTABLE]);
 		mem_cgroup_rotate_lru_list(page, LRU_UNEVICTABLE);
 		if (page_evictable(page, NULL))
 			goto retry;
_
Subject: Subject: mm: collect LRU list heads into struct lruvec

Patches currently in -mm which might be from jweiner@redhat.com are

mm-add-extra-free-kbytes-tunable.patch
mm-memcg-consolidate-hierarchy-iteration-primitives.patch
mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch
mm-move-memcg-hierarchy-reclaim-to-generic-reclaim-code.patch
mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch
mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists.patch
mm-collect-lru-list-heads-into-struct-lruvec.patch
mm-make-per-memcg-lru-lists-exclusive.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags.patch

