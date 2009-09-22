From: akpm@linux-foundation.org
Subject: [merged] mm-drop-unneeded-double-negations.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:41:39 -0700
Message-ID: <200909222041.n8MKfdQC007984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752620AbZIVUlo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:41:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm: drop unneeded double negations
has been removed from the -mm tree.  Its filename was
     mm-drop-unneeded-double-negations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: drop unneeded double negations
From: Johannes Weiner <hannes@cmpxchg.org>

Remove double negations where the operand is already boolean.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 mm/memory.c     |    2 +-
 mm/vmscan.c     |    8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~mm-drop-unneeded-double-negations mm/memcontrol.c
--- a/mm/memcontrol.c~mm-drop-unneeded-double-negations
+++ a/mm/memcontrol.c
@@ -648,7 +648,7 @@ unsigned long mem_cgroup_isolate_pages(u
 	int nid = z->zone_pgdat->node_id;
 	int zid = zone_idx(z);
 	struct mem_cgroup_per_zone *mz;
-	int lru = LRU_FILE * !!file + !!active;
+	int lru = LRU_FILE * file + active;
 	int ret;
 
 	BUG_ON(!mem_cont);
diff -puN mm/memory.c~mm-drop-unneeded-double-negations mm/memory.c
--- a/mm/memory.c~mm-drop-unneeded-double-negations
+++ a/mm/memory.c
@@ -599,7 +599,7 @@ copy_one_pte(struct mm_struct *dst_mm, s
 	if (page) {
 		get_page(page);
 		page_dup_rmap(page);
-		rss[!!PageAnon(page)]++;
+		rss[PageAnon(page)]++;
 	}
 
 out_set_pte:
diff -puN mm/vmscan.c~mm-drop-unneeded-double-negations mm/vmscan.c
--- a/mm/vmscan.c~mm-drop-unneeded-double-negations
+++ a/mm/vmscan.c
@@ -971,7 +971,7 @@ static unsigned long isolate_pages_globa
 	if (file)
 		lru += LRU_FILE;
 	return isolate_lru_pages(nr, &z->lru[lru].list, dst, scanned, order,
-								mode, !!file);
+								mode, file);
 }
 
 /*
@@ -1209,7 +1209,7 @@ static unsigned long shrink_inactive_lis
 			lru = page_lru(page);
 			add_page_to_lru_list(zone, page, lru);
 			if (is_active_lru(lru)) {
-				int file = !!is_file_lru(lru);
+				int file = is_file_lru(lru);
 				reclaim_stat->recent_rotated[file]++;
 			}
 			if (!pagevec_add(&pvec, page)) {
@@ -1319,7 +1319,7 @@ static void shrink_active_list(unsigned 
 	if (scanning_global_lru(sc)) {
 		zone->pages_scanned += pgscanned;
 	}
-	reclaim_stat->recent_scanned[!!file] += nr_taken;
+	reclaim_stat->recent_scanned[file] += nr_taken;
 
 	__count_zone_vm_events(PGREFILL, zone, pgscanned);
 	if (file)
@@ -1372,7 +1372,7 @@ static void shrink_active_list(unsigned 
 	 * helps balance scan pressure between file and anonymous pages in
 	 * get_scan_ratio.
 	 */
-	reclaim_stat->recent_rotated[!!file] += nr_rotated;
+	reclaim_stat->recent_rotated[file] += nr_rotated;
 
 	move_active_pages_to_lru(zone, &l_active,
 						LRU_ACTIVE + file * LRU_FILE);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
vfs-explicitly-cast-s_maxbytes-in-fiemap_check_ranges.patch
vfs-change-sb-s_maxbytes-to-a-loff_t.patch
vfs-remove-redundant-position-check-in-do_sendfile.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch

