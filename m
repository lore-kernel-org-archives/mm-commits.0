From: akpm@linux-foundation.org
Subject: - fat-update-free_clusters-even-if-it-is-untrusted.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:01:36 -0700
Message-ID: <200804282201.m3SM1aUD018880@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965806AbYD1WBj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:01:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fat: Update free_clusters even if it is untrusted
has been removed from the -mm tree.  Its filename was
     fat-update-free_clusters-even-if-it-is-untrusted.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat: Update free_clusters even if it is untrusted
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Currently, free_clusters is not updated until it is trusted, because
Windows doesn't update it correctly.

But if user is using FAT driver of Linux, it updates free_clusters
correctly.  Instead, this updates it even if it's untrusted, so if
free_clustes is correct, now keep correct value.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fatent.c          |    7 +++++--
 fs/fat/inode.c           |    7 ++++---
 include/linux/msdos_fs.h |    1 +
 3 files changed, 10 insertions(+), 5 deletions(-)

diff -puN fs/fat/fatent.c~fat-update-free_clusters-even-if-it-is-untrusted fs/fat/fatent.c
--- a/fs/fat/fatent.c~fat-update-free_clusters-even-if-it-is-untrusted
+++ a/fs/fat/fatent.c
@@ -450,7 +450,8 @@ int fat_alloc_clusters(struct inode *ino
 	BUG_ON(nr_cluster > (MAX_BUF_PER_PAGE / 2));	/* fixed limit */
 
 	lock_fat(sbi);
-	if (sbi->free_clusters != -1 && sbi->free_clusters < nr_cluster) {
+	if (sbi->free_clusters != -1 && sbi->free_clus_valid &&
+	    sbi->free_clusters < nr_cluster) {
 		unlock_fat(sbi);
 		return -ENOSPC;
 	}
@@ -504,6 +505,7 @@ int fat_alloc_clusters(struct inode *ino
 
 	/* Couldn't allocate the free entries */
 	sbi->free_clusters = 0;
+	sbi->free_clus_valid = 1;
 	sb->s_dirt = 1;
 	err = -ENOSPC;
 
@@ -615,7 +617,7 @@ int fat_count_free_clusters(struct super
 	int err = 0, free;
 
 	lock_fat(sbi);
-	if (sbi->free_clusters != -1)
+	if (sbi->free_clusters != -1 && sbi->free_clus_valid)
 		goto out;
 
 	reada_blocks = FAT_READA_SIZE >> sb->s_blocksize_bits;
@@ -643,6 +645,7 @@ int fat_count_free_clusters(struct super
 		} while (fat_ent_next(sbi, &fatent));
 	}
 	sbi->free_clusters = free;
+	sbi->free_clus_valid = 1;
 	sb->s_dirt = 1;
 	fatent_brelse(&fatent);
 out:
diff -puN fs/fat/inode.c~fat-update-free_clusters-even-if-it-is-untrusted fs/fat/inode.c
--- a/fs/fat/inode.c~fat-update-free_clusters-even-if-it-is-untrusted
+++ a/fs/fat/inode.c
@@ -537,7 +537,7 @@ static int fat_statfs(struct dentry *den
 	struct msdos_sb_info *sbi = MSDOS_SB(dentry->d_sb);
 
 	/* If the count of free cluster is still unknown, counts it here. */
-	if (sbi->free_clusters == -1) {
+	if (sbi->free_clusters == -1 || !sbi->free_clus_valid) {
 		int err = fat_count_free_clusters(dentry->d_sb);
 		if (err)
 			return err;
@@ -1274,6 +1274,7 @@ int fat_fill_super(struct super_block *s
 	sbi->fat_length = le16_to_cpu(b->fat_length);
 	sbi->root_cluster = 0;
 	sbi->free_clusters = -1;	/* Don't know yet */
+	sbi->free_clus_valid = 0;
 	sbi->prev_free = FAT_START_ENT;
 
 	if (!sbi->fat_length && b->fat32_length) {
@@ -1309,8 +1310,8 @@ int fat_fill_super(struct super_block *s
 			       sbi->fsinfo_sector);
 		} else {
 			if (sbi->options.usefree)
-				sbi->free_clusters =
-					le32_to_cpu(fsinfo->free_clusters);
+				sbi->free_clus_valid = 1;
+			sbi->free_clusters = le32_to_cpu(fsinfo->free_clusters);
 			sbi->prev_free = le32_to_cpu(fsinfo->next_cluster);
 		}
 
diff -puN include/linux/msdos_fs.h~fat-update-free_clusters-even-if-it-is-untrusted include/linux/msdos_fs.h
--- a/include/linux/msdos_fs.h~fat-update-free_clusters-even-if-it-is-untrusted
+++ a/include/linux/msdos_fs.h
@@ -233,6 +233,7 @@ struct msdos_sb_info {
 	struct mutex fat_lock;
 	unsigned int prev_free;      /* previously allocated cluster number */
 	unsigned int free_clusters;  /* -1 if undefined */
+	unsigned int free_clus_valid; /* is free_clusters valid? */
 	struct fat_mount_options options;
 	struct nls_table *nls_disk;  /* Codepage used on disk */
 	struct nls_table *nls_io;    /* Charset used for input and display */
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

origin.patch
vfs-fix-unconditional-write_super-call-in-file_fsync.patch
fat-use-get-put_unaligned_-helpers.patch

