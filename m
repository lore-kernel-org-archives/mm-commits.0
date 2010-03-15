From: akpm@linux-foundation.org
Subject: [merged] vfs-improve-writeback_inodes_wb.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:05:42 -0400
Message-ID: <201003150706.o2F76Fv6017222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934451Ab0COHGW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:06:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward.shishkin@gmail.com, fengguang.wu@intel.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     vfs: improve writeback_inodes_wb()
has been removed from the -mm tree.  Its filename was
     vfs-improve-writeback_inodes_wb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: improve writeback_inodes_wb()
From: Edward Shishkin <edward.shishkin@gmail.com>

Do not pin/unpin superblock for every inode in writeback_inodes_wb(), pin
it for the whole group of inodes which belong to the same superblock and
call writeback_sb_inodes() handler for them.

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c         |  133 +++++++++++++++++++-----------------
 include/linux/writeback.h |    3 
 2 files changed, 76 insertions(+), 60 deletions(-)

diff -puN fs/fs-writeback.c~vfs-improve-writeback_inodes_wb fs/fs-writeback.c
--- a/fs/fs-writeback.c~vfs-improve-writeback_inodes_wb
+++ a/fs/fs-writeback.c
@@ -552,108 +552,85 @@ select_queue:
 	return ret;
 }
 
-static void unpin_sb_for_writeback(struct super_block **psb)
+static void unpin_sb_for_writeback(struct super_block *sb)
 {
-	struct super_block *sb = *psb;
-
-	if (sb) {
-		up_read(&sb->s_umount);
-		put_super(sb);
-		*psb = NULL;
-	}
+	up_read(&sb->s_umount);
+	put_super(sb);
 }
 
+enum sb_pin_state {
+	SB_PINNED,
+	SB_NOT_PINNED,
+	SB_PIN_FAILED
+};
+
 /*
  * For WB_SYNC_NONE writeback, the caller does not have the sb pinned
  * before calling writeback. So make sure that we do pin it, so it doesn't
  * go away while we are writing inodes from it.
- *
- * Returns 0 if the super was successfully pinned (or pinning wasn't needed),
- * 1 if we failed.
  */
-static int pin_sb_for_writeback(struct writeback_control *wbc,
-				struct inode *inode, struct super_block **psb)
+static enum sb_pin_state pin_sb_for_writeback(struct writeback_control *wbc,
+					      struct super_block *sb)
 {
-	struct super_block *sb = inode->i_sb;
-
-	/*
-	 * If this sb is already pinned, nothing more to do. If not and
-	 * *psb is non-NULL, unpin the old one first
-	 */
-	if (sb == *psb)
-		return 0;
-	else if (*psb)
-		unpin_sb_for_writeback(psb);
-
 	/*
 	 * Caller must already hold the ref for this
 	 */
 	if (wbc->sync_mode == WB_SYNC_ALL) {
 		WARN_ON(!rwsem_is_locked(&sb->s_umount));
-		return 0;
+		return SB_NOT_PINNED;
 	}
-
 	spin_lock(&sb_lock);
 	sb->s_count++;
 	if (down_read_trylock(&sb->s_umount)) {
 		if (sb->s_root) {
 			spin_unlock(&sb_lock);
-			goto pinned;
+			return SB_PINNED;
 		}
 		/*
 		 * umounted, drop rwsem again and fall through to failure
 		 */
 		up_read(&sb->s_umount);
 	}
-
 	sb->s_count--;
 	spin_unlock(&sb_lock);
-	return 1;
-pinned:
-	*psb = sb;
-	return 0;
+	return SB_PIN_FAILED;
 }
 
-static void writeback_inodes_wb(struct bdi_writeback *wb,
-				struct writeback_control *wbc)
+/*
+ * Write a portion of b_io inodes which belong to @sb.
+ * If @wbc->sb != NULL, then find and write all such
+ * inodes. Otherwise write only ones which go sequentially
+ * in reverse order.
+ * Return 1, if the caller writeback routine should be
+ * interrupted. Otherwise return 0.
+ */
+static int writeback_sb_inodes(struct super_block *sb,
+			       struct bdi_writeback *wb,
+			       struct writeback_control *wbc)
 {
-	struct super_block *sb = wbc->sb, *pin_sb = NULL;
-	const unsigned long start = jiffies;	/* livelock avoidance */
-
-	spin_lock(&inode_lock);
-
-	if (!wbc->for_kupdate || list_empty(&wb->b_io))
-		queue_io(wb, wbc->older_than_this);
-
 	while (!list_empty(&wb->b_io)) {
-		struct inode *inode = list_entry(wb->b_io.prev,
-						struct inode, i_list);
 		long pages_skipped;
-
-		/*
-		 * super block given and doesn't match, skip this inode
-		 */
-		if (sb && sb != inode->i_sb) {
+		struct inode *inode = list_entry(wb->b_io.prev,
+						 struct inode, i_list);
+		if (wbc->sb && sb != inode->i_sb) {
+			/* super block given and doesn't
+			   match, skip this inode */
 			redirty_tail(inode);
 			continue;
 		}
-
+		if (sb != inode->i_sb)
+			/* finish with this superblock */
+			return 0;
 		if (inode->i_state & (I_NEW | I_WILL_FREE)) {
 			requeue_io(inode);
 			continue;
 		}
-
 		/*
 		 * Was this inode dirtied after sync_sb_inodes was called?
 		 * This keeps sync from extra jobs and livelock.
 		 */
-		if (inode_dirtied_after(inode, start))
-			break;
-
-		if (pin_sb_for_writeback(wbc, inode, &pin_sb)) {
-			requeue_io(inode);
-			continue;
-		}
+		if (inode_dirtied_after(inode, wbc->wb_start))
+			return 1;
 
 		BUG_ON(inode->i_state & (I_FREEING | I_CLEAR));
 		__iget(inode);
@@ -672,14 +649,50 @@ static void writeback_inodes_wb(struct b
 		spin_lock(&inode_lock);
 		if (wbc->nr_to_write <= 0) {
 			wbc->more_io = 1;
-			break;
+			return 1;
 		}
 		if (!list_empty(&wb->b_more_io))
 			wbc->more_io = 1;
 	}
+	/* b_io is empty */
+	return 1;
+}
+
+static void writeback_inodes_wb(struct bdi_writeback *wb,
+				struct writeback_control *wbc)
+{
+	int ret = 0;
 
-	unpin_sb_for_writeback(&pin_sb);
+	wbc->wb_start = jiffies; /* livelock avoidance */
+	spin_lock(&inode_lock);
+	if (!wbc->for_kupdate || list_empty(&wb->b_io))
+		queue_io(wb, wbc->older_than_this);
 
+	while (!list_empty(&wb->b_io)) {
+		struct inode *inode = list_entry(wb->b_io.prev,
+						 struct inode, i_list);
+		struct super_block *sb = inode->i_sb;
+		enum sb_pin_state state;
+
+		if (wbc->sb && sb != wbc->sb) {
+			/* super block given and doesn't
+			   match, skip this inode */
+			redirty_tail(inode);
+			continue;
+		}
+		state = pin_sb_for_writeback(wbc, sb);
+
+		if (state == SB_PIN_FAILED) {
+			requeue_io(inode);
+			continue;
+		}
+		ret = writeback_sb_inodes(sb, wb, wbc);
+
+		if (state == SB_PINNED)
+			unpin_sb_for_writeback(sb);
+		if (ret)
+			break;
+	}
 	spin_unlock(&inode_lock);
 	/* Leave any unwritten inodes on b_io */
 }
diff -puN include/linux/writeback.h~vfs-improve-writeback_inodes_wb include/linux/writeback.h
--- a/include/linux/writeback.h~vfs-improve-writeback_inodes_wb
+++ a/include/linux/writeback.h
@@ -34,6 +34,9 @@ struct writeback_control {
 	enum writeback_sync_modes sync_mode;
 	unsigned long *older_than_this;	/* If !NULL, only write back inodes
 					   older than this */
+	unsigned long wb_start;         /* Time writeback_inodes_wb was
+					   called. This is needed to avoid
+					   extra jobs and livelock */
 	long nr_to_write;		/* Write this many pages, and decrement
 					   this for each page written */
 	long pages_skipped;		/* Pages which were not written */
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

linux-next.patch
vfs-add-super-operation-writeback_inodes.patch
vfs-take-2add-set_page_dirty_notag.patch
reiser4.patch
reiser4-writeback_inodes-implementation.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixup-checkin-checkout-jnodes-for-entd.patch
reiser4-fixups.patch
reiser4-broke.patch

