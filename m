From: akpm@linux-foundation.org
Subject: - omfs-fix-oops-when-file-metadata-is-corrupted.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:40:28 -0700
Message-ID: <200808181940.m7IJeSJk008461@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756238AbYHRTun (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:50:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: me@bobcopeland.com, snakebyte@gmx.de, mm-commits@vger.kernel.org


The patch titled
     omfs: fix oops when file metadata is corrupted
has been removed from the -mm tree.  Its filename was
     omfs-fix-oops-when-file-metadata-is-corrupted.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: omfs: fix oops when file metadata is corrupted
From: Bob Copeland <me@bobcopeland.com>

A fuzzed fileystem image failed with OMFS when the extent count was
used in a loop without being checked against the max number of extents.
It also provoked a signed division for an array index that was checked
as if unsigned, leading to index by -1.

omfsck will be updated to fix these cases, in the meantime bail out
gracefully.

Reported-by: Eric Sesterhenn <snakebyte@gmx.de>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/omfs/bitmap.c |    5 +++--
 fs/omfs/file.c   |   33 ++++++++++++++++++++++++++-------
 2 files changed, 29 insertions(+), 9 deletions(-)

diff -puN fs/omfs/bitmap.c~omfs-fix-oops-when-file-metadata-is-corrupted fs/omfs/bitmap.c
--- a/fs/omfs/bitmap.c~omfs-fix-oops-when-file-metadata-is-corrupted
+++ a/fs/omfs/bitmap.c
@@ -92,7 +92,7 @@ int omfs_allocate_block(struct super_blo
 	struct buffer_head *bh;
 	struct omfs_sb_info *sbi = OMFS_SB(sb);
 	int bits_per_entry = 8 * sb->s_blocksize;
-	int map, bit;
+	unsigned int map, bit;
 	int ret = 0;
 	u64 tmp;
 
@@ -176,7 +176,8 @@ int omfs_clear_range(struct super_block 
 	struct omfs_sb_info *sbi = OMFS_SB(sb);
 	int bits_per_entry = 8 * sb->s_blocksize;
 	u64 tmp;
-	int map, bit, ret;
+	unsigned int map, bit;
+	int ret;
 
 	tmp = block;
 	bit = do_div(tmp, bits_per_entry);
diff -puN fs/omfs/file.c~omfs-fix-oops-when-file-metadata-is-corrupted fs/omfs/file.c
--- a/fs/omfs/file.c~omfs-fix-oops-when-file-metadata-is-corrupted
+++ a/fs/omfs/file.c
@@ -26,6 +26,13 @@ static int omfs_sync_file(struct file *f
 	return err ? -EIO : 0;
 }
 
+static u32 omfs_max_extents(struct omfs_sb_info *sbi, int offset)
+{
+	return (sbi->s_sys_blocksize - offset -
+		sizeof(struct omfs_extent)) /
+		sizeof(struct omfs_extent_entry) + 1;
+}
+
 void omfs_make_empty_table(struct buffer_head *bh, int offset)
 {
 	struct omfs_extent *oe = (struct omfs_extent *) &bh->b_data[offset];
@@ -45,6 +52,7 @@ int omfs_shrink_inode(struct inode *inod
 	struct buffer_head *bh;
 	u64 next, last;
 	u32 extent_count;
+	u32 max_extents;
 	int ret;
 
 	/* traverse extent table, freeing each entry that is greater
@@ -62,15 +70,18 @@ int omfs_shrink_inode(struct inode *inod
 		goto out;
 
 	oe = (struct omfs_extent *)(&bh->b_data[OMFS_EXTENT_START]);
+	max_extents = omfs_max_extents(sbi, OMFS_EXTENT_START);
 
 	for (;;) {
 
-		if (omfs_is_bad(sbi, (struct omfs_header *) bh->b_data, next)) {
-			brelse(bh);
-			goto out;
-		}
+		if (omfs_is_bad(sbi, (struct omfs_header *) bh->b_data, next))
+			goto out_brelse;
 
 		extent_count = be32_to_cpu(oe->e_extent_count);
+
+		if (extent_count > max_extents)
+			goto out_brelse;
+
 		last = next;
 		next = be64_to_cpu(oe->e_next);
 		entry = &oe->e_entry;
@@ -98,10 +109,14 @@ int omfs_shrink_inode(struct inode *inod
 		if (!bh)
 			goto out;
 		oe = (struct omfs_extent *) (&bh->b_data[OMFS_EXTENT_CONT]);
+		max_extents = omfs_max_extents(sbi, OMFS_EXTENT_CONT);
 	}
 	ret = 0;
 out:
 	return ret;
+out_brelse:
+	brelse(bh);
+	return ret;
 }
 
 static void omfs_truncate(struct inode *inode)
@@ -154,9 +169,7 @@ static int omfs_grow_extent(struct inode
 			goto out;
 		}
 	}
-	max_count = (sbi->s_sys_blocksize - OMFS_EXTENT_START -
-		sizeof(struct omfs_extent)) /
-		sizeof(struct omfs_extent_entry) + 1;
+	max_count = omfs_max_extents(sbi, OMFS_EXTENT_START);
 
 	/* TODO: add a continuation block here */
 	if (be32_to_cpu(oe->e_extent_count) > max_count-1)
@@ -225,6 +238,7 @@ static int omfs_get_block(struct inode *
 	sector_t next, offset;
 	int ret;
 	u64 new_block;
+	u32 max_extents;
 	int extent_count;
 	struct omfs_extent *oe;
 	struct omfs_extent_entry *entry;
@@ -238,6 +252,7 @@ static int omfs_get_block(struct inode *
 		goto out;
 
 	oe = (struct omfs_extent *)(&bh->b_data[OMFS_EXTENT_START]);
+	max_extents = omfs_max_extents(sbi, OMFS_EXTENT_START);
 	next = inode->i_ino;
 
 	for (;;) {
@@ -249,6 +264,9 @@ static int omfs_get_block(struct inode *
 		next = be64_to_cpu(oe->e_next);
 		entry = &oe->e_entry;
 
+		if (extent_count > max_extents)
+			goto out_brelse;
+
 		offset = find_block(inode, entry, block, extent_count, &remain);
 		if (offset > 0) {
 			ret = 0;
@@ -266,6 +284,7 @@ static int omfs_get_block(struct inode *
 		if (!bh)
 			goto out;
 		oe = (struct omfs_extent *) (&bh->b_data[OMFS_EXTENT_CONT]);
+		max_extents = omfs_max_extents(sbi, OMFS_EXTENT_CONT);
 	}
 	if (create) {
 		ret = omfs_grow_extent(inode, oe, &new_block);
_

Patches currently in -mm which might be from me@bobcopeland.com are

origin.patch
ath5k-unify-resets.patch

