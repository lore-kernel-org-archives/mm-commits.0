From: akpm@linux-foundation.org
Subject: + fat-remove-parent_logstart-check-in-fat_get_parent.patch added to -mm tree
Date: Mon, 29 Oct 2012 16:49:50 -0700
Message-ID: <20121029234951.27F8E100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:35962 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932376Ab2J2Xtw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 19:49:52 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so405728qae.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 16:49:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namjae.jeon@samsung.com, a.sahrawat@samsung.com, hirofumi@mail.parknet.co.jp, ravi.n1@samsung.com


The patch titled
     Subject: fat: remove parent_logstart check in fat_get_parent
has been added to the -mm tree.  Its filename is
     fat-remove-parent_logstart-check-in-fat_get_parent.patch

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
Subject: fat: remove parent_logstart check in fat_get_parent

The root directory inode is added to the directory hash table in
fat_attach when mounted with nfs option.  Since root dentry never expires
until umount, fat_dget never fails to return the root inode for
subdirectories of root inode.i.e., parent_logstart cannot be zero.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
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

