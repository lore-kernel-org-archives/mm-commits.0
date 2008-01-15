From: akpm@linux-foundation.org
Subject: + udf-replace-loops-coded-with-goto-to-real-loops.patch added to -mm tree
Date: Tue, 15 Jan 2008 02:46:52 -0800
Message-ID: <200801151046.m0FAkWXL011672@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41247 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751028AbYAOKqx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 05:46:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, hch@infradead.org, jack@suse.cz


The patch titled
     udf: replace loops coded with goto to real loops
has been added to the -mm tree.  Its filename is
     udf-replace-loops-coded-with-goto-to-real-loops.patch

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
Subject: udf: replace loops coded with goto to real loops
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/balloc.c |  118 +++++++++++++++++++++++-----------------------
 1 file changed, 59 insertions(+), 59 deletions(-)

diff -puN fs/udf/balloc.c~udf-replace-loops-coded-with-goto-to-real-loops fs/udf/balloc.c
--- a/fs/udf/balloc.c~udf-replace-loops-coded-with-goto-to-real-loops
+++ a/fs/udf/balloc.c
@@ -183,46 +183,46 @@ static void udf_bitmap_free_blocks(struc
 	block = bloc.logicalBlockNum + offset +
 		(sizeof(struct spaceBitmapDesc) << 3);
 
-do_more:
-	overflow = 0;
-	block_group = block >> (sb->s_blocksize_bits + 3);
-	bit = block % (sb->s_blocksize << 3);
+	do {
+		overflow = 0;
+		block_group = block >> (sb->s_blocksize_bits + 3);
+		bit = block % (sb->s_blocksize << 3);
 
-	/*
-	 * Check to see if we are freeing blocks across a group boundary.
-	 */
-	if (bit + count > (sb->s_blocksize << 3)) {
-		overflow = bit + count - (sb->s_blocksize << 3);
-		count -= overflow;
-	}
-	bitmap_nr = load_block_bitmap(sb, bitmap, block_group);
-	if (bitmap_nr < 0)
-		goto error_return;
+		/*
+		* Check to see if we are freeing blocks across a group boundary.
+		*/
+		if (bit + count > (sb->s_blocksize << 3)) {
+			overflow = bit + count - (sb->s_blocksize << 3);
+			count -= overflow;
+		}
+		bitmap_nr = load_block_bitmap(sb, bitmap, block_group);
+		if (bitmap_nr < 0)
+			goto error_return;
 
-	bh = bitmap->s_block_bitmap[bitmap_nr];
-	for (i = 0; i < count; i++) {
-		if (udf_set_bit(bit + i, bh->b_data)) {
-			udf_debug("bit %ld already set\n", bit + i);
-			udf_debug("byte=%2x\n",
-				  ((char *)bh->b_data)[(bit + i) >> 3]);
-		} else {
-			if (inode)
-				DQUOT_FREE_BLOCK(inode, 1);
-			udf_inc_free_space(sbi, sbi->s_partition, 1);
+		bh = bitmap->s_block_bitmap[bitmap_nr];
+		for (i = 0; i < count; i++) {
+			if (udf_set_bit(bit + i, bh->b_data)) {
+				udf_debug("bit %ld already set\n", bit + i);
+				udf_debug("byte=%2x\n",
+					((char *)bh->b_data)[(bit + i) >> 3]);
+			} else {
+				if (inode)
+					DQUOT_FREE_BLOCK(inode, 1);
+				udf_inc_free_space(sbi, sbi->s_partition, 1);
+			}
 		}
-	}
-	mark_buffer_dirty(bh);
-	if (overflow) {
-		block += count;
-		count = overflow;
-		goto do_more;
-	}
+		mark_buffer_dirty(bh);
+		if (overflow) {
+			block += count;
+			count = overflow;
+		}
+	} while (overflow);
+
 error_return:
 	sb->s_dirt = 1;
 	if (sbi->s_lvid_bh)
 		mark_buffer_dirty(sbi->s_lvid_bh);
 	mutex_unlock(&sbi->s_alloc_mutex);
-	return;
 }
 
 static int udf_bitmap_prealloc_blocks(struct super_block *sb,
@@ -246,37 +246,37 @@ static int udf_bitmap_prealloc_blocks(st
 	if (first_block + block_count > part_len)
 		block_count = part_len - first_block;
 
-repeat:
-	nr_groups = udf_compute_nr_groups(sb, partition);
-	block = first_block + (sizeof(struct spaceBitmapDesc) << 3);
-	block_group = block >> (sb->s_blocksize_bits + 3);
-	group_start = block_group ? 0 : sizeof(struct spaceBitmapDesc);
+	do {
+		nr_groups = udf_compute_nr_groups(sb, partition);
+		block = first_block + (sizeof(struct spaceBitmapDesc) << 3);
+		block_group = block >> (sb->s_blocksize_bits + 3);
+		group_start = block_group ? 0 : sizeof(struct spaceBitmapDesc);
 
-	bitmap_nr = load_block_bitmap(sb, bitmap, block_group);
-	if (bitmap_nr < 0)
-		goto out;
-	bh = bitmap->s_block_bitmap[bitmap_nr];
+		bitmap_nr = load_block_bitmap(sb, bitmap, block_group);
+		if (bitmap_nr < 0)
+			goto out;
+		bh = bitmap->s_block_bitmap[bitmap_nr];
 
-	bit = block % (sb->s_blocksize << 3);
+		bit = block % (sb->s_blocksize << 3);
 
-	while (bit < (sb->s_blocksize << 3) && block_count > 0) {
-		if (!udf_test_bit(bit, bh->b_data)) {
-			goto out;
-		} else if (DQUOT_PREALLOC_BLOCK(inode, 1)) {
-			goto out;
-		} else if (!udf_clear_bit(bit, bh->b_data)) {
-			udf_debug("bit already cleared for block %d\n", bit);
-			DQUOT_FREE_BLOCK(inode, 1);
-			goto out;
+		while (bit < (sb->s_blocksize << 3) && block_count > 0) {
+			if (!udf_test_bit(bit, bh->b_data))
+				goto out;
+			else if (DQUOT_PREALLOC_BLOCK(inode, 1))
+				goto out;
+			else if (!udf_clear_bit(bit, bh->b_data)) {
+				udf_debug("bit already cleared for block %d\n", bit);
+				DQUOT_FREE_BLOCK(inode, 1);
+				goto out;
+			}
+			block_count--;
+			alloc_count++;
+			bit++;
+			block++;
 		}
-		block_count--;
-		alloc_count++;
-		bit++;
-		block++;
-	}
-	mark_buffer_dirty(bh);
-	if (block_count > 0)
-		goto repeat;
+		mark_buffer_dirty(bh);
+	} while (block_count > 0);
+
 out:
 	if (udf_inc_free_space(sbi, partition, -alloc_count))
 		mark_buffer_dirty(sbi->s_lvid_bh);
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
