From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-do-not-allow-kswapd-to-scan-at-maximum-priority.patch removed
 from -mm tree
Date: Mon, 08 Jul 2013 12:24:41 -0700
Message-ID: <51db11f9.5nwBIhrkZ6Eel+J9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3GHTYm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:24:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zcalusic@bitsync.net, riel@redhat.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, jslaby@suse.cz, hannes@cmpxchg.org, dormando@rydia.net, Valdis.Kletnieks@vt.edu, mgorman@suse.de

Subject: [merged] mm-vmscan-do-not-allow-kswapd-to-scan-at-maximum-priority.patch removed from -mm tree
To: mgorman@suse.de,Valdis.Kletnieks@vt.edu,dormando@rydia.net,hannes@cmpxchg.org,jslaby@suse.cz,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,riel@redhat.com,zcalusic@bitsync.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:24:41 -0700


The patch titled
     Subject: mm: vmscan: do not allow kswapd to scan at maximum priority
has been removed from the -mm tree.  Its filename was
     mm-vmscan-do-not-allow-kswapd-to-scan-at-maximum-priority.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: do not allow kswapd to scan at maximum priority

Page reclaim at priority 0 will scan the entire LRU as priority 0 is
considered to be a near OOM condition.  Kswapd can reach priority 0 quite
easily if it is encountering a large number of pages it cannot reclaim
such as pages under writeback.  When this happens, kswapd reclaims very
aggressively even though there may be no real risk of allocation failure
or OOM.

This patch prevents kswapd reaching priority 0 and trying to reclaim the
world.  Direct reclaimers will still reach priority 0 in the event of an
OOM situation.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Tested-by: Zlatko Calusic <zcalusic@bitsync.net>
Cc: dormando <dormando@rydia.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-do-not-allow-kswapd-to-scan-at-maximum-priority mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-do-not-allow-kswapd-to-scan-at-maximum-priority
+++ a/mm/vmscan.c
@@ -2929,7 +2929,7 @@ static unsigned long balance_pgdat(pg_da
 		 */
 		if (raise_priority || !sc.nr_reclaimed)
 			sc.priority--;
-	} while (sc.priority >= 0 &&
+	} while (sc.priority >= 1 &&
 		 !pgdat_balanced(pgdat, order, *classzone_idx));
 
 out:
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
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
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch
mm-vmscan-do-not-continue-scanning-if-reclaim-was-aborted-for-compaction.patch
mm-vmscan-do-not-scale-writeback-pages-when-deciding-whether-to-set-zone_writeback.patch
mm-memmap_init_zone-performance-improvement.patch

