From: akpm@linux-foundation.org
Subject: - fat-i_blocks-warning-fix.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:33:47 -0800
Message-ID: <200811102033.mAAKXl3I024680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753435AbYKJUeT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:34:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fat: i_blocks warning fix
has been removed from the -mm tree.  Its filename was
     fat-i_blocks-warning-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

