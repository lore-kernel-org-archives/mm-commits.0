From: akpm@linux-foundation.org
Subject: + writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds-update.patch added to -mm tree
Date: Thu, 05 Aug 2010 16:25:02 -0700
Message-ID: <201008052325.o75NP2le011797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758898Ab0HEXZn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Aug 2010 19:25:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, a.p.zijlstra@chello.nl, axboe@kernel.dk, david@fromorbit.com, hch@infradead.org


The patch titled
     writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds-update
has been added to the -mm tree.  Its filename is
     writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds-update.patch

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
Subject: writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds-update
From: Wu Fengguang <fengguang.wu@intel.com>

Split get_dirty_limits() into global_dirty_limits()+bdi_dirty_limit(),
so that the latter can be avoided when under global dirty background
threshold (which is the normal state for most systems).

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/page-writeback.c~writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds-update mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds-update
+++ a/mm/page-writeback.c
@@ -443,7 +443,7 @@ unsigned long bdi_dirty_limit(struct bac
 	if (bdi_dirty > (dirty * bdi->max_ratio) / 100)
 		bdi_dirty = dirty * bdi->max_ratio / 100;
 
-	return task_dirty_limit(current, bdi_dirty);
+	return bdi_dirty;
 }
 
 /*
@@ -477,6 +477,7 @@ static void balance_dirty_pages(struct a
 		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
 					global_page_state(NR_UNSTABLE_NFS);
 		nr_writeback = global_page_state(NR_WRITEBACK);
+
 		global_dirty_limits(&background_thresh, &dirty_thresh);
 
 		/*
@@ -489,6 +490,7 @@ static void balance_dirty_pages(struct a
 			break;
 
 		bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);
+		bdi_thresh = task_dirty_limit(current, bdi_thresh);
 
 		/*
 		 * In order to avoid the stacked BDI deadlock we need
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
writeback-dont-redirty-tail-an-inode-with-dirty-pages.patch
writeback-fix-queue_io-ordering.patch
writeback-merge-for_kupdate-and-for_kupdate-cases.patch
vfs-add-super-operation-writeback_inodes.patch

