From: akpm@linux-foundation.org
Subject: + mm-vmscan-handle-isolated-pages-with-lru-lock-released.patch added to -mm tree
Date: Fri, 17 Feb 2012 14:09:26 -0800
Message-ID: <20120217220926.B3FACA01FC@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:62109 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab2BQWJ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 17 Feb 2012 17:09:28 -0500
Received: by ggnp1 with SMTP id p1so483933ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2012 14:09:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhillf@gmail.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     Subject: vmscan: handle isolated pages with lru lock released
has been added to the -mm tree.  Its filename is
     mm-vmscan-handle-isolated-pages-with-lru-lock-released.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: vmscan: handle isolated pages with lru lock released

When shrinking inactive lru list, isolated pages are queued on locally
private list, so the lock-hold time could be reduced if pages are counted
without lock protection.

To achieve that, firstly updating reclaim stat is delayed until the
putback stage, after reacquiring the lru lock.

Secondly, operations related to vm and zone stats are now proteced with
preemption disabled as they are per-cpu operations.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-handle-isolated-pages-with-lru-lock-released mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-handle-isolated-pages-with-lru-lock-released
+++ a/mm/vmscan.c
@@ -1413,7 +1413,6 @@ update_isolated_counts(struct mem_cgroup
 		       unsigned long *nr_anon,
 		       unsigned long *nr_file)
 {
-	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
 	struct zone *zone = mz->zone;
 	unsigned int count[NR_LRU_LISTS] = { 0, };
 	unsigned long nr_active = 0;
@@ -1434,6 +1433,7 @@ update_isolated_counts(struct mem_cgroup
 		count[lru] += numpages;
 	}
 
+	preempt_disable();
 	__count_vm_events(PGDEACTIVATE, nr_active);
 
 	__mod_zone_page_state(zone, NR_ACTIVE_FILE,
@@ -1448,8 +1448,9 @@ update_isolated_counts(struct mem_cgroup
 	*nr_anon = count[LRU_ACTIVE_ANON] + count[LRU_INACTIVE_ANON];
 	*nr_file = count[LRU_ACTIVE_FILE] + count[LRU_INACTIVE_FILE];
 
-	reclaim_stat->recent_scanned[0] += *nr_anon;
-	reclaim_stat->recent_scanned[1] += *nr_file;
+	__mod_zone_page_state(zone, NR_ISOLATED_ANON, *nr_anon);
+	__mod_zone_page_state(zone, NR_ISOLATED_FILE, *nr_file);
+	preempt_enable();
 }
 
 /*
@@ -1511,6 +1512,7 @@ shrink_inactive_list(unsigned long nr_to
 	unsigned long nr_writeback = 0;
 	isolate_mode_t isolate_mode = ISOLATE_INACTIVE;
 	struct zone *zone = mz->zone;
+	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
 
 	while (unlikely(too_many_isolated(zone, file, sc))) {
 		congestion_wait(BLK_RW_ASYNC, HZ/10);
@@ -1544,19 +1546,13 @@ shrink_inactive_list(unsigned long nr_to
 			__count_zone_vm_events(PGSCAN_DIRECT, zone,
 					       nr_scanned);
 	}
+	spin_unlock_irq(&zone->lru_lock);
 
-	if (nr_taken == 0) {
-		spin_unlock_irq(&zone->lru_lock);
+	if (nr_taken == 0)
 		return 0;
-	}
 
 	update_isolated_counts(mz, &page_list, &nr_anon, &nr_file);
 
-	__mod_zone_page_state(zone, NR_ISOLATED_ANON, nr_anon);
-	__mod_zone_page_state(zone, NR_ISOLATED_FILE, nr_file);
-
-	spin_unlock_irq(&zone->lru_lock);
-
 	nr_reclaimed = shrink_page_list(&page_list, mz, sc, priority,
 						&nr_dirty, &nr_writeback);
 
@@ -1569,6 +1565,9 @@ shrink_inactive_list(unsigned long nr_to
 
 	spin_lock_irq(&zone->lru_lock);
 
+	reclaim_stat->recent_scanned[0] += nr_anon;
+	reclaim_stat->recent_scanned[1] += nr_file;
+
 	if (current_is_kswapd())
 		__count_vm_events(KSWAPD_STEAL, nr_reclaimed);
 	__count_zone_vm_events(PGSTEAL, zone, nr_reclaimed);
_
Subject: Subject: vmscan: handle isolated pages with lru lock released

Patches currently in -mm which might be from dhillf@gmail.com are

mm-vmscanc-cleanup-with-s-reclaim_mode-isolate_mode.patch
mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch
vmscan-reclaim-at-order-0-when-compaction-is-enabled.patch
vmscan-kswapd-carefully-call-compaction.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
vmscan-only-defer-compaction-for-failed-order-and-higher.patch
hugetlbfs-fix-hugetlb_get_unmapped_area.patch
hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch
mm-search-from-free_area_cache-for-the-bigger-size.patch
mm-hugetlb-defer-freeing-pages-when-gathering-surplus-pages.patch
mm-vmscan-handle-isolated-pages-with-lru-lock-released.patch

