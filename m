From: akpm@linux-foundation.org
Subject: [merged] vmscan-kill-unnecessary-page-flag-test.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:38:50 -0700
Message-ID: <200909222038.n8MKcoLW002184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752064AbZIVUji (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:39:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, hannes@cmpxchg.org, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: kill unnecessary page flag test
has been removed from the -mm tree.  Its filename was
     vmscan-kill-unnecessary-page-flag-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: kill unnecessary page flag test
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

The page_lru() already evaluate PageActive() and PageSwapBacked().  We
don't need to re-evaluate it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~vmscan-kill-unnecessary-page-flag-test mm/vmscan.c
--- a/mm/vmscan.c~vmscan-kill-unnecessary-page-flag-test
+++ a/mm/vmscan.c
@@ -1208,8 +1208,8 @@ static unsigned long shrink_inactive_lis
 			SetPageLRU(page);
 			lru = page_lru(page);
 			add_page_to_lru_list(zone, page, lru);
-			if (PageActive(page)) {
-				int file = !!page_is_file_cache(page);
+			if (is_active_lru(lru)) {
+				int file = !!is_file_lru(lru);
 				reclaim_stat->recent_rotated[file]++;
 			}
 			if (!pagevec_add(&pvec, page)) {
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

