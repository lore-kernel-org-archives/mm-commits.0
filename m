From: akpm@linux-foundation.org
Subject: + fat-exportfs-move-code-to-rebuild-directory-inode-to-separate-function.patch added to -mm tree
Date: Mon, 29 Oct 2012 16:50:01 -0700
Message-ID: <20121029235002.36EE51E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:35962 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761438Ab2J2XuD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 19:50:03 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so405728qae.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 16:50:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namjae.jeon@samsung.com, a.sahrawat@samsung.com, hirofumi@mail.parknet.co.jp, ravi.n1@samsung.com


The patch titled
     Subject: fat: (exportfs) move code to rebuild directory-inode to separate function
has been added to the -mm tree.  Its filename is
     fat-exportfs-move-code-to-rebuild-directory-inode-to-separate-function.patch

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
Subject: fat: (exportfs) move code to rebuild directory-inode to separate function

Move the logic to rebuild directory inode (when mounted with nostale_ro)
to new function fat_rebuild_parent()

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
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

