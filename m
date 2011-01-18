From: akpm@linux-foundation.org
Subject: [folded] writeback-bdi-write-bandwidth-estimation-fix.patch removed from -mm tree
Date: Tue, 18 Jan 2011 14:05:02 -0800
Message-ID: <201101182205.p0IM5255008144@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644Ab1ARWGS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Jan 2011 17:06:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, a.p.zijlstra@chello.nl, axboe@kernel.dk, chris.mason@oracle.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     writeback-bdi-write-bandwidth-estimation-fix
has been removed from the -mm tree.  Its filename was
     writeback-bdi-write-bandwidth-estimation-fix.patch

This patch was dropped because it was folded into writeback-bdi-write-bandwidth-estimation.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback-bdi-write-bandwidth-estimation-fix
From: Wu Fengguang <fengguang.wu@intel.com>

As suggested by Andrew and Peter:

I do recall hearing of people who set HZ very low, perhaps because their
huge machines were seeing performance prolems when the timer tick went
off.  Probably there's no need to do that any more.

But still, we shouldn't hard-wire the (HZ >= 100) assumption if we don't
absolutely need to, and I don't think it is absolutely needed here.

People who do cpu bring-up on very slow FPGAs also lower HZ as far as
possible.

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

 mm/page-writeback.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/page-writeback.c~writeback-bdi-write-bandwidth-estimation-fix mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-bdi-write-bandwidth-estimation-fix
+++ a/mm/page-writeback.c
@@ -483,6 +483,7 @@ void bdi_update_write_bandwidth(struct b
 				unsigned long *bw_time,
 				s64 *bw_written)
 {
+	const unsigned long unit_time = max(HZ/100, 1);
 	unsigned long written;
 	unsigned long elapsed;
 	unsigned long bw;
@@ -492,7 +493,7 @@ void bdi_update_write_bandwidth(struct b
 		goto snapshot;
 
 	elapsed = jiffies - *bw_time;
-	if (elapsed < HZ/100)
+	if (elapsed < unit_time)
 		return;
 
 	/*
@@ -506,7 +507,7 @@ void bdi_update_write_bandwidth(struct b
 
 	written = percpu_counter_read(&bdi->bdi_stat[BDI_WRITTEN]) - *bw_written;
 	bw = (HZ * PAGE_CACHE_SIZE * written + elapsed/2) / elapsed;
-	w = min(elapsed / (HZ/100), 128UL);
+	w = min(elapsed / unit_time, 128UL);
 	bdi->write_bandwidth = (bdi->write_bandwidth * (1024-w) + bw * w) >> 10;
 	bdi->write_bandwidth_update_time = jiffies;
 snapshot:
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
writeback-check-skipped-pages-on-wb_sync_all.patch
writeback-io-less-balance_dirty_pages.patch
writeback-consolidate-variable-names-in-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages.patch
writeback-prevent-duplicate-balance_dirty_pages_ratelimited-calls.patch
writeback-account-per-bdi-accumulated-written-pages.patch
writeback-bdi-write-bandwidth-estimation.patch
writeback-show-bdi-write-bandwidth-in-debugfs.patch
writeback-quit-throttling-when-bdi-dirty-pages-dropped-low.patch
writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch
writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch

