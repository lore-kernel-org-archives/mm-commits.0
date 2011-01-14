From: akpm@linux-foundation.org
Subject: [merged] writeback-stop-background-kupdate-works-from-livelocking-other-works.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:44:33 -0800
Message-ID: <201101142247.p0EMlNdo004988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752800Ab1ANWrs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:47:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, axboe@kernel.dk, david@fromorbit.com, fengguang.wu@intel.com, hannes@cmpxchg.org, hch@lst.de, jengelh@medozas.de, mm-commits@vger.kernel.org


The patch titled
     writeback: stop background/kupdate works from livelocking other works
has been removed from the -mm tree.  Its filename was
     writeback-stop-background-kupdate-works-from-livelocking-other-works.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback: stop background/kupdate works from livelocking other works
From: Jan Kara <jack@suse.cz>

Background writeback is easily livelockable in a loop in wb_writeback() by
a process continuously re-dirtying pages (or continuously appending to a
file).  This is in fact intended as the target of background writeback is
to write dirty pages it can find as long as we are over
dirty_background_threshold.

But the above behavior gets inconvenient at times because no other work
queued in the flusher thread's queue gets processed.  In particular, since
e.g.  sync(1) relies on flusher thread to do all the IO for it, sync(1)
can hang forever waiting for flusher thread to do the work.

Generally, when a flusher thread has some work queued, someone submitted
the work to achieve a goal more specific than what background writeback
does.  Moreover by working on the specific work, we also reduce amount of
dirty pages which is exactly the target of background writeout.  So it
makes sense to give specific work a priority over a generic page cleaning.

Thus we interrupt background writeback if there is some other work to do. 
We return to the background writeback after completing all the queued
work.

This may delay the writeback of expired inodes for a while, however the
expired inodes will eventually be flushed to disk as long as the other
works won't livelock.

[fengguang.wu@intel.com: update comment]
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de> 
Cc: Jan Engelhardt <jengelh@medozas.de>
Cc: Jens Axboe <axboe@kernel.dk>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN fs/fs-writeback.c~writeback-stop-background-kupdate-works-from-livelocking-other-works fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-stop-background-kupdate-works-from-livelocking-other-works
+++ a/fs/fs-writeback.c
@@ -651,6 +651,16 @@ static long wb_writeback(struct bdi_writ
 			break;
 
 		/*
+		 * Background writeout and kupdate-style writeback may
+		 * run forever. Stop them if there is other work to do
+		 * so that e.g. sync can proceed. They'll be restarted
+		 * after the other works are all done.
+		 */
+		if ((work->for_background || work->for_kupdate) &&
+		    !list_empty(&wb->bdi->work_list))
+			break;
+
+		/*
 		 * For background writeout, stop when we are below the
 		 * background dirty threshold
 		 */
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
linux-next.patch
writeback-check-skipped-pages-on-wb_sync_all.patch
writeback-check-skipped-pages-on-wb_sync_all-update.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-io-less-balance_dirty_pages.patch
writeback-consolidate-variable-names-in-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages-fix.patch
writeback-prevent-duplicate-balance_dirty_pages_ratelimited-calls.patch
writeback-account-per-bdi-accumulated-written-pages.patch
writeback-bdi-write-bandwidth-estimation.patch
writeback-bdi-write-bandwidth-estimation-fix.patch
writeback-show-bdi-write-bandwidth-in-debugfs.patch
writeback-quit-throttling-when-bdi-dirty-pages-dropped-low.patch
writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch
writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch

