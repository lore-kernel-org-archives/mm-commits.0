From: akpm@linux-foundation.org
Subject: + reiserfs-ignore-on-disk-s_bmap_nr-value.patch added to -mm tree
Date: Wed, 17 Oct 2007 15:16:12 -0700
Message-ID: <200710172216.l9HMGCee011061@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58547 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757059AbXJQWQe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 18:16:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeffm@suse.com, hch@lst.de, mason@suse.com, vs@namesys.com


The patch titled
     reiserfs: ignore on disk s_bmap_nr value
has been added to the -mm tree.  Its filename is
     reiserfs-ignore-on-disk-s_bmap_nr-value.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiserfs: ignore on disk s_bmap_nr value
From: Jeff Mahoney <jeffm@suse.com>

Implement support for file systems larger than 8 TiB.

The reiserfs superblock contains a 16 bit value for counting the number of
bitmap blocks.  The rest of the disk format supports file systems up to 2^32
blocks, but the bitmap block limitation artificially limits this to 8 TiB with
a 4KiB block size.

Rather than trust the superblock's 16-bit bitmap block count, we calculate it
dynamically based on the number of blocks in the file system.  When an
incorrect value is observed in the superblock, it is zeroed out, ensuring that
older kernels will not be able to mount the file system.

Userspace support has already been implemented and shipped in reiserfsprogs
3.6.20.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chris Mason <mason@suse.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/bitmap.c        |   39 +++++++++++++++++++---------------
 fs/reiserfs/journal.c       |    6 ++---
 fs/reiserfs/resize.c        |    6 ++---
 fs/reiserfs/super.c         |   15 +++++++++++++
 include/linux/reiserfs_fs.h |    5 ++++
 5 files changed, 48 insertions(+), 23 deletions(-)

diff -puN fs/reiserfs/bitmap.c~reiserfs-ignore-on-disk-s_bmap_nr-value fs/reiserfs/bitmap.c
--- a/fs/reiserfs/bitmap.c~reiserfs-ignore-on-disk-s_bmap_nr-value
+++ a/fs/reiserfs/bitmap.c
@@ -61,6 +61,7 @@ static inline void get_bit_address(struc
 int is_reusable(struct super_block *s, b_blocknr_t block, int bit_value)
 {
 	unsigned int bmap, offset;
+	unsigned int bmap_count = reiserfs_bmap_count(s);
 
 	if (block == 0 || block >= SB_BLOCK_COUNT(s)) {
 		reiserfs_warning(s,
@@ -76,25 +77,26 @@ int is_reusable(struct super_block *s, b
 	if (unlikely(test_bit(REISERFS_OLD_FORMAT,
 			      &(REISERFS_SB(s)->s_properties)))) {
 		b_blocknr_t bmap1 = REISERFS_SB(s)->s_sbh->b_blocknr + 1;
-		if (block >= bmap1 && block <= bmap1 + SB_BMAP_NR(s)) {
+		if (block >= bmap1 &&
+		    block <= bmap1 + bmap_count) {
 			reiserfs_warning(s, "vs: 4019: is_reusable: "
 					 "bitmap block %lu(%u) can't be freed or reused",
-					 block, SB_BMAP_NR(s));
+					 block, bmap_count);
 			return 0;
 		}
 	} else {
 		if (offset == 0) {
 			reiserfs_warning(s, "vs: 4020: is_reusable: "
 					 "bitmap block %lu(%u) can't be freed or reused",
-					 block, SB_BMAP_NR(s));
+					 block, bmap_count);
 			return 0;
 		}
 	}
 
-	if (bmap >= SB_BMAP_NR(s)) {
+	if (bmap >= bmap_count) {
 		reiserfs_warning(s,
 				 "vs-4030: is_reusable: there is no so many bitmap blocks: "
-				 "block=%lu, bitmap_nr=%d", block, bmap);
+				 "block=%lu, bitmap_nr=%u", block, bmap);
 		return 0;
 	}
 
@@ -143,8 +145,8 @@ static int scan_bitmap_block(struct reis
 
 	BUG_ON(!th->t_trans_id);
 
-	RFALSE(bmap_n >= SB_BMAP_NR(s), "Bitmap %d is out of range (0..%d)",
-	       bmap_n, SB_BMAP_NR(s) - 1);
+	RFALSE(bmap_n >= reiserfs_bmap_count(s), "Bitmap %u is out of "
+	       "range (0..%u)", bmap_n, reiserfs_bmap_count(s) - 1);
 	PROC_INFO_INC(s, scan_bitmap.bmap);
 /* this is unclear and lacks comments, explain how journal bitmaps
    work here for the reader.  Convey a sense of the design here. What
@@ -249,12 +251,12 @@ static int bmap_hash_id(struct super_blo
 	} else {
 		hash_in = (char *)(&id);
 		hash = keyed_hash(hash_in, 4);
-		bm = hash % SB_BMAP_NR(s);
+		bm = hash % reiserfs_bmap_count(s);
 		if (!bm)
 			bm = 1;
 	}
 	/* this can only be true when SB_BMAP_NR = 1 */
-	if (bm >= SB_BMAP_NR(s))
+	if (bm >= reiserfs_bmap_count(s))
 		bm = 0;
 	return bm;
 }
@@ -328,10 +330,10 @@ static int scan_bitmap(struct reiserfs_t
 
 	get_bit_address(s, *start, &bm, &off);
 	get_bit_address(s, finish, &end_bm, &end_off);
-	if (bm > SB_BMAP_NR(s))
+	if (bm > reiserfs_bmap_count(s))
 		return 0;
-	if (end_bm > SB_BMAP_NR(s))
-		end_bm = SB_BMAP_NR(s);
+	if (end_bm > reiserfs_bmap_count(s))
+		end_bm = reiserfs_bmap_count(s);
 
 	/* When the bitmap is more than 10% free, anyone can allocate.
 	 * When it's less than 10% free, only files that already use the
@@ -397,10 +399,12 @@ static void _reiserfs_free_block(struct 
 
 	get_bit_address(s, block, &nr, &offset);
 
-	if (nr >= sb_bmap_nr(rs)) {
+	if (nr >= reiserfs_bmap_count(s)) {
 		reiserfs_warning(s, "vs-4075: reiserfs_free_block: "
-				 "block %lu is out of range on %s",
-				 block, reiserfs_bdevname(s));
+				 "block %lu is out of range on %s "
+				 "(nr=%u,max=%u)", block,
+				 reiserfs_bdevname(s), nr,
+				 reiserfs_bmap_count(s));
 		return;
 	}
 
@@ -1269,12 +1273,13 @@ struct buffer_head *reiserfs_read_bitmap
 int reiserfs_init_bitmap_cache(struct super_block *sb)
 {
 	struct reiserfs_bitmap_info *bitmap;
+	unsigned int bmap_nr = reiserfs_bmap_count(sb);
 
-	bitmap = vmalloc(sizeof (*bitmap) * SB_BMAP_NR(sb));
+	bitmap = vmalloc(sizeof (*bitmap) * bmap_nr);
 	if (bitmap == NULL)
 		return -ENOMEM;
 
-	memset(bitmap, 0, sizeof (*bitmap) * SB_BMAP_NR(sb));
+	memset(bitmap, 0, sizeof (*bitmap) * bmap_nr);
 
 	SB_AP_BITMAP(sb) = bitmap;
 
diff -puN fs/reiserfs/journal.c~reiserfs-ignore-on-disk-s_bmap_nr-value fs/reiserfs/journal.c
--- a/fs/reiserfs/journal.c~reiserfs-ignore-on-disk-s_bmap_nr-value
+++ a/fs/reiserfs/journal.c
@@ -240,7 +240,7 @@ static void cleanup_bitmap_list(struct s
 	if (jb->bitmaps == NULL)
 		return;
 
-	for (i = 0; i < SB_BMAP_NR(p_s_sb); i++) {
+	for (i = 0; i < reiserfs_bmap_count(p_s_sb); i++) {
 		if (jb->bitmaps[i]) {
 			free_bitmap_node(p_s_sb, jb->bitmaps[i]);
 			jb->bitmaps[i] = NULL;
@@ -2734,7 +2734,7 @@ int journal_init(struct super_block *p_s
 	journal->j_persistent_trans = 0;
 	if (reiserfs_allocate_list_bitmaps(p_s_sb,
 					   journal->j_list_bitmap,
-					   SB_BMAP_NR(p_s_sb)))
+					   reiserfs_bmap_count(p_s_sb)))
 		goto free_and_return;
 	allocate_bitmap_nodes(p_s_sb);
 
@@ -2742,7 +2742,7 @@ int journal_init(struct super_block *p_s
 	SB_JOURNAL_1st_RESERVED_BLOCK(p_s_sb) = (old_format ?
 						 REISERFS_OLD_DISK_OFFSET_IN_BYTES
 						 / p_s_sb->s_blocksize +
-						 SB_BMAP_NR(p_s_sb) +
+						 reiserfs_bmap_count(p_s_sb) +
 						 1 :
 						 REISERFS_DISK_OFFSET_IN_BYTES /
 						 p_s_sb->s_blocksize + 2);
diff -puN fs/reiserfs/resize.c~reiserfs-ignore-on-disk-s_bmap_nr-value fs/reiserfs/resize.c
--- a/fs/reiserfs/resize.c~reiserfs-ignore-on-disk-s_bmap_nr-value
+++ a/fs/reiserfs/resize.c
@@ -61,7 +61,7 @@ int reiserfs_resize(struct super_block *
 	}
 
 	/* count used bits in last bitmap block */
-	block_r = SB_BLOCK_COUNT(s) - (SB_BMAP_NR(s) - 1) * s->s_blocksize * 8;
+	block_r = SB_BLOCK_COUNT(s) - (reiserfs_bmap_count(s) - 1) * s->s_blocksize * 8;
 
 	/* count bitmap blocks in new fs */
 	bmap_nr_new = block_count_new / (s->s_blocksize * 8);
@@ -73,7 +73,7 @@ int reiserfs_resize(struct super_block *
 
 	/* save old values */
 	block_count = SB_BLOCK_COUNT(s);
-	bmap_nr = SB_BMAP_NR(s);
+	bmap_nr = reiserfs_bmap_count(s);
 
 	/* resizing of reiserfs bitmaps (journal and real), if needed */
 	if (bmap_nr_new > bmap_nr) {
@@ -200,7 +200,7 @@ int reiserfs_resize(struct super_block *
 			   free_blocks + (block_count_new - block_count -
 					  (bmap_nr_new - bmap_nr)));
 	PUT_SB_BLOCK_COUNT(s, block_count_new);
-	PUT_SB_BMAP_NR(s, bmap_nr_new);
+	PUT_SB_BMAP_NR(s, bmap_would_wrap(bmap_nr_new) ? : bmap_nr_new );
 	s->s_dirt = 1;
 
 	journal_mark_dirty(&th, s, SB_BUFFER_WITH_SB(s));
diff -puN fs/reiserfs/super.c~reiserfs-ignore-on-disk-s_bmap_nr-value fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~reiserfs-ignore-on-disk-s_bmap_nr-value
+++ a/fs/reiserfs/super.c
@@ -1725,6 +1725,21 @@ static int reiserfs_fill_super(struct su
 		set_sb_umount_state(rs, REISERFS_ERROR_FS);
 		set_sb_fs_state(rs, 0);
 
+		/* Clear out s_bmap_nr if it would wrap. We can handle this
+		 * case, but older revisions can't. This will cause the
+		 * file system to fail mount on those older implementations,
+		 * avoiding corruption. -jeffm */
+		if (bmap_would_wrap(reiserfs_bmap_count(s)) &&
+		    sb_bmap_nr(rs) != 0) {
+			reiserfs_warning(s, "super-2030: This file system "
+		                         "claims to use %u bitmap blocks in "
+		                         "its super block, but requires %u. "
+		                         "Clearing to zero.", sb_bmap_nr(rs),
+		                         reiserfs_bmap_count(s));
+
+			set_sb_bmap_nr(rs, 0);
+		}
+
 		if (old_format_only(s)) {
 			/* filesystem of format 3.5 either with standard or non-standard
 			   journal */
diff -puN include/linux/reiserfs_fs.h~reiserfs-ignore-on-disk-s_bmap_nr-value include/linux/reiserfs_fs.h
--- a/include/linux/reiserfs_fs.h~reiserfs-ignore-on-disk-s_bmap_nr-value
+++ a/include/linux/reiserfs_fs.h
@@ -231,6 +231,11 @@ struct reiserfs_super_block {
          ((!is_reiserfs_jr(SB_DISK_SUPER_BLOCK(s)) ? \
          SB_ONDISK_JOURNAL_SIZE(s) + 1 : SB_ONDISK_RESERVED_FOR_JOURNAL(s)))
 
+/* s_bmap_nr is a u16 */
+#define reiserfs_bmap_count(sb)	reiserfs_bmap_nr(SB_BLOCK_COUNT(sb), sb->s_blocksize)
+#define reiserfs_bmap_nr(count, blk_size) ((count - 1) / (blk_size * 8) + 1)
+#define bmap_would_wrap(n)		(n > ((1LL << 16) - 1))
+
 int is_reiserfs_3_5(struct reiserfs_super_block *rs);
 int is_reiserfs_3_6(struct reiserfs_super_block *rs);
 int is_reiserfs_jr(struct reiserfs_super_block *rs);
_

Patches currently in -mm which might be from jeffm@suse.com are

try-to-reap-reiserfs-pages-left-around-by-invalidatepage.patch
reiserfs-fix-kernel-panic-on-corrupted-directory.patch
reiserfs-workaround-for-dead-loop-in-finish_unfinished.patch
reiserfs-do-not-repair-wrong-journal-params.patch
reiserfs-fix-up-lockdep-warnings.patch
reiserfs-fix-up-lockdep-warnings-checkpatch-fixes.patch
reiserfs-dont-use-bug-when-panicking.patch
reiserfs-use-is_reusable-to-catch-corruption.patch
reiserfs-use-is_reusable-to-catch-corruption-checkpatch-fixes.patch
reiserfs-fix-usage-of-signed-ints-for-block-numbers.patch
reiserfs-fix-usage-of-signed-ints-for-block-numbers-checkpatch-fixes.patch
reiserfs-fix-memset-byte-count-during-resize.patch
reiserfs-remove-first_zero_hint.patch
reiserfs-remove-first_zero_hint-checkpatch-fixes.patch
reiserfs-ignore-on-disk-s_bmap_nr-value.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
reiserfs-turn-of-attr_kill_sid-at-beginning-of-reiserfs_setattr.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
reiserfs-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
