From: akpm@linux-foundation.org
Subject: + fat-introduce-a-helper-fat_get_blknr_offset.patch added to -mm tree
Date: Thu, 14 Mar 2013 14:36:38 -0700
Message-ID: <20130314213638.CECDF5A4213@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:44069 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab3CNVgk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 17:36:40 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so98713vcb.5
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 14:36:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namjae.jeon@samsung.com, a.sahrawat@samsung.com, hirofumi@mail.parknet.co.jp, ravi.n1@samsung.com


The patch titled
     Subject: fat: introduce a helper fat_get_blknr_offset()
has been added to the -mm tree.  Its filename is
     fat-introduce-a-helper-fat_get_blknr_offset.patch

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

linux-next.patch
fat-introduce-2-new-values-for-the-o-nfs-mount-option.patch
fat-move-fat_i_pos_read-to-fath.patch
fat-introduce-a-helper-fat_get_blknr_offset.patch
fat-restructure-export_operations.patch
fat-exportfs-rebuild-inode-if-ilookup-fails.patch
fat-exportfs-rebuild-directory-inode-if-fat_dget.patch
documentation-update-nfs-option-in-filesystem-vfattxt.patch

