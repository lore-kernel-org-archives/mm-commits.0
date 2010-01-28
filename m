From: akpm@linux-foundation.org
Subject: - memcg-add-anon_scan_ratio-to-memorystat-file.patch removed from -mm tree
Date: Wed, 27 Jan 2010 23:42:13 -0800
Message-ID: <201001280742.o0S7gDOi028122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932251Ab0A1HnD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jan 2010 02:43:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     memcg: add anon_scan_ratio to memory.stat file
has been removed from the -mm tree.  Its filename was
     memcg-add-anon_scan_ratio-to-memorystat-file.patch

This patch was dropped because I dropped memcg-add-anon_scan_ratio-to-memorystat-file.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: add anon_scan_ratio to memory.stat file
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

anon_scan_ratio feature doesn't only useful for global VM pressure
analysis, but it also useful for memcg memroy pressure analysis.

Then, this patch add anon_scan_ratio field to memory.stat file too.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   63 +++++++++++++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 22 deletions(-)

diff -puN mm/memcontrol.c~memcg-add-anon_scan_ratio-to-memorystat-file mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-anon_scan_ratio-to-memorystat-file
+++ a/mm/memcontrol.c
@@ -2950,6 +2950,11 @@ static int mem_control_stat_show(struct 
 {
 	struct mem_cgroup *mem_cont = mem_cgroup_from_cont(cont);
 	struct mcs_total_stat mystat;
+	struct zone *zone;
+	unsigned long total_anon = 0;
+	unsigned long total_scan_anon = 0;
+	unsigned long recent_rotated[2] = {0};
+	unsigned long recent_scanned[2] = {0};
 	int i;
 
 	memset(&mystat, 0, sizeof(mystat));
@@ -2978,33 +2983,47 @@ static int mem_control_stat_show(struct 
 		cb->fill(cb, memcg_stat_strings[i].total_name, mystat.stat[i]);
 	}
 
-#ifdef CONFIG_DEBUG_VM
 	cb->fill(cb, "inactive_ratio", calc_inactive_ratio(mem_cont, NULL));
 
-	{
-		int nid, zid;
+	for_each_populated_zone(zone) {
+		int nid = zone->zone_pgdat->node_id;
+		int zid = zone_idx(zone);
 		struct mem_cgroup_per_zone *mz;
-		unsigned long recent_rotated[2] = {0, 0};
-		unsigned long recent_scanned[2] = {0, 0};
+		unsigned long anon;
+		unsigned long ratio;
+
+		mz = mem_cgroup_zoneinfo(mem_cont, nid, zid);
+
+		anon = MEM_CGROUP_ZSTAT(mz, LRU_INACTIVE_ANON);
+		anon += MEM_CGROUP_ZSTAT(mz, LRU_ACTIVE_ANON);
+
+		ratio = get_anon_scan_ratio(zone, mem_cont, mem_cont->swappiness);
+
+		/*
+		 * We have per-zone anon-scan-ratio. but we don't hope display such
+		 * value directly. Instead, we display following fomula.
+		 *
+		 *   sum(anon * ratio/100)
+		 *   --------------------- * 100
+		 *        sum(anon)
+		 */
+		total_anon += anon;
+		total_scan_anon += anon * ratio;
 
-		for_each_online_node(nid)
-			for (zid = 0; zid < MAX_NR_ZONES; zid++) {
-				mz = mem_cgroup_zoneinfo(mem_cont, nid, zid);
-
-				recent_rotated[0] +=
-					mz->reclaim_stat.recent_rotated[0];
-				recent_rotated[1] +=
-					mz->reclaim_stat.recent_rotated[1];
-				recent_scanned[0] +=
-					mz->reclaim_stat.recent_scanned[0];
-				recent_scanned[1] +=
-					mz->reclaim_stat.recent_scanned[1];
-			}
-		cb->fill(cb, "recent_rotated_anon", recent_rotated[0]);
-		cb->fill(cb, "recent_rotated_file", recent_rotated[1]);
-		cb->fill(cb, "recent_scanned_anon", recent_scanned[0]);
-		cb->fill(cb, "recent_scanned_file", recent_scanned[1]);
+#ifdef CONFIG_DEBUG_VM
+		recent_rotated[0] += mz->reclaim_stat.recent_rotated[0];
+		recent_rotated[1] += mz->reclaim_stat.recent_rotated[1];
+		recent_scanned[0] += mz->reclaim_stat.recent_scanned[0];
+		recent_scanned[1] += mz->reclaim_stat.recent_scanned[1];
+#endif
 	}
+	cb->fill(cb, "anon_scan_ratio", total_scan_anon / total_anon);
+
+#ifdef CONFIG_DEBUG_VM
+	cb->fill(cb, "recent_rotated_anon", recent_rotated[0]);
+	cb->fill(cb, "recent_rotated_file", recent_rotated[1]);
+	cb->fill(cb, "recent_scanned_anon", recent_scanned[0]);
+	cb->fill(cb, "recent_scanned_file", recent_scanned[1]);
 #endif
 
 	return 0;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
sched-cpuacct-use-bigger-percpu-counter-batch-values-for-stats-counters.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mlock_vma_pages_range-never-return-negative-value.patch
mlock_vma_pages_range-only-return-success-or-failure.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
vmscan-get_scan_ratio-cleanup.patch
memcg-add-anon_scan_ratio-to-memorystat-file.patch
mm-lockdep-annotate-reclaim-context-to-zone-reclaim-too.patch
mm-page_allocc-remove-duplicate-call-to-trace_mm_page_free_direct.patch
mm-page_allocc-adjust-a-call-site-to-trace_mm_page_free_direct.patch
mm-remove-function-free_hot_page.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
mm-fix-mbind-vma-merge-problem.patch
mm-fix-mbind-vma-merge-problem-fix.patch
mm-mempolicyc-fix-indentation-of-the-comments-of-do_migrate_pages.patch
mm-migratec-kill-anon-local-variable-from-migrate_page_copy.patch
prctl-add-pr_set_proctitle_area-option-for-prctl.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch
memcg-move-charges-of-anonymous-swap-fix-2.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

