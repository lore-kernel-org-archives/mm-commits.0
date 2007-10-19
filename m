From: akpm@linux-foundation.org
Subject: - reiserfs-remove-first_zero_hint.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:49:50 -0700
Message-ID: <200710192249.l9JMnog1024011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55632 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966744AbXJSXFU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffm@suse.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: remove first_zero_hint
has been removed from the -mm tree.  Its filename was
     reiserfs-remove-first_zero_hint.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: reiserfs: remove first_zero_hint
From: Jeff Mahoney <jeffm@suse.com>

The first_zero_hint metadata caching was never actually used, and it's of
dubious optimization quality.  This patch removes it.

It doesn't actually shrink the size of the reiserfs_bitmap_info struct, since
that doesn't work with block sizes larger than 8K.  There was a big fixme in
there, and with all the work lately in allowing block size > page size, I
might as well kill the fixme as well.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/bitmap.c           |   29 ++++++++++++-----------------
 fs/reiserfs/resize.c           |    6 ------
 include/linux/reiserfs_fs_sb.h |    4 +---
 3 files changed, 13 insertions(+), 26 deletions(-)

diff -puN fs/reiserfs/bitmap.c~reiserfs-remove-first_zero_hint fs/reiserfs/bitmap.c
--- a/fs/reiserfs/bitmap.c~reiserfs-remove-first_zero_hint
+++ a/fs/reiserfs/bitmap.c
@@ -273,7 +273,7 @@ static inline int block_group_used(struc
 	 * to make a better decision. This favors long-term performace gain
 	 * with a better on-disk layout vs. a short term gain of skipping the
 	 * read and potentially having a bad placement. */
-	if (info->first_zero_hint == 0) {
+	if (info->free_count == UINT_MAX) {
 		struct buffer_head *bh = reiserfs_read_bitmap_block(s, bm);
 		brelse(bh);
 	}
@@ -1214,27 +1214,22 @@ void reiserfs_cache_bitmap_metadata(stru
 {
 	unsigned long *cur = (unsigned long *)(bh->b_data + bh->b_size);
 
-	info->first_zero_hint = 1 << (sb->s_blocksize_bits + 3);
+	/* The first bit must ALWAYS be 1 */
+	BUG_ON(!reiserfs_test_le_bit(0, (unsigned long *)bh->b_data));
+
+	info->free_count = 0;
 
 	while (--cur >= (unsigned long *)bh->b_data) {
-		int base = ((char *)cur - bh->b_data) << 3;
+		int i;
 
 		/* 0 and ~0 are special, we can optimize for them */
-		if (*cur == 0) {
-			info->first_zero_hint = base;
+		if (*cur == 0)
 			info->free_count += BITS_PER_LONG;
-		} else if (*cur != ~0L) {       /* A mix, investigate */
-			int b;
-			for (b = BITS_PER_LONG - 1; b >= 0; b--) {
-				if (!reiserfs_test_le_bit(b, cur)) {
-					info->first_zero_hint = base + b;
+		else if (*cur != ~0L)	/* A mix, investigate */
+			for (i = BITS_PER_LONG - 1; i >= 0; i--)
+				if (!reiserfs_test_le_bit(i, cur))
 					info->free_count++;
-				}
-			}
-		}
 	}
-	/* The first bit must ALWAYS be 1 */
-	BUG_ON(info->first_zero_hint == 0);
 }
 
 struct buffer_head *reiserfs_read_bitmap_block(struct super_block *sb,
@@ -1264,7 +1259,7 @@ struct buffer_head *reiserfs_read_bitmap
 		BUG_ON(!buffer_uptodate(bh));
 		BUG_ON(atomic_read(&bh->b_count) == 0);
 
-		if (info->first_zero_hint == 0)
+		if (info->free_count == UINT_MAX)
 			reiserfs_cache_bitmap_metadata(sb, bh, info);
 	}
 
@@ -1279,7 +1274,7 @@ int reiserfs_init_bitmap_cache(struct su
 	if (bitmap == NULL)
 		return -ENOMEM;
 
-	memset(bitmap, 0, sizeof (*bitmap) * SB_BMAP_NR(sb));
+	memset(bitmap, 0xff, sizeof(*bitmap) * SB_BMAP_NR(sb));
 
 	SB_AP_BITMAP(sb) = bitmap;
 
diff -puN fs/reiserfs/resize.c~reiserfs-remove-first_zero_hint fs/reiserfs/resize.c
--- a/fs/reiserfs/resize.c~reiserfs-remove-first_zero_hint
+++ a/fs/reiserfs/resize.c
@@ -143,7 +143,6 @@ int reiserfs_resize(struct super_block *
 			mark_buffer_dirty(bh);
 			sync_dirty_buffer(bh);
 			// update bitmap_info stuff
-			bitmap[i].first_zero_hint = 1;
 			bitmap[i].free_count = sb_blocksize(sb) * 8 - 1;
 			brelse(bh);
 		}
@@ -173,8 +172,6 @@ int reiserfs_resize(struct super_block *
 	for (i = block_r; i < s->s_blocksize * 8; i++)
 		reiserfs_test_and_clear_le_bit(i, bh->b_data);
 	info->free_count += s->s_blocksize * 8 - block_r;
-	if (!info->first_zero_hint)
-		info->first_zero_hint = block_r;
 
 	journal_mark_dirty(&th, s, bh);
 	brelse(bh);
@@ -196,9 +193,6 @@ int reiserfs_resize(struct super_block *
 	brelse(bh);
 
 	info->free_count -= s->s_blocksize * 8 - block_r_new;
-	/* Extreme case where last bitmap is the only valid block in itself. */
-	if (!info->free_count)
-		info->first_zero_hint = 0;
 	/* update super */
 	reiserfs_prepare_for_journal(s, SB_BUFFER_WITH_SB(s), 1);
 	free_blocks = SB_FREE_BLOCKS(s);
diff -puN include/linux/reiserfs_fs_sb.h~reiserfs-remove-first_zero_hint include/linux/reiserfs_fs_sb.h
--- a/include/linux/reiserfs_fs_sb.h~reiserfs-remove-first_zero_hint
+++ a/include/linux/reiserfs_fs_sb.h
@@ -265,9 +265,7 @@ enum journal_state_bits {
 typedef __u32(*hashf_t) (const signed char *, int);
 
 struct reiserfs_bitmap_info {
-	// FIXME: Won't work with block sizes > 8K
-	__u16 first_zero_hint;
-	__u16 free_count;
+	__u32 free_count;
 };
 
 struct proc_dir_entry;
_

Patches currently in -mm which might be from jeffm@suse.com are

origin.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
reiserfs-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
