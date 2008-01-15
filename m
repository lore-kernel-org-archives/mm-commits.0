From: akpm@linux-foundation.org
Subject: + udf-fix-coding-style.patch added to -mm tree
Date: Tue, 15 Jan 2008 02:46:42 -0800
Message-ID: <200801151046.m0FAkMYs011663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51300 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751232AbYAOKqx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 05:46:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, hch@lst.de, jack@suse.cz


The patch titled
     udf: fix coding style
has been added to the -mm tree.  Its filename is
     udf-fix-coding-style.patch

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
Subject: udf: fix coding style
From: Marcin Slusarz <marcin.slusarz@gmail.com>

fix coding style errors found by checkpatch:
- assignments in if conditions
- braces {} around single statement blocks
- no spaces after commas
- printks without KERN_*
- lines longer than 80 characters
- spaces between "type *" and variable name

before: 192 errors, 561 warnings, 8987 lines checked
after: 1 errors, 38 warnings, 9468 lines checked

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/balloc.c    |  231 ++++++++------
 fs/udf/crc.c       |    2 
 fs/udf/directory.c |   80 +++--
 fs/udf/file.c      |   18 -
 fs/udf/ialloc.c    |   24 +
 fs/udf/inode.c     |  667 +++++++++++++++++++++++++------------------
 fs/udf/misc.c      |   76 ++--
 fs/udf/namei.c     |  298 +++++++++++--------
 fs/udf/partition.c |  160 ++++++----
 fs/udf/super.c     |  377 +++++++++++++++---------
 fs/udf/symlink.c   |    3 
 fs/udf/truncate.c  |   58 ++-
 fs/udf/udftime.c   |   57 +--
 fs/udf/unicode.c   |   85 ++---
 14 files changed, 1306 insertions(+), 830 deletions(-)

diff -puN fs/udf/balloc.c~udf-fix-coding-style fs/udf/balloc.c
--- a/fs/udf/balloc.c~udf-fix-coding-style
+++ a/fs/udf/balloc.c
@@ -28,15 +28,16 @@
 #include "udf_i.h"
 #include "udf_sb.h"
 
-#define udf_clear_bit(nr,addr) ext2_clear_bit(nr,addr)
-#define udf_set_bit(nr,addr) ext2_set_bit(nr,addr)
+#define udf_clear_bit(nr, addr) ext2_clear_bit(nr, addr)
+#define udf_set_bit(nr, addr) ext2_set_bit(nr, addr)
 #define udf_test_bit(nr, addr) ext2_test_bit(nr, addr)
 #define udf_find_first_one_bit(addr, size) find_first_one_bit(addr, size)
-#define udf_find_next_one_bit(addr, size, offset) find_next_one_bit(addr, size, offset)
+#define udf_find_next_one_bit(addr, size, offset) \
+		find_next_one_bit(addr, size, offset)
 
 #define leBPL_to_cpup(x) leNUM_to_cpup(BITS_PER_LONG, x)
-#define leNUM_to_cpup(x,y) xleNUM_to_cpup(x,y)
-#define xleNUM_to_cpup(x,y) (le ## x ## _to_cpup(y))
+#define leNUM_to_cpup(x, y) xleNUM_to_cpup(x, y)
+#define xleNUM_to_cpup(x, y) (le ## x ## _to_cpup(y))
 #define uintBPL_t uint(BITS_PER_LONG)
 #define uint(x) xuint(x)
 #define xuint(x) __le ## x
@@ -62,7 +63,8 @@ static inline int find_next_one_bit(void
 		result += BITS_PER_LONG;
 	}
 	while (size & ~(BITS_PER_LONG - 1)) {
-		if ((tmp = leBPL_to_cpup(p++)))
+		tmp = leBPL_to_cpup(p++);
+		if (tmp)
 			goto found_middle;
 		result += BITS_PER_LONG;
 		size -= BITS_PER_LONG;
@@ -91,9 +93,9 @@ static int read_block_bitmap(struct supe
 	loc.partitionReferenceNum = UDF_SB(sb)->s_partition;
 
 	bh = udf_tread(sb, udf_get_lb_pblock(sb, loc, block));
-	if (!bh) {
+	if (!bh)
 		retval = -EIO;
-	}
+
 	bitmap->s_block_bitmap[bitmap_nr] = bh;
 	return retval;
 }
@@ -155,14 +157,17 @@ static void udf_bitmap_free_blocks(struc
 
 	mutex_lock(&sbi->s_alloc_mutex);
 	if (bloc.logicalBlockNum < 0 ||
-	    (bloc.logicalBlockNum + count) > sbi->s_partmaps[bloc.partitionReferenceNum].s_partition_len) {
+	    (bloc.logicalBlockNum + count) >
+		sbi->s_partmaps[bloc.partitionReferenceNum].s_partition_len) {
 		udf_debug("%d < %d || %d + %d > %d\n",
 			  bloc.logicalBlockNum, 0, bloc.logicalBlockNum, count,
-			  sbi->s_partmaps[bloc.partitionReferenceNum].s_partition_len);
+			  sbi->s_partmaps[bloc.partitionReferenceNum].
+							s_partition_len);
 		goto error_return;
 	}
 
-	block = bloc.logicalBlockNum + offset + (sizeof(struct spaceBitmapDesc) << 3);
+	block = bloc.logicalBlockNum + offset +
+		(sizeof(struct spaceBitmapDesc) << 3);
 
 do_more:
 	overflow = 0;
@@ -184,7 +189,8 @@ do_more:
 	for (i = 0; i < count; i++) {
 		if (udf_set_bit(bit + i, bh->b_data)) {
 			udf_debug("bit %ld already set\n", bit + i);
-			udf_debug("byte=%2x\n", ((char *)bh->b_data)[(bit + i) >> 3]);
+			udf_debug("byte=%2x\n",
+				  ((char *)bh->b_data)[(bit + i) >> 3]);
 		} else {
 			if (inode)
 				DQUOT_FREE_BLOCK(inode, 1);
@@ -314,14 +320,16 @@ repeat:
 		if (bit < end_goal)
 			goto got_block;
 
-		ptr = memscan((char *)bh->b_data + (bit >> 3), 0xFF, sb->s_blocksize - ((bit + 7) >> 3));
+		ptr = memscan((char *)bh->b_data + (bit >> 3), 0xFF,
+			      sb->s_blocksize - ((bit + 7) >> 3));
 		newbit = (ptr - ((char *)bh->b_data)) << 3;
 		if (newbit < sb->s_blocksize << 3) {
 			bit = newbit;
 			goto search_back;
 		}
 
-		newbit = udf_find_next_one_bit(bh->b_data, sb->s_blocksize << 3, bit);
+		newbit = udf_find_next_one_bit(bh->b_data,
+					       sb->s_blocksize << 3, bit);
 		if (newbit < sb->s_blocksize << 3) {
 			bit = newbit;
 			goto got_block;
@@ -360,15 +368,20 @@ repeat:
 	if (bit < sb->s_blocksize << 3)
 		goto search_back;
 	else
-		bit = udf_find_next_one_bit(bh->b_data, sb->s_blocksize << 3, group_start << 3);
+		bit = udf_find_next_one_bit(bh->b_data, sb->s_blocksize << 3,
+					    group_start << 3);
 	if (bit >= sb->s_blocksize << 3) {
 		mutex_unlock(&sbi->s_alloc_mutex);
 		return 0;
 	}
 
 search_back:
-	for (i = 0; i < 7 && bit > (group_start << 3) && udf_test_bit(bit - 1, bh->b_data); i++, bit--)
-		; /* empty loop */
+	i = 0;
+	while (i < 7 && bit > (group_start << 3) &&
+	       udf_test_bit(bit - 1, bh->b_data)) {
+		++i;
+		--bit;
+	}
 
 got_block:
 
@@ -424,15 +437,17 @@ static void udf_table_free_blocks(struct
 
 	mutex_lock(&sbi->s_alloc_mutex);
 	if (bloc.logicalBlockNum < 0 ||
-	    (bloc.logicalBlockNum + count) > sbi->s_partmaps[bloc.partitionReferenceNum].s_partition_len) {
+	    (bloc.logicalBlockNum + count) >
+		sbi->s_partmaps[bloc.partitionReferenceNum].s_partition_len) {
 		udf_debug("%d < %d || %d + %d > %d\n",
 			  bloc.logicalBlockNum, 0, bloc.logicalBlockNum, count,
-			  sbi->s_partmaps[bloc.partitionReferenceNum]->s_partition_len);
+			  sbi->s_partmaps[bloc.partitionReferenceNum].
+							s_partition_len);
 		goto error_return;
 	}
 
-	/* We do this up front - There are some error conditions that could occure,
-	   but.. oh well */
+	/* We do this up front - There are some error conditions that
+	   could occure, but.. oh well */
 	if (inode)
 		DQUOT_FREE_BLOCK(inode, count);
 	if (sbi->s_lvid_bh) {
@@ -452,26 +467,39 @@ static void udf_table_free_blocks(struct
 
 	while (count &&
 	       (etype = udf_next_aext(table, &epos, &eloc, &elen, 1)) != -1) {
-		if (((eloc.logicalBlockNum + (elen >> sb->s_blocksize_bits)) == start)) {
-			if ((0x3FFFFFFF - elen) < (count << sb->s_blocksize_bits)) {
-				count -= ((0x3FFFFFFF - elen) >> sb->s_blocksize_bits);
-				start += ((0x3FFFFFFF - elen) >> sb->s_blocksize_bits);
-				elen = (etype << 30) | (0x40000000 - sb->s_blocksize);
+		if (((eloc.logicalBlockNum +
+			(elen >> sb->s_blocksize_bits)) == start)) {
+			if ((0x3FFFFFFF - elen) <
+					(count << sb->s_blocksize_bits)) {
+				uint32_t tmp = ((0x3FFFFFFF - elen) >>
+							sb->s_blocksize_bits);
+				count -= tmp;
+				start += tmp;
+				elen = (etype << 30) |
+					(0x40000000 - sb->s_blocksize);
 			} else {
-				elen = (etype << 30) | (elen + (count << sb->s_blocksize_bits));
+				elen = (etype << 30) |
+					(elen +
+					(count << sb->s_blocksize_bits));
 				start += count;
 				count = 0;
 			}
 			udf_write_aext(table, &oepos, eloc, elen, 1);
 		} else if (eloc.logicalBlockNum == (end + 1)) {
-			if ((0x3FFFFFFF - elen) < (count << sb->s_blocksize_bits)) {
-				count -= ((0x3FFFFFFF - elen) >> sb->s_blocksize_bits);
-				end -= ((0x3FFFFFFF - elen) >> sb->s_blocksize_bits);
-				eloc.logicalBlockNum -= ((0x3FFFFFFF - elen) >> sb->s_blocksize_bits);
-				elen = (etype << 30) | (0x40000000 - sb->s_blocksize);
+			if ((0x3FFFFFFF - elen) <
+					(count << sb->s_blocksize_bits)) {
+				uint32_t tmp = ((0x3FFFFFFF - elen) >>
+						sb->s_blocksize_bits);
+				count -= tmp;
+				end -= tmp;
+				eloc.logicalBlockNum -= tmp;
+				elen = (etype << 30) |
+					(0x40000000 - sb->s_blocksize);
 			} else {
 				eloc.logicalBlockNum = start;
-				elen = (etype << 30) | (elen + (count << sb->s_blocksize_bits));
+				elen = (etype << 30) |
+					(elen +
+					(count << sb->s_blocksize_bits));
 				end -= count;
 				count = 0;
 			}
@@ -492,9 +520,9 @@ static void udf_table_free_blocks(struct
 
 	if (count) {
 		/*
-		 * NOTE: we CANNOT use udf_add_aext here, as it can try to allocate
-		 * a new block, and since we hold the super block lock already
-		 * very bad things would happen :)
+		 * NOTE: we CANNOT use udf_add_aext here, as it can try to
+		 * allocate a new block, and since we hold the super block
+		 * lock already very bad things would happen :)
 		 *
 		 * We copy the behavior of udf_add_aext, but instead of
 		 * trying to allocate a new block close to the existing one,
@@ -535,27 +563,35 @@ static void udf_table_free_blocks(struct
 			eloc.logicalBlockNum++;
 			elen -= sb->s_blocksize;
 
-			if (!(epos.bh = udf_tread(sb, udf_get_lb_pblock(sb, epos.block, 0)))) {
+			epos.bh = udf_tread(sb,
+					udf_get_lb_pblock(sb, epos.block, 0));
+			if (!epos.bh) {
 				brelse(oepos.bh);
 				goto error_return;
 			}
 			aed = (struct allocExtDesc *)(epos.bh->b_data);
-			aed->previousAllocExtLocation = cpu_to_le32(oepos.block.logicalBlockNum);
+			aed->previousAllocExtLocation =
+				cpu_to_le32(oepos.block.logicalBlockNum);
 			if (epos.offset + adsize > sb->s_blocksize) {
 				loffset = epos.offset;
 				aed->lengthAllocDescs = cpu_to_le32(adsize);
 				sptr = UDF_I_DATA(table) + epos.offset - adsize;
-				dptr = epos.bh->b_data + sizeof(struct allocExtDesc);
+				dptr = epos.bh->b_data +
+					sizeof(struct allocExtDesc);
 				memcpy(dptr, sptr, adsize);
-				epos.offset = sizeof(struct allocExtDesc) + adsize;
+				epos.offset = sizeof(struct allocExtDesc) +
+						adsize;
 			} else {
 				loffset = epos.offset + adsize;
 				aed->lengthAllocDescs = cpu_to_le32(0);
 				if (oepos.bh) {
 					sptr = oepos.bh->b_data + epos.offset;
-					aed = (struct allocExtDesc *)oepos.bh->b_data;
+					aed = (struct allocExtDesc *)
+						oepos.bh->b_data;
 					aed->lengthAllocDescs =
-						cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) + adsize);
+						cpu_to_le32(le32_to_cpu(
+							aed->lengthAllocDescs) +
+								adsize);
 				} else {
 					sptr = UDF_I_DATA(table) + epos.offset;
 					UDF_I_LENALLOC(table) += adsize;
@@ -564,27 +600,31 @@ static void udf_table_free_blocks(struct
 				epos.offset = sizeof(struct allocExtDesc);
 			}
 			if (sbi->s_udfrev >= 0x0200)
-				udf_new_tag(epos.bh->b_data, TAG_IDENT_AED, 3, 1,
-					    epos.block.logicalBlockNum, sizeof(tag));
+				udf_new_tag(epos.bh->b_data, TAG_IDENT_AED,
+					    3, 1, epos.block.logicalBlockNum,
+					    sizeof(tag));
 			else
-				udf_new_tag(epos.bh->b_data, TAG_IDENT_AED, 2, 1,
-					    epos.block.logicalBlockNum, sizeof(tag));
+				udf_new_tag(epos.bh->b_data, TAG_IDENT_AED,
+					    2, 1, epos.block.logicalBlockNum,
+					    sizeof(tag));
 
 			switch (UDF_I_ALLOCTYPE(table)) {
-				case ICBTAG_FLAG_AD_SHORT:
-					sad = (short_ad *)sptr;
-					sad->extLength = cpu_to_le32(
-						EXT_NEXT_EXTENT_ALLOCDECS |
-						sb->s_blocksize);
-					sad->extPosition = cpu_to_le32(epos.block.logicalBlockNum);
-					break;
-				case ICBTAG_FLAG_AD_LONG:
-					lad = (long_ad *)sptr;
-					lad->extLength = cpu_to_le32(
-						EXT_NEXT_EXTENT_ALLOCDECS |
-						sb->s_blocksize);
-					lad->extLocation = cpu_to_lelb(epos.block);
-					break;
+			case ICBTAG_FLAG_AD_SHORT:
+				sad = (short_ad *)sptr;
+				sad->extLength = cpu_to_le32(
+					EXT_NEXT_EXTENT_ALLOCDECS |
+					sb->s_blocksize);
+				sad->extPosition =
+					cpu_to_le32(epos.block.logicalBlockNum);
+				break;
+			case ICBTAG_FLAG_AD_LONG:
+				lad = (long_ad *)sptr;
+				lad->extLength = cpu_to_le32(
+					EXT_NEXT_EXTENT_ALLOCDECS |
+					sb->s_blocksize);
+				lad->extLocation =
+					cpu_to_lelb(epos.block);
+				break;
 			}
 			if (oepos.bh) {
 				udf_update_tag(oepos.bh->b_data, loffset);
@@ -594,7 +634,8 @@ static void udf_table_free_blocks(struct
 			}
 		}
 
-		if (elen) { /* It's possible that stealing the block emptied the extent */
+		/* It's possible that stealing the block emptied the extent */
+		if (elen) {
 			udf_write_aext(table, &epos, eloc, elen, 1);
 
 			if (!epos.bh) {
@@ -603,7 +644,8 @@ static void udf_table_free_blocks(struct
 			} else {
 				aed = (struct allocExtDesc *)epos.bh->b_data;
 				aed->lengthAllocDescs =
-					cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) + adsize);
+					cpu_to_le32(le32_to_cpu(
+					    aed->lengthAllocDescs) + adsize);
 				udf_update_tag(epos.bh->b_data, epos.offset);
 				mark_buffer_dirty(epos.bh);
 			}
@@ -631,7 +673,8 @@ static int udf_table_prealloc_blocks(str
 	struct extent_position epos;
 	int8_t etype = -1;
 
-	if (first_block < 0 || first_block >= sbi->s_partmaps[partition].s_partition_len)
+	if (first_block < 0 ||
+		first_block >= sbi->s_partmaps[partition].s_partition_len)
 		return 0;
 
 	if (UDF_I_ALLOCTYPE(table) == ICBTAG_FLAG_AD_SHORT)
@@ -658,16 +701,18 @@ static int udf_table_prealloc_blocks(str
 		epos.offset -= adsize;
 
 		alloc_count = (elen >> sb->s_blocksize_bits);
-		if (inode && DQUOT_PREALLOC_BLOCK(inode, alloc_count > block_count ? block_count : alloc_count)) {
+		if (inode && DQUOT_PREALLOC_BLOCK(inode,
+			alloc_count > block_count ? block_count : alloc_count))
 			alloc_count = 0;
-		} else if (alloc_count > block_count) {
+		else if (alloc_count > block_count) {
 			alloc_count = block_count;
 			eloc.logicalBlockNum += alloc_count;
 			elen -= (alloc_count << sb->s_blocksize_bits);
-			udf_write_aext(table, &epos, eloc, (etype << 30) | elen, 1);
-		} else {
-			udf_delete_aext(table, epos, eloc, (etype << 30) | elen);
-		}
+			udf_write_aext(table, &epos, eloc,
+					(etype << 30) | elen, 1);
+		} else
+			udf_delete_aext(table, epos, eloc,
+					(etype << 30) | elen);
 	} else {
 		alloc_count = 0;
 	}
@@ -711,10 +756,10 @@ static int udf_table_new_block(struct su
 	if (goal < 0 || goal >= sbi->s_partmaps[partition].s_partition_len)
 		goal = 0;
 
-	/* We search for the closest matching block to goal. If we find a exact hit,
-	   we stop. Otherwise we keep going till we run out of extents.
-	   We store the buffer_head, bloc, and extoffset of the current closest
-	   match and use that when we are done.
+	/* We search for the closest matching block to goal. If we find
+	   a exact hit, we stop. Otherwise we keep going till we run out
+	   of extents. We store the buffer_head, bloc, and extoffset
+	   of the current closest match and use that when we are done.
 	 */
 	epos.offset = sizeof(struct unallocSpaceEntry);
 	epos.block = UDF_I_LOCATION(table);
@@ -723,7 +768,8 @@ static int udf_table_new_block(struct su
 	while (spread &&
 	       (etype = udf_next_aext(table, &epos, &eloc, &elen, 1)) != -1) {
 		if (goal >= eloc.logicalBlockNum) {
-			if (goal < eloc.logicalBlockNum + (elen >> sb->s_blocksize_bits))
+			if (goal < eloc.logicalBlockNum +
+					(elen >> sb->s_blocksize_bits))
 				nspread = 0;
 			else
 				nspread = goal - eloc.logicalBlockNum -
@@ -825,52 +871,53 @@ inline int udf_prealloc_blocks(struct su
 {
 	struct udf_part_map *map = &UDF_SB(sb)->s_partmaps[partition];
 
-	if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP) {
+	if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP)
 		return udf_bitmap_prealloc_blocks(sb, inode,
 						  map->s_uspace.s_bitmap,
-						  partition, first_block, block_count);
-	} else if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_TABLE) {
+						  partition, first_block,
+						  block_count);
+	else if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_TABLE)
 		return udf_table_prealloc_blocks(sb, inode,
 						 map->s_uspace.s_table,
-						 partition, first_block, block_count);
-	} else if (map->s_partition_flags & UDF_PART_FLAG_FREED_BITMAP) {
+						 partition, first_block,
+						 block_count);
+	else if (map->s_partition_flags & UDF_PART_FLAG_FREED_BITMAP)
 		return udf_bitmap_prealloc_blocks(sb, inode,
 						  map->s_fspace.s_bitmap,
-						  partition, first_block, block_count);
-	} else if (map->s_partition_flags & UDF_PART_FLAG_FREED_TABLE) {
+						  partition, first_block,
+						  block_count);
+	else if (map->s_partition_flags & UDF_PART_FLAG_FREED_TABLE)
 		return udf_table_prealloc_blocks(sb, inode,
 						 map->s_fspace.s_table,
-						 partition, first_block, block_count);
-	} else {
+						 partition, first_block,
+						 block_count);
+	else
 		return 0;
-	}
 }
 
 inline int udf_new_block(struct super_block *sb,
 			 struct inode *inode,
 			 uint16_t partition, uint32_t goal, int *err)
 {
-	int ret;
 	struct udf_part_map *map = &UDF_SB(sb)->s_partmaps[partition];
 
-	if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP) {
-		ret = udf_bitmap_new_block(sb, inode,
+	if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP)
+		return udf_bitmap_new_block(sb, inode,
 					   map->s_uspace.s_bitmap,
 					   partition, goal, err);
-		return ret;
-	} else if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_TABLE) {
+	else if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_TABLE)
 		return udf_table_new_block(sb, inode,
 					   map->s_uspace.s_table,
 					   partition, goal, err);
-	} else if (map->s_partition_flags & UDF_PART_FLAG_FREED_BITMAP) {
+	else if (map->s_partition_flags & UDF_PART_FLAG_FREED_BITMAP)
 		return udf_bitmap_new_block(sb, inode,
 					    map->s_fspace.s_bitmap,
 					    partition, goal, err);
-	} else if (map->s_partition_flags & UDF_PART_FLAG_FREED_TABLE) {
+	else if (map->s_partition_flags & UDF_PART_FLAG_FREED_TABLE)
 		return udf_table_new_block(sb, inode,
 					   map->s_fspace.s_table,
 					   partition, goal, err);
-	} else {
+	else {
 		*err = -EIO;
 		return 0;
 	}
diff -puN fs/udf/crc.c~udf-fix-coding-style fs/udf/crc.c
--- a/fs/udf/crc.c~udf-fix-coding-style
+++ a/fs/udf/crc.c
@@ -79,7 +79,7 @@ static uint16_t crc_table[256] = {
  *	July 21, 1997 - Andrew E. Mileski
  *	Adapted from OSTA-UDF(tm) 1.50 standard.
  */
-uint16_t udf_crc(uint8_t * data, uint32_t size, uint16_t crc)
+uint16_t udf_crc(uint8_t *data, uint32_t size, uint16_t crc)
 {
 	while (size--)
 		crc = crc_table[(crc >> 8 ^ *(data++)) & 0xffU] ^ (crc << 8);
diff -puN fs/udf/directory.c~udf-fix-coding-style fs/udf/directory.c
--- a/fs/udf/directory.c~udf-fix-coding-style
+++ a/fs/udf/directory.c
@@ -19,7 +19,7 @@
 #include <linux/buffer_head.h>
 
 #if 0
-static uint8_t *udf_filead_read(struct inode *dir, uint8_t * tmpad,
+static uint8_t *udf_filead_read(struct inode *dir, uint8_t *tmpad,
 				uint8_t ad_size, kernel_lb_addr fe_loc,
 				int *pos, int *offset, struct buffer_head **bh,
 				int *error)
@@ -45,7 +45,8 @@ static uint8_t *udf_filead_read(struct i
 		block = udf_get_lb_pblock(dir->i_sb, fe_loc, ++*pos);
 		if (!block)
 			return NULL;
-		if (!(*bh = udf_tread(dir->i_sb, block)))
+		*bh = udf_tread(dir->i_sb, block);
+		if (!*bh)
 			return NULL;
 	} else if (*offset > dir->i_sb->s_blocksize) {
 		ad = tmpad;
@@ -57,10 +58,12 @@ static uint8_t *udf_filead_read(struct i
 		block = udf_get_lb_pblock(dir->i_sb, fe_loc, ++*pos);
 		if (!block)
 			return NULL;
-		if (!((*bh) = udf_tread(dir->i_sb, block)))
+		(*bh) = udf_tread(dir->i_sb, block);
+		if (!*bh)
 			return NULL;
 
-		memcpy((uint8_t *)ad + remainder, (*bh)->b_data, ad_size - remainder);
+		memcpy((uint8_t *)ad + remainder, (*bh)->b_data,
+			ad_size - remainder);
 		*offset = ad_size - remainder;
 	}
 
@@ -68,12 +71,12 @@ static uint8_t *udf_filead_read(struct i
 }
 #endif
 
-struct fileIdentDesc *udf_fileident_read(struct inode *dir, loff_t * nf_pos,
+struct fileIdentDesc *udf_fileident_read(struct inode *dir, loff_t *nf_pos,
 					 struct udf_fileident_bh *fibh,
 					 struct fileIdentDesc *cfi,
 					 struct extent_position *epos,
-					 kernel_lb_addr * eloc, uint32_t * elen,
-					 sector_t * offset)
+					 kernel_lb_addr *eloc, uint32_t *elen,
+					 sector_t *offset)
 {
 	struct fileIdentDesc *fi;
 	int i, num, block;
@@ -86,7 +89,8 @@ struct fileIdentDesc *udf_fileident_read
 				       (UDF_I_EFE(dir) ?
 					sizeof(struct extendedFileEntry) :
 					sizeof(struct fileEntry)),
-				       dir->i_sb->s_blocksize, &(fibh->eoffset));
+				       dir->i_sb->s_blocksize,
+				       &(fibh->eoffset));
 		if (!fi)
 			return NULL;
 
@@ -100,6 +104,7 @@ struct fileIdentDesc *udf_fileident_read
 
 	if (fibh->eoffset == dir->i_sb->s_blocksize) {
 		int lextoffset = epos->offset;
+		unsigned char blocksize_bits = dir->i_sb->s_blocksize_bits;
 
 		if (udf_next_aext(dir, epos, eloc, elen, 1) !=
 		    (EXT_RECORDED_ALLOCATED >> 30))
@@ -109,24 +114,27 @@ struct fileIdentDesc *udf_fileident_read
 
 		(*offset)++;
 
-		if ((*offset << dir->i_sb->s_blocksize_bits) >= *elen)
+		if ((*offset << blocksize_bits) >= *elen)
 			*offset = 0;
 		else
 			epos->offset = lextoffset;
 
 		brelse(fibh->sbh);
-		if (!(fibh->sbh = fibh->ebh = udf_tread(dir->i_sb, block)))
+		fibh->sbh = fibh->ebh = udf_tread(dir->i_sb, block);
+		if (!fibh->sbh)
 			return NULL;
 		fibh->soffset = fibh->eoffset = 0;
 
-		if (!(*offset & ((16 >> (dir->i_sb->s_blocksize_bits - 9)) - 1))) {
-			i = 16 >> (dir->i_sb->s_blocksize_bits - 9);
-			if (i + *offset > (*elen >> dir->i_sb->s_blocksize_bits))
-				i = (*elen >> dir->i_sb->s_blocksize_bits)-*offset;
+		if (!(*offset & ((16 >> (blocksize_bits - 9)) - 1))) {
+			i = 16 >> (blocksize_bits - 9);
+			if (i + *offset > (*elen >> blocksize_bits))
+				i = (*elen >> blocksize_bits)-*offset;
 			for (num = 0; i > 0; i--) {
-				block = udf_get_lb_pblock(dir->i_sb, *eloc, *offset + i);
+				block = udf_get_lb_pblock(dir->i_sb, *eloc,
+							  *offset + i);
 				tmp = udf_tgetblk(dir->i_sb, block);
-				if (tmp && !buffer_uptodate(tmp) && !buffer_locked(tmp))
+				if (tmp && !buffer_uptodate(tmp) &&
+						!buffer_locked(tmp))
 					bha[num++] = tmp;
 				else
 					brelse(tmp);
@@ -172,20 +180,24 @@ struct fileIdentDesc *udf_fileident_read
 		fibh->soffset -= dir->i_sb->s_blocksize;
 		fibh->eoffset -= dir->i_sb->s_blocksize;
 
-		if (!(fibh->ebh = udf_tread(dir->i_sb, block)))
+		fibh->ebh = udf_tread(dir->i_sb, block);
+		if (!fibh->ebh)
 			return NULL;
 
 		if (sizeof(struct fileIdentDesc) > -fibh->soffset) {
 			int fi_len;
 
 			memcpy((uint8_t *)cfi, (uint8_t *)fi, -fibh->soffset);
-			memcpy((uint8_t *)cfi - fibh->soffset, fibh->ebh->b_data,
+			memcpy((uint8_t *)cfi - fibh->soffset,
+			       fibh->ebh->b_data,
 			       sizeof(struct fileIdentDesc) + fibh->soffset);
 
-			fi_len = (sizeof(struct fileIdentDesc) + cfi->lengthFileIdent +
+			fi_len = (sizeof(struct fileIdentDesc) +
+				  cfi->lengthFileIdent +
 				  le16_to_cpu(cfi->lengthOfImpUse) + 3) & ~3;
 
-			*nf_pos += ((fi_len - (fibh->eoffset - fibh->soffset)) >> 2);
+			*nf_pos += (fi_len - (fibh->eoffset - fibh->soffset))
+					>> 2;
 			fibh->eoffset = fibh->soffset + fi_len;
 		} else {
 			memcpy((uint8_t *)cfi, (uint8_t *)fi,
@@ -210,9 +222,8 @@ struct fileIdentDesc *udf_get_fileident(
 
 	ptr = buffer;
 
-	if ((*offset > 0) && (*offset < bufsize)) {
+	if ((*offset > 0) && (*offset < bufsize))
 		ptr += *offset;
-	}
 	fi = (struct fileIdentDesc *)ptr;
 	if (le16_to_cpu(fi->descTag.tagIdent) != TAG_IDENT_FID) {
 		udf_debug("0x%x != TAG_IDENT_FID\n",
@@ -222,12 +233,11 @@ struct fileIdentDesc *udf_get_fileident(
 			  bufsize);
 		return NULL;
 	}
-	if ((*offset + sizeof(struct fileIdentDesc)) > bufsize) {
+	if ((*offset + sizeof(struct fileIdentDesc)) > bufsize)
 		lengthThisIdent = sizeof(struct fileIdentDesc);
-	} else {
+	else
 		lengthThisIdent = sizeof(struct fileIdentDesc) +
 			fi->lengthFileIdent + le16_to_cpu(fi->lengthOfImpUse);
-	}
 
 	/* we need to figure padding, too! */
 	padlen = lengthThisIdent % UDF_NAME_PAD;
@@ -258,11 +268,11 @@ static extent_ad *udf_get_fileextent(voi
 		return NULL;
 	}
 
-	ptr = (uint8_t *)(fe->extendedAttr) + le32_to_cpu(fe->lengthExtendedAttr);
+	ptr = (uint8_t *)(fe->extendedAttr) +
+		le32_to_cpu(fe->lengthExtendedAttr);
 
-	if ((*offset > 0) && (*offset < le32_to_cpu(fe->lengthAllocDescs))) {
+	if ((*offset > 0) && (*offset < le32_to_cpu(fe->lengthAllocDescs)))
 		ptr += *offset;
-	}
 
 	ext = (extent_ad *)ptr;
 
@@ -283,8 +293,11 @@ short_ad *udf_get_fileshortad(uint8_t *p
 
 	if ((*offset < 0) || ((*offset + sizeof(short_ad)) > maxoffset))
 		return NULL;
-	else if ((sa = (short_ad *)ptr)->extLength == 0)
-		return NULL;
+	else {
+		sa = (short_ad *)ptr;
+		if (sa->extLength == 0)
+			return NULL;
+	}
 
 	if (inc)
 		*offset += sizeof(short_ad);
@@ -302,8 +315,11 @@ long_ad *udf_get_filelongad(uint8_t *ptr
 
 	if ((*offset < 0) || ((*offset + sizeof(long_ad)) > maxoffset))
 		return NULL;
-	else if ((la = (long_ad *)ptr)->extLength == 0)
-		return NULL;
+	else {
+		la = (long_ad *)ptr;
+		if (la->extLength == 0)
+			return NULL;
+	}
 
 	if (inc)
 		*offset += sizeof(long_ad);
diff -puN fs/udf/file.c~udf-fix-coding-style fs/udf/file.c
--- a/fs/udf/file.c~udf-fix-coding-style
+++ a/fs/udf/file.c
@@ -59,7 +59,8 @@ static int udf_adinicb_readpage(struct f
 	return 0;
 }
 
-static int udf_adinicb_writepage(struct page *page, struct writeback_control *wbc)
+static int udf_adinicb_writepage(struct page *page,
+				 struct writeback_control *wbc)
 {
 	struct inode *inode = page->mapping->host;
 	char *kaddr;
@@ -116,7 +117,8 @@ static ssize_t udf_file_aio_write(struct
 		else
 			pos = ppos;
 
-		if (inode->i_sb->s_blocksize < (udf_file_entry_alloc_offset(inode) +
+		if (inode->i_sb->s_blocksize <
+				(udf_file_entry_alloc_offset(inode) +
 						pos + count)) {
 			udf_expand_file_adinicb(inode, pos + count, &err);
 			if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB) {
@@ -191,15 +193,19 @@ int udf_ioctl(struct inode *inode, struc
 
 	switch (cmd) {
 	case UDF_GETVOLIDENT:
-		return copy_to_user((char __user *)arg,
-				    UDF_SB(inode->i_sb)->s_volume_ident, 32) ? -EFAULT : 0;
+		if (copy_to_user((char __user *)arg,
+				 UDF_SB(inode->i_sb)->s_volume_ident, 32))
+			return -EFAULT;
+		else
+			return 0;
 	case UDF_RELOCATE_BLOCKS:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EACCES;
 		if (get_user(old_block, (long __user *)arg))
 			return -EFAULT;
-		if ((result = udf_relocate_blocks(inode->i_sb,
-						  old_block, &new_block)) == 0)
+		result = udf_relocate_blocks(inode->i_sb,
+						old_block, &new_block);
+		if (result == 0)
 			result = put_user(new_block, (long __user *)arg);
 		return result;
 	case UDF_GETEASIZE:
diff -puN fs/udf/ialloc.c~udf-fix-coding-style fs/udf/ialloc.c
--- a/fs/udf/ialloc.c~udf-fix-coding-style
+++ a/fs/udf/ialloc.c
@@ -82,7 +82,8 @@ struct inode *udf_new_inode(struct inode
 	UDF_I_NEXT_ALLOC_GOAL(inode) = 0;
 	UDF_I_STRAT4096(inode) = 0;
 
-	block = udf_new_block(dir->i_sb, NULL, UDF_I_LOCATION(dir).partitionReferenceNum,
+	block = udf_new_block(dir->i_sb, NULL,
+			      UDF_I_LOCATION(dir).partitionReferenceNum,
 			      start, err);
 	if (*err) {
 		iput(inode);
@@ -91,11 +92,15 @@ struct inode *udf_new_inode(struct inode
 
 	mutex_lock(&sbi->s_alloc_mutex);
 	if (sbi->s_lvid_bh) {
-		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
-		struct logicalVolIntegrityDescImpUse *lvidiu = udf_sb_lvidiu(sbi);
+		struct logicalVolIntegrityDesc *lvid =
+			(struct logicalVolIntegrityDesc *)
+			sbi->s_lvid_bh->b_data;
+		struct logicalVolIntegrityDescImpUse *lvidiu =
+							udf_sb_lvidiu(sbi);
 		struct logicalVolHeaderDesc *lvhd;
 		uint64_t uniqueID;
-		lvhd = (struct logicalVolHeaderDesc *)(lvid->logicalVolContentsUse);
+		lvhd = (struct logicalVolHeaderDesc *)
+				(lvid->logicalVolContentsUse);
 		if (S_ISDIR(mode))
 			lvidiu->numDirs =
 				cpu_to_le32(le32_to_cpu(lvidiu->numDirs) + 1);
@@ -119,7 +124,8 @@ struct inode *udf_new_inode(struct inode
 	}
 
 	UDF_I_LOCATION(inode).logicalBlockNum = block;
-	UDF_I_LOCATION(inode).partitionReferenceNum = UDF_I_LOCATION(dir).partitionReferenceNum;
+	UDF_I_LOCATION(inode).partitionReferenceNum =
+				UDF_I_LOCATION(dir).partitionReferenceNum;
 	inode->i_ino = udf_get_lb_pblock(sb, UDF_I_LOCATION(inode), 0);
 	inode->i_blocks = 0;
 	UDF_I_LENEATTR(inode) = 0;
@@ -129,10 +135,14 @@ struct inode *udf_new_inode(struct inode
 		UDF_I_EFE(inode) = 1;
 		if (UDF_VERS_USE_EXTENDED_FE > sbi->s_udfrev)
 			sbi->s_udfrev = UDF_VERS_USE_EXTENDED_FE;
-		UDF_I_DATA(inode) = kzalloc(inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry), GFP_KERNEL);
+		UDF_I_DATA(inode) = kzalloc(inode->i_sb->s_blocksize -
+					    sizeof(struct extendedFileEntry),
+					    GFP_KERNEL);
 	} else {
 		UDF_I_EFE(inode) = 0;
-		UDF_I_DATA(inode) = kzalloc(inode->i_sb->s_blocksize - sizeof(struct fileEntry), GFP_KERNEL);
+		UDF_I_DATA(inode) = kzalloc(inode->i_sb->s_blocksize -
+					    sizeof(struct fileEntry),
+					    GFP_KERNEL);
 	}
 	if (!UDF_I_DATA(inode)) {
 		iput(inode);
diff -puN fs/udf/inode.c~udf-fix-coding-style fs/udf/inode.c
--- a/fs/udf/inode.c~udf-fix-coding-style
+++ a/fs/udf/inode.c
@@ -19,7 +19,8 @@
  *  10/04/98 dgb  Added rudimentary directory functions
  *  10/07/98      Fully working udf_block_map! It works!
  *  11/25/98      bmap altered to better support extents
- *  12/06/98 blf  partition support in udf_iget, udf_block_map and udf_read_inode
+ *  12/06/98 blf  partition support in udf_iget, udf_block_map
+ *                and udf_read_inode
  *  12/12/98      rewrote udf_block_map to handle next extents and descs across
  *                block boundaries (which is not actually allowed)
  *  12/20/98      added support for strategy 4096
@@ -237,7 +238,8 @@ struct buffer_head *udf_expand_dir_adini
 	if (!(*block))
 		return NULL;
 	newblock = udf_get_pblock(inode->i_sb, *block,
-				  UDF_I_LOCATION(inode).partitionReferenceNum, 0);
+				  UDF_I_LOCATION(inode).partitionReferenceNum,
+				  0);
 	if (!newblock)
 		return NULL;
 	dbh = udf_tgetblk(inode->i_sb, newblock);
@@ -249,13 +251,15 @@ struct buffer_head *udf_expand_dir_adini
 	unlock_buffer(dbh);
 	mark_buffer_dirty_inode(dbh, inode);
 
-	sfibh.soffset = sfibh.eoffset = (f_pos & ((inode->i_sb->s_blocksize - 1) >> 2)) << 2;
+	sfibh.soffset = sfibh.eoffset =
+			(f_pos & ((inode->i_sb->s_blocksize - 1) >> 2)) << 2;
 	sfibh.sbh = sfibh.ebh = NULL;
 	dfibh.soffset = dfibh.eoffset = 0;
 	dfibh.sbh = dfibh.ebh = dbh;
 	while ((f_pos < size)) {
 		UDF_I_ALLOCTYPE(inode) = ICBTAG_FLAG_AD_IN_ICB;
-		sfi = udf_fileident_read(inode, &f_pos, &sfibh, &cfi, NULL, NULL, NULL, NULL);
+		sfi = udf_fileident_read(inode, &f_pos, &sfibh, &cfi, NULL,
+					 NULL, NULL, NULL);
 		if (!sfi) {
 			brelse(dbh);
 			return NULL;
@@ -266,7 +270,8 @@ struct buffer_head *udf_expand_dir_adini
 		dfibh.eoffset += (sfibh.eoffset - sfibh.soffset);
 		dfi = (struct fileIdentDesc *)(dbh->b_data + dfibh.soffset);
 		if (udf_write_fi(inode, sfi, dfi, &dfibh, sfi->impUse,
-				 sfi->fileIdent + le16_to_cpu(sfi->lengthOfImpUse))) {
+				 sfi->fileIdent +
+					le16_to_cpu(sfi->lengthOfImpUse))) {
 			UDF_I_ALLOCTYPE(inode) = ICBTAG_FLAG_AD_IN_ICB;
 			brelse(dbh);
 			return NULL;
@@ -274,10 +279,12 @@ struct buffer_head *udf_expand_dir_adini
 	}
 	mark_buffer_dirty_inode(dbh, inode);
 
-	memset(UDF_I_DATA(inode) + UDF_I_LENEATTR(inode), 0, UDF_I_LENALLOC(inode));
+	memset(UDF_I_DATA(inode) + UDF_I_LENEATTR(inode), 0,
+		UDF_I_LENALLOC(inode));
 	UDF_I_LENALLOC(inode) = 0;
 	eloc.logicalBlockNum = *block;
-	eloc.partitionReferenceNum = UDF_I_LOCATION(inode).partitionReferenceNum;
+	eloc.partitionReferenceNum =
+				UDF_I_LOCATION(inode).partitionReferenceNum;
 	elen = inode->i_size;
 	UDF_I_LENEXTENTS(inode) = elen;
 	epos.bh = NULL;
@@ -366,7 +373,7 @@ static struct buffer_head *udf_getblk(st
 
 /* Extend the file by 'blocks' blocks, return the number of extents added */
 int udf_extend_file(struct inode *inode, struct extent_position *last_pos,
-		    kernel_long_ad * last_ext, sector_t blocks)
+		    kernel_long_ad *last_ext, sector_t blocks)
 {
 	sector_t add;
 	int count = 0, fake = !(last_ext->extLength & UDF_EXTENT_LENGTH_MASK);
@@ -391,7 +398,8 @@ int udf_extend_file(struct inode *inode,
 	}
 
 	/* Last extent are just preallocated blocks? */
-	if ((last_ext->extLength & UDF_EXTENT_FLAG_MASK) == EXT_NOT_RECORDED_ALLOCATED) {
+	if ((last_ext->extLength & UDF_EXTENT_FLAG_MASK) ==
+						EXT_NOT_RECORDED_ALLOCATED) {
 		/* Save the extent so that we can reattach it to the end */
 		prealloc_loc = last_ext->extLocation;
 		prealloc_len = last_ext->extLength;
@@ -399,13 +407,15 @@ int udf_extend_file(struct inode *inode,
 		last_ext->extLength = EXT_NOT_RECORDED_NOT_ALLOCATED |
 			(last_ext->extLength & UDF_EXTENT_LENGTH_MASK);
 		last_ext->extLocation.logicalBlockNum = 0;
-       		last_ext->extLocation.partitionReferenceNum = 0;
+		last_ext->extLocation.partitionReferenceNum = 0;
 	}
 
 	/* Can we merge with the previous extent? */
-	if ((last_ext->extLength & UDF_EXTENT_FLAG_MASK) == EXT_NOT_RECORDED_NOT_ALLOCATED) {
-		add = ((1 << 30) - sb->s_blocksize - (last_ext->extLength &
-						      UDF_EXTENT_LENGTH_MASK)) >> sb->s_blocksize_bits;
+	if ((last_ext->extLength & UDF_EXTENT_FLAG_MASK) ==
+					EXT_NOT_RECORDED_NOT_ALLOCATED) {
+		add = ((1 << 30) - sb->s_blocksize -
+			(last_ext->extLength & UDF_EXTENT_LENGTH_MASK)) >>
+			sb->s_blocksize_bits;
 		if (add > blocks)
 			add = blocks;
 		blocks -= add;
@@ -416,9 +426,9 @@ int udf_extend_file(struct inode *inode,
 		udf_add_aext(inode, last_pos, last_ext->extLocation,
 			     last_ext->extLength, 1);
 		count++;
-	} else {
-		udf_write_aext(inode, last_pos, last_ext->extLocation, last_ext->extLength, 1);
-	}
+	} else
+		udf_write_aext(inode, last_pos, last_ext->extLocation,
+				last_ext->extLength, 1);
 
 	/* Managed to do everything necessary? */
 	if (!blocks)
@@ -426,9 +436,10 @@ int udf_extend_file(struct inode *inode,
 
 	/* All further extents will be NOT_RECORDED_NOT_ALLOCATED */
 	last_ext->extLocation.logicalBlockNum = 0;
-       	last_ext->extLocation.partitionReferenceNum = 0;
+	last_ext->extLocation.partitionReferenceNum = 0;
 	add = (1 << (30-sb->s_blocksize_bits)) - 1;
-	last_ext->extLength = EXT_NOT_RECORDED_NOT_ALLOCATED | (add << sb->s_blocksize_bits);
+	last_ext->extLength = EXT_NOT_RECORDED_NOT_ALLOCATED |
+				(add << sb->s_blocksize_bits);
 
 	/* Create enough extents to cover the whole hole */
 	while (blocks > add) {
@@ -450,7 +461,8 @@ int udf_extend_file(struct inode *inode,
 out:
 	/* Do we have some preallocated blocks saved? */
 	if (prealloc_len) {
-		if (udf_add_aext(inode, last_pos, prealloc_loc, prealloc_len, 1) == -1)
+		if (udf_add_aext(inode, last_pos, prealloc_loc,
+				 prealloc_len, 1) == -1)
 			return -1;
 		last_ext->extLocation = prealloc_loc;
 		last_ext->extLength = prealloc_len;
@@ -515,7 +527,8 @@ static struct buffer_head *inode_getblk(
 		prev_epos.offset = cur_epos.offset;
 		cur_epos.offset = next_epos.offset;
 
-		if ((etype = udf_next_aext(inode, &next_epos, &eloc, &elen, 1)) == -1)
+		etype = udf_next_aext(inode, &next_epos, &eloc, &elen, 1);
+		if (etype == -1)
 			break;
 
 		c = !c;
@@ -569,9 +582,11 @@ static struct buffer_head *inode_getblk(
 			startnum = 1;
 		} else {
 			/* Create a fake extent when there's not one */
-			memset(&laarr[0].extLocation, 0x00, sizeof(kernel_lb_addr));
+			memset(&laarr[0].extLocation, 0x00,
+				sizeof(kernel_lb_addr));
 			laarr[0].extLength = EXT_NOT_RECORDED_NOT_ALLOCATED;
-			/* Will udf_extend_file() create real extent from a fake one? */
+			/* Will udf_extend_file() create real extent from
+			   a fake one? */
 			startnum = (offset > 0);
 		}
 		/* Create extents for the hole between EOF and offset */
@@ -589,14 +604,16 @@ static struct buffer_head *inode_getblk(
 		offset = 0;
 		count += ret;
 		/* We are not covered by a preallocated extent? */
-		if ((laarr[0].extLength & UDF_EXTENT_FLAG_MASK) != EXT_NOT_RECORDED_ALLOCATED) {
+		if ((laarr[0].extLength & UDF_EXTENT_FLAG_MASK) !=
+						EXT_NOT_RECORDED_ALLOCATED) {
 			/* Is there any real extent? - otherwise we overwrite
 			 * the fake one... */
 			if (count)
 				c = !c;
 			laarr[c].extLength = EXT_NOT_RECORDED_NOT_ALLOCATED |
 				inode->i_sb->s_blocksize;
-			memset(&laarr[c].extLocation, 0x00, sizeof(kernel_lb_addr));
+			memset(&laarr[c].extLocation, 0x00,
+				sizeof(kernel_lb_addr));
 			count++;
 			endnum++;
 		}
@@ -605,7 +622,8 @@ static struct buffer_head *inode_getblk(
 	} else {
 		endnum = startnum = ((count > 2) ? 2 : count);
 
-		/* if the current extent is in position 0, swap it with the previous */
+		/* if the current extent is in position 0,
+		   swap it with the previous */
 		if (!c && count != 1) {
 			laarr[2] = laarr[0];
 			laarr[0] = laarr[1];
@@ -613,34 +631,36 @@ static struct buffer_head *inode_getblk(
 			c = 1;
 		}
 
-		/* if the current block is located in an extent, read the next extent */
-		if ((etype = udf_next_aext(inode, &next_epos, &eloc, &elen, 0)) != -1) {
+		/* if the current block is located in an extent,
+		   read the next extent */
+		etype = udf_next_aext(inode, &next_epos, &eloc, &elen, 0);
+		if (etype != -1) {
 			laarr[c + 1].extLength = (etype << 30) | elen;
 			laarr[c + 1].extLocation = eloc;
 			count++;
 			startnum++;
 			endnum++;
-		} else {
+		} else
 			lastblock = 1;
-		}
 	}
 
 	/* if the current extent is not recorded but allocated, get the
 	 * block in the extent corresponding to the requested block */
-	if ((laarr[c].extLength >> 30) == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
+	if ((laarr[c].extLength >> 30) == (EXT_NOT_RECORDED_ALLOCATED >> 30))
 		newblocknum = laarr[c].extLocation.logicalBlockNum + offset;
-	} else { /* otherwise, allocate a new block */
+	else { /* otherwise, allocate a new block */
 		if (UDF_I_NEXT_ALLOC_BLOCK(inode) == block)
 			goal = UDF_I_NEXT_ALLOC_GOAL(inode);
 
 		if (!goal) {
-			if (!(goal = pgoal))
-				goal = UDF_I_LOCATION(inode).logicalBlockNum + 1;
+			if (!(goal = pgoal)) /* XXX: what was intended here? */
+				goal = UDF_I_LOCATION(inode).logicalBlockNum+1;
 		}
 
-		if (!(newblocknum = udf_new_block(inode->i_sb, inode,
-						  UDF_I_LOCATION(inode).partitionReferenceNum,
-						  goal, err))) {
+		newblocknum = udf_new_block(inode->i_sb, inode,
+				UDF_I_LOCATION(inode).partitionReferenceNum,
+				goal, err);
+		if (!newblocknum) {
 			brelse(prev_epos.bh);
 			*err = -ENOSPC;
 			return NULL;
@@ -648,9 +668,10 @@ static struct buffer_head *inode_getblk(
 		UDF_I_LENEXTENTS(inode) += inode->i_sb->s_blocksize;
 	}
 
-	/* if the extent the requsted block is located in contains multiple blocks,
-	 * split the extent into at most three extents. blocks prior to requested
-	 * block, requested block, and blocks after requested block */
+	/* if the extent the requsted block is located in contains multiple
+	 * blocks, split the extent into at most three extents. blocks prior
+	 * to requested block, requested block, and blocks after requested
+	 * block */
 	udf_split_extents(inode, &c, offset, newblocknum, laarr, &endnum);
 
 #ifdef UDF_PREALLOCATE
@@ -668,10 +689,10 @@ static struct buffer_head *inode_getblk(
 
 	brelse(prev_epos.bh);
 
-	if (!(newblock = udf_get_pblock(inode->i_sb, newblocknum,
-					UDF_I_LOCATION(inode).partitionReferenceNum, 0))) {
+	newblock = udf_get_pblock(inode->i_sb, newblocknum,
+				UDF_I_LOCATION(inode).partitionReferenceNum, 0);
+	if (!newblock)
 		return NULL;
-	}
 	*phys = newblock;
 	*err = 0;
 	*new = 1;
@@ -692,16 +713,20 @@ static void udf_split_extents(struct ino
 			      kernel_long_ad laarr[EXTENT_MERGE_SIZE],
 			      int *endnum)
 {
+	unsigned long blocksize = inode->i_sb->s_blocksize;
+	unsigned char blocksize_bits = inode->i_sb->s_blocksize_bits;
+
 	if ((laarr[*c].extLength >> 30) == (EXT_NOT_RECORDED_ALLOCATED >> 30) ||
-	    (laarr[*c].extLength >> 30) == (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30)) {
+	    (laarr[*c].extLength >> 30) ==
+				(EXT_NOT_RECORDED_NOT_ALLOCATED >> 30)) {
 		int curr = *c;
 		int blen = ((laarr[curr].extLength & UDF_EXTENT_LENGTH_MASK) +
-			    inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits;
+			    blocksize - 1) >> blocksize_bits;
 		int8_t etype = (laarr[curr].extLength >> 30);
 
-		if (blen == 1) {
+		if (blen == 1)
 			;
-		} else if (!offset || blen == offset + 1) {
+		else if (!offset || blen == offset + 1) {
 			laarr[curr + 2] = laarr[curr + 1];
 			laarr[curr + 1] = laarr[curr];
 		} else {
@@ -711,15 +736,18 @@ static void udf_split_extents(struct ino
 
 		if (offset) {
 			if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
-				udf_free_blocks(inode->i_sb, inode, laarr[curr].extLocation, 0, offset);
-				laarr[curr].extLength = EXT_NOT_RECORDED_NOT_ALLOCATED |
-					(offset << inode->i_sb->s_blocksize_bits);
+				udf_free_blocks(inode->i_sb, inode,
+						laarr[curr].extLocation,
+						0, offset);
+				laarr[curr].extLength =
+					EXT_NOT_RECORDED_NOT_ALLOCATED |
+					(offset << blocksize_bits);
 				laarr[curr].extLocation.logicalBlockNum = 0;
-				laarr[curr].extLocation.partitionReferenceNum = 0;
-			} else {
+				laarr[curr].extLocation.
+						partitionReferenceNum = 0;
+			} else
 				laarr[curr].extLength = (etype << 30) |
-					(offset << inode->i_sb->s_blocksize_bits);
-			}
+					(offset << blocksize_bits);
 			curr++;
 			(*c)++;
 			(*endnum)++;
@@ -730,14 +758,15 @@ static void udf_split_extents(struct ino
 			laarr[curr].extLocation.partitionReferenceNum =
 				UDF_I_LOCATION(inode).partitionReferenceNum;
 		laarr[curr].extLength = EXT_RECORDED_ALLOCATED |
-			inode->i_sb->s_blocksize;
+			blocksize;
 		curr++;
 
 		if (blen != offset + 1) {
 			if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30))
-				laarr[curr].extLocation.logicalBlockNum += (offset + 1);
+				laarr[curr].extLocation.logicalBlockNum +=
+								offset + 1;
 			laarr[curr].extLength = (etype << 30) |
-				((blen - (offset + 1)) << inode->i_sb->s_blocksize_bits);
+				((blen - (offset + 1)) << blocksize_bits);
 			curr++;
 			(*endnum)++;
 		}
@@ -756,69 +785,86 @@ static void udf_prealloc_extents(struct 
 		else
 			start = c;
 	} else {
-		if ((laarr[c + 1].extLength >> 30) == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
+		if ((laarr[c + 1].extLength >> 30) ==
+					(EXT_NOT_RECORDED_ALLOCATED >> 30)) {
 			start = c + 1;
-			length = currlength = (((laarr[c + 1].extLength & UDF_EXTENT_LENGTH_MASK) +
-						inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits);
-		} else {
+			length = currlength =
+				(((laarr[c + 1].extLength &
+					UDF_EXTENT_LENGTH_MASK) +
+				inode->i_sb->s_blocksize - 1) >>
+				inode->i_sb->s_blocksize_bits);
+		} else
 			start = c;
-		}
 	}
 
 	for (i = start + 1; i <= *endnum; i++) {
 		if (i == *endnum) {
 			if (lastblock)
 				length += UDF_DEFAULT_PREALLOC_BLOCKS;
-		} else if ((laarr[i].extLength >> 30) == (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30)) {
-			length += (((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-				    inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits);
-		} else {
+		} else if ((laarr[i].extLength >> 30) ==
+				(EXT_NOT_RECORDED_NOT_ALLOCATED >> 30)) {
+			length += (((laarr[i].extLength &
+						UDF_EXTENT_LENGTH_MASK) +
+				    inode->i_sb->s_blocksize - 1) >>
+				    inode->i_sb->s_blocksize_bits);
+		} else
 			break;
-		}
 	}
 
 	if (length) {
 		int next = laarr[start].extLocation.logicalBlockNum +
 			(((laarr[start].extLength & UDF_EXTENT_LENGTH_MASK) +
-			  inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits);
+			  inode->i_sb->s_blocksize - 1) >>
+			  inode->i_sb->s_blocksize_bits);
 		int numalloc = udf_prealloc_blocks(inode->i_sb, inode,
-						   laarr[start].extLocation.partitionReferenceNum,
-						   next, (UDF_DEFAULT_PREALLOC_BLOCKS > length ? length :
-							  UDF_DEFAULT_PREALLOC_BLOCKS) - currlength);
+				laarr[start].extLocation.partitionReferenceNum,
+				next, (UDF_DEFAULT_PREALLOC_BLOCKS > length ?
+				length : UDF_DEFAULT_PREALLOC_BLOCKS) -
+				currlength);
 		if (numalloc) 	{
-			if (start == (c + 1)) {
+			if (start == (c + 1))
 				laarr[start].extLength +=
-					(numalloc << inode->i_sb->s_blocksize_bits);
-			} else {
+					(numalloc <<
+					 inode->i_sb->s_blocksize_bits);
+			else {
 				memmove(&laarr[c + 2], &laarr[c + 1],
 					sizeof(long_ad) * (*endnum - (c + 1)));
 				(*endnum)++;
 				laarr[c + 1].extLocation.logicalBlockNum = next;
 				laarr[c + 1].extLocation.partitionReferenceNum =
-					laarr[c].extLocation.partitionReferenceNum;
-				laarr[c + 1].extLength = EXT_NOT_RECORDED_ALLOCATED |
-					(numalloc << inode->i_sb->s_blocksize_bits);
+					laarr[c].extLocation.
+							partitionReferenceNum;
+				laarr[c + 1].extLength =
+					EXT_NOT_RECORDED_ALLOCATED |
+					(numalloc <<
+					 inode->i_sb->s_blocksize_bits);
 				start = c + 1;
 			}
 
 			for (i = start + 1; numalloc && i < *endnum; i++) {
-				int elen = ((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-					    inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits;
+				int elen = ((laarr[i].extLength &
+						UDF_EXTENT_LENGTH_MASK) +
+					    inode->i_sb->s_blocksize - 1) >>
+					    inode->i_sb->s_blocksize_bits;
 
 				if (elen > numalloc) {
 					laarr[i].extLength -=
-						(numalloc << inode->i_sb->s_blocksize_bits);
+						(numalloc <<
+						 inode->i_sb->s_blocksize_bits);
 					numalloc = 0;
 				} else {
 					numalloc -= elen;
 					if (*endnum > (i + 1))
-						memmove(&laarr[i], &laarr[i + 1],
-							sizeof(long_ad) * (*endnum - (i + 1)));
+						memmove(&laarr[i],
+							&laarr[i + 1],
+							sizeof(long_ad) *
+							(*endnum - (i + 1)));
 					i--;
 					(*endnum)--;
 				}
 			}
-			UDF_I_LENEXTENTS(inode) += numalloc << inode->i_sb->s_blocksize_bits;
+			UDF_I_LENEXTENTS(inode) +=
+				numalloc << inode->i_sb->s_blocksize_bits;
 		}
 	}
 }
@@ -828,70 +874,97 @@ static void udf_merge_extents(struct ino
 			      int *endnum)
 {
 	int i;
+	unsigned long blocksize = inode->i_sb->s_blocksize;
+	unsigned char blocksize_bits = inode->i_sb->s_blocksize_bits;
 
 	for (i = 0; i < (*endnum - 1); i++) {
-		if ((laarr[i].extLength >> 30) == (laarr[i + 1].extLength >> 30)) {
-			if (((laarr[i].extLength >> 30) == (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30)) ||
-			    ((laarr[i + 1].extLocation.logicalBlockNum - laarr[i].extLocation.logicalBlockNum) ==
-			     (((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-			       inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits))) {
-				if (((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-				     (laarr[i + 1].extLength & UDF_EXTENT_LENGTH_MASK) +
-				     inode->i_sb->s_blocksize - 1) & ~UDF_EXTENT_LENGTH_MASK) {
-					laarr[i + 1].extLength = (laarr[i + 1].extLength -
-								  (laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-								  UDF_EXTENT_LENGTH_MASK) & ~(inode->i_sb->s_blocksize - 1);
-					laarr[i].extLength = (laarr[i].extLength & UDF_EXTENT_FLAG_MASK) +
-						(UDF_EXTENT_LENGTH_MASK + 1) - inode->i_sb->s_blocksize;
-					laarr[i + 1].extLocation.logicalBlockNum =
-						laarr[i].extLocation.logicalBlockNum +
-						((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) >>
-						 inode->i_sb->s_blocksize_bits);
-				} else {
-					laarr[i].extLength = laarr[i + 1].extLength +
-						(((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-						  inode->i_sb->s_blocksize - 1) & ~(inode->i_sb->s_blocksize - 1));
-					if (*endnum > (i + 2))
-						memmove(&laarr[i + 1], &laarr[i + 2],
-							sizeof(long_ad) * (*endnum - (i + 2)));
-					i--;
-					(*endnum)--;
-				}
+		kernel_long_ad *li /*l[i]*/ = &laarr[i];
+		kernel_long_ad *lip1 /*l[i plus 1]*/ = &laarr[i + 1];
+
+		if (((li->extLength >> 30) == (lip1->extLength >> 30)) &&
+			(((li->extLength >> 30) ==
+				(EXT_NOT_RECORDED_NOT_ALLOCATED >> 30)) ||
+			((lip1->extLocation.logicalBlockNum -
+			  li->extLocation.logicalBlockNum) ==
+			(((li->extLength & UDF_EXTENT_LENGTH_MASK) +
+			blocksize - 1) >> blocksize_bits)))) {
+
+			if (((li->extLength & UDF_EXTENT_LENGTH_MASK) +
+				(lip1->extLength & UDF_EXTENT_LENGTH_MASK) +
+				blocksize - 1) & ~UDF_EXTENT_LENGTH_MASK) {
+				lip1->extLength = (lip1->extLength -
+						  (li->extLength &
+						   UDF_EXTENT_LENGTH_MASK) +
+						   UDF_EXTENT_LENGTH_MASK) &
+							~(blocksize - 1);
+				li->extLength = (li->extLength &
+						 UDF_EXTENT_FLAG_MASK) +
+						(UDF_EXTENT_LENGTH_MASK + 1) -
+						blocksize;
+				lip1->extLocation.logicalBlockNum =
+					li->extLocation.logicalBlockNum +
+					((li->extLength &
+						UDF_EXTENT_LENGTH_MASK) >>
+						blocksize_bits);
+			} else {
+				li->extLength = lip1->extLength +
+					(((li->extLength &
+						UDF_EXTENT_LENGTH_MASK) +
+					 blocksize - 1) & ~(blocksize - 1));
+				if (*endnum > (i + 2))
+					memmove(&laarr[i + 1], &laarr[i + 2],
+						sizeof(long_ad) *
+						(*endnum - (i + 2)));
+				i--;
+				(*endnum)--;
 			}
-		} else if (((laarr[i].extLength >> 30) == (EXT_NOT_RECORDED_ALLOCATED >> 30)) &&
-			   ((laarr[i + 1].extLength >> 30) == (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30))) {
-			udf_free_blocks(inode->i_sb, inode, laarr[i].extLocation, 0,
-					((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-					 inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits);
-			laarr[i].extLocation.logicalBlockNum = 0;
-			laarr[i].extLocation.partitionReferenceNum = 0;
-
-			if (((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-			     (laarr[i + 1].extLength & UDF_EXTENT_LENGTH_MASK) +
-			     inode->i_sb->s_blocksize - 1) & ~UDF_EXTENT_LENGTH_MASK) {
-				laarr[i + 1].extLength = (laarr[i + 1].extLength -
-							  (laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-							  UDF_EXTENT_LENGTH_MASK) & ~(inode->i_sb->s_blocksize - 1);
-				laarr[i].extLength = (laarr[i].extLength & UDF_EXTENT_FLAG_MASK) +
-					(UDF_EXTENT_LENGTH_MASK + 1) - inode->i_sb->s_blocksize;
+		} else if (((li->extLength >> 30) ==
+				(EXT_NOT_RECORDED_ALLOCATED >> 30)) &&
+			   ((lip1->extLength >> 30) ==
+				(EXT_NOT_RECORDED_NOT_ALLOCATED >> 30))) {
+			udf_free_blocks(inode->i_sb, inode, li->extLocation, 0,
+					((li->extLength &
+					  UDF_EXTENT_LENGTH_MASK) +
+					 blocksize - 1) >> blocksize_bits);
+			li->extLocation.logicalBlockNum = 0;
+			li->extLocation.partitionReferenceNum = 0;
+
+			if (((li->extLength & UDF_EXTENT_LENGTH_MASK) +
+			     (lip1->extLength & UDF_EXTENT_LENGTH_MASK) +
+			     blocksize - 1) & ~UDF_EXTENT_LENGTH_MASK) {
+				lip1->extLength = (lip1->extLength -
+						   (li->extLength &
+						   UDF_EXTENT_LENGTH_MASK) +
+						   UDF_EXTENT_LENGTH_MASK) &
+						   ~(blocksize - 1);
+				li->extLength = (li->extLength &
+						 UDF_EXTENT_FLAG_MASK) +
+						(UDF_EXTENT_LENGTH_MASK + 1) -
+						blocksize;
 			} else {
-				laarr[i].extLength = laarr[i + 1].extLength +
-					(((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-					  inode->i_sb->s_blocksize - 1) & ~(inode->i_sb->s_blocksize - 1));
+				li->extLength = lip1->extLength +
+					(((li->extLength &
+						UDF_EXTENT_LENGTH_MASK) +
+					  blocksize - 1) & ~(blocksize - 1));
 				if (*endnum > (i + 2))
 					memmove(&laarr[i + 1], &laarr[i + 2],
-						sizeof(long_ad) * (*endnum - (i + 2)));
+						sizeof(long_ad) *
+						(*endnum - (i + 2)));
 				i--;
 				(*endnum)--;
 			}
-		} else if ((laarr[i].extLength >> 30) == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
-			udf_free_blocks(inode->i_sb, inode, laarr[i].extLocation, 0,
-					((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-					 inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits);
-			laarr[i].extLocation.logicalBlockNum = 0;
-			laarr[i].extLocation.partitionReferenceNum = 0;
-			laarr[i].extLength = (laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) |
-				EXT_NOT_RECORDED_NOT_ALLOCATED;
+		} else if ((li->extLength >> 30) ==
+					(EXT_NOT_RECORDED_ALLOCATED >> 30)) {
+			udf_free_blocks(inode->i_sb, inode,
+					li->extLocation, 0,
+					((li->extLength &
+						UDF_EXTENT_LENGTH_MASK) +
+					 blocksize - 1) >> blocksize_bits);
+			li->extLocation.logicalBlockNum = 0;
+			li->extLocation.partitionReferenceNum = 0;
+			li->extLength = (li->extLength &
+						UDF_EXTENT_LENGTH_MASK) |
+						EXT_NOT_RECORDED_NOT_ALLOCATED;
 		}
 	}
 }
@@ -962,24 +1035,26 @@ void udf_truncate(struct inode *inode)
 
 	lock_kernel();
 	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB) {
-		if (inode->i_sb->s_blocksize < (udf_file_entry_alloc_offset(inode) +
-						inode->i_size)) {
+		if (inode->i_sb->s_blocksize <
+				(udf_file_entry_alloc_offset(inode) +
+				 inode->i_size)) {
 			udf_expand_file_adinicb(inode, inode->i_size, &err);
 			if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB) {
 				inode->i_size = UDF_I_LENALLOC(inode);
 				unlock_kernel();
 				return;
-			} else {
+			} else
 				udf_truncate_extents(inode);
-			}
 		} else {
 			offset = inode->i_size & (inode->i_sb->s_blocksize - 1);
-			memset(UDF_I_DATA(inode) + UDF_I_LENEATTR(inode) + offset, 0x00,
-			       inode->i_sb->s_blocksize - offset - udf_file_entry_alloc_offset(inode));
+			memset(UDF_I_DATA(inode) + UDF_I_LENEATTR(inode) +
+				offset, 0x00, inode->i_sb->s_blocksize -
+				offset - udf_file_entry_alloc_offset(inode));
 			UDF_I_LENALLOC(inode) = inode->i_size;
 		}
 	} else {
-		block_truncate_page(inode->i_mapping, inode->i_size, udf_get_block);
+		block_truncate_page(inode->i_mapping, inode->i_size,
+				    udf_get_block);
 		udf_truncate_extents(inode);
 	}
 
@@ -1019,8 +1094,8 @@ static void __udf_read_inode(struct inod
 
 	if (ident != TAG_IDENT_FE && ident != TAG_IDENT_EFE &&
 	    ident != TAG_IDENT_USE) {
-		printk(KERN_ERR "udf: udf_read_inode(ino %ld) failed ident=%d\n",
-		       inode->i_ino, ident);
+		printk(KERN_ERR "udf: udf_read_inode(ino %ld) "
+				"failed ident=%d\n", inode->i_ino, ident);
 		brelse(bh);
 		make_bad_inode(inode);
 		return;
@@ -1032,7 +1107,8 @@ static void __udf_read_inode(struct inod
 		struct buffer_head *ibh = NULL, *nbh = NULL;
 		struct indirectEntry *ie;
 
-		ibh = udf_read_ptagged(inode->i_sb, UDF_I_LOCATION(inode), 1, &ident);
+		ibh = udf_read_ptagged(inode->i_sb, UDF_I_LOCATION(inode), 1,
+					&ident);
 		if (ident == TAG_IDENT_IE) {
 			if (ibh) {
 				kernel_lb_addr loc;
@@ -1041,10 +1117,12 @@ static void __udf_read_inode(struct inod
 				loc = lelb_to_cpu(ie->indirectICB.extLocation);
 
 				if (ie->indirectICB.extLength &&
-				    (nbh = udf_read_ptagged(inode->i_sb, loc, 0, &ident))) {
+				    (nbh = udf_read_ptagged(inode->i_sb, loc, 0,
+							    &ident))) {
 					if (ident == TAG_IDENT_FE ||
 					    ident == TAG_IDENT_EFE) {
-						memcpy(&UDF_I_LOCATION(inode), &loc,
+						memcpy(&UDF_I_LOCATION(inode),
+						       &loc,
 						       sizeof(kernel_lb_addr));
 						brelse(bh);
 						brelse(ibh);
@@ -1091,7 +1169,8 @@ static void udf_fill_inode(struct inode 
 	else /* if (le16_to_cpu(fe->icbTag.strategyType) == 4096) */
 		UDF_I_STRAT4096(inode) = 1;
 
-	UDF_I_ALLOCTYPE(inode) = le16_to_cpu(fe->icbTag.flags) & ICBTAG_FLAG_AD_MASK;
+	UDF_I_ALLOCTYPE(inode) = le16_to_cpu(fe->icbTag.flags) &
+							ICBTAG_FLAG_AD_MASK;
 	UDF_I_UNIQUE(inode) = 0;
 	UDF_I_LENEATTR(inode) = 0;
 	UDF_I_LENEXTENTS(inode) = 0;
@@ -1101,16 +1180,20 @@ static void udf_fill_inode(struct inode 
 	if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_EFE) {
 		UDF_I_EFE(inode) = 1;
 		UDF_I_USE(inode) = 0;
-		if (udf_alloc_i_data(inode, inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry))) {
+		if (udf_alloc_i_data(inode, inode->i_sb->s_blocksize -
+					sizeof(struct extendedFileEntry))) {
 			make_bad_inode(inode);
 			return;
 		}
-		memcpy(UDF_I_DATA(inode), bh->b_data + sizeof(struct extendedFileEntry),
-		       inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry));
+		memcpy(UDF_I_DATA(inode),
+		       bh->b_data + sizeof(struct extendedFileEntry),
+		       inode->i_sb->s_blocksize -
+					sizeof(struct extendedFileEntry));
 	} else if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_FE) {
 		UDF_I_EFE(inode) = 0;
 		UDF_I_USE(inode) = 0;
-		if (udf_alloc_i_data(inode, inode->i_sb->s_blocksize - sizeof(struct fileEntry))) {
+		if (udf_alloc_i_data(inode, inode->i_sb->s_blocksize -
+						sizeof(struct fileEntry))) {
 			make_bad_inode(inode);
 			return;
 		}
@@ -1119,14 +1202,18 @@ static void udf_fill_inode(struct inode 
 	} else if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_USE) {
 		UDF_I_EFE(inode) = 0;
 		UDF_I_USE(inode) = 1;
-		UDF_I_LENALLOC(inode) =
-		    le32_to_cpu(((struct unallocSpaceEntry *)bh->b_data)->lengthAllocDescs);
-		if (udf_alloc_i_data(inode, inode->i_sb->s_blocksize - sizeof(struct unallocSpaceEntry))) {
+		UDF_I_LENALLOC(inode) = le32_to_cpu(
+				((struct unallocSpaceEntry *)bh->b_data)->
+				 lengthAllocDescs);
+		if (udf_alloc_i_data(inode, inode->i_sb->s_blocksize -
+					sizeof(struct unallocSpaceEntry))) {
 			make_bad_inode(inode);
 			return;
 		}
-		memcpy(UDF_I_DATA(inode), bh->b_data + sizeof(struct unallocSpaceEntry),
-		       inode->i_sb->s_blocksize - sizeof(struct unallocSpaceEntry));
+		memcpy(UDF_I_DATA(inode),
+		       bh->b_data + sizeof(struct unallocSpaceEntry),
+		       inode->i_sb->s_blocksize -
+					sizeof(struct unallocSpaceEntry));
 		return;
 	}
 
@@ -1223,7 +1310,8 @@ static void udf_fill_inode(struct inode 
 		UDF_I_UNIQUE(inode) = le64_to_cpu(efe->uniqueID);
 		UDF_I_LENEATTR(inode) = le32_to_cpu(efe->lengthExtendedAttr);
 		UDF_I_LENALLOC(inode) = le32_to_cpu(efe->lengthAllocDescs);
-		offset = sizeof(struct extendedFileEntry) + UDF_I_LENEATTR(inode);
+		offset = sizeof(struct extendedFileEntry) +
+							UDF_I_LENEATTR(inode);
 	}
 
 	switch (fe->icbTag.fileType) {
@@ -1262,21 +1350,22 @@ static void udf_fill_inode(struct inode 
 		inode->i_mode = S_IFLNK | S_IRWXUGO;
 		break;
 	default:
-		printk(KERN_ERR "udf: udf_fill_inode(ino %ld) failed unknown file type=%d\n",
-		       inode->i_ino, fe->icbTag.fileType);
+		printk(KERN_ERR "udf: udf_fill_inode(ino %ld) failed unknown "
+				"file type=%d\n", inode->i_ino,
+				fe->icbTag.fileType);
 		make_bad_inode(inode);
 		return;
 	}
 	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
-		struct deviceSpec *dsea = (struct deviceSpec *)udf_get_extendedattr(inode, 12, 1);
+		struct deviceSpec *dsea =
+			(struct deviceSpec *)udf_get_extendedattr(inode, 12, 1);
 		if (dsea) {
 			init_special_inode(inode, inode->i_mode,
-					   MKDEV(le32_to_cpu(dsea->majorDeviceIdent),
-						 le32_to_cpu(dsea->minorDeviceIdent)));
+				MKDEV(le32_to_cpu(dsea->majorDeviceIdent),
+				      le32_to_cpu(dsea->minorDeviceIdent)));
 			/* Developer ID ??? */
-		} else {
+		} else
 			make_bad_inode(inode);
-		}
 	}
 }
 
@@ -1285,8 +1374,8 @@ static int udf_alloc_i_data(struct inode
 	UDF_I_DATA(inode) = kmalloc(size, GFP_KERNEL);
 
 	if (!UDF_I_DATA(inode)) {
-		printk(KERN_ERR "udf:udf_alloc_i_data (ino %ld) no free memory\n",
-		       inode->i_ino);
+		printk(KERN_ERR "udf:udf_alloc_i_data (ino %ld) "
+				"no free memory\n", inode->i_ino);
 		return -ENOMEM;
 	}
 
@@ -1302,12 +1391,12 @@ static mode_t udf_convert_permissions(st
 	permissions = le32_to_cpu(fe->permissions);
 	flags = le16_to_cpu(fe->icbTag.flags);
 
-	mode =	(( permissions      ) & S_IRWXO) |
-		(( permissions >> 2 ) & S_IRWXG) |
-		(( permissions >> 4 ) & S_IRWXU) |
-		(( flags & ICBTAG_FLAG_SETUID) ? S_ISUID : 0) |
-		(( flags & ICBTAG_FLAG_SETGID) ? S_ISGID : 0) |
-		(( flags & ICBTAG_FLAG_STICKY) ? S_ISVTX : 0);
+	mode =	((permissions) & S_IRWXO) |
+		((permissions >> 2) & S_IRWXG) |
+		((permissions >> 4) & S_IRWXU) |
+		((flags & ICBTAG_FLAG_SETUID) ? S_ISUID : 0) |
+		((flags & ICBTAG_FLAG_SETGID) ? S_ISGID : 0) |
+		((flags & ICBTAG_FLAG_STICKY) ? S_ISVTX : 0);
 
 	return mode;
 }
@@ -1355,8 +1444,11 @@ static int udf_update_inode(struct inode
 	kernel_timestamp cpu_time;
 	int err = 0;
 	struct udf_sb_info *sbi = UDF_SB(inode->i_sb);
+	unsigned char blocksize_bits = inode->i_sb->s_blocksize_bits;
 
-	bh = udf_tread(inode->i_sb, udf_get_lb_pblock(inode->i_sb, UDF_I_LOCATION(inode), 0));
+	bh = udf_tread(inode->i_sb,
+			udf_get_lb_pblock(inode->i_sb,
+					  UDF_I_LOCATION(inode), 0));
 	if (!bh) {
 		udf_debug("bread failure\n");
 		return -EIO;
@@ -1372,18 +1464,24 @@ static int udf_update_inode(struct inode
 			(struct unallocSpaceEntry *)bh->b_data;
 
 		use->lengthAllocDescs = cpu_to_le32(UDF_I_LENALLOC(inode));
-		memcpy(bh->b_data + sizeof(struct unallocSpaceEntry), UDF_I_DATA(inode),
-		       inode->i_sb->s_blocksize - sizeof(struct unallocSpaceEntry));
-		crclen = sizeof(struct unallocSpaceEntry) + UDF_I_LENALLOC(inode) - sizeof(tag);
-		use->descTag.tagLocation = cpu_to_le32(UDF_I_LOCATION(inode).logicalBlockNum);
+		memcpy(bh->b_data + sizeof(struct unallocSpaceEntry),
+		       UDF_I_DATA(inode), inode->i_sb->s_blocksize -
+					sizeof(struct unallocSpaceEntry));
+		crclen = sizeof(struct unallocSpaceEntry) +
+				UDF_I_LENALLOC(inode) - sizeof(tag);
+		use->descTag.tagLocation = cpu_to_le32(
+						UDF_I_LOCATION(inode).
+							logicalBlockNum);
 		use->descTag.descCRCLength = cpu_to_le16(crclen);
-		use->descTag.descCRC = cpu_to_le16(udf_crc((char *)use + sizeof(tag), crclen, 0));
+		use->descTag.descCRC = cpu_to_le16(udf_crc((char *)use +
+							   sizeof(tag), crclen,
+							   0));
 
 		use->descTag.tagChecksum = 0;
-		for (i = 0; i < 16; i++) {
+		for (i = 0; i < 16; i++)
 			if (i != 4)
-				use->descTag.tagChecksum += ((uint8_t *)&(use->descTag))[i];
-		}
+				use->descTag.tagChecksum +=
+						((uint8_t *)&(use->descTag))[i];
 
 		mark_buffer_dirty(bh);
 		brelse(bh);
@@ -1400,14 +1498,14 @@ static int udf_update_inode(struct inode
 	else
 		fe->gid = cpu_to_le32(inode->i_gid);
 
-	udfperms =	((inode->i_mode & S_IRWXO)     ) |
-			((inode->i_mode & S_IRWXG) << 2) |
-			((inode->i_mode & S_IRWXU) << 4);
-
-	udfperms |=	(le32_to_cpu(fe->permissions) &
-			(FE_PERM_O_DELETE | FE_PERM_O_CHATTR |
-			 FE_PERM_G_DELETE | FE_PERM_G_CHATTR |
-			 FE_PERM_U_DELETE | FE_PERM_U_CHATTR));
+	udfperms = ((inode->i_mode & S_IRWXO)) |
+		   ((inode->i_mode & S_IRWXG) << 2) |
+		   ((inode->i_mode & S_IRWXU) << 4);
+
+	udfperms |= (le32_to_cpu(fe->permissions) &
+		    (FE_PERM_O_DELETE | FE_PERM_O_CHATTR |
+		     FE_PERM_G_DELETE | FE_PERM_G_CHATTR |
+		     FE_PERM_U_DELETE | FE_PERM_U_CHATTR));
 	fe->permissions = cpu_to_le32(udfperms);
 
 	if (S_ISDIR(inode->i_mode))
@@ -1428,8 +1526,9 @@ static int udf_update_inode(struct inode
 						     sizeof(regid), 12, 0x3);
 			dsea->attrType = cpu_to_le32(12);
 			dsea->attrSubtype = 1;
-			dsea->attrLength = cpu_to_le32(sizeof(struct deviceSpec) +
-						       sizeof(regid));
+			dsea->attrLength = cpu_to_le32(
+						sizeof(struct deviceSpec) +
+						sizeof(regid));
 			dsea->impUseLength = cpu_to_le32(sizeof(regid));
 		}
 		eid = (regid *)dsea->impUse;
@@ -1445,8 +1544,8 @@ static int udf_update_inode(struct inode
 		memcpy(bh->b_data + sizeof(struct fileEntry), UDF_I_DATA(inode),
 		       inode->i_sb->s_blocksize - sizeof(struct fileEntry));
 		fe->logicalBlocksRecorded = cpu_to_le64(
-			(inode->i_blocks + (1 << (inode->i_sb->s_blocksize_bits - 9)) - 1) >>
-			(inode->i_sb->s_blocksize_bits - 9));
+			(inode->i_blocks + (1 << (blocksize_bits - 9)) - 1) >>
+			(blocksize_bits - 9));
 
 		if (udf_time_to_stamp(&cpu_time, inode->i_atime))
 			fe->accessTime = cpu_to_lets(cpu_time);
@@ -1464,28 +1563,29 @@ static int udf_update_inode(struct inode
 		fe->descTag.tagIdent = cpu_to_le16(TAG_IDENT_FE);
 		crclen = sizeof(struct fileEntry);
 	} else {
-		memcpy(bh->b_data + sizeof(struct extendedFileEntry), UDF_I_DATA(inode),
-		       inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry));
+		memcpy(bh->b_data + sizeof(struct extendedFileEntry),
+		       UDF_I_DATA(inode),
+		       inode->i_sb->s_blocksize -
+					sizeof(struct extendedFileEntry));
 		efe->objectSize = cpu_to_le64(inode->i_size);
 		efe->logicalBlocksRecorded = cpu_to_le64(
-			(inode->i_blocks + (1 << (inode->i_sb->s_blocksize_bits - 9)) - 1) >>
-			(inode->i_sb->s_blocksize_bits - 9));
+			(inode->i_blocks + (1 << (blocksize_bits - 9)) - 1) >>
+			(blocksize_bits - 9));
 
 		if (UDF_I_CRTIME(inode).tv_sec > inode->i_atime.tv_sec ||
 		    (UDF_I_CRTIME(inode).tv_sec == inode->i_atime.tv_sec &&
-		     UDF_I_CRTIME(inode).tv_nsec > inode->i_atime.tv_nsec)) {
+		     UDF_I_CRTIME(inode).tv_nsec > inode->i_atime.tv_nsec))
 			UDF_I_CRTIME(inode) = inode->i_atime;
-		}
+
 		if (UDF_I_CRTIME(inode).tv_sec > inode->i_mtime.tv_sec ||
 		    (UDF_I_CRTIME(inode).tv_sec == inode->i_mtime.tv_sec &&
-		     UDF_I_CRTIME(inode).tv_nsec > inode->i_mtime.tv_nsec)) {
+		     UDF_I_CRTIME(inode).tv_nsec > inode->i_mtime.tv_nsec))
 			UDF_I_CRTIME(inode) = inode->i_mtime;
-		}
+
 		if (UDF_I_CRTIME(inode).tv_sec > inode->i_ctime.tv_sec ||
 		    (UDF_I_CRTIME(inode).tv_sec == inode->i_ctime.tv_sec &&
-		     UDF_I_CRTIME(inode).tv_nsec > inode->i_ctime.tv_nsec)) {
+		     UDF_I_CRTIME(inode).tv_nsec > inode->i_ctime.tv_nsec))
 			UDF_I_CRTIME(inode) = inode->i_ctime;
-		}
 
 		if (udf_time_to_stamp(&cpu_time, inode->i_atime))
 			efe->accessTime = cpu_to_lets(cpu_time);
@@ -1544,24 +1644,27 @@ static int udf_update_inode(struct inode
 	else
 		fe->descTag.descVersion = cpu_to_le16(2);
 	fe->descTag.tagSerialNum = cpu_to_le16(sbi->s_serial_number);
-	fe->descTag.tagLocation = cpu_to_le32(UDF_I_LOCATION(inode).logicalBlockNum);
+	fe->descTag.tagLocation = cpu_to_le32(
+					UDF_I_LOCATION(inode).logicalBlockNum);
 	crclen += UDF_I_LENEATTR(inode) + UDF_I_LENALLOC(inode) - sizeof(tag);
 	fe->descTag.descCRCLength = cpu_to_le16(crclen);
-	fe->descTag.descCRC = cpu_to_le16(udf_crc((char *)fe + sizeof(tag), crclen, 0));
+	fe->descTag.descCRC = cpu_to_le16(udf_crc((char *)fe + sizeof(tag),
+						  crclen, 0));
 
 	fe->descTag.tagChecksum = 0;
-	for (i = 0; i < 16; i++) {
+	for (i = 0; i < 16; i++)
 		if (i != 4)
-			fe->descTag.tagChecksum += ((uint8_t *)&(fe->descTag))[i];
-	}
+			fe->descTag.tagChecksum +=
+				((uint8_t *)&(fe->descTag))[i];
 
 	/* write the data blocks */
 	mark_buffer_dirty(bh);
 	if (do_sync) {
 		sync_dirty_buffer(bh);
 		if (buffer_req(bh) && !buffer_uptodate(bh)) {
-			printk("IO error syncing udf inode [%s:%08lx]\n",
-			       inode->i_sb->s_id, inode->i_ino);
+			printk(KERN_WARNING "IO error syncing udf inode "
+				"[%s:%08lx]\n", inode->i_sb->s_id,
+				inode->i_ino);
 			err = -EIO;
 		}
 	}
@@ -1587,7 +1690,8 @@ struct inode *udf_iget(struct super_bloc
 	if (is_bad_inode(inode))
 		goto out_iput;
 
-	if (ino.logicalBlockNum >= UDF_SB(sb)->s_partmaps[ino.partitionReferenceNum].s_partition_len) {
+	if (ino.logicalBlockNum >= UDF_SB(sb)->
+			s_partmaps[ino.partitionReferenceNum].s_partition_len) {
 		udf_debug("block=%d, partition=%d out of range\n",
 			  ino.logicalBlockNum, ino.partitionReferenceNum);
 		make_bad_inode(inode);
@@ -1601,7 +1705,7 @@ struct inode *udf_iget(struct super_bloc
 	return NULL;
 }
 
-int8_t udf_add_aext(struct inode * inode, struct extent_position * epos,
+int8_t udf_add_aext(struct inode *inode, struct extent_position *epos,
 		    kernel_lb_addr eloc, uint32_t elen, int inc)
 {
 	int adsize;
@@ -1612,7 +1716,9 @@ int8_t udf_add_aext(struct inode * inode
 	uint8_t *ptr;
 
 	if (!epos->bh)
-		ptr = UDF_I_DATA(inode) + epos->offset - udf_file_entry_alloc_offset(inode) + UDF_I_LENEATTR(inode);
+		ptr = UDF_I_DATA(inode) + epos->offset -
+			udf_file_entry_alloc_offset(inode) +
+			UDF_I_LENEATTR(inode);
 	else
 		ptr = epos->bh->b_data + epos->offset;
 
@@ -1629,15 +1735,16 @@ int8_t udf_add_aext(struct inode * inode
 		int err, loffset;
 		kernel_lb_addr obloc = epos->block;
 
-		if (!(epos->block.logicalBlockNum = udf_new_block(inode->i_sb, NULL,
-								  obloc.partitionReferenceNum,
-								  obloc.logicalBlockNum, &err))) {
+		epos->block.logicalBlockNum = udf_new_block(inode->i_sb, NULL,
+						obloc.partitionReferenceNum,
+						obloc.logicalBlockNum, &err);
+		if (!epos->block.logicalBlockNum)
 			return -1;
-		}
-		if (!(nbh = udf_tgetblk(inode->i_sb, udf_get_lb_pblock(inode->i_sb,
-								       epos->block, 0)))) {
+		nbh = udf_tgetblk(inode->i_sb, udf_get_lb_pblock(inode->i_sb,
+								 epos->block,
+								 0));
+		if (!nbh)
 			return -1;
-		}
 		lock_buffer(nbh);
 		memset(nbh->b_data, 0x00, inode->i_sb->s_blocksize);
 		set_buffer_uptodate(nbh);
@@ -1646,7 +1753,8 @@ int8_t udf_add_aext(struct inode * inode
 
 		aed = (struct allocExtDesc *)(nbh->b_data);
 		if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT))
-			aed->previousAllocExtLocation = cpu_to_le32(obloc.logicalBlockNum);
+			aed->previousAllocExtLocation =
+					cpu_to_le32(obloc.logicalBlockNum);
 		if (epos->offset + adsize > inode->i_sb->s_blocksize) {
 			loffset = epos->offset;
 			aed->lengthAllocDescs = cpu_to_le32(adsize);
@@ -1663,7 +1771,8 @@ int8_t udf_add_aext(struct inode * inode
 			if (epos->bh) {
 				aed = (struct allocExtDesc *)epos->bh->b_data;
 				aed->lengthAllocDescs =
-					cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) + adsize);
+					cpu_to_le32(le32_to_cpu(
+					aed->lengthAllocDescs) + adsize);
 			} else {
 				UDF_I_LENALLOC(inode) += adsize;
 				mark_inode_dirty(inode);
@@ -1680,7 +1789,8 @@ int8_t udf_add_aext(struct inode * inode
 			sad = (short_ad *)sptr;
 			sad->extLength = cpu_to_le32(EXT_NEXT_EXTENT_ALLOCDECS |
 						     inode->i_sb->s_blocksize);
-			sad->extPosition = cpu_to_le32(epos->block.logicalBlockNum);
+			sad->extPosition =
+				cpu_to_le32(epos->block.logicalBlockNum);
 			break;
 		case ICBTAG_FLAG_AD_LONG:
 			lad = (long_ad *)sptr;
@@ -1695,7 +1805,8 @@ int8_t udf_add_aext(struct inode * inode
 			    UDF_SB(inode->i_sb)->s_udfrev >= 0x0201)
 				udf_update_tag(epos->bh->b_data, loffset);
 			else
-				udf_update_tag(epos->bh->b_data, sizeof(struct allocExtDesc));
+				udf_update_tag(epos->bh->b_data,
+						sizeof(struct allocExtDesc));
 			mark_buffer_dirty_inode(epos->bh, inode);
 			brelse(epos->bh);
 		} else {
@@ -1712,18 +1823,22 @@ int8_t udf_add_aext(struct inode * inode
 	} else {
 		aed = (struct allocExtDesc *)epos->bh->b_data;
 		aed->lengthAllocDescs =
-			cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) + adsize);
-		if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) || UDF_SB(inode->i_sb)->s_udfrev >= 0x0201)
-			udf_update_tag(epos->bh->b_data, epos->offset + (inc ? 0 : adsize));
+			cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) +
+				    adsize);
+		if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
+				UDF_SB(inode->i_sb)->s_udfrev >= 0x0201)
+			udf_update_tag(epos->bh->b_data,
+					epos->offset + (inc ? 0 : adsize));
 		else
-			udf_update_tag(epos->bh->b_data, sizeof(struct allocExtDesc));
+			udf_update_tag(epos->bh->b_data,
+					sizeof(struct allocExtDesc));
 		mark_buffer_dirty_inode(epos->bh, inode);
 	}
 
 	return etype;
 }
 
-int8_t udf_write_aext(struct inode * inode, struct extent_position * epos,
+int8_t udf_write_aext(struct inode *inode, struct extent_position *epos,
 		      kernel_lb_addr eloc, uint32_t elen, int inc)
 {
 	int adsize;
@@ -1732,7 +1847,9 @@ int8_t udf_write_aext(struct inode * ino
 	long_ad *lad;
 
 	if (!epos->bh)
-		ptr = UDF_I_DATA(inode) + epos->offset - udf_file_entry_alloc_offset(inode) + UDF_I_LENEATTR(inode);
+		ptr = UDF_I_DATA(inode) + epos->offset -
+			udf_file_entry_alloc_offset(inode) +
+			UDF_I_LENEATTR(inode);
 	else
 		ptr = epos->bh->b_data + epos->offset;
 
@@ -1757,9 +1874,11 @@ int8_t udf_write_aext(struct inode * ino
 	if (epos->bh) {
 		if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
 		    UDF_SB(inode->i_sb)->s_udfrev >= 0x0201) {
-			struct allocExtDesc *aed = (struct allocExtDesc *)epos->bh->b_data;
+			struct allocExtDesc *aed =
+				(struct allocExtDesc *)epos->bh->b_data;
 			udf_update_tag(epos->bh->b_data,
-				       le32_to_cpu(aed->lengthAllocDescs) + sizeof(struct allocExtDesc));
+				       le32_to_cpu(aed->lengthAllocDescs) +
+				       sizeof(struct allocExtDesc));
 		}
 		mark_buffer_dirty_inode(epos->bh, inode);
 	} else {
@@ -1772,19 +1891,21 @@ int8_t udf_write_aext(struct inode * ino
 	return (elen >> 30);
 }
 
-int8_t udf_next_aext(struct inode * inode, struct extent_position * epos,
-		     kernel_lb_addr * eloc, uint32_t * elen, int inc)
+int8_t udf_next_aext(struct inode *inode, struct extent_position *epos,
+		     kernel_lb_addr *eloc, uint32_t *elen, int inc)
 {
 	int8_t etype;
 
 	while ((etype = udf_current_aext(inode, epos, eloc, elen, inc)) ==
 	       (EXT_NEXT_EXTENT_ALLOCDECS >> 30)) {
+		int block;
 		epos->block = *eloc;
 		epos->offset = sizeof(struct allocExtDesc);
 		brelse(epos->bh);
-		if (!(epos->bh = udf_tread(inode->i_sb, udf_get_lb_pblock(inode->i_sb, epos->block, 0)))) {
-			udf_debug("reading block %d failed!\n",
-				  udf_get_lb_pblock(inode->i_sb, epos->block, 0));
+		block = udf_get_lb_pblock(inode->i_sb, epos->block, 0);
+		epos->bh = udf_tread(inode->i_sb, block);
+		if (!epos->bh) {
+			udf_debug("reading block %d failed!\n", block);
 			return -1;
 		}
 	}
@@ -1792,8 +1913,8 @@ int8_t udf_next_aext(struct inode * inod
 	return etype;
 }
 
-int8_t udf_current_aext(struct inode * inode, struct extent_position * epos,
-			kernel_lb_addr * eloc, uint32_t * elen, int inc)
+int8_t udf_current_aext(struct inode *inode, struct extent_position *epos,
+			kernel_lb_addr *eloc, uint32_t *elen, int inc)
 {
 	int alen;
 	int8_t etype;
@@ -1801,38 +1922,45 @@ int8_t udf_current_aext(struct inode * i
 	short_ad *sad;
 	long_ad *lad;
 
-
 	if (!epos->bh) {
 		if (!epos->offset)
 			epos->offset = udf_file_entry_alloc_offset(inode);
-		ptr = UDF_I_DATA(inode) + epos->offset - udf_file_entry_alloc_offset(inode) + UDF_I_LENEATTR(inode);
-		alen = udf_file_entry_alloc_offset(inode) + UDF_I_LENALLOC(inode);
+		ptr = UDF_I_DATA(inode) + epos->offset -
+			udf_file_entry_alloc_offset(inode) +
+			UDF_I_LENEATTR(inode);
+		alen = udf_file_entry_alloc_offset(inode) +
+							UDF_I_LENALLOC(inode);
 	} else {
 		if (!epos->offset)
 			epos->offset = sizeof(struct allocExtDesc);
 		ptr = epos->bh->b_data + epos->offset;
 		alen = sizeof(struct allocExtDesc) +
-			le32_to_cpu(((struct allocExtDesc *)epos->bh->b_data)->lengthAllocDescs);
+			le32_to_cpu(((struct allocExtDesc *)epos->bh->b_data)->
+							lengthAllocDescs);
 	}
 
 	switch (UDF_I_ALLOCTYPE(inode)) {
 	case ICBTAG_FLAG_AD_SHORT:
-		if (!(sad = udf_get_fileshortad(ptr, alen, &epos->offset, inc)))
+		sad = udf_get_fileshortad(ptr, alen, &epos->offset, inc);
+		if (!sad)
 			return -1;
 		etype = le32_to_cpu(sad->extLength) >> 30;
 		eloc->logicalBlockNum = le32_to_cpu(sad->extPosition);
-		eloc->partitionReferenceNum = UDF_I_LOCATION(inode).partitionReferenceNum;
+		eloc->partitionReferenceNum =
+				UDF_I_LOCATION(inode).partitionReferenceNum;
 		*elen = le32_to_cpu(sad->extLength) & UDF_EXTENT_LENGTH_MASK;
 		break;
 	case ICBTAG_FLAG_AD_LONG:
-		if (!(lad = udf_get_filelongad(ptr, alen, &epos->offset, inc)))
+		lad = udf_get_filelongad(ptr, alen, &epos->offset, inc);
+		if (!lad)
 			return -1;
 		etype = le32_to_cpu(lad->extLength) >> 30;
 		*eloc = lelb_to_cpu(lad->extLocation);
 		*elen = le32_to_cpu(lad->extLength) & UDF_EXTENT_LENGTH_MASK;
 		break;
 	default:
-		udf_debug("alloc_type = %d unsupported\n", UDF_I_ALLOCTYPE(inode));
+		udf_debug("alloc_type = %d unsupported\n",
+				UDF_I_ALLOCTYPE(inode));
 		return -1;
 	}
 
@@ -1860,7 +1988,7 @@ static int8_t udf_insert_aext(struct ino
 	return (nelen >> 30);
 }
 
-int8_t udf_delete_aext(struct inode * inode, struct extent_position epos,
+int8_t udf_delete_aext(struct inode *inode, struct extent_position epos,
 		       kernel_lb_addr eloc, uint32_t elen)
 {
 	struct extent_position oepos;
@@ -1907,12 +2035,15 @@ int8_t udf_delete_aext(struct inode * in
 		} else {
 			aed = (struct allocExtDesc *)oepos.bh->b_data;
 			aed->lengthAllocDescs =
-				cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) - (2 * adsize));
+				cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) -
+					    (2 * adsize));
 			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
 			    UDF_SB(inode->i_sb)->s_udfrev >= 0x0201)
-				udf_update_tag(oepos.bh->b_data, oepos.offset - (2 * adsize));
+				udf_update_tag(oepos.bh->b_data,
+						oepos.offset - (2 * adsize));
 			else
-				udf_update_tag(oepos.bh->b_data, sizeof(struct allocExtDesc));
+				udf_update_tag(oepos.bh->b_data,
+						sizeof(struct allocExtDesc));
 			mark_buffer_dirty_inode(oepos.bh, inode);
 		}
 	} else {
@@ -1923,12 +2054,15 @@ int8_t udf_delete_aext(struct inode * in
 		} else {
 			aed = (struct allocExtDesc *)oepos.bh->b_data;
 			aed->lengthAllocDescs =
-				cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) - adsize);
+				cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) -
+					    adsize);
 			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
 			    UDF_SB(inode->i_sb)->s_udfrev >= 0x0201)
-				udf_update_tag(oepos.bh->b_data, epos.offset - adsize);
+				udf_update_tag(oepos.bh->b_data,
+						epos.offset - adsize);
 			else
-				udf_update_tag(oepos.bh->b_data, sizeof(struct allocExtDesc));
+				udf_update_tag(oepos.bh->b_data,
+						sizeof(struct allocExtDesc));
 			mark_buffer_dirty_inode(oepos.bh, inode);
 		}
 	}
@@ -1939,12 +2073,13 @@ int8_t udf_delete_aext(struct inode * in
 	return (elen >> 30);
 }
 
-int8_t inode_bmap(struct inode * inode, sector_t block,
-		  struct extent_position * pos, kernel_lb_addr * eloc,
-		  uint32_t * elen, sector_t * offset)
+int8_t inode_bmap(struct inode *inode, sector_t block,
+		  struct extent_position *pos, kernel_lb_addr *eloc,
+		  uint32_t *elen, sector_t *offset)
 {
+	unsigned char blocksize_bits = inode->i_sb->s_blocksize_bits;
 	loff_t lbcount = 0, bcount =
-	    (loff_t) block << inode->i_sb->s_blocksize_bits;
+	    (loff_t) block << blocksize_bits;
 	int8_t etype;
 
 	if (block < 0) {
@@ -1958,15 +2093,16 @@ int8_t inode_bmap(struct inode * inode, 
 	*elen = 0;
 
 	do {
-		if ((etype = udf_next_aext(inode, pos, eloc, elen, 1)) == -1) {
-			*offset = (bcount - lbcount) >> inode->i_sb->s_blocksize_bits;
+		etype = udf_next_aext(inode, pos, eloc, elen, 1);
+		if (etype == -1) {
+			*offset = (bcount - lbcount) >> blocksize_bits;
 			UDF_I_LENEXTENTS(inode) = lbcount;
 			return -1;
 		}
 		lbcount += *elen;
 	} while (lbcount <= bcount);
 
-	*offset = (bcount + *elen - lbcount) >> inode->i_sb->s_blocksize_bits;
+	*offset = (bcount + *elen - lbcount) >> blocksize_bits;
 
 	return etype;
 }
@@ -1981,7 +2117,8 @@ long udf_block_map(struct inode *inode, 
 
 	lock_kernel();
 
-	if (inode_bmap(inode, block, &epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30))
+	if (inode_bmap(inode, block, &epos, &eloc, &elen, &offset) ==
+						(EXT_RECORDED_ALLOCATED >> 30))
 		ret = udf_get_lb_pblock(inode->i_sb, eloc, offset);
 	else
 		ret = 0;
diff -puN fs/udf/misc.c~udf-fix-coding-style fs/udf/misc.c
--- a/fs/udf/misc.c~udf-fix-coding-style
+++ a/fs/udf/misc.c
@@ -70,71 +70,84 @@ struct genericFormat *udf_add_extendedat
 		struct extendedAttrHeaderDesc *eahd;
 		eahd = (struct extendedAttrHeaderDesc *)ea;
 
-		if (UDF_I_LENALLOC(inode)) {
+		if (UDF_I_LENALLOC(inode))
 			memmove(&ad[size], ad, UDF_I_LENALLOC(inode));
-		}
 
 		if (UDF_I_LENEATTR(inode)) {
 			/* check checksum/crc */
-			if (le16_to_cpu(eahd->descTag.tagIdent) != TAG_IDENT_EAHD ||
-			    le32_to_cpu(eahd->descTag.tagLocation) != UDF_I_LOCATION(inode).logicalBlockNum) {
+			if (le16_to_cpu(eahd->descTag.tagIdent) !=
+					TAG_IDENT_EAHD ||
+			    le32_to_cpu(eahd->descTag.tagLocation) !=
+					UDF_I_LOCATION(inode).logicalBlockNum)
 				return NULL;
-			}
 		} else {
 			struct udf_sb_info *sbi = UDF_SB(inode->i_sb);
 
 			size -= sizeof(struct extendedAttrHeaderDesc);
-			UDF_I_LENEATTR(inode) += sizeof(struct extendedAttrHeaderDesc);
+			UDF_I_LENEATTR(inode) +=
+				sizeof(struct extendedAttrHeaderDesc);
 			eahd->descTag.tagIdent = cpu_to_le16(TAG_IDENT_EAHD);
 			if (sbi->s_udfrev >= 0x0200)
 				eahd->descTag.descVersion = cpu_to_le16(3);
 			else
 				eahd->descTag.descVersion = cpu_to_le16(2);
-			eahd->descTag.tagSerialNum = cpu_to_le16(sbi->s_serial_number);
-			eahd->descTag.tagLocation = cpu_to_le32(UDF_I_LOCATION(inode).logicalBlockNum);
+			eahd->descTag.tagSerialNum =
+					cpu_to_le16(sbi->s_serial_number);
+			eahd->descTag.tagLocation = cpu_to_le32(
+					UDF_I_LOCATION(inode).logicalBlockNum);
 			eahd->impAttrLocation = cpu_to_le32(0xFFFFFFFF);
 			eahd->appAttrLocation = cpu_to_le32(0xFFFFFFFF);
 		}
 
 		offset = UDF_I_LENEATTR(inode);
 		if (type < 2048) {
-			if (le32_to_cpu(eahd->appAttrLocation) < UDF_I_LENEATTR(inode)) {
-				uint32_t aal = le32_to_cpu(eahd->appAttrLocation);
+			if (le32_to_cpu(eahd->appAttrLocation) <
+					UDF_I_LENEATTR(inode)) {
+				uint32_t aal =
+					le32_to_cpu(eahd->appAttrLocation);
 				memmove(&ea[offset - aal + size],
 					&ea[aal], offset - aal);
 				offset -= aal;
-				eahd->appAttrLocation = cpu_to_le32(aal + size);
+				eahd->appAttrLocation =
+						cpu_to_le32(aal + size);
 			}
-			if (le32_to_cpu(eahd->impAttrLocation) < UDF_I_LENEATTR(inode)) {
-				uint32_t ial = le32_to_cpu(eahd->impAttrLocation);
+			if (le32_to_cpu(eahd->impAttrLocation) <
+					UDF_I_LENEATTR(inode)) {
+				uint32_t ial =
+					le32_to_cpu(eahd->impAttrLocation);
 				memmove(&ea[offset - ial + size],
 					&ea[ial], offset - ial);
 				offset -= ial;
-				eahd->impAttrLocation = cpu_to_le32(ial + size);
+				eahd->impAttrLocation =
+						cpu_to_le32(ial + size);
 			}
 		} else if (type < 65536) {
-			if (le32_to_cpu(eahd->appAttrLocation) < UDF_I_LENEATTR(inode)) {
-				uint32_t aal = le32_to_cpu(eahd->appAttrLocation);
+			if (le32_to_cpu(eahd->appAttrLocation) <
+					UDF_I_LENEATTR(inode)) {
+				uint32_t aal =
+					le32_to_cpu(eahd->appAttrLocation);
 				memmove(&ea[offset - aal + size],
 					&ea[aal], offset - aal);
 				offset -= aal;
-				eahd->appAttrLocation = cpu_to_le32(aal + size);
+				eahd->appAttrLocation =
+						cpu_to_le32(aal + size);
 			}
 		}
 		/* rewrite CRC + checksum of eahd */
 		crclen = sizeof(struct extendedAttrHeaderDesc) - sizeof(tag);
 		eahd->descTag.descCRCLength = cpu_to_le16(crclen);
 		eahd->descTag.descCRC = cpu_to_le16(udf_crc((char *)eahd +
-							    sizeof(tag), crclen, 0));
+						sizeof(tag), crclen, 0));
 		eahd->descTag.tagChecksum = 0;
 		for (i = 0; i < 16; i++)
 			if (i != 4)
-				eahd->descTag.tagChecksum += ((uint8_t *)&(eahd->descTag))[i];
+				eahd->descTag.tagChecksum +=
+					((uint8_t *)&(eahd->descTag))[i];
 		UDF_I_LENEATTR(inode) += size;
 		return (struct genericFormat *)&ea[offset];
 	}
-	if (loc & 0x02) {
-	}
+	if (loc & 0x02)
+		;
 
 	return NULL;
 }
@@ -153,10 +166,11 @@ struct genericFormat *udf_get_extendedat
 		eahd = (struct extendedAttrHeaderDesc *)ea;
 
 		/* check checksum/crc */
-		if (le16_to_cpu(eahd->descTag.tagIdent) != TAG_IDENT_EAHD ||
-		    le32_to_cpu(eahd->descTag.tagLocation) != UDF_I_LOCATION(inode).logicalBlockNum) {
+		if (le16_to_cpu(eahd->descTag.tagIdent) !=
+				TAG_IDENT_EAHD ||
+		    le32_to_cpu(eahd->descTag.tagLocation) !=
+				UDF_I_LOCATION(inode).logicalBlockNum)
 			return NULL;
-		}
 
 		if (type < 2048)
 			offset = sizeof(struct extendedAttrHeaderDesc);
@@ -167,7 +181,8 @@ struct genericFormat *udf_get_extendedat
 
 		while (offset < UDF_I_LENEATTR(inode)) {
 			gaf = (struct genericFormat *)&ea[offset];
-			if (le32_to_cpu(gaf->attrType) == type && gaf->attrSubtype == subtype)
+			if (le32_to_cpu(gaf->attrType) == type &&
+					gaf->attrSubtype == subtype)
 				return gaf;
 			else
 				offset += le32_to_cpu(gaf->attrLength);
@@ -188,7 +203,7 @@ struct genericFormat *udf_get_extendedat
  *	Written, tested, and released.
  */
 struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
-				    uint32_t location, uint16_t * ident)
+				    uint32_t location, uint16_t *ident)
 {
 	tag *tag_p;
 	struct buffer_head *bh = NULL;
@@ -213,7 +228,8 @@ struct buffer_head *udf_read_tagged(stru
 
 	if (location != le32_to_cpu(tag_p->tagLocation)) {
 		udf_debug("location mismatch block %u, tag %u != %u\n",
-			  block + sbi->s_session, le32_to_cpu(tag_p->tagLocation), location);
+			  block + sbi->s_session,
+			  le32_to_cpu(tag_p->tagLocation), location);
 		goto error_out;
 	}
 
@@ -239,9 +255,9 @@ struct buffer_head *udf_read_tagged(stru
 	/* Verify the descriptor CRC */
 	if (le16_to_cpu(tag_p->descCRCLength) + sizeof(tag) > sb->s_blocksize ||
 	    le16_to_cpu(tag_p->descCRC) == udf_crc(bh->b_data + sizeof(tag),
-						   le16_to_cpu(tag_p->descCRCLength), 0)) {
+					le16_to_cpu(tag_p->descCRCLength), 0))
 		return bh;
-	}
+
 	udf_debug("Crc failure block %d: crc = %d, crclen = %d\n",
 		  block + sbi->s_session, le16_to_cpu(tag_p->descCRC),
 		  le16_to_cpu(tag_p->descCRCLength));
@@ -252,7 +268,7 @@ error_out:
 }
 
 struct buffer_head *udf_read_ptagged(struct super_block *sb, kernel_lb_addr loc,
-				     uint32_t offset, uint16_t * ident)
+				     uint32_t offset, uint16_t *ident)
 {
 	return udf_read_tagged(sb, udf_get_lb_pblock(sb, loc, offset),
 			       loc.logicalBlockNum + offset, ident);
diff -puN fs/udf/namei.c~udf-fix-coding-style fs/udf/namei.c
--- a/fs/udf/namei.c~udf-fix-coding-style
+++ a/fs/udf/namei.c
@@ -43,7 +43,7 @@ static inline int udf_match(int len1, co
 
 int udf_write_fi(struct inode *inode, struct fileIdentDesc *cfi,
 		 struct fileIdentDesc *sfi, struct udf_fileident_bh *fibh,
-		 uint8_t * impuse, uint8_t * fileident)
+		 uint8_t *impuse, uint8_t *fileident)
 {
 	uint16_t crclen = fibh->eoffset - fibh->soffset - sizeof(tag);
 	uint16_t crc;
@@ -68,7 +68,8 @@ int udf_write_fi(struct inode *inode, st
 			memcpy(fibh->ebh->b_data + offset, impuse, liu);
 		} else {
 			memcpy((uint8_t *)sfi->impUse, impuse, -offset);
-			memcpy(fibh->ebh->b_data, impuse - offset, liu + offset);
+			memcpy(fibh->ebh->b_data, impuse - offset,
+				liu + offset);
 		}
 	}
 
@@ -80,8 +81,10 @@ int udf_write_fi(struct inode *inode, st
 		} else if (offset >= 0) {
 			memcpy(fibh->ebh->b_data + offset, fileident, lfi);
 		} else {
-			memcpy((uint8_t *)sfi->fileIdent + liu, fileident, -offset);
-			memcpy(fibh->ebh->b_data, fileident - offset, lfi + offset);
+			memcpy((uint8_t *)sfi->fileIdent + liu, fileident,
+				-offset);
+			memcpy(fibh->ebh->b_data, fileident - offset,
+				lfi + offset);
 		}
 	}
 
@@ -101,13 +104,19 @@ int udf_write_fi(struct inode *inode, st
 
 	if (fibh->sbh == fibh->ebh) {
 		crc = udf_crc((uint8_t *)sfi->impUse,
-			      crclen + sizeof(tag) - sizeof(struct fileIdentDesc), crc);
+			      crclen + sizeof(tag) -
+			      sizeof(struct fileIdentDesc), crc);
 	} else if (sizeof(struct fileIdentDesc) >= -fibh->soffset) {
-		crc = udf_crc(fibh->ebh->b_data + sizeof(struct fileIdentDesc) + fibh->soffset,
-			      crclen + sizeof(tag) - sizeof(struct fileIdentDesc), crc);
+		crc = udf_crc(fibh->ebh->b_data +
+					sizeof(struct fileIdentDesc) +
+					fibh->soffset,
+			      crclen + sizeof(tag) -
+					sizeof(struct fileIdentDesc),
+			      crc);
 	} else {
 		crc = udf_crc((uint8_t *)sfi->impUse,
-			      -fibh->soffset - sizeof(struct fileIdentDesc), crc);
+			      -fibh->soffset - sizeof(struct fileIdentDesc),
+			      crc);
 		crc = udf_crc(fibh->ebh->b_data, fibh->eoffset, crc);
 	}
 
@@ -121,7 +130,8 @@ int udf_write_fi(struct inode *inode, st
 
 	cfi->descTag.tagChecksum = checksum;
 	if (adinicb || (sizeof(struct fileIdentDesc) <= -fibh->soffset)) {
-		memcpy((uint8_t *)sfi, (uint8_t *)cfi, sizeof(struct fileIdentDesc));
+		memcpy((uint8_t *)sfi, (uint8_t *)cfi,
+			sizeof(struct fileIdentDesc));
 	} else {
 		memcpy((uint8_t *)sfi, (uint8_t *)cfi, -fibh->soffset);
 		memcpy(fibh->ebh->b_data, (uint8_t *)cfi - fibh->soffset,
@@ -159,22 +169,24 @@ static struct fileIdentDesc *udf_find_en
 	size = (udf_ext0_offset(dir) + dir->i_size) >> 2;
 	f_pos = (udf_ext0_offset(dir) >> 2);
 
-	fibh->soffset = fibh->eoffset = (f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
-	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
+	fibh->soffset = fibh->eoffset =
+		(f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
+	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
 		fibh->sbh = fibh->ebh = NULL;
-	} else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
-			      &epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
+	else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
+			      &epos, &eloc, &elen, &offset) ==
+					(EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
 		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
 			if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_SHORT)
 				epos.offset -= sizeof(short_ad);
 			else if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_LONG)
 				epos.offset -= sizeof(long_ad);
-		} else {
+		} else
 			offset = 0;
-		}
 
-		if (!(fibh->sbh = fibh->ebh = udf_tread(dir->i_sb, block))) {
+		fibh->sbh = fibh->ebh = udf_tread(dir->i_sb, block);
+		if (!fibh->sbh) {
 			brelse(epos.bh);
 			return NULL;
 		}
@@ -202,14 +214,18 @@ static struct fileIdentDesc *udf_find_en
 		} else {
 			int poffset;	/* Unpaded ending offset */
 
-			poffset = fibh->soffset + sizeof(struct fileIdentDesc) + liu + lfi;
+			poffset = fibh->soffset + sizeof(struct fileIdentDesc) +
+					liu + lfi;
 
-			if (poffset >= lfi) {
-				nameptr = (uint8_t *)(fibh->ebh->b_data + poffset - lfi);
-			} else {
+			if (poffset >= lfi)
+				nameptr = (uint8_t *)(fibh->ebh->b_data +
+						      poffset - lfi);
+			else {
 				nameptr = fname;
-				memcpy(nameptr, fi->fileIdent + liu, lfi - poffset);
-				memcpy(nameptr + lfi - poffset, fibh->ebh->b_data, poffset);
+				memcpy(nameptr, fi->fileIdent + liu,
+					lfi - poffset);
+				memcpy(nameptr + lfi - poffset,
+					fibh->ebh->b_data, poffset);
 			}
 		}
 
@@ -226,11 +242,11 @@ static struct fileIdentDesc *udf_find_en
 		if (!lfi)
 			continue;
 
-		if ((flen = udf_get_filename(dir->i_sb, nameptr, fname, lfi))) {
-			if (udf_match(flen, fname, dentry->d_name.len, dentry->d_name.name)) {
-				brelse(epos.bh);
-				return fi;
-			}
+		flen = udf_get_filename(dir->i_sb, nameptr, fname, lfi);
+		if (flen && udf_match(flen, fname, dentry->d_name.len,
+				      dentry->d_name.name)) {
+			brelse(epos.bh);
+			return fi;
 		}
 	}
 
@@ -291,16 +307,16 @@ static struct dentry *udf_lookup(struct 
 	if (!strncmp(dentry->d_name.name, ".B=", 3)) {
 		kernel_lb_addr lb = {
 			.logicalBlockNum = 0,
-			.partitionReferenceNum = simple_strtoul(dentry->d_name.name + 3,
-								NULL, 0),
+			.partitionReferenceNum =
+				simple_strtoul(dentry->d_name.name + 3,
+						NULL, 0),
 		};
 		inode = udf_iget(dir->i_sb, lb);
 		if (!inode) {
 			unlock_kernel();
 			return ERR_PTR(-EACCES);
 		}
-	}
-	else
+	} else
 #endif /* UDF_RECOVERY */
 
 	if (udf_find_entry(dir, dentry, &fibh, &cfi)) {
@@ -347,8 +363,9 @@ static struct fileIdentDesc *udf_add_ent
 			*err = -EINVAL;
 			return NULL;
 		}
-		if (!(namelen = udf_put_filename(sb, dentry->d_name.name, name,
-						 dentry->d_name.len))) {
+		namelen = udf_put_filename(sb, dentry->d_name.name, name,
+						 dentry->d_name.len);
+		if (!namelen) {
 			*err = -ENAMETOOLONG;
 			return NULL;
 		}
@@ -360,22 +377,24 @@ static struct fileIdentDesc *udf_add_ent
 
 	f_pos = (udf_ext0_offset(dir) >> 2);
 
-	fibh->soffset = fibh->eoffset = (f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
-	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
+	fibh->soffset = fibh->eoffset =
+			(f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
+	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
 		fibh->sbh = fibh->ebh = NULL;
-	} else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
-			      &epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
+	else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
+			      &epos, &eloc, &elen, &offset) ==
+					(EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
 		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
 			if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_SHORT)
 				epos.offset -= sizeof(short_ad);
 			else if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_LONG)
 				epos.offset -= sizeof(long_ad);
-		} else {
+		} else
 			offset = 0;
-		}
 
-		if (!(fibh->sbh = fibh->ebh = udf_tread(dir->i_sb, block))) {
+		fibh->sbh = fibh->ebh = udf_tread(dir->i_sb, block);
+		if (!fibh->sbh) {
 			brelse(epos.bh);
 			*err = -EIO;
 			return NULL;
@@ -406,33 +425,39 @@ static struct fileIdentDesc *udf_add_ent
 		liu = le16_to_cpu(cfi->lengthOfImpUse);
 		lfi = cfi->lengthFileIdent;
 
-		if (fibh->sbh == fibh->ebh) {
+		if (fibh->sbh == fibh->ebh)
 			nameptr = fi->fileIdent + liu;
-		} else {
+		else {
 			int poffset;	/* Unpaded ending offset */
 
-			poffset = fibh->soffset + sizeof(struct fileIdentDesc) + liu + lfi;
+			poffset = fibh->soffset + sizeof(struct fileIdentDesc) +
+					liu + lfi;
 
-			if (poffset >= lfi) {
-				nameptr = (char *)(fibh->ebh->b_data + poffset - lfi);
-			} else {
+			if (poffset >= lfi)
+				nameptr = (char *)(fibh->ebh->b_data +
+						   poffset - lfi);
+			else {
 				nameptr = fname;
-				memcpy(nameptr, fi->fileIdent + liu, lfi - poffset);
-				memcpy(nameptr + lfi - poffset, fibh->ebh->b_data, poffset);
+				memcpy(nameptr, fi->fileIdent + liu,
+					lfi - poffset);
+				memcpy(nameptr + lfi - poffset,
+					fibh->ebh->b_data, poffset);
 			}
 		}
 
 		if ((cfi->fileCharacteristics & FID_FILE_CHAR_DELETED) != 0) {
-			if (((sizeof(struct fileIdentDesc) + liu + lfi + 3) & ~3) == nfidlen) {
+			if (((sizeof(struct fileIdentDesc) +
+					liu + lfi + 3) & ~3) == nfidlen) {
 				brelse(epos.bh);
 				cfi->descTag.tagSerialNum = cpu_to_le16(1);
 				cfi->fileVersionNum = cpu_to_le16(1);
 				cfi->fileCharacteristics = 0;
 				cfi->lengthFileIdent = namelen;
 				cfi->lengthOfImpUse = cpu_to_le16(0);
-				if (!udf_write_fi(dir, cfi, fi, fibh, NULL, name)) {
+				if (!udf_write_fi(dir, cfi, fi, fibh, NULL,
+						  name))
 					return fi;
-				} else {
+				else {
 					*err = -EIO;
 					return NULL;
 				}
@@ -442,8 +467,9 @@ static struct fileIdentDesc *udf_add_ent
 		if (!lfi || !dentry)
 			continue;
 
-		if ((flen = udf_get_filename(dir->i_sb, nameptr, fname, lfi)) &&
-		    udf_match(flen, fname, dentry->d_name.len, dentry->d_name.name)) {
+		flen = udf_get_filename(dir->i_sb, nameptr, fname, lfi);
+		if (flen && udf_match(flen, fname, dentry->d_name.len,
+				      dentry->d_name.name)) {
 			if (fibh->sbh != fibh->ebh)
 				brelse(fibh->ebh);
 			brelse(fibh->sbh);
@@ -466,11 +492,14 @@ add:
 		if (fibh->sbh != fibh->ebh)
 			brelse(fibh->ebh);
 		brelse(fibh->sbh);
-		if (!(fibh->sbh = fibh->ebh = udf_expand_dir_adinicb(dir, &block, err)))
+		fibh->sbh = fibh->ebh =
+				udf_expand_dir_adinicb(dir, &block, err);
+		if (!fibh->sbh)
 			return NULL;
 		epos.block = UDF_I_LOCATION(dir);
 		eloc.logicalBlockNum = block;
-		eloc.partitionReferenceNum = UDF_I_LOCATION(dir).partitionReferenceNum;
+		eloc.partitionReferenceNum =
+				UDF_I_LOCATION(dir).partitionReferenceNum;
 		elen = dir->i_sb->s_blocksize;
 		epos.offset = udf_file_entry_alloc_offset(dir);
 		if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_SHORT)
@@ -489,13 +518,16 @@ add:
 
 		if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
 			block = UDF_I_LOCATION(dir).logicalBlockNum;
-			fi = (struct fileIdentDesc *)(UDF_I_DATA(dir) + fibh->soffset -
-						      udf_ext0_offset(dir) +
-						      UDF_I_LENEATTR(dir));
+			fi = (struct fileIdentDesc *)
+					(UDF_I_DATA(dir) + fibh->soffset -
+					 udf_ext0_offset(dir) +
+					 UDF_I_LENEATTR(dir));
 		} else {
-			block = eloc.logicalBlockNum + ((elen - 1) >>
-							dir->i_sb->s_blocksize_bits);
-			fi = (struct fileIdentDesc *)(fibh->sbh->b_data + fibh->soffset);
+			block = eloc.logicalBlockNum +
+					((elen - 1) >>
+						dir->i_sb->s_blocksize_bits);
+			fi = (struct fileIdentDesc *)
+				(fibh->sbh->b_data + fibh->soffset);
 		}
 	} else {
 		fibh->soffset = fibh->eoffset - sb->s_blocksize;
@@ -507,7 +539,9 @@ add:
 
 		block = eloc.logicalBlockNum + ((elen - 1) >>
 						dir->i_sb->s_blocksize_bits);
-		fibh->ebh = udf_bread(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2), 1, err);
+		fibh->ebh = udf_bread(dir,
+				f_pos >> (dir->i_sb->s_blocksize_bits - 2),
+				1, err);
 		if (!fibh->ebh) {
 			brelse(epos.bh);
 			brelse(fibh->sbh);
@@ -519,24 +553,26 @@ add:
 			    (EXT_RECORDED_ALLOCATED >> 30)) {
 				block = eloc.logicalBlockNum + ((elen - 1) >>
 					dir->i_sb->s_blocksize_bits);
-			} else {
+			} else
 				block++;
-			}
 
 			brelse(fibh->sbh);
 			fibh->sbh = fibh->ebh;
 			fi = (struct fileIdentDesc *)(fibh->sbh->b_data);
 		} else {
 			fi = (struct fileIdentDesc *)
-				(fibh->sbh->b_data + sb->s_blocksize + fibh->soffset);
+				(fibh->sbh->b_data + sb->s_blocksize +
+					fibh->soffset);
 		}
 	}
 
 	memset(cfi, 0, sizeof(struct fileIdentDesc));
 	if (UDF_SB(sb)->s_udfrev >= 0x0200)
-		udf_new_tag((char *)cfi, TAG_IDENT_FID, 3, 1, block, sizeof(tag));
+		udf_new_tag((char *)cfi, TAG_IDENT_FID, 3, 1, block,
+			    sizeof(tag));
 	else
-		udf_new_tag((char *)cfi, TAG_IDENT_FID, 2, 1, block, sizeof(tag));
+		udf_new_tag((char *)cfi, TAG_IDENT_FID, 2, 1, block,
+			    sizeof(tag));
 	cfi->fileVersionNum = cpu_to_le16(1);
 	cfi->lengthFileIdent = namelen;
 	cfi->lengthOfImpUse = cpu_to_le16(0);
@@ -593,7 +629,8 @@ static int udf_create(struct inode *dir,
 	inode->i_mode = mode;
 	mark_inode_dirty(inode);
 
-	if (!(fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err))) {
+	fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err);
+	if (!fi) {
 		inode->i_nlink--;
 		mark_inode_dirty(inode);
 		iput(inode);
@@ -605,9 +642,8 @@ static int udf_create(struct inode *dir,
 	*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
 		cpu_to_le32(UDF_I_UNIQUE(inode) & 0x00000000FFFFFFFFUL);
 	udf_write_fi(dir, &cfi, fi, &fibh, NULL, NULL);
-	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
+	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
 		mark_inode_dirty(dir);
-	}
 	if (fibh.sbh != fibh.ebh)
 		brelse(fibh.ebh);
 	brelse(fibh.sbh);
@@ -636,7 +672,8 @@ static int udf_mknod(struct inode *dir, 
 
 	inode->i_uid = current->fsuid;
 	init_special_inode(inode, mode, rdev);
-	if (!(fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err))) {
+	fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err);
+	if (!fi) {
 		inode->i_nlink--;
 		mark_inode_dirty(inode);
 		iput(inode);
@@ -648,9 +685,8 @@ static int udf_mknod(struct inode *dir, 
 	*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
 		cpu_to_le32(UDF_I_UNIQUE(inode) & 0x00000000FFFFFFFFUL);
 	udf_write_fi(dir, &cfi, fi, &fibh, NULL, NULL);
-	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
+	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
 		mark_inode_dirty(dir);
-	}
 	mark_inode_dirty(inode);
 
 	if (fibh.sbh != fibh.ebh)
@@ -683,7 +719,8 @@ static int udf_mkdir(struct inode *dir, 
 
 	inode->i_op = &udf_dir_inode_operations;
 	inode->i_fop = &udf_dir_operations;
-	if (!(fi = udf_add_entry(inode, NULL, &fibh, &cfi, &err))) {
+	fi = udf_add_entry(inode, NULL, &fibh, &cfi, &err);
+	if (!fi) {
 		inode->i_nlink--;
 		mark_inode_dirty(inode);
 		iput(inode);
@@ -694,7 +731,8 @@ static int udf_mkdir(struct inode *dir, 
 	cfi.icb.extLocation = cpu_to_lelb(UDF_I_LOCATION(dir));
 	*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
 		cpu_to_le32(UDF_I_UNIQUE(dir) & 0x00000000FFFFFFFFUL);
-	cfi.fileCharacteristics = FID_FILE_CHAR_DIRECTORY | FID_FILE_CHAR_PARENT;
+	cfi.fileCharacteristics =
+			FID_FILE_CHAR_DIRECTORY | FID_FILE_CHAR_PARENT;
 	udf_write_fi(inode, &cfi, fi, &fibh, NULL, NULL);
 	brelse(fibh.sbh);
 	inode->i_mode = S_IFDIR | mode;
@@ -702,7 +740,8 @@ static int udf_mkdir(struct inode *dir, 
 		inode->i_mode |= S_ISGID;
 	mark_inode_dirty(inode);
 
-	if (!(fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err))) {
+	fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err);
+	if (!fi) {
 		inode->i_nlink = 0;
 		mark_inode_dirty(inode);
 		iput(inode);
@@ -741,23 +780,25 @@ static int empty_dir(struct inode *dir)
 
 	f_pos = (udf_ext0_offset(dir) >> 2);
 
-	fibh.soffset = fibh.eoffset = (f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
+	fibh.soffset = fibh.eoffset =
+			(f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
 
-	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
+	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
 		fibh.sbh = fibh.ebh = NULL;
-	} else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
-			      &epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
+	else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
+			      &epos, &eloc, &elen, &offset) ==
+					(EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
 		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
 			if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_SHORT)
 				epos.offset -= sizeof(short_ad);
 			else if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_LONG)
 				epos.offset -= sizeof(long_ad);
-		} else {
+		} else
 			offset = 0;
-		}
 
-		if (!(fibh.sbh = fibh.ebh = udf_tread(dir->i_sb, block))) {
+		fibh.sbh = fibh.ebh = udf_tread(dir->i_sb, block);
+		if (!fibh.sbh) {
 			brelse(epos.bh);
 			return 0;
 		}
@@ -826,7 +867,8 @@ static int udf_rmdir(struct inode *dir, 
 	clear_nlink(inode);
 	inode->i_size = 0;
 	inode_dec_link_count(dir);
-	inode->i_ctime = dir->i_ctime = dir->i_mtime = current_fs_time(dir->i_sb);
+	inode->i_ctime = dir->i_ctime = dir->i_mtime =
+						current_fs_time(dir->i_sb);
 	mark_inode_dirty(dir);
 
 end_rmdir:
@@ -902,7 +944,8 @@ static int udf_symlink(struct inode *dir
 	struct buffer_head *bh;
 
 	lock_kernel();
-	if (!(inode = udf_new_inode(dir, S_IFLNK, &err)))
+	inode = udf_new_inode(dir, S_IFLNK, &err);
+	if (!inode)
 		goto out;
 
 	inode->i_mode = S_IFLNK | S_IRWXUGO;
@@ -914,22 +957,24 @@ static int udf_symlink(struct inode *dir
 		uint32_t elen;
 
 		block = udf_new_block(inode->i_sb, inode,
-				      UDF_I_LOCATION(inode).partitionReferenceNum,
-				      UDF_I_LOCATION(inode).logicalBlockNum, &err);
+				UDF_I_LOCATION(inode).partitionReferenceNum,
+				UDF_I_LOCATION(inode).logicalBlockNum, &err);
 		if (!block)
 			goto out_no_entry;
 		epos.block = UDF_I_LOCATION(inode);
 		epos.offset = udf_file_entry_alloc_offset(inode);
 		epos.bh = NULL;
 		eloc.logicalBlockNum = block;
-		eloc.partitionReferenceNum = UDF_I_LOCATION(inode).partitionReferenceNum;
+		eloc.partitionReferenceNum =
+				UDF_I_LOCATION(inode).partitionReferenceNum;
 		elen = inode->i_sb->s_blocksize;
 		UDF_I_LENEXTENTS(inode) = elen;
 		udf_add_aext(inode, &epos, eloc, elen, 0);
 		brelse(epos.bh);
 
 		block = udf_get_pblock(inode->i_sb, block,
-				       UDF_I_LOCATION(inode).partitionReferenceNum, 0);
+				UDF_I_LOCATION(inode).partitionReferenceNum,
+				0);
 		epos.bh = udf_tread(inode->i_sb, block);
 		lock_buffer(epos.bh);
 		memset(epos.bh->b_data, 0x00, inode->i_sb->s_blocksize);
@@ -976,7 +1021,8 @@ static int udf_symlink(struct inode *dir
 		if (compstart[0] == '.') {
 			if ((symname - compstart) == 1)
 				pc->componentType = 4;
-			else if ((symname - compstart) == 2 && compstart[1] == '.')
+			else if ((symname - compstart) == 2 &&
+					compstart[1] == '.')
 				pc->componentType = 3;
 		}
 
@@ -986,7 +1032,8 @@ static int udf_symlink(struct inode *dir
 			if (!namelen)
 				goto out_no_entry;
 
-			if (elen + sizeof(struct pathComponent) + namelen > eoffset)
+			if (elen + sizeof(struct pathComponent) + namelen >
+					eoffset)
 				goto out_no_entry;
 			else
 				pc->lengthComponentIdent = namelen;
@@ -1009,16 +1056,19 @@ static int udf_symlink(struct inode *dir
 		UDF_I_LENALLOC(inode) = inode->i_size;
 	mark_inode_dirty(inode);
 
-	if (!(fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err)))
+	fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err);
+	if (!fi)
 		goto out_no_entry;
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
 	cfi.icb.extLocation = cpu_to_lelb(UDF_I_LOCATION(inode));
 	bh = UDF_SB(inode->i_sb)->s_lvid_bh;
 	if (bh) {
-		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)bh->b_data;
+		struct logicalVolIntegrityDesc *lvid =
+				(struct logicalVolIntegrityDesc *)bh->b_data;
 		struct logicalVolHeaderDesc *lvhd;
 		uint64_t uniqueID;
-		lvhd = (struct logicalVolHeaderDesc *)(lvid->logicalVolContentsUse);
+		lvhd = (struct logicalVolHeaderDesc *)
+				lvid->logicalVolContentsUse;
 		uniqueID = le64_to_cpu(lvhd->uniqueID);
 		*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
 			cpu_to_le32(uniqueID & 0x00000000FFFFFFFFUL);
@@ -1028,9 +1078,8 @@ static int udf_symlink(struct inode *dir
 		mark_buffer_dirty(bh);
 	}
 	udf_write_fi(dir, &cfi, fi, &fibh, NULL, NULL);
-	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
+	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
 		mark_inode_dirty(dir);
-	}
 	if (fibh.sbh != fibh.ebh)
 		brelse(fibh.ebh);
 	brelse(fibh.sbh);
@@ -1062,7 +1111,8 @@ static int udf_link(struct dentry *old_d
 		return -EMLINK;
 	}
 
-	if (!(fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err))) {
+	fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err);
+	if (!fi) {
 		unlock_kernel();
 		return err;
 	}
@@ -1070,10 +1120,12 @@ static int udf_link(struct dentry *old_d
 	cfi.icb.extLocation = cpu_to_lelb(UDF_I_LOCATION(inode));
 	bh = UDF_SB(inode->i_sb)->s_lvid_bh;
 	if (bh) {
-		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)bh->b_data;
+		struct logicalVolIntegrityDesc *lvid =
+				(struct logicalVolIntegrityDesc *)bh->b_data;
 		struct logicalVolHeaderDesc *lvhd;
 		uint64_t uniqueID;
-		lvhd = (struct logicalVolHeaderDesc *)(lvid->logicalVolContentsUse);
+		lvhd = (struct logicalVolHeaderDesc *)
+				(lvid->logicalVolContentsUse);
 		uniqueID = le64_to_cpu(lvhd->uniqueID);
 		*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
 			cpu_to_le32(uniqueID & 0x00000000FFFFFFFFUL);
@@ -1083,9 +1135,8 @@ static int udf_link(struct dentry *old_d
 		mark_buffer_dirty(bh);
 	}
 	udf_write_fi(dir, &cfi, fi, &fibh, NULL, NULL);
-	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
+	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
 		mark_inode_dirty(dir);
-	}
 
 	if (fibh.sbh != fibh.ebh)
 		brelse(fibh.ebh);
@@ -1109,13 +1160,15 @@ static int udf_rename(struct inode *old_
 	struct inode *old_inode = old_dentry->d_inode;
 	struct inode *new_inode = new_dentry->d_inode;
 	struct udf_fileident_bh ofibh, nfibh;
-	struct fileIdentDesc *ofi = NULL, *nfi = NULL, *dir_fi = NULL, ocfi, ncfi;
+	struct fileIdentDesc *ofi = NULL, *nfi = NULL, *dir_fi = NULL;
+	struct fileIdentDesc ocfi, ncfi;
 	struct buffer_head *dir_bh = NULL;
 	int retval = -ENOENT;
 	kernel_lb_addr tloc;
 
 	lock_kernel();
-	if ((ofi = udf_find_entry(old_dir, old_dentry, &ofibh, &ocfi))) {
+	ofi = udf_find_entry(old_dir, old_dentry, &ofibh, &ocfi);
+	if (ofi) {
 		if (ofibh.sbh != ofibh.ebh)
 			brelse(ofibh.ebh);
 		brelse(ofibh.sbh);
@@ -1144,29 +1197,35 @@ static int udf_rename(struct inode *old_
 		}
 		retval = -EIO;
 		if (UDF_I_ALLOCTYPE(old_inode) == ICBTAG_FLAG_AD_IN_ICB) {
-			dir_fi = udf_get_fileident(UDF_I_DATA(old_inode) -
-						   (UDF_I_EFE(old_inode) ?
-						    sizeof(struct extendedFileEntry) :
-						    sizeof(struct fileEntry)),
-						   old_inode->i_sb->s_blocksize, &offset);
+			dir_fi = udf_get_fileident(
+					UDF_I_DATA(old_inode) -
+					  (UDF_I_EFE(old_inode) ?
+					   sizeof(struct extendedFileEntry) :
+					   sizeof(struct fileEntry)),
+					old_inode->i_sb->s_blocksize, &offset);
 		} else {
 			dir_bh = udf_bread(old_inode, 0, 0, &retval);
 			if (!dir_bh)
 				goto end_rename;
-			dir_fi = udf_get_fileident(dir_bh->b_data, old_inode->i_sb->s_blocksize, &offset);
+			dir_fi = udf_get_fileident(dir_bh->b_data,
+					old_inode->i_sb->s_blocksize, &offset);
 		}
 		if (!dir_fi)
 			goto end_rename;
 		tloc = lelb_to_cpu(dir_fi->icb.extLocation);
-		if (udf_get_lb_pblock(old_inode->i_sb, tloc, 0) != old_dir->i_ino)
+		if (udf_get_lb_pblock(old_inode->i_sb, tloc, 0) !=
+				old_dir->i_ino)
 			goto end_rename;
 
 		retval = -EMLINK;
-		if (!new_inode && new_dir->i_nlink >= (256 << sizeof(new_dir->i_nlink)) - 1)
+		if (!new_inode &&
+			new_dir->i_nlink >=
+				(256 << sizeof(new_dir->i_nlink)) - 1)
 			goto end_rename;
 	}
 	if (!nfi) {
-		nfi = udf_add_entry(new_dir, new_dentry, &nfibh, &ncfi, &retval);
+		nfi = udf_add_entry(new_dir, new_dentry, &nfibh, &ncfi,
+				    &retval);
 		if (!nfi)
 			goto end_rename;
 	}
@@ -1199,17 +1258,18 @@ static int udf_rename(struct inode *old_
 
 	if (dir_fi) {
 		dir_fi->icb.extLocation = cpu_to_lelb(UDF_I_LOCATION(new_dir));
-		udf_update_tag((char *)dir_fi, (sizeof(struct fileIdentDesc) +
-						le16_to_cpu(dir_fi->lengthOfImpUse) + 3) & ~3);
-		if (UDF_I_ALLOCTYPE(old_inode) == ICBTAG_FLAG_AD_IN_ICB) {
+		udf_update_tag((char *)dir_fi,
+				(sizeof(struct fileIdentDesc) +
+				le16_to_cpu(dir_fi->lengthOfImpUse) + 3) & ~3);
+		if (UDF_I_ALLOCTYPE(old_inode) == ICBTAG_FLAG_AD_IN_ICB)
 			mark_inode_dirty(old_inode);
-		} else {
+		else
 			mark_buffer_dirty_inode(dir_bh, old_inode);
-		}
+
 		inode_dec_link_count(old_dir);
-		if (new_inode) {
+		if (new_inode)
 			inode_dec_link_count(new_inode);
-		} else {
+		else {
 			inc_nlink(new_dir);
 			mark_inode_dirty(new_dir);
 		}
diff -puN fs/udf/partition.c~udf-fix-coding-style fs/udf/partition.c
--- a/fs/udf/partition.c~udf-fix-coding-style
+++ a/fs/udf/partition.c
@@ -34,8 +34,8 @@ inline uint32_t udf_get_pblock(struct su
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct udf_part_map *map;
 	if (partition >= sbi->s_partitions) {
-		udf_debug("block=%d, partition=%d, offset=%d: invalid partition\n",
-			  block, partition, offset);
+		udf_debug("block=%d, partition=%d, offset=%d: "
+			  "invalid partition\n", block, partition, offset);
 		return 0xFFFFFFFF;
 	}
 	map = &sbi->s_partmaps[partition];
@@ -54,13 +54,15 @@ uint32_t udf_get_pblock_virt15(struct su
 	uint32_t loc;
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct udf_part_map *map;
+	struct udf_virtual_data *vdata;
 
 	map = &sbi->s_partmaps[partition];
-	index = (sb->s_blocksize - map->s_type_specific.s_virtual.s_start_offset) / sizeof(uint32_t);
+	vdata = &map->s_type_specific.s_virtual;
+	index = (sb->s_blocksize - vdata->s_start_offset) / sizeof(uint32_t);
 
-	if (block > map->s_type_specific.s_virtual.s_num_entries) {
-		udf_debug("Trying to access block beyond end of VAT (%d max %d)\n",
-			  block, map->s_type_specific.s_virtual.s_num_entries);
+	if (block > vdata->s_num_entries) {
+		udf_debug("Trying to access block beyond end of VAT "
+			  "(%d max %d)\n", block, vdata->s_num_entries);
 		return 0xFFFFFFFF;
 	}
 
@@ -70,12 +72,13 @@ uint32_t udf_get_pblock_virt15(struct su
 		index = block % (sb->s_blocksize / sizeof(uint32_t));
 	} else {
 		newblock = 0;
-		index = map->s_type_specific.s_virtual.s_start_offset / sizeof(uint32_t) + block;
+		index = vdata->s_start_offset / sizeof(uint32_t) + block;
 	}
 
 	loc = udf_block_map(sbi->s_vat_inode, newblock);
 
-	if (!(bh = sb_bread(sb, loc))) {
+	bh = sb_bread(sb, loc);
+	if (!bh) {
 		udf_debug("get_pblock(UDF_VIRTUAL_MAP:%p,%d,%d) VAT: %d[%d]\n",
 			  sb, block, partition, loc, index);
 		return 0xFFFFFFFF;
@@ -85,17 +88,19 @@ uint32_t udf_get_pblock_virt15(struct su
 
 	brelse(bh);
 
-	if (UDF_I_LOCATION(sbi->s_vat_inode).partitionReferenceNum == partition) {
+	if (UDF_I_LOCATION(sbi->s_vat_inode).partitionReferenceNum ==
+								partition) {
 		udf_debug("recursive call to udf_get_pblock!\n");
 		return 0xFFFFFFFF;
 	}
 
 	return udf_get_pblock(sb, loc,
-			      UDF_I_LOCATION(sbi->s_vat_inode).partitionReferenceNum,
+			      UDF_I_LOCATION(sbi->s_vat_inode).
+							partitionReferenceNum,
 			      offset);
 }
 
-inline uint32_t udf_get_pblock_virt20(struct super_block * sb, uint32_t block,
+inline uint32_t udf_get_pblock_virt20(struct super_block *sb, uint32_t block,
 				      uint16_t partition, uint32_t offset)
 {
 	return udf_get_pblock_virt15(sb, block, partition, offset);
@@ -109,27 +114,32 @@ uint32_t udf_get_pblock_spar15(struct su
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct udf_part_map *map;
 	uint32_t packet;
+	struct udf_sparing_data *sdata;
 
 	map = &sbi->s_partmaps[partition];
-	packet = (block + offset) & ~(map->s_type_specific.s_sparing.s_packet_len - 1);
+	sdata = &map->s_type_specific.s_sparing;
+	packet = (block + offset) & ~(sdata->s_packet_len - 1);
 
 	for (i = 0; i < 4; i++) {
-		if (map->s_type_specific.s_sparing.s_spar_map[i] != NULL) {
-			st = (struct sparingTable *)map->s_type_specific.s_sparing.s_spar_map[i]->b_data;
+		if (sdata->s_spar_map[i] != NULL) {
+			st = (struct sparingTable *)
+					sdata->s_spar_map[i]->b_data;
 			break;
 		}
 	}
 
 	if (st) {
 		for (i = 0; i < le16_to_cpu(st->reallocationTableLen); i++) {
-			if (le32_to_cpu(st->mapEntry[i].origLocation) >= 0xFFFFFFF0) {
+			struct sparingEntry *entry = &st->mapEntry[i];
+			u32 origLoc = le32_to_cpu(entry->origLocation);
+			if (origLoc >= 0xFFFFFFF0)
 				break;
-			} else if (le32_to_cpu(st->mapEntry[i].origLocation) == packet) {
-				return le32_to_cpu(st->mapEntry[i].mappedLocation) +
-					((block + offset) & (map->s_type_specific.s_sparing.s_packet_len - 1));
-			} else if (le32_to_cpu(st->mapEntry[i].origLocation) > packet) {
+			else if (origLoc == packet)
+				return le32_to_cpu(entry->mappedLocation) +
+					((block + offset) &
+						(sdata->s_packet_len - 1));
+			else if (origLoc > packet)
 				break;
-			}
 		}
 	}
 
@@ -144,63 +154,101 @@ int udf_relocate_blocks(struct super_blo
 	uint32_t packet;
 	int i, j, k, l;
 	struct udf_sb_info *sbi = UDF_SB(sb);
+	u16 reallocationTableLen;
+	struct buffer_head *bh;
 
 	for (i = 0; i < sbi->s_partitions; i++) {
 		struct udf_part_map *map = &sbi->s_partmaps[i];
 		if (old_block > map->s_partition_root &&
 		    old_block < map->s_partition_root + map->s_partition_len) {
 			sdata = &map->s_type_specific.s_sparing;
-			packet = (old_block - map->s_partition_root) & ~(sdata->s_packet_len - 1);
+			packet = (old_block - map->s_partition_root) &
+						~(sdata->s_packet_len - 1);
 
-			for (j = 0; j < 4; j++) {
-				if (map->s_type_specific.s_sparing.s_spar_map[j] != NULL) {
-					st = (struct sparingTable *)sdata->s_spar_map[j]->b_data;
+			for (j = 0; j < 4; j++)
+				if (sdata->s_spar_map[j] != NULL) {
+					st = (struct sparingTable *)
+						sdata->s_spar_map[j]->b_data;
 					break;
 				}
-			}
 
 			if (!st)
 				return 1;
 
-			for (k = 0; k < le16_to_cpu(st->reallocationTableLen); k++) {
-				if (le32_to_cpu(st->mapEntry[k].origLocation) == 0xFFFFFFFF) {
+			reallocationTableLen =
+					le16_to_cpu(st->reallocationTableLen);
+			for (k = 0; k < reallocationTableLen; k++) {
+				struct sparingEntry *entry = &st->mapEntry[k];
+				u32 origLoc = le32_to_cpu(entry->origLocation);
+
+				if (origLoc == 0xFFFFFFFF) {
 					for (; j < 4; j++) {
-						if (sdata->s_spar_map[j]) {
-							st = (struct sparingTable *)sdata->s_spar_map[j]->b_data;
-							st->mapEntry[k].origLocation = cpu_to_le32(packet);
-							udf_update_tag((char *)st, sizeof(struct sparingTable) + le16_to_cpu(st->reallocationTableLen) * sizeof(struct sparingEntry));
-							mark_buffer_dirty(sdata->s_spar_map[j]);
-						}
+						int len;
+						bh = sdata->s_spar_map[j];
+						if (!bh)
+							continue;
+
+						st = (struct sparingTable *)
+								bh->b_data;
+						entry->origLocation =
+							cpu_to_le32(packet);
+						len =
+						  sizeof(struct sparingTable) +
+						  reallocationTableLen *
+						  sizeof(struct sparingEntry);
+						udf_update_tag((char *)st, len);
+						mark_buffer_dirty(bh);
 					}
-					*new_block = le32_to_cpu(st->mapEntry[k].mappedLocation) +
-						((old_block - map->s_partition_root) & (sdata->s_packet_len - 1));
+					*new_block = le32_to_cpu(
+							entry->mappedLocation) +
+						     ((old_block -
+							map->s_partition_root) &
+						     (sdata->s_packet_len - 1));
 					return 0;
-				} else if (le32_to_cpu(st->mapEntry[k].origLocation) == packet) {
-					*new_block = le32_to_cpu(st->mapEntry[k].mappedLocation) +
-						((old_block - map->s_partition_root) & (sdata->s_packet_len - 1));
+				} else if (origLoc == packet) {
+					*new_block = le32_to_cpu(
+							entry->mappedLocation) +
+						     ((old_block -
+							map->s_partition_root) &
+						     (sdata->s_packet_len - 1));
 					return 0;
-				} else if (le32_to_cpu(st->mapEntry[k].origLocation) > packet) {
+				} else if (origLoc > packet)
 					break;
-				}
 			}
 
-			for (l = k; l < le16_to_cpu(st->reallocationTableLen); l++) {
-				if (le32_to_cpu(st->mapEntry[l].origLocation) == 0xFFFFFFFF) {
-					for (; j < 4; j++) {
-						if (sdata->s_spar_map[j]) {
-							st = (struct sparingTable *)sdata->s_spar_map[j]->b_data;
-							mapEntry = st->mapEntry[l];
-							mapEntry.origLocation = cpu_to_le32(packet);
-							memmove(&st->mapEntry[k + 1], &st->mapEntry[k], (l - k) * sizeof(struct sparingEntry));
-							st->mapEntry[k] = mapEntry;
-							udf_update_tag((char *)st, sizeof(struct sparingTable) + le16_to_cpu(st->reallocationTableLen) * sizeof(struct sparingEntry));
-							mark_buffer_dirty(sdata->s_spar_map[j]);
-						}
-					}
-					*new_block = le32_to_cpu(st->mapEntry[k].mappedLocation) +
-						((old_block - map->s_partition_root) & (sdata->s_packet_len - 1));
-					return 0;
+			for (l = k; l < reallocationTableLen; l++) {
+				struct sparingEntry *entry = &st->mapEntry[l];
+				u32 origLoc = le32_to_cpu(entry->origLocation);
+
+				if (origLoc != 0xFFFFFFFF)
+					continue;
+
+				for (; j < 4; j++) {
+					bh = sdata->s_spar_map[j];
+					if (!bh)
+						continue;
+
+					st = (struct sparingTable *)bh->b_data;
+					mapEntry = st->mapEntry[l];
+					mapEntry.origLocation =
+							cpu_to_le32(packet);
+					memmove(&st->mapEntry[k + 1],
+						&st->mapEntry[k],
+						(l - k) *
+						sizeof(struct sparingEntry));
+					st->mapEntry[k] = mapEntry;
+					udf_update_tag((char *)st,
+						sizeof(struct sparingTable) +
+						reallocationTableLen *
+						sizeof(struct sparingEntry));
+					mark_buffer_dirty(bh);
 				}
+				*new_block =
+					le32_to_cpu(
+					      st->mapEntry[k].mappedLocation) +
+					((old_block - map->s_partition_root) &
+					 (sdata->s_packet_len - 1));
+				return 0;
 			}
 
 			return 1;
diff -puN fs/udf/super.c~udf-fix-coding-style fs/udf/super.c
--- a/fs/udf/super.c~udf-fix-coding-style
+++ a/fs/udf/super.c
@@ -98,9 +98,11 @@ static int udf_statfs(struct dentry *, s
 
 struct logicalVolIntegrityDescImpUse *udf_sb_lvidiu(struct udf_sb_info *sbi)
 {
-	struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
+	struct logicalVolIntegrityDesc *lvid =
+		(struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
 	__u32 number_of_partitions = le32_to_cpu(lvid->numOfPartitions);
-	__u32 offset = number_of_partitions * 2 * sizeof(uint32_t)/sizeof(uint8_t);
+	__u32 offset = number_of_partitions * 2 *
+				sizeof(uint32_t)/sizeof(uint8_t);
 	return (struct logicalVolIntegrityDescImpUse *)&(lvid->impUse[offset]);
 }
 
@@ -713,16 +715,23 @@ static void udf_find_anchor(struct super
 					lastblock = last[i] - sbi->s_session;
 					sbi->s_anchor[0] = lastblock;
 					sbi->s_anchor[1] = lastblock - 256;
-				} else if (location == udf_variable_to_fixed(last[i]) - sbi->s_session) {
+				} else if (location ==
+						udf_variable_to_fixed(last[i]) -
+							sbi->s_session) {
 					UDF_SET_FLAG(sb, UDF_FLAG_VARCONV);
-					lastblock = udf_variable_to_fixed(last[i]) - sbi->s_session;
+					lastblock =
+						udf_variable_to_fixed(last[i]) -
+							sbi->s_session;
 					sbi->s_anchor[0] = lastblock;
-					sbi->s_anchor[1] = lastblock - 256 - sbi->s_session;
+					sbi->s_anchor[1] = lastblock - 256 -
+								sbi->s_session;
 				} else {
-					udf_debug("Anchor found at block %d, location mismatch %d.\n",
+					udf_debug("Anchor found at block %d, "
+						  "location mismatch %d.\n",
 						  last[i], location);
 				}
-			} else if (ident == TAG_IDENT_FE || ident == TAG_IDENT_EFE) {
+			} else if (ident == TAG_IDENT_FE ||
+					ident == TAG_IDENT_EFE) {
 				lastblock = last[i];
 				sbi->s_anchor[3] = 512;
 			} else {
@@ -731,31 +740,40 @@ static void udf_find_anchor(struct super
 					bh = sb_bread(sb, last[i] - 256);
 					if (bh) {
 						tag *t = (tag *)bh->b_data;
-						ident = le16_to_cpu(t->tagIdent);
-						location = le32_to_cpu(t->tagLocation);
+						ident = le16_to_cpu(
+								t->tagIdent);
+						location = le32_to_cpu(
+								t->tagLocation);
 						brelse(bh);
 					}
 				}
 
 				if (ident == TAG_IDENT_AVDP &&
-				    location == last[i] - 256 - sbi->s_session) {
+				    location == last[i] - 256 -
+						sbi->s_session) {
 					lastblock = last[i];
 					sbi->s_anchor[1] = last[i] - 256;
 				} else {
 					ident = location = 0;
 					if (last[i] >= 312 + sbi->s_session) {
-						bh = sb_bread(sb, last[i] - 312 - sbi->s_session);
+						bh = sb_bread(sb,
+								last[i] - 312 -
+								sbi->s_session);
 						if (bh) {
-							tag *t = (tag *)bh->b_data;
-							ident = le16_to_cpu(t->tagIdent);
-							location = le32_to_cpu(t->tagLocation);
+							tag *t = (tag *)
+								 bh->b_data;
+							ident = le16_to_cpu(
+								t->tagIdent);
+							location = le32_to_cpu(
+								t->tagLocation);
 							brelse(bh);
 						}
 					}
 
 					if (ident == TAG_IDENT_AVDP &&
 					    location == udf_variable_to_fixed(last[i]) - 256) {
-						UDF_SET_FLAG(sb, UDF_FLAG_VARCONV);
+						UDF_SET_FLAG(sb,
+							     UDF_FLAG_VARCONV);
 						lastblock = udf_variable_to_fixed(last[i]);
 						sbi->s_anchor[1] = lastblock - 256;
 					}
@@ -787,7 +805,8 @@ static void udf_find_anchor(struct super
 			else {
 				brelse(bh);
 				if ((ident != TAG_IDENT_AVDP) &&
-				    (i || (ident != TAG_IDENT_FE && ident != TAG_IDENT_EFE)))
+				    (i || (ident != TAG_IDENT_FE &&
+					   ident != TAG_IDENT_EFE)))
 					sbi->s_anchor[i] = 0;
 			}
 		}
@@ -848,11 +867,12 @@ static int udf_find_fileset(struct super
 				case TAG_IDENT_SBD:
 				{
 					struct spaceBitmapDesc *sp;
-					sp = (struct spaceBitmapDesc *)bh->b_data;
+					sp = (struct spaceBitmapDesc *)
+								bh->b_data;
 					newfileset.logicalBlockNum += 1 +
 						((le32_to_cpu(sp->numOfBytes) +
-						  sizeof(struct spaceBitmapDesc) - 1)
-						 >> sb->s_blocksize_bits);
+						  sizeof(struct spaceBitmapDesc)
+						  - 1) >> sb->s_blocksize_bits);
 					brelse(bh);
 					break;
 				}
@@ -908,18 +928,17 @@ static void udf_load_pvoldesc(struct sup
 		UDF_SB(sb)->s_record_time.tv_nsec = recording_usec * 1000;
 	}
 
-	if (!udf_build_ustr(&instr, pvoldesc->volIdent, 32)) {
+	if (!udf_build_ustr(&instr, pvoldesc->volIdent, 32))
 		if (udf_CS0toUTF8(&outstr, &instr)) {
 			strncpy(UDF_SB(sb)->s_volume_ident, outstr.u_name,
 				outstr.u_len > 31 ? 31 : outstr.u_len);
-			udf_debug("volIdent[] = '%s'\n", UDF_SB(sb)->s_volume_ident);
+			udf_debug("volIdent[] = '%s'\n",
+					UDF_SB(sb)->s_volume_ident);
 		}
-	}
 
-	if (!udf_build_ustr(&instr, pvoldesc->volSetIdent, 128)) {
+	if (!udf_build_ustr(&instr, pvoldesc->volSetIdent, 128))
 		if (udf_CS0toUTF8(&outstr, &instr))
 			udf_debug("volSetIdent[] = '%s'\n", outstr.u_name);
-	}
 }
 
 static void udf_load_fileset(struct super_block *sb, struct buffer_head *bh,
@@ -987,18 +1006,30 @@ static int udf_load_partdesc(struct supe
 	for (i = 0; i < sbi->s_partitions; i++) {
 		map = &sbi->s_partmaps[i];
 		udf_debug("Searching map: (%d == %d)\n",
-			  map->s_partition_num, le16_to_cpu(p->partitionNumber));
-		if (map->s_partition_num == le16_to_cpu(p->partitionNumber)) {
-			map->s_partition_len = le32_to_cpu(p->partitionLength); /* blocks */
-			map->s_partition_root = le32_to_cpu(p->partitionStartingLocation);
-			if (le32_to_cpu(p->accessType) == PD_ACCESS_TYPE_READ_ONLY)
-				map->s_partition_flags |= UDF_PART_FLAG_READ_ONLY;
-			if (le32_to_cpu(p->accessType) == PD_ACCESS_TYPE_WRITE_ONCE)
-				map->s_partition_flags |= UDF_PART_FLAG_WRITE_ONCE;
-			if (le32_to_cpu(p->accessType) == PD_ACCESS_TYPE_REWRITABLE)
-				map->s_partition_flags |= UDF_PART_FLAG_REWRITABLE;
-			if (le32_to_cpu(p->accessType) == PD_ACCESS_TYPE_OVERWRITABLE)
-				map->s_partition_flags |= UDF_PART_FLAG_OVERWRITABLE;
+			  map->s_partition_num,
+			  le16_to_cpu(p->partitionNumber));
+		if (map->s_partition_num ==
+				le16_to_cpu(p->partitionNumber)) {
+			map->s_partition_len =
+				le32_to_cpu(p->partitionLength); /* blocks */
+			map->s_partition_root =
+				le32_to_cpu(p->partitionStartingLocation);
+			if (le32_to_cpu(p->accessType) ==
+					PD_ACCESS_TYPE_READ_ONLY)
+				map->s_partition_flags |=
+						UDF_PART_FLAG_READ_ONLY;
+			if (le32_to_cpu(p->accessType) ==
+					PD_ACCESS_TYPE_WRITE_ONCE)
+				map->s_partition_flags |=
+						UDF_PART_FLAG_WRITE_ONCE;
+			if (le32_to_cpu(p->accessType) ==
+					PD_ACCESS_TYPE_REWRITABLE)
+				map->s_partition_flags |=
+						UDF_PART_FLAG_REWRITABLE;
+			if (le32_to_cpu(p->accessType) ==
+					PD_ACCESS_TYPE_OVERWRITABLE)
+				map->s_partition_flags |=
+						UDF_PART_FLAG_OVERWRITABLE;
 
 			if (!strcmp(p->partitionContents.ident,
 				    PD_PARTITION_CONTENTS_NSR02) ||
@@ -1006,7 +1037,8 @@ static int udf_load_partdesc(struct supe
 				    PD_PARTITION_CONTENTS_NSR03)) {
 				struct partitionHeaderDesc *phd;
 
-				phd = (struct partitionHeaderDesc *)(p->partitionContentsUse);
+				phd = (struct partitionHeaderDesc *)
+						(p->partitionContentsUse);
 				if (phd->unallocSpaceTable.extLength) {
 					kernel_lb_addr loc = {
 						.logicalBlockNum = le32_to_cpu(phd->unallocSpaceTable.extPosition),
@@ -1019,20 +1051,23 @@ static int udf_load_partdesc(struct supe
 						udf_debug("cannot load unallocSpaceTable (part %d)\n", i);
 						return 1;
 					}
-					map->s_partition_flags |= UDF_PART_FLAG_UNALLOC_TABLE;
+					map->s_partition_flags |=
+						UDF_PART_FLAG_UNALLOC_TABLE;
 					udf_debug("unallocSpaceTable (part %d) @ %ld\n",
 						  i, map->s_uspace.s_table->i_ino);
 				}
 				if (phd->unallocSpaceBitmap.extLength) {
-					map->s_uspace.s_bitmap = udf_sb_alloc_bitmap(sb, i);
-					if (map->s_uspace.s_bitmap != NULL) {
-						map->s_uspace.s_bitmap->s_extLength =
+					struct udf_bitmap *bitmap =
+						udf_sb_alloc_bitmap(sb, i);
+					map->s_uspace.s_bitmap = bitmap;
+					if (bitmap != NULL) {
+						bitmap->s_extLength =
 							le32_to_cpu(phd->unallocSpaceBitmap.extLength);
-						map->s_uspace.s_bitmap->s_extPosition =
+						bitmap->s_extPosition =
 							le32_to_cpu(phd->unallocSpaceBitmap.extPosition);
 						map->s_partition_flags |= UDF_PART_FLAG_UNALLOC_BITMAP;
 						udf_debug("unallocSpaceBitmap (part %d) @ %d\n",
-							  i, map->s_uspace.s_bitmap->s_extPosition);
+							  i, bitmap->s_extPosition);
 					}
 				}
 				if (phd->partitionIntegrityTable.extLength)
@@ -1049,37 +1084,39 @@ static int udf_load_partdesc(struct supe
 						udf_debug("cannot load freedSpaceTable (part %d)\n", i);
 						return 1;
 					}
-					map->s_partition_flags |= UDF_PART_FLAG_FREED_TABLE;
+					map->s_partition_flags |=
+						UDF_PART_FLAG_FREED_TABLE;
 					udf_debug("freedSpaceTable (part %d) @ %ld\n",
 						  i, map->s_fspace.s_table->i_ino);
 				}
 				if (phd->freedSpaceBitmap.extLength) {
-					map->s_fspace.s_bitmap = udf_sb_alloc_bitmap(sb, i);
-					if (map->s_fspace.s_bitmap != NULL) {
-						map->s_fspace.s_bitmap->s_extLength =
+					struct udf_bitmap *bitmap =
+						udf_sb_alloc_bitmap(sb, i);
+					map->s_fspace.s_bitmap = bitmap;
+					if (bitmap != NULL) {
+						bitmap->s_extLength =
 							le32_to_cpu(phd->freedSpaceBitmap.extLength);
-						map->s_fspace.s_bitmap->s_extPosition =
+						bitmap->s_extPosition =
 							le32_to_cpu(phd->freedSpaceBitmap.extPosition);
 						map->s_partition_flags |= UDF_PART_FLAG_FREED_BITMAP;
 						udf_debug("freedSpaceBitmap (part %d) @ %d\n",
-							  i, map->s_fspace.s_bitmap->s_extPosition);
+							  i, bitmap->s_extPosition);
 					}
 				}
 			}
 			break;
 		}
 	}
-	if (i == sbi->s_partitions) {
+	if (i == sbi->s_partitions)
 		udf_debug("Partition (%d) not found in partition map\n",
 			  le16_to_cpu(p->partitionNumber));
-	} else {
+	else
 		udf_debug("Partition (%d:%d type %x) starts at physical %d, "
 			  "block length %d\n",
 			  le16_to_cpu(p->partitionNumber), i,
 			  map->s_partition_type,
 			  map->s_partition_root,
 			  map->s_partition_len);
-	}
 	return 0;
 }
 
@@ -1090,6 +1127,7 @@ static int udf_load_logicalvol(struct su
 	int i, j, offset;
 	uint8_t type;
 	struct udf_sb_info *sbi = UDF_SB(sb);
+	struct genericPartitionMap *gpm;
 
 	lvd = (struct logicalVolDesc *)bh->b_data;
 
@@ -1099,43 +1137,71 @@ static int udf_load_logicalvol(struct su
 
 	for (i = 0, offset = 0;
 	     i < sbi->s_partitions && offset < le32_to_cpu(lvd->mapTableLength);
-	     i++, offset += ((struct genericPartitionMap *)&(lvd->partitionMaps[offset]))->partitionMapLength) {
-	     	struct udf_part_map *map = &sbi->s_partmaps[i];
-		type = ((struct genericPartitionMap *)&(lvd->partitionMaps[offset]))->partitionMapType;
+	     i++, offset += gpm->partitionMapLength) {
+		struct udf_part_map *map = &sbi->s_partmaps[i];
+		gpm = (struct genericPartitionMap *)
+				&(lvd->partitionMaps[offset]);
+		type = gpm->partitionMapType;
 		if (type == 1) {
-			struct genericPartitionMap1 *gpm1 = (struct genericPartitionMap1 *)&(lvd->partitionMaps[offset]);
+			struct genericPartitionMap1 *gpm1 =
+				(struct genericPartitionMap1 *)gpm;
 			map->s_partition_type = UDF_TYPE1_MAP15;
 			map->s_volumeseqnum = le16_to_cpu(gpm1->volSeqNum);
 			map->s_partition_num = le16_to_cpu(gpm1->partitionNum);
 			map->s_partition_func = NULL;
 		} else if (type == 2) {
-			struct udfPartitionMap2 *upm2 = (struct udfPartitionMap2 *)&(lvd->partitionMaps[offset]);
-			if (!strncmp(upm2->partIdent.ident, UDF_ID_VIRTUAL, strlen(UDF_ID_VIRTUAL))) {
-				if (le16_to_cpu(((__le16 *)upm2->partIdent.identSuffix)[0]) == 0x0150) {
-					map->s_partition_type = UDF_VIRTUAL_MAP15;
-					map->s_partition_func = udf_get_pblock_virt15;
-				} else if (le16_to_cpu(((__le16 *)upm2->partIdent.identSuffix)[0]) == 0x0200) {
-					map->s_partition_type = UDF_VIRTUAL_MAP20;
-					map->s_partition_func = udf_get_pblock_virt20;
+			struct udfPartitionMap2 *upm2 =
+						(struct udfPartitionMap2 *)gpm;
+			if (!strncmp(upm2->partIdent.ident, UDF_ID_VIRTUAL,
+						strlen(UDF_ID_VIRTUAL))) {
+				u16 suf =
+					le16_to_cpu(((__le16 *)upm2->partIdent.
+							identSuffix)[0]);
+				if (suf == 0x0150) {
+					map->s_partition_type =
+							UDF_VIRTUAL_MAP15;
+					map->s_partition_func =
+							udf_get_pblock_virt15;
+				} else if (suf == 0x0200) {
+					map->s_partition_type =
+							UDF_VIRTUAL_MAP20;
+					map->s_partition_func =
+							udf_get_pblock_virt20;
 				}
-			} else if (!strncmp(upm2->partIdent.ident, UDF_ID_SPARABLE, strlen(UDF_ID_SPARABLE))) {
+			} else if (!strncmp(upm2->partIdent.ident,
+						UDF_ID_SPARABLE,
+						strlen(UDF_ID_SPARABLE))) {
 				uint32_t loc;
 				uint16_t ident;
 				struct sparingTable *st;
-				struct sparablePartitionMap *spm = (struct sparablePartitionMap *)&(lvd->partitionMaps[offset]);
+				struct sparablePartitionMap *spm =
+					(struct sparablePartitionMap *)gpm;
 
 				map->s_partition_type = UDF_SPARABLE_MAP15;
-				map->s_type_specific.s_sparing.s_packet_len = le16_to_cpu(spm->packetLength);
+				map->s_type_specific.s_sparing.s_packet_len =
+						le16_to_cpu(spm->packetLength);
 				for (j = 0; j < spm->numSparingTables; j++) {
-					loc = le32_to_cpu(spm->locSparingTable[j]);
-					map->s_type_specific.s_sparing.s_spar_map[j] =
-						udf_read_tagged(sb, loc, loc, &ident);
-					if (map->s_type_specific.s_sparing.s_spar_map[j] != NULL) {
-						st = (struct sparingTable *)map->s_type_specific.s_sparing.s_spar_map[j]->b_data;
-						if (ident != 0 ||
-						    strncmp(st->sparingIdent.ident, UDF_ID_SPARING, strlen(UDF_ID_SPARING))) {
-							brelse(map->s_type_specific.s_sparing.s_spar_map[j]);
-							map->s_type_specific.s_sparing.s_spar_map[j] = NULL;
+					struct buffer_head *bh2;
+
+					loc = le32_to_cpu(
+						spm->locSparingTable[j]);
+					bh2 = udf_read_tagged(sb, loc, loc,
+							     &ident);
+					map->s_type_specific.s_sparing.
+							s_spar_map[j] = bh2;
+
+					if (bh2 != NULL) {
+						st = (struct sparingTable *)
+								bh2->b_data;
+						if (ident != 0 || strncmp(
+							st->sparingIdent.ident,
+							UDF_ID_SPARING,
+							strlen(UDF_ID_SPARING))) {
+							brelse(bh2);
+							map->s_type_specific.
+								s_sparing.
+								s_spar_map[j] =
+									NULL;
 						}
 					}
 				}
@@ -1218,6 +1284,7 @@ static int udf_process_sequence(struct s
 {
 	struct buffer_head *bh = NULL;
 	struct udf_vds_record vds[VDS_POS_LENGTH];
+	struct udf_vds_record *curr;
 	struct generic_desc *gd;
 	struct volDescPtr *vdp;
 	int done = 0;
@@ -1240,43 +1307,51 @@ static int udf_process_sequence(struct s
 		vdsn = le32_to_cpu(gd->volDescSeqNum);
 		switch (ident) {
 		case TAG_IDENT_PVD: /* ISO 13346 3/10.1 */
-			if (vdsn >= vds[VDS_POS_PRIMARY_VOL_DESC].volDescSeqNum) {
-				vds[VDS_POS_PRIMARY_VOL_DESC].volDescSeqNum = vdsn;
-				vds[VDS_POS_PRIMARY_VOL_DESC].block = block;
+			curr = &vds[VDS_POS_PRIMARY_VOL_DESC];
+			if (vdsn >= curr->volDescSeqNum) {
+				curr->volDescSeqNum = vdsn;
+				curr->block = block;
 			}
 			break;
 		case TAG_IDENT_VDP: /* ISO 13346 3/10.3 */
-			if (vdsn >= vds[VDS_POS_VOL_DESC_PTR].volDescSeqNum) {
-				vds[VDS_POS_VOL_DESC_PTR].volDescSeqNum = vdsn;
-				vds[VDS_POS_VOL_DESC_PTR].block = block;
+			curr = &vds[VDS_POS_VOL_DESC_PTR];
+			if (vdsn >= curr->volDescSeqNum) {
+				curr->volDescSeqNum = vdsn;
+				curr->block = block;
 
 				vdp = (struct volDescPtr *)bh->b_data;
-				next_s = le32_to_cpu(vdp->nextVolDescSeqExt.extLocation);
-				next_e = le32_to_cpu(vdp->nextVolDescSeqExt.extLength);
+				next_s = le32_to_cpu(
+					vdp->nextVolDescSeqExt.extLocation);
+				next_e = le32_to_cpu(
+					vdp->nextVolDescSeqExt.extLength);
 				next_e = next_e >> sb->s_blocksize_bits;
 				next_e += next_s;
 			}
 			break;
 		case TAG_IDENT_IUVD: /* ISO 13346 3/10.4 */
-			if (vdsn >= vds[VDS_POS_IMP_USE_VOL_DESC].volDescSeqNum) {
-				vds[VDS_POS_IMP_USE_VOL_DESC].volDescSeqNum = vdsn;
-				vds[VDS_POS_IMP_USE_VOL_DESC].block = block;
+			curr = &vds[VDS_POS_IMP_USE_VOL_DESC];
+			if (vdsn >= curr->volDescSeqNum) {
+				curr->volDescSeqNum = vdsn;
+				curr->block = block;
 			}
 			break;
 		case TAG_IDENT_PD: /* ISO 13346 3/10.5 */
-			if (!vds[VDS_POS_PARTITION_DESC].block)
-				vds[VDS_POS_PARTITION_DESC].block = block;
+			curr = &vds[VDS_POS_PARTITION_DESC];
+			if (!curr->block)
+				curr->block = block;
 			break;
 		case TAG_IDENT_LVD: /* ISO 13346 3/10.6 */
-			if (vdsn >= vds[VDS_POS_LOGICAL_VOL_DESC].volDescSeqNum) {
-				vds[VDS_POS_LOGICAL_VOL_DESC].volDescSeqNum = vdsn;
-				vds[VDS_POS_LOGICAL_VOL_DESC].block = block;
+			curr = &vds[VDS_POS_LOGICAL_VOL_DESC];
+			if (vdsn >= curr->volDescSeqNum) {
+				curr->volDescSeqNum = vdsn;
+				curr->block = block;
 			}
 			break;
 		case TAG_IDENT_USD: /* ISO 13346 3/10.8 */
-			if (vdsn >= vds[VDS_POS_UNALLOC_SPACE_DESC].volDescSeqNum) {
-				vds[VDS_POS_UNALLOC_SPACE_DESC].volDescSeqNum = vdsn;
-				vds[VDS_POS_UNALLOC_SPACE_DESC].block = block;
+			curr = &vds[VDS_POS_UNALLOC_SPACE_DESC];
+			if (vdsn >= curr->volDescSeqNum) {
+				curr->volDescSeqNum = vdsn;
+				curr->block = block;
 			}
 			break;
 		case TAG_IDENT_TD: /* ISO 13346 3/10.9 */
@@ -1285,9 +1360,8 @@ static int udf_process_sequence(struct s
 				block = next_s;
 				lastblock = next_e;
 				next_s = next_e = 0;
-			} else {
+			} else
 				done = 1;
-			}
 			break;
 		}
 		brelse(bh);
@@ -1379,14 +1453,18 @@ static int udf_load_partition(struct sup
 			anchor = (struct anchorVolDescPtr *)bh->b_data;
 
 			/* Locate the main sequence */
-			main_s = le32_to_cpu(anchor->mainVolDescSeqExt.extLocation);
-			main_e = le32_to_cpu(anchor->mainVolDescSeqExt.extLength);
+			main_s = le32_to_cpu(
+					anchor->mainVolDescSeqExt.extLocation);
+			main_e = le32_to_cpu(
+					anchor->mainVolDescSeqExt.extLength);
 			main_e = main_e >> sb->s_blocksize_bits;
 			main_e += main_s;
 
 			/* Locate the reserve sequence */
-			reserve_s = le32_to_cpu(anchor->reserveVolDescSeqExt.extLocation);
-			reserve_e = le32_to_cpu(anchor->reserveVolDescSeqExt.extLength);
+			reserve_s = le32_to_cpu(
+				anchor->reserveVolDescSeqExt.extLocation);
+			reserve_e = le32_to_cpu(
+				anchor->reserveVolDescSeqExt.extLength);
 			reserve_e = reserve_e >> sb->s_blocksize_bits;
 			reserve_e += reserve_s;
 
@@ -1394,8 +1472,10 @@ static int udf_load_partition(struct sup
 
 			/* Process the main & reserve sequences */
 			/* responsible for finding the PartitionDesc(s) */
-			if (!(udf_process_sequence(sb, main_s, main_e, fileset) &&
-			      udf_process_sequence(sb, reserve_s, reserve_e, fileset)))
+			if (!(udf_process_sequence(sb, main_s, main_e,
+						   fileset) &&
+			      udf_process_sequence(sb, reserve_s, reserve_e,
+						   fileset)))
 				break;
 		}
 	}
@@ -1426,10 +1506,14 @@ static int udf_load_partition(struct sup
 			for (j = 0; j < sbi->s_partitions; j++) {
 				struct udf_part_map *map2 = &sbi->s_partmaps[j];
 				if (j != i &&
-				    map->s_volumeseqnum == map2->s_volumeseqnum &&
-				    map->s_partition_num == map2->s_partition_num) {
+				    map->s_volumeseqnum ==
+						map2->s_volumeseqnum &&
+				    map->s_partition_num ==
+						map2->s_partition_num) {
 					ino.partitionReferenceNum = j;
-					ino.logicalBlockNum = sbi->s_last_block - map2->s_partition_root;
+					ino.logicalBlockNum =
+						sbi->s_last_block -
+							map2->s_partition_root;
 					break;
 				}
 			}
@@ -1448,17 +1532,22 @@ static int udf_load_partition(struct sup
 					(sbi->s_vat_inode->i_size - 36) >> 2;
 			} else if (map->s_partition_type == UDF_VIRTUAL_MAP20) {
 				uint32_t pos;
+				struct virtualAllocationTable20 *vat20;
 
 				pos = udf_block_map(sbi->s_vat_inode, 0);
 				bh = sb_bread(sb, pos);
 				if (!bh)
 					return 1;
+				vat20 = (struct virtualAllocationTable20 *)
+					bh->b_data +
+					udf_ext0_offset(sbi->s_vat_inode);
 				map->s_type_specific.s_virtual.s_start_offset =
-					le16_to_cpu(((struct virtualAllocationTable20 *)bh->b_data +
-						     udf_ext0_offset(sbi->s_vat_inode))->lengthHeader) +
+					le16_to_cpu(vat20->lengthHeader) +
 					udf_ext0_offset(sbi->s_vat_inode);
-				map->s_type_specific.s_virtual.s_num_entries = (sbi->s_vat_inode->i_size -
-									map->s_type_specific.s_virtual.s_start_offset) >> 2;
+				map->s_type_specific.s_virtual.s_num_entries =
+					(sbi->s_vat_inode->i_size -
+					 map->s_type_specific.s_virtual.
+							s_start_offset) >> 2;
 				brelse(bh);
 			}
 			map->s_partition_root = udf_get_pblock(sb, 0, i, 0);
@@ -1477,8 +1566,10 @@ static void udf_open_lvid(struct super_b
 	if (bh) {
 		int i;
 		kernel_timestamp cpu_time;
-		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)bh->b_data;
-		struct logicalVolIntegrityDescImpUse *lvidiu = udf_sb_lvidiu(sbi);
+		struct logicalVolIntegrityDesc *lvid =
+				(struct logicalVolIntegrityDesc *)bh->b_data;
+		struct logicalVolIntegrityDescImpUse *lvidiu =
+							udf_sb_lvidiu(sbi);
 
 		lvidiu->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
 		lvidiu->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
@@ -1486,8 +1577,10 @@ static void udf_open_lvid(struct super_b
 			lvid->recordingDateAndTime = cpu_to_lets(cpu_time);
 		lvid->integrityType = LVID_INTEGRITY_TYPE_OPEN;
 
-		lvid->descTag.descCRC = cpu_to_le16(udf_crc((char *)lvid + sizeof(tag),
-								       le16_to_cpu(lvid->descTag.descCRCLength), 0));
+		lvid->descTag.descCRC = cpu_to_le16(
+			udf_crc((char *)lvid + sizeof(tag),
+				le16_to_cpu(lvid->descTag.descCRCLength),
+				0));
 
 		lvid->descTag.tagChecksum = 0;
 		for (i = 0; i < 16; i++)
@@ -1513,22 +1606,25 @@ static void udf_close_lvid(struct super_
 	lvid = (struct logicalVolIntegrityDesc *)bh->b_data;
 
 	if (lvid->integrityType == LVID_INTEGRITY_TYPE_OPEN) {
-		struct logicalVolIntegrityDescImpUse *lvidiu = udf_sb_lvidiu(sbi);
+		struct logicalVolIntegrityDescImpUse *lvidiu =
+							udf_sb_lvidiu(sbi);
 		lvidiu->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
 		lvidiu->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
 		if (udf_time_to_stamp(&cpu_time, CURRENT_TIME))
 			lvid->recordingDateAndTime = cpu_to_lets(cpu_time);
 		if (UDF_MAX_WRITE_VERSION > le16_to_cpu(lvidiu->maxUDFWriteRev))
-			lvidiu->maxUDFWriteRev = cpu_to_le16(UDF_MAX_WRITE_VERSION);
+			lvidiu->maxUDFWriteRev =
+					cpu_to_le16(UDF_MAX_WRITE_VERSION);
 		if (sbi->s_udfrev > le16_to_cpu(lvidiu->minUDFReadRev))
 			lvidiu->minUDFReadRev = cpu_to_le16(sbi->s_udfrev);
 		if (sbi->s_udfrev > le16_to_cpu(lvidiu->minUDFWriteRev))
 			lvidiu->minUDFWriteRev = cpu_to_le16(sbi->s_udfrev);
 		lvid->integrityType = cpu_to_le32(LVID_INTEGRITY_TYPE_CLOSE);
 
-		lvid->descTag.descCRC =
-			cpu_to_le16(udf_crc((char *)lvid + sizeof(tag),
-					    le16_to_cpu(lvid->descTag.descCRCLength), 0));
+		lvid->descTag.descCRC = cpu_to_le16(
+			udf_crc((char *)lvid + sizeof(tag),
+				le16_to_cpu(lvid->descTag.descCRCLength),
+				0));
 
 		lvid->descTag.tagChecksum = 0;
 		for (i = 0; i < 16; i++)
@@ -1544,7 +1640,8 @@ static void udf_sb_free_bitmap(struct ud
 {
 	int i;
 	int nr_groups = bitmap->s_nr_groups;
-	int size = sizeof(struct udf_bitmap) + (sizeof(struct buffer_head *) * nr_groups);
+	int size = sizeof(struct udf_bitmap) + (sizeof(struct buffer_head *) *
+						nr_groups);
 
 	for (i = 0; i < nr_groups; i++)
 		if (bitmap->s_block_bitmap[i])
@@ -1662,19 +1759,21 @@ static int udf_fill_super(struct super_b
 	udf_debug("Lastblock=%d\n", sbi->s_last_block);
 
 	if (sbi->s_lvid_bh) {
-		struct logicalVolIntegrityDescImpUse *lvidiu = udf_sb_lvidiu(sbi);
+		struct logicalVolIntegrityDescImpUse *lvidiu =
+							udf_sb_lvidiu(sbi);
 		uint16_t minUDFReadRev = le16_to_cpu(lvidiu->minUDFReadRev);
 		uint16_t minUDFWriteRev = le16_to_cpu(lvidiu->minUDFWriteRev);
-		/* uint16_t maxUDFWriteRev = le16_to_cpu(lvidiu->maxUDFWriteRev); */
+		/* uint16_t maxUDFWriteRev =
+				le16_to_cpu(lvidiu->maxUDFWriteRev); */
 
 		if (minUDFReadRev > UDF_MAX_READ_VERSION) {
-			printk(KERN_ERR "UDF-fs: minUDFReadRev=%x (max is %x)\n",
+			printk(KERN_ERR "UDF-fs: minUDFReadRev=%x "
+					"(max is %x)\n",
 			       le16_to_cpu(lvidiu->minUDFReadRev),
 			       UDF_MAX_READ_VERSION);
 			goto error_out;
-		} else if (minUDFWriteRev > UDF_MAX_WRITE_VERSION) {
+		} else if (minUDFWriteRev > UDF_MAX_WRITE_VERSION)
 			sb->s_flags |= MS_RDONLY;
-		}
 
 		sbi->s_udfrev = minUDFWriteRev;
 
@@ -1689,8 +1788,10 @@ static int udf_fill_super(struct super_b
 		goto error_out;
 	}
 
-	if (sbi->s_partmaps[sbi->s_partition].s_partition_flags & UDF_PART_FLAG_READ_ONLY) {
-		printk(KERN_NOTICE "UDF-fs: Partition marked readonly; forcing readonly mount\n");
+	if (sbi->s_partmaps[sbi->s_partition].s_partition_flags &
+			UDF_PART_FLAG_READ_ONLY) {
+		printk(KERN_NOTICE "UDF-fs: Partition marked readonly; "
+				   "forcing readonly mount\n");
 		sb->s_flags |= MS_RDONLY;
 	}
 
@@ -1716,7 +1817,8 @@ static int udf_fill_super(struct super_b
 	/* perhaps it's not extensible enough, but for now ... */
 	inode = udf_iget(sb, rootdir);
 	if (!inode) {
-		printk(KERN_ERR "UDF-fs: Error in udf_iget, block=%d, partition=%d\n",
+		printk(KERN_ERR "UDF-fs: Error in udf_iget, block=%d, "
+				"partition=%d\n",
 		       rootdir.logicalBlockNum, rootdir.partitionReferenceNum);
 		goto error_out;
 	}
@@ -1746,7 +1848,8 @@ error_out:
 			udf_sb_free_bitmap(map->s_fspace.s_bitmap);
 		if (map->s_partition_type == UDF_SPARABLE_MAP15)
 			for (i = 0; i < 4; i++)
-				brelse(map->s_type_specific.s_sparing.s_spar_map[i]);
+				brelse(map->s_type_specific.s_sparing.
+						s_spar_map[i]);
 	}
 #ifdef CONFIG_UDF_NLS
 	if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP))
@@ -1824,7 +1927,8 @@ static void udf_put_super(struct super_b
 			udf_sb_free_bitmap(map->s_fspace.s_bitmap);
 		if (map->s_partition_type == UDF_SPARABLE_MAP15)
 			for (i = 0; i < 4; i++)
-				brelse(map->s_type_specific.s_sparing.s_spar_map[i]);
+				brelse(map->s_type_specific.s_sparing.
+						s_spar_map[i]);
 	}
 #ifdef CONFIG_UDF_NLS
 	if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP))
@@ -1881,7 +1985,8 @@ static unsigned char udf_bitmap_lookup[1
 	0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4
 };
 
-static unsigned int udf_count_free_bitmap(struct super_block *sb, struct udf_bitmap *bitmap)
+static unsigned int udf_count_free_bitmap(struct super_block *sb,
+					  struct udf_bitmap *bitmap)
 {
 	struct buffer_head *bh = NULL;
 	unsigned int accum = 0;
@@ -1942,7 +2047,8 @@ out:
 	return accum;
 }
 
-static unsigned int udf_count_free_table(struct super_block *sb, struct inode *table)
+static unsigned int udf_count_free_table(struct super_block *sb,
+					 struct inode *table)
 {
 	unsigned int accum = 0;
 	uint32_t elen;
@@ -1974,9 +2080,12 @@ static unsigned int udf_count_free(struc
 
 	sbi = UDF_SB(sb);
 	if (sbi->s_lvid_bh) {
-		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
+		struct logicalVolIntegrityDesc *lvid =
+			(struct logicalVolIntegrityDesc *)
+			sbi->s_lvid_bh->b_data;
 		if (le32_to_cpu(lvid->numOfPartitions) > sbi->s_partition) {
-			accum = le32_to_cpu(lvid->freeSpaceTable[sbi->s_partition]);
+			accum = le32_to_cpu(
+					lvid->freeSpaceTable[sbi->s_partition]);
 			if (accum == 0xFFFFFFFF)
 				accum = 0;
 		}
diff -puN fs/udf/symlink.c~udf-fix-coding-style fs/udf/symlink.c
--- a/fs/udf/symlink.c~udf-fix-coding-style
+++ a/fs/udf/symlink.c
@@ -33,7 +33,8 @@
 #include <linux/buffer_head.h>
 #include "udf_i.h"
 
-static void udf_pc_to_char(struct super_block *sb, char *from, int fromlen, char *to)
+static void udf_pc_to_char(struct super_block *sb, char *from, int fromlen,
+			   char *to)
 {
 	struct pathComponent *pc;
 	int elen = 0;
diff -puN fs/udf/truncate.c~udf-fix-coding-style fs/udf/truncate.c
--- a/fs/udf/truncate.c~udf-fix-coding-style
+++ a/fs/udf/truncate.c
@@ -154,7 +154,8 @@ void udf_discard_prealloc(struct inode *
 		extent_trunc(inode, &epos, eloc, etype, elen, 0);
 		if (!epos.bh) {
 			UDF_I_LENALLOC(inode) =
-				epos.offset - udf_file_entry_alloc_offset(inode);
+				epos.offset -
+				udf_file_entry_alloc_offset(inode);
 			mark_inode_dirty(inode);
 		} else {
 			struct allocExtDesc *aed =
@@ -213,7 +214,8 @@ void udf_truncate_extents(struct inode *
 		else
 			lenalloc -= sizeof(struct allocExtDesc);
 
-		while ((etype = udf_current_aext(inode, &epos, &eloc, &elen, 0)) != -1) {
+		while ((etype = udf_current_aext(inode, &epos, &eloc,
+						 &elen, 0)) != -1) {
 			if (etype == (EXT_NEXT_EXTENT_ALLOCDECS >> 30)) {
 				udf_write_aext(inode, &epos, neloc, nelen, 0);
 				if (indirect_ext_len) {
@@ -225,35 +227,43 @@ void udf_truncate_extents(struct inode *
 							0, indirect_ext_len);
 				} else {
 					if (!epos.bh) {
-						UDF_I_LENALLOC(inode) = lenalloc;
+						UDF_I_LENALLOC(inode) =
+								lenalloc;
 						mark_inode_dirty(inode);
 					} else {
 						struct allocExtDesc *aed =
-							(struct allocExtDesc *)(epos.bh->b_data);
+							(struct allocExtDesc *)
+							(epos.bh->b_data);
+						int len =
+						    sizeof(struct allocExtDesc);
+
 						aed->lengthAllocDescs =
 						    cpu_to_le32(lenalloc);
-						if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT) ||
+						if (!UDF_QUERY_FLAG(sb,
+							UDF_FLAG_STRICT) ||
 						    sbi->s_udfrev >= 0x0201)
-							udf_update_tag(epos.bh->b_data,
-								       lenalloc +
-								       sizeof(struct allocExtDesc));
-						else
-							udf_update_tag(epos.bh->b_data,
-								       sizeof(struct allocExtDesc));
-						mark_buffer_dirty_inode(epos.bh, inode);
+							len += lenalloc;
+
+						udf_update_tag(epos.bh->b_data,
+								len);
+						mark_buffer_dirty_inode(
+								epos.bh, inode);
 					}
 				}
 				brelse(epos.bh);
 				epos.offset = sizeof(struct allocExtDesc);
 				epos.block = eloc;
-				epos.bh = udf_tread(sb, udf_get_lb_pblock(sb, eloc, 0));
+				epos.bh = udf_tread(sb,
+						udf_get_lb_pblock(sb, eloc, 0));
 				if (elen)
-					indirect_ext_len = (elen + sb->s_blocksize -1) >>
+					indirect_ext_len =
+						(elen + sb->s_blocksize - 1) >>
 						sb->s_blocksize_bits;
 				else
 					indirect_ext_len = 1;
 			} else {
-				extent_trunc(inode, &epos, eloc, etype, elen, 0);
+				extent_trunc(inode, &epos, eloc, etype,
+					     elen, 0);
 				epos.offset += adsize;
 			}
 		}
@@ -274,10 +284,11 @@ void udf_truncate_extents(struct inode *
 				if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT) ||
 				    sbi->s_udfrev >= 0x0201)
 					udf_update_tag(epos.bh->b_data,
-						       lenalloc + sizeof(struct allocExtDesc));
+						lenalloc +
+						sizeof(struct allocExtDesc));
 				else
 					udf_update_tag(epos.bh->b_data,
-						       sizeof(struct allocExtDesc));
+						sizeof(struct allocExtDesc));
 				mark_buffer_dirty_inode(epos.bh, inode);
 			}
 		}
@@ -291,13 +302,16 @@ void udf_truncate_extents(struct inode *
 			 *  extending the file by 'offset' blocks.
 			 */
 			if ((!epos.bh &&
-			     epos.offset == udf_file_entry_alloc_offset(inode)) ||
-			    (epos.bh && epos.offset == sizeof(struct allocExtDesc))) {
+			     epos.offset ==
+					udf_file_entry_alloc_offset(inode)) ||
+			    (epos.bh && epos.offset ==
+						sizeof(struct allocExtDesc))) {
 				/* File has no extents at all or has empty last
 				 * indirect extent! Create a fake extent... */
 				extent.extLocation.logicalBlockNum = 0;
 				extent.extLocation.partitionReferenceNum = 0;
-				extent.extLength = EXT_NOT_RECORDED_NOT_ALLOCATED;
+				extent.extLength =
+					EXT_NOT_RECORDED_NOT_ALLOCATED;
 			} else {
 				epos.offset -= adsize;
 				etype = udf_next_aext(inode, &epos,
@@ -306,7 +320,9 @@ void udf_truncate_extents(struct inode *
 				extent.extLength |= etype << 30;
 			}
 			udf_extend_file(inode, &epos, &extent,
-					offset + ((inode->i_size & (sb->s_blocksize - 1)) != 0));
+					offset +
+					((inode->i_size &
+						(sb->s_blocksize - 1)) != 0));
 		}
 	}
 	UDF_I_LENEXTENTS(inode) = inode->i_size;
diff -puN fs/udf/udftime.c~udf-fix-coding-style fs/udf/udftime.c
--- a/fs/udf/udftime.c~udf-fix-coding-style
+++ a/fs/udf/udftime.c
@@ -18,8 +18,10 @@
    Boston, MA 02111-1307, USA.  */
 
 /*
- * dgb 10/02/98: ripped this from glibc source to help convert timestamps to unix time
- *     10/04/98: added new table-based lookup after seeing how ugly the gnu code is
+ * dgb 10/02/98: ripped this from glibc source to help convert timestamps
+ *               to unix time
+ *     10/04/98: added new table-based lookup after seeing how ugly
+ *               the gnu code is
  * blf 09/27/99: ripped out all the old code and inserted new table from
  *		 John Brockmeyer (without leap second corrections)
  *		 rewrote udf_stamp_to_time and fixed timezone accounting in
@@ -55,27 +57,27 @@ static const unsigned short int __mon_yd
 
 #define MAX_YEAR_SECONDS	69
 #define SPD			0x15180	/*3600*24 */
-#define SPY(y,l,s)		(SPD * (365*y+l)+s)
+#define SPY(y, l, s)		(SPD * (365 * y + l) + s)
 
-static time_t year_seconds[MAX_YEAR_SECONDS]= {
-/*1970*/ SPY( 0, 0,0), SPY( 1, 0,0), SPY( 2, 0,0), SPY( 3, 1,0),
-/*1974*/ SPY( 4, 1,0), SPY( 5, 1,0), SPY( 6, 1,0), SPY( 7, 2,0),
-/*1978*/ SPY( 8, 2,0), SPY( 9, 2,0), SPY(10, 2,0), SPY(11, 3,0),
-/*1982*/ SPY(12, 3,0), SPY(13, 3,0), SPY(14, 3,0), SPY(15, 4,0),
-/*1986*/ SPY(16, 4,0), SPY(17, 4,0), SPY(18, 4,0), SPY(19, 5,0),
-/*1990*/ SPY(20, 5,0), SPY(21, 5,0), SPY(22, 5,0), SPY(23, 6,0),
-/*1994*/ SPY(24, 6,0), SPY(25, 6,0), SPY(26, 6,0), SPY(27, 7,0),
-/*1998*/ SPY(28, 7,0), SPY(29, 7,0), SPY(30, 7,0), SPY(31, 8,0),
-/*2002*/ SPY(32, 8,0), SPY(33, 8,0), SPY(34, 8,0), SPY(35, 9,0),
-/*2006*/ SPY(36, 9,0), SPY(37, 9,0), SPY(38, 9,0), SPY(39,10,0),
-/*2010*/ SPY(40,10,0), SPY(41,10,0), SPY(42,10,0), SPY(43,11,0),
-/*2014*/ SPY(44,11,0), SPY(45,11,0), SPY(46,11,0), SPY(47,12,0),
-/*2018*/ SPY(48,12,0), SPY(49,12,0), SPY(50,12,0), SPY(51,13,0),
-/*2022*/ SPY(52,13,0), SPY(53,13,0), SPY(54,13,0), SPY(55,14,0),
-/*2026*/ SPY(56,14,0), SPY(57,14,0), SPY(58,14,0), SPY(59,15,0),
-/*2030*/ SPY(60,15,0), SPY(61,15,0), SPY(62,15,0), SPY(63,16,0),
-/*2034*/ SPY(64,16,0), SPY(65,16,0), SPY(66,16,0), SPY(67,17,0),
-/*2038*/ SPY(68,17,0)
+static time_t year_seconds[MAX_YEAR_SECONDS] = {
+/*1970*/ SPY(0,   0, 0), SPY(1,   0, 0), SPY(2,   0, 0), SPY(3,   1, 0),
+/*1974*/ SPY(4,   1, 0), SPY(5,   1, 0), SPY(6,   1, 0), SPY(7,   2, 0),
+/*1978*/ SPY(8,   2, 0), SPY(9,   2, 0), SPY(10,  2, 0), SPY(11,  3, 0),
+/*1982*/ SPY(12,  3, 0), SPY(13,  3, 0), SPY(14,  3, 0), SPY(15,  4, 0),
+/*1986*/ SPY(16,  4, 0), SPY(17,  4, 0), SPY(18,  4, 0), SPY(19,  5, 0),
+/*1990*/ SPY(20,  5, 0), SPY(21,  5, 0), SPY(22,  5, 0), SPY(23,  6, 0),
+/*1994*/ SPY(24,  6, 0), SPY(25,  6, 0), SPY(26,  6, 0), SPY(27,  7, 0),
+/*1998*/ SPY(28,  7, 0), SPY(29,  7, 0), SPY(30,  7, 0), SPY(31,  8, 0),
+/*2002*/ SPY(32,  8, 0), SPY(33,  8, 0), SPY(34,  8, 0), SPY(35,  9, 0),
+/*2006*/ SPY(36,  9, 0), SPY(37,  9, 0), SPY(38,  9, 0), SPY(39, 10, 0),
+/*2010*/ SPY(40, 10, 0), SPY(41, 10, 0), SPY(42, 10, 0), SPY(43, 11, 0),
+/*2014*/ SPY(44, 11, 0), SPY(45, 11, 0), SPY(46, 11, 0), SPY(47, 12, 0),
+/*2018*/ SPY(48, 12, 0), SPY(49, 12, 0), SPY(50, 12, 0), SPY(51, 13, 0),
+/*2022*/ SPY(52, 13, 0), SPY(53, 13, 0), SPY(54, 13, 0), SPY(55, 14, 0),
+/*2026*/ SPY(56, 14, 0), SPY(57, 14, 0), SPY(58, 14, 0), SPY(59, 15, 0),
+/*2030*/ SPY(60, 15, 0), SPY(61, 15, 0), SPY(62, 15, 0), SPY(63, 16, 0),
+/*2034*/ SPY(64, 16, 0), SPY(65, 16, 0), SPY(66, 16, 0), SPY(67, 17, 0),
+/*2038*/ SPY(68, 17, 0)
 };
 
 extern struct timezone sys_tz;
@@ -115,7 +117,7 @@ time_t *udf_stamp_to_time(time_t *dest, 
 	return dest;
 }
 
-kernel_timestamp *udf_time_to_stamp(kernel_timestamp * dest, struct timespec ts)
+kernel_timestamp *udf_time_to_stamp(kernel_timestamp *dest, struct timespec ts)
 {
 	long int days, rem, y;
 	const unsigned short int *ip;
@@ -137,7 +139,7 @@ kernel_timestamp *udf_time_to_stamp(kern
 	dest->second = rem % 60;
 	y = 1970;
 
-#define DIV(a,b) ((a) / (b) - ((a) % (b) < 0))
+#define DIV(a, b) ((a) / (b) - ((a) % (b) < 0))
 #define LEAPS_THRU_END_OF(y) (DIV (y, 4) - DIV (y, 100) + DIV (y, 400))
 
 	while (days < 0 || days >= (__isleap(y) ? 366 : 365)) {
@@ -145,8 +147,8 @@ kernel_timestamp *udf_time_to_stamp(kern
 
 		/* Adjust DAYS and Y to match the guessed year.  */
 		days -= ((yg - y) * 365
-			 + LEAPS_THRU_END_OF (yg - 1)
-			 - LEAPS_THRU_END_OF (y - 1));
+			 + LEAPS_THRU_END_OF(yg - 1)
+			 - LEAPS_THRU_END_OF(y - 1));
 		y = yg;
 	}
 	dest->year = y;
@@ -158,7 +160,8 @@ kernel_timestamp *udf_time_to_stamp(kern
 	dest->day = days + 1;
 
 	dest->centiseconds = ts.tv_nsec / 10000000;
-	dest->hundredsOfMicroseconds = (ts.tv_nsec / 1000 - dest->centiseconds * 10000) / 100;
+	dest->hundredsOfMicroseconds = (ts.tv_nsec / 1000 -
+					dest->centiseconds * 10000) / 100;
 	dest->microseconds = (ts.tv_nsec / 1000 - dest->centiseconds * 10000 -
 			      dest->hundredsOfMicroseconds * 100);
 	return dest;
diff -puN fs/udf/unicode.c~udf-fix-coding-style fs/udf/unicode.c
--- a/fs/udf/unicode.c~udf-fix-coding-style
+++ a/fs/udf/unicode.c
@@ -136,12 +136,18 @@ int udf_CS0toUTF8(struct ustr *utf_o, st
 		if (c < 0x80U) {
 			utf_o->u_name[utf_o->u_len++] = (uint8_t)c;
 		} else if (c < 0x800U) {
-			utf_o->u_name[utf_o->u_len++] = (uint8_t)(0xc0 | (c >> 6));
-			utf_o->u_name[utf_o->u_len++] = (uint8_t)(0x80 | (c & 0x3f));
+			utf_o->u_name[utf_o->u_len++] =
+						(uint8_t)(0xc0 | (c >> 6));
+			utf_o->u_name[utf_o->u_len++] =
+						(uint8_t)(0x80 | (c & 0x3f));
 		} else {
-			utf_o->u_name[utf_o->u_len++] = (uint8_t)(0xe0 | (c >> 12));
-			utf_o->u_name[utf_o->u_len++] = (uint8_t)(0x80 | ((c >> 6) & 0x3f));
-			utf_o->u_name[utf_o->u_len++] = (uint8_t)(0x80 | (c & 0x3f));
+			utf_o->u_name[utf_o->u_len++] =
+						(uint8_t)(0xe0 | (c >> 12));
+			utf_o->u_name[utf_o->u_len++] =
+						(uint8_t)(0x80 |
+							  ((c >> 6) & 0x3f));
+			utf_o->u_name[utf_o->u_len++] =
+						(uint8_t)(0x80 | (c & 0x3f));
 		}
 	}
 	utf_o->u_cmpID = 8;
@@ -232,9 +238,8 @@ try_again:
 			goto error_out;
 		}
 
-		if (max_val == 0xffffU) {
+		if (max_val == 0xffffU)
 			ocu[++u_len] = (uint8_t)(utf_char >> 8);
-		}
 		ocu[++u_len] = (uint8_t)(utf_char & 0xffU);
 	}
 
@@ -330,29 +335,29 @@ int udf_get_filename(struct super_block 
 	struct ustr filename, unifilename;
 	int len;
 
-	if (udf_build_ustr_exact(&unifilename, sname, flen)) {
+	if (udf_build_ustr_exact(&unifilename, sname, flen))
 		return 0;
-	}
 
 	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UTF8)) {
 		if (!udf_CS0toUTF8(&filename, &unifilename)) {
-			udf_debug("Failed in udf_get_filename: sname = %s\n", sname);
+			udf_debug("Failed in udf_get_filename: sname = %s\n",
+				  sname);
 			return 0;
 		}
 	} else if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP)) {
-		if (!udf_CS0toNLS(UDF_SB(sb)->s_nls_map, &filename, &unifilename)) {
-			udf_debug("Failed in udf_get_filename: sname = %s\n", sname);
+		if (!udf_CS0toNLS(UDF_SB(sb)->s_nls_map, &filename,
+				  &unifilename)) {
+			udf_debug("Failed in udf_get_filename: sname = %s\n",
+				  sname);
 			return 0;
 		}
-	} else {
+	} else
 		return 0;
-	}
 
 	len = udf_translate_to_linux(dname, filename.u_name, filename.u_len,
 				     unifilename.u_name, unifilename.u_len);
-	if (len) {
+	if (len)
 		return len;
-	}
 
 	return 0;
 }
@@ -363,23 +368,20 @@ int udf_put_filename(struct super_block 
 	struct ustr unifilename;
 	int namelen;
 
-	if (!(udf_char_to_ustr(&unifilename, sname, flen))) {
+	if (!udf_char_to_ustr(&unifilename, sname, flen))
 		return 0;
-	}
 
 	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UTF8)) {
 		namelen = udf_UTF8toCS0(dname, &unifilename, UDF_NAME_LEN);
-		if (!namelen) {
+		if (!namelen)
 			return 0;
-		}
 	} else if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP)) {
-		namelen = udf_NLStoCS0(UDF_SB(sb)->s_nls_map, dname, &unifilename, UDF_NAME_LEN);
-		if (!namelen) {
+		namelen = udf_NLStoCS0(UDF_SB(sb)->s_nls_map, dname,
+					&unifilename, UDF_NAME_LEN);
+		if (!namelen)
 			return 0;
-		}
-	} else {
+	} else
 		return 0;
-	}
 
 	return namelen;
 }
@@ -389,8 +391,9 @@ int udf_put_filename(struct super_block 
 #define CRC_MARK		'#'
 #define EXT_SIZE 		5
 
-static int udf_translate_to_linux(uint8_t *newName, uint8_t *udfName, int udfLen,
-				  uint8_t *fidName, int fidNameLen)
+static int udf_translate_to_linux(uint8_t *newName, uint8_t *udfName,
+				  int udfLen, uint8_t *fidName,
+				  int fidNameLen)
 {
 	int index, newIndex = 0, needsCRC = 0;
 	int extIndex = 0, newExtIndex = 0, hasExt = 0;
@@ -409,13 +412,16 @@ static int udf_translate_to_linux(uint8_
 			if (curr == '/' || curr == 0) {
 				needsCRC = 1;
 				curr = ILLEGAL_CHAR_MARK;
-				while (index + 1 < udfLen && (udfName[index + 1] == '/' ||
-							      udfName[index + 1] == 0))
+				while (index + 1 < udfLen &&
+						(udfName[index + 1] == '/' ||
+						 udfName[index + 1] == 0))
 					index++;
-			} if (curr == EXT_MARK && (udfLen - index - 1) <= EXT_SIZE) {
-				if (udfLen == index + 1) {
+			}
+			if (curr == EXT_MARK &&
+					(udfLen - index - 1) <= EXT_SIZE) {
+				if (udfLen == index + 1)
 					hasExt = 0;
-				} else {
+				else {
 					hasExt = 1;
 					extIndex = index;
 					newExtIndex = newIndex;
@@ -433,16 +439,18 @@ static int udf_translate_to_linux(uint8_
 
 		if (hasExt) {
 			int maxFilenameLen;
-			for(index = 0; index < EXT_SIZE && extIndex + index + 1 < udfLen; index++) {
+			for (index = 0;
+			     index < EXT_SIZE && extIndex + index + 1 < udfLen;
+			     index++) {
 				curr = udfName[extIndex + index + 1];
 
 				if (curr == '/' || curr == 0) {
 					needsCRC = 1;
 					curr = ILLEGAL_CHAR_MARK;
-					while(extIndex + index + 2 < udfLen &&
-					      (index + 1 < EXT_SIZE
-					       && (udfName[extIndex + index + 2] == '/' ||
-						   udfName[extIndex + index + 2] == 0)))
+					while (extIndex + index + 2 < udfLen &&
+					      (index + 1 < EXT_SIZE &&
+						(udfName[extIndex + index + 2] == '/' ||
+						 udfName[extIndex + index + 2] == 0)))
 						index++;
 				}
 				ext[localExtIndex++] = curr;
@@ -452,9 +460,8 @@ static int udf_translate_to_linux(uint8_
 				newIndex = maxFilenameLen;
 			else
 				newIndex = newExtIndex;
-		} else if (newIndex > 250) {
+		} else if (newIndex > 250)
 			newIndex = 250;
-		}
 		newName[newIndex++] = CRC_MARK;
 		valueCRC = udf_crc(fidName, fidNameLen, 0);
 		newName[newIndex++] = hexChar[(valueCRC & 0xf000) >> 12];
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
