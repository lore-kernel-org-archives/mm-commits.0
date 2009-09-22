From: akpm@linux-foundation.org
Subject: [merged] vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:38:47 -0700
Message-ID: <200909222038.n8MKclCN002116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751669AbZIVUjg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:39:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, hannes@cmpxchg.org, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: move ClearPageActive from move_active_pages() to shrink_active_list()
has been removed from the -mm tree.  Its filename was
     vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: move ClearPageActive from move_active_pages() to shrink_active_list()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

The move_active_pages_to_lru() function is called under irq disabled and
ClearPageActive() doesn't need irq disabling.

Then, this patch move it into shrink_active_list().

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/vmscan.c~vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list mm/vmscan.c
--- a/mm/vmscan.c~vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list
+++ a/mm/vmscan.c
@@ -1278,10 +1278,6 @@ static void move_active_pages_to_lru(str
 		VM_BUG_ON(PageLRU(page));
 		SetPageLRU(page);
 
-		VM_BUG_ON(!PageActive(page));
-		if (!is_active_lru(lru))
-			ClearPageActive(page);	/* we are de-activating */
-
 		list_move(&page->lru, &zone->lru[lru].list);
 		mem_cgroup_add_lru_list(page, lru);
 		pgmoved++;
@@ -1363,6 +1359,7 @@ static void shrink_active_list(unsigned 
 			}
 		}
 
+		ClearPageActive(page);	/* we are de-activating */
 		list_add(&page->lru, &l_inactive);
 	}
 
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

