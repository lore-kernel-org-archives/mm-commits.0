From: akpm@linux-foundation.org
Subject: + mm-shrink_inactive_list-nr_scan-accounting-fix-fix.patch added to -mm tree
Date: Wed, 15 Jul 2009 20:21:34 -0700
Message-ID: <200907160321.n6G3LYB8028189@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757307AbZGPDVy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jul 2009 23:21:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, riel@redhat.com


The patch titled
     mm: shrink_inactive_list() nr_scan accounting fix fix
has been added to the -mm tree.  Its filename is
     mm-shrink_inactive_list-nr_scan-accounting-fix-fix.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff -puN mm/vmscan.c~mm-shrink_inactive_list-nr_scan-accounting-fix-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-shrink_inactive_list-nr_scan-accounting-fix-fix
+++ a/mm/vmscan.c
@@ -1071,6 +1071,20 @@ static unsigned long shrink_inactive_lis
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
 
@@ -1083,8 +1097,6 @@ static unsigned long shrink_inactive_lis
 		__mod_zone_page_state(zone, NR_INACTIVE_ANON,
 						-count[LRU_INACTIVE_ANON]);
 
-		if (scanning_global_lru(sc))
-			zone->pages_scanned += nr_scan;
 
 		reclaim_stat->recent_scanned[0] += count[LRU_INACTIVE_ANON];
 		reclaim_stat->recent_scanned[0] += count[LRU_ACTIVE_ANON];
@@ -1118,18 +1130,12 @@ static unsigned long shrink_inactive_lis
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
@@ -1159,9 +1165,9 @@ static unsigned long shrink_inactive_lis
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

linux-next.patch
mm-copy-over-oom_adj-value-at-fork-time.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
mm-clean-up-page_remove_rmap.patch
mm-show_free_areas-display-slab-pages-in-two-separate-fields.patch
mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch
mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output.patch
mm-oom-analysis-add-shmem-vmstat.patch
mm-rename-pgmoved-variable-in-shrink_active_list.patch
mm-shrink_inactive_list-nr_scan-accounting-fix-fix.patch
mm-vmstat-add-isolate-pages.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

