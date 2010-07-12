From: akpm@linux-foundation.org
Subject: + writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds.patch added to -mm tree
Date: Mon, 12 Jul 2010 15:23:57 -0700
Message-ID: <201007122223.o6CMNvd4032674@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754442Ab0GLWYh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jul 2010 18:24:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, a.p.zijlstra@chello.nl, axboe@kernel.dk, david@fromorbit.com, hch@infradead.org


The patch titled
     writeback: avoid unnecessary calculation of bdi dirty thresholds
has been added to the -mm tree.  Its filename is
     writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback: avoid unnecessary calculation of bdi dirty thresholds
From: Wu Fengguang <fengguang.wu@intel.com>

Split get_dirty_limits() into global_dirty_limits()+bdi_dirty_limit(), so
that the latter can be avoided when under global dirty background
threshold (which is the normal state for most systems).

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c         |    2 
 include/linux/writeback.h |    5 +-
 mm/backing-dev.c          |    3 -
 mm/page-writeback.c       |   74 ++++++++++++++++++------------------
 4 files changed, 43 insertions(+), 41 deletions(-)

diff -puN fs/fs-writeback.c~writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds
+++ a/fs/fs-writeback.c
@@ -593,7 +593,7 @@ static inline bool over_bground_thresh(v
 {
 	unsigned long background_thresh, dirty_thresh;
 
-	get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
+	global_dirty_limits(&background_thresh, &dirty_thresh);
 
 	return (global_page_state(NR_FILE_DIRTY) +
 		global_page_state(NR_UNSTABLE_NFS) >= background_thresh);
diff -puN include/linux/writeback.h~writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds include/linux/writeback.h
--- a/include/linux/writeback.h~writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds
+++ a/include/linux/writeback.h
@@ -124,8 +124,9 @@ struct ctl_table;
 int dirty_writeback_centisecs_handler(struct ctl_table *, int,
 				      void __user *, size_t *, loff_t *);
 
-void get_dirty_limits(unsigned long *pbackground, unsigned long *pdirty,
-		      unsigned long *pbdi_dirty, struct backing_dev_info *bdi);
+void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty);
+unsigned long bdi_dirty_limit(struct backing_dev_info *bdi,
+			       unsigned long dirty);
 
 void page_writeback_init(void);
 void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
diff -puN mm/backing-dev.c~writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds mm/backing-dev.c
--- a/mm/backing-dev.c~writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds
+++ a/mm/backing-dev.c
@@ -83,7 +83,8 @@ static int bdi_debug_stats_show(struct s
 		nr_more_io++;
 	spin_unlock(&inode_lock);
 
-	get_dirty_limits(&background_thresh, &dirty_thresh, &bdi_thresh, bdi);
+	global_dirty_limits(&background_thresh, &dirty_thresh);
+	bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);
 
 #define K(x) ((x) << (PAGE_SHIFT - 10))
 	seq_printf(m,
diff -puN mm/page-writeback.c~writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds
+++ a/mm/page-writeback.c
@@ -267,10 +267,11 @@ static inline void task_dirties_fraction
  *
  *   dirty -= (dirty/8) * p_{t}
  */
-static void task_dirty_limit(struct task_struct *tsk, unsigned long *pdirty)
+static unsigned long task_dirty_limit(struct task_struct *tsk,
+				       unsigned long bdi_dirty)
 {
 	long numerator, denominator;
-	unsigned long dirty = *pdirty;
+	unsigned long dirty = bdi_dirty;
 	u64 inv = dirty >> 3;
 
 	task_dirties_fraction(tsk, &numerator, &denominator);
@@ -278,10 +279,8 @@ static void task_dirty_limit(struct task
 	do_div(inv, denominator);
 
 	dirty -= inv;
-	if (dirty < *pdirty/2)
-		dirty = *pdirty/2;
 
-	*pdirty = dirty;
+	return max(dirty, bdi_dirty/2);
 }
 
 /*
@@ -391,9 +390,7 @@ unsigned long determine_dirtyable_memory
 	return x + 1;	/* Ensure that we never return 0 */
 }
 
-void
-get_dirty_limits(unsigned long *pbackground, unsigned long *pdirty,
-		 unsigned long *pbdi_dirty, struct backing_dev_info *bdi)
+void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty)
 {
 	unsigned long background;
 	unsigned long dirty;
@@ -425,26 +422,28 @@ get_dirty_limits(unsigned long *pbackgro
 	}
 	*pbackground = background;
 	*pdirty = dirty;
+}
 
-	if (bdi) {
-		u64 bdi_dirty;
-		long numerator, denominator;
+unsigned long bdi_dirty_limit(struct backing_dev_info *bdi,
+			       unsigned long dirty)
+{
+	u64 bdi_dirty;
+	long numerator, denominator;
 
-		/*
-		 * Calculate this BDI's share of the dirty ratio.
-		 */
-		bdi_writeout_fraction(bdi, &numerator, &denominator);
+	/*
+	 * Calculate this BDI's share of the dirty ratio.
+	 */
+	bdi_writeout_fraction(bdi, &numerator, &denominator);
 
-		bdi_dirty = (dirty * (100 - bdi_min_ratio)) / 100;
-		bdi_dirty *= numerator;
-		do_div(bdi_dirty, denominator);
-		bdi_dirty += (dirty * bdi->min_ratio) / 100;
-		if (bdi_dirty > (dirty * bdi->max_ratio) / 100)
-			bdi_dirty = dirty * bdi->max_ratio / 100;
+	bdi_dirty = (dirty * (100 - bdi_min_ratio)) / 100;
+	bdi_dirty *= numerator;
+	do_div(bdi_dirty, denominator);
 
-		*pbdi_dirty = bdi_dirty;
-		task_dirty_limit(current, pbdi_dirty);
-	}
+	bdi_dirty += (dirty * bdi->min_ratio) / 100;
+	if (bdi_dirty > (dirty * bdi->max_ratio) / 100)
+		bdi_dirty = dirty * bdi->max_ratio / 100;
+
+	return task_dirty_limit(current, bdi_dirty);
 }
 
 /*
@@ -475,14 +474,24 @@ static void balance_dirty_pages(struct a
 			.range_cyclic	= 1,
 		};
 
-		get_dirty_limits(&background_thresh, &dirty_thresh,
-				 &bdi_thresh, bdi);
-
 		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
 				 global_page_state(NR_UNSTABLE_NFS);
 		nr_writeback = global_page_state(NR_WRITEBACK) +
 			       global_page_state(NR_WRITEBACK_TEMP);
 
+		global_dirty_limits(&background_thresh, &dirty_thresh);
+
+		/*
+		 * Throttle it only when the background writeback cannot
+		 * catch-up. This avoids (excessively) small writeouts
+		 * when the bdi limits are ramping up.
+		 */
+		if (nr_reclaimable + nr_writeback <
+				(background_thresh + dirty_thresh) / 2)
+			break;
+
+		bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);
+
 		/*
 		 * In order to avoid the stacked BDI deadlock we need
 		 * to ensure we accurately count the 'dirty' pages when
@@ -514,15 +523,6 @@ static void balance_dirty_pages(struct a
 		if (!dirty_exceeded)
 			break;
 
-		/*
-		 * Throttle it only when the background writeback cannot
-		 * catch-up. This avoids (excessively) small writeouts
-		 * when the bdi limits are ramping up.
-		 */
-		if (nr_reclaimable + nr_writeback <
-				(background_thresh + dirty_thresh) / 2)
-			break;
-
 		if (!bdi->dirty_exceeded)
 			bdi->dirty_exceeded = 1;
 
@@ -635,7 +635,7 @@ void throttle_vm_writeout(gfp_t gfp_mask
 	unsigned long dirty_thresh;
 
         for ( ; ; ) {
-		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
+		global_dirty_limits(&background_thresh, &dirty_thresh);
 
                 /*
                  * Boost the allowable dirty threshold a bit for page
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
vfs-o_-bit-numbers-uniqueness-check.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
writeback-take-account-of-nr_writeback_temp-in-balance_dirty_pages.patch
writeback-reduce-calls-to-global_page_state-in-balance_dirty_pages.patch
writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds.patch
writeback-dont-redirty-tail-an-inode-with-dirty-pages.patch
writeback-fix-queue_io-ordering.patch
writeback-merge-for_kupdate-and-for_kupdate-cases.patch
vfs-add-super-operation-writeback_inodes.patch

