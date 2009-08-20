From: akpm@linux-foundation.org
Subject: + btrfs-convert-to-use-the-new-truncate-convention.patch added to -mm tree
Date: Thu, 20 Aug 2009 15:48:33 -0700
Message-ID: <200908202248.n7KMmXfs029817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755039AbZHTWtb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 18:49:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, chris.mason@oracle.com, hch@lst.de, hirofumi@mail.parknet.co.jp, hugh.dickins@tiscali.co.uk, jack@suse.cz, miklos@szeredi.hu, sfrench@us.ibm.com, shaggy@linux.vnet.ibm.com, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk


The patch titled
     btrfs: convert to use the new truncate convention
has been added to the -mm tree.  Its filename is
     btrfs-convert-to-use-the-new-truncate-convention.patch

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
Subject: btrfs: convert to use the new truncate convention
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Steven French <sfrench@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/ctree.h |    1 
 fs/btrfs/inode.c |  132 ++++++++++++++++++++++++++++-----------------
 fs/btrfs/ioctl.c |    2 
 3 files changed, 86 insertions(+), 49 deletions(-)

diff -puN fs/btrfs/ctree.h~btrfs-convert-to-use-the-new-truncate-convention fs/btrfs/ctree.h
--- a/fs/btrfs/ctree.h~btrfs-convert-to-use-the-new-truncate-convention
+++ a/fs/btrfs/ctree.h
@@ -2275,6 +2275,7 @@ int btrfs_orphan_add(struct btrfs_trans_
 int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode);
 void btrfs_orphan_cleanup(struct btrfs_root *root);
 int btrfs_cont_expand(struct inode *inode, loff_t size);
+void btrfs_truncate_blocks(struct inode *inode, loff_t offset);
 
 /* ioctl.c */
 long btrfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
diff -puN fs/btrfs/inode.c~btrfs-convert-to-use-the-new-truncate-convention fs/btrfs/inode.c
--- a/fs/btrfs/inode.c~btrfs-convert-to-use-the-new-truncate-convention
+++ a/fs/btrfs/inode.c
@@ -81,7 +81,6 @@ static unsigned char btrfs_type_by_mode[
 	[S_IFLNK >> S_SHIFT]	= BTRFS_FT_SYMLINK,
 };
 
-static void btrfs_truncate(struct inode *inode);
 static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end);
 static noinline int cow_file_range(struct inode *inode,
 				   struct page *locked_page,
@@ -1990,7 +1989,7 @@ void btrfs_orphan_cleanup(struct btrfs_r
 		/* if we have links, this was a truncate, lets do that */
 		if (inode->i_nlink) {
 			nr_truncate++;
-			btrfs_truncate(inode);
+			btrfs_truncate_blocks(inode, inode->i_size);
 		} else {
 			nr_unlink++;
 		}
@@ -2956,39 +2955,6 @@ int btrfs_cont_expand(struct inode *inod
 	return err;
 }
 
-static int btrfs_setattr(struct dentry *dentry, struct iattr *attr)
-{
-	struct inode *inode = dentry->d_inode;
-	int err;
-
-	err = inode_change_ok(inode, attr);
-	if (err)
-		return err;
-
-	if (S_ISREG(inode->i_mode) && (attr->ia_valid & ATTR_SIZE)) {
-		if (attr->ia_size > inode->i_size) {
-			err = btrfs_cont_expand(inode, attr->ia_size);
-			if (err)
-				return err;
-		} else if (inode->i_size > 0 &&
-			   attr->ia_size == 0) {
-
-			/* we're truncating a file that used to have good
-			 * data down to zero.  Make sure it gets into
-			 * the ordered flush list so that any new writes
-			 * get down to disk quickly.
-			 */
-			BTRFS_I(inode)->ordered_data_close = 1;
-		}
-	}
-
-	err = inode_setattr(inode, attr);
-
-	if (!err && ((attr->ia_valid & ATTR_MODE)))
-		err = btrfs_acl_chmod(inode);
-	return err;
-}
-
 void btrfs_delete_inode(struct inode *inode)
 {
 	struct btrfs_trans_handle *trans;
@@ -4438,7 +4404,7 @@ static void btrfs_invalidatepage(struct 
  *
  * We are not allowed to take the i_mutex here so we have to play games to
  * protect against truncate races as the page could now be beyond EOF.  Because
- * vmtruncate() writes the inode size before removing pages, once we have the
+ * btrfs_setsize() writes the inode size before removing pages, once we have the
  * page lock we can determine safely if the page is beyond EOF. If it is not
  * beyond EOF, then the page is guaranteed safe against truncation until we
  * unlock the page.
@@ -4524,7 +4490,7 @@ out:
 	return ret;
 }
 
-static void btrfs_truncate(struct inode *inode)
+static void __btrfs_truncate_blocks(struct inode *inode, loff_t offset)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
@@ -4532,13 +4498,8 @@ static void btrfs_truncate(struct inode 
 	unsigned long nr;
 	u64 mask = root->sectorsize - 1;
 
-	if (!S_ISREG(inode->i_mode))
-		return;
-	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
-		return;
-
-	btrfs_truncate_page(inode->i_mapping, inode->i_size);
-	btrfs_wait_ordered_range(inode, inode->i_size & (~mask), (u64)-1);
+	btrfs_truncate_page(inode->i_mapping, offset);
+	btrfs_wait_ordered_range(inode, offset & (~mask), (u64)-1);
 
 	trans = btrfs_start_transaction(root, 1);
 
@@ -4559,17 +4520,17 @@ static void btrfs_truncate(struct inode 
 	 * using truncate to replace the contents of the file will
 	 * end up with a zero length file after a crash.
 	 */
-	if (inode->i_size == 0 && BTRFS_I(inode)->ordered_data_close)
+	if (offset == 0 && BTRFS_I(inode)->ordered_data_close)
 		btrfs_add_ordered_operation(trans, root, inode);
 
 	btrfs_set_trans_block_group(trans, inode);
-	btrfs_i_size_write(inode, inode->i_size);
+	btrfs_i_size_write(inode, offset);
 
 	ret = btrfs_orphan_add(trans, inode);
 	if (ret)
 		goto out;
 	/* FIXME, add redo link to tree so we don't leak on crash */
-	ret = btrfs_truncate_inode_items(trans, root, inode, inode->i_size,
+	ret = btrfs_truncate_inode_items(trans, root, inode, offset,
 				      BTRFS_EXTENT_DATA_KEY);
 	btrfs_update_inode(trans, root, inode);
 
@@ -4583,6 +4544,81 @@ out:
 	btrfs_btree_balance_dirty(root, nr);
 }
 
+void btrfs_truncate_blocks(struct inode *inode, loff_t offset)
+{
+	if (!S_ISREG(inode->i_mode))
+		return;
+	/* XXX: should allow IS_APPEND and IS_IMMUTABLE files to have
+	 * blocks trimmed past i_size */
+	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
+		return;
+
+	__btrfs_truncate_blocks(inode, offset);
+	mark_inode_dirty(inode);
+}
+
+static int btrfs_setsize(struct inode *inode, loff_t newsize)
+{
+	int error;
+	loff_t oldsize;
+
+	if (!S_ISREG(inode->i_mode))
+		return -EINVAL;
+	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
+		return -EPERM;
+
+	error = inode_newsize_ok(inode, newsize);
+	if (error)
+		return error;
+
+	oldsize = inode->i_size;
+	__btrfs_truncate_blocks(inode, newsize);
+	truncate_pagecache(inode, oldsize, newsize);
+
+	return error;
+}
+
+static int btrfs_setattr(struct dentry *dentry, struct iattr *attr)
+{
+	struct inode *inode = dentry->d_inode;
+	int err;
+
+	err = inode_change_ok(inode, attr);
+	if (err)
+		return err;
+
+	if (S_ISREG(inode->i_mode) && (attr->ia_valid & ATTR_SIZE)) {
+		loff_t newsize = attr->ia_size;
+
+		if (newsize > inode->i_size) {
+			err = btrfs_cont_expand(inode, newsize);
+			if (err)
+				return err;
+		} else if (inode->i_size > 0 &&
+			   newsize == 0) {
+
+			/* we're truncating a file that used to have good
+			 * data down to zero.  Make sure it gets into
+			 * the ordered flush list so that any new writes
+			 * get down to disk quickly.
+			 */
+			BTRFS_I(inode)->ordered_data_close = 1;
+		}
+
+		err = btrfs_setsize(inode, newsize);
+		if (err)
+			return err;
+	}
+
+	generic_setattr(inode, attr);
+
+	if ((attr->ia_valid & ATTR_MODE))
+		err = btrfs_acl_chmod(inode);
+	mark_inode_dirty(inode);
+
+	return err;
+}
+
 /*
  * create a new subvolume directory/inode (helper for the ioctl).
  */
@@ -5272,7 +5308,7 @@ static struct address_space_operations b
 };
 
 static struct inode_operations btrfs_file_inode_operations = {
-	.truncate	= btrfs_truncate,
+	.new_truncate	= 1,
 	.getattr	= btrfs_getattr,
 	.setattr	= btrfs_setattr,
 	.setxattr	= btrfs_setxattr,
diff -puN fs/btrfs/ioctl.c~btrfs-convert-to-use-the-new-truncate-convention fs/btrfs/ioctl.c
--- a/fs/btrfs/ioctl.c~btrfs-convert-to-use-the-new-truncate-convention
+++ a/fs/btrfs/ioctl.c
@@ -1148,7 +1148,7 @@ out:
 	btrfs_end_transaction(trans, root);
 	unlock_extent(&BTRFS_I(src)->io_tree, off, off+len, GFP_NOFS);
 	if (ret)
-		vmtruncate(inode, 0);
+		btrfs_truncate_blocks(inode, 0);
 out_unlock:
 	mutex_unlock(&src->i_mutex);
 	mutex_unlock(&inode->i_mutex);
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
ksm-no-debug-in-page_dup_rmap.patch
fs-turn-iprune_mutex-into-rwsem.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

