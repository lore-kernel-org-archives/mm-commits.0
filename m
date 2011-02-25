From: akpm@linux-foundation.org
Subject: [folded] mm-vmscan-stop-reclaim-compaction-earlier-due-to-insufficient-progress-if-__gfp_repeat-v2.patch removed from -mm tree
Date: Fri, 25 Feb 2011 14:42:43 -0800
Message-ID: <201102252242.p1PMghNr001718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754324Ab1BYWne (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Feb 2011 17:43:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, aarcange@redhat.com, hannes@cmpxchg.org, kent.overstreet@gmail.com, mhocko@suse.cz, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm-vmscan-stop-reclaim-compaction-earlier-due-to-insufficient-progress-if-__gfp_repeat-v2
has been removed from the -mm tree.  Its filename was
     mm-vmscan-stop-reclaim-compaction-earlier-due-to-insufficient-progress-if-__gfp_repeat-v2.patch

This patch was dropped because it was folded into mm-vmscan-stop-reclaim-compaction-earlier-due-to-insufficient-progress-if-__gfp_repeat.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-vmscan-stop-reclaim-compaction-earlier-due-to-insufficient-progress-if-__gfp_repeat-v2
From: Mel Gorman <mel@csn.ul.ie>

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-stop-reclaim-compaction-earlier-due-to-insufficient-progress-if-__gfp_repeat-v2 mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-stop-reclaim-compaction-earlier-due-to-insufficient-progress-if-__gfp_repeat-v2
+++ a/mm/vmscan.c
@@ -1844,16 +1844,16 @@ static inline bool should_continue_recla
 	/* Consider stopping depending on scan and reclaim activity */
 	if (sc->gfp_mask & __GFP_REPEAT) {
 		/*
-		 * For GFP_REPEAT allocations, stop reclaiming if the
+		 * For __GFP_REPEAT allocations, stop reclaiming if the
 		 * full LRU list has been scanned and we are still failing
 		 * to reclaim pages. This full LRU scan is potentially
-		 * expensive but a GFP_REPEAT caller really wants to succeed
+		 * expensive but a __GFP_REPEAT caller really wants to succeed
 		 */
 		if (!nr_reclaimed && !nr_scanned)
 			return false;
 	} else {
 		/*
-		 * For non-GFP_REPEAT allocations which can presumably
+		 * For non-__GFP_REPEAT allocations which can presumably
 		 * fail without consequence, stop if we failed to reclaim
 		 * any pages from the last SWAP_CLUSTER_MAX number of
 		 * pages that were scanned. This will return to the
_

Patches currently in -mm which might be from mel@csn.ul.ie are

mm-grab-rcu-read-lock-in-move_pages.patch
mm-vmscan-stop-reclaim-compaction-earlier-due-to-insufficient-progress-if-__gfp_repeat.patch
linux-next.patch
mm-compaction-check-migrate_pagess-return-value-instead-of-list_empty.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill.patch
oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-page-alloc-failure.patch
mm-add-replace_page_cache_page-function.patch
mm-add-replace_page_cache_page-function-add-freepage-hook.patch
mm-introduce-delete_from_page_cache.patch
mm-hugetlbfs-change-remove_from_page_cache.patch
mm-shmem-change-remove_from_page_cache.patch
mm-truncate-change-remove_from_page_cache.patch
mm-good-bye-remove_from_page_cache.patch
mm-change-__remove_from_page_cache.patch
mm-batch-free-pcp-list-if-possible.patch
mm-batch-free-pcp-list-if-possible-fix.patch
mm-rename-drop_anon_vma-to-put_anon_vma.patch
mm-move-anon_vma-ref-out-from-under-config_foo.patch
mm-simplify-anon_vma-refcounts.patch
mm-deactivate-invalidated-pages.patch
mm-reclaim-invalidated-page-asap.patch
pagewalk-only-split-huge-pages-when-necessary.patch
smaps-break-out-smaps_pte_entry-from-smaps_pte_range.patch
smaps-pass-pte-size-argument-in-to-smaps_pte_entry.patch
smaps-teach-smaps_pte_range-about-thp-pmds.patch
smaps-have-smaps-show-transparent-huge-pages.patch
mm-vmscan-kswapd-should-not-free-an-excessive-number-of-pages-when-balancing-small-zones.patch
hugetlbfs-correct-handling-of-negative-input-to-proc-sys-vm-nr_hugepages.patch
add-debugging-aid-for-memory-initialisation-problems.patch

