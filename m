From: akpm@linux-foundation.org
Subject: [to-be-updated] writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch removed from -mm tree
Date: Tue, 18 Jan 2011 18:33:42 -0800
Message-ID: <201101190233.p0J2XgFO021002@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753239Ab1ASCfD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Jan 2011 21:35:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, a.p.zijlstra@chello.nl, axboe@kernel.dk, chris.mason@oracle.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     writeback: make reasonable gap between the dirty/background thresholds
has been removed from the -mm tree.  Its filename was
     writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback: make reasonable gap between the dirty/background thresholds
From: Wu Fengguang <fengguang.wu@intel.com>

The change is virtually a no-op for the majority users that use the
default 10/20 background/dirty ratios.  For others don't know why they are
setting background ratio close enough to dirty ratio.  Someone must set
background ratio equal to dirty ratio, but no one seems to notice or
complain that it's then silently halved under the hood..

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

 mm/page-writeback.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN mm/page-writeback.c~writeback-make-reasonable-gap-between-the-dirty-background-thresholds mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-make-reasonable-gap-between-the-dirty-background-thresholds
+++ a/mm/page-writeback.c
@@ -403,8 +403,15 @@ void global_dirty_limits(unsigned long *
 	else
 		background = (dirty_background_ratio * available_memory) / 100;
 
-	if (background >= dirty)
-		background = dirty / 2;
+	/*
+	 * Ensure at least 1/4 gap between background and dirty thresholds, so
+	 * that when dirty throttling starts at (background + dirty)/2, it's at
+	 * the entrance of bdi soft throttle threshold, so as to avoid being
+	 * hard throttled.
+	 */
+	if (background > dirty - dirty * 2 / BDI_SOFT_DIRTY_LIMIT)
+		background = dirty - dirty * 2 / BDI_SOFT_DIRTY_LIMIT;
+
 	tsk = current;
 	if (tsk->flags & PF_LESS_THROTTLE || rt_task(tsk)) {
 		background += background / 4;
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch

