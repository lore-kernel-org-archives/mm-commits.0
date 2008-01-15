From: akpm@linux-foundation.org
Subject: + udf-move-calculating-of-nr_groups-into-helper-function.patch added to -mm tree
Date: Tue, 15 Jan 2008 02:46:38 -0800
Message-ID: <200801151046.m0FAkIj5011655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37654 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751217AbYAOKrF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 05:47:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, bfennema@falcon.csc.calpoly.edu, hch@infradead.org, jack@suse.cz


The patch titled
     udf: move calculating of nr_groups into helper function
has been added to the -mm tree.  Its filename is
     udf-move-calculating-of-nr_groups-into-helper-function.patch

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
Subject: udf: move calculating of nr_groups into helper function
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Acked-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/balloc.c |    4 +---
 fs/udf/super.c  |   16 ++++++++++------
 fs/udf/udf_sb.h |    2 ++
 3 files changed, 13 insertions(+), 9 deletions(-)

diff -puN fs/udf/balloc.c~udf-move-calculating-of-nr_groups-into-helper-function fs/udf/balloc.c
--- a/fs/udf/balloc.c~udf-move-calculating-of-nr_groups-into-helper-function
+++ a/fs/udf/balloc.c
@@ -231,9 +231,7 @@ static int udf_bitmap_prealloc_blocks(st
 		block_count = part_len - first_block;
 
 repeat:
-	nr_groups = (sbi->s_partmaps[partition].s_partition_len +
-		     (sizeof(struct spaceBitmapDesc) << 3) +
-		     (sb->s_blocksize * 8) - 1) / (sb->s_blocksize * 8);
+	nr_groups = udf_compute_nr_groups(sb, partition);
 	block = first_block + (sizeof(struct spaceBitmapDesc) << 3);
 	block_group = block >> (sb->s_blocksize_bits + 3);
 	group_start = block_group ? 0 : sizeof(struct spaceBitmapDesc);
diff -puN fs/udf/super.c~udf-move-calculating-of-nr_groups-into-helper-function fs/udf/super.c
--- a/fs/udf/super.c~udf-move-calculating-of-nr_groups-into-helper-function
+++ a/fs/udf/super.c
@@ -937,18 +937,22 @@ static void udf_load_fileset(struct supe
 		  root->logicalBlockNum, root->partitionReferenceNum);
 }
 
+int udf_compute_nr_groups(struct super_block *sb, u32 partition)
+{
+	struct udf_part_map *map = &UDF_SB(sb)->s_partmaps[partition];
+	return (map->s_partition_len +
+		(sizeof(struct spaceBitmapDesc) << 3) +
+		(sb->s_blocksize * 8) - 1) /
+		(sb->s_blocksize * 8);
+}
+
 static struct udf_bitmap *udf_sb_alloc_bitmap(struct super_block *sb, u32 index)
 {
-	struct udf_part_map *map = &UDF_SB(sb)->s_partmaps[index];
 	struct udf_bitmap *bitmap;
 	int nr_groups;
 	int size;
 
-	/* TODO: move calculating of nr_groups into helper function */
-	nr_groups = (map->s_partition_len +
-			(sizeof(struct spaceBitmapDesc) << 3) +
-			(sb->s_blocksize * 8) - 1) /
-			(sb->s_blocksize * 8);
+	nr_groups = udf_compute_nr_groups(sb, index);
 	size = sizeof(struct udf_bitmap) +
 		(sizeof(struct buffer_head *) * nr_groups);
 
diff -puN fs/udf/udf_sb.h~udf-move-calculating-of-nr_groups-into-helper-function fs/udf/udf_sb.h
--- a/fs/udf/udf_sb.h~udf-move-calculating-of-nr_groups-into-helper-function
+++ a/fs/udf/udf_sb.h
@@ -43,6 +43,8 @@ static inline struct udf_sb_info *UDF_SB
 
 struct logicalVolIntegrityDescImpUse *udf_sb_lvidiu(struct udf_sb_info *sbi);
 
+int udf_compute_nr_groups(struct super_block *sb, u32 partition);
+
 #define UDF_QUERY_FLAG(X,Y)			( UDF_SB(X)->s_flags & ( 1 << (Y) ) )
 #define UDF_SET_FLAG(X,Y)			( UDF_SB(X)->s_flags |= ( 1 << (Y) ) )
 #define UDF_CLEAR_FLAG(X,Y)			( UDF_SB(X)->s_flags &= ~( 1 << (Y) ) )
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
