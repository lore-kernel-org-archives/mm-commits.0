From: akpm@linux-foundation.org
Subject: [merged] fat-add-simple-validation-for-directory-inode.patch
 removed from -mm tree
Date: Thu, 21 Jan 2016 14:59:30 -0800
Message-ID: <56a162d2.pyC1nJ11w55gsghE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbcAUW7b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:59:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, vegard.nossum@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: add simple validation for directory inode
has been removed from the -mm tree.  Its filename was
     fat-add-simple-validation-for-directory-inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: fat: add simple validation for directory inode

This detects simple corruption cases of directory, and tries to avoid
further damage to user data.

And performance impact of this validation should be very low, or not
measurable.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Tested-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN fs/fat/inode.c~fat-add-simple-validation-for-directory-inode fs/fat/inode.c
--- a/fs/fat/inode.c~fat-add-simple-validation-for-directory-inode
+++ a/fs/fat/inode.c
@@ -449,6 +449,24 @@ static int fat_calc_dir_size(struct inod
 	return 0;
 }
 
+static int fat_validate_dir(struct inode *dir)
+{
+	struct super_block *sb = dir->i_sb;
+
+	if (dir->i_nlink < 2) {
+		/* Directory should have "."/".." entries at least. */
+		fat_fs_error(sb, "corrupted directory (invalid entries)");
+		return -EIO;
+	}
+	if (MSDOS_I(dir)->i_start == 0 ||
+	    MSDOS_I(dir)->i_start == MSDOS_SB(sb)->root_cluster) {
+		/* Directory should point valid cluster. */
+		fat_fs_error(sb, "corrupted directory (invalid i_start)");
+		return -EIO;
+	}
+	return 0;
+}
+
 /* doesn't deal with root inode */
 int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de)
 {
@@ -475,6 +493,10 @@ int fat_fill_inode(struct inode *inode,
 		MSDOS_I(inode)->mmu_private = inode->i_size;
 
 		set_nlink(inode, fat_subdirs(inode));
+
+		error = fat_validate_dir(inode);
+		if (error < 0)
+			return error;
 	} else { /* not a directory */
 		inode->i_generation |= 1;
 		inode->i_mode = fat_make_mode(sbi, de->attr,
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are


