From: akpm@linux-foundation.org
Subject: + nilfs2-pathname-operations.patch added to -mm tree
Date: Wed, 17 Sep 2008 13:28:01 -0700
Message-ID: <200809172028.m8HKS2dU029010@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753892AbYIQU2F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 16:28:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konishi.ryusuke@lab.ntt.co.jp


The patch titled
     nilfs2: pathname operations
has been added to the -mm tree.  Its filename is
     nilfs2-pathname-operations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: pathname operations
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This adds pathname operations, most of which comes from the ext2 file
system.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/namei.c |  452 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 452 insertions(+)

diff -puN /dev/null fs/nilfs2/namei.c
--- /dev/null
+++ a/fs/nilfs2/namei.c
@@ -0,0 +1,452 @@
+/*
+ * namei.c - NILFS pathname lookup operations.
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Modified for NILFS by Amagai Yoshiji <amagai@osrg.net>,
+ *                       Ryusuke Konishi <ryusuke@osrg.net>
+ */
+/*
+ *  linux/fs/ext2/namei.c
+ *
+ * Copyright (C) 1992, 1993, 1994, 1995
+ * Remy Card (card@masi.ibp.fr)
+ * Laboratoire MASI - Institut Blaise Pascal
+ * Universite Pierre et Marie Curie (Paris VI)
+ *
+ *  from
+ *
+ *  linux/fs/minix/namei.c
+ *
+ *  Copyright (C) 1991, 1992  Linus Torvalds
+ *
+ *  Big-endian to little-endian byte-swapping/bitmaps by
+ *        David S. Miller (davem@caip.rutgers.edu), 1995
+ */
+
+#include <linux/pagemap.h>
+#include "nilfs.h"
+
+
+static inline int nilfs_add_nondir(struct dentry *dentry, struct inode *inode)
+{
+	int err = nilfs_add_link(dentry, inode);
+	if (!err) {
+		d_instantiate(dentry, inode);
+		return 0;
+	}
+	inode_dec_link_count(inode);
+	iput(inode);
+	return err;
+}
+
+/*
+ * Methods themselves.
+ */
+
+static struct dentry *
+nilfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+{
+	struct inode *inode;
+	ino_t ino;
+
+	if (dentry->d_name.len > NILFS_NAME_LEN)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	ino = nilfs_inode_by_name(dir, dentry);
+	inode = NULL;
+	if (ino) {
+		inode = nilfs_iget(dir->i_sb, ino);
+		if (IS_ERR(inode))
+			return ERR_CAST(inode);
+	}
+	return d_splice_alias(inode, dentry);
+}
+
+struct dentry *nilfs_get_parent(struct dentry *child)
+{
+	unsigned long ino;
+	struct dentry *parent;
+	struct inode *inode;
+	struct dentry dotdot;
+
+	dotdot.d_name.name = "..";
+	dotdot.d_name.len = 2;
+
+	ino = nilfs_inode_by_name(child->d_inode, &dotdot);
+	if (!ino)
+		return ERR_PTR(-ENOENT);
+
+	inode = nilfs_iget(child->d_inode->i_sb, ino);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+	parent = d_alloc_anon(inode);
+	if (!parent) {
+		iput(inode);
+		parent = ERR_PTR(-ENOMEM);
+	}
+	return parent;
+}
+
+/*
+ * By the time this is called, we already have created
+ * the directory cache entry for the new file, but it
+ * is so far negative - it has no inode.
+ *
+ * If the create succeeds, we fill in the inode information
+ * with d_instantiate().
+ */
+static int nilfs_create(struct inode *dir, struct dentry *dentry, int mode,
+			struct nameidata *nd)
+{
+	struct inode *inode;
+	struct nilfs_transaction_info ti;
+	int err, err2;
+
+	err = nilfs_transaction_begin(dir->i_sb, &ti, 1);
+	if (err)
+		return err;
+	inode = nilfs_new_inode(dir, mode);
+	err = PTR_ERR(inode);
+	if (!IS_ERR(inode)) {
+		inode->i_op = &nilfs_file_inode_operations;
+		inode->i_fop = &nilfs_file_operations;
+		inode->i_mapping->a_ops = &nilfs_aops;
+		mark_inode_dirty(inode);
+		err = nilfs_add_nondir(dentry, inode);
+	}
+	err2 = nilfs_transaction_end(dir->i_sb, !err);
+	return err ? : err2;
+}
+
+static int
+nilfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t rdev)
+{
+	struct inode *inode;
+	struct nilfs_transaction_info ti;
+	int err, err2;
+
+	if (!new_valid_dev(rdev))
+		return -EINVAL;
+
+	err = nilfs_transaction_begin(dir->i_sb, &ti, 1);
+	if (err)
+		return err;
+	inode = nilfs_new_inode(dir, mode);
+	err = PTR_ERR(inode);
+	if (!IS_ERR(inode)) {
+		init_special_inode(inode, inode->i_mode, rdev);
+		mark_inode_dirty(inode);
+		err = nilfs_add_nondir(dentry, inode);
+	}
+	err2 = nilfs_transaction_end(dir->i_sb, !err);
+	return err ? : err2;
+}
+
+static int nilfs_symlink(struct inode *dir, struct dentry *dentry,
+			 const char *symname)
+{
+	struct nilfs_transaction_info ti;
+	struct super_block *sb = dir->i_sb;
+	unsigned l = strlen(symname)+1;
+	struct inode *inode;
+	int err, err2;
+
+	if (l > sb->s_blocksize)
+		return -ENAMETOOLONG;
+
+	err = nilfs_transaction_begin(dir->i_sb, &ti, 1);
+	if (err)
+		return err;
+
+	inode = nilfs_new_inode(dir, S_IFLNK | S_IRWXUGO);
+	err = PTR_ERR(inode);
+	if (IS_ERR(inode))
+		goto out;
+
+	/* slow symlink */
+	inode->i_op = &nilfs_symlink_inode_operations;
+	inode->i_mapping->a_ops = &nilfs_aops;
+	err = page_symlink(inode, symname, l);
+	if (err)
+		goto out_fail;
+
+	/* mark_inode_dirty(inode); */
+	/* nilfs_new_inode() and page_symlink() do this */
+
+	err = nilfs_add_nondir(dentry, inode);
+out:
+	err2 = nilfs_transaction_end(dir->i_sb, !err);
+	return err ? : err2;
+
+out_fail:
+	inode_dec_link_count(inode);
+	iput(inode);
+	goto out;
+}
+
+static int nilfs_link(struct dentry *old_dentry, struct inode *dir,
+		      struct dentry *dentry)
+{
+	struct inode *inode = old_dentry->d_inode;
+	struct nilfs_transaction_info ti;
+	int err, err2;
+
+	if (inode->i_nlink >= NILFS_LINK_MAX)
+		return -EMLINK;
+
+	err = nilfs_transaction_begin(dir->i_sb, &ti, 1);
+	if (err)
+		return err;
+
+	inode->i_ctime = CURRENT_TIME;
+	inode_inc_link_count(inode);
+	atomic_inc(&inode->i_count);
+
+	err = nilfs_add_nondir(dentry, inode);
+	err2 = nilfs_transaction_end(dir->i_sb, !err);
+	return err ? : err2;
+}
+
+static int nilfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+{
+	struct inode *inode;
+	struct nilfs_transaction_info ti;
+	int err, err2;
+
+	if (dir->i_nlink >= NILFS_LINK_MAX)
+		return -EMLINK;
+
+	err = nilfs_transaction_begin(dir->i_sb, &ti, 1);
+	if (err)
+		return err;
+
+	inode_inc_link_count(dir);
+
+	inode = nilfs_new_inode(dir, S_IFDIR | mode);
+	err = PTR_ERR(inode);
+	if (IS_ERR(inode))
+		goto out_dir;
+
+	inode->i_op = &nilfs_dir_inode_operations;
+	inode->i_fop = &nilfs_dir_operations;
+	inode->i_mapping->a_ops = &nilfs_aops;
+
+	inode_inc_link_count(inode);
+
+	err = nilfs_make_empty(inode, dir);
+	if (err)
+		goto out_fail;
+
+	err = nilfs_add_link(dentry, inode);
+	if (err)
+		goto out_fail;
+
+	d_instantiate(dentry, inode);
+out:
+	err2 = nilfs_transaction_end(dir->i_sb, !err);
+	return err ? : err2;
+
+out_fail:
+	inode_dec_link_count(inode);
+	inode_dec_link_count(inode);
+	iput(inode);
+out_dir:
+	inode_dec_link_count(dir);
+	goto out;
+}
+
+static int nilfs_unlink(struct inode *dir, struct dentry *dentry)
+{
+	struct inode *inode;
+	struct nilfs_dir_entry *de;
+	struct page *page;
+	struct nilfs_transaction_info ti;
+	int err, err2;
+
+	err = nilfs_transaction_begin(dir->i_sb, &ti, 0);
+	if (err)
+		return err;
+
+	err = -ENOENT;
+	de = nilfs_find_entry(dir, dentry, &page);
+	if (!de)
+		goto out;
+
+	inode = dentry->d_inode;
+	err = -EIO;
+	if (le64_to_cpu(de->inode) != inode->i_ino)
+		goto out;
+
+	if (!inode->i_nlink) {
+		nilfs_warning(inode->i_sb, __func__,
+			      "deleting nonexistent file (%lu), %d\n",
+			      inode->i_ino, inode->i_nlink);
+		inode->i_nlink = 1;
+	}
+	err = nilfs_delete_entry(de, page);
+	if (err)
+		goto out;
+
+	inode->i_ctime = dir->i_ctime;
+	inode_dec_link_count(inode);
+	err = 0;
+out:
+	err2 = nilfs_transaction_end(dir->i_sb, !err);
+	return err ? : err2;
+}
+
+static int nilfs_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+	struct nilfs_transaction_info ti;
+	int err, err2;
+
+	err = nilfs_transaction_begin(dir->i_sb, &ti, 0);
+	if (err)
+		return err;
+
+	err = -ENOTEMPTY;
+	if (nilfs_empty_dir(inode)) {
+		err = nilfs_unlink(dir, dentry);
+		if (!err) {
+			inode->i_size = 0;
+			inode_dec_link_count(inode);
+			inode_dec_link_count(dir);
+		}
+	}
+	err2 = nilfs_transaction_end(dir->i_sb, !err);
+	return err ? : err2;
+}
+
+static int nilfs_rename(struct inode *old_dir, struct dentry *old_dentry,
+			struct inode *new_dir,	struct dentry *new_dentry)
+{
+	struct inode *old_inode = old_dentry->d_inode;
+	struct inode *new_inode = new_dentry->d_inode;
+	struct page *dir_page = NULL;
+	struct nilfs_dir_entry *dir_de = NULL;
+	struct page *old_page;
+	struct nilfs_dir_entry *old_de;
+	struct nilfs_transaction_info ti;
+	int err;
+
+	err = nilfs_transaction_begin(old_dir->i_sb, &ti, 1);
+	if (unlikely(err))
+		return err;
+
+	err = -ENOENT;
+	old_de = nilfs_find_entry(old_dir, old_dentry, &old_page);
+	if (!old_de)
+		goto out;
+
+	if (S_ISDIR(old_inode->i_mode)) {
+		err = -EIO;
+		dir_de = nilfs_dotdot(old_inode, &dir_page);
+		if (!dir_de)
+			goto out_old;
+	}
+
+	if (new_inode) {
+		struct page *new_page;
+		struct nilfs_dir_entry *new_de;
+
+		err = -ENOTEMPTY;
+		if (dir_de && !nilfs_empty_dir(new_inode))
+			goto out_dir;
+
+		err = -ENOENT;
+		new_de = nilfs_find_entry(new_dir, new_dentry, &new_page);
+		if (!new_de)
+			goto out_dir;
+		inode_inc_link_count(old_inode);
+		nilfs_set_link(new_dir, new_de, new_page, old_inode);
+		new_inode->i_ctime = CURRENT_TIME;
+		if (dir_de)
+			drop_nlink(new_inode);
+		inode_dec_link_count(new_inode);
+	} else {
+		if (dir_de) {
+			err = -EMLINK;
+			if (new_dir->i_nlink >= NILFS_LINK_MAX)
+				goto out_dir;
+		}
+		inode_inc_link_count(old_inode);
+		err = nilfs_add_link(new_dentry, old_inode);
+		if (err) {
+			inode_dec_link_count(old_inode);
+			goto out_dir;
+		}
+		if (dir_de)
+			inode_inc_link_count(new_dir);
+	}
+
+	/*
+	 * Like most other Unix systems, set the ctime for inodes on a
+	 * rename.
+	 * inode_dec_link_count() will mark the inode dirty.
+	 */
+	old_inode->i_ctime = CURRENT_TIME;
+
+	nilfs_delete_entry(old_de, old_page);
+	inode_dec_link_count(old_inode);
+
+	if (dir_de) {
+		nilfs_set_link(old_inode, dir_de, dir_page, new_dir);
+		inode_dec_link_count(old_dir);
+	}
+
+	err = nilfs_transaction_end(old_dir->i_sb, 1);
+	return err;
+
+out_dir:
+	if (dir_de) {
+		kunmap(dir_page);
+		page_cache_release(dir_page);
+	}
+out_old:
+	kunmap(old_page);
+	page_cache_release(old_page);
+out:
+	nilfs_transaction_end(old_dir->i_sb, 0);
+	return err;
+}
+
+struct inode_operations nilfs_dir_inode_operations = {
+	.create		= nilfs_create,
+	.lookup		= nilfs_lookup,
+	.link		= nilfs_link,
+	.unlink		= nilfs_unlink,
+	.symlink	= nilfs_symlink,
+	.mkdir		= nilfs_mkdir,
+	.rmdir		= nilfs_rmdir,
+	.mknod		= nilfs_mknod,
+	.rename		= nilfs_rename,
+	.setattr	= nilfs_setattr,
+	.permission	= nilfs_permission,
+};
+
+struct inode_operations nilfs_special_inode_operations = {
+	.setattr	= nilfs_setattr,
+	.permission	= nilfs_permission,
+};
+
+struct inode_operations nilfs_symlink_inode_operations = {
+	.readlink	= generic_readlink,
+	.follow_link	= page_follow_link_light,
+	.put_link	= page_put_link,
+};
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-add-document.patch
nilfs2-disk-format-and-userland-interface.patch
nilfs2-add-inode-and-other-major-structures.patch
nilfs2-integrated-block-mapping.patch
nilfs2-b-tree-based-block-mapping.patch
nilfs2-direct-block-mapping.patch
nilfs2-b-tree-node-cache.patch
nilfs2-buffer-and-page-operations.patch
nilfs2-meta-data-file.patch
nilfs2-persistent-object-allocator.patch
nilfs2-disk-address-translator.patch
nilfs2-inode-map-file.patch
nilfs2-checkpoint-file.patch
nilfs2-segment-usage-file.patch
nilfs2-inode-operations.patch
nilfs2-file-operations.patch
nilfs2-directory-entry-operations.patch
nilfs2-pathname-operations.patch
nilfs2-operations-for-the_nilfs-core-object.patch
nilfs2-super-block-operations.patch
nilfs2-segment-buffer.patch
nilfs2-segment-constructor.patch
nilfs2-recovery-functions.patch
nilfs2-another-dat-for-garbage-collection.patch
nilfs2-block-cache-for-garbage-collection.patch
nilfs2-ioctl-operations.patch
nilfs2-update-makefile-and-kconfig.patch

