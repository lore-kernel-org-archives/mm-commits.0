From: akpm@linux-foundation.org
Subject: + writeback-fix-queue_io-ordering-update.patch added to -mm tree
Date: Thu, 05 Aug 2010 16:27:36 -0700
Message-ID: <201008052327.o75NRaRG012023@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756769Ab0HEX2I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Aug 2010 19:28:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, axboe@kernel.dk, david@fromorbit.com, hch@infradead.org, mbligh@google.com, mrubin@google.com, peterz@infradead.org


The patch titled
     writeback-fix-queue_io-ordering-update
has been added to the -mm tree.  Its filename is
     writeback-fix-queue_io-ordering-update.patch

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
Subject: writeback-fix-queue_io-ordering-update
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

 fs/fs-writeback.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN fs/fs-writeback.c~writeback-fix-queue_io-ordering-update fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-fix-queue_io-ordering-update
+++ a/fs/fs-writeback.c
@@ -251,10 +251,15 @@ static void move_expired_inodes(struct l
 }
 
 /*
- * Queue all expired dirty inodes for io, eldest first:
- * (newly dirtied) => b_dirty inodes
- *                 => b_more_io inodes
- *                 => remaining inodes in b_io => (dequeue for sync)
+ * Queue all expired dirty inodes for io, eldest first.
+ * Before
+ *         newly dirtied     b_dirty    b_io    b_more_io
+ *         =============>    gf         edc     BA
+ * After
+ *         newly dirtied     b_dirty    b_io    b_more_io
+ *         =============>    g          fBAedc
+ *                                           |
+ *                                           +--> dequeue for IO
  */
 static void queue_io(struct bdi_writeback *wb, unsigned long *older_than_this)
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
writeback-fix-queue_io-ordering-update.patch
writeback-merge-for_kupdate-and-for_kupdate-cases.patch
vfs-add-super-operation-writeback_inodes.patch

