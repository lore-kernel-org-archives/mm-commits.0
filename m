From: akpm@linux-foundation.org
Subject: + memcg-add-inactive_anon_is_low.patch added to -mm tree
Date: Tue, 02 Dec 2008 20:17:13 -0800
Message-ID: <200812030417.mB34HDgk005676@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753562AbYLCERp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 23:17:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, balbir@linux.vnet.ibm.com, gorcunov@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, penberg@cs.helsinki.fi, riel@redhat.com


The patch titled
     memcg: add inactive_anon_is_low()
has been added to the -mm tree.  Its filename is
     memcg-add-inactive_anon_is_low.patch

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
Subject: memcg: add inactive_anon_is_low()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

The inactive_anon_is_low() is key component of active/inactive anon
balancing on reclaim.  However current inactive_anon_is_low() function
only consider global reclaim.

Therefore, we need following ugly scan_global_lru() condition.

	if (lru == LRU_ACTIVE_ANON &&
	    (!scan_global_lru(sc) || inactive_anon_is_low(zone))) {
		shrink_active_list(nr_to_scan, zone, sc, priority, file);
		return 0;

It causes that memcg reclaim always deactivate pages when shrink_list() is
called.  To make mem_cgroup_inactive_anon_is_low() improve active/inactive
anon balancing of memcgroup.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    9 ++++++
 mm/memcontrol.c            |   46 ++++++++++++++++++++++++++++++++++-
 mm/vmscan.c                |   36 +++++++++++++++++----------
 3 files changed, 77 insertions(+), 14 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-add-inactive_anon_is_low include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-add-inactive_anon_is_low
+++ a/include/linux/memcontrol.h
@@ -90,6 +90,8 @@ extern void mem_cgroup_record_reclaim_pr
 
 extern long mem_cgroup_calc_reclaim(struct mem_cgroup *mem, struct zone *zone,
 					int priority, enum lru_list lru);
+int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg,
+				    struct zone *zone);
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 extern int do_swap_account;
@@ -241,6 +243,13 @@ static inline bool mem_cgroup_oom_called
 {
 	return false;
 }
+
+static inline int
+mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg, struct zone *zone)
+{
+	return 1;
+}
+
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
 #endif /* _LINUX_MEMCONTROL_H */
diff -puN mm/memcontrol.c~memcg-add-inactive_anon_is_low mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-inactive_anon_is_low
+++ a/mm/memcontrol.c
@@ -156,6 +156,9 @@ struct mem_cgroup {
 	unsigned long	last_oom_jiffies;
 	int		obsolete;
 	atomic_t	refcnt;
+
+	unsigned int inactive_ratio;
+
 	/*
 	 * statistics. This must be placed at the end of memcg.
 	 */
@@ -431,6 +434,20 @@ long mem_cgroup_calc_reclaim(struct mem_
 	return (nr_pages >> priority);
 }
 
+int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg, struct zone *zone)
+{
+	unsigned long active;
+	unsigned long inactive;
+
+	inactive = mem_cgroup_get_all_zonestat(memcg, LRU_INACTIVE_ANON);
+	active = mem_cgroup_get_all_zonestat(memcg, LRU_ACTIVE_ANON);
+
+	if (inactive * memcg->inactive_ratio < active)
+		return 1;
+
+	return 0;
+}
+
 unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
 					struct list_head *dst,
 					unsigned long *scanned, int order,
@@ -1346,6 +1363,29 @@ int mem_cgroup_shrink_usage(struct mm_st
 	return 0;
 }
 
+/*
+ * The inactive anon list should be small enough that the VM never has to
+ * do too much work, but large enough that each inactive page has a chance
+ * to be referenced again before it is swapped out.
+ *
+ * this calculation is straightforward porting from
+ * page_alloc.c::setup_per_zone_inactive_ratio().
+ * it describe more detail.
+ */
+static void mem_cgroup_set_inactive_ratio(struct mem_cgroup *memcg)
+{
+	unsigned int gb, ratio;
+
+	gb = res_counter_read_u64(&memcg->res, RES_LIMIT) >> 30;
+	if (gb)
+		ratio = int_sqrt(10 * gb);
+	else
+		ratio = 1;
+
+	memcg->inactive_ratio = ratio;
+
+}
+
 static DEFINE_MUTEX(set_limit_mutex);
 
 static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
@@ -1384,6 +1424,10 @@ static int mem_cgroup_resize_limit(struc
 				GFP_HIGHUSER_MOVABLE, false);
   		if (!progress)			retry_count--;
 	}
+
+	if (!ret)
+		mem_cgroup_set_inactive_ratio(memcg);
+
 	return ret;
 }
 
@@ -1968,7 +2012,7 @@ mem_cgroup_create(struct cgroup_subsys *
 		res_counter_init(&mem->res, NULL);
 		res_counter_init(&mem->memsw, NULL);
 	}
-
+	mem_cgroup_set_inactive_ratio(mem);
 	mem->last_scanned_child = NULL;
 
 	return &mem->css;
diff -puN mm/vmscan.c~memcg-add-inactive_anon_is_low mm/vmscan.c
--- a/mm/vmscan.c~memcg-add-inactive_anon_is_low
+++ a/mm/vmscan.c
@@ -1357,14 +1357,7 @@ static void shrink_active_list(unsigned 
 	pagevec_release(&pvec);
 }
 
-/**
- * inactive_anon_is_low - check if anonymous pages need to be deactivated
- * @zone: zone to check
- *
- * Returns true if the zone does not have enough inactive anon pages,
- * meaning some active anon pages need to be deactivated.
- */
-static int inactive_anon_is_low(struct zone *zone)
+static int inactive_anon_is_low_global(struct zone *zone)
 {
 	unsigned long active, inactive;
 
@@ -1377,6 +1370,25 @@ static int inactive_anon_is_low(struct z
 	return 0;
 }
 
+/**
+ * inactive_anon_is_low - check if anonymous pages need to be deactivated
+ * @zone: zone to check
+ * @sc:   scan control of this context
+ *
+ * Returns true if the zone does not have enough inactive anon pages,
+ * meaning some active anon pages need to be deactivated.
+ */
+static int inactive_anon_is_low(struct zone *zone, struct scan_control *sc)
+{
+	int low;
+
+	if (scan_global_lru(sc))
+		low = inactive_anon_is_low_global(zone);
+	else
+		low = mem_cgroup_inactive_anon_is_low(sc->mem_cgroup, zone);
+	return low;
+}
+
 static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
 	struct zone *zone, struct scan_control *sc, int priority)
 {
@@ -1388,7 +1400,7 @@ static unsigned long shrink_list(enum lr
 	}
 
 	if (lru == LRU_ACTIVE_ANON &&
-	    (!scan_global_lru(sc) || inactive_anon_is_low(zone))) {
+	    inactive_anon_is_low(zone, sc)) {
 		shrink_active_list(nr_to_scan, zone, sc, priority, file);
 		return 0;
 	}
@@ -1553,9 +1565,7 @@ static void shrink_zone(int priority, st
 	 * Even if we did not try to evict anon pages at all, we want to
 	 * rebalance the anon lru active/inactive ratio.
 	 */
-	if (!scan_global_lru(sc) || inactive_anon_is_low(zone))
-		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
-	else if (!scan_global_lru(sc))
+	if (inactive_anon_is_low(zone, sc))
 		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
 
 	throttle_vm_writeout(sc->gfp_mask);
@@ -1851,7 +1861,7 @@ loop_again:
 			 * Do some background aging of the anon list, to give
 			 * pages a chance to be referenced before reclaiming.
 			 */
-			if (inactive_anon_is_low(zone))
+			if (inactive_anon_is_low(zone, &sc))
 				shrink_active_list(SWAP_CLUSTER_MAX, zone,
 							&sc, priority, 0);
 
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

