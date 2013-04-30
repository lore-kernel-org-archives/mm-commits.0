From: akpm@linux-foundation.org
Subject: [merged] fat-introduce-a-helper-fat_get_blknr_offset.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:01:45 -0700
Message-ID: <20130430190145.AE40A31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:59868 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933296Ab3D3TBq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:01:46 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so87378ggm.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:01:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, a.sahrawat@samsung.com, hirofumi@mail.parknet.co.jp, ravi.n1@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: introduce a helper fat_get_blknr_offset()
has been removed from the -mm tree.  Its filename was
     fat-introduce-a-helper-fat_get_blknr_offset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: fat: introduce a helper fat_get_blknr_offset()

Introduce helper function to get the block number and offset for a given
i_pos value.  Use it in __fat_write_inode() now and later on in nfs.c

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h   |    7 +++++++
 fs/fat/inode.c |    9 +++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

diff -puN fs/fat/fat.h~fat-introduce-a-helper-fat_get_blknr_offset fs/fat/fat.h
--- a/fs/fat/fat.h~fat-introduce-a-helper-fat_get_blknr_offset
+++ a/fs/fat/fat.h
@@ -218,6 +218,13 @@ static inline sector_t fat_clus_to_blknr
 		+ sbi->data_start;
 }
 
+static inline void fat_get_blknr_offset(struct msdos_sb_info *sbi,
+				loff_t i_pos, sector_t *blknr, int *offset)
+{
+	*blknr = i_pos >> sbi->dir_per_block_bits;
+	*offset = i_pos & (sbi->dir_per_block - 1);
+}
+
 static inline loff_t fat_i_pos_read(struct msdos_sb_info *sbi,
 					struct inode *inode)
 {
diff -puN fs/fat/inode.c~fat-introduce-a-helper-fat_get_blknr_offset fs/fat/inode.c
--- a/fs/fat/inode.c~fat-introduce-a-helper-fat_get_blknr_offset
+++ a/fs/fat/inode.c
@@ -662,7 +662,8 @@ static int __fat_write_inode(struct inod
 	struct buffer_head *bh;
 	struct msdos_dir_entry *raw_entry;
 	loff_t i_pos;
-	int err;
+	sector_t blocknr;
+	int err, offset;
 
 	if (inode->i_ino == MSDOS_ROOT_INO)
 		return 0;
@@ -672,7 +673,8 @@ retry:
 	if (!i_pos)
 		return 0;
 
-	bh = sb_bread(sb, i_pos >> sbi->dir_per_block_bits);
+	fat_get_blknr_offset(sbi, i_pos, &blocknr, &offset);
+	bh = sb_bread(sb, blocknr);
 	if (!bh) {
 		fat_msg(sb, KERN_ERR, "unable to read inode block "
 		       "for updating (i_pos %lld)", i_pos);
@@ -685,8 +687,7 @@ retry:
 		goto retry;
 	}
 
-	raw_entry = &((struct msdos_dir_entry *) (bh->b_data))
-	    [i_pos & (sbi->dir_per_block - 1)];
+	raw_entry = &((struct msdos_dir_entry *) (bh->b_data))[offset];
 	if (S_ISDIR(inode->i_mode))
 		raw_entry->size = 0;
 	else
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

origin.patch
linux-next.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-fix.patch

