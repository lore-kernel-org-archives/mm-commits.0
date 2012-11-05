From: akpm@linux-foundation.org
Subject: [nacked] fat-remove-parent_logstart-check-in-fat_get_parent.patch removed from -mm tree
Date: Mon, 05 Nov 2012 12:07:08 -0800
Message-ID: <20121105200709.15D4A20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:47869 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab2KEUHL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2012 15:07:11 -0500
Received: by mail-wi0-f202.google.com with SMTP id hr7so273538wib.1
        for <mm-commits@vger.kernel.org>; Mon, 05 Nov 2012 12:07:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, a.sahrawat@samsung.com, bfields@fieldses.org, hirofumi@mail.parknet.co.jp, ravi.n1@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: remove parent_logstart check in fat_get_parent
has been removed from the -mm tree.  Its filename was
     fat-remove-parent_logstart-check-in-fat_get_parent.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: fat: remove parent_logstart check in fat_get_parent

The root directory inode is added to the directory hash table in
fat_attach when mounted with nfs option.  Since root dentry never expires
until umount, fat_dget never fails to return the root inode for
subdirectories of root inode.i.e., parent_logstart cannot be zero.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/nfs.c |   51 +++++++++++++++++++++----------------------------
 1 file changed, 22 insertions(+), 29 deletions(-)

diff -puN fs/fat/nfs.c~fat-remove-parent_logstart-check-in-fat_get_parent fs/fat/nfs.c
--- a/fs/fat/nfs.c~fat-remove-parent_logstart-check-in-fat_get_parent
+++ a/fs/fat/nfs.c
@@ -274,36 +274,29 @@ struct dentry *fat_get_parent(struct den
 		parent_inode = fat_dget(sb, parent_logstart);
 		if (parent_inode || sbi->options.nfs != FAT_NFS_NOSTALE_RO)
 			goto out;
-		if (!parent_logstart)
-			/*logstart of dotdot entry is zero if
-			* if the directory's parent is root
-			*/
-			parent_inode = sb->s_root->d_inode;
-		else {
-			blknr = fat_clus_to_blknr(sbi, parent_logstart);
-			parent_bh = sb_bread(sb, blknr);
-			if (!parent_bh) {
-				fat_msg(sb, KERN_ERR,
-					"NFS:unable to read cluster of parent directory");
-				goto out;
-			}
-			de = (struct msdos_dir_entry *) parent_bh->b_data;
-			clus_to_match = fat_get_start(sbi, &de[0]);
-			search_clus = fat_get_start(sbi, &de[1]);
-			if (!search_clus)
-				search_clus = sbi->root_cluster;
-			brelse(parent_bh);
-			do {
-				parent_inode =  fat_traverse_cluster(sb,
-						search_clus, clus_to_match);
-				if (IS_ERR(parent_inode) || parent_inode)
-					break;
-				search_clus = fat_read_next_clus(sb,
-								search_clus);
-				if (search_clus < 0)
-					break;
-			} while (search_clus != FAT_ENT_EOF);
+		blknr = fat_clus_to_blknr(sbi, parent_logstart);
+		parent_bh = sb_bread(sb, blknr);
+		if (!parent_bh) {
+			fat_msg(sb, KERN_ERR,
+				"NFS:unable to read cluster of parent directory");
+			goto out;
 		}
+		de = (struct msdos_dir_entry *) parent_bh->b_data;
+		clus_to_match = fat_get_start(sbi, &de[0]);
+		search_clus = fat_get_start(sbi, &de[1]);
+		if (!search_clus)
+			search_clus = sbi->root_cluster;
+		brelse(parent_bh);
+		do {
+			parent_inode =  fat_traverse_cluster(sb,
+					search_clus, clus_to_match);
+			if (IS_ERR(parent_inode) || parent_inode)
+				break;
+			search_clus = fat_read_next_clus(sb,
+							search_clus);
+			if (search_clus < 0)
+				break;
+		} while (search_clus != FAT_ENT_EOF);
 	}
 out:
 	brelse(dotdot_bh);
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

fat-restructure-export-operations.patch
fat-move-fat_i_pos_read-to-fath.patch
fat-exportfs-move-code-to-rebuild-directory-inode-to-separate-function.patch
fat-add-mutex-lock-to-fat_build_inode.patch

