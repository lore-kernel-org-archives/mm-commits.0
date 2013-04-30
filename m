From: akpm@linux-foundation.org
Subject: [merged] fat-restructure-export_operations.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:01:48 -0700
Message-ID: <20130430190148.7B79031C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:56808 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759093Ab3D3TBt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:01:49 -0400
Received: by mail-qa0-f74.google.com with SMTP id bs12so88786qab.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:01:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, a.sahrawat@samsung.com, hirofumi@mail.parknet.co.jp, ravi.n1@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: restructure export_operations
has been removed from the -mm tree.  Its filename was
     fat-restructure-export_operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: fat: restructure export_operations

Define two nfs export_operation structures,one for 'stale_rw' mounts and
the other for 'nostale_ro'.  The latter uses i_pos as a basis for encoding
and decoding file handles.

Also, assign i_pos to kstat->ino.  The logic for rebuilding the inode is
added in the subsequent patches.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h             |    8 --
 fs/fat/file.c            |    5 +
 fs/fat/inode.c           |   13 +--
 fs/fat/nfs.c             |  130 +++++++++++++++++++++++++++++++++++--
 include/linux/exportfs.h |   11 +++
 5 files changed, 147 insertions(+), 20 deletions(-)

diff -puN fs/fat/fat.h~fat-restructure-export_operations fs/fat/fat.h
--- a/fs/fat/fat.h~fat-restructure-export_operations
+++ a/fs/fat/fat.h
@@ -406,12 +406,8 @@ int fat_cache_init(void);
 void fat_cache_destroy(void);
 
 /* fat/nfs.c */
-struct fid;
-extern struct dentry *fat_fh_to_dentry(struct super_block *sb, struct fid *fid,
-				       int fh_len, int fh_type);
-extern struct dentry *fat_fh_to_parent(struct super_block *sb, struct fid *fid,
-				       int fh_len, int fh_type);
-extern struct dentry *fat_get_parent(struct dentry *child_dir);
+extern const struct export_operations fat_export_ops;
+extern const struct export_operations fat_export_ops_nostale;
 
 /* helper for printk */
 typedef unsigned long long	llu;
diff -puN fs/fat/file.c~fat-restructure-export_operations fs/fat/file.c
--- a/fs/fat/file.c~fat-restructure-export_operations
+++ a/fs/fat/file.c
@@ -306,6 +306,11 @@ int fat_getattr(struct vfsmount *mnt, st
 	struct inode *inode = dentry->d_inode;
 	generic_fillattr(inode, stat);
 	stat->blksize = MSDOS_SB(inode->i_sb)->cluster_size;
+
+	if (MSDOS_SB(inode->i_sb)->options.nfs == FAT_NFS_NOSTALE_RO) {
+		/* Use i_pos for ino. This is used as fileid of nfs. */
+		stat->ino = fat_i_pos_read(MSDOS_SB(inode->i_sb), inode);
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(fat_getattr);
diff -puN fs/fat/inode.c~fat-restructure-export_operations fs/fat/inode.c
--- a/fs/fat/inode.c~fat-restructure-export_operations
+++ a/fs/fat/inode.c
@@ -18,7 +18,6 @@
 #include <linux/pagemap.h>
 #include <linux/mpage.h>
 #include <linux/buffer_head.h>
-#include <linux/exportfs.h>
 #include <linux/mount.h>
 #include <linux/vfs.h>
 #include <linux/parser.h>
@@ -748,12 +747,6 @@ static const struct super_operations fat
 	.show_options	= fat_show_options,
 };
 
-static const struct export_operations fat_export_ops = {
-	.fh_to_dentry	= fat_fh_to_dentry,
-	.fh_to_parent	= fat_fh_to_parent,
-	.get_parent	= fat_get_parent,
-};
-
 static int fat_show_options(struct seq_file *m, struct dentry *root)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(root->d_sb);
@@ -1177,8 +1170,10 @@ out:
 		opts->allow_utime = ~opts->fs_dmask & (S_IWGRP | S_IWOTH);
 	if (opts->unicode_xlate)
 		opts->utf8 = 0;
-	if (opts->nfs == FAT_NFS_NOSTALE_RO)
+	if (opts->nfs == FAT_NFS_NOSTALE_RO) {
 		sb->s_flags |= MS_RDONLY;
+		sb->s_export_op = &fat_export_ops_nostale;
+	}
 
 	return 0;
 }
@@ -1189,7 +1184,7 @@ static int fat_read_root(struct inode *i
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	int error;
 
-	MSDOS_I(inode)->i_pos = 0;
+	MSDOS_I(inode)->i_pos = MSDOS_ROOT_INO;
 	inode->i_uid = sbi->options.fs_uid;
 	inode->i_gid = sbi->options.fs_gid;
 	inode->i_version++;
diff -puN fs/fat/nfs.c~fat-restructure-export_operations fs/fat/nfs.c
--- a/fs/fat/nfs.c~fat-restructure-export_operations
+++ a/fs/fat/nfs.c
@@ -14,6 +14,18 @@
 #include <linux/exportfs.h>
 #include "fat.h"
 
+struct fat_fid {
+	u32 i_gen;
+	u32 i_pos_low;
+	u16 i_pos_hi;
+	u16 parent_i_pos_hi;
+	u32 parent_i_pos_low;
+	u32 parent_i_gen;
+};
+
+#define FAT_FID_SIZE_WITHOUT_PARENT 3
+#define FAT_FID_SIZE_WITH_PARENT (sizeof(struct fat_fid)/sizeof(u32))
+
 /**
  * Look up a directory inode given its starting cluster.
  */
@@ -38,8 +50,8 @@ static struct inode *fat_dget(struct sup
 	return inode;
 }
 
-static struct inode *fat_nfs_get_inode(struct super_block *sb,
-				       u64 ino, u32 generation)
+static struct inode *__fat_nfs_get_inode(struct super_block *sb,
+				       u64 ino, u32 generation, loff_t i_pos)
 {
 	struct inode *inode;
 
@@ -55,35 +67,130 @@ static struct inode *fat_nfs_get_inode(s
 	return inode;
 }
 
+static struct inode *fat_nfs_get_inode(struct super_block *sb,
+				       u64 ino, u32 generation)
+{
+
+	return __fat_nfs_get_inode(sb, ino, generation, 0);
+}
+
+static int
+fat_encode_fh_nostale(struct inode *inode, __u32 *fh, int *lenp,
+		      struct inode *parent)
+{
+	int len = *lenp;
+	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
+	struct fat_fid *fid = (struct fat_fid *) fh;
+	loff_t i_pos;
+	int type = FILEID_FAT_WITHOUT_PARENT;
+
+	if (parent) {
+		if (len < FAT_FID_SIZE_WITH_PARENT) {
+			*lenp = FAT_FID_SIZE_WITH_PARENT;
+			return FILEID_INVALID;
+		}
+	} else {
+		if (len < FAT_FID_SIZE_WITHOUT_PARENT) {
+			*lenp = FAT_FID_SIZE_WITHOUT_PARENT;
+			return FILEID_INVALID;
+		}
+	}
+
+	i_pos = fat_i_pos_read(sbi, inode);
+	*lenp = FAT_FID_SIZE_WITHOUT_PARENT;
+	fid->i_gen = inode->i_generation;
+	fid->i_pos_low = i_pos & 0xFFFFFFFF;
+	fid->i_pos_hi = (i_pos >> 32) & 0xFFFF;
+	if (parent) {
+		i_pos = fat_i_pos_read(sbi, parent);
+		fid->parent_i_pos_hi = (i_pos >> 32) & 0xFFFF;
+		fid->parent_i_pos_low = i_pos & 0xFFFFFFFF;
+		fid->parent_i_gen = parent->i_generation;
+		type = FILEID_FAT_WITH_PARENT;
+		*lenp = FAT_FID_SIZE_WITH_PARENT;
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
+static struct dentry *fat_fh_to_dentry(struct super_block *sb, struct fid *fid,
 				int fh_len, int fh_type)
 {
 	return generic_fh_to_dentry(sb, fid, fh_len, fh_type,
 				    fat_nfs_get_inode);
 }
 
+static struct dentry *fat_fh_to_dentry_nostale(struct super_block *sb,
+					       struct fid *fh, int fh_len,
+					       int fh_type)
+{
+	struct inode *inode = NULL;
+	struct fat_fid *fid = (struct fat_fid *)fh;
+	loff_t i_pos;
+
+	switch (fh_type) {
+	case FILEID_FAT_WITHOUT_PARENT:
+		if (fh_len < FAT_FID_SIZE_WITHOUT_PARENT)
+			return NULL;
+		break;
+	case FILEID_FAT_WITH_PARENT:
+		if (fh_len < FAT_FID_SIZE_WITH_PARENT)
+			return NULL;
+		break;
+	default:
+		return NULL;
+	}
+	i_pos = fid->i_pos_hi;
+	i_pos = (i_pos << 32) | (fid->i_pos_low);
+	inode = __fat_nfs_get_inode(sb, 0, fid->i_gen, i_pos);
+
+	return d_obtain_alias(inode);
+}
+
 /*
  * Find the parent for a file specified by NFS handle.
  * This requires that the handle contain the i_ino of the parent.
  */
-struct dentry *fat_fh_to_parent(struct super_block *sb, struct fid *fid,
+static struct dentry *fat_fh_to_parent(struct super_block *sb, struct fid *fid,
 				int fh_len, int fh_type)
 {
 	return generic_fh_to_parent(sb, fid, fh_len, fh_type,
 				    fat_nfs_get_inode);
 }
 
+static struct dentry *fat_fh_to_parent_nostale(struct super_block *sb,
+					       struct fid *fh, int fh_len,
+					       int fh_type)
+{
+	struct inode *inode = NULL;
+	struct fat_fid *fid = (struct fat_fid *)fh;
+	loff_t i_pos;
+
+	if (fh_len < FAT_FID_SIZE_WITH_PARENT)
+		return NULL;
+
+	switch (fh_type) {
+	case FILEID_FAT_WITH_PARENT:
+		i_pos = fid->parent_i_pos_hi;
+		i_pos = (i_pos << 32) | (fid->parent_i_pos_low);
+		inode = __fat_nfs_get_inode(sb, 0, fid->parent_i_gen, i_pos);
+		break;
+	}
+
+	return d_obtain_alias(inode);
+}
+
 /*
  * Find the parent for a directory that is not currently connected to
  * the filesystem root.
  *
  * On entry, the caller holds child_dir->d_inode->i_mutex.
  */
-struct dentry *fat_get_parent(struct dentry *child_dir)
+static struct dentry *fat_get_parent(struct dentry *child_dir)
 {
 	struct super_block *sb = child_dir->d_sb;
 	struct buffer_head *bh = NULL;
@@ -98,3 +205,16 @@ struct dentry *fat_get_parent(struct den
 
 	return d_obtain_alias(parent_inode);
 }
+
+const struct export_operations fat_export_ops = {
+	.fh_to_dentry   = fat_fh_to_dentry,
+	.fh_to_parent   = fat_fh_to_parent,
+	.get_parent     = fat_get_parent,
+};
+
+const struct export_operations fat_export_ops_nostale = {
+	.encode_fh      = fat_encode_fh_nostale,
+	.fh_to_dentry   = fat_fh_to_dentry_nostale,
+	.fh_to_parent   = fat_fh_to_parent_nostale,
+	.get_parent     = fat_get_parent,
+};
diff -puN include/linux/exportfs.h~fat-restructure-export_operations include/linux/exportfs.h
--- a/include/linux/exportfs.h~fat-restructure-export_operations
+++ a/include/linux/exportfs.h
@@ -85,6 +85,17 @@ enum fid_type {
 	FILEID_NILFS_WITH_PARENT = 0x62,
 
 	/*
+	 * 32 bit generation number, 40 bit i_pos.
+	 */
+	FILEID_FAT_WITHOUT_PARENT = 0x71,
+
+	/*
+	 * 32 bit generation number, 40 bit i_pos,
+	 * 32 bit parent generation number, 40 bit parent i_pos
+	 */
+	FILEID_FAT_WITH_PARENT = 0x72,
+
+	/*
 	 * Filesystems must not use 0xff file ID.
 	 */
 	FILEID_INVALID = 0xff,
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

origin.patch
linux-next.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-fix.patch

