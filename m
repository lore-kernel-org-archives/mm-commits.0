From: akpm@linux-foundation.org
Subject: [merged] mm-rename-pgmoved-variable-in-shrink_active_list.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:38:21 -0700
Message-ID: <200909222038.n8MKcLTW001244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752764AbZIVUmR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: rename pgmoved variable in shrink_active_list()
has been removed from the -mm tree.  Its filename was
     mm-rename-pgmoved-variable-in-shrink_active_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: rename pgmoved variable in shrink_active_list()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently the pgmoved variable has two meanings.  It causes harder
reviewing.  This patch separates it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/vmscan.c~mm-rename-pgmoved-variable-in-shrink_active_list mm/vmscan.c
--- a/mm/vmscan.c~mm-rename-pgmoved-variable-in-shrink_active_list
+++ a/mm/vmscan.c
@@ -1244,7 +1244,7 @@ static void move_active_pages_to_lru(str
 static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
 			struct scan_control *sc, int priority, int file)
 {
-	unsigned long pgmoved;
+	unsigned long nr_taken;
 	unsigned long pgscanned;
 	unsigned long vm_flags;
 	LIST_HEAD(l_hold);	/* The pages which were snipped off */
@@ -1252,10 +1252,11 @@ static void shrink_active_list(unsigned 
 	LIST_HEAD(l_inactive);
 	struct page *page;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
+	unsigned long nr_rotated = 0;
 
 	lru_add_drain();
 	spin_lock_irq(&zone->lru_lock);
-	pgmoved = sc->isolate_pages(nr_pages, &l_hold, &pgscanned, sc->order,
+	nr_taken = sc->isolate_pages(nr_pages, &l_hold, &pgscanned, sc->order,
 					ISOLATE_ACTIVE, zone,
 					sc->mem_cgroup, 1, file);
 	/*
@@ -1265,16 +1266,15 @@ static void shrink_active_list(unsigned 
 	if (scanning_global_lru(sc)) {
 		zone->pages_scanned += pgscanned;
 	}
-	reclaim_stat->recent_scanned[!!file] += pgmoved;
+	reclaim_stat->recent_scanned[!!file] += nr_taken;
 
 	__count_zone_vm_events(PGREFILL, zone, pgscanned);
 	if (file)
-		__mod_zone_page_state(zone, NR_ACTIVE_FILE, -pgmoved);
+		__mod_zone_page_state(zone, NR_ACTIVE_FILE, -nr_taken);
 	else
-		__mod_zone_page_state(zone, NR_ACTIVE_ANON, -pgmoved);
+		__mod_zone_page_state(zone, NR_ACTIVE_ANON, -nr_taken);
 	spin_unlock_irq(&zone->lru_lock);
 
-	pgmoved = 0;  /* count referenced (mapping) mapped pages */
 	while (!list_empty(&l_hold)) {
 		cond_resched();
 		page = lru_to_page(&l_hold);
@@ -1288,7 +1288,7 @@ static void shrink_active_list(unsigned 
 		/* page_referenced clears PageReferenced */
 		if (page_mapping_inuse(page) &&
 		    page_referenced(page, 0, sc->mem_cgroup, &vm_flags)) {
-			pgmoved++;
+			nr_rotated++;
 			/*
 			 * Identify referenced, file-backed active pages and
 			 * give them one more trip around the active list. So
@@ -1317,7 +1317,7 @@ static void shrink_active_list(unsigned 
 	 * helps balance scan pressure between file and anonymous pages in
 	 * get_scan_ratio.
 	 */
-	reclaim_stat->recent_rotated[!!file] += pgmoved;
+	reclaim_stat->recent_rotated[!!file] += nr_rotated;
 
 	move_active_pages_to_lru(zone, &l_active,
 						LRU_ACTIVE + file * LRU_FILE);
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

