From: akpm@linux-foundation.org
Subject: - vmscan-evict-streaming-io-first.patch removed from -mm tree
Date: Wed, 03 Dec 2008 12:28:45 -0800
Message-ID: <200812032028.mB3KSjDv028078@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759262AbYLCUaA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 15:30:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, gene.heskett@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     vmscan: evict streaming IO first
has been removed from the -mm tree.  Its filename was
     vmscan-evict-streaming-io-first.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: evict streaming IO first
From: Rik van Riel <riel@redhat.com>

Count the insertion of new pages in the statistics used to drive the
pageout scanning code.  This should help the kernel quickly evict
streaming file IO.

We count on the fact that new file pages start on the inactive file LRU
and new anonymous pages start on the active anon list.  This means
streaming file IO will increment the recent scanned file statistic, while
leaving the recent rotated file statistic alone, driving pageout scanning
to the file LRUs.

Pageout activity does its own list manipulation.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Tested-by: Gene Heskett <gene.heskett@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/swap.c~vmscan-evict-streaming-io-first mm/swap.c
--- a/mm/swap.c~vmscan-evict-streaming-io-first
+++ a/mm/swap.c
@@ -445,6 +445,7 @@ void ____pagevec_lru_add(struct pagevec 
 	for (i = 0; i < pagevec_count(pvec); i++) {
 		struct page *page = pvec->pages[i];
 		struct zone *pagezone = page_zone(page);
+		int file;
 
 		if (pagezone != zone) {
 			if (zone)
@@ -456,8 +457,12 @@ void ____pagevec_lru_add(struct pagevec 
 		VM_BUG_ON(PageUnevictable(page));
 		VM_BUG_ON(PageLRU(page));
 		SetPageLRU(page);
-		if (is_active_lru(lru))
+		file = is_file_lru(lru);
+		zone->recent_scanned[file]++;
+		if (is_active_lru(lru)) {
 			SetPageActive(page);
+			zone->recent_rotated[file]++;
+		}
 		add_page_to_lru_list(zone, page, lru);
 	}
 	if (zone)
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
linux-next.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-add_active_or_unevictable-into-rmap.patch
mm-further-cleanup-page_add_new_anon_rmap.patch
mm-gup-persist-for-write-permission.patch
mm-wp-lock-page-before-deciding-cow.patch
mm-reuse_swap_page-replaces-can_share_swap_page.patch
mm-try_to_free_swap-replaces-remove_exclusive_swap_page.patch
mm-try_to_unuse-check-removing-right-swap.patch
mm-remove-try_to_munlock-from-vmscan.patch
mm-remove-gfp_mask-from-add_to_swap.patch
mm-add-add_to_swap-stub.patch
mm-optimize-get_scan_ratio-for-no-swap.patch
memcg-reclaim-shouldnt-change-zone-recent_rotated-statistics.patch
vmscan-bail-out-of-direct-reclaim-after-swap_cluster_max-pages.patch
badpage-simplify-page_alloc-flag-checkclear.patch
badpage-keep-any-bad-page-out-of-circulation.patch
badpage-replace-page_remove_rmap-eeek-and-bug.patch
badpage-vm_normal_page-use-print_bad_pte.patch
badpage-zap-print_bad_pte-on-swap-and-file.patch
badpage-remove-vma-from-page_remove_rmap.patch
badpage-ratelimit-print_bad_pte-and-bad_page.patch
badpage-kern_alert-bug-instead-of-kern_emerg.patch
vmscan-shrink_active_list-reduce-lru_lock-hold-time.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch

