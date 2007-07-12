From: akpm@linux-foundation.org
Subject: + writeback-fix-periodic-superblock-dirty-inode-flushing.patch added to -mm tree
Date: Thu, 12 Jul 2007 12:00:34 -0700
Message-ID: <200707121900.l6CJ0YoV027633@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58321 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753597AbXGLTAp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jul 2007 15:00:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kenchen@google.com


The patch titled
     writeback: fix periodic superblock dirty inode flushing
has been added to the -mm tree.  Its filename is
     writeback-fix-periodic-superblock-dirty-inode-flushing.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: writeback: fix periodic superblock dirty inode flushing
From: "Ken Chen" <kenchen@google.com>

Current -mm tree has bucketful of bug fixes in periodic writeback path. 
However, we still hit a glitch where dirty pages on a given inode aren't
completely flushed to the disk, and system will accumulate large amount of
dirty pages beyond what dirty_expire_interval is designed for.

The problem is __sync_single_inode() will move an inode to sb->s_dirty list
even when there are more pending dirty pages on that inode.  If there is
another inode with a small number of dirty pages, we hit a case where the loop
iteration in wb_kupdate() terminates prematurely because wbc.nr_to_write > 0. 
Thus leaving the inode that has large amount of dirty pages behind and it has
to wait for another dirty_writeback_interval before we flush it again.  We
effectively only write out MAX_WRITEBACK_PAGES every dirty_writeback_interval.
If the rate of dirtying is sufficiently high, the system will start
accumulate a large number of dirty pages.

So fix it by having another sb->s_more_io list on which to park the inode
while we iterate through sb->s_io and to allow each dirty inode which resides
on that sb to have an equal chance of flushing some amount of dirty pages.

Signed-off-by: Ken Chen <kenchen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c  |   36 ++++++++++++++----------------------
 fs/super.c         |    1 +
 include/linux/fs.h |    1 +
 3 files changed, 16 insertions(+), 22 deletions(-)

diff -puN fs/fs-writeback.c~writeback-fix-periodic-superblock-dirty-inode-flushing fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-fix-periodic-superblock-dirty-inode-flushing
+++ a/fs/fs-writeback.c
@@ -164,25 +164,11 @@ static void redirty_tail(struct inode *i
 }
 
 /*
- * Redirty an inode, but mark it as the very next-to-be-written inode on its
- * superblock's dirty-inode list.
- * We need to preserve s_dirty's reverse-time-orderedness, so we cheat by
- * setting this inode's dirtied_when to the same value as that of the inode
- * which is presently head-of-list, if present head-of-list is newer than this
- * inode. (head-of-list is the least-recently-dirtied inode: the oldest one).
+ * requeue inode for re-scanning after sb->s_io list is exhausted.
  */
-static void redirty_head(struct inode *inode)
+static void requeue_io(struct inode *inode)
 {
-	struct super_block *sb = inode->i_sb;
-
-	if (!list_empty(&sb->s_dirty)) {
-		struct inode *head_inode;
-
-		head_inode = list_entry(sb->s_dirty.prev, struct inode, i_list);
-		if (time_after(inode->dirtied_when, head_inode->dirtied_when))
-			inode->dirtied_when = head_inode->dirtied_when;
-	}
-	list_move_tail(&inode->i_list, &sb->s_dirty);
+	list_move(&inode->i_list, &inode->i_sb->s_more_io);
 }
 
 /*
@@ -254,7 +240,7 @@ __sync_single_inode(struct inode *inode,
 				 * uncongested.
 				 */
 				inode->i_state |= I_DIRTY_PAGES;
-				redirty_head(inode);
+				requeue_io(inode);
 			} else {
 				/*
 				 * Otherwise fully redirty the inode so that
@@ -314,7 +300,7 @@ __writeback_single_inode(struct inode *i
 		 * on s_io.  We'll have another go at writing back this inode
 		 * when the s_dirty iodes get moved back onto s_io.
 		 */
-		redirty_head(inode);
+		requeue_io(inode);
 
 		/*
 		 * Even if we don't actually write the inode itself here,
@@ -409,14 +395,14 @@ sync_sb_inodes(struct super_block *sb, s
 			wbc->encountered_congestion = 1;
 			if (!sb_is_blkdev_sb(sb))
 				break;		/* Skip a congested fs */
-			redirty_head(inode);
+			requeue_io(inode);
 			continue;		/* Skip a congested blockdev */
 		}
 
 		if (wbc->bdi && bdi != wbc->bdi) {
 			if (!sb_is_blkdev_sb(sb))
 				break;		/* fs has the wrong queue */
-			redirty_head(inode);
+			requeue_io(inode);
 			continue;		/* blockdev has wrong queue */
 		}
 
@@ -426,8 +412,10 @@ sync_sb_inodes(struct super_block *sb, s
 
 		/* Was this inode dirtied too recently? */
 		if (wbc->older_than_this && time_after(inode->dirtied_when,
-						*wbc->older_than_this))
+						*wbc->older_than_this)) {
+			list_splice_init(&sb->s_io, sb->s_dirty.prev);
 			break;
+		}
 
 		/* Is another pdflush already flushing this queue? */
 		if (current_is_pdflush() && !writeback_acquire(bdi))
@@ -457,6 +445,10 @@ sync_sb_inodes(struct super_block *sb, s
 		if (wbc->nr_to_write <= 0)
 			break;
 	}
+
+	if (list_empty(&sb->s_io))
+		list_splice_init(&sb->s_more_io, &sb->s_io);
+
 	return;		/* Leave any unwritten inodes on s_io */
 }
 
diff -puN fs/super.c~writeback-fix-periodic-superblock-dirty-inode-flushing fs/super.c
--- a/fs/super.c~writeback-fix-periodic-superblock-dirty-inode-flushing
+++ a/fs/super.c
@@ -67,6 +67,7 @@ static struct super_block *alloc_super(s
 		}
 		INIT_LIST_HEAD(&s->s_dirty);
 		INIT_LIST_HEAD(&s->s_io);
+		INIT_LIST_HEAD(&s->s_more_io);
 		INIT_LIST_HEAD(&s->s_files);
 		INIT_LIST_HEAD(&s->s_instances);
 		INIT_HLIST_HEAD(&s->s_anon);
diff -puN include/linux/fs.h~writeback-fix-periodic-superblock-dirty-inode-flushing include/linux/fs.h
--- a/include/linux/fs.h~writeback-fix-periodic-superblock-dirty-inode-flushing
+++ a/include/linux/fs.h
@@ -996,6 +996,7 @@ struct super_block {
 	struct list_head	s_inodes;	/* all inodes */
 	struct list_head	s_dirty;	/* dirty inodes */
 	struct list_head	s_io;		/* parked for writeback */
+	struct list_head	s_more_io;	/* parked for more writeback */
 	struct hlist_head	s_anon;		/* anonymous dentries for (nfs) exporting */
 	struct list_head	s_files;
 
_

Patches currently in -mm which might be from kenchen@google.com are

cache-pipe-buf-page-address-for-non-highmem-arch.patch
writeback-fix-periodic-superblock-dirty-inode-flushing.patch
