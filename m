From: akpm@linux-foundation.org
Subject: [folded] writeback-check-skipped-pages-on-wb_sync_all-update.patch removed from -mm tree
Date: Tue, 18 Jan 2011 14:04:09 -0800
Message-ID: <201101182204.p0IM49kx008040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751597Ab1ARWEj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Jan 2011 17:04:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, axboe@kernel.dk, david@fromorbit.com, hannes@cmpxchg.org, hch@lst.de, jack@suse.cz, jengelh@medozas.de, mm-commits@vger.kernel.org


The patch titled
     writeback-check-skipped-pages-on-wb_sync_all-update
has been removed from the -mm tree.  Its filename was
     writeback-check-skipped-pages-on-wb_sync_all-update.patch

This patch was dropped because it was folded into writeback-check-skipped-pages-on-wb_sync_all.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback-check-skipped-pages-on-wb_sync_all-update
From: Wu Fengguang <fengguang.wu@intel.com>

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de> 
Cc: Jan Engelhardt <jengelh@medozas.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/fs-writeback.c~writeback-check-skipped-pages-on-wb_sync_all-update fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-check-skipped-pages-on-wb_sync_all-update
+++ a/fs/fs-writeback.c
@@ -527,6 +527,11 @@ static int writeback_sb_inodes(struct su
 			 * buffers.  Skip this inode for now.
 			 */
 			redirty_tail(inode);
+			/*
+			 * There's no logic to retry skipped pages for sync(),
+			 * filesystems are assumed not to skip dirty pages on
+			 * temporal lock contentions or non fatal errors.
+			 */
 			WARN_ON_ONCE(wbc->sync_mode == WB_SYNC_ALL);
 		}
 		spin_unlock(&inode_lock);
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
writeback-check-skipped-pages-on-wb_sync_all.patch
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

