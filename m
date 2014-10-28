From: akpm@linux-foundation.org
Subject: [to-be-updated]
 ocfs2-add-two-functions-of-add-and-remove-inode-in-orphan-dir.patch removed from -mm tree
Date: Tue, 28 Oct 2014 13:50:43 -0700
Message-ID: <545001a3.MS2NxFsizxoCYMtw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbaJ1Uum (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Oct 2014 16:50:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangww631@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: add two functions of add and remove inode in orphan dir
has been removed from the -mm tree.  Its filename was
     ocfs2-add-two-functions-of-add-and-remove-inode-in-orphan-dir.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: WeiWei Wang <wangww631@huawei.com>
Subject: ocfs2: add two functions of add and remove inode in orphan dir

Add two functions to add inode to orphan dir and remove inode from orphan
dir.  Here the original functions ocfs2_orphan_add and ocfs2_orphan_del
are called respectively.

Signed-off-by: Weiwei Wang <wangww631@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.h |    5 +
 fs/ocfs2/namei.c   |  147 +++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/namei.h   |    5 +
 3 files changed, 157 insertions(+)

diff -puN fs/ocfs2/journal.h~ocfs2-add-two-functions-of-add-and-remove-inode-in-orphan-dir fs/ocfs2/journal.h
--- a/fs/ocfs2/journal.h~ocfs2-add-two-functions-of-add-and-remove-inode-in-orphan-dir
+++ a/fs/ocfs2/journal.h
@@ -472,6 +472,11 @@ static inline int ocfs2_unlink_credits(s
  * orphan dir index leaf */
 #define OCFS2_DELETE_INODE_CREDITS (3 * OCFS2_INODE_UPDATE_CREDITS + 4)
 
+/* dinode + orphan dir dinode + extent tree leaf block + orphan dir entry +
+ * orphan dir index root + orphan dir index leaf */
+#define OCFS2_INODE_ADD_TO_ORPHAN_CREDITS  (2 * OCFS2_INODE_UPDATE_CREDITS + 4)
+#define OCFS2_INODE_DEL_FROM_ORPHAN_CREDITS  OCFS2_INODE_ADD_TO_ORPHAN_CREDITS
+
 /* dinode update, old dir dinode update, new dir dinode update, old
  * dir dir entry, new dir dir entry, dir entry update for renaming
  * directory + target unlink + 3 x dir index leaves */
diff -puN fs/ocfs2/namei.c~ocfs2-add-two-functions-of-add-and-remove-inode-in-orphan-dir fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-add-two-functions-of-add-and-remove-inode-in-orphan-dir
+++ a/fs/ocfs2/namei.c
@@ -2486,6 +2486,153 @@ leave:
 	return status;
 }
 
+/* An orphan dir name is an 8 byte value, printed as a hex string */
+#define OCFS2_ORPHAN_NAMELEN ((int)(2 * sizeof(u64)))
+int ocfs2_add_inode_to_orphan(struct ocfs2_super *osb,
+		struct inode *inode)
+{
+	char orphan_name[OCFS2_ORPHAN_NAMELEN + 1];
+	struct inode *orphan_dir_inode = NULL;
+	struct ocfs2_dir_lookup_result orphan_insert = { NULL, };
+	struct buffer_head *di_bh = NULL;
+	int status = 0;
+	handle_t *handle = NULL;
+
+	status = ocfs2_inode_lock(inode, &di_bh, 1);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail;
+	}
+
+	status = ocfs2_prepare_orphan_dir(osb, &orphan_dir_inode,
+			OCFS2_I(inode)->ip_blkno,
+			orphan_name,
+			&orphan_insert);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail_unlock_inode;
+	}
+
+	handle = ocfs2_start_trans(osb, OCFS2_INODE_ADD_TO_ORPHAN_CREDITS);
+	if (IS_ERR(handle)) {
+		status = PTR_ERR(handle);
+		goto bail_unlock_orphan;
+	}
+
+	status = ocfs2_orphan_add(osb, handle, inode, di_bh, orphan_name,
+			&orphan_insert, orphan_dir_inode);
+	if (status)
+		mlog_errno(status);
+
+	ocfs2_commit_trans(osb, handle);
+
+bail_unlock_orphan:
+	ocfs2_inode_unlock(orphan_dir_inode, 1);
+	mutex_unlock(&orphan_dir_inode->i_mutex);
+	iput(orphan_dir_inode);
+
+	ocfs2_free_dir_lookup_result(&orphan_insert);
+
+bail_unlock_inode:
+	ocfs2_inode_unlock(inode, 1);
+	brelse(di_bh);
+
+bail:
+	return status;
+}
+
+int ocfs2_del_inode_from_orphan(struct ocfs2_super *osb,
+		struct inode *inode, int update_isize,
+		loff_t end)
+{
+	struct inode *orphan_dir_inode = NULL;
+	struct buffer_head *orphan_dir_bh = NULL;
+	struct buffer_head *di_bh = NULL;
+	struct ocfs2_dinode *di = NULL;
+	handle_t *handle = NULL;
+	int status = 0;
+
+	status = ocfs2_inode_lock(inode, &di_bh, 1);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail;
+	}
+	di = (struct ocfs2_dinode *) di_bh->b_data;
+
+	orphan_dir_inode = ocfs2_get_system_file_inode(osb,
+			ORPHAN_DIR_SYSTEM_INODE,
+			osb->slot_num);
+	if (!orphan_dir_inode) {
+		status = -EEXIST;
+		mlog_errno(status);
+		goto bail_unlock_inode;
+	}
+
+	mutex_lock(&orphan_dir_inode->i_mutex);
+	status = ocfs2_inode_lock(orphan_dir_inode, &orphan_dir_bh, 1);
+	if (status < 0) {
+		mutex_unlock(&orphan_dir_inode->i_mutex);
+		iput(orphan_dir_inode);
+		mlog_errno(status);
+		goto bail_unlock_inode;
+	}
+
+	handle = ocfs2_start_trans(osb, OCFS2_INODE_DEL_FROM_ORPHAN_CREDITS);
+	if (IS_ERR(handle)) {
+		status = PTR_ERR(handle);
+		goto bail_unlock_orphan;
+	}
+
+	status = ocfs2_orphan_del(osb, handle, orphan_dir_inode,
+			inode, orphan_dir_bh);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail_commit;
+	}
+
+	/*
+	 * We're going to journal the change of i_flags and i_orphaned_slot.
+	 * It's safe anyway, though some callers may duplicate the journaling.
+	 * Journaling within the func just make the logic look more
+	 * straightforward.
+	 */
+	status = ocfs2_journal_access_di(handle,
+			INODE_CACHE(inode),
+			di_bh,
+			OCFS2_JOURNAL_ACCESS_WRITE);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail_commit;
+	}
+
+	di->i_flags &= ~cpu_to_le32(OCFS2_ORPHANED_FL);
+	OCFS2_I(inode)->ip_flags |= OCFS2_INODE_SKIP_ORPHAN_DIR;
+	di->i_orphaned_slot = 0;
+
+	if (update_isize) {
+		status = ocfs2_set_inode_size(handle, inode, di_bh, end);
+		if (status)
+			mlog_errno(status);
+	} else
+		ocfs2_journal_dirty(handle, di_bh);
+
+bail_commit:
+	ocfs2_commit_trans(osb, handle);
+
+bail_unlock_orphan:
+	ocfs2_inode_unlock(orphan_dir_inode, 1);
+	mutex_unlock(&orphan_dir_inode->i_mutex);
+	brelse(orphan_dir_bh);
+	iput(orphan_dir_inode);
+
+bail_unlock_inode:
+	ocfs2_inode_unlock(inode, 1);
+	brelse(di_bh);
+
+bail:
+	return status;
+}
+
 int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
 				   struct inode *inode,
 				   struct dentry *dentry)
diff -puN fs/ocfs2/namei.h~ocfs2-add-two-functions-of-add-and-remove-inode-in-orphan-dir fs/ocfs2/namei.h
--- a/fs/ocfs2/namei.h~ocfs2-add-two-functions-of-add-and-remove-inode-in-orphan-dir
+++ a/fs/ocfs2/namei.h
@@ -51,6 +51,11 @@ int ocfs2_orphan_del(struct ocfs2_super
 int ocfs2_create_inode_in_orphan(struct inode *dir,
 				 int mode,
 				 struct inode **new_inode);
+int ocfs2_add_inode_to_orphan(struct ocfs2_super *osb,
+		struct inode *inode);
+int ocfs2_del_inode_from_orphan(struct ocfs2_super *osb,
+		struct inode *inode, int update_isize,
+		loff_t end);
 int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
 				   struct inode *new_inode,
 				   struct dentry *new_dentry);
_

Patches currently in -mm which might be from wangww631@huawei.com are

ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans.patch
ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io.patch
ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io-fix.patch
ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io-fix-fix.patch
ocfs2-allocate-blocks-in-ocfs2_direct_io_get_blocks.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes-checkpatch-fixes.patch

