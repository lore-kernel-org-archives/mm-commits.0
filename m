From: akpm@linux-foundation.org
Subject: + fat-convert-to-use-the-new-truncate-convention.patch added to -mm tree
Date: Thu, 20 Aug 2009 15:48:31 -0700
Message-ID: <200908202248.n7KMmVFk029791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755359AbZHTWtX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 18:49:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, chris.mason@oracle.com, hch@lst.de, hirofumi@mail.parknet.co.jp, hugh.dickins@tiscali.co.uk, jack@suse.cz, miklos@szeredi.hu, sfrench@us.ibm.com, shaggy@linux.vnet.ibm.com, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk


The patch titled
     fat: convert to use the new truncate convention
has been added to the -mm tree.  Its filename is
     fat-convert-to-use-the-new-truncate-convention.patch

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
Subject: fat: convert to use the new truncate convention
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Steven French <sfrench@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h   |    2 +-
 fs/fat/file.c  |   35 +++++++++++++++++++++++++++--------
 fs/fat/inode.c |   25 ++++++++++++++++++++++---
 3 files changed, 50 insertions(+), 12 deletions(-)

diff -puN fs/fat/fat.h~fat-convert-to-use-the-new-truncate-convention fs/fat/fat.h
--- a/fs/fat/fat.h~fat-convert-to-use-the-new-truncate-convention
+++ a/fs/fat/fat.h
@@ -302,7 +302,7 @@ extern int fat_generic_ioctl(struct inod
 extern const struct file_operations fat_file_operations;
 extern const struct inode_operations fat_file_inode_operations;
 extern int fat_setattr(struct dentry * dentry, struct iattr * attr);
-extern void fat_truncate(struct inode *inode);
+extern void fat_truncate_blocks(struct inode *inode, loff_t offset);
 extern int fat_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		       struct kstat *stat);
 extern int fat_file_fsync(struct file *file, struct dentry *dentry,
diff -puN fs/fat/file.c~fat-convert-to-use-the-new-truncate-convention fs/fat/file.c
--- a/fs/fat/file.c~fat-convert-to-use-the-new-truncate-convention
+++ a/fs/fat/file.c
@@ -252,7 +252,7 @@ static int fat_free(struct inode *inode,
 	return fat_free_clusters(inode, free_start);
 }
 
-void fat_truncate(struct inode *inode)
+void fat_truncate_blocks(struct inode *inode, loff_t offset)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
 	const unsigned int cluster_size = sbi->cluster_size;
@@ -262,10 +262,10 @@ void fat_truncate(struct inode *inode)
 	 * This protects against truncating a file bigger than it was then
 	 * trying to write into the hole.
 	 */
-	if (MSDOS_I(inode)->mmu_private > inode->i_size)
-		MSDOS_I(inode)->mmu_private = inode->i_size;
+	if (MSDOS_I(inode)->mmu_private > offset)
+		MSDOS_I(inode)->mmu_private = offset;
 
-	nr_clusters = (inode->i_size + (cluster_size - 1)) >> sbi->cluster_bits;
+	nr_clusters = (offset + (cluster_size - 1)) >> sbi->cluster_bits;
 
 	fat_free(inode, nr_clusters);
 	fat_flush_inodes(inode->i_sb, inode, NULL);
@@ -333,6 +333,18 @@ static int fat_allow_set_time(struct msd
 	return 0;
 }
 
+static int fat_setsize(struct inode *inode, loff_t offset)
+{
+	int error;
+
+	error = simple_setsize(inode, offset);
+	if (error)
+		return error;
+	fat_truncate_blocks(inode, offset);
+
+	return error;
+}
+
 #define TIMES_SET_FLAGS	(ATTR_MTIME_SET | ATTR_ATIME_SET | ATTR_TIMES_SET)
 /* valid file mode bits */
 #define FAT_VALID_MODE	(S_IFREG | S_IFDIR | S_IRWXUGO)
@@ -347,7 +359,8 @@ int fat_setattr(struct dentry *dentry, s
 	/*
 	 * Expand the file. Since inode_setattr() updates ->i_size
 	 * before calling the ->truncate(), but FAT needs to fill the
-	 * hole before it.
+	 * hole before it. XXX: this is no longer true with new truncate
+	 * sequence.
 	 */
 	if (attr->ia_valid & ATTR_SIZE) {
 		if (attr->ia_size > inode->i_size) {
@@ -396,15 +409,21 @@ int fat_setattr(struct dentry *dentry, s
 			attr->ia_valid &= ~ATTR_MODE;
 	}
 
-	if (attr->ia_valid)
-		error = inode_setattr(inode, attr);
+	if (attr->ia_valid & ATTR_SIZE) {
+		error = fat_setsize(inode, attr->ia_size);
+		if (error)
+			goto out;
+	}
+
+	generic_setattr(inode, attr);
+	mark_inode_dirty(inode);
 out:
 	return error;
 }
 EXPORT_SYMBOL_GPL(fat_setattr);
 
 const struct inode_operations fat_file_inode_operations = {
-	.truncate	= fat_truncate,
+	.new_truncate	= 1,
 	.setattr	= fat_setattr,
 	.getattr	= fat_getattr,
 };
diff -puN fs/fat/inode.c~fat-convert-to-use-the-new-truncate-convention fs/fat/inode.c
--- a/fs/fat/inode.c~fat-convert-to-use-the-new-truncate-convention
+++ a/fs/fat/inode.c
@@ -146,10 +146,19 @@ static int fat_write_begin(struct file *
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
 {
+	int err;
+
 	*pagep = NULL;
-	return cont_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+	err = cont_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
 				fat_get_block,
 				&MSDOS_I(mapping->host)->mmu_private);
+	if (err < 0) {
+		struct inode *inode = mapping->host;
+		loff_t isize = inode->i_size;
+		if (pos + len > isize)
+			fat_truncate_blocks(inode, isize);
+	}
+	return err;
 }
 
 static int fat_write_end(struct file *file, struct address_space *mapping,
@@ -159,6 +168,11 @@ static int fat_write_end(struct file *fi
 	struct inode *inode = mapping->host;
 	int err;
 	err = generic_write_end(file, mapping, pos, len, copied, pagep, fsdata);
+	if (err < len) {
+		loff_t isize = inode->i_size;
+		if (pos + len > isize)
+			fat_truncate_blocks(inode, isize);
+	}
 	if (!(err < 0) && !(MSDOS_I(inode)->i_attrs & ATTR_ARCH)) {
 		inode->i_mtime = inode->i_ctime = CURRENT_TIME_SEC;
 		MSDOS_I(inode)->i_attrs |= ATTR_ARCH;
@@ -173,6 +187,7 @@ static ssize_t fat_direct_IO(int rw, str
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
+	ssize_t ret;
 
 	if (rw == WRITE) {
 		/*
@@ -193,8 +208,12 @@ static ssize_t fat_direct_IO(int rw, str
 	 * FAT need to use the DIO_LOCKING for avoiding the race
 	 * condition of fat_get_block() and ->truncate().
 	 */
-	return blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
+	ret = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
 				  offset, nr_segs, fat_get_block, NULL);
+	if (ret < 0 && (rw & WRITE))
+		fat_truncate_blocks(inode, inode->i_size);
+
+	return ret;
 }
 
 static sector_t _fat_bmap(struct address_space *mapping, sector_t block)
@@ -429,7 +448,7 @@ static void fat_delete_inode(struct inod
 {
 	truncate_inode_pages(&inode->i_data, 0);
 	inode->i_size = 0;
-	fat_truncate(inode);
+	fat_truncate_blocks(inode, 0);
 	clear_inode(inode);
 }
 
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

