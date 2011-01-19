From: akpm@linux-foundation.org
Subject: [to-be-updated] writeback-bdi-write-bandwidth-estimation.patch removed from -mm tree
Date: Tue, 18 Jan 2011 18:33:30 -0800
Message-ID: <201101190233.p0J2XUWO020990@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753239Ab1ASCfB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Jan 2011 21:35:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, a.p.zijlstra@chello.nl, axboe@kernel.dk, chris.mason@oracle.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     writeback: bdi write bandwidth estimation
has been removed from the -mm tree.  Its filename was
     writeback-bdi-write-bandwidth-estimation.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback: bdi write bandwidth estimation
From: Wu Fengguang <fengguang.wu@intel.com>

The estimation value will start from 100MB/s and adapt to the real
bandwidth in seconds.  It's pretty accurate for common filesystems.

As the first use case, it replaces the fixed 100MB/s value used for
throttle bandwidth calculation in balance_dirty_pages().

The overheads won't be high because the bdi bandwidth udpate only occurs
in >10ms intervals.

Initially it's only estimated in balance_dirty_pages() because this is the
most reliable place to get reasonable large bandwidth -- the bdi is
normally fully utilized when bdi_thresh is reached.

Then Shaohua recommends to also do it in the flusher thread, to keep the
value updated when there are only periodic/background writeback and no
tasks throttled.

The estimation cannot be done purely in the flusher thread because it's
not sufficient for NFS.  NFS writeback won't block at get_request_wait(),
so tend to complete quickly.  Another problem is, slow devices may take
dozens of seconds to write the initial 64MB chunk (write_bandwidth starts
with 100MB/s, this translates to 64MB nr_to_write).  So it may take more
than 1 minute to adapt to the smallish bandwidth if the bandwidth is only
updated in the flusher thread.

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

 fs/fs-writeback.c           |    5 ++++
 include/linux/backing-dev.h |    2 +
 include/linux/writeback.h   |    3 ++
 mm/backing-dev.c            |    1 
 mm/page-writeback.c         |   42 +++++++++++++++++++++++++++++++++-
 5 files changed, 52 insertions(+), 1 deletion(-)

diff -puN fs/fs-writeback.c~writeback-bdi-write-bandwidth-estimation fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-bdi-write-bandwidth-estimation
+++ a/fs/fs-writeback.c
@@ -635,6 +635,8 @@ static long wb_writeback(struct bdi_writ
 		.range_cyclic		= work->range_cyclic,
 	};
 	unsigned long oldest_jif;
+	unsigned long bw_time;
+	s64 bw_written = 0;
 	long wrote = 0;
 	long write_chunk;
 	struct inode *inode;
@@ -668,6 +670,8 @@ static long wb_writeback(struct bdi_writ
 		write_chunk = LONG_MAX;
 
 	wbc.wb_start = jiffies; /* livelock avoidance */
+	bdi_update_write_bandwidth(wb->bdi, &bw_time, &bw_written);
+
 	for (;;) {
 		/*
 		 * Stop writeback when nr_pages has been consumed
@@ -702,6 +706,7 @@ static long wb_writeback(struct bdi_writ
 		else
 			writeback_inodes_wb(wb, &wbc);
 		trace_wbc_writeback_written(&wbc, wb->bdi);
+		bdi_update_write_bandwidth(wb->bdi, &bw_time, &bw_written);
 
 		work->nr_pages -= write_chunk - wbc.nr_to_write;
 		wrote += write_chunk - wbc.nr_to_write;
diff -puN include/linux/backing-dev.h~writeback-bdi-write-bandwidth-estimation include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~writeback-bdi-write-bandwidth-estimation
+++ a/include/linux/backing-dev.h
@@ -75,6 +75,8 @@ struct backing_dev_info {
 	struct percpu_counter bdi_stat[NR_BDI_STAT_ITEMS];
 
 	struct prop_local_percpu completions;
+	unsigned long write_bandwidth_update_time;
+	int write_bandwidth;
 	int dirty_exceeded;
 
 	unsigned int min_ratio;
diff -puN include/linux/writeback.h~writeback-bdi-write-bandwidth-estimation include/linux/writeback.h
--- a/include/linux/writeback.h~writeback-bdi-write-bandwidth-estimation
+++ a/include/linux/writeback.h
@@ -137,6 +137,9 @@ int dirty_writeback_centisecs_handler(st
 void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty);
 unsigned long bdi_dirty_limit(struct backing_dev_info *bdi,
 			       unsigned long dirty);
+void bdi_update_write_bandwidth(struct backing_dev_info *bdi,
+				unsigned long *bw_time,
+				s64 *bw_written);
 
 void page_writeback_init(void);
 void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
diff -puN mm/backing-dev.c~writeback-bdi-write-bandwidth-estimation mm/backing-dev.c
--- a/mm/backing-dev.c~writeback-bdi-write-bandwidth-estimation
+++ a/mm/backing-dev.c
@@ -660,6 +660,7 @@ int bdi_init(struct backing_dev_info *bd
 			goto err;
 	}
 
+	bdi->write_bandwidth = 100 << 20;
 	bdi->dirty_exceeded = 0;
 	err = prop_local_init_percpu(&bdi->completions);
 
diff -puN mm/page-writeback.c~writeback-bdi-write-bandwidth-estimation mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-bdi-write-bandwidth-estimation
+++ a/mm/page-writeback.c
@@ -482,6 +482,42 @@ out:
 	return 1 + int_sqrt(dirty_thresh - dirty_pages);
 }
 
+void bdi_update_write_bandwidth(struct backing_dev_info *bdi,
+				unsigned long *bw_time,
+				s64 *bw_written)
+{
+	const unsigned long unit_time = max(HZ/100, 1);
+	unsigned long written;
+	unsigned long elapsed;
+	unsigned long bw;
+	unsigned long w;
+
+	if (*bw_written == 0)
+		goto snapshot;
+
+	elapsed = jiffies - *bw_time;
+	if (elapsed < unit_time)
+		return;
+
+	/*
+	 * When there lots of tasks throttled in balance_dirty_pages(), they
+	 * will each try to update the bandwidth for the same period, making
+	 * the bandwidth drift much faster than the desired rate (as in the
+	 * single dirtier case). So do some rate limiting.
+	 */
+	if (jiffies - bdi->write_bandwidth_update_time < elapsed)
+		goto snapshot;
+
+	written = percpu_counter_read(&bdi->bdi_stat[BDI_WRITTEN]) - *bw_written;
+	bw = (HZ * PAGE_CACHE_SIZE * written + elapsed/2) / elapsed;
+	w = min(elapsed / unit_time, 128UL);
+	bdi->write_bandwidth = (bdi->write_bandwidth * (1024-w) + bw * w) >> 10;
+	bdi->write_bandwidth_update_time = jiffies;
+snapshot:
+	*bw_written = percpu_counter_read(&bdi->bdi_stat[BDI_WRITTEN]);
+	*bw_time = jiffies;
+}
+
 /*
  * balance_dirty_pages() must be called by processes which are generating dirty
  * data.  It looks at the number of dirty pages in the machine and will force
@@ -501,6 +537,8 @@ static void balance_dirty_pages(struct a
 	unsigned long pause = 0;
 	bool dirty_exceeded = false;
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
+	unsigned long bw_time;
+	s64 bw_written = 0;
 
 	for (;;) {
 		/*
@@ -549,7 +587,7 @@ static void balance_dirty_pages(struct a
 			goto pause;
 		}
 
-		bw = 100 << 20; /* use static 100MB/s for the moment */
+		bw = bdi->write_bandwidth;
 
 		bw = bw * (bdi_thresh - bdi_dirty);
 		bw = bw / (bdi_thresh / TASK_SOFT_DIRTY_LIMIT + 1);
@@ -558,8 +596,10 @@ static void balance_dirty_pages(struct a
 		pause = clamp_val(pause, 1, HZ/10);
 
 pause:
+		bdi_update_write_bandwidth(bdi, &bw_time, &bw_written);
 		__set_current_state(TASK_INTERRUPTIBLE);
 		io_schedule_timeout(pause);
+		bdi_update_write_bandwidth(bdi, &bw_time, &bw_written);
 
 		/*
 		 * The bdi thresh is somehow "soft" limit derived from the
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
writeback-show-bdi-write-bandwidth-in-debugfs.patch
writeback-quit-throttling-when-bdi-dirty-pages-dropped-low.patch
writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch
writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch

