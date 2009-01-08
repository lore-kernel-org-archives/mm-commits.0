From: akpm@linux-foundation.org
Subject: - memcg-add-zone_reclaim_stat.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:49:16 -0800
Message-ID: <200901082249.n08MnGkx028538@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763269AbZAHW7N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:59:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, balbir@in.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     memcg: add zone_reclaim_stat
has been removed from the -mm tree.  Its filename was
     memcg-add-zone_reclaim_stat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: add zone_reclaim_stat
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Introduce mem_cgroup_per_zone::reclaim_stat member and its statics
collecting function.

Now, get_scan_ratio() can calculate correct value on memcg reclaim.

[hugh@veritas.com: avoid reclaim_stat oops when disabled]
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   16 ++++++++++++++++
 mm/memcontrol.c            |   29 +++++++++++++++++++++++++++++
 mm/swap.c                  |   34 +++++++++++++++++++++++++---------
 mm/vmscan.c                |   27 +++++++++++++--------------
 4 files changed, 83 insertions(+), 23 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-add-zone_reclaim_stat include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-add-zone_reclaim_stat
+++ a/include/linux/memcontrol.h
@@ -105,6 +105,10 @@ int mem_cgroup_inactive_anon_is_low(stru
 unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
 				       struct zone *zone,
 				       enum lru_list lru);
+struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg,
+						      struct zone *zone);
+struct zone_reclaim_stat*
+mem_cgroup_get_reclaim_stat_from_page(struct page *page);
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 extern int do_swap_account;
@@ -271,6 +275,18 @@ mem_cgroup_zone_nr_pages(struct mem_cgro
 }
 
 
+static inline struct zone_reclaim_stat*
+mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg, struct zone *zone)
+{
+	return NULL;
+}
+
+static inline struct zone_reclaim_stat*
+mem_cgroup_get_reclaim_stat_from_page(struct page *page)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
 #endif /* _LINUX_MEMCONTROL_H */
diff -puN mm/memcontrol.c~memcg-add-zone_reclaim_stat mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-zone_reclaim_stat
+++ a/mm/memcontrol.c
@@ -103,6 +103,8 @@ struct mem_cgroup_per_zone {
 	 */
 	struct list_head	lists[NR_LRU_LISTS];
 	unsigned long		count[NR_LRU_LISTS];
+
+	struct zone_reclaim_stat reclaim_stat;
 };
 /* Macro for accessing counter */
 #define MEM_CGROUP_ZSTAT(mz, idx)	((mz)->count[(idx)])
@@ -458,6 +460,33 @@ unsigned long mem_cgroup_zone_nr_pages(s
 	return MEM_CGROUP_ZSTAT(mz, lru);
 }
 
+struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg,
+						      struct zone *zone)
+{
+	int nid = zone->zone_pgdat->node_id;
+	int zid = zone_idx(zone);
+	struct mem_cgroup_per_zone *mz = mem_cgroup_zoneinfo(memcg, nid, zid);
+
+	return &mz->reclaim_stat;
+}
+
+struct zone_reclaim_stat *
+mem_cgroup_get_reclaim_stat_from_page(struct page *page)
+{
+	struct page_cgroup *pc;
+	struct mem_cgroup_per_zone *mz;
+
+	if (mem_cgroup_disabled())
+		return NULL;
+
+	pc = lookup_page_cgroup(page);
+	mz = page_cgroup_zoneinfo(pc);
+	if (!mz)
+		return NULL;
+
+	return &mz->reclaim_stat;
+}
+
 unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
 					struct list_head *dst,
 					unsigned long *scanned, int order,
diff -puN mm/swap.c~memcg-add-zone_reclaim_stat mm/swap.c
--- a/mm/swap.c~memcg-add-zone_reclaim_stat
+++ a/mm/swap.c
@@ -151,13 +151,32 @@ void  rotate_reclaimable_page(struct pag
 	}
 }
 
+static void update_page_reclaim_stat(struct zone *zone, struct page *page,
+				     int file, int rotated)
+{
+	struct zone_reclaim_stat *reclaim_stat = &zone->reclaim_stat;
+	struct zone_reclaim_stat *memcg_reclaim_stat;
+
+	memcg_reclaim_stat = mem_cgroup_get_reclaim_stat_from_page(page);
+
+	reclaim_stat->recent_scanned[file]++;
+	if (rotated)
+		reclaim_stat->recent_rotated[file]++;
+
+	if (!memcg_reclaim_stat)
+		return;
+
+	memcg_reclaim_stat->recent_scanned[file]++;
+	if (rotated)
+		memcg_reclaim_stat->recent_rotated[file]++;
+}
+
 /*
  * FIXME: speed this up?
  */
 void activate_page(struct page *page)
 {
 	struct zone *zone = page_zone(page);
-	struct zone_reclaim_stat *reclaim_stat = &zone->reclaim_stat;
 
 	spin_lock_irq(&zone->lru_lock);
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
@@ -170,8 +189,7 @@ void activate_page(struct page *page)
 		add_page_to_lru_list(zone, page, lru);
 		__count_vm_event(PGACTIVATE);
 
-		reclaim_stat->recent_rotated[!!file]++;
-		reclaim_stat->recent_scanned[!!file]++;
+		update_page_reclaim_stat(zone, page, !!file, 1);
 	}
 	spin_unlock_irq(&zone->lru_lock);
 }
@@ -386,7 +404,6 @@ void ____pagevec_lru_add(struct pagevec 
 {
 	int i;
 	struct zone *zone = NULL;
-	struct zone_reclaim_stat *reclaim_stat = NULL;
 
 	VM_BUG_ON(is_unevictable_lru(lru));
 
@@ -394,24 +411,23 @@ void ____pagevec_lru_add(struct pagevec 
 		struct page *page = pvec->pages[i];
 		struct zone *pagezone = page_zone(page);
 		int file;
+		int active;
 
 		if (pagezone != zone) {
 			if (zone)
 				spin_unlock_irq(&zone->lru_lock);
 			zone = pagezone;
-			reclaim_stat = &zone->reclaim_stat;
 			spin_lock_irq(&zone->lru_lock);
 		}
 		VM_BUG_ON(PageActive(page));
 		VM_BUG_ON(PageUnevictable(page));
 		VM_BUG_ON(PageLRU(page));
 		SetPageLRU(page);
+		active = is_active_lru(lru);
 		file = is_file_lru(lru);
-		reclaim_stat->recent_scanned[file]++;
-		if (is_active_lru(lru)) {
+		if (active)
 			SetPageActive(page);
-			reclaim_stat->recent_rotated[file]++;
-		}
+		update_page_reclaim_stat(zone, page, file, active);
 		add_page_to_lru_list(zone, page, lru);
 	}
 	if (zone)
diff -puN mm/vmscan.c~memcg-add-zone_reclaim_stat mm/vmscan.c
--- a/mm/vmscan.c~memcg-add-zone_reclaim_stat
+++ a/mm/vmscan.c
@@ -133,6 +133,9 @@ static DECLARE_RWSEM(shrinker_rwsem);
 static struct zone_reclaim_stat *get_reclaim_stat(struct zone *zone,
 						  struct scan_control *sc)
 {
+	if (!scan_global_lru(sc))
+		return mem_cgroup_get_reclaim_stat(sc->mem_cgroup, zone);
+
 	return &zone->reclaim_stat;
 }
 
@@ -1087,17 +1090,14 @@ static unsigned long shrink_inactive_lis
 		__mod_zone_page_state(zone, NR_INACTIVE_ANON,
 						-count[LRU_INACTIVE_ANON]);
 
-		if (scan_global_lru(sc)) {
+		if (scan_global_lru(sc))
 			zone->pages_scanned += nr_scan;
-			reclaim_stat->recent_scanned[0] +=
-						      count[LRU_INACTIVE_ANON];
-			reclaim_stat->recent_scanned[0] +=
-						      count[LRU_ACTIVE_ANON];
-			reclaim_stat->recent_scanned[1] +=
-						      count[LRU_INACTIVE_FILE];
-			reclaim_stat->recent_scanned[1] +=
-						      count[LRU_ACTIVE_FILE];
-		}
+
+		reclaim_stat->recent_scanned[0] += count[LRU_INACTIVE_ANON];
+		reclaim_stat->recent_scanned[0] += count[LRU_ACTIVE_ANON];
+		reclaim_stat->recent_scanned[1] += count[LRU_INACTIVE_FILE];
+		reclaim_stat->recent_scanned[1] += count[LRU_ACTIVE_FILE];
+
 		spin_unlock_irq(&zone->lru_lock);
 
 		nr_scanned += nr_scan;
@@ -1155,7 +1155,7 @@ static unsigned long shrink_inactive_lis
 			SetPageLRU(page);
 			lru = page_lru(page);
 			add_page_to_lru_list(zone, page, lru);
-			if (PageActive(page) && scan_global_lru(sc)) {
+			if (PageActive(page)) {
 				int file = !!page_is_file_cache(page);
 				reclaim_stat->recent_rotated[file]++;
 			}
@@ -1230,8 +1230,8 @@ static void shrink_active_list(unsigned 
 	 */
 	if (scan_global_lru(sc)) {
 		zone->pages_scanned += pgscanned;
-		reclaim_stat->recent_scanned[!!file] += pgmoved;
 	}
+	reclaim_stat->recent_scanned[!!file] += pgmoved;
 
 	if (file)
 		__mod_zone_page_state(zone, NR_ACTIVE_FILE, -pgmoved);
@@ -1272,8 +1272,7 @@ static void shrink_active_list(unsigned 
 	 * This helps balance scan pressure between file and anonymous
 	 * pages in get_scan_ratio.
 	 */
-	if (scan_global_lru(sc))
-		reclaim_stat->recent_rotated[!!file] += pgmoved;
+	reclaim_stat->recent_rotated[!!file] += pgmoved;
 
 	while (!list_empty(&l_inactive)) {
 		page = lru_to_page(&l_inactive);
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
ia64-implement-interrupt-enabling-rwlocks.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

