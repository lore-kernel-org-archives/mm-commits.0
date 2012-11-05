From: akpm@linux-foundation.org
Subject: [nacked] fat-exportfs-rebuild-inode-if-ilookup-fails.patch removed from -mm tree
Date: Mon, 05 Nov 2012 12:06:52 -0800
Message-ID: <20121105200653.2410320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:49682 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab2KEUG4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2012 15:06:56 -0500
Received: by mail-la0-f74.google.com with SMTP id j13so400973lah.1
        for <mm-commits@vger.kernel.org>; Mon, 05 Nov 2012 12:06:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, a.sahrawat@samsung.com, bfields@fieldses.org, hirofumi@mail.parknet.co.jp, ravi.n1@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fat (exportfs): rebuild inode if ilookup() fails
has been removed from the -mm tree.  Its filename was
     fat-exportfs-rebuild-inode-if-ilookup-fails.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: fat (exportfs): rebuild inode if ilookup() fails

Assign i_pos to kstat->ino and re-introduce fat_encode_fh() and include
i_pos value in the file handle.Use the i_pos value to find the directory
entry of the inode and subsequently rebuild the inode if the cache lookups
fail.

Since this involves accessing the FAT media, it is better to do this only
if the 'nfs' mount option is enabled with nostale_ro.  Also introduce a
helper fat_get_blknr_offset() for use in __fat_write_inode() and
fat_nfs_get_inode()

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h   |   10 ++++
 fs/fat/file.c  |    4 +
 fs/fat/inode.c |   13 +++---
 fs/fat/nfs.c   |  101 +++++++++++++++++++++++++++++++++++++++++++----
 4 files changed, 115 insertions(+), 13 deletions(-)

diff -puN fs/fat/fat.h~fat-exportfs-rebuild-inode-if-ilookup-fails fs/fat/fat.h
--- a/fs/fat/fat.h~fat-exportfs-rebuild-inode-if-ilookup-fails
+++ a/fs/fat/fat.h
@@ -215,6 +215,13 @@ static inline sector_t fat_clus_to_blknr
 		+ sbi->data_start;
 }
 
+static inline void fat_get_blknr_offset(struct msdos_sb_info *sbi,
+				loff_t i_pos, sector_t *blknr, int *offset)
+{
+	*blknr = i_pos >> sbi->dir_per_block_bits;
+	*offset = i_pos & (sbi->dir_per_block - 1);
+}
+
 static inline void fat16_towchar(wchar_t *dst, const __u8 *src, size_t len)
 {
 #ifdef __BIG_ENDIAN
@@ -340,6 +347,7 @@ extern int fat_file_fsync(struct file *f
 			  int datasync);
 
 /* fat/inode.c */
+extern loff_t fat_i_pos_read(struct msdos_sb_info *sbi, struct inode *inode);
 extern void fat_attach(struct inode *inode, loff_t i_pos);
 extern void fat_detach(struct inode *inode);
 extern struct inode *fat_iget(struct super_block *sb, loff_t i_pos);
@@ -383,6 +391,8 @@ void fat_cache_destroy(void);
 
 /* fat/nfs.c */
 struct fid;
+extern int fat_encode_fh(struct inode *inode, __u32 *fh, int *lenp,
+			 struct inode *parent);
 extern struct dentry *fat_fh_to_dentry(struct super_block *sb, struct fid *fid,
 				       int fh_len, int fh_type);
 extern struct dentry *fat_fh_to_parent(struct super_block *sb, struct fid *fid,
diff -puN fs/fat/file.c~fat-exportfs-rebuild-inode-if-ilookup-fails fs/fat/file.c
--- a/fs/fat/file.c~fat-exportfs-rebuild-inode-if-ilookup-fails
+++ a/fs/fat/file.c
@@ -306,6 +306,10 @@ int fat_getattr(struct vfsmount *mnt, st
 	struct inode *inode = dentry->d_inode;
 	generic_fillattr(inode, stat);
 	stat->blksize = MSDOS_SB(inode->i_sb)->cluster_size;
+	if (MSDOS_SB(inode->i_sb)->options.nfs == FAT_NFS_NOSTALE_RO) {
+		/* Use i_pos for ino. This is used as fileid of nfs. */
+		stat->ino = fat_i_pos_read(MSDOS_SB(inode->i_sb), inode);
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(fat_getattr);
diff -puN fs/fat/inode.c~fat-exportfs-rebuild-inode-if-ilookup-fails fs/fat/inode.c
--- a/fs/fat/inode.c~fat-exportfs-rebuild-inode-if-ilookup-fails
+++ a/fs/fat/inode.c
@@ -596,7 +596,7 @@ static int fat_statfs(struct dentry *den
 	return 0;
 }
 
-static inline loff_t fat_i_pos_read(struct msdos_sb_info *sbi,
+loff_t fat_i_pos_read(struct msdos_sb_info *sbi,
 				    struct inode *inode)
 {
 	loff_t i_pos;
@@ -616,8 +616,8 @@ static int __fat_write_inode(struct inod
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	struct buffer_head *bh;
 	struct msdos_dir_entry *raw_entry;
-	loff_t i_pos;
-	int err;
+	loff_t i_pos, blocknr;
+	int offset, err;
 
 	if (inode->i_ino == MSDOS_ROOT_INO)
 		return 0;
@@ -627,7 +627,8 @@ retry:
 	if (!i_pos)
 		return 0;
 
-	bh = sb_bread(sb, i_pos >> sbi->dir_per_block_bits);
+	fat_get_blknr_offset(sbi, i_pos, &blocknr, &offset);
+	bh = sb_bread(sb, blocknr);
 	if (!bh) {
 		fat_msg(sb, KERN_ERR, "unable to read inode block "
 		       "for updating (i_pos %lld)", i_pos);
@@ -640,8 +641,7 @@ retry:
 		goto retry;
 	}
 
-	raw_entry = &((struct msdos_dir_entry *) (bh->b_data))
-	    [i_pos & (sbi->dir_per_block - 1)];
+	raw_entry = &((struct msdos_dir_entry *) (bh->b_data))[offset];
 	if (S_ISDIR(inode->i_mode))
 		raw_entry->size = 0;
 	else
@@ -703,6 +703,7 @@ static const struct super_operations fat
 };
 
 static const struct export_operations fat_export_ops = {
+	.encode_fh      = fat_encode_fh,
 	.fh_to_dentry	= fat_fh_to_dentry,
 	.fh_to_parent	= fat_fh_to_parent,
 	.get_parent	= fat_get_parent,
diff -puN fs/fat/nfs.c~fat-exportfs-rebuild-inode-if-ilookup-fails fs/fat/nfs.c
--- a/fs/fat/nfs.c~fat-exportfs-rebuild-inode-if-ilookup-fails
+++ a/fs/fat/nfs.c
@@ -14,6 +14,14 @@
 #include <linux/exportfs.h>
 #include "fat.h"
 
+struct fat_fid {
+	u32 ino;
+	u32 gen;
+	u64 i_pos;
+	u32 parent_ino;
+	u32 parent_gen;
+} __packed;
+
 /**
  * Look up a directory inode given its starting cluster.
  */
@@ -40,7 +48,7 @@ static struct inode *fat_dget(struct sup
 }
 
 static struct inode *fat_nfs_get_inode(struct super_block *sb,
-				       u64 ino, u32 generation)
+				       u64 ino, u32 generation, loff_t i_pos)
 {
 	struct inode *inode;
 
@@ -52,30 +60,109 @@ static struct inode *fat_nfs_get_inode(s
 		iput(inode);
 		inode = NULL;
 	}
+	if (inode == NULL && MSDOS_SB(sb)->options.nfs == FAT_NFS_NOSTALE_RO) {
+		struct buffer_head *bh = NULL;
+		struct msdos_dir_entry *de ;
+		loff_t blocknr;
+		int offset;
+		fat_get_blknr_offset(MSDOS_SB(sb), i_pos, &blocknr, &offset);
+		bh = sb_bread(sb, blocknr);
+		if (!bh) {
+			fat_msg(sb, KERN_ERR,
+				"unable to read block(%llu) for building NFS inode",
+				(llu)blocknr);
+			return inode;
+		}
+		de = (struct msdos_dir_entry *)bh->b_data;
+		/* If a file is deleted on server and client is not updated
+		 * yet, we must not build the inode upon a lookup call.
+		 */
+		if (IS_FREE(de[offset].name))
+			inode = NULL;
+		else
+			inode = fat_build_inode(sb, &de[offset], i_pos);
+		brelse(bh);
+	}
 
 	return inode;
 }
 
+
+int
+fat_encode_fh(struct inode *inode, __u32 *fh, int *lenp, struct inode *parent)
+{
+	int len = *lenp;
+	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
+	struct fat_fid *fid = (struct fat_fid *) fh;
+	loff_t i_pos;
+	int type = FILEID_INO32_GEN;
+
+	if (parent && (len < 5)) {
+		*lenp = 5;
+		return 255;
+	} else if (len < 3) {
+		*lenp = 3;
+		return 255;
+	}
+
+	i_pos = fat_i_pos_read(sbi, inode);
+	*lenp = 3;
+	fid->ino = inode->i_ino;
+	fid->gen = inode->i_generation;
+	fid->i_pos = i_pos;
+	if (parent) {
+		fid->parent_ino = parent->i_ino;
+		fid->parent_gen = parent->i_generation;
+		type = FILEID_INO32_GEN_PARENT;
+		*lenp = 5;
+	}
+
+	return type;
+}
+
 /**
  * Map a NFS file handle to a corresponding dentry.
  * The dentry may or may not be connected to the filesystem root.
  */
-struct dentry *fat_fh_to_dentry(struct super_block *sb, struct fid *fid,
+struct dentry *fat_fh_to_dentry(struct super_block *sb, struct fid *fh,
 				int fh_len, int fh_type)
 {
-	return generic_fh_to_dentry(sb, fid, fh_len, fh_type,
-				    fat_nfs_get_inode);
+	struct inode *inode = NULL;
+	struct fat_fid *fid = (struct fat_fid *)fh;
+	if (fh_len < 3)
+		return NULL;
+
+	switch (fh_type) {
+	case FILEID_INO32_GEN:
+	case FILEID_INO32_GEN_PARENT:
+		inode = fat_nfs_get_inode(sb, fid->ino, fid->gen, fid->i_pos);
+
+		break;
+	}
+
+	return d_obtain_alias(inode);
 }
 
 /*
  * Find the parent for a file specified by NFS handle.
  * This requires that the handle contain the i_ino of the parent.
  */
-struct dentry *fat_fh_to_parent(struct super_block *sb, struct fid *fid,
+struct dentry *fat_fh_to_parent(struct super_block *sb, struct fid *fh,
 				int fh_len, int fh_type)
 {
-	return generic_fh_to_parent(sb, fid, fh_len, fh_type,
-				    fat_nfs_get_inode);
+	struct inode *inode = NULL;
+	struct fat_fid *fid = (struct fat_fid *)fh;
+	if (fh_len < 5)
+		return NULL;
+
+	switch (fh_type) {
+	case FILEID_INO32_GEN_PARENT:
+		inode = fat_nfs_get_inode(sb, fid->parent_ino, fid->parent_gen,
+						fid->i_pos);
+		break;
+	}
+
+	return d_obtain_alias(inode);
 }
 
 /*
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
fat-exportfs-rebuild-directory-inode-if-fat_dget-fails.patch
documentation-update-nfs-option-in-filesystem-vfattxt.patch
fat-remove-parent_logstart-check-in-fat_get_parent.patch
fat-restructure-export-operations.patch
fat-move-fat_i_pos_read-to-fath.patch
fat-exportfs-move-code-to-rebuild-directory-inode-to-separate-function.patch
fat-add-mutex-lock-to-fat_build_inode.patch

