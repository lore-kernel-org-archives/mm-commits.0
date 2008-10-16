From: akpm@linux-foundation.org
Subject: + fat-mmu_private-race-fix.patch added to -mm tree
Date: Thu, 16 Oct 2008 15:07:52 -0700
Message-ID: <200810162207.m9GM7q5l028131@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756688AbYJPWHz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 18:07:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp


The patch titled
     fat: mmu_private race fix
has been added to the -mm tree.  Its filename is
     fat-mmu_private-race-fix.patch

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
Subject: fat: mmu_private race fix
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

mmu_private is 64bits value, hence it's not atomic to update.

So, the access rule for mmu_private is we must hold ->i_mutex.  But,
fat_get_block() path doesn't follow the rule on non-allocation path.

This fixes by using i_size instead if non-allocation path.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/cache.c |   23 ++++++++++++++++++-----
 fs/fat/dir.c   |    2 +-
 fs/fat/fat.h   |    6 ++++--
 fs/fat/inode.c |    4 ++--
 4 files changed, 25 insertions(+), 10 deletions(-)

diff -puN fs/fat/cache.c~fat-mmu_private-race-fix fs/fat/cache.c
--- a/fs/fat/cache.c~fat-mmu_private-race-fix
+++ a/fs/fat/cache.c
@@ -293,10 +293,12 @@ static int fat_bmap_cluster(struct inode
 }
 
 int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
-	     unsigned long *mapped_blocks)
+	     unsigned long *mapped_blocks, int create)
 {
 	struct super_block *sb = inode->i_sb;
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	const unsigned long blocksize = sb->s_blocksize;
+	const unsigned char blocksize_bits = sb->s_blocksize_bits;
 	sector_t last_block;
 	int cluster, offset;
 
@@ -309,10 +311,21 @@ int fat_bmap(struct inode *inode, sector
 		}
 		return 0;
 	}
-	last_block = (MSDOS_I(inode)->mmu_private + (sb->s_blocksize - 1))
-		>> sb->s_blocksize_bits;
-	if (sector >= last_block)
-		return 0;
+
+	last_block = (i_size_read(inode) + (blocksize - 1)) >> blocksize_bits;
+	if (sector >= last_block) {
+		if (!create)
+			return 0;
+
+		/*
+		 * ->mmu_private can access on only allocation path.
+		 * (caller must hold ->i_mutex)
+		 */
+		last_block = (MSDOS_I(inode)->mmu_private + (blocksize - 1))
+			>> blocksize_bits;
+		if (sector >= last_block)
+			return 0;
+	}
 
 	cluster = sector >> (sbi->cluster_bits - sb->s_blocksize_bits);
 	offset  = sector & (sbi->sec_per_clus - 1);
diff -puN fs/fat/dir.c~fat-mmu_private-race-fix fs/fat/dir.c
--- a/fs/fat/dir.c~fat-mmu_private-race-fix
+++ a/fs/fat/dir.c
@@ -77,7 +77,7 @@ next:
 
 	*bh = NULL;
 	iblock = *pos >> sb->s_blocksize_bits;
-	err = fat_bmap(dir, iblock, &phys, &mapped_blocks);
+	err = fat_bmap(dir, iblock, &phys, &mapped_blocks, 0);
 	if (err || !phys)
 		return -1;	/* beyond EOF or error */
 
diff -puN fs/fat/fat.h~fat-mmu_private-race-fix fs/fat/fat.h
--- a/fs/fat/fat.h~fat-mmu_private-race-fix
+++ a/fs/fat/fat.h
@@ -91,7 +91,9 @@ struct msdos_inode_info {
 	/* for avoiding the race between fat_free() and fat_get_cluster() */
 	unsigned int cache_valid_id;
 
-	loff_t mmu_private;
+	/* NOTE: mmu_private is 64bits, so must hold ->i_mutex to access */
+	loff_t mmu_private;	/* physically allocated size */
+
 	int i_start;		/* first cluster or 0 */
 	int i_logstart;		/* logical first cluster */
 	int i_attrs;		/* unused attribute bits */
@@ -222,7 +224,7 @@ extern void fat_cache_inval_inode(struct
 extern int fat_get_cluster(struct inode *inode, int cluster,
 			   int *fclus, int *dclus);
 extern int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
-		    unsigned long *mapped_blocks);
+		    unsigned long *mapped_blocks, int create);
 
 /* fat/dir.c */
 extern const struct file_operations fat_dir_operations;
diff -puN fs/fat/inode.c~fat-mmu_private-race-fix fs/fat/inode.c
--- a/fs/fat/inode.c~fat-mmu_private-race-fix
+++ a/fs/fat/inode.c
@@ -64,7 +64,7 @@ static inline int __fat_get_block(struct
 	sector_t phys;
 	int err, offset;
 
-	err = fat_bmap(inode, iblock, &phys, &mapped_blocks);
+	err = fat_bmap(inode, iblock, &phys, &mapped_blocks, create);
 	if (err)
 		return err;
 	if (phys) {
@@ -94,7 +94,7 @@ static inline int __fat_get_block(struct
 	*max_blocks = min(mapped_blocks, *max_blocks);
 	MSDOS_I(inode)->mmu_private += *max_blocks << sb->s_blocksize_bits;
 
-	err = fat_bmap(inode, iblock, &phys, &mapped_blocks);
+	err = fat_bmap(inode, iblock, &phys, &mapped_blocks, create);
 	if (err)
 		return err;
 
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

