From: akpm@linux-foundation.org
Subject: [merged] vmscan-kill-unnecessary-prefetch.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:38:53 -0700
Message-ID: <200909222038.n8MKcrlw002328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752507AbZIVUjp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:39:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, hannes@cmpxchg.org, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: kill unnecessary prefetch
has been removed from the -mm tree.  Its filename was
     vmscan-kill-unnecessary-prefetch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: kill unnecessary prefetch
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
@@ -1273,7 +1273,6 @@ static void move_active_pages_to_lru(str
 
 	while (!list_empty(list)) {
 		page = lru_to_page(list);
-		prefetchw_prev_lru_page(page, list, flags);
 
 		VM_BUG_ON(PageLRU(page));
 		SetPageLRU(page);
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

