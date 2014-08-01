From: akpm@linux-foundation.org
Subject: +
 memcg-vmscan-fix-forced-scan-of-anonymous-pages-fix-cleanups.patch added to -mm tree
Date: Fri, 01 Aug 2014 11:53:06 -0700
Message-ID: <53dbe212.GyTjpFCLSc2M3t5E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:33602 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaHASxH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Aug 2014 14:53:07 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so825320pab.5
        for <mm-commits@vger.kernel.org>; Fri, 01 Aug 2014 11:53:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg, vmscan: fix forced scan of anonymous pages fix - cleanups
has been added to the -mm tree.  Its filename is
     memcg-vmscan-fix-forced-scan-of-anonymous-pages-fix-cleanups.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-vmscan-fix-forced-scan-of-anonymous-pages-fix-cleanups.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-vmscan-fix-forced-scan-of-anonymous-pages-fix-cleanups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: memcg, vmscan: fix forced scan of anonymous pages fix - cleanups

o Use enum zone_stat_item symbols directly to select zone stats,
  rather than NR_LRU_BASE plus LRU index

o scanned/rotated scaling is the only user of the lruvec anon/file
  counters, so move the reads of those values to right before that

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff -puN mm/vmscan.c~memcg-vmscan-fix-forced-scan-of-anonymous-pages-fix-cleanups mm/vmscan.c
--- a/mm/vmscan.c~memcg-vmscan-fix-forced-scan-of-anonymous-pages-fix-cleanups
+++ a/mm/vmscan.c
@@ -1934,11 +1934,6 @@ static void get_scan_count(struct lruvec
 		goto out;
 	}
 
-	anon  = get_lru_size(lruvec, LRU_ACTIVE_ANON) +
-		get_lru_size(lruvec, LRU_INACTIVE_ANON);
-	file  = get_lru_size(lruvec, LRU_ACTIVE_FILE) +
-		get_lru_size(lruvec, LRU_INACTIVE_FILE);
-
 	/*
 	 * Prevent the reclaimer from falling into the cache trap: as
 	 * cache pages start out inactive, every cache fault will tip
@@ -1949,12 +1944,14 @@ static void get_scan_count(struct lruvec
 	 * anon pages.  Try to detect this based on file LRU size.
 	 */
 	if (global_reclaim(sc)) {
-		unsigned long free = zone_page_state(zone, NR_FREE_PAGES);
-		unsigned long zonefile =
-			zone_page_state(zone, NR_LRU_BASE + LRU_ACTIVE_FILE) +
-			zone_page_state(zone, NR_LRU_BASE + LRU_INACTIVE_FILE);
+		unsigned long zonefile;
+		unsigned long zonefree;
+
+		zonefree = zone_page_state(zone, NR_FREE_PAGES);
+		zonefile = zone_page_state(zone, NR_ACTIVE_FILE) +
+			   zone_page_state(zone, NR_INACTIVE_FILE);
 
-		if (unlikely(zonefile + free <= high_wmark_pages(zone))) {
+		if (unlikely(zonefile + zonefree <= high_wmark_pages(zone))) {
 			scan_balance = SCAN_ANON;
 			goto out;
 		}
@@ -1989,6 +1986,12 @@ static void get_scan_count(struct lruvec
 	 *
 	 * anon in [0], file in [1]
 	 */
+
+	anon  = get_lru_size(lruvec, LRU_ACTIVE_ANON) +
+		get_lru_size(lruvec, LRU_INACTIVE_ANON);
+	file  = get_lru_size(lruvec, LRU_ACTIVE_FILE) +
+		get_lru_size(lruvec, LRU_INACTIVE_FILE);
+
 	spin_lock_irq(&zone->lru_lock);
 	if (unlikely(reclaim_stat->recent_scanned[0] > anon / 4)) {
 		reclaim_stat->recent_scanned[0] /= 2;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
mm-page-flags-clean-up-the-page-flag-test-set-clear-macros.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-use-root_mem_cgroup-res_counter.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-charge-api-fix-3.patch
mm-memcontrol-rewrite-charge-api-fix-shmem_unuse.patch
mm-memcontrol-rewrite-charge-api-fix-hugetlb-charging.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-2.patch
mm-memcontrol-rewrite-uncharge-api-fix-4.patch
mm-memcontrol-rewrite-uncharge-api-fix-5.patch
mm-memcontrol-rewrite-uncharge-api-fix-uncharge-from-irq-context.patch
mm-memcontrol-rewrite-uncharge-api-fix-double-migration-v2.patch
mm-memcontrol-rewrite-uncharge-api-fix-migrate-before-re-mapping.patch
mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration.patch
mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration-2.patch
mm-memcontrol-rewrite-uncharge-api-fix-clear-page-mapping-in-migration.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
memcg-remove-lookup_cgroup_page-prototype.patch
mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim-fix.patch
mm-vmscan-remove-all_unreclaimable.patch
mm-vmscan-remove-all_unreclaimable-fix.patch
mm-vmscan-move-swappiness-out-of-scan_control.patch
mm-vmscan-clean-up-struct-scan_control-v2.patch
mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch
mm-replace-init_page_accessed-by-__setpagereferenced.patch
mm-update-the-description-for-vm_total_pages.patch
mm-vmscan-report-the-number-of-file-anon-pages-respectively.patch
mm-pagemap-avoid-unnecessary-overhead-when-tracepoints-are-deactivated.patch
mm-rearrange-zone-fields-into-read-only-page-alloc-statistics-and-page-reclaim-lines.patch
mm-move-zone-pages_scanned-into-a-vmstat-counter.patch
mm-vmscan-only-update-per-cpu-thresholds-for-online-cpu.patch
mm-page_alloc-abort-fair-zone-allocation-policy-when-remotes-nodes-are-encountered.patch
mm-page_alloc-reduce-cost-of-the-fair-zone-allocation-policy.patch
mm-writeback-prevent-race-when-calculating-dirty-limits.patch
slub-remove-kmemcg-id-from-create_unique_id.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix.patch
mm-oom-remove-unnecessary-check-for-null-zonelist.patch
mm-oom-rename-zonelist-locking-functions.patch
mm-thp-restructure-thp-avoidance-of-light-synchronous-migration.patch
mm-vmscan-fix-an-outdated-comment-still-mentioning-get_scan_ratio.patch
memcg-vmscan-fix-forced-scan-of-anonymous-pages.patch
memcg-vmscan-fix-forced-scan-of-anonymous-pages-fix-cleanups.patch
nilfs2-integrate-sysfs-support-into-driver-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

