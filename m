From: akpm@linux-foundation.org
Subject: + ext2-ext3-ext4-add-block-bitmap-validation.patch added to -mm tree
Date: Tue, 07 Aug 2007 18:18:52 -0700
Message-ID: <200708080118.l781IqOI014227@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47129 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755065AbXHHBTF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 21:19:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, adilger@clusterfs.com, cmm@us.ibm.com


The patch titled
     ext2/ext3/ext4: add block bitmap validation
has been added to the -mm tree.  Its filename is
     ext2-ext3-ext4-add-block-bitmap-validation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext2/ext3/ext4: add block bitmap validation
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

When a new block bitmap is read from disk in read_block_bitmap() there are
a few bits that should ALWAYS be set.  In particular, the blocks given by
ext4_blk_bitmap, ext4_inode_bitmap and ext4_inode_table.  Validate the
block bitmap against these blocks.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Acked-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/balloc.c |   56 +++++++++++++++++++++++++++++++---------
 fs/ext3/balloc.c |   53 ++++++++++++++++++++++++++++++--------
 fs/ext4/balloc.c |   62 ++++++++++++++++++++++++++++++++++-----------
 3 files changed, 133 insertions(+), 38 deletions(-)

diff -puN fs/ext2/balloc.c~ext2-ext3-ext4-add-block-bitmap-validation fs/ext2/balloc.c
--- a/fs/ext2/balloc.c~ext2-ext3-ext4-add-block-bitmap-validation
+++ a/fs/ext2/balloc.c
@@ -69,6 +69,14 @@ struct ext2_group_desc * ext2_get_group_
 	return desc + offset;
 }
 
+static inline int
+block_in_use(unsigned long block, struct super_block *sb, unsigned char *map)
+{
+	return ext2_test_bit ((block -
+		le32_to_cpu(EXT2_SB(sb)->s_es->s_first_data_block)) %
+			 EXT2_BLOCKS_PER_GROUP(sb), map);
+}
+
 /*
  * Read the bitmap for a given block_group, reading into the specified 
  * slot in the superblock's bitmap cache.
@@ -78,20 +86,51 @@ struct ext2_group_desc * ext2_get_group_
 static struct buffer_head *
 read_block_bitmap(struct super_block *sb, unsigned int block_group)
 {
+	int i;
 	struct ext2_group_desc * desc;
 	struct buffer_head * bh = NULL;
-	
+	unsigned int bitmap_blk;
+
 	desc = ext2_get_group_desc (sb, block_group, NULL);
 	if (!desc)
-		goto error_out;
-	bh = sb_bread(sb, le32_to_cpu(desc->bg_block_bitmap));
+		return NULL;
+	bitmap_blk = le32_to_cpu(desc->bg_block_bitmap);
+	bh = sb_bread(sb, bitmap_blk);
 	if (!bh)
-		ext2_error (sb, "read_block_bitmap",
+		ext2_error (sb, __FUNCTION__,
 			    "Cannot read block bitmap - "
 			    "block_group = %d, block_bitmap = %u",
 			    block_group, le32_to_cpu(desc->bg_block_bitmap));
-error_out:
+
+	/* check whether block bitmap block number is set */
+	if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
+		/* bad block bitmap */
+		goto error_out;
+	}
+	/* check whether the inode bitmap block number is set */
+	bitmap_blk = le32_to_cpu(desc->bg_inode_bitmap);
+	if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
+		/* bad block bitmap */
+		goto error_out;
+	}
+	/* check whether the inode table block number is set */
+	bitmap_blk = le32_to_cpu(desc->bg_inode_table);
+	for (i = 0; i < EXT2_SB(sb)->s_itb_per_group; i++, bitmap_blk++) {
+		if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
+			/* bad block bitmap */
+			goto error_out;
+		}
+	}
+
 	return bh;
+
+error_out:
+	brelse(bh);
+	ext2_error(sb, __FUNCTION__,
+			"Invalid block bitmap - "
+			"block_group = %d, block = %u",
+			block_group, bitmap_blk);
+	return NULL;
 }
 
 /*
@@ -583,13 +622,6 @@ unsigned long ext2_count_free_blocks (st
 #endif
 }
 
-static inline int
-block_in_use(unsigned long block, struct super_block *sb, unsigned char *map)
-{
-	return ext2_test_bit ((block -
-		le32_to_cpu(EXT2_SB(sb)->s_es->s_first_data_block)) %
-			 EXT2_BLOCKS_PER_GROUP(sb), map);
-}
 
 static inline int test_root(int a, int b)
 {
diff -puN fs/ext3/balloc.c~ext2-ext3-ext4-add-block-bitmap-validation fs/ext3/balloc.c
--- a/fs/ext3/balloc.c~ext2-ext3-ext4-add-block-bitmap-validation
+++ a/fs/ext3/balloc.c
@@ -79,6 +79,13 @@ struct ext3_group_desc * ext3_get_group_
 		*bh = sbi->s_group_desc[group_desc];
 	return desc + offset;
 }
+static inline int
+block_in_use(ext3_fsblk_t block, struct super_block *sb, unsigned char *map)
+{
+	return ext3_test_bit ((block -
+		le32_to_cpu(EXT3_SB(sb)->s_es->s_first_data_block)) %
+			 EXT3_BLOCKS_PER_GROUP(sb), map);
+}
 
 /**
  * read_block_bitmap()
@@ -93,20 +100,51 @@ struct ext3_group_desc * ext3_get_group_
 static struct buffer_head *
 read_block_bitmap(struct super_block *sb, unsigned int block_group)
 {
+	int i;
 	struct ext3_group_desc * desc;
 	struct buffer_head * bh = NULL;
+	ext3_fsblk_t bitmap_blk;
 
 	desc = ext3_get_group_desc (sb, block_group, NULL);
 	if (!desc)
-		goto error_out;
-	bh = sb_bread(sb, le32_to_cpu(desc->bg_block_bitmap));
+		return NULL;
+	bitmap_blk = le32_to_cpu(desc->bg_block_bitmap);
+	bh = sb_bread(sb, bitmap_blk);
 	if (!bh)
-		ext3_error (sb, "read_block_bitmap",
+		ext3_error (sb, __FUNCTION__,
 			    "Cannot read block bitmap - "
 			    "block_group = %d, block_bitmap = %u",
 			    block_group, le32_to_cpu(desc->bg_block_bitmap));
-error_out:
+
+	/* check whether block bitmap block number is set */
+	if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
+		/* bad block bitmap */
+		goto error_out;
+	}
+	/* check whether the inode bitmap block number is set */
+	bitmap_blk = le32_to_cpu(desc->bg_inode_bitmap);
+	if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
+		/* bad block bitmap */
+		goto error_out;
+	}
+	/* check whether the inode table block number is set */
+	bitmap_blk = le32_to_cpu(desc->bg_inode_table);
+	for (i = 0; i < EXT3_SB(sb)->s_itb_per_group; i++, bitmap_blk++) {
+		if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
+			/* bad block bitmap */
+			goto error_out;
+		}
+	}
+
 	return bh;
+
+error_out:
+	brelse(bh);
+	ext3_error(sb, __FUNCTION__,
+			"Invalid block bitmap - "
+			"block_group = %d, block = %lu",
+			block_group, bitmap_blk);
+	return NULL;
 }
 /*
  * The reservation window structure operations
@@ -1733,13 +1771,6 @@ ext3_fsblk_t ext3_count_free_blocks(stru
 #endif
 }
 
-static inline int
-block_in_use(ext3_fsblk_t block, struct super_block *sb, unsigned char *map)
-{
-	return ext3_test_bit ((block -
-		le32_to_cpu(EXT3_SB(sb)->s_es->s_first_data_block)) %
-			 EXT3_BLOCKS_PER_GROUP(sb), map);
-}
 
 static inline int test_root(int a, int b)
 {
diff -puN fs/ext4/balloc.c~ext2-ext3-ext4-add-block-bitmap-validation fs/ext4/balloc.c
--- a/fs/ext4/balloc.c~ext2-ext3-ext4-add-block-bitmap-validation
+++ a/fs/ext4/balloc.c
@@ -99,6 +99,15 @@ struct ext4_group_desc * ext4_get_group_
 		*bh = sbi->s_group_desc[group_desc];
 	return desc;
 }
+static inline int
+block_in_use(ext4_fsblk_t block, struct super_block *sb, unsigned char *map)
+{
+	ext4_grpblk_t offset;
+
+	ext4_get_group_no_and_offset(sb, block, NULL, &offset);
+	return ext4_test_bit (offset, map);
+}
+
 
 /**
  * read_block_bitmap()
@@ -113,21 +122,53 @@ struct ext4_group_desc * ext4_get_group_
 static struct buffer_head *
 read_block_bitmap(struct super_block *sb, unsigned int block_group)
 {
+	int i;
 	struct ext4_group_desc * desc;
 	struct buffer_head * bh = NULL;
+	ext4_fsblk_t bitmap_blk;
 
 	desc = ext4_get_group_desc (sb, block_group, NULL);
 	if (!desc)
-		goto error_out;
-	bh = sb_bread(sb, ext4_block_bitmap(sb, desc));
+		return NULL;
+	bitmap_blk = ext4_block_bitmap(sb, desc);
+	bh = sb_bread(sb, bitmap_blk);
 	if (!bh)
-		ext4_error (sb, "read_block_bitmap",
+		ext4_error (sb, __FUNCTION__,
 			    "Cannot read block bitmap - "
 			    "block_group = %d, block_bitmap = %llu",
-			    block_group,
-			    ext4_block_bitmap(sb, desc));
-error_out:
+			    block_group, bitmap_blk);
+
+	/* check whether block bitmap block number is set */
+	if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
+		/* bad block bitmap */
+		goto error_out;
+	}
+
+	/* check whether the inode bitmap block number is set */
+	bitmap_blk = ext4_inode_bitmap(sb, desc);
+	if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
+		/* bad block bitmap */
+		goto error_out;
+	}
+	/* check whether the inode table block number is set */
+	bitmap_blk = ext4_inode_table(sb, desc);
+	for (i = 0; i < EXT4_SB(sb)->s_itb_per_group; i++, bitmap_blk++) {
+		if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
+			/* bad block bitmap */
+			goto error_out;
+		}
+	}
+
 	return bh;
+
+error_out:
+	brelse(bh);
+	ext4_error(sb, __FUNCTION__,
+			"Invalid block bitmap - "
+			"block_group = %d, block = %llu",
+			block_group, bitmap_blk);
+	return NULL;
+
 }
 /*
  * The reservation window structure operations
@@ -1747,15 +1788,6 @@ ext4_fsblk_t ext4_count_free_blocks(stru
 #endif
 }
 
-static inline int
-block_in_use(ext4_fsblk_t block, struct super_block *sb, unsigned char *map)
-{
-	ext4_grpblk_t offset;
-
-	ext4_get_group_no_and_offset(sb, block, NULL, &offset);
-	return ext4_test_bit (offset, map);
-}
-
 static inline int test_root(int a, int b)
 {
 	int num = b;
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

ext2-ext3-ext4-add-block-bitmap-validation.patch
ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
