From: akpm@linux-foundation.org
Subject: [to-be-updated] writeback-enabling-gate-for-light-dirtied-bdi.patch removed from -mm tree
Date: Tue, 14 Dec 2010 15:41:47 -0800
Message-ID: <201012150014.oBF0EjmI018330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755127Ab0LOAQQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Dec 2010 19:16:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, a.p.zijlstra@chello.nl, david@fromorbit.com, hch@lst.de, jack@suse.cz, mel@csn.ul.ie, mrubin@google.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     writeback: enabling-gate for light dirtied bdi
has been removed from the -mm tree.  Its filename was
     writeback-enabling-gate-for-light-dirtied-bdi.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback: enabling-gate for light dirtied bdi
From: Wu Fengguang <fengguang.wu@intel.com>

I noticed that my NFSROOT test system goes slow responding when there is
heavy dd to a local disk.  Traces show that the NFSROOT's bdi limit is
near 0 and many tasks in the system are repeatedly stuck in
balance_dirty_pages().

There are two generic problems:

- light dirtiers at one device (more often than not the rootfs) get
  heavily impacted by heavy dirtiers on another independent device

- the light dirtied device does heavy throttling because bdi limit=0,
  and the heavy throttling may in turn withhold its bdi limit in 0 as
  it cannot dirty fast enough to grow up the bdi's proportional weight.

Fix it by introducing some "low pass" gate, which is a small (<=32MB)
value reserved by others and can be safely "stole" from the current
global dirty margin.  It does not need to be big to help the bdi gain
its initial weight.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michael Rubin <mrubin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    3 ++-
 mm/backing-dev.c          |    2 +-
 mm/page-writeback.c       |   29 ++++++++++++++++++++++++++---
 3 files changed, 29 insertions(+), 5 deletions(-)

diff -puN include/linux/writeback.h~writeback-enabling-gate-for-light-dirtied-bdi include/linux/writeback.h
--- a/include/linux/writeback.h~writeback-enabling-gate-for-light-dirtied-bdi
+++ a/include/linux/writeback.h
@@ -137,7 +137,8 @@ int dirty_writeback_centisecs_handler(st
 
 void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty);
 unsigned long bdi_dirty_limit(struct backing_dev_info *bdi,
-			       unsigned long dirty);
+			       unsigned long dirty,
+			       unsigned long dirty_pages);
 void bdi_update_write_bandwidth(struct backing_dev_info *bdi,
 				unsigned long *bw_time,
 				s64 *bw_written);
diff -puN mm/backing-dev.c~writeback-enabling-gate-for-light-dirtied-bdi mm/backing-dev.c
--- a/mm/backing-dev.c~writeback-enabling-gate-for-light-dirtied-bdi
+++ a/mm/backing-dev.c
@@ -83,7 +83,7 @@ static int bdi_debug_stats_show(struct s
 	spin_unlock(&inode_lock);
 
 	global_dirty_limits(&background_thresh, &dirty_thresh);
-	bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);
+	bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh, dirty_thresh);
 
 #define K(x) ((x) << (PAGE_SHIFT - 10))
 	seq_printf(m,
diff -puN mm/page-writeback.c~writeback-enabling-gate-for-light-dirtied-bdi mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-enabling-gate-for-light-dirtied-bdi
+++ a/mm/page-writeback.c
@@ -430,13 +430,26 @@ void global_dirty_limits(unsigned long *
  *
  * The bdi's share of dirty limit will be adapting to its throughput and
  * bounded by the bdi->min_ratio and/or bdi->max_ratio parameters, if set.
- */
-unsigned long bdi_dirty_limit(struct backing_dev_info *bdi, unsigned long dirty)
+ *
+ * There is a chicken and egg problem: when bdi A (eg. /pub) is heavy dirtied
+ * and bdi B (eg. /) is light dirtied hence has 0 dirty limit, tasks writing to
+ * B always get heavily throttled and bdi B's dirty limit might never be able
+ * to grow up from 0. So we do tricks to reserve some global margin and honour
+ * it to the bdi's that run low.
+ */
+unsigned long bdi_dirty_limit(struct backing_dev_info *bdi,
+			      unsigned long dirty,
+			      unsigned long dirty_pages)
 {
 	u64 bdi_dirty;
 	long numerator, denominator;
 
 	/*
+	 * Provide a global safety margin of ~1%, or up to 32MB for a 20GB box.
+	 */
+	dirty -= min(dirty / 128, 32768ULL >> (PAGE_SHIFT-10));
+
+	/*
 	 * Calculate this BDI's share of the dirty ratio.
 	 */
 	bdi_writeout_fraction(bdi, &numerator, &denominator);
@@ -446,6 +459,15 @@ unsigned long bdi_dirty_limit(struct bac
 	do_div(bdi_dirty, denominator);
 
 	bdi_dirty += (dirty * bdi->min_ratio) / 100;
+
+	/*
+	 * If we can dirty N more pages globally, honour N/2 to the bdi that
+	 * runs low, so as to help it ramp up.
+	 */
+	if (unlikely(bdi_dirty < (dirty - dirty_pages) / 2 &&
+		     dirty > dirty_pages))
+		bdi_dirty = (dirty - dirty_pages) / 2;
+
 	if (bdi_dirty > (dirty * bdi->max_ratio) / 100)
 		bdi_dirty = dirty * bdi->max_ratio / 100;
 
@@ -567,7 +589,8 @@ static void balance_dirty_pages(struct a
 		if (nr_dirty <= (background_thresh + dirty_thresh) / 2)
 			break;
 
-		bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);
+		bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh,
+					     nr_reclaimable + nr_writeback);
 		task_thresh = task_dirty_limit(current, bdi_thresh);
 
 		/*
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
writeback-do-uninterruptible-sleep-in-balance_dirty_pages.patch
writeback-integrated-background-writeback-work.patch
writeback-trace-wakeup-event-for-background-writeback.patch
writeback-stop-background-kupdate-works-from-livelocking-other-works.patch
writeback-stop-background-kupdate-works-from-livelocking-other-works-update.patch
writeback-avoid-livelocking-wb_sync_all-writeback.patch
writeback-avoid-livelocking-wb_sync_all-writeback-update.patch
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
writeback-enabling-gate-for-light-dirtied-bdi-fix.patch
writeback-safety-margin-for-bdi-stat-error.patch
mm-page-writebackc-fix-__set_page_dirty_no_writeback-return-value.patch
mm-find_get_pages_contig-fixlet.patch
mm-smaps-export-mlock-information.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
memcg-use-zalloc-rather-than-mallocmemset.patch

