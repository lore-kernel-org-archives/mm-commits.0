From: akpm@linux-foundation.org
Subject: + introduce-i_sync.patch added to -mm tree
Date: Thu, 31 May 2007 15:46:56 -0700
Message-ID: <200705312246.l4VMkuH7029914@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753115AbXEaWrk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2007 18:47:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joern@wohnheim.fh-wedel.de, aia21@cam.ac.uk, dgc@sgi.com, hch@infradead.org, shaggy@linux.vnet.ibm.com, viro@ftp.linux.org.uk


The patch titled
     introduce I_SYNC
has been added to the -mm tree.  Its filename is
     introduce-i_sync.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: introduce I_SYNC
From: Joern Engel <joern@wohnheim.fh-wedel.de>

I_LOCK was used for several unrelated purposes, which caused deadlock
situations in certain filesystems as a side effect.  One of the purposes
now uses the new I_SYNC bit.

Also document the various bits and change their order from historical to
logical.

Signed-off-by: Joern Engel <joern@wohnheim.fh-wedel.de>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: David Chinner <dgc@sgi.com>
Cc: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Al Viro <viro@ftp.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c           |   39 +++++++++++-------
 fs/hugetlbfs/inode.c        |    2 
 fs/inode.c                  |    6 +-
 fs/jfs/jfs_txnmgr.c         |    9 +++-
 fs/xfs/linux-2.6/xfs_iops.c |    4 -
 include/linux/fs.h          |   70 +++++++++++++++++++++++++++++-----
 include/linux/writeback.h   |    7 +++
 mm/page-writeback.c         |    2 
 8 files changed, 107 insertions(+), 32 deletions(-)

diff -puN fs/fs-writeback.c~introduce-i_sync fs/fs-writeback.c
--- a/fs/fs-writeback.c~introduce-i_sync
+++ a/fs/fs-writeback.c
@@ -99,11 +99,11 @@ void __mark_inode_dirty(struct inode *in
 		inode->i_state |= flags;
 
 		/*
-		 * If the inode is locked, just update its dirty state. 
+		 * If the inode is being synced, just update its dirty state.
 		 * The unlocker will place the inode on the appropriate
 		 * superblock list, based upon its state.
 		 */
-		if (inode->i_state & I_LOCK)
+		if (inode->i_state & I_SYNC)
 			goto out;
 
 		/*
@@ -185,6 +185,15 @@ static void redirty_head(struct inode *i
 	list_move_tail(&inode->i_list, &sb->s_dirty);
 }
 
+static void inode_sync_complete(struct inode *inode)
+{
+	/*
+	 * Prevent speculative execution through spin_unlock(&inode_lock);
+	 */
+	smp_mb();
+	wake_up_bit(&inode->i_state, __I_SYNC);
+}
+
 /*
  * Write a single inode's dirty pages and inode data out to disk.
  * If `wait' is set, wait on the writeout.
@@ -203,11 +212,11 @@ __sync_single_inode(struct inode *inode,
 	int wait = wbc->sync_mode == WB_SYNC_ALL;
 	int ret;
 
-	BUG_ON(inode->i_state & I_LOCK);
+	BUG_ON(inode->i_state & I_SYNC);
 
-	/* Set I_LOCK, reset I_DIRTY */
+	/* Set I_SYNC, reset I_DIRTY */
 	dirty = inode->i_state & I_DIRTY;
-	inode->i_state |= I_LOCK;
+	inode->i_state |= I_SYNC;
 	inode->i_state &= ~I_DIRTY;
 
 	spin_unlock(&inode_lock);
@@ -228,7 +237,7 @@ __sync_single_inode(struct inode *inode,
 	}
 
 	spin_lock(&inode_lock);
-	inode->i_state &= ~I_LOCK;
+	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & I_FREEING)) {
 		if (!(inode->i_state & I_DIRTY) &&
 		    mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
@@ -284,7 +293,7 @@ __sync_single_inode(struct inode *inode,
 			list_move(&inode->i_list, &inode_unused);
 		}
 	}
-	wake_up_inode(inode);
+	inode_sync_complete(inode);
 	return ret;
 }
 
@@ -303,7 +312,7 @@ __writeback_single_inode(struct inode *i
 	else
 		WARN_ON(inode->i_state & I_WILL_FREE);
 
-	if ((wbc->sync_mode != WB_SYNC_ALL) && (inode->i_state & I_LOCK)) {
+	if ((wbc->sync_mode != WB_SYNC_ALL) && (inode->i_state & I_SYNC)) {
 		struct address_space *mapping = inode->i_mapping;
 		int ret;
 
@@ -329,16 +338,16 @@ __writeback_single_inode(struct inode *i
 	/*
 	 * It's a data-integrity sync.  We must wait.
 	 */
-	if (inode->i_state & I_LOCK) {
-		DEFINE_WAIT_BIT(wq, &inode->i_state, __I_LOCK);
+	if (inode->i_state & I_SYNC) {
+		DEFINE_WAIT_BIT(wq, &inode->i_state, __I_SYNC);
 
-		wqh = bit_waitqueue(&inode->i_state, __I_LOCK);
+		wqh = bit_waitqueue(&inode->i_state, __I_SYNC);
 		do {
 			spin_unlock(&inode_lock);
 			__wait_on_bit(wqh, &wq, inode_wait,
 							TASK_UNINTERRUPTIBLE);
 			spin_lock(&inode_lock);
-		} while (inode->i_state & I_LOCK);
+		} while (inode->i_state & I_SYNC);
 	}
 	return __sync_single_inode(inode, wbc);
 }
@@ -371,7 +380,7 @@ __writeback_single_inode(struct inode *i
  * The inodes to be written are parked on sb->s_io.  They are moved back onto
  * sb->s_dirty as they are selected for writing.  This way, none can be missed
  * on the writer throttling path, and we get decent balancing between many
- * throttled threads: we don't want them all piling up on __wait_on_inode.
+ * throttled threads: we don't want them all piling up on inode_sync_wait.
  */
 static void
 sync_sb_inodes(struct super_block *sb, struct writeback_control *wbc)
@@ -643,7 +652,7 @@ int write_inode_now(struct inode *inode,
 	ret = __writeback_single_inode(inode, &wbc);
 	spin_unlock(&inode_lock);
 	if (sync)
-		wait_on_inode(inode);
+		inode_sync_wait(inode);
 	return ret;
 }
 EXPORT_SYMBOL(write_inode_now);
@@ -718,7 +727,7 @@ int generic_osync_inode(struct inode *in
 			err = err2;
 	}
 	else
-		wait_on_inode(inode);
+		inode_sync_wait(inode);
 
 	return err;
 }
diff -puN fs/hugetlbfs/inode.c~introduce-i_sync fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~introduce-i_sync
+++ a/fs/hugetlbfs/inode.c
@@ -237,7 +237,7 @@ static void hugetlbfs_forget_inode(struc
 	struct super_block *sb = inode->i_sb;
 
 	if (!hlist_unhashed(&inode->i_hash)) {
-		if (!(inode->i_state & (I_DIRTY|I_LOCK)))
+		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
 			list_move(&inode->i_list, &inode_unused);
 		inodes_stat.nr_unused++;
 		if (!sb || (sb->s_flags & MS_ACTIVE)) {
diff -puN fs/inode.c~introduce-i_sync fs/inode.c
--- a/fs/inode.c~introduce-i_sync
+++ a/fs/inode.c
@@ -226,7 +226,7 @@ void __iget(struct inode * inode)
 		return;
 	}
 	atomic_inc(&inode->i_count);
-	if (!(inode->i_state & (I_DIRTY|I_LOCK)))
+	if (!(inode->i_state & (I_DIRTY|I_SYNC)))
 		list_move(&inode->i_list, &inode_in_use);
 	inodes_stat.nr_unused--;
 }
@@ -247,7 +247,7 @@ void clear_inode(struct inode *inode)
 	BUG_ON(inode->i_data.nrpages);
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(inode->i_state & I_CLEAR);
-	wait_on_inode(inode);
+	inode_sync_wait(inode);
 	DQUOT_DROP(inode);
 	if (inode->i_sb->s_op->clear_inode)
 		inode->i_sb->s_op->clear_inode(inode);
@@ -1053,7 +1053,7 @@ static void generic_forget_inode(struct 
 	struct super_block *sb = inode->i_sb;
 
 	if (!hlist_unhashed(&inode->i_hash)) {
-		if (!(inode->i_state & (I_DIRTY|I_LOCK)))
+		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
 			list_move(&inode->i_list, &inode_unused);
 		inodes_stat.nr_unused++;
 		if (sb->s_flags & MS_ACTIVE) {
diff -puN fs/jfs/jfs_txnmgr.c~introduce-i_sync fs/jfs/jfs_txnmgr.c
--- a/fs/jfs/jfs_txnmgr.c~introduce-i_sync
+++ a/fs/jfs/jfs_txnmgr.c
@@ -1285,7 +1285,14 @@ int txCommit(tid_t tid,		/* transaction 
 		 * commit the transaction synchronously, so the last iput
 		 * will be done by the calling thread (or later)
 		 */
-		if (tblk->u.ip->i_state & I_LOCK)
+		/*
+		 * I believe this code is no longer needed.  Splitting I_LOCK
+		 * into two bits, I_LOCK and I_SYNC should prevent this
+		 * deadlock as well.  But since I don't have a JFS testload
+		 * to verify this, only a trivial s/I_LOCK/I_SYNC/ was done.
+		 * Joern
+		 */
+		if (tblk->u.ip->i_state & I_SYNC)
 			tblk->xflag &= ~COMMIT_LAZY;
 	}
 
diff -puN fs/xfs/linux-2.6/xfs_iops.c~introduce-i_sync fs/xfs/linux-2.6/xfs_iops.c
--- a/fs/xfs/linux-2.6/xfs_iops.c~introduce-i_sync
+++ a/fs/xfs/linux-2.6/xfs_iops.c
@@ -133,7 +133,7 @@ xfs_ichgtime(
 	 */
 	SYNCHRONIZE();
 	ip->i_update_core = 1;
-	if (!(inode->i_state & I_LOCK))
+	if (!(inode->i_state & I_SYNC))
 		mark_inode_dirty_sync(inode);
 }
 
@@ -185,7 +185,7 @@ xfs_ichgtime_fast(
 	 */
 	SYNCHRONIZE();
 	ip->i_update_core = 1;
-	if (!(inode->i_state & I_LOCK))
+	if (!(inode->i_state & I_SYNC))
 		mark_inode_dirty_sync(inode);
 }
 
diff -puN include/linux/fs.h~introduce-i_sync include/linux/fs.h
--- a/include/linux/fs.h~introduce-i_sync
+++ a/include/linux/fs.h
@@ -1247,16 +1247,68 @@ struct super_operations {
 #endif
 };
 
-/* Inode state bits.  Protected by inode_lock. */
-#define I_DIRTY_SYNC		1 /* Not dirty enough for O_DATASYNC */
-#define I_DIRTY_DATASYNC	2 /* Data-related inode changes pending */
-#define I_DIRTY_PAGES		4 /* Data-related inode changes pending */
-#define __I_LOCK		3
+/*
+ * Inode state bits.  Protected by inode_lock.
+ *
+ * Three bits determine the dirty state of the inode, I_DIRTY_SYNC,
+ * I_DIRTY_DATASYNC and I_DIRTY_PAGES.
+ *
+ * Four bits define the lifetime of an inode.  Initially, inodes are I_NEW,
+ * until that flag is cleared.  I_WILL_FREE, I_FREEING and I_CLEAR are set at
+ * various stages of removing an inode.
+ *
+ * Two bits are used for locking and completion notification, I_LOCK and I_SYNC.
+ *
+ * I_DIRTY_SYNC		Inode itself is dirty.
+ * I_DIRTY_DATASYNC	Data-related inode changes pending
+ * I_DIRTY_PAGES	Inode has dirty pages.  Inode itself may be clean.
+ * I_NEW		get_new_inode() sets i_state to I_LOCK|I_NEW.  Both
+ *			are cleared by unlock_new_inode(), called from iget().
+ * I_WILL_FREE		Must be set when calling write_inode_now() if i_count
+ *			is zero.  I_FREEING must be set when I_WILL_FREE is
+ *			cleared.
+ * I_FREEING		Set when inode is about to be freed but still has dirty
+ *			pages or buffers attached or the inode itself is still
+ *			dirty.
+ * I_CLEAR		Set by clear_inode().  In this state the inode is clean
+ *			and can be destroyed.
+ *
+ *			Inodes that are I_WILL_FREE, I_FREEING or I_CLEAR are
+ *			prohibited for many purposes.  iget() must wait for
+ *			the inode to be completely released, then create it
+ *			anew.  Other functions will just ignore such inodes,
+ *			if appropriate.  I_LOCK is used for waiting.
+ *
+ * I_LOCK		Serves as both a mutex and completion notification.
+ *			New inodes set I_LOCK.  If two processes both create
+ *			the same inode, one of them will release its inode and
+ *			wait for I_LOCK to be released before returning.
+ *			Inodes in I_WILL_FREE, I_FREEING or I_CLEAR state can
+ *			also cause waiting on I_LOCK, without I_LOCK actually
+ *			being set.  find_inode() uses this to prevent returning
+ *			nearly-dead inodes.
+ * I_SYNC		Similar to I_LOCK, but limited in scope to writeback
+ *			of inode dirty data.  Having a seperate lock for this
+ *			purpose reduces latency and prevents some filesystem-
+ *			specific deadlocks.
+ *
+ * Q: Why does I_DIRTY_DATASYNC exist?  It appears as if it could be replaced
+ *    by (I_DIRTY_SYNC|I_DIRTY_PAGES).
+ * Q: What is the difference between I_WILL_FREE and I_FREEING?
+ * Q: igrab() only checks on (I_FREEING|I_WILL_FREE).  Should it also check on
+ *    I_CLEAR?  If not, why?
+ */
+#define I_DIRTY_SYNC		1
+#define I_DIRTY_DATASYNC	2
+#define I_DIRTY_PAGES		4
+#define I_NEW			8
+#define I_WILL_FREE		16
+#define I_FREEING		32
+#define I_CLEAR			64
+#define __I_LOCK		7
 #define I_LOCK			(1 << __I_LOCK)
-#define I_FREEING		16
-#define I_CLEAR			32
-#define I_NEW			64
-#define I_WILL_FREE		128
+#define __I_SYNC		8
+#define I_SYNC			(1 << __I_SYNC)
 
 #define I_DIRTY (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES)
 
diff -puN include/linux/writeback.h~introduce-i_sync include/linux/writeback.h
--- a/include/linux/writeback.h~introduce-i_sync
+++ a/include/linux/writeback.h
@@ -81,6 +81,13 @@ static inline void wait_on_inode(struct 
 	wait_on_bit(&inode->i_state, __I_LOCK, inode_wait,
 							TASK_UNINTERRUPTIBLE);
 }
+static inline void inode_sync_wait(struct inode *inode)
+{
+	might_sleep();
+	wait_on_bit(&inode->i_state, __I_SYNC, inode_wait,
+							TASK_UNINTERRUPTIBLE);
+}
+
 
 /*
  * mm/page-writeback.c
diff -puN mm/page-writeback.c~introduce-i_sync mm/page-writeback.c
--- a/mm/page-writeback.c~introduce-i_sync
+++ a/mm/page-writeback.c
@@ -36,7 +36,7 @@
 
 /*
  * The maximum number of pages to writeout in a single bdflush/kupdate
- * operation.  We do this so we don't hold I_LOCK against an inode for
+ * operation.  We do this so we don't hold I_SYNC against an inode for
  * enormous amounts of time, which would block a userspace task which has
  * been forced to throttle against that inode.  Also, the code reevaluates
  * the dirty each time it has written this many pages.
_

Patches currently in -mm which might be from joern@wohnheim.fh-wedel.de are

introduce-i_sync.patch
