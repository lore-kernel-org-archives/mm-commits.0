From: akpm@linux-foundation.org
Subject: + memcg-add-zone_reclaim_stat.patch added to -mm tree
Date: Tue, 02 Dec 2008 20:17:17 -0800
Message-ID: <200812030417.mB34HHcJ005684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753338AbYLCERi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 23:17:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com


The patch titled
     memcg: add zone_reclaim_stat
has been added to the -mm tree.  Its filename is
     memcg-add-zone_reclaim_stat.patch

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
Subject: memcg: add zone_reclaim_stat
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Introduce mem_cgroup_per_zone::reclaim_stat member and its statics
collecting function.

Now, get_scan_ratio() can calculate correct value although memcg reclaim.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   16 ++++++++++++++++
 mm/memcontrol.c            |   23 +++++++++++++++++++++++
 mm/swap.c                  |   14 ++++++++++++++
 mm/vmscan.c                |   27 +++++++++++++--------------
 4 files changed, 66 insertions(+), 14 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-add-zone_reclaim_stat include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-add-zone_reclaim_stat
+++ a/include/linux/memcontrol.h
@@ -95,6 +95,10 @@ int mem_cgroup_inactive_anon_is_low(stru
 unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
 				       struct zone *zone,
 				       enum lru_list lru);
+struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg,
+						      struct zone *zone);
+struct zone_reclaim_stat*
+mem_cgroup_get_reclaim_stat_by_page(struct page *page);
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 extern int do_swap_account;
@@ -261,6 +265,18 @@ mem_cgroup_zone_nr_pages(struct mem_cgro
 }
 
 
+static inline struct zone_reclaim_stat*
+mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg, struct zone *zone)
+{
+	return NULL;
+}
+
+static inline struct zone_reclaim_stat*
+mem_cgroup_get_reclaim_stat_by_page(struct page *page)
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
@@ -458,6 +460,27 @@ unsigned long mem_cgroup_zone_nr_pages(s
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
+struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat_by_page(struct page *page)
+{
+	struct page_cgroup *pc = lookup_page_cgroup(page);
+	struct mem_cgroup_per_zone *mz = page_cgroup_zoneinfo(pc);
+
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
@@ -158,6 +158,7 @@ void activate_page(struct page *page)
 {
 	struct zone *zone = page_zone(page);
 	struct zone_reclaim_stat *reclaim_stat = &zone->reclaim_stat;
+	struct zone_reclaim_stat *memcg_reclaim_stat;
 
 	spin_lock_irq(&zone->lru_lock);
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
@@ -172,6 +173,12 @@ void activate_page(struct page *page)
 
 		reclaim_stat->recent_rotated[!!file]++;
 		reclaim_stat->recent_scanned[!!file]++;
+
+		memcg_reclaim_stat = mem_cgroup_get_reclaim_stat_by_page(page);
+		if (memcg_reclaim_stat) {
+			memcg_reclaim_stat->recent_rotated[!!file]++;
+			memcg_reclaim_stat->recent_scanned[!!file]++;
+		}
 	}
 	spin_unlock_irq(&zone->lru_lock);
 }
@@ -400,6 +407,7 @@ void ____pagevec_lru_add(struct pagevec 
 	int i;
 	struct zone *zone = NULL;
 	struct zone_reclaim_stat *reclaim_stat = NULL;
+	struct zone_reclaim_stat *memcg_reclaim_stat = NULL;
 
 	VM_BUG_ON(is_unevictable_lru(lru));
 
@@ -413,6 +421,8 @@ void ____pagevec_lru_add(struct pagevec 
 				spin_unlock_irq(&zone->lru_lock);
 			zone = pagezone;
 			reclaim_stat = &zone->reclaim_stat;
+			memcg_reclaim_stat =
+				mem_cgroup_get_reclaim_stat_by_page(page);
 			spin_lock_irq(&zone->lru_lock);
 		}
 		VM_BUG_ON(PageActive(page));
@@ -421,9 +431,13 @@ void ____pagevec_lru_add(struct pagevec 
 		SetPageLRU(page);
 		file = is_file_lru(lru);
 		reclaim_stat->recent_scanned[file]++;
+		if (memcg_reclaim_stat)
+			memcg_reclaim_stat->recent_scanned[file]++;
 		if (is_active_lru(lru)) {
 			SetPageActive(page);
 			reclaim_stat->recent_rotated[file]++;
+			if (memcg_reclaim_stat)
+				memcg_reclaim_stat->recent_rotated[file]++;
 		}
 		add_page_to_lru_list(zone, page, lru);
 	}
diff -puN mm/vmscan.c~memcg-add-zone_reclaim_stat mm/vmscan.c
--- a/mm/vmscan.c~memcg-add-zone_reclaim_stat
+++ a/mm/vmscan.c
@@ -133,6 +133,9 @@ static DECLARE_RWSEM(shrinker_rwsem);
 static struct zone_reclaim_stat *get_reclaim_stat(struct zone *zone,
 						  struct scan_control *sc)
 {
+	if (!scan_global_lru(sc))
+		mem_cgroup_get_reclaim_stat(sc->mem_cgroup, zone);
+
 	return &zone->reclaim_stat;
 }
 
@@ -1134,17 +1137,14 @@ static unsigned long shrink_inactive_lis
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
@@ -1202,7 +1202,7 @@ static unsigned long shrink_inactive_lis
 			SetPageLRU(page);
 			lru = page_lru(page);
 			add_page_to_lru_list(zone, page, lru);
-			if (PageActive(page) && scan_global_lru(sc)) {
+			if (PageActive(page)) {
 				int file = !!page_is_file_cache(page);
 				reclaim_stat->recent_rotated[file]++;
 			}
@@ -1277,8 +1277,8 @@ static void shrink_active_list(unsigned 
 	 */
 	if (scan_global_lru(sc)) {
 		zone->pages_scanned += pgscanned;
-		reclaim_stat->recent_scanned[!!file] += pgmoved;
 	}
+	reclaim_stat->recent_scanned[!!file] += pgmoved;
 
 	if (file)
 		__mod_zone_page_state(zone, NR_ACTIVE_FILE, -pgmoved);
@@ -1312,8 +1312,7 @@ static void shrink_active_list(unsigned 
 	 * This helps balance scan pressure between file and anonymous
 	 * pages in get_scan_ratio.
 	 */
-	if (scan_global_lru(sc))
-		reclaim_stat->recent_rotated[!!file] += pgmoved;
+	reclaim_stat->recent_rotated[!!file] += pgmoved;
 
 	/*
 	 * Move the pages to the [file or anon] inactive list.
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

vmscan-evict-streaming-io-first.patch
linux-next.patch
arch-ia64-kernel-iosapicc-fix-warnings.patch
mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps.patch
mm-report-the-mmu-pagesize-in-proc-pid-smaps.patch
oom-fix-zone_scan_mutex-name.patch
mm-get-rid-of-pagevec_release_nonlru.patch
cleanup-get-rid-of-ifdef-config_migration.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-make-page_lock_anon_vma-static.patch
memcg-reclaim-shouldnt-change-zone-recent_rotated-statistics.patch
mm-make-init_section_page_cgroup-static.patch
mm-make-maddr-__iomem.patch
mm-make-mem_cgroup_resize_limit-static.patch
mm-make-scan_all_zones_unevictable_pages-static.patch
mm-make-scan_zone_unevictable_pages-static.patch
mm-make-setup_per_zone_inactive_ratio-static.patch
mm-make-vread-and-vwrite-declaration.patch
vmscan-bail-out-of-direct-reclaim-after-swap_cluster_max-pages.patch
mm-kill-zone_is_near_oom.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
inactive_anon_is_low-move-to-vmscanc.patch
introduce-zone_reclaim-struct.patch
add-zone_nr_pages-helper-function.patch
make-get_scan_ratio-memcg-safe.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-remove-mem_cgroup_calc_reclaim.patch
memcg-show-inactive_ratio.patch
memcg-show-reclaim_stat.patch

