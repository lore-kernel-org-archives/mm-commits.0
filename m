From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-handle-isolated-pages-with-lru-lock-released.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:18:20 -0700
Message-ID: <20120322201820.7D569A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:46778 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758859Ab2CVUSV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:18:21 -0400
Received: by mail-vx0-f202.google.com with SMTP id fk26so402092vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:18:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhillf@gmail.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: handle isolated pages with lru lock released
has been removed from the -mm tree.  Its filename was
     mm-vmscan-handle-isolated-pages-with-lru-lock-released.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
