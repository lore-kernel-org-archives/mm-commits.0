From: akpm@linux-foundation.org
Subject: [merged] fat-exportfs-rebuild-directory-inode-if-fat_dget.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:01:53 -0700
Message-ID: <20130430190153.B88035A41E9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:47335 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933545Ab3D3TBz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:01:55 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so87533qen.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:01:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, a.sahrawat@samsung.com, hirofumi@mail.parknet.co.jp, ravi.n1@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fat (exportfs): rebuild directory-inode if fat_dget()
has been removed from the -mm tree.  Its filename was
     fat-exportfs-rebuild-directory-inode-if-fat_dget.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: fat (exportfs): rebuild directory-inode if fat_dget()

This patch enables rebuilding of directory inodes which are not present in
the cache.This is done by traversing the disk clusters to find the
directory entry of the parent directory and using its i_pos to build the
inode.

The traversal is done by fat_scan_logstart() which is similar to
fat_scan() but matches i_pos values instead of names.fat_scan_logstart()
needs an inode parameter to work, for which a dummy inode is created by
it's caller fat_rebuild_parent().  This dummy inode is destroyed after the
traversal completes.

All this is done  only if the nostale_ro nfs mount option is specified.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c   |   23 ++++++++++++++++++++
 fs/fat/fat.h   |    3 ++
 fs/fat/inode.c |    2 -
 fs/fat/nfs.c   |   52 ++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 78 insertions(+), 2 deletions(-)

diff -puN fs/fat/dir.c~fat-exportfs-rebuild-directory-inode-if-fat_dget fs/fat/dir.c
--- a/fs/fat/dir.c~fat-exportfs-rebuild-directory-inode-if-fat_dget
+++ a/fs/fat/dir.c
@@ -964,6 +964,29 @@ int fat_scan(struct inode *dir, const un
 }
 EXPORT_SYMBOL_GPL(fat_scan);
 
+/*
+ * Scans a directory for a given logstart.
+ * Returns an error code or zero.
+ */
+int fat_scan_logstart(struct inode *dir, int i_logstart,
+		      struct fat_slot_info *sinfo)
+{
+	struct super_block *sb = dir->i_sb;
+
+	sinfo->slot_off = 0;
+	sinfo->bh = NULL;
+	while (fat_get_short_entry(dir, &sinfo->slot_off, &sinfo->bh,
+				   &sinfo->de) >= 0) {
+		if (fat_get_start(MSDOS_SB(sb), sinfo->de) == i_logstart) {
+			sinfo->slot_off -= sizeof(*sinfo->de);
+			sinfo->nr_slots = 1;
+			sinfo->i_pos = fat_make_i_pos(sb, sinfo->bh, sinfo->de);
+			return 0;
+		}
+	}
+	return -ENOENT;
+}
+
 static int __fat_remove_entries(struct inode *dir, loff_t pos, int nr_slots)
 {
 	struct super_block *sb = dir->i_sb;
diff -puN fs/fat/fat.h~fat-exportfs-rebuild-directory-inode-if-fat_dget fs/fat/fat.h
--- a/fs/fat/fat.h~fat-exportfs-rebuild-directory-inode-if-fat_dget
+++ a/fs/fat/fat.h
@@ -296,6 +296,8 @@ extern int fat_dir_empty(struct inode *d
 extern int fat_subdirs(struct inode *dir);
 extern int fat_scan(struct inode *dir, const unsigned char *name,
 		    struct fat_slot_info *sinfo);
+extern int fat_scan_logstart(struct inode *dir, int i_logstart,
+			     struct fat_slot_info *sinfo);
 extern int fat_get_dotdot_entry(struct inode *dir, struct buffer_head **bh,
 				struct msdos_dir_entry **de);
 extern int fat_alloc_new_dir(struct inode *dir, struct timespec *ts);
@@ -373,6 +375,7 @@ extern struct inode *fat_build_inode(str
 extern int fat_sync_inode(struct inode *inode);
 extern int fat_fill_super(struct super_block *sb, void *data, int silent,
 			  int isvfat, void (*setup)(struct super_block *));
+extern int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de);
 
 extern int fat_flush_inodes(struct super_block *sb, struct inode *i1,
 			    struct inode *i2);
diff -puN fs/fat/inode.c~fat-exportfs-rebuild-directory-inode-if-fat_dget fs/fat/inode.c
--- a/fs/fat/inode.c~fat-exportfs-rebuild-directory-inode-if-fat_dget
+++ a/fs/fat/inode.c
@@ -384,7 +384,7 @@ static int fat_calc_dir_size(struct inod
 }
 
 /* doesn't deal with root inode */
-static int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de)
+int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
 	int error;
diff -puN fs/fat/nfs.c~fat-exportfs-rebuild-directory-inode-if-fat_dget fs/fat/nfs.c
--- a/fs/fat/nfs.c~fat-exportfs-rebuild-directory-inode-if-fat_dget
+++ a/fs/fat/nfs.c
@@ -216,6 +216,53 @@ static struct dentry *fat_fh_to_parent_n
 }
 
 /*
+ * Rebuild the parent for a directory that is not connected
+ *  to the filesystem root
+ */
+static
+struct inode *fat_rebuild_parent(struct super_block *sb, int parent_logstart)
+{
+	int search_clus, clus_to_match;
+	struct msdos_dir_entry *de;
+	struct inode *parent = NULL;
+	struct inode *dummy_grand_parent = NULL;
+	struct fat_slot_info sinfo;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	sector_t blknr = fat_clus_to_blknr(sbi, parent_logstart);
+	struct buffer_head *parent_bh = sb_bread(sb, blknr);
+	if (!parent_bh) {
+		fat_msg(sb, KERN_ERR,
+			"unable to read cluster of parent directory");
+		return NULL;
+	}
+
+	de = (struct msdos_dir_entry *) parent_bh->b_data;
+	clus_to_match = fat_get_start(sbi, &de[0]);
+	search_clus = fat_get_start(sbi, &de[1]);
+
+	dummy_grand_parent = fat_dget(sb, search_clus);
+	if (!dummy_grand_parent) {
+		dummy_grand_parent = new_inode(sb);
+		if (!dummy_grand_parent) {
+			brelse(parent_bh);
+			return parent;
+		}
+
+		dummy_grand_parent->i_ino = iunique(sb, MSDOS_ROOT_INO);
+		fat_fill_inode(dummy_grand_parent, &de[1]);
+		MSDOS_I(dummy_grand_parent)->i_pos = -1;
+	}
+
+	if (!fat_scan_logstart(dummy_grand_parent, clus_to_match, &sinfo))
+		parent = fat_build_inode(sb, sinfo.de, sinfo.i_pos);
+
+	brelse(parent_bh);
+	iput(dummy_grand_parent);
+
+	return parent;
+}
+
+/*
  * Find the parent for a directory that is not currently connected to
  * the filesystem root.
  *
@@ -227,10 +274,13 @@ static struct dentry *fat_get_parent(str
 	struct buffer_head *bh = NULL;
 	struct msdos_dir_entry *de;
 	struct inode *parent_inode = NULL;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 
 	if (!fat_get_dotdot_entry(child_dir->d_inode, &bh, &de)) {
-		int parent_logstart = fat_get_start(MSDOS_SB(sb), de);
+		int parent_logstart = fat_get_start(sbi, de);
 		parent_inode = fat_dget(sb, parent_logstart);
+		if (!parent_inode && sbi->options.nfs == FAT_NFS_NOSTALE_RO)
+			parent_inode = fat_rebuild_parent(sb, parent_logstart);
 	}
 	brelse(bh);
 
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

origin.patch
linux-next.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-fix.patch

