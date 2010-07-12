From: akpm@linux-foundation.org
Subject: + writeback-dont-redirty-tail-an-inode-with-dirty-pages.patch added to -mm tree
Date: Mon, 12 Jul 2010 15:23:59 -0700
Message-ID: <201007122223.o6CMNxfi032677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754442Ab0GLWYi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jul 2010 18:24:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, axboe@kernel.dk, david@fromorbit.com, hch@infradead.org, jack@suse.cz


The patch titled
     writeback: don't redirty tail an inode with dirty pages
has been added to the -mm tree.  Its filename is
     writeback-dont-redirty-tail-an-inode-with-dirty-pages.patch

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
Subject: writeback: don't redirty tail an inode with dirty pages
From: Wu Fengguang <fengguang.wu@intel.com>

Avoid delaying writeback for an expire inode with lots of dirty pages, but
no active dirtier at the moment.  Previously we only do that for the
kupdate case.

Any filesystem that does delayed allocation or unwritten extent conversion
after IO completion will cause this - for example, XFS.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff -puN fs/fs-writeback.c~writeback-dont-redirty-tail-an-inode-with-dirty-pages fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-dont-redirty-tail-an-inode-with-dirty-pages
+++ a/fs/fs-writeback.c
@@ -366,18 +366,7 @@ writeback_single_inode(struct inode *ino
 	spin_lock(&inode_lock);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & I_FREEING)) {
-		if ((inode->i_state & I_DIRTY_PAGES) && wbc->for_kupdate) {
-			/*
-			 * More pages get dirtied by a fast dirtier.
-			 */
-			goto select_queue;
-		} else if (inode->i_state & I_DIRTY) {
-			/*
-			 * At least XFS will redirty the inode during the
-			 * writeback (delalloc) and on io completion (isize).
-			 */
-			redirty_tail(inode);
-		} else if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
+		if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
 			/*
 			 * We didn't write back all the pages.  nfs_writepages()
 			 * sometimes bales out without doing anything. Redirty
@@ -399,7 +388,6 @@ writeback_single_inode(struct inode *ino
 				 * soon as the queue becomes uncongested.
 				 */
 				inode->i_state |= I_DIRTY_PAGES;
-select_queue:
 				if (wbc->nr_to_write <= 0) {
 					/*
 					 * slice used up: queue for next turn
@@ -422,6 +410,14 @@ select_queue:
 				inode->i_state |= I_DIRTY_PAGES;
 				redirty_tail(inode);
 			}
+		} else if (inode->i_state & I_DIRTY) {
+			/*
+			 * Filesystems can dirty the inode during writeback
+			 * operations, such as delayed allocation during
+			 * submission or metadata updates after data IO
+			 * completion.
+			 */
+			redirty_tail(inode);
 		} else if (atomic_read(&inode->i_count)) {
 			/*
 			 * The inode is clean, inuse
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

