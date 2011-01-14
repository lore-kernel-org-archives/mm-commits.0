From: akpm@linux-foundation.org
Subject: [merged] writeback-trace-wakeup-event-for-background-writeback.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:44:29 -0800
Message-ID: <201101142247.p0EMlJVE004982@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752845Ab1ANWsA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:48:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, axboe@kernel.dk, david@fromorbit.com, hannes@cmpxchg.org, hch@infradead.org, jack@suse.cz, jengelh@medozas.de, mm-commits@vger.kernel.org


The patch titled
     writeback: trace wakeup event for background writeback
has been removed from the -mm tree.  Its filename was
     writeback-trace-wakeup-event-for-background-writeback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback: trace wakeup event for background writeback
From: Wu Fengguang <fengguang.wu@intel.com>

This tracks when balance_dirty_pages() tries to wakeup the flusher thread
for background writeback (if it was not started already).

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Engelhardt <jengelh@medozas.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c                |    1 +
 include/trace/events/writeback.h |    1 +
 2 files changed, 2 insertions(+)

diff -puN fs/fs-writeback.c~writeback-trace-wakeup-event-for-background-writeback fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-trace-wakeup-event-for-background-writeback
+++ a/fs/fs-writeback.c
@@ -169,6 +169,7 @@ void bdi_start_background_writeback(stru
 	 * We just wake up the flusher thread. It will perform background
 	 * writeback as soon as there is no other work to do.
 	 */
+	trace_writeback_wake_background(bdi);
 	spin_lock_bh(&bdi->wb_lock);
 	bdi_wakeup_flusher(bdi);
 	spin_unlock_bh(&bdi->wb_lock);
diff -puN include/trace/events/writeback.h~writeback-trace-wakeup-event-for-background-writeback include/trace/events/writeback.h
--- a/include/trace/events/writeback.h~writeback-trace-wakeup-event-for-background-writeback
+++ a/include/trace/events/writeback.h
@@ -81,6 +81,7 @@ DEFINE_EVENT(writeback_class, name, \
 	TP_ARGS(bdi))
 
 DEFINE_WRITEBACK_EVENT(writeback_nowork);
+DEFINE_WRITEBACK_EVENT(writeback_wake_background);
 DEFINE_WRITEBACK_EVENT(writeback_wake_thread);
 DEFINE_WRITEBACK_EVENT(writeback_wake_forker_thread);
 DEFINE_WRITEBACK_EVENT(writeback_bdi_register);
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

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

