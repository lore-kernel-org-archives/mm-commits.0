From: akpm@linux-foundation.org
Subject: + minix-convert-to-use-the-new-truncate-convention.patch added to -mm tree
Date: Thu, 20 Aug 2009 15:48:39 -0700
Message-ID: <200908202248.n7KMmdAJ030008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932086AbZHTWts (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 18:49:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, chris.mason@oracle.com, hch@lst.de, hirofumi@mail.parknet.co.jp, hugh.dickins@tiscali.co.uk, jack@suse.cz, miklos@szeredi.hu, sfrench@us.ibm.com, shaggy@linux.vnet.ibm.com, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk


The patch titled
     minix: convert to use the new truncate convention
has been added to the -mm tree.  Its filename is
     minix-convert-to-use-the-new-truncate-convention.patch

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
Subject: minix: convert to use the new truncate convention
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Steven French <sfrench@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/file.c         |    3 -
 fs/minix/inode.c        |   82 ++++++++++++++++++++++++++++++++++----
 fs/minix/itree_common.c |    5 --
 fs/minix/itree_v1.c     |    4 -
 fs/minix/itree_v2.c     |    4 -
 fs/minix/minix.h        |    6 +-
 6 files changed, 85 insertions(+), 19 deletions(-)

diff -puN fs/minix/file.c~minix-convert-to-use-the-new-truncate-convention fs/minix/file.c
--- a/fs/minix/file.c~minix-convert-to-use-the-new-truncate-convention
+++ a/fs/minix/file.c
@@ -24,6 +24,7 @@ const struct file_operations minix_file_
 };
 
 const struct inode_operations minix_file_inode_operations = {
-	.truncate	= minix_truncate,
+	.new_truncate	= 1,
+	.setattr	= minix_setattr,
 	.getattr	= minix_getattr,
 };
diff -puN fs/minix/inode.c~minix-convert-to-use-the-new-truncate-convention fs/minix/inode.c
--- a/fs/minix/inode.c~minix-convert-to-use-the-new-truncate-convention
+++ a/fs/minix/inode.c
@@ -18,15 +18,16 @@
 #include <linux/highuid.h>
 #include <linux/vfs.h>
 
-static int minix_write_inode(struct inode * inode, int wait);
+static int minix_write_inode(struct inode *inode, int wait);
 static int minix_statfs(struct dentry *dentry, struct kstatfs *buf);
-static int minix_remount (struct super_block * sb, int * flags, char * data);
+static int minix_remount(struct super_block *sb, int *flags, char *data);
+static void minix_truncate_blocks(struct inode *inode, loff_t offset);
 
 static void minix_delete_inode(struct inode *inode)
 {
 	truncate_inode_pages(&inode->i_data, 0);
 	inode->i_size = 0;
-	minix_truncate(inode);
+	minix_truncate_blocks(inode, 0);
 	minix_free_inode(inode);
 }
 
@@ -367,8 +368,33 @@ static int minix_write_begin(struct file
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
 {
+	int ret;
+
 	*pagep = NULL;
-	return __minix_write_begin(file, mapping, pos, len, flags, pagep, fsdata);
+	ret = __minix_write_begin(file, mapping, pos, len, flags, pagep,fsdata);
+	if (ret < 0) {
+		struct inode *inode = mapping->host;
+		loff_t isize = inode->i_size;
+		if (pos + len > isize)
+			minix_truncate_blocks(inode, isize);
+	}
+	return ret;
+}
+
+static int minix_write_end(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *page, void *fsdata)
+{
+	int ret;
+
+	ret = generic_write_end(file, mapping, pos, len, copied, page, fsdata);
+	if (ret < len) {
+		struct inode *inode = mapping->host;
+		loff_t isize = inode->i_size;
+		if (pos + len > isize)
+			minix_truncate_blocks(inode, isize);
+	}
+	return ret;
 }
 
 static sector_t minix_bmap(struct address_space *mapping, sector_t block)
@@ -381,7 +407,7 @@ static const struct address_space_operat
 	.writepage = minix_writepage,
 	.sync_page = block_sync_page,
 	.write_begin = minix_write_begin,
-	.write_end = generic_write_end,
+	.write_end = minix_write_end,
 	.bmap = minix_bmap
 };
 
@@ -591,14 +617,54 @@ int minix_getattr(struct vfsmount *mnt, 
 /*
  * The function that is called for file truncation.
  */
-void minix_truncate(struct inode * inode)
+static void minix_truncate_blocks(struct inode *inode, loff_t offset)
 {
 	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode)))
 		return;
 	if (INODE_VERSION(inode) == MINIX_V1)
-		V1_minix_truncate(inode);
+		V1_minix_truncate_blocks(inode, offset);
 	else
-		V2_minix_truncate(inode);
+		V2_minix_truncate_blocks(inode, offset);
+}
+
+static int minix_setsize(struct inode *inode, loff_t newsize)
+{
+	loff_t oldsize;
+	int error;
+
+	error = inode_newsize_ok(inode, newsize);
+	if (error)
+		return error;
+
+	oldsize = inode->i_size;
+	i_size_write(inode, newsize);
+	truncate_pagecache(inode, oldsize, newsize);
+
+	error = block_truncate_page(inode->i_mapping, newsize, minix_get_block);
+	if (error)
+		return error;
+	minix_truncate_blocks(inode, newsize);
+
+	return error;
+}
+
+int minix_setattr(struct dentry *dentry, struct iattr *iattr)
+{
+	struct inode *inode = dentry->d_inode;
+	int error;
+
+	error = inode_change_ok(inode, iattr);
+	if (error)
+		return error;
+	if (iattr->ia_valid & ATTR_SIZE) {
+		error = minix_setsize(inode, iattr->ia_size);
+		if (error)
+			return error;
+	}
+	generic_setattr(inode, iattr);
+	mark_inode_dirty(inode);
+
+	return error;
 }
 
 static int minix_get_sb(struct file_system_type *fs_type,
diff -puN fs/minix/itree_common.c~minix-convert-to-use-the-new-truncate-convention fs/minix/itree_common.c
--- a/fs/minix/itree_common.c~minix-convert-to-use-the-new-truncate-convention
+++ a/fs/minix/itree_common.c
@@ -290,7 +290,7 @@ static void free_branches(struct inode *
 		free_data(inode, p, q);
 }
 
-static inline void truncate (struct inode * inode)
+static inline void truncate_blocks(struct inode *inode, loff_t offset)
 {
 	struct super_block *sb = inode->i_sb;
 	block_t *idata = i_data(inode);
@@ -302,8 +302,7 @@ static inline void truncate (struct inod
 	int first_whole;
 	long iblock;
 
-	iblock = (inode->i_size + sb->s_blocksize -1) >> sb->s_blocksize_bits;
-	block_truncate_page(inode->i_mapping, inode->i_size, get_block);
+	iblock = (offset + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
 
 	n = block_to_path(inode, iblock, offsets);
 	if (!n)
diff -puN fs/minix/itree_v1.c~minix-convert-to-use-the-new-truncate-convention fs/minix/itree_v1.c
--- a/fs/minix/itree_v1.c~minix-convert-to-use-the-new-truncate-convention
+++ a/fs/minix/itree_v1.c
@@ -55,9 +55,9 @@ int V1_minix_get_block(struct inode * in
 	return get_block(inode, block, bh_result, create);
 }
 
-void V1_minix_truncate(struct inode * inode)
+void V1_minix_truncate_blocks(struct inode *inode, loff_t offset)
 {
-	truncate(inode);
+	truncate_blocks(inode, offset);
 }
 
 unsigned V1_minix_blocks(loff_t size, struct super_block *sb)
diff -puN fs/minix/itree_v2.c~minix-convert-to-use-the-new-truncate-convention fs/minix/itree_v2.c
--- a/fs/minix/itree_v2.c~minix-convert-to-use-the-new-truncate-convention
+++ a/fs/minix/itree_v2.c
@@ -61,9 +61,9 @@ int V2_minix_get_block(struct inode * in
 	return get_block(inode, block, bh_result, create);
 }
 
-void V2_minix_truncate(struct inode * inode)
+void V2_minix_truncate_blocks(struct inode *inode, loff_t offset)
 {
-	truncate(inode);
+	truncate_blocks(inode, offset);
 }
 
 unsigned V2_minix_blocks(loff_t size, struct super_block *sb)
diff -puN fs/minix/minix.h~minix-convert-to-use-the-new-truncate-convention fs/minix/minix.h
--- a/fs/minix/minix.h~minix-convert-to-use-the-new-truncate-convention
+++ a/fs/minix/minix.h
@@ -52,14 +52,14 @@ extern unsigned long minix_count_free_in
 extern int minix_new_block(struct inode * inode);
 extern void minix_free_block(struct inode *inode, unsigned long block);
 extern unsigned long minix_count_free_blocks(struct minix_sb_info *sbi);
+extern int minix_setattr(struct dentry *dentry, struct iattr *iattr);
 extern int minix_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 extern int __minix_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata);
 
-extern void V1_minix_truncate(struct inode *);
-extern void V2_minix_truncate(struct inode *);
-extern void minix_truncate(struct inode *);
+extern void V1_minix_truncate_blocks(struct inode *, loff_t);
+extern void V2_minix_truncate_blocks(struct inode *, loff_t);
 extern void minix_set_inode(struct inode *, dev_t);
 extern int V1_minix_get_block(struct inode *, long, struct buffer_head *, int);
 extern int V2_minix_get_block(struct inode *, long, struct buffer_head *, int);
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

