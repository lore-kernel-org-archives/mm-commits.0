From: akpm@linux-foundation.org
Subject: + vmscan-kill-unnecessary-prefetch.patch added to -mm tree
Date: Thu, 16 Jul 2009 17:14:59 -0700
Message-ID: <200907170014.n6H0Ex63008075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933681AbZGQAQO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Jul 2009 20:16:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, hannes@cmpxchg.org, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     vmscan: Kill unnecessary prefetch
has been added to the -mm tree.  Its filename is
     vmscan-kill-unnecessary-prefetch.patch

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
Subject: vmscan: Kill unnecessary prefetch
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

The pages in the list passed move_active_pages_to_lru() are already
touched by shrink_active_list().  IOW the prefetch in
move_active_pages_to_lru() don't populate any cache.  it's pointless.

This patch remove it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/vmscan.c~vmscan-kill-unnecessary-prefetch mm/vmscan.c
--- a/mm/vmscan.c~vmscan-kill-unnecessary-prefetch
+++ a/mm/vmscan.c
@@ -1268,7 +1268,6 @@ static void move_active_pages_to_lru(str
 
 	while (!list_empty(list)) {
 		page = lru_to_page(list);
-		prefetchw_prev_lru_page(page, list, flags);
 
 		VM_BUG_ON(PageLRU(page));
 		SetPageLRU(page);
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
mm-vmstat-add-isolate-pages-fix.patch
vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch
mm-remove-__addsub_zone_page_state.patch
mm-count-only-reclaimable-lru-pages-v2.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable-cleanup.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
vmscan-use-add_page_to_lru_list-helper-function.patch
vmscan-move-pgdeactivate-modification-to-shrink_active_list.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

