From: akpm@linux-foundation.org
Subject: - writeback-fix-time-ordering-of-the-per-superblock-inode-lists-8.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:02:28 -0700
Message-ID: <200710180702.l9I72SrG031272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50569 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760611AbXJRHPe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, akpm@linux-foundation.org, kenchen@google.com, mm-commits@vger.kernel.org


The patch titled
     writeback: fix time ordering of the per superblock inode lists 8
has been removed from the -mm tree.  Its filename was
     writeback-fix-time-ordering-of-the-per-superblock-inode-lists-8.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: writeback: fix time ordering of the per superblock inode lists 8
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Streamline the management of dirty inode lists and fix time ordering bugs.

The writeback logic used to move not-yet-expired dirty inodes from s_dirty to
s_io, *only to* move them back.  The move-inodes-back-and-forth thing is a
mess, which is eliminated by this patch.

The new scheme is:
- s_dirty acts as a time ordered io delaying queue;
- s_io/s_more_io together acts as an io dispatching queue.

On kupdate writeback, we pull some inodes from s_dirty to s_io at the start of
every full scan of s_io.  Otherwise  (i.e. for sync/throttle/background
writeback), we always pull from s_dirty on each run (a partial scan).

Note that the line
	list_splice_init(&sb->s_more_io, &sb->s_io);
is moved to queue_io() to leave s_io empty. Otherwise a big dirtied file will
sit in s_io for a long time, preventing new expired inodes to get in.

Cc: Ken Chen <kenchen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |   61 +++++++++++++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 23 deletions(-)

diff -puN fs/fs-writeback.c~writeback-fix-time-ordering-of-the-per-superblock-inode-lists-8 fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-fix-time-ordering-of-the-per-superblock-inode-lists-8
+++ a/fs/fs-writeback.c
@@ -119,7 +119,7 @@ void __mark_inode_dirty(struct inode *in
 			goto out;
 
 		/*
-		 * If the inode was already on s_dirty or s_io, don't
+		 * If the inode was already on s_dirty/s_io/s_more_io, don't
 		 * reposition it (that would break s_dirty time-ordering).
 		 */
 		if (!was_dirty) {
@@ -173,6 +173,33 @@ static void requeue_io(struct inode *ino
 }
 
 /*
+ * Move expired dirty inodes from @delaying_queue to @dispatch_queue.
+ */
+static void move_expired_inodes(struct list_head *delaying_queue,
+			       struct list_head *dispatch_queue,
+				unsigned long *older_than_this)
+{
+	while (!list_empty(delaying_queue)) {
+		struct inode *inode = list_entry(delaying_queue->prev,
+						struct inode, i_list);
+		if (older_than_this &&
+			time_after(inode->dirtied_when, *older_than_this))
+			break;
+		list_move(&inode->i_list, dispatch_queue);
+	}
+}
+
+/*
+ * Queue all expired dirty inodes for io, eldest first.
+ */
+static void queue_io(struct super_block *sb,
+				unsigned long *older_than_this)
+{
+	list_splice_init(&sb->s_more_io, sb->s_io.prev);
+	move_expired_inodes(&sb->s_dirty, &sb->s_io, older_than_this);
+}
+
+/*
  * Write a single inode's dirty pages and inode data out to disk.
  * If `wait' is set, wait on the writeout.
  *
@@ -222,7 +249,7 @@ __sync_single_inode(struct inode *inode,
 			/*
 			 * We didn't write back all the pages.  nfs_writepages()
 			 * sometimes bales out without doing anything. Redirty
-			 * the inode.  It is moved from s_io onto s_dirty.
+			 * the inode; Move it from s_io onto s_more_io/s_dirty.
 			 */
 			/*
 			 * akpm: if the caller was the kupdate function we put
@@ -235,10 +262,9 @@ __sync_single_inode(struct inode *inode,
 			 */
 			if (wbc->for_kupdate) {
 				/*
-				 * For the kupdate function we leave the inode
-				 * at the head of sb_dirty so it will get more
-				 * writeout as soon as the queue becomes
-				 * uncongested.
+				 * For the kupdate function we move the inode
+				 * to s_more_io so it will get more writeout as
+				 * soon as the queue becomes uncongested.
 				 */
 				inode->i_state |= I_DIRTY_PAGES;
 				requeue_io(inode);
@@ -296,10 +322,10 @@ __writeback_single_inode(struct inode *i
 
 		/*
 		 * We're skipping this inode because it's locked, and we're not
-		 * doing writeback-for-data-integrity.  Move it to the head of
-		 * s_dirty so that writeback can proceed with the other inodes
-		 * on s_io.  We'll have another go at writing back this inode
-		 * when the s_dirty iodes get moved back onto s_io.
+		 * doing writeback-for-data-integrity.  Move it to s_more_io so
+		 * that writeback can proceed with the other inodes on s_io.
+		 * We'll have another go at writing back this inode when we
+		 * completed a full scan of s_io.
 		 */
 		requeue_io(inode);
 
@@ -366,7 +392,7 @@ sync_sb_inodes(struct super_block *sb, s
 	const unsigned long start = jiffies;	/* livelock avoidance */
 
 	if (!wbc->for_kupdate || list_empty(&sb->s_io))
-		list_splice_init(&sb->s_dirty, &sb->s_io);
+		queue_io(sb, wbc->older_than_this);
 
 	while (!list_empty(&sb->s_io)) {
 		struct inode *inode = list_entry(sb->s_io.prev,
@@ -411,13 +437,6 @@ sync_sb_inodes(struct super_block *sb, s
 		if (time_after(inode->dirtied_when, start))
 			break;
 
-		/* Was this inode dirtied too recently? */
-		if (wbc->older_than_this && time_after(inode->dirtied_when,
-						*wbc->older_than_this)) {
-			list_splice_init(&sb->s_io, sb->s_dirty.prev);
-			break;
-		}
-
 		/* Is another pdflush already flushing this queue? */
 		if (current_is_pdflush() && !writeback_acquire(bdi))
 			break;
@@ -446,10 +465,6 @@ sync_sb_inodes(struct super_block *sb, s
 		if (wbc->nr_to_write <= 0)
 			break;
 	}
-
-	if (list_empty(&sb->s_io))
-		list_splice_init(&sb->s_more_io, &sb->s_io);
-
 	return;		/* Leave any unwritten inodes on s_io */
 }
 
@@ -459,7 +474,7 @@ sync_sb_inodes(struct super_block *sb, s
  * Note:
  * We don't need to grab a reference to superblock here. If it has non-empty
  * ->s_dirty it's hadn't been killed yet and kill_super() won't proceed
- * past sync_inodes_sb() until both the ->s_dirty and ->s_io lists are
+ * past sync_inodes_sb() until the ->s_dirty/s_io/s_more_io lists are all
  * empty. Since __sync_single_inode() regains inode_lock before it finally moves
  * inode from superblock lists we are OK.
  *
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
