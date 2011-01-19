From: akpm@linux-foundation.org
Subject: [to-be-updated] writeback-add-trace-event-for-balance_dirty_pages.patch removed from -mm tree
Date: Tue, 18 Jan 2011 18:33:48 -0800
Message-ID: <201101190233.p0J2XmHE021009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751446Ab1ASCmQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Jan 2011 21:42:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, a.p.zijlstra@chello.nl, axboe@kernel.dk, chris.mason@oracle.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     writeback: add trace event for balance_dirty_pages()
has been removed from the -mm tree.  Its filename was
     writeback-add-trace-event-for-balance_dirty_pages.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback: add trace event for balance_dirty_pages()
From: Wu Fengguang <fengguang.wu@intel.com>

Here is an interesting test to verify the theory with
balance_dirty_pages() tracing.  On a partition that can do ~60MB/s, a
sparse file is created and 4 rsync tasks with different write bandwidth
started:

	dd if=/dev/zero of=/mnt/1T bs=1M count=1 seek=1024000
	echo 1 > /debug/tracing/events/writeback/balance_dirty_pages/enable

	rsync localhost:/mnt/1T /mnt/a --bwlimit 10000&
	rsync localhost:/mnt/1T /mnt/A --bwlimit 10000&
	rsync localhost:/mnt/1T /mnt/b --bwlimit 20000&
	rsync localhost:/mnt/1T /mnt/c --bwlimit 30000&

Trace outputs within 0.1 second, grouped by tasks:

rsync-3824  [004] 15002.076447: balance_dirty_pages: bdi=btrfs-2 weight=15% limit=130876 gap=5340 dirtied=192 pause=20

rsync-3822  [003] 15002.091701: balance_dirty_pages: bdi=btrfs-2 weight=15% limit=130777 gap=5113 dirtied=192 pause=20

rsync-3821  [006] 15002.004667: balance_dirty_pages: bdi=btrfs-2 weight=30% limit=129570 gap=3714 dirtied=64 pause=8
rsync-3821  [006] 15002.012654: balance_dirty_pages: bdi=btrfs-2 weight=30% limit=129589 gap=3733 dirtied=64 pause=8
rsync-3821  [006] 15002.021838: balance_dirty_pages: bdi=btrfs-2 weight=30% limit=129604 gap=3748 dirtied=64 pause=8
rsync-3821  [004] 15002.091193: balance_dirty_pages: bdi=btrfs-2 weight=29% limit=129583 gap=3983 dirtied=64 pause=8
rsync-3821  [004] 15002.102729: balance_dirty_pages: bdi=btrfs-2 weight=29% limit=129594 gap=3802 dirtied=64 pause=8
rsync-3821  [000] 15002.109252: balance_dirty_pages: bdi=btrfs-2 weight=29% limit=129619 gap=3827 dirtied=64 pause=8

rsync-3823  [002] 15002.009029: balance_dirty_pages: bdi=btrfs-2 weight=39% limit=128762 gap=2842 dirtied=64 pause=12
rsync-3823  [002] 15002.021598: balance_dirty_pages: bdi=btrfs-2 weight=39% limit=128813 gap=3021 dirtied=64 pause=12
rsync-3823  [003] 15002.032973: balance_dirty_pages: bdi=btrfs-2 weight=39% limit=128805 gap=2885 dirtied=64 pause=12
rsync-3823  [003] 15002.048800: balance_dirty_pages: bdi=btrfs-2 weight=39% limit=128823 gap=2967 dirtied=64 pause=12
rsync-3823  [003] 15002.060728: balance_dirty_pages: bdi=btrfs-2 weight=39% limit=128821 gap=3221 dirtied=64 pause=12
rsync-3823  [000] 15002.073152: balance_dirty_pages: bdi=btrfs-2 weight=39% limit=128825 gap=3225 dirtied=64 pause=12
rsync-3823  [005] 15002.090111: balance_dirty_pages: bdi=btrfs-2 weight=39% limit=128782 gap=3214 dirtied=64 pause=12
rsync-3823  [004] 15002.102520: balance_dirty_pages: bdi=btrfs-2 weight=39% limit=128764 gap=3036 dirtied=64 pause=12

The data vividly show that

- the heaviest writer is throttled a bit (weight=39%)

- the lighter writers run at full speed (weight=15%,15%,30%)
  rsync is smart enough to compensate for the in-kernel pause time

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

 include/trace/events/writeback.h |   61 +++++++++++++++++++++++++++--
 mm/page-writeback.c              |    6 ++
 2 files changed, 64 insertions(+), 3 deletions(-)

diff -puN include/trace/events/writeback.h~writeback-add-trace-event-for-balance_dirty_pages include/trace/events/writeback.h
--- a/include/trace/events/writeback.h~writeback-add-trace-event-for-balance_dirty_pages
+++ a/include/trace/events/writeback.h
@@ -147,11 +147,66 @@ DEFINE_EVENT(wbc_class, name, \
 DEFINE_WBC_EVENT(wbc_writeback_start);
 DEFINE_WBC_EVENT(wbc_writeback_written);
 DEFINE_WBC_EVENT(wbc_writeback_wait);
-DEFINE_WBC_EVENT(wbc_balance_dirty_start);
-DEFINE_WBC_EVENT(wbc_balance_dirty_written);
-DEFINE_WBC_EVENT(wbc_balance_dirty_wait);
 DEFINE_WBC_EVENT(wbc_writepage);
 
+#define BDP_PERCENT(a, b, c)	((__entry->a - __entry->b) * 100 * c + \
+				  __entry->bdi_limit/2) / (__entry->bdi_limit|1)
+TRACE_EVENT(balance_dirty_pages,
+
+	TP_PROTO(struct backing_dev_info *bdi,
+		 long bdi_dirty,
+		 long bdi_limit,
+		 long task_limit,
+		 long pages_dirtied,
+		 long pause),
+
+	TP_ARGS(bdi, bdi_dirty, bdi_limit, task_limit,
+		pages_dirtied, pause),
+
+	TP_STRUCT__entry(
+		__array(char,	bdi, 32)
+		__field(long,	bdi_dirty)
+		__field(long,	bdi_limit)
+		__field(long,	task_limit)
+		__field(long,	pages_dirtied)
+		__field(long,	pause)
+	),
+
+	TP_fast_assign(
+		strlcpy(__entry->bdi, dev_name(bdi->dev), 32);
+		__entry->bdi_dirty	= bdi_dirty;
+		__entry->bdi_limit	= bdi_limit;
+		__entry->task_limit	= task_limit;
+		__entry->pages_dirtied	= pages_dirtied;
+		__entry->pause		= pause * 1000 / HZ;
+	),
+
+
+	/*
+	 *           [..................soft throttling range.........]
+	 *           ^                |<=========== bdi_gap =========>|
+	 * background_thresh          |<== task_gap ==>|
+	 * -------------------|-------+----------------|--------------|
+	 *   (bdi_limit * 7/8)^       ^bdi_dirty       ^task_limit    ^bdi_limit
+	 *
+	 * Reasonable large gaps help produce smooth pause times.
+	 */
+	TP_printk("bdi=%s bdi_dirty=%lu bdi_limit=%lu task_limit=%lu "
+		  "task_weight=%ld%% task_gap=%ld%% bdi_gap=%ld%% "
+		  "pages_dirtied=%lu pause=%lu",
+		  __entry->bdi,
+		  __entry->bdi_dirty,
+		  __entry->bdi_limit,
+		  __entry->task_limit,
+		  /* task weight: proportion of recent dirtied pages */
+		  BDP_PERCENT(bdi_limit, task_limit, TASK_SOFT_DIRTY_LIMIT),
+		  BDP_PERCENT(task_limit, bdi_dirty, TASK_SOFT_DIRTY_LIMIT),
+		  BDP_PERCENT(bdi_limit, bdi_dirty, BDI_SOFT_DIRTY_LIMIT),
+		  __entry->pages_dirtied,
+		  __entry->pause
+		  )
+);
+
 DECLARE_EVENT_CLASS(writeback_congest_waited_template,
 
 	TP_PROTO(unsigned int usec_timeout, unsigned int usec_delayed),
diff -puN mm/page-writeback.c~writeback-add-trace-event-for-balance_dirty_pages mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-add-trace-event-for-balance_dirty_pages
+++ a/mm/page-writeback.c
@@ -630,6 +630,12 @@ static void balance_dirty_pages(struct a
 		pause = clamp_val(pause, 1, HZ/10);
 
 pause:
+		trace_balance_dirty_pages(bdi,
+					  bdi_dirty,
+					  bdi_thresh,
+					  task_thresh,
+					  pages_dirtied,
+					  pause);
 		bdi_update_write_bandwidth(bdi, &bw_time, &bw_written);
 		__set_current_state(TASK_INTERRUPTIBLE);
 		io_schedule_timeout(pause);
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
writeback-make-nr_to_write-a-per-file-limit.patch

