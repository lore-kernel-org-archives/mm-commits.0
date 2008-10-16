From: akpm@linux-foundation.org
Subject: + fat-use-fat_detach-in-fat_clear_inode.patch added to -mm tree
Date: Thu, 16 Oct 2008 15:07:32 -0700
Message-ID: <200810162207.m9GM7Ww9028070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755878AbYJPWHf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 18:07:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp


The patch titled
     fat: use fat_detach() in fat_clear_inode()
has been added to the -mm tree.  Its filename is
     fat-use-fat_detach-in-fat_clear_inode.patch

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
Subject: fat: use fat_detach() in fat_clear_inode()
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Use fat_detach() instead of opencoding it.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN fs/fat/inode.c~fat-use-fat_detach-in-fat_clear_inode fs/fat/inode.c
--- a/fs/fat/inode.c~fat-use-fat_detach-in-fat_clear_inode
+++ a/fs/fat/inode.c
@@ -429,13 +429,8 @@ static void fat_delete_inode(struct inod
 
 static void fat_clear_inode(struct inode *inode)
 {
-	struct super_block *sb = inode->i_sb;
-	struct msdos_sb_info *sbi = MSDOS_SB(sb);
-
-	spin_lock(&sbi->inode_hash_lock);
 	fat_cache_inval_inode(inode);
-	hlist_del_init(&MSDOS_I(inode)->i_fat_hash);
-	spin_unlock(&sbi->inode_hash_lock);
+	fat_detach(inode);
 }
 
 static void fat_write_super(struct super_block *sb)
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

