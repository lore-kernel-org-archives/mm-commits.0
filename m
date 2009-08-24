From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-balance_dirty_pages-reduce-calls-to-global_page_state-to-reduce-cache-references.patch removed from -mm tree
Date: Mon, 24 Aug 2009 13:08:11 -0700
Message-ID: <200908242008.n7OK8CDZ022691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753369AbZHXUJ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 16:09:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@rsk.demon.co.uk, a.p.zijlstra@chello.nl, chris.mason@oracle.com, fengguang.wu@intel.com, jens.axboe@oracle.com, mbligh@mbligh.org, miklos@szeredi.hu, mm-commits@vger.kernel.org


The patch titled
     mm: balance_dirty_pages(): reduce calls to global_page_state to reduce cache references
has been removed from the -mm tree.  Its filename was
     mm-balance_dirty_pages-reduce-calls-to-global_page_state-to-reduce-cache-references.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: balance_dirty_pages(): reduce calls to global_page_state to reduce cache references
From: Richard Kennedy <richard@rsk.demon.co.uk>

Reducing the number of times balance_dirty_pages calls global_page_state
reduces the cache references and so improves write performance on a
variety of workloads.

'perf stats' of simple fio write tests shows the reduction in cache
access.  Where the test is fio 'write,mmap,600Mb,pre_read' on AMD AthlonX2
with 3Gb memory (dirty_threshold approx 600 Mb) running each test 10
times, taking the average & standard deviation

		average (s.d.) in millions (10^6)
2.6.31-rc6	661 (9.88)
+patch		604 (4.19)

Achieving this reduction is by dropping clip_bdi_dirty_limit as it rereads
the counters to apply the dirty_threshold and moving this check up into
balance_dirty_pages where it has already read the counters.

Also by rearrange the for loop to only contain one copy of the limit tests
allows the pdflush test after the loop to use the local copies of the
counters rather than rereading then.

In the common case with no throttling it now calls global_page_state 5
fewer times and bdi_stat 2 fewer.

I have tried to retain the existing behavior as much as possible, but have
added NR_WRITEBACK_TEMP to nr_writeback.  This counter was used in
clip_bdi_dirty_limit but not in balance_dirty_pages, grep suggests this is
only used by FUSE but I haven't done any testing on that.  It does seem
logical to count all the WRITEBACK pages when making the throttling
decisions so this change should be more correct ;)

I have been running this patch for over a week and have had no problems
with it and generally see improved disk write performance on a variety of
tests & workloads, even in the worst cases performance is the same as the
unpatched kernel.  I also tried this on a Intel ATOM 330 twincore system
and saw similar improvements.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Chris Mason <chris.mason@oracle.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Martin Bligh <mbligh@mbligh.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |  116 +++++++++++++++---------------------------
 1 file changed, 43 insertions(+), 73 deletions(-)

diff -puN mm/page-writeback.c~mm-balance_dirty_pages-reduce-calls-to-global_page_state-to-reduce-cache-references mm/page-writeback.c
--- a/mm/page-writeback.c~mm-balance_dirty_pages-reduce-calls-to-global_page_state-to-reduce-cache-references
+++ a/mm/page-writeback.c
@@ -249,32 +249,6 @@ static void bdi_writeout_fraction(struct
 	}
 }
 
-/*
- * Clip the earned share of dirty pages to that which is actually available.
- * This avoids exceeding the total dirty_limit when the floating averages
- * fluctuate too quickly.
- */
-static void clip_bdi_dirty_limit(struct backing_dev_info *bdi,
-		unsigned long dirty, unsigned long *pbdi_dirty)
-{
-	unsigned long avail_dirty;
-
-	avail_dirty = global_page_state(NR_FILE_DIRTY) +
-		 global_page_state(NR_WRITEBACK) +
-		 global_page_state(NR_UNSTABLE_NFS) +
-		 global_page_state(NR_WRITEBACK_TEMP);
-
-	if (avail_dirty < dirty)
-		avail_dirty = dirty - avail_dirty;
-	else
-		avail_dirty = 0;
-
-	avail_dirty += bdi_stat(bdi, BDI_RECLAIMABLE) +
-		bdi_stat(bdi, BDI_WRITEBACK);
-
-	*pbdi_dirty = min(*pbdi_dirty, avail_dirty);
-}
-
 static inline void task_dirties_fraction(struct task_struct *tsk,
 		long *numerator, long *denominator)
 {
@@ -465,7 +439,6 @@ get_dirty_limits(unsigned long *pbackgro
 			bdi_dirty = dirty * bdi->max_ratio / 100;
 
 		*pbdi_dirty = bdi_dirty;
-		clip_bdi_dirty_limit(bdi, dirty, pbdi_dirty);
 		task_dirty_limit(current, pbdi_dirty);
 	}
 }
@@ -499,45 +472,12 @@ static void balance_dirty_pages(struct a
 		};
 
 		get_dirty_limits(&background_thresh, &dirty_thresh,
-				&bdi_thresh, bdi);
+				 &bdi_thresh, bdi);
 
 		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
-					global_page_state(NR_UNSTABLE_NFS);
-		nr_writeback = global_page_state(NR_WRITEBACK);
-
-		bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
-		bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
-
-		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
-			break;
-
-		/*
-		 * Throttle it only when the background writeback cannot
-		 * catch-up. This avoids (excessively) small writeouts
-		 * when the bdi limits are ramping up.
-		 */
-		if (nr_reclaimable + nr_writeback <
-				(background_thresh + dirty_thresh) / 2)
-			break;
-
-		if (!bdi->dirty_exceeded)
-			bdi->dirty_exceeded = 1;
-
-		/* Note: nr_reclaimable denotes nr_dirty + nr_unstable.
-		 * Unstable writes are a feature of certain networked
-		 * filesystems (i.e. NFS) in which data may have been
-		 * written to the server's write cache, but has not yet
-		 * been flushed to permanent storage.
-		 * Only move pages to writeback if this bdi is over its
-		 * threshold otherwise wait until the disk writes catch
-		 * up.
-		 */
-		if (bdi_nr_reclaimable > bdi_thresh) {
-			generic_sync_bdi_inodes(NULL, &wbc);
-			pages_written += write_chunk - wbc.nr_to_write;
-			get_dirty_limits(&background_thresh, &dirty_thresh,
-				       &bdi_thresh, bdi);
-		}
+			global_page_state(NR_UNSTABLE_NFS);
+		nr_writeback = global_page_state(NR_WRITEBACK) +
+			global_page_state(NR_WRITEBACK_TEMP);
 
 		/*
 		 * In order to avoid the stacked BDI deadlock we need
@@ -557,16 +497,48 @@ static void balance_dirty_pages(struct a
 			bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
 		}
 
-		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
-			break;
-		if (pages_written >= write_chunk)
-			break;		/* We've done our duty */
+		/* always throttle if over threshold */
+		if (nr_reclaimable + nr_writeback < dirty_thresh) {
+
+			if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
+				break;
+
+			/*
+			 * Throttle it only when the background writeback cannot
+			 * catch-up. This avoids (excessively) small writeouts
+			 * when the bdi limits are ramping up.
+			 */
+			if (nr_reclaimable + nr_writeback <
+			    (background_thresh + dirty_thresh) / 2)
+				break;
+
+			/* done enough? */
+			if (pages_written >= write_chunk)
+				break;
+		}
+		if (!bdi->dirty_exceeded)
+			bdi->dirty_exceeded = 1;
 
+		/* Note: nr_reclaimable denotes nr_dirty + nr_unstable.
+		 * Unstable writes are a feature of certain networked
+		 * filesystems (i.e. NFS) in which data may have been
+		 * written to the server's write cache, but has not yet
+		 * been flushed to permanent storage.
+		 * Only move pages to writeback if this bdi is over its
+		 * threshold otherwise wait until the disk writes catch
+		 * up.
+		 */
+		if (bdi_nr_reclaimable > bdi_thresh) {
+			writeback_inodes(&wbc);
+			pages_written += write_chunk - wbc.nr_to_write;
+			if (wbc.nr_to_write == 0)
+				continue;
+		}
 		congestion_wait(BLK_RW_ASYNC, HZ/10);
 	}
 
 	if (bdi_nr_reclaimable + bdi_nr_writeback < bdi_thresh &&
-			bdi->dirty_exceeded)
+	    bdi->dirty_exceeded)
 		bdi->dirty_exceeded = 0;
 
 	if (writeback_in_progress(bdi))
@@ -580,10 +552,8 @@ static void balance_dirty_pages(struct a
 	 * In normal mode, we start background writeout at the lower
 	 * background_thresh, to keep the amount of dirty memory low.
 	 */
-	if ((laptop_mode && pages_written) ||
-			(!laptop_mode && (global_page_state(NR_FILE_DIRTY)
-					  + global_page_state(NR_UNSTABLE_NFS)
-					  > background_thresh)))
+	if ((laptop_mode && pages_written) || (!laptop_mode &&
+	     (nr_reclaimable > background_thresh)))
 		bdi_start_writeback(bdi, NULL, 0, WB_SYNC_NONE);
 }
 
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

mm-balance_dirty_pages-reduce-calls-to-global_page_state-to-reduce-cache-references.patch

