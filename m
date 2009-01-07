From: akpm@linux-foundation.org
Subject: - swapfile-change-discard-pgoff_t-to-sector_t.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:13:36 -0800
Message-ID: <200901072213.n07MDap7013628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758513AbZAGWOZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:14:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, James.Bottomley@HansenPartnership.com, djshin90@gmail.com, dwmw2@infradead.org, jens.axboe@oracle.com, joern@logfs.org, kamezawa.hiroyu@jp.fujitsu.com, matthew@wil.cx


The patch titled
     swapfile: change discard pgoff_t to sector_t
has been removed from the -mm tree.  Its filename was
     swapfile-change-discard-pgoff_t-to-sector_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: swapfile: change discard pgoff_t to sector_t
From: Hugh Dickins <hugh@veritas.com>

Change pgoff_t nr_blocks in discard_swap() and discard_swap_cluster() to
sector_t: given the constraints on swap offsets (in particular, the 5 bits
of swap type accommodated in the same unsigned long), pgoff_t was actually
safe as is, but it certainly looked worrying when shifted left.

[akpm@linux-foundation.org: fix shift overflow]
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Joern Engel <joern@logfs.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Donjun Shin <djshin90@gmail.com>
Cc: Tejun Heo <teheo@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/swapfile.c~swapfile-change-discard-pgoff_t-to-sector_t mm/swapfile.c
--- a/mm/swapfile.c~swapfile-change-discard-pgoff_t-to-sector_t
+++ a/mm/swapfile.c
@@ -96,7 +96,7 @@ static int discard_swap(struct swap_info
 
 	list_for_each_entry(se, &si->extent_list, list) {
 		sector_t start_block = se->start_block << (PAGE_SHIFT - 9);
-		pgoff_t nr_blocks = se->nr_pages << (PAGE_SHIFT - 9);
+		sector_t nr_blocks = (sector_t)se->nr_pages << (PAGE_SHIFT - 9);
 
 		if (se->start_page == 0) {
 			/* Do not discard the swap header page! */
@@ -133,7 +133,7 @@ static void discard_swap_cluster(struct 
 		    start_page < se->start_page + se->nr_pages) {
 			pgoff_t offset = start_page - se->start_page;
 			sector_t start_block = se->start_block + offset;
-			pgoff_t nr_blocks = se->nr_pages - offset;
+			sector_t nr_blocks = se->nr_pages - offset;
 
 			if (nr_blocks > nr_pages)
 				nr_blocks = nr_pages;
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
linux-next.patch
mark-complex-bitopsh-inlines-as-__always_inline.patch
clocksource-pass-clocksource-to-read-callback.patch
clocksource-pass-clocksource-to-read-callback-sparc-cleanup.patch
bio-zero-inlined-bio_vec.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-shmemc-fix-division-by-zero.patch
getrusage-fill-ru_maxrss-value.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-explain-details-and-test-document.patch
memcg-fix-swap-accounting-leak-v3.patch
memcg-fix-swap-accounting-leak-doc-fix.patch
memcg-fix-shmems-swap-accounting.patch
prio_tree-debugging-patch.patch

