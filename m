From: akpm@linux-foundation.org
Subject: + vfs-add-super-operation-writeback_inodes.patch added to -mm tree
Date: Wed, 03 Feb 2010 12:18:37 -0800
Message-ID: <201002032018.o13KIbU7016616@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757854Ab0BCUTC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 15:19:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward.shishkin@gmail.com, fengguang.wu@intel.com, jens.axboe@oracle.com


The patch titled
     vfs: add super operation writeback_inodes
has been added to the -mm tree.  Its filename is
     vfs-add-super-operation-writeback_inodes.patch

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
Subject: vfs: add super operation writeback_inodes
From: Edward Shishkin <edward.shishkin@gmail.com>

. add ->writeback_inodes() super operation.

    This patch adds new operation to struct super_operations -
    writeback_inodes, generic implementaion and changes
    fs-writeback.c:writeback_inodes_wb() to call filesystem's
    writeback_inodes if it is defined or generic implementaion
    otherwise. This new operation allows filesystem to decide
    itself what to flush.

    Reiser4 flushes dirty pages on basic of atoms, not of inodes.
    writeback_inodes_wb used to call address space flushing
    method (writepages) for every dirty inode. For reiser4 it
    caused having to commit atoms unnecessarily often.  This
    turned into substantial slowdown.  Having this method helped
    to fix that problem.

. add vfs library function writeback_skip_sb_inodes()

   This function is for file systems which have their own means
   of periodical writeout of old data.

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c         |   47 ++++++++++++++++++++++++++++++++----
 include/linux/fs.h        |   10 +++++++
 include/linux/writeback.h |    6 ++++
 3 files changed, 59 insertions(+), 4 deletions(-)

diff -puN fs/fs-writeback.c~vfs-add-super-operation-writeback_inodes fs/fs-writeback.c
--- a/fs/fs-writeback.c~vfs-add-super-operation-writeback_inodes
+++ a/fs/fs-writeback.c
@@ -605,9 +605,9 @@ static enum sb_pin_state pin_sb_for_writ
  * Return 1, if the caller writeback routine should be
  * interrupted. Otherwise return 0.
  */
-static int writeback_sb_inodes(struct super_block *sb,
-			       struct bdi_writeback *wb,
-			       struct writeback_control *wbc)
+int generic_writeback_sb_inodes(struct super_block *sb,
+				struct bdi_writeback *wb,
+				struct writeback_control *wbc)
 {
 	while (!list_empty(&wb->b_io)) {
 		long pages_skipped;
@@ -658,6 +658,32 @@ static int writeback_sb_inodes(struct su
 	/* b_io is empty */
 	return 1;
 }
+EXPORT_SYMBOL(generic_writeback_sb_inodes);
+
+/*
+ * This function is for file systems which have their
+ * own means of periodical write-out of old data.
+ * NOTE: inode_lock should be hold.
+ *
+ * Skip a portion of b_io inodes which belong to @sb
+ * and go sequentially in reverse order.
+ */
+void writeback_skip_sb_inodes(struct super_block *sb,
+			      struct bdi_writeback *wb)
+{
+	while (1) {
+		struct inode *inode;
+
+		if (list_empty(&wb->b_io))
+			break;
+		inode = list_entry(wb->b_io.prev, struct inode, i_list);
+		if (sb != inode->i_sb)
+			break;
+		redirty_tail(inode);
+	}
+}
+EXPORT_SYMBOL(writeback_skip_sb_inodes);
+
 
 static void writeback_inodes_wb(struct bdi_writeback *wb,
 				struct writeback_control *wbc)
@@ -687,7 +713,10 @@ static void writeback_inodes_wb(struct b
 			requeue_io(inode);
 			continue;
 		}
-		ret = writeback_sb_inodes(sb, wb, wbc);
+		if (sb->s_op->writeback_inodes)
+			ret = sb->s_op->writeback_inodes(sb, wb, wbc);
+		else
+			ret = generic_writeback_sb_inodes(sb, wb, wbc);
 
 		if (state == SB_PINNED)
 			unpin_sb_for_writeback(sb);
@@ -704,6 +733,7 @@ void writeback_inodes_wbc(struct writeba
 
 	writeback_inodes_wb(&bdi->wb, wbc);
 }
+EXPORT_SYMBOL(writeback_inodes_wbc);
 
 /*
  * The maximum number of pages to writeout in a single bdi flush/kupdate
@@ -1289,3 +1319,12 @@ int sync_inode(struct inode *inode, stru
 	return ret;
 }
 EXPORT_SYMBOL(sync_inode);
+/*
+ * Local variables:
+ * c-indentation-style: "K&R"
+ * mode-name: "LC"
+ * c-basic-offset: 8
+ * tab-width: 8
+ * fill-column: 79
+ * End:
+ */
diff -puN include/linux/fs.h~vfs-add-super-operation-writeback_inodes include/linux/fs.h
--- a/include/linux/fs.h~vfs-add-super-operation-writeback_inodes
+++ a/include/linux/fs.h
@@ -514,6 +514,7 @@ enum positive_aop_returns {
 struct page;
 struct address_space;
 struct writeback_control;
+struct bdi_writeback;
 
 struct iov_iter {
 	const struct iovec *iov;
@@ -1565,6 +1566,9 @@ struct super_operations {
 	int (*remount_fs) (struct super_block *, int *, char *);
 	void (*clear_inode) (struct inode *);
 	void (*umount_begin) (struct super_block *);
+	int (*writeback_inodes)(struct super_block *sb,
+				struct bdi_writeback *wb,
+				struct writeback_control *wbc);
 
 	int (*show_options)(struct seq_file *, struct vfsmount *);
 	int (*show_stats)(struct seq_file *, struct vfsmount *);
@@ -2068,6 +2072,12 @@ extern int invalidate_inode_pages2(struc
 extern int invalidate_inode_pages2_range(struct address_space *mapping,
 					 pgoff_t start, pgoff_t end);
 extern int write_inode_now(struct inode *, int);
+extern void writeback_skip_sb_inodes(struct super_block *sb,
+				     struct bdi_writeback *wb);
+extern void writeback_inodes_wbc(struct writeback_control *wbc);
+extern int generic_writeback_sb_inodes(struct super_block *sb,
+				       struct bdi_writeback *wb,
+				       struct writeback_control *wbc);
 extern int filemap_fdatawrite(struct address_space *);
 extern int filemap_flush(struct address_space *);
 extern int filemap_fdatawait(struct address_space *);
diff -puN include/linux/writeback.h~vfs-add-super-operation-writeback_inodes include/linux/writeback.h
--- a/include/linux/writeback.h~vfs-add-super-operation-writeback_inodes
+++ a/include/linux/writeback.h
@@ -13,6 +13,12 @@ extern spinlock_t inode_lock;
 extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 
+static inline int is_flush_bd_task(struct task_struct *task)
+{
+       return task->flags & PF_FLUSHER;
+}
+#define current_is_flush_bd_task()  is_flush_bd_task(current)
+
 /*
  * fs/fs-writeback.c
  */
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

vfs-improve-writeback_inodes_wb.patch
vfs-add-super-operation-writeback_inodes.patch
vfs-take-2add-set_page_dirty_notag.patch
reiser4.patch
reiser4-adjust-to-the-new-aops.patch
reiser4-adjust-to-the-new-aops-fixup.patch
reiser4-remove-simple_prepare_write-usage.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
reiser4-handling-error-returned-by-d_obtain_alias-fixup.patch
reiser4-update-names-of-quota-methods.patch
reiser4-use-set_page_dirty_notag.patch
fs-reiser4-add-parenths-around-x-y.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-rename-psched-to-dispatch.patch
reiser4-drop-journal-info.patch
reiser4-fix-compile-warnings.patch
reiser4-reduce-frame-size-of-reiser4_init_super_data.patch
reiser4-reduce-frame-size-of-reiser4_init_super_data-fixup.patch
reiser4-some-changes-from-reiser4-2631-patch.patch
reiser4-some-comments-were-still-mentioning-pdflush.patch
reiser4-writeback_inodes-implementation.patch
reiser4-fixup-checkin-checkout-jnodes-for-entd.patch

