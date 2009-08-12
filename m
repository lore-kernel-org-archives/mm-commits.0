From: akpm@linux-foundation.org
Subject: + mm-drop-unneeded-double-negations.patch added to -mm tree
Date: Wed, 12 Aug 2009 15:57:01 -0700
Message-ID: <200908122257.n7CMv1QM021457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752759AbZHLW5e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Aug 2009 18:57:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, mel@csn.ul.ie


The patch titled
     mm: drop unneeded double negations
has been added to the -mm tree.  Its filename is
     mm-drop-unneeded-double-negations.patch

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
Subject: mm: drop unneeded double negations
From: Johannes Weiner <hannes@cmpxchg.org>

Remove double negations where the operand is already boolean.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
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
@@ -598,7 +598,7 @@ copy_one_pte(struct mm_struct *dst_mm, s
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
@@ -966,7 +966,7 @@ static unsigned long isolate_pages_globa
 	if (file)
 		lru += LRU_FILE;
 	return isolate_lru_pages(nr, &z->lru[lru].list, dst, scanned, order,
-								mode, !!file);
+								mode, file);
 }
 
 /*
@@ -1204,7 +1204,7 @@ static unsigned long shrink_inactive_lis
 			lru = page_lru(page);
 			add_page_to_lru_list(zone, page, lru);
 			if (is_active_lru(lru)) {
-				int file = !!is_file_lru(lru);
+				int file = is_file_lru(lru);
 				reclaim_stat->recent_rotated[file]++;
 			}
 			if (!pagevec_add(&pvec, page)) {
@@ -1314,7 +1314,7 @@ static void shrink_active_list(unsigned 
 	if (scanning_global_lru(sc)) {
 		zone->pages_scanned += pgscanned;
 	}
-	reclaim_stat->recent_scanned[!!file] += nr_taken;
+	reclaim_stat->recent_scanned[file] += nr_taken;
 
 	__count_zone_vm_events(PGREFILL, zone, pgscanned);
 	if (file)
@@ -1367,7 +1367,7 @@ static void shrink_active_list(unsigned 
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
vfs-make-get_sb_pseudo-set-s_maxbytes-to-value-that-can-be-cast-to-signed.patch
linux-next.patch
vfs-remove-redundant-position-check-in-do_sendfile.patch
vfs-change-sb-s_maxbytes-to-a-loff_t.patch
mm-make-swap-token-dummies-static-inlines.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
mm-count-only-reclaimable-lru-pages-v2.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
mm-add_to_swap_cache-must-not-sleep.patch
mm-add_to_swap_cache-does-not-return-eexist.patch
mm-drop-unneeded-double-negations.patch
mm-introduce-page_lru_base_type.patch
mm-return-boolean-from-page_is_file_cache.patch
mm-return-boolean-from-page_has_private.patch
mm-document-is_page_cache_freeable.patch

