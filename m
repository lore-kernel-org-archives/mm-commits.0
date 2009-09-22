From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-rename-zone_nr_pages-to-zone_lru_nr_pages.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:42:09 -0700
Message-ID: <200909222042.n8MKg9wg008989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37585 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753060AbZIVUnU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:43:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macli@brc.ubc.ca, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm/vmscan: rename zone_nr_pages() to zone_nr_lru_pages()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-rename-zone_nr_pages-to-zone_lru_nr_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/vmscan: rename zone_nr_pages() to zone_nr_lru_pages()
From: Vincent Li <macli@brc.ubc.ca>

The name `zone_nr_pages' can be mis-read as zone's (total) number pages,
but it actually returns zone's LRU list number pages.

Signed-off-by: Vincent Li <macli@brc.ubc.ca>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-rename-zone_nr_pages-to-zone_lru_nr_pages mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-rename-zone_nr_pages-to-zone_lru_nr_pages
+++ a/mm/vmscan.c
@@ -148,8 +148,8 @@ static struct zone_reclaim_stat *get_rec
 	return &zone->reclaim_stat;
 }
 
-static unsigned long zone_nr_pages(struct zone *zone, struct scan_control *sc,
-				   enum lru_list lru)
+static unsigned long zone_nr_lru_pages(struct zone *zone,
+				struct scan_control *sc, enum lru_list lru)
 {
 	if (!scanning_global_lru(sc))
 		return mem_cgroup_zone_nr_pages(sc->mem_cgroup, zone, lru);
@@ -1489,10 +1489,10 @@ static void get_scan_ratio(struct zone *
 	unsigned long ap, fp;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 
-	anon  = zone_nr_pages(zone, sc, LRU_ACTIVE_ANON) +
-		zone_nr_pages(zone, sc, LRU_INACTIVE_ANON);
-	file  = zone_nr_pages(zone, sc, LRU_ACTIVE_FILE) +
-		zone_nr_pages(zone, sc, LRU_INACTIVE_FILE);
+	anon  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_ANON) +
+		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_ANON);
+	file  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_FILE) +
+		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_FILE);
 
 	if (scanning_global_lru(sc)) {
 		free  = zone_page_state(zone, NR_FREE_PAGES);
@@ -1600,7 +1600,7 @@ static void shrink_zone(int priority, st
 		int file = is_file_lru(l);
 		unsigned long scan;
 
-		scan = zone_nr_pages(zone, sc, l);
+		scan = zone_nr_lru_pages(zone, sc, l);
 		if (priority || noswap) {
 			scan >>= priority;
 			scan = (scan * percent[file]) / 100;
_

Patches currently in -mm which might be from macli@brc.ubc.ca are

origin.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
fs-proc-task_mmuc-v1-fix-clear_refs_write-input-sanity-check.patch
fs-proc-basec-fix-proc_fault_inject_write-input-sanity-check.patch

