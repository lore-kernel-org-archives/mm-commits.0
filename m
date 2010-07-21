From: akpm@linux-foundation.org
Subject: + writeback-add-comment-to-the-dirty-limit-functions.patch added to -mm tree
Date: Wed, 21 Jul 2010 15:29:07 -0700
Message-ID: <201007212229.o6LMT7ui018736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753514Ab0GUW3d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Jul 2010 18:29:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, a.p.zijlstra@chello.nl, axboe@kernel.dk, david@fromorbit.com, hch@infradead.org


The patch titled
     writeback: add comment to the dirty limit functions
has been added to the -mm tree.  Its filename is
     writeback-add-comment-to-the-dirty-limit-functions.patch

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
Subject: writeback: add comment to the dirty limit functions
From: Wu Fengguang <fengguang.wu@intel.com>

Document global_dirty_limits() and bdi_dirty_limit().

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff -puN mm/page-writeback.c~writeback-add-comment-to-the-dirty-limit-functions mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-add-comment-to-the-dirty-limit-functions
+++ a/mm/page-writeback.c
@@ -390,6 +390,15 @@ unsigned long determine_dirtyable_memory
 	return x + 1;	/* Ensure that we never return 0 */
 }
 
+/**
+ * global_dirty_limits - background writeback and dirty throttling thresholds
+ *
+ * Calculate the dirty thresholds based on sysctl parameters
+ * - vm.dirty_background_ratio  or  vm.dirty_background_bytes
+ * - vm.dirty_ratio             or  vm.dirty_bytes
+ * The dirty limits will be lifted by 1/4 for PF_LESS_THROTTLE (ie. nfsd) and
+ * runtime tasks.
+ */
 void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty)
 {
 	unsigned long background;
@@ -424,8 +433,18 @@ void global_dirty_limits(unsigned long *
 	*pdirty = dirty;
 }
 
-unsigned long bdi_dirty_limit(struct backing_dev_info *bdi,
-			       unsigned long dirty)
+/**
+ * bdi_dirty_limit - current task's share of dirty throttling threshold on @bdi
+ *
+ * Once the global dirty limit is _exceeded_, all dirtiers will be throttled.
+ * To avoid starving fast devices (which can sync dirty pages in short time) or
+ * throttling light dirtiers, we start throttling individual tasks on a per-bdi
+ * basis when _approaching_ the global dirty limit. Relative high limits will
+ * be allocated to fast devices and/or light dirtiers. The bdi's dirty share is
+ * evaluated adapting to its throughput and bounded if the bdi->min_ratio
+ * and/or bdi->max_ratio parameters are set.
+ */
+unsigned long bdi_dirty_limit(struct backing_dev_info *bdi, unsigned long dirty)
 {
 	u64 bdi_dirty;
 	long numerator, denominator;
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
fs-inodec-work-around-bug.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
vfs-o_-bit-numbers-uniqueness-check.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
writeback-reduce-calls-to-global_page_state-in-balance_dirty_pages.patch
writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds.patch
writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds-fix.patch
writeback-add-comment-to-the-dirty-limit-functions.patch
writeback-dont-redirty-tail-an-inode-with-dirty-pages.patch
writeback-fix-queue_io-ordering.patch
writeback-merge-for_kupdate-and-for_kupdate-cases.patch
vfs-add-super-operation-writeback_inodes.patch

