From: akpm@linux-foundation.org
Subject: + writeback-add-comment-to-the-dirty-limit-functions-update.patch added to -mm tree
Date: Thu, 05 Aug 2010 16:26:11 -0700
Message-ID: <201008052326.o75NQBOB011965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759077Ab0HEX0W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Aug 2010 19:26:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, a.p.zijlstra@chello.nl, axboe@kernel.dk, david@fromorbit.com, hch@infradead.org


The patch titled
     writeback-add-comment-to-the-dirty-limit-functions-update
has been added to the -mm tree.  Its filename is
     writeback-add-comment-to-the-dirty-limit-functions-update.patch

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
Subject: writeback-add-comment-to-the-dirty-limit-functions-update
From: Wu Fengguang <fengguang.wu@intel.com>

Document global_dirty_limits(), bdi_dirty_limit() and task_dirty_limit().

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff -puN mm/page-writeback.c~writeback-add-comment-to-the-dirty-limit-functions-update mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-add-comment-to-the-dirty-limit-functions-update
+++ a/mm/page-writeback.c
@@ -261,11 +261,18 @@ static inline void task_dirties_fraction
 }
 
 /*
- * scale the dirty limit
+ * task_dirty_limit - scale down dirty throttling threshold for one task
  *
  * task specific dirty limit:
  *
  *   dirty -= (dirty/8) * p_{t}
+ *
+ * To protect light/slow dirtying tasks from heavier/fast ones, we start
+ * throttling individual tasks before reaching the bdi dirty limit.
+ * Relatively low thresholds will be allocated to heavy dirtiers. So when
+ * dirty pages grow large, heavy dirtiers will be throttled first, which will
+ * effectively curb the growth of dirty pages. Light dirtiers with high enough
+ * dirty threshold may never get throttled.
  */
 static unsigned long task_dirty_limit(struct task_struct *tsk,
 				       unsigned long bdi_dirty)
@@ -391,7 +398,7 @@ unsigned long determine_dirtyable_memory
 }
 
 /**
- * global_dirty_limits - background writeback and dirty throttling thresholds
+ * global_dirty_limits - background-writeback and dirty-throttling thresholds
  *
  * Calculate the dirty thresholds based on sysctl parameters
  * - vm.dirty_background_ratio  or  vm.dirty_background_bytes
@@ -434,15 +441,14 @@ void global_dirty_limits(unsigned long *
 }
 
 /**
- * bdi_dirty_limit - current task's share of dirty throttling threshold on @bdi
+ * bdi_dirty_limit - @bdi's share of dirty throttling threshold
+ *
+ * Allocate high/low dirty limits to fast/slow devices, in order to prevent
+ * - starving fast devices
+ * - piling up dirty pages (that will take long time to sync) on slow devices
  *
- * Once the global dirty limit is _exceeded_, all dirtiers will be throttled.
- * To avoid starving fast devices (which can sync dirty pages in short time) or
- * throttling light dirtiers, we start throttling individual tasks on a per-bdi
- * basis when _approaching_ the global dirty limit. Relative high limits will
- * be allocated to fast devices and/or light dirtiers. The bdi's dirty share is
- * evaluated adapting to its throughput and bounded if the bdi->min_ratio
- * and/or bdi->max_ratio parameters are set.
+ * The bdi's share of dirty limit will be adapting to its throughput and
+ * bounded by the bdi->min_ratio and/or bdi->max_ratio parameters, if set.
  */
 unsigned long bdi_dirty_limit(struct backing_dev_info *bdi, unsigned long dirty)
 {
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
fs-inodec-work-around-bug.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
vfs-o_-bit-numbers-uniqueness-check.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
writeback-reduce-calls-to-global_page_state-in-balance_dirty_pages.patch
writeback-reduce-calls-to-global_page_state-in-balance_dirty_pages-update.patch
writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds.patch
writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds-update.patch
writeback-add-comment-to-the-dirty-limit-functions.patch
writeback-add-comment-to-the-dirty-limit-functions-update.patch
writeback-dont-redirty-tail-an-inode-with-dirty-pages.patch
writeback-fix-queue_io-ordering.patch
writeback-merge-for_kupdate-and-for_kupdate-cases.patch
vfs-add-super-operation-writeback_inodes.patch

