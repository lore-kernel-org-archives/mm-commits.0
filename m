From: akpm@linux-foundation.org
Subject: + writeback-merge-for_kupdate-and-for_kupdate-cases.patch added to -mm tree
Date: Mon, 12 Jul 2010 15:24:05 -0700
Message-ID: <201007122224.o6CMO5Ao032684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37159 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755475Ab0GLWZK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jul 2010 18:25:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, axboe@kernel.dk, david@fromorbit.com, hch@infradead.org, mbligh@google.com, mrubin@google.com, peterz@infradead.org


The patch titled
     writeback: merge for_kupdate and !for_kupdate cases
has been added to the -mm tree.  Its filename is
     writeback-merge-for_kupdate-and-for_kupdate-cases.patch

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
Subject: writeback: merge for_kupdate and !for_kupdate cases
From: Wu Fengguang <fengguang.wu@intel.com>

Unify the logic for kupdate and non-kupdate cases.  There won't be
starvation because the inodes requeued into b_more_io will later be
spliced _after_ the remaining inodes in b_io, hence won't stand in the way
of other inodes in the next run.

It avoids unnecessary redirty_tail() calls, hence the update of
i_dirtied_when.  The timestamp update is undesirable because it could
later delay the inode's periodic writeback, or exclude the inode from the
data integrity sync operation (which will check timestamp to avoid extra
work and livelock).

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |   39 ++++++---------------------------------
 1 file changed, 6 insertions(+), 33 deletions(-)

diff -puN fs/fs-writeback.c~writeback-merge-for_kupdate-and-for_kupdate-cases fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-merge-for_kupdate-and-for_kupdate-cases
+++ a/fs/fs-writeback.c
@@ -372,45 +372,18 @@ writeback_single_inode(struct inode *ino
 		if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
 			/*
 			 * We didn't write back all the pages.  nfs_writepages()
-			 * sometimes bales out without doing anything. Redirty
-			 * the inode; Move it from b_io onto b_more_io/b_dirty.
+			 * sometimes bales out without doing anything.
 			 */
-			/*
-			 * akpm: if the caller was the kupdate function we put
-			 * this inode at the head of b_dirty so it gets first
-			 * consideration.  Otherwise, move it to the tail, for
-			 * the reasons described there.  I'm not really sure
-			 * how much sense this makes.  Presumably I had a good
-			 * reasons for doing it this way, and I'd rather not
-			 * muck with it at present.
-			 */
-			if (wbc->for_kupdate) {
+			inode->i_state |= I_DIRTY_PAGES;
+			if (wbc->nr_to_write <= 0) {
 				/*
-				 * For the kupdate function we move the inode
-				 * to b_more_io so it will get more writeout as
-				 * soon as the queue becomes uncongested.
+				 * slice used up: queue for next turn
 				 */
-				inode->i_state |= I_DIRTY_PAGES;
-				if (wbc->nr_to_write <= 0) {
-					/*
-					 * slice used up: queue for next turn
-					 */
-					requeue_io(inode);
-				} else {
-					/*
-					 * somehow blocked: retry later
-					 */
-					redirty_tail(inode);
-				}
+				requeue_io(inode);
 			} else {
 				/*
-				 * Otherwise fully redirty the inode so that
-				 * other inodes on this superblock will get some
-				 * writeout.  Otherwise heavy writing to one
-				 * file would indefinitely suspend writeout of
-				 * all the other files.
+				 * somehow blocked: retry later
 				 */
-				inode->i_state |= I_DIRTY_PAGES;
 				redirty_tail(inode);
 			}
 		} else if (inode->i_state & I_DIRTY) {
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

