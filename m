From: akpm@linux-foundation.org
Subject: + fat-i_blocks-warning-fix.patch added to -mm tree
Date: Thu, 16 Oct 2008 15:07:56 -0700
Message-ID: <200810162207.m9GM7u7u028147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41272 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756822AbYJPWH7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 18:07:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp


The patch titled
     fat: i_blocks warning fix
has been added to the -mm tree.  Its filename is
     fat-i_blocks-warning-fix.patch

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
Subject: fat: i_blocks warning fix
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

blkcnt_t type depends on CONFIG_LSF. Use unsigned long long always for
printk().  But lazy to type it, so add "llu" and use it.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c    |    2 +-
 fs/fat/fat.h    |    3 +++
 fs/fat/fatent.c |    5 ++---
 fs/fat/misc.c   |    5 +++--
 4 files changed, 9 insertions(+), 6 deletions(-)

diff -puN fs/fat/dir.c~fat-i_blocks-warning-fix fs/fat/dir.c
--- a/fs/fat/dir.c~fat-i_blocks-warning-fix
+++ a/fs/fat/dir.c
@@ -86,7 +86,7 @@ next:
 	*bh = sb_bread(sb, phys);
 	if (*bh == NULL) {
 		printk(KERN_ERR "FAT: Directory bread(block %llu) failed\n",
-		       (unsigned long long)phys);
+		       (llu)phys);
 		/* skip this block */
 		*pos = (iblock + 1) << sb->s_blocksize_bits;
 		goto next;
diff -puN fs/fat/fat.h~fat-i_blocks-warning-fix fs/fat/fat.h
--- a/fs/fat/fat.h~fat-i_blocks-warning-fix
+++ a/fs/fat/fat.h
@@ -323,4 +323,7 @@ extern int fat_sync_bhs(struct buffer_he
 int fat_cache_init(void);
 void fat_cache_destroy(void);
 
+/* helper for printk */
+typedef unsigned long long	llu;
+
 #endif /* !_FAT_H */
diff -puN fs/fat/fatent.c~fat-i_blocks-warning-fix fs/fat/fatent.c
--- a/fs/fat/fatent.c~fat-i_blocks-warning-fix
+++ a/fs/fat/fatent.c
@@ -93,8 +93,7 @@ static int fat12_ent_bread(struct super_
 err_brelse:
 	brelse(bhs[0]);
 err:
-	printk(KERN_ERR "FAT: FAT read failed (blocknr %llu)\n",
-	       (unsigned long long)blocknr);
+	printk(KERN_ERR "FAT: FAT read failed (blocknr %llu)\n", (llu)blocknr);
 	return -EIO;
 }
 
@@ -107,7 +106,7 @@ static int fat_ent_bread(struct super_bl
 	fatent->bhs[0] = sb_bread(sb, blocknr);
 	if (!fatent->bhs[0]) {
 		printk(KERN_ERR "FAT: FAT read failed (blocknr %llu)\n",
-		       (unsigned long long)blocknr);
+		       (llu)blocknr);
 		return -EIO;
 	}
 	fatent->nr_bhs = 1;
diff -puN fs/fat/misc.c~fat-i_blocks-warning-fix fs/fat/misc.c
--- a/fs/fat/misc.c~fat-i_blocks-warning-fix
+++ a/fs/fat/misc.c
@@ -124,8 +124,9 @@ int fat_chain_add(struct inode *inode, i
 			mark_inode_dirty(inode);
 	}
 	if (new_fclus != (inode->i_blocks >> (sbi->cluster_bits - 9))) {
-		fat_fs_panic(sb, "clusters badly computed (%d != %lu)",
-			new_fclus, inode->i_blocks >> (sbi->cluster_bits - 9));
+		fat_fs_panic(sb, "clusters badly computed (%d != %llu)",
+			     new_fclus,
+			     (llu)(inode->i_blocks >> (sbi->cluster_bits - 9)));
 		fat_cache_inval_inode(inode);
 	}
 	inode->i_blocks += nr_cluster << (sbi->cluster_bits - 9);
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

