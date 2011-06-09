From: akpm@linux-foundation.org
Subject: [merged] writeback-try-more-writeback-as-long-as-something-was-written.patch removed from -mm tree
Date: Thu, 09 Jun 2011 12:05:26 -0700
Message-ID: <201106091904.p59J4DLh025379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752963Ab1FITFN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2011 15:05:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, david@fromorbit.com, jack@suse.cz, kitayama@cl.bb4u.ne.jp, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     writeback: try more writeback as long as something was written
has been removed from the -mm tree.  Its filename was
     writeback-try-more-writeback-as-long-as-something-was-written.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback: try more writeback as long as something was written
From: Wu Fengguang <fengguang.wu@intel.com>

writeback_inodes_wb()/__writeback_inodes_sb() are not aggressive in that
they only populate possibly a subset of eligible inodes into b_io at entry
time.  When the queued set of inodes are all synced, they just return,
possibly with all queued inode pages written but still wbc.nr_to_write >
0.

For kupdate and background writeback, there may be more eligible inodes
sitting in b_dirty when the current set of b_io inodes are completed.  So
it is necessary to try another round of writeback as long as we made some
progress in this round.  When there are no more eligible inodes, no more
inodes will be enqueued in queue_io(), hence nothing could/will be synced
and we may safely bail.

For example, imagine 100 inodes

        i0, i1, i2, ..., i90, i91, i99

At queue_io() time, i90-i99 happen to be expired and moved to s_io for IO.
 When finished successfully, if their total size is less than
MAX_WRITEBACK_PAGES, nr_to_write will be > 0.  Then wb_writeback() will
quit the background work (w/o this patch) while it's still over background
threshold.  This will be a fairly normal/frequent case I guess.

Jan raised the concern

       I'm just afraid that in some pathological cases this could
       result in bad writeback pattern - like if there is some process
       which manages to dirty just a few pages while we are doing
       writeout, this looping could result in writing just a few pages in
       each round which is bad for fragmentation etc.

However it requires really strong timing to make that to (continuously)
happen.  In practice it's very hard to produce such a pattern even if
there is such a possibility in theory.  I actually tried to write 1 page
per 1ms with this command

	write-and-fsync -n10000 -S 1000 -c 4096 /fs/test

and do sync(1) at the same time.  The sync completes quickly on ext4, xfs,
btrfs.  The readers could try other write-and-sleep patterns and check if
it can block sync for longer time.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/fs-writeback.c~writeback-try-more-writeback-as-long-as-something-was-written fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-try-more-writeback-as-long-as-something-was-written
+++ a/fs/fs-writeback.c
@@ -730,23 +730,23 @@ static long wb_writeback(struct bdi_writ
 		wrote += write_chunk - wbc.nr_to_write;
 
 		/*
-		 * If we consumed everything, see if we have more
+		 * Did we write something? Try for more
+		 *
+		 * Dirty inodes are moved to b_io for writeback in batches.
+		 * The completion of the current batch does not necessarily
+		 * mean the overall work is done. So we keep looping as long
+		 * as made some progress on cleaning pages or inodes.
 		 */
-		if (wbc.nr_to_write <= 0)
+		if (wbc.nr_to_write < write_chunk)
 			continue;
 		if (wbc.inodes_cleaned)
 			continue;
 		/*
-		 * Didn't write everything and we don't have more IO, bail
+		 * No more inodes for IO, bail
 		 */
 		if (!wbc.more_io)
 			break;
 		/*
-		 * Did we write something? Try for more
-		 */
-		if (wbc.nr_to_write < write_chunk)
-			continue;
-		/*
 		 * Nothing written. Wait for some inode to
 		 * become available for writeback. Otherwise
 		 * we'll just busyloop.
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
bdi_min_ratio-never-shrinks-ultimately-preventing-valid-setting-of-min_ratio.patch

