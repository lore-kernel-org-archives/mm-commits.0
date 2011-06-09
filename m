From: akpm@linux-foundation.org
Subject: [merged] writeback-pass-writeback_control-down-to-move_expired_inodes.patch removed from -mm tree
Date: Thu, 09 Jun 2011 12:05:20 -0700
Message-ID: <201106091904.p59J4778025369@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752572Ab1FITFF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2011 15:05:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, david@fromorbit.com, jack@suse.cz, kitayama@cl.bb4u.ne.jp, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     writeback: pass writeback_control down to move_expired_inodes()
has been removed from the -mm tree.  Its filename was
     writeback-pass-writeback_control-down-to-move_expired_inodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback: pass writeback_control down to move_expired_inodes()
From: Wu Fengguang <fengguang.wu@intel.com>

This patchset aims to reduce possible pageout() calls by making the
flusher concentrate a bit more on old/expired dirty inodes.

Rationales and benchmark numbers are provided in patches 5 and 6.


This patch:

Pass writeback_control down to move_expired_inodes().

No behavior change.  This will add debug visibility to the code, for
example, to dump the wbc contents when kprobing queue_io().

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Jan Kara <jack@suse.cz>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/fs-writeback.c~writeback-pass-writeback_control-down-to-move_expired_inodes fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-pass-writeback_control-down-to-move_expired_inodes
+++ a/fs/fs-writeback.c
@@ -251,8 +251,8 @@ static bool inode_dirtied_after(struct i
  * Move expired dirty inodes from @delaying_queue to @dispatch_queue.
  */
 static void move_expired_inodes(struct list_head *delaying_queue,
-			       struct list_head *dispatch_queue,
-				unsigned long *older_than_this)
+				struct list_head *dispatch_queue,
+				struct writeback_control *wbc)
 {
 	LIST_HEAD(tmp);
 	struct list_head *pos, *node;
@@ -262,8 +262,8 @@ static void move_expired_inodes(struct l
 
 	while (!list_empty(delaying_queue)) {
 		inode = wb_inode(delaying_queue->prev);
-		if (older_than_this &&
-		    inode_dirtied_after(inode, *older_than_this))
+		if (wbc->older_than_this &&
+		    inode_dirtied_after(inode, *wbc->older_than_this))
 			break;
 		if (sb && sb != inode->i_sb)
 			do_sb_sort = 1;
@@ -299,11 +299,11 @@ static void move_expired_inodes(struct l
  *                                           |
  *                                           +--> dequeue for IO
  */
-static void queue_io(struct bdi_writeback *wb, unsigned long *older_than_this)
+static void queue_io(struct bdi_writeback *wb, struct writeback_control *wbc)
 {
 	assert_spin_locked(&inode_wb_list_lock);
 	list_splice_init(&wb->b_more_io, &wb->b_io);
-	move_expired_inodes(&wb->b_dirty, &wb->b_io, older_than_this);
+	move_expired_inodes(&wb->b_dirty, &wb->b_io, wbc);
 }
 
 static int write_inode(struct inode *inode, struct writeback_control *wbc)
@@ -579,7 +579,7 @@ void writeback_inodes_wb(struct bdi_writ
 		wbc->wb_start = jiffies; /* livelock avoidance */
 	spin_lock(&inode_wb_list_lock);
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
-		queue_io(wb, wbc->older_than_this);
+		queue_io(wb, wbc);
 
 	while (!list_empty(&wb->b_io)) {
 		struct inode *inode = wb_inode(wb->b_io.prev);
@@ -606,7 +606,7 @@ static void __writeback_inodes_sb(struct
 
 	spin_lock(&inode_wb_list_lock);
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
-		queue_io(wb, wbc->older_than_this);
+		queue_io(wb, wbc);
 	writeback_sb_inodes(sb, wb, wbc, true);
 	spin_unlock(&inode_wb_list_lock);
 }
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
bdi_min_ratio-never-shrinks-ultimately-preventing-valid-setting-of-min_ratio.patch

