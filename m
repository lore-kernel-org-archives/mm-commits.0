From: akpm@linux-foundation.org
Subject: + mm-vmscan-stop-reclaim-compaction-earlier-due-to-insufficient-progress-if-__gfp_repeat-v2.patch added to -mm tree
Date: Thu, 17 Feb 2011 15:23:26 -0800
Message-ID: <201102172323.p1HNNQOl022138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752529Ab1BQXYS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Feb 2011 18:24:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, hannes@cmpxchg.org, kent.overstreet@gmail.com, mhocko@suse.cz, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm-vmscan-stop-reclaim-compaction-earlier-due-to-insufficient-progress-if-__gfp_repeat-v2
has been added to the -mm tree.  Its filename is
     mm-vmscan-stop-reclaim-compaction-earlier-due-to-insufficient-progress-if-__gfp_repeat-v2.patch

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

linux-next.patch
mm-grab-rcu-read-lock-in-move_pages.patch
mm-vmscan-stop-reclaim-compaction-earlier-due-to-insufficient-progress-if-__gfp_repeat.patch
mm-vmscan-stop-reclaim-compaction-earlier-due-to-insufficient-progress-if-__gfp_repeat-v2.patch
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
add-debugging-aid-for-memory-initialisation-problems.patch

