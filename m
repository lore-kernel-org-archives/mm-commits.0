From: akpm@linux-foundation.org
Subject: [merged] vmscan-zone_reclaim-dont-use-insane-swap_cluster_max.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:53:03 -0800
Message-ID: <200912152153.nBFLr34q015238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761352AbZLOWQS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:16:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: zone_reclaim() don't use insane swap_cluster_max
has been removed from the -mm tree.  Its filename was
     vmscan-zone_reclaim-dont-use-insane-swap_cluster_max.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: zone_reclaim() don't use insane swap_cluster_max
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

In old days, we didn't have sc.nr_to_reclaim and it brought
sc.swap_cluster_max misuse.

huge sc.swap_cluster_max might makes unnecessary OOM risk and no
performance benefit.

Now, we can stop its insane thing.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/vmscan.c~vmscan-zone_reclaim-dont-use-insane-swap_cluster_max mm/vmscan.c
--- a/mm/vmscan.c~vmscan-zone_reclaim-dont-use-insane-swap_cluster_max
+++ a/mm/vmscan.c
@@ -2539,8 +2539,7 @@ static int __zone_reclaim(struct zone *z
 		.may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
 		.may_unmap = !!(zone_reclaim_mode & RECLAIM_SWAP),
 		.may_swap = 1,
-		.swap_cluster_max = max_t(unsigned long, nr_pages,
-				       SWAP_CLUSTER_MAX),
+		.swap_cluster_max = SWAP_CLUSTER_MAX,
 		.nr_to_reclaim = max_t(unsigned long, nr_pages,
 				       SWAP_CLUSTER_MAX),
 		.gfp_mask = gfp_mask,
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
mm-introduce-coredump-parameter-structure.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

