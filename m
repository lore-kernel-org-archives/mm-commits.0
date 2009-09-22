From: akpm@linux-foundation.org
Subject: [merged] mm-shrink_inactive_list-nr_scan-accounting-fix-fix.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:38:24 -0700
Message-ID: <200909222038.n8MKcO7W001366@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752757AbZIVUmT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: shrink_inactive_list() nr_scan accounting fix fix
has been removed from the -mm tree.  Its filename was
     mm-shrink_inactive_list-nr_scan-accounting-fix-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: shrink_inactive_list() nr_scan accounting fix fix
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

If sc->isolate_pages() return 0, we don't need to call shrink_page_list().
In past days, shrink_inactive_list() handled it properly.

But commit fb8d14e1 (three years ago commit!) breaked it.  current
shrink_inactive_list() always call shrink_page_list() although
isolate_pages() return 0.

This patch restore proper return value check.

Requirements:
  o "nr_taken == 0" condition should stay before calling shrink_page_list().
  o "nr_taken == 0" condition should stay after nr_scan related statistics
     modification.

Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff -puN mm/vmscan.c~mm-shrink_inactive_list-nr_scan-accounting-fix-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-shrink_inactive_list-nr_scan-accounting-fix-fix
+++ a/mm/vmscan.c
@@ -1076,6 +1076,20 @@ static unsigned long shrink_inactive_lis
 		nr_taken = sc->isolate_pages(sc->swap_cluster_max,
 			     &page_list, &nr_scan, sc->order, mode,
 				zone, sc->mem_cgroup, 0, file);
+
+		if (scanning_global_lru(sc)) {
+			zone->pages_scanned += nr_scan;
+			if (current_is_kswapd())
+				__count_zone_vm_events(PGSCAN_KSWAPD, zone,
+						       nr_scan);
+			else
+				__count_zone_vm_events(PGSCAN_DIRECT, zone,
+						       nr_scan);
+		}
+
+		if (nr_taken == 0)
+			goto done;
+
 		nr_active = clear_active_flags(&page_list, count);
 		__count_vm_events(PGDEACTIVATE, nr_active);
 
@@ -1088,8 +1102,6 @@ static unsigned long shrink_inactive_lis
 		__mod_zone_page_state(zone, NR_INACTIVE_ANON,
 						-count[LRU_INACTIVE_ANON]);
 
-		if (scanning_global_lru(sc))
-			zone->pages_scanned += nr_scan;
 
 		reclaim_stat->recent_scanned[0] += count[LRU_INACTIVE_ANON];
 		reclaim_stat->recent_scanned[0] += count[LRU_ACTIVE_ANON];
@@ -1123,18 +1135,12 @@ static unsigned long shrink_inactive_lis
 		}
 
 		nr_reclaimed += nr_freed;
+
 		local_irq_disable();
-		if (current_is_kswapd()) {
-			__count_zone_vm_events(PGSCAN_KSWAPD, zone, nr_scan);
+		if (current_is_kswapd())
 			__count_vm_events(KSWAPD_STEAL, nr_freed);
-		} else if (scanning_global_lru(sc))
-			__count_zone_vm_events(PGSCAN_DIRECT, zone, nr_scan);
-
 		__count_zone_vm_events(PGSTEAL, zone, nr_freed);
 
-		if (nr_taken == 0)
-			goto done;
-
 		spin_lock(&zone->lru_lock);
 		/*
 		 * Put back any unfreeable pages.
@@ -1164,9 +1170,9 @@ static unsigned long shrink_inactive_lis
 			}
 		}
   	} while (nr_scanned < max_scan);
-	spin_unlock(&zone->lru_lock);
+
 done:
-	local_irq_enable();
+	spin_unlock_irq(&zone->lru_lock);
 	pagevec_release(&pvec);
 	return nr_reclaimed;
 }
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
revert-staging-android-lowmemorykillerc-fix-it-for-oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch
readahead-add-blk_run_backing_dev.patch
oom-move-oom_adj-value-from-task_struct-to-signal_struct-fix.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
getrusage-fill-ru_maxrss-value.patch
kcore-use-registerd-physmem-information-ia64-fix.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

