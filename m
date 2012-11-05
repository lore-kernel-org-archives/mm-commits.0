From: akpm@linux-foundation.org
Subject: [nacked] fat-exportfs-move-code-to-rebuild-directory-inode-to-separate-function.patch removed from -mm tree
Date: Mon, 05 Nov 2012 12:07:19 -0800
Message-ID: <20121105200720.23308200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:57126 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab2KEUHX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2012 15:07:23 -0500
Received: by mail-bk0-f74.google.com with SMTP id q16so396295bkw.1
        for <mm-commits@vger.kernel.org>; Mon, 05 Nov 2012 12:07:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, a.sahrawat@samsung.com, bfields@fieldses.org, hirofumi@mail.parknet.co.jp, ravi.n1@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: (exportfs) move code to rebuild directory-inode to separate function
has been removed from the -mm tree.  Its filename was
     fat-exportfs-move-code-to-rebuild-directory-inode-to-separate-function.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: fat: (exportfs) move code to rebuild directory-inode to separate function

Move the logic to rebuild directory inode (when mounted with nostale_ro)
to new function fat_rebuild_parent()

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/nfs.c |   71 ++++++++++++++++++++++++++++---------------------
 1 file changed, 42 insertions(+), 29 deletions(-)

diff -puN fs/fat/nfs.c~fat-exportfs-move-code-to-rebuild-directory-inode-to-separate-function fs/fat/nfs.c
--- a/fs/fat/nfs.c~fat-exportfs-move-code-to-rebuild-directory-inode-to-separate-function
+++ a/fs/fat/nfs.c
@@ -312,6 +312,45 @@ static int fat_read_next_clus(struct sup
 }
 
 /*
+ * Rebuild the parent for a directory that is not connected
+ * to the filesystem root
+ */
+static
+struct inode *fat_rebuild_parent(struct super_block *sb, int parent_logstart)
+{
+	int search_clus, clus_to_match;
+	struct msdos_dir_entry *de;
+	struct inode *parent;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	sector_t blknr = fat_clus_to_blknr(sbi, parent_logstart);
+	struct buffer_head *parent_bh = sb_bread(sb, blknr);
+
+	if (!parent_bh) {
+		fat_msg(sb, KERN_ERR,
+			"NFS:unable to read cluster of parent directory");
+		return NULL;
+	}
+	de = (struct msdos_dir_entry *) parent_bh->b_data;
+	clus_to_match = fat_get_start(sbi, &de[0]);
+	search_clus = fat_get_start(sbi, &de[1]);
+	if (!search_clus)
+		search_clus = sbi->root_cluster;
+	brelse(parent_bh);
+	do {
+		parent =  fat_traverse_cluster(sb,
+					search_clus, clus_to_match);
+		if (IS_ERR(parent) || parent)
+			break;
+		search_clus = fat_read_next_clus(sb, search_clus);
+		if (search_clus < 0)
+			break;
+	} while (search_clus != FAT_ENT_EOF);
+
+	return parent;
+
+
+}
+/*
  * Find the parent for a directory that is not currently connected to
  * the filesystem root.
  *
@@ -320,44 +359,18 @@ static int fat_read_next_clus(struct sup
 struct dentry *fat_get_parent(struct dentry *child_dir)
 {
 	struct super_block *sb = child_dir->d_sb;
-	struct buffer_head *dotdot_bh = NULL, *parent_bh = NULL;
+	struct buffer_head *dotdot_bh = NULL;
 	struct msdos_dir_entry *de;
 	struct inode *parent_inode = NULL;
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	int parent_logstart;
-	int search_clus, clus_to_match;
-	sector_t blknr;
 
 	if (!fat_get_dotdot_entry(child_dir->d_inode, &dotdot_bh, &de)) {
 		parent_logstart = fat_get_start(sbi, de);
 		parent_inode = fat_dget(sb, parent_logstart);
-		if (parent_inode || sbi->options.nfs != FAT_NFS_NOSTALE_RO)
-			goto out;
-		blknr = fat_clus_to_blknr(sbi, parent_logstart);
-		parent_bh = sb_bread(sb, blknr);
-		if (!parent_bh) {
-			fat_msg(sb, KERN_ERR,
-				"NFS:unable to read cluster of parent directory");
-			goto out;
-		}
-		de = (struct msdos_dir_entry *) parent_bh->b_data;
-		clus_to_match = fat_get_start(sbi, &de[0]);
-		search_clus = fat_get_start(sbi, &de[1]);
-		if (!search_clus)
-			search_clus = sbi->root_cluster;
-		brelse(parent_bh);
-		do {
-			parent_inode =  fat_traverse_cluster(sb,
-					search_clus, clus_to_match);
-			if (IS_ERR(parent_inode) || parent_inode)
-				break;
-			search_clus = fat_read_next_clus(sb,
-							search_clus);
-			if (search_clus < 0)
-				break;
-		} while (search_clus != FAT_ENT_EOF);
+		if (!parent_inode && sbi->options.nfs == FAT_NFS_NOSTALE_RO)
+			parent_inode = fat_rebuild_parent(sb, parent_logstart);
 	}
-out:
 	brelse(dotdot_bh);
 
 	return d_obtain_alias(parent_inode);
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

fat-add-mutex-lock-to-fat_build_inode.patch

