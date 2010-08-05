From: akpm@linux-foundation.org
Subject: + writeback-merge-for_kupdate-and-for_kupdate-cases-update.patch added to -mm tree
Date: Thu, 05 Aug 2010 16:28:57 -0700
Message-ID: <201008052328.o75NSvvp012064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756769Ab0HEX3b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Aug 2010 19:29:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, axboe@kernel.dk, david@fromorbit.com, hch@infradead.org, mbligh@google.com, mrubin@google.com, peterz@infradead.org


The patch titled
     writeback-merge-for_kupdate-and-for_kupdate-cases-update
has been added to the -mm tree.  Its filename is
     writeback-merge-for_kupdate-and-for_kupdate-cases-update.patch

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
Subject: writeback-merge-for_kupdate-and-for_kupdate-cases-update
From: Wu Fengguang <fengguang.wu@intel.com>

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/fs-writeback.c~writeback-merge-for_kupdate-and-for_kupdate-cases-update fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-merge-for_kupdate-and-for_kupdate-cases-update
+++ a/fs/fs-writeback.c
@@ -387,7 +387,11 @@ writeback_single_inode(struct inode *ino
 				requeue_io(inode);
 			} else {
 				/*
-				 * somehow blocked: retry later
+				 * Writeback blocked by something other than
+				 * congestion. Delay the inode for some time to
+				 * avoid spinning on the CPU (100% iowait)
+				 * retrying writeback of the dirty page/inode
+				 * that cannot be performed immediately.
 				 */
 				redirty_tail(inode);
 			}
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
writeback-fix-queue_io-ordering-update.patch
writeback-merge-for_kupdate-and-for_kupdate-cases.patch
writeback-merge-for_kupdate-and-for_kupdate-cases-update.patch
vfs-add-super-operation-writeback_inodes.patch

