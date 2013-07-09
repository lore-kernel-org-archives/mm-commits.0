From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-do-not-continue-scanning-if-reclaim-was-aborted-for-compaction.patch removed from -mm tree
Date: Tue, 09 Jul 2013 16:20:27 -0700
Message-ID: <51dc9abb.sw6KmmYnerjxY7f0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38917 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab3GIXU2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:20:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, david@fromorbit.com, mgorman@suse.de

Subject: [merged] mm-vmscan-do-not-continue-scanning-if-reclaim-was-aborted-for-compaction.patch removed from -mm tree
To: mgorman@suse.de,david@fromorbit.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:20:27 -0700


The patch titled
     Subject: mm: vmscan: do not continue scanning if reclaim was aborted for compaction
has been removed from the -mm tree.  Its filename was
     mm-vmscan-do-not-continue-scanning-if-reclaim-was-aborted-for-compaction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: do not continue scanning if reclaim was aborted for compaction

Direct reclaim is not aborting to allow compaction to go ahead properly. 
do_try_to_free_pages is told to abort reclaim which is happily ignores and
instead increases priority instead until it reaches 0 and starts shrinking
file/anon equally.  This patch corrects the situation by aborting reclaim
when requested instead of raising priority.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-do-not-continue-scanning-if-reclaim-was-aborted-for-compaction mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-do-not-continue-scanning-if-reclaim-was-aborted-for-compaction
+++ a/mm/vmscan.c
@@ -2361,8 +2361,10 @@ static unsigned long do_try_to_free_page
 		aborted_reclaim = shrink_zones(zonelist, sc);
 
 		/*
-		 * Don't shrink slabs when reclaiming memory from
-		 * over limit cgroups
+		 * Don't shrink slabs when reclaiming memory from over limit
+		 * cgroups but do shrink slab at least once when aborting
+		 * reclaim for compaction to avoid unevenly scanning file/anon
+		 * LRU pages over slab pages.
 		 */
 		if (global_reclaim(sc)) {
 			unsigned long lru_pages = 0;
@@ -2404,7 +2406,7 @@ static unsigned long do_try_to_free_page
 						WB_REASON_TRY_TO_FREE_PAGES);
 			sc->may_writepage = 1;
 		}
-	} while (--sc->priority >= 0);
+	} while (--sc->priority >= 0 && !aborted_reclaim);
 
 out:
 	delayacct_freepages_end();
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

