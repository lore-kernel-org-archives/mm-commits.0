From: akpm@linux-foundation.org
Subject: + fat-add-simple-validation-for-directory-inode.patch added to
 -mm tree
Date: Mon, 30 Nov 2015 14:40:12 -0800
Message-ID: <565cd04c.WY/tA8BOmlNHkZQ6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59981 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbbK3WkM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Nov 2015 17:40:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, vegard.nossum@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: add simple validation for directory inode
has been added to the -mm tree.  Its filename is
     fat-add-simple-validation-for-directory-inode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fat-add-simple-validation-for-directory-inode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fat-add-simple-validation-for-directory-inode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fat-add-simple-validation-for-directory-inode.patch

