From: akpm@linux-foundation.org
Subject: + fat-cleanup-msdos_lookup.patch added to -mm tree
Date: Thu, 16 Oct 2008 15:07:40 -0700
Message-ID: <200810162207.m9GM7eSW028096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756452AbYJPWHn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 18:07:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp


The patch titled
     fat: Cleanup msdos_lookup()
has been added to the -mm tree.  Its filename is
     fat-cleanup-msdos_lookup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat: Cleanup msdos_lookup()
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Use same style with vfat_lookup().

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/namei_msdos.c |   38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff -puN fs/fat/namei_msdos.c~fat-cleanup-msdos_lookup fs/fat/namei_msdos.c
--- a/fs/fat/namei_msdos.c~fat-cleanup-msdos_lookup
+++ a/fs/fat/namei_msdos.c
@@ -203,33 +203,37 @@ static struct dentry *msdos_lookup(struc
 {
 	struct super_block *sb = dir->i_sb;
 	struct fat_slot_info sinfo;
-	struct inode *inode = NULL;
-	int res;
-
-	dentry->d_op = &msdos_dentry_operations;
+	struct inode *inode;
+	int err;
 
 	lock_super(sb);
-	res = msdos_find(dir, dentry->d_name.name, dentry->d_name.len, &sinfo);
-	if (res == -ENOENT)
-		goto add;
-	if (res < 0)
-		goto out;
+
+	err = msdos_find(dir, dentry->d_name.name, dentry->d_name.len, &sinfo);
+	if (err) {
+		if (err == -ENOENT) {
+			inode = NULL;
+			goto out;
+		}
+		goto error;
+	}
+
 	inode = fat_build_inode(sb, sinfo.de, sinfo.i_pos);
 	brelse(sinfo.bh);
 	if (IS_ERR(inode)) {
-		res = PTR_ERR(inode);
-		goto out;
+		err = PTR_ERR(inode);
+		goto error;
 	}
-add:
-	res = 0;
+out:
+	unlock_super(sb);
+	dentry->d_op = &msdos_dentry_operations;
 	dentry = d_splice_alias(inode, dentry);
 	if (dentry)
 		dentry->d_op = &msdos_dentry_operations;
-out:
+	return dentry;
+
+error:
 	unlock_super(sb);
-	if (!res)
-		return dentry;
-	return ERR_PTR(res);
+	return ERR_PTR(err);
 }
 
 /***** Creates a directory entry (name is already formatted). */
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

origin.patch
fat-document-additional-vfat-mount-options.patch
fat-move-fs-vfat-and-fs-msdos-to-fs-fat.patch
fat-split-include-msdos_fsh.patch
fat-fix-and-cleanup-timestamp-conversion.patch
fat-use-generic_file_llseek-for-directory.patch
fat-cleanup-fat_parse_long-error-handling.patch
fat-improve-fat_hash.patch
fat-fix-fat_ent_update_ptr-for-fat12.patch
fat-use-fat_detach-in-fat_clear_inode.patch
vfat-fix-vfat_find-error-path-in-vfat_lookup.patch
fat-fix-cleanup-dcache-handling-for-vfat.patch
fat-kill-d_invalidate-in-vfat_lookup.patch
fat-cleanup-msdos_lookup.patch
fat-cleanup-fat-attribute-stuff.patch
fat-fix-attr_ro-in-the-case-of-umask-s_wugo-==-0.patch
fat-fix-attr_ro-for-directory.patch
fat-fix-_fat_bmap-race.patch
fat-add-printf-attribute-to-fat_fs_panic.patch
fat-mmu_private-race-fix.patch
fat-i_pos-race-fix.patch
fat-i_blocks-warning-fix.patch

