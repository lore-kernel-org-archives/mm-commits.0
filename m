From: akpm@linux-foundation.org
Subject: + fat-restructure-export-operations.patch added to -mm tree
Date: Mon, 29 Oct 2012 16:49:53 -0700
Message-ID: <20121029234954.97A225C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:38866 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758494Ab2J2Xt5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 19:49:57 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so344498lbo.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 16:49:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namjae.jeon@samsung.com, a.sahrawat@samsung.com, hirofumi@mail.parknet.co.jp, ravi.n1@samsung.com


The patch titled
     Subject: fat: restructure export operations
has been added to the -mm tree.  Its filename is
     fat-restructure-export-operations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: fat: restructure export operations

Define two nfs export_operation structures,one for 'stale_rw' mounts and
the other for 'nostale_ro'.The former uses the generic export_encode_fh
function to encode file handle, while the latter uses fat_encode_fh().

Since inode number is not needed for nostale_ro, remove it from struct
fat_fid and repack other needed info viz.  i_pos and i_generation.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h   |    2 
 fs/fat/inode.c |   12 +---
 fs/fat/nfs.c   |  127 ++++++++++++++++++++++++++++++++++++-----------
 3 files changed, 104 insertions(+), 37 deletions(-)

diff -puN fs/fat/fat.h~fat-restructure-export-operations fs/fat/fat.h
--- a/fs/fat/fat.h~fat-restructure-export-operations
+++ a/fs/fat/fat.h
@@ -391,6 +391,8 @@ void fat_cache_destroy(void);
 
 /* fat/nfs.c */
 struct fid;
+extern const struct export_operations fat_export_ops;
+extern const struct export_operations fat_export_ops_nostale;
 extern int fat_encode_fh(struct inode *inode, __u32 *fh, int *lenp,
 			 struct inode *parent);
 extern struct dentry *fat_fh_to_dentry(struct super_block *sb, struct fid *fid,
diff -puN fs/fat/inode.c~fat-restructure-export-operations fs/fat/inode.c
--- a/fs/fat/inode.c~fat-restructure-export-operations
+++ a/fs/fat/inode.c
@@ -18,7 +18,6 @@
 #include <linux/pagemap.h>
 #include <linux/mpage.h>
 #include <linux/buffer_head.h>
-#include <linux/exportfs.h>
 #include <linux/mount.h>
 #include <linux/vfs.h>
 #include <linux/parser.h>
@@ -703,13 +702,6 @@ static const struct super_operations fat
 	.show_options	= fat_show_options,
 };
 
-static const struct export_operations fat_export_ops = {
-	.encode_fh      = fat_encode_fh,
-	.fh_to_dentry	= fat_fh_to_dentry,
-	.fh_to_parent	= fat_fh_to_parent,
-	.get_parent	= fat_get_parent,
-};
-
 static int fat_show_options(struct seq_file *m, struct dentry *root)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(root->d_sb);
@@ -1118,8 +1110,10 @@ out:
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
diff -puN fs/fat/nfs.c~fat-restructure-export-operations fs/fat/nfs.c
--- a/fs/fat/nfs.c~fat-restructure-export-operations
+++ a/fs/fat/nfs.c
@@ -15,13 +15,17 @@
 #include "fat.h"
 
 struct fat_fid {
-	u32 ino;
-	u32 gen;
-	u64 i_pos;
-	u32 parent_ino;
-	u32 parent_gen;
+	u32 i_gen;
+	u32 i_pos_low;
+	u16 i_pos_hi;
+	u16 parent_i_pos_hi;
+	u32 parent_i_pos_low;
+	u32 parent_i_gen;
 } __packed;
 
+#define FILEID_FAT_WITHOUT_PARENT (offsetof(struct fat_fid, parent_i_pos_hi)/4)
+#define FILEID_FAT_WITH_PARENT (sizeof(struct fat_fid)/4)
+
 /**
  * Look up a directory inode given its starting cluster.
  */
@@ -47,15 +51,24 @@ static struct inode *fat_dget(struct sup
 	return inode;
 }
 
+static struct inode *fat_ilookup(struct super_block *sb, u64 ino, loff_t i_pos)
+{
+	if (MSDOS_SB(sb)->options.nfs == FAT_NFS_NOSTALE_RO)
+		return fat_iget(sb, i_pos);
+
+	else {
+		if ((ino < MSDOS_ROOT_INO) || (ino == MSDOS_FSINFO_INO))
+			return NULL;
+		return ilookup(sb, ino);
+	}
+}
+
 static struct inode *fat_nfs_get_inode(struct super_block *sb,
 				       u64 ino, u32 generation, loff_t i_pos)
 {
-	struct inode *inode;
 
-	if ((ino < MSDOS_ROOT_INO) || (ino == MSDOS_FSINFO_INO))
-		return NULL;
+	struct inode *inode = fat_ilookup(sb, ino, i_pos);
 
-	inode = ilookup(sb, ino);
 	if (inode && generation && (inode->i_generation != generation)) {
 		iput(inode);
 		inode = NULL;
@@ -89,7 +102,8 @@ static struct inode *fat_nfs_get_inode(s
 
 
 int
-fat_encode_fh(struct inode *inode, __u32 *fh, int *lenp, struct inode *parent)
+fat_encode_fh_nostale(struct inode *inode, __u32 *fh, int *lenp,
+					struct inode *parent)
 {
 	int len = *lenp;
 	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
@@ -97,24 +111,26 @@ fat_encode_fh(struct inode *inode, __u32
 	loff_t i_pos;
 	int type = FILEID_INO32_GEN;
 
-	if (parent && (len < 5)) {
-		*lenp = 5;
+	if (parent && (len < FILEID_FAT_WITH_PARENT)) {
+		*lenp = FILEID_FAT_WITH_PARENT;
 		return 255;
-	} else if (len < 3) {
-		*lenp = 3;
+	} else if (len < FILEID_FAT_WITHOUT_PARENT) {
+		*lenp = FILEID_FAT_WITHOUT_PARENT;
 		return 255;
 	}
 
 	i_pos = fat_i_pos_read(sbi, inode);
-	*lenp = 3;
-	fid->ino = inode->i_ino;
-	fid->gen = inode->i_generation;
-	fid->i_pos = i_pos;
+	*lenp = FILEID_FAT_WITHOUT_PARENT;
+	fid->i_gen = inode->i_generation;
+	fid->i_pos_low = i_pos & 0xFFFFFFFF;
+	fid->i_pos_hi = (i_pos >> 32) & 0xFF;
 	if (parent) {
-		fid->parent_ino = parent->i_ino;
-		fid->parent_gen = parent->i_generation;
+		i_pos = fat_i_pos_read(sbi, parent);
+		fid->parent_i_pos_hi = (i_pos >> 32) & 0xFF;
+		fid->parent_i_pos_low = i_pos & 0xFFFFFFFF;
+		fid->parent_i_gen = parent->i_generation;
 		type = FILEID_INO32_GEN_PARENT;
-		*lenp = 5;
+		*lenp = FILEID_FAT_WITH_PARENT;
 	}
 
 	return type;
@@ -128,14 +144,36 @@ struct dentry *fat_fh_to_dentry(struct s
 				int fh_len, int fh_type)
 {
 	struct inode *inode = NULL;
-	struct fat_fid *fid = (struct fat_fid *)fh;
-	if (fh_len < 3)
+	if (fh_len < 2)
 		return NULL;
 
 	switch (fh_type) {
 	case FILEID_INO32_GEN:
 	case FILEID_INO32_GEN_PARENT:
-		inode = fat_nfs_get_inode(sb, fid->ino, fid->gen, fid->i_pos);
+		inode = fat_nfs_get_inode(sb, fh->i32.ino, fh->i32.gen, 0);
+		break;
+	}
+
+	return d_obtain_alias(inode);
+}
+struct dentry *fat_fh_to_dentry_nostale(struct super_block *sb, struct fid *fh,
+				int fh_len, int fh_type)
+{
+	struct inode *inode = NULL;
+	struct fat_fid *fid = (struct fat_fid *)fh;
+	loff_t i_pos;
+
+	switch (fh_type) {
+	case FILEID_INO32_GEN:
+		if (fh_len < FILEID_FAT_WITHOUT_PARENT)
+			return NULL;
+	case FILEID_INO32_GEN_PARENT:
+		if ((fh_len < FILEID_FAT_WITH_PARENT) &&
+			(fh_type == FILEID_INO32_GEN_PARENT))
+			return NULL;
+		i_pos = fid->i_pos_hi;
+		i_pos = (i_pos << 32) | (fid->i_pos_low);
+		inode = fat_nfs_get_inode(sb, 0, fid->i_gen, i_pos);
 
 		break;
 	}
@@ -147,18 +185,39 @@ struct dentry *fat_fh_to_dentry(struct s
  * Find the parent for a file specified by NFS handle.
  * This requires that the handle contain the i_ino of the parent.
  */
-struct dentry *fat_fh_to_parent(struct super_block *sb, struct fid *fh,
+struct dentry *fat_fh_to_parent(struct super_block *sb, struct fid *fid,
+				int fh_len, int fh_type)
+{
+	struct inode *inode = NULL;
+
+	if (fh_len < 2)
+		return NULL;
+
+	switch (fh_type) {
+	case FILEID_INO32_GEN:
+	case FILEID_INO32_GEN_PARENT:
+		inode = fat_nfs_get_inode(sb, fid->i32.ino, fid->i32.gen, 0);
+		break;
+	}
+
+	return d_obtain_alias(inode);
+}
+
+struct dentry *fat_fh_to_parent_nostale(struct super_block *sb, struct fid *fh,
 				int fh_len, int fh_type)
 {
 	struct inode *inode = NULL;
 	struct fat_fid *fid = (struct fat_fid *)fh;
-	if (fh_len < 5)
+	loff_t i_pos;
+
+	if (fh_len < FILEID_FAT_WITH_PARENT)
 		return NULL;
 
 	switch (fh_type) {
 	case FILEID_INO32_GEN_PARENT:
-		inode = fat_nfs_get_inode(sb, fid->parent_ino, fid->parent_gen,
-						fid->i_pos);
+		i_pos = fid->parent_i_pos_hi;
+		i_pos = (i_pos << 32) | (fid->parent_i_pos_low);
+		inode = fat_nfs_get_inode(sb, 0, fid->parent_i_gen, i_pos);
 		break;
 	}
 
@@ -303,3 +362,15 @@ out:
 
 	return d_obtain_alias(parent_inode);
 }
+
+const struct export_operations fat_export_ops = {
+	.fh_to_dentry   = fat_fh_to_dentry,
+	.fh_to_parent   = fat_fh_to_parent,
+	.get_parent     = fat_get_parent,
+};
+const struct export_operations fat_export_ops_nostale = {
+	.encode_fh      = fat_encode_fh_nostale,
+	.fh_to_dentry   = fat_fh_to_dentry_nostale,
+	.fh_to_parent   = fat_fh_to_parent_nostale,
+	.get_parent     = fat_get_parent,
+};
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

fat-modify-nfs-mount-option.patch
fat-exportfs-rebuild-inode-if-ilookup-fails.patch
fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
fat-exportfs-rebuild-directory-inode-if-fat_dget-fails.patch
documentation-update-nfs-option-in-filesystem-vfattxt.patch
fat-remove-parent_logstart-check-in-fat_get_parent.patch
fat-restructure-export-operations.patch
fat-move-fat_i_pos_read-to-fath.patch
fat-exportfs-move-code-to-rebuild-directory-inode-to-separate-function.patch
fat-add-mutex-lock-to-fat_build_inode.patch

