From: akpm@linux-foundation.org
Subject: + mm-rename-pgmoved-variable-in-shrink_active_list.patch added to -mm tree
Date: Wed, 15 Jul 2009 20:21:32 -0700
Message-ID: <200907160321.n6G3LW2I028151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757277AbZGPDVu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jul 2009 23:21:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     mm: rename pgmoved variable in shrink_active_list()
has been added to the -mm tree.  Its filename is
     mm-rename-pgmoved-variable-in-shrink_active_list.patch

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
Subject: mm: rename pgmoved variable in shrink_active_list()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently the pgmoved variable has two meanings.  It causes harder
reviewing.  This patch separates it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/vmscan.c~mm-rename-pgmoved-variable-in-shrink_active_list mm/vmscan.c
--- a/mm/vmscan.c~mm-rename-pgmoved-variable-in-shrink_active_list
+++ a/mm/vmscan.c
@@ -1239,7 +1239,7 @@ static void move_active_pages_to_lru(str
 static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
 			struct scan_control *sc, int priority, int file)
 {
-	unsigned long pgmoved;
+	unsigned long nr_taken;
 	unsigned long pgscanned;
 	unsigned long vm_flags;
 	LIST_HEAD(l_hold);	/* The pages which were snipped off */
@@ -1247,10 +1247,11 @@ static void shrink_active_list(unsigned 
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
@@ -1260,16 +1261,15 @@ static void shrink_active_list(unsigned 
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
@@ -1283,7 +1283,7 @@ static void shrink_active_list(unsigned 
 		/* page_referenced clears PageReferenced */
 		if (page_mapping_inuse(page) &&
 		    page_referenced(page, 0, sc->mem_cgroup, &vm_flags)) {
-			pgmoved++;
+			nr_rotated++;
 			/*
 			 * Identify referenced, file-backed active pages and
 			 * give them one more trip around the active list. So
@@ -1312,7 +1312,7 @@ static void shrink_active_list(unsigned 
 	 * helps balance scan pressure between file and anonymous pages in
 	 * get_scan_ratio.
 	 */
-	reclaim_stat->recent_rotated[!!file] += pgmoved;
+	reclaim_stat->recent_rotated[!!file] += nr_rotated;
 
 	move_active_pages_to_lru(zone, &l_active,
 						LRU_ACTIVE + file * LRU_FILE);
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

