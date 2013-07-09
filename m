From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-do-not-scale-writeback-pages-when-deciding-whether-to-set-zone_writeback.patch removed from -mm tree
Date: Tue, 09 Jul 2013 16:20:29 -0700
Message-ID: <51dc9abd.WSaSSbgCMqscDxqG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38925 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab3GIXUa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:20:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, david@fromorbit.com, mgorman@suse.de

Subject: [merged] mm-vmscan-do-not-scale-writeback-pages-when-deciding-whether-to-set-zone_writeback.patch removed from -mm tree
To: mgorman@suse.de,david@fromorbit.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:20:29 -0700


The patch titled
     Subject: mm: vmscan: do not scale writeback pages when deciding whether to set ZONE_WRITEBACK
has been removed from the -mm tree.  Its filename was
     mm-vmscan-do-not-scale-writeback-pages-when-deciding-whether-to-set-zone_writeback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: do not scale writeback pages when deciding whether to set ZONE_WRITEBACK

After the patch "mm: vmscan: Flatten kswapd priority loop" was merged the
scanning priority of kswapd changed.  The priority now raises until it is
scanning enough pages to meet the high watermark.  shrink_inactive_list
sets ZONE_WRITEBACK if a number of pages were encountered under writeback
but this value is scaled based on the priority.  As kswapd frequently
scans with a higher priority now it is relatively easy to set
ZONE_WRITEBACK.  This patch removes the scaling and treates writeback
pages similar to how it treats unqueued dirty pages and congested pages. 
The user-visible effect should be that kswapd will writeback fewer pages
from reclaim context.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-do-not-scale-writeback-pages-when-deciding-whether-to-set-zone_writeback mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-do-not-scale-writeback-pages-when-deciding-whether-to-set-zone_writeback
+++ a/mm/vmscan.c
@@ -1443,25 +1443,11 @@ shrink_inactive_list(unsigned long nr_to
 	 * as there is no guarantee the dirtying process is throttled in the
 	 * same way balance_dirty_pages() manages.
 	 *
-	 * This scales the number of dirty pages that must be under writeback
-	 * before a zone gets flagged ZONE_WRITEBACK. It is a simple backoff
-	 * function that has the most effect in the range DEF_PRIORITY to
-	 * DEF_PRIORITY-2 which is the priority reclaim is considered to be
-	 * in trouble and reclaim is considered to be in trouble.
-	 *
-	 * DEF_PRIORITY   100% isolated pages must be PageWriteback to throttle
-	 * DEF_PRIORITY-1  50% must be PageWriteback
-	 * DEF_PRIORITY-2  25% must be PageWriteback, kswapd in trouble
-	 * ...
-	 * DEF_PRIORITY-6 For SWAP_CLUSTER_MAX isolated pages, throttle if any
-	 *                     isolated page is PageWriteback
-	 *
 	 * Once a zone is flagged ZONE_WRITEBACK, kswapd will count the number
 	 * of pages under pages flagged for immediate reclaim and stall if any
 	 * are encountered in the nr_immediate check below.
 	 */
-	if (nr_writeback && nr_writeback >=
-			(nr_taken >> (DEF_PRIORITY - sc->priority)))
+	if (nr_writeback && nr_writeback == nr_taken)
 		zone_set_flag(zone, ZONE_WRITEBACK);
 
 	/*
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch
linux-next.patch
mm-mempolicy-fix-mbind_range-vma_adjust-interaction.patch
fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
list_lru-dynamically-adjust-node-arrays.patch
mm-memmap_init_zone-performance-improvement.patch

