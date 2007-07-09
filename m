From: akpm@linux-foundation.org
Subject: - udf-coding-style-conversion-lindent-fixups.patch removed from -mm tree
Date: Mon, 09 Jul 2007 14:50:43 -0700
Message-ID: <200707092150.l69LohXD014235@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57903 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754379AbXGIVu5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 17:50:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, jack@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     UDF: coding style conversion - lindent fixups
has been removed from the -mm tree.  Its filename was
     udf-coding-style-conversion-lindent-fixups.patch

This patch was dropped because it was folded into udf-coding-style-conversion-lindent.patch

------------------------------------------------------
Subject: UDF: coding style conversion - lindent fixups
From: Cyrill Gorcunov <gorcunov@gmail.com>

This patch fixups sources were converted by Lindent.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Jan Kara <jack@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/balloc.c    |  420 ++++++-----------
 fs/udf/crc.c       |    4 
 fs/udf/dir.c       |   62 +-
 fs/udf/directory.c |   68 +-
 fs/udf/ecma_167.h  |  680 ++++++++++++++--------------
 fs/udf/file.c      |   72 +-
 fs/udf/fsync.c     |    2 
 fs/udf/ialloc.c    |   38 -
 fs/udf/inode.c     |  942 +++++++++++++++-----------------------
 fs/udf/lowlevel.c  |    4 
 fs/udf/misc.c      |   87 +--
 fs/udf/namei.c     |  414 +++++++----------
 fs/udf/osta_udf.h  |  164 +++---
 fs/udf/partition.c |  214 ++------
 fs/udf/super.c     | 1040 ++++++++++++++++---------------------------
 fs/udf/symlink.c   |   14 
 fs/udf/truncate.c  |    4 
 fs/udf/udf_i.h     |    2 
 fs/udf/udf_sb.h    |   26 -
 fs/udf/udfdecl.h   |    4 
 fs/udf/udfend.h    |   20 
 fs/udf/udftime.c   |   80 +--
 fs/udf/unicode.c   |  155 +++---
 23 files changed, 1882 insertions(+), 2634 deletions(-)

diff -puN fs/udf/balloc.c~udf-coding-style-conversion-lindent-fixups fs/udf/balloc.c
--- a/fs/udf/balloc.c~udf-coding-style-conversion-lindent-fixups
+++ a/fs/udf/balloc.c
@@ -70,9 +70,9 @@ static inline int find_next_one_bit(void
 	if (!size)
 		return result;
 	tmp = leBPL_to_cpup(p);
-      found_first:
+found_first:
 	tmp &= ~0UL >> (BITS_PER_LONG - size);
-      found_middle:
+found_middle:
 	return result + ffz(~tmp);
 }
 
@@ -110,11 +110,11 @@ static int __load_block_bitmap(struct su
 			  nr_groups);
 	}
 
-	if (bitmap->s_block_bitmap[block_group])
+	if (bitmap->s_block_bitmap[block_group]) {
 		return block_group;
-	else {
-		retval =
-		    read_block_bitmap(sb, bitmap, block_group, block_group);
+	} else {
+		retval = read_block_bitmap(sb, bitmap, block_group,
+					   block_group);
 		if (retval < 0)
 			return retval;
 		return block_group;
@@ -155,22 +155,16 @@ static void udf_bitmap_free_blocks(struc
 
 	mutex_lock(&sbi->s_alloc_mutex);
 	if (bloc.logicalBlockNum < 0 ||
-	    (bloc.logicalBlockNum + count) > UDF_SB_PARTLEN(sb,
-							    bloc.
-							    partitionReferenceNum))
-	{
-		udf_debug("%d < %d || %d + %d > %d\n", bloc.logicalBlockNum, 0,
-			  bloc.logicalBlockNum, count, UDF_SB_PARTLEN(sb,
-								      bloc.
-								      partitionReferenceNum));
+	    (bloc.logicalBlockNum + count) > UDF_SB_PARTLEN(sb, bloc.partitionReferenceNum)) {
+		udf_debug("%d < %d || %d + %d > %d\n",
+			  bloc.logicalBlockNum, 0, bloc.logicalBlockNum, count,
+			  UDF_SB_PARTLEN(sb, bloc.partitionReferenceNum));
 		goto error_return;
 	}
 
-	block =
-	    bloc.logicalBlockNum + offset +
-	    (sizeof(struct spaceBitmapDesc) << 3);
+	block = bloc.logicalBlockNum + offset + (sizeof(struct spaceBitmapDesc) << 3);
 
-      do_more:
+do_more:
 	overflow = 0;
 	block_group = block >> (sb->s_blocksize_bits + 3);
 	bit = block % (sb->s_blocksize << 3);
@@ -190,18 +184,13 @@ static void udf_bitmap_free_blocks(struc
 	for (i = 0; i < count; i++) {
 		if (udf_set_bit(bit + i, bh->b_data)) {
 			udf_debug("bit %ld already set\n", bit + i);
-			udf_debug("byte=%2x\n",
-				  ((char *)bh->b_data)[(bit + i) >> 3]);
+			udf_debug("byte=%2x\n", ((char *)bh->b_data)[(bit + i) >> 3]);
 		} else {
 			if (inode)
 				DQUOT_FREE_BLOCK(inode, 1);
 			if (UDF_SB_LVIDBH(sb)) {
-				UDF_SB_LVID(sb)->
-				    freeSpaceTable[UDF_SB_PARTITION(sb)] =
-				    cpu_to_le32(le32_to_cpu
-						(UDF_SB_LVID(sb)->
-						 freeSpaceTable[UDF_SB_PARTITION
-								(sb)]) + 1);
+				UDF_SB_LVID(sb)->freeSpaceTable[UDF_SB_PARTITION(sb)] =
+					cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[UDF_SB_PARTITION(sb)]) + 1);
 			}
 		}
 	}
@@ -211,7 +200,7 @@ static void udf_bitmap_free_blocks(struc
 		count = overflow;
 		goto do_more;
 	}
-      error_return:
+error_return:
 	sb->s_dirt = 1;
 	if (UDF_SB_LVIDBH(sb))
 		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
@@ -238,7 +227,7 @@ static int udf_bitmap_prealloc_blocks(st
 	if (first_block + block_count > UDF_SB_PARTLEN(sb, partition))
 		block_count = UDF_SB_PARTLEN(sb, partition) - first_block;
 
-      repeat:
+repeat:
 	nr_groups = (UDF_SB_PARTLEN(sb, partition) +
 		     (sizeof(struct spaceBitmapDesc) << 3) +
 		     (sb->s_blocksize * 8) - 1) / (sb->s_blocksize * 8);
@@ -254,11 +243,11 @@ static int udf_bitmap_prealloc_blocks(st
 	bit = block % (sb->s_blocksize << 3);
 
 	while (bit < (sb->s_blocksize << 3) && block_count > 0) {
-		if (!udf_test_bit(bit, bh->b_data))
+		if (!udf_test_bit(bit, bh->b_data)) {
 			goto out;
-		else if (DQUOT_PREALLOC_BLOCK(inode, 1))
+		} else if (DQUOT_PREALLOC_BLOCK(inode, 1)) {
 			goto out;
-		else if (!udf_clear_bit(bit, bh->b_data)) {
+		} else if (!udf_clear_bit(bit, bh->b_data)) {
 			udf_debug("bit already cleared for block %d\n", bit);
 			DQUOT_FREE_BLOCK(inode, 1);
 			goto out;
@@ -271,12 +260,10 @@ static int udf_bitmap_prealloc_blocks(st
 	mark_buffer_dirty(bh);
 	if (block_count > 0)
 		goto repeat;
-      out:
+out:
 	if (UDF_SB_LVIDBH(sb)) {
 		UDF_SB_LVID(sb)->freeSpaceTable[partition] =
-		    cpu_to_le32(le32_to_cpu
-				(UDF_SB_LVID(sb)->freeSpaceTable[partition]) -
-				alloc_count);
+			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[partition]) - alloc_count);
 		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
 	}
 	sb->s_dirt = 1;
@@ -299,7 +286,7 @@ static int udf_bitmap_new_block(struct s
 	*err = -ENOSPC;
 	mutex_lock(&sbi->s_alloc_mutex);
 
-      repeat:
+repeat:
 	if (goal < 0 || goal >= UDF_SB_PARTLEN(sb, partition))
 		goal = 0;
 
@@ -312,31 +299,27 @@ static int udf_bitmap_new_block(struct s
 	if (bitmap_nr < 0)
 		goto error_return;
 	bh = bitmap->s_block_bitmap[bitmap_nr];
-	ptr =
-	    memscan((char *)bh->b_data + group_start, 0xFF,
-		    sb->s_blocksize - group_start);
+	ptr = memscan((char *)bh->b_data + group_start, 0xFF,
+		      sb->s_blocksize - group_start);
 
 	if ((ptr - ((char *)bh->b_data)) < sb->s_blocksize) {
 		bit = block % (sb->s_blocksize << 3);
-
-		if (udf_test_bit(bit, bh->b_data)) {
+		if (udf_test_bit(bit, bh->b_data))
 			goto got_block;
-		}
+
 		end_goal = (bit + 63) & ~63;
 		bit = udf_find_next_one_bit(bh->b_data, end_goal, bit);
 		if (bit < end_goal)
 			goto got_block;
-		ptr =
-		    memscan((char *)bh->b_data + (bit >> 3), 0xFF,
-			    sb->s_blocksize - ((bit + 7) >> 3));
+
+		ptr = memscan((char *)bh->b_data + (bit >> 3), 0xFF, sb->s_blocksize - ((bit + 7) >> 3));
 		newbit = (ptr - ((char *)bh->b_data)) << 3;
 		if (newbit < sb->s_blocksize << 3) {
 			bit = newbit;
 			goto search_back;
 		}
-		newbit =
-		    udf_find_next_one_bit(bh->b_data, sb->s_blocksize << 3,
-					  bit);
+
+		newbit = udf_find_next_one_bit(bh->b_data, sb->s_blocksize << 3, bit);
 		if (newbit < sb->s_blocksize << 3) {
 			bit = newbit;
 			goto got_block;
@@ -354,18 +337,16 @@ static int udf_bitmap_new_block(struct s
 			goto error_return;
 		bh = bitmap->s_block_bitmap[bitmap_nr];
 		if (i < nr_groups) {
-			ptr =
-			    memscan((char *)bh->b_data + group_start, 0xFF,
-				    sb->s_blocksize - group_start);
+			ptr = memscan((char *)bh->b_data + group_start, 0xFF,
+				      sb->s_blocksize - group_start);
 			if ((ptr - ((char *)bh->b_data)) < sb->s_blocksize) {
 				bit = (ptr - ((char *)bh->b_data)) << 3;
 				break;
 			}
 		} else {
-			bit =
-			    udf_find_next_one_bit((char *)bh->b_data,
-						  sb->s_blocksize << 3,
-						  group_start << 3);
+			bit = udf_find_next_one_bit((char *)bh->b_data,
+						    sb->s_blocksize << 3,
+						    group_start << 3);
 			if (bit < sb->s_blocksize << 3)
 				break;
 		}
@@ -377,20 +358,17 @@ static int udf_bitmap_new_block(struct s
 	if (bit < sb->s_blocksize << 3)
 		goto search_back;
 	else
-		bit =
-		    udf_find_next_one_bit(bh->b_data, sb->s_blocksize << 3,
-					  group_start << 3);
+		bit = udf_find_next_one_bit(bh->b_data, sb->s_blocksize << 3, group_start << 3);
 	if (bit >= sb->s_blocksize << 3) {
 		mutex_unlock(&sbi->s_alloc_mutex);
 		return 0;
 	}
 
-      search_back:
-	for (i = 0;
-	     i < 7 && bit > (group_start << 3)
-	     && udf_test_bit(bit - 1, bh->b_data); i++, bit--) ;
+search_back:
+	for (i = 0; i < 7 && bit > (group_start << 3) && udf_test_bit(bit - 1, bh->b_data); i++, bit--)
+		; /* empty loop */
 
-      got_block:
+got_block:
 
 	/*
 	 * Check quota for allocation of this block.
@@ -402,7 +380,7 @@ static int udf_bitmap_new_block(struct s
 	}
 
 	newblock = bit + (block_group << (sb->s_blocksize_bits + 3)) -
-	    (sizeof(struct spaceBitmapDesc) << 3);
+		(sizeof(struct spaceBitmapDesc) << 3);
 
 	if (!udf_clear_bit(bit, bh->b_data)) {
 		udf_debug("bit already cleared for block %d\n", bit);
@@ -413,9 +391,7 @@ static int udf_bitmap_new_block(struct s
 
 	if (UDF_SB_LVIDBH(sb)) {
 		UDF_SB_LVID(sb)->freeSpaceTable[partition] =
-		    cpu_to_le32(le32_to_cpu
-				(UDF_SB_LVID(sb)->freeSpaceTable[partition]) -
-				1);
+			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[partition]) - 1);
 		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
 	}
 	sb->s_dirt = 1;
@@ -423,7 +399,7 @@ static int udf_bitmap_new_block(struct s
 	*err = 0;
 	return newblock;
 
-      error_return:
+error_return:
 	*err = -EIO;
 	mutex_unlock(&sbi->s_alloc_mutex);
 	return 0;
@@ -445,14 +421,10 @@ static void udf_table_free_blocks(struct
 
 	mutex_lock(&sbi->s_alloc_mutex);
 	if (bloc.logicalBlockNum < 0 ||
-	    (bloc.logicalBlockNum + count) > UDF_SB_PARTLEN(sb,
-							    bloc.
-							    partitionReferenceNum))
-	{
-		udf_debug("%d < %d || %d + %d > %d\n", bloc.logicalBlockNum, 0,
-			  bloc.logicalBlockNum, count, UDF_SB_PARTLEN(sb,
-								      bloc.
-								      partitionReferenceNum));
+	    (bloc.logicalBlockNum + count) > UDF_SB_PARTLEN(sb, bloc.partitionReferenceNum)) {
+		udf_debug("%d < %d || %d + %d > %d\n",
+			  bloc.logicalBlockNum, 0, bloc.logicalBlockNum, count,
+			  UDF_SB_PARTLEN(sb, bloc.partitionReferenceNum));
 		goto error_return;
 	}
 
@@ -462,9 +434,7 @@ static void udf_table_free_blocks(struct
 		DQUOT_FREE_BLOCK(inode, count);
 	if (UDF_SB_LVIDBH(sb)) {
 		UDF_SB_LVID(sb)->freeSpaceTable[UDF_SB_PARTITION(sb)] =
-		    cpu_to_le32(le32_to_cpu
-				(UDF_SB_LVID(sb)->
-				 freeSpaceTable[UDF_SB_PARTITION(sb)]) + count);
+			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[UDF_SB_PARTITION(sb)]) + count);
 		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
 	}
 
@@ -476,47 +446,28 @@ static void udf_table_free_blocks(struct
 	epos.block = oepos.block = UDF_I_LOCATION(table);
 	epos.bh = oepos.bh = NULL;
 
-	while (count && (etype =
-			 udf_next_aext(table, &epos, &eloc, &elen, 1)) != -1) {
-		if (((eloc.logicalBlockNum + (elen >> sb->s_blocksize_bits)) ==
-		     start)) {
-			if ((0x3FFFFFFF - elen) <
-			    (count << sb->s_blocksize_bits)) {
-				count -=
-				    ((0x3FFFFFFF -
-				      elen) >> sb->s_blocksize_bits);
-				start +=
-				    ((0x3FFFFFFF -
-				      elen) >> sb->s_blocksize_bits);
-				elen =
-				    (etype << 30) | (0x40000000 -
-						     sb->s_blocksize);
+	while (count &&
+	       (etype = udf_next_aext(table, &epos, &eloc, &elen, 1)) != -1) {
+		if (((eloc.logicalBlockNum + (elen >> sb->s_blocksize_bits)) == start)) {
+			if ((0x3FFFFFFF - elen) < (count << sb->s_blocksize_bits)) {
+				count -= ((0x3FFFFFFF - elen) >> sb->s_blocksize_bits);
+				start += ((0x3FFFFFFF - elen) >> sb->s_blocksize_bits);
+				elen = (etype << 30) | (0x40000000 - sb->s_blocksize);
 			} else {
-				elen = (etype << 30) |
-				    (elen + (count << sb->s_blocksize_bits));
+				elen = (etype << 30) | (elen + (count << sb->s_blocksize_bits));
 				start += count;
 				count = 0;
 			}
 			udf_write_aext(table, &oepos, eloc, elen, 1);
 		} else if (eloc.logicalBlockNum == (end + 1)) {
-			if ((0x3FFFFFFF - elen) <
-			    (count << sb->s_blocksize_bits)) {
-				count -=
-				    ((0x3FFFFFFF -
-				      elen) >> sb->s_blocksize_bits);
-				end -=
-				    ((0x3FFFFFFF -
-				      elen) >> sb->s_blocksize_bits);
-				eloc.logicalBlockNum -=
-				    ((0x3FFFFFFF -
-				      elen) >> sb->s_blocksize_bits);
-				elen =
-				    (etype << 30) | (0x40000000 -
-						     sb->s_blocksize);
+			if ((0x3FFFFFFF - elen) < (count << sb->s_blocksize_bits)) {
+				count -= ((0x3FFFFFFF - elen) >> sb->s_blocksize_bits);
+				end -= ((0x3FFFFFFF - elen) >> sb->s_blocksize_bits);
+				eloc.logicalBlockNum -= ((0x3FFFFFFF - elen) >> sb->s_blocksize_bits);
+				elen = (etype << 30) | (0x40000000 - sb->s_blocksize);
 			} else {
 				eloc.logicalBlockNum = start;
-				elen = (etype << 30) |
-				    (elen + (count << sb->s_blocksize_bits));
+				elen = (etype << 30) | (elen + (count << sb->s_blocksize_bits));
 				end -= count;
 				count = 0;
 			}
@@ -530,21 +481,23 @@ static void udf_table_free_blocks(struct
 			get_bh(epos.bh);
 			oepos.bh = epos.bh;
 			oepos.offset = 0;
-		} else
+		} else {
 			oepos.offset = epos.offset;
+		}
 	}
 
 	if (count) {
-		/* NOTE: we CANNOT use udf_add_aext here, as it can try to allocate
-		   a new block, and since we hold the super block lock already
-		   very bad things would happen :)
-
-		   We copy the behavior of udf_add_aext, but instead of
-		   trying to allocate a new block close to the existing one,
-		   we just steal a block from the extent we are trying to add.
-
-		   It would be nice if the blocks were close together, but it
-		   isn't required.
+		/*
+		 * NOTE: we CANNOT use udf_add_aext here, as it can try to allocate
+		 * a new block, and since we hold the super block lock already
+		 * very bad things would happen :)
+		 *
+		 * We copy the behavior of udf_add_aext, but instead of
+		 * trying to allocate a new block close to the existing one,
+		 * we just steal a block from the extent we are trying to add.
+		 *
+		 * It would be nice if the blocks were close together, but it
+		 * isn't required.
 		 */
 
 		int adsize;
@@ -553,13 +506,14 @@ static void udf_table_free_blocks(struct
 		struct allocExtDesc *aed;
 
 		eloc.logicalBlockNum = start;
-		elen = EXT_RECORDED_ALLOCATED | (count << sb->s_blocksize_bits);
+		elen = EXT_RECORDED_ALLOCATED |
+			(count << sb->s_blocksize_bits);
 
-		if (UDF_I_ALLOCTYPE(table) == ICBTAG_FLAG_AD_SHORT)
+		if (UDF_I_ALLOCTYPE(table) == ICBTAG_FLAG_AD_SHORT) {
 			adsize = sizeof(short_ad);
-		else if (UDF_I_ALLOCTYPE(table) == ICBTAG_FLAG_AD_LONG)
+		} else if (UDF_I_ALLOCTYPE(table) == ICBTAG_FLAG_AD_LONG) {
 			adsize = sizeof(long_ad);
-		else {
+		} else {
 			brelse(oepos.bh);
 			brelse(epos.bh);
 			goto error_return;
@@ -577,28 +531,21 @@ static void udf_table_free_blocks(struct
 			eloc.logicalBlockNum++;
 			elen -= sb->s_blocksize;
 
-			if (!(epos.bh = udf_tread(sb,
-						  udf_get_lb_pblock(sb,
-								    epos.block,
-								    0)))) {
+			if (!(epos.bh = udf_tread(sb, udf_get_lb_pblock(sb, epos.block, 0)))) {
 				brelse(oepos.bh);
 				goto error_return;
 			}
 			aed = (struct allocExtDesc *)(epos.bh->b_data);
-			aed->previousAllocExtLocation =
-			    cpu_to_le32(oepos.block.logicalBlockNum);
+			aed->previousAllocExtLocation = cpu_to_le32(oepos.block.logicalBlockNum);
 			if (epos.offset + adsize > sb->s_blocksize) {
 				loffset = epos.offset;
 				aed->lengthAllocDescs = cpu_to_le32(adsize);
 				sptr = UDF_I_DATA(inode) + epos.offset -
-				    udf_file_entry_alloc_offset(inode) +
-				    UDF_I_LENEATTR(inode) - adsize;
-				dptr =
-				    epos.bh->b_data +
-				    sizeof(struct allocExtDesc);
+					udf_file_entry_alloc_offset(inode) +
+					UDF_I_LENEATTR(inode) - adsize;
+				dptr = epos.bh->b_data + sizeof(struct allocExtDesc);
 				memcpy(dptr, sptr, adsize);
-				epos.offset =
-				    sizeof(struct allocExtDesc) + adsize;
+				epos.offset = sizeof(struct allocExtDesc) + adsize;
 			} else {
 				loffset = epos.offset + adsize;
 				aed->lengthAllocDescs = cpu_to_le32(0);
@@ -606,60 +553,46 @@ static void udf_table_free_blocks(struct
 				epos.offset = sizeof(struct allocExtDesc);
 
 				if (oepos.bh) {
-					aed =
-					    (struct allocExtDesc *)oepos.bh->
-					    b_data;
+					aed = (struct allocExtDesc *)oepos.bh->b_data;
 					aed->lengthAllocDescs =
-					    cpu_to_le32(le32_to_cpu
-							(aed->
-							 lengthAllocDescs) +
-							adsize);
+						cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) + adsize);
 				} else {
 					UDF_I_LENALLOC(table) += adsize;
 					mark_inode_dirty(table);
 				}
 			}
 			if (UDF_SB_UDFREV(sb) >= 0x0200)
-				udf_new_tag(epos.bh->b_data, TAG_IDENT_AED, 3,
-					    1, epos.block.logicalBlockNum,
-					    sizeof(tag));
+				udf_new_tag(epos.bh->b_data, TAG_IDENT_AED, 3, 1,
+					    epos.block.logicalBlockNum, sizeof(tag));
 			else
-				udf_new_tag(epos.bh->b_data, TAG_IDENT_AED, 2,
-					    1, epos.block.logicalBlockNum,
-					    sizeof(tag));
+				udf_new_tag(epos.bh->b_data, TAG_IDENT_AED, 2, 1,
+					    epos.block.logicalBlockNum, sizeof(tag));
+
 			switch (UDF_I_ALLOCTYPE(table)) {
-			case ICBTAG_FLAG_AD_SHORT:
-				{
-					sad = (short_ad *) sptr;
-					sad->extLength =
-					    cpu_to_le32
-					    (EXT_NEXT_EXTENT_ALLOCDECS | sb->
-					     s_blocksize);
-					sad->extPosition =
-					    cpu_to_le32(epos.block.
-							logicalBlockNum);
+				case ICBTAG_FLAG_AD_SHORT:
+					sad = (short_ad *)sptr;
+					sad->extLength = cpu_to_le32(
+						EXT_NEXT_EXTENT_ALLOCDECS |
+						sb->s_blocksize);
+					sad->extPosition = cpu_to_le32(epos.block.logicalBlockNum);
 					break;
-				}
-			case ICBTAG_FLAG_AD_LONG:
-				{
-					lad = (long_ad *) sptr;
-					lad->extLength =
-					    cpu_to_le32
-					    (EXT_NEXT_EXTENT_ALLOCDECS | sb->
-					     s_blocksize);
-					lad->extLocation =
-					    cpu_to_lelb(epos.block);
+				case ICBTAG_FLAG_AD_LONG:
+					lad = (long_ad *)sptr;
+					lad->extLength = cpu_to_le32(
+						EXT_NEXT_EXTENT_ALLOCDECS |
+						sb->s_blocksize);
+					lad->extLocation = cpu_to_lelb(epos.block);
 					break;
-				}
 			}
 			if (oepos.bh) {
 				udf_update_tag(oepos.bh->b_data, loffset);
 				mark_buffer_dirty(oepos.bh);
-			} else
+			} else {
 				mark_inode_dirty(table);
+			}
 		}
 
-		if (elen) {	/* It's possible that stealing the block emptied the extent */
+		if (elen) { /* It's possible that stealing the block emptied the extent */
 			udf_write_aext(table, &epos, eloc, elen, 1);
 
 			if (!epos.bh) {
@@ -668,9 +601,7 @@ static void udf_table_free_blocks(struct
 			} else {
 				aed = (struct allocExtDesc *)epos.bh->b_data;
 				aed->lengthAllocDescs =
-				    cpu_to_le32(le32_to_cpu
-						(aed->lengthAllocDescs) +
-						adsize);
+					cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) + adsize);
 				udf_update_tag(epos.bh->b_data, epos.offset);
 				mark_buffer_dirty(epos.bh);
 			}
@@ -680,7 +611,7 @@ static void udf_table_free_blocks(struct
 	brelse(epos.bh);
 	brelse(oepos.bh);
 
-      error_return:
+error_return:
 	sb->s_dirt = 1;
 	mutex_unlock(&sbi->s_alloc_mutex);
 	return;
@@ -714,47 +645,36 @@ static int udf_table_prealloc_blocks(str
 	epos.bh = NULL;
 	eloc.logicalBlockNum = 0xFFFFFFFF;
 
-	while (first_block != eloc.logicalBlockNum && (etype =
-						       udf_next_aext(table,
-								     &epos,
-								     &eloc,
-								     &elen,
-								     1)) !=
-	       -1) {
+	while (first_block != eloc.logicalBlockNum &&
+	       (etype = udf_next_aext(table, &epos, &eloc, &elen, 1)) != -1) {
 		udf_debug("eloc=%d, elen=%d, first_block=%d\n",
 			  eloc.logicalBlockNum, elen, first_block);
-		;		/* empty loop body */
+		; /* empty loop body */
 	}
 
 	if (first_block == eloc.logicalBlockNum) {
 		epos.offset -= adsize;
 
 		alloc_count = (elen >> sb->s_blocksize_bits);
-		if (inode
-		    && DQUOT_PREALLOC_BLOCK(inode,
-					    alloc_count >
-					    block_count ? block_count :
-					    alloc_count))
+		if (inode && DQUOT_PREALLOC_BLOCK(inode, alloc_count > block_count ? block_count : alloc_count)) {
 			alloc_count = 0;
-		else if (alloc_count > block_count) {
+		} else if (alloc_count > block_count) {
 			alloc_count = block_count;
 			eloc.logicalBlockNum += alloc_count;
 			elen -= (alloc_count << sb->s_blocksize_bits);
-			udf_write_aext(table, &epos, eloc, (etype << 30) | elen,
-				       1);
-		} else
-			udf_delete_aext(table, epos, eloc,
-					(etype << 30) | elen);
-	} else
+			udf_write_aext(table, &epos, eloc, (etype << 30) | elen, 1);
+		} else {
+			udf_delete_aext(table, epos, eloc, (etype << 30) | elen);
+		}
+	} else {
 		alloc_count = 0;
+	}
 
 	brelse(epos.bh);
 
 	if (alloc_count && UDF_SB_LVIDBH(sb)) {
 		UDF_SB_LVID(sb)->freeSpaceTable[partition] =
-		    cpu_to_le32(le32_to_cpu
-				(UDF_SB_LVID(sb)->freeSpaceTable[partition]) -
-				alloc_count);
+			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[partition]) - alloc_count);
 		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
 		sb->s_dirt = 1;
 	}
@@ -797,18 +717,17 @@ static int udf_table_new_block(struct su
 	epos.block = UDF_I_LOCATION(table);
 	epos.bh = goal_epos.bh = NULL;
 
-	while (spread && (etype =
-			  udf_next_aext(table, &epos, &eloc, &elen, 1)) != -1) {
+	while (spread &&
+	       (etype = udf_next_aext(table, &epos, &eloc, &elen, 1)) != -1) {
 		if (goal >= eloc.logicalBlockNum) {
-			if (goal <
-			    eloc.logicalBlockNum +
-			    (elen >> sb->s_blocksize_bits))
+			if (goal < eloc.logicalBlockNum + (elen >> sb->s_blocksize_bits))
 				nspread = 0;
 			else
 				nspread = goal - eloc.logicalBlockNum -
-				    (elen >> sb->s_blocksize_bits);
-		} else
+					(elen >> sb->s_blocksize_bits);
+		} else {
 			nspread = eloc.logicalBlockNum - goal;
+		}
 
 		if (nspread < spread) {
 			spread = nspread;
@@ -856,9 +775,7 @@ static int udf_table_new_block(struct su
 
 	if (UDF_SB_LVIDBH(sb)) {
 		UDF_SB_LVID(sb)->freeSpaceTable[partition] =
-		    cpu_to_le32(le32_to_cpu
-				(UDF_SB_LVID(sb)->freeSpaceTable[partition]) -
-				1);
+			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[partition]) - 1);
 		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
 	}
 
@@ -877,27 +794,23 @@ inline void udf_free_blocks(struct super
 
 	if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_BITMAP) {
 		return udf_bitmap_free_blocks(sb, inode,
-					      UDF_SB_PARTMAPS(sb)[partition].
-					      s_uspace.s_bitmap, bloc, offset,
-					      count);
-	} else if (UDF_SB_PARTFLAGS(sb, partition) &
-		   UDF_PART_FLAG_UNALLOC_TABLE) {
+					      UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_bitmap,
+					      bloc, offset, count);
+	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_TABLE) {
 		return udf_table_free_blocks(sb, inode,
-					     UDF_SB_PARTMAPS(sb)[partition].
-					     s_uspace.s_table, bloc, offset,
-					     count);
+					     UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_table,
+					     bloc, offset, count);
 	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_BITMAP) {
 		return udf_bitmap_free_blocks(sb, inode,
-					      UDF_SB_PARTMAPS(sb)[partition].
-					      s_fspace.s_bitmap, bloc, offset,
-					      count);
+					      UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_bitmap,
+					      bloc, offset, count);
 	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_TABLE) {
 		return udf_table_free_blocks(sb, inode,
-					     UDF_SB_PARTMAPS(sb)[partition].
-					     s_fspace.s_table, bloc, offset,
-					     count);
-	} else
+					     UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_table,
+					     bloc, offset, count);
+	} else {
 		return;
+	}
 }
 
 inline int udf_prealloc_blocks(struct super_block *sb,
@@ -907,29 +820,23 @@ inline int udf_prealloc_blocks(struct su
 {
 	if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_BITMAP) {
 		return udf_bitmap_prealloc_blocks(sb, inode,
-						  UDF_SB_PARTMAPS(sb)
-						  [partition].s_uspace.s_bitmap,
-						  partition, first_block,
-						  block_count);
-	} else if (UDF_SB_PARTFLAGS(sb, partition) &
-		   UDF_PART_FLAG_UNALLOC_TABLE) {
+						  UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_bitmap,
+						  partition, first_block, block_count);
+	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_TABLE) {
 		return udf_table_prealloc_blocks(sb, inode,
-						 UDF_SB_PARTMAPS(sb)[partition].
-						 s_uspace.s_table, partition,
-						 first_block, block_count);
+						 UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_table,
+						 partition, first_block, block_count);
 	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_BITMAP) {
 		return udf_bitmap_prealloc_blocks(sb, inode,
-						  UDF_SB_PARTMAPS(sb)
-						  [partition].s_fspace.s_bitmap,
-						  partition, first_block,
-						  block_count);
+						  UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_bitmap,
+						  partition, first_block, block_count);
 	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_TABLE) {
 		return udf_table_prealloc_blocks(sb, inode,
-						 UDF_SB_PARTMAPS(sb)[partition].
-						 s_fspace.s_table, partition,
-						 first_block, block_count);
-	} else
+						 UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_table,
+						 partition, first_block, block_count);
+	} else {
 		return 0;
+	}
 }
 
 inline int udf_new_block(struct super_block *sb,
@@ -940,26 +847,21 @@ inline int udf_new_block(struct super_bl
 
 	if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_BITMAP) {
 		ret = udf_bitmap_new_block(sb, inode,
-					   UDF_SB_PARTMAPS(sb)[partition].
-					   s_uspace.s_bitmap, partition, goal,
-					   err);
+					   UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_bitmap,
+					   partition, goal, err);
 		return ret;
-	} else if (UDF_SB_PARTFLAGS(sb, partition) &
-		   UDF_PART_FLAG_UNALLOC_TABLE) {
+	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_TABLE) {
 		return udf_table_new_block(sb, inode,
-					   UDF_SB_PARTMAPS(sb)[partition].
-					   s_uspace.s_table, partition, goal,
-					   err);
+					   UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_table,
+					   partition, goal, err);
 	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_BITMAP) {
 		return udf_bitmap_new_block(sb, inode,
-					    UDF_SB_PARTMAPS(sb)[partition].
-					    s_fspace.s_bitmap, partition, goal,
-					    err);
+					    UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_bitmap,
+					    partition, goal, err);
 	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_TABLE) {
 		return udf_table_new_block(sb, inode,
-					   UDF_SB_PARTMAPS(sb)[partition].
-					   s_fspace.s_table, partition, goal,
-					   err);
+					   UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_table,
+					   partition, goal, err);
 	} else {
 		*err = -EIO;
 		return 0;
diff -puN fs/udf/crc.c~udf-coding-style-conversion-lindent-fixups fs/udf/crc.c
--- a/fs/udf/crc.c~udf-coding-style-conversion-lindent-fixups
+++ a/fs/udf/crc.c
@@ -111,7 +111,7 @@ int main(void)
 	return 0;
 }
 
-#endif				/* defined(TEST) */
+#endif /* defined(TEST) */
 
 /****************************************************************************/
 #if defined(GENERATE)
@@ -169,4 +169,4 @@ int main(int argc, char **argv)
 	return 0;
 }
 
-#endif				/* defined(GENERATE) */
+#endif /* defined(GENERATE) */
diff -puN fs/udf/dir.c~udf-coding-style-conversion-lindent-fixups fs/udf/dir.c
--- a/fs/udf/dir.c~udf-coding-style-conversion-lindent-fixups
+++ a/fs/udf/dir.c
@@ -43,10 +43,10 @@ static int do_udf_readdir(struct inode *
 /* readdir and lookup functions */
 
 const struct file_operations udf_dir_operations = {
-	.read = generic_read_dir,
-	.readdir = udf_readdir,
-	.ioctl = udf_ioctl,
-	.fsync = udf_fsync_file,
+	.read			= generic_read_dir,
+	.readdir		= udf_readdir,
+	.ioctl			= udf_ioctl,
+	.fsync			= udf_fsync_file,
 };
 
 /*
@@ -83,8 +83,7 @@ int udf_readdir(struct file *filp, void 
 	lock_kernel();
 
 	if (filp->f_pos == 0) {
-		if (filldir(dirent, ".", 1, filp->f_pos, dir->i_ino, DT_DIR) <
-		    0) {
+		if (filldir(dirent, ".", 1, filp->f_pos, dir->i_ino, DT_DIR) < 0) {
 			unlock_kernel();
 			return 0;
 		}
@@ -93,7 +92,7 @@ int udf_readdir(struct file *filp, void 
 
 	result = do_udf_readdir(dir, filp, filldir, dirent);
 	unlock_kernel();
-	return result;
+ 	return result;
 }
 
 static int
@@ -125,21 +124,20 @@ do_udf_readdir(struct inode *dir, struct
 	if (nf_pos == 0)
 		nf_pos = (udf_ext0_offset(dir) >> 2);
 
-	fibh.soffset = fibh.eoffset =
-	    (nf_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
-	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
+	fibh.soffset = fibh.eoffset = (nf_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
+	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
 		fibh.sbh = fibh.ebh = NULL;
-	else if (inode_bmap(dir, nf_pos >> (dir->i_sb->s_blocksize_bits - 2),
-			    &epos, &eloc, &elen,
-			    &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
+	} else if (inode_bmap(dir, nf_pos >> (dir->i_sb->s_blocksize_bits - 2),
+			      &epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
 		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
 			if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_SHORT)
 				epos.offset -= sizeof(short_ad);
 			else if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_LONG)
 				epos.offset -= sizeof(long_ad);
-		} else
+		} else {
 			offset = 0;
+		}
 
 		if (!(fibh.sbh = fibh.ebh = udf_tread(dir->i_sb, block))) {
 			brelse(epos.bh);
@@ -149,15 +147,11 @@ do_udf_readdir(struct inode *dir, struct
 		if (!(offset & ((16 >> (dir->i_sb->s_blocksize_bits - 9)) - 1))) {
 			i = 16 >> (dir->i_sb->s_blocksize_bits - 9);
 			if (i + offset > (elen >> dir->i_sb->s_blocksize_bits))
-				i = (elen >> dir->i_sb->s_blocksize_bits) -
-				    offset;
+				i = (elen >> dir->i_sb->s_blocksize_bits) - offset;
 			for (num = 0; i > 0; i--) {
-				block =
-				    udf_get_lb_pblock(dir->i_sb, eloc,
-						      offset + i);
+				block = udf_get_lb_pblock(dir->i_sb, eloc, offset + i);
 				tmp = udf_tgetblk(dir->i_sb, block);
-				if (tmp && !buffer_uptodate(tmp)
-				    && !buffer_locked(tmp))
+				if (tmp && !buffer_uptodate(tmp) && !buffer_locked(tmp))
 					bha[num++] = tmp;
 				else
 					brelse(tmp);
@@ -178,7 +172,6 @@ do_udf_readdir(struct inode *dir, struct
 
 		fi = udf_fileident_read(dir, &nf_pos, &fibh, &cfi, &epos, &eloc,
 					&elen, &offset);
-
 		if (!fi) {
 			if (fibh.sbh != fibh.ebh)
 				brelse(fibh.ebh);
@@ -190,19 +183,16 @@ do_udf_readdir(struct inode *dir, struct
 		liu = le16_to_cpu(cfi.lengthOfImpUse);
 		lfi = cfi.lengthFileIdent;
 
-		if (fibh.sbh == fibh.ebh)
+		if (fibh.sbh == fibh.ebh) {
 			nameptr = fi->fileIdent + liu;
-		else {
+		} else {
 			int poffset;	/* Unpaded ending offset */
 
-			poffset =
-			    fibh.soffset + sizeof(struct fileIdentDesc) + liu +
-			    lfi;
-
-			if (poffset >= lfi)
-				nameptr =
-				    (char *)(fibh.ebh->b_data + poffset - lfi);
-			else {
+			poffset = fibh.soffset + sizeof(struct fileIdentDesc) + liu + lfi;
+
+			if (poffset >= lfi) {
+				nameptr = (char *)(fibh.ebh->b_data + poffset - lfi);
+			} else {
 				nameptr = fname;
 				memcpy(nameptr, fi->fileIdent + liu,
 				       lfi - poffset);
@@ -235,17 +225,15 @@ do_udf_readdir(struct inode *dir, struct
 		}
 
 		if (flen) {
-			if (filldir
-			    (dirent, fname, flen, filp->f_pos, iblock,
-			     dt_type) < 0) {
+			if (filldir(dirent, fname, flen, filp->f_pos, iblock, dt_type) < 0) {
 				if (fibh.sbh != fibh.ebh)
 					brelse(fibh.ebh);
 				brelse(fibh.sbh);
 				brelse(epos.bh);
-				return 0;
+	 			return 0;
 			}
 		}
-	}			/* end while */
+	} /* end while */
 
 	filp->f_pos = nf_pos + 1;
 
diff -puN fs/udf/directory.c~udf-coding-style-conversion-lindent-fixups fs/udf/directory.c
--- a/fs/udf/directory.c~udf-coding-style-conversion-lindent-fixups
+++ a/fs/udf/directory.c
@@ -31,7 +31,7 @@ static uint8_t *udf_filead_read(struct i
 
 	*error = 0;
 
-	ad = (uint8_t *) (*bh)->b_data + *offset;
+	ad = (uint8_t *)(*bh)->b_data + *offset;
 	*offset += ad_size;
 
 	if (!ad) {
@@ -51,7 +51,7 @@ static uint8_t *udf_filead_read(struct i
 		ad = tmpad;
 
 		remainder = dir->i_sb->s_blocksize - loffset;
-		memcpy((uint8_t *) ad, (*bh)->b_data + loffset, remainder);
+		memcpy((uint8_t *)ad, (*bh)->b_data + loffset, remainder);
 
 		brelse(*bh);
 		block = udf_get_lb_pblock(dir->i_sb, fe_loc, ++*pos);
@@ -60,10 +60,10 @@ static uint8_t *udf_filead_read(struct i
 		if (!((*bh) = udf_tread(dir->i_sb, block)))
 			return NULL;
 
-		memcpy((uint8_t *) ad + remainder, (*bh)->b_data,
-		       ad_size - remainder);
+		memcpy((uint8_t *)ad + remainder, (*bh)->b_data, ad_size - remainder);
 		*offset = ad_size - remainder;
 	}
+
 	return ad;
 }
 #endif
@@ -86,15 +86,13 @@ struct fileIdentDesc *udf_fileident_read
 				       (UDF_I_EFE(dir) ?
 					sizeof(struct extendedFileEntry) :
 					sizeof(struct fileEntry)),
-				       dir->i_sb->s_blocksize,
-				       &(fibh->eoffset));
-
+				       dir->i_sb->s_blocksize, &(fibh->eoffset));
 		if (!fi)
 			return NULL;
 
 		*nf_pos += ((fibh->eoffset - fibh->soffset) >> 2);
 
-		memcpy((uint8_t *) cfi, (uint8_t *) fi,
+		memcpy((uint8_t *)cfi, (uint8_t *)fi,
 		       sizeof(struct fileIdentDesc));
 
 		return fi;
@@ -121,21 +119,14 @@ struct fileIdentDesc *udf_fileident_read
 			return NULL;
 		fibh->soffset = fibh->eoffset = 0;
 
-		if (!
-		    (*offset & ((16 >> (dir->i_sb->s_blocksize_bits - 9)) - 1)))
-		{
+		if (!(*offset & ((16 >> (dir->i_sb->s_blocksize_bits - 9)) - 1))) {
 			i = 16 >> (dir->i_sb->s_blocksize_bits - 9);
-			if (i + *offset >
-			    (*elen >> dir->i_sb->s_blocksize_bits))
-				i = (*elen >> dir->i_sb->s_blocksize_bits) -
-				    *offset;
+			if (i + *offset > (*elen >> dir->i_sb->s_blocksize_bits))
+				i = (*elen >> dir->i_sb->s_blocksize_bits)-*offset;
 			for (num = 0; i > 0; i--) {
-				block =
-				    udf_get_lb_pblock(dir->i_sb, *eloc,
-						      *offset + i);
+				block = udf_get_lb_pblock(dir->i_sb, *eloc, *offset + i);
 				tmp = udf_tgetblk(dir->i_sb, block);
-				if (tmp && !buffer_uptodate(tmp)
-				    && !buffer_locked(tmp))
+				if (tmp && !buffer_uptodate(tmp) && !buffer_locked(tmp))
 					bha[num++] = tmp;
 				else
 					brelse(tmp);
@@ -160,7 +151,7 @@ struct fileIdentDesc *udf_fileident_read
 	*nf_pos += ((fibh->eoffset - fibh->soffset) >> 2);
 
 	if (fibh->eoffset <= dir->i_sb->s_blocksize) {
-		memcpy((uint8_t *) cfi, (uint8_t *) fi,
+		memcpy((uint8_t *)cfi, (uint8_t *)fi,
 		       sizeof(struct fileIdentDesc));
 	} else if (fibh->eoffset > dir->i_sb->s_blocksize) {
 		int lextoffset = epos->offset;
@@ -187,21 +178,17 @@ struct fileIdentDesc *udf_fileident_read
 		if (sizeof(struct fileIdentDesc) > -fibh->soffset) {
 			int fi_len;
 
-			memcpy((uint8_t *) cfi, (uint8_t *) fi, -fibh->soffset);
-			memcpy((uint8_t *) cfi - fibh->soffset,
-			       fibh->ebh->b_data,
+			memcpy((uint8_t *)cfi, (uint8_t *)fi, -fibh->soffset);
+			memcpy((uint8_t *)cfi - fibh->soffset, fibh->ebh->b_data,
 			       sizeof(struct fileIdentDesc) + fibh->soffset);
 
-			fi_len =
-			    (sizeof(struct fileIdentDesc) +
-			     cfi->lengthFileIdent +
-			     le16_to_cpu(cfi->lengthOfImpUse) + 3) & ~3;
+			fi_len = (sizeof(struct fileIdentDesc) + cfi->lengthFileIdent +
+				  le16_to_cpu(cfi->lengthOfImpUse) + 3) & ~3;
 
-			*nf_pos +=
-			    ((fi_len - (fibh->eoffset - fibh->soffset)) >> 2);
+			*nf_pos += ((fi_len - (fibh->eoffset - fibh->soffset)) >> 2);
 			fibh->eoffset = fibh->soffset + fi_len;
 		} else {
-			memcpy((uint8_t *) cfi, (uint8_t *) fi,
+			memcpy((uint8_t *)cfi, (uint8_t *)fi,
 			       sizeof(struct fileIdentDesc));
 		}
 	}
@@ -237,9 +224,10 @@ struct fileIdentDesc *udf_get_fileident(
 	}
 	if ((*offset + sizeof(struct fileIdentDesc)) > bufsize) {
 		lengthThisIdent = sizeof(struct fileIdentDesc);
-	} else
+	} else {
 		lengthThisIdent = sizeof(struct fileIdentDesc) +
-		    fi->lengthFileIdent + le16_to_cpu(fi->lengthOfImpUse);
+			fi->lengthFileIdent + le16_to_cpu(fi->lengthOfImpUse);
+	}
 
 	/* we need to figure padding, too! */
 	padlen = lengthThisIdent % UDF_NAME_PAD;
@@ -270,22 +258,20 @@ static extent_ad *udf_get_fileextent(voi
 		return NULL;
 	}
 
-	ptr =
-	    (uint8_t *) (fe->extendedAttr) +
-	    le32_to_cpu(fe->lengthExtendedAttr);
+	ptr = (uint8_t *)(fe->extendedAttr) + le32_to_cpu(fe->lengthExtendedAttr);
 
 	if ((*offset > 0) && (*offset < le32_to_cpu(fe->lengthAllocDescs))) {
 		ptr += *offset;
 	}
 
-	ext = (extent_ad *) ptr;
+	ext = (extent_ad *)ptr;
 
 	*offset = *offset + sizeof(extent_ad);
 	return ext;
 }
 #endif
 
-short_ad *udf_get_fileshortad(uint8_t * ptr, int maxoffset, int *offset,
+short_ad *udf_get_fileshortad(uint8_t *ptr, int maxoffset, int *offset,
 			      int inc)
 {
 	short_ad *sa;
@@ -297,7 +283,7 @@ short_ad *udf_get_fileshortad(uint8_t * 
 
 	if ((*offset < 0) || ((*offset + sizeof(short_ad)) > maxoffset))
 		return NULL;
-	else if ((sa = (short_ad *) ptr)->extLength == 0)
+	else if ((sa = (short_ad *)ptr)->extLength == 0)
 		return NULL;
 
 	if (inc)
@@ -305,7 +291,7 @@ short_ad *udf_get_fileshortad(uint8_t * 
 	return sa;
 }
 
-long_ad *udf_get_filelongad(uint8_t * ptr, int maxoffset, int *offset, int inc)
+long_ad *udf_get_filelongad(uint8_t *ptr, int maxoffset, int *offset, int inc)
 {
 	long_ad *la;
 
@@ -316,7 +302,7 @@ long_ad *udf_get_filelongad(uint8_t * pt
 
 	if ((*offset < 0) || ((*offset + sizeof(long_ad)) > maxoffset))
 		return NULL;
-	else if ((la = (long_ad *) ptr)->extLength == 0)
+	else if ((la = (long_ad *)ptr)->extLength == 0)
 		return NULL;
 
 	if (inc)
diff -puN fs/udf/ecma_167.h~udf-coding-style-conversion-lindent-fixups fs/udf/ecma_167.h
--- a/fs/udf/ecma_167.h~udf-coding-style-conversion-lindent-fixups
+++ a/fs/udf/ecma_167.h
@@ -39,8 +39,8 @@
 
 /* Character set specification (ECMA 167r3 1/7.2.1) */
 typedef struct {
-	uint8_t charSetType;
-	uint8_t charSetInfo[63];
+	uint8_t		charSetType;
+	uint8_t		charSetInfo[63];
 } __attribute__ ((packed)) charspec;
 
 /* Character Set Type (ECMA 167r3 1/7.2.1.1) */
@@ -54,33 +54,33 @@ typedef struct {
 #define CHARSPEC_TYPE_CS7		0x07	/* (1/7.2.9) */
 #define CHARSPEC_TYPE_CS8		0x08	/* (1/7.2.10) */
 
-typedef uint8_t dstring;
+typedef uint8_t		dstring;
 
 /* Timestamp (ECMA 167r3 1/7.3) */
 typedef struct {
-	__le16 typeAndTimezone;
-	__le16 year;
-	uint8_t month;
-	uint8_t day;
-	uint8_t hour;
-	uint8_t minute;
-	uint8_t second;
-	uint8_t centiseconds;
-	uint8_t hundredsOfMicroseconds;
-	uint8_t microseconds;
+	__le16		typeAndTimezone;
+	__le16		year;
+	uint8_t		month;
+	uint8_t		day;
+	uint8_t		hour;
+	uint8_t		minute;
+	uint8_t		second;
+	uint8_t		centiseconds;
+	uint8_t		hundredsOfMicroseconds;
+	uint8_t		microseconds;
 } __attribute__ ((packed)) timestamp;
 
 typedef struct {
-	uint16_t typeAndTimezone;
-	int16_t year;
-	uint8_t month;
-	uint8_t day;
-	uint8_t hour;
-	uint8_t minute;
-	uint8_t second;
-	uint8_t centiseconds;
-	uint8_t hundredsOfMicroseconds;
-	uint8_t microseconds;
+	uint16_t	typeAndTimezone;
+	int16_t		year;
+	uint8_t		month;
+	uint8_t		day;
+	uint8_t		hour;
+	uint8_t		minute;
+	uint8_t		second;
+	uint8_t		centiseconds;
+	uint8_t		hundredsOfMicroseconds;
+	uint8_t		microseconds;
 } __attribute__ ((packed)) kernel_timestamp;
 
 /* Type and Time Zone (ECMA 167r3 1/7.3.1) */
@@ -92,9 +92,9 @@ typedef struct {
 
 /* Entity identifier (ECMA 167r3 1/7.4) */
 typedef struct {
-	uint8_t flags;
-	uint8_t ident[23];
-	uint8_t identSuffix[8];
+	uint8_t		flags;
+	uint8_t		ident[23];
+	uint8_t		identSuffix[8];
 } __attribute__ ((packed)) regid;
 
 /* Flags (ECMA 167r3 1/7.4.1) */
@@ -104,10 +104,10 @@ typedef struct {
 /* Volume Structure Descriptor (ECMA 167r3 2/9.1) */
 #define VSD_STD_ID_LEN			5
 struct volStructDesc {
-	uint8_t structType;
-	uint8_t stdIdent[VSD_STD_ID_LEN];
-	uint8_t structVersion;
-	uint8_t structData[2041];
+	uint8_t		structType;
+	uint8_t		stdIdent[VSD_STD_ID_LEN];
+	uint8_t		structVersion;
+	uint8_t		structData[2041];
 } __attribute__ ((packed));
 
 /* Standard Identifier (EMCA 167r2 2/9.1.2) */
@@ -123,36 +123,36 @@ struct volStructDesc {
 
 /* Beginning Extended Area Descriptor (ECMA 167r3 2/9.2) */
 struct beginningExtendedAreaDesc {
-	uint8_t structType;
-	uint8_t stdIdent[VSD_STD_ID_LEN];
-	uint8_t structVersion;
-	uint8_t structData[2041];
+	uint8_t		structType;
+	uint8_t		stdIdent[VSD_STD_ID_LEN];
+	uint8_t		structVersion;
+	uint8_t		structData[2041];
 } __attribute__ ((packed));
 
 /* Terminating Extended Area Descriptor (ECMA 167r3 2/9.3) */
 struct terminatingExtendedAreaDesc {
-	uint8_t structType;
-	uint8_t stdIdent[VSD_STD_ID_LEN];
-	uint8_t structVersion;
-	uint8_t structData[2041];
+	uint8_t		structType;
+	uint8_t		stdIdent[VSD_STD_ID_LEN];
+	uint8_t		structVersion;
+	uint8_t		structData[2041];
 } __attribute__ ((packed));
 
 /* Boot Descriptor (ECMA 167r3 2/9.4) */
 struct bootDesc {
-	uint8_t structType;
-	uint8_t stdIdent[VSD_STD_ID_LEN];
-	uint8_t structVersion;
-	uint8_t reserved1;
-	regid archType;
-	regid bootIdent;
-	__le32 bootExtLocation;
-	__le32 bootExtLength;
-	__le64 loadAddress;
-	__le64 startAddress;
-	timestamp descCreationDateAndTime;
-	__le16 flags;
-	uint8_t reserved2[32];
-	uint8_t bootUse[1906];
+	uint8_t		structType;
+	uint8_t		stdIdent[VSD_STD_ID_LEN];
+	uint8_t		structVersion;
+	uint8_t		reserved1;
+	regid		archType;
+	regid		bootIdent;
+	__le32		bootExtLocation;
+	__le32		bootExtLength;
+	__le64		loadAddress;
+	__le64		startAddress;
+	timestamp	descCreationDateAndTime;
+	__le16		flags;
+	uint8_t		reserved2[32];
+	uint8_t		bootUse[1906];
 } __attribute__ ((packed));
 
 /* Flags (ECMA 167r3 2/9.4.12) */
@@ -160,25 +160,25 @@ struct bootDesc {
 
 /* Extent Descriptor (ECMA 167r3 3/7.1) */
 typedef struct {
-	__le32 extLength;
-	__le32 extLocation;
+	__le32		extLength;
+	__le32		extLocation;
 } __attribute__ ((packed)) extent_ad;
 
 typedef struct {
-	uint32_t extLength;
-	uint32_t extLocation;
+	uint32_t	extLength;
+	uint32_t	extLocation;
 } kernel_extent_ad;
 
 /* Descriptor Tag (ECMA 167r3 3/7.2) */
 typedef struct {
-	__le16 tagIdent;
-	__le16 descVersion;
-	uint8_t tagChecksum;
-	uint8_t reserved;
-	__le16 tagSerialNum;
-	__le16 descCRC;
-	__le16 descCRCLength;
-	__le32 tagLocation;
+	__le16		tagIdent;
+	__le16		descVersion;
+	uint8_t		tagChecksum;
+	uint8_t		reserved;
+	__le16		tagSerialNum;
+	__le16		descCRC;
+	__le16		descCRCLength;
+	__le32		tagLocation;
 } __attribute__ ((packed)) tag;
 
 /* Tag Identifier (ECMA 167r3 3/7.2.1) */
@@ -194,37 +194,37 @@ typedef struct {
 
 /* NSR Descriptor (ECMA 167r3 3/9.1) */
 struct NSRDesc {
-	uint8_t structType;
-	uint8_t stdIdent[VSD_STD_ID_LEN];
-	uint8_t structVersion;
-	uint8_t reserved;
-	uint8_t structData[2040];
+	uint8_t		structType;
+	uint8_t		stdIdent[VSD_STD_ID_LEN];
+	uint8_t		structVersion;
+	uint8_t		reserved;
+	uint8_t		structData[2040];
 } __attribute__ ((packed));
 
 /* Primary Volume Descriptor (ECMA 167r3 3/10.1) */
 struct primaryVolDesc {
-	tag descTag;
-	__le32 volDescSeqNum;
-	__le32 primaryVolDescNum;
-	dstring volIdent[32];
-	__le16 volSeqNum;
-	__le16 maxVolSeqNum;
-	__le16 interchangeLvl;
-	__le16 maxInterchangeLvl;
-	__le32 charSetList;
-	__le32 maxCharSetList;
-	dstring volSetIdent[128];
-	charspec descCharSet;
-	charspec explanatoryCharSet;
-	extent_ad volAbstract;
-	extent_ad volCopyright;
-	regid appIdent;
-	timestamp recordingDateAndTime;
-	regid impIdent;
-	uint8_t impUse[64];
-	__le32 predecessorVolDescSeqLocation;
-	__le16 flags;
-	uint8_t reserved[22];
+	tag		descTag;
+	__le32		volDescSeqNum;
+	__le32		primaryVolDescNum;
+	dstring		volIdent[32];
+	__le16		volSeqNum;
+	__le16		maxVolSeqNum;
+	__le16		interchangeLvl;
+	__le16		maxInterchangeLvl;
+	__le32		charSetList;
+	__le32		maxCharSetList;
+	dstring		volSetIdent[128];
+	charspec	descCharSet;
+	charspec	explanatoryCharSet;
+	extent_ad	volAbstract;
+	extent_ad	volCopyright;
+	regid		appIdent;
+	timestamp	recordingDateAndTime;
+	regid		impIdent;
+	uint8_t		impUse[64];
+	__le32		predecessorVolDescSeqLocation;
+	__le16		flags;
+	uint8_t		reserved[22];
 } __attribute__ ((packed));
 
 /* Flags (ECMA 167r3 3/10.1.21) */
@@ -232,26 +232,26 @@ struct primaryVolDesc {
 
 /* Anchor Volume Descriptor Pointer (ECMA 167r3 3/10.2) */
 struct anchorVolDescPtr {
-	tag descTag;
-	extent_ad mainVolDescSeqExt;
-	extent_ad reserveVolDescSeqExt;
-	uint8_t reserved[480];
+	tag		descTag;
+	extent_ad	mainVolDescSeqExt;
+	extent_ad	reserveVolDescSeqExt;
+	uint8_t	 	reserved[480];
 } __attribute__ ((packed));
 
 /* Volume Descriptor Pointer (ECMA 167r3 3/10.3) */
 struct volDescPtr {
-	tag descTag;
-	__le32 volDescSeqNum;
-	extent_ad nextVolDescSeqExt;
-	uint8_t reserved[484];
+	tag		descTag;
+	__le32		volDescSeqNum;
+	extent_ad	nextVolDescSeqExt;
+	uint8_t		reserved[484];
 } __attribute__ ((packed));
 
 /* Implementation Use Volume Descriptor (ECMA 167r3 3/10.4) */
 struct impUseVolDesc {
-	tag descTag;
-	__le32 volDescSeqNum;
-	regid impIdent;
-	uint8_t impUse[460];
+	tag		descTag;
+	__le32		volDescSeqNum;
+	regid		impIdent;
+	uint8_t		impUse[460];
 } __attribute__ ((packed));
 
 /* Partition Descriptor (ECMA 167r3 3/10.5) */
@@ -291,26 +291,26 @@ struct partitionDesc {
 
 /* Logical Volume Descriptor (ECMA 167r3 3/10.6) */
 struct logicalVolDesc {
-	tag descTag;
-	__le32 volDescSeqNum;
-	charspec descCharSet;
-	dstring logicalVolIdent[128];
-	__le32 logicalBlockSize;
-	regid domainIdent;
-	uint8_t logicalVolContentsUse[16];
-	__le32 mapTableLength;
-	__le32 numPartitionMaps;
-	regid impIdent;
-	uint8_t impUse[128];
-	extent_ad integritySeqExt;
-	uint8_t partitionMaps[0];
+	tag		descTag;
+	__le32		volDescSeqNum;
+	charspec	descCharSet;
+	dstring		logicalVolIdent[128];
+	__le32		logicalBlockSize;
+	regid		domainIdent;
+	uint8_t		logicalVolContentsUse[16];
+	__le32		mapTableLength;
+	__le32		numPartitionMaps;
+	regid		impIdent;
+	uint8_t		impUse[128];
+	extent_ad	integritySeqExt;
+	uint8_t		partitionMaps[0];
 } __attribute__ ((packed));
 
 /* Generic Partition Map (ECMA 167r3 3/10.7.1) */
 struct genericPartitionMap {
-	uint8_t partitionMapType;
-	uint8_t partitionMapLength;
-	uint8_t partitionMapping[0];
+	uint8_t		partitionMapType;
+	uint8_t		partitionMapLength;
+	uint8_t		partitionMapping[0];
 } __attribute__ ((packed));
 
 /* Partition Map Type (ECMA 167r3 3/10.7.1.1) */
@@ -320,45 +320,45 @@ struct genericPartitionMap {
 
 /* Type 1 Partition Map (ECMA 167r3 3/10.7.2) */
 struct genericPartitionMap1 {
-	uint8_t partitionMapType;
-	uint8_t partitionMapLength;
-	__le16 volSeqNum;
-	__le16 partitionNum;
+	uint8_t		partitionMapType;
+	uint8_t		partitionMapLength;
+	__le16		volSeqNum;
+	__le16		partitionNum;
 } __attribute__ ((packed));
 
 /* Type 2 Partition Map (ECMA 167r3 3/10.7.3) */
 struct genericPartitionMap2 {
-	uint8_t partitionMapType;
-	uint8_t partitionMapLength;
-	uint8_t partitionIdent[62];
+	uint8_t		partitionMapType;
+	uint8_t		partitionMapLength;
+	uint8_t		partitionIdent[62];
 } __attribute__ ((packed));
 
 /* Unallocated Space Descriptor (ECMA 167r3 3/10.8) */
 struct unallocSpaceDesc {
-	tag descTag;
-	__le32 volDescSeqNum;
-	__le32 numAllocDescs;
-	extent_ad allocDescs[0];
+	tag		descTag;
+	__le32		volDescSeqNum;
+	__le32		numAllocDescs;
+	extent_ad	allocDescs[0];
 } __attribute__ ((packed));
 
 /* Terminating Descriptor (ECMA 167r3 3/10.9) */
 struct terminatingDesc {
-	tag descTag;
-	uint8_t reserved[496];
+	tag		descTag;
+	uint8_t		reserved[496];
 } __attribute__ ((packed));
 
 /* Logical Volume Integrity Descriptor (ECMA 167r3 3/10.10) */
 struct logicalVolIntegrityDesc {
-	tag descTag;
-	timestamp recordingDateAndTime;
-	__le32 integrityType;
-	extent_ad nextIntegrityExt;
-	uint8_t logicalVolContentsUse[32];
-	__le32 numOfPartitions;
-	__le32 lengthOfImpUse;
-	__le32 freeSpaceTable[0];
-	__le32 sizeTable[0];
-	uint8_t impUse[0];
+	tag		descTag;
+	timestamp	recordingDateAndTime;
+	__le32		integrityType;
+	extent_ad	nextIntegrityExt;
+	uint8_t		logicalVolContentsUse[32];
+	__le32		numOfPartitions;
+	__le32		lengthOfImpUse;
+	__le32		freeSpaceTable[0];
+	__le32		sizeTable[0];
+	uint8_t		impUse[0];
 } __attribute__ ((packed));
 
 /* Integrity Type (ECMA 167r3 3/10.10.3) */
@@ -367,48 +367,48 @@ struct logicalVolIntegrityDesc {
 
 /* Recorded Address (ECMA 167r3 4/7.1) */
 typedef struct {
-	__le32 logicalBlockNum;
-	__le16 partitionReferenceNum;
+	__le32		logicalBlockNum;
+	__le16	 	partitionReferenceNum;
 } __attribute__ ((packed)) lb_addr;
 
 /* ... and its in-core analog */
 typedef struct {
-	uint32_t logicalBlockNum;
-	uint16_t partitionReferenceNum;
+	uint32_t		logicalBlockNum;
+	uint16_t	 	partitionReferenceNum;
 } kernel_lb_addr;
 
 /* Short Allocation Descriptor (ECMA 167r3 4/14.14.1) */
 typedef struct {
-	__le32 extLength;
-	__le32 extPosition;
+        __le32		extLength;
+        __le32		extPosition;
 } __attribute__ ((packed)) short_ad;
 
 /* Long Allocation Descriptor (ECMA 167r3 4/14.14.2) */
 typedef struct {
-	__le32 extLength;
-	lb_addr extLocation;
-	uint8_t impUse[6];
+	__le32		extLength;
+	lb_addr		extLocation;
+	uint8_t		impUse[6];
 } __attribute__ ((packed)) long_ad;
 
 typedef struct {
-	uint32_t extLength;
-	kernel_lb_addr extLocation;
-	uint8_t impUse[6];
+	uint32_t	extLength;
+	kernel_lb_addr	extLocation;
+	uint8_t		impUse[6];
 } kernel_long_ad;
 
 /* Extended Allocation Descriptor (ECMA 167r3 4/14.14.3) */
 typedef struct {
-	__le32 extLength;
-	__le32 recordedLength;
-	__le32 informationLength;
-	lb_addr extLocation;
+	__le32		extLength;
+	__le32		recordedLength;
+	__le32		informationLength;
+	lb_addr		extLocation;
 } __attribute__ ((packed)) ext_ad;
 
 typedef struct {
-	uint32_t extLength;
-	uint32_t recordedLength;
-	uint32_t informationLength;
-	kernel_lb_addr extLocation;
+	uint32_t	extLength;
+	uint32_t	recordedLength;
+	uint32_t	informationLength;
+	kernel_lb_addr	extLocation;
 } kernel_ext_ad;
 
 /* Descriptor Tag (ECMA 167r3 4/7.2 - See 3/7.2) */
@@ -428,48 +428,48 @@ typedef struct {
 
 /* File Set Descriptor (ECMA 167r3 4/14.1) */
 struct fileSetDesc {
-	tag descTag;
-	timestamp recordingDateAndTime;
-	__le16 interchangeLvl;
-	__le16 maxInterchangeLvl;
-	__le32 charSetList;
-	__le32 maxCharSetList;
-	__le32 fileSetNum;
-	__le32 fileSetDescNum;
-	charspec logicalVolIdentCharSet;
-	dstring logicalVolIdent[128];
-	charspec fileSetCharSet;
-	dstring fileSetIdent[32];
-	dstring copyrightFileIdent[32];
-	dstring abstractFileIdent[32];
-	long_ad rootDirectoryICB;
-	regid domainIdent;
-	long_ad nextExt;
-	long_ad streamDirectoryICB;
-	uint8_t reserved[32];
+	tag		descTag;
+	timestamp	recordingDateAndTime;
+	__le16		interchangeLvl;
+	__le16		maxInterchangeLvl;
+	__le32		charSetList;
+	__le32		maxCharSetList;
+	__le32		fileSetNum;
+	__le32		fileSetDescNum;
+	charspec	logicalVolIdentCharSet;
+	dstring		logicalVolIdent[128];
+	charspec	fileSetCharSet;
+	dstring		fileSetIdent[32];
+	dstring		copyrightFileIdent[32];
+	dstring		abstractFileIdent[32];
+	long_ad		rootDirectoryICB;
+	regid		domainIdent;
+	long_ad		nextExt;
+	long_ad		streamDirectoryICB;
+	uint8_t		reserved[32];
 } __attribute__ ((packed));
 
 /* Partition Header Descriptor (ECMA 167r3 4/14.3) */
 struct partitionHeaderDesc {
-	short_ad unallocSpaceTable;
-	short_ad unallocSpaceBitmap;
-	short_ad partitionIntegrityTable;
-	short_ad freedSpaceTable;
-	short_ad freedSpaceBitmap;
-	uint8_t reserved[88];
+	short_ad	unallocSpaceTable;
+	short_ad	unallocSpaceBitmap;
+	short_ad	partitionIntegrityTable;
+	short_ad	freedSpaceTable;
+	short_ad	freedSpaceBitmap;
+	uint8_t		reserved[88];
 } __attribute__ ((packed));
 
 /* File Identifier Descriptor (ECMA 167r3 4/14.4) */
 struct fileIdentDesc {
-	tag descTag;
-	__le16 fileVersionNum;
-	uint8_t fileCharacteristics;
-	uint8_t lengthFileIdent;
-	long_ad icb;
-	__le16 lengthOfImpUse;
-	uint8_t impUse[0];
-	uint8_t fileIdent[0];
-	uint8_t padding[0];
+	tag		descTag;
+	__le16		fileVersionNum;
+	uint8_t		fileCharacteristics;
+	uint8_t		lengthFileIdent;
+	long_ad		icb;
+	__le16		lengthOfImpUse;
+	uint8_t		impUse[0];
+	uint8_t		fileIdent[0];
+	uint8_t		padding[0];
 } __attribute__ ((packed));
 
 /* File Characteristics (ECMA 167r3 4/14.4.3) */
@@ -481,21 +481,21 @@ struct fileIdentDesc {
 
 /* Allocation Ext Descriptor (ECMA 167r3 4/14.5) */
 struct allocExtDesc {
-	tag descTag;
-	__le32 previousAllocExtLocation;
-	__le32 lengthAllocDescs;
+	tag		descTag;
+	__le32		previousAllocExtLocation;
+	__le32		lengthAllocDescs;
 } __attribute__ ((packed));
 
 /* ICB Tag (ECMA 167r3 4/14.6) */
 typedef struct {
-	__le32 priorRecordedNumDirectEntries;
-	__le16 strategyType;
-	__le16 strategyParameter;
-	__le16 numEntries;
-	uint8_t reserved;
-	uint8_t fileType;
-	lb_addr parentICBLocation;
-	__le16 flags;
+	__le32		priorRecordedNumDirectEntries;
+	__le16		strategyType;
+	__le16		strategyParameter;
+	__le16		numEntries;
+	uint8_t		reserved;
+	uint8_t		fileType;
+	lb_addr		parentICBLocation;
+	__le16		flags;
 } __attribute__ ((packed)) icbtag;
 
 /* Strategy Type (ECMA 167r3 4/14.6.2) */
@@ -541,41 +541,41 @@ typedef struct {
 
 /* Indirect Entry (ECMA 167r3 4/14.7) */
 struct indirectEntry {
-	tag descTag;
-	icbtag icbTag;
-	long_ad indirectICB;
+	tag		descTag;
+	icbtag		icbTag;
+	long_ad		indirectICB;
 } __attribute__ ((packed));
 
 /* Terminal Entry (ECMA 167r3 4/14.8) */
 struct terminalEntry {
-	tag descTag;
-	icbtag icbTag;
+	tag		descTag;
+	icbtag		icbTag;
 } __attribute__ ((packed));
 
 /* File Entry (ECMA 167r3 4/14.9) */
 struct fileEntry {
-	tag descTag;
-	icbtag icbTag;
-	__le32 uid;
-	__le32 gid;
-	__le32 permissions;
-	__le16 fileLinkCount;
-	uint8_t recordFormat;
-	uint8_t recordDisplayAttr;
-	__le32 recordLength;
-	__le64 informationLength;
-	__le64 logicalBlocksRecorded;
-	timestamp accessTime;
-	timestamp modificationTime;
-	timestamp attrTime;
-	__le32 checkpoint;
-	long_ad extendedAttrICB;
-	regid impIdent;
-	__le64 uniqueID;
-	__le32 lengthExtendedAttr;
-	__le32 lengthAllocDescs;
-	uint8_t extendedAttr[0];
-	uint8_t allocDescs[0];
+	tag		descTag;
+	icbtag		icbTag;
+	__le32		uid;
+	__le32		gid;
+	__le32		permissions;
+	__le16		fileLinkCount;
+	uint8_t		recordFormat;
+	uint8_t		recordDisplayAttr;
+	__le32		recordLength;
+	__le64		informationLength;
+	__le64		logicalBlocksRecorded;
+	timestamp	accessTime;
+	timestamp	modificationTime;
+	timestamp	attrTime;
+	__le32		checkpoint;
+	long_ad		extendedAttrICB;
+	regid		impIdent;
+	__le64		uniqueID;
+	__le32		lengthExtendedAttr;
+	__le32		lengthAllocDescs;
+	uint8_t		extendedAttr[0];
+	uint8_t		allocDescs[0];
 } __attribute__ ((packed));
 
 /* Permissions (ECMA 167r3 4/14.9.5) */
@@ -617,51 +617,51 @@ struct fileEntry {
 
 /* Extended Attribute Header Descriptor (ECMA 167r3 4/14.10.1) */
 struct extendedAttrHeaderDesc {
-	tag descTag;
-	__le32 impAttrLocation;
-	__le32 appAttrLocation;
+	tag		descTag;
+	__le32		impAttrLocation;
+	__le32		appAttrLocation;
 } __attribute__ ((packed));
 
 /* Generic Format (ECMA 167r3 4/14.10.2) */
 struct genericFormat {
-	__le32 attrType;
-	uint8_t attrSubtype;
-	uint8_t reserved[3];
-	__le32 attrLength;
-	uint8_t attrData[0];
+	__le32		attrType;
+	uint8_t		attrSubtype;
+	uint8_t		reserved[3];
+	__le32		attrLength;
+	uint8_t		attrData[0];
 } __attribute__ ((packed));
 
 /* Character Set Information (ECMA 167r3 4/14.10.3) */
 struct charSetInfo {
-	__le32 attrType;
-	uint8_t attrSubtype;
-	uint8_t reserved[3];
-	__le32 attrLength;
-	__le32 escapeSeqLength;
-	uint8_t charSetType;
-	uint8_t escapeSeq[0];
+	__le32		attrType;
+	uint8_t		attrSubtype;
+	uint8_t		reserved[3];
+	__le32		attrLength;
+	__le32		escapeSeqLength;
+	uint8_t		charSetType;
+	uint8_t		escapeSeq[0];
 } __attribute__ ((packed));
 
 /* Alternate Permissions (ECMA 167r3 4/14.10.4) */
 struct altPerms {
-	__le32 attrType;
-	uint8_t attrSubtype;
-	uint8_t reserved[3];
-	__le32 attrLength;
-	__le16 ownerIdent;
-	__le16 groupIdent;
-	__le16 permission;
+	__le32		attrType;
+	uint8_t		attrSubtype;
+	uint8_t		reserved[3];
+	__le32		attrLength;
+	__le16		ownerIdent;
+	__le16		groupIdent;
+	__le16		permission;
 } __attribute__ ((packed));
 
 /* File Times Extended Attribute (ECMA 167r3 4/14.10.5) */
 struct fileTimesExtAttr {
-	__le32 attrType;
-	uint8_t attrSubtype;
-	uint8_t reserved[3];
-	__le32 attrLength;
-	__le32 dataLength;
-	__le32 fileTimeExistence;
-	uint8_t fileTimes;
+	__le32		attrType;
+	uint8_t		attrSubtype;
+	uint8_t		reserved[3];
+	__le32		attrLength;
+	__le32		dataLength;
+	__le32		fileTimeExistence;
+	uint8_t		fileTimes;
 } __attribute__ ((packed));
 
 /* FileTimeExistence (ECMA 167r3 4/14.10.5.6) */
@@ -672,47 +672,47 @@ struct fileTimesExtAttr {
 
 /* Information Times Extended Attribute (ECMA 167r3 4/14.10.6) */
 struct infoTimesExtAttr {
-	__le32 attrType;
-	uint8_t attrSubtype;
-	uint8_t reserved[3];
-	__le32 attrLength;
-	__le32 dataLength;
-	__le32 infoTimeExistence;
-	uint8_t infoTimes[0];
+	__le32		attrType;
+	uint8_t		attrSubtype;
+	uint8_t		reserved[3];
+	__le32		attrLength;
+	__le32		dataLength;
+	__le32		infoTimeExistence;
+	uint8_t		infoTimes[0];
 } __attribute__ ((packed));
 
 /* Device Specification (ECMA 167r3 4/14.10.7) */
 struct deviceSpec {
-	__le32 attrType;
-	uint8_t attrSubtype;
-	uint8_t reserved[3];
-	__le32 attrLength;
-	__le32 impUseLength;
-	__le32 majorDeviceIdent;
-	__le32 minorDeviceIdent;
-	uint8_t impUse[0];
+	__le32		attrType;
+	uint8_t		attrSubtype;
+	uint8_t		reserved[3];
+	__le32		attrLength;
+	__le32		impUseLength;
+	__le32		majorDeviceIdent;
+	__le32		minorDeviceIdent;
+	uint8_t		impUse[0];
 } __attribute__ ((packed));
 
 /* Implementation Use Extended Attr (ECMA 167r3 4/14.10.8) */
 struct impUseExtAttr {
-	__le32 attrType;
-	uint8_t attrSubtype;
-	uint8_t reserved[3];
-	__le32 attrLength;
-	__le32 impUseLength;
-	regid impIdent;
-	uint8_t impUse[0];
+	__le32		attrType;
+	uint8_t		attrSubtype;
+	uint8_t		reserved[3];
+	__le32		attrLength;
+	__le32		impUseLength;
+	regid		impIdent;
+	uint8_t		impUse[0];
 } __attribute__ ((packed));
 
 /* Application Use Extended Attribute (ECMA 167r3 4/14.10.9) */
 struct appUseExtAttr {
-	__le32 attrType;
-	uint8_t attrSubtype;
-	uint8_t reserved[3];
-	__le32 attrLength;
-	__le32 appUseLength;
-	regid appIdent;
-	uint8_t appUse[0];
+	__le32		attrType;
+	uint8_t		attrSubtype;
+	uint8_t		reserved[3];
+	__le32		attrLength;
+	__le32		appUseLength;
+	regid		appIdent;
+	uint8_t		appUse[0];
 } __attribute__ ((packed));
 
 #define EXTATTR_CHAR_SET		1
@@ -725,29 +725,29 @@ struct appUseExtAttr {
 
 /* Unallocated Space Entry (ECMA 167r3 4/14.11) */
 struct unallocSpaceEntry {
-	tag descTag;
-	icbtag icbTag;
-	__le32 lengthAllocDescs;
-	uint8_t allocDescs[0];
+	tag		descTag;
+	icbtag		icbTag;
+	__le32		lengthAllocDescs;
+	uint8_t		allocDescs[0];
 } __attribute__ ((packed));
 
 /* Space Bitmap Descriptor (ECMA 167r3 4/14.12) */
 struct spaceBitmapDesc {
-	tag descTag;
-	__le32 numOfBits;
-	__le32 numOfBytes;
-	uint8_t bitmap[0];
+	tag		descTag;
+	__le32		numOfBits;
+	__le32		numOfBytes;
+	uint8_t		bitmap[0];
 } __attribute__ ((packed));
 
 /* Partition Integrity Entry (ECMA 167r3 4/14.13) */
 struct partitionIntegrityEntry {
-	tag descTag;
-	icbtag icbTag;
-	timestamp recordingDateAndTime;
-	uint8_t integrityType;
-	uint8_t reserved[175];
-	regid impIdent;
-	uint8_t impUse[256];
+	tag		descTag;
+	icbtag		icbTag;
+	timestamp	recordingDateAndTime;
+	uint8_t		integrityType;
+	uint8_t		reserved[175];
+	regid		impIdent;
+	uint8_t		impUse[256];
 } __attribute__ ((packed));
 
 /* Short Allocation Descriptor (ECMA 167r3 4/14.14.1) */
@@ -764,46 +764,46 @@ struct partitionIntegrityEntry {
 
 /* Logical Volume Header Descriptor (ECMA 167r3 4/14.15) */
 struct logicalVolHeaderDesc {
-	__le64 uniqueID;
-	uint8_t reserved[24];
+	__le64		uniqueID;
+	uint8_t		reserved[24];
 } __attribute__ ((packed));
 
 /* Path Component (ECMA 167r3 4/14.16.1) */
 struct pathComponent {
-	uint8_t componentType;
-	uint8_t lengthComponentIdent;
-	__le16 componentFileVersionNum;
-	dstring componentIdent[0];
+	uint8_t		componentType;
+	uint8_t		lengthComponentIdent;
+	__le16		componentFileVersionNum;
+	dstring		componentIdent[0];
 } __attribute__ ((packed));
 
 /* File Entry (ECMA 167r3 4/14.17) */
 struct extendedFileEntry {
-	tag descTag;
-	icbtag icbTag;
-	__le32 uid;
-	__le32 gid;
-	__le32 permissions;
-	__le16 fileLinkCount;
-	uint8_t recordFormat;
-	uint8_t recordDisplayAttr;
-	__le32 recordLength;
-	__le64 informationLength;
-	__le64 objectSize;
-	__le64 logicalBlocksRecorded;
-	timestamp accessTime;
-	timestamp modificationTime;
-	timestamp createTime;
-	timestamp attrTime;
-	__le32 checkpoint;
-	__le32 reserved;
-	long_ad extendedAttrICB;
-	long_ad streamDirectoryICB;
-	regid impIdent;
-	__le64 uniqueID;
-	__le32 lengthExtendedAttr;
-	__le32 lengthAllocDescs;
-	uint8_t extendedAttr[0];
-	uint8_t allocDescs[0];
+	tag		descTag;
+	icbtag		icbTag;
+	__le32		uid;
+	__le32		gid;
+	__le32		permissions;
+	__le16		fileLinkCount;
+	uint8_t		recordFormat;
+	uint8_t		recordDisplayAttr;
+	__le32		recordLength;
+	__le64		informationLength;
+	__le64		objectSize;
+	__le64		logicalBlocksRecorded;
+	timestamp	accessTime;
+	timestamp	modificationTime;
+	timestamp	createTime;
+	timestamp	attrTime;
+	__le32		checkpoint;
+	__le32		reserved;
+	long_ad		extendedAttrICB;
+	long_ad		streamDirectoryICB;
+	regid		impIdent;
+	__le64		uniqueID;
+	__le32		lengthExtendedAttr;
+	__le32		lengthAllocDescs;
+	uint8_t		extendedAttr[0];
+	uint8_t		allocDescs[0];
 } __attribute__ ((packed));
 
-#endif				/* _ECMA_167_H */
+#endif /* _ECMA_167_H */
diff -puN fs/udf/file.c~udf-coding-style-conversion-lindent-fixups fs/udf/file.c
--- a/fs/udf/file.c~udf-coding-style-conversion-lindent-fixups
+++ a/fs/udf/file.c
@@ -30,7 +30,7 @@
 #include <linux/udf_fs.h>
 #include <asm/uaccess.h>
 #include <linux/kernel.h>
-#include <linux/string.h>	/* memset */
+#include <linux/string.h> /* memset */
 #include <linux/capability.h>
 #include <linux/errno.h>
 #include <linux/smp_lock.h>
@@ -55,11 +55,11 @@ static int udf_adinicb_readpage(struct f
 	SetPageUptodate(page);
 	kunmap(page);
 	unlock_page(page);
+
 	return 0;
 }
 
-static int udf_adinicb_writepage(struct page *page,
-				 struct writeback_control *wbc)
+static int udf_adinicb_writepage(struct page *page, struct writeback_control *wbc)
 {
 	struct inode *inode = page->mapping->host;
 	char *kaddr;
@@ -72,6 +72,7 @@ static int udf_adinicb_writepage(struct 
 	SetPageUptodate(page);
 	kunmap(page);
 	unlock_page(page);
+
 	return 0;
 }
 
@@ -93,11 +94,11 @@ static int udf_adinicb_write_end(struct 
 }
 
 const struct address_space_operations udf_adinicb_aops = {
-	.readpage = udf_adinicb_readpage,
-	.writepage = udf_adinicb_writepage,
-	.sync_page = block_sync_page,
-	.write_begin = simple_write_begin,
-	.write_end = udf_adinicb_write_end,
+	.readpage	= udf_adinicb_readpage,
+	.writepage	= udf_adinicb_writepage,
+	.sync_page	= block_sync_page,
+	.write_begin	= simple_write_begin,
+	.write_end	= udf_adinicb_write_end,
 };
 
 static ssize_t udf_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
@@ -115,8 +116,8 @@ static ssize_t udf_file_aio_write(struct
 		else
 			pos = ppos;
 
-		if (inode->i_sb->s_blocksize <
-		    (udf_file_entry_alloc_offset(inode) + pos + count)) {
+		if (inode->i_sb->s_blocksize < (udf_file_entry_alloc_offset(inode) +
+						pos + count)) {
 			udf_expand_file_adinicb(inode, pos + count, &err);
 			if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB) {
 				udf_debug("udf_expand_adinicb: err=%d\n", err);
@@ -131,9 +132,9 @@ static ssize_t udf_file_aio_write(struct
 	}
 
 	retval = generic_file_aio_write(iocb, iov, nr_segs, ppos);
-
 	if (retval > 0)
 		mark_inode_dirty(inode);
+
 	return retval;
 }
 
@@ -174,10 +175,12 @@ static ssize_t udf_file_aio_write(struct
 int udf_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 	      unsigned long arg)
 {
+	long old_block, new_block;
 	int result = -EINVAL;
 
 	if (file_permission(filp, MAY_READ) != 0) {
-		udf_debug("no permission to access inode %lu\n", inode->i_ino);
+		udf_debug("no permission to access inode %lu\n",
+			  inode->i_ino);
 		return -EPERM;
 	}
 
@@ -189,26 +192,19 @@ int udf_ioctl(struct inode *inode, struc
 	switch (cmd) {
 	case UDF_GETVOLIDENT:
 		return copy_to_user((char __user *)arg,
-				    UDF_SB_VOLIDENT(inode->i_sb),
-				    32) ? -EFAULT : 0;
+				    UDF_SB_VOLIDENT(inode->i_sb), 32) ? -EFAULT : 0;
 	case UDF_RELOCATE_BLOCKS:
-		{
-			long old, new;
-
-			if (!capable(CAP_SYS_ADMIN))
-				return -EACCES;
-			if (get_user(old, (long __user *)arg))
-				return -EFAULT;
-			if ((result = udf_relocate_blocks(inode->i_sb,
-							  old, &new)) == 0)
-				result = put_user(new, (long __user *)arg);
-
-			return result;
-		}
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
+		if (get_user(old_block, (long __user *)arg))
+			return -EFAULT;
+		if ((result = udf_relocate_blocks(inode->i_sb,
+						  old_block, &new_block)) == 0)
+			result = put_user(new_block, (long __user *)arg);
+		return result;
 	case UDF_GETEASIZE:
 		result = put_user(UDF_I_LENEATTR(inode), (int __user *)arg);
 		break;
-
 	case UDF_GETEABLOCK:
 		result = copy_to_user((char __user *)arg, UDF_I_DATA(inode),
 				      UDF_I_LENEATTR(inode)) ? -EFAULT : 0;
@@ -241,16 +237,16 @@ static int udf_release_file(struct inode
 }
 
 const struct file_operations udf_file_operations = {
-	.read = do_sync_read,
-	.aio_read = generic_file_aio_read,
-	.ioctl = udf_ioctl,
-	.open = generic_file_open,
-	.mmap = generic_file_mmap,
-	.write = do_sync_write,
-	.aio_write = udf_file_aio_write,
-	.release = udf_release_file,
-	.fsync = udf_fsync_file,
-	.splice_read = generic_file_splice_read,
+	.read			= do_sync_read,
+	.aio_read		= generic_file_aio_read,
+	.ioctl			= udf_ioctl,
+	.open			= generic_file_open,
+	.mmap			= generic_file_mmap,
+	.write			= do_sync_write,
+	.aio_write		= udf_file_aio_write,
+	.release		= udf_release_file,
+	.fsync			= udf_fsync_file,
+	.splice_read		= generic_file_splice_read,
 };
 
 const struct inode_operations udf_file_inode_operations = {
diff -puN fs/udf/fsync.c~udf-coding-style-conversion-lindent-fixups fs/udf/fsync.c
--- a/fs/udf/fsync.c~udf-coding-style-conversion-lindent-fixups
+++ a/fs/udf/fsync.c
@@ -32,6 +32,7 @@ static int udf_fsync_inode(struct inode 
 int udf_fsync_file(struct file *file, struct dentry *dentry, int datasync)
 {
 	struct inode *inode = dentry->d_inode;
+
 	return udf_fsync_inode(inode, datasync);
 }
 
@@ -46,5 +47,6 @@ static int udf_fsync_inode(struct inode 
 		return err;
 
 	err |= udf_sync_inode(inode);
+
 	return err ? -EIO : 0;
 }
diff -puN fs/udf/ialloc.c~udf-coding-style-conversion-lindent-fixups fs/udf/ialloc.c
--- a/fs/udf/ialloc.c~udf-coding-style-conversion-lindent-fixups
+++ a/fs/udf/ialloc.c
@@ -46,12 +46,10 @@ void udf_free_inode(struct inode *inode)
 	if (sbi->s_lvidbh) {
 		if (S_ISDIR(inode->i_mode))
 			UDF_SB_LVIDIU(sb)->numDirs =
-			    cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numDirs)
-					- 1);
+				cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numDirs) - 1);
 		else
 			UDF_SB_LVIDIU(sb)->numFiles =
-			    cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numFiles)
-					- 1);
+				cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numFiles) - 1);
 
 		mark_buffer_dirty(sbi->s_lvidbh);
 	}
@@ -82,10 +80,8 @@ struct inode *udf_new_inode(struct inode
 	UDF_I_NEXT_ALLOC_GOAL(inode) = 0;
 	UDF_I_STRAT4096(inode) = 0;
 
-	block =
-	    udf_new_block(dir->i_sb, NULL,
-			  UDF_I_LOCATION(dir).partitionReferenceNum, start,
-			  err);
+	block = udf_new_block(dir->i_sb, NULL, UDF_I_LOCATION(dir).partitionReferenceNum,
+			      start, err);
 	if (*err) {
 		iput(inode);
 		return NULL;
@@ -95,17 +91,13 @@ struct inode *udf_new_inode(struct inode
 	if (UDF_SB_LVIDBH(sb)) {
 		struct logicalVolHeaderDesc *lvhd;
 		uint64_t uniqueID;
-		lvhd =
-		    (struct logicalVolHeaderDesc *)(UDF_SB_LVID(sb)->
-						    logicalVolContentsUse);
+		lvhd = (struct logicalVolHeaderDesc *)(UDF_SB_LVID(sb)->logicalVolContentsUse);
 		if (S_ISDIR(mode))
 			UDF_SB_LVIDIU(sb)->numDirs =
-			    cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numDirs)
-					+ 1);
+				cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numDirs) + 1);
 		else
 			UDF_SB_LVIDIU(sb)->numFiles =
-			    cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numFiles)
-					+ 1);
+				cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numFiles) + 1);
 		UDF_I_UNIQUE(inode) = uniqueID = le64_to_cpu(lvhd->uniqueID);
 		if (!(++uniqueID & 0x00000000FFFFFFFFUL))
 			uniqueID += 16;
@@ -118,12 +110,12 @@ struct inode *udf_new_inode(struct inode
 		inode->i_gid = dir->i_gid;
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
-	} else
+	} else {
 		inode->i_gid = current->fsgid;
+	}
 
 	UDF_I_LOCATION(inode).logicalBlockNum = block;
-	UDF_I_LOCATION(inode).partitionReferenceNum =
-	    UDF_I_LOCATION(dir).partitionReferenceNum;
+	UDF_I_LOCATION(inode).partitionReferenceNum = UDF_I_LOCATION(dir).partitionReferenceNum;
 	inode->i_ino = udf_get_lb_pblock(sb, UDF_I_LOCATION(inode), 0);
 	inode->i_blocks = 0;
 	UDF_I_LENEATTR(inode) = 0;
@@ -132,14 +124,10 @@ struct inode *udf_new_inode(struct inode
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_EXTENDED_FE)) {
 		UDF_I_EFE(inode) = 1;
 		UDF_UPDATE_UDFREV(inode->i_sb, UDF_VERS_USE_EXTENDED_FE);
-		UDF_I_DATA(inode) =
-		    kzalloc(inode->i_sb->s_blocksize -
-			    sizeof(struct extendedFileEntry), GFP_KERNEL);
+		UDF_I_DATA(inode) = kzalloc(inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry), GFP_KERNEL);
 	} else {
 		UDF_I_EFE(inode) = 0;
-		UDF_I_DATA(inode) =
-		    kzalloc(inode->i_sb->s_blocksize - sizeof(struct fileEntry),
-			    GFP_KERNEL);
+		UDF_I_DATA(inode) = kzalloc(inode->i_sb->s_blocksize - sizeof(struct fileEntry), GFP_KERNEL);
 	}
 	if (!UDF_I_DATA(inode)) {
 		iput(inode);
@@ -154,7 +142,7 @@ struct inode *udf_new_inode(struct inode
 	else
 		UDF_I_ALLOCTYPE(inode) = ICBTAG_FLAG_AD_LONG;
 	inode->i_mtime = inode->i_atime = inode->i_ctime =
-	    UDF_I_CRTIME(inode) = current_fs_time(inode->i_sb);
+		UDF_I_CRTIME(inode) = current_fs_time(inode->i_sb);
 	insert_inode_hash(inode);
 	mark_inode_dirty(inode);
 	mutex_unlock(&sbi->s_alloc_mutex);
diff -puN fs/udf/inode.c~udf-coding-style-conversion-lindent-fixups fs/udf/inode.c
--- a/fs/udf/inode.c~udf-coding-style-conversion-lindent-fixups
+++ a/fs/udf/inode.c
@@ -97,7 +97,8 @@ void udf_delete_inode(struct inode *inod
 
 	unlock_kernel();
 	return;
-      no_delete:
+
+no_delete:
 	clear_inode(inode);
 }
 
@@ -146,12 +147,12 @@ static sector_t udf_bmap(struct address_
 }
 
 const struct address_space_operations udf_aops = {
-	.readpage = udf_readpage,
-	.writepage = udf_writepage,
-	.sync_page = block_sync_page,
-	.write_begin = udf_write_begin,
-	.write_end = generic_write_end,
-	.bmap = udf_bmap,
+	.readpage	= udf_readpage,
+	.writepage	= udf_writepage,
+	.sync_page	= block_sync_page,
+	.write_begin	= udf_write_begin,
+	.write_end	= generic_write_end,
+	.bmap		= udf_bmap,
 };
 
 void udf_expand_file_adinicb(struct inode *inode, int newsize, int *err)
@@ -232,12 +233,10 @@ struct buffer_head *udf_expand_dir_adini
 	*block = udf_new_block(inode->i_sb, inode,
 			       UDF_I_LOCATION(inode).partitionReferenceNum,
 			       UDF_I_LOCATION(inode).logicalBlockNum, err);
-
 	if (!(*block))
 		return NULL;
 	newblock = udf_get_pblock(inode->i_sb, *block,
-				  UDF_I_LOCATION(inode).partitionReferenceNum,
-				  0);
+				  UDF_I_LOCATION(inode).partitionReferenceNum, 0);
 	if (!newblock)
 		return NULL;
 	dbh = udf_tgetblk(inode->i_sb, newblock);
@@ -249,16 +248,13 @@ struct buffer_head *udf_expand_dir_adini
 	unlock_buffer(dbh);
 	mark_buffer_dirty_inode(dbh, inode);
 
-	sfibh.soffset = sfibh.eoffset =
-	    (f_pos & ((inode->i_sb->s_blocksize - 1) >> 2)) << 2;
+	sfibh.soffset = sfibh.eoffset = (f_pos & ((inode->i_sb->s_blocksize - 1) >> 2)) << 2;
 	sfibh.sbh = sfibh.ebh = NULL;
 	dfibh.soffset = dfibh.eoffset = 0;
 	dfibh.sbh = dfibh.ebh = dbh;
 	while ((f_pos < size)) {
 		UDF_I_ALLOCTYPE(inode) = ICBTAG_FLAG_AD_IN_ICB;
-		sfi =
-		    udf_fileident_read(inode, &f_pos, &sfibh, &cfi, NULL, NULL,
-				       NULL, NULL);
+		sfi = udf_fileident_read(inode, &f_pos, &sfibh, &cfi, NULL, NULL, NULL, NULL);
 		if (!sfi) {
 			brelse(dbh);
 			return NULL;
@@ -269,8 +265,7 @@ struct buffer_head *udf_expand_dir_adini
 		dfibh.eoffset += (sfibh.eoffset - sfibh.soffset);
 		dfi = (struct fileIdentDesc *)(dbh->b_data + dfibh.soffset);
 		if (udf_write_fi(inode, sfi, dfi, &dfibh, sfi->impUse,
-				 sfi->fileIdent +
-				 le16_to_cpu(sfi->lengthOfImpUse))) {
+				 sfi->fileIdent + le16_to_cpu(sfi->lengthOfImpUse))) {
 			UDF_I_ALLOCTYPE(inode) = ICBTAG_FLAG_AD_IN_ICB;
 			brelse(dbh);
 			return NULL;
@@ -278,12 +273,10 @@ struct buffer_head *udf_expand_dir_adini
 	}
 	mark_buffer_dirty_inode(dbh, inode);
 
-	memset(UDF_I_DATA(inode) + UDF_I_LENEATTR(inode), 0,
-	       UDF_I_LENALLOC(inode));
+	memset(UDF_I_DATA(inode) + UDF_I_LENEATTR(inode), 0, UDF_I_LENALLOC(inode));
 	UDF_I_LENALLOC(inode) = 0;
 	eloc.logicalBlockNum = *block;
-	eloc.partitionReferenceNum =
-	    UDF_I_LOCATION(inode).partitionReferenceNum;
+	eloc.partitionReferenceNum = UDF_I_LOCATION(inode).partitionReferenceNum;
 	elen = inode->i_size;
 	UDF_I_LENEXTENTS(inode) = elen;
 	epos.bh = NULL;
@@ -336,11 +329,12 @@ static int udf_get_block(struct inode *i
 	if (new)
 		set_buffer_new(bh_result);
 	map_bh(bh_result, inode->i_sb, phys);
-      abort:
+
+abort:
 	unlock_kernel();
 	return err;
 
-      abort_negative:
+abort_negative:
 	udf_warning(inode->i_sb, "udf_get_block", "block < 0");
 	goto abort;
 }
@@ -348,13 +342,13 @@ static int udf_get_block(struct inode *i
 static struct buffer_head *udf_getblk(struct inode *inode, long block,
 				      int create, int *err)
 {
+	struct buffer_head *bh;
 	struct buffer_head dummy;
 
 	dummy.b_state = 0;
 	dummy.b_blocknr = -1000;
 	*err = udf_get_block(inode, block, &dummy, create);
 	if (!*err && buffer_mapped(&dummy)) {
-		struct buffer_head *bh;
 		bh = sb_getblk(inode->i_sb, dummy.b_blocknr);
 		if (buffer_new(&dummy)) {
 			lock_buffer(bh);
@@ -365,6 +359,7 @@ static struct buffer_head *udf_getblk(st
 		}
 		return bh;
 	}
+
 	return NULL;
 }
 
@@ -375,42 +370,41 @@ int udf_extend_file(struct inode *inode,
 	sector_t add;
 	int count = 0, fake = !(last_ext->extLength & UDF_EXTENT_LENGTH_MASK);
 	struct super_block *sb = inode->i_sb;
-	kernel_lb_addr prealloc_loc = { 0, 0 };
+	kernel_lb_addr prealloc_loc = {};
 	int prealloc_len = 0;
 
 	/* The previous extent is fake and we should not extend by anything
 	 * - there's nothing to do... */
 	if (!blocks && fake)
 		return 0;
+
 	/* Round the last extent up to a multiple of block size */
 	if (last_ext->extLength & (sb->s_blocksize - 1)) {
 		last_ext->extLength =
-		    (last_ext->extLength & UDF_EXTENT_FLAG_MASK) |
-		    (((last_ext->extLength & UDF_EXTENT_LENGTH_MASK) +
-		      sb->s_blocksize - 1) & ~(sb->s_blocksize - 1));
+			(last_ext->extLength & UDF_EXTENT_FLAG_MASK) |
+			(((last_ext->extLength & UDF_EXTENT_LENGTH_MASK) +
+			  sb->s_blocksize - 1) & ~(sb->s_blocksize - 1));
 		UDF_I_LENEXTENTS(inode) =
-		    (UDF_I_LENEXTENTS(inode) + sb->s_blocksize - 1) &
-		    ~(sb->s_blocksize - 1);
+			(UDF_I_LENEXTENTS(inode) + sb->s_blocksize - 1) &
+			~(sb->s_blocksize - 1);
 	}
+
 	/* Last extent are just preallocated blocks? */
-	if ((last_ext->extLength & UDF_EXTENT_FLAG_MASK) ==
-	    EXT_NOT_RECORDED_ALLOCATED) {
+	if ((last_ext->extLength & UDF_EXTENT_FLAG_MASK) == EXT_NOT_RECORDED_ALLOCATED) {
 		/* Save the extent so that we can reattach it to the end */
 		prealloc_loc = last_ext->extLocation;
 		prealloc_len = last_ext->extLength;
 		/* Mark the extent as a hole */
 		last_ext->extLength = EXT_NOT_RECORDED_NOT_ALLOCATED |
-		    (last_ext->extLength & UDF_EXTENT_LENGTH_MASK);
+			(last_ext->extLength & UDF_EXTENT_LENGTH_MASK);
 		last_ext->extLocation.logicalBlockNum = 0;
-		last_ext->extLocation.partitionReferenceNum = 0;
+       		last_ext->extLocation.partitionReferenceNum = 0;
 	}
+
 	/* Can we merge with the previous extent? */
-	if ((last_ext->extLength & UDF_EXTENT_FLAG_MASK) ==
-	    EXT_NOT_RECORDED_NOT_ALLOCATED) {
-		add =
-		    ((1 << 30) - sb->s_blocksize -
-		     (last_ext->extLength & UDF_EXTENT_LENGTH_MASK)) >> sb->
-		    s_blocksize_bits;
+	if ((last_ext->extLength & UDF_EXTENT_FLAG_MASK) == EXT_NOT_RECORDED_NOT_ALLOCATED) {
+		add = ((1 << 30) - sb->s_blocksize - (last_ext->extLength &
+						      UDF_EXTENT_LENGTH_MASK)) >> sb->s_blocksize_bits;
 		if (add > blocks)
 			add = blocks;
 		blocks -= add;
@@ -421,19 +415,20 @@ int udf_extend_file(struct inode *inode,
 		udf_add_aext(inode, last_pos, last_ext->extLocation,
 			     last_ext->extLength, 1);
 		count++;
-	} else
-		udf_write_aext(inode, last_pos, last_ext->extLocation,
-			       last_ext->extLength, 1);
+	} else {
+		udf_write_aext(inode, last_pos, last_ext->extLocation, last_ext->extLength, 1);
+	}
+
 	/* Managed to do everything necessary? */
 	if (!blocks)
 		goto out;
 
 	/* All further extents will be NOT_RECORDED_NOT_ALLOCATED */
 	last_ext->extLocation.logicalBlockNum = 0;
-	last_ext->extLocation.partitionReferenceNum = 0;
-	add = (1 << (30 - sb->s_blocksize_bits)) - 1;
-	last_ext->extLength =
-	    EXT_NOT_RECORDED_NOT_ALLOCATED | (add << sb->s_blocksize_bits);
+       	last_ext->extLocation.partitionReferenceNum = 0;
+	add = (1 << (30-sb->s_blocksize_bits)) - 1;
+	last_ext->extLength = EXT_NOT_RECORDED_NOT_ALLOCATED | (add << sb->s_blocksize_bits);
+
 	/* Create enough extents to cover the whole hole */
 	while (blocks > add) {
 		blocks -= add;
@@ -444,22 +439,23 @@ int udf_extend_file(struct inode *inode,
 	}
 	if (blocks) {
 		last_ext->extLength = EXT_NOT_RECORDED_NOT_ALLOCATED |
-		    (blocks << sb->s_blocksize_bits);
+			(blocks << sb->s_blocksize_bits);
 		if (udf_add_aext(inode, last_pos, last_ext->extLocation,
 				 last_ext->extLength, 1) == -1)
 			return -1;
 		count++;
 	}
-      out:
+
+out:
 	/* Do we have some preallocated blocks saved? */
 	if (prealloc_len) {
-		if (udf_add_aext(inode, last_pos, prealloc_loc, prealloc_len, 1)
-		    == -1)
+		if (udf_add_aext(inode, last_pos, prealloc_loc, prealloc_len, 1) == -1)
 			return -1;
 		last_ext->extLocation = prealloc_loc;
 		last_ext->extLength = prealloc_len;
 		count++;
 	}
+
 	/* last_pos should point to the last written extent... */
 	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_SHORT)
 		last_pos->offset -= sizeof(short_ad);
@@ -467,6 +463,7 @@ int udf_extend_file(struct inode *inode,
 		last_pos->offset -= sizeof(long_ad);
 	else
 		return -1;
+
 	return count;
 }
 
@@ -492,7 +489,7 @@ static struct buffer_head *inode_getblk(
 	prev_epos.block = UDF_I_LOCATION(inode);
 	prev_epos.bh = NULL;
 	cur_epos = next_epos = prev_epos;
-	b_off = (loff_t) block << inode->i_sb->s_blocksize_bits;
+	b_off = (loff_t)block << inode->i_sb->s_blocksize_bits;
 
 	/* find the extent which contains the block we are looking for.
 	   alternate between laarr[0] and laarr[1] for locations of the
@@ -517,8 +514,7 @@ static struct buffer_head *inode_getblk(
 		prev_epos.offset = cur_epos.offset;
 		cur_epos.offset = next_epos.offset;
 
-		if ((etype =
-		     udf_next_aext(inode, &next_epos, &eloc, &elen, 1)) == -1)
+		if ((etype = udf_next_aext(inode, &next_epos, &eloc, &elen, 1)) == -1)
 			break;
 
 		c = !c;
@@ -528,8 +524,8 @@ static struct buffer_head *inode_getblk(
 
 		if (etype != (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30))
 			pgoal = eloc.logicalBlockNum +
-			    ((elen + inode->i_sb->s_blocksize - 1) >>
-			     inode->i_sb->s_blocksize_bits);
+				((elen + inode->i_sb->s_blocksize - 1) >>
+				 inode->i_sb->s_blocksize_bits);
 
 		count++;
 	} while (lbcount + elen <= b_off);
@@ -549,8 +545,8 @@ static struct buffer_head *inode_getblk(
 	if (etype == (EXT_RECORDED_ALLOCATED >> 30)) {
 		if (elen & (inode->i_sb->s_blocksize - 1)) {
 			elen = EXT_RECORDED_ALLOCATED |
-			    ((elen + inode->i_sb->s_blocksize - 1) &
-			     ~(inode->i_sb->s_blocksize - 1));
+				((elen + inode->i_sb->s_blocksize - 1) &
+				 ~(inode->i_sb->s_blocksize - 1));
 			etype = udf_write_aext(inode, &cur_epos, eloc, elen, 1);
 		}
 		brelse(prev_epos.bh);
@@ -572,8 +568,7 @@ static struct buffer_head *inode_getblk(
 			startnum = 1;
 		} else {
 			/* Create a fake extent when there's not one */
-			memset(&laarr[0].extLocation, 0x00,
-			       sizeof(kernel_lb_addr));
+			memset(&laarr[0].extLocation, 0x00, sizeof(kernel_lb_addr));
 			laarr[0].extLength = EXT_NOT_RECORDED_NOT_ALLOCATED;
 			/* Will udf_extend_file() create real extent from a fake one? */
 			startnum = (offset > 0);
@@ -593,16 +588,14 @@ static struct buffer_head *inode_getblk(
 		offset = 0;
 		count += ret;
 		/* We are not covered by a preallocated extent? */
-		if ((laarr[0].extLength & UDF_EXTENT_FLAG_MASK) !=
-		    EXT_NOT_RECORDED_ALLOCATED) {
+		if ((laarr[0].extLength & UDF_EXTENT_FLAG_MASK) != EXT_NOT_RECORDED_ALLOCATED) {
 			/* Is there any real extent? - otherwise we overwrite
 			 * the fake one... */
 			if (count)
 				c = !c;
 			laarr[c].extLength = EXT_NOT_RECORDED_NOT_ALLOCATED |
-			    inode->i_sb->s_blocksize;
-			memset(&laarr[c].extLocation, 0x00,
-			       sizeof(kernel_lb_addr));
+				inode->i_sb->s_blocksize;
+			memset(&laarr[c].extLocation, 0x00, sizeof(kernel_lb_addr));
 			count++;
 			endnum++;
 		}
@@ -620,8 +613,7 @@ static struct buffer_head *inode_getblk(
 		}
 
 		/* if the current block is located in an extent, read the next extent */
-		if ((etype =
-		     udf_next_aext(inode, &next_epos, &eloc, &elen, 0)) != -1) {
+		if ((etype = udf_next_aext(inode, &next_epos, &eloc, &elen, 0)) != -1) {
 			laarr[c + 1].extLength = (etype << 30) | elen;
 			laarr[c + 1].extLocation = eloc;
 			count++;
@@ -633,24 +625,21 @@ static struct buffer_head *inode_getblk(
 	}
 
 	/* if the current extent is not recorded but allocated, get the
-	   block in the extent corresponding to the requested block */
-	if ((laarr[c].extLength >> 30) == (EXT_NOT_RECORDED_ALLOCATED >> 30))
+	 * block in the extent corresponding to the requested block */
+	if ((laarr[c].extLength >> 30) == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
 		newblocknum = laarr[c].extLocation.logicalBlockNum + offset;
-	else {			/* otherwise, allocate a new block */
-
+	} else { /* otherwise, allocate a new block */
 		if (UDF_I_NEXT_ALLOC_BLOCK(inode) == block)
 			goal = UDF_I_NEXT_ALLOC_GOAL(inode);
 
 		if (!goal) {
 			if (!(goal = pgoal))
-				goal =
-				    UDF_I_LOCATION(inode).logicalBlockNum + 1;
+				goal = UDF_I_LOCATION(inode).logicalBlockNum + 1;
 		}
 
 		if (!(newblocknum = udf_new_block(inode->i_sb, inode,
-						  UDF_I_LOCATION(inode).
-						  partitionReferenceNum, goal,
-						  err))) {
+						  UDF_I_LOCATION(inode).partitionReferenceNum,
+						  goal, err))) {
 			brelse(prev_epos.bh);
 			*err = -ENOSPC;
 			return NULL;
@@ -659,8 +648,8 @@ static struct buffer_head *inode_getblk(
 	}
 
 	/* if the extent the requsted block is located in contains multiple blocks,
-	   split the extent into at most three extents. blocks prior to requested
-	   block, requested block, and blocks after requested block */
+	 * split the extent into at most three extents. blocks prior to requested
+	 * block, requested block, and blocks after requested block */
 	udf_split_extents(inode, &c, offset, newblocknum, laarr, &endnum);
 
 #ifdef UDF_PREALLOCATE
@@ -672,15 +661,14 @@ static struct buffer_head *inode_getblk(
 	udf_merge_extents(inode, laarr, &endnum);
 
 	/* write back the new extents, inserting new extents if the new number
-	   of extents is greater than the old number, and deleting extents if
-	   the new number of extents is less than the old number */
+	 * of extents is greater than the old number, and deleting extents if
+	 * the new number of extents is less than the old number */
 	udf_update_extents(inode, laarr, startnum, endnum, &prev_epos);
 
 	brelse(prev_epos.bh);
 
 	if (!(newblock = udf_get_pblock(inode->i_sb, newblocknum,
-					UDF_I_LOCATION(inode).
-					partitionReferenceNum, 0))) {
+					UDF_I_LOCATION(inode).partitionReferenceNum, 0))) {
 		return NULL;
 	}
 	*phys = newblock;
@@ -694,6 +682,7 @@ static struct buffer_head *inode_getblk(
 		udf_sync_inode(inode);
 	else
 		mark_inode_dirty(inode);
+
 	return result;
 }
 
@@ -703,16 +692,15 @@ static void udf_split_extents(struct ino
 			      int *endnum)
 {
 	if ((laarr[*c].extLength >> 30) == (EXT_NOT_RECORDED_ALLOCATED >> 30) ||
-	    (laarr[*c].extLength >> 30) ==
-	    (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30)) {
+	    (laarr[*c].extLength >> 30) == (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30)) {
 		int curr = *c;
 		int blen = ((laarr[curr].extLength & UDF_EXTENT_LENGTH_MASK) +
-			    inode->i_sb->s_blocksize -
-			    1) >> inode->i_sb->s_blocksize_bits;
+			    inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits;
 		int8_t etype = (laarr[curr].extLength >> 30);
 
-		if (blen == 1) ;
-		else if (!offset || blen == offset + 1) {
+		if (blen == 1) {
+			;
+		} else if (!offset || blen == offset + 1) {
 			laarr[curr + 2] = laarr[curr + 1];
 			laarr[curr + 1] = laarr[curr];
 		} else {
@@ -722,20 +710,15 @@ static void udf_split_extents(struct ino
 
 		if (offset) {
 			if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
-				udf_free_blocks(inode->i_sb, inode,
-						laarr[curr].extLocation, 0,
-						offset);
-				laarr[curr].extLength =
-				    EXT_NOT_RECORDED_NOT_ALLOCATED | (offset <<
-								      inode->
-								      i_sb->
-								      s_blocksize_bits);
+				udf_free_blocks(inode->i_sb, inode, laarr[curr].extLocation, 0, offset);
+				laarr[curr].extLength = EXT_NOT_RECORDED_NOT_ALLOCATED |
+					(offset << inode->i_sb->s_blocksize_bits);
 				laarr[curr].extLocation.logicalBlockNum = 0;
-				laarr[curr].extLocation.partitionReferenceNum =
-				    0;
-			} else
+				laarr[curr].extLocation.partitionReferenceNum = 0;
+			} else {
 				laarr[curr].extLength = (etype << 30) |
-				    (offset << inode->i_sb->s_blocksize_bits);
+					(offset << inode->i_sb->s_blocksize_bits);
+			}
 			curr++;
 			(*c)++;
 			(*endnum)++;
@@ -744,18 +727,16 @@ static void udf_split_extents(struct ino
 		laarr[curr].extLocation.logicalBlockNum = newblocknum;
 		if (etype == (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30))
 			laarr[curr].extLocation.partitionReferenceNum =
-			    UDF_I_LOCATION(inode).partitionReferenceNum;
+				UDF_I_LOCATION(inode).partitionReferenceNum;
 		laarr[curr].extLength = EXT_RECORDED_ALLOCATED |
-		    inode->i_sb->s_blocksize;
+			inode->i_sb->s_blocksize;
 		curr++;
 
 		if (blen != offset + 1) {
 			if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30))
-				laarr[curr].extLocation.logicalBlockNum +=
-				    (offset + 1);
-			laarr[curr].extLength =
-			    (etype << 30) | ((blen - (offset + 1)) << inode->
-					     i_sb->s_blocksize_bits);
+				laarr[curr].extLocation.logicalBlockNum += (offset + 1);
+			laarr[curr].extLength = (etype << 30) |
+				((blen - (offset + 1)) << inode->i_sb->s_blocksize_bits);
 			curr++;
 			(*endnum)++;
 		}
@@ -774,90 +755,69 @@ static void udf_prealloc_extents(struct 
 		else
 			start = c;
 	} else {
-		if ((laarr[c + 1].extLength >> 30) ==
-		    (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
+		if ((laarr[c + 1].extLength >> 30) == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
 			start = c + 1;
-			length = currlength =
-			    (((laarr[c + 1].
-			       extLength & UDF_EXTENT_LENGTH_MASK) +
-			      inode->i_sb->s_blocksize -
-			      1) >> inode->i_sb->s_blocksize_bits);
-		} else
+			length = currlength = (((laarr[c + 1].extLength & UDF_EXTENT_LENGTH_MASK) +
+						inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits);
+		} else {
 			start = c;
+		}
 	}
 
 	for (i = start + 1; i <= *endnum; i++) {
 		if (i == *endnum) {
 			if (lastblock)
 				length += UDF_DEFAULT_PREALLOC_BLOCKS;
-		} else if ((laarr[i].extLength >> 30) ==
-			   (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30))
-			length +=
-			    (((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-			      inode->i_sb->s_blocksize -
-			      1) >> inode->i_sb->s_blocksize_bits);
-		else
+		} else if ((laarr[i].extLength >> 30) == (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30)) {
+			length += (((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
+				    inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits);
+		} else {
 			break;
+		}
 	}
 
 	if (length) {
 		int next = laarr[start].extLocation.logicalBlockNum +
-		    (((laarr[start].extLength & UDF_EXTENT_LENGTH_MASK) +
-		      inode->i_sb->s_blocksize -
-		      1) >> inode->i_sb->s_blocksize_bits);
+			(((laarr[start].extLength & UDF_EXTENT_LENGTH_MASK) +
+			  inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits);
 		int numalloc = udf_prealloc_blocks(inode->i_sb, inode,
-						   laarr[start].extLocation.
-						   partitionReferenceNum,
-						   next,
-						   (UDF_DEFAULT_PREALLOC_BLOCKS
-						    >
-						    length ? length :
-						    UDF_DEFAULT_PREALLOC_BLOCKS)
-						   - currlength);
-
-		if (numalloc) {
-			if (start == (c + 1))
+						   laarr[start].extLocation.partitionReferenceNum,
+						   next, (UDF_DEFAULT_PREALLOC_BLOCKS > length ? length :
+							  UDF_DEFAULT_PREALLOC_BLOCKS) - currlength);
+		if (numalloc) 	{
+			if (start == (c + 1)) {
 				laarr[start].extLength +=
-				    (numalloc << inode->i_sb->s_blocksize_bits);
-			else {
+					(numalloc << inode->i_sb->s_blocksize_bits);
+			} else {
 				memmove(&laarr[c + 2], &laarr[c + 1],
 					sizeof(long_ad) * (*endnum - (c + 1)));
 				(*endnum)++;
 				laarr[c + 1].extLocation.logicalBlockNum = next;
 				laarr[c + 1].extLocation.partitionReferenceNum =
-				    laarr[c].extLocation.partitionReferenceNum;
-				laarr[c + 1].extLength =
-				    EXT_NOT_RECORDED_ALLOCATED | (numalloc <<
-								  inode->i_sb->
-								  s_blocksize_bits);
+					laarr[c].extLocation.partitionReferenceNum;
+				laarr[c + 1].extLength = EXT_NOT_RECORDED_ALLOCATED |
+					(numalloc << inode->i_sb->s_blocksize_bits);
 				start = c + 1;
 			}
 
 			for (i = start + 1; numalloc && i < *endnum; i++) {
-				int elen =
-				    ((laarr[i].
-				      extLength & UDF_EXTENT_LENGTH_MASK) +
-				     inode->i_sb->s_blocksize -
-				     1) >> inode->i_sb->s_blocksize_bits;
+				int elen = ((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
+					    inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits;
 
 				if (elen > numalloc) {
 					laarr[i].extLength -=
-					    (numalloc << inode->i_sb->
-					     s_blocksize_bits);
+						(numalloc << inode->i_sb->s_blocksize_bits);
 					numalloc = 0;
 				} else {
 					numalloc -= elen;
 					if (*endnum > (i + 1))
-						memmove(&laarr[i],
-							&laarr[i + 1],
-							sizeof(long_ad) *
-							(*endnum - (i + 1)));
+						memmove(&laarr[i], &laarr[i + 1],
+							sizeof(long_ad) * (*endnum - (i + 1)));
 					i--;
 					(*endnum)--;
 				}
 			}
-			UDF_I_LENEXTENTS(inode) +=
-			    numalloc << inode->i_sb->s_blocksize_bits;
+			UDF_I_LENEXTENTS(inode) += numalloc << inode->i_sb->s_blocksize_bits;
 		}
 	}
 }
@@ -869,119 +829,68 @@ static void udf_merge_extents(struct ino
 	int i;
 
 	for (i = 0; i < (*endnum - 1); i++) {
-		if ((laarr[i].extLength >> 30) ==
-		    (laarr[i + 1].extLength >> 30)) {
-			if (((laarr[i].extLength >> 30) ==
-			     (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30))
-			    ||
-			    ((laarr[i + 1].extLocation.logicalBlockNum -
-			      laarr[i].extLocation.logicalBlockNum) ==
+		if ((laarr[i].extLength >> 30) == (laarr[i + 1].extLength >> 30)) {
+			if (((laarr[i].extLength >> 30) == (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30)) ||
+			    ((laarr[i + 1].extLocation.logicalBlockNum - laarr[i].extLocation.logicalBlockNum) ==
 			     (((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-			       inode->i_sb->s_blocksize -
-			       1) >> inode->i_sb->s_blocksize_bits))) {
-				if (((laarr[i].
-				      extLength & UDF_EXTENT_LENGTH_MASK) +
-				     (laarr[i + 1].
-				      extLength & UDF_EXTENT_LENGTH_MASK) +
-				     inode->i_sb->s_blocksize -
-				     1) & ~UDF_EXTENT_LENGTH_MASK) {
-					laarr[i + 1].extLength =
-					    (laarr[i + 1].extLength -
-					     (laarr[i].
-					      extLength &
-					      UDF_EXTENT_LENGTH_MASK) +
-					     UDF_EXTENT_LENGTH_MASK) & ~(inode->
-									 i_sb->
-									 s_blocksize
-									 - 1);
-					laarr[i].extLength =
-					    (laarr[i].
-					     extLength & UDF_EXTENT_FLAG_MASK) +
-					    (UDF_EXTENT_LENGTH_MASK + 1) -
-					    inode->i_sb->s_blocksize;
-					laarr[i +
-					      1].extLocation.logicalBlockNum =
-					    laarr[i].extLocation.
-					    logicalBlockNum +
-					    ((laarr[i].
-					      extLength &
-					      UDF_EXTENT_LENGTH_MASK) >> inode->
-					     i_sb->s_blocksize_bits);
+			       inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits))) {
+				if (((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
+				     (laarr[i + 1].extLength & UDF_EXTENT_LENGTH_MASK) +
+				     inode->i_sb->s_blocksize - 1) & ~UDF_EXTENT_LENGTH_MASK) {
+					laarr[i + 1].extLength = (laarr[i + 1].extLength -
+								  (laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
+								  UDF_EXTENT_LENGTH_MASK) & ~(inode->i_sb->s_blocksize - 1);
+					laarr[i].extLength = (laarr[i].extLength & UDF_EXTENT_FLAG_MASK) +
+						(UDF_EXTENT_LENGTH_MASK + 1) - inode->i_sb->s_blocksize;
+					laarr[i + 1].extLocation.logicalBlockNum =
+						laarr[i].extLocation.logicalBlockNum +
+						((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) >>
+						 inode->i_sb->s_blocksize_bits);
 				} else {
-					laarr[i].extLength =
-					    laarr[i + 1].extLength +
-					    (((laarr[i].
-					       extLength &
-					       UDF_EXTENT_LENGTH_MASK) +
-					      inode->i_sb->s_blocksize -
-					      1) & ~(inode->i_sb->s_blocksize -
-						     1));
+					laarr[i].extLength = laarr[i + 1].extLength +
+						(((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
+						  inode->i_sb->s_blocksize - 1) & ~(inode->i_sb->s_blocksize - 1));
 					if (*endnum > (i + 2))
-						memmove(&laarr[i + 1],
-							&laarr[i + 2],
-							sizeof(long_ad) *
-							(*endnum - (i + 2)));
+						memmove(&laarr[i + 1], &laarr[i + 2],
+							sizeof(long_ad) * (*endnum - (i + 2)));
 					i--;
 					(*endnum)--;
 				}
 			}
-		} else
-		    if (((laarr[i].extLength >> 30) ==
-			 (EXT_NOT_RECORDED_ALLOCATED >> 30))
-			&& ((laarr[i + 1].extLength >> 30) ==
-			    (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30))) {
-			udf_free_blocks(inode->i_sb, inode,
-					laarr[i].extLocation, 0,
-					((laarr[i].
-					  extLength & UDF_EXTENT_LENGTH_MASK) +
-					 inode->i_sb->s_blocksize -
-					 1) >> inode->i_sb->s_blocksize_bits);
+		} else if (((laarr[i].extLength >> 30) == (EXT_NOT_RECORDED_ALLOCATED >> 30)) &&
+			   ((laarr[i + 1].extLength >> 30) == (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30))) {
+			udf_free_blocks(inode->i_sb, inode, laarr[i].extLocation, 0,
+					((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
+					 inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits);
 			laarr[i].extLocation.logicalBlockNum = 0;
 			laarr[i].extLocation.partitionReferenceNum = 0;
 
 			if (((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
 			     (laarr[i + 1].extLength & UDF_EXTENT_LENGTH_MASK) +
-			     inode->i_sb->s_blocksize -
-			     1) & ~UDF_EXTENT_LENGTH_MASK) {
-				laarr[i + 1].extLength =
-				    (laarr[i + 1].extLength -
-				     (laarr[i].
-				      extLength & UDF_EXTENT_LENGTH_MASK) +
-				     UDF_EXTENT_LENGTH_MASK) & ~(inode->i_sb->
-								 s_blocksize -
-								 1);
-				laarr[i].extLength =
-				    (laarr[i].
-				     extLength & UDF_EXTENT_FLAG_MASK) +
-				    (UDF_EXTENT_LENGTH_MASK + 1) -
-				    inode->i_sb->s_blocksize;
+			     inode->i_sb->s_blocksize - 1) & ~UDF_EXTENT_LENGTH_MASK) {
+				laarr[i + 1].extLength = (laarr[i + 1].extLength -
+							  (laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
+							  UDF_EXTENT_LENGTH_MASK) & ~(inode->i_sb->s_blocksize - 1);
+				laarr[i].extLength = (laarr[i].extLength & UDF_EXTENT_FLAG_MASK) +
+					(UDF_EXTENT_LENGTH_MASK + 1) - inode->i_sb->s_blocksize;
 			} else {
 				laarr[i].extLength = laarr[i + 1].extLength +
-				    (((laarr[i].
-				       extLength & UDF_EXTENT_LENGTH_MASK) +
-				      inode->i_sb->s_blocksize -
-				      1) & ~(inode->i_sb->s_blocksize - 1));
+					(((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
+					  inode->i_sb->s_blocksize - 1) & ~(inode->i_sb->s_blocksize - 1));
 				if (*endnum > (i + 2))
 					memmove(&laarr[i + 1], &laarr[i + 2],
-						sizeof(long_ad) * (*endnum -
-								   (i + 2)));
+						sizeof(long_ad) * (*endnum - (i + 2)));
 				i--;
 				(*endnum)--;
 			}
-		} else if ((laarr[i].extLength >> 30) ==
-			   (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
-			udf_free_blocks(inode->i_sb, inode,
-					laarr[i].extLocation, 0,
-					((laarr[i].
-					  extLength & UDF_EXTENT_LENGTH_MASK) +
-					 inode->i_sb->s_blocksize -
-					 1) >> inode->i_sb->s_blocksize_bits);
+		} else if ((laarr[i].extLength >> 30) == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
+			udf_free_blocks(inode->i_sb, inode, laarr[i].extLocation, 0,
+					((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
+					 inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits);
 			laarr[i].extLocation.logicalBlockNum = 0;
 			laarr[i].extLocation.partitionReferenceNum = 0;
-			laarr[i].extLength =
-			    (laarr[i].
-			     extLength & UDF_EXTENT_LENGTH_MASK) |
-			    EXT_NOT_RECORDED_NOT_ALLOCATED;
+			laarr[i].extLength = (laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) |
+				EXT_NOT_RECORDED_NOT_ALLOCATED;
 		}
 	}
 }
@@ -1027,10 +936,13 @@ struct buffer_head *udf_bread(struct ino
 
 	if (buffer_uptodate(bh))
 		return bh;
+
 	ll_rw_block(READ, 1, &bh);
+
 	wait_on_buffer(bh);
 	if (buffer_uptodate(bh))
 		return bh;
+
 	brelse(bh);
 	*err = -EIO;
 	return NULL;
@@ -1049,26 +961,24 @@ void udf_truncate(struct inode *inode)
 
 	lock_kernel();
 	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB) {
-		if (inode->i_sb->s_blocksize <
-		    (udf_file_entry_alloc_offset(inode) + inode->i_size)) {
+		if (inode->i_sb->s_blocksize < (udf_file_entry_alloc_offset(inode) +
+						inode->i_size)) {
 			udf_expand_file_adinicb(inode, inode->i_size, &err);
 			if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB) {
 				inode->i_size = UDF_I_LENALLOC(inode);
 				unlock_kernel();
 				return;
-			} else
+			} else {
 				udf_truncate_extents(inode);
+			}
 		} else {
 			offset = inode->i_size & (inode->i_sb->s_blocksize - 1);
-			memset(UDF_I_DATA(inode) + UDF_I_LENEATTR(inode) +
-			       offset, 0x00,
-			       inode->i_sb->s_blocksize - offset -
-			       udf_file_entry_alloc_offset(inode));
+			memset(UDF_I_DATA(inode) + UDF_I_LENEATTR(inode) + offset, 0x00,
+			       inode->i_sb->s_blocksize - offset - udf_file_entry_alloc_offset(inode));
 			UDF_I_LENALLOC(inode) = inode->i_size;
 		}
 	} else {
-		block_truncate_page(inode->i_mapping, inode->i_size,
-				    udf_get_block);
+		block_truncate_page(inode->i_mapping, inode->i_size, udf_get_block);
 		udf_truncate_extents(inode);
 	}
 
@@ -1099,7 +1009,6 @@ static void __udf_read_inode(struct inod
 	 *      i_op = NULL;
 	 */
 	bh = udf_read_ptagged(inode->i_sb, UDF_I_LOCATION(inode), 0, &ident);
-
 	if (!bh) {
 		printk(KERN_ERR "udf: udf_read_inode(ino %ld) failed !bh\n",
 		       inode->i_ino);
@@ -1109,8 +1018,7 @@ static void __udf_read_inode(struct inod
 
 	if (ident != TAG_IDENT_FE && ident != TAG_IDENT_EFE &&
 	    ident != TAG_IDENT_USE) {
-		printk(KERN_ERR
-		       "udf: udf_read_inode(ino %ld) failed ident=%d\n",
+		printk(KERN_ERR "udf: udf_read_inode(ino %ld) failed ident=%d\n",
 		       inode->i_ino, ident);
 		brelse(bh);
 		make_bad_inode(inode);
@@ -1123,9 +1031,7 @@ static void __udf_read_inode(struct inod
 		struct buffer_head *ibh = NULL, *nbh = NULL;
 		struct indirectEntry *ie;
 
-		ibh =
-		    udf_read_ptagged(inode->i_sb, UDF_I_LOCATION(inode), 1,
-				     &ident);
+		ibh = udf_read_ptagged(inode->i_sb, UDF_I_LOCATION(inode), 1, &ident);
 		if (ident == TAG_IDENT_IE) {
 			if (ibh) {
 				kernel_lb_addr loc;
@@ -1134,13 +1040,10 @@ static void __udf_read_inode(struct inod
 				loc = lelb_to_cpu(ie->indirectICB.extLocation);
 
 				if (ie->indirectICB.extLength &&
-				    (nbh =
-				     udf_read_ptagged(inode->i_sb, loc, 0,
-						      &ident))) {
-					if (ident == TAG_IDENT_FE
-					    || ident == TAG_IDENT_EFE) {
-						memcpy(&UDF_I_LOCATION(inode),
-						       &loc,
+				    (nbh = udf_read_ptagged(inode->i_sb, loc, 0, &ident))) {
+					if (ident == TAG_IDENT_FE ||
+					    ident == TAG_IDENT_EFE) {
+						memcpy(&UDF_I_LOCATION(inode), &loc,
 						       sizeof(kernel_lb_addr));
 						brelse(bh);
 						brelse(ibh);
@@ -1151,11 +1054,13 @@ static void __udf_read_inode(struct inod
 						brelse(nbh);
 						brelse(ibh);
 					}
-				} else
+				} else {
 					brelse(ibh);
+				}
 			}
-		} else
+		} else {
 			brelse(ibh);
+		}
 	} else if (le16_to_cpu(fe->icbTag.strategyType) != 4) {
 		printk(KERN_ERR "udf: unsupported strategy type: %d\n",
 		       le16_to_cpu(fe->icbTag.strategyType));
@@ -1181,11 +1086,10 @@ static void udf_fill_inode(struct inode 
 
 	if (le16_to_cpu(fe->icbTag.strategyType) == 4)
 		UDF_I_STRAT4096(inode) = 0;
-	else			/* if (le16_to_cpu(fe->icbTag.strategyType) == 4096) */
+	else /* if (le16_to_cpu(fe->icbTag.strategyType) == 4096) */
 		UDF_I_STRAT4096(inode) = 1;
 
-	UDF_I_ALLOCTYPE(inode) =
-	    le16_to_cpu(fe->icbTag.flags) & ICBTAG_FLAG_AD_MASK;
+	UDF_I_ALLOCTYPE(inode) = le16_to_cpu(fe->icbTag.flags) & ICBTAG_FLAG_AD_MASK;
 	UDF_I_UNIQUE(inode) = 0;
 	UDF_I_LENEATTR(inode) = 0;
 	UDF_I_LENEXTENTS(inode) = 0;
@@ -1195,23 +1099,15 @@ static void udf_fill_inode(struct inode 
 	if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_EFE) {
 		UDF_I_EFE(inode) = 1;
 		UDF_I_USE(inode) = 0;
-		if (udf_alloc_i_data
-		    (inode,
-		     inode->i_sb->s_blocksize -
-		     sizeof(struct extendedFileEntry))) {
+		if (udf_alloc_i_data(inode, inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry))) {
 			make_bad_inode(inode);
 			return;
 		}
-		memcpy(UDF_I_DATA(inode),
-		       bh->b_data + sizeof(struct extendedFileEntry),
-		       inode->i_sb->s_blocksize -
-		       sizeof(struct extendedFileEntry));
+		memcpy(UDF_I_DATA(inode), bh->b_data + sizeof(struct extendedFileEntry), inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry));
 	} else if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_FE) {
 		UDF_I_EFE(inode) = 0;
 		UDF_I_USE(inode) = 0;
-		if (udf_alloc_i_data
-		    (inode,
-		     inode->i_sb->s_blocksize - sizeof(struct fileEntry))) {
+		if (udf_alloc_i_data(inode, inode->i_sb->s_blocksize - sizeof(struct fileEntry))) {
 			make_bad_inode(inode);
 			return;
 		}
@@ -1221,19 +1117,13 @@ static void udf_fill_inode(struct inode 
 		UDF_I_EFE(inode) = 0;
 		UDF_I_USE(inode) = 1;
 		UDF_I_LENALLOC(inode) =
-		    le32_to_cpu(((struct unallocSpaceEntry *)bh->b_data)->
-				lengthAllocDescs);
-		if (udf_alloc_i_data
-		    (inode,
-		     inode->i_sb->s_blocksize -
-		     sizeof(struct unallocSpaceEntry))) {
+		    le32_to_cpu(((struct unallocSpaceEntry *)bh->b_data)->lengthAllocDescs);
+		if (udf_alloc_i_data(inode, inode->i_sb->s_blocksize - sizeof(struct unallocSpaceEntry))) {
 			make_bad_inode(inode);
 			return;
 		}
-		memcpy(UDF_I_DATA(inode),
-		       bh->b_data + sizeof(struct unallocSpaceEntry),
-		       inode->i_sb->s_blocksize -
-		       sizeof(struct unallocSpaceEntry));
+		memcpy(UDF_I_DATA(inode), bh->b_data + sizeof(struct unallocSpaceEntry),
+		       inode->i_sb->s_blocksize - sizeof(struct unallocSpaceEntry));
 		return;
 	}
 
@@ -1259,7 +1149,7 @@ static void udf_fill_inode(struct inode 
 
 	if (UDF_I_EFE(inode) == 0) {
 		inode->i_blocks = le64_to_cpu(fe->logicalBlocksRecorded) <<
-		    (inode->i_sb->s_blocksize_bits - 9);
+			(inode->i_sb->s_blocksize_bits - 9);
 
 		if (udf_stamp_to_time(&convtime, &convtime_usec,
 				      lets_to_cpu(fe->accessTime))) {
@@ -1328,78 +1218,56 @@ static void udf_fill_inode(struct inode 
 		UDF_I_UNIQUE(inode) = le64_to_cpu(efe->uniqueID);
 		UDF_I_LENEATTR(inode) = le32_to_cpu(efe->lengthExtendedAttr);
 		UDF_I_LENALLOC(inode) = le32_to_cpu(efe->lengthAllocDescs);
-		offset =
-		    sizeof(struct extendedFileEntry) + UDF_I_LENEATTR(inode);
+		offset = sizeof(struct extendedFileEntry) + UDF_I_LENEATTR(inode);
 	}
 
 	switch (fe->icbTag.fileType) {
 	case ICBTAG_FILE_TYPE_DIRECTORY:
-		{
-			inode->i_op = &udf_dir_inode_operations;
-			inode->i_fop = &udf_dir_operations;
-			inode->i_mode |= S_IFDIR;
-			inc_nlink(inode);
-			break;
-		}
+		inode->i_op = &udf_dir_inode_operations;
+		inode->i_fop = &udf_dir_operations;
+		inode->i_mode |= S_IFDIR;
+		inc_nlink(inode);
+		break;
 	case ICBTAG_FILE_TYPE_REALTIME:
 	case ICBTAG_FILE_TYPE_REGULAR:
 	case ICBTAG_FILE_TYPE_UNDEF:
-		{
-			if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB)
-				inode->i_data.a_ops = &udf_adinicb_aops;
-			else
-				inode->i_data.a_ops = &udf_aops;
-			inode->i_op = &udf_file_inode_operations;
-			inode->i_fop = &udf_file_operations;
-			inode->i_mode |= S_IFREG;
-			break;
-		}
+		if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB)
+			inode->i_data.a_ops = &udf_adinicb_aops;
+		else
+			inode->i_data.a_ops = &udf_aops;
+		inode->i_op = &udf_file_inode_operations;
+		inode->i_fop = &udf_file_operations;
+		inode->i_mode |= S_IFREG;
+		break;
 	case ICBTAG_FILE_TYPE_BLOCK:
-		{
-			inode->i_mode |= S_IFBLK;
-			break;
-		}
+		inode->i_mode |= S_IFBLK;
+		break;
 	case ICBTAG_FILE_TYPE_CHAR:
-		{
-			inode->i_mode |= S_IFCHR;
-			break;
-		}
+		inode->i_mode |= S_IFCHR;
+		break;
 	case ICBTAG_FILE_TYPE_FIFO:
-		{
-			init_special_inode(inode, inode->i_mode | S_IFIFO, 0);
-			break;
-		}
+		init_special_inode(inode, inode->i_mode | S_IFIFO, 0);
+		break;
 	case ICBTAG_FILE_TYPE_SOCKET:
-		{
-			init_special_inode(inode, inode->i_mode | S_IFSOCK, 0);
-			break;
-		}
+		init_special_inode(inode, inode->i_mode | S_IFSOCK, 0);
+		break;
 	case ICBTAG_FILE_TYPE_SYMLINK:
-		{
-			inode->i_data.a_ops = &udf_symlink_aops;
-			inode->i_op = &page_symlink_inode_operations;
-			inode->i_mode = S_IFLNK | S_IRWXUGO;
-			break;
-		}
+		inode->i_data.a_ops = &udf_symlink_aops;
+		inode->i_op = &page_symlink_inode_operations;
+		inode->i_mode = S_IFLNK | S_IRWXUGO;
+		break;
 	default:
-		{
-			printk(KERN_ERR
-			       "udf: udf_fill_inode(ino %ld) failed unknown file type=%d\n",
-			       inode->i_ino, fe->icbTag.fileType);
-			make_bad_inode(inode);
-			return;
-		}
+		printk(KERN_ERR "udf: udf_fill_inode(ino %ld) failed unknown file type=%d\n",
+		       inode->i_ino, fe->icbTag.fileType);
+		make_bad_inode(inode);
+		return;
 	}
 	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
-		struct deviceSpec *dsea = (struct deviceSpec *)
-		    udf_get_extendedattr(inode, 12, 1);
-
+		struct deviceSpec *dsea = (struct deviceSpec *)udf_get_extendedattr(inode, 12, 1);
 		if (dsea) {
 			init_special_inode(inode, inode->i_mode,
-					   MKDEV(le32_to_cpu
-						 (dsea->majorDeviceIdent),
-						 le32_to_cpu(dsea->
-							     minorDeviceIdent)));
+					   MKDEV(le32_to_cpu(dsea->majorDeviceIdent),
+						 le32_to_cpu(dsea->minorDeviceIdent)));
 			/* Developer ID ??? */
 		} else {
 			make_bad_inode(inode);
@@ -1412,8 +1280,7 @@ static int udf_alloc_i_data(struct inode
 	UDF_I_DATA(inode) = kmalloc(size, GFP_KERNEL);
 
 	if (!UDF_I_DATA(inode)) {
-		printk(KERN_ERR
-		       "udf:udf_alloc_i_data (ino %ld) no free memory\n",
+		printk(KERN_ERR "udf:udf_alloc_i_data (ino %ld) no free memory\n",
 		       inode->i_ino);
 		return -ENOMEM;
 	}
@@ -1430,12 +1297,12 @@ static mode_t udf_convert_permissions(st
 	permissions = le32_to_cpu(fe->permissions);
 	flags = le16_to_cpu(fe->icbTag.flags);
 
-	mode = ((permissions) & S_IRWXO) |
-	    ((permissions >> 2) & S_IRWXG) |
-	    ((permissions >> 4) & S_IRWXU) |
-	    ((flags & ICBTAG_FLAG_SETUID) ? S_ISUID : 0) |
-	    ((flags & ICBTAG_FLAG_SETGID) ? S_ISGID : 0) |
-	    ((flags & ICBTAG_FLAG_STICKY) ? S_ISVTX : 0);
+	mode =	(( permissions      ) & S_IRWXO) |
+		(( permissions >> 2 ) & S_IRWXG) |
+		(( permissions >> 4 ) & S_IRWXU) |
+		(( flags & ICBTAG_FLAG_SETUID) ? S_ISUID : 0) |
+		(( flags & ICBTAG_FLAG_SETGID) ? S_ISGID : 0) |
+		(( flags & ICBTAG_FLAG_STICKY) ? S_ISVTX : 0);
 
 	return mode;
 }
@@ -1458,9 +1325,11 @@ static mode_t udf_convert_permissions(st
 int udf_write_inode(struct inode *inode, int sync)
 {
 	int ret;
+
 	lock_kernel();
 	ret = udf_update_inode(inode, sync);
 	unlock_kernel();
+
 	return ret;
 }
 
@@ -1481,10 +1350,7 @@ static int udf_update_inode(struct inode
 	kernel_timestamp cpu_time;
 	int err = 0;
 
-	bh = udf_tread(inode->i_sb,
-		       udf_get_lb_pblock(inode->i_sb, UDF_I_LOCATION(inode),
-					 0));
-
+	bh = udf_tread(inode->i_sb, udf_get_lb_pblock(inode->i_sb, UDF_I_LOCATION(inode), 0));
 	if (!bh) {
 		udf_debug("bread failure\n");
 		return -EIO;
@@ -1497,27 +1363,21 @@ static int udf_update_inode(struct inode
 
 	if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_USE) {
 		struct unallocSpaceEntry *use =
-		    (struct unallocSpaceEntry *)bh->b_data;
+			(struct unallocSpaceEntry *)bh->b_data;
 
 		use->lengthAllocDescs = cpu_to_le32(UDF_I_LENALLOC(inode));
-		memcpy(bh->b_data + sizeof(struct unallocSpaceEntry),
-		       UDF_I_DATA(inode),
-		       inode->i_sb->s_blocksize -
-		       sizeof(struct unallocSpaceEntry));
-		crclen =
-		    sizeof(struct unallocSpaceEntry) + UDF_I_LENALLOC(inode) -
-		    sizeof(tag);
-		use->descTag.tagLocation =
-		    cpu_to_le32(UDF_I_LOCATION(inode).logicalBlockNum);
+		memcpy(bh->b_data + sizeof(struct unallocSpaceEntry), UDF_I_DATA(inode),
+		       inode->i_sb->s_blocksize - sizeof(struct unallocSpaceEntry));
+		crclen = sizeof(struct unallocSpaceEntry) + UDF_I_LENALLOC(inode) - sizeof(tag);
+		use->descTag.tagLocation = cpu_to_le32(UDF_I_LOCATION(inode).logicalBlockNum);
 		use->descTag.descCRCLength = cpu_to_le16(crclen);
-		use->descTag.descCRC =
-		    cpu_to_le16(udf_crc((char *)use + sizeof(tag), crclen, 0));
+		use->descTag.descCRC = cpu_to_le16(udf_crc((char *)use + sizeof(tag), crclen, 0));
 
 		use->descTag.tagChecksum = 0;
-		for (i = 0; i < 16; i++)
+		for (i = 0; i < 16; i++) {
 			if (i != 4)
-				use->descTag.tagChecksum +=
-				    ((uint8_t *) & (use->descTag))[i];
+				use->descTag.tagChecksum += ((uint8_t *)&(use->descTag))[i];
+		}
 
 		mark_buffer_dirty(bh);
 		brelse(bh);
@@ -1534,13 +1394,14 @@ static int udf_update_inode(struct inode
 	else
 		fe->gid = cpu_to_le32(inode->i_gid);
 
-	udfperms = ((inode->i_mode & S_IRWXO)) |
-	    ((inode->i_mode & S_IRWXG) << 2) | ((inode->i_mode & S_IRWXU) << 4);
-
-	udfperms |= (le32_to_cpu(fe->permissions) &
-		     (FE_PERM_O_DELETE | FE_PERM_O_CHATTR |
-		      FE_PERM_G_DELETE | FE_PERM_G_CHATTR |
-		      FE_PERM_U_DELETE | FE_PERM_U_CHATTR));
+	udfperms =	((inode->i_mode & S_IRWXO)     ) |
+			((inode->i_mode & S_IRWXG) << 2) |
+			((inode->i_mode & S_IRWXU) << 4);
+
+	udfperms |=	(le32_to_cpu(fe->permissions) &
+			(FE_PERM_O_DELETE | FE_PERM_O_CHATTR |
+			 FE_PERM_G_DELETE | FE_PERM_G_CHATTR |
+			 FE_PERM_U_DELETE | FE_PERM_U_CHATTR));
 	fe->permissions = cpu_to_le32(udfperms);
 
 	if (S_ISDIR(inode->i_mode))
@@ -1552,22 +1413,20 @@ static int udf_update_inode(struct inode
 
 	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
 		regid *eid;
-		struct deviceSpec *dsea = (struct deviceSpec *)
-		    udf_get_extendedattr(inode, 12, 1);
-
+		struct deviceSpec *dsea =
+			(struct deviceSpec *)udf_get_extendedattr(inode, 12, 1);
 		if (!dsea) {
 			dsea = (struct deviceSpec *)
-			    udf_add_extendedattr(inode,
-						 sizeof(struct deviceSpec) +
-						 sizeof(regid), 12, 0x3);
+				udf_add_extendedattr(inode,
+						     sizeof(struct deviceSpec) +
+						     sizeof(regid), 12, 0x3);
 			dsea->attrType = cpu_to_le32(12);
 			dsea->attrSubtype = 1;
-			dsea->attrLength =
-			    cpu_to_le32(sizeof(struct deviceSpec) +
-					sizeof(regid));
+			dsea->attrLength = cpu_to_le32(sizeof(struct deviceSpec) +
+						       sizeof(regid));
 			dsea->impUseLength = cpu_to_le32(sizeof(regid));
 		}
-		eid = (regid *) dsea->impUse;
+		eid = (regid *)dsea->impUse;
 		memset(eid, 0, sizeof(regid));
 		strcpy(eid->ident, UDF_ID_DEVELOPER);
 		eid->identSuffix[0] = UDF_OS_CLASS_UNIX;
@@ -1579,10 +1438,9 @@ static int udf_update_inode(struct inode
 	if (UDF_I_EFE(inode) == 0) {
 		memcpy(bh->b_data + sizeof(struct fileEntry), UDF_I_DATA(inode),
 		       inode->i_sb->s_blocksize - sizeof(struct fileEntry));
-		fe->logicalBlocksRecorded =
-		    cpu_to_le64((inode->i_blocks +
-				 (1 << (inode->i_sb->s_blocksize_bits - 9)) -
-				 1) >> (inode->i_sb->s_blocksize_bits - 9));
+		fe->logicalBlocksRecorded = cpu_to_le64(
+			(inode->i_blocks + (1 << (inode->i_sb->s_blocksize_bits - 9)) - 1) >>
+			(inode->i_sb->s_blocksize_bits - 9));
 
 		if (udf_time_to_stamp(&cpu_time, inode->i_atime))
 			fe->accessTime = cpu_to_lets(cpu_time);
@@ -1600,19 +1458,12 @@ static int udf_update_inode(struct inode
 		fe->descTag.tagIdent = cpu_to_le16(TAG_IDENT_FE);
 		crclen = sizeof(struct fileEntry);
 	} else {
-		memcpy(bh->b_data + sizeof(struct extendedFileEntry),
-		       UDF_I_DATA(inode),
-		       inode->i_sb->s_blocksize -
-		       sizeof(struct extendedFileEntry));
+		memcpy(bh->b_data + sizeof(struct extendedFileEntry), UDF_I_DATA(inode),
+		       inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry));
 		efe->objectSize = cpu_to_le64(inode->i_size);
-		efe->logicalBlocksRecorded = cpu_to_le64((inode->i_blocks +
-							  (1 <<
-							   (inode->i_sb->
-							    s_blocksize_bits -
-							    9)) -
-							  1) >> (inode->i_sb->
-								 s_blocksize_bits
-								 - 9));
+		efe->logicalBlocksRecorded = cpu_to_le64(
+			(inode->i_blocks + (1 << (inode->i_sb->s_blocksize_bits - 9)) - 1) >>
+			(inode->i_sb->s_blocksize_bits - 9));
 
 		if (UDF_I_CRTIME(inode).tv_sec > inode->i_atime.tv_sec ||
 		    (UDF_I_CRTIME(inode).tv_sec == inode->i_atime.tv_sec &&
@@ -1673,13 +1524,13 @@ static int udf_update_inode(struct inode
 	else if (S_ISSOCK(inode->i_mode))
 		fe->icbTag.fileType = ICBTAG_FILE_TYPE_SOCKET;
 
-	icbflags = UDF_I_ALLOCTYPE(inode) |
-	    ((inode->i_mode & S_ISUID) ? ICBTAG_FLAG_SETUID : 0) |
-	    ((inode->i_mode & S_ISGID) ? ICBTAG_FLAG_SETGID : 0) |
-	    ((inode->i_mode & S_ISVTX) ? ICBTAG_FLAG_STICKY : 0) |
-	    (le16_to_cpu(fe->icbTag.flags) &
-	     ~(ICBTAG_FLAG_AD_MASK | ICBTAG_FLAG_SETUID |
-	       ICBTAG_FLAG_SETGID | ICBTAG_FLAG_STICKY));
+	icbflags =	UDF_I_ALLOCTYPE(inode) |
+			((inode->i_mode & S_ISUID) ? ICBTAG_FLAG_SETUID : 0) |
+			((inode->i_mode & S_ISGID) ? ICBTAG_FLAG_SETGID : 0) |
+			((inode->i_mode & S_ISVTX) ? ICBTAG_FLAG_STICKY : 0) |
+			(le16_to_cpu(fe->icbTag.flags) &
+				~(ICBTAG_FLAG_AD_MASK | ICBTAG_FLAG_SETUID |
+				ICBTAG_FLAG_SETGID | ICBTAG_FLAG_STICKY));
 
 	fe->icbTag.flags = cpu_to_le16(icbflags);
 	if (UDF_SB_UDFREV(inode->i_sb) >= 0x0200)
@@ -1687,18 +1538,16 @@ static int udf_update_inode(struct inode
 	else
 		fe->descTag.descVersion = cpu_to_le16(2);
 	fe->descTag.tagSerialNum = cpu_to_le16(UDF_SB_SERIALNUM(inode->i_sb));
-	fe->descTag.tagLocation =
-	    cpu_to_le32(UDF_I_LOCATION(inode).logicalBlockNum);
+	fe->descTag.tagLocation = cpu_to_le32(UDF_I_LOCATION(inode).logicalBlockNum);
 	crclen += UDF_I_LENEATTR(inode) + UDF_I_LENALLOC(inode) - sizeof(tag);
 	fe->descTag.descCRCLength = cpu_to_le16(crclen);
-	fe->descTag.descCRC =
-	    cpu_to_le16(udf_crc((char *)fe + sizeof(tag), crclen, 0));
+	fe->descTag.descCRC = cpu_to_le16(udf_crc((char *)fe + sizeof(tag), crclen, 0));
 
 	fe->descTag.tagChecksum = 0;
-	for (i = 0; i < 16; i++)
+	for (i = 0; i < 16; i++) {
 		if (i != 4)
-			fe->descTag.tagChecksum +=
-			    ((uint8_t *) & (fe->descTag))[i];
+			fe->descTag.tagChecksum += ((uint8_t *)&(fe->descTag))[i];
+	}
 
 	/* write the data blocks */
 	mark_buffer_dirty(bh);
@@ -1711,6 +1560,7 @@ static int udf_update_inode(struct inode
 		}
 	}
 	brelse(bh);
+
 	return err;
 }
 
@@ -1731,8 +1581,7 @@ struct inode *udf_iget(struct super_bloc
 	if (is_bad_inode(inode))
 		goto out_iput;
 
-	if (ino.logicalBlockNum >=
-	    UDF_SB_PARTLEN(sb, ino.partitionReferenceNum)) {
+	if (ino.logicalBlockNum >= UDF_SB_PARTLEN(sb, ino.partitionReferenceNum)) {
 		udf_debug("block=%d, partition=%d out of range\n",
 			  ino.logicalBlockNum, ino.partitionReferenceNum);
 		make_bad_inode(inode);
@@ -1741,7 +1590,7 @@ struct inode *udf_iget(struct super_bloc
 
 	return inode;
 
-      out_iput:
+ out_iput:
 	iput(inode);
 	return NULL;
 }
@@ -1757,9 +1606,7 @@ int8_t udf_add_aext(struct inode * inode
 	uint8_t *ptr;
 
 	if (!epos->bh)
-		ptr =
-		    UDF_I_DATA(inode) + epos->offset -
-		    udf_file_entry_alloc_offset(inode) + UDF_I_LENEATTR(inode);
+		ptr = UDF_I_DATA(inode) + epos->offset - udf_file_entry_alloc_offset(inode) + UDF_I_LENEATTR(inode);
 	else
 		ptr = epos->bh->b_data + epos->offset;
 
@@ -1776,18 +1623,13 @@ int8_t udf_add_aext(struct inode * inode
 		int err, loffset;
 		kernel_lb_addr obloc = epos->block;
 
-		if (!
-		    (epos->block.logicalBlockNum =
-		     udf_new_block(inode->i_sb, NULL,
-				   obloc.partitionReferenceNum,
-				   obloc.logicalBlockNum, &err))) {
+		if (!(epos->block.logicalBlockNum = udf_new_block(inode->i_sb, NULL,
+								  obloc.partitionReferenceNum,
+								  obloc.logicalBlockNum, &err))) {
 			return -1;
 		}
-		if (!
-		    (nbh =
-		     udf_tgetblk(inode->i_sb,
-				 udf_get_lb_pblock(inode->i_sb, epos->block,
-						   0)))) {
+		if (!(nbh = udf_tgetblk(inode->i_sb, udf_get_lb_pblock(inode->i_sb,
+								       epos->block, 0)))) {
 			return -1;
 		}
 		lock_buffer(nbh);
@@ -1798,8 +1640,7 @@ int8_t udf_add_aext(struct inode * inode
 
 		aed = (struct allocExtDesc *)(nbh->b_data);
 		if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT))
-			aed->previousAllocExtLocation =
-			    cpu_to_le32(obloc.logicalBlockNum);
+			aed->previousAllocExtLocation = cpu_to_le32(obloc.logicalBlockNum);
 		if (epos->offset + adsize > inode->i_sb->s_blocksize) {
 			loffset = epos->offset;
 			aed->lengthAllocDescs = cpu_to_le32(adsize);
@@ -1816,9 +1657,7 @@ int8_t udf_add_aext(struct inode * inode
 			if (epos->bh) {
 				aed = (struct allocExtDesc *)epos->bh->b_data;
 				aed->lengthAllocDescs =
-				    cpu_to_le32(le32_to_cpu
-						(aed->lengthAllocDescs) +
-						adsize);
+					cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) + adsize);
 			} else {
 				UDF_I_LENALLOC(inode) += adsize;
 				mark_inode_dirty(inode);
@@ -1832,37 +1671,30 @@ int8_t udf_add_aext(struct inode * inode
 				    epos->block.logicalBlockNum, sizeof(tag));
 		switch (UDF_I_ALLOCTYPE(inode)) {
 		case ICBTAG_FLAG_AD_SHORT:
-			{
-				sad = (short_ad *) sptr;
-				sad->extLength =
-				    cpu_to_le32(EXT_NEXT_EXTENT_ALLOCDECS |
-						inode->i_sb->s_blocksize);
-				sad->extPosition =
-				    cpu_to_le32(epos->block.logicalBlockNum);
-				break;
-			}
+			sad = (short_ad *)sptr;
+			sad->extLength = cpu_to_le32(EXT_NEXT_EXTENT_ALLOCDECS |
+						     inode->i_sb->s_blocksize);
+			sad->extPosition = cpu_to_le32(epos->block.logicalBlockNum);
+			break;
 		case ICBTAG_FLAG_AD_LONG:
-			{
-				lad = (long_ad *) sptr;
-				lad->extLength =
-				    cpu_to_le32(EXT_NEXT_EXTENT_ALLOCDECS |
-						inode->i_sb->s_blocksize);
-				lad->extLocation = cpu_to_lelb(epos->block);
-				memset(lad->impUse, 0x00, sizeof(lad->impUse));
-				break;
-			}
+			lad = (long_ad *)sptr;
+			lad->extLength = cpu_to_le32(EXT_NEXT_EXTENT_ALLOCDECS |
+						     inode->i_sb->s_blocksize);
+			lad->extLocation = cpu_to_lelb(epos->block);
+			memset(lad->impUse, 0x00, sizeof(lad->impUse));
+			break;
 		}
 		if (epos->bh) {
-			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT)
-			    || UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
+			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
+			    UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
 				udf_update_tag(epos->bh->b_data, loffset);
 			else
-				udf_update_tag(epos->bh->b_data,
-					       sizeof(struct allocExtDesc));
+				udf_update_tag(epos->bh->b_data, sizeof(struct allocExtDesc));
 			mark_buffer_dirty_inode(epos->bh, inode);
 			brelse(epos->bh);
-		} else
+		} else {
 			mark_inode_dirty(inode);
+		}
 		epos->bh = nbh;
 	}
 
@@ -1874,14 +1706,11 @@ int8_t udf_add_aext(struct inode * inode
 	} else {
 		aed = (struct allocExtDesc *)epos->bh->b_data;
 		aed->lengthAllocDescs =
-		    cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) + adsize);
-		if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT)
-		    || UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
-			udf_update_tag(epos->bh->b_data,
-				       epos->offset + (inc ? 0 : adsize));
+			cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) + adsize);
+		if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) || UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
+			udf_update_tag(epos->bh->b_data, epos->offset + (inc ? 0 : adsize));
 		else
-			udf_update_tag(epos->bh->b_data,
-				       sizeof(struct allocExtDesc));
+			udf_update_tag(epos->bh->b_data, sizeof(struct allocExtDesc));
 		mark_buffer_dirty_inode(epos->bh, inode);
 	}
 
@@ -1893,51 +1722,47 @@ int8_t udf_write_aext(struct inode * ino
 {
 	int adsize;
 	uint8_t *ptr;
+	short_ad *sad;
+	long_ad *lad;
 
 	if (!epos->bh)
-		ptr =
-		    UDF_I_DATA(inode) + epos->offset -
-		    udf_file_entry_alloc_offset(inode) + UDF_I_LENEATTR(inode);
+		ptr = UDF_I_DATA(inode) + epos->offset - udf_file_entry_alloc_offset(inode) + UDF_I_LENEATTR(inode);
 	else
 		ptr = epos->bh->b_data + epos->offset;
 
 	switch (UDF_I_ALLOCTYPE(inode)) {
 	case ICBTAG_FLAG_AD_SHORT:
-		{
-			short_ad *sad = (short_ad *) ptr;
-			sad->extLength = cpu_to_le32(elen);
-			sad->extPosition = cpu_to_le32(eloc.logicalBlockNum);
-			adsize = sizeof(short_ad);
-			break;
-		}
+		sad = (short_ad *)ptr;
+		sad->extLength = cpu_to_le32(elen);
+		sad->extPosition = cpu_to_le32(eloc.logicalBlockNum);
+		adsize = sizeof(short_ad);
+		break;
 	case ICBTAG_FLAG_AD_LONG:
-		{
-			long_ad *lad = (long_ad *) ptr;
-			lad->extLength = cpu_to_le32(elen);
-			lad->extLocation = cpu_to_lelb(eloc);
-			memset(lad->impUse, 0x00, sizeof(lad->impUse));
-			adsize = sizeof(long_ad);
-			break;
-		}
+		lad = (long_ad *)ptr;
+		lad->extLength = cpu_to_le32(elen);
+		lad->extLocation = cpu_to_lelb(eloc);
+		memset(lad->impUse, 0x00, sizeof(lad->impUse));
+		adsize = sizeof(long_ad);
+		break;
 	default:
 		return -1;
 	}
 
 	if (epos->bh) {
-		if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT)
-		    || UDF_SB_UDFREV(inode->i_sb) >= 0x0201) {
-			struct allocExtDesc *aed =
-			    (struct allocExtDesc *)epos->bh->b_data;
+		if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
+		    UDF_SB_UDFREV(inode->i_sb) >= 0x0201) {
+			struct allocExtDesc *aed = (struct allocExtDesc *)epos->bh->b_data;
 			udf_update_tag(epos->bh->b_data,
-				       le32_to_cpu(aed->lengthAllocDescs) +
-				       sizeof(struct allocExtDesc));
+				       le32_to_cpu(aed->lengthAllocDescs) + sizeof(struct allocExtDesc));
 		}
 		mark_buffer_dirty_inode(epos->bh, inode);
-	} else
+	} else {
 		mark_inode_dirty(inode);
+	}
 
 	if (inc)
 		epos->offset += adsize;
+
 	return (elen >> 30);
 }
 
@@ -1951,14 +1776,9 @@ int8_t udf_next_aext(struct inode * inod
 		epos->block = *eloc;
 		epos->offset = sizeof(struct allocExtDesc);
 		brelse(epos->bh);
-		if (!
-		    (epos->bh =
-		     udf_tread(inode->i_sb,
-			       udf_get_lb_pblock(inode->i_sb, epos->block,
-						 0)))) {
+		if (!(epos->bh = udf_tread(inode->i_sb, udf_get_lb_pblock(inode->i_sb, epos->block, 0)))) {
 			udf_debug("reading block %d failed!\n",
-				  udf_get_lb_pblock(inode->i_sb, epos->block,
-						    0));
+				  udf_get_lb_pblock(inode->i_sb, epos->block, 0));
 			return -1;
 		}
 	}
@@ -1972,67 +1792,41 @@ int8_t udf_current_aext(struct inode * i
 	int alen;
 	int8_t etype;
 	uint8_t *ptr;
+	short_ad *sad;
+	long_ad *lad;
+
 
 	if (!epos->bh) {
 		if (!epos->offset)
 			epos->offset = udf_file_entry_alloc_offset(inode);
-		ptr =
-		    UDF_I_DATA(inode) + epos->offset -
-		    udf_file_entry_alloc_offset(inode) + UDF_I_LENEATTR(inode);
-		alen =
-		    udf_file_entry_alloc_offset(inode) + UDF_I_LENALLOC(inode);
+		ptr = UDF_I_DATA(inode) + epos->offset - udf_file_entry_alloc_offset(inode) + UDF_I_LENEATTR(inode);
+		alen = udf_file_entry_alloc_offset(inode) + UDF_I_LENALLOC(inode);
 	} else {
 		if (!epos->offset)
 			epos->offset = sizeof(struct allocExtDesc);
 		ptr = epos->bh->b_data + epos->offset;
-		alen =
-		    sizeof(struct allocExtDesc) +
-		    le32_to_cpu(((struct allocExtDesc *)epos->bh->b_data)->
-				lengthAllocDescs);
+		alen = sizeof(struct allocExtDesc) + le32_to_cpu(((struct allocExtDesc *)epos->bh->b_data)->lengthAllocDescs);
 	}
 
 	switch (UDF_I_ALLOCTYPE(inode)) {
 	case ICBTAG_FLAG_AD_SHORT:
-		{
-			short_ad *sad;
-
-			if (!
-			    (sad =
-			     udf_get_fileshortad(ptr, alen, &epos->offset,
-						 inc)))
-				return -1;
-
-			etype = le32_to_cpu(sad->extLength) >> 30;
-			eloc->logicalBlockNum = le32_to_cpu(sad->extPosition);
-			eloc->partitionReferenceNum =
-			    UDF_I_LOCATION(inode).partitionReferenceNum;
-			*elen =
-			    le32_to_cpu(sad->
-					extLength) & UDF_EXTENT_LENGTH_MASK;
-			break;
-		}
+		if (!(sad = udf_get_fileshortad(ptr, alen, &epos->offset, inc)))
+			return -1;
+		etype = le32_to_cpu(sad->extLength) >> 30;
+		eloc->logicalBlockNum = le32_to_cpu(sad->extPosition);
+		eloc->partitionReferenceNum = UDF_I_LOCATION(inode).partitionReferenceNum;
+		*elen = le32_to_cpu(sad->extLength) & UDF_EXTENT_LENGTH_MASK;
+		break;
 	case ICBTAG_FLAG_AD_LONG:
-		{
-			long_ad *lad;
-
-			if (!
-			    (lad =
-			     udf_get_filelongad(ptr, alen, &epos->offset, inc)))
-				return -1;
-
-			etype = le32_to_cpu(lad->extLength) >> 30;
-			*eloc = lelb_to_cpu(lad->extLocation);
-			*elen =
-			    le32_to_cpu(lad->
-					extLength) & UDF_EXTENT_LENGTH_MASK;
-			break;
-		}
-	default:
-		{
-			udf_debug("alloc_type = %d unsupported\n",
-				  UDF_I_ALLOCTYPE(inode));
+		if (!(lad = udf_get_filelongad(ptr, alen, &epos->offset, inc)))
 			return -1;
-		}
+		etype = le32_to_cpu(lad->extLength) >> 30;
+		*eloc = lelb_to_cpu(lad->extLocation);
+		*elen = le32_to_cpu(lad->extLength) & UDF_EXTENT_LENGTH_MASK;
+		break;
+	default:
+		udf_debug("alloc_type = %d unsupported\n", UDF_I_ALLOCTYPE(inode));
+		return -1;
 	}
 
 	return etype;
@@ -2051,12 +1845,12 @@ udf_insert_aext(struct inode *inode, str
 
 	while ((etype = udf_next_aext(inode, &epos, &oeloc, &oelen, 0)) != -1) {
 		udf_write_aext(inode, &epos, neloc, nelen, 1);
-
 		neloc = oeloc;
 		nelen = (etype << 30) | oelen;
 	}
 	udf_add_aext(inode, &epos, neloc, nelen, 1);
 	brelse(epos.bh);
+
 	return (nelen >> 30);
 }
 
@@ -2107,15 +1901,12 @@ int8_t udf_delete_aext(struct inode * in
 		} else {
 			aed = (struct allocExtDesc *)oepos.bh->b_data;
 			aed->lengthAllocDescs =
-			    cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) -
-					(2 * adsize));
-			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT)
-			    || UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
-				udf_update_tag(oepos.bh->b_data,
-					       oepos.offset - (2 * adsize));
+				cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) - (2 * adsize));
+			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
+			    UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
+				udf_update_tag(oepos.bh->b_data, oepos.offset - (2 * adsize));
 			else
-				udf_update_tag(oepos.bh->b_data,
-					       sizeof(struct allocExtDesc));
+				udf_update_tag(oepos.bh->b_data, sizeof(struct allocExtDesc));
 			mark_buffer_dirty_inode(oepos.bh, inode);
 		}
 	} else {
@@ -2126,21 +1917,18 @@ int8_t udf_delete_aext(struct inode * in
 		} else {
 			aed = (struct allocExtDesc *)oepos.bh->b_data;
 			aed->lengthAllocDescs =
-			    cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) -
-					adsize);
-			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT)
-			    || UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
-				udf_update_tag(oepos.bh->b_data,
-					       epos.offset - adsize);
+				cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) - adsize);
+			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) || UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
+				udf_update_tag(oepos.bh->b_data, epos.offset - adsize);
 			else
-				udf_update_tag(oepos.bh->b_data,
-					       sizeof(struct allocExtDesc));
+				udf_update_tag(oepos.bh->b_data, sizeof(struct allocExtDesc));
 			mark_buffer_dirty_inode(oepos.bh, inode);
 		}
 	}
 
 	brelse(epos.bh);
 	brelse(oepos.bh);
+
 	return (elen >> 30);
 }
 
@@ -2164,8 +1952,7 @@ int8_t inode_bmap(struct inode * inode, 
 
 	do {
 		if ((etype = udf_next_aext(inode, pos, eloc, elen, 1)) == -1) {
-			*offset =
-			    (bcount - lbcount) >> inode->i_sb->s_blocksize_bits;
+			*offset = (bcount - lbcount) >> inode->i_sb->s_blocksize_bits;
 			UDF_I_LENEXTENTS(inode) = lbcount;
 			return -1;
 		}
@@ -2182,13 +1969,12 @@ long udf_block_map(struct inode *inode, 
 	kernel_lb_addr eloc;
 	uint32_t elen;
 	sector_t offset;
-	struct extent_position epos = { NULL, 0, {0, 0} };
+	struct extent_position epos = {};
 	int ret;
 
 	lock_kernel();
 
-	if (inode_bmap(inode, block, &epos, &eloc, &elen, &offset) ==
-	    (EXT_RECORDED_ALLOCATED >> 30))
+	if (inode_bmap(inode, block, &epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30))
 		ret = udf_get_lb_pblock(inode->i_sb, eloc, offset);
 	else
 		ret = 0;
diff -puN fs/udf/lowlevel.c~udf-coding-style-conversion-lindent-fixups fs/udf/lowlevel.c
--- a/fs/udf/lowlevel.c~udf-coding-style-conversion-lindent-fixups
+++ a/fs/udf/lowlevel.c
@@ -43,7 +43,7 @@ unsigned int udf_get_last_session(struct
 		udf_debug("XA disk: %s, vol_desc_start=%d\n",
 			  (ms_info.xa_flag ? "yes" : "no"), ms_info.addr.lba);
 #if WE_OBEY_THE_WRITTEN_STANDARDS
-		if (ms_info.xa_flag)	/* necessary for a valid ms_info.addr */
+		if (ms_info.xa_flag) /* necessary for a valid ms_info.addr */
 #endif
 			vol_desc_start = ms_info.addr.lba;
 	} else {
@@ -57,7 +57,7 @@ unsigned long udf_get_last_block(struct 
 	struct block_device *bdev = sb->s_bdev;
 	unsigned long lblock = 0;
 
-	if (ioctl_by_bdev(bdev, CDROM_LAST_WRITTEN, (unsigned long)&lblock))
+	if (ioctl_by_bdev(bdev, CDROM_LAST_WRITTEN, (unsigned long) &lblock))
 		lblock = bdev->bd_inode->i_size >> sb->s_blocksize_bits;
 
 	if (lblock)
diff -puN fs/udf/misc.c~udf-coding-style-conversion-lindent-fixups fs/udf/misc.c
--- a/fs/udf/misc.c~udf-coding-style-conversion-lindent-fixups
+++ a/fs/udf/misc.c
@@ -54,15 +54,15 @@ struct genericFormat *udf_add_extendedat
 	int i;
 
 	ea = UDF_I_DATA(inode);
-	if (UDF_I_LENEATTR(inode))
+	if (UDF_I_LENEATTR(inode)) {
 		ad = UDF_I_DATA(inode) + UDF_I_LENEATTR(inode);
-	else {
+	} else {
 		ad = ea;
 		size += sizeof(struct extendedAttrHeaderDesc);
 	}
 
 	offset = inode->i_sb->s_blocksize - udf_file_entry_alloc_offset(inode) -
-	    UDF_I_LENALLOC(inode);
+		UDF_I_LENALLOC(inode);
 
 	/* TODO - Check for FreeEASpace */
 
@@ -76,56 +76,45 @@ struct genericFormat *udf_add_extendedat
 
 		if (UDF_I_LENEATTR(inode)) {
 			/* check checksum/crc */
-			if (le16_to_cpu(eahd->descTag.tagIdent) !=
-			    TAG_IDENT_EAHD
-			    || le32_to_cpu(eahd->descTag.tagLocation) !=
-			    UDF_I_LOCATION(inode).logicalBlockNum) {
+			if (le16_to_cpu(eahd->descTag.tagIdent) != TAG_IDENT_EAHD ||
+			    le32_to_cpu(eahd->descTag.tagLocation) != UDF_I_LOCATION(inode).logicalBlockNum) {
 				return NULL;
 			}
 		} else {
 			size -= sizeof(struct extendedAttrHeaderDesc);
-			UDF_I_LENEATTR(inode) +=
-			    sizeof(struct extendedAttrHeaderDesc);
+			UDF_I_LENEATTR(inode) += sizeof(struct extendedAttrHeaderDesc);
 			eahd->descTag.tagIdent = cpu_to_le16(TAG_IDENT_EAHD);
 			if (UDF_SB_UDFREV(inode->i_sb) >= 0x0200)
 				eahd->descTag.descVersion = cpu_to_le16(3);
 			else
 				eahd->descTag.descVersion = cpu_to_le16(2);
-			eahd->descTag.tagSerialNum =
-			    cpu_to_le16(UDF_SB_SERIALNUM(inode->i_sb));
-			eahd->descTag.tagLocation =
-			    cpu_to_le32(UDF_I_LOCATION(inode).logicalBlockNum);
+			eahd->descTag.tagSerialNum = cpu_to_le16(UDF_SB_SERIALNUM(inode->i_sb));
+			eahd->descTag.tagLocation = cpu_to_le32(UDF_I_LOCATION(inode).logicalBlockNum);
 			eahd->impAttrLocation = cpu_to_le32(0xFFFFFFFF);
 			eahd->appAttrLocation = cpu_to_le32(0xFFFFFFFF);
 		}
 
 		offset = UDF_I_LENEATTR(inode);
 		if (type < 2048) {
-			if (le32_to_cpu(eahd->appAttrLocation) <
-			    UDF_I_LENEATTR(inode)) {
-				uint32_t aal =
-				    le32_to_cpu(eahd->appAttrLocation);
-				memmove(&ea[offset - aal + size], &ea[aal],
-					offset - aal);
+			if (le32_to_cpu(eahd->appAttrLocation) < UDF_I_LENEATTR(inode)) {
+				uint32_t aal = le32_to_cpu(eahd->appAttrLocation);
+				memmove(&ea[offset - aal + size],
+					&ea[aal], offset - aal);
 				offset -= aal;
 				eahd->appAttrLocation = cpu_to_le32(aal + size);
 			}
-			if (le32_to_cpu(eahd->impAttrLocation) <
-			    UDF_I_LENEATTR(inode)) {
-				uint32_t ial =
-				    le32_to_cpu(eahd->impAttrLocation);
-				memmove(&ea[offset - ial + size], &ea[ial],
-					offset - ial);
+			if (le32_to_cpu(eahd->impAttrLocation) < UDF_I_LENEATTR(inode)) {
+				uint32_t ial = le32_to_cpu(eahd->impAttrLocation);
+				memmove(&ea[offset - ial + size],
+					&ea[ial], offset - ial);
 				offset -= ial;
 				eahd->impAttrLocation = cpu_to_le32(ial + size);
 			}
 		} else if (type < 65536) {
-			if (le32_to_cpu(eahd->appAttrLocation) <
-			    UDF_I_LENEATTR(inode)) {
-				uint32_t aal =
-				    le32_to_cpu(eahd->appAttrLocation);
-				memmove(&ea[offset - aal + size], &ea[aal],
-					offset - aal);
+			if (le32_to_cpu(eahd->appAttrLocation) < UDF_I_LENEATTR(inode)) {
+				uint32_t aal = le32_to_cpu(eahd->appAttrLocation);
+				memmove(&ea[offset - aal + size],
+					&ea[aal], offset - aal);
 				offset -= aal;
 				eahd->appAttrLocation = cpu_to_le32(aal + size);
 			}
@@ -133,18 +122,18 @@ struct genericFormat *udf_add_extendedat
 		/* rewrite CRC + checksum of eahd */
 		crclen = sizeof(struct extendedAttrHeaderDesc) - sizeof(tag);
 		eahd->descTag.descCRCLength = cpu_to_le16(crclen);
-		eahd->descTag.descCRC =
-		    cpu_to_le16(udf_crc((char *)eahd + sizeof(tag), crclen, 0));
+		eahd->descTag.descCRC = cpu_to_le16(udf_crc((char *)eahd +
+							    sizeof(tag), crclen, 0));
 		eahd->descTag.tagChecksum = 0;
 		for (i = 0; i < 16; i++)
 			if (i != 4)
-				eahd->descTag.tagChecksum +=
-				    ((uint8_t *) & (eahd->descTag))[i];
+				eahd->descTag.tagChecksum += ((uint8_t *)&(eahd->descTag))[i];
 		UDF_I_LENEATTR(inode) += size;
 		return (struct genericFormat *)&ea[offset];
 	}
 	if (loc & 0x02) {
 	}
+
 	return NULL;
 }
 
@@ -163,8 +152,7 @@ struct genericFormat *udf_get_extendedat
 
 		/* check checksum/crc */
 		if (le16_to_cpu(eahd->descTag.tagIdent) != TAG_IDENT_EAHD ||
-		    le32_to_cpu(eahd->descTag.tagLocation) !=
-		    UDF_I_LOCATION(inode).logicalBlockNum) {
+		    le32_to_cpu(eahd->descTag.tagLocation) != UDF_I_LOCATION(inode).logicalBlockNum) {
 			return NULL;
 		}
 
@@ -177,13 +165,13 @@ struct genericFormat *udf_get_extendedat
 
 		while (offset < UDF_I_LENEATTR(inode)) {
 			gaf = (struct genericFormat *)&ea[offset];
-			if (le32_to_cpu(gaf->attrType) == type
-			    && gaf->attrSubtype == subtype)
+			if (le32_to_cpu(gaf->attrType) == type && gaf->attrSubtype == subtype)
 				return gaf;
 			else
 				offset += le32_to_cpu(gaf->attrLength);
 		}
 	}
+
 	return NULL;
 }
 
@@ -216,23 +204,22 @@ struct buffer_head *udf_read_tagged(stru
 		return NULL;
 	}
 
-	tag_p = (tag *) (bh->b_data);
+	tag_p = (tag *)(bh->b_data);
 
 	*ident = le16_to_cpu(tag_p->tagIdent);
 
 	if (location != le32_to_cpu(tag_p->tagLocation)) {
 		udf_debug("location mismatch block %u, tag %u != %u\n",
-			  block + UDF_SB_SESSION(sb),
-			  le32_to_cpu(tag_p->tagLocation), location);
+			  block + UDF_SB_SESSION(sb), le32_to_cpu(tag_p->tagLocation), location);
 		goto error_out;
 	}
 
 	/* Verify the tag checksum */
 	checksum = 0U;
 	for (i = 0; i < 4; i++)
-		checksum += (uint8_t) (bh->b_data[i]);
+		checksum += (uint8_t)(bh->b_data[i]);
 	for (i = 5; i < 16; i++)
-		checksum += (uint8_t) (bh->b_data[i]);
+		checksum += (uint8_t)(bh->b_data[i]);
 	if (checksum != tag_p->tagChecksum) {
 		printk(KERN_ERR "udf: tag checksum failed block %d\n", block);
 		goto error_out;
@@ -249,16 +236,14 @@ struct buffer_head *udf_read_tagged(stru
 	/* Verify the descriptor CRC */
 	if (le16_to_cpu(tag_p->descCRCLength) + sizeof(tag) > sb->s_blocksize ||
 	    le16_to_cpu(tag_p->descCRC) == udf_crc(bh->b_data + sizeof(tag),
-						   le16_to_cpu(tag_p->
-							       descCRCLength),
-						   0)) {
+						   le16_to_cpu(tag_p->descCRCLength), 0)) {
 		return bh;
 	}
 	udf_debug("Crc failure block %d: crc = %d, crclen = %d\n",
 		  block + UDF_SB_SESSION(sb), le16_to_cpu(tag_p->descCRC),
 		  le16_to_cpu(tag_p->descCRCLength));
 
-      error_out:
+error_out:
 	brelse(bh);
 	return NULL;
 }
@@ -272,7 +257,7 @@ struct buffer_head *udf_read_ptagged(str
 
 void udf_update_tag(char *data, int length)
 {
-	tag *tptr = (tag *) data;
+	tag *tptr = (tag *)data;
 	int i;
 
 	length -= sizeof(tag);
@@ -283,13 +268,13 @@ void udf_update_tag(char *data, int leng
 
 	for (i = 0; i < 16; i++)
 		if (i != 4)
-			tptr->tagChecksum += (uint8_t) (data[i]);
+			tptr->tagChecksum += (uint8_t)(data[i]);
 }
 
 void udf_new_tag(char *data, uint16_t ident, uint16_t version, uint16_t snum,
 		 uint32_t loc, int length)
 {
-	tag *tptr = (tag *) data;
+	tag *tptr = (tag *)data;
 	tptr->tagIdent = cpu_to_le16(ident);
 	tptr->descVersion = cpu_to_le16(version);
 	tptr->tagSerialNum = cpu_to_le16(snum);
diff -puN fs/udf/namei.c~udf-coding-style-conversion-lindent-fixups fs/udf/namei.c
--- a/fs/udf/namei.c~udf-coding-style-conversion-lindent-fixups
+++ a/fs/udf/namei.c
@@ -37,6 +37,7 @@ static inline int udf_match(int len1, co
 {
 	if (len1 != len2)
 		return 0;
+
 	return !memcmp(name1, name2, len1);
 }
 
@@ -52,7 +53,7 @@ int udf_write_fi(struct inode *inode, st
 	uint16_t liu = le16_to_cpu(cfi->lengthOfImpUse);
 	uint8_t lfi = cfi->lengthFileIdent;
 	int padlen = fibh->eoffset - fibh->soffset - liu - lfi -
-	    sizeof(struct fileIdentDesc);
+		sizeof(struct fileIdentDesc);
 	int adinicb = 0;
 
 	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB)
@@ -61,85 +62,75 @@ int udf_write_fi(struct inode *inode, st
 	offset = fibh->soffset + sizeof(struct fileIdentDesc);
 
 	if (impuse) {
-		if (adinicb || (offset + liu < 0))
-			memcpy((uint8_t *) sfi->impUse, impuse, liu);
-		else if (offset >= 0)
+		if (adinicb || (offset + liu < 0)) {
+			memcpy((uint8_t *)sfi->impUse, impuse, liu);
+		} else if (offset >= 0) {
 			memcpy(fibh->ebh->b_data + offset, impuse, liu);
-		else {
-			memcpy((uint8_t *) sfi->impUse, impuse, -offset);
-			memcpy(fibh->ebh->b_data, impuse - offset,
-			       liu + offset);
+		} else {
+			memcpy((uint8_t *)sfi->impUse, impuse, -offset);
+			memcpy(fibh->ebh->b_data, impuse - offset, liu + offset);
 		}
 	}
 
 	offset += liu;
 
 	if (fileident) {
-		if (adinicb || (offset + lfi < 0))
-			memcpy((uint8_t *) sfi->fileIdent + liu, fileident,
-			       lfi);
-		else if (offset >= 0)
+		if (adinicb || (offset + lfi < 0)) {
+			memcpy((uint8_t *)sfi->fileIdent + liu, fileident, lfi);
+		} else if (offset >= 0) {
 			memcpy(fibh->ebh->b_data + offset, fileident, lfi);
-		else {
-			memcpy((uint8_t *) sfi->fileIdent + liu, fileident,
-			       -offset);
-			memcpy(fibh->ebh->b_data, fileident - offset,
-			       lfi + offset);
+		} else {
+			memcpy((uint8_t *)sfi->fileIdent + liu, fileident, -offset);
+			memcpy(fibh->ebh->b_data, fileident - offset, lfi + offset);
 		}
 	}
 
 	offset += lfi;
 
-	if (adinicb || (offset + padlen < 0))
-		memset((uint8_t *) sfi->padding + liu + lfi, 0x00, padlen);
-	else if (offset >= 0)
+	if (adinicb || (offset + padlen < 0)) {
+		memset((uint8_t *)sfi->padding + liu + lfi, 0x00, padlen);
+	} else if (offset >= 0) {
 		memset(fibh->ebh->b_data + offset, 0x00, padlen);
-	else {
-		memset((uint8_t *) sfi->padding + liu + lfi, 0x00, -offset);
+	} else {
+		memset((uint8_t *)sfi->padding + liu + lfi, 0x00, -offset);
 		memset(fibh->ebh->b_data, 0x00, padlen + offset);
 	}
 
-	crc =
-	    udf_crc((uint8_t *) cfi + sizeof(tag),
-		    sizeof(struct fileIdentDesc) - sizeof(tag), 0);
-
-	if (fibh->sbh == fibh->ebh)
-		crc = udf_crc((uint8_t *) sfi->impUse,
-			      crclen + sizeof(tag) -
-			      sizeof(struct fileIdentDesc), crc);
-	else if (sizeof(struct fileIdentDesc) >= -fibh->soffset)
-		crc =
-		    udf_crc(fibh->ebh->b_data + sizeof(struct fileIdentDesc) +
-			    fibh->soffset,
-			    crclen + sizeof(tag) - sizeof(struct fileIdentDesc),
-			    crc);
-	else {
-		crc = udf_crc((uint8_t *) sfi->impUse,
-			      -fibh->soffset - sizeof(struct fileIdentDesc),
-			      crc);
+	crc = udf_crc((uint8_t *)cfi + sizeof(tag),
+		      sizeof(struct fileIdentDesc) - sizeof(tag), 0);
+
+	if (fibh->sbh == fibh->ebh) {
+		crc = udf_crc((uint8_t *)sfi->impUse,
+			      crclen + sizeof(tag) - sizeof(struct fileIdentDesc), crc);
+	} else if (sizeof(struct fileIdentDesc) >= -fibh->soffset) {
+		crc = udf_crc(fibh->ebh->b_data + sizeof(struct fileIdentDesc) + fibh->soffset,
+			      crclen + sizeof(tag) - sizeof(struct fileIdentDesc), crc);
+	} else {
+		crc = udf_crc((uint8_t *)sfi->impUse,
+			      -fibh->soffset - sizeof(struct fileIdentDesc), crc);
 		crc = udf_crc(fibh->ebh->b_data, fibh->eoffset, crc);
 	}
 
 	cfi->descTag.descCRC = cpu_to_le16(crc);
 	cfi->descTag.descCRCLength = cpu_to_le16(crclen);
 
-	for (i = 0; i < 16; i++)
+	for (i = 0; i < 16; i++) {
 		if (i != 4)
-			checksum += ((uint8_t *) & cfi->descTag)[i];
+			checksum += ((uint8_t *)&cfi->descTag)[i];
+	}
 
 	cfi->descTag.tagChecksum = checksum;
-	if (adinicb || (sizeof(struct fileIdentDesc) <= -fibh->soffset))
-		memcpy((uint8_t *) sfi, (uint8_t *) cfi,
-		       sizeof(struct fileIdentDesc));
-	else {
-		memcpy((uint8_t *) sfi, (uint8_t *) cfi, -fibh->soffset);
-		memcpy(fibh->ebh->b_data, (uint8_t *) cfi - fibh->soffset,
+	if (adinicb || (sizeof(struct fileIdentDesc) <= -fibh->soffset)) {
+		memcpy((uint8_t *)sfi, (uint8_t *)cfi, sizeof(struct fileIdentDesc));
+	} else {
+		memcpy((uint8_t *)sfi, (uint8_t *)cfi, -fibh->soffset);
+		memcpy(fibh->ebh->b_data, (uint8_t *)cfi - fibh->soffset,
 		       sizeof(struct fileIdentDesc) + fibh->soffset);
 	}
 
-	if (adinicb)
+	if (adinicb) {
 		mark_inode_dirty(inode);
-	else {
+	} else {
 		if (fibh->sbh != fibh->ebh)
 			mark_buffer_dirty_inode(fibh->ebh, inode);
 		mark_buffer_dirty_inode(fibh->sbh, inode);
@@ -163,26 +154,25 @@ static struct fileIdentDesc *udf_find_en
 	kernel_lb_addr eloc;
 	uint32_t elen;
 	sector_t offset;
-	struct extent_position epos = { NULL, 0, {0, 0} };
+	struct extent_position epos = {};
 
 	size = (udf_ext0_offset(dir) + dir->i_size) >> 2;
 	f_pos = (udf_ext0_offset(dir) >> 2);
 
-	fibh->soffset = fibh->eoffset =
-	    (f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
-	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
+	fibh->soffset = fibh->eoffset = (f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
+	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
 		fibh->sbh = fibh->ebh = NULL;
-	else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
-			    &epos, &eloc, &elen,
-			    &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
+	} else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
+			      &epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
 		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
 			if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_SHORT)
 				epos.offset -= sizeof(short_ad);
 			else if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_LONG)
 				epos.offset -= sizeof(long_ad);
-		} else
+		} else {
 			offset = 0;
+		}
 
 		if (!(fibh->sbh = fibh->ebh = udf_tread(dir->i_sb, block))) {
 			brelse(epos.bh);
@@ -196,7 +186,6 @@ static struct fileIdentDesc *udf_find_en
 	while ((f_pos < size)) {
 		fi = udf_fileident_read(dir, &f_pos, fibh, cfi, &epos, &eloc,
 					&elen, &offset);
-
 		if (!fi) {
 			if (fibh->sbh != fibh->ebh)
 				brelse(fibh->ebh);
@@ -213,20 +202,14 @@ static struct fileIdentDesc *udf_find_en
 		} else {
 			int poffset;	/* Unpaded ending offset */
 
-			poffset =
-			    fibh->soffset + sizeof(struct fileIdentDesc) + liu +
-			    lfi;
-
-			if (poffset >= lfi)
-				nameptr =
-				    (uint8_t *) (fibh->ebh->b_data + poffset -
-						 lfi);
-			else {
+			poffset = fibh->soffset + sizeof(struct fileIdentDesc) + liu + lfi;
+
+			if (poffset >= lfi) {
+				nameptr = (uint8_t *)(fibh->ebh->b_data + poffset - lfi);
+			} else {
 				nameptr = fname;
-				memcpy(nameptr, fi->fileIdent + liu,
-				       lfi - poffset);
-				memcpy(nameptr + lfi - poffset,
-				       fibh->ebh->b_data, poffset);
+				memcpy(nameptr, fi->fileIdent + liu, lfi - poffset);
+				memcpy(nameptr + lfi - poffset, fibh->ebh->b_data, poffset);
 			}
 		}
 
@@ -244,18 +227,18 @@ static struct fileIdentDesc *udf_find_en
 			continue;
 
 		if ((flen = udf_get_filename(dir->i_sb, nameptr, fname, lfi))) {
-			if (udf_match
-			    (flen, fname, dentry->d_name.len,
-			     dentry->d_name.name)) {
+			if (udf_match(flen, fname, dentry->d_name.len, dentry->d_name.name)) {
 				brelse(epos.bh);
 				return fi;
 			}
 		}
 	}
+
 	if (fibh->sbh != fibh->ebh)
 		brelse(fibh->ebh);
 	brelse(fibh->sbh);
 	brelse(epos.bh);
+
 	return NULL;
 }
 
@@ -306,15 +289,19 @@ static struct dentry *udf_lookup(struct 
 #ifdef UDF_RECOVERY
 	/* temporary shorthand for specifying files by inode number */
 	if (!strncmp(dentry->d_name.name, ".B=", 3)) {
-		kernel_lb_addr lb =
-		    { 0, simple_strtoul(dentry->d_name.name + 3, NULL, 0) };
+		kernel_lb_addr lb = {
+			.logicalBlockNum = 0,
+			.partitionReferenceNum = simple_strtoul(dentry->d_name.name + 3,
+								NULL, 0),
+		};
 		inode = udf_iget(dir->i_sb, lb);
 		if (!inode) {
 			unlock_kernel();
 			return ERR_PTR(-EACCES);
 		}
-	} else
-#endif				/* UDF_RECOVERY */
+	}
+	else
+#endif /* UDF_RECOVERY */
 
 	if (udf_find_entry(dir, dentry, &fibh, &cfi)) {
 		if (fibh.sbh != fibh.ebh)
@@ -329,6 +316,7 @@ static struct dentry *udf_lookup(struct 
 	}
 	unlock_kernel();
 	d_add(dentry, inode);
+
 	return NULL;
 }
 
@@ -352,7 +340,7 @@ static struct fileIdentDesc *udf_add_ent
 	kernel_lb_addr eloc;
 	uint32_t elen;
 	sector_t offset;
-	struct extent_position epos = { NULL, 0, {0, 0} };
+	struct extent_position epos = {};
 
 	sb = dir->i_sb;
 
@@ -361,36 +349,33 @@ static struct fileIdentDesc *udf_add_ent
 			*err = -EINVAL;
 			return NULL;
 		}
-
-		if (!
-		    (namelen =
-		     udf_put_filename(sb, dentry->d_name.name, name,
-				      dentry->d_name.len))) {
+		if (!(namelen = udf_put_filename(sb, dentry->d_name.name, name,
+						 dentry->d_name.len))) {
 			*err = -ENAMETOOLONG;
 			return NULL;
 		}
-	} else
+	} else {
 		namelen = 0;
+	}
 
 	nfidlen = (sizeof(struct fileIdentDesc) + namelen + 3) & ~3;
 
 	f_pos = (udf_ext0_offset(dir) >> 2);
 
-	fibh->soffset = fibh->eoffset =
-	    (f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
-	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
+	fibh->soffset = fibh->eoffset = (f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
+	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
 		fibh->sbh = fibh->ebh = NULL;
-	else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
-			    &epos, &eloc, &elen,
-			    &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
+	} else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
+			      &epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
 		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
 			if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_SHORT)
 				epos.offset -= sizeof(short_ad);
 			else if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_LONG)
 				epos.offset -= sizeof(long_ad);
-		} else
+		} else {
 			offset = 0;
+		}
 
 		if (!(fibh->sbh = fibh->ebh = udf_tread(dir->i_sb, block))) {
 			brelse(epos.bh);
@@ -423,40 +408,33 @@ static struct fileIdentDesc *udf_add_ent
 		liu = le16_to_cpu(cfi->lengthOfImpUse);
 		lfi = cfi->lengthFileIdent;
 
-		if (fibh->sbh == fibh->ebh)
+		if (fibh->sbh == fibh->ebh) {
 			nameptr = fi->fileIdent + liu;
-		else {
+		} else {
 			int poffset;	/* Unpaded ending offset */
 
-			poffset =
-			    fibh->soffset + sizeof(struct fileIdentDesc) + liu +
-			    lfi;
-
-			if (poffset >= lfi)
-				nameptr =
-				    (char *)(fibh->ebh->b_data + poffset - lfi);
-			else {
+			poffset = fibh->soffset + sizeof(struct fileIdentDesc) + liu + lfi;
+
+			if (poffset >= lfi) {
+				nameptr = (char *)(fibh->ebh->b_data + poffset - lfi);
+			} else {
 				nameptr = fname;
-				memcpy(nameptr, fi->fileIdent + liu,
-				       lfi - poffset);
-				memcpy(nameptr + lfi - poffset,
-				       fibh->ebh->b_data, poffset);
+				memcpy(nameptr, fi->fileIdent + liu, lfi - poffset);
+				memcpy(nameptr + lfi - poffset, fibh->ebh->b_data, poffset);
 			}
 		}
 
 		if ((cfi->fileCharacteristics & FID_FILE_CHAR_DELETED) != 0) {
-			if (((sizeof(struct fileIdentDesc) + liu + lfi +
-			      3) & ~3) == nfidlen) {
+			if (((sizeof(struct fileIdentDesc) + liu + lfi + 3) & ~3) == nfidlen) {
 				brelse(epos.bh);
 				cfi->descTag.tagSerialNum = cpu_to_le16(1);
 				cfi->fileVersionNum = cpu_to_le16(1);
 				cfi->fileCharacteristics = 0;
 				cfi->lengthFileIdent = namelen;
 				cfi->lengthOfImpUse = cpu_to_le16(0);
-				if (!udf_write_fi
-				    (dir, cfi, fi, fibh, NULL, name))
+				if (!udf_write_fi(dir, cfi, fi, fibh, NULL, name)) {
 					return fi;
-				else {
+				} else {
 					*err = -EIO;
 					return NULL;
 				}
@@ -467,8 +445,7 @@ static struct fileIdentDesc *udf_add_ent
 			continue;
 
 		if ((flen = udf_get_filename(dir->i_sb, nameptr, fname, lfi)) &&
-		    udf_match(flen, fname, dentry->d_name.len,
-			      dentry->d_name.name)) {
+		    udf_match(flen, fname, dentry->d_name.len, dentry->d_name.name)) {
 			if (fibh->sbh != fibh->ebh)
 				brelse(fibh->ebh);
 			brelse(fibh->sbh);
@@ -478,7 +455,7 @@ static struct fileIdentDesc *udf_add_ent
 		}
 	}
 
-      add:
+add:
 	f_pos += nfidlen;
 
 	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB &&
@@ -491,14 +468,11 @@ static struct fileIdentDesc *udf_add_ent
 		if (fibh->sbh != fibh->ebh)
 			brelse(fibh->ebh);
 		brelse(fibh->sbh);
-		if (!
-		    (fibh->sbh = fibh->ebh =
-		     udf_expand_dir_adinicb(dir, &block, err)))
+		if (!(fibh->sbh = fibh->ebh = udf_expand_dir_adinicb(dir, &block, err)))
 			return NULL;
 		epos.block = UDF_I_LOCATION(dir);
 		eloc.logicalBlockNum = block;
-		eloc.partitionReferenceNum =
-		    UDF_I_LOCATION(dir).partitionReferenceNum;
+		eloc.partitionReferenceNum = UDF_I_LOCATION(dir).partitionReferenceNum;
 		elen = dir->i_sb->s_blocksize;
 		epos.offset = udf_file_entry_alloc_offset(dir);
 		if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_SHORT)
@@ -517,16 +491,13 @@ static struct fileIdentDesc *udf_add_ent
 
 		if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
 			block = UDF_I_LOCATION(dir).logicalBlockNum;
-			fi = (struct fileIdentDesc *)(UDF_I_DATA(dir) +
-						      fibh->soffset -
+			fi = (struct fileIdentDesc *)(UDF_I_DATA(dir) + fibh->soffset -
 						      udf_ext0_offset(dir) +
 						      UDF_I_LENEATTR(dir));
 		} else {
 			block = eloc.logicalBlockNum + ((elen - 1) >>
-							dir->i_sb->
-							s_blocksize_bits);
-			fi = (struct fileIdentDesc *)(fibh->sbh->b_data +
-						      fibh->soffset);
+							dir->i_sb->s_blocksize_bits);
+			fi = (struct fileIdentDesc *)(fibh->sbh->b_data + fibh->soffset);
 		}
 	} else {
 		fibh->soffset = fibh->eoffset - sb->s_blocksize;
@@ -538,42 +509,36 @@ static struct fileIdentDesc *udf_add_ent
 
 		block = eloc.logicalBlockNum + ((elen - 1) >>
 						dir->i_sb->s_blocksize_bits);
-
-		if (!
-		    (fibh->ebh =
-		     udf_bread(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
-			       1, err))) {
+		fibh->ebh = udf_bread(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2), 1, err);
+		if (!fibh->ebh) {
 			brelse(epos.bh);
 			brelse(fibh->sbh);
 			return NULL;
 		}
 
-		if (!(fibh->soffset)) {
+		if (!fibh->soffset) {
 			if (udf_next_aext(dir, &epos, &eloc, &elen, 1) ==
 			    (EXT_RECORDED_ALLOCATED >> 30)) {
 				block = eloc.logicalBlockNum + ((elen - 1) >>
-								dir->i_sb->
-								s_blocksize_bits);
-			} else
+					dir->i_sb->s_blocksize_bits);
+			} else {
 				block++;
+			}
 
 			brelse(fibh->sbh);
 			fibh->sbh = fibh->ebh;
 			fi = (struct fileIdentDesc *)(fibh->sbh->b_data);
 		} else {
 			fi = (struct fileIdentDesc *)
-			    (fibh->sbh->b_data + sb->s_blocksize +
-			     fibh->soffset);
+				(fibh->sbh->b_data + sb->s_blocksize + fibh->soffset);
 		}
 	}
 
 	memset(cfi, 0, sizeof(struct fileIdentDesc));
 	if (UDF_SB_UDFREV(sb) >= 0x0200)
-		udf_new_tag((char *)cfi, TAG_IDENT_FID, 3, 1, block,
-			    sizeof(tag));
+		udf_new_tag((char *)cfi, TAG_IDENT_FID, 3, 1, block, sizeof(tag));
 	else
-		udf_new_tag((char *)cfi, TAG_IDENT_FID, 2, 1, block,
-			    sizeof(tag));
+		udf_new_tag((char *)cfi, TAG_IDENT_FID, 2, 1, block, sizeof(tag));
 	cfi->fileVersionNum = cpu_to_le16(1);
 	cfi->lengthFileIdent = namelen;
 	cfi->lengthOfImpUse = cpu_to_le16(0);
@@ -599,8 +564,10 @@ static int udf_delete_entry(struct inode
 			    struct fileIdentDesc *cfi)
 {
 	cfi->fileCharacteristics |= FID_FILE_CHAR_DELETED;
+
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT))
 		memset(&(cfi->icb), 0x00, sizeof(long_ad));
+
 	return udf_write_fi(inode, cfi, fi, fibh, NULL, NULL);
 }
 
@@ -637,8 +604,8 @@ static int udf_create(struct inode *dir,
 	}
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
 	cfi.icb.extLocation = cpu_to_lelb(UDF_I_LOCATION(inode));
-	*(__le32 *) ((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
-	    cpu_to_le32(UDF_I_UNIQUE(inode) & 0x00000000FFFFFFFFUL);
+	*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
+		cpu_to_le32(UDF_I_UNIQUE(inode) & 0x00000000FFFFFFFFUL);
 	udf_write_fi(dir, &cfi, fi, &fibh, NULL, NULL);
 	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
 		mark_inode_dirty(dir);
@@ -648,6 +615,7 @@ static int udf_create(struct inode *dir,
 	brelse(fibh.sbh);
 	unlock_kernel();
 	d_instantiate(dentry, inode);
+
 	return 0;
 }
 
@@ -679,8 +647,8 @@ static int udf_mknod(struct inode *dir, 
 	}
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
 	cfi.icb.extLocation = cpu_to_lelb(UDF_I_LOCATION(inode));
-	*(__le32 *) ((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
-	    cpu_to_le32(UDF_I_UNIQUE(inode) & 0x00000000FFFFFFFFUL);
+	*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
+		cpu_to_le32(UDF_I_UNIQUE(inode) & 0x00000000FFFFFFFFUL);
 	udf_write_fi(dir, &cfi, fi, &fibh, NULL, NULL);
 	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
 		mark_inode_dirty(dir);
@@ -692,7 +660,8 @@ static int udf_mknod(struct inode *dir, 
 	brelse(fibh.sbh);
 	d_instantiate(dentry, inode);
 	err = 0;
-      out:
+
+out:
 	unlock_kernel();
 	return err;
 }
@@ -725,10 +694,9 @@ static int udf_mkdir(struct inode *dir, 
 	inode->i_nlink = 2;
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
 	cfi.icb.extLocation = cpu_to_lelb(UDF_I_LOCATION(dir));
-	*(__le32 *) ((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
-	    cpu_to_le32(UDF_I_UNIQUE(dir) & 0x00000000FFFFFFFFUL);
-	cfi.fileCharacteristics =
-	    FID_FILE_CHAR_DIRECTORY | FID_FILE_CHAR_PARENT;
+	*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
+		cpu_to_le32(UDF_I_UNIQUE(dir) & 0x00000000FFFFFFFFUL);
+	cfi.fileCharacteristics = FID_FILE_CHAR_DIRECTORY | FID_FILE_CHAR_PARENT;
 	udf_write_fi(inode, &cfi, fi, &fibh, NULL, NULL);
 	brelse(fibh.sbh);
 	inode->i_mode = S_IFDIR | mode;
@@ -744,8 +712,8 @@ static int udf_mkdir(struct inode *dir, 
 	}
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
 	cfi.icb.extLocation = cpu_to_lelb(UDF_I_LOCATION(inode));
-	*(__le32 *) ((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
-	    cpu_to_le32(UDF_I_UNIQUE(inode) & 0x00000000FFFFFFFFUL);
+	*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
+		cpu_to_le32(UDF_I_UNIQUE(inode) & 0x00000000FFFFFFFFUL);
 	cfi.fileCharacteristics |= FID_FILE_CHAR_DIRECTORY;
 	udf_write_fi(dir, &cfi, fi, &fibh, NULL, NULL);
 	inc_nlink(dir);
@@ -755,7 +723,8 @@ static int udf_mkdir(struct inode *dir, 
 		brelse(fibh.ebh);
 	brelse(fibh.sbh);
 	err = 0;
-      out:
+
+out:
 	unlock_kernel();
 	return err;
 }
@@ -770,26 +739,25 @@ static int empty_dir(struct inode *dir)
 	kernel_lb_addr eloc;
 	uint32_t elen;
 	sector_t offset;
-	struct extent_position epos = { NULL, 0, {0, 0} };
+	struct extent_position epos = {};
 
 	f_pos = (udf_ext0_offset(dir) >> 2);
 
-	fibh.soffset = fibh.eoffset =
-	    (f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
+	fibh.soffset = fibh.eoffset = (f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
 
-	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
+	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
 		fibh.sbh = fibh.ebh = NULL;
-	else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
-			    &epos, &eloc, &elen,
-			    &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
+	} else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
+			      &epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
 		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
 			if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_SHORT)
 				epos.offset -= sizeof(short_ad);
 			else if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_LONG)
 				epos.offset -= sizeof(long_ad);
-		} else
+		} else {
 			offset = 0;
+		}
 
 		if (!(fibh.sbh = fibh.ebh = udf_tread(dir->i_sb, block))) {
 			brelse(epos.bh);
@@ -803,7 +771,6 @@ static int empty_dir(struct inode *dir)
 	while ((f_pos < size)) {
 		fi = udf_fileident_read(dir, &f_pos, &fibh, &cfi, &epos, &eloc,
 					&elen, &offset);
-
 		if (!fi) {
 			if (fibh.sbh != fibh.ebh)
 				brelse(fibh.ebh);
@@ -812,8 +779,8 @@ static int empty_dir(struct inode *dir)
 			return 0;
 		}
 
-		if (cfi.lengthFileIdent
-		    && (cfi.fileCharacteristics & FID_FILE_CHAR_DELETED) == 0) {
+		if (cfi.lengthFileIdent &&
+		    (cfi.fileCharacteristics & FID_FILE_CHAR_DELETED) == 0) {
 			if (fibh.sbh != fibh.ebh)
 				brelse(fibh.ebh);
 			brelse(fibh.sbh);
@@ -821,10 +788,12 @@ static int empty_dir(struct inode *dir)
 			return 0;
 		}
 	}
+
 	if (fibh.sbh != fibh.ebh)
 		brelse(fibh.ebh);
 	brelse(fibh.sbh);
 	brelse(epos.bh);
+
 	return 1;
 }
 
@@ -859,15 +828,15 @@ static int udf_rmdir(struct inode *dir, 
 	clear_nlink(inode);
 	inode->i_size = 0;
 	inode_dec_link_count(dir);
-	inode->i_ctime = dir->i_ctime = dir->i_mtime =
-	    current_fs_time(dir->i_sb);
+	inode->i_ctime = dir->i_ctime = dir->i_mtime = current_fs_time(dir->i_sb);
 	mark_inode_dirty(dir);
 
-      end_rmdir:
+end_rmdir:
 	if (fibh.sbh != fibh.ebh)
 		brelse(fibh.ebh);
 	brelse(fibh.sbh);
-      out:
+
+out:
 	unlock_kernel();
 	return retval;
 }
@@ -906,11 +875,12 @@ static int udf_unlink(struct inode *dir,
 	inode->i_ctime = dir->i_ctime;
 	retval = 0;
 
-      end_unlink:
+end_unlink:
 	if (fibh.sbh != fibh.ebh)
 		brelse(fibh.ebh);
 	brelse(fibh.sbh);
-      out:
+
+out:
 	unlock_kernel();
 	return retval;
 }
@@ -922,7 +892,7 @@ static int udf_symlink(struct inode *dir
 	struct pathComponent *pc;
 	char *compstart;
 	struct udf_fileident_bh fibh;
-	struct extent_position epos = { NULL, 0, {0, 0} };
+	struct extent_position epos = {};
 	int eoffset, elen = 0;
 	struct fileIdentDesc *fi;
 	struct fileIdentDesc cfi;
@@ -945,26 +915,22 @@ static int udf_symlink(struct inode *dir
 		uint32_t elen;
 
 		block = udf_new_block(inode->i_sb, inode,
-				      UDF_I_LOCATION(inode).
-				      partitionReferenceNum,
-				      UDF_I_LOCATION(inode).logicalBlockNum,
-				      &err);
+				      UDF_I_LOCATION(inode).partitionReferenceNum,
+				      UDF_I_LOCATION(inode).logicalBlockNum, &err);
 		if (!block)
 			goto out_no_entry;
 		epos.block = UDF_I_LOCATION(inode);
 		epos.offset = udf_file_entry_alloc_offset(inode);
 		epos.bh = NULL;
 		eloc.logicalBlockNum = block;
-		eloc.partitionReferenceNum =
-		    UDF_I_LOCATION(inode).partitionReferenceNum;
+		eloc.partitionReferenceNum = UDF_I_LOCATION(inode).partitionReferenceNum;
 		elen = inode->i_sb->s_blocksize;
 		UDF_I_LENEXTENTS(inode) = elen;
 		udf_add_aext(inode, &epos, eloc, elen, 0);
 		brelse(epos.bh);
 
 		block = udf_get_pblock(inode->i_sb, block,
-				       UDF_I_LOCATION(inode).
-				       partitionReferenceNum, 0);
+				       UDF_I_LOCATION(inode).partitionReferenceNum, 0);
 		epos.bh = udf_tread(inode->i_sb, block);
 		lock_buffer(epos.bh);
 		memset(epos.bh->b_data, 0x00, inode->i_sb->s_blocksize);
@@ -972,8 +938,9 @@ static int udf_symlink(struct inode *dir
 		unlock_buffer(epos.bh);
 		mark_buffer_dirty_inode(epos.bh, inode);
 		ea = epos.bh->b_data + udf_ext0_offset(inode);
-	} else
+	} else {
 		ea = UDF_I_DATA(inode) + UDF_I_LENEATTR(inode);
+	}
 
 	eoffset = inode->i_sb->s_blocksize - udf_ext0_offset(inode);
 	pc = (struct pathComponent *)ea;
@@ -1010,20 +977,17 @@ static int udf_symlink(struct inode *dir
 		if (compstart[0] == '.') {
 			if ((symname - compstart) == 1)
 				pc->componentType = 4;
-			else if ((symname - compstart) == 2
-				 && compstart[1] == '.')
+			else if ((symname - compstart) == 2 && compstart[1] == '.')
 				pc->componentType = 3;
 		}
 
 		if (pc->componentType == 5) {
-			if (!
-			    (namelen =
-			     udf_put_filename(inode->i_sb, compstart, name,
-					      symname - compstart)))
+			namelen = udf_put_filename(inode->i_sb, compstart, name,
+						   symname - compstart);
+			if (!namelen)
 				goto out_no_entry;
 
-			if (elen + sizeof(struct pathComponent) + namelen >
-			    eoffset)
+			if (elen + sizeof(struct pathComponent) + namelen > eoffset)
 				goto out_no_entry;
 			else
 				pc->lengthComponentIdent = namelen;
@@ -1053,12 +1017,10 @@ static int udf_symlink(struct inode *dir
 	if (UDF_SB_LVIDBH(inode->i_sb)) {
 		struct logicalVolHeaderDesc *lvhd;
 		uint64_t uniqueID;
-		lvhd =
-		    (struct logicalVolHeaderDesc *)(UDF_SB_LVID(inode->i_sb)->
-						    logicalVolContentsUse);
+		lvhd = (struct logicalVolHeaderDesc *)(UDF_SB_LVID(inode->i_sb)->logicalVolContentsUse);
 		uniqueID = le64_to_cpu(lvhd->uniqueID);
-		*(__le32 *) ((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
-		    cpu_to_le32(uniqueID & 0x00000000FFFFFFFFUL);
+		*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
+			cpu_to_le32(uniqueID & 0x00000000FFFFFFFFUL);
 		if (!(++uniqueID & 0x00000000FFFFFFFFUL))
 			uniqueID += 16;
 		lvhd->uniqueID = cpu_to_le64(uniqueID);
@@ -1074,11 +1036,11 @@ static int udf_symlink(struct inode *dir
 	d_instantiate(dentry, inode);
 	err = 0;
 
-      out:
+out:
 	unlock_kernel();
 	return err;
 
-      out_no_entry:
+out_no_entry:
 	inode_dec_link_count(inode);
 	iput(inode);
 	goto out;
@@ -1107,12 +1069,10 @@ static int udf_link(struct dentry *old_d
 	if (UDF_SB_LVIDBH(inode->i_sb)) {
 		struct logicalVolHeaderDesc *lvhd;
 		uint64_t uniqueID;
-		lvhd =
-		    (struct logicalVolHeaderDesc *)(UDF_SB_LVID(inode->i_sb)->
-						    logicalVolContentsUse);
+		lvhd = (struct logicalVolHeaderDesc *)(UDF_SB_LVID(inode->i_sb)->logicalVolContentsUse);
 		uniqueID = le64_to_cpu(lvhd->uniqueID);
-		*(__le32 *) ((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
-		    cpu_to_le32(uniqueID & 0x00000000FFFFFFFFUL);
+		*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
+			cpu_to_le32(uniqueID & 0x00000000FFFFFFFFUL);
 		if (!(++uniqueID & 0x00000000FFFFFFFFUL))
 			uniqueID += 16;
 		lvhd->uniqueID = cpu_to_le64(uniqueID);
@@ -1122,6 +1082,7 @@ static int udf_link(struct dentry *old_d
 	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
 		mark_inode_dirty(dir);
 	}
+
 	if (fibh.sbh != fibh.ebh)
 		brelse(fibh.ebh);
 	brelse(fibh.sbh);
@@ -1131,6 +1092,7 @@ static int udf_link(struct dentry *old_d
 	atomic_inc(&inode->i_count);
 	d_instantiate(dentry, inode);
 	unlock_kernel();
+
 	return 0;
 }
 
@@ -1143,8 +1105,7 @@ static int udf_rename(struct inode *old_
 	struct inode *old_inode = old_dentry->d_inode;
 	struct inode *new_inode = new_dentry->d_inode;
 	struct udf_fileident_bh ofibh, nfibh;
-	struct fileIdentDesc *ofi = NULL, *nfi = NULL, *dir_fi =
-	    NULL, ocfi, ncfi;
+	struct fileIdentDesc *ofi = NULL, *nfi = NULL, *dir_fi = NULL, ocfi, ncfi;
 	struct buffer_head *dir_bh = NULL;
 	int retval = -ENOENT;
 	kernel_lb_addr tloc;
@@ -1181,36 +1142,27 @@ static int udf_rename(struct inode *old_
 		if (UDF_I_ALLOCTYPE(old_inode) == ICBTAG_FLAG_AD_IN_ICB) {
 			dir_fi = udf_get_fileident(UDF_I_DATA(old_inode) -
 						   (UDF_I_EFE(old_inode) ?
-						    sizeof(struct
-							   extendedFileEntry) :
+						    sizeof(struct extendedFileEntry) :
 						    sizeof(struct fileEntry)),
-						   old_inode->i_sb->s_blocksize,
-						   &offset);
+						   old_inode->i_sb->s_blocksize, &offset);
 		} else {
 			dir_bh = udf_bread(old_inode, 0, 0, &retval);
 			if (!dir_bh)
 				goto end_rename;
-			dir_fi =
-			    udf_get_fileident(dir_bh->b_data,
-					      old_inode->i_sb->s_blocksize,
-					      &offset);
+			dir_fi = udf_get_fileident(dir_bh->b_data, old_inode->i_sb->s_blocksize, &offset);
 		}
 		if (!dir_fi)
 			goto end_rename;
 		tloc = lelb_to_cpu(dir_fi->icb.extLocation);
-		if (udf_get_lb_pblock(old_inode->i_sb, tloc, 0)
-		    != old_dir->i_ino)
+		if (udf_get_lb_pblock(old_inode->i_sb, tloc, 0) != old_dir->i_ino)
 			goto end_rename;
 
 		retval = -EMLINK;
-		if (!new_inode
-		    && new_dir->i_nlink >=
-		    (256 << sizeof(new_dir->i_nlink)) - 1)
+		if (!new_inode && new_dir->i_nlink >= (256 << sizeof(new_dir->i_nlink)) - 1)
 			goto end_rename;
 	}
 	if (!nfi) {
-		nfi =
-		    udf_add_entry(new_dir, new_dentry, &nfibh, &ncfi, &retval);
+		nfi = udf_add_entry(new_dir, new_dentry, &nfibh, &ncfi, &retval);
 		if (!nfi)
 			goto end_rename;
 	}
@@ -1244,13 +1196,12 @@ static int udf_rename(struct inode *old_
 	if (dir_fi) {
 		dir_fi->icb.extLocation = cpu_to_lelb(UDF_I_LOCATION(new_dir));
 		udf_update_tag((char *)dir_fi, (sizeof(struct fileIdentDesc) +
-						le16_to_cpu(dir_fi->
-							    lengthOfImpUse) +
-						3) & ~3);
+						le16_to_cpu(dir_fi->lengthOfImpUse) + 3) & ~3);
 		if (UDF_I_ALLOCTYPE(old_inode) == ICBTAG_FLAG_AD_IN_ICB) {
 			mark_inode_dirty(old_inode);
-		} else
+		} else {
 			mark_buffer_dirty_inode(dir_bh, old_inode);
+		}
 		inode_dec_link_count(old_dir);
 		if (new_inode) {
 			inode_dec_link_count(new_inode);
@@ -1268,7 +1219,7 @@ static int udf_rename(struct inode *old_
 
 	retval = 0;
 
-      end_rename:
+end_rename:
 	brelse(dir_bh);
 	if (nfi) {
 		if (nfibh.sbh != nfibh.ebh)
@@ -1276,17 +1227,18 @@ static int udf_rename(struct inode *old_
 		brelse(nfibh.sbh);
 	}
 	unlock_kernel();
+
 	return retval;
 }
 
 const struct inode_operations udf_dir_inode_operations = {
-	.lookup = udf_lookup,
-	.create = udf_create,
-	.link = udf_link,
-	.unlink = udf_unlink,
-	.symlink = udf_symlink,
-	.mkdir = udf_mkdir,
-	.rmdir = udf_rmdir,
-	.mknod = udf_mknod,
-	.rename = udf_rename,
+	.lookup				= udf_lookup,
+	.create				= udf_create,
+	.link				= udf_link,
+	.unlink				= udf_unlink,
+	.symlink			= udf_symlink,
+	.mkdir				= udf_mkdir,
+	.rmdir				= udf_rmdir,
+	.mknod				= udf_mknod,
+	.rename				= udf_rename,
 };
diff -puN fs/udf/osta_udf.h~udf-coding-style-conversion-lindent-fixups fs/udf/osta_udf.h
--- a/fs/udf/osta_udf.h~udf-coding-style-conversion-lindent-fixups
+++ a/fs/udf/osta_udf.h
@@ -66,64 +66,64 @@
 #define IS_DF_SOFT_WRITE_PROTECT	0x02
 
 struct UDFIdentSuffix {
-	__le16 UDFRevision;
-	uint8_t OSClass;
-	uint8_t OSIdentifier;
-	uint8_t reserved[4];
+	__le16		UDFRevision;
+	uint8_t		OSClass;
+	uint8_t		OSIdentifier;
+	uint8_t		reserved[4];
 } __attribute__ ((packed));
 
 struct impIdentSuffix {
-	uint8_t OSClass;
-	uint8_t OSIdentifier;
-	uint8_t reserved[6];
+	uint8_t		OSClass;
+	uint8_t		OSIdentifier;
+	uint8_t		reserved[6];
 } __attribute__ ((packed));
 
 struct appIdentSuffix {
-	uint8_t impUse[8];
+	uint8_t		impUse[8];
 } __attribute__ ((packed));
 
 /* Logical Volume Integrity Descriptor (UDF 2.50 2.2.6) */
 /* Implementation Use (UDF 2.50 2.2.6.4) */
 struct logicalVolIntegrityDescImpUse {
-	regid impIdent;
-	__le32 numFiles;
-	__le32 numDirs;
-	__le16 minUDFReadRev;
-	__le16 minUDFWriteRev;
-	__le16 maxUDFWriteRev;
-	uint8_t impUse[0];
+	regid		impIdent;
+	__le32		numFiles;
+	__le32		numDirs;
+	__le16		minUDFReadRev;
+	__le16		minUDFWriteRev;
+	__le16		maxUDFWriteRev;
+	uint8_t		impUse[0];
 } __attribute__ ((packed));
 
 /* Implementation Use Volume Descriptor (UDF 2.50 2.2.7) */
 /* Implementation Use (UDF 2.50 2.2.7.2) */
 struct impUseVolDescImpUse {
-	charspec LVICharset;
-	dstring logicalVolIdent[128];
-	dstring LVInfo1[36];
-	dstring LVInfo2[36];
-	dstring LVInfo3[36];
-	regid impIdent;
-	uint8_t impUse[128];
+	charspec	LVICharset;
+	dstring		logicalVolIdent[128];
+	dstring		LVInfo1[36];
+	dstring		LVInfo2[36];
+	dstring		LVInfo3[36];
+	regid		impIdent;
+	uint8_t		impUse[128];
 } __attribute__ ((packed));
 
 struct udfPartitionMap2 {
-	uint8_t partitionMapType;
-	uint8_t partitionMapLength;
-	uint8_t reserved1[2];
-	regid partIdent;
-	__le16 volSeqNum;
-	__le16 partitionNum;
+	uint8_t		partitionMapType;
+	uint8_t		partitionMapLength;
+	uint8_t		reserved1[2];
+	regid		partIdent;
+	__le16		volSeqNum;
+	__le16		partitionNum;
 } __attribute__ ((packed));
 
 /* Virtual Partition Map (UDF 2.50 2.2.8) */
 struct virtualPartitionMap {
-	uint8_t partitionMapType;
-	uint8_t partitionMapLength;
-	uint8_t reserved1[2];
-	regid partIdent;
-	__le16 volSeqNum;
-	__le16 partitionNum;
-	uint8_t reserved2[24];
+	uint8_t		partitionMapType;
+	uint8_t		partitionMapLength;
+	uint8_t		reserved1[2];
+	regid		partIdent;
+	__le16		volSeqNum;
+	__le16		partitionNum;
+	uint8_t		reserved2[24];
 } __attribute__ ((packed));
 
 /* Sparable Partition Map (UDF 2.50 2.2.9) */
@@ -143,62 +143,62 @@ struct sparablePartitionMap {
 
 /* Metadata Partition Map (UDF 2.4.0 2.2.10) */
 struct metadataPartitionMap {
-	uint8_t partitionMapType;
-	uint8_t partitionMapLength;
-	uint8_t reserved1[2];
-	regid partIdent;
-	__le16 volSeqNum;
-	__le16 partitionNum;
-	__le32 metadataFileLoc;
-	__le32 metadataMirrorFileLoc;
-	__le32 metadataBitmapFileLoc;
-	__le32 allocUnitSize;
-	__le16 alignUnitSize;
-	uint8_t flags;
-	uint8_t reserved2[5];
+	uint8_t		partitionMapType;
+	uint8_t		partitionMapLength;
+	uint8_t		reserved1[2];
+	regid		partIdent;
+	__le16		volSeqNum;
+	__le16		partitionNum;
+	__le32		metadataFileLoc;
+	__le32		metadataMirrorFileLoc;
+	__le32		metadataBitmapFileLoc;
+	__le32		allocUnitSize;
+	__le16		alignUnitSize;
+	uint8_t		flags;
+	uint8_t		reserved2[5];
 } __attribute__ ((packed));
 
 /* Virtual Allocation Table (UDF 1.5 2.2.10) */
 struct virtualAllocationTable15 {
-	__le32 VirtualSector[0];
-	regid vatIdent;
-	__le32 previousVATICBLoc;
+	__le32		VirtualSector[0];
+	regid		vatIdent;
+	__le32		previousVATICBLoc;
 } __attribute__ ((packed));
 
 #define ICBTAG_FILE_TYPE_VAT15		0x00U
 
 /* Virtual Allocation Table (UDF 2.50 2.2.11) */
 struct virtualAllocationTable20 {
-	__le16 lengthHeader;
-	__le16 lengthImpUse;
-	dstring logicalVolIdent[128];
-	__le32 previousVATICBLoc;
-	__le32 numFiles;
-	__le32 numDirs;
-	__le16 minReadRevision;
-	__le16 minWriteRevision;
-	__le16 maxWriteRevision;
-	__le16 reserved;
-	uint8_t impUse[0];
-	__le32 vatEntry[0];
+	__le16		lengthHeader;
+	__le16		lengthImpUse;
+	dstring		logicalVolIdent[128];
+	__le32		previousVATICBLoc;
+	__le32		numFiles;
+	__le32		numDirs;
+	__le16		minReadRevision;
+	__le16		minWriteRevision;
+	__le16		maxWriteRevision;
+	__le16		reserved;
+	uint8_t		impUse[0];
+	__le32		vatEntry[0];
 } __attribute__ ((packed));
 
 #define ICBTAG_FILE_TYPE_VAT20		0xF8U
 
 /* Sparing Table (UDF 2.50 2.2.12) */
 struct sparingEntry {
-	__le32 origLocation;
-	__le32 mappedLocation;
+	__le32		origLocation;
+	__le32		mappedLocation;
 } __attribute__ ((packed));
 
 struct sparingTable {
-	tag descTag;
-	regid sparingIdent;
-	__le16 reallocationTableLen;
-	__le16 reserved;
-	__le32 sequenceNum;
+	tag 		descTag;
+	regid		sparingIdent;
+	__le16		reallocationTableLen;
+	__le16		reserved;
+	__le32		sequenceNum;
 	struct sparingEntry
-	 mapEntry[0];
+			mapEntry[0];
 } __attribute__ ((packed));
 
 /* Metadata File (and Metadata Mirror File) (UDF 2.50 2.2.13.1) */
@@ -208,8 +208,8 @@ struct sparingTable {
 
 /* struct long_ad ICB - ADImpUse (UDF 2.50 2.2.4.3) */
 struct allocDescImpUse {
-	__le16 flags;
-	uint8_t impUse[4];
+	__le16		flags;
+	uint8_t		impUse[4];
 } __attribute__ ((packed));
 
 #define AD_IU_EXT_ERASED		0x0001
@@ -220,23 +220,23 @@ struct allocDescImpUse {
 /* Implementation Use Extended Attribute (UDF 2.50 3.3.4.5) */
 /* FreeEASpace (UDF 2.50 3.3.4.5.1.1) */
 struct freeEaSpace {
-	__le16 headerChecksum;
-	uint8_t freeEASpace[0];
+	__le16		headerChecksum;
+	uint8_t		freeEASpace[0];
 } __attribute__ ((packed));
 
 /* DVD Copyright Management Information (UDF 2.50 3.3.4.5.1.2) */
 struct DVDCopyrightImpUse {
-	__le16 headerChecksum;
-	uint8_t CGMSInfo;
-	uint8_t dataType;
-	uint8_t protectionSystemInfo[4];
+	__le16		headerChecksum;
+	uint8_t		CGMSInfo;
+	uint8_t		dataType;
+	uint8_t		protectionSystemInfo[4];
 } __attribute__ ((packed));
 
 /* Application Use Extended Attribute (UDF 2.50 3.3.4.6) */
 /* FreeAppEASpace (UDF 2.50 3.3.4.6.1) */
 struct freeAppEASpace {
-	__le16 headerChecksum;
-	uint8_t freeEASpace[0];
+	__le16		headerChecksum;
+	uint8_t		freeEASpace[0];
 } __attribute__ ((packed));
 
 /* UDF Defined System Stream (UDF 2.50 3.3.7) */
@@ -276,4 +276,4 @@ struct freeAppEASpace {
 #define UDF_OS_ID_BEOS			0x00U
 #define UDF_OS_ID_WINCE			0x00U
 
-#endif				/* _OSTA_UDF_H */
+#endif /* _OSTA_UDF_H */
diff -puN fs/udf/partition.c~udf-coding-style-conversion-lindent-fixups fs/udf/partition.c
--- a/fs/udf/partition.c~udf-coding-style-conversion-lindent-fixups
+++ a/fs/udf/partition.c
@@ -14,7 +14,7 @@
  *
  * HISTORY
  *
- * 12/06/98 blf  Created file. 
+ * 12/06/98 blf  Created file.
  *
  */
 
@@ -32,19 +32,17 @@ inline uint32_t udf_get_pblock(struct su
 			       uint16_t partition, uint32_t offset)
 {
 	if (partition >= UDF_SB_NUMPARTS(sb)) {
-		udf_debug
-		    ("block=%d, partition=%d, offset=%d: invalid partition\n",
-		     block, partition, offset);
+		udf_debug("block=%d, partition=%d, offset=%d: invalid partition\n",
+			  block, partition, offset);
 		return 0xFFFFFFFF;
 	}
 	if (UDF_SB_PARTFUNC(sb, partition))
-		return UDF_SB_PARTFUNC(sb, partition) (sb, block, partition,
-						       offset);
+		return UDF_SB_PARTFUNC(sb, partition)(sb, block, partition, offset);
 	else
 		return UDF_SB_PARTROOT(sb, partition) + block + offset;
 }
 
-uint32_t udf_get_pblock_virt15(struct super_block * sb, uint32_t block,
+uint32_t udf_get_pblock_virt15(struct super_block *sb, uint32_t block,
 			       uint16_t partition, uint32_t offset)
 {
 	struct buffer_head *bh = NULL;
@@ -52,14 +50,11 @@ uint32_t udf_get_pblock_virt15(struct su
 	uint32_t index;
 	uint32_t loc;
 
-	index =
-	    (sb->s_blocksize -
-	     UDF_SB_TYPEVIRT(sb, partition).s_start_offset) / sizeof(uint32_t);
-
-	if (block > UDF_SB_TYPEVIRT(sb, partition).s_num_entries) {
-		udf_debug
-		    ("Trying to access block beyond end of VAT (%d max %d)\n",
-		     block, UDF_SB_TYPEVIRT(sb, partition).s_num_entries);
+	index = (sb->s_blocksize - UDF_SB_TYPEVIRT(sb,partition).s_start_offset) / sizeof(uint32_t);
+
+	if (block > UDF_SB_TYPEVIRT(sb,partition).s_num_entries) {
+		udf_debug("Trying to access block beyond end of VAT (%d max %d)\n",
+			  block, UDF_SB_TYPEVIRT(sb,partition).s_num_entries);
 		return 0xFFFFFFFF;
 	}
 
@@ -69,10 +64,7 @@ uint32_t udf_get_pblock_virt15(struct su
 		index = block % (sb->s_blocksize / sizeof(uint32_t));
 	} else {
 		newblock = 0;
-		index =
-		    UDF_SB_TYPEVIRT(sb,
-				    partition).s_start_offset /
-		    sizeof(uint32_t) + block;
+		index = UDF_SB_TYPEVIRT(sb,partition).s_start_offset / sizeof(uint32_t) + block;
 	}
 
 	loc = udf_block_map(UDF_SB_VAT(sb), newblock);
@@ -83,7 +75,7 @@ uint32_t udf_get_pblock_virt15(struct su
 		return 0xFFFFFFFF;
 	}
 
-	loc = le32_to_cpu(((__le32 *) bh->b_data)[index]);
+	loc = le32_to_cpu(((__le32 *)bh->b_data)[index]);
 
 	brelse(bh);
 
@@ -93,8 +85,8 @@ uint32_t udf_get_pblock_virt15(struct su
 	}
 
 	return udf_get_pblock(sb, loc,
-			      UDF_I_LOCATION(UDF_SB_VAT(sb)).
-			      partitionReferenceNum, offset);
+			      UDF_I_LOCATION(UDF_SB_VAT(sb)).partitionReferenceNum,
+			      offset);
 }
 
 inline uint32_t udf_get_pblock_virt20(struct super_block * sb, uint32_t block,
@@ -108,40 +100,29 @@ uint32_t udf_get_pblock_spar15(struct su
 {
 	int i;
 	struct sparingTable *st = NULL;
-	uint32_t packet =
-	    (block + offset) & ~(UDF_SB_TYPESPAR(sb, partition).s_packet_len -
-				 1);
+	uint32_t packet = (block + offset) & ~(UDF_SB_TYPESPAR(sb,partition).s_packet_len - 1);
 
 	for (i = 0; i < 4; i++) {
-		if (UDF_SB_TYPESPAR(sb, partition).s_spar_map[i] != NULL) {
-			st = (struct sparingTable *)UDF_SB_TYPESPAR(sb,
-								    partition).
-			    s_spar_map[i]->b_data;
+		if (UDF_SB_TYPESPAR(sb,partition).s_spar_map[i] != NULL) {
+			st = (struct sparingTable *)UDF_SB_TYPESPAR(sb,partition).s_spar_map[i]->b_data;
 			break;
 		}
 	}
 
 	if (st) {
 		for (i = 0; i < le16_to_cpu(st->reallocationTableLen); i++) {
-			if (le32_to_cpu(st->mapEntry[i].origLocation) >=
-			    0xFFFFFFF0)
+			if (le32_to_cpu(st->mapEntry[i].origLocation) >= 0xFFFFFFF0) {
 				break;
-			else if (le32_to_cpu(st->mapEntry[i].origLocation) ==
-				 packet) {
-				return le32_to_cpu(st->mapEntry[i].
-						   mappedLocation) + ((block +
-								       offset) &
-								      (UDF_SB_TYPESPAR
-								       (sb,
-									partition).
-								       s_packet_len
-								       - 1));
-			} else if (le32_to_cpu(st->mapEntry[i].origLocation) >
-				   packet)
+			} else if (le32_to_cpu(st->mapEntry[i].origLocation) == packet) {
+				return le32_to_cpu(st->mapEntry[i].mappedLocation) +
+					((block + offset) & (UDF_SB_TYPESPAR(sb,partition).s_packet_len - 1));
+			} else if (le32_to_cpu(st->mapEntry[i].origLocation) > packet) {
 				break;
+			}
 		}
 	}
-	return UDF_SB_PARTROOT(sb, partition) + block + offset;
+
+	return UDF_SB_PARTROOT(sb,partition) + block + offset;
 }
 
 int udf_relocate_blocks(struct super_block *sb, long old_block, long *new_block)
@@ -153,20 +134,14 @@ int udf_relocate_blocks(struct super_blo
 	int i, j, k, l;
 
 	for (i = 0; i < UDF_SB_NUMPARTS(sb); i++) {
-		if (old_block > UDF_SB_PARTROOT(sb, i) &&
-		    old_block < UDF_SB_PARTROOT(sb, i) + UDF_SB_PARTLEN(sb, i))
-		{
-			sdata = &UDF_SB_TYPESPAR(sb, i);
-			packet =
-			    (old_block -
-			     UDF_SB_PARTROOT(sb,
-					     i)) & ~(sdata->s_packet_len - 1);
+		if (old_block > UDF_SB_PARTROOT(sb,i) &&
+		    old_block < UDF_SB_PARTROOT(sb,i) + UDF_SB_PARTLEN(sb,i)) {
+			sdata = &UDF_SB_TYPESPAR(sb,i);
+			packet = (old_block - UDF_SB_PARTROOT(sb,i)) & ~(sdata->s_packet_len - 1);
 
 			for (j = 0; j < 4; j++) {
-				if (UDF_SB_TYPESPAR(sb, i).s_spar_map[j] !=
-				    NULL) {
-					st = (struct sparingTable *)sdata->
-					    s_spar_map[j]->b_data;
+				if (UDF_SB_TYPESPAR(sb,i).s_spar_map[j] != NULL) {
+					st = (struct sparingTable *)sdata->s_spar_map[j]->b_data;
 					break;
 				}
 			}
@@ -174,122 +149,51 @@ int udf_relocate_blocks(struct super_blo
 			if (!st)
 				return 1;
 
-			for (k = 0; k < le16_to_cpu(st->reallocationTableLen);
-			     k++) {
-				if (le32_to_cpu(st->mapEntry[k].origLocation) ==
-				    0xFFFFFFFF) {
+			for (k = 0; k < le16_to_cpu(st->reallocationTableLen); k++) {
+				if (le32_to_cpu(st->mapEntry[k].origLocation) == 0xFFFFFFFF) {
 					for (; j < 4; j++) {
 						if (sdata->s_spar_map[j]) {
-							st = (struct
-							      sparingTable *)
-							    sdata->
-							    s_spar_map[j]->
-							    b_data;
-							st->mapEntry[k].
-							    origLocation =
-							    cpu_to_le32(packet);
-							udf_update_tag((char *)
-								       st,
-								       sizeof
-								       (struct
-									sparingTable)
-								       +
-								       le16_to_cpu
-								       (st->
-									reallocationTableLen)
-								       *
-								       sizeof
-								       (struct
-									sparingEntry));
-							mark_buffer_dirty
-							    (sdata->
-							     s_spar_map[j]);
+							st = (struct sparingTable *)sdata->s_spar_map[j]->b_data;
+							st->mapEntry[k].origLocation = cpu_to_le32(packet);
+							udf_update_tag((char *)st, sizeof(struct sparingTable) + le16_to_cpu(st->reallocationTableLen) * sizeof(struct sparingEntry));
+							mark_buffer_dirty(sdata->s_spar_map[j]);
 						}
 					}
-					*new_block =
-					    le32_to_cpu(st->mapEntry[k].
-							mappedLocation) +
-					    ((old_block -
-					      UDF_SB_PARTROOT(sb,
-							      i)) & (sdata->
-								     s_packet_len
-								     - 1));
+					*new_block = le32_to_cpu(st->mapEntry[k].mappedLocation) +
+						((old_block - UDF_SB_PARTROOT(sb,i)) & (sdata->s_packet_len - 1));
 					return 0;
-				} else
-				    if (le32_to_cpu
-					(st->mapEntry[k].origLocation) ==
-					packet) {
-					*new_block =
-					    le32_to_cpu(st->mapEntry[k].
-							mappedLocation) +
-					    ((old_block -
-					      UDF_SB_PARTROOT(sb,
-							      i)) & (sdata->
-								     s_packet_len
-								     - 1));
+				} else if (le32_to_cpu(st->mapEntry[k].origLocation) == packet) {
+					*new_block = le32_to_cpu(st->mapEntry[k].mappedLocation) +
+						((old_block - UDF_SB_PARTROOT(sb,i)) & (sdata->s_packet_len - 1));
 					return 0;
-				} else
-				    if (le32_to_cpu
-					(st->mapEntry[k].origLocation) > packet)
+				} else if (le32_to_cpu(st->mapEntry[k].origLocation) > packet) {
 					break;
+				}
 			}
-			for (l = k; l < le16_to_cpu(st->reallocationTableLen);
-			     l++) {
-				if (le32_to_cpu(st->mapEntry[l].origLocation) ==
-				    0xFFFFFFFF) {
+
+			for (l = k; l < le16_to_cpu(st->reallocationTableLen); l++) {
+				if (le32_to_cpu(st->mapEntry[l].origLocation) == 0xFFFFFFFF) {
 					for (; j < 4; j++) {
 						if (sdata->s_spar_map[j]) {
-							st = (struct
-							      sparingTable *)
-							    sdata->
-							    s_spar_map[j]->
-							    b_data;
-							mapEntry =
-							    st->mapEntry[l];
-							mapEntry.origLocation =
-							    cpu_to_le32(packet);
-							memmove(&st->
-								mapEntry[k + 1],
-								&st->
-								mapEntry[k],
-								(l -
-								 k) *
-								sizeof(struct
-								       sparingEntry));
-							st->mapEntry[k] =
-							    mapEntry;
-							udf_update_tag((char *)
-								       st,
-								       sizeof
-								       (struct
-									sparingTable)
-								       +
-								       le16_to_cpu
-								       (st->
-									reallocationTableLen)
-								       *
-								       sizeof
-								       (struct
-									sparingEntry));
-							mark_buffer_dirty
-							    (sdata->
-							     s_spar_map[j]);
+							st = (struct sparingTable *)sdata->s_spar_map[j]->b_data;
+							mapEntry = st->mapEntry[l];
+							mapEntry.origLocation = cpu_to_le32(packet);
+							memmove(&st->mapEntry[k + 1], &st->mapEntry[k], (l - k) * sizeof(struct sparingEntry));
+							st->mapEntry[k] = mapEntry;
+							udf_update_tag((char *)st, sizeof(struct sparingTable) + le16_to_cpu(st->reallocationTableLen) * sizeof(struct sparingEntry));
+							mark_buffer_dirty(sdata->s_spar_map[j]);
 						}
 					}
-					*new_block =
-					    le32_to_cpu(st->mapEntry[k].
-							mappedLocation) +
-					    ((old_block -
-					      UDF_SB_PARTROOT(sb,
-							      i)) & (sdata->
-								     s_packet_len
-								     - 1));
+					*new_block = le32_to_cpu(st->mapEntry[k].mappedLocation) +
+						((old_block - UDF_SB_PARTROOT(sb,i)) & (sdata->s_packet_len - 1));
 					return 0;
 				}
 			}
+
 			return 1;
-		}
+		} /* if old_block */
 	}
+
 	if (i == UDF_SB_NUMPARTS(sb)) {
 		/* outside of partitions */
 		/* for now, fail =) */
diff -puN fs/udf/super.c~udf-coding-style-conversion-lindent-fixups fs/udf/super.c
--- a/fs/udf/super.c~udf-coding-style-conversion-lindent-fixups
+++ a/fs/udf/super.c
@@ -104,11 +104,11 @@ static int udf_get_sb(struct file_system
 }
 
 static struct file_system_type udf_fstype = {
-	.owner = THIS_MODULE,
-	.name = "udf",
-	.get_sb = udf_get_sb,
-	.kill_sb = kill_block_super,
-	.fs_flags = FS_REQUIRES_DEV,
+	.owner		= THIS_MODULE,
+	.name		= "udf",
+	.get_sb		= udf_get_sb,
+	.kill_sb	= kill_block_super,
+	.fs_flags	= FS_REQUIRES_DEV,
 };
 
 static struct kmem_cache *udf_inode_cachep;
@@ -116,8 +116,7 @@ static struct kmem_cache *udf_inode_cach
 static struct inode *udf_alloc_inode(struct super_block *sb)
 {
 	struct udf_inode_info *ei;
-	ei = (struct udf_inode_info *)kmem_cache_alloc(udf_inode_cachep,
-						       GFP_KERNEL);
+	ei = (struct udf_inode_info *)kmem_cache_alloc(udf_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 
@@ -147,11 +146,11 @@ static int init_inodecache(void)
 {
 	udf_inode_cachep = kmem_cache_create("udf_inode_cache",
 					     sizeof(struct udf_inode_info),
-					     0, (SLAB_RECLAIM_ACCOUNT |
-						 SLAB_MEM_SPREAD),
+					     0, (SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD),
 					     init_once, NULL);
-	if (udf_inode_cachep == NULL)
+	if (!udf_inode_cachep)
 		return -ENOMEM;
+
 	return 0;
 }
 
@@ -162,15 +161,15 @@ static void destroy_inodecache(void)
 
 /* Superblock operations */
 static const struct super_operations udf_sb_ops = {
-	.alloc_inode = udf_alloc_inode,
-	.destroy_inode = udf_destroy_inode,
-	.write_inode = udf_write_inode,
-	.delete_inode = udf_delete_inode,
-	.clear_inode = udf_clear_inode,
-	.put_super = udf_put_super,
-	.write_super = udf_write_super,
-	.statfs = udf_statfs,
-	.remount_fs = udf_remount_fs,
+	.alloc_inode	= udf_alloc_inode,
+	.destroy_inode	= udf_destroy_inode,
+	.write_inode	= udf_write_inode,
+	.delete_inode	= udf_delete_inode,
+	.clear_inode	= udf_clear_inode,
+	.put_super	= udf_put_super,
+	.write_super	= udf_write_super,
+	.statfs		= udf_statfs,
+	.remount_fs	= udf_remount_fs,
 };
 
 struct udf_options {
@@ -193,16 +192,20 @@ struct udf_options {
 static int __init init_udf_fs(void)
 {
 	int err;
+
 	err = init_inodecache();
 	if (err)
 		goto out1;
 	err = register_filesystem(&udf_fstype);
 	if (err)
 		goto out;
+
 	return 0;
-      out:
+
+out:
 	destroy_inodecache();
-      out1:
+
+out1:
 	return err;
 }
 
@@ -213,7 +216,7 @@ static void __exit exit_udf_fs(void)
 }
 
 module_init(init_udf_fs)
-    module_exit(exit_udf_fs)
+module_exit(exit_udf_fs)
 
 /*
  * udf_parse_options
@@ -239,7 +242,7 @@ module_init(init_udf_fs)
  *
  *	The remaining are for debugging and disaster recovery:
  *
- *	novrs		Skip volume sequence recognition 
+ *	novrs		Skip volume sequence recognition
  *
  *	The following expect a offset from 0.
  *
@@ -268,6 +271,7 @@ module_init(init_udf_fs)
  *	July 1, 1997 - Andrew E. Mileski
  *	Written, tested, and released.
  */
+
 enum {
 	Opt_novrs, Opt_nostrict, Opt_bs, Opt_unhide, Opt_undelete,
 	Opt_noadinicb, Opt_adinicb, Opt_shortad, Opt_longad,
@@ -278,32 +282,32 @@ enum {
 };
 
 static match_table_t tokens = {
-	{Opt_novrs, "novrs"},
-	{Opt_nostrict, "nostrict"},
-	{Opt_bs, "bs=%u"},
-	{Opt_unhide, "unhide"},
-	{Opt_undelete, "undelete"},
-	{Opt_noadinicb, "noadinicb"},
-	{Opt_adinicb, "adinicb"},
-	{Opt_shortad, "shortad"},
-	{Opt_longad, "longad"},
-	{Opt_uforget, "uid=forget"},
-	{Opt_uignore, "uid=ignore"},
-	{Opt_gforget, "gid=forget"},
-	{Opt_gignore, "gid=ignore"},
-	{Opt_gid, "gid=%u"},
-	{Opt_uid, "uid=%u"},
-	{Opt_umask, "umask=%o"},
-	{Opt_session, "session=%u"},
-	{Opt_lastblock, "lastblock=%u"},
-	{Opt_anchor, "anchor=%u"},
-	{Opt_volume, "volume=%u"},
-	{Opt_partition, "partition=%u"},
-	{Opt_fileset, "fileset=%u"},
-	{Opt_rootdir, "rootdir=%u"},
-	{Opt_utf8, "utf8"},
-	{Opt_iocharset, "iocharset=%s"},
-	{Opt_err, NULL}
+	{Opt_novrs,	"novrs"},
+	{Opt_nostrict,	"nostrict"},
+	{Opt_bs,	"bs=%u"},
+	{Opt_unhide,	"unhide"},
+	{Opt_undelete,	"undelete"},
+	{Opt_noadinicb,	"noadinicb"},
+	{Opt_adinicb,	"adinicb"},
+	{Opt_shortad,	"shortad"},
+	{Opt_longad,	"longad"},
+	{Opt_uforget,	"uid=forget"},
+	{Opt_uignore,	"uid=ignore"},
+	{Opt_gforget,	"gid=forget"},
+	{Opt_gignore,	"gid=ignore"},
+	{Opt_gid,	"gid=%u"},
+	{Opt_uid,	"uid=%u"},
+	{Opt_umask,	"umask=%o"},
+	{Opt_session,	"session=%u"},
+	{Opt_lastblock,	"lastblock=%u"},
+	{Opt_anchor,	"anchor=%u"},
+	{Opt_volume,	"volume=%u"},
+	{Opt_partition,	"partition=%u"},
+	{Opt_fileset,	"fileset=%u"},
+	{Opt_rootdir,	"rootdir=%u"},
+	{Opt_utf8,	"utf8"},
+	{Opt_iocharset,	"iocharset=%s"},
+	{Opt_err,	NULL}
 };
 
 static int udf_parse_options(char *options, struct udf_options *uopt)
@@ -444,9 +448,11 @@ static int udf_parse_options(char *optio
 void udf_write_super(struct super_block *sb)
 {
 	lock_kernel();
+
 	if (!(sb->s_flags & MS_RDONLY))
 		udf_open_lvid(sb);
 	sb->s_dirt = 0;
+
 	unlock_kernel();
 }
 
@@ -455,16 +461,16 @@ static int udf_remount_fs(struct super_b
 	struct udf_options uopt;
 
 	uopt.flags = UDF_SB(sb)->s_flags;
-	uopt.uid = UDF_SB(sb)->s_uid;
-	uopt.gid = UDF_SB(sb)->s_gid;
+	uopt.uid   = UDF_SB(sb)->s_uid;
+	uopt.gid   = UDF_SB(sb)->s_gid;
 	uopt.umask = UDF_SB(sb)->s_umask;
 
 	if (!udf_parse_options(options, &uopt))
 		return -EINVAL;
 
 	UDF_SB(sb)->s_flags = uopt.flags;
-	UDF_SB(sb)->s_uid = uopt.uid;
-	UDF_SB(sb)->s_gid = uopt.gid;
+	UDF_SB(sb)->s_uid   = uopt.uid;
+	UDF_SB(sb)->s_gid   = uopt.gid;
 	UDF_SB(sb)->s_umask = uopt.umask;
 
 	if (UDF_SB_LVIDBH(sb)) {
@@ -517,6 +523,7 @@ static int udf_set_blocksize(struct supe
 		printk(KERN_ERR "udf: bad block size (%d)\n", bsize);
 		return 0;
 	}
+
 	return sb->s_blocksize;
 }
 
@@ -552,15 +559,12 @@ static int udf_vrs(struct super_block *s
 
 		/* Look for ISO  descriptors */
 		vsd = (struct volStructDesc *)(bh->b_data +
-					       (sector &
-						(sb->s_blocksize - 1)));
+					       (sector & (sb->s_blocksize - 1)));
 
 		if (vsd->stdIdent[0] == 0) {
 			brelse(bh);
 			break;
-		} else
-		    if (!strncmp
-			(vsd->stdIdent, VSD_STD_ID_CD001, VSD_STD_ID_LEN)) {
+		} else if (!strncmp(vsd->stdIdent, VSD_STD_ID_CD001, VSD_STD_ID_LEN)) {
 			iso9660 = sector;
 			switch (vsd->structType) {
 			case 0:
@@ -587,21 +591,13 @@ static int udf_vrs(struct super_block *s
 					  vsd->structType);
 				break;
 			}
-		} else
-		    if (!strncmp
-			(vsd->stdIdent, VSD_STD_ID_BEA01, VSD_STD_ID_LEN)) {
-		} else
-		    if (!strncmp
-			(vsd->stdIdent, VSD_STD_ID_TEA01, VSD_STD_ID_LEN)) {
+		} else if (!strncmp(vsd->stdIdent, VSD_STD_ID_BEA01, VSD_STD_ID_LEN)) {
+		} else if (!strncmp(vsd->stdIdent, VSD_STD_ID_TEA01, VSD_STD_ID_LEN)) {
 			brelse(bh);
 			break;
-		} else
-		    if (!strncmp
-			(vsd->stdIdent, VSD_STD_ID_NSR02, VSD_STD_ID_LEN)) {
+		} else if (!strncmp(vsd->stdIdent, VSD_STD_ID_NSR02, VSD_STD_ID_LEN)) {
 			nsr02 = sector;
-		} else
-		    if (!strncmp
-			(vsd->stdIdent, VSD_STD_ID_NSR03, VSD_STD_ID_LEN)) {
+		} else if (!strncmp(vsd->stdIdent, VSD_STD_ID_NSR03, VSD_STD_ID_LEN)) {
 			nsr03 = sector;
 		}
 		brelse(bh);
@@ -644,11 +640,10 @@ static void udf_find_anchor(struct super
 
 	if (lastblock) {
 		int varlastblock = udf_variable_to_fixed(lastblock);
-		int last[] = { lastblock, lastblock - 2,
-			lastblock - 150, lastblock - 152,
-			varlastblock, varlastblock - 2,
-			varlastblock - 150, varlastblock - 152
-		};
+		int last[] =  { lastblock, lastblock - 2,
+				lastblock - 150, lastblock - 152,
+				varlastblock, varlastblock - 2,
+				varlastblock - 150, varlastblock - 152 };
 
 		lastblock = 0;
 
@@ -664,88 +659,54 @@ static void udf_find_anchor(struct super
 			if (last[i] < 0 || !(bh = sb_bread(sb, last[i]))) {
 				ident = location = 0;
 			} else {
-				ident =
-				    le16_to_cpu(((tag *) bh->b_data)->tagIdent);
-				location =
-				    le32_to_cpu(((tag *) bh->b_data)->
-						tagLocation);
+				ident = le16_to_cpu(((tag *)bh->b_data)->tagIdent);
+				location = le32_to_cpu(((tag *)bh->b_data)->tagLocation);
 				brelse(bh);
 			}
 
 			if (ident == TAG_IDENT_AVDP) {
 				if (location == last[i] - UDF_SB_SESSION(sb)) {
-					lastblock = UDF_SB_ANCHOR(sb)[0] =
-					    last[i] - UDF_SB_SESSION(sb);
-					UDF_SB_ANCHOR(sb)[1] =
-					    last[i] - 256 - UDF_SB_SESSION(sb);
-				} else if (location ==
-					   udf_variable_to_fixed(last[i]) -
-					   UDF_SB_SESSION(sb)) {
+					lastblock = UDF_SB_ANCHOR(sb)[0] = last[i] - UDF_SB_SESSION(sb);
+					UDF_SB_ANCHOR(sb)[1] = last[i] - 256 - UDF_SB_SESSION(sb);
+				} else if (location == udf_variable_to_fixed(last[i]) - UDF_SB_SESSION(sb)) {
 					UDF_SET_FLAG(sb, UDF_FLAG_VARCONV);
-					lastblock = UDF_SB_ANCHOR(sb)[0] =
-					    udf_variable_to_fixed(last[i]) -
-					    UDF_SB_SESSION(sb);
-					UDF_SB_ANCHOR(sb)[1] =
-					    lastblock - 256 -
-					    UDF_SB_SESSION(sb);
-				} else
-					udf_debug
-					    ("Anchor found at block %d, location mismatch %d.\n",
-					     last[i], location);
-			} else if (ident == TAG_IDENT_FE
-				   || ident == TAG_IDENT_EFE) {
+					lastblock = UDF_SB_ANCHOR(sb)[0] = udf_variable_to_fixed(last[i]) - UDF_SB_SESSION(sb);
+					UDF_SB_ANCHOR(sb)[1] = lastblock - 256 - UDF_SB_SESSION(sb);
+				} else {
+					udf_debug("Anchor found at block %d, location mismatch %d.\n",
+						  last[i], location);
+				}
+			} else if (ident == TAG_IDENT_FE || ident == TAG_IDENT_EFE) {
 				lastblock = last[i];
 				UDF_SB_ANCHOR(sb)[3] = 512;
 			} else {
-				if (last[i] < 256
-				    || !(bh = sb_bread(sb, last[i] - 256))) {
+				if (last[i] < 256 || !(bh = sb_bread(sb, last[i] - 256))) {
 					ident = location = 0;
 				} else {
-					ident =
-					    le16_to_cpu(((tag *) bh->b_data)->
-							tagIdent);
-					location =
-					    le32_to_cpu(((tag *) bh->b_data)->
-							tagLocation);
+					ident = le16_to_cpu(((tag *)bh->b_data)->tagIdent);
+					location = le32_to_cpu(((tag *)bh->b_data)->tagLocation);
 					brelse(bh);
 				}
 
 				if (ident == TAG_IDENT_AVDP &&
-				    location ==
-				    last[i] - 256 - UDF_SB_SESSION(sb)) {
+				    location == last[i] - 256 - UDF_SB_SESSION(sb)) {
 					lastblock = last[i];
 					UDF_SB_ANCHOR(sb)[1] = last[i] - 256;
 				} else {
-					if (last[i] < 312 + UDF_SB_SESSION(sb)
-					    || !(bh =
-						 sb_bread(sb,
-							  last[i] - 312 -
-							  UDF_SB_SESSION(sb))))
-					{
+					if (last[i] < 312 + UDF_SB_SESSION(sb) ||
+					    !(bh = sb_bread(sb, last[i] - 312 - UDF_SB_SESSION(sb)))) {
 						ident = location = 0;
 					} else {
-						ident =
-						    le16_to_cpu(((tag *) bh->
-								 b_data)->
-								tagIdent);
-						location =
-						    le32_to_cpu(((tag *) bh->
-								 b_data)->
-								tagLocation);
+						ident = le16_to_cpu(((tag *)bh->b_data)->tagIdent);
+						location = le32_to_cpu(((tag *)bh->b_data)->tagLocation);
 						brelse(bh);
 					}
 
 					if (ident == TAG_IDENT_AVDP &&
-					    location ==
-					    udf_variable_to_fixed(last[i]) -
-					    256) {
-						UDF_SET_FLAG(sb,
-							     UDF_FLAG_VARCONV);
-						lastblock =
-						    udf_variable_to_fixed(last
-									  [i]);
-						UDF_SB_ANCHOR(sb)[1] =
-						    lastblock - 256;
+					    location == udf_variable_to_fixed(last[i]) - 256) {
+						UDF_SET_FLAG(sb, UDF_FLAG_VARCONV);
+						lastblock = udf_variable_to_fixed(last[i]);
+						UDF_SB_ANCHOR(sb)[1] = lastblock - 256;
 					}
 				}
 			}
@@ -755,9 +716,8 @@ static void udf_find_anchor(struct super
 	if (!lastblock) {
 		/* We havn't found the lastblock. check 312 */
 		if ((bh = sb_bread(sb, 312 + UDF_SB_SESSION(sb)))) {
-			ident = le16_to_cpu(((tag *) bh->b_data)->tagIdent);
-			location =
-			    le32_to_cpu(((tag *) bh->b_data)->tagLocation);
+			ident = le16_to_cpu(((tag *)bh->b_data)->tagIdent);
+			location = le32_to_cpu(((tag *)bh->b_data)->tagLocation);
 			brelse(bh);
 
 			if (ident == TAG_IDENT_AVDP && location == 256)
@@ -767,19 +727,13 @@ static void udf_find_anchor(struct super
 
 	for (i = 0; i < ARRAY_SIZE(UDF_SB_ANCHOR(sb)); i++) {
 		if (UDF_SB_ANCHOR(sb)[i]) {
-			if (!(bh = udf_read_tagged(sb,
-						   UDF_SB_ANCHOR(sb)[i],
-						   UDF_SB_ANCHOR(sb)[i],
-						   &ident))) {
+			if (!(bh = udf_read_tagged(sb, UDF_SB_ANCHOR(sb)[i],
+						   UDF_SB_ANCHOR(sb)[i], &ident))) {
 				UDF_SB_ANCHOR(sb)[i] = 0;
 			} else {
 				brelse(bh);
-				if ((ident != TAG_IDENT_AVDP) && (i ||
-								  (ident !=
-								   TAG_IDENT_FE
-								   && ident !=
-								   TAG_IDENT_EFE)))
-				{
+				if ((ident != TAG_IDENT_AVDP) &&
+				    (i || (ident != TAG_IDENT_FE && ident != TAG_IDENT_EFE))) {
 					UDF_SB_ANCHOR(sb)[i] = 0;
 				}
 			}
@@ -789,9 +743,7 @@ static void udf_find_anchor(struct super
 	UDF_SB_LASTBLOCK(sb) = lastblock;
 }
 
-static int
-udf_find_fileset(struct super_block *sb, kernel_lb_addr * fileset,
-		 kernel_lb_addr * root)
+static int udf_find_fileset(struct super_block *sb, kernel_lb_addr *fileset, kernel_lb_addr *root)
 {
 	struct buffer_head *bh = NULL;
 	long lastblock;
@@ -801,18 +753,19 @@ udf_find_fileset(struct super_block *sb,
 	    fileset->partitionReferenceNum != 0xFFFF) {
 		bh = udf_read_ptagged(sb, *fileset, 0, &ident);
 
-		if (!bh)
+		if (!bh) {
 			return 1;
-		else if (ident != TAG_IDENT_FSD) {
+		} else if (ident != TAG_IDENT_FSD) {
 			brelse(bh);
 			return 1;
 		}
 
 	}
 
-	if (!bh) {		/* Search backwards through the partitions */
+	if (!bh) { /* Search backwards through the partitions */
 		kernel_lb_addr newfileset;
 
+/* --> cvg: FIXME - is it reasonable? */
 		return 1;
 
 		for (newfileset.partitionReferenceNum = UDF_SB_NUMPARTS(sb) - 1;
@@ -820,14 +773,11 @@ udf_find_fileset(struct super_block *sb,
 		      fileset->logicalBlockNum == 0xFFFFFFFF &&
 		      fileset->partitionReferenceNum == 0xFFFF);
 		     newfileset.partitionReferenceNum--) {
-			lastblock =
-			    UDF_SB_PARTLEN(sb,
-					   newfileset.partitionReferenceNum);
+			lastblock = UDF_SB_PARTLEN(sb, newfileset.partitionReferenceNum);
 			newfileset.logicalBlockNum = 0;
 
 			do {
-				bh = udf_read_ptagged(sb, newfileset, 0,
-						      &ident);
+				bh = udf_read_ptagged(sb, newfileset, 0, &ident);
 				if (!bh) {
 					newfileset.logicalBlockNum++;
 					continue;
@@ -835,38 +785,28 @@ udf_find_fileset(struct super_block *sb,
 
 				switch (ident) {
 				case TAG_IDENT_SBD:
-					{
-						struct spaceBitmapDesc *sp;
-						sp = (struct spaceBitmapDesc *)
-						    bh->b_data;
-						newfileset.logicalBlockNum +=
-						    1 +
-						    ((le32_to_cpu
-						      (sp->numOfBytes) +
-						      sizeof(struct
-							     spaceBitmapDesc) -
-						      1)
-						     >> sb->s_blocksize_bits);
-						brelse(bh);
-						break;
-					}
+				{
+					struct spaceBitmapDesc *sp;
+					sp = (struct spaceBitmapDesc *)bh->b_data;
+					newfileset.logicalBlockNum += 1 +
+						((le32_to_cpu(sp->numOfBytes) +
+						  sizeof(struct spaceBitmapDesc) - 1)
+						 >> sb->s_blocksize_bits);
+					brelse(bh);
+					break;
+				}
 				case TAG_IDENT_FSD:
-					{
-						*fileset = newfileset;
-						break;
-					}
+					*fileset = newfileset;
+					break;
 				default:
-					{
-						newfileset.logicalBlockNum++;
-						brelse(bh);
-						bh = NULL;
-						break;
-					}
+					newfileset.logicalBlockNum++;
+					brelse(bh);
+					bh = NULL;
+					break;
 				}
-			}
-			while (newfileset.logicalBlockNum < lastblock &&
-			       fileset->logicalBlockNum == 0xFFFFFFFF &&
-			       fileset->partitionReferenceNum == 0xFFFF);
+			} while (newfileset.logicalBlockNum < lastblock &&
+				 fileset->logicalBlockNum == 0xFFFFFFFF &&
+				 fileset->partitionReferenceNum == 0xFFFF);
 		}
 	}
 
@@ -898,10 +838,10 @@ static void udf_load_pvoldesc(struct sup
 			      lets_to_cpu(pvoldesc->recordingDateAndTime))) {
 		kernel_timestamp ts;
 		ts = lets_to_cpu(pvoldesc->recordingDateAndTime);
-		udf_debug
-		    ("recording time %ld/%ld, %04u/%02u/%02u %02u:%02u (%x)\n",
-		     recording, recording_usec, ts.year, ts.month, ts.day,
-		     ts.hour, ts.minute, ts.typeAndTimezone);
+		udf_debug("recording time %ld/%ld, %04u/%02u/%02u %02u:%02u (%x)\n",
+			  recording, recording_usec,
+			  ts.year, ts.month, ts.day, ts.hour,
+			  ts.minute, ts.typeAndTimezone);
 		UDF_SB_RECORDTIME(sb).tv_sec = recording;
 		UDF_SB_RECORDTIME(sb).tv_nsec = recording_usec * 1000;
 	}
@@ -920,9 +860,8 @@ static void udf_load_pvoldesc(struct sup
 	}
 }
 
-static void
-udf_load_fileset(struct super_block *sb, struct buffer_head *bh,
-		 kernel_lb_addr * root)
+static void udf_load_fileset(struct super_block *sb, struct buffer_head *bh,
+			     kernel_lb_addr *root)
 {
 	struct fileSetDesc *fset;
 
@@ -945,121 +884,72 @@ static void udf_load_partdesc(struct sup
 
 	for (i = 0; i < UDF_SB_NUMPARTS(sb); i++) {
 		udf_debug("Searching map: (%d == %d)\n",
-			  UDF_SB_PARTMAPS(sb)[i].s_partition_num,
-			  le16_to_cpu(p->partitionNumber));
-		if (UDF_SB_PARTMAPS(sb)[i].s_partition_num ==
-		    le16_to_cpu(p->partitionNumber)) {
-			UDF_SB_PARTLEN(sb, i) = le32_to_cpu(p->partitionLength);	/* blocks */
-			UDF_SB_PARTROOT(sb, i) =
-			    le32_to_cpu(p->partitionStartingLocation);
-			if (le32_to_cpu(p->accessType) ==
-			    PD_ACCESS_TYPE_READ_ONLY)
-				UDF_SB_PARTFLAGS(sb, i) |=
-				    UDF_PART_FLAG_READ_ONLY;
-			if (le32_to_cpu(p->accessType) ==
-			    PD_ACCESS_TYPE_WRITE_ONCE)
-				UDF_SB_PARTFLAGS(sb, i) |=
-				    UDF_PART_FLAG_WRITE_ONCE;
-			if (le32_to_cpu(p->accessType) ==
-			    PD_ACCESS_TYPE_REWRITABLE)
-				UDF_SB_PARTFLAGS(sb, i) |=
-				    UDF_PART_FLAG_REWRITABLE;
-			if (le32_to_cpu(p->accessType) ==
-			    PD_ACCESS_TYPE_OVERWRITABLE)
-				UDF_SB_PARTFLAGS(sb, i) |=
-				    UDF_PART_FLAG_OVERWRITABLE;
-
-			if (!strcmp
-			    (p->partitionContents.ident,
-			     PD_PARTITION_CONTENTS_NSR02)
-			    || !strcmp(p->partitionContents.ident,
-				       PD_PARTITION_CONTENTS_NSR03)) {
+			  UDF_SB_PARTMAPS(sb)[i].s_partition_num, le16_to_cpu(p->partitionNumber));
+		if (UDF_SB_PARTMAPS(sb)[i].s_partition_num == le16_to_cpu(p->partitionNumber)) {
+			UDF_SB_PARTLEN(sb,i) = le32_to_cpu(p->partitionLength); /* blocks */
+			UDF_SB_PARTROOT(sb,i) = le32_to_cpu(p->partitionStartingLocation);
+			if (le32_to_cpu(p->accessType) == PD_ACCESS_TYPE_READ_ONLY)
+				UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_READ_ONLY;
+			if (le32_to_cpu(p->accessType) == PD_ACCESS_TYPE_WRITE_ONCE)
+				UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_WRITE_ONCE;
+			if (le32_to_cpu(p->accessType) == PD_ACCESS_TYPE_REWRITABLE)
+				UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_REWRITABLE;
+			if (le32_to_cpu(p->accessType) == PD_ACCESS_TYPE_OVERWRITABLE)
+				UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_OVERWRITABLE;
+
+			if (!strcmp(p->partitionContents.ident, PD_PARTITION_CONTENTS_NSR02) ||
+			    !strcmp(p->partitionContents.ident, PD_PARTITION_CONTENTS_NSR03)) {
 				struct partitionHeaderDesc *phd;
 
-				phd =
-				    (struct partitionHeaderDesc *)(p->
-								   partitionContentsUse);
+				phd = (struct partitionHeaderDesc *)(p->partitionContentsUse);
 				if (phd->unallocSpaceTable.extLength) {
-					kernel_lb_addr loc =
-					    { le32_to_cpu(phd->
-							  unallocSpaceTable.
-							  extPosition), i };
-
-					UDF_SB_PARTMAPS(sb)[i].s_uspace.
-					    s_table = udf_iget(sb, loc);
-					UDF_SB_PARTFLAGS(sb, i) |=
-					    UDF_PART_FLAG_UNALLOC_TABLE;
-					udf_debug
-					    ("unallocSpaceTable (part %d) @ %ld\n",
-					     i,
-					     UDF_SB_PARTMAPS(sb)[i].s_uspace.
-					     s_table->i_ino);
+					kernel_lb_addr loc = {
+						.logicalBlockNum = le32_to_cpu(phd->unallocSpaceTable.extPosition),
+						.partitionReferenceNum = i,
+					};
+
+					UDF_SB_PARTMAPS(sb)[i].s_uspace.s_table =
+						udf_iget(sb, loc);
+					UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_UNALLOC_TABLE;
+					udf_debug("unallocSpaceTable (part %d) @ %ld\n",
+						  i, UDF_SB_PARTMAPS(sb)[i].s_uspace.s_table->i_ino);
 				}
 				if (phd->unallocSpaceBitmap.extLength) {
 					UDF_SB_ALLOC_BITMAP(sb, i, s_uspace);
-					if (UDF_SB_PARTMAPS(sb)[i].s_uspace.
-					    s_bitmap != NULL) {
-						UDF_SB_PARTMAPS(sb)[i].s_uspace.
-						    s_bitmap->s_extLength =
-						    le32_to_cpu(phd->
-								unallocSpaceBitmap.
-								extLength);
-						UDF_SB_PARTMAPS(sb)[i].s_uspace.
-						    s_bitmap->s_extPosition =
-						    le32_to_cpu(phd->
-								unallocSpaceBitmap.
-								extPosition);
-						UDF_SB_PARTFLAGS(sb, i) |=
-						    UDF_PART_FLAG_UNALLOC_BITMAP;
-						udf_debug
-						    ("unallocSpaceBitmap (part %d) @ %d\n",
-						     i,
-						     UDF_SB_PARTMAPS(sb)[i].
-						     s_uspace.s_bitmap->
-						     s_extPosition);
+					if (UDF_SB_PARTMAPS(sb)[i].s_uspace.s_bitmap != NULL) {
+						UDF_SB_PARTMAPS(sb)[i].s_uspace.s_bitmap->s_extLength =
+							le32_to_cpu(phd->unallocSpaceBitmap.extLength);
+						UDF_SB_PARTMAPS(sb)[i].s_uspace.s_bitmap->s_extPosition =
+							le32_to_cpu(phd->unallocSpaceBitmap.extPosition);
+						UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_UNALLOC_BITMAP;
+						udf_debug("unallocSpaceBitmap (part %d) @ %d\n",
+							  i, UDF_SB_PARTMAPS(sb)[i].s_uspace.s_bitmap->s_extPosition);
 					}
 				}
 				if (phd->partitionIntegrityTable.extLength)
-					udf_debug
-					    ("partitionIntegrityTable (part %d)\n",
-					     i);
+					udf_debug("partitionIntegrityTable (part %d)\n", i);
 				if (phd->freedSpaceTable.extLength) {
-					kernel_lb_addr loc =
-					    { le32_to_cpu(phd->freedSpaceTable.
-							  extPosition), i };
-
-					UDF_SB_PARTMAPS(sb)[i].s_fspace.
-					    s_table = udf_iget(sb, loc);
-					UDF_SB_PARTFLAGS(sb, i) |=
-					    UDF_PART_FLAG_FREED_TABLE;
-					udf_debug
-					    ("freedSpaceTable (part %d) @ %ld\n",
-					     i,
-					     UDF_SB_PARTMAPS(sb)[i].s_fspace.
-					     s_table->i_ino);
+					kernel_lb_addr loc = {
+						.logicalBlockNum = le32_to_cpu(phd->freedSpaceTable.extPosition),
+						.partitionReferenceNum = i,
+					};
+
+					UDF_SB_PARTMAPS(sb)[i].s_fspace.s_table =
+						udf_iget(sb, loc);
+					UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_FREED_TABLE;
+					udf_debug("freedSpaceTable (part %d) @ %ld\n",
+						  i, UDF_SB_PARTMAPS(sb)[i].s_fspace.s_table->i_ino);
 				}
 				if (phd->freedSpaceBitmap.extLength) {
 					UDF_SB_ALLOC_BITMAP(sb, i, s_fspace);
-					if (UDF_SB_PARTMAPS(sb)[i].s_fspace.
-					    s_bitmap != NULL) {
-						UDF_SB_PARTMAPS(sb)[i].s_fspace.
-						    s_bitmap->s_extLength =
-						    le32_to_cpu(phd->
-								freedSpaceBitmap.
-								extLength);
-						UDF_SB_PARTMAPS(sb)[i].s_fspace.
-						    s_bitmap->s_extPosition =
-						    le32_to_cpu(phd->
-								freedSpaceBitmap.
-								extPosition);
-						UDF_SB_PARTFLAGS(sb, i) |=
-						    UDF_PART_FLAG_FREED_BITMAP;
-						udf_debug
-						    ("freedSpaceBitmap (part %d) @ %d\n",
-						     i,
-						     UDF_SB_PARTMAPS(sb)[i].
-						     s_fspace.s_bitmap->
-						     s_extPosition);
+					if (UDF_SB_PARTMAPS(sb)[i].s_fspace.s_bitmap != NULL) {
+						UDF_SB_PARTMAPS(sb)[i].s_fspace.s_bitmap->s_extLength =
+							le32_to_cpu(phd->freedSpaceBitmap.extLength);
+						UDF_SB_PARTMAPS(sb)[i].s_fspace.s_bitmap->s_extPosition =
+							le32_to_cpu(phd->freedSpaceBitmap.extPosition);
+						UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_FREED_BITMAP;
+						udf_debug("freedSpaceBitmap (part %d) @ %d\n",
+							  i, UDF_SB_PARTMAPS(sb)[i].s_fspace.s_bitmap->s_extPosition);
 					}
 				}
 			}
@@ -1070,16 +960,14 @@ static void udf_load_partdesc(struct sup
 		udf_debug("Partition (%d) not found in partition map\n",
 			  le16_to_cpu(p->partitionNumber));
 	} else {
-		udf_debug
-		    ("Partition (%d:%d type %x) starts at physical %d, block length %d\n",
-		     le16_to_cpu(p->partitionNumber), i, UDF_SB_PARTTYPE(sb, i),
-		     UDF_SB_PARTROOT(sb, i), UDF_SB_PARTLEN(sb, i));
+		udf_debug("Partition (%d:%d type %x) starts at physical %d, block length %d\n",
+			  le16_to_cpu(p->partitionNumber), i, UDF_SB_PARTTYPE(sb,i),
+			  UDF_SB_PARTROOT(sb,i), UDF_SB_PARTLEN(sb,i));
 	}
 }
 
-static int
-udf_load_logicalvol(struct super_block *sb, struct buffer_head *bh,
-		    kernel_lb_addr * fileset)
+static int udf_load_logicalvol(struct super_block *sb, struct buffer_head *bh,
+			       kernel_lb_addr *fileset)
 {
 	struct logicalVolDesc *lvd;
 	int i, j, offset;
@@ -1090,116 +978,69 @@ udf_load_logicalvol(struct super_block *
 	UDF_SB_ALLOC_PARTMAPS(sb, le32_to_cpu(lvd->numPartitionMaps));
 
 	for (i = 0, offset = 0;
-	     i < UDF_SB_NUMPARTS(sb)
-	     && offset < le32_to_cpu(lvd->mapTableLength);
-	     i++, offset +=
-	     ((struct genericPartitionMap *)&(lvd->partitionMaps[offset]))->
-	     partitionMapLength) {
-		type =
-		    ((struct genericPartitionMap *)
-		     &(lvd->partitionMaps[offset]))->partitionMapType;
+	     i < UDF_SB_NUMPARTS(sb) && offset < le32_to_cpu(lvd->mapTableLength);
+	     i++, offset += ((struct genericPartitionMap *)&(lvd->partitionMaps[offset]))->partitionMapLength) {
+		type = ((struct genericPartitionMap *)&(lvd->partitionMaps[offset]))->partitionMapType;
 		if (type == 1) {
-			struct genericPartitionMap1 *gpm1 =
-			    (struct genericPartitionMap1 *)&(lvd->
-							     partitionMaps
-							     [offset]);
-			UDF_SB_PARTTYPE(sb, i) = UDF_TYPE1_MAP15;
-			UDF_SB_PARTVSN(sb, i) = le16_to_cpu(gpm1->volSeqNum);
-			UDF_SB_PARTNUM(sb, i) = le16_to_cpu(gpm1->partitionNum);
-			UDF_SB_PARTFUNC(sb, i) = NULL;
+			struct genericPartitionMap1 *gpm1 = (struct genericPartitionMap1 *)&(lvd->partitionMaps[offset]);
+			UDF_SB_PARTTYPE(sb,i) = UDF_TYPE1_MAP15;
+			UDF_SB_PARTVSN(sb,i) = le16_to_cpu(gpm1->volSeqNum);
+			UDF_SB_PARTNUM(sb,i) = le16_to_cpu(gpm1->partitionNum);
+			UDF_SB_PARTFUNC(sb,i) = NULL;
 		} else if (type == 2) {
-			struct udfPartitionMap2 *upm2 =
-			    (struct udfPartitionMap2 *)&(lvd->
-							 partitionMaps[offset]);
-			if (!strncmp
-			    (upm2->partIdent.ident, UDF_ID_VIRTUAL,
-			     strlen(UDF_ID_VIRTUAL))) {
-				if (le16_to_cpu
-				    (((__le16 *) upm2->partIdent.
-				      identSuffix)[0]) == 0x0150) {
-					UDF_SB_PARTTYPE(sb, i) =
-					    UDF_VIRTUAL_MAP15;
-					UDF_SB_PARTFUNC(sb, i) =
-					    udf_get_pblock_virt15;
-				} else
-				    if (le16_to_cpu
-					(((__le16 *) upm2->partIdent.
-					  identSuffix)[0]) == 0x0200) {
-					UDF_SB_PARTTYPE(sb, i) =
-					    UDF_VIRTUAL_MAP20;
-					UDF_SB_PARTFUNC(sb, i) =
-					    udf_get_pblock_virt20;
+			struct udfPartitionMap2 *upm2 = (struct udfPartitionMap2 *)&(lvd->partitionMaps[offset]);
+			if (!strncmp(upm2->partIdent.ident, UDF_ID_VIRTUAL, strlen(UDF_ID_VIRTUAL))) {
+				if (le16_to_cpu(((__le16 *)upm2->partIdent.identSuffix)[0]) == 0x0150) {
+					UDF_SB_PARTTYPE(sb,i) = UDF_VIRTUAL_MAP15;
+					UDF_SB_PARTFUNC(sb,i) = udf_get_pblock_virt15;
+				} else if (le16_to_cpu(((__le16 *)upm2->partIdent.identSuffix)[0]) == 0x0200) {
+					UDF_SB_PARTTYPE(sb,i) = UDF_VIRTUAL_MAP20;
+					UDF_SB_PARTFUNC(sb,i) = udf_get_pblock_virt20;
 				}
-			} else
-			    if (!strncmp
-				(upm2->partIdent.ident, UDF_ID_SPARABLE,
-				 strlen(UDF_ID_SPARABLE))) {
+			} else if (!strncmp(upm2->partIdent.ident, UDF_ID_SPARABLE, strlen(UDF_ID_SPARABLE))) {
 				uint32_t loc;
 				uint16_t ident;
 				struct sparingTable *st;
-				struct sparablePartitionMap *spm =
-				    (struct sparablePartitionMap *)&(lvd->
-								     partitionMaps
-								     [offset]);
-
-				UDF_SB_PARTTYPE(sb, i) = UDF_SPARABLE_MAP15;
-				UDF_SB_TYPESPAR(sb, i).s_packet_len =
-				    le16_to_cpu(spm->packetLength);
+				struct sparablePartitionMap *spm = (struct sparablePartitionMap *)&(lvd->partitionMaps[offset]);
+
+				UDF_SB_PARTTYPE(sb,i) = UDF_SPARABLE_MAP15;
+				UDF_SB_TYPESPAR(sb,i).s_packet_len = le16_to_cpu(spm->packetLength);
 				for (j = 0; j < spm->numSparingTables; j++) {
-					loc =
-					    le32_to_cpu(spm->
-							locSparingTable[j]);
-					UDF_SB_TYPESPAR(sb, i).s_spar_map[j] =
-					    udf_read_tagged(sb, loc, loc,
-							    &ident);
-					if (UDF_SB_TYPESPAR(sb, i).
-					    s_spar_map[j] != NULL) {
-						st = (struct sparingTable *)
-						    UDF_SB_TYPESPAR(sb,
-								    i).
-						    s_spar_map[j]->b_data;
-						if (ident != 0
-						    || strncmp(st->sparingIdent.
-							       ident,
-							       UDF_ID_SPARING,
-							       strlen
-							       (UDF_ID_SPARING)))
-						{
-							brelse(UDF_SB_TYPESPAR
-							       (sb,
-								i).
-							       s_spar_map[j]);
-							UDF_SB_TYPESPAR(sb,
-									i).
-							    s_spar_map[j] =
-							    NULL;
+					loc = le32_to_cpu(spm->locSparingTable[j]);
+					UDF_SB_TYPESPAR(sb,i).s_spar_map[j] =
+						udf_read_tagged(sb, loc, loc, &ident);
+					if (UDF_SB_TYPESPAR(sb,i).s_spar_map[j] != NULL) {
+						st = (struct sparingTable *)UDF_SB_TYPESPAR(sb,i).s_spar_map[j]->b_data;
+						if (ident != 0 ||
+						    strncmp(st->sparingIdent.ident, UDF_ID_SPARING, strlen(UDF_ID_SPARING))) {
+							brelse(UDF_SB_TYPESPAR(sb,i).s_spar_map[j]);
+							UDF_SB_TYPESPAR(sb,i).s_spar_map[j] = NULL;
 						}
 					}
 				}
-				UDF_SB_PARTFUNC(sb, i) = udf_get_pblock_spar15;
+				UDF_SB_PARTFUNC(sb,i) = udf_get_pblock_spar15;
 			} else {
-				udf_debug("Unknown ident: %s\n",
-					  upm2->partIdent.ident);
+				udf_debug("Unknown ident: %s\n", upm2->partIdent.ident);
 				continue;
 			}
-			UDF_SB_PARTVSN(sb, i) = le16_to_cpu(upm2->volSeqNum);
-			UDF_SB_PARTNUM(sb, i) = le16_to_cpu(upm2->partitionNum);
+			UDF_SB_PARTVSN(sb,i) = le16_to_cpu(upm2->volSeqNum);
+			UDF_SB_PARTNUM(sb,i) = le16_to_cpu(upm2->partitionNum);
 		}
 		udf_debug("Partition (%d:%d) type %d on volume %d\n",
-			  i, UDF_SB_PARTNUM(sb, i), type, UDF_SB_PARTVSN(sb,
-									 i));
+			  i, UDF_SB_PARTNUM(sb,i), type, UDF_SB_PARTVSN(sb,i));
 	}
 
 	if (fileset) {
-		long_ad *la = (long_ad *) & (lvd->logicalVolContentsUse[0]);
+		long_ad *la = (long_ad *)&(lvd->logicalVolContentsUse[0]);
 
 		*fileset = lelb_to_cpu(la->extLocation);
-		udf_debug
-		    ("FileSet found in LogicalVolDesc at block=%d, partition=%d\n",
-		     fileset->logicalBlockNum, fileset->partitionReferenceNum);
+		udf_debug("FileSet found in LogicalVolDesc at block=%d, partition=%d\n",
+			  fileset->logicalBlockNum,
+			  fileset->partitionReferenceNum);
 	}
 	if (lvd->integritySeqExt.extLength)
 		udf_load_logicalvolint(sb, leea_to_cpu(lvd->integritySeqExt));
+
 	return 0;
 }
 
@@ -1219,9 +1060,7 @@ static void udf_load_logicalvolint(struc
 		UDF_SB_LVIDBH(sb) = bh;
 
 		if (UDF_SB_LVID(sb)->nextIntegrityExt.extLength)
-			udf_load_logicalvolint(sb,
-					       leea_to_cpu(UDF_SB_LVID(sb)->
-							   nextIntegrityExt));
+			udf_load_logicalvolint(sb, leea_to_cpu(UDF_SB_LVID(sb)->nextIntegrityExt));
 
 		if (UDF_SB_LVIDBH(sb) != bh)
 			brelse(bh);
@@ -1247,9 +1086,8 @@ static void udf_load_logicalvolint(struc
  *	July 1, 1997 - Andrew E. Mileski
  *	Written, tested, and released.
  */
-static int
-udf_process_sequence(struct super_block *sb, long block, long lastblock,
-		     kernel_lb_addr * fileset)
+static int udf_process_sequence(struct super_block *sb, long block, long lastblock,
+				 kernel_lb_addr *fileset)
 {
 	struct buffer_head *bh = NULL;
 	struct udf_vds_record vds[VDS_POS_LENGTH];
@@ -1274,82 +1112,71 @@ udf_process_sequence(struct super_block 
 		gd = (struct generic_desc *)bh->b_data;
 		vdsn = le32_to_cpu(gd->volDescSeqNum);
 		switch (ident) {
-		case TAG_IDENT_PVD:	/* ISO 13346 3/10.1 */
+		case TAG_IDENT_PVD: /* ISO 13346 3/10.1 */
 			if (vdsn >= vds[VDS_POS_PRIMARY_VOL_DESC].volDescSeqNum) {
-				vds[VDS_POS_PRIMARY_VOL_DESC].volDescSeqNum =
-				    vdsn;
+				vds[VDS_POS_PRIMARY_VOL_DESC].volDescSeqNum = vdsn;
 				vds[VDS_POS_PRIMARY_VOL_DESC].block = block;
 			}
 			break;
-		case TAG_IDENT_VDP:	/* ISO 13346 3/10.3 */
+		case TAG_IDENT_VDP: /* ISO 13346 3/10.3 */
 			if (vdsn >= vds[VDS_POS_VOL_DESC_PTR].volDescSeqNum) {
 				vds[VDS_POS_VOL_DESC_PTR].volDescSeqNum = vdsn;
 				vds[VDS_POS_VOL_DESC_PTR].block = block;
 
 				vdp = (struct volDescPtr *)bh->b_data;
-				next_s =
-				    le32_to_cpu(vdp->nextVolDescSeqExt.
-						extLocation);
-				next_e =
-				    le32_to_cpu(vdp->nextVolDescSeqExt.
-						extLength);
+				next_s = le32_to_cpu(vdp->nextVolDescSeqExt.extLocation);
+				next_e = le32_to_cpu(vdp->nextVolDescSeqExt.extLength);
 				next_e = next_e >> sb->s_blocksize_bits;
 				next_e += next_s;
 			}
 			break;
-		case TAG_IDENT_IUVD:	/* ISO 13346 3/10.4 */
+		case TAG_IDENT_IUVD: /* ISO 13346 3/10.4 */
 			if (vdsn >= vds[VDS_POS_IMP_USE_VOL_DESC].volDescSeqNum) {
-				vds[VDS_POS_IMP_USE_VOL_DESC].volDescSeqNum =
-				    vdsn;
+				vds[VDS_POS_IMP_USE_VOL_DESC].volDescSeqNum = vdsn;
 				vds[VDS_POS_IMP_USE_VOL_DESC].block = block;
 			}
 			break;
-		case TAG_IDENT_PD:	/* ISO 13346 3/10.5 */
+		case TAG_IDENT_PD: /* ISO 13346 3/10.5 */
 			if (!vds[VDS_POS_PARTITION_DESC].block)
 				vds[VDS_POS_PARTITION_DESC].block = block;
 			break;
-		case TAG_IDENT_LVD:	/* ISO 13346 3/10.6 */
+		case TAG_IDENT_LVD: /* ISO 13346 3/10.6 */
 			if (vdsn >= vds[VDS_POS_LOGICAL_VOL_DESC].volDescSeqNum) {
-				vds[VDS_POS_LOGICAL_VOL_DESC].volDescSeqNum =
-				    vdsn;
+				vds[VDS_POS_LOGICAL_VOL_DESC].volDescSeqNum = vdsn;
 				vds[VDS_POS_LOGICAL_VOL_DESC].block = block;
 			}
 			break;
-		case TAG_IDENT_USD:	/* ISO 13346 3/10.8 */
-			if (vdsn >=
-			    vds[VDS_POS_UNALLOC_SPACE_DESC].volDescSeqNum) {
-				vds[VDS_POS_UNALLOC_SPACE_DESC].volDescSeqNum =
-				    vdsn;
+		case TAG_IDENT_USD: /* ISO 13346 3/10.8 */
+			if (vdsn >= vds[VDS_POS_UNALLOC_SPACE_DESC].volDescSeqNum) {
+				vds[VDS_POS_UNALLOC_SPACE_DESC].volDescSeqNum = vdsn;
 				vds[VDS_POS_UNALLOC_SPACE_DESC].block = block;
 			}
 			break;
-		case TAG_IDENT_TD:	/* ISO 13346 3/10.9 */
+		case TAG_IDENT_TD: /* ISO 13346 3/10.9 */
 			vds[VDS_POS_TERMINATING_DESC].block = block;
 			if (next_e) {
 				block = next_s;
 				lastblock = next_e;
 				next_s = next_e = 0;
-			} else
+			} else {
 				done = 1;
+			}
 			break;
 		}
 		brelse(bh);
 	}
 	for (i = 0; i < VDS_POS_LENGTH; i++) {
 		if (vds[i].block) {
-			bh = udf_read_tagged(sb, vds[i].block, vds[i].block,
-					     &ident);
+			bh = udf_read_tagged(sb, vds[i].block, vds[i].block, &ident);
 
-			if (i == VDS_POS_PRIMARY_VOL_DESC)
+			if (i == VDS_POS_PRIMARY_VOL_DESC) {
 				udf_load_pvoldesc(sb, bh);
-			else if (i == VDS_POS_LOGICAL_VOL_DESC)
+			} else if (i == VDS_POS_LOGICAL_VOL_DESC) {
 				udf_load_logicalvol(sb, bh, fileset);
-			else if (i == VDS_POS_PARTITION_DESC) {
+			} else if (i == VDS_POS_PARTITION_DESC) {
 				struct buffer_head *bh2 = NULL;
 				udf_load_partdesc(sb, bh);
-				for (j = vds[i].block + 1;
-				     j < vds[VDS_POS_TERMINATING_DESC].block;
-				     j++) {
+				for (j = vds[i].block + 1; j <  vds[VDS_POS_TERMINATING_DESC].block; j++) {
 					bh2 = udf_read_tagged(sb, j, j, &ident);
 					gd = (struct generic_desc *)bh2->b_data;
 					if (ident == TAG_IDENT_PD)
@@ -1378,49 +1205,43 @@ static int udf_check_valid(struct super_
 	/* Check that it is NSR02 compliant */
 	/* Process any "CD-ROM Volume Descriptor Set" (ECMA 167 2/8.3.1) */
 	else if ((block = udf_vrs(sb, silent)) == -1) {
-		udf_debug
-		    ("Failed to read byte 32768. Assuming open disc. Skipping validity check\n");
+		udf_debug("Failed to read byte 32768. Assuming open disc. "
+			  "Skipping validity check\n");
 		if (!UDF_SB_LASTBLOCK(sb))
 			UDF_SB_LASTBLOCK(sb) = udf_get_last_block(sb);
 		return 0;
-	} else
+	} else {
 		return !block;
+	}
 }
 
-static int udf_load_partition(struct super_block *sb, kernel_lb_addr * fileset)
+static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 {
 	struct anchorVolDescPtr *anchor;
 	uint16_t ident;
 	struct buffer_head *bh;
 	long main_s, main_e, reserve_s, reserve_e;
 	int i, j;
+	kernel_lb_addr ino;
 
 	if (!sb)
 		return 1;
 
 	for (i = 0; i < ARRAY_SIZE(UDF_SB_ANCHOR(sb)); i++) {
-		if (UDF_SB_ANCHOR(sb)[i] && (bh = udf_read_tagged(sb,
-								  UDF_SB_ANCHOR
-								  (sb)[i],
-								  UDF_SB_ANCHOR
-								  (sb)[i],
-								  &ident))) {
+		if (UDF_SB_ANCHOR(sb)[i] &&
+		    (bh = udf_read_tagged(sb, UDF_SB_ANCHOR(sb)[i],
+					  UDF_SB_ANCHOR(sb)[i], &ident))) {
 			anchor = (struct anchorVolDescPtr *)bh->b_data;
 
 			/* Locate the main sequence */
-			main_s =
-			    le32_to_cpu(anchor->mainVolDescSeqExt.extLocation);
-			main_e =
-			    le32_to_cpu(anchor->mainVolDescSeqExt.extLength);
+			main_s = le32_to_cpu(anchor->mainVolDescSeqExt.extLocation);
+			main_e = le32_to_cpu(anchor->mainVolDescSeqExt.extLength );
 			main_e = main_e >> sb->s_blocksize_bits;
 			main_e += main_s;
 
 			/* Locate the reserve sequence */
-			reserve_s =
-			    le32_to_cpu(anchor->reserveVolDescSeqExt.
-					extLocation);
-			reserve_e =
-			    le32_to_cpu(anchor->reserveVolDescSeqExt.extLength);
+			reserve_s = le32_to_cpu(anchor->reserveVolDescSeqExt.extLocation);
+			reserve_e = le32_to_cpu(anchor->reserveVolDescSeqExt.extLength);
 			reserve_e = reserve_e >> sb->s_blocksize_bits;
 			reserve_e += reserve_s;
 
@@ -1428,10 +1249,8 @@ static int udf_load_partition(struct sup
 
 			/* Process the main & reserve sequences */
 			/* responsible for finding the PartitionDesc(s) */
-			if (!
-			    (udf_process_sequence(sb, main_s, main_e, fileset)
-			     && udf_process_sequence(sb, reserve_s, reserve_e,
-						     fileset))) {
+			if (!(udf_process_sequence(sb, main_s, main_e, fileset) &&
+			      udf_process_sequence(sb, reserve_s, reserve_e, fileset))) {
 				break;
 			}
 		}
@@ -1440,85 +1259,77 @@ static int udf_load_partition(struct sup
 	if (i == ARRAY_SIZE(UDF_SB_ANCHOR(sb))) {
 		udf_debug("No Anchor block found\n");
 		return 1;
-	} else
+	} else {
 		udf_debug("Using anchor in block %d\n", UDF_SB_ANCHOR(sb)[i]);
+	}
 
 	for (i = 0; i < UDF_SB_NUMPARTS(sb); i++) {
 		switch (UDF_SB_PARTTYPE(sb, i)) {
 		case UDF_VIRTUAL_MAP15:
 		case UDF_VIRTUAL_MAP20:
-			{
-				kernel_lb_addr ino;
 
-				if (!UDF_SB_LASTBLOCK(sb)) {
-					UDF_SB_LASTBLOCK(sb) =
-					    udf_get_last_block(sb);
-					udf_find_anchor(sb);
-				}
+			if (!UDF_SB_LASTBLOCK(sb)) {
+				UDF_SB_LASTBLOCK(sb) = udf_get_last_block(sb);
+				udf_find_anchor(sb);
+			}
 
-				if (!UDF_SB_LASTBLOCK(sb)) {
-					udf_debug
-					    ("Unable to determine Lastblock (For Virtual Partition)\n");
-					return 1;
-				}
+			if (!UDF_SB_LASTBLOCK(sb)) {
+				udf_debug("Unable to determine Lastblock (For "
+					"Virtual Partition)\n");
+				return 1;
+			}
 
-				for (j = 0; j < UDF_SB_NUMPARTS(sb); j++) {
-					if (j != i &&
-					    UDF_SB_PARTVSN(sb,
-							   i) ==
-					    UDF_SB_PARTVSN(sb, j)
-					    && UDF_SB_PARTNUM(sb,
-							      i) ==
-					    UDF_SB_PARTNUM(sb, j)) {
-						ino.partitionReferenceNum = j;
-						ino.logicalBlockNum =
-						    UDF_SB_LASTBLOCK(sb) -
-						    UDF_SB_PARTROOT(sb, j);
-						break;
-					}
+			for (j = 0; j < UDF_SB_NUMPARTS(sb); j++) {
+				if (j != i &&
+					UDF_SB_PARTVSN(sb, i) ==
+						UDF_SB_PARTVSN(sb, j) &&
+					UDF_SB_PARTNUM(sb, i) ==
+					  UDF_SB_PARTNUM(sb, j)) {
+					ino.partitionReferenceNum = j;
+					ino.logicalBlockNum =
+					    UDF_SB_LASTBLOCK(sb) -
+					    UDF_SB_PARTROOT(sb, j);
+					break;
 				}
+			}
 
-				if (j == UDF_SB_NUMPARTS(sb))
-					return 1;
+			if (j == UDF_SB_NUMPARTS(sb))
+				return 1;
 
-				if (!(UDF_SB_VAT(sb) = udf_iget(sb, ino)))
-					return 1;
+			if (!(UDF_SB_VAT(sb) = udf_iget(sb, ino)))
+				return 1;
 
-				if (UDF_SB_PARTTYPE(sb, i) == UDF_VIRTUAL_MAP15) {
-					UDF_SB_TYPEVIRT(sb, i).s_start_offset =
-					    udf_ext0_offset(UDF_SB_VAT(sb));
-					UDF_SB_TYPEVIRT(sb, i).s_num_entries =
-					    (UDF_SB_VAT(sb)->i_size - 36) >> 2;
-				} else if (UDF_SB_PARTTYPE(sb, i) ==
-					   UDF_VIRTUAL_MAP20) {
-					struct buffer_head *bh = NULL;
-					uint32_t pos;
-
-					pos = udf_block_map(UDF_SB_VAT(sb), 0);
-					bh = sb_bread(sb, pos);
-					if (!bh)
-						return 1;
-					UDF_SB_TYPEVIRT(sb, i).s_start_offset =
-					    le16_to_cpu(((struct
-							  virtualAllocationTable20
-							  *)bh->b_data +
-							 udf_ext0_offset
-							 (UDF_SB_VAT(sb)))->
-							lengthHeader) +
-					    udf_ext0_offset(UDF_SB_VAT(sb));
-					UDF_SB_TYPEVIRT(sb, i).s_num_entries =
-					    (UDF_SB_VAT(sb)->i_size -
-					     UDF_SB_TYPEVIRT(sb,
-							     i).
-					     s_start_offset) >> 2;
-					brelse(bh);
-				}
-				UDF_SB_PARTROOT(sb, i) =
-				    udf_get_pblock(sb, 0, i, 0);
-				UDF_SB_PARTLEN(sb, i) =
-				    UDF_SB_PARTLEN(sb,
-						   ino.partitionReferenceNum);
+			if (UDF_SB_PARTTYPE(sb, i) == UDF_VIRTUAL_MAP15) {
+				UDF_SB_TYPEVIRT(sb, i).s_start_offset =
+				    udf_ext0_offset(UDF_SB_VAT(sb));
+				UDF_SB_TYPEVIRT(sb, i).s_num_entries =
+				    (UDF_SB_VAT(sb)->i_size - 36) >> 2;
+			} else if (UDF_SB_PARTTYPE(sb, i) == UDF_VIRTUAL_MAP20) {
+				struct buffer_head *bh = NULL;
+				uint32_t pos;
+
+				pos = udf_block_map(UDF_SB_VAT(sb), 0);
+				bh = sb_bread(sb, pos);
+				if (!bh)
+					return 1;
+				UDF_SB_TYPEVIRT(sb, i).s_start_offset =
+				    le16_to_cpu(((struct
+						  virtualAllocationTable20
+						 *)bh->b_data +
+						 udf_ext0_offset
+						 (UDF_SB_VAT(sb)))->
+						 lengthHeader) +
+				    udf_ext0_offset(UDF_SB_VAT(sb));
+				UDF_SB_TYPEVIRT(sb, i).s_num_entries =
+				    (UDF_SB_VAT(sb)->i_size -
+				     UDF_SB_TYPEVIRT(sb, i).s_start_offset) >> 2;
+				brelse(bh);
 			}
+			UDF_SB_PARTROOT(sb, i) =
+			    udf_get_pblock(sb, 0, i, 0);
+			UDF_SB_PARTLEN(sb, i) =
+			    UDF_SB_PARTLEN(sb,
+					   ino.partitionReferenceNum);
 		}
 	}
 	return 0;
@@ -1555,42 +1366,32 @@ static void udf_open_lvid(struct super_b
 
 static void udf_close_lvid(struct super_block *sb)
 {
+	kernel_timestamp cpu_time;
+	int i;
+
 	if (UDF_SB_LVIDBH(sb) &&
 	    UDF_SB_LVID(sb)->integrityType == LVID_INTEGRITY_TYPE_OPEN) {
-		int i;
-		kernel_timestamp cpu_time;
-
 		UDF_SB_LVIDIU(sb)->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
 		UDF_SB_LVIDIU(sb)->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
 		if (udf_time_to_stamp(&cpu_time, CURRENT_TIME))
-			UDF_SB_LVID(sb)->recordingDateAndTime =
-			    cpu_to_lets(cpu_time);
-		if (UDF_MAX_WRITE_VERSION >
-		    le16_to_cpu(UDF_SB_LVIDIU(sb)->maxUDFWriteRev))
-			UDF_SB_LVIDIU(sb)->maxUDFWriteRev =
-			    cpu_to_le16(UDF_MAX_WRITE_VERSION);
-		if (UDF_SB_UDFREV(sb) >
-		    le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFReadRev))
-			UDF_SB_LVIDIU(sb)->minUDFReadRev =
-			    cpu_to_le16(UDF_SB_UDFREV(sb));
-		if (UDF_SB_UDFREV(sb) >
-		    le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFWriteRev))
-			UDF_SB_LVIDIU(sb)->minUDFWriteRev =
-			    cpu_to_le16(UDF_SB_UDFREV(sb));
-		UDF_SB_LVID(sb)->integrityType =
-		    cpu_to_le32(LVID_INTEGRITY_TYPE_CLOSE);
+			UDF_SB_LVID(sb)->recordingDateAndTime = cpu_to_lets(cpu_time);
+		if (UDF_MAX_WRITE_VERSION > le16_to_cpu(UDF_SB_LVIDIU(sb)->maxUDFWriteRev))
+			UDF_SB_LVIDIU(sb)->maxUDFWriteRev = cpu_to_le16(UDF_MAX_WRITE_VERSION);
+		if (UDF_SB_UDFREV(sb) > le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFReadRev))
+			UDF_SB_LVIDIU(sb)->minUDFReadRev = cpu_to_le16(UDF_SB_UDFREV(sb));
+		if (UDF_SB_UDFREV(sb) > le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFWriteRev))
+			UDF_SB_LVIDIU(sb)->minUDFWriteRev = cpu_to_le16(UDF_SB_UDFREV(sb));
+		UDF_SB_LVID(sb)->integrityType = cpu_to_le32(LVID_INTEGRITY_TYPE_CLOSE);
 
 		UDF_SB_LVID(sb)->descTag.descCRC =
-		    cpu_to_le16(udf_crc((char *)UDF_SB_LVID(sb) + sizeof(tag),
-					le16_to_cpu(UDF_SB_LVID(sb)->descTag.
-						    descCRCLength), 0));
+			cpu_to_le16(udf_crc((char *)UDF_SB_LVID(sb) + sizeof(tag),
+					    le16_to_cpu(UDF_SB_LVID(sb)->descTag.descCRCLength), 0));
 
 		UDF_SB_LVID(sb)->descTag.tagChecksum = 0;
 		for (i = 0; i < 16; i++)
 			if (i != 4)
 				UDF_SB_LVID(sb)->descTag.tagChecksum +=
-				    ((uint8_t *) &
-				     (UDF_SB_LVID(sb)->descTag))[i];
+					((uint8_t *)&(UDF_SB_LVID(sb)->descTag))[i];
 
 		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
 	}
@@ -1628,6 +1429,7 @@ static int udf_fill_super(struct super_b
 	sbi = kmalloc(sizeof(struct udf_sb_info), GFP_KERNEL);
 	if (!sbi)
 		return -ENOMEM;
+
 	sb->s_fs_info = sbi;
 	memset(UDF_SB(sb), 0x00, sizeof(struct udf_sb_info));
 
@@ -1679,7 +1481,7 @@ static int udf_fill_super(struct super_b
 	UDF_SB_ANCHOR(sb)[2] = uopt.anchor;
 	UDF_SB_ANCHOR(sb)[3] = 256;
 
-	if (udf_check_valid(sb, uopt.novrs, silent)) {	/* read volume recognition sequences */
+	if (udf_check_valid(sb, uopt.novrs, silent)) { /* read volume recognition sequences */
 		printk("UDF-fs: No VRS found\n");
 		goto error_out;
 	}
@@ -1701,10 +1503,8 @@ static int udf_fill_super(struct super_b
 	udf_debug("Lastblock=%d\n", UDF_SB_LASTBLOCK(sb));
 
 	if (UDF_SB_LVIDBH(sb)) {
-		uint16_t minUDFReadRev =
-		    le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFReadRev);
-		uint16_t minUDFWriteRev =
-		    le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFWriteRev);
+		uint16_t minUDFReadRev = le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFReadRev);
+		uint16_t minUDFWriteRev = le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFWriteRev);
 		/* uint16_t maxUDFWriteRev = le16_to_cpu(UDF_SB_LVIDIU(sb)->maxUDFWriteRev); */
 
 		if (minUDFReadRev > UDF_MAX_READ_VERSION) {
@@ -1729,10 +1529,8 @@ static int udf_fill_super(struct super_b
 		goto error_out;
 	}
 
-	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) &
-	    UDF_PART_FLAG_READ_ONLY) {
-		printk
-		    ("UDF-fs: Partition marked readonly; forcing readonly mount\n");
+	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_READ_ONLY) {
+		printk("UDF-fs: Partition marked readonly; forcing readonly mount\n");
 		sb->s_flags |= MS_RDONLY;
 	}
 
@@ -1744,10 +1542,11 @@ static int udf_fill_super(struct super_b
 	if (!silent) {
 		kernel_timestamp ts;
 		udf_time_to_stamp(&ts, UDF_SB_RECORDTIME(sb));
-		udf_info
-		    ("UDF %s (%s) Mounting volume '%s', timestamp %04u/%02u/%02u %02u:%02u (%x)\n",
-		     UDFFS_VERSION, UDFFS_DATE, UDF_SB_VOLIDENT(sb), ts.year,
-		     ts.month, ts.day, ts.hour, ts.minute, ts.typeAndTimezone);
+		udf_info("UDF %s (%s) Mounting volume '%s', "
+			 "timestamp %04u/%02u/%02u %02u:%02u (%x)\n",
+			 UDFFS_VERSION, UDFFS_DATE,
+			 UDF_SB_VOLIDENT(sb), ts.year, ts.month, ts.day, ts.hour, ts.minute,
+			 ts.typeAndTimezone);
 	}
 	if (!(sb->s_flags & MS_RDONLY))
 		udf_open_lvid(sb);
@@ -1772,30 +1571,21 @@ static int udf_fill_super(struct super_b
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	return 0;
 
-      error_out:
+error_out:
 	if (UDF_SB_VAT(sb))
 		iput(UDF_SB_VAT(sb));
 	if (UDF_SB_NUMPARTS(sb)) {
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) &
-		    UDF_PART_FLAG_UNALLOC_TABLE)
-			iput(UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_uspace.
-			     s_table);
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) &
-		    UDF_PART_FLAG_FREED_TABLE)
-			iput(UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_fspace.
-			     s_table);
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) &
-		    UDF_PART_FLAG_UNALLOC_BITMAP)
-			UDF_SB_FREE_BITMAP(sb, UDF_SB_PARTITION(sb), s_uspace);
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) &
-		    UDF_PART_FLAG_FREED_BITMAP)
-			UDF_SB_FREE_BITMAP(sb, UDF_SB_PARTITION(sb), s_fspace);
-		if (UDF_SB_PARTTYPE(sb, UDF_SB_PARTITION(sb)) ==
-		    UDF_SPARABLE_MAP15) {
+		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_TABLE)
+			iput(UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_table);
+		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_TABLE)
+			iput(UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_table);
+		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_BITMAP)
+			UDF_SB_FREE_BITMAP(sb,UDF_SB_PARTITION(sb), s_uspace);
+		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP)
+			UDF_SB_FREE_BITMAP(sb,UDF_SB_PARTITION(sb), s_fspace);
+		if (UDF_SB_PARTTYPE(sb, UDF_SB_PARTITION(sb)) == UDF_SPARABLE_MAP15) {
 			for (i = 0; i < 4; i++)
-				brelse(UDF_SB_TYPESPAR
-				       (sb,
-					UDF_SB_PARTITION(sb)).s_spar_map[i]);
+				brelse(UDF_SB_TYPESPAR(sb, UDF_SB_PARTITION(sb)).s_spar_map[i]);
 		}
 	}
 #ifdef CONFIG_UDF_NLS
@@ -1808,6 +1598,7 @@ static int udf_fill_super(struct super_b
 	UDF_SB_FREE(sb);
 	kfree(sbi);
 	sb->s_fs_info = NULL;
+
 	return -EINVAL;
 }
 
@@ -1823,8 +1614,8 @@ void udf_error(struct super_block *sb, c
 	va_start(args, fmt);
 	vsnprintf(error_buf, sizeof(error_buf), fmt, args);
 	va_end(args);
-	printk(KERN_CRIT "UDF-fs error (device %s): %s: %s\n",
-	       sb->s_id, function, error_buf);
+	printk (KERN_CRIT "UDF-fs error (device %s): %s: %s\n",
+		sb->s_id, function, error_buf);
 }
 
 void udf_warning(struct super_block *sb, const char *function,
@@ -1859,26 +1650,17 @@ static void udf_put_super(struct super_b
 	if (UDF_SB_VAT(sb))
 		iput(UDF_SB_VAT(sb));
 	if (UDF_SB_NUMPARTS(sb)) {
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) &
-		    UDF_PART_FLAG_UNALLOC_TABLE)
-			iput(UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_uspace.
-			     s_table);
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) &
-		    UDF_PART_FLAG_FREED_TABLE)
-			iput(UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_fspace.
-			     s_table);
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) &
-		    UDF_PART_FLAG_UNALLOC_BITMAP)
-			UDF_SB_FREE_BITMAP(sb, UDF_SB_PARTITION(sb), s_uspace);
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) &
-		    UDF_PART_FLAG_FREED_BITMAP)
-			UDF_SB_FREE_BITMAP(sb, UDF_SB_PARTITION(sb), s_fspace);
-		if (UDF_SB_PARTTYPE(sb, UDF_SB_PARTITION(sb)) ==
-		    UDF_SPARABLE_MAP15) {
+		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_TABLE)
+			iput(UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_table);
+		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_TABLE)
+			iput(UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_table);
+		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_BITMAP)
+			UDF_SB_FREE_BITMAP(sb,UDF_SB_PARTITION(sb), s_uspace);
+		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP)
+			UDF_SB_FREE_BITMAP(sb,UDF_SB_PARTITION(sb), s_fspace);
+		if (UDF_SB_PARTTYPE(sb, UDF_SB_PARTITION(sb)) == UDF_SPARABLE_MAP15) {
 			for (i = 0; i < 4; i++)
-				brelse(UDF_SB_TYPESPAR
-				       (sb,
-					UDF_SB_PARTITION(sb)).s_spar_map[i]);
+				brelse(UDF_SB_TYPESPAR(sb, UDF_SB_PARTITION(sb)).s_spar_map[i]);
 		}
 	}
 #ifdef CONFIG_UDF_NLS
@@ -1917,8 +1699,7 @@ static int udf_statfs(struct dentry *den
 	buf->f_bavail = buf->f_bfree;
 	buf->f_files = (UDF_SB_LVIDBH(sb) ?
 			(le32_to_cpu(UDF_SB_LVIDIU(sb)->numFiles) +
-			 le32_to_cpu(UDF_SB_LVIDIU(sb)->numDirs)) : 0) +
-	    buf->f_bfree;
+			 le32_to_cpu(UDF_SB_LVIDIU(sb)->numDirs)) : 0) + buf->f_bfree;
 	buf->f_ffree = buf->f_bfree;
 	/* __kernel_fsid_t f_fsid */
 	buf->f_namelen = UDF_NAME_LEN - 2;
@@ -1930,8 +1711,7 @@ static unsigned char udf_bitmap_lookup[1
 	0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4
 };
 
-static unsigned int
-udf_count_free_bitmap(struct super_block *sb, struct udf_bitmap *bitmap)
+static unsigned int udf_count_free_bitmap(struct super_block *sb, struct udf_bitmap *bitmap)
 {
 	struct buffer_head *bh = NULL;
 	unsigned int accum = 0;
@@ -1961,8 +1741,8 @@ udf_count_free_bitmap(struct super_block
 
 	bm = (struct spaceBitmapDesc *)bh->b_data;
 	bytes = le32_to_cpu(bm->numOfBytes);
-	index = sizeof(struct spaceBitmapDesc);	/* offset in first block only */
-	ptr = (uint8_t *) bh->b_data;
+	index = sizeof(struct spaceBitmapDesc); /* offset in first block only */
+	ptr = (uint8_t *)bh->b_data;
 
 	while (bytes > 0) {
 		while ((bytes > 0) && (index < sb->s_blocksize)) {
@@ -1981,19 +1761,18 @@ udf_count_free_bitmap(struct super_block
 				goto out;
 			}
 			index = 0;
-			ptr = (uint8_t *) bh->b_data;
+			ptr = (uint8_t *)bh->b_data;
 		}
 	}
 	brelse(bh);
 
-      out:
+out:
 	unlock_kernel();
 
 	return accum;
 }
 
-static unsigned int
-udf_count_free_table(struct super_block *sb, struct inode *table)
+static unsigned int udf_count_free_table(struct super_block *sb, struct inode *table)
 {
 	unsigned int accum = 0;
 	uint32_t elen;
@@ -2007,8 +1786,9 @@ udf_count_free_table(struct super_block 
 	epos.offset = sizeof(struct unallocSpaceEntry);
 	epos.bh = NULL;
 
-	while ((etype = udf_next_aext(table, &epos, &eloc, &elen, 1)) != -1)
+	while ((etype = udf_next_aext(table, &epos, &eloc, &elen, 1)) != -1) {
 		accum += (elen >> table->i_sb->s_blocksize_bits);
+	}
 	brelse(epos.bh);
 
 	unlock_kernel();
@@ -2021,12 +1801,8 @@ static unsigned int udf_count_free(struc
 	unsigned int accum = 0;
 
 	if (UDF_SB_LVIDBH(sb)) {
-		if (le32_to_cpu(UDF_SB_LVID(sb)->numOfPartitions) >
-		    UDF_SB_PARTITION(sb)) {
-			accum =
-			    le32_to_cpu(UDF_SB_LVID(sb)->
-					freeSpaceTable[UDF_SB_PARTITION(sb)]);
-
+		if (le32_to_cpu(UDF_SB_LVID(sb)->numOfPartitions) > UDF_SB_PARTITION(sb)) {
+			accum = le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[UDF_SB_PARTITION(sb)]);
 			if (accum == 0xFFFFFFFF)
 				accum = 0;
 		}
@@ -2035,40 +1811,24 @@ static unsigned int udf_count_free(struc
 	if (accum)
 		return accum;
 
-	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) &
-	    UDF_PART_FLAG_UNALLOC_BITMAP) {
-		accum +=
-		    udf_count_free_bitmap(sb,
-					  UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION
-							      (sb)].s_uspace.
-					  s_bitmap);
-	}
-	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) &
-	    UDF_PART_FLAG_FREED_BITMAP) {
-		accum +=
-		    udf_count_free_bitmap(sb,
-					  UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION
-							      (sb)].s_fspace.
-					  s_bitmap);
+	if (UDF_SB_PARTFLAGS(sb,UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_BITMAP) {
+		accum += udf_count_free_bitmap(sb,
+					       UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_bitmap);
+	}
+	if (UDF_SB_PARTFLAGS(sb,UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP) {
+		accum += udf_count_free_bitmap(sb,
+					       UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_bitmap);
 	}
 	if (accum)
 		return accum;
 
-	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) &
-	    UDF_PART_FLAG_UNALLOC_TABLE) {
-		accum +=
-		    udf_count_free_table(sb,
-					 UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION
-							     (sb)].s_uspace.
-					 s_table);
-	}
-	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) &
-	    UDF_PART_FLAG_FREED_TABLE) {
-		accum +=
-		    udf_count_free_table(sb,
-					 UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION
-							     (sb)].s_fspace.
-					 s_table);
+	if (UDF_SB_PARTFLAGS(sb,UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_TABLE) {
+		accum += udf_count_free_table(sb,
+					      UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_table);
+	}
+	if (UDF_SB_PARTFLAGS(sb,UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_TABLE) {
+		accum += udf_count_free_table(sb,
+					      UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_table);
 	}
 
 	return accum;
diff -puN fs/udf/symlink.c~udf-coding-style-conversion-lindent-fixups fs/udf/symlink.c
--- a/fs/udf/symlink.c~udf-coding-style-conversion-lindent-fixups
+++ a/fs/udf/symlink.c
@@ -11,7 +11,7 @@
  *	Each contributing author retains all rights to their own work.
  *
  *  (C) 1998-2001 Ben Fennema
- *  (C) 1999 Stelias Computing Inc 
+ *  (C) 1999 Stelias Computing Inc
  *
  * HISTORY
  *
@@ -33,8 +33,7 @@
 #include <linux/buffer_head.h>
 #include "udf_i.h"
 
-static void udf_pc_to_char(struct super_block *sb, char *from, int fromlen,
-			   char *to)
+static void udf_pc_to_char(struct super_block *sb, char *from, int fromlen, char *to)
 {
 	struct pathComponent *pc;
 	int elen = 0;
@@ -81,9 +80,9 @@ static int udf_symlink_filler(struct fil
 	char *p = kmap(page);
 
 	lock_kernel();
-	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB)
+	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB) {
 		symlink = UDF_I_DATA(inode) + UDF_I_LENEATTR(inode);
-	else {
+	} else {
 		bh = sb_bread(inode->i_sb, udf_block_map(inode, 0));
 
 		if (!bh)
@@ -100,7 +99,8 @@ static int udf_symlink_filler(struct fil
 	kunmap(page);
 	unlock_page(page);
 	return 0;
-      out:
+
+out:
 	unlock_kernel();
 	SetPageError(page);
 	kunmap(page);
@@ -112,5 +112,5 @@ static int udf_symlink_filler(struct fil
  * symlinks can't do much...
  */
 const struct address_space_operations udf_symlink_aops = {
-	.readpage = udf_symlink_filler,
+	.readpage		= udf_symlink_filler,
 };
diff -puN fs/udf/truncate.c~udf-coding-style-conversion-lindent-fixups fs/udf/truncate.c
--- a/fs/udf/truncate.c~udf-coding-style-conversion-lindent-fixups
+++ a/fs/udf/truncate.c
@@ -32,7 +32,7 @@ static void extent_trunc(struct inode *i
 			 kernel_lb_addr eloc, int8_t etype, uint32_t elen,
 			 uint32_t nelen)
 {
-	kernel_lb_addr neloc = { 0, 0 };
+	kernel_lb_addr neloc = {};
 	int last_block =
 	    (elen + inode->i_sb->s_blocksize -
 	     1) >> inode->i_sb->s_blocksize_bits;
@@ -70,7 +70,7 @@ static void extent_trunc(struct inode *i
  */
 void udf_truncate_tail_extent(struct inode *inode)
 {
-	struct extent_position epos = { NULL, 0, {0, 0} };
+	struct extent_position epos = {};
 	kernel_lb_addr eloc;
 	uint32_t elen, nelen;
 	uint64_t lbcount = 0;
diff -puN fs/udf/udf_i.h~udf-coding-style-conversion-lindent-fixups fs/udf/udf_i.h
--- a/fs/udf/udf_i.h~udf-coding-style-conversion-lindent-fixups
+++ a/fs/udf/udf_i.h
@@ -23,4 +23,4 @@ static inline struct udf_inode_info *UDF
 #define UDF_I_LAD(X)		( UDF_I(X)->i_ext.i_lad )
 #define UDF_I_DATA(X)		( UDF_I(X)->i_ext.i_data )
 
-#endif				/* !defined(_LINUX_UDF_I_H) */
+#endif /* !defined(_LINUX_UDF_I_H) */
diff -puN fs/udf/udf_sb.h~udf-coding-style-conversion-lindent-fixups fs/udf/udf_sb.h
--- a/fs/udf/udf_sb.h~udf-coding-style-conversion-lindent-fixups
+++ a/fs/udf/udf_sb.h
@@ -20,8 +20,8 @@
 #define UDF_FLAG_VARCONV		8
 #define UDF_FLAG_NLS_MAP		9
 #define UDF_FLAG_UTF8			10
-#define UDF_FLAG_UID_FORGET     11	/* save -1 for uid to disk */
-#define UDF_FLAG_UID_IGNORE     12	/* use sb uid instead of on disk uid */
+#define UDF_FLAG_UID_FORGET     11    /* save -1 for uid to disk */
+#define UDF_FLAG_UID_IGNORE     12    /* use sb uid instead of on disk uid */
 #define UDF_FLAG_GID_FORGET     13
 #define UDF_FLAG_GID_IGNORE     14
 
@@ -41,8 +41,7 @@ static inline struct udf_sb_info *UDF_SB
 
 #define UDF_SB_FREE(X)\
 {\
-	if (UDF_SB(X))\
-	{\
+	if (UDF_SB(X)) {\
 		kfree(UDF_SB_PARTMAPS(X));\
 		UDF_SB_PARTMAPS(X) = NULL;\
 	}\
@@ -51,13 +50,10 @@ static inline struct udf_sb_info *UDF_SB
 #define UDF_SB_ALLOC_PARTMAPS(X,Y)\
 {\
 	UDF_SB_PARTMAPS(X) = kmalloc(sizeof(struct udf_part_map) * Y, GFP_KERNEL);\
-	if (UDF_SB_PARTMAPS(X) != NULL)\
-	{\
+	if (UDF_SB_PARTMAPS(X) != NULL) {\
 		UDF_SB_NUMPARTS(X) = Y;\
 		memset(UDF_SB_PARTMAPS(X), 0x00, sizeof(struct udf_part_map) * Y);\
-	}\
-	else\
-	{\
+	} else {\
 		UDF_SB_NUMPARTS(X) = 0;\
 		udf_error(X, __FUNCTION__, "Unable to allocate space for %d partition maps", Y);\
 	}\
@@ -72,15 +68,12 @@ static inline struct udf_sb_info *UDF_SB
 		UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap = kmalloc(size, GFP_KERNEL);\
 	else\
 		UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap = vmalloc(size);\
-	if (UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap != NULL)\
-	{\
+	if (UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap != NULL) {\
 		memset(UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap, 0x00, size);\
 		UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap->s_block_bitmap =\
 			(struct buffer_head **)(UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap + 1);\
 		UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap->s_nr_groups = nr_groups;\
-	}\
-	else\
-	{\
+	} else {\
 		udf_error(X, __FUNCTION__, "Unable to allocate space for bitmap and %d buffer_head pointers", nr_groups);\
 	}\
 }
@@ -90,8 +83,7 @@ static inline struct udf_sb_info *UDF_SB
 	int i;\
 	int nr_groups = UDF_SB_BITMAP_NR_GROUPS(X,Y,Z);\
 	int size = sizeof(struct udf_bitmap) + (sizeof(struct buffer_head *) * nr_groups);\
-	for (i=0; i<nr_groups; i++)\
-	{\
+	for (i = 0; i < nr_groups; i++) {\
 		if (UDF_SB_BITMAP(X,Y,Z,i))\
 			brelse(UDF_SB_BITMAP(X,Y,Z,i));\
 	}\
@@ -139,4 +131,4 @@ static inline struct udf_sb_info *UDF_SB
 #define UDF_SB_FLAGS(X)				( UDF_SB(X)->s_flags )
 #define UDF_SB_VAT(X)				( UDF_SB(X)->s_vat )
 
-#endif				/* __LINUX_UDF_SB_H */
+#endif /* __LINUX_UDF_SB_H */
diff -puN fs/udf/udfdecl.h~udf-coding-style-conversion-lindent-fixups fs/udf/udfdecl.h
--- a/fs/udf/udfdecl.h~udf-coding-style-conversion-lindent-fixups
+++ a/fs/udf/udfdecl.h
@@ -63,8 +63,8 @@ struct udf_vds_record {
 };
 
 struct generic_desc {
-	tag descTag;
-	__le32 volDescSeqNum;
+	tag		descTag;
+	__le32		volDescSeqNum;
 };
 
 struct ustr {
diff -puN fs/udf/udfend.h~udf-coding-style-conversion-lindent-fixups fs/udf/udfend.h
--- a/fs/udf/udfend.h~udf-coding-style-conversion-lindent-fixups
+++ a/fs/udf/udfend.h
@@ -7,75 +7,93 @@
 static inline kernel_lb_addr lelb_to_cpu(lb_addr in)
 {
 	kernel_lb_addr out;
+
 	out.logicalBlockNum = le32_to_cpu(in.logicalBlockNum);
 	out.partitionReferenceNum = le16_to_cpu(in.partitionReferenceNum);
+
 	return out;
 }
 
 static inline lb_addr cpu_to_lelb(kernel_lb_addr in)
 {
 	lb_addr out;
+
 	out.logicalBlockNum = cpu_to_le32(in.logicalBlockNum);
 	out.partitionReferenceNum = cpu_to_le16(in.partitionReferenceNum);
+
 	return out;
 }
 
 static inline kernel_timestamp lets_to_cpu(timestamp in)
 {
 	kernel_timestamp out;
+
 	memcpy(&out, &in, sizeof(timestamp));
 	out.typeAndTimezone = le16_to_cpu(in.typeAndTimezone);
 	out.year = le16_to_cpu(in.year);
+
 	return out;
 }
 
 static inline short_ad lesa_to_cpu(short_ad in)
 {
 	short_ad out;
+
 	out.extLength = le32_to_cpu(in.extLength);
 	out.extPosition = le32_to_cpu(in.extPosition);
+
 	return out;
 }
 
 static inline short_ad cpu_to_lesa(short_ad in)
 {
 	short_ad out;
+
 	out.extLength = cpu_to_le32(in.extLength);
 	out.extPosition = cpu_to_le32(in.extPosition);
+
 	return out;
 }
 
 static inline kernel_long_ad lela_to_cpu(long_ad in)
 {
 	kernel_long_ad out;
+
 	out.extLength = le32_to_cpu(in.extLength);
 	out.extLocation = lelb_to_cpu(in.extLocation);
+
 	return out;
 }
 
 static inline long_ad cpu_to_lela(kernel_long_ad in)
 {
 	long_ad out;
+
 	out.extLength = cpu_to_le32(in.extLength);
 	out.extLocation = cpu_to_lelb(in.extLocation);
+
 	return out;
 }
 
 static inline kernel_extent_ad leea_to_cpu(extent_ad in)
 {
 	kernel_extent_ad out;
+
 	out.extLength = le32_to_cpu(in.extLength);
 	out.extLocation = le32_to_cpu(in.extLocation);
+
 	return out;
 }
 
 static inline timestamp cpu_to_lets(kernel_timestamp in)
 {
 	timestamp out;
+
 	memcpy(&out, &in, sizeof(timestamp));
 	out.typeAndTimezone = cpu_to_le16(in.typeAndTimezone);
 	out.year = cpu_to_le16(in.year);
+
 	return out;
 }
 
-#endif				/* __UDF_ENDIAN_H */
+#endif /* __UDF_ENDIAN_H */
diff -puN fs/udf/udftime.c~udf-coding-style-conversion-lindent-fixups fs/udf/udftime.c
--- a/fs/udf/udftime.c~udf-coding-style-conversion-lindent-fixups
+++ a/fs/udf/udftime.c
@@ -18,18 +18,18 @@
    Boston, MA 02111-1307, USA.  */
 
 /*
- * dgb 10/02/98: ripped this from glibc source to help convert timestamps to unix time 
+ * dgb 10/02/98: ripped this from glibc source to help convert timestamps to unix time
  *     10/04/98: added new table-based lookup after seeing how ugly the gnu code is
  * blf 09/27/99: ripped out all the old code and inserted new table from
- *					John Brockmeyer (without leap second corrections)
- *				 rewrote udf_stamp_to_time and fixed timezone accounting in
-					udf_time_to_stamp.
+ *		 John Brockmeyer (without leap second corrections)
+ *		 rewrote udf_stamp_to_time and fixed timezone accounting in
+ *		 udf_time_to_stamp.
  */
 
 /*
  * We don't take into account leap seconds. This may be correct or incorrect.
  * For more NIST information (especially dealing with leap seconds), see:
- *  http://www.boulder.nist.gov/timefreq/pubs/bulletin/leapsecond.htm
+ * http://www.boulder.nist.gov/timefreq/pubs/bulletin/leapsecond.htm
  */
 
 #include <linux/types.h>
@@ -54,28 +54,28 @@ static const unsigned short int __mon_yd
 };
 
 #define MAX_YEAR_SECONDS	69
-#define SPD 0x15180		/*3600*24 */
-#define SPY(y,l,s) (SPD * (365*y+l)+s)
+#define SPD			0x15180	/*3600*24 */
+#define SPY(y,l,s)		(SPD * (365*y+l)+s)
 
-static time_t year_seconds[MAX_YEAR_SECONDS] = {
-/*1970*/ SPY(0, 0, 0), SPY(1, 0, 0), SPY(2, 0, 0), SPY(3, 1, 0),
-/*1974*/ SPY(4, 1, 0), SPY(5, 1, 0), SPY(6, 1, 0), SPY(7, 2, 0),
-/*1978*/ SPY(8, 2, 0), SPY(9, 2, 0), SPY(10, 2, 0), SPY(11, 3, 0),
-/*1982*/ SPY(12, 3, 0), SPY(13, 3, 0), SPY(14, 3, 0), SPY(15, 4, 0),
-/*1986*/ SPY(16, 4, 0), SPY(17, 4, 0), SPY(18, 4, 0), SPY(19, 5, 0),
-/*1990*/ SPY(20, 5, 0), SPY(21, 5, 0), SPY(22, 5, 0), SPY(23, 6, 0),
-/*1994*/ SPY(24, 6, 0), SPY(25, 6, 0), SPY(26, 6, 0), SPY(27, 7, 0),
-/*1998*/ SPY(28, 7, 0), SPY(29, 7, 0), SPY(30, 7, 0), SPY(31, 8, 0),
-/*2002*/ SPY(32, 8, 0), SPY(33, 8, 0), SPY(34, 8, 0), SPY(35, 9, 0),
-/*2006*/ SPY(36, 9, 0), SPY(37, 9, 0), SPY(38, 9, 0), SPY(39, 10, 0),
-/*2010*/ SPY(40, 10, 0), SPY(41, 10, 0), SPY(42, 10, 0), SPY(43, 11, 0),
-/*2014*/ SPY(44, 11, 0), SPY(45, 11, 0), SPY(46, 11, 0), SPY(47, 12, 0),
-/*2018*/ SPY(48, 12, 0), SPY(49, 12, 0), SPY(50, 12, 0), SPY(51, 13, 0),
-/*2022*/ SPY(52, 13, 0), SPY(53, 13, 0), SPY(54, 13, 0), SPY(55, 14, 0),
-/*2026*/ SPY(56, 14, 0), SPY(57, 14, 0), SPY(58, 14, 0), SPY(59, 15, 0),
-/*2030*/ SPY(60, 15, 0), SPY(61, 15, 0), SPY(62, 15, 0), SPY(63, 16, 0),
-/*2034*/ SPY(64, 16, 0), SPY(65, 16, 0), SPY(66, 16, 0), SPY(67, 17, 0),
-/*2038*/ SPY(68, 17, 0)
+static time_t year_seconds[MAX_YEAR_SECONDS]= {
+/*1970*/ SPY( 0, 0,0), SPY( 1, 0,0), SPY( 2, 0,0), SPY( 3, 1,0),
+/*1974*/ SPY( 4, 1,0), SPY( 5, 1,0), SPY( 6, 1,0), SPY( 7, 2,0),
+/*1978*/ SPY( 8, 2,0), SPY( 9, 2,0), SPY(10, 2,0), SPY(11, 3,0),
+/*1982*/ SPY(12, 3,0), SPY(13, 3,0), SPY(14, 3,0), SPY(15, 4,0),
+/*1986*/ SPY(16, 4,0), SPY(17, 4,0), SPY(18, 4,0), SPY(19, 5,0),
+/*1990*/ SPY(20, 5,0), SPY(21, 5,0), SPY(22, 5,0), SPY(23, 6,0),
+/*1994*/ SPY(24, 6,0), SPY(25, 6,0), SPY(26, 6,0), SPY(27, 7,0),
+/*1998*/ SPY(28, 7,0), SPY(29, 7,0), SPY(30, 7,0), SPY(31, 8,0),
+/*2002*/ SPY(32, 8,0), SPY(33, 8,0), SPY(34, 8,0), SPY(35, 9,0),
+/*2006*/ SPY(36, 9,0), SPY(37, 9,0), SPY(38, 9,0), SPY(39,10,0),
+/*2010*/ SPY(40,10,0), SPY(41,10,0), SPY(42,10,0), SPY(43,11,0),
+/*2014*/ SPY(44,11,0), SPY(45,11,0), SPY(46,11,0), SPY(47,12,0),
+/*2018*/ SPY(48,12,0), SPY(49,12,0), SPY(50,12,0), SPY(51,13,0),
+/*2022*/ SPY(52,13,0), SPY(53,13,0), SPY(54,13,0), SPY(55,14,0),
+/*2026*/ SPY(56,14,0), SPY(57,14,0), SPY(58,14,0), SPY(59,15,0),
+/*2030*/ SPY(60,15,0), SPY(61,15,0), SPY(62,15,0), SPY(63,16,0),
+/*2034*/ SPY(64,16,0), SPY(65,16,0), SPY(66,16,0), SPY(67,17,0),
+/*2038*/ SPY(68,17,0)
 };
 
 extern struct timezone sys_tz;
@@ -83,7 +83,7 @@ extern struct timezone sys_tz;
 #define SECS_PER_HOUR	(60 * 60)
 #define SECS_PER_DAY	(SECS_PER_HOUR * 24)
 
-time_t *udf_stamp_to_time(time_t * dest, long *dest_usec, kernel_timestamp src)
+time_t *udf_stamp_to_time(time_t *dest, long *dest_usec, kernel_timestamp src)
 {
 	int yday;
 	uint8_t type = src.typeAndTimezone >> 12;
@@ -93,10 +93,11 @@ time_t *udf_stamp_to_time(time_t * dest,
 		offset = src.typeAndTimezone << 4;
 		/* sign extent offset */
 		offset = (offset >> 4);
-		if (offset == -2047)	/* unspecified offset */
+		if (offset == -2047) /* unspecified offset */
 			offset = 0;
-	} else
+	} else {
 		offset = 0;
+	}
 
 	if ((src.year < EPOCH_YEAR) ||
 	    (src.year >= EPOCH_YEAR + MAX_YEAR_SECONDS)) {
@@ -107,12 +108,10 @@ time_t *udf_stamp_to_time(time_t * dest,
 	*dest = year_seconds[src.year - EPOCH_YEAR];
 	*dest -= offset * 60;
 
-	yday = ((__mon_yday[__isleap(src.year)]
+	yday = ((__mon_yday[__isleap (src.year)]
 		 [src.month - 1]) + (src.day - 1));
-	*dest += (((yday * 24) + src.hour) * 60 + src.minute) * 60 + src.second;
-	*dest_usec =
-	    src.centiseconds * 10000 + src.hundredsOfMicroseconds * 100 +
-	    src.microseconds;
+	*dest += ( ( (yday * 24) + src.hour ) * 60 + src.minute ) * 60 + src.second;
+	*dest_usec = src.centiseconds * 10000 + src.hundredsOfMicroseconds * 100 + src.microseconds;
 	return dest;
 }
 
@@ -145,8 +144,9 @@ kernel_timestamp *udf_time_to_stamp(kern
 		long int yg = y + days / 365 - (days % 365 < 0);
 
 		/* Adjust DAYS and Y to match the guessed year.  */
-		days -= ((yg - y) * 365 + LEAPS_THRU_END_OF(yg - 1)
-			 - LEAPS_THRU_END_OF(y - 1));
+		days -= ((yg - y) * 365
+			 + LEAPS_THRU_END_OF (yg - 1)
+			 - LEAPS_THRU_END_OF (y - 1));
 		y = yg;
 	}
 	dest->year = y;
@@ -158,11 +158,9 @@ kernel_timestamp *udf_time_to_stamp(kern
 	dest->day = days + 1;
 
 	dest->centiseconds = ts.tv_nsec / 10000000;
-	dest->hundredsOfMicroseconds =
-	    (ts.tv_nsec / 1000 - dest->centiseconds * 10000) / 100;
-	dest->microseconds =
-	    (ts.tv_nsec / 1000 - dest->centiseconds * 10000 -
-	     dest->hundredsOfMicroseconds * 100);
+	dest->hundredsOfMicroseconds = (ts.tv_nsec / 1000 - dest->centiseconds * 10000) / 100;
+	dest->microseconds = (ts.tv_nsec / 1000 - dest->centiseconds * 10000 -
+			      dest->hundredsOfMicroseconds * 100);
 	return dest;
 }
 
diff -puN fs/udf/unicode.c~udf-coding-style-conversion-lindent-fixups fs/udf/unicode.c
--- a/fs/udf/unicode.c~udf-coding-style-conversion-lindent-fixups
+++ a/fs/udf/unicode.c
@@ -29,21 +29,23 @@
 
 static int udf_translate_to_linux(uint8_t *, uint8_t *, int, uint8_t *, int);
 
-static int udf_char_to_ustr(struct ustr *dest, const uint8_t * src, int strlen)
+static int udf_char_to_ustr(struct ustr *dest, const uint8_t *src, int strlen)
 {
 	if ((!dest) || (!src) || (!strlen) || (strlen > UDF_NAME_LEN - 2))
 		return 0;
+
 	memset(dest, 0, sizeof(struct ustr));
 	memcpy(dest->u_name, src, strlen);
 	dest->u_cmpID = 0x08;
 	dest->u_len = strlen;
+
 	return strlen;
 }
 
 /*
  * udf_build_ustr
  */
-int udf_build_ustr(struct ustr *dest, dstring * ptr, int size)
+int udf_build_ustr(struct ustr *dest, dstring *ptr, int size)
 {
 	int usesize;
 
@@ -55,13 +57,14 @@ int udf_build_ustr(struct ustr *dest, ds
 	dest->u_cmpID = ptr[0];
 	dest->u_len = ptr[size - 1];
 	memcpy(dest->u_name, ptr + 1, usesize - 1);
+
 	return 0;
 }
 
 /*
  * udf_build_ustr_exact
  */
-static int udf_build_ustr_exact(struct ustr *dest, dstring * ptr, int exactsize)
+static int udf_build_ustr_exact(struct ustr *dest, dstring *ptr, int exactsize)
 {
 	if ((!dest) || (!ptr) || (!exactsize))
 		return -1;
@@ -70,6 +73,7 @@ static int udf_build_ustr_exact(struct u
 	dest->u_cmpID = ptr[0];
 	dest->u_len = exactsize - 1;
 	memcpy(dest->u_name, ptr + 1, exactsize - 1);
+
 	return 0;
 }
 
@@ -129,20 +133,15 @@ int udf_CS0toUTF8(struct ustr *utf_o, st
 			c = (c << 8) | ocu[i++];
 
 		/* Compress Unicode to UTF-8 */
-		if (c < 0x80U)
-			utf_o->u_name[utf_o->u_len++] = (uint8_t) c;
-		else if (c < 0x800U) {
-			utf_o->u_name[utf_o->u_len++] =
-			    (uint8_t) (0xc0 | (c >> 6));
-			utf_o->u_name[utf_o->u_len++] =
-			    (uint8_t) (0x80 | (c & 0x3f));
+		if (c < 0x80U) {
+			utf_o->u_name[utf_o->u_len++] = (uint8_t)c;
+		} else if (c < 0x800U) {
+			utf_o->u_name[utf_o->u_len++] = (uint8_t)(0xc0 | (c >> 6));
+			utf_o->u_name[utf_o->u_len++] = (uint8_t)(0x80 | (c & 0x3f));
 		} else {
-			utf_o->u_name[utf_o->u_len++] =
-			    (uint8_t) (0xe0 | (c >> 12));
-			utf_o->u_name[utf_o->u_len++] =
-			    (uint8_t) (0x80 | ((c >> 6) & 0x3f));
-			utf_o->u_name[utf_o->u_len++] =
-			    (uint8_t) (0x80 | (c & 0x3f));
+			utf_o->u_name[utf_o->u_len++] = (uint8_t)(0xe0 | (c >> 12));
+			utf_o->u_name[utf_o->u_len++] = (uint8_t)(0x80 | ((c >> 6) & 0x3f));
+			utf_o->u_name[utf_o->u_len++] = (uint8_t)(0x80 | (c & 0x3f));
 		}
 	}
 	utf_o->u_cmpID = 8;
@@ -173,7 +172,7 @@ int udf_CS0toUTF8(struct ustr *utf_o, st
  *	November 12, 1997 - Andrew E. Mileski
  *	Written, tested, and released.
  */
-static int udf_UTF8toCS0(dstring * ocu, struct ustr *utf, int length)
+static int udf_UTF8toCS0(dstring *ocu, struct ustr *utf, int length)
 {
 	unsigned c, i, max_val, utf_char;
 	int utf_cnt, u_len;
@@ -182,12 +181,12 @@ static int udf_UTF8toCS0(dstring * ocu, 
 	ocu[0] = 8;
 	max_val = 0xffU;
 
-      try_again:
+try_again:
 	u_len = 0U;
 	utf_char = 0U;
 	utf_cnt = 0U;
 	for (i = 0U; i < utf->u_len; i++) {
-		c = (uint8_t) utf->u_name[i];
+		c = (uint8_t)utf->u_name[i];
 
 		/* Complete a multi-byte UTF-8 character */
 		if (utf_cnt) {
@@ -213,37 +212,40 @@ static int udf_UTF8toCS0(dstring * ocu, 
 				} else if ((c & 0xfeU) == 0xfcU) {
 					utf_char = c & 0x01U;
 					utf_cnt = 5;
-				} else
+				} else {
 					goto error_out;
+				}
 				continue;
-			} else
+			} else {
 				/* Single byte UTF-8 character (most common) */
 				utf_char = c;
+			}
 		}
 
 		/* Choose no compression if necessary */
 		if (utf_char > max_val) {
-			if (0xffU == max_val) {
+			if (max_val == 0xffU) {
 				max_val = 0xffffU;
-				ocu[0] = (uint8_t) 0x10U;
+				ocu[0] = (uint8_t)0x10U;
 				goto try_again;
 			}
 			goto error_out;
 		}
 
 		if (max_val == 0xffffU) {
-			ocu[++u_len] = (uint8_t) (utf_char >> 8);
+			ocu[++u_len] = (uint8_t)(utf_char >> 8);
 		}
-		ocu[++u_len] = (uint8_t) (utf_char & 0xffU);
+		ocu[++u_len] = (uint8_t)(utf_char & 0xffU);
 	}
 
 	if (utf_cnt) {
-	      error_out:
+error_out:
 		ocu[++u_len] = '?';
 		printk(KERN_DEBUG "udf: bad UTF-8 character\n");
 	}
 
-	ocu[length - 1] = (uint8_t) u_len + 1;
+	ocu[length - 1] = (uint8_t)u_len + 1;
+
 	return u_len + 1;
 }
 
@@ -288,7 +290,7 @@ static int udf_CS0toNLS(struct nls_table
 	return utf_o->u_len;
 }
 
-static int udf_NLStoCS0(struct nls_table *nls, dstring * ocu, struct ustr *uni,
+static int udf_NLStoCS0(struct nls_table *nls, dstring *ocu, struct ustr *uni,
 			int length)
 {
 	unsigned len, i, max_val;
@@ -299,7 +301,7 @@ static int udf_NLStoCS0(struct nls_table
 	ocu[0] = 8;
 	max_val = 0xffU;
 
-      try_again:
+try_again:
 	u_len = 0U;
 	for (i = 0U; i < uni->u_len; i++) {
 		len = nls->char2uni(&uni->u_name[i], uni->u_len - i, &uni_char);
@@ -308,21 +310,21 @@ static int udf_NLStoCS0(struct nls_table
 
 		if (uni_char > max_val) {
 			max_val = 0xffffU;
-			ocu[0] = (uint8_t) 0x10U;
+			ocu[0] = (uint8_t)0x10U;
 			goto try_again;
 		}
 
 		if (max_val == 0xffffU)
-			ocu[++u_len] = (uint8_t) (uni_char >> 8);
-		ocu[++u_len] = (uint8_t) (uni_char & 0xffU);
+			ocu[++u_len] = (uint8_t)(uni_char >> 8);
+		ocu[++u_len] = (uint8_t)(uni_char & 0xffU);
 		i += len - 1;
 	}
 
-	ocu[length - 1] = (uint8_t) u_len + 1;
+	ocu[length - 1] = (uint8_t)u_len + 1;
 	return u_len + 1;
 }
 
-int udf_get_filename(struct super_block *sb, uint8_t * sname, uint8_t * dname,
+int udf_get_filename(struct super_block *sb, uint8_t *sname, uint8_t *dname,
 		     int flen)
 {
 	struct ustr filename, unifilename;
@@ -334,30 +336,29 @@ int udf_get_filename(struct super_block 
 
 	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UTF8)) {
 		if (!udf_CS0toUTF8(&filename, &unifilename)) {
-			udf_debug("Failed in udf_get_filename: sname = %s\n",
-				  sname);
+			udf_debug("Failed in udf_get_filename: sname = %s\n", sname);
 			return 0;
 		}
 	} else if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP)) {
-		if (!udf_CS0toNLS
-		    (UDF_SB(sb)->s_nls_map, &filename, &unifilename)) {
-			udf_debug("Failed in udf_get_filename: sname = %s\n",
-				  sname);
+		if (!udf_CS0toNLS(UDF_SB(sb)->s_nls_map, &filename, &unifilename)) {
+			udf_debug("Failed in udf_get_filename: sname = %s\n", sname);
 			return 0;
 		}
-	} else
+	} else {
 		return 0;
+	}
 
-	if ((len =
-	     udf_translate_to_linux(dname, filename.u_name, filename.u_len,
-				    unifilename.u_name, unifilename.u_len))) {
+	len = udf_translate_to_linux(dname, filename.u_name, filename.u_len,
+				     unifilename.u_name, unifilename.u_len);
+	if (len) {
 		return len;
 	}
+
 	return 0;
 }
 
-int udf_put_filename(struct super_block *sb, const uint8_t * sname,
-		     uint8_t * dname, int flen)
+int udf_put_filename(struct super_block *sb, const uint8_t *sname,
+		     uint8_t *dname, int flen)
 {
 	struct ustr unifilename;
 	int namelen;
@@ -367,31 +368,29 @@ int udf_put_filename(struct super_block 
 	}
 
 	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UTF8)) {
-		if (!
-		    (namelen =
-		     udf_UTF8toCS0(dname, &unifilename, UDF_NAME_LEN))) {
+		namelen = udf_UTF8toCS0(dname, &unifilename, UDF_NAME_LEN);
+		if (!namelen) {
 			return 0;
 		}
 	} else if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP)) {
-		if (!
-		    (namelen =
-		     udf_NLStoCS0(UDF_SB(sb)->s_nls_map, dname, &unifilename,
-				  UDF_NAME_LEN))) {
+		namelen = udf_NLStoCS0(UDF_SB(sb)->s_nls_map, dname, &unifilename, UDF_NAME_LEN);
+		if (!namelen) {
 			return 0;
 		}
-	} else
+	} else {
 		return 0;
+	}
 
 	return namelen;
 }
 
 #define ILLEGAL_CHAR_MARK	'_'
-#define EXT_MARK			'.'
-#define CRC_MARK			'#'
-#define EXT_SIZE			5
+#define EXT_MARK		'.'
+#define CRC_MARK		'#'
+#define EXT_SIZE 		5
 
-static int udf_translate_to_linux(uint8_t * newName, uint8_t * udfName,
-				  int udfLen, uint8_t * fidName, int fidNameLen)
+static int udf_translate_to_linux(uint8_t *newName, uint8_t *udfName, int udfLen,
+				  uint8_t *fidName, int fidNameLen)
 {
 	int index, newIndex = 0, needsCRC = 0;
 	int extIndex = 0, newExtIndex = 0, hasExt = 0;
@@ -399,8 +398,8 @@ static int udf_translate_to_linux(uint8_
 	uint8_t curr;
 	const uint8_t hexChar[] = "0123456789ABCDEF";
 
-	if (udfName[0] == '.' && (udfLen == 1 ||
-				  (udfLen == 2 && udfName[1] == '.'))) {
+	if (udfName[0] == '.' &&
+	    (udfLen == 1 || (udfLen == 2 && udfName[1] == '.'))) {
 		needsCRC = 1;
 		newIndex = udfLen;
 		memcpy(newName, udfName, udfLen);
@@ -410,16 +409,13 @@ static int udf_translate_to_linux(uint8_
 			if (curr == '/' || curr == 0) {
 				needsCRC = 1;
 				curr = ILLEGAL_CHAR_MARK;
-				while (index + 1 < udfLen
-				       && (udfName[index + 1] == '/'
-					   || udfName[index + 1] == 0))
+				while (index + 1 < udfLen && (udfName[index + 1] == '/' ||
+							      udfName[index + 1] == 0))
 					index++;
-			}
-			if (curr == EXT_MARK
-			    && (udfLen - index - 1) <= EXT_SIZE) {
-				if (udfLen == index + 1)
+			} if (curr == EXT_MARK && (udfLen - index - 1) <= EXT_SIZE) {
+				if (udfLen == index + 1) {
 					hasExt = 0;
-				else {
+				} else {
 					hasExt = 1;
 					extIndex = index;
 					newExtIndex = newIndex;
@@ -437,23 +433,16 @@ static int udf_translate_to_linux(uint8_
 
 		if (hasExt) {
 			int maxFilenameLen;
-			for (index = 0;
-			     index < EXT_SIZE && extIndex + index + 1 < udfLen;
-			     index++) {
+			for(index = 0; index < EXT_SIZE && extIndex + index + 1 < udfLen; index++) {
 				curr = udfName[extIndex + index + 1];
 
 				if (curr == '/' || curr == 0) {
 					needsCRC = 1;
 					curr = ILLEGAL_CHAR_MARK;
-					while (extIndex + index + 2 < udfLen
-					       && (index + 1 < EXT_SIZE
-						   &&
-						   (udfName
-						    [extIndex + index + 2] ==
-						    '/'
-						    || udfName[extIndex +
-							       index + 2] ==
-						    0)))
+					while(extIndex + index + 2 < udfLen &&
+					      (index + 1 < EXT_SIZE
+					       && (udfName[extIndex + index + 2] == '/' ||
+						   udfName[extIndex + index + 2] == 0)))
 						index++;
 				}
 				ext[localExtIndex++] = curr;
@@ -463,8 +452,9 @@ static int udf_translate_to_linux(uint8_
 				newIndex = maxFilenameLen;
 			else
 				newIndex = newExtIndex;
-		} else if (newIndex > 250)
+		} else if (newIndex > 250) {
 			newIndex = 250;
+		}
 		newName[newIndex++] = CRC_MARK;
 		valueCRC = udf_crc(fidName, fidNameLen, 0);
 		newName[newIndex++] = hexChar[(valueCRC & 0xf000) >> 12];
@@ -478,5 +468,6 @@ static int udf_translate_to_linux(uint8_
 				newName[newIndex++] = ext[index];
 		}
 	}
+
 	return newIndex;
 }
_

Patches currently in -mm which might be from gorcunov@gmail.com are

sky-cpu-and-nexus-code-style-improvement.patch
sky-cpu-and-nexus-include-ioh.patch
sky-cpu-and-nexus-check-for-platform_get_resource-ret.patch
sky-cpu-and-nexus-check-for-create_proc_entry-ret-code.patch
sky-cpu-use-c99-style-for-struct-init.patch
udf-check-for-allocated-memory-for-data-of-new-inodes.patch
udf-check-for-allocated-memory-for-inode-data-v2.patch
udf-coding-style-conversion-lindent.patch
udf-coding-style-conversion-lindent-fixups.patch
udf-coding-style-conversion-lindent-fixups-2.patch
udf-fix-function-name-from-udf_crc16-to-udf_crc.patch
