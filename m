From: akpm@linux-foundation.org
Subject: [merged]
 revert-writeback-do-not-sync-data-dirtied-after-sync-start.patch removed
 from -mm tree
Date: Mon, 24 Feb 2014 12:39:53 -0800
Message-ID: <530bae19.5WTHMCqPDfWcXxfW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50313 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbaBXUjy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Feb 2014 15:39:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, david@fromorbit.com, jack@suse.cz

Subject: [merged] revert-writeback-do-not-sync-data-dirtied-after-sync-start.patch removed from -mm tree
To: jack@suse.cz,david@fromorbit.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 24 Feb 2014 12:39:53 -0800


The patch titled
     Subject: Revert "writeback: do not sync data dirtied after sync start"
has been removed from the -mm tree.  Its filename was
     revert-writeback-do-not-sync-data-dirtied-after-sync-start.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: Revert "writeback: do not sync data dirtied after sync start"

This reverts c4a391b53a72.  Dave Chinner has reported the commit may cause
some inodes to be left out from sync(2).  This is because we can call
redirty_tail() for some inode (which sets i_dirtied_when to current time)
after sync(2) has started or similarly requeue_inode() can set
i_dirtied_when to current time if writeback had to skip some pages.  The
real problem is in the functions clobbering i_dirtied_when but fixing that
isn't trivial so revert is a safer choice for now.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c                |   33 +++++++++--------------------
 fs/sync.c                        |   15 +++++--------
 fs/xfs/xfs_super.c               |    2 -
 include/linux/writeback.h        |    2 -
 include/trace/events/writeback.h |    6 ++---
 5 files changed, 22 insertions(+), 36 deletions(-)

diff -puN fs/fs-writeback.c~revert-writeback-do-not-sync-data-dirtied-after-sync-start fs/fs-writeback.c
--- a/fs/fs-writeback.c~revert-writeback-do-not-sync-data-dirtied-after-sync-start
+++ a/fs/fs-writeback.c
@@ -40,18 +40,13 @@
 struct wb_writeback_work {
 	long nr_pages;
 	struct super_block *sb;
-	/*
-	 * Write only inodes dirtied before this time. Don't forget to set
-	 * older_than_this_is_set when you set this.
-	 */
-	unsigned long older_than_this;
+	unsigned long *older_than_this;
 	enum writeback_sync_modes sync_mode;
 	unsigned int tagged_writepages:1;
 	unsigned int for_kupdate:1;
 	unsigned int range_cyclic:1;
 	unsigned int for_background:1;
 	unsigned int for_sync:1;	/* sync(2) WB_SYNC_ALL writeback */
-	unsigned int older_than_this_is_set:1;
 	enum wb_reason reason;		/* why was writeback initiated? */
 
 	struct list_head list;		/* pending work list */
@@ -252,10 +247,10 @@ static int move_expired_inodes(struct li
 	int do_sb_sort = 0;
 	int moved = 0;
 
-	WARN_ON_ONCE(!work->older_than_this_is_set);
 	while (!list_empty(delaying_queue)) {
 		inode = wb_inode(delaying_queue->prev);
-		if (inode_dirtied_after(inode, work->older_than_this))
+		if (work->older_than_this &&
+		    inode_dirtied_after(inode, *work->older_than_this))
 			break;
 		list_move(&inode->i_wb_list, &tmp);
 		moved++;
@@ -742,8 +737,6 @@ static long writeback_inodes_wb(struct b
 		.sync_mode	= WB_SYNC_NONE,
 		.range_cyclic	= 1,
 		.reason		= reason,
-		.older_than_this = jiffies,
-		.older_than_this_is_set = 1,
 	};
 
 	spin_lock(&wb->list_lock);
@@ -802,13 +795,12 @@ static long wb_writeback(struct bdi_writ
 {
 	unsigned long wb_start = jiffies;
 	long nr_pages = work->nr_pages;
+	unsigned long oldest_jif;
 	struct inode *inode;
 	long progress;
 
-	if (!work->older_than_this_is_set) {
-		work->older_than_this = jiffies;
-		work->older_than_this_is_set = 1;
-	}
+	oldest_jif = jiffies;
+	work->older_than_this = &oldest_jif;
 
 	spin_lock(&wb->list_lock);
 	for (;;) {
@@ -842,10 +834,10 @@ static long wb_writeback(struct bdi_writ
 		 * safe.
 		 */
 		if (work->for_kupdate) {
-			work->older_than_this = jiffies -
+			oldest_jif = jiffies -
 				msecs_to_jiffies(dirty_expire_interval * 10);
 		} else if (work->for_background)
-			work->older_than_this = jiffies;
+			oldest_jif = jiffies;
 
 		trace_writeback_start(wb->bdi, work);
 		if (list_empty(&wb->b_io))
@@ -1358,21 +1350,18 @@ EXPORT_SYMBOL(try_to_writeback_inodes_sb
 
 /**
  * sync_inodes_sb	-	sync sb inode pages
- * @sb:			the superblock
- * @older_than_this:	timestamp
+ * @sb: the superblock
  *
  * This function writes and waits on any dirty inode belonging to this
- * superblock that has been dirtied before given timestamp.
+ * super_block.
  */
-void sync_inodes_sb(struct super_block *sb, unsigned long older_than_this)
+void sync_inodes_sb(struct super_block *sb)
 {
 	DECLARE_COMPLETION_ONSTACK(done);
 	struct wb_writeback_work work = {
 		.sb		= sb,
 		.sync_mode	= WB_SYNC_ALL,
 		.nr_pages	= LONG_MAX,
-		.older_than_this = older_than_this,
-		.older_than_this_is_set = 1,
 		.range_cyclic	= 0,
 		.done		= &done,
 		.reason		= WB_REASON_SYNC,
diff -puN fs/sync.c~revert-writeback-do-not-sync-data-dirtied-after-sync-start fs/sync.c
--- a/fs/sync.c~revert-writeback-do-not-sync-data-dirtied-after-sync-start
+++ a/fs/sync.c
@@ -27,11 +27,10 @@
  * wait == 1 case since in that case write_inode() functions do
  * sync_dirty_buffer() and thus effectively write one block at a time.
  */
-static int __sync_filesystem(struct super_block *sb, int wait,
-			     unsigned long start)
+static int __sync_filesystem(struct super_block *sb, int wait)
 {
 	if (wait)
-		sync_inodes_sb(sb, start);
+		sync_inodes_sb(sb);
 	else
 		writeback_inodes_sb(sb, WB_REASON_SYNC);
 
@@ -48,7 +47,6 @@ static int __sync_filesystem(struct supe
 int sync_filesystem(struct super_block *sb)
 {
 	int ret;
-	unsigned long start = jiffies;
 
 	/*
 	 * We need to be protected against the filesystem going from
@@ -62,17 +60,17 @@ int sync_filesystem(struct super_block *
 	if (sb->s_flags & MS_RDONLY)
 		return 0;
 
-	ret = __sync_filesystem(sb, 0, start);
+	ret = __sync_filesystem(sb, 0);
 	if (ret < 0)
 		return ret;
-	return __sync_filesystem(sb, 1, start);
+	return __sync_filesystem(sb, 1);
 }
 EXPORT_SYMBOL_GPL(sync_filesystem);
 
 static void sync_inodes_one_sb(struct super_block *sb, void *arg)
 {
 	if (!(sb->s_flags & MS_RDONLY))
-		sync_inodes_sb(sb, *((unsigned long *)arg));
+		sync_inodes_sb(sb);
 }
 
 static void sync_fs_one_sb(struct super_block *sb, void *arg)
@@ -104,10 +102,9 @@ static void fdatawait_one_bdev(struct bl
 SYSCALL_DEFINE0(sync)
 {
 	int nowait = 0, wait = 1;
-	unsigned long start = jiffies;
 
 	wakeup_flusher_threads(0, WB_REASON_SYNC);
-	iterate_supers(sync_inodes_one_sb, &start);
+	iterate_supers(sync_inodes_one_sb, NULL);
 	iterate_supers(sync_fs_one_sb, &nowait);
 	iterate_supers(sync_fs_one_sb, &wait);
 	iterate_bdevs(fdatawrite_one_bdev, NULL);
diff -puN fs/xfs/xfs_super.c~revert-writeback-do-not-sync-data-dirtied-after-sync-start fs/xfs/xfs_super.c
--- a/fs/xfs/xfs_super.c~revert-writeback-do-not-sync-data-dirtied-after-sync-start
+++ a/fs/xfs/xfs_super.c
@@ -913,7 +913,7 @@ xfs_flush_inodes(
 	struct super_block	*sb = mp->m_super;
 
 	if (down_read_trylock(&sb->s_umount)) {
-		sync_inodes_sb(sb, jiffies);
+		sync_inodes_sb(sb);
 		up_read(&sb->s_umount);
 	}
 }
diff -puN include/linux/writeback.h~revert-writeback-do-not-sync-data-dirtied-after-sync-start include/linux/writeback.h
--- a/include/linux/writeback.h~revert-writeback-do-not-sync-data-dirtied-after-sync-start
+++ a/include/linux/writeback.h
@@ -97,7 +97,7 @@ void writeback_inodes_sb_nr(struct super
 int try_to_writeback_inodes_sb(struct super_block *, enum wb_reason reason);
 int try_to_writeback_inodes_sb_nr(struct super_block *, unsigned long nr,
 				  enum wb_reason reason);
-void sync_inodes_sb(struct super_block *sb, unsigned long older_than_this);
+void sync_inodes_sb(struct super_block *);
 void wakeup_flusher_threads(long nr_pages, enum wb_reason reason);
 void inode_wait_for_writeback(struct inode *inode);
 
diff -puN include/trace/events/writeback.h~revert-writeback-do-not-sync-data-dirtied-after-sync-start include/trace/events/writeback.h
--- a/include/trace/events/writeback.h~revert-writeback-do-not-sync-data-dirtied-after-sync-start
+++ a/include/trace/events/writeback.h
@@ -287,11 +287,11 @@ TRACE_EVENT(writeback_queue_io,
 		__field(int,		reason)
 	),
 	TP_fast_assign(
-		unsigned long older_than_this = work->older_than_this;
+		unsigned long *older_than_this = work->older_than_this;
 		strncpy(__entry->name, dev_name(wb->bdi->dev), 32);
-		__entry->older	= older_than_this;
+		__entry->older	= older_than_this ?  *older_than_this : 0;
 		__entry->age	= older_than_this ?
-				  (jiffies - older_than_this) * 1000 / HZ : -1;
+				  (jiffies - *older_than_this) * 1000 / HZ : -1;
 		__entry->moved	= moved;
 		__entry->reason	= work->reason;
 	),
_

Patches currently in -mm which might be from jack@suse.cz are

backing_dev-fix-hung-task-on-sync.patch
kthread-ensure-locality-of-task_struct-allocations.patch
fanotify-remove-useless-bypass_perm-check.patch
fanotify-use-fanotify-event-structure-for-permission-response-processing.patch
fanotify-remove-useless-test-from-event-initialization.patch
fanotify-convert-access_mutex-to-spinlock.patch
fanotify-reorganize-loop-in-fanotify_read.patch
fanotify-move-unrelated-handling-from-copy_event_to_user.patch
ocfs2-remove-ocfs2_inode_skip_delete-flag.patch
ocfs2-move-dquot_initialize-in-ocfs2_delete_inode-somewhat-later.patch
quota-provide-function-to-grab-quota-structure-reference.patch
ocfs2-implement-delayed-dropping-of-last-dquot-reference.patch
ocfs2-avoid-blocking-in-ocfs2_mark_lockres_freeing-in-downconvert-thread.patch
ocfs2-revert-iput-deferring-code-in-ocfs2_drop_dentry_lock.patch
ocfs2-fix-quota-file-corruption.patch
mm-vmstat-fix-up-zone-state-accounting.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
lib-radix_tree-tree-node-interface.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-readaheadc-fix-readahead-failure-for-memoryless-numa-nodes-and-limit-readahead-pages.patch
printk-remove-duplicated-check-for-log-level.patch
printk-remove-obsolete-check-for-log-level-c.patch
printk-add-comment-about-tricky-check-for-text-buffer-size.patch
printk-use-also-the-last-bytes-in-the-ring-buffer.patch
printk-do-not-compute-the-size-of-the-message-twice.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch

