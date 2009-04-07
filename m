From: akpm@linux-foundation.org
Subject: [merged] nilfs2-avoid-double-error-caused-by-nilfs_transaction_end.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:09:14 -0700
Message-ID: <200904071909.n37J9ETK012245@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755745AbZDGTLp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:11:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     nilfs2: avoid double error caused by nilfs_transaction_end
has been removed from the -mm tree.  Its filename was
     nilfs2-avoid-double-error-caused-by-nilfs_transaction_end.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: avoid double error caused by nilfs_transaction_end
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Pekka Enberg pointed out that double error handlings found after
nilfs_transaction_end() can be avoided by separating abort operation:

 OK, I don't understand this. The only way nilfs_transaction_end() can
 fail is if we have NILFS_TI_SYNC set and we fail to construct the
 segment. But why do we want to construct a segment if we don't commit?

 I guess what I'm asking is why don't we have a separate
 nilfs_transaction_abort() function that can't fail for the erroneous
 case to avoid this double error value tracking thing?

This does the separation and renames nilfs_transaction_end() to
nilfs_transaction_commit() for clarification.

Since, some calls of these functions were used just for exclusion control
against the segment constructor, they are replaced with semaphore
operations.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c     |   23 +++++++-----
 fs/nilfs2/ioctl.c     |   58 ++++++++++++++++++-------------
 fs/nilfs2/mdt.c       |    5 ++
 fs/nilfs2/namei.c     |   74 +++++++++++++++++++++++++++-------------
 fs/nilfs2/nilfs.h     |    3 +
 fs/nilfs2/segment.c   |   43 +++++++++++++++--------
 fs/nilfs2/the_nilfs.h |    4 +-
 7 files changed, 135 insertions(+), 75 deletions(-)

diff -puN fs/nilfs2/inode.c~nilfs2-avoid-double-error-caused-by-nilfs_transaction_end fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~nilfs2-avoid-double-error-caused-by-nilfs_transaction_end
+++ a/fs/nilfs2/inode.c
@@ -77,7 +77,6 @@ int nilfs_get_block(struct inode *inode,
 			goto out;
 		err = nilfs_bmap_insert(ii->i_bmap, (unsigned long)blkoff,
 					(unsigned long)bh_result);
-		nilfs_transaction_end(inode->i_sb, !err);
 		if (unlikely(err != 0)) {
 			if (err == -EEXIST) {
 				/*
@@ -100,8 +99,10 @@ int nilfs_get_block(struct inode *inode,
 					    inode->i_ino);
 				err = -EIO;
 			}
+			nilfs_transaction_abort(inode->i_sb);
 			goto out;
 		}
+		nilfs_transaction_commit(inode->i_sb); /* never fails */
 		/* Error handling should be detailed */
 		set_buffer_new(bh_result);
 		map_bh(bh_result, inode->i_sb, 0); /* dbn must be changed
@@ -203,7 +204,7 @@ static int nilfs_write_begin(struct file
 	err = block_write_begin(file, mapping, pos, len, flags, pagep,
 				fsdata, nilfs_get_block);
 	if (unlikely(err))
-		nilfs_transaction_end(inode->i_sb, 0);
+		nilfs_transaction_abort(inode->i_sb);
 	return err;
 }
 
@@ -221,7 +222,7 @@ static int nilfs_write_end(struct file *
 	copied = generic_write_end(file, mapping, pos, len, copied, page,
 				   fsdata);
 	nilfs_set_file_dirty(NILFS_SB(inode->i_sb), inode, nr_dirty);
-	err = nilfs_transaction_end(inode->i_sb, 1);
+	err = nilfs_transaction_commit(inode->i_sb);
 	return err ? : copied;
 }
 
@@ -641,7 +642,7 @@ void nilfs_truncate(struct inode *inode)
 		nilfs_set_transaction_flag(NILFS_TI_SYNC);
 
 	nilfs_set_file_dirty(NILFS_SB(sb), inode, 0);
-	nilfs_transaction_end(sb, 1);
+	nilfs_transaction_commit(sb);
 	/* May construct a logical segment and may fail in sync mode.
 	   But truncate has no return value. */
 }
@@ -669,7 +670,7 @@ void nilfs_delete_inode(struct inode *in
 	/* nilfs_free_inode() marks inode buffer dirty */
 	if (IS_SYNC(inode))
 		nilfs_set_transaction_flag(NILFS_TI_SYNC);
-	nilfs_transaction_end(sb, 1);
+	nilfs_transaction_commit(sb);
 	/* May construct a logical segment and may fail in sync mode.
 	   But delete_inode has no return value. */
 }
@@ -679,7 +680,7 @@ int nilfs_setattr(struct dentry *dentry,
 	struct nilfs_transaction_info ti;
 	struct inode *inode = dentry->d_inode;
 	struct super_block *sb = inode->i_sb;
-	int err, err2;
+	int err;
 
 	err = inode_change_ok(inode, iattr);
 	if (err)
@@ -691,8 +692,12 @@ int nilfs_setattr(struct dentry *dentry,
 	err = inode_setattr(inode, iattr);
 	if (!err && (iattr->ia_valid & ATTR_MODE))
 		err = nilfs_acl_chmod(inode);
-	err2 = nilfs_transaction_end(sb, 1);
-	return err ? : err2;
+	if (likely(!err))
+		err = nilfs_transaction_commit(sb);
+	else
+		nilfs_transaction_abort(sb);
+
+	return err;
 }
 
 int nilfs_load_inode_block(struct nilfs_sb_info *sbi, struct inode *inode,
@@ -817,5 +822,5 @@ void nilfs_dirty_inode(struct inode *ino
 	nilfs_transaction_begin(inode->i_sb, &ti, 0);
 	if (likely(inode->i_ino != NILFS_SKETCH_INO))
 		nilfs_mark_inode_dirty(inode);
-	nilfs_transaction_end(inode->i_sb, 1); /* never fails */
+	nilfs_transaction_commit(inode->i_sb); /* never fails */
 }
diff -puN fs/nilfs2/ioctl.c~nilfs2-avoid-double-error-caused-by-nilfs_transaction_end fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~nilfs2-avoid-double-error-caused-by-nilfs_transaction_end
+++ a/fs/nilfs2/ioctl.c
@@ -105,7 +105,11 @@ static int nilfs_ioctl_change_cpmode(str
 	nilfs_transaction_begin(inode->i_sb, &ti, 0);
 	ret = nilfs_cpfile_change_cpmode(
 		cpfile, cpmode.cm_cno, cpmode.cm_mode);
-	nilfs_transaction_end(inode->i_sb, !ret);
+	if (unlikely(ret < 0)) {
+		nilfs_transaction_abort(inode->i_sb);
+		return ret;
+	}
+	nilfs_transaction_commit(inode->i_sb); /* never fails */
 	return ret;
 }
 
@@ -125,7 +129,11 @@ nilfs_ioctl_delete_checkpoint(struct ino
 
 	nilfs_transaction_begin(inode->i_sb, &ti, 0);
 	ret = nilfs_cpfile_delete_checkpoint(cpfile, cno);
-	nilfs_transaction_end(inode->i_sb, !ret);
+	if (unlikely(ret < 0)) {
+		nilfs_transaction_abort(inode->i_sb);
+		return ret;
+	}
+	nilfs_transaction_commit(inode->i_sb); /* never fails */
 	return ret;
 }
 
@@ -142,16 +150,17 @@ static int nilfs_ioctl_get_cpinfo(struct
 {
 	struct the_nilfs *nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
 	struct nilfs_argv argv;
-	struct nilfs_transaction_info ti;
 	int ret;
 
 	if (copy_from_user(&argv, argp, sizeof(argv)))
 		return -EFAULT;
 
-	nilfs_transaction_begin(inode->i_sb, &ti, 0);
+	down_read(&nilfs->ns_segctor_sem);
 	ret = nilfs_ioctl_wrap_copy(nilfs, &argv, _IOC_DIR(cmd),
 				    nilfs_ioctl_do_get_cpinfo);
-	nilfs_transaction_end(inode->i_sb, 0);
+	up_read(&nilfs->ns_segctor_sem);
+	if (ret < 0)
+		return ret;
 
 	if (copy_to_user(argp, &argv, sizeof(argv)))
 		ret = -EFAULT;
@@ -161,14 +170,13 @@ static int nilfs_ioctl_get_cpinfo(struct
 static int nilfs_ioctl_get_cpstat(struct inode *inode, struct file *filp,
 				  unsigned int cmd, void __user *argp)
 {
-	struct inode *cpfile = NILFS_SB(inode->i_sb)->s_nilfs->ns_cpfile;
+	struct the_nilfs *nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
 	struct nilfs_cpstat cpstat;
-	struct nilfs_transaction_info ti;
 	int ret;
 
-	nilfs_transaction_begin(inode->i_sb, &ti, 0);
-	ret = nilfs_cpfile_get_stat(cpfile, &cpstat);
-	nilfs_transaction_end(inode->i_sb, 0);
+	down_read(&nilfs->ns_segctor_sem);
+	ret = nilfs_cpfile_get_stat(nilfs->ns_cpfile, &cpstat);
+	up_read(&nilfs->ns_segctor_sem);
 	if (ret < 0)
 		return ret;
 
@@ -189,16 +197,17 @@ static int nilfs_ioctl_get_suinfo(struct
 {
 	struct the_nilfs *nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
 	struct nilfs_argv argv;
-	struct nilfs_transaction_info ti;
 	int ret;
 
 	if (copy_from_user(&argv, argp, sizeof(argv)))
 		return -EFAULT;
 
-	nilfs_transaction_begin(inode->i_sb, &ti, 0);
+	down_read(&nilfs->ns_segctor_sem);
 	ret = nilfs_ioctl_wrap_copy(nilfs, &argv, _IOC_DIR(cmd),
 				    nilfs_ioctl_do_get_suinfo);
-	nilfs_transaction_end(inode->i_sb, 0);
+	up_read(&nilfs->ns_segctor_sem);
+	if (ret < 0)
+		return ret;
 
 	if (copy_to_user(argp, &argv, sizeof(argv)))
 		ret = -EFAULT;
@@ -208,14 +217,13 @@ static int nilfs_ioctl_get_suinfo(struct
 static int nilfs_ioctl_get_sustat(struct inode *inode, struct file *filp,
 				  unsigned int cmd, void __user *argp)
 {
-	struct inode *sufile = NILFS_SB(inode->i_sb)->s_nilfs->ns_sufile;
+	struct the_nilfs *nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
 	struct nilfs_sustat sustat;
-	struct nilfs_transaction_info ti;
 	int ret;
 
-	nilfs_transaction_begin(inode->i_sb, &ti, 0);
-	ret = nilfs_sufile_get_stat(sufile, &sustat);
-	nilfs_transaction_end(inode->i_sb, 0);
+	down_read(&nilfs->ns_segctor_sem);
+	ret = nilfs_sufile_get_stat(nilfs->ns_sufile, &sustat);
+	up_read(&nilfs->ns_segctor_sem);
 	if (ret < 0)
 		return ret;
 
@@ -236,16 +244,17 @@ static int nilfs_ioctl_get_vinfo(struct 
 {
 	struct the_nilfs *nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
 	struct nilfs_argv argv;
-	struct nilfs_transaction_info ti;
 	int ret;
 
 	if (copy_from_user(&argv, argp, sizeof(argv)))
 		return -EFAULT;
 
-	nilfs_transaction_begin(inode->i_sb, &ti, 0);
+	down_read(&nilfs->ns_segctor_sem);
 	ret = nilfs_ioctl_wrap_copy(nilfs, &argv, _IOC_DIR(cmd),
 				    nilfs_ioctl_do_get_vinfo);
-	nilfs_transaction_end(inode->i_sb, 0);
+	up_read(&nilfs->ns_segctor_sem);
+	if (ret < 0)
+		return ret;
 
 	if (copy_to_user(argp, &argv, sizeof(argv)))
 		ret = -EFAULT;
@@ -280,16 +289,17 @@ static int nilfs_ioctl_get_bdescs(struct
 {
 	struct the_nilfs *nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
 	struct nilfs_argv argv;
-	struct nilfs_transaction_info ti;
 	int ret;
 
 	if (copy_from_user(&argv, argp, sizeof(argv)))
 		return -EFAULT;
 
-	nilfs_transaction_begin(inode->i_sb, &ti, 0);
+	down_read(&nilfs->ns_segctor_sem);
 	ret = nilfs_ioctl_wrap_copy(nilfs, &argv, _IOC_DIR(cmd),
 				    nilfs_ioctl_do_get_bdescs);
-	nilfs_transaction_end(inode->i_sb, 0);
+	up_read(&nilfs->ns_segctor_sem);
+	if (ret < 0)
+		return ret;
 
 	if (copy_to_user(argp, &argv, sizeof(argv)))
 		ret = -EFAULT;
diff -puN fs/nilfs2/mdt.c~nilfs2-avoid-double-error-caused-by-nilfs_transaction_end fs/nilfs2/mdt.c
--- a/fs/nilfs2/mdt.c~nilfs2-avoid-double-error-caused-by-nilfs_transaction_end
+++ a/fs/nilfs2/mdt.c
@@ -123,7 +123,10 @@ static int nilfs_mdt_create_block(struct
 	brelse(bh);
 
  failed_unlock:
-	nilfs_transaction_end(sb, !err);
+	if (likely(!err))
+		err = nilfs_transaction_commit(sb);
+	else
+		nilfs_transaction_abort(sb);
 	if (writer)
 		nilfs_put_writer(nilfs);
  out:
diff -puN fs/nilfs2/namei.c~nilfs2-avoid-double-error-caused-by-nilfs_transaction_end fs/nilfs2/namei.c
--- a/fs/nilfs2/namei.c~nilfs2-avoid-double-error-caused-by-nilfs_transaction_end
+++ a/fs/nilfs2/namei.c
@@ -109,7 +109,7 @@ static int nilfs_create(struct inode *di
 {
 	struct inode *inode;
 	struct nilfs_transaction_info ti;
-	int err, err2;
+	int err;
 
 	err = nilfs_transaction_begin(dir->i_sb, &ti, 1);
 	if (err)
@@ -123,8 +123,12 @@ static int nilfs_create(struct inode *di
 		mark_inode_dirty(inode);
 		err = nilfs_add_nondir(dentry, inode);
 	}
-	err2 = nilfs_transaction_end(dir->i_sb, !err);
-	return err ? : err2;
+	if (!err)
+		err = nilfs_transaction_commit(dir->i_sb);
+	else
+		nilfs_transaction_abort(dir->i_sb);
+
+	return err;
 }
 
 static int
@@ -132,7 +136,7 @@ nilfs_mknod(struct inode *dir, struct de
 {
 	struct inode *inode;
 	struct nilfs_transaction_info ti;
-	int err, err2;
+	int err;
 
 	if (!new_valid_dev(rdev))
 		return -EINVAL;
@@ -147,8 +151,12 @@ nilfs_mknod(struct inode *dir, struct de
 		mark_inode_dirty(inode);
 		err = nilfs_add_nondir(dentry, inode);
 	}
-	err2 = nilfs_transaction_end(dir->i_sb, !err);
-	return err ? : err2;
+	if (!err)
+		err = nilfs_transaction_commit(dir->i_sb);
+	else
+		nilfs_transaction_abort(dir->i_sb);
+
+	return err;
 }
 
 static int nilfs_symlink(struct inode *dir, struct dentry *dentry,
@@ -158,7 +166,7 @@ static int nilfs_symlink(struct inode *d
 	struct super_block *sb = dir->i_sb;
 	unsigned l = strlen(symname)+1;
 	struct inode *inode;
-	int err, err2;
+	int err;
 
 	if (l > sb->s_blocksize)
 		return -ENAMETOOLONG;
@@ -184,8 +192,12 @@ static int nilfs_symlink(struct inode *d
 
 	err = nilfs_add_nondir(dentry, inode);
 out:
-	err2 = nilfs_transaction_end(dir->i_sb, !err);
-	return err ? : err2;
+	if (!err)
+		err = nilfs_transaction_commit(dir->i_sb);
+	else
+		nilfs_transaction_abort(dir->i_sb);
+
+	return err;
 
 out_fail:
 	inode_dec_link_count(inode);
@@ -198,7 +210,7 @@ static int nilfs_link(struct dentry *old
 {
 	struct inode *inode = old_dentry->d_inode;
 	struct nilfs_transaction_info ti;
-	int err, err2;
+	int err;
 
 	if (inode->i_nlink >= NILFS_LINK_MAX)
 		return -EMLINK;
@@ -212,15 +224,19 @@ static int nilfs_link(struct dentry *old
 	atomic_inc(&inode->i_count);
 
 	err = nilfs_add_nondir(dentry, inode);
-	err2 = nilfs_transaction_end(dir->i_sb, !err);
-	return err ? : err2;
+	if (!err)
+		err = nilfs_transaction_commit(dir->i_sb);
+	else
+		nilfs_transaction_abort(dir->i_sb);
+
+	return err;
 }
 
 static int nilfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
 	struct inode *inode;
 	struct nilfs_transaction_info ti;
-	int err, err2;
+	int err;
 
 	if (dir->i_nlink >= NILFS_LINK_MAX)
 		return -EMLINK;
@@ -252,8 +268,12 @@ static int nilfs_mkdir(struct inode *dir
 
 	d_instantiate(dentry, inode);
 out:
-	err2 = nilfs_transaction_end(dir->i_sb, !err);
-	return err ? : err2;
+	if (!err)
+		err = nilfs_transaction_commit(dir->i_sb);
+	else
+		nilfs_transaction_abort(dir->i_sb);
+
+	return err;
 
 out_fail:
 	inode_dec_link_count(inode);
@@ -270,7 +290,7 @@ static int nilfs_unlink(struct inode *di
 	struct nilfs_dir_entry *de;
 	struct page *page;
 	struct nilfs_transaction_info ti;
-	int err, err2;
+	int err;
 
 	err = nilfs_transaction_begin(dir->i_sb, &ti, 0);
 	if (err)
@@ -300,15 +320,19 @@ static int nilfs_unlink(struct inode *di
 	inode_dec_link_count(inode);
 	err = 0;
 out:
-	err2 = nilfs_transaction_end(dir->i_sb, !err);
-	return err ? : err2;
+	if (!err)
+		err = nilfs_transaction_commit(dir->i_sb);
+	else
+		nilfs_transaction_abort(dir->i_sb);
+
+	return err;
 }
 
 static int nilfs_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
 	struct nilfs_transaction_info ti;
-	int err, err2;
+	int err;
 
 	err = nilfs_transaction_begin(dir->i_sb, &ti, 0);
 	if (err)
@@ -323,8 +347,12 @@ static int nilfs_rmdir(struct inode *dir
 			inode_dec_link_count(dir);
 		}
 	}
-	err2 = nilfs_transaction_end(dir->i_sb, !err);
-	return err ? : err2;
+	if (!err)
+		err = nilfs_transaction_commit(dir->i_sb);
+	else
+		nilfs_transaction_abort(dir->i_sb);
+
+	return err;
 }
 
 static int nilfs_rename(struct inode *old_dir, struct dentry *old_dentry,
@@ -404,7 +432,7 @@ static int nilfs_rename(struct inode *ol
 		inode_dec_link_count(old_dir);
 	}
 
-	err = nilfs_transaction_end(old_dir->i_sb, 1);
+	err = nilfs_transaction_commit(old_dir->i_sb);
 	return err;
 
 out_dir:
@@ -416,7 +444,7 @@ out_old:
 	kunmap(old_page);
 	page_cache_release(old_page);
 out:
-	nilfs_transaction_end(old_dir->i_sb, 0);
+	nilfs_transaction_abort(old_dir->i_sb);
 	return err;
 }
 
diff -puN fs/nilfs2/nilfs.h~nilfs2-avoid-double-error-caused-by-nilfs_transaction_end fs/nilfs2/nilfs.h
--- a/fs/nilfs2/nilfs.h~nilfs2-avoid-double-error-caused-by-nilfs_transaction_end
+++ a/fs/nilfs2/nilfs.h
@@ -166,7 +166,8 @@ struct nilfs_transaction_info {
 
 int nilfs_transaction_begin(struct super_block *,
 			    struct nilfs_transaction_info *, int);
-int nilfs_transaction_end(struct super_block *, int);
+int nilfs_transaction_commit(struct super_block *);
+void nilfs_transaction_abort(struct super_block *);
 
 static inline void nilfs_set_transaction_flag(unsigned int flag)
 {
diff -puN fs/nilfs2/segment.c~nilfs2-avoid-double-error-caused-by-nilfs_transaction_end fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-avoid-double-error-caused-by-nilfs_transaction_end
+++ a/fs/nilfs2/segment.c
@@ -163,8 +163,8 @@ static int nilfs_prepare_segment_lock(st
 		else {
 			/*
 			 * If journal_info field is occupied by other FS,
-			 * we save it and restore on nilfs_transaction_end().
-			 * But this should never happen.
+			 * it is saved and will be restored on
+			 * nilfs_transaction_commit().
 			 */
 			printk(KERN_WARNING
 			       "NILFS warning: journal info from a different "
@@ -195,7 +195,7 @@ static int nilfs_prepare_segment_lock(st
  *
  * nilfs_transaction_begin() acquires a reader/writer semaphore, called
  * the segment semaphore, to make a segment construction and write tasks
- * exclusive.  The function is used with nilfs_transaction_end() in pairs.
+ * exclusive.  The function is used with nilfs_transaction_commit() in pairs.
  * The region enclosed by these two functions can be nested.  To avoid a
  * deadlock, the semaphore is only acquired or released in the outermost call.
  *
@@ -212,8 +212,6 @@ static int nilfs_prepare_segment_lock(st
  *
  * %-ENOMEM - Insufficient memory available.
  *
- * %-ERESTARTSYS - Interrupted
- *
  * %-ENOSPC - No space left on device
  */
 int nilfs_transaction_begin(struct super_block *sb,
@@ -248,16 +246,17 @@ int nilfs_transaction_begin(struct super
 }
 
 /**
- * nilfs_transaction_end - end indivisible file operations.
+ * nilfs_transaction_commit - commit indivisible file operations.
  * @sb: super block
- * @commit: commit flag (0 for no change)
  *
- * nilfs_transaction_end() releases the read semaphore which is
- * acquired by nilfs_transaction_begin(). Its releasing is only done
- * in outermost call of this function. If the nilfs_transaction_info
- * was allocated dynamically, it is given back to a slab cache.
+ * nilfs_transaction_commit() releases the read semaphore which is
+ * acquired by nilfs_transaction_begin(). This is only performed
+ * in outermost call of this function.  If a commit flag is set,
+ * nilfs_transaction_commit() sets a timer to start the segment
+ * constructor.  If a sync flag is set, it starts construction
+ * directly.
  */
-int nilfs_transaction_end(struct super_block *sb, int commit)
+int nilfs_transaction_commit(struct super_block *sb)
 {
 	struct nilfs_transaction_info *ti = current->journal_info;
 	struct nilfs_sb_info *sbi;
@@ -265,9 +264,7 @@ int nilfs_transaction_end(struct super_b
 	int err = 0;
 
 	BUG_ON(ti == NULL || ti->ti_magic != NILFS_TI_MAGIC);
-
-	if (commit)
-		ti->ti_flags |= NILFS_TI_COMMIT;
+	ti->ti_flags |= NILFS_TI_COMMIT;
 	if (ti->ti_count > 0) {
 		ti->ti_count--;
 		return 0;
@@ -291,6 +288,22 @@ int nilfs_transaction_end(struct super_b
 	return err;
 }
 
+void nilfs_transaction_abort(struct super_block *sb)
+{
+	struct nilfs_transaction_info *ti = current->journal_info;
+
+	BUG_ON(ti == NULL || ti->ti_magic != NILFS_TI_MAGIC);
+	if (ti->ti_count > 0) {
+		ti->ti_count--;
+		return;
+	}
+	up_read(&NILFS_SB(sb)->s_nilfs->ns_segctor_sem);
+
+	current->journal_info = ti->ti_save;
+	if (ti->ti_flags & NILFS_TI_DYNAMIC_ALLOC)
+		kmem_cache_free(nilfs_transaction_cachep, ti);
+}
+
 void nilfs_relax_pressure_in_lock(struct super_block *sb)
 {
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
diff -puN fs/nilfs2/the_nilfs.h~nilfs2-avoid-double-error-caused-by-nilfs_transaction_end fs/nilfs2/the_nilfs.h
--- a/fs/nilfs2/the_nilfs.h~nilfs2-avoid-double-error-caused-by-nilfs_transaction_end
+++ a/fs/nilfs2/the_nilfs.h
@@ -112,8 +112,8 @@ struct the_nilfs {
 	/*
 	 * Following fields are dedicated to a writable FS-instance.
 	 * Except for the period seeking checkpoint, code outside the segment
-	 * constructor must lock a segment semaphore with transaction_begin()
-	 * and transaction_end(), when accessing these fields.
+	 * constructor must lock a segment semaphore while accessing these
+	 * fields.
 	 * The writable FS-instance is sole during a lifetime of the_nilfs.
 	 */
 	u64			ns_seg_seq;
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

origin.patch

