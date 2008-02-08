From: akpm@linux-foundation.org
Subject: - udf-create-common-function-for-changing-free-space-counter.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:17:27 -0800
Message-ID: <200802082017.m18KH8NY010791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38244 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757531AbYBHVBg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:01:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, hch@infradead.org, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     udf: create common function for changing free space counter
has been removed from the -mm tree.  Its filename was
     udf-create-common-function-for-changing-free-space-counter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: udf: create common function for changing free space counter
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/balloc.c |   49 ++++++++++++++++++----------------------------
 1 file changed, 20 insertions(+), 29 deletions(-)

diff -puN fs/udf/balloc.c~udf-create-common-function-for-changing-free-space-counter fs/udf/balloc.c
--- a/fs/udf/balloc.c~udf-create-common-function-for-changing-free-space-counter
+++ a/fs/udf/balloc.c
@@ -140,6 +140,20 @@ static inline int load_block_bitmap(stru
 	return slot;
 }
 
+static bool udf_add_free_space(struct udf_sb_info *sbi,
+				u16 partition, u32 cnt)
+{
+	struct logicalVolIntegrityDesc *lvid;
+
+	if (sbi->s_lvid_bh)
+		return false;
+
+	lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
+	lvid->freeSpaceTable[partition] = cpu_to_le32(le32_to_cpu(
+					lvid->freeSpaceTable[partition]) + cnt);
+	return true;
+}
+
 static void udf_bitmap_free_blocks(struct super_block *sb,
 				   struct inode *inode,
 				   struct udf_bitmap *bitmap,
@@ -194,11 +208,7 @@ do_more:
 		} else {
 			if (inode)
 				DQUOT_FREE_BLOCK(inode, 1);
-			if (sbi->s_lvid_bh) {
-				struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
-				lvid->freeSpaceTable[sbi->s_partition] =
-					cpu_to_le32(le32_to_cpu(lvid->freeSpaceTable[sbi->s_partition]) + 1);
-			}
+			udf_add_free_space(sbi, sbi->s_partition, 1);
 		}
 	}
 	mark_buffer_dirty(bh);
@@ -268,12 +278,8 @@ repeat:
 	if (block_count > 0)
 		goto repeat;
 out:
-	if (sbi->s_lvid_bh) {
-		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
-		lvid->freeSpaceTable[partition] =
-			cpu_to_le32(le32_to_cpu(lvid->freeSpaceTable[partition]) - alloc_count);
+	if (udf_add_free_space(sbi, partition, -alloc_count))
 		mark_buffer_dirty(sbi->s_lvid_bh);
-	}
 	sb->s_dirt = 1;
 	mutex_unlock(&sbi->s_alloc_mutex);
 	return alloc_count;
@@ -404,12 +410,8 @@ got_block:
 
 	mark_buffer_dirty(bh);
 
-	if (sbi->s_lvid_bh) {
-		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
-		lvid->freeSpaceTable[partition] =
-			cpu_to_le32(le32_to_cpu(lvid->freeSpaceTable[partition]) - 1);
+	if (udf_add_free_space(sbi, partition, -1))
 		mark_buffer_dirty(sbi->s_lvid_bh);
-	}
 	sb->s_dirt = 1;
 	mutex_unlock(&sbi->s_alloc_mutex);
 	*err = 0;
@@ -450,12 +452,8 @@ static void udf_table_free_blocks(struct
 	   could occure, but.. oh well */
 	if (inode)
 		DQUOT_FREE_BLOCK(inode, count);
-	if (sbi->s_lvid_bh) {
-		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
-		lvid->freeSpaceTable[sbi->s_partition] =
-			cpu_to_le32(le32_to_cpu(lvid->freeSpaceTable[sbi->s_partition]) + count);
+	if (udf_add_free_space(sbi, sbi->s_partition, count))
 		mark_buffer_dirty(sbi->s_lvid_bh);
-	}
 
 	start = bloc.logicalBlockNum + offset;
 	end = bloc.logicalBlockNum + offset + count - 1;
@@ -719,10 +717,7 @@ static int udf_table_prealloc_blocks(str
 
 	brelse(epos.bh);
 
-	if (alloc_count && sbi->s_lvid_bh) {
-		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
-		lvid->freeSpaceTable[partition] =
-			cpu_to_le32(le32_to_cpu(lvid->freeSpaceTable[partition]) - alloc_count);
+	if (alloc_count && udf_add_free_space(sbi, partition, -alloc_count)) {
 		mark_buffer_dirty(sbi->s_lvid_bh);
 		sb->s_dirt = 1;
 	}
@@ -822,12 +817,8 @@ static int udf_table_new_block(struct su
 		udf_delete_aext(table, goal_epos, goal_eloc, goal_elen);
 	brelse(goal_epos.bh);
 
-	if (sbi->s_lvid_bh) {
-		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
-		lvid->freeSpaceTable[partition] =
-			cpu_to_le32(le32_to_cpu(lvid->freeSpaceTable[partition]) - 1);
+	if (udf_add_free_space(sbi, partition, -1))
 		mark_buffer_dirty(sbi->s_lvid_bh);
-	}
 
 	sb->s_dirt = 1;
 	mutex_unlock(&sbi->s_alloc_mutex);
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix.patch
