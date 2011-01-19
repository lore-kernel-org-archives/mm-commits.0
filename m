From: akpm@linux-foundation.org
Subject: [to-be-updated] writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch removed from -mm tree
Date: Tue, 18 Jan 2011 18:33:39 -0800
Message-ID: <201101190233.p0J2Xd6Y020999@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753239Ab1ASCfV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Jan 2011 21:35:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, a.p.zijlstra@chello.nl, axboe@kernel.dk, chris.mason@oracle.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     writeback: reduce per-bdi dirty threshold ramp up time
has been removed from the -mm tree.  Its filename was
     writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback: reduce per-bdi dirty threshold ramp up time
From: Wu Fengguang <fengguang.wu@intel.com>

Reduce the dampening for the control system, yielding faster convergence.

Currently it converges at a snail's pace for slow devices (in order of
minutes).  For really fast storage, the convergence speed should be fine.

It makes sense to make it reasonably fast for typical desktops.

After patch, it converges in ~10 seconds for 60MB/s writes and 4GB mem. 
So expect ~1s for a fast 600MB/s storage under 4GB mem, or ~4s under 16GB
mem, which seems reasonable.

$ while true; do grep BdiDirtyThresh /debug/bdi/8:0/stats; sleep 1; done
BdiDirtyThresh:            0 kB
BdiDirtyThresh:       118748 kB
BdiDirtyThresh:       214280 kB
BdiDirtyThresh:       303868 kB
BdiDirtyThresh:       376528 kB
BdiDirtyThresh:       411180 kB
BdiDirtyThresh:       448636 kB
BdiDirtyThresh:       472260 kB
BdiDirtyThresh:       490924 kB
BdiDirtyThresh:       499596 kB
BdiDirtyThresh:       507068 kB
...
DirtyThresh:          530392 kB

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michael Rubin <mrubin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page-writeback.c~writeback-reduce-per-bdi-dirty-threshold-ramp-up-time mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-reduce-per-bdi-dirty-threshold-ramp-up-time
+++ a/mm/page-writeback.c
@@ -125,7 +125,7 @@ static int calc_period_shift(void)
 	else
 		dirty_total = (vm_dirty_ratio * determine_dirtyable_memory()) /
 				100;
-	return 2 + ilog2(dirty_total - 1);
+	return ilog2(dirty_total - 1) - 1;
 }
 
 /*
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch

