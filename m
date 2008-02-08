From: akpm@linux-foundation.org
Subject: - udf-replace-loops-coded-with-goto-to-real-loops.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:17:29 -0800
Message-ID: <200802082017.m18KHARj010794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57332 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754754AbYBHVCH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:02:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, hch@infradead.org, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     udf: replace loops coded with goto to real loops
has been removed from the -mm tree.  Its filename was
     udf-replace-loops-coded-with-goto-to-real-loops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
-			udf_add_free_space(sbi, sbi->s_partition, 1);
+		bh = bitmap->s_block_bitmap[bitmap_nr];
+		for (i = 0; i < count; i++) {
+			if (udf_set_bit(bit + i, bh->b_data)) {
+				udf_debug("bit %ld already set\n", bit + i);
+				udf_debug("byte=%2x\n",
+					((char *)bh->b_data)[(bit + i) >> 3]);
+			} else {
+				if (inode)
+					DQUOT_FREE_BLOCK(inode, 1);
+				udf_add_free_space(sbi, sbi->s_partition, 1);
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
 	if (udf_add_free_space(sbi, partition, -alloc_count))
 		mark_buffer_dirty(sbi->s_lvid_bh);
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix.patch
