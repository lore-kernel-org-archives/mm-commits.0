From: akpm@linux-foundation.org
Subject: + memcg-fix-calclation-of-active_ratio.patch added to -mm tree
Date: Mon, 15 Dec 2008 16:02:13 -0800
Message-ID: <200812160002.mBG02ExQ028178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753988AbYLPACg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Dec 2008 19:02:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcg: fix calclation of active_ratio
has been added to the -mm tree.  Its filename is
     memcg-fix-calclation-of-active_ratio.patch

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
Subject: memcg: fix calclation of active_ratio
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, inactive_ratio of memcg is calculated at setting limit. 
because page_alloc.c does so and current implementation is straightforward
porting.

However, memcg introduced hierarchy feature recently.  In hierarchy
restriction, memory limit is not only decided memory.limit_in_bytes of
current cgroup, but also parent limit and sibling memory usage.

Then, The optimal inactive_ratio is changed frequently.  So, everytime
calculation is better.

Tested-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    3 -
 mm/memcontrol.c            |   64 ++++++++++++++++-------------------
 mm/vmscan.c                |    2 -
 3 files changed, 33 insertions(+), 36 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-fix-calclation-of-active_ratio include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-fix-calclation-of-active_ratio
+++ a/include/linux/memcontrol.h
@@ -97,8 +97,7 @@ extern void mem_cgroup_note_reclaim_prio
 							int priority);
 extern void mem_cgroup_record_reclaim_priority(struct mem_cgroup *mem,
 							int priority);
-int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg,
-				    struct zone *zone);
+int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg);
 unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
 				       struct zone *zone,
 				       enum lru_list lru);
diff -puN mm/memcontrol.c~memcg-fix-calclation-of-active_ratio mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-calclation-of-active_ratio
+++ a/mm/memcontrol.c
@@ -166,9 +166,6 @@ struct mem_cgroup {
 
 	unsigned int	swappiness;
 
-
-	unsigned int inactive_ratio;
-
 	/*
 	 * statistics. This must be placed at the end of memcg.
 	 */
@@ -432,15 +429,43 @@ void mem_cgroup_record_reclaim_priority(
 	spin_unlock(&mem->reclaim_param_lock);
 }
 
-int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg, struct zone *zone)
+static int calc_inactive_ratio(struct mem_cgroup *memcg, unsigned long *present_pages)
 {
 	unsigned long active;
 	unsigned long inactive;
+	unsigned long gb;
+	unsigned long inactive_ratio;
 
 	inactive = mem_cgroup_get_all_zonestat(memcg, LRU_INACTIVE_ANON);
 	active = mem_cgroup_get_all_zonestat(memcg, LRU_ACTIVE_ANON);
 
-	if (inactive * memcg->inactive_ratio < active)
+	gb = (inactive + active) >> (30 - PAGE_SHIFT);
+	if (gb)
+		inactive_ratio = int_sqrt(10 * gb);
+	else
+		inactive_ratio = 1;
+
+	if (present_pages) {
+		present_pages[0] = inactive;
+		present_pages[1] = active;
+	}
+
+	return inactive_ratio;
+}
+
+int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg)
+{
+	unsigned long active;
+	unsigned long inactive;
+	unsigned long present_pages[2];
+	unsigned long inactive_ratio;
+
+	inactive_ratio = calc_inactive_ratio(memcg, present_pages);
+
+	inactive = present_pages[0];
+	active = present_pages[1];
+
+	if (inactive * inactive_ratio < active)
 		return 1;
 
 	return 0;
@@ -1427,29 +1452,6 @@ int mem_cgroup_shrink_usage(struct mm_st
 	return 0;
 }
 
-/*
- * The inactive anon list should be small enough that the VM never has to
- * do too much work, but large enough that each inactive page has a chance
- * to be referenced again before it is swapped out.
- *
- * this calculation is straightforward porting from
- * page_alloc.c::setup_per_zone_inactive_ratio().
- * it describe more detail.
- */
-static void mem_cgroup_set_inactive_ratio(struct mem_cgroup *memcg)
-{
-	unsigned int gb, ratio;
-
-	gb = res_counter_read_u64(&memcg->res, RES_LIMIT) >> 30;
-	if (gb)
-		ratio = int_sqrt(10 * gb);
-	else
-		ratio = 1;
-
-	memcg->inactive_ratio = ratio;
-
-}
-
 static DEFINE_MUTEX(set_limit_mutex);
 
 static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
@@ -1491,9 +1493,6 @@ static int mem_cgroup_resize_limit(struc
   		if (!progress)			retry_count--;
 	}
 
-	if (!ret)
-		mem_cgroup_set_inactive_ratio(memcg);
-
 	return ret;
 }
 
@@ -1853,7 +1852,7 @@ static int mem_control_stat_show(struct 
 	}
 
 #ifdef CONFIG_DEBUG_VM
-	cb->fill(cb, "inactive_ratio", mem_cont->inactive_ratio);
+	cb->fill(cb, "inactive_ratio", calc_inactive_ratio(mem_cont, NULL));
 
 	{
 		int nid, zid;
@@ -2145,7 +2144,6 @@ mem_cgroup_create(struct cgroup_subsys *
 		res_counter_init(&mem->res, NULL);
 		res_counter_init(&mem->memsw, NULL);
 	}
-	mem_cgroup_set_inactive_ratio(mem);
 	mem->last_scanned_child = NULL;
 	spin_lock_init(&mem->reclaim_param_lock);
 
diff -puN mm/vmscan.c~memcg-fix-calclation-of-active_ratio mm/vmscan.c
--- a/mm/vmscan.c~memcg-fix-calclation-of-active_ratio
+++ a/mm/vmscan.c
@@ -1387,7 +1387,7 @@ static int inactive_anon_is_low(struct z
 	if (scanning_global_lru(sc))
 		low = inactive_anon_is_low_global(zone);
 	else
-		low = mem_cgroup_inactive_anon_is_low(sc->mem_cgroup, zone);
+		low = mem_cgroup_inactive_anon_is_low(sc->mem_cgroup);
 	return low;
 }
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
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
vmscan-improve-reclaim-throughput-to-bail-out-patch.patch
mm-kill-zone_is_near_oom.patch
mm-make-get_user_pages-interruptible.patch
mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_pages-during-munlock.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
devices-cgroup-allow-mkfifo.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-inactive_anon_is_low-vmscan-style-cleanup.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-fix-calclation-of-active_ratio.patch
memcg-explain-details-and-test-document.patch

