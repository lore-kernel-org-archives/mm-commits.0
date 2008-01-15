From: akpm@linux-foundation.org
Subject: + udf-remove-some-ugly-macros.patch added to -mm tree
Date: Tue, 15 Jan 2008 02:46:28 -0800
Message-ID: <200801151046.m0FAk8bi011619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53940 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396AbYAOKrU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 05:47:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, bfennema@falcon.csc.calpoly.edu, hch@infradead.org, jack@suse.cz


The patch titled
     udf: remove some ugly macros
has been added to the -mm tree.  Its filename is
     udf-remove-some-ugly-macros.patch

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
Subject: udf: remove some ugly macros
From: Marcin Slusarz <marcin.slusarz@gmail.com>

remove macros:
- UDF_SB_PARTMAPS
- UDF_SB_PARTTYPE
- UDF_SB_PARTROOT
- UDF_SB_PARTLEN
- UDF_SB_PARTVSN
- UDF_SB_PARTNUM
- UDF_SB_TYPESPAR
- UDF_SB_TYPEVIRT
- UDF_SB_PARTFUNC
- UDF_SB_PARTFLAGS
- UDF_SB_VOLIDENT
- UDF_SB_NUMPARTS
- UDF_SB_PARTITION
- UDF_SB_SESSION
- UDF_SB_ANCHOR
- UDF_SB_LASTBLOCK
- UDF_SB_LVIDBH
- UDF_SB_LVID
- UDF_SB_UMASK
- UDF_SB_GID
- UDF_SB_UID
- UDF_SB_RECORDTIME
- UDF_SB_SERIALNUM
- UDF_SB_UDFREV
- UDF_SB_FLAGS
- UDF_SB_VAT
- UDF_UPDATE_UDFREV
- UDF_SB_FREE
and open code them

convert UDF_SB_LVIDIU macro to udf_sb_lvidiu function

rename some struct udf_sb_info fields:
- s_volident to s_volume_ident
- s_lastblock to s_last_block
- s_lvidbh to s_lvid_bh
- s_recordtime to s_record_time
- s_serialnum to s_serial_number;
- s_vat to s_vat_inode;

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Cc: Jan Kara <jack@suse.cz>
Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/balloc.c           |  136 ++++----
 fs/udf/file.c             |    2 
 fs/udf/ialloc.c           |   33 +-
 fs/udf/inode.c            |   34 +-
 fs/udf/misc.c             |   15 
 fs/udf/namei.c            |   24 -
 fs/udf/partition.c        |   67 ++--
 fs/udf/super.c            |  546 ++++++++++++++++++++----------------
 fs/udf/truncate.c         |    7 
 fs/udf/udf_sb.h           |   75 +---
 include/linux/udf_fs_sb.h |   12 
 11 files changed, 509 insertions(+), 442 deletions(-)

diff -puN fs/udf/balloc.c~udf-remove-some-ugly-macros fs/udf/balloc.c
--- a/fs/udf/balloc.c~udf-remove-some-ugly-macros
+++ a/fs/udf/balloc.c
@@ -88,7 +88,7 @@ static int read_block_bitmap(struct supe
 	kernel_lb_addr loc;
 
 	loc.logicalBlockNum = bitmap->s_extPosition;
-	loc.partitionReferenceNum = UDF_SB_PARTITION(sb);
+	loc.partitionReferenceNum = UDF_SB(sb)->s_partition;
 
 	bh = udf_tread(sb, udf_get_lb_pblock(sb, loc, block));
 	if (!bh) {
@@ -155,10 +155,10 @@ static void udf_bitmap_free_blocks(struc
 
 	mutex_lock(&sbi->s_alloc_mutex);
 	if (bloc.logicalBlockNum < 0 ||
-	    (bloc.logicalBlockNum + count) > UDF_SB_PARTLEN(sb, bloc.partitionReferenceNum)) {
+	    (bloc.logicalBlockNum + count) > sbi->s_partmaps[bloc.partitionReferenceNum].s_partition_len) {
 		udf_debug("%d < %d || %d + %d > %d\n",
 			  bloc.logicalBlockNum, 0, bloc.logicalBlockNum, count,
-			  UDF_SB_PARTLEN(sb, bloc.partitionReferenceNum));
+			  sbi->s_partmaps[bloc.partitionReferenceNum].s_partition_len);
 		goto error_return;
 	}
 
@@ -188,9 +188,10 @@ do_more:
 		} else {
 			if (inode)
 				DQUOT_FREE_BLOCK(inode, 1);
-			if (UDF_SB_LVIDBH(sb)) {
-				UDF_SB_LVID(sb)->freeSpaceTable[UDF_SB_PARTITION(sb)] =
-					cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[UDF_SB_PARTITION(sb)]) + 1);
+			if (sbi->s_lvid_bh) {
+				struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
+				lvid->freeSpaceTable[sbi->s_partition] =
+					cpu_to_le32(le32_to_cpu(lvid->freeSpaceTable[sbi->s_partition]) + 1);
 			}
 		}
 	}
@@ -202,8 +203,8 @@ do_more:
 	}
 error_return:
 	sb->s_dirt = 1;
-	if (UDF_SB_LVIDBH(sb))
-		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
+	if (sbi->s_lvid_bh)
+		mark_buffer_dirty(sbi->s_lvid_bh);
 	mutex_unlock(&sbi->s_alloc_mutex);
 	return;
 }
@@ -219,16 +220,18 @@ static int udf_bitmap_prealloc_blocks(st
 	int bit, block, block_group, group_start;
 	int nr_groups, bitmap_nr;
 	struct buffer_head *bh;
+	__u32 part_len;
 
 	mutex_lock(&sbi->s_alloc_mutex);
-	if (first_block < 0 || first_block >= UDF_SB_PARTLEN(sb, partition))
+	part_len = sbi->s_partmaps[partition].s_partition_len;
+	if (first_block < 0 || first_block >= part_len)
 		goto out;
 
-	if (first_block + block_count > UDF_SB_PARTLEN(sb, partition))
-		block_count = UDF_SB_PARTLEN(sb, partition) - first_block;
+	if (first_block + block_count > part_len)
+		block_count = part_len - first_block;
 
 repeat:
-	nr_groups = (UDF_SB_PARTLEN(sb, partition) +
+	nr_groups = (sbi->s_partmaps[partition].s_partition_len +
 		     (sizeof(struct spaceBitmapDesc) << 3) +
 		     (sb->s_blocksize * 8) - 1) / (sb->s_blocksize * 8);
 	block = first_block + (sizeof(struct spaceBitmapDesc) << 3);
@@ -261,10 +264,11 @@ repeat:
 	if (block_count > 0)
 		goto repeat;
 out:
-	if (UDF_SB_LVIDBH(sb)) {
-		UDF_SB_LVID(sb)->freeSpaceTable[partition] =
-			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[partition]) - alloc_count);
-		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
+	if (sbi->s_lvid_bh) {
+		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
+		lvid->freeSpaceTable[partition] =
+			cpu_to_le32(le32_to_cpu(lvid->freeSpaceTable[partition]) - alloc_count);
+		mark_buffer_dirty(sbi->s_lvid_bh);
 	}
 	sb->s_dirt = 1;
 	mutex_unlock(&sbi->s_alloc_mutex);
@@ -287,7 +291,7 @@ static int udf_bitmap_new_block(struct s
 	mutex_lock(&sbi->s_alloc_mutex);
 
 repeat:
-	if (goal < 0 || goal >= UDF_SB_PARTLEN(sb, partition))
+	if (goal < 0 || goal >= sbi->s_partmaps[partition].s_partition_len)
 		goal = 0;
 
 	nr_groups = bitmap->s_nr_groups;
@@ -389,10 +393,11 @@ got_block:
 
 	mark_buffer_dirty(bh);
 
-	if (UDF_SB_LVIDBH(sb)) {
-		UDF_SB_LVID(sb)->freeSpaceTable[partition] =
-			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[partition]) - 1);
-		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
+	if (sbi->s_lvid_bh) {
+		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
+		lvid->freeSpaceTable[partition] =
+			cpu_to_le32(le32_to_cpu(lvid->freeSpaceTable[partition]) - 1);
+		mark_buffer_dirty(sbi->s_lvid_bh);
 	}
 	sb->s_dirt = 1;
 	mutex_unlock(&sbi->s_alloc_mutex);
@@ -421,10 +426,10 @@ static void udf_table_free_blocks(struct
 
 	mutex_lock(&sbi->s_alloc_mutex);
 	if (bloc.logicalBlockNum < 0 ||
-	    (bloc.logicalBlockNum + count) > UDF_SB_PARTLEN(sb, bloc.partitionReferenceNum)) {
+	    (bloc.logicalBlockNum + count) > sbi->s_partmaps[bloc.partitionReferenceNum].s_partition_len) {
 		udf_debug("%d < %d || %d + %d > %d\n",
 			  bloc.logicalBlockNum, 0, bloc.logicalBlockNum, count,
-			  UDF_SB_PARTLEN(sb, bloc.partitionReferenceNum));
+			  sbi->s_partmaps[bloc.partitionReferenceNum]->s_partition_len);
 		goto error_return;
 	}
 
@@ -432,10 +437,11 @@ static void udf_table_free_blocks(struct
 	   but.. oh well */
 	if (inode)
 		DQUOT_FREE_BLOCK(inode, count);
-	if (UDF_SB_LVIDBH(sb)) {
-		UDF_SB_LVID(sb)->freeSpaceTable[UDF_SB_PARTITION(sb)] =
-			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[UDF_SB_PARTITION(sb)]) + count);
-		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
+	if (sbi->s_lvid_bh) {
+		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
+		lvid->freeSpaceTable[sbi->s_partition] =
+			cpu_to_le32(le32_to_cpu(lvid->freeSpaceTable[sbi->s_partition]) + count);
+		mark_buffer_dirty(sbi->s_lvid_bh);
 	}
 
 	start = bloc.logicalBlockNum + offset;
@@ -559,7 +565,7 @@ static void udf_table_free_blocks(struct
 				}
 				epos.offset = sizeof(struct allocExtDesc);
 			}
-			if (UDF_SB_UDFREV(sb) >= 0x0200)
+			if (sbi->s_udfrev >= 0x0200)
 				udf_new_tag(epos.bh->b_data, TAG_IDENT_AED, 3, 1,
 					    epos.block.logicalBlockNum, sizeof(tag));
 			else
@@ -627,7 +633,7 @@ static int udf_table_prealloc_blocks(str
 	struct extent_position epos;
 	int8_t etype = -1;
 
-	if (first_block < 0 || first_block >= UDF_SB_PARTLEN(sb, partition))
+	if (first_block < 0 || first_block >= sbi->s_partmaps[partition].s_partition_len)
 		return 0;
 
 	if (UDF_I_ALLOCTYPE(table) == ICBTAG_FLAG_AD_SHORT)
@@ -670,10 +676,11 @@ static int udf_table_prealloc_blocks(str
 
 	brelse(epos.bh);
 
-	if (alloc_count && UDF_SB_LVIDBH(sb)) {
-		UDF_SB_LVID(sb)->freeSpaceTable[partition] =
-			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[partition]) - alloc_count);
-		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
+	if (alloc_count && sbi->s_lvid_bh) {
+		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
+		lvid->freeSpaceTable[partition] =
+			cpu_to_le32(le32_to_cpu(lvid->freeSpaceTable[partition]) - alloc_count);
+		mark_buffer_dirty(sbi->s_lvid_bh);
 		sb->s_dirt = 1;
 	}
 	mutex_unlock(&sbi->s_alloc_mutex);
@@ -703,7 +710,7 @@ static int udf_table_new_block(struct su
 		return newblock;
 
 	mutex_lock(&sbi->s_alloc_mutex);
-	if (goal < 0 || goal >= UDF_SB_PARTLEN(sb, partition))
+	if (goal < 0 || goal >= sbi->s_partmaps[partition].s_partition_len)
 		goal = 0;
 
 	/* We search for the closest matching block to goal. If we find a exact hit,
@@ -771,10 +778,11 @@ static int udf_table_new_block(struct su
 		udf_delete_aext(table, goal_epos, goal_eloc, goal_elen);
 	brelse(goal_epos.bh);
 
-	if (UDF_SB_LVIDBH(sb)) {
-		UDF_SB_LVID(sb)->freeSpaceTable[partition] =
-			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[partition]) - 1);
-		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
+	if (sbi->s_lvid_bh) {
+		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
+		lvid->freeSpaceTable[partition] =
+			cpu_to_le32(le32_to_cpu(lvid->freeSpaceTable[partition]) - 1);
+		mark_buffer_dirty(sbi->s_lvid_bh);
 	}
 
 	sb->s_dirt = 1;
@@ -789,22 +797,23 @@ inline void udf_free_blocks(struct super
 			    uint32_t count)
 {
 	uint16_t partition = bloc.partitionReferenceNum;
+	struct udf_part_map *map = &UDF_SB(sb)->s_partmaps[partition];
 
-	if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_BITMAP) {
+	if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP) {
 		return udf_bitmap_free_blocks(sb, inode,
-					      UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_bitmap,
+					      map->s_uspace.s_bitmap,
 					      bloc, offset, count);
-	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_TABLE) {
+	} else if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_TABLE) {
 		return udf_table_free_blocks(sb, inode,
-					     UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_table,
+					     map->s_uspace.s_table,
 					     bloc, offset, count);
-	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_BITMAP) {
+	} else if (map->s_partition_flags & UDF_PART_FLAG_FREED_BITMAP) {
 		return udf_bitmap_free_blocks(sb, inode,
-					      UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_bitmap,
+					      map->s_fspace.s_bitmap,
 					      bloc, offset, count);
-	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_TABLE) {
+	} else if (map->s_partition_flags & UDF_PART_FLAG_FREED_TABLE) {
 		return udf_table_free_blocks(sb, inode,
-					     UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_table,
+					     map->s_fspace.s_table,
 					     bloc, offset, count);
 	} else {
 		return;
@@ -816,21 +825,23 @@ inline int udf_prealloc_blocks(struct su
 			       uint16_t partition, uint32_t first_block,
 			       uint32_t block_count)
 {
-	if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_BITMAP) {
+	struct udf_part_map *map = &UDF_SB(sb)->s_partmaps[partition];
+
+	if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP) {
 		return udf_bitmap_prealloc_blocks(sb, inode,
-						  UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_bitmap,
+						  map->s_uspace.s_bitmap,
 						  partition, first_block, block_count);
-	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_TABLE) {
+	} else if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_TABLE) {
 		return udf_table_prealloc_blocks(sb, inode,
-						 UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_table,
+						 map->s_uspace.s_table,
 						 partition, first_block, block_count);
-	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_BITMAP) {
+	} else if (map->s_partition_flags & UDF_PART_FLAG_FREED_BITMAP) {
 		return udf_bitmap_prealloc_blocks(sb, inode,
-						  UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_bitmap,
+						  map->s_fspace.s_bitmap,
 						  partition, first_block, block_count);
-	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_TABLE) {
+	} else if (map->s_partition_flags & UDF_PART_FLAG_FREED_TABLE) {
 		return udf_table_prealloc_blocks(sb, inode,
-						 UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_table,
+						 map->s_fspace.s_table,
 						 partition, first_block, block_count);
 	} else {
 		return 0;
@@ -842,23 +853,24 @@ inline int udf_new_block(struct super_bl
 			 uint16_t partition, uint32_t goal, int *err)
 {
 	int ret;
+	struct udf_part_map *map = &UDF_SB(sb)->s_partmaps[partition];
 
-	if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_BITMAP) {
+	if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP) {
 		ret = udf_bitmap_new_block(sb, inode,
-					   UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_bitmap,
+					   map->s_uspace.s_bitmap,
 					   partition, goal, err);
 		return ret;
-	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_TABLE) {
+	} else if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_TABLE) {
 		return udf_table_new_block(sb, inode,
-					   UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_table,
+					   map->s_uspace.s_table,
 					   partition, goal, err);
-	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_BITMAP) {
+	} else if (map->s_partition_flags & UDF_PART_FLAG_FREED_BITMAP) {
 		return udf_bitmap_new_block(sb, inode,
-					    UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_bitmap,
+					    map->s_fspace.s_bitmap,
 					    partition, goal, err);
-	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_TABLE) {
+	} else if (map->s_partition_flags & UDF_PART_FLAG_FREED_TABLE) {
 		return udf_table_new_block(sb, inode,
-					   UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_table,
+					   map->s_fspace.s_table,
 					   partition, goal, err);
 	} else {
 		*err = -EIO;
diff -puN fs/udf/file.c~udf-remove-some-ugly-macros fs/udf/file.c
--- a/fs/udf/file.c~udf-remove-some-ugly-macros
+++ a/fs/udf/file.c
@@ -192,7 +192,7 @@ int udf_ioctl(struct inode *inode, struc
 	switch (cmd) {
 	case UDF_GETVOLIDENT:
 		return copy_to_user((char __user *)arg,
-				    UDF_SB_VOLIDENT(inode->i_sb), 32) ? -EFAULT : 0;
+				    UDF_SB(inode->i_sb)->s_volume_ident, 32) ? -EFAULT : 0;
 	case UDF_RELOCATE_BLOCKS:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EACCES;
diff -puN fs/udf/ialloc.c~udf-remove-some-ugly-macros fs/udf/ialloc.c
--- a/fs/udf/ialloc.c~udf-remove-some-ugly-macros
+++ a/fs/udf/ialloc.c
@@ -43,15 +43,17 @@ void udf_free_inode(struct inode *inode)
 	clear_inode(inode);
 
 	mutex_lock(&sbi->s_alloc_mutex);
-	if (sbi->s_lvidbh) {
+	if (sbi->s_lvid_bh) {
+		struct logicalVolIntegrityDescImpUse *lvidiu =
+							udf_sb_lvidiu(sbi);
 		if (S_ISDIR(inode->i_mode))
-			UDF_SB_LVIDIU(sb)->numDirs =
-				cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numDirs) - 1);
+			lvidiu->numDirs =
+				cpu_to_le32(le32_to_cpu(lvidiu->numDirs) - 1);
 		else
-			UDF_SB_LVIDIU(sb)->numFiles =
-				cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numFiles) - 1);
+			lvidiu->numFiles =
+				cpu_to_le32(le32_to_cpu(lvidiu->numFiles) - 1);
 
-		mark_buffer_dirty(sbi->s_lvidbh);
+		mark_buffer_dirty(sbi->s_lvid_bh);
 	}
 	mutex_unlock(&sbi->s_alloc_mutex);
 
@@ -88,21 +90,23 @@ struct inode *udf_new_inode(struct inode
 	}
 
 	mutex_lock(&sbi->s_alloc_mutex);
-	if (UDF_SB_LVIDBH(sb)) {
+	if (sbi->s_lvid_bh) {
+		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
+		struct logicalVolIntegrityDescImpUse *lvidiu = udf_sb_lvidiu(sbi);
 		struct logicalVolHeaderDesc *lvhd;
 		uint64_t uniqueID;
-		lvhd = (struct logicalVolHeaderDesc *)(UDF_SB_LVID(sb)->logicalVolContentsUse);
+		lvhd = (struct logicalVolHeaderDesc *)(lvid->logicalVolContentsUse);
 		if (S_ISDIR(mode))
-			UDF_SB_LVIDIU(sb)->numDirs =
-				cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numDirs) + 1);
+			lvidiu->numDirs =
+				cpu_to_le32(le32_to_cpu(lvidiu->numDirs) + 1);
 		else
-			UDF_SB_LVIDIU(sb)->numFiles =
-				cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numFiles) + 1);
+			lvidiu->numFiles =
+				cpu_to_le32(le32_to_cpu(lvidiu->numFiles) + 1);
 		UDF_I_UNIQUE(inode) = uniqueID = le64_to_cpu(lvhd->uniqueID);
 		if (!(++uniqueID & 0x00000000FFFFFFFFUL))
 			uniqueID += 16;
 		lvhd->uniqueID = cpu_to_le64(uniqueID);
-		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
+		mark_buffer_dirty(sbi->s_lvid_bh);
 	}
 	inode->i_mode = mode;
 	inode->i_uid = current->fsuid;
@@ -123,7 +127,8 @@ struct inode *udf_new_inode(struct inode
 	UDF_I_USE(inode) = 0;
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_EXTENDED_FE)) {
 		UDF_I_EFE(inode) = 1;
-		UDF_UPDATE_UDFREV(inode->i_sb, UDF_VERS_USE_EXTENDED_FE);
+		if (UDF_VERS_USE_EXTENDED_FE > sbi->s_udfrev)
+			sbi->s_udfrev = UDF_VERS_USE_EXTENDED_FE;
 		UDF_I_DATA(inode) = kzalloc(inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry), GFP_KERNEL);
 	} else {
 		UDF_I_EFE(inode) = 0;
diff -puN fs/udf/inode.c~udf-remove-some-ugly-macros fs/udf/inode.c
--- a/fs/udf/inode.c~udf-remove-some-ugly-macros
+++ a/fs/udf/inode.c
@@ -1081,6 +1081,7 @@ static void udf_fill_inode(struct inode 
 	time_t convtime;
 	long convtime_usec;
 	int offset;
+	struct udf_sb_info *sbi = UDF_SB(inode->i_sb);
 
 	fe = (struct fileEntry *)bh->b_data;
 	efe = (struct extendedFileEntry *)bh->b_data;
@@ -1160,7 +1161,7 @@ static void udf_fill_inode(struct inode 
 			inode->i_atime.tv_sec = convtime;
 			inode->i_atime.tv_nsec = convtime_usec * 1000;
 		} else {
-			inode->i_atime = UDF_SB_RECORDTIME(inode->i_sb);
+			inode->i_atime = sbi->s_record_time;
 		}
 
 		if (udf_stamp_to_time(&convtime, &convtime_usec,
@@ -1168,7 +1169,7 @@ static void udf_fill_inode(struct inode 
 			inode->i_mtime.tv_sec = convtime;
 			inode->i_mtime.tv_nsec = convtime_usec * 1000;
 		} else {
-			inode->i_mtime = UDF_SB_RECORDTIME(inode->i_sb);
+			inode->i_mtime = sbi->s_record_time;
 		}
 
 		if (udf_stamp_to_time(&convtime, &convtime_usec,
@@ -1176,7 +1177,7 @@ static void udf_fill_inode(struct inode 
 			inode->i_ctime.tv_sec = convtime;
 			inode->i_ctime.tv_nsec = convtime_usec * 1000;
 		} else {
-			inode->i_ctime = UDF_SB_RECORDTIME(inode->i_sb);
+			inode->i_ctime = sbi->s_record_time;
 		}
 
 		UDF_I_UNIQUE(inode) = le64_to_cpu(fe->uniqueID);
@@ -1192,7 +1193,7 @@ static void udf_fill_inode(struct inode 
 			inode->i_atime.tv_sec = convtime;
 			inode->i_atime.tv_nsec = convtime_usec * 1000;
 		} else {
-			inode->i_atime = UDF_SB_RECORDTIME(inode->i_sb);
+			inode->i_atime = sbi->s_record_time;
 		}
 
 		if (udf_stamp_to_time(&convtime, &convtime_usec,
@@ -1200,7 +1201,7 @@ static void udf_fill_inode(struct inode 
 			inode->i_mtime.tv_sec = convtime;
 			inode->i_mtime.tv_nsec = convtime_usec * 1000;
 		} else {
-			inode->i_mtime = UDF_SB_RECORDTIME(inode->i_sb);
+			inode->i_mtime = sbi->s_record_time;
 		}
 
 		if (udf_stamp_to_time(&convtime, &convtime_usec,
@@ -1208,7 +1209,7 @@ static void udf_fill_inode(struct inode 
 			UDF_I_CRTIME(inode).tv_sec = convtime;
 			UDF_I_CRTIME(inode).tv_nsec = convtime_usec * 1000;
 		} else {
-			UDF_I_CRTIME(inode) = UDF_SB_RECORDTIME(inode->i_sb);
+			UDF_I_CRTIME(inode) = sbi->s_record_time;
 		}
 
 		if (udf_stamp_to_time(&convtime, &convtime_usec,
@@ -1216,7 +1217,7 @@ static void udf_fill_inode(struct inode 
 			inode->i_ctime.tv_sec = convtime;
 			inode->i_ctime.tv_nsec = convtime_usec * 1000;
 		} else {
-			inode->i_ctime = UDF_SB_RECORDTIME(inode->i_sb);
+			inode->i_ctime = sbi->s_record_time;
 		}
 
 		UDF_I_UNIQUE(inode) = le64_to_cpu(efe->uniqueID);
@@ -1353,6 +1354,7 @@ static int udf_update_inode(struct inode
 	int i;
 	kernel_timestamp cpu_time;
 	int err = 0;
+	struct udf_sb_info *sbi = UDF_SB(inode->i_sb);
 
 	bh = udf_tread(inode->i_sb, udf_get_lb_pblock(inode->i_sb, UDF_I_LOCATION(inode), 0));
 	if (!bh) {
@@ -1537,11 +1539,11 @@ static int udf_update_inode(struct inode
 				ICBTAG_FLAG_SETGID | ICBTAG_FLAG_STICKY));
 
 	fe->icbTag.flags = cpu_to_le16(icbflags);
-	if (UDF_SB_UDFREV(inode->i_sb) >= 0x0200)
+	if (sbi->s_udfrev >= 0x0200)
 		fe->descTag.descVersion = cpu_to_le16(3);
 	else
 		fe->descTag.descVersion = cpu_to_le16(2);
-	fe->descTag.tagSerialNum = cpu_to_le16(UDF_SB_SERIALNUM(inode->i_sb));
+	fe->descTag.tagSerialNum = cpu_to_le16(sbi->s_serial_number);
 	fe->descTag.tagLocation = cpu_to_le32(UDF_I_LOCATION(inode).logicalBlockNum);
 	crclen += UDF_I_LENEATTR(inode) + UDF_I_LENALLOC(inode) - sizeof(tag);
 	fe->descTag.descCRCLength = cpu_to_le16(crclen);
@@ -1585,7 +1587,7 @@ struct inode *udf_iget(struct super_bloc
 	if (is_bad_inode(inode))
 		goto out_iput;
 
-	if (ino.logicalBlockNum >= UDF_SB_PARTLEN(sb, ino.partitionReferenceNum)) {
+	if (ino.logicalBlockNum >= UDF_SB(sb)->s_partmaps[ino.partitionReferenceNum].s_partition_len) {
 		udf_debug("block=%d, partition=%d out of range\n",
 			  ino.logicalBlockNum, ino.partitionReferenceNum);
 		make_bad_inode(inode);
@@ -1667,7 +1669,7 @@ int8_t udf_add_aext(struct inode * inode
 				mark_inode_dirty(inode);
 			}
 		}
-		if (UDF_SB_UDFREV(inode->i_sb) >= 0x0200)
+		if (UDF_SB(inode->i_sb)->s_udfrev >= 0x0200)
 			udf_new_tag(nbh->b_data, TAG_IDENT_AED, 3, 1,
 				    epos->block.logicalBlockNum, sizeof(tag));
 		else
@@ -1690,7 +1692,7 @@ int8_t udf_add_aext(struct inode * inode
 		}
 		if (epos->bh) {
 			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
-			    UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
+			    UDF_SB(inode->i_sb)->s_udfrev >= 0x0201)
 				udf_update_tag(epos->bh->b_data, loffset);
 			else
 				udf_update_tag(epos->bh->b_data, sizeof(struct allocExtDesc));
@@ -1711,7 +1713,7 @@ int8_t udf_add_aext(struct inode * inode
 		aed = (struct allocExtDesc *)epos->bh->b_data;
 		aed->lengthAllocDescs =
 			cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) + adsize);
-		if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) || UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
+		if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) || UDF_SB(inode->i_sb)->s_udfrev >= 0x0201)
 			udf_update_tag(epos->bh->b_data, epos->offset + (inc ? 0 : adsize));
 		else
 			udf_update_tag(epos->bh->b_data, sizeof(struct allocExtDesc));
@@ -1754,7 +1756,7 @@ int8_t udf_write_aext(struct inode * ino
 
 	if (epos->bh) {
 		if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
-		    UDF_SB_UDFREV(inode->i_sb) >= 0x0201) {
+		    UDF_SB(inode->i_sb)->s_udfrev >= 0x0201) {
 			struct allocExtDesc *aed = (struct allocExtDesc *)epos->bh->b_data;
 			udf_update_tag(epos->bh->b_data,
 				       le32_to_cpu(aed->lengthAllocDescs) + sizeof(struct allocExtDesc));
@@ -1907,7 +1909,7 @@ int8_t udf_delete_aext(struct inode * in
 			aed->lengthAllocDescs =
 				cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) - (2 * adsize));
 			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
-			    UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
+			    UDF_SB(inode->i_sb)->s_udfrev >= 0x0201)
 				udf_update_tag(oepos.bh->b_data, oepos.offset - (2 * adsize));
 			else
 				udf_update_tag(oepos.bh->b_data, sizeof(struct allocExtDesc));
@@ -1923,7 +1925,7 @@ int8_t udf_delete_aext(struct inode * in
 			aed->lengthAllocDescs =
 				cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) - adsize);
 			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
-			    UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
+			    UDF_SB(inode->i_sb)->s_udfrev >= 0x0201)
 				udf_update_tag(oepos.bh->b_data, epos.offset - adsize);
 			else
 				udf_update_tag(oepos.bh->b_data, sizeof(struct allocExtDesc));
diff -puN fs/udf/misc.c~udf-remove-some-ugly-macros fs/udf/misc.c
--- a/fs/udf/misc.c~udf-remove-some-ugly-macros
+++ a/fs/udf/misc.c
@@ -81,14 +81,16 @@ struct genericFormat *udf_add_extendedat
 				return NULL;
 			}
 		} else {
+			struct udf_sb_info *sbi = UDF_SB(inode->i_sb);
+
 			size -= sizeof(struct extendedAttrHeaderDesc);
 			UDF_I_LENEATTR(inode) += sizeof(struct extendedAttrHeaderDesc);
 			eahd->descTag.tagIdent = cpu_to_le16(TAG_IDENT_EAHD);
-			if (UDF_SB_UDFREV(inode->i_sb) >= 0x0200)
+			if (sbi->s_udfrev >= 0x0200)
 				eahd->descTag.descVersion = cpu_to_le16(3);
 			else
 				eahd->descTag.descVersion = cpu_to_le16(2);
-			eahd->descTag.tagSerialNum = cpu_to_le16(UDF_SB_SERIALNUM(inode->i_sb));
+			eahd->descTag.tagSerialNum = cpu_to_le16(sbi->s_serial_number);
 			eahd->descTag.tagLocation = cpu_to_le32(UDF_I_LOCATION(inode).logicalBlockNum);
 			eahd->impAttrLocation = cpu_to_le32(0xFFFFFFFF);
 			eahd->appAttrLocation = cpu_to_le32(0xFFFFFFFF);
@@ -192,15 +194,16 @@ struct buffer_head *udf_read_tagged(stru
 	struct buffer_head *bh = NULL;
 	register uint8_t checksum;
 	register int i;
+	struct udf_sb_info *sbi = UDF_SB(sb);
 
 	/* Read the block */
 	if (block == 0xFFFFFFFF)
 		return NULL;
 
-	bh = udf_tread(sb, block + UDF_SB_SESSION(sb));
+	bh = udf_tread(sb, block + sbi->s_session);
 	if (!bh) {
 		udf_debug("block=%d, location=%d: read failed\n",
-			  block + UDF_SB_SESSION(sb), location);
+			  block + sbi->s_session, location);
 		return NULL;
 	}
 
@@ -210,7 +213,7 @@ struct buffer_head *udf_read_tagged(stru
 
 	if (location != le32_to_cpu(tag_p->tagLocation)) {
 		udf_debug("location mismatch block %u, tag %u != %u\n",
-			  block + UDF_SB_SESSION(sb), le32_to_cpu(tag_p->tagLocation), location);
+			  block + sbi->s_session, le32_to_cpu(tag_p->tagLocation), location);
 		goto error_out;
 	}
 
@@ -240,7 +243,7 @@ struct buffer_head *udf_read_tagged(stru
 		return bh;
 	}
 	udf_debug("Crc failure block %d: crc = %d, crclen = %d\n",
-		  block + UDF_SB_SESSION(sb), le16_to_cpu(tag_p->descCRC),
+		  block + sbi->s_session, le16_to_cpu(tag_p->descCRC),
 		  le16_to_cpu(tag_p->descCRCLength));
 
 error_out:
diff -puN fs/udf/namei.c~udf-remove-some-ugly-macros fs/udf/namei.c
--- a/fs/udf/namei.c~udf-remove-some-ugly-macros
+++ a/fs/udf/namei.c
@@ -325,7 +325,7 @@ static struct fileIdentDesc *udf_add_ent
 					   struct udf_fileident_bh *fibh,
 					   struct fileIdentDesc *cfi, int *err)
 {
-	struct super_block *sb;
+	struct super_block *sb = dir->i_sb;
 	struct fileIdentDesc *fi = NULL;
 	char name[UDF_NAME_LEN], fname[UDF_NAME_LEN];
 	int namelen;
@@ -342,8 +342,6 @@ static struct fileIdentDesc *udf_add_ent
 	sector_t offset;
 	struct extent_position epos = {};
 
-	sb = dir->i_sb;
-
 	if (dentry) {
 		if (!dentry->d_name.len) {
 			*err = -EINVAL;
@@ -535,7 +533,7 @@ add:
 	}
 
 	memset(cfi, 0, sizeof(struct fileIdentDesc));
-	if (UDF_SB_UDFREV(sb) >= 0x0200)
+	if (UDF_SB(sb)->s_udfrev >= 0x0200)
 		udf_new_tag((char *)cfi, TAG_IDENT_FID, 3, 1, block, sizeof(tag));
 	else
 		udf_new_tag((char *)cfi, TAG_IDENT_FID, 2, 1, block, sizeof(tag));
@@ -901,6 +899,7 @@ static int udf_symlink(struct inode *dir
 	int block;
 	char name[UDF_NAME_LEN];
 	int namelen;
+	struct buffer_head *bh;
 
 	lock_kernel();
 	if (!(inode = udf_new_inode(dir, S_IFLNK, &err)))
@@ -1014,17 +1013,19 @@ static int udf_symlink(struct inode *dir
 		goto out_no_entry;
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
 	cfi.icb.extLocation = cpu_to_lelb(UDF_I_LOCATION(inode));
-	if (UDF_SB_LVIDBH(inode->i_sb)) {
+	bh = UDF_SB(inode->i_sb)->s_lvid_bh;
+	if (bh) {
+		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)bh->b_data;
 		struct logicalVolHeaderDesc *lvhd;
 		uint64_t uniqueID;
-		lvhd = (struct logicalVolHeaderDesc *)(UDF_SB_LVID(inode->i_sb)->logicalVolContentsUse);
+		lvhd = (struct logicalVolHeaderDesc *)(lvid->logicalVolContentsUse);
 		uniqueID = le64_to_cpu(lvhd->uniqueID);
 		*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
 			cpu_to_le32(uniqueID & 0x00000000FFFFFFFFUL);
 		if (!(++uniqueID & 0x00000000FFFFFFFFUL))
 			uniqueID += 16;
 		lvhd->uniqueID = cpu_to_le64(uniqueID);
-		mark_buffer_dirty(UDF_SB_LVIDBH(inode->i_sb));
+		mark_buffer_dirty(bh);
 	}
 	udf_write_fi(dir, &cfi, fi, &fibh, NULL, NULL);
 	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
@@ -1053,6 +1054,7 @@ static int udf_link(struct dentry *old_d
 	struct udf_fileident_bh fibh;
 	struct fileIdentDesc cfi, *fi;
 	int err;
+	struct buffer_head *bh;
 
 	lock_kernel();
 	if (inode->i_nlink >= (256 << sizeof(inode->i_nlink)) - 1) {
@@ -1066,17 +1068,19 @@ static int udf_link(struct dentry *old_d
 	}
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
 	cfi.icb.extLocation = cpu_to_lelb(UDF_I_LOCATION(inode));
-	if (UDF_SB_LVIDBH(inode->i_sb)) {
+	bh = UDF_SB(inode->i_sb)->s_lvid_bh;
+	if (bh) {
+		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)bh->b_data;
 		struct logicalVolHeaderDesc *lvhd;
 		uint64_t uniqueID;
-		lvhd = (struct logicalVolHeaderDesc *)(UDF_SB_LVID(inode->i_sb)->logicalVolContentsUse);
+		lvhd = (struct logicalVolHeaderDesc *)(lvid->logicalVolContentsUse);
 		uniqueID = le64_to_cpu(lvhd->uniqueID);
 		*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
 			cpu_to_le32(uniqueID & 0x00000000FFFFFFFFUL);
 		if (!(++uniqueID & 0x00000000FFFFFFFFUL))
 			uniqueID += 16;
 		lvhd->uniqueID = cpu_to_le64(uniqueID);
-		mark_buffer_dirty(UDF_SB_LVIDBH(inode->i_sb));
+		mark_buffer_dirty(bh);
 	}
 	udf_write_fi(dir, &cfi, fi, &fibh, NULL, NULL);
 	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
diff -puN fs/udf/partition.c~udf-remove-some-ugly-macros fs/udf/partition.c
--- a/fs/udf/partition.c~udf-remove-some-ugly-macros
+++ a/fs/udf/partition.c
@@ -31,15 +31,18 @@
 inline uint32_t udf_get_pblock(struct super_block *sb, uint32_t block,
 			       uint16_t partition, uint32_t offset)
 {
-	if (partition >= UDF_SB_NUMPARTS(sb)) {
+	struct udf_sb_info *sbi = UDF_SB(sb);
+	struct udf_part_map *map;
+	if (partition >= sbi->s_partitions) {
 		udf_debug("block=%d, partition=%d, offset=%d: invalid partition\n",
 			  block, partition, offset);
 		return 0xFFFFFFFF;
 	}
-	if (UDF_SB_PARTFUNC(sb, partition))
-		return UDF_SB_PARTFUNC(sb, partition)(sb, block, partition, offset);
+	map = &sbi->s_partmaps[partition];
+	if (map->s_partition_func)
+		return map->s_partition_func(sb, block, partition, offset);
 	else
-		return UDF_SB_PARTROOT(sb, partition) + block + offset;
+		return map->s_partition_root + block + offset;
 }
 
 uint32_t udf_get_pblock_virt15(struct super_block *sb, uint32_t block,
@@ -49,12 +52,15 @@ uint32_t udf_get_pblock_virt15(struct su
 	uint32_t newblock;
 	uint32_t index;
 	uint32_t loc;
+	struct udf_sb_info *sbi = UDF_SB(sb);
+	struct udf_part_map *map;
 
-	index = (sb->s_blocksize - UDF_SB_TYPEVIRT(sb,partition).s_start_offset) / sizeof(uint32_t);
+	map = &sbi->s_partmaps[partition];
+	index = (sb->s_blocksize - map->s_type_specific.s_virtual.s_start_offset) / sizeof(uint32_t);
 
-	if (block > UDF_SB_TYPEVIRT(sb,partition).s_num_entries) {
+	if (block > map->s_type_specific.s_virtual.s_num_entries) {
 		udf_debug("Trying to access block beyond end of VAT (%d max %d)\n",
-			  block, UDF_SB_TYPEVIRT(sb,partition).s_num_entries);
+			  block, map->s_type_specific.s_virtual.s_num_entries);
 		return 0xFFFFFFFF;
 	}
 
@@ -64,10 +70,10 @@ uint32_t udf_get_pblock_virt15(struct su
 		index = block % (sb->s_blocksize / sizeof(uint32_t));
 	} else {
 		newblock = 0;
-		index = UDF_SB_TYPEVIRT(sb,partition).s_start_offset / sizeof(uint32_t) + block;
+		index = map->s_type_specific.s_virtual.s_start_offset / sizeof(uint32_t) + block;
 	}
 
-	loc = udf_block_map(UDF_SB_VAT(sb), newblock);
+	loc = udf_block_map(sbi->s_vat_inode, newblock);
 
 	if (!(bh = sb_bread(sb, loc))) {
 		udf_debug("get_pblock(UDF_VIRTUAL_MAP:%p,%d,%d) VAT: %d[%d]\n",
@@ -79,13 +85,13 @@ uint32_t udf_get_pblock_virt15(struct su
 
 	brelse(bh);
 
-	if (UDF_I_LOCATION(UDF_SB_VAT(sb)).partitionReferenceNum == partition) {
+	if (UDF_I_LOCATION(sbi->s_vat_inode).partitionReferenceNum == partition) {
 		udf_debug("recursive call to udf_get_pblock!\n");
 		return 0xFFFFFFFF;
 	}
 
 	return udf_get_pblock(sb, loc,
-			      UDF_I_LOCATION(UDF_SB_VAT(sb)).partitionReferenceNum,
+			      UDF_I_LOCATION(sbi->s_vat_inode).partitionReferenceNum,
 			      offset);
 }
 
@@ -95,16 +101,21 @@ inline uint32_t udf_get_pblock_virt20(st
 	return udf_get_pblock_virt15(sb, block, partition, offset);
 }
 
-uint32_t udf_get_pblock_spar15(struct super_block * sb, uint32_t block,
+uint32_t udf_get_pblock_spar15(struct super_block *sb, uint32_t block,
 			       uint16_t partition, uint32_t offset)
 {
 	int i;
 	struct sparingTable *st = NULL;
-	uint32_t packet = (block + offset) & ~(UDF_SB_TYPESPAR(sb,partition).s_packet_len - 1);
+	struct udf_sb_info *sbi = UDF_SB(sb);
+	struct udf_part_map *map;
+	uint32_t packet;
+
+	map = &sbi->s_partmaps[partition];
+	packet = (block + offset) & ~(map->s_type_specific.s_sparing.s_packet_len - 1);
 
 	for (i = 0; i < 4; i++) {
-		if (UDF_SB_TYPESPAR(sb,partition).s_spar_map[i] != NULL) {
-			st = (struct sparingTable *)UDF_SB_TYPESPAR(sb,partition).s_spar_map[i]->b_data;
+		if (map->s_type_specific.s_sparing.s_spar_map[i] != NULL) {
+			st = (struct sparingTable *)map->s_type_specific.s_sparing.s_spar_map[i]->b_data;
 			break;
 		}
 	}
@@ -115,14 +126,14 @@ uint32_t udf_get_pblock_spar15(struct su
 				break;
 			} else if (le32_to_cpu(st->mapEntry[i].origLocation) == packet) {
 				return le32_to_cpu(st->mapEntry[i].mappedLocation) +
-					((block + offset) & (UDF_SB_TYPESPAR(sb,partition).s_packet_len - 1));
+					((block + offset) & (map->s_type_specific.s_sparing.s_packet_len - 1));
 			} else if (le32_to_cpu(st->mapEntry[i].origLocation) > packet) {
 				break;
 			}
 		}
 	}
 
-	return UDF_SB_PARTROOT(sb,partition) + block + offset;
+	return map->s_partition_root + block + offset;
 }
 
 int udf_relocate_blocks(struct super_block *sb, long old_block, long *new_block)
@@ -132,15 +143,17 @@ int udf_relocate_blocks(struct super_blo
 	struct sparingEntry mapEntry;
 	uint32_t packet;
 	int i, j, k, l;
+	struct udf_sb_info *sbi = UDF_SB(sb);
 
-	for (i = 0; i < UDF_SB_NUMPARTS(sb); i++) {
-		if (old_block > UDF_SB_PARTROOT(sb,i) &&
-		    old_block < UDF_SB_PARTROOT(sb,i) + UDF_SB_PARTLEN(sb,i)) {
-			sdata = &UDF_SB_TYPESPAR(sb,i);
-			packet = (old_block - UDF_SB_PARTROOT(sb,i)) & ~(sdata->s_packet_len - 1);
+	for (i = 0; i < sbi->s_partitions; i++) {
+		struct udf_part_map *map = &sbi->s_partmaps[i];
+		if (old_block > map->s_partition_root &&
+		    old_block < map->s_partition_root + map->s_partition_len) {
+			sdata = &map->s_type_specific.s_sparing;
+			packet = (old_block - map->s_partition_root) & ~(sdata->s_packet_len - 1);
 
 			for (j = 0; j < 4; j++) {
-				if (UDF_SB_TYPESPAR(sb,i).s_spar_map[j] != NULL) {
+				if (map->s_type_specific.s_sparing.s_spar_map[j] != NULL) {
 					st = (struct sparingTable *)sdata->s_spar_map[j]->b_data;
 					break;
 				}
@@ -160,11 +173,11 @@ int udf_relocate_blocks(struct super_blo
 						}
 					}
 					*new_block = le32_to_cpu(st->mapEntry[k].mappedLocation) +
-						((old_block - UDF_SB_PARTROOT(sb,i)) & (sdata->s_packet_len - 1));
+						((old_block - map->s_partition_root) & (sdata->s_packet_len - 1));
 					return 0;
 				} else if (le32_to_cpu(st->mapEntry[k].origLocation) == packet) {
 					*new_block = le32_to_cpu(st->mapEntry[k].mappedLocation) +
-						((old_block - UDF_SB_PARTROOT(sb,i)) & (sdata->s_packet_len - 1));
+						((old_block - map->s_partition_root) & (sdata->s_packet_len - 1));
 					return 0;
 				} else if (le32_to_cpu(st->mapEntry[k].origLocation) > packet) {
 					break;
@@ -185,7 +198,7 @@ int udf_relocate_blocks(struct super_blo
 						}
 					}
 					*new_block = le32_to_cpu(st->mapEntry[k].mappedLocation) +
-						((old_block - UDF_SB_PARTROOT(sb,i)) & (sdata->s_packet_len - 1));
+						((old_block - map->s_partition_root) & (sdata->s_packet_len - 1));
 					return 0;
 				}
 			}
@@ -194,7 +207,7 @@ int udf_relocate_blocks(struct super_blo
 		} /* if old_block */
 	}
 
-	if (i == UDF_SB_NUMPARTS(sb)) {
+	if (i == sbi->s_partitions) {
 		/* outside of partitions */
 		/* for now, fail =) */
 		return 1;
diff -puN fs/udf/super.c~udf-remove-some-ugly-macros fs/udf/super.c
--- a/fs/udf/super.c~udf-remove-some-ugly-macros
+++ a/fs/udf/super.c
@@ -95,6 +95,14 @@ static void udf_close_lvid(struct super_
 static unsigned int udf_count_free(struct super_block *);
 static int udf_statfs(struct dentry *, struct kstatfs *);
 
+struct logicalVolIntegrityDescImpUse *udf_sb_lvidiu(struct udf_sb_info *sbi)
+{
+	struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
+	__u32 number_of_partitions = le32_to_cpu(lvid->numOfPartitions);
+	__u32 offset = number_of_partitions * 2 * sizeof(uint32_t)/sizeof(uint8_t);
+	return (struct logicalVolIntegrityDescImpUse *)&(lvid->impUse[offset]);
+}
+
 /* UDF filesystem type */
 static int udf_get_sb(struct file_system_type *fs_type,
 		      int flags, const char *dev_name, void *data,
@@ -461,22 +469,23 @@ void udf_write_super(struct super_block 
 static int udf_remount_fs(struct super_block *sb, int *flags, char *options)
 {
 	struct udf_options uopt;
+	struct udf_sb_info *sbi = UDF_SB(sb);
 
-	uopt.flags = UDF_SB(sb)->s_flags;
-	uopt.uid   = UDF_SB(sb)->s_uid;
-	uopt.gid   = UDF_SB(sb)->s_gid;
-	uopt.umask = UDF_SB(sb)->s_umask;
+	uopt.flags = sbi->s_flags;
+	uopt.uid   = sbi->s_uid;
+	uopt.gid   = sbi->s_gid;
+	uopt.umask = sbi->s_umask;
 
 	if (!udf_parse_options(options, &uopt))
 		return -EINVAL;
 
-	UDF_SB(sb)->s_flags = uopt.flags;
-	UDF_SB(sb)->s_uid   = uopt.uid;
-	UDF_SB(sb)->s_gid   = uopt.gid;
-	UDF_SB(sb)->s_umask = uopt.umask;
+	sbi->s_flags = uopt.flags;
+	sbi->s_uid   = uopt.uid;
+	sbi->s_gid   = uopt.gid;
+	sbi->s_umask = uopt.umask;
 
-	if (UDF_SB_LVIDBH(sb)) {
-		int write_rev = le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFWriteRev);
+	if (sbi->s_lvid_bh) {
+		int write_rev = le16_to_cpu(udf_sb_lvidiu(sbi)->minUDFWriteRev);
 		if (write_rev > UDF_MAX_WRITE_VERSION)
 			*flags |= MS_RDONLY;
 	}
@@ -538,17 +547,19 @@ static int udf_vrs(struct super_block *s
 	int iso9660 = 0;
 	int nsr02 = 0;
 	int nsr03 = 0;
+	struct udf_sb_info *sbi;
 
 	/* Block size must be a multiple of 512 */
 	if (sb->s_blocksize & 511)
 		return 0;
+	sbi = UDF_SB(sb);
 
 	if (sb->s_blocksize < sizeof(struct volStructDesc))
 		sectorsize = sizeof(struct volStructDesc);
 	else
 		sectorsize = sb->s_blocksize;
 
-	sector += (UDF_SB_SESSION(sb) << sb->s_blocksize_bits);
+	sector += (sbi->s_session << sb->s_blocksize_bits);
 
 	udf_debug("Starting at sector %u (%ld byte sectors)\n",
 		  (sector >> sb->s_blocksize_bits), sb->s_blocksize);
@@ -614,7 +625,7 @@ static int udf_vrs(struct super_block *s
 		return nsr03;
 	else if (nsr02)
 		return nsr02;
-	else if (sector - (UDF_SB_SESSION(sb) << sb->s_blocksize_bits) == 32768)
+	else if (sector - (sbi->s_session << sb->s_blocksize_bits) == 32768)
 		return -1;
 	else
 		return 0;
@@ -639,11 +650,15 @@ static int udf_vrs(struct super_block *s
  */
 static void udf_find_anchor(struct super_block *sb)
 {
-	int lastblock = UDF_SB_LASTBLOCK(sb);
+	int lastblock;
 	struct buffer_head *bh = NULL;
 	uint16_t ident;
 	uint32_t location;
 	int i;
+	struct udf_sb_info *sbi;
+
+	sbi = UDF_SB(sb);
+	lastblock = sbi->s_last_block;
 
 	if (lastblock) {
 		int varlastblock = udf_variable_to_fixed(lastblock);
@@ -675,22 +690,22 @@ static void udf_find_anchor(struct super
 			}
 
 			if (ident == TAG_IDENT_AVDP) {
-				if (location == last[i] - UDF_SB_SESSION(sb)) {
-					lastblock = last[i] - UDF_SB_SESSION(sb);
-					UDF_SB_ANCHOR(sb)[0] = lastblock;
-					UDF_SB_ANCHOR(sb)[1] = lastblock - 256;
-				} else if (location == udf_variable_to_fixed(last[i]) - UDF_SB_SESSION(sb)) {
+				if (location == last[i] - sbi->s_session) {
+					lastblock = last[i] - sbi->s_session;
+					sbi->s_anchor[0] = lastblock;
+					sbi->s_anchor[1] = lastblock - 256;
+				} else if (location == udf_variable_to_fixed(last[i]) - sbi->s_session) {
 					UDF_SET_FLAG(sb, UDF_FLAG_VARCONV);
-					lastblock = udf_variable_to_fixed(last[i]) - UDF_SB_SESSION(sb);
-					UDF_SB_ANCHOR(sb)[0] = lastblock;
-					UDF_SB_ANCHOR(sb)[1] = lastblock - 256 - UDF_SB_SESSION(sb);
+					lastblock = udf_variable_to_fixed(last[i]) - sbi->s_session;
+					sbi->s_anchor[0] = lastblock;
+					sbi->s_anchor[1] = lastblock - 256 - sbi->s_session;
 				} else {
 					udf_debug("Anchor found at block %d, location mismatch %d.\n",
 						  last[i], location);
 				}
 			} else if (ident == TAG_IDENT_FE || ident == TAG_IDENT_EFE) {
 				lastblock = last[i];
-				UDF_SB_ANCHOR(sb)[3] = 512;
+				sbi->s_anchor[3] = 512;
 			} else {
 				ident = location = 0;
 				if (last[i] >= 256) {
@@ -704,13 +719,13 @@ static void udf_find_anchor(struct super
 				}
 
 				if (ident == TAG_IDENT_AVDP &&
-				    location == last[i] - 256 - UDF_SB_SESSION(sb)) {
+				    location == last[i] - 256 - sbi->s_session) {
 					lastblock = last[i];
-					UDF_SB_ANCHOR(sb)[1] = last[i] - 256;
+					sbi->s_anchor[1] = last[i] - 256;
 				} else {
 					ident = location = 0;
-					if (last[i] >= 312 + UDF_SB_SESSION(sb)) {
-						bh = sb_bread(sb, last[i] - 312 - UDF_SB_SESSION(sb));
+					if (last[i] >= 312 + sbi->s_session) {
+						bh = sb_bread(sb, last[i] - 312 - sbi->s_session);
 						if (bh) {
 							tag *t = (tag *)bh->b_data;
 							ident = le16_to_cpu(t->tagIdent);
@@ -723,7 +738,7 @@ static void udf_find_anchor(struct super
 					    location == udf_variable_to_fixed(last[i]) - 256) {
 						UDF_SET_FLAG(sb, UDF_FLAG_VARCONV);
 						lastblock = udf_variable_to_fixed(last[i]);
-						UDF_SB_ANCHOR(sb)[1] = lastblock - 256;
+						sbi->s_anchor[1] = lastblock - 256;
 					}
 				}
 			}
@@ -732,7 +747,7 @@ static void udf_find_anchor(struct super
 
 	if (!lastblock) {
 		/* We haven't found the lastblock. check 312 */
-		bh = sb_bread(sb, 312 + UDF_SB_SESSION(sb));
+		bh = sb_bread(sb, 312 + sbi->s_session);
 		if (bh) {
 			tag *t = (tag *)bh->b_data;
 			ident = le16_to_cpu(t->tagIdent);
@@ -744,22 +759,22 @@ static void udf_find_anchor(struct super
 		}
 	}
 
-	for (i = 0; i < ARRAY_SIZE(UDF_SB_ANCHOR(sb)); i++) {
-		if (UDF_SB_ANCHOR(sb)[i]) {
-			bh = udf_read_tagged(sb, UDF_SB_ANCHOR(sb)[i],
-					     UDF_SB_ANCHOR(sb)[i], &ident);
+	for (i = 0; i < ARRAY_SIZE(sbi->s_anchor); i++) {
+		if (sbi->s_anchor[i]) {
+			bh = udf_read_tagged(sb, sbi->s_anchor[i],
+					     sbi->s_anchor[i], &ident);
 			if (!bh)
-				UDF_SB_ANCHOR(sb)[i] = 0;
+				sbi->s_anchor[i] = 0;
 			else {
 				brelse(bh);
 				if ((ident != TAG_IDENT_AVDP) &&
 				    (i || (ident != TAG_IDENT_FE && ident != TAG_IDENT_EFE)))
-					UDF_SB_ANCHOR(sb)[i] = 0;
+					sbi->s_anchor[i] = 0;
 			}
 		}
 	}
 
-	UDF_SB_LASTBLOCK(sb) = lastblock;
+	sbi->s_last_block = lastblock;
 }
 
 static int udf_find_fileset(struct super_block *sb,
@@ -769,6 +784,7 @@ static int udf_find_fileset(struct super
 	struct buffer_head *bh = NULL;
 	long lastblock;
 	uint16_t ident;
+	struct udf_sb_info *sbi;
 
 	if (fileset->logicalBlockNum != 0xFFFFFFFF ||
 	    fileset->partitionReferenceNum != 0xFFFF) {
@@ -783,6 +799,7 @@ static int udf_find_fileset(struct super
 
 	}
 
+	sbi = UDF_SB(sb);
 	if (!bh) {
 		/* Search backwards through the partitions */
 		kernel_lb_addr newfileset;
@@ -790,13 +807,14 @@ static int udf_find_fileset(struct super
 /* --> cvg: FIXME - is it reasonable? */
 		return 1;
 
-		for (newfileset.partitionReferenceNum = UDF_SB_NUMPARTS(sb) - 1;
+		for (newfileset.partitionReferenceNum = sbi->s_partitions - 1;
 		     (newfileset.partitionReferenceNum != 0xFFFF &&
 		      fileset->logicalBlockNum == 0xFFFFFFFF &&
 		      fileset->partitionReferenceNum == 0xFFFF);
 		     newfileset.partitionReferenceNum--) {
-			lastblock = UDF_SB_PARTLEN(sb,
-					newfileset.partitionReferenceNum);
+			lastblock = sbi->s_partmaps
+					[newfileset.partitionReferenceNum]
+						.s_partition_len;
 			newfileset.logicalBlockNum = 0;
 
 			do {
@@ -840,7 +858,7 @@ static int udf_find_fileset(struct super
 			  fileset->logicalBlockNum,
 			  fileset->partitionReferenceNum);
 
-		UDF_SB_PARTITION(sb) = fileset->partitionReferenceNum;
+		sbi->s_partition = fileset->partitionReferenceNum;
 		udf_load_fileset(sb, bh, root);
 		brelse(bh);
 		return 0;
@@ -867,15 +885,15 @@ static void udf_load_pvoldesc(struct sup
 			  recording, recording_usec,
 			  ts.year, ts.month, ts.day, ts.hour,
 			  ts.minute, ts.typeAndTimezone);
-		UDF_SB_RECORDTIME(sb).tv_sec = recording;
-		UDF_SB_RECORDTIME(sb).tv_nsec = recording_usec * 1000;
+		UDF_SB(sb)->s_record_time.tv_sec = recording;
+		UDF_SB(sb)->s_record_time.tv_nsec = recording_usec * 1000;
 	}
 
 	if (!udf_build_ustr(&instr, pvoldesc->volIdent, 32)) {
 		if (udf_CS0toUTF8(&outstr, &instr)) {
-			strncpy(UDF_SB_VOLIDENT(sb), outstr.u_name,
+			strncpy(UDF_SB(sb)->s_volume_ident, outstr.u_name,
 				outstr.u_len > 31 ? 31 : outstr.u_len);
-			udf_debug("volIdent[] = '%s'\n", UDF_SB_VOLIDENT(sb));
+			udf_debug("volIdent[] = '%s'\n", UDF_SB(sb)->s_volume_ident);
 		}
 	}
 
@@ -894,7 +912,7 @@ static void udf_load_fileset(struct supe
 
 	*root = lelb_to_cpu(fset->rootDirectoryICB.extLocation);
 
-	UDF_SB_SERIALNUM(sb) = le16_to_cpu(fset->descTag.tagSerialNum);
+	UDF_SB(sb)->s_serial_number = le16_to_cpu(fset->descTag.tagSerialNum);
 
 	udf_debug("Rootdir at block=%d, partition=%d\n",
 		  root->logicalBlockNum, root->partitionReferenceNum);
@@ -904,23 +922,27 @@ static int udf_load_partdesc(struct supe
 {
 	struct partitionDesc *p;
 	int i;
+	struct udf_part_map *map;
+	struct udf_sb_info *sbi;
 
 	p = (struct partitionDesc *)bh->b_data;
+	sbi = UDF_SB(sb);
 
-	for (i = 0; i < UDF_SB_NUMPARTS(sb); i++) {
+	for (i = 0; i < sbi->s_partitions; i++) {
+		map = &sbi->s_partmaps[i];
 		udf_debug("Searching map: (%d == %d)\n",
-			  UDF_SB_PARTMAPS(sb)[i].s_partition_num, le16_to_cpu(p->partitionNumber));
-		if (UDF_SB_PARTMAPS(sb)[i].s_partition_num == le16_to_cpu(p->partitionNumber)) {
-			UDF_SB_PARTLEN(sb, i) = le32_to_cpu(p->partitionLength); /* blocks */
-			UDF_SB_PARTROOT(sb, i) = le32_to_cpu(p->partitionStartingLocation);
+			  map->s_partition_num, le16_to_cpu(p->partitionNumber));
+		if (map->s_partition_num == le16_to_cpu(p->partitionNumber)) {
+			map->s_partition_len = le32_to_cpu(p->partitionLength); /* blocks */
+			map->s_partition_root = le32_to_cpu(p->partitionStartingLocation);
 			if (le32_to_cpu(p->accessType) == PD_ACCESS_TYPE_READ_ONLY)
-				UDF_SB_PARTFLAGS(sb, i) |= UDF_PART_FLAG_READ_ONLY;
+				map->s_partition_flags |= UDF_PART_FLAG_READ_ONLY;
 			if (le32_to_cpu(p->accessType) == PD_ACCESS_TYPE_WRITE_ONCE)
-				UDF_SB_PARTFLAGS(sb, i) |= UDF_PART_FLAG_WRITE_ONCE;
+				map->s_partition_flags |= UDF_PART_FLAG_WRITE_ONCE;
 			if (le32_to_cpu(p->accessType) == PD_ACCESS_TYPE_REWRITABLE)
-				UDF_SB_PARTFLAGS(sb, i) |= UDF_PART_FLAG_REWRITABLE;
+				map->s_partition_flags |= UDF_PART_FLAG_REWRITABLE;
 			if (le32_to_cpu(p->accessType) == PD_ACCESS_TYPE_OVERWRITABLE)
-				UDF_SB_PARTFLAGS(sb, i) |= UDF_PART_FLAG_OVERWRITABLE;
+				map->s_partition_flags |= UDF_PART_FLAG_OVERWRITABLE;
 
 			if (!strcmp(p->partitionContents.ident,
 				    PD_PARTITION_CONTENTS_NSR02) ||
@@ -935,26 +957,26 @@ static int udf_load_partdesc(struct supe
 						.partitionReferenceNum = i,
 					};
 
-					UDF_SB_PARTMAPS(sb)[i].s_uspace.s_table =
+					map->s_uspace.s_table =
 						udf_iget(sb, loc);
-					if (!UDF_SB_PARTMAPS(sb)[i].s_uspace.s_table) {
+					if (!map->s_uspace.s_table) {
 						udf_debug("cannot load unallocSpaceTable (part %d)\n", i);
 						return 1;
 					}
-					UDF_SB_PARTFLAGS(sb, i) |= UDF_PART_FLAG_UNALLOC_TABLE;
+					map->s_partition_flags |= UDF_PART_FLAG_UNALLOC_TABLE;
 					udf_debug("unallocSpaceTable (part %d) @ %ld\n",
-						  i, UDF_SB_PARTMAPS(sb)[i].s_uspace.s_table->i_ino);
+						  i, map->s_uspace.s_table->i_ino);
 				}
 				if (phd->unallocSpaceBitmap.extLength) {
 					UDF_SB_ALLOC_BITMAP(sb, i, s_uspace);
-					if (UDF_SB_PARTMAPS(sb)[i].s_uspace.s_bitmap != NULL) {
-						UDF_SB_PARTMAPS(sb)[i].s_uspace.s_bitmap->s_extLength =
+					if (map->s_uspace.s_bitmap != NULL) {
+						map->s_uspace.s_bitmap->s_extLength =
 							le32_to_cpu(phd->unallocSpaceBitmap.extLength);
-						UDF_SB_PARTMAPS(sb)[i].s_uspace.s_bitmap->s_extPosition =
+						map->s_uspace.s_bitmap->s_extPosition =
 							le32_to_cpu(phd->unallocSpaceBitmap.extPosition);
-						UDF_SB_PARTFLAGS(sb, i) |= UDF_PART_FLAG_UNALLOC_BITMAP;
+						map->s_partition_flags |= UDF_PART_FLAG_UNALLOC_BITMAP;
 						udf_debug("unallocSpaceBitmap (part %d) @ %d\n",
-							  i, UDF_SB_PARTMAPS(sb)[i].s_uspace.s_bitmap->s_extPosition);
+							  i, map->s_uspace.s_bitmap->s_extPosition);
 					}
 				}
 				if (phd->partitionIntegrityTable.extLength)
@@ -965,41 +987,42 @@ static int udf_load_partdesc(struct supe
 						.partitionReferenceNum = i,
 					};
 
-					UDF_SB_PARTMAPS(sb)[i].s_fspace.s_table =
+					map->s_fspace.s_table =
 						udf_iget(sb, loc);
-					if (!UDF_SB_PARTMAPS(sb)[i].s_fspace.s_table) {
+					if (!map->s_fspace.s_table) {
 						udf_debug("cannot load freedSpaceTable (part %d)\n", i);
 						return 1;
 					}
-					UDF_SB_PARTFLAGS(sb, i) |= UDF_PART_FLAG_FREED_TABLE;
+					map->s_partition_flags |= UDF_PART_FLAG_FREED_TABLE;
 					udf_debug("freedSpaceTable (part %d) @ %ld\n",
-						  i, UDF_SB_PARTMAPS(sb)[i].s_fspace.s_table->i_ino);
+						  i, map->s_fspace.s_table->i_ino);
 				}
 				if (phd->freedSpaceBitmap.extLength) {
 					UDF_SB_ALLOC_BITMAP(sb, i, s_fspace);
-					if (UDF_SB_PARTMAPS(sb)[i].s_fspace.s_bitmap != NULL) {
-						UDF_SB_PARTMAPS(sb)[i].s_fspace.s_bitmap->s_extLength =
+					if (map->s_fspace.s_bitmap != NULL) {
+						map->s_fspace.s_bitmap->s_extLength =
 							le32_to_cpu(phd->freedSpaceBitmap.extLength);
-						UDF_SB_PARTMAPS(sb)[i].s_fspace.s_bitmap->s_extPosition =
+						map->s_fspace.s_bitmap->s_extPosition =
 							le32_to_cpu(phd->freedSpaceBitmap.extPosition);
-						UDF_SB_PARTFLAGS(sb, i) |= UDF_PART_FLAG_FREED_BITMAP;
+						map->s_partition_flags |= UDF_PART_FLAG_FREED_BITMAP;
 						udf_debug("freedSpaceBitmap (part %d) @ %d\n",
-							  i, UDF_SB_PARTMAPS(sb)[i].s_fspace.s_bitmap->s_extPosition);
+							  i, map->s_fspace.s_bitmap->s_extPosition);
 					}
 				}
 			}
 			break;
 		}
 	}
-	if (i == UDF_SB_NUMPARTS(sb)) {
+	if (i == sbi->s_partitions) {
 		udf_debug("Partition (%d) not found in partition map\n",
 			  le16_to_cpu(p->partitionNumber));
 	} else {
 		udf_debug("Partition (%d:%d type %x) starts at physical %d, "
 			  "block length %d\n",
 			  le16_to_cpu(p->partitionNumber), i,
-			  UDF_SB_PARTTYPE(sb, i), UDF_SB_PARTROOT(sb, i),
-			  UDF_SB_PARTLEN(sb, i));
+			  map->s_partition_type,
+			  map->s_partition_root,
+			  map->s_partition_len);
 	}
 	return 0;
 }
@@ -1010,30 +1033,32 @@ static int udf_load_logicalvol(struct su
 	struct logicalVolDesc *lvd;
 	int i, j, offset;
 	uint8_t type;
+	struct udf_sb_info *sbi = UDF_SB(sb);
 
 	lvd = (struct logicalVolDesc *)bh->b_data;
 
 	UDF_SB_ALLOC_PARTMAPS(sb, le32_to_cpu(lvd->numPartitionMaps));
 
 	for (i = 0, offset = 0;
-	     i < UDF_SB_NUMPARTS(sb) && offset < le32_to_cpu(lvd->mapTableLength);
+	     i < sbi->s_partitions && offset < le32_to_cpu(lvd->mapTableLength);
 	     i++, offset += ((struct genericPartitionMap *)&(lvd->partitionMaps[offset]))->partitionMapLength) {
+	     	struct udf_part_map *map = &sbi->s_partmaps[i];
 		type = ((struct genericPartitionMap *)&(lvd->partitionMaps[offset]))->partitionMapType;
 		if (type == 1) {
 			struct genericPartitionMap1 *gpm1 = (struct genericPartitionMap1 *)&(lvd->partitionMaps[offset]);
-			UDF_SB_PARTTYPE(sb, i) = UDF_TYPE1_MAP15;
-			UDF_SB_PARTVSN(sb, i) = le16_to_cpu(gpm1->volSeqNum);
-			UDF_SB_PARTNUM(sb, i) = le16_to_cpu(gpm1->partitionNum);
-			UDF_SB_PARTFUNC(sb, i) = NULL;
+			map->s_partition_type = UDF_TYPE1_MAP15;
+			map->s_volumeseqnum = le16_to_cpu(gpm1->volSeqNum);
+			map->s_partition_num = le16_to_cpu(gpm1->partitionNum);
+			map->s_partition_func = NULL;
 		} else if (type == 2) {
 			struct udfPartitionMap2 *upm2 = (struct udfPartitionMap2 *)&(lvd->partitionMaps[offset]);
 			if (!strncmp(upm2->partIdent.ident, UDF_ID_VIRTUAL, strlen(UDF_ID_VIRTUAL))) {
 				if (le16_to_cpu(((__le16 *)upm2->partIdent.identSuffix)[0]) == 0x0150) {
-					UDF_SB_PARTTYPE(sb, i) = UDF_VIRTUAL_MAP15;
-					UDF_SB_PARTFUNC(sb, i) = udf_get_pblock_virt15;
+					map->s_partition_type = UDF_VIRTUAL_MAP15;
+					map->s_partition_func = udf_get_pblock_virt15;
 				} else if (le16_to_cpu(((__le16 *)upm2->partIdent.identSuffix)[0]) == 0x0200) {
-					UDF_SB_PARTTYPE(sb, i) = UDF_VIRTUAL_MAP20;
-					UDF_SB_PARTFUNC(sb, i) = udf_get_pblock_virt20;
+					map->s_partition_type = UDF_VIRTUAL_MAP20;
+					map->s_partition_func = udf_get_pblock_virt20;
 				}
 			} else if (!strncmp(upm2->partIdent.ident, UDF_ID_SPARABLE, strlen(UDF_ID_SPARABLE))) {
 				uint32_t loc;
@@ -1041,33 +1066,33 @@ static int udf_load_logicalvol(struct su
 				struct sparingTable *st;
 				struct sparablePartitionMap *spm = (struct sparablePartitionMap *)&(lvd->partitionMaps[offset]);
 
-				UDF_SB_PARTTYPE(sb, i) = UDF_SPARABLE_MAP15;
-				UDF_SB_TYPESPAR(sb, i).s_packet_len = le16_to_cpu(spm->packetLength);
+				map->s_partition_type = UDF_SPARABLE_MAP15;
+				map->s_type_specific.s_sparing.s_packet_len = le16_to_cpu(spm->packetLength);
 				for (j = 0; j < spm->numSparingTables; j++) {
 					loc = le32_to_cpu(spm->locSparingTable[j]);
-					UDF_SB_TYPESPAR(sb, i).s_spar_map[j] =
+					map->s_type_specific.s_sparing.s_spar_map[j] =
 						udf_read_tagged(sb, loc, loc, &ident);
-					if (UDF_SB_TYPESPAR(sb, i).s_spar_map[j] != NULL) {
-						st = (struct sparingTable *)UDF_SB_TYPESPAR(sb, i).s_spar_map[j]->b_data;
+					if (map->s_type_specific.s_sparing.s_spar_map[j] != NULL) {
+						st = (struct sparingTable *)map->s_type_specific.s_sparing.s_spar_map[j]->b_data;
 						if (ident != 0 ||
 						    strncmp(st->sparingIdent.ident, UDF_ID_SPARING, strlen(UDF_ID_SPARING))) {
-							brelse(UDF_SB_TYPESPAR(sb, i).s_spar_map[j]);
-							UDF_SB_TYPESPAR(sb, i).s_spar_map[j] = NULL;
+							brelse(map->s_type_specific.s_sparing.s_spar_map[j]);
+							map->s_type_specific.s_sparing.s_spar_map[j] = NULL;
 						}
 					}
 				}
-				UDF_SB_PARTFUNC(sb, i) = udf_get_pblock_spar15;
+				map->s_partition_func = udf_get_pblock_spar15;
 			} else {
 				udf_debug("Unknown ident: %s\n",
 					  upm2->partIdent.ident);
 				continue;
 			}
-			UDF_SB_PARTVSN(sb, i) = le16_to_cpu(upm2->volSeqNum);
-			UDF_SB_PARTNUM(sb, i) = le16_to_cpu(upm2->partitionNum);
+			map->s_volumeseqnum = le16_to_cpu(upm2->volSeqNum);
+			map->s_partition_num = le16_to_cpu(upm2->partitionNum);
 		}
 		udf_debug("Partition (%d:%d) type %d on volume %d\n",
-			  i, UDF_SB_PARTNUM(sb, i), type,
-			  UDF_SB_PARTVSN(sb, i));
+			  i, map->s_partition_num, type,
+			  map->s_volumeseqnum);
 	}
 
 	if (fileset) {
@@ -1092,23 +1117,26 @@ static void udf_load_logicalvolint(struc
 {
 	struct buffer_head *bh = NULL;
 	uint16_t ident;
+	struct udf_sb_info *sbi = UDF_SB(sb);
+	struct logicalVolIntegrityDesc *lvid;
 
 	while (loc.extLength > 0 &&
 	       (bh = udf_read_tagged(sb, loc.extLocation,
 				     loc.extLocation, &ident)) &&
 	       ident == TAG_IDENT_LVID) {
-		UDF_SB_LVIDBH(sb) = bh;
+		sbi->s_lvid_bh = bh;
+		lvid = (struct logicalVolIntegrityDesc *)bh->b_data;
 
-		if (UDF_SB_LVID(sb)->nextIntegrityExt.extLength)
+		if (lvid->nextIntegrityExt.extLength)
 			udf_load_logicalvolint(sb,
-				leea_to_cpu(UDF_SB_LVID(sb)->nextIntegrityExt));
+				leea_to_cpu(lvid->nextIntegrityExt));
 
-		if (UDF_SB_LVIDBH(sb) != bh)
+		if (sbi->s_lvid_bh != bh)
 			brelse(bh);
 		loc.extLength -= sb->s_blocksize;
 		loc.extLocation++;
 	}
-	if (UDF_SB_LVIDBH(sb) != bh)
+	if (sbi->s_lvid_bh != bh)
 		brelse(bh);
 }
 
@@ -1259,10 +1287,11 @@ static int udf_check_valid(struct super_
 	else {
 		block = udf_vrs(sb, silent);
 		if (block == -1) {
+			struct udf_sb_info *sbi = UDF_SB(sb);
 			udf_debug("Failed to read byte 32768. Assuming open "
 				  "disc. Skipping validity check\n");
-			if (!UDF_SB_LASTBLOCK(sb))
-				UDF_SB_LASTBLOCK(sb) = udf_get_last_block(sb);
+			if (!sbi->s_last_block)
+				sbi->s_last_block = udf_get_last_block(sb);
 			return 0;
 		} else
 			return !block;
@@ -1276,14 +1305,16 @@ static int udf_load_partition(struct sup
 	struct buffer_head *bh;
 	long main_s, main_e, reserve_s, reserve_e;
 	int i, j;
+	struct udf_sb_info *sbi;
 
 	if (!sb)
 		return 1;
+	sbi = UDF_SB(sb);
 
-	for (i = 0; i < ARRAY_SIZE(UDF_SB_ANCHOR(sb)); i++) {
-		if (UDF_SB_ANCHOR(sb)[i] &&
-		    (bh = udf_read_tagged(sb, UDF_SB_ANCHOR(sb)[i],
-					  UDF_SB_ANCHOR(sb)[i], &ident))) {
+	for (i = 0; i < ARRAY_SIZE(sbi->s_anchor); i++) {
+		if (sbi->s_anchor[i] &&
+		    (bh = udf_read_tagged(sb, sbi->s_anchor[i],
+					  sbi->s_anchor[i], &ident))) {
 			anchor = (struct anchorVolDescPtr *)bh->b_data;
 
 			/* Locate the main sequence */
@@ -1308,68 +1339,72 @@ static int udf_load_partition(struct sup
 		}
 	}
 
-	if (i == ARRAY_SIZE(UDF_SB_ANCHOR(sb))) {
+	if (i == ARRAY_SIZE(sbi->s_anchor)) {
 		udf_debug("No Anchor block found\n");
 		return 1;
 	} else
-		udf_debug("Using anchor in block %d\n", UDF_SB_ANCHOR(sb)[i]);
+		udf_debug("Using anchor in block %d\n", sbi->s_anchor[i]);
 
-	for (i = 0; i < UDF_SB_NUMPARTS(sb); i++) {
+	for (i = 0; i < sbi->s_partitions; i++) {
 		kernel_lb_addr uninitialized_var(ino);
-		switch (UDF_SB_PARTTYPE(sb, i)) {
+		struct udf_part_map *map = &sbi->s_partmaps[i];
+		switch (map->s_partition_type) {
 		case UDF_VIRTUAL_MAP15:
 		case UDF_VIRTUAL_MAP20:
-			if (!UDF_SB_LASTBLOCK(sb)) {
-				UDF_SB_LASTBLOCK(sb) = udf_get_last_block(sb);
+			if (!sbi->s_last_block) {
+				sbi->s_last_block = udf_get_last_block(sb);
 				udf_find_anchor(sb);
 			}
 
-			if (!UDF_SB_LASTBLOCK(sb)) {
+			if (!sbi->s_last_block) {
 				udf_debug("Unable to determine Lastblock (For "
 					  "Virtual Partition)\n");
 				return 1;
 			}
 
-			for (j = 0; j < UDF_SB_NUMPARTS(sb); j++) {
+			for (j = 0; j < sbi->s_partitions; j++) {
+				struct udf_part_map *map2 = &sbi->s_partmaps[j];
 				if (j != i &&
-				    UDF_SB_PARTVSN(sb, i) == UDF_SB_PARTVSN(sb, j) &&
-				    UDF_SB_PARTNUM(sb, i) == UDF_SB_PARTNUM(sb, j)) {
+				    map->s_volumeseqnum == map2->s_volumeseqnum &&
+				    map->s_partition_num == map2->s_partition_num) {
 					ino.partitionReferenceNum = j;
-					ino.logicalBlockNum = UDF_SB_LASTBLOCK(sb) - UDF_SB_PARTROOT(sb, j);
+					ino.logicalBlockNum = sbi->s_last_block - map2->s_partition_root;
 					break;
 				}
 			}
 
-			if (j == UDF_SB_NUMPARTS(sb))
+			if (j == sbi->s_partitions)
 				return 1;
 
-			UDF_SB_VAT(sb) = udf_iget(sb, ino);
-			if (!UDF_SB_VAT(sb))
+			sbi->s_vat_inode = udf_iget(sb, ino);
+			if (!sbi->s_vat_inode)
 				return 1;
 
-			if (UDF_SB_PARTTYPE(sb, i) == UDF_VIRTUAL_MAP15) {
-				UDF_SB_TYPEVIRT(sb, i).s_start_offset =
-					udf_ext0_offset(UDF_SB_VAT(sb));
-				UDF_SB_TYPEVIRT(sb, i).s_num_entries =
-					(UDF_SB_VAT(sb)->i_size - 36) >> 2;
-			} else if (UDF_SB_PARTTYPE(sb, i) == UDF_VIRTUAL_MAP20) {
+			if (map->s_partition_type == UDF_VIRTUAL_MAP15) {
+				map->s_type_specific.s_virtual.s_start_offset =
+					udf_ext0_offset(sbi->s_vat_inode);
+				map->s_type_specific.s_virtual.s_num_entries =
+					(sbi->s_vat_inode->i_size - 36) >> 2;
+			} else if (map->s_partition_type == UDF_VIRTUAL_MAP20) {
 				struct buffer_head *bh = NULL;
 				uint32_t pos;
 
-				pos = udf_block_map(UDF_SB_VAT(sb), 0);
+				pos = udf_block_map(sbi->s_vat_inode, 0);
 				bh = sb_bread(sb, pos);
 				if (!bh)
 					return 1;
-				UDF_SB_TYPEVIRT(sb, i).s_start_offset =
+				map->s_type_specific.s_virtual.s_start_offset =
 					le16_to_cpu(((struct virtualAllocationTable20 *)bh->b_data +
-						     udf_ext0_offset(UDF_SB_VAT(sb)))->lengthHeader) +
-					udf_ext0_offset(UDF_SB_VAT(sb));
-				UDF_SB_TYPEVIRT(sb, i).s_num_entries = (UDF_SB_VAT(sb)->i_size -
-									UDF_SB_TYPEVIRT(sb, i).s_start_offset) >> 2;
+						     udf_ext0_offset(sbi->s_vat_inode))->lengthHeader) +
+					udf_ext0_offset(sbi->s_vat_inode);
+				map->s_type_specific.s_virtual.s_num_entries = (sbi->s_vat_inode->i_size -
+									map->s_type_specific.s_virtual.s_start_offset) >> 2;
 				brelse(bh);
 			}
-			UDF_SB_PARTROOT(sb, i) = udf_get_pblock(sb, 0, i, 0);
-			UDF_SB_PARTLEN(sb, i) = UDF_SB_PARTLEN(sb, ino.partitionReferenceNum);
+			map->s_partition_root = udf_get_pblock(sb, 0, i, 0);
+			map->s_partition_len =
+				sbi->s_partmaps[ino.partitionReferenceNum].
+								s_partition_len;
 		}
 	}
 	return 0;
@@ -1377,26 +1412,30 @@ static int udf_load_partition(struct sup
 
 static void udf_open_lvid(struct super_block *sb)
 {
-	if (UDF_SB_LVIDBH(sb)) {
+	struct udf_sb_info *sbi = UDF_SB(sb);
+	struct buffer_head *bh = sbi->s_lvid_bh;
+	if (bh) {
 		int i;
 		kernel_timestamp cpu_time;
+		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)bh->b_data;
+		struct logicalVolIntegrityDescImpUse *lvidiu = udf_sb_lvidiu(sbi);
 
-		UDF_SB_LVIDIU(sb)->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
-		UDF_SB_LVIDIU(sb)->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
+		lvidiu->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
+		lvidiu->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
 		if (udf_time_to_stamp(&cpu_time, CURRENT_TIME))
-			UDF_SB_LVID(sb)->recordingDateAndTime = cpu_to_lets(cpu_time);
-		UDF_SB_LVID(sb)->integrityType = LVID_INTEGRITY_TYPE_OPEN;
+			lvid->recordingDateAndTime = cpu_to_lets(cpu_time);
+		lvid->integrityType = LVID_INTEGRITY_TYPE_OPEN;
 
-		UDF_SB_LVID(sb)->descTag.descCRC = cpu_to_le16(udf_crc((char *)UDF_SB_LVID(sb) + sizeof(tag),
-								       le16_to_cpu(UDF_SB_LVID(sb)->descTag.descCRCLength), 0));
+		lvid->descTag.descCRC = cpu_to_le16(udf_crc((char *)lvid + sizeof(tag),
+								       le16_to_cpu(lvid->descTag.descCRCLength), 0));
 
-		UDF_SB_LVID(sb)->descTag.tagChecksum = 0;
+		lvid->descTag.tagChecksum = 0;
 		for (i = 0; i < 16; i++)
 			if (i != 4)
-				UDF_SB_LVID(sb)->descTag.tagChecksum +=
-					((uint8_t *) &(UDF_SB_LVID(sb)->descTag))[i];
+				lvid->descTag.tagChecksum +=
+					((uint8_t *) &(lvid->descTag))[i];
 
-		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
+		mark_buffer_dirty(bh);
 	}
 }
 
@@ -1404,32 +1443,40 @@ static void udf_close_lvid(struct super_
 {
 	kernel_timestamp cpu_time;
 	int i;
-
-	if (UDF_SB_LVIDBH(sb) &&
-	    UDF_SB_LVID(sb)->integrityType == LVID_INTEGRITY_TYPE_OPEN) {
-		UDF_SB_LVIDIU(sb)->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
-		UDF_SB_LVIDIU(sb)->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
+	struct udf_sb_info *sbi = UDF_SB(sb);
+	struct buffer_head *bh = sbi->s_lvid_bh;
+	struct logicalVolIntegrityDesc *lvid;
+
+	if (!bh)
+		return;
+
+	lvid = (struct logicalVolIntegrityDesc *)bh->b_data;
+
+	if (lvid->integrityType == LVID_INTEGRITY_TYPE_OPEN) {
+		struct logicalVolIntegrityDescImpUse *lvidiu = udf_sb_lvidiu(sbi);
+		lvidiu->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
+		lvidiu->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
 		if (udf_time_to_stamp(&cpu_time, CURRENT_TIME))
-			UDF_SB_LVID(sb)->recordingDateAndTime = cpu_to_lets(cpu_time);
-		if (UDF_MAX_WRITE_VERSION > le16_to_cpu(UDF_SB_LVIDIU(sb)->maxUDFWriteRev))
-			UDF_SB_LVIDIU(sb)->maxUDFWriteRev = cpu_to_le16(UDF_MAX_WRITE_VERSION);
-		if (UDF_SB_UDFREV(sb) > le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFReadRev))
-			UDF_SB_LVIDIU(sb)->minUDFReadRev = cpu_to_le16(UDF_SB_UDFREV(sb));
-		if (UDF_SB_UDFREV(sb) > le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFWriteRev))
-			UDF_SB_LVIDIU(sb)->minUDFWriteRev = cpu_to_le16(UDF_SB_UDFREV(sb));
-		UDF_SB_LVID(sb)->integrityType = cpu_to_le32(LVID_INTEGRITY_TYPE_CLOSE);
-
-		UDF_SB_LVID(sb)->descTag.descCRC =
-			cpu_to_le16(udf_crc((char *)UDF_SB_LVID(sb) + sizeof(tag),
-					    le16_to_cpu(UDF_SB_LVID(sb)->descTag.descCRCLength), 0));
+			lvid->recordingDateAndTime = cpu_to_lets(cpu_time);
+		if (UDF_MAX_WRITE_VERSION > le16_to_cpu(lvidiu->maxUDFWriteRev))
+			lvidiu->maxUDFWriteRev = cpu_to_le16(UDF_MAX_WRITE_VERSION);
+		if (sbi->s_udfrev > le16_to_cpu(lvidiu->minUDFReadRev))
+			lvidiu->minUDFReadRev = cpu_to_le16(sbi->s_udfrev);
+		if (sbi->s_udfrev > le16_to_cpu(lvidiu->minUDFWriteRev))
+			lvidiu->minUDFWriteRev = cpu_to_le16(sbi->s_udfrev);
+		lvid->integrityType = cpu_to_le32(LVID_INTEGRITY_TYPE_CLOSE);
+
+		lvid->descTag.descCRC =
+			cpu_to_le16(udf_crc((char *)lvid + sizeof(tag),
+					    le16_to_cpu(lvid->descTag.descCRCLength), 0));
 
-		UDF_SB_LVID(sb)->descTag.tagChecksum = 0;
+		lvid->descTag.tagChecksum = 0;
 		for (i = 0; i < 16; i++)
 			if (i != 4)
-				UDF_SB_LVID(sb)->descTag.tagChecksum +=
-					((uint8_t *)&(UDF_SB_LVID(sb)->descTag))[i];
+				lvid->descTag.tagChecksum +=
+					((uint8_t *)&(lvid->descTag))[i];
 
-		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
+		mark_buffer_dirty(bh);
 	}
 }
 
@@ -1462,12 +1509,11 @@ static int udf_fill_super(struct super_b
 	uopt.gid = -1;
 	uopt.umask = 0;
 
-	sbi = kmalloc(sizeof(struct udf_sb_info), GFP_KERNEL);
+	sbi = kzalloc(sizeof(struct udf_sb_info), GFP_KERNEL);
 	if (!sbi)
 		return -ENOMEM;
 
 	sb->s_fs_info = sbi;
-	memset(UDF_SB(sb), 0x00, sizeof(struct udf_sb_info));
 
 	mutex_init(&sbi->s_alloc_mutex);
 
@@ -1495,27 +1541,27 @@ static int udf_fill_super(struct super_b
 	fileset.logicalBlockNum = 0xFFFFFFFF;
 	fileset.partitionReferenceNum = 0xFFFF;
 
-	UDF_SB(sb)->s_flags = uopt.flags;
-	UDF_SB(sb)->s_uid = uopt.uid;
-	UDF_SB(sb)->s_gid = uopt.gid;
-	UDF_SB(sb)->s_umask = uopt.umask;
-	UDF_SB(sb)->s_nls_map = uopt.nls_map;
+	sbi->s_flags = uopt.flags;
+	sbi->s_uid = uopt.uid;
+	sbi->s_gid = uopt.gid;
+	sbi->s_umask = uopt.umask;
+	sbi->s_nls_map = uopt.nls_map;
 
 	/* Set the block size for all transfers */
 	if (!udf_set_blocksize(sb, uopt.blocksize))
 		goto error_out;
 
 	if (uopt.session == 0xFFFFFFFF)
-		UDF_SB_SESSION(sb) = udf_get_last_session(sb);
+		sbi->s_session = udf_get_last_session(sb);
 	else
-		UDF_SB_SESSION(sb) = uopt.session;
+		sbi->s_session = uopt.session;
 
-	udf_debug("Multi-session=%d\n", UDF_SB_SESSION(sb));
+	udf_debug("Multi-session=%d\n", sbi->s_session);
 
-	UDF_SB_LASTBLOCK(sb) = uopt.lastblock;
-	UDF_SB_ANCHOR(sb)[0] = UDF_SB_ANCHOR(sb)[1] = 0;
-	UDF_SB_ANCHOR(sb)[2] = uopt.anchor;
-	UDF_SB_ANCHOR(sb)[3] = 256;
+	sbi->s_last_block = uopt.lastblock;
+	sbi->s_anchor[0] = sbi->s_anchor[1] = 0;
+	sbi->s_anchor[2] = uopt.anchor;
+	sbi->s_anchor[3] = 256;
 
 	if (udf_check_valid(sb, uopt.novrs, silent)) {
 		/* read volume recognition sequences */
@@ -1537,23 +1583,24 @@ static int udf_fill_super(struct super_b
 		goto error_out;
 	}
 
-	udf_debug("Lastblock=%d\n", UDF_SB_LASTBLOCK(sb));
+	udf_debug("Lastblock=%d\n", sbi->s_last_block);
 
-	if (UDF_SB_LVIDBH(sb)) {
-		uint16_t minUDFReadRev = le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFReadRev);
-		uint16_t minUDFWriteRev = le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFWriteRev);
-		/* uint16_t maxUDFWriteRev = le16_to_cpu(UDF_SB_LVIDIU(sb)->maxUDFWriteRev); */
+	if (sbi->s_lvid_bh) {
+		struct logicalVolIntegrityDescImpUse *lvidiu = udf_sb_lvidiu(sbi);
+		uint16_t minUDFReadRev = le16_to_cpu(lvidiu->minUDFReadRev);
+		uint16_t minUDFWriteRev = le16_to_cpu(lvidiu->minUDFWriteRev);
+		/* uint16_t maxUDFWriteRev = le16_to_cpu(lvidiu->maxUDFWriteRev); */
 
 		if (minUDFReadRev > UDF_MAX_READ_VERSION) {
 			printk(KERN_ERR "UDF-fs: minUDFReadRev=%x (max is %x)\n",
-			       le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFReadRev),
+			       le16_to_cpu(lvidiu->minUDFReadRev),
 			       UDF_MAX_READ_VERSION);
 			goto error_out;
 		} else if (minUDFWriteRev > UDF_MAX_WRITE_VERSION) {
 			sb->s_flags |= MS_RDONLY;
 		}
 
-		UDF_SB_UDFREV(sb) = minUDFWriteRev;
+		sbi->s_udfrev = minUDFWriteRev;
 
 		if (minUDFReadRev >= UDF_VERS_USE_EXTENDED_FE)
 			UDF_SET_FLAG(sb, UDF_FLAG_USE_EXTENDED_FE);
@@ -1561,12 +1608,12 @@ static int udf_fill_super(struct super_b
 			UDF_SET_FLAG(sb, UDF_FLAG_USE_STREAMS);
 	}
 
-	if (!UDF_SB_NUMPARTS(sb)) {
+	if (!sbi->s_partitions) {
 		printk(KERN_WARNING "UDF-fs: No partition found (2)\n");
 		goto error_out;
 	}
 
-	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_READ_ONLY) {
+	if (sbi->s_partmaps[sbi->s_partition].s_partition_flags & UDF_PART_FLAG_READ_ONLY) {
 		printk(KERN_NOTICE "UDF-fs: Partition marked readonly; forcing readonly mount\n");
 		sb->s_flags |= MS_RDONLY;
 	}
@@ -1578,12 +1625,12 @@ static int udf_fill_super(struct super_b
 
 	if (!silent) {
 		kernel_timestamp ts;
-		udf_time_to_stamp(&ts, UDF_SB_RECORDTIME(sb));
+		udf_time_to_stamp(&ts, sbi->s_record_time);
 		udf_info("UDF %s (%s) Mounting volume '%s', "
 			 "timestamp %04u/%02u/%02u %02u:%02u (%x)\n",
 			 UDFFS_VERSION, UDFFS_DATE,
-			 UDF_SB_VOLIDENT(sb), ts.year, ts.month, ts.day, ts.hour, ts.minute,
-			 ts.typeAndTimezone);
+			 sbi->s_volume_ident, ts.year, ts.month, ts.day,
+			 ts.hour, ts.minute, ts.typeAndTimezone);
 	}
 	if (!(sb->s_flags & MS_RDONLY))
 		udf_open_lvid(sb);
@@ -1609,30 +1656,31 @@ static int udf_fill_super(struct super_b
 	return 0;
 
 error_out:
-	if (UDF_SB_VAT(sb))
-		iput(UDF_SB_VAT(sb));
-	if (UDF_SB_NUMPARTS(sb)) {
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_TABLE)
-			iput(UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_table);
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_TABLE)
-			iput(UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_table);
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_BITMAP)
-			UDF_SB_FREE_BITMAP(sb, UDF_SB_PARTITION(sb), s_uspace);
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP)
-			UDF_SB_FREE_BITMAP(sb, UDF_SB_PARTITION(sb), s_fspace);
-		if (UDF_SB_PARTTYPE(sb, UDF_SB_PARTITION(sb)) == UDF_SPARABLE_MAP15) {
+	if (sbi->s_vat_inode)
+		iput(sbi->s_vat_inode);
+	if (sbi->s_partitions) {
+		struct udf_part_map *map = &sbi->s_partmaps[sbi->s_partition];
+		if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_TABLE)
+			iput(map->s_uspace.s_table);
+		if (map->s_partition_flags & UDF_PART_FLAG_FREED_TABLE)
+			iput(map->s_fspace.s_table);
+		if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP)
+			UDF_SB_FREE_BITMAP(sb, sbi->s_partition, s_uspace);
+		if (map->s_partition_flags & UDF_PART_FLAG_FREED_BITMAP)
+			UDF_SB_FREE_BITMAP(sb, sbi->s_partition, s_fspace);
+		if (map->s_partition_type == UDF_SPARABLE_MAP15)
 			for (i = 0; i < 4; i++)
-				brelse(UDF_SB_TYPESPAR(sb, UDF_SB_PARTITION(sb)).s_spar_map[i]);
-		}
+				brelse(map->s_type_specific.s_sparing.s_spar_map[i]);
 	}
 #ifdef CONFIG_UDF_NLS
 	if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP))
-		unload_nls(UDF_SB(sb)->s_nls_map);
+		unload_nls(sbi->s_nls_map);
 #endif
 	if (!(sb->s_flags & MS_RDONLY))
 		udf_close_lvid(sb);
-	brelse(UDF_SB_LVIDBH(sb));
-	UDF_SB_FREE(sb);
+	brelse(sbi->s_lvid_bh);
+
+	kfree(sbi->s_partmaps);
 	kfree(sbi);
 	sb->s_fs_info = NULL;
 
@@ -1683,31 +1731,33 @@ void udf_warning(struct super_block *sb,
 static void udf_put_super(struct super_block *sb)
 {
 	int i;
+	struct udf_sb_info *sbi;
 
-	if (UDF_SB_VAT(sb))
-		iput(UDF_SB_VAT(sb));
-	if (UDF_SB_NUMPARTS(sb)) {
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_TABLE)
-			iput(UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_table);
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_TABLE)
-			iput(UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_table);
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_BITMAP)
-			UDF_SB_FREE_BITMAP(sb, UDF_SB_PARTITION(sb), s_uspace);
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP)
-			UDF_SB_FREE_BITMAP(sb, UDF_SB_PARTITION(sb), s_fspace);
-		if (UDF_SB_PARTTYPE(sb, UDF_SB_PARTITION(sb)) == UDF_SPARABLE_MAP15) {
+	sbi = UDF_SB(sb);
+	if (sbi->s_vat_inode)
+		iput(sbi->s_vat_inode);
+	if (sbi->s_partitions) {
+		struct udf_part_map *map = &sbi->s_partmaps[sbi->s_partition];
+		if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_TABLE)
+			iput(map->s_uspace.s_table);
+		if (map->s_partition_flags & UDF_PART_FLAG_FREED_TABLE)
+			iput(map->s_fspace.s_table);
+		if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP)
+			UDF_SB_FREE_BITMAP(sb, sbi->s_partition, s_uspace);
+		if (map->s_partition_flags & UDF_PART_FLAG_FREED_BITMAP)
+			UDF_SB_FREE_BITMAP(sb, sbi->s_partition, s_fspace);
+		if (map->s_partition_type == UDF_SPARABLE_MAP15)
 			for (i = 0; i < 4; i++)
-				brelse(UDF_SB_TYPESPAR(sb, UDF_SB_PARTITION(sb)).s_spar_map[i]);
-		}
+				brelse(map->s_type_specific.s_sparing.s_spar_map[i]);
 	}
 #ifdef CONFIG_UDF_NLS
 	if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP))
-		unload_nls(UDF_SB(sb)->s_nls_map);
+		unload_nls(sbi->s_nls_map);
 #endif
 	if (!(sb->s_flags & MS_RDONLY))
 		udf_close_lvid(sb);
-	brelse(UDF_SB_LVIDBH(sb));
-	UDF_SB_FREE(sb);
+	brelse(sbi->s_lvid_bh);
+	kfree(sbi->s_partmaps);
 	kfree(sb->s_fs_info);
 	sb->s_fs_info = NULL;
 }
@@ -1728,15 +1778,22 @@ static void udf_put_super(struct super_b
 static int udf_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
+	struct udf_sb_info *sbi = UDF_SB(sb);
+	struct logicalVolIntegrityDescImpUse *lvidiu;
+
+	if (sbi->s_lvid_bh != NULL)
+		lvidiu = udf_sb_lvidiu(sbi);
+	else
+		lvidiu = NULL;
 
 	buf->f_type = UDF_SUPER_MAGIC;
 	buf->f_bsize = sb->s_blocksize;
-	buf->f_blocks = UDF_SB_PARTLEN(sb, UDF_SB_PARTITION(sb));
+	buf->f_blocks = sbi->s_partmaps[sbi->s_partition].s_partition_len;
 	buf->f_bfree = udf_count_free(sb);
 	buf->f_bavail = buf->f_bfree;
-	buf->f_files = (UDF_SB_LVIDBH(sb) ?
-			(le32_to_cpu(UDF_SB_LVIDIU(sb)->numFiles) +
-			 le32_to_cpu(UDF_SB_LVIDIU(sb)->numDirs)) : 0) + buf->f_bfree;
+	buf->f_files = (lvidiu != NULL ? (le32_to_cpu(lvidiu->numFiles) +
+					  le32_to_cpu(lvidiu->numDirs)) : 0)
+			+ buf->f_bfree;
 	buf->f_ffree = buf->f_bfree;
 	/* __kernel_fsid_t f_fsid */
 	buf->f_namelen = UDF_NAME_LEN - 2;
@@ -1764,7 +1821,7 @@ static unsigned int udf_count_free_bitma
 	lock_kernel();
 
 	loc.logicalBlockNum = bitmap->s_extPosition;
-	loc.partitionReferenceNum = UDF_SB_PARTITION(sb);
+	loc.partitionReferenceNum = UDF_SB(sb)->s_partition;
 	bh = udf_read_ptagged(sb, loc, 0, &ident);
 
 	if (!bh) {
@@ -1836,10 +1893,14 @@ static unsigned int udf_count_free_table
 static unsigned int udf_count_free(struct super_block *sb)
 {
 	unsigned int accum = 0;
+	struct udf_sb_info *sbi;
+	struct udf_part_map *map;
 
-	if (UDF_SB_LVIDBH(sb)) {
-		if (le32_to_cpu(UDF_SB_LVID(sb)->numOfPartitions) > UDF_SB_PARTITION(sb)) {
-			accum = le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[UDF_SB_PARTITION(sb)]);
+	sbi = UDF_SB(sb);
+	if (sbi->s_lvid_bh) {
+		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
+		if (le32_to_cpu(lvid->numOfPartitions) > sbi->s_partition) {
+			accum = le32_to_cpu(lvid->freeSpaceTable[sbi->s_partition]);
 			if (accum == 0xFFFFFFFF)
 				accum = 0;
 		}
@@ -1848,24 +1909,25 @@ static unsigned int udf_count_free(struc
 	if (accum)
 		return accum;
 
-	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_BITMAP) {
+	map = &sbi->s_partmaps[sbi->s_partition];
+	if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP) {
 		accum += udf_count_free_bitmap(sb,
-					       UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_bitmap);
+					       map->s_uspace.s_bitmap);
 	}
-	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP) {
+	if (map->s_partition_flags & UDF_PART_FLAG_FREED_BITMAP) {
 		accum += udf_count_free_bitmap(sb,
-					       UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_bitmap);
+					       map->s_fspace.s_bitmap);
 	}
 	if (accum)
 		return accum;
 
-	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_TABLE) {
+	if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_TABLE) {
 		accum += udf_count_free_table(sb,
-					      UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_table);
+					      map->s_uspace.s_table);
 	}
-	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_TABLE) {
+	if (map->s_partition_flags & UDF_PART_FLAG_FREED_TABLE) {
 		accum += udf_count_free_table(sb,
-					      UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_table);
+					      map->s_fspace.s_table);
 	}
 
 	return accum;
diff -puN fs/udf/truncate.c~udf-remove-some-ugly-macros fs/udf/truncate.c
--- a/fs/udf/truncate.c~udf-remove-some-ugly-macros
+++ a/fs/udf/truncate.c
@@ -163,7 +163,7 @@ void udf_discard_prealloc(struct inode *
 				cpu_to_le32(epos.offset -
 					    sizeof(struct allocExtDesc));
 			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
-			    UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
+			    UDF_SB(inode->i_sb)->s_udfrev >= 0x0201)
 				udf_update_tag(epos.bh->b_data, epos.offset);
 			else
 				udf_update_tag(epos.bh->b_data,
@@ -184,6 +184,7 @@ void udf_truncate_extents(struct inode *
 	uint32_t elen, nelen = 0, indirect_ext_len = 0, lenalloc;
 	int8_t etype;
 	struct super_block *sb = inode->i_sb;
+	struct udf_sb_info *sbi = UDF_SB(sb);
 	sector_t first_block = inode->i_size >> sb->s_blocksize_bits, offset;
 	loff_t byte_offset;
 	int adsize;
@@ -232,7 +233,7 @@ void udf_truncate_extents(struct inode *
 						aed->lengthAllocDescs =
 						    cpu_to_le32(lenalloc);
 						if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT) ||
-						    UDF_SB_UDFREV(sb) >= 0x0201)
+						    sbi->s_udfrev >= 0x0201)
 							udf_update_tag(epos.bh->b_data,
 								       lenalloc +
 								       sizeof(struct allocExtDesc));
@@ -271,7 +272,7 @@ void udf_truncate_extents(struct inode *
 				    (struct allocExtDesc *)(epos.bh->b_data);
 				aed->lengthAllocDescs = cpu_to_le32(lenalloc);
 				if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT) ||
-				    UDF_SB_UDFREV(sb) >= 0x0201)
+				    sbi->s_udfrev >= 0x0201)
 					udf_update_tag(epos.bh->b_data,
 						       lenalloc + sizeof(struct allocExtDesc));
 				else
diff -puN fs/udf/udf_sb.h~udf-remove-some-ugly-macros fs/udf/udf_sb.h
--- a/fs/udf/udf_sb.h~udf-remove-some-ugly-macros
+++ a/fs/udf/udf_sb.h
@@ -41,40 +41,36 @@ static inline struct udf_sb_info *UDF_SB
 	return sb->s_fs_info;
 }
 
-#define UDF_SB_FREE(X)\
-{\
-	if (UDF_SB(X)) {\
-		kfree(UDF_SB_PARTMAPS(X));\
-		UDF_SB_PARTMAPS(X) = NULL;\
-	}\
-}
+struct logicalVolIntegrityDescImpUse *udf_sb_lvidiu(struct udf_sb_info *sbi);
 
 #define UDF_SB_ALLOC_PARTMAPS(X,Y)\
 {\
-	UDF_SB_PARTMAPS(X) = kmalloc(sizeof(struct udf_part_map) * Y, GFP_KERNEL);\
-	if (UDF_SB_PARTMAPS(X) != NULL) {\
-		UDF_SB_NUMPARTS(X) = Y;\
-		memset(UDF_SB_PARTMAPS(X), 0x00, sizeof(struct udf_part_map) * Y);\
+	struct udf_sb_info *sbi = UDF_SB(X);\
+	sbi->s_partmaps = kmalloc(sizeof(struct udf_part_map) * Y, GFP_KERNEL);\
+	if (sbi->s_partmaps != NULL) {\
+		sbi->s_partitions = Y;\
+		memset(sbi->s_partmaps, 0x00, sizeof(struct udf_part_map) * Y);\
 	} else {\
-		UDF_SB_NUMPARTS(X) = 0;\
+		sbi->s_partitions = 0;\
 		udf_error(X, __FUNCTION__, "Unable to allocate space for %d partition maps", Y);\
 	}\
 }
 
 #define UDF_SB_ALLOC_BITMAP(X,Y,Z)\
 {\
-	int nr_groups = ((UDF_SB_PARTLEN((X),(Y)) + (sizeof(struct spaceBitmapDesc) << 3) +\
+	struct udf_sb_info *sbi = UDF_SB(X);\
+	int nr_groups = ((sbi->s_partmaps[(Y)].s_partition_len + (sizeof(struct spaceBitmapDesc) << 3) +\
 		((X)->s_blocksize * 8) - 1) / ((X)->s_blocksize * 8));\
 	int size = sizeof(struct udf_bitmap) + (sizeof(struct buffer_head *) * nr_groups);\
 	if (size <= PAGE_SIZE)\
-		UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap = kmalloc(size, GFP_KERNEL);\
+		sbi->s_partmaps[(Y)].Z.s_bitmap = kmalloc(size, GFP_KERNEL);\
 	else\
-		UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap = vmalloc(size);\
-	if (UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap != NULL) {\
-		memset(UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap, 0x00, size);\
-		UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap->s_block_bitmap =\
-			(struct buffer_head **)(UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap + 1);\
-		UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap->s_nr_groups = nr_groups;\
+		sbi->s_partmaps[(Y)].Z.s_bitmap = vmalloc(size);\
+	if (sbi->s_partmaps[(Y)].Z.s_bitmap != NULL) {\
+		memset(sbi->s_partmaps[(Y)].Z.s_bitmap, 0x00, size);\
+		sbi->s_partmaps[(Y)].Z.s_bitmap->s_block_bitmap =\
+			(struct buffer_head **)(sbi->s_partmaps[(Y)].Z.s_bitmap + 1);\
+		sbi->s_partmaps[(Y)].Z.s_bitmap->s_nr_groups = nr_groups;\
 	} else {\
 		udf_error(X, __FUNCTION__, "Unable to allocate space for bitmap and %d buffer_head pointers", nr_groups);\
 	}\
@@ -90,47 +86,16 @@ static inline struct udf_sb_info *UDF_SB
 			brelse(UDF_SB_BITMAP(X,Y,Z,i));\
 	}\
 	if (size <= PAGE_SIZE)\
-		kfree(UDF_SB_PARTMAPS(X)[Y].Z.s_bitmap);\
+		kfree(UDF_SB(X)->s_partmaps[Y].Z.s_bitmap);\
 	else\
-		vfree(UDF_SB_PARTMAPS(X)[Y].Z.s_bitmap);\
+		vfree(UDF_SB(X)->s_partmaps[Y].Z.s_bitmap);\
 }
 
 #define UDF_QUERY_FLAG(X,Y)			( UDF_SB(X)->s_flags & ( 1 << (Y) ) )
 #define UDF_SET_FLAG(X,Y)			( UDF_SB(X)->s_flags |= ( 1 << (Y) ) )
 #define UDF_CLEAR_FLAG(X,Y)			( UDF_SB(X)->s_flags &= ~( 1 << (Y) ) )
 
-#define UDF_UPDATE_UDFREV(X,Y)			( ((Y) > UDF_SB_UDFREV(X)) ? UDF_SB_UDFREV(X) = (Y) : UDF_SB_UDFREV(X) )
-
-#define UDF_SB_PARTMAPS(X)			( UDF_SB(X)->s_partmaps )
-#define UDF_SB_PARTTYPE(X,Y)			( UDF_SB_PARTMAPS(X)[(Y)].s_partition_type )
-#define UDF_SB_PARTROOT(X,Y)			( UDF_SB_PARTMAPS(X)[(Y)].s_partition_root )
-#define UDF_SB_PARTLEN(X,Y)			( UDF_SB_PARTMAPS(X)[(Y)].s_partition_len )
-#define UDF_SB_PARTVSN(X,Y)			( UDF_SB_PARTMAPS(X)[(Y)].s_volumeseqnum )
-#define UDF_SB_PARTNUM(X,Y)			( UDF_SB_PARTMAPS(X)[(Y)].s_partition_num )
-#define UDF_SB_TYPESPAR(X,Y)			( UDF_SB_PARTMAPS(X)[(Y)].s_type_specific.s_sparing )
-#define UDF_SB_TYPEVIRT(X,Y)			( UDF_SB_PARTMAPS(X)[(Y)].s_type_specific.s_virtual )
-#define UDF_SB_PARTFUNC(X,Y)			( UDF_SB_PARTMAPS(X)[(Y)].s_partition_func )
-#define UDF_SB_PARTFLAGS(X,Y)			( UDF_SB_PARTMAPS(X)[(Y)].s_partition_flags )
-#define UDF_SB_BITMAP(X,Y,Z,I)			( UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap->s_block_bitmap[I] )
-#define UDF_SB_BITMAP_NR_GROUPS(X,Y,Z)		( UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap->s_nr_groups )
-
-#define UDF_SB_VOLIDENT(X)			( UDF_SB(X)->s_volident )
-#define UDF_SB_NUMPARTS(X)			( UDF_SB(X)->s_partitions )
-#define UDF_SB_PARTITION(X)			( UDF_SB(X)->s_partition )
-#define UDF_SB_SESSION(X)			( UDF_SB(X)->s_session )
-#define UDF_SB_ANCHOR(X)			( UDF_SB(X)->s_anchor )
-#define UDF_SB_LASTBLOCK(X)			( UDF_SB(X)->s_lastblock )
-#define UDF_SB_LVIDBH(X)			( UDF_SB(X)->s_lvidbh )
-#define UDF_SB_LVID(X)				( (struct logicalVolIntegrityDesc *)UDF_SB_LVIDBH(X)->b_data )
-#define UDF_SB_LVIDIU(X)			( (struct logicalVolIntegrityDescImpUse *)&(UDF_SB_LVID(X)->impUse[le32_to_cpu(UDF_SB_LVID(X)->numOfPartitions) * 2 * sizeof(uint32_t)/sizeof(uint8_t)]) )
-
-#define UDF_SB_UMASK(X)				( UDF_SB(X)->s_umask )
-#define UDF_SB_GID(X)				( UDF_SB(X)->s_gid )
-#define UDF_SB_UID(X)				( UDF_SB(X)->s_uid )
-#define UDF_SB_RECORDTIME(X)			( UDF_SB(X)->s_recordtime )
-#define UDF_SB_SERIALNUM(X)			( UDF_SB(X)->s_serialnum )
-#define UDF_SB_UDFREV(X)			( UDF_SB(X)->s_udfrev )
-#define UDF_SB_FLAGS(X)				( UDF_SB(X)->s_flags )
-#define UDF_SB_VAT(X)				( UDF_SB(X)->s_vat )
+#define UDF_SB_BITMAP(X,Y,Z,I)			( UDF_SB(X)->s_partmaps[(Y)].Z.s_bitmap->s_block_bitmap[I] )
+#define UDF_SB_BITMAP_NR_GROUPS(X,Y,Z)		( UDF_SB(X)->s_partmaps[(Y)].Z.s_bitmap->s_nr_groups )
 
 #endif /* __LINUX_UDF_SB_H */
diff -puN include/linux/udf_fs_sb.h~udf-remove-some-ugly-macros include/linux/udf_fs_sb.h
--- a/include/linux/udf_fs_sb.h~udf-remove-some-ugly-macros
+++ a/include/linux/udf_fs_sb.h
@@ -75,7 +75,7 @@ struct udf_part_map
 struct udf_sb_info
 {
 	struct udf_part_map	*s_partmaps;
-	__u8			s_volident[32];
+	__u8			s_volume_ident[32];
 
 	/* Overall info */
 	__u16			s_partitions;
@@ -84,9 +84,9 @@ struct udf_sb_info
 	/* Sector headers */
 	__s32			s_session;
 	__u32			s_anchor[4];
-	__u32			s_lastblock;
+	__u32			s_last_block;
 
-	struct buffer_head	*s_lvidbh;
+	struct buffer_head	*s_lvid_bh;
 
 	/* Default permissions */
 	mode_t			s_umask;
@@ -94,10 +94,10 @@ struct udf_sb_info
 	uid_t			s_uid;
 
 	/* Root Info */
-	struct timespec		s_recordtime;
+	struct timespec		s_record_time;
 
 	/* Fileset Info */
-	__u16			s_serialnum;
+	__u16			s_serial_number;
 
 	/* highest UDF revision we have recorded to this media */
 	__u16			s_udfrev;
@@ -109,7 +109,7 @@ struct udf_sb_info
 	struct nls_table	*s_nls_map;
 
 	/* VAT inode */
-	struct inode		*s_vat;
+	struct inode		*s_vat_inode;
 
 	struct mutex		s_alloc_mutex;
 };
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
