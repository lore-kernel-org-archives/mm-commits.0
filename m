From: akpm@linux-foundation.org
Subject: + udf-create-common-function-for-changing-free-space-counter.patch added to -mm tree
Date: Tue, 15 Jan 2008 02:46:50 -0800
Message-ID: <200801151046.m0FAkUBF011669@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33155 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751222AbYAOKq4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 05:46:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, hch@infradead.org, jack@suse.cz


The patch titled
     udf: create common function for changing free space counter
has been added to the -mm tree.  Its filename is
     udf-create-common-function-for-changing-free-space-counter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 
+static bool udf_inc_free_space(struct udf_sb_info *sbi,
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
+			udf_inc_free_space(sbi, sbi->s_partition, 1);
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
+	if (udf_inc_free_space(sbi, partition, -alloc_count))
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
+	if (udf_inc_free_space(sbi, partition, -1))
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
+	if (udf_inc_free_space(sbi, sbi->s_partition, count))
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
+	if (alloc_count && udf_inc_free_space(sbi, partition, -alloc_count)) {
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
+	if (udf_inc_free_space(sbi, partition, -1))
 		mark_buffer_dirty(sbi->s_lvid_bh);
-	}
 
 	sb->s_dirt = 1;
 	mutex_unlock(&sbi->s_alloc_mutex);
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

git-alsa.patch
git-ocfs2.patch
ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol-checkpatch-fixes.patch
vgacon-fix-sparse-warning-about-shadowing-i-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-p-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-rotate-symbol.patch
byteorder-move-le32_add_cpu-friends-from-ocfs2-to-core.patch
ext3-replace-all-adds-to-little-endians-variables-with-le_add_cpu.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api.patch
udf-fix-coding-style-of-superc.patch
udf-remove-some-ugly-macros.patch
udf-convert-udf_sb_alloc_partmaps-macro-to-udf_sb_alloc_partition_maps-function.patch
udf-check-if-udf_load_logicalvol-failed.patch
udf-convert-macros-related-to-bitmaps-to-functions.patch
udf-move-calculating-of-nr_groups-into-helper-function.patch
udf-fix-sparse-warnings-shadowing-mismatch-between-declaration-and-definition.patch
udf-fix-coding-style.patch
udf-create-common-function-for-tag-checksumming.patch
udf-create-common-function-for-changing-free-space-counter.patch
udf-replace-loops-coded-with-goto-to-real-loops.patch
udf-convert-byte-order-of-constant-instead-of-variable.patch
udf-remove-udf_i_-macros-and-open-code-them.patch
udf-cache-struct-udf_inode_info.patch
udf-fix-udf_debug-macro.patch
udf-improve-readability-of-udf_load_partition.patch
udf-remove-wrong-prototype-of-udf_readdir.patch
udf-fix-3-signedness-1-unitialized-variable-warnings.patch
udf-fix-signedness-issue.patch
