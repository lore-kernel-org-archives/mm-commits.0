From: akpm@linux-foundation.org
Subject: - udf-coding-style-conversion-lindent.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:00:38 -0700
Message-ID: <200707192000.l6JK0cWH019469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35125 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755534AbXGSUes (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:34:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, jack@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     UDF: coding style conversion - lindent
has been removed from the -mm tree.  Its filename was
     udf-coding-style-conversion-lindent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: UDF: coding style conversion - lindent
From: Cyrill Gorcunov <gorcunov@gmail.com>

This patch converts UDF coding style to kernel coding style using Lindent.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Jan Kara <jack@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/balloc.c    |  711 +++++++++---------
 fs/udf/crc.c       |   19 
 fs/udf/dir.c       |  132 +--
 fs/udf/directory.c |  209 ++---
 fs/udf/ecma_167.h  |  869 ++++++++++------------
 fs/udf/file.c      |  116 +--
 fs/udf/fsync.c     |    4 
 fs/udf/ialloc.c    |   69 -
 fs/udf/inode.c     | 1496 ++++++++++++++++++++-------------------
 fs/udf/lowlevel.c  |   25 
 fs/udf/misc.c      |  172 ++--
 fs/udf/namei.c     |  720 +++++++++---------
 fs/udf/osta_udf.h  |  251 +++---
 fs/udf/partition.c |  277 ++++---
 fs/udf/super.c     | 1631 +++++++++++++++++++++++--------------------
 fs/udf/symlink.c   |   56 -
 fs/udf/truncate.c  |  211 +++--
 fs/udf/udf_i.h     |    2 
 fs/udf/udf_sb.h    |    6 
 fs/udf/udfdecl.h   |  106 +-
 fs/udf/udfend.h    |    2 
 fs/udf/udftime.c   |   93 +-
 fs/udf/unicode.c   |  299 +++----
 23 files changed, 3814 insertions(+), 3662 deletions(-)

diff -puN fs/udf/balloc.c~udf-coding-style-conversion-lindent fs/udf/balloc.c
--- a/fs/udf/balloc.c~udf-coding-style-conversion-lindent
+++ a/fs/udf/balloc.c
@@ -41,18 +41,17 @@
 #define uint(x) xuint(x)
 #define xuint(x) __le ## x
 
-static inline int find_next_one_bit (void * addr, int size, int offset)
+static inline int find_next_one_bit(void *addr, int size, int offset)
 {
-	uintBPL_t * p = ((uintBPL_t *) addr) + (offset / BITS_PER_LONG);
-	int result = offset & ~(BITS_PER_LONG-1);
+	uintBPL_t *p = ((uintBPL_t *) addr) + (offset / BITS_PER_LONG);
+	int result = offset & ~(BITS_PER_LONG - 1);
 	unsigned long tmp;
 
 	if (offset >= size)
 		return size;
 	size -= result;
-	offset &= (BITS_PER_LONG-1);
-	if (offset)
-	{
+	offset &= (BITS_PER_LONG - 1);
+	if (offset) {
 		tmp = leBPL_to_cpup(p++);
 		tmp &= ~0UL << offset;
 		if (size < BITS_PER_LONG)
@@ -62,8 +61,7 @@ static inline int find_next_one_bit (voi
 		size -= BITS_PER_LONG;
 		result += BITS_PER_LONG;
 	}
-	while (size & ~(BITS_PER_LONG-1))
-	{
+	while (size & ~(BITS_PER_LONG - 1)) {
 		if ((tmp = leBPL_to_cpup(p++)))
 			goto found_middle;
 		result += BITS_PER_LONG;
@@ -72,17 +70,18 @@ static inline int find_next_one_bit (voi
 	if (!size)
 		return result;
 	tmp = leBPL_to_cpup(p);
-found_first:
-	tmp &= ~0UL >> (BITS_PER_LONG-size);
-found_middle:
+      found_first:
+	tmp &= ~0UL >> (BITS_PER_LONG - size);
+      found_middle:
 	return result + ffz(~tmp);
 }
 
 #define find_first_one_bit(addr, size)\
 	find_next_one_bit((addr), (size), 0)
 
-static int read_block_bitmap(struct super_block * sb,
-	struct udf_bitmap *bitmap, unsigned int block, unsigned long bitmap_nr)
+static int read_block_bitmap(struct super_block *sb,
+			     struct udf_bitmap *bitmap, unsigned int block,
+			     unsigned long bitmap_nr)
 {
 	struct buffer_head *bh = NULL;
 	int retval = 0;
@@ -92,38 +91,39 @@ static int read_block_bitmap(struct supe
 	loc.partitionReferenceNum = UDF_SB_PARTITION(sb);
 
 	bh = udf_tread(sb, udf_get_lb_pblock(sb, loc, block));
-	if (!bh)
-	{
+	if (!bh) {
 		retval = -EIO;
 	}
 	bitmap->s_block_bitmap[bitmap_nr] = bh;
 	return retval;
 }
 
-static int __load_block_bitmap(struct super_block * sb,
-	struct udf_bitmap *bitmap, unsigned int block_group)
+static int __load_block_bitmap(struct super_block *sb,
+			       struct udf_bitmap *bitmap,
+			       unsigned int block_group)
 {
 	int retval = 0;
 	int nr_groups = bitmap->s_nr_groups;
 
-	if (block_group >= nr_groups)
-	{
-		udf_debug("block_group (%d) > nr_groups (%d)\n", block_group, nr_groups);
+	if (block_group >= nr_groups) {
+		udf_debug("block_group (%d) > nr_groups (%d)\n", block_group,
+			  nr_groups);
 	}
 
 	if (bitmap->s_block_bitmap[block_group])
 		return block_group;
-	else
-	{
-		retval = read_block_bitmap(sb, bitmap, block_group, block_group);
+	else {
+		retval =
+		    read_block_bitmap(sb, bitmap, block_group, block_group);
 		if (retval < 0)
 			return retval;
 		return block_group;
 	}
 }
 
-static inline int load_block_bitmap(struct super_block * sb,
-	struct udf_bitmap *bitmap, unsigned int block_group)
+static inline int load_block_bitmap(struct super_block *sb,
+				    struct udf_bitmap *bitmap,
+				    unsigned int block_group)
 {
 	int slot;
 
@@ -138,13 +138,14 @@ static inline int load_block_bitmap(stru
 	return slot;
 }
 
-static void udf_bitmap_free_blocks(struct super_block * sb,
-	struct inode * inode,
-	struct udf_bitmap *bitmap,
-	kernel_lb_addr bloc, uint32_t offset, uint32_t count)
+static void udf_bitmap_free_blocks(struct super_block *sb,
+				   struct inode *inode,
+				   struct udf_bitmap *bitmap,
+				   kernel_lb_addr bloc, uint32_t offset,
+				   uint32_t count)
 {
 	struct udf_sb_info *sbi = UDF_SB(sb);
-	struct buffer_head * bh = NULL;
+	struct buffer_head *bh = NULL;
 	unsigned long block;
 	unsigned long block_group;
 	unsigned long bit;
@@ -154,17 +155,22 @@ static void udf_bitmap_free_blocks(struc
 
 	mutex_lock(&sbi->s_alloc_mutex);
 	if (bloc.logicalBlockNum < 0 ||
-		(bloc.logicalBlockNum + count) > UDF_SB_PARTLEN(sb, bloc.partitionReferenceNum))
-	{
-		udf_debug("%d < %d || %d + %d > %d\n",
-			bloc.logicalBlockNum, 0, bloc.logicalBlockNum, count,
-			UDF_SB_PARTLEN(sb, bloc.partitionReferenceNum));
+	    (bloc.logicalBlockNum + count) > UDF_SB_PARTLEN(sb,
+							    bloc.
+							    partitionReferenceNum))
+	{
+		udf_debug("%d < %d || %d + %d > %d\n", bloc.logicalBlockNum, 0,
+			  bloc.logicalBlockNum, count, UDF_SB_PARTLEN(sb,
+								      bloc.
+								      partitionReferenceNum));
 		goto error_return;
 	}
 
-	block = bloc.logicalBlockNum + offset + (sizeof(struct spaceBitmapDesc) << 3);
+	block =
+	    bloc.logicalBlockNum + offset +
+	    (sizeof(struct spaceBitmapDesc) << 3);
 
-do_more:
+      do_more:
 	overflow = 0;
 	block_group = block >> (sb->s_blocksize_bits + 3);
 	bit = block % (sb->s_blocksize << 3);
@@ -172,8 +178,7 @@ do_more:
 	/*
 	 * Check to see if we are freeing blocks across a group boundary.
 	 */
-	if (bit + count > (sb->s_blocksize << 3))
-	{
+	if (bit + count > (sb->s_blocksize << 3)) {
 		overflow = bit + count - (sb->s_blocksize << 3);
 		count -= overflow;
 	}
@@ -182,32 +187,31 @@ do_more:
 		goto error_return;
 
 	bh = bitmap->s_block_bitmap[bitmap_nr];
-	for (i=0; i < count; i++)
-	{
-		if (udf_set_bit(bit + i, bh->b_data))
-		{
+	for (i = 0; i < count; i++) {
+		if (udf_set_bit(bit + i, bh->b_data)) {
 			udf_debug("bit %ld already set\n", bit + i);
-			udf_debug("byte=%2x\n", ((char *)bh->b_data)[(bit + i) >> 3]);
-		}
-		else
-		{
+			udf_debug("byte=%2x\n",
+				  ((char *)bh->b_data)[(bit + i) >> 3]);
+		} else {
 			if (inode)
 				DQUOT_FREE_BLOCK(inode, 1);
-			if (UDF_SB_LVIDBH(sb))
-			{
-				UDF_SB_LVID(sb)->freeSpaceTable[UDF_SB_PARTITION(sb)] =
-					cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[UDF_SB_PARTITION(sb)])+1);
+			if (UDF_SB_LVIDBH(sb)) {
+				UDF_SB_LVID(sb)->
+				    freeSpaceTable[UDF_SB_PARTITION(sb)] =
+				    cpu_to_le32(le32_to_cpu
+						(UDF_SB_LVID(sb)->
+						 freeSpaceTable[UDF_SB_PARTITION
+								(sb)]) + 1);
 			}
 		}
 	}
 	mark_buffer_dirty(bh);
-	if (overflow)
-	{
+	if (overflow) {
 		block += count;
 		count = overflow;
 		goto do_more;
 	}
-error_return:
+      error_return:
 	sb->s_dirt = 1;
 	if (UDF_SB_LVIDBH(sb))
 		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
@@ -215,10 +219,11 @@ error_return:
 	return;
 }
 
-static int udf_bitmap_prealloc_blocks(struct super_block * sb,
-	struct inode * inode,
-	struct udf_bitmap *bitmap, uint16_t partition, uint32_t first_block,
-	uint32_t block_count)
+static int udf_bitmap_prealloc_blocks(struct super_block *sb,
+				      struct inode *inode,
+				      struct udf_bitmap *bitmap,
+				      uint16_t partition, uint32_t first_block,
+				      uint32_t block_count)
 {
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	int alloc_count = 0;
@@ -233,9 +238,10 @@ static int udf_bitmap_prealloc_blocks(st
 	if (first_block + block_count > UDF_SB_PARTLEN(sb, partition))
 		block_count = UDF_SB_PARTLEN(sb, partition) - first_block;
 
-repeat:
+      repeat:
 	nr_groups = (UDF_SB_PARTLEN(sb, partition) +
-		(sizeof(struct spaceBitmapDesc) << 3) + (sb->s_blocksize * 8) - 1) / (sb->s_blocksize * 8);
+		     (sizeof(struct spaceBitmapDesc) << 3) +
+		     (sb->s_blocksize * 8) - 1) / (sb->s_blocksize * 8);
 	block = first_block + (sizeof(struct spaceBitmapDesc) << 3);
 	block_group = block >> (sb->s_blocksize_bits + 3);
 	group_start = block_group ? 0 : sizeof(struct spaceBitmapDesc);
@@ -247,31 +253,30 @@ repeat:
 
 	bit = block % (sb->s_blocksize << 3);
 
-	while (bit < (sb->s_blocksize << 3) && block_count > 0)
-	{
+	while (bit < (sb->s_blocksize << 3) && block_count > 0) {
 		if (!udf_test_bit(bit, bh->b_data))
 			goto out;
 		else if (DQUOT_PREALLOC_BLOCK(inode, 1))
 			goto out;
-		else if (!udf_clear_bit(bit, bh->b_data))
-		{
+		else if (!udf_clear_bit(bit, bh->b_data)) {
 			udf_debug("bit already cleared for block %d\n", bit);
 			DQUOT_FREE_BLOCK(inode, 1);
 			goto out;
 		}
-		block_count --;
-		alloc_count ++;
-		bit ++;
-		block ++;
+		block_count--;
+		alloc_count++;
+		bit++;
+		block++;
 	}
 	mark_buffer_dirty(bh);
 	if (block_count > 0)
 		goto repeat;
-out:
-	if (UDF_SB_LVIDBH(sb))
-	{
+      out:
+	if (UDF_SB_LVIDBH(sb)) {
 		UDF_SB_LVID(sb)->freeSpaceTable[partition] =
-			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[partition])-alloc_count);
+		    cpu_to_le32(le32_to_cpu
+				(UDF_SB_LVID(sb)->freeSpaceTable[partition]) -
+				alloc_count);
 		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
 	}
 	sb->s_dirt = 1;
@@ -279,12 +284,13 @@ out:
 	return alloc_count;
 }
 
-static int udf_bitmap_new_block(struct super_block * sb,
-	struct inode * inode,
-	struct udf_bitmap *bitmap, uint16_t partition, uint32_t goal, int *err)
+static int udf_bitmap_new_block(struct super_block *sb,
+				struct inode *inode,
+				struct udf_bitmap *bitmap, uint16_t partition,
+				uint32_t goal, int *err)
 {
 	struct udf_sb_info *sbi = UDF_SB(sb);
-	int newbit, bit=0, block, block_group, group_start;
+	int newbit, bit = 0, block, block_group, group_start;
 	int end_goal, nr_groups, bitmap_nr, i;
 	struct buffer_head *bh = NULL;
 	char *ptr;
@@ -293,7 +299,7 @@ static int udf_bitmap_new_block(struct s
 	*err = -ENOSPC;
 	mutex_lock(&sbi->s_alloc_mutex);
 
-repeat:
+      repeat:
 	if (goal < 0 || goal >= UDF_SB_PARTLEN(sb, partition))
 		goal = 0;
 
@@ -306,38 +312,39 @@ repeat:
 	if (bitmap_nr < 0)
 		goto error_return;
 	bh = bitmap->s_block_bitmap[bitmap_nr];
-	ptr = memscan((char *)bh->b_data + group_start, 0xFF, sb->s_blocksize - group_start);
+	ptr =
+	    memscan((char *)bh->b_data + group_start, 0xFF,
+		    sb->s_blocksize - group_start);
 
-	if ((ptr - ((char *)bh->b_data)) < sb->s_blocksize)
-	{
+	if ((ptr - ((char *)bh->b_data)) < sb->s_blocksize) {
 		bit = block % (sb->s_blocksize << 3);
 
-		if (udf_test_bit(bit, bh->b_data))
-		{
+		if (udf_test_bit(bit, bh->b_data)) {
 			goto got_block;
 		}
 		end_goal = (bit + 63) & ~63;
 		bit = udf_find_next_one_bit(bh->b_data, end_goal, bit);
 		if (bit < end_goal)
 			goto got_block;
-		ptr = memscan((char *)bh->b_data + (bit >> 3), 0xFF, sb->s_blocksize - ((bit + 7) >> 3));
+		ptr =
+		    memscan((char *)bh->b_data + (bit >> 3), 0xFF,
+			    sb->s_blocksize - ((bit + 7) >> 3));
 		newbit = (ptr - ((char *)bh->b_data)) << 3;
-		if (newbit < sb->s_blocksize << 3)
-		{
+		if (newbit < sb->s_blocksize << 3) {
 			bit = newbit;
 			goto search_back;
 		}
-		newbit = udf_find_next_one_bit(bh->b_data, sb->s_blocksize << 3, bit);
-		if (newbit < sb->s_blocksize << 3)
-		{
+		newbit =
+		    udf_find_next_one_bit(bh->b_data, sb->s_blocksize << 3,
+					  bit);
+		if (newbit < sb->s_blocksize << 3) {
 			bit = newbit;
 			goto got_block;
 		}
 	}
 
-	for (i=0; i<(nr_groups*2); i++)
-	{
-		block_group ++;
+	for (i = 0; i < (nr_groups * 2); i++) {
+		block_group++;
 		if (block_group >= nr_groups)
 			block_group = 0;
 		group_start = block_group ? 0 : sizeof(struct spaceBitmapDesc);
@@ -346,67 +353,69 @@ repeat:
 		if (bitmap_nr < 0)
 			goto error_return;
 		bh = bitmap->s_block_bitmap[bitmap_nr];
-		if (i < nr_groups)
-		{
-			ptr = memscan((char *)bh->b_data + group_start, 0xFF, sb->s_blocksize - group_start);
-			if ((ptr - ((char *)bh->b_data)) < sb->s_blocksize)
-			{
+		if (i < nr_groups) {
+			ptr =
+			    memscan((char *)bh->b_data + group_start, 0xFF,
+				    sb->s_blocksize - group_start);
+			if ((ptr - ((char *)bh->b_data)) < sb->s_blocksize) {
 				bit = (ptr - ((char *)bh->b_data)) << 3;
 				break;
 			}
-		}
-		else
-		{
-			bit = udf_find_next_one_bit((char *)bh->b_data, sb->s_blocksize << 3, group_start << 3);
+		} else {
+			bit =
+			    udf_find_next_one_bit((char *)bh->b_data,
+						  sb->s_blocksize << 3,
+						  group_start << 3);
 			if (bit < sb->s_blocksize << 3)
 				break;
 		}
 	}
-	if (i >= (nr_groups*2))
-	{
+	if (i >= (nr_groups * 2)) {
 		mutex_unlock(&sbi->s_alloc_mutex);
 		return newblock;
 	}
 	if (bit < sb->s_blocksize << 3)
 		goto search_back;
 	else
-		bit = udf_find_next_one_bit(bh->b_data, sb->s_blocksize << 3, group_start << 3);
-	if (bit >= sb->s_blocksize << 3)
-	{
+		bit =
+		    udf_find_next_one_bit(bh->b_data, sb->s_blocksize << 3,
+					  group_start << 3);
+	if (bit >= sb->s_blocksize << 3) {
 		mutex_unlock(&sbi->s_alloc_mutex);
 		return 0;
 	}
 
-search_back:
-	for (i=0; i<7 && bit > (group_start << 3) && udf_test_bit(bit - 1, bh->b_data); i++, bit--);
+      search_back:
+	for (i = 0;
+	     i < 7 && bit > (group_start << 3)
+	     && udf_test_bit(bit - 1, bh->b_data); i++, bit--) ;
 
-got_block:
+      got_block:
 
 	/*
 	 * Check quota for allocation of this block.
 	 */
-	if (inode && DQUOT_ALLOC_BLOCK(inode, 1))
-	{
+	if (inode && DQUOT_ALLOC_BLOCK(inode, 1)) {
 		mutex_unlock(&sbi->s_alloc_mutex);
 		*err = -EDQUOT;
 		return 0;
 	}
 
 	newblock = bit + (block_group << (sb->s_blocksize_bits + 3)) -
-		(sizeof(struct spaceBitmapDesc) << 3);
+	    (sizeof(struct spaceBitmapDesc) << 3);
 
-	if (!udf_clear_bit(bit, bh->b_data))
-	{
+	if (!udf_clear_bit(bit, bh->b_data)) {
 		udf_debug("bit already cleared for block %d\n", bit);
 		goto repeat;
 	}
 
 	mark_buffer_dirty(bh);
 
-	if (UDF_SB_LVIDBH(sb))
-	{
+	if (UDF_SB_LVIDBH(sb)) {
 		UDF_SB_LVID(sb)->freeSpaceTable[partition] =
-			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[partition])-1);
+		    cpu_to_le32(le32_to_cpu
+				(UDF_SB_LVID(sb)->freeSpaceTable[partition]) -
+				1);
 		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
 	}
 	sb->s_dirt = 1;
@@ -414,16 +423,17 @@ got_block:
 	*err = 0;
 	return newblock;
 
-error_return:
+      error_return:
 	*err = -EIO;
 	mutex_unlock(&sbi->s_alloc_mutex);
 	return 0;
 }
 
-static void udf_table_free_blocks(struct super_block * sb,
-	struct inode * inode,
-	struct inode * table,
-	kernel_lb_addr bloc, uint32_t offset, uint32_t count)
+static void udf_table_free_blocks(struct super_block *sb,
+				  struct inode *inode,
+				  struct inode *table,
+				  kernel_lb_addr bloc, uint32_t offset,
+				  uint32_t count)
 {
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	uint32_t start, end;
@@ -435,11 +445,14 @@ static void udf_table_free_blocks(struct
 
 	mutex_lock(&sbi->s_alloc_mutex);
 	if (bloc.logicalBlockNum < 0 ||
-		(bloc.logicalBlockNum + count) > UDF_SB_PARTLEN(sb, bloc.partitionReferenceNum))
-	{
-		udf_debug("%d < %d || %d + %d > %d\n",
-			bloc.logicalBlockNum, 0, bloc.logicalBlockNum, count,
-			UDF_SB_PARTLEN(sb, bloc.partitionReferenceNum));
+	    (bloc.logicalBlockNum + count) > UDF_SB_PARTLEN(sb,
+							    bloc.
+							    partitionReferenceNum))
+	{
+		udf_debug("%d < %d || %d + %d > %d\n", bloc.logicalBlockNum, 0,
+			  bloc.logicalBlockNum, count, UDF_SB_PARTLEN(sb,
+								      bloc.
+								      partitionReferenceNum));
 		goto error_return;
 	}
 
@@ -447,10 +460,11 @@ static void udf_table_free_blocks(struct
 	   but.. oh well */
 	if (inode)
 		DQUOT_FREE_BLOCK(inode, count);
-	if (UDF_SB_LVIDBH(sb))
-	{
+	if (UDF_SB_LVIDBH(sb)) {
 		UDF_SB_LVID(sb)->freeSpaceTable[UDF_SB_PARTITION(sb)] =
-			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[UDF_SB_PARTITION(sb)])+count);
+		    cpu_to_le32(le32_to_cpu
+				(UDF_SB_LVID(sb)->
+				 freeSpaceTable[UDF_SB_PARTITION(sb)]) + count);
 		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
 	}
 
@@ -463,73 +477,75 @@ static void udf_table_free_blocks(struct
 	epos.bh = oepos.bh = NULL;
 
 	while (count && (etype =
-		udf_next_aext(table, &epos, &eloc, &elen, 1)) != -1)
-	{
+			 udf_next_aext(table, &epos, &eloc, &elen, 1)) != -1) {
 		if (((eloc.logicalBlockNum + (elen >> sb->s_blocksize_bits)) ==
-			start))
-		{
-			if ((0x3FFFFFFF - elen) < (count << sb->s_blocksize_bits))
-			{
-				count -= ((0x3FFFFFFF - elen) >> sb->s_blocksize_bits);
-				start += ((0x3FFFFFFF - elen) >> sb->s_blocksize_bits);
-				elen = (etype << 30) | (0x40000000 - sb->s_blocksize);
-			}
-			else
-			{
+		     start)) {
+			if ((0x3FFFFFFF - elen) <
+			    (count << sb->s_blocksize_bits)) {
+				count -=
+				    ((0x3FFFFFFF -
+				      elen) >> sb->s_blocksize_bits);
+				start +=
+				    ((0x3FFFFFFF -
+				      elen) >> sb->s_blocksize_bits);
+				elen =
+				    (etype << 30) | (0x40000000 -
+						     sb->s_blocksize);
+			} else {
 				elen = (etype << 30) |
-					(elen + (count << sb->s_blocksize_bits));
+				    (elen + (count << sb->s_blocksize_bits));
 				start += count;
 				count = 0;
 			}
 			udf_write_aext(table, &oepos, eloc, elen, 1);
-		}
-		else if (eloc.logicalBlockNum == (end + 1))
-		{
-			if ((0x3FFFFFFF - elen) < (count << sb->s_blocksize_bits))
-			{
-				count -= ((0x3FFFFFFF - elen) >> sb->s_blocksize_bits);
-				end -= ((0x3FFFFFFF - elen) >> sb->s_blocksize_bits);
+		} else if (eloc.logicalBlockNum == (end + 1)) {
+			if ((0x3FFFFFFF - elen) <
+			    (count << sb->s_blocksize_bits)) {
+				count -=
+				    ((0x3FFFFFFF -
+				      elen) >> sb->s_blocksize_bits);
+				end -=
+				    ((0x3FFFFFFF -
+				      elen) >> sb->s_blocksize_bits);
 				eloc.logicalBlockNum -=
-					((0x3FFFFFFF - elen) >> sb->s_blocksize_bits);
-				elen = (etype << 30) | (0x40000000 - sb->s_blocksize);
-			}
-			else
-			{
+				    ((0x3FFFFFFF -
+				      elen) >> sb->s_blocksize_bits);
+				elen =
+				    (etype << 30) | (0x40000000 -
+						     sb->s_blocksize);
+			} else {
 				eloc.logicalBlockNum = start;
 				elen = (etype << 30) |
-					(elen + (count << sb->s_blocksize_bits));
+				    (elen + (count << sb->s_blocksize_bits));
 				end -= count;
 				count = 0;
 			}
 			udf_write_aext(table, &oepos, eloc, elen, 1);
 		}
 
-		if (epos.bh != oepos.bh)
-		{
+		if (epos.bh != oepos.bh) {
 			i = -1;
 			oepos.block = epos.block;
 			brelse(oepos.bh);
 			get_bh(epos.bh);
 			oepos.bh = epos.bh;
 			oepos.offset = 0;
-		}
-		else
+		} else
 			oepos.offset = epos.offset;
 	}
 
-	if (count)
-	{
+	if (count) {
 		/* NOTE: we CANNOT use udf_add_aext here, as it can try to allocate
-				 a new block, and since we hold the super block lock already
-				 very bad things would happen :)
+		   a new block, and since we hold the super block lock already
+		   very bad things would happen :)
 
-				 We copy the behavior of udf_add_aext, but instead of
-				 trying to allocate a new block close to the existing one,
-				 we just steal a block from the extent we are trying to add.
-
-				 It would be nice if the blocks were close together, but it
-				 isn't required.
-		*/
+		   We copy the behavior of udf_add_aext, but instead of
+		   trying to allocate a new block close to the existing one,
+		   we just steal a block from the extent we are trying to add.
+
+		   It would be nice if the blocks were close together, but it
+		   isn't required.
+		 */
 
 		int adsize;
 		short_ad *sad = NULL;
@@ -537,121 +553,124 @@ static void udf_table_free_blocks(struct
 		struct allocExtDesc *aed;
 
 		eloc.logicalBlockNum = start;
-		elen = EXT_RECORDED_ALLOCATED |
-			(count << sb->s_blocksize_bits);
+		elen = EXT_RECORDED_ALLOCATED | (count << sb->s_blocksize_bits);
 
 		if (UDF_I_ALLOCTYPE(table) == ICBTAG_FLAG_AD_SHORT)
 			adsize = sizeof(short_ad);
 		else if (UDF_I_ALLOCTYPE(table) == ICBTAG_FLAG_AD_LONG)
 			adsize = sizeof(long_ad);
-		else
-		{
+		else {
 			brelse(oepos.bh);
 			brelse(epos.bh);
 			goto error_return;
 		}
 
-		if (epos.offset + (2 * adsize) > sb->s_blocksize)
-		{
+		if (epos.offset + (2 * adsize) > sb->s_blocksize) {
 			char *sptr, *dptr;
 			int loffset;
-	
+
 			brelse(oepos.bh);
 			oepos = epos;
 
 			/* Steal a block from the extent being free'd */
 			epos.block.logicalBlockNum = eloc.logicalBlockNum;
-			eloc.logicalBlockNum ++;
+			eloc.logicalBlockNum++;
 			elen -= sb->s_blocksize;
 
 			if (!(epos.bh = udf_tread(sb,
-				udf_get_lb_pblock(sb, epos.block, 0))))
-			{
+						  udf_get_lb_pblock(sb,
+								    epos.block,
+								    0)))) {
 				brelse(oepos.bh);
 				goto error_return;
 			}
 			aed = (struct allocExtDesc *)(epos.bh->b_data);
-			aed->previousAllocExtLocation = cpu_to_le32(oepos.block.logicalBlockNum);
-			if (epos.offset + adsize > sb->s_blocksize)
-			{
+			aed->previousAllocExtLocation =
+			    cpu_to_le32(oepos.block.logicalBlockNum);
+			if (epos.offset + adsize > sb->s_blocksize) {
 				loffset = epos.offset;
 				aed->lengthAllocDescs = cpu_to_le32(adsize);
 				sptr = UDF_I_DATA(inode) + epos.offset -
-					udf_file_entry_alloc_offset(inode) +
-					UDF_I_LENEATTR(inode) - adsize;
-				dptr = epos.bh->b_data + sizeof(struct allocExtDesc);
+				    udf_file_entry_alloc_offset(inode) +
+				    UDF_I_LENEATTR(inode) - adsize;
+				dptr =
+				    epos.bh->b_data +
+				    sizeof(struct allocExtDesc);
 				memcpy(dptr, sptr, adsize);
-				epos.offset = sizeof(struct allocExtDesc) + adsize;
-			}
-			else
-			{
+				epos.offset =
+				    sizeof(struct allocExtDesc) + adsize;
+			} else {
 				loffset = epos.offset + adsize;
 				aed->lengthAllocDescs = cpu_to_le32(0);
 				sptr = oepos.bh->b_data + epos.offset;
 				epos.offset = sizeof(struct allocExtDesc);
 
-				if (oepos.bh)
-				{
-					aed = (struct allocExtDesc *)oepos.bh->b_data;
+				if (oepos.bh) {
+					aed =
+					    (struct allocExtDesc *)oepos.bh->
+					    b_data;
 					aed->lengthAllocDescs =
-						cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) + adsize);
-				}
-				else
-				{
+					    cpu_to_le32(le32_to_cpu
+							(aed->
+							 lengthAllocDescs) +
+							adsize);
+				} else {
 					UDF_I_LENALLOC(table) += adsize;
 					mark_inode_dirty(table);
 				}
 			}
 			if (UDF_SB_UDFREV(sb) >= 0x0200)
-				udf_new_tag(epos.bh->b_data, TAG_IDENT_AED, 3, 1,
-					epos.block.logicalBlockNum, sizeof(tag));
+				udf_new_tag(epos.bh->b_data, TAG_IDENT_AED, 3,
+					    1, epos.block.logicalBlockNum,
+					    sizeof(tag));
 			else
-				udf_new_tag(epos.bh->b_data, TAG_IDENT_AED, 2, 1,
-					epos.block.logicalBlockNum, sizeof(tag));
-			switch (UDF_I_ALLOCTYPE(table))
-			{
-				case ICBTAG_FLAG_AD_SHORT:
+				udf_new_tag(epos.bh->b_data, TAG_IDENT_AED, 2,
+					    1, epos.block.logicalBlockNum,
+					    sizeof(tag));
+			switch (UDF_I_ALLOCTYPE(table)) {
+			case ICBTAG_FLAG_AD_SHORT:
 				{
-					sad = (short_ad *)sptr;
-					sad->extLength = cpu_to_le32(
-						EXT_NEXT_EXTENT_ALLOCDECS |
-						sb->s_blocksize);
-					sad->extPosition = cpu_to_le32(epos.block.logicalBlockNum);
+					sad = (short_ad *) sptr;
+					sad->extLength =
+					    cpu_to_le32
+					    (EXT_NEXT_EXTENT_ALLOCDECS | sb->
+					     s_blocksize);
+					sad->extPosition =
+					    cpu_to_le32(epos.block.
+							logicalBlockNum);
 					break;
 				}
-				case ICBTAG_FLAG_AD_LONG:
+			case ICBTAG_FLAG_AD_LONG:
 				{
-					lad = (long_ad *)sptr;
-					lad->extLength = cpu_to_le32(
-						EXT_NEXT_EXTENT_ALLOCDECS |
-						sb->s_blocksize);
-					lad->extLocation = cpu_to_lelb(epos.block);
+					lad = (long_ad *) sptr;
+					lad->extLength =
+					    cpu_to_le32
+					    (EXT_NEXT_EXTENT_ALLOCDECS | sb->
+					     s_blocksize);
+					lad->extLocation =
+					    cpu_to_lelb(epos.block);
 					break;
 				}
 			}
-			if (oepos.bh)
-			{
+			if (oepos.bh) {
 				udf_update_tag(oepos.bh->b_data, loffset);
 				mark_buffer_dirty(oepos.bh);
-			}
-			else
+			} else
 				mark_inode_dirty(table);
 		}
 
-		if (elen) /* It's possible that stealing the block emptied the extent */
-		{
+		if (elen) {	/* It's possible that stealing the block emptied the extent */
 			udf_write_aext(table, &epos, eloc, elen, 1);
 
-			if (!epos.bh)
-			{
+			if (!epos.bh) {
 				UDF_I_LENALLOC(table) += adsize;
 				mark_inode_dirty(table);
-			}
-			else
-			{
+			} else {
 				aed = (struct allocExtDesc *)epos.bh->b_data;
 				aed->lengthAllocDescs =
-					cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) + adsize);
+				    cpu_to_le32(le32_to_cpu
+						(aed->lengthAllocDescs) +
+						adsize);
 				udf_update_tag(epos.bh->b_data, epos.offset);
 				mark_buffer_dirty(epos.bh);
 			}
@@ -661,16 +680,16 @@ static void udf_table_free_blocks(struct
 	brelse(epos.bh);
 	brelse(oepos.bh);
 
-error_return:
+      error_return:
 	sb->s_dirt = 1;
 	mutex_unlock(&sbi->s_alloc_mutex);
 	return;
 }
 
-static int udf_table_prealloc_blocks(struct super_block * sb,
-	struct inode * inode,
-	struct inode *table, uint16_t partition, uint32_t first_block,
-	uint32_t block_count)
+static int udf_table_prealloc_blocks(struct super_block *sb,
+				     struct inode *inode,
+				     struct inode *table, uint16_t partition,
+				     uint32_t first_block, uint32_t block_count)
 {
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	int alloc_count = 0;
@@ -696,39 +715,46 @@ static int udf_table_prealloc_blocks(str
 	eloc.logicalBlockNum = 0xFFFFFFFF;
 
 	while (first_block != eloc.logicalBlockNum && (etype =
-		udf_next_aext(table, &epos, &eloc, &elen, 1)) != -1)
-	{
+						       udf_next_aext(table,
+								     &epos,
+								     &eloc,
+								     &elen,
+								     1)) !=
+	       -1) {
 		udf_debug("eloc=%d, elen=%d, first_block=%d\n",
-			eloc.logicalBlockNum, elen, first_block);
-		; /* empty loop body */
+			  eloc.logicalBlockNum, elen, first_block);
+		;		/* empty loop body */
 	}
 
-	if (first_block == eloc.logicalBlockNum)
-	{
+	if (first_block == eloc.logicalBlockNum) {
 		epos.offset -= adsize;
 
 		alloc_count = (elen >> sb->s_blocksize_bits);
-		if (inode && DQUOT_PREALLOC_BLOCK(inode, alloc_count > block_count ? block_count : alloc_count))
+		if (inode
+		    && DQUOT_PREALLOC_BLOCK(inode,
+					    alloc_count >
+					    block_count ? block_count :
+					    alloc_count))
 			alloc_count = 0;
-		else if (alloc_count > block_count)
-		{
+		else if (alloc_count > block_count) {
 			alloc_count = block_count;
 			eloc.logicalBlockNum += alloc_count;
 			elen -= (alloc_count << sb->s_blocksize_bits);
-			udf_write_aext(table, &epos, eloc, (etype << 30) | elen, 1);
-		}
-		else
-			udf_delete_aext(table, epos, eloc, (etype << 30) | elen);
-	}
-	else
+			udf_write_aext(table, &epos, eloc, (etype << 30) | elen,
+				       1);
+		} else
+			udf_delete_aext(table, epos, eloc,
+					(etype << 30) | elen);
+	} else
 		alloc_count = 0;
 
 	brelse(epos.bh);
 
-	if (alloc_count && UDF_SB_LVIDBH(sb))
-	{
+	if (alloc_count && UDF_SB_LVIDBH(sb)) {
 		UDF_SB_LVID(sb)->freeSpaceTable[partition] =
-			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[partition])-alloc_count);
+		    cpu_to_le32(le32_to_cpu
+				(UDF_SB_LVID(sb)->freeSpaceTable[partition]) -
+				alloc_count);
 		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
 		sb->s_dirt = 1;
 	}
@@ -736,9 +762,10 @@ static int udf_table_prealloc_blocks(str
 	return alloc_count;
 }
 
-static int udf_table_new_block(struct super_block * sb,
-	struct inode * inode,
-	struct inode *table, uint16_t partition, uint32_t goal, int *err)
+static int udf_table_new_block(struct super_block *sb,
+			       struct inode *inode,
+			       struct inode *table, uint16_t partition,
+			       uint32_t goal, int *err)
 {
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	uint32_t spread = 0xFFFFFFFF, nspread = 0xFFFFFFFF;
@@ -765,30 +792,27 @@ static int udf_table_new_block(struct su
 	   we stop. Otherwise we keep going till we run out of extents.
 	   We store the buffer_head, bloc, and extoffset of the current closest
 	   match and use that when we are done.
-	*/
+	 */
 	epos.offset = sizeof(struct unallocSpaceEntry);
 	epos.block = UDF_I_LOCATION(table);
 	epos.bh = goal_epos.bh = NULL;
 
 	while (spread && (etype =
-		udf_next_aext(table, &epos, &eloc, &elen, 1)) != -1)
-	{
-		if (goal >= eloc.logicalBlockNum)
-		{
-			if (goal < eloc.logicalBlockNum + (elen >> sb->s_blocksize_bits))
+			  udf_next_aext(table, &epos, &eloc, &elen, 1)) != -1) {
+		if (goal >= eloc.logicalBlockNum) {
+			if (goal <
+			    eloc.logicalBlockNum +
+			    (elen >> sb->s_blocksize_bits))
 				nspread = 0;
 			else
 				nspread = goal - eloc.logicalBlockNum -
-					(elen >> sb->s_blocksize_bits);
-		}
-		else
+				    (elen >> sb->s_blocksize_bits);
+		} else
 			nspread = eloc.logicalBlockNum - goal;
 
-		if (nspread < spread)
-		{
+		if (nspread < spread) {
 			spread = nspread;
-			if (goal_epos.bh != epos.bh)
-			{
+			if (goal_epos.bh != epos.bh) {
 				brelse(goal_epos.bh);
 				goal_epos.bh = epos.bh;
 				get_bh(goal_epos.bh);
@@ -802,8 +826,7 @@ static int udf_table_new_block(struct su
 
 	brelse(epos.bh);
 
-	if (spread == 0xFFFFFFFF)
-	{
+	if (spread == 0xFFFFFFFF) {
 		brelse(goal_epos.bh);
 		mutex_unlock(&sbi->s_alloc_mutex);
 		return 0;
@@ -815,11 +838,10 @@ static int udf_table_new_block(struct su
 	/* This works, but very poorly.... */
 
 	newblock = goal_eloc.logicalBlockNum;
-	goal_eloc.logicalBlockNum ++;
+	goal_eloc.logicalBlockNum++;
 	goal_elen -= sb->s_blocksize;
 
-	if (inode && DQUOT_ALLOC_BLOCK(inode, 1))
-	{
+	if (inode && DQUOT_ALLOC_BLOCK(inode, 1)) {
 		brelse(goal_epos.bh);
 		mutex_unlock(&sbi->s_alloc_mutex);
 		*err = -EDQUOT;
@@ -832,10 +854,11 @@ static int udf_table_new_block(struct su
 		udf_delete_aext(table, goal_epos, goal_eloc, goal_elen);
 	brelse(goal_epos.bh);
 
-	if (UDF_SB_LVIDBH(sb))
-	{
+	if (UDF_SB_LVIDBH(sb)) {
 		UDF_SB_LVID(sb)->freeSpaceTable[partition] =
-			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[partition])-1);
+		    cpu_to_le32(le32_to_cpu
+				(UDF_SB_LVID(sb)->freeSpaceTable[partition]) -
+				1);
 		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
 	}
 
@@ -845,105 +868,99 @@ static int udf_table_new_block(struct su
 	return newblock;
 }
 
-inline void udf_free_blocks(struct super_block * sb,
-	struct inode * inode,
-	kernel_lb_addr bloc, uint32_t offset, uint32_t count)
+inline void udf_free_blocks(struct super_block *sb,
+			    struct inode *inode,
+			    kernel_lb_addr bloc, uint32_t offset,
+			    uint32_t count)
 {
 	uint16_t partition = bloc.partitionReferenceNum;
 
-	if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_BITMAP)
-	{
+	if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_BITMAP) {
 		return udf_bitmap_free_blocks(sb, inode,
-			UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_bitmap,
-			bloc, offset, count);
-	}
-	else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_TABLE)
-	{
+					      UDF_SB_PARTMAPS(sb)[partition].
+					      s_uspace.s_bitmap, bloc, offset,
+					      count);
+	} else if (UDF_SB_PARTFLAGS(sb, partition) &
+		   UDF_PART_FLAG_UNALLOC_TABLE) {
 		return udf_table_free_blocks(sb, inode,
-			UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_table,
-			bloc, offset, count);
-	}
-	else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_BITMAP)
-	{
+					     UDF_SB_PARTMAPS(sb)[partition].
+					     s_uspace.s_table, bloc, offset,
+					     count);
+	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_BITMAP) {
 		return udf_bitmap_free_blocks(sb, inode,
-			UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_bitmap,
-			bloc, offset, count);
-	}
-	else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_TABLE)
-	{
+					      UDF_SB_PARTMAPS(sb)[partition].
+					      s_fspace.s_bitmap, bloc, offset,
+					      count);
+	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_TABLE) {
 		return udf_table_free_blocks(sb, inode,
-			UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_table,
-			bloc, offset, count);
-	}
-	else
+					     UDF_SB_PARTMAPS(sb)[partition].
+					     s_fspace.s_table, bloc, offset,
+					     count);
+	} else
 		return;
 }
 
-inline int udf_prealloc_blocks(struct super_block * sb,
-	struct inode * inode,
-	uint16_t partition, uint32_t first_block, uint32_t block_count)
+inline int udf_prealloc_blocks(struct super_block *sb,
+			       struct inode *inode,
+			       uint16_t partition, uint32_t first_block,
+			       uint32_t block_count)
 {
-	if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_BITMAP)
-	{
+	if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_BITMAP) {
 		return udf_bitmap_prealloc_blocks(sb, inode,
-			UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_bitmap,
-			partition, first_block, block_count);
-	}
-	else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_TABLE)
-	{
+						  UDF_SB_PARTMAPS(sb)
+						  [partition].s_uspace.s_bitmap,
+						  partition, first_block,
+						  block_count);
+	} else if (UDF_SB_PARTFLAGS(sb, partition) &
+		   UDF_PART_FLAG_UNALLOC_TABLE) {
 		return udf_table_prealloc_blocks(sb, inode,
-			UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_table,
-			partition, first_block, block_count);
-	}
-	else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_BITMAP)
-	{
+						 UDF_SB_PARTMAPS(sb)[partition].
+						 s_uspace.s_table, partition,
+						 first_block, block_count);
+	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_BITMAP) {
 		return udf_bitmap_prealloc_blocks(sb, inode,
-			UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_bitmap,
-			partition, first_block, block_count);
-	}
-	else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_TABLE)
-	{
+						  UDF_SB_PARTMAPS(sb)
+						  [partition].s_fspace.s_bitmap,
+						  partition, first_block,
+						  block_count);
+	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_TABLE) {
 		return udf_table_prealloc_blocks(sb, inode,
-			UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_table,
-			partition, first_block, block_count);
-	}
-	else
+						 UDF_SB_PARTMAPS(sb)[partition].
+						 s_fspace.s_table, partition,
+						 first_block, block_count);
+	} else
 		return 0;
 }
 
-inline int udf_new_block(struct super_block * sb,
-	struct inode * inode,
-	uint16_t partition, uint32_t goal, int *err)
+inline int udf_new_block(struct super_block *sb,
+			 struct inode *inode,
+			 uint16_t partition, uint32_t goal, int *err)
 {
 	int ret;
 
-	if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_BITMAP)
-	{
+	if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_BITMAP) {
 		ret = udf_bitmap_new_block(sb, inode,
-			UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_bitmap,
-			partition, goal, err);
+					   UDF_SB_PARTMAPS(sb)[partition].
+					   s_uspace.s_bitmap, partition, goal,
+					   err);
 		return ret;
-	}
-	else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_TABLE)
-	{
+	} else if (UDF_SB_PARTFLAGS(sb, partition) &
+		   UDF_PART_FLAG_UNALLOC_TABLE) {
 		return udf_table_new_block(sb, inode,
-			UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_table,
-			partition, goal, err);
-	}
-	else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_BITMAP)
-	{
+					   UDF_SB_PARTMAPS(sb)[partition].
+					   s_uspace.s_table, partition, goal,
+					   err);
+	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_BITMAP) {
 		return udf_bitmap_new_block(sb, inode,
-			UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_bitmap,
-			partition, goal, err);
-	}
-	else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_TABLE)
-	{
+					    UDF_SB_PARTMAPS(sb)[partition].
+					    s_fspace.s_bitmap, partition, goal,
+					    err);
+	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_TABLE) {
 		return udf_table_new_block(sb, inode,
-			UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_table,
-			partition, goal, err);
-	}
-	else
-	{
+					   UDF_SB_PARTMAPS(sb)[partition].
+					   s_fspace.s_table, partition, goal,
+					   err);
+	} else {
 		*err = -EIO;
 		return 0;
 	}
diff -puN fs/udf/crc.c~udf-coding-style-conversion-lindent fs/udf/crc.c
--- a/fs/udf/crc.c~udf-coding-style-conversion-lindent
+++ a/fs/udf/crc.c
@@ -79,8 +79,7 @@ static uint16_t crc_table[256] = {
  *	July 21, 1997 - Andrew E. Mileski
  *	Adapted from OSTA-UDF(tm) 1.50 standard.
  */
-uint16_t
-udf_crc(uint8_t *data, uint32_t size, uint16_t crc)
+uint16_t udf_crc(uint8_t * data, uint32_t size, uint16_t crc)
 {
 	while (size--)
 		crc = crc_table[(crc >> 8 ^ *(data++)) & 0xffU] ^ (crc << 8);
@@ -112,7 +111,7 @@ int main(void)
 	return 0;
 }
 
-#endif /* defined(TEST) */
+#endif				/* defined(TEST) */
 
 /****************************************************************************/
 #if defined(GENERATE)
@@ -138,7 +137,7 @@ int main(int argc, char **argv)
 
 	/* Get the polynomial */
 	sscanf(argv[1], "%lo", &poly);
-	if (poly & 0xffff0000U){
+	if (poly & 0xffff0000U) {
 		fprintf(stderr, "polynomial is too large\en");
 		exit(1);
 	}
@@ -147,22 +146,22 @@ int main(int argc, char **argv)
 
 	/* Create a table */
 	printf("static unsigned short crc_table[256] = {\n");
-	for (n = 0; n < 256; n++){
+	for (n = 0; n < 256; n++) {
 		if (n % 8 == 0)
 			printf("\t");
 		crc = n << 8;
-		for (i = 0; i < 8; i++){
-			if(crc & 0x8000U)
+		for (i = 0; i < 8; i++) {
+			if (crc & 0x8000U)
 				crc = (crc << 1) ^ poly;
 			else
 				crc <<= 1;
-		crc &= 0xFFFFU;
+			crc &= 0xFFFFU;
 		}
 		if (n == 255)
 			printf("0x%04xU ", crc);
 		else
 			printf("0x%04xU, ", crc);
-		if(n % 8 == 7)
+		if (n % 8 == 7)
 			printf("\n");
 	}
 	printf("};\n");
@@ -170,4 +169,4 @@ int main(int argc, char **argv)
 	return 0;
 }
 
-#endif /* defined(GENERATE) */
+#endif				/* defined(GENERATE) */
diff -puN fs/udf/dir.c~udf-coding-style-conversion-lindent fs/udf/dir.c
--- a/fs/udf/dir.c~udf-coding-style-conversion-lindent
+++ a/fs/udf/dir.c
@@ -43,10 +43,10 @@ static int do_udf_readdir(struct inode *
 /* readdir and lookup functions */
 
 const struct file_operations udf_dir_operations = {
-	.read			= generic_read_dir,
-	.readdir		= udf_readdir,
-	.ioctl			= udf_ioctl,
-	.fsync			= udf_fsync_file,
+	.read = generic_read_dir,
+	.readdir = udf_readdir,
+	.ioctl = udf_ioctl,
+	.fsync = udf_fsync_file,
 };
 
 /*
@@ -82,26 +82,26 @@ int udf_readdir(struct file *filp, void 
 
 	lock_kernel();
 
-	if ( filp->f_pos == 0 ) 
-	{
-		if (filldir(dirent, ".", 1, filp->f_pos, dir->i_ino, DT_DIR) < 0)
-		{
+	if (filp->f_pos == 0) {
+		if (filldir(dirent, ".", 1, filp->f_pos, dir->i_ino, DT_DIR) <
+		    0) {
 			unlock_kernel();
 			return 0;
 		}
-		filp->f_pos ++;
+		filp->f_pos++;
 	}
 
 	result = do_udf_readdir(dir, filp, filldir, dirent);
 	unlock_kernel();
- 	return result;
+	return result;
 }
 
-static int 
-do_udf_readdir(struct inode * dir, struct file *filp, filldir_t filldir, void *dirent)
+static int
+do_udf_readdir(struct inode *dir, struct file *filp, filldir_t filldir,
+	       void *dirent)
 {
 	struct udf_fileident_bh fibh;
-	struct fileIdentDesc *fi=NULL;
+	struct fileIdentDesc *fi = NULL;
 	struct fileIdentDesc cfi;
 	int block, iblock;
 	loff_t nf_pos = filp->f_pos - 1;
@@ -117,7 +117,7 @@ do_udf_readdir(struct inode * dir, struc
 	sector_t offset;
 	int i, num;
 	unsigned int dt_type;
-	struct extent_position epos = { NULL, 0, {0, 0}};
+	struct extent_position epos = { NULL, 0, {0, 0} };
 
 	if (nf_pos >= size)
 		return 0;
@@ -125,65 +125,61 @@ do_udf_readdir(struct inode * dir, struc
 	if (nf_pos == 0)
 		nf_pos = (udf_ext0_offset(dir) >> 2);
 
-	fibh.soffset = fibh.eoffset = (nf_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
+	fibh.soffset = fibh.eoffset =
+	    (nf_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
 	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
 		fibh.sbh = fibh.ebh = NULL;
 	else if (inode_bmap(dir, nf_pos >> (dir->i_sb->s_blocksize_bits - 2),
-		&epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30))
-	{
+			    &epos, &eloc, &elen,
+			    &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
-		if ((++offset << dir->i_sb->s_blocksize_bits) < elen)
-		{
+		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
 			if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_SHORT)
 				epos.offset -= sizeof(short_ad);
 			else if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_LONG)
 				epos.offset -= sizeof(long_ad);
-		}
-		else
+		} else
 			offset = 0;
 
-		if (!(fibh.sbh = fibh.ebh = udf_tread(dir->i_sb, block)))
-		{
+		if (!(fibh.sbh = fibh.ebh = udf_tread(dir->i_sb, block))) {
 			brelse(epos.bh);
 			return -EIO;
 		}
-	
-		if (!(offset & ((16 >> (dir->i_sb->s_blocksize_bits - 9))-1)))
-		{
+
+		if (!(offset & ((16 >> (dir->i_sb->s_blocksize_bits - 9)) - 1))) {
 			i = 16 >> (dir->i_sb->s_blocksize_bits - 9);
-			if (i+offset > (elen >> dir->i_sb->s_blocksize_bits))
-				i = (elen >> dir->i_sb->s_blocksize_bits)-offset;
-			for (num=0; i>0; i--)
-			{
-				block = udf_get_lb_pblock(dir->i_sb, eloc, offset+i);
+			if (i + offset > (elen >> dir->i_sb->s_blocksize_bits))
+				i = (elen >> dir->i_sb->s_blocksize_bits) -
+				    offset;
+			for (num = 0; i > 0; i--) {
+				block =
+				    udf_get_lb_pblock(dir->i_sb, eloc,
+						      offset + i);
 				tmp = udf_tgetblk(dir->i_sb, block);
-				if (tmp && !buffer_uptodate(tmp) && !buffer_locked(tmp))
+				if (tmp && !buffer_uptodate(tmp)
+				    && !buffer_locked(tmp))
 					bha[num++] = tmp;
 				else
 					brelse(tmp);
 			}
-			if (num)
-			{
+			if (num) {
 				ll_rw_block(READA, num, bha);
-				for (i=0; i<num; i++)
+				for (i = 0; i < num; i++)
 					brelse(bha[i]);
 			}
 		}
-	}
-	else
-	{
+	} else {
 		brelse(epos.bh);
 		return -ENOENT;
 	}
 
-	while ( nf_pos < size )
-	{
+	while (nf_pos < size) {
 		filp->f_pos = nf_pos + 1;
 
-		fi = udf_fileident_read(dir, &nf_pos, &fibh, &cfi, &epos, &eloc, &elen, &offset);
+		fi = udf_fileident_read(dir, &nf_pos, &fibh, &cfi, &epos, &eloc,
+					&elen, &offset);
 
-		if (!fi)
-		{
+		if (!fi) {
 			if (fibh.sbh != fibh.ebh)
 				brelse(fibh.ebh);
 			brelse(fibh.sbh);
@@ -196,43 +192,41 @@ do_udf_readdir(struct inode * dir, struc
 
 		if (fibh.sbh == fibh.ebh)
 			nameptr = fi->fileIdent + liu;
-		else
-		{
+		else {
 			int poffset;	/* Unpaded ending offset */
 
-			poffset = fibh.soffset + sizeof(struct fileIdentDesc) + liu + lfi;
+			poffset =
+			    fibh.soffset + sizeof(struct fileIdentDesc) + liu +
+			    lfi;
 
 			if (poffset >= lfi)
-				nameptr = (char *)(fibh.ebh->b_data + poffset - lfi);
-			else
-			{
+				nameptr =
+				    (char *)(fibh.ebh->b_data + poffset - lfi);
+			else {
 				nameptr = fname;
-				memcpy(nameptr, fi->fileIdent + liu, lfi - poffset);
-				memcpy(nameptr + lfi - poffset, fibh.ebh->b_data, poffset);
+				memcpy(nameptr, fi->fileIdent + liu,
+				       lfi - poffset);
+				memcpy(nameptr + lfi - poffset,
+				       fibh.ebh->b_data, poffset);
 			}
 		}
 
-		if ( (cfi.fileCharacteristics & FID_FILE_CHAR_DELETED) != 0 )
-		{
-			if ( !UDF_QUERY_FLAG(dir->i_sb, UDF_FLAG_UNDELETE) )
+		if ((cfi.fileCharacteristics & FID_FILE_CHAR_DELETED) != 0) {
+			if (!UDF_QUERY_FLAG(dir->i_sb, UDF_FLAG_UNDELETE))
 				continue;
 		}
-		
-		if ( (cfi.fileCharacteristics & FID_FILE_CHAR_HIDDEN) != 0 )
-		{
-			if ( !UDF_QUERY_FLAG(dir->i_sb, UDF_FLAG_UNHIDE) )
+
+		if ((cfi.fileCharacteristics & FID_FILE_CHAR_HIDDEN) != 0) {
+			if (!UDF_QUERY_FLAG(dir->i_sb, UDF_FLAG_UNHIDE))
 				continue;
 		}
 
-		if ( cfi.fileCharacteristics & FID_FILE_CHAR_PARENT )
-		{
+		if (cfi.fileCharacteristics & FID_FILE_CHAR_PARENT) {
 			iblock = parent_ino(filp->f_path.dentry);
 			flen = 2;
 			memcpy(fname, "..", flen);
 			dt_type = DT_DIR;
-		}
-		else
-		{
+		} else {
 			kernel_lb_addr tloc = lelb_to_cpu(cfi.icb.extLocation);
 
 			iblock = udf_get_lb_pblock(dir->i_sb, tloc, 0);
@@ -240,18 +234,18 @@ do_udf_readdir(struct inode * dir, struc
 			dt_type = DT_UNKNOWN;
 		}
 
-		if (flen)
-		{
-			if (filldir(dirent, fname, flen, filp->f_pos, iblock, dt_type) < 0)
-			{
+		if (flen) {
+			if (filldir
+			    (dirent, fname, flen, filp->f_pos, iblock,
+			     dt_type) < 0) {
 				if (fibh.sbh != fibh.ebh)
 					brelse(fibh.ebh);
 				brelse(fibh.sbh);
 				brelse(epos.bh);
-	 			return 0;
+				return 0;
 			}
 		}
-	} /* end while */
+	}			/* end while */
 
 	filp->f_pos = nf_pos + 1;
 
diff -puN fs/udf/directory.c~udf-coding-style-conversion-lindent fs/udf/directory.c
--- a/fs/udf/directory.c~udf-coding-style-conversion-lindent
+++ a/fs/udf/directory.c
@@ -19,10 +19,10 @@
 #include <linux/buffer_head.h>
 
 #if 0
-static uint8_t *
-udf_filead_read(struct inode *dir, uint8_t *tmpad, uint8_t ad_size,
-		kernel_lb_addr fe_loc, int *pos, int *offset,
-		struct buffer_head **bh, int *error)
+static uint8_t *udf_filead_read(struct inode *dir, uint8_t * tmpad,
+				uint8_t ad_size, kernel_lb_addr fe_loc,
+				int *pos, int *offset, struct buffer_head **bh,
+				int *error)
 {
 	int loffset = *offset;
 	int block;
@@ -31,31 +31,27 @@ udf_filead_read(struct inode *dir, uint8
 
 	*error = 0;
 
-	ad = (uint8_t *)(*bh)->b_data + *offset;
+	ad = (uint8_t *) (*bh)->b_data + *offset;
 	*offset += ad_size;
 
-	if (!ad)
-	{
+	if (!ad) {
 		brelse(*bh);
 		*error = 1;
 		return NULL;
 	}
 
-	if (*offset == dir->i_sb->s_blocksize)
-	{
+	if (*offset == dir->i_sb->s_blocksize) {
 		brelse(*bh);
 		block = udf_get_lb_pblock(dir->i_sb, fe_loc, ++*pos);
 		if (!block)
 			return NULL;
 		if (!(*bh = udf_tread(dir->i_sb, block)))
 			return NULL;
-	}
-	else if (*offset > dir->i_sb->s_blocksize)
-	{
+	} else if (*offset > dir->i_sb->s_blocksize) {
 		ad = tmpad;
 
 		remainder = dir->i_sb->s_blocksize - loffset;
-		memcpy((uint8_t *)ad, (*bh)->b_data + loffset, remainder);
+		memcpy((uint8_t *) ad, (*bh)->b_data + loffset, remainder);
 
 		brelse(*bh);
 		block = udf_get_lb_pblock(dir->i_sb, fe_loc, ++*pos);
@@ -64,56 +60,56 @@ udf_filead_read(struct inode *dir, uint8
 		if (!((*bh) = udf_tread(dir->i_sb, block)))
 			return NULL;
 
-		memcpy((uint8_t *)ad + remainder, (*bh)->b_data, ad_size - remainder);
+		memcpy((uint8_t *) ad + remainder, (*bh)->b_data,
+		       ad_size - remainder);
 		*offset = ad_size - remainder;
 	}
 	return ad;
 }
 #endif
 
-struct fileIdentDesc *
-udf_fileident_read(struct inode *dir, loff_t *nf_pos,
-	struct udf_fileident_bh *fibh,
-	struct fileIdentDesc *cfi,
-	struct extent_position *epos,
-	kernel_lb_addr *eloc, uint32_t *elen,
-	sector_t *offset)
+struct fileIdentDesc *udf_fileident_read(struct inode *dir, loff_t * nf_pos,
+					 struct udf_fileident_bh *fibh,
+					 struct fileIdentDesc *cfi,
+					 struct extent_position *epos,
+					 kernel_lb_addr * eloc, uint32_t * elen,
+					 sector_t * offset)
 {
 	struct fileIdentDesc *fi;
 	int i, num, block;
-	struct buffer_head * tmp, * bha[16];
+	struct buffer_head *tmp, *bha[16];
 
 	fibh->soffset = fibh->eoffset;
 
-	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
-	{
+	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
 		fi = udf_get_fileident(UDF_I_DATA(dir) -
-			(UDF_I_EFE(dir) ?
-				sizeof(struct extendedFileEntry) :
-				sizeof(struct fileEntry)),
-			dir->i_sb->s_blocksize, &(fibh->eoffset));
+				       (UDF_I_EFE(dir) ?
+					sizeof(struct extendedFileEntry) :
+					sizeof(struct fileEntry)),
+				       dir->i_sb->s_blocksize,
+				       &(fibh->eoffset));
 
 		if (!fi)
 			return NULL;
 
 		*nf_pos += ((fibh->eoffset - fibh->soffset) >> 2);
 
-		memcpy((uint8_t *)cfi, (uint8_t *)fi, sizeof(struct fileIdentDesc));
+		memcpy((uint8_t *) cfi, (uint8_t *) fi,
+		       sizeof(struct fileIdentDesc));
 
 		return fi;
 	}
 
-	if (fibh->eoffset == dir->i_sb->s_blocksize)
-	{
+	if (fibh->eoffset == dir->i_sb->s_blocksize) {
 		int lextoffset = epos->offset;
 
 		if (udf_next_aext(dir, epos, eloc, elen, 1) !=
-			(EXT_RECORDED_ALLOCATED >> 30))
+		    (EXT_RECORDED_ALLOCATED >> 30))
 			return NULL;
 
 		block = udf_get_lb_pblock(dir->i_sb, *eloc, *offset);
 
-		(*offset) ++;
+		(*offset)++;
 
 		if ((*offset << dir->i_sb->s_blocksize_bits) >= *elen)
 			*offset = 0;
@@ -125,57 +121,57 @@ udf_fileident_read(struct inode *dir, lo
 			return NULL;
 		fibh->soffset = fibh->eoffset = 0;
 
-		if (!(*offset & ((16 >> (dir->i_sb->s_blocksize_bits - 9))-1)))
+		if (!
+		    (*offset & ((16 >> (dir->i_sb->s_blocksize_bits - 9)) - 1)))
 		{
 			i = 16 >> (dir->i_sb->s_blocksize_bits - 9);
-			if (i+*offset > (*elen >> dir->i_sb->s_blocksize_bits))
-				i = (*elen >> dir->i_sb->s_blocksize_bits)-*offset;
-			for (num=0; i>0; i--)
-			{
-				block = udf_get_lb_pblock(dir->i_sb, *eloc, *offset+i);
+			if (i + *offset >
+			    (*elen >> dir->i_sb->s_blocksize_bits))
+				i = (*elen >> dir->i_sb->s_blocksize_bits) -
+				    *offset;
+			for (num = 0; i > 0; i--) {
+				block =
+				    udf_get_lb_pblock(dir->i_sb, *eloc,
+						      *offset + i);
 				tmp = udf_tgetblk(dir->i_sb, block);
-				if (tmp && !buffer_uptodate(tmp) && !buffer_locked(tmp))
+				if (tmp && !buffer_uptodate(tmp)
+				    && !buffer_locked(tmp))
 					bha[num++] = tmp;
 				else
 					brelse(tmp);
 			}
-			if (num)
-			{
+			if (num) {
 				ll_rw_block(READA, num, bha);
-				for (i=0; i<num; i++)
+				for (i = 0; i < num; i++)
 					brelse(bha[i]);
 			}
 		}
-	}
-	else if (fibh->sbh != fibh->ebh)
-	{
+	} else if (fibh->sbh != fibh->ebh) {
 		brelse(fibh->sbh);
 		fibh->sbh = fibh->ebh;
 	}
 
 	fi = udf_get_fileident(fibh->sbh->b_data, dir->i_sb->s_blocksize,
-		&(fibh->eoffset));
+			       &(fibh->eoffset));
 
 	if (!fi)
 		return NULL;
 
 	*nf_pos += ((fibh->eoffset - fibh->soffset) >> 2);
 
-	if (fibh->eoffset <= dir->i_sb->s_blocksize)
-	{
-		memcpy((uint8_t *)cfi, (uint8_t *)fi, sizeof(struct fileIdentDesc));
-	}
-	else if (fibh->eoffset > dir->i_sb->s_blocksize)
-	{
+	if (fibh->eoffset <= dir->i_sb->s_blocksize) {
+		memcpy((uint8_t *) cfi, (uint8_t *) fi,
+		       sizeof(struct fileIdentDesc));
+	} else if (fibh->eoffset > dir->i_sb->s_blocksize) {
 		int lextoffset = epos->offset;
 
 		if (udf_next_aext(dir, epos, eloc, elen, 1) !=
-			(EXT_RECORDED_ALLOCATED >> 30))
+		    (EXT_RECORDED_ALLOCATED >> 30))
 			return NULL;
 
 		block = udf_get_lb_pblock(dir->i_sb, *eloc, *offset);
 
-		(*offset) ++;
+		(*offset)++;
 
 		if ((*offset << dir->i_sb->s_blocksize_bits) >= *elen)
 			*offset = 0;
@@ -188,62 +184,62 @@ udf_fileident_read(struct inode *dir, lo
 		if (!(fibh->ebh = udf_tread(dir->i_sb, block)))
 			return NULL;
 
-		if (sizeof(struct fileIdentDesc) > - fibh->soffset)
-		{
+		if (sizeof(struct fileIdentDesc) > -fibh->soffset) {
 			int fi_len;
 
-			memcpy((uint8_t *)cfi, (uint8_t *)fi, - fibh->soffset);
-			memcpy((uint8_t *)cfi - fibh->soffset, fibh->ebh->b_data,
-				sizeof(struct fileIdentDesc) + fibh->soffset);
-
-			fi_len = (sizeof(struct fileIdentDesc) + cfi->lengthFileIdent +
-				le16_to_cpu(cfi->lengthOfImpUse) + 3) & ~3;
+			memcpy((uint8_t *) cfi, (uint8_t *) fi, -fibh->soffset);
+			memcpy((uint8_t *) cfi - fibh->soffset,
+			       fibh->ebh->b_data,
+			       sizeof(struct fileIdentDesc) + fibh->soffset);
+
+			fi_len =
+			    (sizeof(struct fileIdentDesc) +
+			     cfi->lengthFileIdent +
+			     le16_to_cpu(cfi->lengthOfImpUse) + 3) & ~3;
 
-			*nf_pos += ((fi_len - (fibh->eoffset - fibh->soffset)) >> 2);
+			*nf_pos +=
+			    ((fi_len - (fibh->eoffset - fibh->soffset)) >> 2);
 			fibh->eoffset = fibh->soffset + fi_len;
-		}
-		else
-		{
-			memcpy((uint8_t *)cfi, (uint8_t *)fi, sizeof(struct fileIdentDesc));
+		} else {
+			memcpy((uint8_t *) cfi, (uint8_t *) fi,
+			       sizeof(struct fileIdentDesc));
 		}
 	}
 	return fi;
 }
 
-struct fileIdentDesc * 
-udf_get_fileident(void * buffer, int bufsize, int * offset)
+struct fileIdentDesc *udf_get_fileident(void *buffer, int bufsize, int *offset)
 {
 	struct fileIdentDesc *fi;
 	int lengthThisIdent;
-	uint8_t * ptr;
+	uint8_t *ptr;
 	int padlen;
 
-	if ( (!buffer) || (!offset) ) {
-		udf_debug("invalidparms\n, buffer=%p, offset=%p\n", buffer, offset);
+	if ((!buffer) || (!offset)) {
+		udf_debug("invalidparms\n, buffer=%p, offset=%p\n", buffer,
+			  offset);
 		return NULL;
 	}
 
 	ptr = buffer;
 
-	if ( (*offset > 0) && (*offset < bufsize) ) {
+	if ((*offset > 0) && (*offset < bufsize)) {
 		ptr += *offset;
 	}
-	fi=(struct fileIdentDesc *)ptr;
-	if (le16_to_cpu(fi->descTag.tagIdent) != TAG_IDENT_FID)
-	{
+	fi = (struct fileIdentDesc *)ptr;
+	if (le16_to_cpu(fi->descTag.tagIdent) != TAG_IDENT_FID) {
 		udf_debug("0x%x != TAG_IDENT_FID\n",
-			le16_to_cpu(fi->descTag.tagIdent));
+			  le16_to_cpu(fi->descTag.tagIdent));
 		udf_debug("offset: %u sizeof: %lu bufsize: %u\n",
-			*offset, (unsigned long)sizeof(struct fileIdentDesc), bufsize);
+			  *offset, (unsigned long)sizeof(struct fileIdentDesc),
+			  bufsize);
 		return NULL;
 	}
-	if ( (*offset + sizeof(struct fileIdentDesc)) > bufsize )
-	{
+	if ((*offset + sizeof(struct fileIdentDesc)) > bufsize) {
 		lengthThisIdent = sizeof(struct fileIdentDesc);
-	}
-	else
+	} else
 		lengthThisIdent = sizeof(struct fileIdentDesc) +
-			fi->lengthFileIdent + le16_to_cpu(fi->lengthOfImpUse);
+		    fi->lengthFileIdent + le16_to_cpu(fi->lengthOfImpUse);
 
 	/* we need to figure padding, too! */
 	padlen = lengthThisIdent % UDF_NAME_PAD;
@@ -255,56 +251,53 @@ udf_get_fileident(void * buffer, int buf
 }
 
 #if 0
-static extent_ad *
-udf_get_fileextent(void * buffer, int bufsize, int * offset)
+static extent_ad *udf_get_fileextent(void *buffer, int bufsize, int *offset)
 {
-	extent_ad * ext;
+	extent_ad *ext;
 	struct fileEntry *fe;
-	uint8_t * ptr;
+	uint8_t *ptr;
 
-	if ( (!buffer) || (!offset) )
-	{
+	if ((!buffer) || (!offset)) {
 		printk(KERN_ERR "udf: udf_get_fileextent() invalidparms\n");
 		return NULL;
 	}
 
 	fe = (struct fileEntry *)buffer;
 
-	if ( le16_to_cpu(fe->descTag.tagIdent) != TAG_IDENT_FE )
-	{
+	if (le16_to_cpu(fe->descTag.tagIdent) != TAG_IDENT_FE) {
 		udf_debug("0x%x != TAG_IDENT_FE\n",
-			le16_to_cpu(fe->descTag.tagIdent));
+			  le16_to_cpu(fe->descTag.tagIdent));
 		return NULL;
 	}
 
-	ptr=(uint8_t *)(fe->extendedAttr) + le32_to_cpu(fe->lengthExtendedAttr);
+	ptr =
+	    (uint8_t *) (fe->extendedAttr) +
+	    le32_to_cpu(fe->lengthExtendedAttr);
 
-	if ( (*offset > 0) && (*offset < le32_to_cpu(fe->lengthAllocDescs)) )
-	{
+	if ((*offset > 0) && (*offset < le32_to_cpu(fe->lengthAllocDescs))) {
 		ptr += *offset;
 	}
 
-	ext = (extent_ad *)ptr;
+	ext = (extent_ad *) ptr;
 
 	*offset = *offset + sizeof(extent_ad);
 	return ext;
 }
 #endif
 
-short_ad *
-udf_get_fileshortad(uint8_t *ptr, int maxoffset, int *offset, int inc)
+short_ad *udf_get_fileshortad(uint8_t * ptr, int maxoffset, int *offset,
+			      int inc)
 {
 	short_ad *sa;
 
-	if ( (!ptr) || (!offset) )
-	{
+	if ((!ptr) || (!offset)) {
 		printk(KERN_ERR "udf: udf_get_fileshortad() invalidparms\n");
 		return NULL;
 	}
 
-	if ( (*offset < 0) || ((*offset + sizeof(short_ad)) > maxoffset) )
+	if ((*offset < 0) || ((*offset + sizeof(short_ad)) > maxoffset))
 		return NULL;
-	else if ((sa = (short_ad *)ptr)->extLength == 0)
+	else if ((sa = (short_ad *) ptr)->extLength == 0)
 		return NULL;
 
 	if (inc)
@@ -312,20 +305,18 @@ udf_get_fileshortad(uint8_t *ptr, int ma
 	return sa;
 }
 
-long_ad *
-udf_get_filelongad(uint8_t *ptr, int maxoffset, int * offset, int inc)
+long_ad *udf_get_filelongad(uint8_t * ptr, int maxoffset, int *offset, int inc)
 {
 	long_ad *la;
 
-	if ( (!ptr) || (!offset) ) 
-	{
+	if ((!ptr) || (!offset)) {
 		printk(KERN_ERR "udf: udf_get_filelongad() invalidparms\n");
 		return NULL;
 	}
 
-	if ( (*offset < 0) || ((*offset + sizeof(long_ad)) > maxoffset) )
+	if ((*offset < 0) || ((*offset + sizeof(long_ad)) > maxoffset))
 		return NULL;
-	else if ((la = (long_ad *)ptr)->extLength == 0)
+	else if ((la = (long_ad *) ptr)->extLength == 0)
 		return NULL;
 
 	if (inc)
diff -puN fs/udf/ecma_167.h~udf-coding-style-conversion-lindent fs/udf/ecma_167.h
--- a/fs/udf/ecma_167.h~udf-coding-style-conversion-lindent
+++ a/fs/udf/ecma_167.h
@@ -38,10 +38,9 @@
 #define _ECMA_167_H 1
 
 /* Character set specification (ECMA 167r3 1/7.2.1) */
-typedef struct
-{
-	uint8_t		charSetType;
-	uint8_t		charSetInfo[63];
+typedef struct {
+	uint8_t charSetType;
+	uint8_t charSetInfo[63];
 } __attribute__ ((packed)) charspec;
 
 /* Character Set Type (ECMA 167r3 1/7.2.1.1) */
@@ -55,35 +54,33 @@ typedef struct
 #define CHARSPEC_TYPE_CS7		0x07	/* (1/7.2.9) */
 #define CHARSPEC_TYPE_CS8		0x08	/* (1/7.2.10) */
 
-typedef uint8_t		dstring;
+typedef uint8_t dstring;
 
 /* Timestamp (ECMA 167r3 1/7.3) */
-typedef struct
-{
-	__le16		typeAndTimezone;
-	__le16		year;
-	uint8_t		month;
-	uint8_t		day;
-	uint8_t		hour;
-	uint8_t		minute;
-	uint8_t		second;
-	uint8_t		centiseconds;
-	uint8_t		hundredsOfMicroseconds;
-	uint8_t		microseconds;
+typedef struct {
+	__le16 typeAndTimezone;
+	__le16 year;
+	uint8_t month;
+	uint8_t day;
+	uint8_t hour;
+	uint8_t minute;
+	uint8_t second;
+	uint8_t centiseconds;
+	uint8_t hundredsOfMicroseconds;
+	uint8_t microseconds;
 } __attribute__ ((packed)) timestamp;
 
-typedef struct
-{
-	uint16_t	typeAndTimezone;
-	int16_t		year;
-	uint8_t		month;
-	uint8_t		day;
-	uint8_t		hour;
-	uint8_t		minute;
-	uint8_t		second;
-	uint8_t		centiseconds;
-	uint8_t		hundredsOfMicroseconds;
-	uint8_t		microseconds;
+typedef struct {
+	uint16_t typeAndTimezone;
+	int16_t year;
+	uint8_t month;
+	uint8_t day;
+	uint8_t hour;
+	uint8_t minute;
+	uint8_t second;
+	uint8_t centiseconds;
+	uint8_t hundredsOfMicroseconds;
+	uint8_t microseconds;
 } __attribute__ ((packed)) kernel_timestamp;
 
 /* Type and Time Zone (ECMA 167r3 1/7.3.1) */
@@ -94,11 +91,10 @@ typedef struct
 #define TIMESTAMP_TIMEZONE_MASK		0x0FFF
 
 /* Entity identifier (ECMA 167r3 1/7.4) */
-typedef struct
-{
-	uint8_t		flags;
-	uint8_t		ident[23];
-	uint8_t		identSuffix[8];
+typedef struct {
+	uint8_t flags;
+	uint8_t ident[23];
+	uint8_t identSuffix[8];
 } __attribute__ ((packed)) regid;
 
 /* Flags (ECMA 167r3 1/7.4.1) */
@@ -107,12 +103,11 @@ typedef struct
 
 /* Volume Structure Descriptor (ECMA 167r3 2/9.1) */
 #define VSD_STD_ID_LEN			5
-struct volStructDesc
-{
-	uint8_t		structType;
-	uint8_t		stdIdent[VSD_STD_ID_LEN];
-	uint8_t		structVersion;
-	uint8_t		structData[2041];
+struct volStructDesc {
+	uint8_t structType;
+	uint8_t stdIdent[VSD_STD_ID_LEN];
+	uint8_t structVersion;
+	uint8_t structData[2041];
 } __attribute__ ((packed));
 
 /* Standard Identifier (EMCA 167r2 2/9.1.2) */
@@ -127,69 +122,63 @@ struct volStructDesc
 #define VSD_STD_ID_TEA01		"TEA01"	/* (2/9.3) */
 
 /* Beginning Extended Area Descriptor (ECMA 167r3 2/9.2) */
-struct beginningExtendedAreaDesc
-{
-	uint8_t		structType;
-	uint8_t		stdIdent[VSD_STD_ID_LEN];
-	uint8_t		structVersion;
-	uint8_t		structData[2041];
+struct beginningExtendedAreaDesc {
+	uint8_t structType;
+	uint8_t stdIdent[VSD_STD_ID_LEN];
+	uint8_t structVersion;
+	uint8_t structData[2041];
 } __attribute__ ((packed));
 
 /* Terminating Extended Area Descriptor (ECMA 167r3 2/9.3) */
-struct terminatingExtendedAreaDesc
-{
-	uint8_t		structType;
-	uint8_t		stdIdent[VSD_STD_ID_LEN];
-	uint8_t		structVersion;
-	uint8_t		structData[2041];
+struct terminatingExtendedAreaDesc {
+	uint8_t structType;
+	uint8_t stdIdent[VSD_STD_ID_LEN];
+	uint8_t structVersion;
+	uint8_t structData[2041];
 } __attribute__ ((packed));
 
 /* Boot Descriptor (ECMA 167r3 2/9.4) */
-struct bootDesc
-{
-	uint8_t		structType;
-	uint8_t		stdIdent[VSD_STD_ID_LEN];
-	uint8_t		structVersion;
-	uint8_t		reserved1;
-	regid		archType;
-	regid		bootIdent;
-	__le32		bootExtLocation;
-	__le32		bootExtLength;
-	__le64		loadAddress;
-	__le64		startAddress;
-	timestamp	descCreationDateAndTime;
-	__le16		flags;
-	uint8_t		reserved2[32];
-	uint8_t		bootUse[1906];
+struct bootDesc {
+	uint8_t structType;
+	uint8_t stdIdent[VSD_STD_ID_LEN];
+	uint8_t structVersion;
+	uint8_t reserved1;
+	regid archType;
+	regid bootIdent;
+	__le32 bootExtLocation;
+	__le32 bootExtLength;
+	__le64 loadAddress;
+	__le64 startAddress;
+	timestamp descCreationDateAndTime;
+	__le16 flags;
+	uint8_t reserved2[32];
+	uint8_t bootUse[1906];
 } __attribute__ ((packed));
 
 /* Flags (ECMA 167r3 2/9.4.12) */
 #define BOOT_FLAGS_ERASE		0x01
 
 /* Extent Descriptor (ECMA 167r3 3/7.1) */
-typedef struct
-{
-	__le32		extLength;
-	__le32		extLocation;
+typedef struct {
+	__le32 extLength;
+	__le32 extLocation;
 } __attribute__ ((packed)) extent_ad;
 
-typedef struct
-{
-	uint32_t	extLength;
-	uint32_t	extLocation;
+typedef struct {
+	uint32_t extLength;
+	uint32_t extLocation;
 } kernel_extent_ad;
 
 /* Descriptor Tag (ECMA 167r3 3/7.2) */
-typedef struct
-{
-	__le16		tagIdent;
-	__le16		descVersion;
-	uint8_t		tagChecksum;
-	uint8_t		reserved;
-	__le16		tagSerialNum;
-	__le16		descCRC;
-	__le16		descCRCLength;
-	__le32		tagLocation;
+typedef struct {
+	__le16 tagIdent;
+	__le16 descVersion;
+	uint8_t tagChecksum;
+	uint8_t reserved;
+	__le16 tagSerialNum;
+	__le16 descCRC;
+	__le16 descCRCLength;
+	__le32 tagLocation;
 } __attribute__ ((packed)) tag;
 
 /* Tag Identifier (ECMA 167r3 3/7.2.1) */
@@ -204,87 +193,81 @@ typedef struct
 #define TAG_IDENT_LVID			0x0009
 
 /* NSR Descriptor (ECMA 167r3 3/9.1) */
-struct NSRDesc
-{
-	uint8_t		structType;
-	uint8_t		stdIdent[VSD_STD_ID_LEN];
-	uint8_t		structVersion;
-	uint8_t		reserved;
-	uint8_t		structData[2040];
+struct NSRDesc {
+	uint8_t structType;
+	uint8_t stdIdent[VSD_STD_ID_LEN];
+	uint8_t structVersion;
+	uint8_t reserved;
+	uint8_t structData[2040];
 } __attribute__ ((packed));
-	
+
 /* Primary Volume Descriptor (ECMA 167r3 3/10.1) */
-struct primaryVolDesc
-{
-	tag		descTag;
-	__le32		volDescSeqNum;
-	__le32		primaryVolDescNum;
-	dstring		volIdent[32];
-	__le16		volSeqNum;
-	__le16		maxVolSeqNum;
-	__le16		interchangeLvl;
-	__le16		maxInterchangeLvl;
-	__le32		charSetList;
-	__le32		maxCharSetList;
-	dstring		volSetIdent[128];
-	charspec	descCharSet;
-	charspec	explanatoryCharSet;
-	extent_ad	volAbstract;
-	extent_ad	volCopyright;
-	regid		appIdent;
-	timestamp	recordingDateAndTime;
-	regid		impIdent;
-	uint8_t		impUse[64];
-	__le32		predecessorVolDescSeqLocation;
-	__le16		flags;
-	uint8_t		reserved[22];
+struct primaryVolDesc {
+	tag descTag;
+	__le32 volDescSeqNum;
+	__le32 primaryVolDescNum;
+	dstring volIdent[32];
+	__le16 volSeqNum;
+	__le16 maxVolSeqNum;
+	__le16 interchangeLvl;
+	__le16 maxInterchangeLvl;
+	__le32 charSetList;
+	__le32 maxCharSetList;
+	dstring volSetIdent[128];
+	charspec descCharSet;
+	charspec explanatoryCharSet;
+	extent_ad volAbstract;
+	extent_ad volCopyright;
+	regid appIdent;
+	timestamp recordingDateAndTime;
+	regid impIdent;
+	uint8_t impUse[64];
+	__le32 predecessorVolDescSeqLocation;
+	__le16 flags;
+	uint8_t reserved[22];
 } __attribute__ ((packed));
 
 /* Flags (ECMA 167r3 3/10.1.21) */
 #define PVD_FLAGS_VSID_COMMON		0x0001
 
 /* Anchor Volume Descriptor Pointer (ECMA 167r3 3/10.2) */
-struct anchorVolDescPtr
-{
-	tag		descTag;
-	extent_ad	mainVolDescSeqExt;
-	extent_ad	reserveVolDescSeqExt;
-	uint8_t	 	reserved[480];
+struct anchorVolDescPtr {
+	tag descTag;
+	extent_ad mainVolDescSeqExt;
+	extent_ad reserveVolDescSeqExt;
+	uint8_t reserved[480];
 } __attribute__ ((packed));
 
 /* Volume Descriptor Pointer (ECMA 167r3 3/10.3) */
-struct volDescPtr
-{
-	tag		descTag;
-	__le32		volDescSeqNum;
-	extent_ad	nextVolDescSeqExt;
-	uint8_t		reserved[484];
+struct volDescPtr {
+	tag descTag;
+	__le32 volDescSeqNum;
+	extent_ad nextVolDescSeqExt;
+	uint8_t reserved[484];
 } __attribute__ ((packed));
 
 /* Implementation Use Volume Descriptor (ECMA 167r3 3/10.4) */
-struct impUseVolDesc
-{
-	tag		descTag;
-	__le32		volDescSeqNum;
-	regid		impIdent;
-	uint8_t		impUse[460];
+struct impUseVolDesc {
+	tag descTag;
+	__le32 volDescSeqNum;
+	regid impIdent;
+	uint8_t impUse[460];
 } __attribute__ ((packed));
 
 /* Partition Descriptor (ECMA 167r3 3/10.5) */
-struct partitionDesc
-{
-	tag		descTag;
-	__le32		volDescSeqNum;
-	__le16		partitionFlags;
-	__le16		partitionNumber;
-	regid		partitionContents;
-	uint8_t		partitionContentsUse[128];
-	__le32		accessType;
-	__le32		partitionStartingLocation;
-	__le32		partitionLength;
-	regid		impIdent;
-	uint8_t		impUse[128];
-	uint8_t		reserved[156];
+struct partitionDesc {
+	tag descTag;
+	__le32 volDescSeqNum;
+	__le16 partitionFlags;
+	__le16 partitionNumber;
+	regid partitionContents;
+	uint8_t partitionContentsUse[128];
+	__le32 accessType;
+	__le32 partitionStartingLocation;
+	__le32 partitionLength;
+	regid impIdent;
+	uint8_t impUse[128];
+	uint8_t reserved[156];
 } __attribute__ ((packed));
 
 /* Partition Flags (ECMA 167r3 3/10.5.3) */
@@ -307,29 +290,27 @@ struct partitionDesc
 #define PD_ACCESS_TYPE_OVERWRITABLE	0x00000004
 
 /* Logical Volume Descriptor (ECMA 167r3 3/10.6) */
-struct logicalVolDesc
-{
-	tag		descTag;
-	__le32		volDescSeqNum;
-	charspec	descCharSet;
-	dstring		logicalVolIdent[128];
-	__le32		logicalBlockSize;
-	regid		domainIdent;
-	uint8_t		logicalVolContentsUse[16];
-	__le32		mapTableLength;
-	__le32		numPartitionMaps;
-	regid		impIdent;
-	uint8_t		impUse[128];
-	extent_ad	integritySeqExt;
-	uint8_t		partitionMaps[0];
+struct logicalVolDesc {
+	tag descTag;
+	__le32 volDescSeqNum;
+	charspec descCharSet;
+	dstring logicalVolIdent[128];
+	__le32 logicalBlockSize;
+	regid domainIdent;
+	uint8_t logicalVolContentsUse[16];
+	__le32 mapTableLength;
+	__le32 numPartitionMaps;
+	regid impIdent;
+	uint8_t impUse[128];
+	extent_ad integritySeqExt;
+	uint8_t partitionMaps[0];
 } __attribute__ ((packed));
 
 /* Generic Partition Map (ECMA 167r3 3/10.7.1) */
-struct genericPartitionMap
-{
-	uint8_t		partitionMapType;
-	uint8_t		partitionMapLength;
-	uint8_t		partitionMapping[0];
+struct genericPartitionMap {
+	uint8_t partitionMapType;
+	uint8_t partitionMapLength;
+	uint8_t partitionMapping[0];
 } __attribute__ ((packed));
 
 /* Partition Map Type (ECMA 167r3 3/10.7.1.1) */
@@ -338,51 +319,46 @@ struct genericPartitionMap
 #define GP_PARTITION_MAP_TYPE_2		0x02
 
 /* Type 1 Partition Map (ECMA 167r3 3/10.7.2) */
-struct genericPartitionMap1
-{
-	uint8_t		partitionMapType;
-	uint8_t		partitionMapLength;
-	__le16		volSeqNum;
-	__le16		partitionNum;
+struct genericPartitionMap1 {
+	uint8_t partitionMapType;
+	uint8_t partitionMapLength;
+	__le16 volSeqNum;
+	__le16 partitionNum;
 } __attribute__ ((packed));
 
 /* Type 2 Partition Map (ECMA 167r3 3/10.7.3) */
-struct genericPartitionMap2
-{
-	uint8_t		partitionMapType;
-	uint8_t		partitionMapLength; 
-	uint8_t		partitionIdent[62];
+struct genericPartitionMap2 {
+	uint8_t partitionMapType;
+	uint8_t partitionMapLength;
+	uint8_t partitionIdent[62];
 } __attribute__ ((packed));
 
 /* Unallocated Space Descriptor (ECMA 167r3 3/10.8) */
-struct unallocSpaceDesc
-{
-	tag		descTag;
-	__le32		volDescSeqNum;
-	__le32		numAllocDescs;
-	extent_ad	allocDescs[0];
+struct unallocSpaceDesc {
+	tag descTag;
+	__le32 volDescSeqNum;
+	__le32 numAllocDescs;
+	extent_ad allocDescs[0];
 } __attribute__ ((packed));
 
 /* Terminating Descriptor (ECMA 167r3 3/10.9) */
-struct terminatingDesc
-{
-	tag		descTag;
-	uint8_t		reserved[496];
+struct terminatingDesc {
+	tag descTag;
+	uint8_t reserved[496];
 } __attribute__ ((packed));
 
 /* Logical Volume Integrity Descriptor (ECMA 167r3 3/10.10) */
-struct logicalVolIntegrityDesc
-{
-	tag		descTag;
-	timestamp	recordingDateAndTime;
-	__le32		integrityType;
-	extent_ad	nextIntegrityExt;
-	uint8_t		logicalVolContentsUse[32];
-	__le32		numOfPartitions;
-	__le32		lengthOfImpUse;
-	__le32		freeSpaceTable[0];
-	__le32		sizeTable[0];
-	uint8_t		impUse[0];
+struct logicalVolIntegrityDesc {
+	tag descTag;
+	timestamp recordingDateAndTime;
+	__le32 integrityType;
+	extent_ad nextIntegrityExt;
+	uint8_t logicalVolContentsUse[32];
+	__le32 numOfPartitions;
+	__le32 lengthOfImpUse;
+	__le32 freeSpaceTable[0];
+	__le32 sizeTable[0];
+	uint8_t impUse[0];
 } __attribute__ ((packed));
 
 /* Integrity Type (ECMA 167r3 3/10.10.3) */
@@ -390,56 +366,49 @@ struct logicalVolIntegrityDesc
 #define LVID_INTEGRITY_TYPE_CLOSE	0x00000001
 
 /* Recorded Address (ECMA 167r3 4/7.1) */
-typedef struct 
-{
-	__le32		logicalBlockNum;
-	__le16	 	partitionReferenceNum;
+typedef struct {
+	__le32 logicalBlockNum;
+	__le16 partitionReferenceNum;
 } __attribute__ ((packed)) lb_addr;
 
 /* ... and its in-core analog */
-typedef struct 
-{
-	uint32_t		logicalBlockNum;
-	uint16_t	 	partitionReferenceNum;
+typedef struct {
+	uint32_t logicalBlockNum;
+	uint16_t partitionReferenceNum;
 } kernel_lb_addr;
 
 /* Short Allocation Descriptor (ECMA 167r3 4/14.14.1) */
-typedef struct
-{
-        __le32		extLength;
-        __le32		extPosition;
+typedef struct {
+	__le32 extLength;
+	__le32 extPosition;
 } __attribute__ ((packed)) short_ad;
 
 /* Long Allocation Descriptor (ECMA 167r3 4/14.14.2) */
-typedef struct
-{
-	__le32		extLength;
-	lb_addr		extLocation;
-	uint8_t		impUse[6];
+typedef struct {
+	__le32 extLength;
+	lb_addr extLocation;
+	uint8_t impUse[6];
 } __attribute__ ((packed)) long_ad;
 
-typedef struct
-{
-	uint32_t	extLength;
-	kernel_lb_addr	extLocation;
-	uint8_t		impUse[6];
+typedef struct {
+	uint32_t extLength;
+	kernel_lb_addr extLocation;
+	uint8_t impUse[6];
 } kernel_long_ad;
 
 /* Extended Allocation Descriptor (ECMA 167r3 4/14.14.3) */
-typedef struct
-{
-	__le32		extLength;
-	__le32		recordedLength;
-	__le32		informationLength;
-	lb_addr		extLocation;
+typedef struct {
+	__le32 extLength;
+	__le32 recordedLength;
+	__le32 informationLength;
+	lb_addr extLocation;
 } __attribute__ ((packed)) ext_ad;
 
-typedef struct
-{
-	uint32_t	extLength;
-	uint32_t	recordedLength;
-	uint32_t	informationLength;
-	kernel_lb_addr	extLocation;
+typedef struct {
+	uint32_t extLength;
+	uint32_t recordedLength;
+	uint32_t informationLength;
+	kernel_lb_addr extLocation;
 } kernel_ext_ad;
 
 /* Descriptor Tag (ECMA 167r3 4/7.2 - See 3/7.2) */
@@ -458,52 +427,49 @@ typedef struct
 #define TAG_IDENT_EFE			0x010A
 
 /* File Set Descriptor (ECMA 167r3 4/14.1) */
-struct fileSetDesc
-{
-	tag		descTag;
-	timestamp	recordingDateAndTime;
-	__le16		interchangeLvl;
-	__le16		maxInterchangeLvl;
-	__le32		charSetList;
-	__le32		maxCharSetList;
-	__le32		fileSetNum;
-	__le32		fileSetDescNum;
-	charspec	logicalVolIdentCharSet;
-	dstring		logicalVolIdent[128];
-	charspec	fileSetCharSet;
-	dstring		fileSetIdent[32];
-	dstring		copyrightFileIdent[32];
-	dstring		abstractFileIdent[32];
-	long_ad		rootDirectoryICB;
-	regid		domainIdent;
-	long_ad		nextExt;
-	long_ad		streamDirectoryICB;
-	uint8_t		reserved[32];
+struct fileSetDesc {
+	tag descTag;
+	timestamp recordingDateAndTime;
+	__le16 interchangeLvl;
+	__le16 maxInterchangeLvl;
+	__le32 charSetList;
+	__le32 maxCharSetList;
+	__le32 fileSetNum;
+	__le32 fileSetDescNum;
+	charspec logicalVolIdentCharSet;
+	dstring logicalVolIdent[128];
+	charspec fileSetCharSet;
+	dstring fileSetIdent[32];
+	dstring copyrightFileIdent[32];
+	dstring abstractFileIdent[32];
+	long_ad rootDirectoryICB;
+	regid domainIdent;
+	long_ad nextExt;
+	long_ad streamDirectoryICB;
+	uint8_t reserved[32];
 } __attribute__ ((packed));
 
 /* Partition Header Descriptor (ECMA 167r3 4/14.3) */
-struct partitionHeaderDesc
-{
-	short_ad	unallocSpaceTable;
-	short_ad	unallocSpaceBitmap;
-	short_ad	partitionIntegrityTable;
-	short_ad	freedSpaceTable;
-	short_ad	freedSpaceBitmap;
-	uint8_t		reserved[88];
+struct partitionHeaderDesc {
+	short_ad unallocSpaceTable;
+	short_ad unallocSpaceBitmap;
+	short_ad partitionIntegrityTable;
+	short_ad freedSpaceTable;
+	short_ad freedSpaceBitmap;
+	uint8_t reserved[88];
 } __attribute__ ((packed));
 
 /* File Identifier Descriptor (ECMA 167r3 4/14.4) */
-struct fileIdentDesc
-{
-	tag		descTag;
-	__le16		fileVersionNum;
-	uint8_t		fileCharacteristics;
-	uint8_t		lengthFileIdent;
-	long_ad		icb;
-	__le16		lengthOfImpUse;
-	uint8_t		impUse[0];
-	uint8_t		fileIdent[0];
-	uint8_t		padding[0];
+struct fileIdentDesc {
+	tag descTag;
+	__le16 fileVersionNum;
+	uint8_t fileCharacteristics;
+	uint8_t lengthFileIdent;
+	long_ad icb;
+	__le16 lengthOfImpUse;
+	uint8_t impUse[0];
+	uint8_t fileIdent[0];
+	uint8_t padding[0];
 } __attribute__ ((packed));
 
 /* File Characteristics (ECMA 167r3 4/14.4.3) */
@@ -514,24 +480,22 @@ struct fileIdentDesc
 #define FID_FILE_CHAR_METADATA		0x10
 
 /* Allocation Ext Descriptor (ECMA 167r3 4/14.5) */
-struct allocExtDesc
-{
-	tag		descTag;
-	__le32		previousAllocExtLocation;
-	__le32		lengthAllocDescs;
+struct allocExtDesc {
+	tag descTag;
+	__le32 previousAllocExtLocation;
+	__le32 lengthAllocDescs;
 } __attribute__ ((packed));
 
 /* ICB Tag (ECMA 167r3 4/14.6) */
-typedef struct
-{
-	__le32		priorRecordedNumDirectEntries;
-	__le16		strategyType;
-	__le16		strategyParameter;
-	__le16		numEntries;
-	uint8_t		reserved;
-	uint8_t		fileType;
-	lb_addr		parentICBLocation;
-	__le16		flags;
+typedef struct {
+	__le32 priorRecordedNumDirectEntries;
+	__le16 strategyType;
+	__le16 strategyParameter;
+	__le16 numEntries;
+	uint8_t reserved;
+	uint8_t fileType;
+	lb_addr parentICBLocation;
+	__le16 flags;
 } __attribute__ ((packed)) icbtag;
 
 /* Strategy Type (ECMA 167r3 4/14.6.2) */
@@ -576,45 +540,42 @@ typedef struct
 #define ICBTAG_FLAG_STREAM		0x2000
 
 /* Indirect Entry (ECMA 167r3 4/14.7) */
-struct indirectEntry
-{
-	tag		descTag;
-	icbtag		icbTag;
-	long_ad		indirectICB;
+struct indirectEntry {
+	tag descTag;
+	icbtag icbTag;
+	long_ad indirectICB;
 } __attribute__ ((packed));
 
 /* Terminal Entry (ECMA 167r3 4/14.8) */
-struct terminalEntry
-{
-	tag		descTag;
-	icbtag		icbTag;
+struct terminalEntry {
+	tag descTag;
+	icbtag icbTag;
 } __attribute__ ((packed));
 
 /* File Entry (ECMA 167r3 4/14.9) */
-struct fileEntry
-{
-	tag		descTag;
-	icbtag		icbTag;
-	__le32		uid;
-	__le32		gid;
-	__le32		permissions;
-	__le16		fileLinkCount;
-	uint8_t		recordFormat;
-	uint8_t		recordDisplayAttr;
-	__le32		recordLength;
-	__le64		informationLength;
-	__le64		logicalBlocksRecorded;
-	timestamp	accessTime;
-	timestamp	modificationTime;
-	timestamp	attrTime;
-	__le32		checkpoint;
-	long_ad		extendedAttrICB;
-	regid		impIdent;
-	__le64		uniqueID;
-	__le32		lengthExtendedAttr;
-	__le32		lengthAllocDescs;
-	uint8_t		extendedAttr[0];
-	uint8_t		allocDescs[0];
+struct fileEntry {
+	tag descTag;
+	icbtag icbTag;
+	__le32 uid;
+	__le32 gid;
+	__le32 permissions;
+	__le16 fileLinkCount;
+	uint8_t recordFormat;
+	uint8_t recordDisplayAttr;
+	__le32 recordLength;
+	__le64 informationLength;
+	__le64 logicalBlocksRecorded;
+	timestamp accessTime;
+	timestamp modificationTime;
+	timestamp attrTime;
+	__le32 checkpoint;
+	long_ad extendedAttrICB;
+	regid impIdent;
+	__le64 uniqueID;
+	__le32 lengthExtendedAttr;
+	__le32 lengthAllocDescs;
+	uint8_t extendedAttr[0];
+	uint8_t allocDescs[0];
 } __attribute__ ((packed));
 
 /* Permissions (ECMA 167r3 4/14.9.5) */
@@ -655,57 +616,52 @@ struct fileEntry
 #define FE_RECORD_DISPLAY_ATTR_3	0x03
 
 /* Extended Attribute Header Descriptor (ECMA 167r3 4/14.10.1) */
-struct extendedAttrHeaderDesc
-{
-	tag		descTag;
-	__le32		impAttrLocation;
-	__le32		appAttrLocation;
+struct extendedAttrHeaderDesc {
+	tag descTag;
+	__le32 impAttrLocation;
+	__le32 appAttrLocation;
 } __attribute__ ((packed));
 
 /* Generic Format (ECMA 167r3 4/14.10.2) */
-struct genericFormat
-{
-	__le32		attrType;
-	uint8_t		attrSubtype;
-	uint8_t		reserved[3];
-	__le32		attrLength;
-	uint8_t		attrData[0];
+struct genericFormat {
+	__le32 attrType;
+	uint8_t attrSubtype;
+	uint8_t reserved[3];
+	__le32 attrLength;
+	uint8_t attrData[0];
 } __attribute__ ((packed));
 
 /* Character Set Information (ECMA 167r3 4/14.10.3) */
-struct charSetInfo
-{
-	__le32		attrType;
-	uint8_t		attrSubtype;
-	uint8_t		reserved[3];
-	__le32		attrLength;
-	__le32		escapeSeqLength;
-	uint8_t		charSetType;
-	uint8_t		escapeSeq[0];
+struct charSetInfo {
+	__le32 attrType;
+	uint8_t attrSubtype;
+	uint8_t reserved[3];
+	__le32 attrLength;
+	__le32 escapeSeqLength;
+	uint8_t charSetType;
+	uint8_t escapeSeq[0];
 } __attribute__ ((packed));
 
 /* Alternate Permissions (ECMA 167r3 4/14.10.4) */
-struct altPerms
-{
-	__le32		attrType;
-	uint8_t		attrSubtype;
-	uint8_t		reserved[3];
-	__le32		attrLength;
-	__le16		ownerIdent;
-	__le16		groupIdent;
-	__le16		permission;
+struct altPerms {
+	__le32 attrType;
+	uint8_t attrSubtype;
+	uint8_t reserved[3];
+	__le32 attrLength;
+	__le16 ownerIdent;
+	__le16 groupIdent;
+	__le16 permission;
 } __attribute__ ((packed));
 
 /* File Times Extended Attribute (ECMA 167r3 4/14.10.5) */
-struct fileTimesExtAttr
-{
-	__le32		attrType;
-	uint8_t		attrSubtype;
-	uint8_t		reserved[3];
-	__le32		attrLength;
-	__le32		dataLength;
-	__le32		fileTimeExistence;
-	uint8_t		fileTimes;
+struct fileTimesExtAttr {
+	__le32 attrType;
+	uint8_t attrSubtype;
+	uint8_t reserved[3];
+	__le32 attrLength;
+	__le32 dataLength;
+	__le32 fileTimeExistence;
+	uint8_t fileTimes;
 } __attribute__ ((packed));
 
 /* FileTimeExistence (ECMA 167r3 4/14.10.5.6) */
@@ -715,52 +671,48 @@ struct fileTimesExtAttr
 #define FTE_BACKUP			0x00000002
 
 /* Information Times Extended Attribute (ECMA 167r3 4/14.10.6) */
-struct infoTimesExtAttr
-{
-	__le32		attrType;
-	uint8_t		attrSubtype;
-	uint8_t		reserved[3];
-	__le32		attrLength;
-	__le32		dataLength;
-	__le32		infoTimeExistence;
-	uint8_t		infoTimes[0];
+struct infoTimesExtAttr {
+	__le32 attrType;
+	uint8_t attrSubtype;
+	uint8_t reserved[3];
+	__le32 attrLength;
+	__le32 dataLength;
+	__le32 infoTimeExistence;
+	uint8_t infoTimes[0];
 } __attribute__ ((packed));
 
 /* Device Specification (ECMA 167r3 4/14.10.7) */
-struct deviceSpec
-{
-	__le32		attrType;
-	uint8_t		attrSubtype;
-	uint8_t		reserved[3];
-	__le32		attrLength;
-	__le32		impUseLength;
-	__le32		majorDeviceIdent;
-	__le32		minorDeviceIdent;
-	uint8_t		impUse[0];
+struct deviceSpec {
+	__le32 attrType;
+	uint8_t attrSubtype;
+	uint8_t reserved[3];
+	__le32 attrLength;
+	__le32 impUseLength;
+	__le32 majorDeviceIdent;
+	__le32 minorDeviceIdent;
+	uint8_t impUse[0];
 } __attribute__ ((packed));
 
 /* Implementation Use Extended Attr (ECMA 167r3 4/14.10.8) */
-struct impUseExtAttr
-{
-	__le32		attrType;
-	uint8_t		attrSubtype;
-	uint8_t		reserved[3];
-	__le32		attrLength;
-	__le32		impUseLength;
-	regid		impIdent;
-	uint8_t		impUse[0];
+struct impUseExtAttr {
+	__le32 attrType;
+	uint8_t attrSubtype;
+	uint8_t reserved[3];
+	__le32 attrLength;
+	__le32 impUseLength;
+	regid impIdent;
+	uint8_t impUse[0];
 } __attribute__ ((packed));
 
 /* Application Use Extended Attribute (ECMA 167r3 4/14.10.9) */
-struct appUseExtAttr
-{
-	__le32		attrType;
-	uint8_t		attrSubtype;
-	uint8_t		reserved[3];
-	__le32		attrLength;
-	__le32		appUseLength;
-	regid		appIdent;
-	uint8_t		appUse[0];
+struct appUseExtAttr {
+	__le32 attrType;
+	uint8_t attrSubtype;
+	uint8_t reserved[3];
+	__le32 attrLength;
+	__le32 appUseLength;
+	regid appIdent;
+	uint8_t appUse[0];
 } __attribute__ ((packed));
 
 #define EXTATTR_CHAR_SET		1
@@ -771,35 +723,31 @@ struct appUseExtAttr
 #define EXTATTR_IMP_USE			2048
 #define EXTATTR_APP_USE			65536
 
-
 /* Unallocated Space Entry (ECMA 167r3 4/14.11) */
-struct unallocSpaceEntry
-{
-	tag		descTag;
-	icbtag		icbTag;
-	__le32		lengthAllocDescs;
-	uint8_t		allocDescs[0];
+struct unallocSpaceEntry {
+	tag descTag;
+	icbtag icbTag;
+	__le32 lengthAllocDescs;
+	uint8_t allocDescs[0];
 } __attribute__ ((packed));
 
 /* Space Bitmap Descriptor (ECMA 167r3 4/14.12) */
-struct spaceBitmapDesc
-{
-	tag		descTag;
-	__le32		numOfBits;
-	__le32		numOfBytes;
-	uint8_t		bitmap[0];
+struct spaceBitmapDesc {
+	tag descTag;
+	__le32 numOfBits;
+	__le32 numOfBytes;
+	uint8_t bitmap[0];
 } __attribute__ ((packed));
 
 /* Partition Integrity Entry (ECMA 167r3 4/14.13) */
-struct partitionIntegrityEntry
-{
-	tag		descTag;
-	icbtag		icbTag;
-	timestamp	recordingDateAndTime;
-	uint8_t		integrityType;
-	uint8_t		reserved[175];
-	regid		impIdent;
-	uint8_t		impUse[256];
+struct partitionIntegrityEntry {
+	tag descTag;
+	icbtag icbTag;
+	timestamp recordingDateAndTime;
+	uint8_t integrityType;
+	uint8_t reserved[175];
+	regid impIdent;
+	uint8_t impUse[256];
 } __attribute__ ((packed));
 
 /* Short Allocation Descriptor (ECMA 167r3 4/14.14.1) */
@@ -815,50 +763,47 @@ struct partitionIntegrityEntry
 /* Extended Allocation Descriptor (ECMA 167r3 4/14.14.3) */
 
 /* Logical Volume Header Descriptor (ECMA 167r3 4/14.15) */
-struct logicalVolHeaderDesc
-{
-	__le64		uniqueID;
-	uint8_t		reserved[24];
+struct logicalVolHeaderDesc {
+	__le64 uniqueID;
+	uint8_t reserved[24];
 } __attribute__ ((packed));
 
 /* Path Component (ECMA 167r3 4/14.16.1) */
-struct pathComponent
-{
-	uint8_t		componentType;
-	uint8_t		lengthComponentIdent;
-	__le16		componentFileVersionNum;
-	dstring		componentIdent[0];
+struct pathComponent {
+	uint8_t componentType;
+	uint8_t lengthComponentIdent;
+	__le16 componentFileVersionNum;
+	dstring componentIdent[0];
 } __attribute__ ((packed));
 
 /* File Entry (ECMA 167r3 4/14.17) */
-struct extendedFileEntry
-{
-	tag		descTag;
-	icbtag		icbTag;
-	__le32		uid;
-	__le32		gid;
-	__le32		permissions;
-	__le16		fileLinkCount;
-	uint8_t		recordFormat;
-	uint8_t		recordDisplayAttr;
-	__le32		recordLength;
-	__le64		informationLength;
-	__le64		objectSize;
-	__le64		logicalBlocksRecorded;
-	timestamp	accessTime;
-	timestamp	modificationTime;
-	timestamp	createTime;
-	timestamp	attrTime;
-	__le32		checkpoint;
-	__le32		reserved;
-	long_ad		extendedAttrICB;
-	long_ad		streamDirectoryICB;
-	regid		impIdent;
-	__le64		uniqueID;
-	__le32		lengthExtendedAttr;
-	__le32		lengthAllocDescs;
-	uint8_t		extendedAttr[0];
-	uint8_t		allocDescs[0];
+struct extendedFileEntry {
+	tag descTag;
+	icbtag icbTag;
+	__le32 uid;
+	__le32 gid;
+	__le32 permissions;
+	__le16 fileLinkCount;
+	uint8_t recordFormat;
+	uint8_t recordDisplayAttr;
+	__le32 recordLength;
+	__le64 informationLength;
+	__le64 objectSize;
+	__le64 logicalBlocksRecorded;
+	timestamp accessTime;
+	timestamp modificationTime;
+	timestamp createTime;
+	timestamp attrTime;
+	__le32 checkpoint;
+	__le32 reserved;
+	long_ad extendedAttrICB;
+	long_ad streamDirectoryICB;
+	regid impIdent;
+	__le64 uniqueID;
+	__le32 lengthExtendedAttr;
+	__le32 lengthAllocDescs;
+	uint8_t extendedAttr[0];
+	uint8_t allocDescs[0];
 } __attribute__ ((packed));
 
-#endif /* _ECMA_167_H */
+#endif				/* _ECMA_167_H */
diff -puN fs/udf/file.c~udf-coding-style-conversion-lindent fs/udf/file.c
--- a/fs/udf/file.c~udf-coding-style-conversion-lindent
+++ a/fs/udf/file.c
@@ -30,7 +30,7 @@
 #include <linux/udf_fs.h>
 #include <asm/uaccess.h>
 #include <linux/kernel.h>
-#include <linux/string.h> /* memset */
+#include <linux/string.h>	/* memset */
 #include <linux/capability.h>
 #include <linux/errno.h>
 #include <linux/smp_lock.h>
@@ -41,7 +41,7 @@
 #include "udf_i.h"
 #include "udf_sb.h"
 
-static int udf_adinicb_readpage(struct file *file, struct page * page)
+static int udf_adinicb_readpage(struct file *file, struct page *page)
 {
 	struct inode *inode = page->mapping->host;
 	char *kaddr;
@@ -58,7 +58,8 @@ static int udf_adinicb_readpage(struct f
 	return 0;
 }
 
-static int udf_adinicb_writepage(struct page *page, struct writeback_control *wbc)
+static int udf_adinicb_writepage(struct page *page,
+				 struct writeback_control *wbc)
 {
 	struct inode *inode = page->mapping->host;
 	char *kaddr;
@@ -74,19 +75,21 @@ static int udf_adinicb_writepage(struct 
 	return 0;
 }
 
-static int udf_adinicb_prepare_write(struct file *file, struct page *page, unsigned offset, unsigned to)
+static int udf_adinicb_prepare_write(struct file *file, struct page *page,
+				     unsigned offset, unsigned to)
 {
 	kmap(page);
 	return 0;
 }
 
-static int udf_adinicb_commit_write(struct file *file, struct page *page, unsigned offset, unsigned to)
+static int udf_adinicb_commit_write(struct file *file, struct page *page,
+				    unsigned offset, unsigned to)
 {
 	struct inode *inode = page->mapping->host;
 	char *kaddr = page_address(page);
 
 	memcpy(UDF_I_DATA(inode) + UDF_I_LENEATTR(inode) + offset,
-		kaddr + offset, to - offset);
+	       kaddr + offset, to - offset);
 	mark_inode_dirty(inode);
 	SetPageUptodate(page);
 	kunmap(page);
@@ -97,15 +100,15 @@ static int udf_adinicb_commit_write(stru
 }
 
 const struct address_space_operations udf_adinicb_aops = {
-	.readpage		= udf_adinicb_readpage,
-	.writepage		= udf_adinicb_writepage,
-	.sync_page		= block_sync_page,
-	.prepare_write		= udf_adinicb_prepare_write,
-	.commit_write		= udf_adinicb_commit_write,
+	.readpage = udf_adinicb_readpage,
+	.writepage = udf_adinicb_writepage,
+	.sync_page = block_sync_page,
+	.prepare_write = udf_adinicb_prepare_write,
+	.commit_write = udf_adinicb_commit_write,
 };
 
 static ssize_t udf_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
-			      unsigned long nr_segs, loff_t ppos)
+				  unsigned long nr_segs, loff_t ppos)
 {
 	ssize_t retval;
 	struct file *file = iocb->ki_filp;
@@ -113,25 +116,20 @@ static ssize_t udf_file_aio_write(struct
 	int err, pos;
 	size_t count = iocb->ki_left;
 
-	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB)
-	{
+	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB) {
 		if (file->f_flags & O_APPEND)
 			pos = inode->i_size;
 		else
 			pos = ppos;
 
-		if (inode->i_sb->s_blocksize < (udf_file_entry_alloc_offset(inode) +
-			pos + count))
-		{
+		if (inode->i_sb->s_blocksize <
+		    (udf_file_entry_alloc_offset(inode) + pos + count)) {
 			udf_expand_file_adinicb(inode, pos + count, &err);
-			if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB)
-			{
+			if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB) {
 				udf_debug("udf_expand_adinicb: err=%d\n", err);
 				return err;
 			}
-		}
-		else
-		{
+		} else {
 			if (pos + count > inode->i_size)
 				UDF_I_LENALLOC(inode) = pos + count;
 			else
@@ -181,48 +179,47 @@ static ssize_t udf_file_aio_write(struct
  *	Written, tested, and released.
  */
 int udf_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
-	unsigned long arg)
+	      unsigned long arg)
 {
 	int result = -EINVAL;
 
-	if ( file_permission(filp, MAY_READ) != 0 )
-	{
-		udf_debug("no permission to access inode %lu\n",
-						inode->i_ino);
+	if (file_permission(filp, MAY_READ) != 0) {
+		udf_debug("no permission to access inode %lu\n", inode->i_ino);
 		return -EPERM;
 	}
 
-	if ( !arg )
-	{
+	if (!arg) {
 		udf_debug("invalid argument to udf_ioctl\n");
 		return -EINVAL;
 	}
 
-	switch (cmd)
-	{
-		case UDF_GETVOLIDENT:
-			return copy_to_user((char __user *)arg,
-				UDF_SB_VOLIDENT(inode->i_sb), 32) ? -EFAULT : 0;
-		case UDF_RELOCATE_BLOCKS:
+	switch (cmd) {
+	case UDF_GETVOLIDENT:
+		return copy_to_user((char __user *)arg,
+				    UDF_SB_VOLIDENT(inode->i_sb),
+				    32) ? -EFAULT : 0;
+	case UDF_RELOCATE_BLOCKS:
 		{
 			long old, new;
 
-			if (!capable(CAP_SYS_ADMIN)) return -EACCES;
-			if (get_user(old, (long __user *)arg)) return -EFAULT;
+			if (!capable(CAP_SYS_ADMIN))
+				return -EACCES;
+			if (get_user(old, (long __user *)arg))
+				return -EFAULT;
 			if ((result = udf_relocate_blocks(inode->i_sb,
-					old, &new)) == 0)
+							  old, &new)) == 0)
 				result = put_user(new, (long __user *)arg);
 
 			return result;
 		}
-		case UDF_GETEASIZE:
-			result = put_user(UDF_I_LENEATTR(inode), (int __user *)arg);
-			break;
-
-		case UDF_GETEABLOCK:
-			result = copy_to_user((char __user *)arg, UDF_I_DATA(inode),
-				UDF_I_LENEATTR(inode)) ? -EFAULT : 0;
-			break;
+	case UDF_GETEASIZE:
+		result = put_user(UDF_I_LENEATTR(inode), (int __user *)arg);
+		break;
+
+	case UDF_GETEABLOCK:
+		result = copy_to_user((char __user *)arg, UDF_I_DATA(inode),
+				      UDF_I_LENEATTR(inode)) ? -EFAULT : 0;
+		break;
 	}
 
 	return result;
@@ -240,10 +237,9 @@ int udf_ioctl(struct inode *inode, struc
  * HISTORY
  *
  */
-static int udf_release_file(struct inode * inode, struct file * filp)
+static int udf_release_file(struct inode *inode, struct file *filp)
 {
-	if (filp->f_mode & FMODE_WRITE)
-	{
+	if (filp->f_mode & FMODE_WRITE) {
 		lock_kernel();
 		udf_discard_prealloc(inode);
 		unlock_kernel();
@@ -252,18 +248,18 @@ static int udf_release_file(struct inode
 }
 
 const struct file_operations udf_file_operations = {
-	.read			= do_sync_read,
-	.aio_read		= generic_file_aio_read,
-	.ioctl			= udf_ioctl,
-	.open			= generic_file_open,
-	.mmap			= generic_file_mmap,
-	.write			= do_sync_write,
-	.aio_write		= udf_file_aio_write,
-	.release		= udf_release_file,
-	.fsync			= udf_fsync_file,
-	.splice_read		= generic_file_splice_read,
+	.read = do_sync_read,
+	.aio_read = generic_file_aio_read,
+	.ioctl = udf_ioctl,
+	.open = generic_file_open,
+	.mmap = generic_file_mmap,
+	.write = do_sync_write,
+	.aio_write = udf_file_aio_write,
+	.release = udf_release_file,
+	.fsync = udf_fsync_file,
+	.splice_read = generic_file_splice_read,
 };
 
 const struct inode_operations udf_file_inode_operations = {
-	.truncate		= udf_truncate,
+	.truncate = udf_truncate,
 };
diff -puN fs/udf/fsync.c~udf-coding-style-conversion-lindent fs/udf/fsync.c
--- a/fs/udf/fsync.c~udf-coding-style-conversion-lindent
+++ a/fs/udf/fsync.c
@@ -29,7 +29,7 @@ static int udf_fsync_inode(struct inode 
  *	even pass file to fsync ?
  */
 
-int udf_fsync_file(struct file * file, struct dentry *dentry, int datasync)
+int udf_fsync_file(struct file *file, struct dentry *dentry, int datasync)
 {
 	struct inode *inode = dentry->d_inode;
 	return udf_fsync_inode(inode, datasync);
@@ -45,6 +45,6 @@ static int udf_fsync_inode(struct inode 
 	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
 		return err;
 
-	err |= udf_sync_inode (inode);
+	err |= udf_sync_inode(inode);
 	return err ? -EIO : 0;
 }
diff -puN fs/udf/ialloc.c~udf-coding-style-conversion-lindent fs/udf/ialloc.c
--- a/fs/udf/ialloc.c~udf-coding-style-conversion-lindent
+++ a/fs/udf/ialloc.c
@@ -28,7 +28,7 @@
 #include "udf_i.h"
 #include "udf_sb.h"
 
-void udf_free_inode(struct inode * inode)
+void udf_free_inode(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 	struct udf_sb_info *sbi = UDF_SB(sb);
@@ -46,10 +46,12 @@ void udf_free_inode(struct inode * inode
 	if (sbi->s_lvidbh) {
 		if (S_ISDIR(inode->i_mode))
 			UDF_SB_LVIDIU(sb)->numDirs =
-				cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numDirs) - 1);
+			    cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numDirs)
+					- 1);
 		else
 			UDF_SB_LVIDIU(sb)->numFiles =
-				cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numFiles) - 1);
+			    cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numFiles)
+					- 1);
 
 		mark_buffer_dirty(sbi->s_lvidbh);
 	}
@@ -58,18 +60,17 @@ void udf_free_inode(struct inode * inode
 	udf_free_blocks(sb, NULL, UDF_I_LOCATION(inode), 0, 1);
 }
 
-struct inode * udf_new_inode (struct inode *dir, int mode, int * err)
+struct inode *udf_new_inode(struct inode *dir, int mode, int *err)
 {
 	struct super_block *sb = dir->i_sb;
 	struct udf_sb_info *sbi = UDF_SB(sb);
-	struct inode * inode;
+	struct inode *inode;
 	int block;
 	uint32_t start = UDF_I_LOCATION(dir).logicalBlockNum;
 
 	inode = new_inode(sb);
 
-	if (!inode)
-	{
+	if (!inode) {
 		*err = -ENOMEM;
 		return NULL;
 	}
@@ -81,26 +82,30 @@ struct inode * udf_new_inode (struct ino
 	UDF_I_NEXT_ALLOC_GOAL(inode) = 0;
 	UDF_I_STRAT4096(inode) = 0;
 
-	block = udf_new_block(dir->i_sb, NULL, UDF_I_LOCATION(dir).partitionReferenceNum,
-		start, err);
-	if (*err)
-	{
+	block =
+	    udf_new_block(dir->i_sb, NULL,
+			  UDF_I_LOCATION(dir).partitionReferenceNum, start,
+			  err);
+	if (*err) {
 		iput(inode);
 		return NULL;
 	}
 
 	mutex_lock(&sbi->s_alloc_mutex);
-	if (UDF_SB_LVIDBH(sb))
-	{
+	if (UDF_SB_LVIDBH(sb)) {
 		struct logicalVolHeaderDesc *lvhd;
 		uint64_t uniqueID;
-		lvhd = (struct logicalVolHeaderDesc *)(UDF_SB_LVID(sb)->logicalVolContentsUse);
+		lvhd =
+		    (struct logicalVolHeaderDesc *)(UDF_SB_LVID(sb)->
+						    logicalVolContentsUse);
 		if (S_ISDIR(mode))
 			UDF_SB_LVIDIU(sb)->numDirs =
-				cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numDirs) + 1);
+			    cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numDirs)
+					+ 1);
 		else
 			UDF_SB_LVIDIU(sb)->numFiles =
-				cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numFiles) + 1);
+			    cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numFiles)
+					+ 1);
 		UDF_I_UNIQUE(inode) = uniqueID = le64_to_cpu(lvhd->uniqueID);
 		if (!(++uniqueID & 0x00000000FFFFFFFFUL))
 			uniqueID += 16;
@@ -109,35 +114,34 @@ struct inode * udf_new_inode (struct ino
 	}
 	inode->i_mode = mode;
 	inode->i_uid = current->fsuid;
-	if (dir->i_mode & S_ISGID)
-	{
+	if (dir->i_mode & S_ISGID) {
 		inode->i_gid = dir->i_gid;
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
-	}
-	else
+	} else
 		inode->i_gid = current->fsgid;
 
 	UDF_I_LOCATION(inode).logicalBlockNum = block;
-	UDF_I_LOCATION(inode).partitionReferenceNum = UDF_I_LOCATION(dir).partitionReferenceNum;
+	UDF_I_LOCATION(inode).partitionReferenceNum =
+	    UDF_I_LOCATION(dir).partitionReferenceNum;
 	inode->i_ino = udf_get_lb_pblock(sb, UDF_I_LOCATION(inode), 0);
 	inode->i_blocks = 0;
 	UDF_I_LENEATTR(inode) = 0;
 	UDF_I_LENALLOC(inode) = 0;
 	UDF_I_USE(inode) = 0;
-	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_EXTENDED_FE))
-	{
+	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_EXTENDED_FE)) {
 		UDF_I_EFE(inode) = 1;
 		UDF_UPDATE_UDFREV(inode->i_sb, UDF_VERS_USE_EXTENDED_FE);
-		UDF_I_DATA(inode) = kzalloc(inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry), GFP_KERNEL);
-	}
-	else
-	{
+		UDF_I_DATA(inode) =
+		    kzalloc(inode->i_sb->s_blocksize -
+			    sizeof(struct extendedFileEntry), GFP_KERNEL);
+	} else {
 		UDF_I_EFE(inode) = 0;
-		UDF_I_DATA(inode) = kzalloc(inode->i_sb->s_blocksize - sizeof(struct fileEntry), GFP_KERNEL);
+		UDF_I_DATA(inode) =
+		    kzalloc(inode->i_sb->s_blocksize - sizeof(struct fileEntry),
+			    GFP_KERNEL);
 	}
-	if (!UDF_I_DATA(inode))
-	{
+	if (!UDF_I_DATA(inode)) {
 		iput(inode);
 		*err = -ENOMEM;
 		mutex_unlock(&sbi->s_alloc_mutex);
@@ -150,13 +154,12 @@ struct inode * udf_new_inode (struct ino
 	else
 		UDF_I_ALLOCTYPE(inode) = ICBTAG_FLAG_AD_LONG;
 	inode->i_mtime = inode->i_atime = inode->i_ctime =
-		UDF_I_CRTIME(inode) = current_fs_time(inode->i_sb);
+	    UDF_I_CRTIME(inode) = current_fs_time(inode->i_sb);
 	insert_inode_hash(inode);
 	mark_inode_dirty(inode);
 	mutex_unlock(&sbi->s_alloc_mutex);
 
-	if (DQUOT_ALLOC_INODE(inode))
-	{
+	if (DQUOT_ALLOC_INODE(inode)) {
 		DQUOT_DROP(inode);
 		inode->i_flags |= S_NOQUOTA;
 		inode->i_nlink = 0;
diff -puN fs/udf/inode.c~udf-coding-style-conversion-lindent fs/udf/inode.c
--- a/fs/udf/inode.c~udf-coding-style-conversion-lindent
+++ a/fs/udf/inode.c
@@ -51,18 +51,18 @@ static int udf_update_inode(struct inode
 static void udf_fill_inode(struct inode *, struct buffer_head *);
 static int udf_alloc_i_data(struct inode *inode, size_t size);
 static struct buffer_head *inode_getblk(struct inode *, sector_t, int *,
-	long *, int *);
+					long *, int *);
 static int8_t udf_insert_aext(struct inode *, struct extent_position,
-	kernel_lb_addr, uint32_t);
+			      kernel_lb_addr, uint32_t);
 static void udf_split_extents(struct inode *, int *, int, int,
-	kernel_long_ad [EXTENT_MERGE_SIZE], int *);
+			      kernel_long_ad[EXTENT_MERGE_SIZE], int *);
 static void udf_prealloc_extents(struct inode *, int, int,
-	 kernel_long_ad [EXTENT_MERGE_SIZE], int *);
+				 kernel_long_ad[EXTENT_MERGE_SIZE], int *);
 static void udf_merge_extents(struct inode *,
-	 kernel_long_ad [EXTENT_MERGE_SIZE], int *);
+			      kernel_long_ad[EXTENT_MERGE_SIZE], int *);
 static void udf_update_extents(struct inode *,
-	kernel_long_ad [EXTENT_MERGE_SIZE], int, int,
-	struct extent_position *);
+			       kernel_long_ad[EXTENT_MERGE_SIZE], int, int,
+			       struct extent_position *);
 static int udf_get_block(struct inode *, sector_t, struct buffer_head *, int);
 
 /*
@@ -81,7 +81,7 @@ static int udf_get_block(struct inode *,
  *
  *  Called at the last iput() if i_nlink is zero.
  */
-void udf_delete_inode(struct inode * inode)
+void udf_delete_inode(struct inode *inode)
 {
 	truncate_inode_pages(&inode->i_data, 0);
 
@@ -97,7 +97,7 @@ void udf_delete_inode(struct inode * ino
 
 	unlock_kernel();
 	return;
-no_delete:
+      no_delete:
 	clear_inode(inode);
 }
 
@@ -132,26 +132,27 @@ static int udf_readpage(struct file *fil
 	return block_read_full_page(page, udf_get_block);
 }
 
-static int udf_prepare_write(struct file *file, struct page *page, unsigned from, unsigned to)
+static int udf_prepare_write(struct file *file, struct page *page,
+			     unsigned from, unsigned to)
 {
 	return block_prepare_write(page, from, to, udf_get_block);
 }
 
 static sector_t udf_bmap(struct address_space *mapping, sector_t block)
 {
-	return generic_block_bmap(mapping,block,udf_get_block);
+	return generic_block_bmap(mapping, block, udf_get_block);
 }
 
 const struct address_space_operations udf_aops = {
-	.readpage		= udf_readpage,
-	.writepage		= udf_writepage,
-	.sync_page		= block_sync_page,
-	.prepare_write		= udf_prepare_write,
-	.commit_write		= generic_commit_write,
-	.bmap			= udf_bmap,
+	.readpage = udf_readpage,
+	.writepage = udf_writepage,
+	.sync_page = block_sync_page,
+	.prepare_write = udf_prepare_write,
+	.commit_write = generic_commit_write,
+	.bmap = udf_bmap,
 };
 
-void udf_expand_file_adinicb(struct inode * inode, int newsize, int * err)
+void udf_expand_file_adinicb(struct inode *inode, int newsize, int *err)
 {
 	struct page *page;
 	char *kaddr;
@@ -163,8 +164,7 @@ void udf_expand_file_adinicb(struct inod
 	/* from now on we have normal address_space methods */
 	inode->i_data.a_ops = &udf_aops;
 
-	if (!UDF_I_LENALLOC(inode))
-	{
+	if (!UDF_I_LENALLOC(inode)) {
 		if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
 			UDF_I_ALLOCTYPE(inode) = ICBTAG_FLAG_AD_SHORT;
 		else
@@ -176,19 +176,18 @@ void udf_expand_file_adinicb(struct inod
 	page = grab_cache_page(inode->i_mapping, 0);
 	BUG_ON(!PageLocked(page));
 
-	if (!PageUptodate(page))
-	{
+	if (!PageUptodate(page)) {
 		kaddr = kmap(page);
 		memset(kaddr + UDF_I_LENALLOC(inode), 0x00,
-			PAGE_CACHE_SIZE - UDF_I_LENALLOC(inode));
+		       PAGE_CACHE_SIZE - UDF_I_LENALLOC(inode));
 		memcpy(kaddr, UDF_I_DATA(inode) + UDF_I_LENEATTR(inode),
-			UDF_I_LENALLOC(inode));
+		       UDF_I_LENALLOC(inode));
 		flush_dcache_page(page);
 		SetPageUptodate(page);
 		kunmap(page);
 	}
 	memset(UDF_I_DATA(inode) + UDF_I_LENEATTR(inode), 0x00,
-		UDF_I_LENALLOC(inode));
+	       UDF_I_LENALLOC(inode));
 	UDF_I_LENALLOC(inode) = 0;
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
 		UDF_I_ALLOCTYPE(inode) = ICBTAG_FLAG_AD_SHORT;
@@ -201,7 +200,8 @@ void udf_expand_file_adinicb(struct inod
 	mark_inode_dirty(inode);
 }
 
-struct buffer_head * udf_expand_dir_adinicb(struct inode *inode, int *block, int *err)
+struct buffer_head *udf_expand_dir_adinicb(struct inode *inode, int *block,
+					   int *err)
 {
 	int newblock;
 	struct buffer_head *dbh = NULL;
@@ -220,8 +220,7 @@ struct buffer_head * udf_expand_dir_adin
 	else
 		alloctype = ICBTAG_FLAG_AD_LONG;
 
-	if (!inode->i_size)
-	{
+	if (!inode->i_size) {
 		UDF_I_ALLOCTYPE(inode) = alloctype;
 		mark_inode_dirty(inode);
 		return NULL;
@@ -229,13 +228,14 @@ struct buffer_head * udf_expand_dir_adin
 
 	/* alloc block, and copy data to it */
 	*block = udf_new_block(inode->i_sb, inode,
-		UDF_I_LOCATION(inode).partitionReferenceNum,
-		UDF_I_LOCATION(inode).logicalBlockNum, err);
+			       UDF_I_LOCATION(inode).partitionReferenceNum,
+			       UDF_I_LOCATION(inode).logicalBlockNum, err);
 
 	if (!(*block))
 		return NULL;
 	newblock = udf_get_pblock(inode->i_sb, *block,
-		UDF_I_LOCATION(inode).partitionReferenceNum, 0);
+				  UDF_I_LOCATION(inode).partitionReferenceNum,
+				  0);
 	if (!newblock)
 		return NULL;
 	dbh = udf_tgetblk(inode->i_sb, newblock);
@@ -247,16 +247,17 @@ struct buffer_head * udf_expand_dir_adin
 	unlock_buffer(dbh);
 	mark_buffer_dirty_inode(dbh, inode);
 
-	sfibh.soffset = sfibh.eoffset = (f_pos & ((inode->i_sb->s_blocksize - 1) >> 2)) << 2;
+	sfibh.soffset = sfibh.eoffset =
+	    (f_pos & ((inode->i_sb->s_blocksize - 1) >> 2)) << 2;
 	sfibh.sbh = sfibh.ebh = NULL;
 	dfibh.soffset = dfibh.eoffset = 0;
 	dfibh.sbh = dfibh.ebh = dbh;
-	while ( (f_pos < size) )
-	{
+	while ((f_pos < size)) {
 		UDF_I_ALLOCTYPE(inode) = ICBTAG_FLAG_AD_IN_ICB;
-		sfi = udf_fileident_read(inode, &f_pos, &sfibh, &cfi, NULL, NULL, NULL, NULL);
-		if (!sfi)
-		{
+		sfi =
+		    udf_fileident_read(inode, &f_pos, &sfibh, &cfi, NULL, NULL,
+				       NULL, NULL);
+		if (!sfi) {
 			brelse(dbh);
 			return NULL;
 		}
@@ -266,8 +267,8 @@ struct buffer_head * udf_expand_dir_adin
 		dfibh.eoffset += (sfibh.eoffset - sfibh.soffset);
 		dfi = (struct fileIdentDesc *)(dbh->b_data + dfibh.soffset);
 		if (udf_write_fi(inode, sfi, dfi, &dfibh, sfi->impUse,
-			sfi->fileIdent + le16_to_cpu(sfi->lengthOfImpUse)))
-		{
+				 sfi->fileIdent +
+				 le16_to_cpu(sfi->lengthOfImpUse))) {
 			UDF_I_ALLOCTYPE(inode) = ICBTAG_FLAG_AD_IN_ICB;
 			brelse(dbh);
 			return NULL;
@@ -275,10 +276,12 @@ struct buffer_head * udf_expand_dir_adin
 	}
 	mark_buffer_dirty_inode(dbh, inode);
 
-	memset(UDF_I_DATA(inode) + UDF_I_LENEATTR(inode), 0, UDF_I_LENALLOC(inode));
+	memset(UDF_I_DATA(inode) + UDF_I_LENEATTR(inode), 0,
+	       UDF_I_LENALLOC(inode));
 	UDF_I_LENALLOC(inode) = 0;
 	eloc.logicalBlockNum = *block;
-	eloc.partitionReferenceNum = UDF_I_LOCATION(inode).partitionReferenceNum;
+	eloc.partitionReferenceNum =
+	    UDF_I_LOCATION(inode).partitionReferenceNum;
 	elen = inode->i_size;
 	UDF_I_LENEXTENTS(inode) = elen;
 	epos.bh = NULL;
@@ -292,14 +295,14 @@ struct buffer_head * udf_expand_dir_adin
 	return dbh;
 }
 
-static int udf_get_block(struct inode *inode, sector_t block, struct buffer_head *bh_result, int create)
+static int udf_get_block(struct inode *inode, sector_t block,
+			 struct buffer_head *bh_result, int create)
 {
 	int err, new;
 	struct buffer_head *bh;
 	unsigned long phys;
 
-	if (!create)
-	{
+	if (!create) {
 		phys = udf_block_map(inode, block);
 		if (phys)
 			map_bh(bh_result, inode->i_sb, phys);
@@ -315,10 +318,9 @@ static int udf_get_block(struct inode *i
 	if (block < 0)
 		goto abort_negative;
 
-	if (block == UDF_I_NEXT_ALLOC_BLOCK(inode) + 1)
-	{
-		UDF_I_NEXT_ALLOC_BLOCK(inode) ++;
-		UDF_I_NEXT_ALLOC_GOAL(inode) ++;
+	if (block == UDF_I_NEXT_ALLOC_BLOCK(inode) + 1) {
+		UDF_I_NEXT_ALLOC_BLOCK(inode)++;
+		UDF_I_NEXT_ALLOC_GOAL(inode)++;
 	}
 
 	err = 0;
@@ -332,29 +334,27 @@ static int udf_get_block(struct inode *i
 	if (new)
 		set_buffer_new(bh_result);
 	map_bh(bh_result, inode->i_sb, phys);
-abort:
+      abort:
 	unlock_kernel();
 	return err;
 
-abort_negative:
+      abort_negative:
 	udf_warning(inode->i_sb, "udf_get_block", "block < 0");
 	goto abort;
 }
 
-static struct buffer_head *
-udf_getblk(struct inode *inode, long block, int create, int *err)
+static struct buffer_head *udf_getblk(struct inode *inode, long block,
+				      int create, int *err)
 {
 	struct buffer_head dummy;
 
 	dummy.b_state = 0;
 	dummy.b_blocknr = -1000;
 	*err = udf_get_block(inode, block, &dummy, create);
-	if (!*err && buffer_mapped(&dummy))
-	{
+	if (!*err && buffer_mapped(&dummy)) {
 		struct buffer_head *bh;
 		bh = sb_getblk(inode->i_sb, dummy.b_blocknr);
-		if (buffer_new(&dummy))
-		{
+		if (buffer_new(&dummy)) {
 			lock_buffer(bh);
 			memset(bh->b_data, 0x00, inode->i_sb->s_blocksize);
 			set_buffer_uptodate(bh);
@@ -368,12 +368,12 @@ udf_getblk(struct inode *inode, long blo
 
 /* Extend the file by 'blocks' blocks, return the number of extents added */
 int udf_extend_file(struct inode *inode, struct extent_position *last_pos,
-	kernel_long_ad *last_ext, sector_t blocks)
+		    kernel_long_ad * last_ext, sector_t blocks)
 {
 	sector_t add;
 	int count = 0, fake = !(last_ext->extLength & UDF_EXTENT_LENGTH_MASK);
 	struct super_block *sb = inode->i_sb;
-	kernel_lb_addr prealloc_loc = {0, 0};
+	kernel_lb_addr prealloc_loc = { 0, 0 };
 	int prealloc_len = 0;
 
 	/* The previous extent is fake and we should not extend by anything
@@ -383,28 +383,32 @@ int udf_extend_file(struct inode *inode,
 	/* Round the last extent up to a multiple of block size */
 	if (last_ext->extLength & (sb->s_blocksize - 1)) {
 		last_ext->extLength =
-			(last_ext->extLength & UDF_EXTENT_FLAG_MASK) |
-			(((last_ext->extLength & UDF_EXTENT_LENGTH_MASK) +
-				sb->s_blocksize - 1) & ~(sb->s_blocksize - 1));
+		    (last_ext->extLength & UDF_EXTENT_FLAG_MASK) |
+		    (((last_ext->extLength & UDF_EXTENT_LENGTH_MASK) +
+		      sb->s_blocksize - 1) & ~(sb->s_blocksize - 1));
 		UDF_I_LENEXTENTS(inode) =
-			(UDF_I_LENEXTENTS(inode) + sb->s_blocksize - 1) &
-				~(sb->s_blocksize - 1);
+		    (UDF_I_LENEXTENTS(inode) + sb->s_blocksize - 1) &
+		    ~(sb->s_blocksize - 1);
 	}
 	/* Last extent are just preallocated blocks? */
-	if ((last_ext->extLength & UDF_EXTENT_FLAG_MASK) == EXT_NOT_RECORDED_ALLOCATED) {
+	if ((last_ext->extLength & UDF_EXTENT_FLAG_MASK) ==
+	    EXT_NOT_RECORDED_ALLOCATED) {
 		/* Save the extent so that we can reattach it to the end */
 		prealloc_loc = last_ext->extLocation;
 		prealloc_len = last_ext->extLength;
 		/* Mark the extent as a hole */
 		last_ext->extLength = EXT_NOT_RECORDED_NOT_ALLOCATED |
-			(last_ext->extLength & UDF_EXTENT_LENGTH_MASK);
+		    (last_ext->extLength & UDF_EXTENT_LENGTH_MASK);
 		last_ext->extLocation.logicalBlockNum = 0;
-       		last_ext->extLocation.partitionReferenceNum = 0;
+		last_ext->extLocation.partitionReferenceNum = 0;
 	}
 	/* Can we merge with the previous extent? */
-	if ((last_ext->extLength & UDF_EXTENT_FLAG_MASK) == EXT_NOT_RECORDED_NOT_ALLOCATED) {
-		add = ((1<<30) - sb->s_blocksize - (last_ext->extLength &
-			UDF_EXTENT_LENGTH_MASK)) >> sb->s_blocksize_bits;
+	if ((last_ext->extLength & UDF_EXTENT_FLAG_MASK) ==
+	    EXT_NOT_RECORDED_NOT_ALLOCATED) {
+		add =
+		    ((1 << 30) - sb->s_blocksize -
+		     (last_ext->extLength & UDF_EXTENT_LENGTH_MASK)) >> sb->
+		    s_blocksize_bits;
 		if (add > blocks)
 			add = blocks;
 		blocks -= add;
@@ -413,40 +417,42 @@ int udf_extend_file(struct inode *inode,
 
 	if (fake) {
 		udf_add_aext(inode, last_pos, last_ext->extLocation,
-			last_ext->extLength, 1);
+			     last_ext->extLength, 1);
 		count++;
-	}
-	else
-		udf_write_aext(inode, last_pos, last_ext->extLocation, last_ext->extLength, 1);
+	} else
+		udf_write_aext(inode, last_pos, last_ext->extLocation,
+			       last_ext->extLength, 1);
 	/* Managed to do everything necessary? */
 	if (!blocks)
 		goto out;
 
 	/* All further extents will be NOT_RECORDED_NOT_ALLOCATED */
 	last_ext->extLocation.logicalBlockNum = 0;
-       	last_ext->extLocation.partitionReferenceNum = 0;
-	add = (1 << (30-sb->s_blocksize_bits)) - 1;
-	last_ext->extLength = EXT_NOT_RECORDED_NOT_ALLOCATED | (add << sb->s_blocksize_bits);
+	last_ext->extLocation.partitionReferenceNum = 0;
+	add = (1 << (30 - sb->s_blocksize_bits)) - 1;
+	last_ext->extLength =
+	    EXT_NOT_RECORDED_NOT_ALLOCATED | (add << sb->s_blocksize_bits);
 	/* Create enough extents to cover the whole hole */
 	while (blocks > add) {
 		blocks -= add;
 		if (udf_add_aext(inode, last_pos, last_ext->extLocation,
-			last_ext->extLength, 1) == -1)
+				 last_ext->extLength, 1) == -1)
 			return -1;
 		count++;
 	}
 	if (blocks) {
 		last_ext->extLength = EXT_NOT_RECORDED_NOT_ALLOCATED |
-			(blocks << sb->s_blocksize_bits);
+		    (blocks << sb->s_blocksize_bits);
 		if (udf_add_aext(inode, last_pos, last_ext->extLocation,
-			last_ext->extLength, 1) == -1)
+				 last_ext->extLength, 1) == -1)
 			return -1;
 		count++;
 	}
-out:
+      out:
 	/* Do we have some preallocated blocks saved? */
 	if (prealloc_len) {
-		if (udf_add_aext(inode, last_pos, prealloc_loc, prealloc_len, 1) == -1)
+		if (udf_add_aext(inode, last_pos, prealloc_loc, prealloc_len, 1)
+		    == -1)
 			return -1;
 		last_ext->extLocation = prealloc_loc;
 		last_ext->extLength = prealloc_len;
@@ -462,8 +468,8 @@ out:
 	return count;
 }
 
-static struct buffer_head * inode_getblk(struct inode * inode, sector_t block,
-	int *err, long *phys, int *new)
+static struct buffer_head *inode_getblk(struct inode *inode, sector_t block,
+					int *err, long *phys, int *new)
 {
 	static sector_t last_block;
 	struct buffer_head *result = NULL;
@@ -484,21 +490,18 @@ static struct buffer_head * inode_getblk
 	prev_epos.block = UDF_I_LOCATION(inode);
 	prev_epos.bh = NULL;
 	cur_epos = next_epos = prev_epos;
-	b_off = (loff_t)block << inode->i_sb->s_blocksize_bits;
+	b_off = (loff_t) block << inode->i_sb->s_blocksize_bits;
 
 	/* find the extent which contains the block we are looking for.
-       alternate between laarr[0] and laarr[1] for locations of the
-       current extent, and the previous extent */
-	do
-	{
-		if (prev_epos.bh != cur_epos.bh)
-		{
+	   alternate between laarr[0] and laarr[1] for locations of the
+	   current extent, and the previous extent */
+	do {
+		if (prev_epos.bh != cur_epos.bh) {
 			brelse(prev_epos.bh);
 			get_bh(cur_epos.bh);
 			prev_epos.bh = cur_epos.bh;
 		}
-		if (cur_epos.bh != next_epos.bh)
-		{
+		if (cur_epos.bh != next_epos.bh) {
 			brelse(cur_epos.bh);
 			get_bh(next_epos.bh);
 			cur_epos.bh = next_epos.bh;
@@ -512,7 +515,8 @@ static struct buffer_head * inode_getblk
 		prev_epos.offset = cur_epos.offset;
 		cur_epos.offset = next_epos.offset;
 
-		if ((etype = udf_next_aext(inode, &next_epos, &eloc, &elen, 1)) == -1)
+		if ((etype =
+		     udf_next_aext(inode, &next_epos, &eloc, &elen, 1)) == -1)
 			break;
 
 		c = !c;
@@ -522,10 +526,10 @@ static struct buffer_head * inode_getblk
 
 		if (etype != (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30))
 			pgoal = eloc.logicalBlockNum +
-				((elen + inode->i_sb->s_blocksize - 1) >>
-				inode->i_sb->s_blocksize_bits);
+			    ((elen + inode->i_sb->s_blocksize - 1) >>
+			     inode->i_sb->s_blocksize_bits);
 
-		count ++;
+		count++;
 	} while (lbcount + elen <= b_off);
 
 	b_off -= lbcount;
@@ -538,15 +542,13 @@ static struct buffer_head * inode_getblk
 	udf_next_aext(inode, &cur_epos, &tmpeloc, &tmpelen, 0);
 
 	/* if the extent is allocated and recorded, return the block
-       if the extent is not a multiple of the blocksize, round up */
+	   if the extent is not a multiple of the blocksize, round up */
 
-	if (etype == (EXT_RECORDED_ALLOCATED >> 30))
-	{
-		if (elen & (inode->i_sb->s_blocksize - 1))
-		{
+	if (etype == (EXT_RECORDED_ALLOCATED >> 30)) {
+		if (elen & (inode->i_sb->s_blocksize - 1)) {
 			elen = EXT_RECORDED_ALLOCATED |
-				((elen + inode->i_sb->s_blocksize - 1) &
-				~(inode->i_sb->s_blocksize - 1));
+			    ((elen + inode->i_sb->s_blocksize - 1) &
+			     ~(inode->i_sb->s_blocksize - 1));
 			etype = udf_write_aext(inode, &cur_epos, eloc, elen, 1);
 		}
 		brelse(prev_epos.bh);
@@ -559,18 +561,17 @@ static struct buffer_head * inode_getblk
 
 	last_block = block;
 	/* Are we beyond EOF? */
-	if (etype == -1)
-	{
+	if (etype == -1) {
 		int ret;
 
 		if (count) {
 			if (c)
 				laarr[0] = laarr[1];
 			startnum = 1;
-		}
-		else {
+		} else {
 			/* Create a fake extent when there's not one */
-			memset(&laarr[0].extLocation, 0x00, sizeof(kernel_lb_addr));
+			memset(&laarr[0].extLocation, 0x00,
+			       sizeof(kernel_lb_addr));
 			laarr[0].extLength = EXT_NOT_RECORDED_NOT_ALLOCATED;
 			/* Will udf_extend_file() create real extent from a fake one? */
 			startnum = (offset > 0);
@@ -590,26 +591,26 @@ static struct buffer_head * inode_getblk
 		offset = 0;
 		count += ret;
 		/* We are not covered by a preallocated extent? */
-		if ((laarr[0].extLength & UDF_EXTENT_FLAG_MASK) != EXT_NOT_RECORDED_ALLOCATED) {
+		if ((laarr[0].extLength & UDF_EXTENT_FLAG_MASK) !=
+		    EXT_NOT_RECORDED_ALLOCATED) {
 			/* Is there any real extent? - otherwise we overwrite
 			 * the fake one... */
 			if (count)
 				c = !c;
 			laarr[c].extLength = EXT_NOT_RECORDED_NOT_ALLOCATED |
-				inode->i_sb->s_blocksize;
-			memset(&laarr[c].extLocation, 0x00, sizeof(kernel_lb_addr));
-			count ++;
-			endnum ++;
+			    inode->i_sb->s_blocksize;
+			memset(&laarr[c].extLocation, 0x00,
+			       sizeof(kernel_lb_addr));
+			count++;
+			endnum++;
 		}
-		endnum = c+1;
+		endnum = c + 1;
 		lastblock = 1;
-	}
-	else {
+	} else {
 		endnum = startnum = ((count > 2) ? 2 : count);
 
 		/* if the current extent is in position 0, swap it with the previous */
-		if (!c && count != 1)
-		{
+		if (!c && count != 1) {
 			laarr[2] = laarr[0];
 			laarr[0] = laarr[1];
 			laarr[1] = laarr[2];
@@ -617,37 +618,37 @@ static struct buffer_head * inode_getblk
 		}
 
 		/* if the current block is located in an extent, read the next extent */
-		if ((etype = udf_next_aext(inode, &next_epos, &eloc, &elen, 0)) != -1)
-		{
-			laarr[c+1].extLength = (etype << 30) | elen;
-			laarr[c+1].extLocation = eloc;
-			count ++;
-			startnum ++;
-			endnum ++;
-		}
-		else {
+		if ((etype =
+		     udf_next_aext(inode, &next_epos, &eloc, &elen, 0)) != -1) {
+			laarr[c + 1].extLength = (etype << 30) | elen;
+			laarr[c + 1].extLocation = eloc;
+			count++;
+			startnum++;
+			endnum++;
+		} else {
 			lastblock = 1;
 		}
 	}
 
 	/* if the current extent is not recorded but allocated, get the
-		block in the extent corresponding to the requested block */
+	   block in the extent corresponding to the requested block */
 	if ((laarr[c].extLength >> 30) == (EXT_NOT_RECORDED_ALLOCATED >> 30))
 		newblocknum = laarr[c].extLocation.logicalBlockNum + offset;
-	else /* otherwise, allocate a new block */
-	{
+	else {			/* otherwise, allocate a new block */
+
 		if (UDF_I_NEXT_ALLOC_BLOCK(inode) == block)
 			goal = UDF_I_NEXT_ALLOC_GOAL(inode);
 
-		if (!goal)
-		{
+		if (!goal) {
 			if (!(goal = pgoal))
-				goal = UDF_I_LOCATION(inode).logicalBlockNum + 1;
+				goal =
+				    UDF_I_LOCATION(inode).logicalBlockNum + 1;
 		}
 
 		if (!(newblocknum = udf_new_block(inode->i_sb, inode,
-			UDF_I_LOCATION(inode).partitionReferenceNum, goal, err)))
-		{
+						  UDF_I_LOCATION(inode).
+						  partitionReferenceNum, goal,
+						  err))) {
 			brelse(prev_epos.bh);
 			*err = -ENOSPC;
 			return NULL;
@@ -656,8 +657,8 @@ static struct buffer_head * inode_getblk
 	}
 
 	/* if the extent the requsted block is located in contains multiple blocks,
-       split the extent into at most three extents. blocks prior to requested
-       block, requested block, and blocks after requested block */
+	   split the extent into at most three extents. blocks prior to requested
+	   block, requested block, and blocks after requested block */
 	udf_split_extents(inode, &c, offset, newblocknum, laarr, &endnum);
 
 #ifdef UDF_PREALLOCATE
@@ -669,15 +670,15 @@ static struct buffer_head * inode_getblk
 	udf_merge_extents(inode, laarr, &endnum);
 
 	/* write back the new extents, inserting new extents if the new number
-	of extents is greater than the old number, and deleting extents if
-	the new number of extents is less than the old number */
+	   of extents is greater than the old number, and deleting extents if
+	   the new number of extents is less than the old number */
 	udf_update_extents(inode, laarr, startnum, endnum, &prev_epos);
 
 	brelse(prev_epos.bh);
 
 	if (!(newblock = udf_get_pblock(inode->i_sb, newblocknum,
-		UDF_I_LOCATION(inode).partitionReferenceNum, 0)))
-	{
+					UDF_I_LOCATION(inode).
+					partitionReferenceNum, 0))) {
 		return NULL;
 	}
 	*phys = newblock;
@@ -694,283 +695,329 @@ static struct buffer_head * inode_getblk
 	return result;
 }
 
-static void udf_split_extents(struct inode *inode, int *c, int offset, int newblocknum,
-	kernel_long_ad laarr[EXTENT_MERGE_SIZE], int *endnum)
+static void udf_split_extents(struct inode *inode, int *c, int offset,
+			      int newblocknum,
+			      kernel_long_ad laarr[EXTENT_MERGE_SIZE],
+			      int *endnum)
 {
 	if ((laarr[*c].extLength >> 30) == (EXT_NOT_RECORDED_ALLOCATED >> 30) ||
-		(laarr[*c].extLength >> 30) == (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30))
-	{
+	    (laarr[*c].extLength >> 30) ==
+	    (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30)) {
 		int curr = *c;
 		int blen = ((laarr[curr].extLength & UDF_EXTENT_LENGTH_MASK) +
-			inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits;
+			    inode->i_sb->s_blocksize -
+			    1) >> inode->i_sb->s_blocksize_bits;
 		int8_t etype = (laarr[curr].extLength >> 30);
 
-		if (blen == 1)
-			;
-		else if (!offset || blen == offset + 1)
-		{
-			laarr[curr+2] = laarr[curr+1];
-			laarr[curr+1] = laarr[curr];
-		}
-		else
-		{
-			laarr[curr+3] = laarr[curr+1];
-			laarr[curr+2] = laarr[curr+1] = laarr[curr];
-		}
-
-		if (offset)
-		{
-			if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30))
-			{
-				udf_free_blocks(inode->i_sb, inode, laarr[curr].extLocation, 0, offset);
-				laarr[curr].extLength = EXT_NOT_RECORDED_NOT_ALLOCATED |
-					(offset << inode->i_sb->s_blocksize_bits);
+		if (blen == 1) ;
+		else if (!offset || blen == offset + 1) {
+			laarr[curr + 2] = laarr[curr + 1];
+			laarr[curr + 1] = laarr[curr];
+		} else {
+			laarr[curr + 3] = laarr[curr + 1];
+			laarr[curr + 2] = laarr[curr + 1] = laarr[curr];
+		}
+
+		if (offset) {
+			if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
+				udf_free_blocks(inode->i_sb, inode,
+						laarr[curr].extLocation, 0,
+						offset);
+				laarr[curr].extLength =
+				    EXT_NOT_RECORDED_NOT_ALLOCATED | (offset <<
+								      inode->
+								      i_sb->
+								      s_blocksize_bits);
 				laarr[curr].extLocation.logicalBlockNum = 0;
-				laarr[curr].extLocation.partitionReferenceNum = 0;
-			}
-			else
+				laarr[curr].extLocation.partitionReferenceNum =
+				    0;
+			} else
 				laarr[curr].extLength = (etype << 30) |
-					(offset << inode->i_sb->s_blocksize_bits);
-			curr ++;
-			(*c) ++;
-			(*endnum) ++;
+				    (offset << inode->i_sb->s_blocksize_bits);
+			curr++;
+			(*c)++;
+			(*endnum)++;
 		}
 
 		laarr[curr].extLocation.logicalBlockNum = newblocknum;
 		if (etype == (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30))
 			laarr[curr].extLocation.partitionReferenceNum =
-				UDF_I_LOCATION(inode).partitionReferenceNum;
+			    UDF_I_LOCATION(inode).partitionReferenceNum;
 		laarr[curr].extLength = EXT_RECORDED_ALLOCATED |
-			inode->i_sb->s_blocksize;
-		curr ++;
+		    inode->i_sb->s_blocksize;
+		curr++;
 
-		if (blen != offset + 1)
-		{
+		if (blen != offset + 1) {
 			if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30))
-				laarr[curr].extLocation.logicalBlockNum += (offset + 1);
-			laarr[curr].extLength = (etype << 30) |
-				((blen - (offset + 1)) << inode->i_sb->s_blocksize_bits);
-			curr ++;
-			(*endnum) ++;
+				laarr[curr].extLocation.logicalBlockNum +=
+				    (offset + 1);
+			laarr[curr].extLength =
+			    (etype << 30) | ((blen - (offset + 1)) << inode->
+					     i_sb->s_blocksize_bits);
+			curr++;
+			(*endnum)++;
 		}
 	}
 }
 
 static void udf_prealloc_extents(struct inode *inode, int c, int lastblock,
-	 kernel_long_ad laarr[EXTENT_MERGE_SIZE], int *endnum)
+				 kernel_long_ad laarr[EXTENT_MERGE_SIZE],
+				 int *endnum)
 {
 	int start, length = 0, currlength = 0, i;
 
-	if (*endnum >= (c+1))
-	{
+	if (*endnum >= (c + 1)) {
 		if (!lastblock)
 			return;
 		else
 			start = c;
-	}
-	else
-	{
-		if ((laarr[c+1].extLength >> 30) == (EXT_NOT_RECORDED_ALLOCATED >> 30))
-		{
-			start = c+1;
-			length = currlength = (((laarr[c+1].extLength & UDF_EXTENT_LENGTH_MASK) +
-				inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits);
-		}
-		else
+	} else {
+		if ((laarr[c + 1].extLength >> 30) ==
+		    (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
+			start = c + 1;
+			length = currlength =
+			    (((laarr[c + 1].
+			       extLength & UDF_EXTENT_LENGTH_MASK) +
+			      inode->i_sb->s_blocksize -
+			      1) >> inode->i_sb->s_blocksize_bits);
+		} else
 			start = c;
 	}
 
-	for (i=start+1; i<=*endnum; i++)
-	{
-		if (i == *endnum)
-		{
+	for (i = start + 1; i <= *endnum; i++) {
+		if (i == *endnum) {
 			if (lastblock)
 				length += UDF_DEFAULT_PREALLOC_BLOCKS;
-		}
-		else if ((laarr[i].extLength >> 30) == (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30))
-			length += (((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-				inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits);
+		} else if ((laarr[i].extLength >> 30) ==
+			   (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30))
+			length +=
+			    (((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
+			      inode->i_sb->s_blocksize -
+			      1) >> inode->i_sb->s_blocksize_bits);
 		else
 			break;
 	}
 
-	if (length)
-	{
+	if (length) {
 		int next = laarr[start].extLocation.logicalBlockNum +
-			(((laarr[start].extLength & UDF_EXTENT_LENGTH_MASK) +
-			inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits);
+		    (((laarr[start].extLength & UDF_EXTENT_LENGTH_MASK) +
+		      inode->i_sb->s_blocksize -
+		      1) >> inode->i_sb->s_blocksize_bits);
 		int numalloc = udf_prealloc_blocks(inode->i_sb, inode,
-			laarr[start].extLocation.partitionReferenceNum,
-			next, (UDF_DEFAULT_PREALLOC_BLOCKS > length ? length :
-				UDF_DEFAULT_PREALLOC_BLOCKS) - currlength);
+						   laarr[start].extLocation.
+						   partitionReferenceNum,
+						   next,
+						   (UDF_DEFAULT_PREALLOC_BLOCKS
+						    >
+						    length ? length :
+						    UDF_DEFAULT_PREALLOC_BLOCKS)
+						   - currlength);
 
-		if (numalloc)
-		{
-			if (start == (c+1))
+		if (numalloc) {
+			if (start == (c + 1))
 				laarr[start].extLength +=
-					(numalloc << inode->i_sb->s_blocksize_bits);
-			else
-			{
-				memmove(&laarr[c+2], &laarr[c+1],
-					sizeof(long_ad) * (*endnum - (c+1)));
-				(*endnum) ++;
-				laarr[c+1].extLocation.logicalBlockNum = next;
-				laarr[c+1].extLocation.partitionReferenceNum =
-					laarr[c].extLocation.partitionReferenceNum;
-				laarr[c+1].extLength = EXT_NOT_RECORDED_ALLOCATED |
-					(numalloc << inode->i_sb->s_blocksize_bits);
-				start = c+1;
+				    (numalloc << inode->i_sb->s_blocksize_bits);
+			else {
+				memmove(&laarr[c + 2], &laarr[c + 1],
+					sizeof(long_ad) * (*endnum - (c + 1)));
+				(*endnum)++;
+				laarr[c + 1].extLocation.logicalBlockNum = next;
+				laarr[c + 1].extLocation.partitionReferenceNum =
+				    laarr[c].extLocation.partitionReferenceNum;
+				laarr[c + 1].extLength =
+				    EXT_NOT_RECORDED_ALLOCATED | (numalloc <<
+								  inode->i_sb->
+								  s_blocksize_bits);
+				start = c + 1;
 			}
 
-			for (i=start+1; numalloc && i<*endnum; i++)
-			{
-				int elen = ((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-					inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits;
+			for (i = start + 1; numalloc && i < *endnum; i++) {
+				int elen =
+				    ((laarr[i].
+				      extLength & UDF_EXTENT_LENGTH_MASK) +
+				     inode->i_sb->s_blocksize -
+				     1) >> inode->i_sb->s_blocksize_bits;
 
-				if (elen > numalloc)
-				{
+				if (elen > numalloc) {
 					laarr[i].extLength -=
-						(numalloc << inode->i_sb->s_blocksize_bits);
+					    (numalloc << inode->i_sb->
+					     s_blocksize_bits);
 					numalloc = 0;
-				}
-				else
-				{
+				} else {
 					numalloc -= elen;
-					if (*endnum > (i+1))
-						memmove(&laarr[i], &laarr[i+1],
-							sizeof(long_ad) * (*endnum - (i+1)));
-					i --;
-					(*endnum) --;
+					if (*endnum > (i + 1))
+						memmove(&laarr[i],
+							&laarr[i + 1],
+							sizeof(long_ad) *
+							(*endnum - (i + 1)));
+					i--;
+					(*endnum)--;
 				}
 			}
-			UDF_I_LENEXTENTS(inode) += numalloc << inode->i_sb->s_blocksize_bits;
+			UDF_I_LENEXTENTS(inode) +=
+			    numalloc << inode->i_sb->s_blocksize_bits;
 		}
 	}
 }
 
 static void udf_merge_extents(struct inode *inode,
-	 kernel_long_ad laarr[EXTENT_MERGE_SIZE], int *endnum)
+			      kernel_long_ad laarr[EXTENT_MERGE_SIZE],
+			      int *endnum)
 {
 	int i;
 
-	for (i=0; i<(*endnum-1); i++)
-	{
-		if ((laarr[i].extLength >> 30) == (laarr[i+1].extLength >> 30))
-		{
-			if (((laarr[i].extLength >> 30) == (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30)) ||
-				((laarr[i+1].extLocation.logicalBlockNum - laarr[i].extLocation.logicalBlockNum) ==
-				(((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-				inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits)))
-			{
-				if (((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-					(laarr[i+1].extLength & UDF_EXTENT_LENGTH_MASK) +
-					inode->i_sb->s_blocksize - 1) & ~UDF_EXTENT_LENGTH_MASK)
-				{
-					laarr[i+1].extLength = (laarr[i+1].extLength -
-						(laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-						UDF_EXTENT_LENGTH_MASK) & ~(inode->i_sb->s_blocksize-1);
-					laarr[i].extLength = (laarr[i].extLength & UDF_EXTENT_FLAG_MASK) +
-						(UDF_EXTENT_LENGTH_MASK + 1) - inode->i_sb->s_blocksize;
-					laarr[i+1].extLocation.logicalBlockNum =
-						laarr[i].extLocation.logicalBlockNum +
-						((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) >>
-							inode->i_sb->s_blocksize_bits);
-				}
-				else
-				{
-					laarr[i].extLength = laarr[i+1].extLength +
-						(((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-						inode->i_sb->s_blocksize - 1) & ~(inode->i_sb->s_blocksize-1));
-					if (*endnum > (i+2))
-						memmove(&laarr[i+1], &laarr[i+2],
-							sizeof(long_ad) * (*endnum - (i+2)));
-					i --;
-					(*endnum) --;
+	for (i = 0; i < (*endnum - 1); i++) {
+		if ((laarr[i].extLength >> 30) ==
+		    (laarr[i + 1].extLength >> 30)) {
+			if (((laarr[i].extLength >> 30) ==
+			     (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30))
+			    ||
+			    ((laarr[i + 1].extLocation.logicalBlockNum -
+			      laarr[i].extLocation.logicalBlockNum) ==
+			     (((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
+			       inode->i_sb->s_blocksize -
+			       1) >> inode->i_sb->s_blocksize_bits))) {
+				if (((laarr[i].
+				      extLength & UDF_EXTENT_LENGTH_MASK) +
+				     (laarr[i + 1].
+				      extLength & UDF_EXTENT_LENGTH_MASK) +
+				     inode->i_sb->s_blocksize -
+				     1) & ~UDF_EXTENT_LENGTH_MASK) {
+					laarr[i + 1].extLength =
+					    (laarr[i + 1].extLength -
+					     (laarr[i].
+					      extLength &
+					      UDF_EXTENT_LENGTH_MASK) +
+					     UDF_EXTENT_LENGTH_MASK) & ~(inode->
+									 i_sb->
+									 s_blocksize
+									 - 1);
+					laarr[i].extLength =
+					    (laarr[i].
+					     extLength & UDF_EXTENT_FLAG_MASK) +
+					    (UDF_EXTENT_LENGTH_MASK + 1) -
+					    inode->i_sb->s_blocksize;
+					laarr[i +
+					      1].extLocation.logicalBlockNum =
+					    laarr[i].extLocation.
+					    logicalBlockNum +
+					    ((laarr[i].
+					      extLength &
+					      UDF_EXTENT_LENGTH_MASK) >> inode->
+					     i_sb->s_blocksize_bits);
+				} else {
+					laarr[i].extLength =
+					    laarr[i + 1].extLength +
+					    (((laarr[i].
+					       extLength &
+					       UDF_EXTENT_LENGTH_MASK) +
+					      inode->i_sb->s_blocksize -
+					      1) & ~(inode->i_sb->s_blocksize -
+						     1));
+					if (*endnum > (i + 2))
+						memmove(&laarr[i + 1],
+							&laarr[i + 2],
+							sizeof(long_ad) *
+							(*endnum - (i + 2)));
+					i--;
+					(*endnum)--;
 				}
 			}
-		}
-		else if (((laarr[i].extLength >> 30) == (EXT_NOT_RECORDED_ALLOCATED >> 30)) &&
-			((laarr[i+1].extLength >> 30) == (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30)))
-		{
-			udf_free_blocks(inode->i_sb, inode, laarr[i].extLocation, 0,
-				((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-				inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits);
+		} else
+		    if (((laarr[i].extLength >> 30) ==
+			 (EXT_NOT_RECORDED_ALLOCATED >> 30))
+			&& ((laarr[i + 1].extLength >> 30) ==
+			    (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30))) {
+			udf_free_blocks(inode->i_sb, inode,
+					laarr[i].extLocation, 0,
+					((laarr[i].
+					  extLength & UDF_EXTENT_LENGTH_MASK) +
+					 inode->i_sb->s_blocksize -
+					 1) >> inode->i_sb->s_blocksize_bits);
 			laarr[i].extLocation.logicalBlockNum = 0;
 			laarr[i].extLocation.partitionReferenceNum = 0;
 
 			if (((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-				(laarr[i+1].extLength & UDF_EXTENT_LENGTH_MASK) +
-				inode->i_sb->s_blocksize - 1) & ~UDF_EXTENT_LENGTH_MASK)
-			{
-				laarr[i+1].extLength = (laarr[i+1].extLength -
-					(laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-					UDF_EXTENT_LENGTH_MASK) & ~(inode->i_sb->s_blocksize-1);
-				laarr[i].extLength = (laarr[i].extLength & UDF_EXTENT_FLAG_MASK) +
-					(UDF_EXTENT_LENGTH_MASK + 1) - inode->i_sb->s_blocksize;
-			}
-			else
-			{
-				laarr[i].extLength = laarr[i+1].extLength +
-					(((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-					inode->i_sb->s_blocksize - 1) & ~(inode->i_sb->s_blocksize-1));
-				if (*endnum > (i+2))
-					memmove(&laarr[i+1], &laarr[i+2],
-						sizeof(long_ad) * (*endnum - (i+2)));
-				i --;
-				(*endnum) --;
+			     (laarr[i + 1].extLength & UDF_EXTENT_LENGTH_MASK) +
+			     inode->i_sb->s_blocksize -
+			     1) & ~UDF_EXTENT_LENGTH_MASK) {
+				laarr[i + 1].extLength =
+				    (laarr[i + 1].extLength -
+				     (laarr[i].
+				      extLength & UDF_EXTENT_LENGTH_MASK) +
+				     UDF_EXTENT_LENGTH_MASK) & ~(inode->i_sb->
+								 s_blocksize -
+								 1);
+				laarr[i].extLength =
+				    (laarr[i].
+				     extLength & UDF_EXTENT_FLAG_MASK) +
+				    (UDF_EXTENT_LENGTH_MASK + 1) -
+				    inode->i_sb->s_blocksize;
+			} else {
+				laarr[i].extLength = laarr[i + 1].extLength +
+				    (((laarr[i].
+				       extLength & UDF_EXTENT_LENGTH_MASK) +
+				      inode->i_sb->s_blocksize -
+				      1) & ~(inode->i_sb->s_blocksize - 1));
+				if (*endnum > (i + 2))
+					memmove(&laarr[i + 1], &laarr[i + 2],
+						sizeof(long_ad) * (*endnum -
+								   (i + 2)));
+				i--;
+				(*endnum)--;
 			}
-		}
-		else if ((laarr[i].extLength >> 30) == (EXT_NOT_RECORDED_ALLOCATED >> 30))
-		{
-			udf_free_blocks(inode->i_sb, inode, laarr[i].extLocation, 0,
-				((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-			       inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits);
+		} else if ((laarr[i].extLength >> 30) ==
+			   (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
+			udf_free_blocks(inode->i_sb, inode,
+					laarr[i].extLocation, 0,
+					((laarr[i].
+					  extLength & UDF_EXTENT_LENGTH_MASK) +
+					 inode->i_sb->s_blocksize -
+					 1) >> inode->i_sb->s_blocksize_bits);
 			laarr[i].extLocation.logicalBlockNum = 0;
 			laarr[i].extLocation.partitionReferenceNum = 0;
-			laarr[i].extLength = (laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) |
-				EXT_NOT_RECORDED_NOT_ALLOCATED;
+			laarr[i].extLength =
+			    (laarr[i].
+			     extLength & UDF_EXTENT_LENGTH_MASK) |
+			    EXT_NOT_RECORDED_NOT_ALLOCATED;
 		}
 	}
 }
 
 static void udf_update_extents(struct inode *inode,
-	kernel_long_ad laarr[EXTENT_MERGE_SIZE], int startnum, int endnum,
-	struct extent_position *epos)
+			       kernel_long_ad laarr[EXTENT_MERGE_SIZE],
+			       int startnum, int endnum,
+			       struct extent_position *epos)
 {
 	int start = 0, i;
 	kernel_lb_addr tmploc;
 	uint32_t tmplen;
 
-	if (startnum > endnum)
-	{
-		for (i=0; i<(startnum-endnum); i++)
+	if (startnum > endnum) {
+		for (i = 0; i < (startnum - endnum); i++)
 			udf_delete_aext(inode, *epos, laarr[i].extLocation,
-				laarr[i].extLength);
-	}
-	else if (startnum < endnum)
-	{
-		for (i=0; i<(endnum-startnum); i++)
-		{
+					laarr[i].extLength);
+	} else if (startnum < endnum) {
+		for (i = 0; i < (endnum - startnum); i++) {
 			udf_insert_aext(inode, *epos, laarr[i].extLocation,
-				laarr[i].extLength);
+					laarr[i].extLength);
 			udf_next_aext(inode, epos, &laarr[i].extLocation,
-				&laarr[i].extLength, 1);
-			start ++;
+				      &laarr[i].extLength, 1);
+			start++;
 		}
 	}
 
-	for (i=start; i<endnum; i++)
-	{
+	for (i = start; i < endnum; i++) {
 		udf_next_aext(inode, epos, &tmploc, &tmplen, 0);
 		udf_write_aext(inode, epos, laarr[i].extLocation,
-			laarr[i].extLength, 1);
+			       laarr[i].extLength, 1);
 	}
 }
 
-struct buffer_head * udf_bread(struct inode * inode, int block,
-	int create, int * err)
+struct buffer_head *udf_bread(struct inode *inode, int block,
+			      int create, int *err)
 {
-	struct buffer_head * bh = NULL;
+	struct buffer_head *bh = NULL;
 
 	bh = udf_getblk(inode, block, create, err);
 	if (!bh)
@@ -987,56 +1034,51 @@ struct buffer_head * udf_bread(struct in
 	return NULL;
 }
 
-void udf_truncate(struct inode * inode)
+void udf_truncate(struct inode *inode)
 {
 	int offset;
 	int err;
 
 	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
-			S_ISLNK(inode->i_mode)))
+	      S_ISLNK(inode->i_mode)))
 		return;
 	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
 		return;
 
 	lock_kernel();
-	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB)
-	{
-		if (inode->i_sb->s_blocksize < (udf_file_entry_alloc_offset(inode) +
-			inode->i_size))
-		{
+	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB) {
+		if (inode->i_sb->s_blocksize <
+		    (udf_file_entry_alloc_offset(inode) + inode->i_size)) {
 			udf_expand_file_adinicb(inode, inode->i_size, &err);
-			if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB)
-			{
+			if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB) {
 				inode->i_size = UDF_I_LENALLOC(inode);
 				unlock_kernel();
 				return;
-			}
-			else
+			} else
 				udf_truncate_extents(inode);
-		}
-		else
-		{
+		} else {
 			offset = inode->i_size & (inode->i_sb->s_blocksize - 1);
-			memset(UDF_I_DATA(inode) + UDF_I_LENEATTR(inode) + offset, 0x00, inode->i_sb->s_blocksize - offset - udf_file_entry_alloc_offset(inode));
+			memset(UDF_I_DATA(inode) + UDF_I_LENEATTR(inode) +
+			       offset, 0x00,
+			       inode->i_sb->s_blocksize - offset -
+			       udf_file_entry_alloc_offset(inode));
 			UDF_I_LENALLOC(inode) = inode->i_size;
 		}
-	}
-	else
-	{
-		block_truncate_page(inode->i_mapping, inode->i_size, udf_get_block);
+	} else {
+		block_truncate_page(inode->i_mapping, inode->i_size,
+				    udf_get_block);
 		udf_truncate_extents(inode);
 	}
 
 	inode->i_mtime = inode->i_ctime = current_fs_time(inode->i_sb);
 	if (IS_SYNC(inode))
-		udf_sync_inode (inode);
+		udf_sync_inode(inode);
 	else
 		mark_inode_dirty(inode);
 	unlock_kernel();
 }
 
-static void
-__udf_read_inode(struct inode *inode)
+static void __udf_read_inode(struct inode *inode)
 {
 	struct buffer_head *bh = NULL;
 	struct fileEntry *fe;
@@ -1056,19 +1098,18 @@ __udf_read_inode(struct inode *inode)
 	 */
 	bh = udf_read_ptagged(inode->i_sb, UDF_I_LOCATION(inode), 0, &ident);
 
-	if (!bh)
-	{
+	if (!bh) {
 		printk(KERN_ERR "udf: udf_read_inode(ino %ld) failed !bh\n",
-			inode->i_ino);
+		       inode->i_ino);
 		make_bad_inode(inode);
 		return;
 	}
 
 	if (ident != TAG_IDENT_FE && ident != TAG_IDENT_EFE &&
-		ident != TAG_IDENT_USE)
-	{
-		printk(KERN_ERR "udf: udf_read_inode(ino %ld) failed ident=%d\n",
-			inode->i_ino, ident);
+	    ident != TAG_IDENT_USE) {
+		printk(KERN_ERR
+		       "udf: udf_read_inode(ino %ld) failed ident=%d\n",
+		       inode->i_ino, ident);
 		brelse(bh);
 		make_bad_inode(inode);
 		return;
@@ -1076,51 +1117,46 @@ __udf_read_inode(struct inode *inode)
 
 	fe = (struct fileEntry *)bh->b_data;
 
-	if (le16_to_cpu(fe->icbTag.strategyType) == 4096)
-	{
+	if (le16_to_cpu(fe->icbTag.strategyType) == 4096) {
 		struct buffer_head *ibh = NULL, *nbh = NULL;
 		struct indirectEntry *ie;
 
-		ibh = udf_read_ptagged(inode->i_sb, UDF_I_LOCATION(inode), 1, &ident);
-		if (ident == TAG_IDENT_IE)
-		{
-			if (ibh)
-			{
+		ibh =
+		    udf_read_ptagged(inode->i_sb, UDF_I_LOCATION(inode), 1,
+				     &ident);
+		if (ident == TAG_IDENT_IE) {
+			if (ibh) {
 				kernel_lb_addr loc;
 				ie = (struct indirectEntry *)ibh->b_data;
 
 				loc = lelb_to_cpu(ie->indirectICB.extLocation);
 
 				if (ie->indirectICB.extLength &&
-					(nbh = udf_read_ptagged(inode->i_sb, loc, 0, &ident)))
-				{
-					if (ident == TAG_IDENT_FE ||
-						ident == TAG_IDENT_EFE)
-					{
-						memcpy(&UDF_I_LOCATION(inode), &loc, sizeof(kernel_lb_addr));
+				    (nbh =
+				     udf_read_ptagged(inode->i_sb, loc, 0,
+						      &ident))) {
+					if (ident == TAG_IDENT_FE
+					    || ident == TAG_IDENT_EFE) {
+						memcpy(&UDF_I_LOCATION(inode),
+						       &loc,
+						       sizeof(kernel_lb_addr));
 						brelse(bh);
 						brelse(ibh);
 						brelse(nbh);
 						__udf_read_inode(inode);
 						return;
-					}
-					else
-					{
+					} else {
 						brelse(nbh);
 						brelse(ibh);
 					}
-				}
-				else
+				} else
 					brelse(ibh);
 			}
-		}
-		else
+		} else
 			brelse(ibh);
-	}
-	else if (le16_to_cpu(fe->icbTag.strategyType) != 4)
-	{
+	} else if (le16_to_cpu(fe->icbTag.strategyType) != 4) {
 		printk(KERN_ERR "udf: unsupported strategy type: %d\n",
-			le16_to_cpu(fe->icbTag.strategyType));
+		       le16_to_cpu(fe->icbTag.strategyType));
 		brelse(bh);
 		make_bad_inode(inode);
 		return;
@@ -1143,62 +1179,70 @@ static void udf_fill_inode(struct inode 
 
 	if (le16_to_cpu(fe->icbTag.strategyType) == 4)
 		UDF_I_STRAT4096(inode) = 0;
-	else /* if (le16_to_cpu(fe->icbTag.strategyType) == 4096) */
+	else			/* if (le16_to_cpu(fe->icbTag.strategyType) == 4096) */
 		UDF_I_STRAT4096(inode) = 1;
 
-	UDF_I_ALLOCTYPE(inode) = le16_to_cpu(fe->icbTag.flags) & ICBTAG_FLAG_AD_MASK;
+	UDF_I_ALLOCTYPE(inode) =
+	    le16_to_cpu(fe->icbTag.flags) & ICBTAG_FLAG_AD_MASK;
 	UDF_I_UNIQUE(inode) = 0;
 	UDF_I_LENEATTR(inode) = 0;
 	UDF_I_LENEXTENTS(inode) = 0;
 	UDF_I_LENALLOC(inode) = 0;
 	UDF_I_NEXT_ALLOC_BLOCK(inode) = 0;
 	UDF_I_NEXT_ALLOC_GOAL(inode) = 0;
-	if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_EFE)
-	{
+	if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_EFE) {
 		UDF_I_EFE(inode) = 1;
 		UDF_I_USE(inode) = 0;
-		if (udf_alloc_i_data(inode, inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry)))
-		{
+		if (udf_alloc_i_data
+		    (inode,
+		     inode->i_sb->s_blocksize -
+		     sizeof(struct extendedFileEntry))) {
 			make_bad_inode(inode);
 			return;
 		}
-		memcpy(UDF_I_DATA(inode), bh->b_data + sizeof(struct extendedFileEntry), inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry));
-	}
-	else if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_FE)
-	{
+		memcpy(UDF_I_DATA(inode),
+		       bh->b_data + sizeof(struct extendedFileEntry),
+		       inode->i_sb->s_blocksize -
+		       sizeof(struct extendedFileEntry));
+	} else if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_FE) {
 		UDF_I_EFE(inode) = 0;
 		UDF_I_USE(inode) = 0;
-		if (udf_alloc_i_data(inode, inode->i_sb->s_blocksize - sizeof(struct fileEntry)))
-		{
+		if (udf_alloc_i_data
+		    (inode,
+		     inode->i_sb->s_blocksize - sizeof(struct fileEntry))) {
 			make_bad_inode(inode);
 			return;
 		}
-		memcpy(UDF_I_DATA(inode), bh->b_data + sizeof(struct fileEntry), inode->i_sb->s_blocksize - sizeof(struct fileEntry));
-	}
-	else if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_USE)
-	{
+		memcpy(UDF_I_DATA(inode), bh->b_data + sizeof(struct fileEntry),
+		       inode->i_sb->s_blocksize - sizeof(struct fileEntry));
+	} else if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_USE) {
 		UDF_I_EFE(inode) = 0;
 		UDF_I_USE(inode) = 1;
 		UDF_I_LENALLOC(inode) =
-			le32_to_cpu(
-				((struct unallocSpaceEntry *)bh->b_data)->lengthAllocDescs);
-		if (udf_alloc_i_data(inode, inode->i_sb->s_blocksize - sizeof(struct unallocSpaceEntry)))
-		{
+		    le32_to_cpu(((struct unallocSpaceEntry *)bh->b_data)->
+				lengthAllocDescs);
+		if (udf_alloc_i_data
+		    (inode,
+		     inode->i_sb->s_blocksize -
+		     sizeof(struct unallocSpaceEntry))) {
 			make_bad_inode(inode);
 			return;
 		}
-		memcpy(UDF_I_DATA(inode), bh->b_data + sizeof(struct unallocSpaceEntry), inode->i_sb->s_blocksize - sizeof(struct unallocSpaceEntry));
+		memcpy(UDF_I_DATA(inode),
+		       bh->b_data + sizeof(struct unallocSpaceEntry),
+		       inode->i_sb->s_blocksize -
+		       sizeof(struct unallocSpaceEntry));
 		return;
 	}
 
 	inode->i_uid = le32_to_cpu(fe->uid);
 	if (inode->i_uid == -1 || UDF_QUERY_FLAG(inode->i_sb,
-					UDF_FLAG_UID_IGNORE))
+						 UDF_FLAG_UID_IGNORE))
 		inode->i_uid = UDF_SB(inode->i_sb)->s_uid;
 
 	inode->i_gid = le32_to_cpu(fe->gid);
 	if (inode->i_gid == -1 || UDF_QUERY_FLAG(inode->i_sb,
-					UDF_FLAG_GID_IGNORE))
+						 UDF_FLAG_GID_IGNORE))
 		inode->i_gid = UDF_SB(inode->i_sb)->s_gid;
 
 	inode->i_nlink = le16_to_cpu(fe->fileLinkCount);
@@ -1211,41 +1255,31 @@ static void udf_fill_inode(struct inode 
 	inode->i_mode = udf_convert_permissions(fe);
 	inode->i_mode &= ~UDF_SB(inode->i_sb)->s_umask;
 
-	if (UDF_I_EFE(inode) == 0)
-	{
+	if (UDF_I_EFE(inode) == 0) {
 		inode->i_blocks = le64_to_cpu(fe->logicalBlocksRecorded) <<
-			(inode->i_sb->s_blocksize_bits - 9);
+		    (inode->i_sb->s_blocksize_bits - 9);
 
-		if ( udf_stamp_to_time(&convtime, &convtime_usec,
-			lets_to_cpu(fe->accessTime)) )
-		{
+		if (udf_stamp_to_time(&convtime, &convtime_usec,
+				      lets_to_cpu(fe->accessTime))) {
 			inode->i_atime.tv_sec = convtime;
 			inode->i_atime.tv_nsec = convtime_usec * 1000;
-		}
-		else
-		{
+		} else {
 			inode->i_atime = UDF_SB_RECORDTIME(inode->i_sb);
 		}
 
-		if ( udf_stamp_to_time(&convtime, &convtime_usec,
-			lets_to_cpu(fe->modificationTime)) )
-		{
+		if (udf_stamp_to_time(&convtime, &convtime_usec,
+				      lets_to_cpu(fe->modificationTime))) {
 			inode->i_mtime.tv_sec = convtime;
 			inode->i_mtime.tv_nsec = convtime_usec * 1000;
-		}
-		else
-		{
+		} else {
 			inode->i_mtime = UDF_SB_RECORDTIME(inode->i_sb);
 		}
 
-		if ( udf_stamp_to_time(&convtime, &convtime_usec,
-			lets_to_cpu(fe->attrTime)) )
-		{
+		if (udf_stamp_to_time(&convtime, &convtime_usec,
+				      lets_to_cpu(fe->attrTime))) {
 			inode->i_ctime.tv_sec = convtime;
 			inode->i_ctime.tv_nsec = convtime_usec * 1000;
-		}
-		else
-		{
+		} else {
 			inode->i_ctime = UDF_SB_RECORDTIME(inode->i_sb);
 		}
 
@@ -1253,65 +1287,51 @@ static void udf_fill_inode(struct inode 
 		UDF_I_LENEATTR(inode) = le32_to_cpu(fe->lengthExtendedAttr);
 		UDF_I_LENALLOC(inode) = le32_to_cpu(fe->lengthAllocDescs);
 		offset = sizeof(struct fileEntry) + UDF_I_LENEATTR(inode);
-	}
-	else
-	{
+	} else {
 		inode->i_blocks = le64_to_cpu(efe->logicalBlocksRecorded) <<
-			(inode->i_sb->s_blocksize_bits - 9);
+		    (inode->i_sb->s_blocksize_bits - 9);
 
-		if ( udf_stamp_to_time(&convtime, &convtime_usec,
-			lets_to_cpu(efe->accessTime)) )
-		{
+		if (udf_stamp_to_time(&convtime, &convtime_usec,
+				      lets_to_cpu(efe->accessTime))) {
 			inode->i_atime.tv_sec = convtime;
 			inode->i_atime.tv_nsec = convtime_usec * 1000;
-		}
-		else
-		{
+		} else {
 			inode->i_atime = UDF_SB_RECORDTIME(inode->i_sb);
 		}
 
-		if ( udf_stamp_to_time(&convtime, &convtime_usec,
-			lets_to_cpu(efe->modificationTime)) )
-		{
+		if (udf_stamp_to_time(&convtime, &convtime_usec,
+				      lets_to_cpu(efe->modificationTime))) {
 			inode->i_mtime.tv_sec = convtime;
 			inode->i_mtime.tv_nsec = convtime_usec * 1000;
-		}
-		else
-		{
+		} else {
 			inode->i_mtime = UDF_SB_RECORDTIME(inode->i_sb);
 		}
 
-		if ( udf_stamp_to_time(&convtime, &convtime_usec,
-			lets_to_cpu(efe->createTime)) )
-		{
+		if (udf_stamp_to_time(&convtime, &convtime_usec,
+				      lets_to_cpu(efe->createTime))) {
 			UDF_I_CRTIME(inode).tv_sec = convtime;
 			UDF_I_CRTIME(inode).tv_nsec = convtime_usec * 1000;
-		}
-		else
-		{
+		} else {
 			UDF_I_CRTIME(inode) = UDF_SB_RECORDTIME(inode->i_sb);
 		}
 
-		if ( udf_stamp_to_time(&convtime, &convtime_usec,
-			lets_to_cpu(efe->attrTime)) )
-		{
+		if (udf_stamp_to_time(&convtime, &convtime_usec,
+				      lets_to_cpu(efe->attrTime))) {
 			inode->i_ctime.tv_sec = convtime;
 			inode->i_ctime.tv_nsec = convtime_usec * 1000;
-		}
-		else
-		{
+		} else {
 			inode->i_ctime = UDF_SB_RECORDTIME(inode->i_sb);
 		}
 
 		UDF_I_UNIQUE(inode) = le64_to_cpu(efe->uniqueID);
 		UDF_I_LENEATTR(inode) = le32_to_cpu(efe->lengthExtendedAttr);
 		UDF_I_LENALLOC(inode) = le32_to_cpu(efe->lengthAllocDescs);
-		offset = sizeof(struct extendedFileEntry) + UDF_I_LENEATTR(inode);
+		offset =
+		    sizeof(struct extendedFileEntry) + UDF_I_LENEATTR(inode);
 	}
 
-	switch (fe->icbTag.fileType)
-	{
-		case ICBTAG_FILE_TYPE_DIRECTORY:
+	switch (fe->icbTag.fileType) {
+	case ICBTAG_FILE_TYPE_DIRECTORY:
 		{
 			inode->i_op = &udf_dir_inode_operations;
 			inode->i_fop = &udf_dir_operations;
@@ -1319,9 +1339,9 @@ static void udf_fill_inode(struct inode 
 			inc_nlink(inode);
 			break;
 		}
-		case ICBTAG_FILE_TYPE_REALTIME:
-		case ICBTAG_FILE_TYPE_REGULAR:
-		case ICBTAG_FILE_TYPE_UNDEF:
+	case ICBTAG_FILE_TYPE_REALTIME:
+	case ICBTAG_FILE_TYPE_REGULAR:
+	case ICBTAG_FILE_TYPE_UNDEF:
 		{
 			if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB)
 				inode->i_data.a_ops = &udf_adinicb_aops;
@@ -1332,56 +1352,54 @@ static void udf_fill_inode(struct inode 
 			inode->i_mode |= S_IFREG;
 			break;
 		}
-		case ICBTAG_FILE_TYPE_BLOCK:
+	case ICBTAG_FILE_TYPE_BLOCK:
 		{
 			inode->i_mode |= S_IFBLK;
 			break;
 		}
-		case ICBTAG_FILE_TYPE_CHAR:
+	case ICBTAG_FILE_TYPE_CHAR:
 		{
 			inode->i_mode |= S_IFCHR;
 			break;
 		}
-		case ICBTAG_FILE_TYPE_FIFO:
+	case ICBTAG_FILE_TYPE_FIFO:
 		{
 			init_special_inode(inode, inode->i_mode | S_IFIFO, 0);
 			break;
 		}
-		case ICBTAG_FILE_TYPE_SOCKET:
+	case ICBTAG_FILE_TYPE_SOCKET:
 		{
 			init_special_inode(inode, inode->i_mode | S_IFSOCK, 0);
 			break;
 		}
-		case ICBTAG_FILE_TYPE_SYMLINK:
+	case ICBTAG_FILE_TYPE_SYMLINK:
 		{
 			inode->i_data.a_ops = &udf_symlink_aops;
 			inode->i_op = &page_symlink_inode_operations;
-			inode->i_mode = S_IFLNK|S_IRWXUGO;
+			inode->i_mode = S_IFLNK | S_IRWXUGO;
 			break;
 		}
-		default:
+	default:
 		{
-			printk(KERN_ERR "udf: udf_fill_inode(ino %ld) failed unknown file type=%d\n",
-				inode->i_ino, fe->icbTag.fileType);
+			printk(KERN_ERR
+			       "udf: udf_fill_inode(ino %ld) failed unknown file type=%d\n",
+			       inode->i_ino, fe->icbTag.fileType);
 			make_bad_inode(inode);
 			return;
 		}
 	}
-	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode))
-	{
-		struct deviceSpec *dsea =
-			(struct deviceSpec *)
-				udf_get_extendedattr(inode, 12, 1);
-
-		if (dsea)
-		{
-			init_special_inode(inode, inode->i_mode, MKDEV(
-				le32_to_cpu(dsea->majorDeviceIdent),
-				le32_to_cpu(dsea->minorDeviceIdent)));
+	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
+		struct deviceSpec *dsea = (struct deviceSpec *)
+		    udf_get_extendedattr(inode, 12, 1);
+
+		if (dsea) {
+			init_special_inode(inode, inode->i_mode,
+					   MKDEV(le32_to_cpu
+						 (dsea->majorDeviceIdent),
+						 le32_to_cpu(dsea->
+							     minorDeviceIdent)));
 			/* Developer ID ??? */
-		}
-		else
-		{
+		} else {
 			make_bad_inode(inode);
 		}
 	}
@@ -1391,9 +1409,9 @@ static int udf_alloc_i_data(struct inode
 {
 	UDF_I_DATA(inode) = kmalloc(size, GFP_KERNEL);
 
-	if (!UDF_I_DATA(inode))
-	{
-		printk(KERN_ERR "udf:udf_alloc_i_data (ino %ld) no free memory\n",
+	if (!UDF_I_DATA(inode)) {
+		printk(KERN_ERR
+		       "udf:udf_alloc_i_data (ino %ld) no free memory\n",
 		       inode->i_ino);
 		return -ENOMEM;
 	}
@@ -1401,8 +1419,7 @@ static int udf_alloc_i_data(struct inode
 	return 0;
 }
 
-static mode_t
-udf_convert_permissions(struct fileEntry *fe)
+static mode_t udf_convert_permissions(struct fileEntry *fe)
 {
 	mode_t mode;
 	uint32_t permissions;
@@ -1411,12 +1428,12 @@ udf_convert_permissions(struct fileEntry
 	permissions = le32_to_cpu(fe->permissions);
 	flags = le16_to_cpu(fe->icbTag.flags);
 
-	mode =	(( permissions      ) & S_IRWXO) |
-		(( permissions >> 2 ) & S_IRWXG) |
-		(( permissions >> 4 ) & S_IRWXU) |
-		(( flags & ICBTAG_FLAG_SETUID) ? S_ISUID : 0) |
-		(( flags & ICBTAG_FLAG_SETGID) ? S_ISGID : 0) |
-		(( flags & ICBTAG_FLAG_STICKY) ? S_ISVTX : 0);
+	mode = ((permissions) & S_IRWXO) |
+	    ((permissions >> 2) & S_IRWXG) |
+	    ((permissions >> 4) & S_IRWXU) |
+	    ((flags & ICBTAG_FLAG_SETUID) ? S_ISUID : 0) |
+	    ((flags & ICBTAG_FLAG_SETGID) ? S_ISGID : 0) |
+	    ((flags & ICBTAG_FLAG_STICKY) ? S_ISVTX : 0);
 
 	return mode;
 }
@@ -1436,7 +1453,7 @@ udf_convert_permissions(struct fileEntry
  *	Written, tested, and released.
  */
 
-int udf_write_inode(struct inode * inode, int sync)
+int udf_write_inode(struct inode *inode, int sync)
 {
 	int ret;
 	lock_kernel();
@@ -1445,13 +1462,12 @@ int udf_write_inode(struct inode * inode
 	return ret;
 }
 
-int udf_sync_inode(struct inode * inode)
+int udf_sync_inode(struct inode *inode)
 {
 	return udf_update_inode(inode, 1);
 }
 
-static int
-udf_update_inode(struct inode *inode, int do_sync)
+static int udf_update_inode(struct inode *inode, int do_sync)
 {
 	struct buffer_head *bh = NULL;
 	struct fileEntry *fe;
@@ -1464,10 +1480,10 @@ udf_update_inode(struct inode *inode, in
 	int err = 0;
 
 	bh = udf_tread(inode->i_sb,
-		udf_get_lb_pblock(inode->i_sb, UDF_I_LOCATION(inode), 0));
+		       udf_get_lb_pblock(inode->i_sb, UDF_I_LOCATION(inode),
+					 0));
 
-	if (!bh)
-	{
+	if (!bh) {
 		udf_debug("bread failure\n");
 		return -EIO;
 	}
@@ -1477,23 +1493,29 @@ udf_update_inode(struct inode *inode, in
 	fe = (struct fileEntry *)bh->b_data;
 	efe = (struct extendedFileEntry *)bh->b_data;
 
-	if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_USE)
-	{
+	if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_USE) {
 		struct unallocSpaceEntry *use =
-			(struct unallocSpaceEntry *)bh->b_data;
+		    (struct unallocSpaceEntry *)bh->b_data;
 
 		use->lengthAllocDescs = cpu_to_le32(UDF_I_LENALLOC(inode));
-		memcpy(bh->b_data + sizeof(struct unallocSpaceEntry), UDF_I_DATA(inode), inode->i_sb->s_blocksize - sizeof(struct unallocSpaceEntry));
-		crclen = sizeof(struct unallocSpaceEntry) + UDF_I_LENALLOC(inode) -
-			sizeof(tag);
-		use->descTag.tagLocation = cpu_to_le32(UDF_I_LOCATION(inode).logicalBlockNum);
+		memcpy(bh->b_data + sizeof(struct unallocSpaceEntry),
+		       UDF_I_DATA(inode),
+		       inode->i_sb->s_blocksize -
+		       sizeof(struct unallocSpaceEntry));
+		crclen =
+		    sizeof(struct unallocSpaceEntry) + UDF_I_LENALLOC(inode) -
+		    sizeof(tag);
+		use->descTag.tagLocation =
+		    cpu_to_le32(UDF_I_LOCATION(inode).logicalBlockNum);
 		use->descTag.descCRCLength = cpu_to_le16(crclen);
-		use->descTag.descCRC = cpu_to_le16(udf_crc((char *)use + sizeof(tag), crclen, 0));
+		use->descTag.descCRC =
+		    cpu_to_le16(udf_crc((char *)use + sizeof(tag), crclen, 0));
 
 		use->descTag.tagChecksum = 0;
-		for (i=0; i<16; i++)
+		for (i = 0; i < 16; i++)
 			if (i != 4)
-				use->descTag.tagChecksum += ((uint8_t *)&(use->descTag))[i];
+				use->descTag.tagChecksum +=
+				    ((uint8_t *) & (use->descTag))[i];
 
 		mark_buffer_dirty(bh);
 		brelse(bh);
@@ -1502,20 +1524,21 @@ udf_update_inode(struct inode *inode, in
 
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_UID_FORGET))
 		fe->uid = cpu_to_le32(-1);
-	else fe->uid = cpu_to_le32(inode->i_uid);
+	else
+		fe->uid = cpu_to_le32(inode->i_uid);
 
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_GID_FORGET))
 		fe->gid = cpu_to_le32(-1);
-	else fe->gid = cpu_to_le32(inode->i_gid);
+	else
+		fe->gid = cpu_to_le32(inode->i_gid);
+
+	udfperms = ((inode->i_mode & S_IRWXO)) |
+	    ((inode->i_mode & S_IRWXG) << 2) | ((inode->i_mode & S_IRWXU) << 4);
 
-	udfperms =	((inode->i_mode & S_IRWXO)     ) |
-			((inode->i_mode & S_IRWXG) << 2) |
-			((inode->i_mode & S_IRWXU) << 4);
-
-	udfperms |=	(le32_to_cpu(fe->permissions) &
-			(FE_PERM_O_DELETE | FE_PERM_O_CHATTR |
-			 FE_PERM_G_DELETE | FE_PERM_G_CHATTR |
-			 FE_PERM_U_DELETE | FE_PERM_U_CHATTR));
+	udfperms |= (le32_to_cpu(fe->permissions) &
+		     (FE_PERM_O_DELETE | FE_PERM_O_CHATTR |
+		      FE_PERM_G_DELETE | FE_PERM_G_CHATTR |
+		      FE_PERM_U_DELETE | FE_PERM_U_CHATTR));
 	fe->permissions = cpu_to_le32(udfperms);
 
 	if (S_ISDIR(inode->i_mode))
@@ -1525,26 +1548,24 @@ udf_update_inode(struct inode *inode, in
 
 	fe->informationLength = cpu_to_le64(inode->i_size);
 
-	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode))
-	{
+	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
 		regid *eid;
-		struct deviceSpec *dsea =
-			(struct deviceSpec *)
-				udf_get_extendedattr(inode, 12, 1);
+		struct deviceSpec *dsea = (struct deviceSpec *)
+		    udf_get_extendedattr(inode, 12, 1);
 
-		if (!dsea)
-		{
+		if (!dsea) {
 			dsea = (struct deviceSpec *)
-				udf_add_extendedattr(inode,
-					sizeof(struct deviceSpec) +
-					sizeof(regid), 12, 0x3);
+			    udf_add_extendedattr(inode,
+						 sizeof(struct deviceSpec) +
+						 sizeof(regid), 12, 0x3);
 			dsea->attrType = cpu_to_le32(12);
 			dsea->attrSubtype = 1;
-			dsea->attrLength = cpu_to_le32(sizeof(struct deviceSpec) +
-				sizeof(regid));
+			dsea->attrLength =
+			    cpu_to_le32(sizeof(struct deviceSpec) +
+					sizeof(regid));
 			dsea->impUseLength = cpu_to_le32(sizeof(regid));
 		}
-		eid = (regid *)dsea->impUse;
+		eid = (regid *) dsea->impUse;
 		memset(eid, 0, sizeof(regid));
 		strcpy(eid->ident, UDF_ID_DEVELOPER);
 		eid->identSuffix[0] = UDF_OS_CLASS_UNIX;
@@ -1553,12 +1574,13 @@ udf_update_inode(struct inode *inode, in
 		dsea->minorDeviceIdent = cpu_to_le32(iminor(inode));
 	}
 
-	if (UDF_I_EFE(inode) == 0)
-	{
-		memcpy(bh->b_data + sizeof(struct fileEntry), UDF_I_DATA(inode), inode->i_sb->s_blocksize - sizeof(struct fileEntry));
-		fe->logicalBlocksRecorded = cpu_to_le64(
-			(inode->i_blocks + (1 << (inode->i_sb->s_blocksize_bits - 9)) - 1) >>
-			(inode->i_sb->s_blocksize_bits - 9));
+	if (UDF_I_EFE(inode) == 0) {
+		memcpy(bh->b_data + sizeof(struct fileEntry), UDF_I_DATA(inode),
+		       inode->i_sb->s_blocksize - sizeof(struct fileEntry));
+		fe->logicalBlocksRecorded =
+		    cpu_to_le64((inode->i_blocks +
+				 (1 << (inode->i_sb->s_blocksize_bits - 9)) -
+				 1) >> (inode->i_sb->s_blocksize_bits - 9));
 
 		if (udf_time_to_stamp(&cpu_time, inode->i_atime))
 			fe->accessTime = cpu_to_lets(cpu_time);
@@ -1575,31 +1597,34 @@ udf_update_inode(struct inode *inode, in
 		fe->lengthAllocDescs = cpu_to_le32(UDF_I_LENALLOC(inode));
 		fe->descTag.tagIdent = cpu_to_le16(TAG_IDENT_FE);
 		crclen = sizeof(struct fileEntry);
-	}
-	else
-	{
-		memcpy(bh->b_data + sizeof(struct extendedFileEntry), UDF_I_DATA(inode), inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry));
+	} else {
+		memcpy(bh->b_data + sizeof(struct extendedFileEntry),
+		       UDF_I_DATA(inode),
+		       inode->i_sb->s_blocksize -
+		       sizeof(struct extendedFileEntry));
 		efe->objectSize = cpu_to_le64(inode->i_size);
-		efe->logicalBlocksRecorded = cpu_to_le64(
-			(inode->i_blocks + (1 << (inode->i_sb->s_blocksize_bits - 9)) - 1) >>
-			(inode->i_sb->s_blocksize_bits - 9));
+		efe->logicalBlocksRecorded = cpu_to_le64((inode->i_blocks +
+							  (1 <<
+							   (inode->i_sb->
+							    s_blocksize_bits -
+							    9)) -
+							  1) >> (inode->i_sb->
+								 s_blocksize_bits
+								 - 9));
 
 		if (UDF_I_CRTIME(inode).tv_sec > inode->i_atime.tv_sec ||
-			(UDF_I_CRTIME(inode).tv_sec == inode->i_atime.tv_sec &&
-			 UDF_I_CRTIME(inode).tv_nsec > inode->i_atime.tv_nsec))
-		{
+		    (UDF_I_CRTIME(inode).tv_sec == inode->i_atime.tv_sec &&
+		     UDF_I_CRTIME(inode).tv_nsec > inode->i_atime.tv_nsec)) {
 			UDF_I_CRTIME(inode) = inode->i_atime;
 		}
 		if (UDF_I_CRTIME(inode).tv_sec > inode->i_mtime.tv_sec ||
-			(UDF_I_CRTIME(inode).tv_sec == inode->i_mtime.tv_sec &&
-			 UDF_I_CRTIME(inode).tv_nsec > inode->i_mtime.tv_nsec))
-		{
+		    (UDF_I_CRTIME(inode).tv_sec == inode->i_mtime.tv_sec &&
+		     UDF_I_CRTIME(inode).tv_nsec > inode->i_mtime.tv_nsec)) {
 			UDF_I_CRTIME(inode) = inode->i_mtime;
 		}
 		if (UDF_I_CRTIME(inode).tv_sec > inode->i_ctime.tv_sec ||
-			(UDF_I_CRTIME(inode).tv_sec == inode->i_ctime.tv_sec &&
-			 UDF_I_CRTIME(inode).tv_nsec > inode->i_ctime.tv_nsec))
-		{
+		    (UDF_I_CRTIME(inode).tv_sec == inode->i_ctime.tv_sec &&
+		     UDF_I_CRTIME(inode).tv_nsec > inode->i_ctime.tv_nsec)) {
 			UDF_I_CRTIME(inode) = inode->i_ctime;
 		}
 
@@ -1622,14 +1647,11 @@ udf_update_inode(struct inode *inode, in
 		efe->descTag.tagIdent = cpu_to_le16(TAG_IDENT_EFE);
 		crclen = sizeof(struct extendedFileEntry);
 	}
-	if (UDF_I_STRAT4096(inode))
-	{
+	if (UDF_I_STRAT4096(inode)) {
 		fe->icbTag.strategyType = cpu_to_le16(4096);
 		fe->icbTag.strategyParameter = cpu_to_le16(1);
 		fe->icbTag.numEntries = cpu_to_le16(2);
-	}
-	else
-	{
+	} else {
 		fe->icbTag.strategyType = cpu_to_le16(4);
 		fe->icbTag.numEntries = cpu_to_le16(1);
 	}
@@ -1649,13 +1671,13 @@ udf_update_inode(struct inode *inode, in
 	else if (S_ISSOCK(inode->i_mode))
 		fe->icbTag.fileType = ICBTAG_FILE_TYPE_SOCKET;
 
-	icbflags =	UDF_I_ALLOCTYPE(inode) |
-			((inode->i_mode & S_ISUID) ? ICBTAG_FLAG_SETUID : 0) |
-			((inode->i_mode & S_ISGID) ? ICBTAG_FLAG_SETGID : 0) |
-			((inode->i_mode & S_ISVTX) ? ICBTAG_FLAG_STICKY : 0) |
-			(le16_to_cpu(fe->icbTag.flags) &
-				~(ICBTAG_FLAG_AD_MASK | ICBTAG_FLAG_SETUID |
-				ICBTAG_FLAG_SETGID | ICBTAG_FLAG_STICKY));
+	icbflags = UDF_I_ALLOCTYPE(inode) |
+	    ((inode->i_mode & S_ISUID) ? ICBTAG_FLAG_SETUID : 0) |
+	    ((inode->i_mode & S_ISGID) ? ICBTAG_FLAG_SETGID : 0) |
+	    ((inode->i_mode & S_ISVTX) ? ICBTAG_FLAG_STICKY : 0) |
+	    (le16_to_cpu(fe->icbTag.flags) &
+	     ~(ICBTAG_FLAG_AD_MASK | ICBTAG_FLAG_SETUID |
+	       ICBTAG_FLAG_SETGID | ICBTAG_FLAG_STICKY));
 
 	fe->icbTag.flags = cpu_to_le16(icbflags);
 	if (UDF_SB_UDFREV(inode->i_sb) >= 0x0200)
@@ -1663,25 +1685,26 @@ udf_update_inode(struct inode *inode, in
 	else
 		fe->descTag.descVersion = cpu_to_le16(2);
 	fe->descTag.tagSerialNum = cpu_to_le16(UDF_SB_SERIALNUM(inode->i_sb));
-	fe->descTag.tagLocation = cpu_to_le32(UDF_I_LOCATION(inode).logicalBlockNum);
+	fe->descTag.tagLocation =
+	    cpu_to_le32(UDF_I_LOCATION(inode).logicalBlockNum);
 	crclen += UDF_I_LENEATTR(inode) + UDF_I_LENALLOC(inode) - sizeof(tag);
 	fe->descTag.descCRCLength = cpu_to_le16(crclen);
-	fe->descTag.descCRC = cpu_to_le16(udf_crc((char *)fe + sizeof(tag), crclen, 0));
+	fe->descTag.descCRC =
+	    cpu_to_le16(udf_crc((char *)fe + sizeof(tag), crclen, 0));
 
 	fe->descTag.tagChecksum = 0;
-	for (i=0; i<16; i++)
+	for (i = 0; i < 16; i++)
 		if (i != 4)
-			fe->descTag.tagChecksum += ((uint8_t *)&(fe->descTag))[i];
+			fe->descTag.tagChecksum +=
+			    ((uint8_t *) & (fe->descTag))[i];
 
 	/* write the data blocks */
 	mark_buffer_dirty(bh);
-	if (do_sync)
-	{
+	if (do_sync) {
 		sync_dirty_buffer(bh);
-		if (buffer_req(bh) && !buffer_uptodate(bh))
-		{
+		if (buffer_req(bh) && !buffer_uptodate(bh)) {
 			printk("IO error syncing udf inode [%s:%08lx]\n",
-				inode->i_sb->s_id, inode->i_ino);
+			       inode->i_sb->s_id, inode->i_ino);
 			err = -EIO;
 		}
 	}
@@ -1689,8 +1712,7 @@ udf_update_inode(struct inode *inode, in
 	return err;
 }
 
-struct inode *
-udf_iget(struct super_block *sb, kernel_lb_addr ino)
+struct inode *udf_iget(struct super_block *sb, kernel_lb_addr ino)
 {
 	unsigned long block = udf_get_lb_pblock(sb, ino, 0);
 	struct inode *inode = iget_locked(sb, block);
@@ -1707,22 +1729,23 @@ udf_iget(struct super_block *sb, kernel_
 	if (is_bad_inode(inode))
 		goto out_iput;
 
-	if (ino.logicalBlockNum >= UDF_SB_PARTLEN(sb, ino.partitionReferenceNum)) {
+	if (ino.logicalBlockNum >=
+	    UDF_SB_PARTLEN(sb, ino.partitionReferenceNum)) {
 		udf_debug("block=%d, partition=%d out of range\n",
-			ino.logicalBlockNum, ino.partitionReferenceNum);
+			  ino.logicalBlockNum, ino.partitionReferenceNum);
 		make_bad_inode(inode);
 		goto out_iput;
 	}
 
 	return inode;
 
- out_iput:
+      out_iput:
 	iput(inode);
 	return NULL;
 }
 
-int8_t udf_add_aext(struct inode *inode, struct extent_position *epos,
-	kernel_lb_addr eloc, uint32_t elen, int inc)
+int8_t udf_add_aext(struct inode * inode, struct extent_position * epos,
+		    kernel_lb_addr eloc, uint32_t elen, int inc)
 {
 	int adsize;
 	short_ad *sad = NULL;
@@ -1732,7 +1755,9 @@ int8_t udf_add_aext(struct inode *inode,
 	uint8_t *ptr;
 
 	if (!epos->bh)
-		ptr = UDF_I_DATA(inode) + epos->offset - udf_file_entry_alloc_offset(inode) + UDF_I_LENEATTR(inode);
+		ptr =
+		    UDF_I_DATA(inode) + epos->offset -
+		    udf_file_entry_alloc_offset(inode) + UDF_I_LENEATTR(inode);
 	else
 		ptr = epos->bh->b_data + epos->offset;
 
@@ -1743,21 +1768,24 @@ int8_t udf_add_aext(struct inode *inode,
 	else
 		return -1;
 
-	if (epos->offset + (2 * adsize) > inode->i_sb->s_blocksize)
-	{
+	if (epos->offset + (2 * adsize) > inode->i_sb->s_blocksize) {
 		char *sptr, *dptr;
 		struct buffer_head *nbh;
 		int err, loffset;
 		kernel_lb_addr obloc = epos->block;
 
-		if (!(epos->block.logicalBlockNum = udf_new_block(inode->i_sb, NULL,
-			obloc.partitionReferenceNum, obloc.logicalBlockNum, &err)))
-		{
+		if (!
+		    (epos->block.logicalBlockNum =
+		     udf_new_block(inode->i_sb, NULL,
+				   obloc.partitionReferenceNum,
+				   obloc.logicalBlockNum, &err))) {
 			return -1;
 		}
-		if (!(nbh = udf_tgetblk(inode->i_sb, udf_get_lb_pblock(inode->i_sb,
-			epos->block, 0))))
-		{
+		if (!
+		    (nbh =
+		     udf_tgetblk(inode->i_sb,
+				 udf_get_lb_pblock(inode->i_sb, epos->block,
+						   0)))) {
 			return -1;
 		}
 		lock_buffer(nbh);
@@ -1768,144 +1796,142 @@ int8_t udf_add_aext(struct inode *inode,
 
 		aed = (struct allocExtDesc *)(nbh->b_data);
 		if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT))
-			aed->previousAllocExtLocation = cpu_to_le32(obloc.logicalBlockNum);
-		if (epos->offset + adsize > inode->i_sb->s_blocksize)
-		{
+			aed->previousAllocExtLocation =
+			    cpu_to_le32(obloc.logicalBlockNum);
+		if (epos->offset + adsize > inode->i_sb->s_blocksize) {
 			loffset = epos->offset;
 			aed->lengthAllocDescs = cpu_to_le32(adsize);
 			sptr = ptr - adsize;
 			dptr = nbh->b_data + sizeof(struct allocExtDesc);
 			memcpy(dptr, sptr, adsize);
 			epos->offset = sizeof(struct allocExtDesc) + adsize;
-		}
-		else
-		{
+		} else {
 			loffset = epos->offset + adsize;
 			aed->lengthAllocDescs = cpu_to_le32(0);
 			sptr = ptr;
 			epos->offset = sizeof(struct allocExtDesc);
 
-			if (epos->bh)
-			{
+			if (epos->bh) {
 				aed = (struct allocExtDesc *)epos->bh->b_data;
 				aed->lengthAllocDescs =
-					cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) + adsize);
-			}
-			else
-			{
+				    cpu_to_le32(le32_to_cpu
+						(aed->lengthAllocDescs) +
+						adsize);
+			} else {
 				UDF_I_LENALLOC(inode) += adsize;
 				mark_inode_dirty(inode);
 			}
 		}
 		if (UDF_SB_UDFREV(inode->i_sb) >= 0x0200)
 			udf_new_tag(nbh->b_data, TAG_IDENT_AED, 3, 1,
-				epos->block.logicalBlockNum, sizeof(tag));
+				    epos->block.logicalBlockNum, sizeof(tag));
 		else
 			udf_new_tag(nbh->b_data, TAG_IDENT_AED, 2, 1,
-				epos->block.logicalBlockNum, sizeof(tag));
-		switch (UDF_I_ALLOCTYPE(inode))
-		{
-			case ICBTAG_FLAG_AD_SHORT:
+				    epos->block.logicalBlockNum, sizeof(tag));
+		switch (UDF_I_ALLOCTYPE(inode)) {
+		case ICBTAG_FLAG_AD_SHORT:
 			{
-				sad = (short_ad *)sptr;
-				sad->extLength = cpu_to_le32(
-					EXT_NEXT_EXTENT_ALLOCDECS |
-					inode->i_sb->s_blocksize);
-				sad->extPosition = cpu_to_le32(epos->block.logicalBlockNum);
+				sad = (short_ad *) sptr;
+				sad->extLength =
+				    cpu_to_le32(EXT_NEXT_EXTENT_ALLOCDECS |
+						inode->i_sb->s_blocksize);
+				sad->extPosition =
+				    cpu_to_le32(epos->block.logicalBlockNum);
 				break;
 			}
-			case ICBTAG_FLAG_AD_LONG:
+		case ICBTAG_FLAG_AD_LONG:
 			{
-				lad = (long_ad *)sptr;
-				lad->extLength = cpu_to_le32(
-					EXT_NEXT_EXTENT_ALLOCDECS |
-					inode->i_sb->s_blocksize);
+				lad = (long_ad *) sptr;
+				lad->extLength =
+				    cpu_to_le32(EXT_NEXT_EXTENT_ALLOCDECS |
+						inode->i_sb->s_blocksize);
 				lad->extLocation = cpu_to_lelb(epos->block);
 				memset(lad->impUse, 0x00, sizeof(lad->impUse));
 				break;
 			}
 		}
-		if (epos->bh)
-		{
-			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) || UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
+		if (epos->bh) {
+			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT)
+			    || UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
 				udf_update_tag(epos->bh->b_data, loffset);
 			else
-				udf_update_tag(epos->bh->b_data, sizeof(struct allocExtDesc));
+				udf_update_tag(epos->bh->b_data,
+					       sizeof(struct allocExtDesc));
 			mark_buffer_dirty_inode(epos->bh, inode);
 			brelse(epos->bh);
-		}
-		else
+		} else
 			mark_inode_dirty(inode);
 		epos->bh = nbh;
 	}
 
 	etype = udf_write_aext(inode, epos, eloc, elen, inc);
 
-	if (!epos->bh)
-	{
+	if (!epos->bh) {
 		UDF_I_LENALLOC(inode) += adsize;
 		mark_inode_dirty(inode);
-	}
-	else
-	{
+	} else {
 		aed = (struct allocExtDesc *)epos->bh->b_data;
 		aed->lengthAllocDescs =
-			cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) + adsize);
-		if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) || UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
-			udf_update_tag(epos->bh->b_data, epos->offset + (inc ? 0 : adsize));
+		    cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) + adsize);
+		if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT)
+		    || UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
+			udf_update_tag(epos->bh->b_data,
+				       epos->offset + (inc ? 0 : adsize));
 		else
-			udf_update_tag(epos->bh->b_data, sizeof(struct allocExtDesc));
+			udf_update_tag(epos->bh->b_data,
+				       sizeof(struct allocExtDesc));
 		mark_buffer_dirty_inode(epos->bh, inode);
 	}
 
 	return etype;
 }
 
-int8_t udf_write_aext(struct inode *inode, struct extent_position *epos,
-    kernel_lb_addr eloc, uint32_t elen, int inc)
+int8_t udf_write_aext(struct inode * inode, struct extent_position * epos,
+		      kernel_lb_addr eloc, uint32_t elen, int inc)
 {
 	int adsize;
 	uint8_t *ptr;
 
 	if (!epos->bh)
-		ptr = UDF_I_DATA(inode) + epos->offset - udf_file_entry_alloc_offset(inode) + UDF_I_LENEATTR(inode);
+		ptr =
+		    UDF_I_DATA(inode) + epos->offset -
+		    udf_file_entry_alloc_offset(inode) + UDF_I_LENEATTR(inode);
 	else
 		ptr = epos->bh->b_data + epos->offset;
 
-	switch (UDF_I_ALLOCTYPE(inode))
-	{
-		case ICBTAG_FLAG_AD_SHORT:
+	switch (UDF_I_ALLOCTYPE(inode)) {
+	case ICBTAG_FLAG_AD_SHORT:
 		{
-			short_ad *sad = (short_ad *)ptr;
+			short_ad *sad = (short_ad *) ptr;
 			sad->extLength = cpu_to_le32(elen);
 			sad->extPosition = cpu_to_le32(eloc.logicalBlockNum);
 			adsize = sizeof(short_ad);
 			break;
 		}
-		case ICBTAG_FLAG_AD_LONG:
+	case ICBTAG_FLAG_AD_LONG:
 		{
-			long_ad *lad = (long_ad *)ptr;
+			long_ad *lad = (long_ad *) ptr;
 			lad->extLength = cpu_to_le32(elen);
 			lad->extLocation = cpu_to_lelb(eloc);
 			memset(lad->impUse, 0x00, sizeof(lad->impUse));
 			adsize = sizeof(long_ad);
 			break;
 		}
-		default:
-			return -1;
+	default:
+		return -1;
 	}
 
-	if (epos->bh)
-	{
-		if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) || UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
-		{
-			struct allocExtDesc *aed = (struct allocExtDesc *)epos->bh->b_data;
+	if (epos->bh) {
+		if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT)
+		    || UDF_SB_UDFREV(inode->i_sb) >= 0x0201) {
+			struct allocExtDesc *aed =
+			    (struct allocExtDesc *)epos->bh->b_data;
 			udf_update_tag(epos->bh->b_data,
-				le32_to_cpu(aed->lengthAllocDescs) + sizeof(struct allocExtDesc));
+				       le32_to_cpu(aed->lengthAllocDescs) +
+				       sizeof(struct allocExtDesc));
 		}
 		mark_buffer_dirty_inode(epos->bh, inode);
-	}
-	else
+	} else
 		mark_inode_dirty(inode);
 
 	if (inc)
@@ -1913,21 +1939,24 @@ int8_t udf_write_aext(struct inode *inod
 	return (elen >> 30);
 }
 
-int8_t udf_next_aext(struct inode *inode, struct extent_position *epos,
-	kernel_lb_addr *eloc, uint32_t *elen, int inc)
+int8_t udf_next_aext(struct inode * inode, struct extent_position * epos,
+		     kernel_lb_addr * eloc, uint32_t * elen, int inc)
 {
 	int8_t etype;
 
 	while ((etype = udf_current_aext(inode, epos, eloc, elen, inc)) ==
-		(EXT_NEXT_EXTENT_ALLOCDECS >> 30))
-	{
+	       (EXT_NEXT_EXTENT_ALLOCDECS >> 30)) {
 		epos->block = *eloc;
 		epos->offset = sizeof(struct allocExtDesc);
 		brelse(epos->bh);
-		if (!(epos->bh = udf_tread(inode->i_sb, udf_get_lb_pblock(inode->i_sb, epos->block, 0))))
-		{
+		if (!
+		    (epos->bh =
+		     udf_tread(inode->i_sb,
+			       udf_get_lb_pblock(inode->i_sb, epos->block,
+						 0)))) {
 			udf_debug("reading block %d failed!\n",
-				udf_get_lb_pblock(inode->i_sb, epos->block, 0));
+				  udf_get_lb_pblock(inode->i_sb, epos->block,
+						    0));
 			return -1;
 		}
 	}
@@ -1935,58 +1964,71 @@ int8_t udf_next_aext(struct inode *inode
 	return etype;
 }
 
-int8_t udf_current_aext(struct inode *inode, struct extent_position *epos,
-	kernel_lb_addr *eloc, uint32_t *elen, int inc)
+int8_t udf_current_aext(struct inode * inode, struct extent_position * epos,
+			kernel_lb_addr * eloc, uint32_t * elen, int inc)
 {
 	int alen;
 	int8_t etype;
 	uint8_t *ptr;
 
-	if (!epos->bh)
-	{
+	if (!epos->bh) {
 		if (!epos->offset)
 			epos->offset = udf_file_entry_alloc_offset(inode);
-		ptr = UDF_I_DATA(inode) + epos->offset - udf_file_entry_alloc_offset(inode) + UDF_I_LENEATTR(inode);
-		alen = udf_file_entry_alloc_offset(inode) + UDF_I_LENALLOC(inode);
-	}
-	else
-	{
+		ptr =
+		    UDF_I_DATA(inode) + epos->offset -
+		    udf_file_entry_alloc_offset(inode) + UDF_I_LENEATTR(inode);
+		alen =
+		    udf_file_entry_alloc_offset(inode) + UDF_I_LENALLOC(inode);
+	} else {
 		if (!epos->offset)
 			epos->offset = sizeof(struct allocExtDesc);
 		ptr = epos->bh->b_data + epos->offset;
-		alen = sizeof(struct allocExtDesc) + le32_to_cpu(((struct allocExtDesc *)epos->bh->b_data)->lengthAllocDescs);
+		alen =
+		    sizeof(struct allocExtDesc) +
+		    le32_to_cpu(((struct allocExtDesc *)epos->bh->b_data)->
+				lengthAllocDescs);
 	}
 
-	switch (UDF_I_ALLOCTYPE(inode))
-	{
-		case ICBTAG_FLAG_AD_SHORT:
+	switch (UDF_I_ALLOCTYPE(inode)) {
+	case ICBTAG_FLAG_AD_SHORT:
 		{
 			short_ad *sad;
 
-			if (!(sad = udf_get_fileshortad(ptr, alen, &epos->offset, inc)))
+			if (!
+			    (sad =
+			     udf_get_fileshortad(ptr, alen, &epos->offset,
+						 inc)))
 				return -1;
 
 			etype = le32_to_cpu(sad->extLength) >> 30;
 			eloc->logicalBlockNum = le32_to_cpu(sad->extPosition);
-			eloc->partitionReferenceNum = UDF_I_LOCATION(inode).partitionReferenceNum;
-			*elen = le32_to_cpu(sad->extLength) & UDF_EXTENT_LENGTH_MASK;
+			eloc->partitionReferenceNum =
+			    UDF_I_LOCATION(inode).partitionReferenceNum;
+			*elen =
+			    le32_to_cpu(sad->
+					extLength) & UDF_EXTENT_LENGTH_MASK;
 			break;
 		}
-		case ICBTAG_FLAG_AD_LONG:
+	case ICBTAG_FLAG_AD_LONG:
 		{
 			long_ad *lad;
 
-			if (!(lad = udf_get_filelongad(ptr, alen, &epos->offset, inc)))
+			if (!
+			    (lad =
+			     udf_get_filelongad(ptr, alen, &epos->offset, inc)))
 				return -1;
 
 			etype = le32_to_cpu(lad->extLength) >> 30;
 			*eloc = lelb_to_cpu(lad->extLocation);
-			*elen = le32_to_cpu(lad->extLength) & UDF_EXTENT_LENGTH_MASK;
+			*elen =
+			    le32_to_cpu(lad->
+					extLength) & UDF_EXTENT_LENGTH_MASK;
 			break;
 		}
-		default:
+	default:
 		{
-			udf_debug("alloc_type = %d unsupported\n", UDF_I_ALLOCTYPE(inode));
+			udf_debug("alloc_type = %d unsupported\n",
+				  UDF_I_ALLOCTYPE(inode));
 			return -1;
 		}
 	}
@@ -2005,8 +2047,7 @@ udf_insert_aext(struct inode *inode, str
 	if (epos.bh)
 		get_bh(epos.bh);
 
-	while ((etype = udf_next_aext(inode, &epos, &oeloc, &oelen, 0)) != -1)
-	{
+	while ((etype = udf_next_aext(inode, &epos, &oeloc, &oelen, 0)) != -1) {
 		udf_write_aext(inode, &epos, neloc, nelen, 1);
 
 		neloc = oeloc;
@@ -2017,16 +2058,15 @@ udf_insert_aext(struct inode *inode, str
 	return (nelen >> 30);
 }
 
-int8_t udf_delete_aext(struct inode *inode, struct extent_position epos,
-	kernel_lb_addr eloc, uint32_t elen)
+int8_t udf_delete_aext(struct inode * inode, struct extent_position epos,
+		       kernel_lb_addr eloc, uint32_t elen)
 {
 	struct extent_position oepos;
 	int adsize;
 	int8_t etype;
 	struct allocExtDesc *aed;
 
-	if (epos.bh)
-	{
+	if (epos.bh) {
 		get_bh(epos.bh);
 		get_bh(epos.bh);
 	}
@@ -2042,11 +2082,9 @@ int8_t udf_delete_aext(struct inode *ino
 	if (udf_next_aext(inode, &epos, &eloc, &elen, 1) == -1)
 		return -1;
 
-	while ((etype = udf_next_aext(inode, &epos, &eloc, &elen, 1)) != -1)
-	{
+	while ((etype = udf_next_aext(inode, &epos, &eloc, &elen, 1)) != -1) {
 		udf_write_aext(inode, &oepos, eloc, (etype << 30) | elen, 1);
-		if (oepos.bh != epos.bh)
-		{
+		if (oepos.bh != epos.bh) {
 			oepos.block = epos.block;
 			brelse(oepos.bh);
 			get_bh(epos.bh);
@@ -2057,45 +2095,44 @@ int8_t udf_delete_aext(struct inode *ino
 	memset(&eloc, 0x00, sizeof(kernel_lb_addr));
 	elen = 0;
 
-	if (epos.bh != oepos.bh)
-	{
+	if (epos.bh != oepos.bh) {
 		udf_free_blocks(inode->i_sb, inode, epos.block, 0, 1);
 		udf_write_aext(inode, &oepos, eloc, elen, 1);
 		udf_write_aext(inode, &oepos, eloc, elen, 1);
-		if (!oepos.bh)
-		{
+		if (!oepos.bh) {
 			UDF_I_LENALLOC(inode) -= (adsize * 2);
 			mark_inode_dirty(inode);
-		}
-		else
-		{
+		} else {
 			aed = (struct allocExtDesc *)oepos.bh->b_data;
 			aed->lengthAllocDescs =
-				cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) - (2*adsize));
-			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) || UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
-				udf_update_tag(oepos.bh->b_data, oepos.offset - (2*adsize));
+			    cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) -
+					(2 * adsize));
+			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT)
+			    || UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
+				udf_update_tag(oepos.bh->b_data,
+					       oepos.offset - (2 * adsize));
 			else
-				udf_update_tag(oepos.bh->b_data, sizeof(struct allocExtDesc));
+				udf_update_tag(oepos.bh->b_data,
+					       sizeof(struct allocExtDesc));
 			mark_buffer_dirty_inode(oepos.bh, inode);
 		}
-	}
-	else
-	{
+	} else {
 		udf_write_aext(inode, &oepos, eloc, elen, 1);
-		if (!oepos.bh)
-		{
+		if (!oepos.bh) {
 			UDF_I_LENALLOC(inode) -= adsize;
 			mark_inode_dirty(inode);
-		}
-		else
-		{
+		} else {
 			aed = (struct allocExtDesc *)oepos.bh->b_data;
 			aed->lengthAllocDescs =
-				cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) - adsize);
-			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) || UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
-				udf_update_tag(oepos.bh->b_data, epos.offset - adsize);
+			    cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) -
+					adsize);
+			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT)
+			    || UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
+				udf_update_tag(oepos.bh->b_data,
+					       epos.offset - adsize);
 			else
-				udf_update_tag(oepos.bh->b_data, sizeof(struct allocExtDesc));
+				udf_update_tag(oepos.bh->b_data,
+					       sizeof(struct allocExtDesc));
 			mark_buffer_dirty_inode(oepos.bh, inode);
 		}
 	}
@@ -2105,14 +2142,15 @@ int8_t udf_delete_aext(struct inode *ino
 	return (elen >> 30);
 }
 
-int8_t inode_bmap(struct inode *inode, sector_t block, struct extent_position *pos,
-	kernel_lb_addr *eloc, uint32_t *elen, sector_t *offset)
+int8_t inode_bmap(struct inode * inode, sector_t block,
+		  struct extent_position * pos, kernel_lb_addr * eloc,
+		  uint32_t * elen, sector_t * offset)
 {
-	loff_t lbcount = 0, bcount = (loff_t)block << inode->i_sb->s_blocksize_bits;
+	loff_t lbcount = 0, bcount =
+	    (loff_t) block << inode->i_sb->s_blocksize_bits;
 	int8_t etype;
 
-	if (block < 0)
-	{
+	if (block < 0) {
 		printk(KERN_ERR "udf: inode_bmap: block < 0\n");
 		return -1;
 	}
@@ -2122,11 +2160,10 @@ int8_t inode_bmap(struct inode *inode, s
 	pos->bh = NULL;
 	*elen = 0;
 
-	do
-	{
-		if ((etype = udf_next_aext(inode, pos, eloc, elen, 1)) == -1)
-		{
-			*offset = (bcount - lbcount) >> inode->i_sb->s_blocksize_bits;
+	do {
+		if ((etype = udf_next_aext(inode, pos, eloc, elen, 1)) == -1) {
+			*offset =
+			    (bcount - lbcount) >> inode->i_sb->s_blocksize_bits;
 			UDF_I_LENEXTENTS(inode) = lbcount;
 			return -1;
 		}
@@ -2143,12 +2180,13 @@ long udf_block_map(struct inode *inode, 
 	kernel_lb_addr eloc;
 	uint32_t elen;
 	sector_t offset;
-	struct extent_position epos = { NULL, 0, { 0, 0}};
+	struct extent_position epos = { NULL, 0, {0, 0} };
 	int ret;
 
 	lock_kernel();
 
-	if (inode_bmap(inode, block, &epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30))
+	if (inode_bmap(inode, block, &epos, &eloc, &elen, &offset) ==
+	    (EXT_RECORDED_ALLOCATED >> 30))
 		ret = udf_get_lb_pblock(inode->i_sb, eloc, offset);
 	else
 		ret = 0;
diff -puN fs/udf/lowlevel.c~udf-coding-style-conversion-lindent fs/udf/lowlevel.c
--- a/fs/udf/lowlevel.c~udf-coding-style-conversion-lindent
+++ a/fs/udf/lowlevel.c
@@ -26,43 +26,38 @@
 #include <linux/udf_fs.h>
 #include "udf_sb.h"
 
-unsigned int 
-udf_get_last_session(struct super_block *sb)
+unsigned int udf_get_last_session(struct super_block *sb)
 {
 	struct cdrom_multisession ms_info;
 	unsigned int vol_desc_start;
 	struct block_device *bdev = sb->s_bdev;
 	int i;
 
-	vol_desc_start=0;
-	ms_info.addr_format=CDROM_LBA;
-	i = ioctl_by_bdev(bdev, CDROMMULTISESSION, (unsigned long) &ms_info);
+	vol_desc_start = 0;
+	ms_info.addr_format = CDROM_LBA;
+	i = ioctl_by_bdev(bdev, CDROMMULTISESSION, (unsigned long)&ms_info);
 
 #define WE_OBEY_THE_WRITTEN_STANDARDS 1
 
-	if (i == 0)
-	{
+	if (i == 0) {
 		udf_debug("XA disk: %s, vol_desc_start=%d\n",
-			(ms_info.xa_flag ? "yes" : "no"), ms_info.addr.lba);
+			  (ms_info.xa_flag ? "yes" : "no"), ms_info.addr.lba);
 #if WE_OBEY_THE_WRITTEN_STANDARDS
-		if (ms_info.xa_flag) /* necessary for a valid ms_info.addr */
+		if (ms_info.xa_flag)	/* necessary for a valid ms_info.addr */
 #endif
 			vol_desc_start = ms_info.addr.lba;
-	}
-	else
-	{
+	} else {
 		udf_debug("CDROMMULTISESSION not supported: rc=%d\n", i);
 	}
 	return vol_desc_start;
 }
 
-unsigned long
-udf_get_last_block(struct super_block *sb)
+unsigned long udf_get_last_block(struct super_block *sb)
 {
 	struct block_device *bdev = sb->s_bdev;
 	unsigned long lblock = 0;
 
-	if (ioctl_by_bdev(bdev, CDROM_LAST_WRITTEN, (unsigned long) &lblock))
+	if (ioctl_by_bdev(bdev, CDROM_LAST_WRITTEN, (unsigned long)&lblock))
 		lblock = bdev->bd_inode->i_size >> sb->s_blocksize_bits;
 
 	if (lblock)
diff -puN fs/udf/misc.c~udf-coding-style-conversion-lindent fs/udf/misc.c
--- a/fs/udf/misc.c~udf-coding-style-conversion-lindent
+++ a/fs/udf/misc.c
@@ -29,8 +29,7 @@
 #include "udf_i.h"
 #include "udf_sb.h"
 
-struct buffer_head *
-udf_tgetblk(struct super_block *sb, int block)
+struct buffer_head *udf_tgetblk(struct super_block *sb, int block)
 {
 	if (UDF_QUERY_FLAG(sb, UDF_FLAG_VARCONV))
 		return sb_getblk(sb, udf_fixed_to_variable(block));
@@ -38,8 +37,7 @@ udf_tgetblk(struct super_block *sb, int 
 		return sb_getblk(sb, block);
 }
 
-struct buffer_head *
-udf_tread(struct super_block *sb, int block)
+struct buffer_head *udf_tread(struct super_block *sb, int block)
 {
 	if (UDF_QUERY_FLAG(sb, UDF_FLAG_VARCONV))
 		return sb_bread(sb, udf_fixed_to_variable(block));
@@ -47,9 +45,8 @@ udf_tread(struct super_block *sb, int bl
 		return sb_bread(sb, block);
 }
 
-struct genericFormat *
-udf_add_extendedattr(struct inode * inode, uint32_t size, uint32_t type,
-	uint8_t loc)
+struct genericFormat *udf_add_extendedattr(struct inode *inode, uint32_t size,
+					   uint32_t type, uint8_t loc)
 {
 	uint8_t *ea = NULL, *ad = NULL;
 	int offset;
@@ -59,78 +56,76 @@ udf_add_extendedattr(struct inode * inod
 	ea = UDF_I_DATA(inode);
 	if (UDF_I_LENEATTR(inode))
 		ad = UDF_I_DATA(inode) + UDF_I_LENEATTR(inode);
-	else
-	{
+	else {
 		ad = ea;
 		size += sizeof(struct extendedAttrHeaderDesc);
 	}
 
 	offset = inode->i_sb->s_blocksize - udf_file_entry_alloc_offset(inode) -
-		UDF_I_LENALLOC(inode);
+	    UDF_I_LENALLOC(inode);
 
 	/* TODO - Check for FreeEASpace */
 
-	if (loc & 0x01 && offset >= size)
-	{
+	if (loc & 0x01 && offset >= size) {
 		struct extendedAttrHeaderDesc *eahd;
 		eahd = (struct extendedAttrHeaderDesc *)ea;
 
-		if (UDF_I_LENALLOC(inode))
-		{
+		if (UDF_I_LENALLOC(inode)) {
 			memmove(&ad[size], ad, UDF_I_LENALLOC(inode));
 		}
 
-		if (UDF_I_LENEATTR(inode))
-		{
+		if (UDF_I_LENEATTR(inode)) {
 			/* check checksum/crc */
-			if (le16_to_cpu(eahd->descTag.tagIdent) != TAG_IDENT_EAHD ||
-				le32_to_cpu(eahd->descTag.tagLocation) != UDF_I_LOCATION(inode).logicalBlockNum)
-			{
+			if (le16_to_cpu(eahd->descTag.tagIdent) !=
+			    TAG_IDENT_EAHD
+			    || le32_to_cpu(eahd->descTag.tagLocation) !=
+			    UDF_I_LOCATION(inode).logicalBlockNum) {
 				return NULL;
 			}
-		}
-		else
-		{
+		} else {
 			size -= sizeof(struct extendedAttrHeaderDesc);
-			UDF_I_LENEATTR(inode) += sizeof(struct extendedAttrHeaderDesc);
+			UDF_I_LENEATTR(inode) +=
+			    sizeof(struct extendedAttrHeaderDesc);
 			eahd->descTag.tagIdent = cpu_to_le16(TAG_IDENT_EAHD);
 			if (UDF_SB_UDFREV(inode->i_sb) >= 0x0200)
 				eahd->descTag.descVersion = cpu_to_le16(3);
 			else
 				eahd->descTag.descVersion = cpu_to_le16(2);
-			eahd->descTag.tagSerialNum = cpu_to_le16(UDF_SB_SERIALNUM(inode->i_sb));
-			eahd->descTag.tagLocation = cpu_to_le32(UDF_I_LOCATION(inode).logicalBlockNum);
+			eahd->descTag.tagSerialNum =
+			    cpu_to_le16(UDF_SB_SERIALNUM(inode->i_sb));
+			eahd->descTag.tagLocation =
+			    cpu_to_le32(UDF_I_LOCATION(inode).logicalBlockNum);
 			eahd->impAttrLocation = cpu_to_le32(0xFFFFFFFF);
 			eahd->appAttrLocation = cpu_to_le32(0xFFFFFFFF);
 		}
 
 		offset = UDF_I_LENEATTR(inode);
-		if (type < 2048)
-		{
-			if (le32_to_cpu(eahd->appAttrLocation) < UDF_I_LENEATTR(inode))
-			{
-				uint32_t aal = le32_to_cpu(eahd->appAttrLocation);
-				memmove(&ea[offset - aal + size],
-					&ea[aal], offset - aal);
+		if (type < 2048) {
+			if (le32_to_cpu(eahd->appAttrLocation) <
+			    UDF_I_LENEATTR(inode)) {
+				uint32_t aal =
+				    le32_to_cpu(eahd->appAttrLocation);
+				memmove(&ea[offset - aal + size], &ea[aal],
+					offset - aal);
 				offset -= aal;
 				eahd->appAttrLocation = cpu_to_le32(aal + size);
 			}
-			if (le32_to_cpu(eahd->impAttrLocation) < UDF_I_LENEATTR(inode))
-			{
-				uint32_t ial = le32_to_cpu(eahd->impAttrLocation);
-				memmove(&ea[offset - ial + size],
-					&ea[ial], offset - ial);
+			if (le32_to_cpu(eahd->impAttrLocation) <
+			    UDF_I_LENEATTR(inode)) {
+				uint32_t ial =
+				    le32_to_cpu(eahd->impAttrLocation);
+				memmove(&ea[offset - ial + size], &ea[ial],
+					offset - ial);
 				offset -= ial;
 				eahd->impAttrLocation = cpu_to_le32(ial + size);
 			}
-		}
-		else if (type < 65536)
-		{
-			if (le32_to_cpu(eahd->appAttrLocation) < UDF_I_LENEATTR(inode))
-			{
-				uint32_t aal = le32_to_cpu(eahd->appAttrLocation);
-				memmove(&ea[offset - aal + size],
-					&ea[aal], offset - aal);
+		} else if (type < 65536) {
+			if (le32_to_cpu(eahd->appAttrLocation) <
+			    UDF_I_LENEATTR(inode)) {
+				uint32_t aal =
+				    le32_to_cpu(eahd->appAttrLocation);
+				memmove(&ea[offset - aal + size], &ea[aal],
+					offset - aal);
 				offset -= aal;
 				eahd->appAttrLocation = cpu_to_le32(aal + size);
 			}
@@ -138,22 +133,23 @@ udf_add_extendedattr(struct inode * inod
 		/* rewrite CRC + checksum of eahd */
 		crclen = sizeof(struct extendedAttrHeaderDesc) - sizeof(tag);
 		eahd->descTag.descCRCLength = cpu_to_le16(crclen);
-		eahd->descTag.descCRC = cpu_to_le16(udf_crc((char *)eahd + sizeof(tag), crclen, 0));
+		eahd->descTag.descCRC =
+		    cpu_to_le16(udf_crc((char *)eahd + sizeof(tag), crclen, 0));
 		eahd->descTag.tagChecksum = 0;
-		for (i=0; i<16; i++)
+		for (i = 0; i < 16; i++)
 			if (i != 4)
-				eahd->descTag.tagChecksum += ((uint8_t *)&(eahd->descTag))[i];
+				eahd->descTag.tagChecksum +=
+				    ((uint8_t *) & (eahd->descTag))[i];
 		UDF_I_LENEATTR(inode) += size;
 		return (struct genericFormat *)&ea[offset];
 	}
-	if (loc & 0x02)
-	{
+	if (loc & 0x02) {
 	}
 	return NULL;
 }
 
-struct genericFormat *
-udf_get_extendedattr(struct inode *inode, uint32_t type, uint8_t subtype)
+struct genericFormat *udf_get_extendedattr(struct inode *inode, uint32_t type,
+					   uint8_t subtype)
 {
 	struct genericFormat *gaf;
 	uint8_t *ea = NULL;
@@ -161,18 +157,17 @@ udf_get_extendedattr(struct inode *inode
 
 	ea = UDF_I_DATA(inode);
 
-	if (UDF_I_LENEATTR(inode))
-	{
+	if (UDF_I_LENEATTR(inode)) {
 		struct extendedAttrHeaderDesc *eahd;
 		eahd = (struct extendedAttrHeaderDesc *)ea;
 
 		/* check checksum/crc */
 		if (le16_to_cpu(eahd->descTag.tagIdent) != TAG_IDENT_EAHD ||
-			le32_to_cpu(eahd->descTag.tagLocation) != UDF_I_LOCATION(inode).logicalBlockNum)
-		{
+		    le32_to_cpu(eahd->descTag.tagLocation) !=
+		    UDF_I_LOCATION(inode).logicalBlockNum) {
 			return NULL;
 		}
-	
+
 		if (type < 2048)
 			offset = sizeof(struct extendedAttrHeaderDesc);
 		else if (type < 65536)
@@ -180,10 +175,10 @@ udf_get_extendedattr(struct inode *inode
 		else
 			offset = le32_to_cpu(eahd->appAttrLocation);
 
-		while (offset < UDF_I_LENEATTR(inode))
-		{
+		while (offset < UDF_I_LENEATTR(inode)) {
 			gaf = (struct genericFormat *)&ea[offset];
-			if (le32_to_cpu(gaf->attrType) == type && gaf->attrSubtype == subtype)
+			if (le32_to_cpu(gaf->attrType) == type
+			    && gaf->attrSubtype == subtype)
 				return gaf;
 			else
 				offset += le32_to_cpu(gaf->attrLength);
@@ -202,8 +197,8 @@ udf_get_extendedattr(struct inode *inode
  *	July 1, 1997 - Andrew E. Mileski
  *	Written, tested, and released.
  */
-struct buffer_head *
-udf_read_tagged(struct super_block *sb, uint32_t block, uint32_t location, uint16_t *ident)
+struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
+				    uint32_t location, uint16_t * ident)
 {
 	tag *tag_p;
 	struct buffer_head *bh = NULL;
@@ -215,29 +210,29 @@ udf_read_tagged(struct super_block *sb, 
 		return NULL;
 
 	bh = udf_tread(sb, block + UDF_SB_SESSION(sb));
-	if (!bh)
-	{
-		udf_debug("block=%d, location=%d: read failed\n", block + UDF_SB_SESSION(sb), location);
+	if (!bh) {
+		udf_debug("block=%d, location=%d: read failed\n",
+			  block + UDF_SB_SESSION(sb), location);
 		return NULL;
 	}
 
-	tag_p = (tag *)(bh->b_data);
+	tag_p = (tag *) (bh->b_data);
 
 	*ident = le16_to_cpu(tag_p->tagIdent);
 
-	if ( location != le32_to_cpu(tag_p->tagLocation) )
-	{
+	if (location != le32_to_cpu(tag_p->tagLocation)) {
 		udf_debug("location mismatch block %u, tag %u != %u\n",
-			block + UDF_SB_SESSION(sb), le32_to_cpu(tag_p->tagLocation), location);
+			  block + UDF_SB_SESSION(sb),
+			  le32_to_cpu(tag_p->tagLocation), location);
 		goto error_out;
 	}
-	
+
 	/* Verify the tag checksum */
 	checksum = 0U;
 	for (i = 0; i < 4; i++)
-		checksum += (uint8_t)(bh->b_data[i]);
+		checksum += (uint8_t) (bh->b_data[i]);
 	for (i = 5; i < 16; i++)
-		checksum += (uint8_t)(bh->b_data[i]);
+		checksum += (uint8_t) (bh->b_data[i]);
 	if (checksum != tag_p->tagChecksum) {
 		printk(KERN_ERR "udf: tag checksum failed block %d\n", block);
 		goto error_out;
@@ -245,38 +240,39 @@ udf_read_tagged(struct super_block *sb, 
 
 	/* Verify the tag version */
 	if (le16_to_cpu(tag_p->descVersion) != 0x0002U &&
-		le16_to_cpu(tag_p->descVersion) != 0x0003U)
-	{
+	    le16_to_cpu(tag_p->descVersion) != 0x0003U) {
 		udf_debug("tag version 0x%04x != 0x0002 || 0x0003 block %d\n",
-			le16_to_cpu(tag_p->descVersion), block);
+			  le16_to_cpu(tag_p->descVersion), block);
 		goto error_out;
 	}
 
 	/* Verify the descriptor CRC */
 	if (le16_to_cpu(tag_p->descCRCLength) + sizeof(tag) > sb->s_blocksize ||
-		le16_to_cpu(tag_p->descCRC) == udf_crc(bh->b_data + sizeof(tag),
-			le16_to_cpu(tag_p->descCRCLength), 0))
-	{
+	    le16_to_cpu(tag_p->descCRC) == udf_crc(bh->b_data + sizeof(tag),
+						   le16_to_cpu(tag_p->
+							       descCRCLength),
+						   0)) {
 		return bh;
 	}
 	udf_debug("Crc failure block %d: crc = %d, crclen = %d\n",
-		block + UDF_SB_SESSION(sb), le16_to_cpu(tag_p->descCRC), le16_to_cpu(tag_p->descCRCLength));
+		  block + UDF_SB_SESSION(sb), le16_to_cpu(tag_p->descCRC),
+		  le16_to_cpu(tag_p->descCRCLength));
 
-error_out:
+      error_out:
 	brelse(bh);
 	return NULL;
 }
 
-struct buffer_head *
-udf_read_ptagged(struct super_block *sb, kernel_lb_addr loc, uint32_t offset, uint16_t *ident)
+struct buffer_head *udf_read_ptagged(struct super_block *sb, kernel_lb_addr loc,
+				     uint32_t offset, uint16_t * ident)
 {
 	return udf_read_tagged(sb, udf_get_lb_pblock(sb, loc, offset),
-		loc.logicalBlockNum + offset, ident);
+			       loc.logicalBlockNum + offset, ident);
 }
 
 void udf_update_tag(char *data, int length)
 {
-	tag *tptr = (tag *)data;
+	tag *tptr = (tag *) data;
 	int i;
 
 	length -= sizeof(tag);
@@ -285,15 +281,15 @@ void udf_update_tag(char *data, int leng
 	tptr->descCRCLength = cpu_to_le16(length);
 	tptr->descCRC = cpu_to_le16(udf_crc(data + sizeof(tag), length, 0));
 
-	for (i=0; i<16; i++)
+	for (i = 0; i < 16; i++)
 		if (i != 4)
-			tptr->tagChecksum += (uint8_t)(data[i]);
+			tptr->tagChecksum += (uint8_t) (data[i]);
 }
 
 void udf_new_tag(char *data, uint16_t ident, uint16_t version, uint16_t snum,
-	uint32_t loc, int length)
+		 uint32_t loc, int length)
 {
-	tag *tptr = (tag *)data;
+	tag *tptr = (tag *) data;
 	tptr->tagIdent = cpu_to_le16(ident);
 	tptr->descVersion = cpu_to_le16(version);
 	tptr->tagSerialNum = cpu_to_le16(snum);
diff -puN fs/udf/namei.c~udf-coding-style-conversion-lindent fs/udf/namei.c
--- a/fs/udf/namei.c~udf-coding-style-conversion-lindent
+++ a/fs/udf/namei.c
@@ -32,7 +32,8 @@
 #include <linux/buffer_head.h>
 #include <linux/sched.h>
 
-static inline int udf_match(int len1, const char *name1, int len2, const char *name2)
+static inline int udf_match(int len1, const char *name1, int len2,
+			    const char *name2)
 {
 	if (len1 != len2)
 		return 0;
@@ -40,8 +41,8 @@ static inline int udf_match(int len1, co
 }
 
 int udf_write_fi(struct inode *inode, struct fileIdentDesc *cfi,
-	struct fileIdentDesc *sfi, struct udf_fileident_bh *fibh,
-	uint8_t *impuse, uint8_t *fileident)
+		 struct fileIdentDesc *sfi, struct udf_fileident_bh *fibh,
+		 uint8_t * impuse, uint8_t * fileident)
 {
 	uint16_t crclen = fibh->eoffset - fibh->soffset - sizeof(tag);
 	uint16_t crc;
@@ -51,7 +52,7 @@ int udf_write_fi(struct inode *inode, st
 	uint16_t liu = le16_to_cpu(cfi->lengthOfImpUse);
 	uint8_t lfi = cfi->lengthFileIdent;
 	int padlen = fibh->eoffset - fibh->soffset - liu - lfi -
-		sizeof(struct fileIdentDesc);
+	    sizeof(struct fileIdentDesc);
 	int adinicb = 0;
 
 	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB)
@@ -59,83 +60,86 @@ int udf_write_fi(struct inode *inode, st
 
 	offset = fibh->soffset + sizeof(struct fileIdentDesc);
 
-	if (impuse)
-	{
+	if (impuse) {
 		if (adinicb || (offset + liu < 0))
-			memcpy((uint8_t *)sfi->impUse, impuse, liu);
+			memcpy((uint8_t *) sfi->impUse, impuse, liu);
 		else if (offset >= 0)
 			memcpy(fibh->ebh->b_data + offset, impuse, liu);
-		else
-		{
-			memcpy((uint8_t *)sfi->impUse, impuse, -offset);
-			memcpy(fibh->ebh->b_data, impuse - offset, liu + offset);
+		else {
+			memcpy((uint8_t *) sfi->impUse, impuse, -offset);
+			memcpy(fibh->ebh->b_data, impuse - offset,
+			       liu + offset);
 		}
 	}
 
 	offset += liu;
 
-	if (fileident)
-	{
+	if (fileident) {
 		if (adinicb || (offset + lfi < 0))
-			memcpy((uint8_t *)sfi->fileIdent + liu, fileident, lfi);
+			memcpy((uint8_t *) sfi->fileIdent + liu, fileident,
+			       lfi);
 		else if (offset >= 0)
 			memcpy(fibh->ebh->b_data + offset, fileident, lfi);
-		else
-		{
-			memcpy((uint8_t *)sfi->fileIdent + liu, fileident, -offset);
-			memcpy(fibh->ebh->b_data, fileident - offset, lfi + offset);
+		else {
+			memcpy((uint8_t *) sfi->fileIdent + liu, fileident,
+			       -offset);
+			memcpy(fibh->ebh->b_data, fileident - offset,
+			       lfi + offset);
 		}
 	}
 
 	offset += lfi;
 
 	if (adinicb || (offset + padlen < 0))
-		memset((uint8_t *)sfi->padding + liu + lfi, 0x00, padlen);
+		memset((uint8_t *) sfi->padding + liu + lfi, 0x00, padlen);
 	else if (offset >= 0)
 		memset(fibh->ebh->b_data + offset, 0x00, padlen);
-	else
-	{
-		memset((uint8_t *)sfi->padding + liu + lfi, 0x00, -offset);
+	else {
+		memset((uint8_t *) sfi->padding + liu + lfi, 0x00, -offset);
 		memset(fibh->ebh->b_data, 0x00, padlen + offset);
 	}
 
-	crc = udf_crc((uint8_t *)cfi + sizeof(tag), sizeof(struct fileIdentDesc) -
-		sizeof(tag), 0);
+	crc =
+	    udf_crc((uint8_t *) cfi + sizeof(tag),
+		    sizeof(struct fileIdentDesc) - sizeof(tag), 0);
 
 	if (fibh->sbh == fibh->ebh)
-		crc = udf_crc((uint8_t *)sfi->impUse,
-			crclen + sizeof(tag) - sizeof(struct fileIdentDesc), crc);
+		crc = udf_crc((uint8_t *) sfi->impUse,
+			      crclen + sizeof(tag) -
+			      sizeof(struct fileIdentDesc), crc);
 	else if (sizeof(struct fileIdentDesc) >= -fibh->soffset)
-		crc = udf_crc(fibh->ebh->b_data + sizeof(struct fileIdentDesc) + fibh->soffset,
-			crclen + sizeof(tag) - sizeof(struct fileIdentDesc), crc);
-	else
-	{
-		crc = udf_crc((uint8_t *)sfi->impUse,
-			-fibh->soffset - sizeof(struct fileIdentDesc), crc);
+		crc =
+		    udf_crc(fibh->ebh->b_data + sizeof(struct fileIdentDesc) +
+			    fibh->soffset,
+			    crclen + sizeof(tag) - sizeof(struct fileIdentDesc),
+			    crc);
+	else {
+		crc = udf_crc((uint8_t *) sfi->impUse,
+			      -fibh->soffset - sizeof(struct fileIdentDesc),
+			      crc);
 		crc = udf_crc(fibh->ebh->b_data, fibh->eoffset, crc);
 	}
 
 	cfi->descTag.descCRC = cpu_to_le16(crc);
 	cfi->descTag.descCRCLength = cpu_to_le16(crclen);
 
-	for (i=0; i<16; i++)
+	for (i = 0; i < 16; i++)
 		if (i != 4)
-			checksum += ((uint8_t *)&cfi->descTag)[i];
+			checksum += ((uint8_t *) & cfi->descTag)[i];
 
 	cfi->descTag.tagChecksum = checksum;
 	if (adinicb || (sizeof(struct fileIdentDesc) <= -fibh->soffset))
-		memcpy((uint8_t *)sfi, (uint8_t *)cfi, sizeof(struct fileIdentDesc));
-	else
-	{
-		memcpy((uint8_t *)sfi, (uint8_t *)cfi, -fibh->soffset);
-		memcpy(fibh->ebh->b_data, (uint8_t *)cfi - fibh->soffset,
-			sizeof(struct fileIdentDesc) + fibh->soffset);
+		memcpy((uint8_t *) sfi, (uint8_t *) cfi,
+		       sizeof(struct fileIdentDesc));
+	else {
+		memcpy((uint8_t *) sfi, (uint8_t *) cfi, -fibh->soffset);
+		memcpy(fibh->ebh->b_data, (uint8_t *) cfi - fibh->soffset,
+		       sizeof(struct fileIdentDesc) + fibh->soffset);
 	}
 
 	if (adinicb)
 		mark_inode_dirty(inode);
-	else
-	{
+	else {
 		if (fibh->sbh != fibh->ebh)
 			mark_buffer_dirty_inode(fibh->ebh, inode);
 		mark_buffer_dirty_inode(fibh->sbh, inode);
@@ -143,12 +147,12 @@ int udf_write_fi(struct inode *inode, st
 	return 0;
 }
 
-static struct fileIdentDesc *
-udf_find_entry(struct inode *dir, struct dentry *dentry,
-	struct udf_fileident_bh *fibh,
-	struct fileIdentDesc *cfi)
+static struct fileIdentDesc *udf_find_entry(struct inode *dir,
+					    struct dentry *dentry,
+					    struct udf_fileident_bh *fibh,
+					    struct fileIdentDesc *cfi)
 {
-	struct fileIdentDesc *fi=NULL;
+	struct fileIdentDesc *fi = NULL;
 	loff_t f_pos;
 	int block, flen;
 	char fname[UDF_NAME_LEN];
@@ -159,46 +163,41 @@ udf_find_entry(struct inode *dir, struct
 	kernel_lb_addr eloc;
 	uint32_t elen;
 	sector_t offset;
-	struct extent_position epos = { NULL, 0, { 0, 0}};
+	struct extent_position epos = { NULL, 0, {0, 0} };
 
 	size = (udf_ext0_offset(dir) + dir->i_size) >> 2;
 	f_pos = (udf_ext0_offset(dir) >> 2);
 
-	fibh->soffset = fibh->eoffset = (f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
+	fibh->soffset = fibh->eoffset =
+	    (f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
 	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
 		fibh->sbh = fibh->ebh = NULL;
 	else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
-		&epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30))
-	{
+			    &epos, &eloc, &elen,
+			    &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
-		if ((++offset << dir->i_sb->s_blocksize_bits) < elen)
-		{
+		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
 			if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_SHORT)
 				epos.offset -= sizeof(short_ad);
 			else if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_LONG)
 				epos.offset -= sizeof(long_ad);
-		}
-		else
+		} else
 			offset = 0;
 
-		if (!(fibh->sbh = fibh->ebh = udf_tread(dir->i_sb, block)))
-		{
+		if (!(fibh->sbh = fibh->ebh = udf_tread(dir->i_sb, block))) {
 			brelse(epos.bh);
 			return NULL;
 		}
-	}
-	else
-	{
+	} else {
 		brelse(epos.bh);
 		return NULL;
 	}
 
-	while ( (f_pos < size) )
-	{
-		fi = udf_fileident_read(dir, &f_pos, fibh, cfi, &epos, &eloc, &elen, &offset);
+	while ((f_pos < size)) {
+		fi = udf_fileident_read(dir, &f_pos, fibh, cfi, &epos, &eloc,
+					&elen, &offset);
 
-		if (!fi)
-		{
+		if (!fi) {
 			if (fibh->sbh != fibh->ebh)
 				brelse(fibh->ebh);
 			brelse(fibh->sbh);
@@ -209,45 +208,45 @@ udf_find_entry(struct inode *dir, struct
 		liu = le16_to_cpu(cfi->lengthOfImpUse);
 		lfi = cfi->lengthFileIdent;
 
-		if (fibh->sbh == fibh->ebh)
-		{
+		if (fibh->sbh == fibh->ebh) {
 			nameptr = fi->fileIdent + liu;
-		}
-		else
-		{
+		} else {
 			int poffset;	/* Unpaded ending offset */
 
-			poffset = fibh->soffset + sizeof(struct fileIdentDesc) + liu + lfi;
+			poffset =
+			    fibh->soffset + sizeof(struct fileIdentDesc) + liu +
+			    lfi;
 
 			if (poffset >= lfi)
-				nameptr = (uint8_t *)(fibh->ebh->b_data + poffset - lfi);
-			else
-			{
+				nameptr =
+				    (uint8_t *) (fibh->ebh->b_data + poffset -
+						 lfi);
+			else {
 				nameptr = fname;
-				memcpy(nameptr, fi->fileIdent + liu, lfi - poffset);
-				memcpy(nameptr + lfi - poffset, fibh->ebh->b_data, poffset);
+				memcpy(nameptr, fi->fileIdent + liu,
+				       lfi - poffset);
+				memcpy(nameptr + lfi - poffset,
+				       fibh->ebh->b_data, poffset);
 			}
 		}
 
-		if ( (cfi->fileCharacteristics & FID_FILE_CHAR_DELETED) != 0 )
-		{
-			if ( !UDF_QUERY_FLAG(dir->i_sb, UDF_FLAG_UNDELETE) )
+		if ((cfi->fileCharacteristics & FID_FILE_CHAR_DELETED) != 0) {
+			if (!UDF_QUERY_FLAG(dir->i_sb, UDF_FLAG_UNDELETE))
 				continue;
 		}
-	    
-		if ( (cfi->fileCharacteristics & FID_FILE_CHAR_HIDDEN) != 0 )
-		{
-			if ( !UDF_QUERY_FLAG(dir->i_sb, UDF_FLAG_UNHIDE) )
+
+		if ((cfi->fileCharacteristics & FID_FILE_CHAR_HIDDEN) != 0) {
+			if (!UDF_QUERY_FLAG(dir->i_sb, UDF_FLAG_UNHIDE))
 				continue;
 		}
 
 		if (!lfi)
 			continue;
 
-		if ((flen = udf_get_filename(dir->i_sb, nameptr, fname, lfi)))
-		{
-			if (udf_match(flen, fname, dentry->d_name.len, dentry->d_name.name))
-			{
+		if ((flen = udf_get_filename(dir->i_sb, nameptr, fname, lfi))) {
+			if (udf_match
+			    (flen, fname, dentry->d_name.len,
+			     dentry->d_name.name)) {
 				brelse(epos.bh);
 				return fi;
 			}
@@ -293,41 +292,37 @@ udf_find_entry(struct inode *dir, struct
  *	Written, tested, and released.
  */
 
-static struct dentry *
-udf_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *udf_lookup(struct inode *dir, struct dentry *dentry,
+				 struct nameidata *nd)
 {
 	struct inode *inode = NULL;
 	struct fileIdentDesc cfi;
 	struct udf_fileident_bh fibh;
 
-	if (dentry->d_name.len > UDF_NAME_LEN-2)
+	if (dentry->d_name.len > UDF_NAME_LEN - 2)
 		return ERR_PTR(-ENAMETOOLONG);
 
 	lock_kernel();
 #ifdef UDF_RECOVERY
 	/* temporary shorthand for specifying files by inode number */
-	if (!strncmp(dentry->d_name.name, ".B=", 3) )
-	{
-		kernel_lb_addr lb = { 0, simple_strtoul(dentry->d_name.name+3, NULL, 0) };
+	if (!strncmp(dentry->d_name.name, ".B=", 3)) {
+		kernel_lb_addr lb =
+		    { 0, simple_strtoul(dentry->d_name.name + 3, NULL, 0) };
 		inode = udf_iget(dir->i_sb, lb);
-		if (!inode)
-		{
+		if (!inode) {
 			unlock_kernel();
 			return ERR_PTR(-EACCES);
 		}
-	}
-	else
-#endif /* UDF_RECOVERY */
+	} else
+#endif				/* UDF_RECOVERY */
 
-	if (udf_find_entry(dir, dentry, &fibh, &cfi))
-	{
+	if (udf_find_entry(dir, dentry, &fibh, &cfi)) {
 		if (fibh.sbh != fibh.ebh)
 			brelse(fibh.ebh);
 		brelse(fibh.sbh);
 
 		inode = udf_iget(dir->i_sb, lelb_to_cpu(cfi.icb.extLocation));
-		if ( !inode )
-		{
+		if (!inode) {
 			unlock_kernel();
 			return ERR_PTR(-EACCES);
 		}
@@ -337,13 +332,13 @@ udf_lookup(struct inode *dir, struct den
 	return NULL;
 }
 
-static struct fileIdentDesc *
-udf_add_entry(struct inode *dir, struct dentry *dentry,
-	struct udf_fileident_bh *fibh,
-	struct fileIdentDesc *cfi, int *err)
+static struct fileIdentDesc *udf_add_entry(struct inode *dir,
+					   struct dentry *dentry,
+					   struct udf_fileident_bh *fibh,
+					   struct fileIdentDesc *cfi, int *err)
 {
 	struct super_block *sb;
-	struct fileIdentDesc *fi=NULL;
+	struct fileIdentDesc *fi = NULL;
 	char name[UDF_NAME_LEN], fname[UDF_NAME_LEN];
 	int namelen;
 	loff_t f_pos;
@@ -357,50 +352,47 @@ udf_add_entry(struct inode *dir, struct 
 	kernel_lb_addr eloc;
 	uint32_t elen;
 	sector_t offset;
-	struct extent_position epos = { NULL, 0, { 0, 0 }};
+	struct extent_position epos = { NULL, 0, {0, 0} };
 
 	sb = dir->i_sb;
 
-	if (dentry)
-	{
-		if (!dentry->d_name.len)
-		{
+	if (dentry) {
+		if (!dentry->d_name.len) {
 			*err = -EINVAL;
 			return NULL;
 		}
 
-		if ( !(namelen = udf_put_filename(sb, dentry->d_name.name, name, dentry->d_name.len)))
-		{
+		if (!
+		    (namelen =
+		     udf_put_filename(sb, dentry->d_name.name, name,
+				      dentry->d_name.len))) {
 			*err = -ENAMETOOLONG;
 			return NULL;
 		}
-	}
-	else
+	} else
 		namelen = 0;
 
 	nfidlen = (sizeof(struct fileIdentDesc) + namelen + 3) & ~3;
 
 	f_pos = (udf_ext0_offset(dir) >> 2);
 
-	fibh->soffset = fibh->eoffset = (f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
+	fibh->soffset = fibh->eoffset =
+	    (f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
 	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
 		fibh->sbh = fibh->ebh = NULL;
 	else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
-		&epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30))
-	{
+			    &epos, &eloc, &elen,
+			    &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
-		if ((++offset << dir->i_sb->s_blocksize_bits) < elen)
-		{
+		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
 			if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_SHORT)
 				epos.offset -= sizeof(short_ad);
 			else if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_LONG)
 				epos.offset -= sizeof(long_ad);
-		}
-		else
+		} else
 			offset = 0;
 
-		if (!(fibh->sbh = fibh->ebh = udf_tread(dir->i_sb, block)))
-		{
+		if (!(fibh->sbh = fibh->ebh = udf_tread(dir->i_sb, block))) {
 			brelse(epos.bh);
 			*err = -EIO;
 			return NULL;
@@ -408,21 +400,18 @@ udf_add_entry(struct inode *dir, struct 
 
 		block = UDF_I_LOCATION(dir).logicalBlockNum;
 
-	}
-	else
-	{
+	} else {
 		block = udf_get_lb_pblock(dir->i_sb, UDF_I_LOCATION(dir), 0);
 		fibh->sbh = fibh->ebh = NULL;
 		fibh->soffset = fibh->eoffset = sb->s_blocksize;
 		goto add;
 	}
 
-	while ( (f_pos < size) )
-	{
-		fi = udf_fileident_read(dir, &f_pos, fibh, cfi, &epos, &eloc, &elen, &offset);
+	while ((f_pos < size)) {
+		fi = udf_fileident_read(dir, &f_pos, fibh, cfi, &epos, &eloc,
+					&elen, &offset);
 
-		if (!fi)
-		{
+		if (!fi) {
 			if (fibh->sbh != fibh->ebh)
 				brelse(fibh->ebh);
 			brelse(fibh->sbh);
@@ -436,36 +425,38 @@ udf_add_entry(struct inode *dir, struct 
 
 		if (fibh->sbh == fibh->ebh)
 			nameptr = fi->fileIdent + liu;
-		else
-		{
+		else {
 			int poffset;	/* Unpaded ending offset */
 
-			poffset = fibh->soffset + sizeof(struct fileIdentDesc) + liu + lfi;
+			poffset =
+			    fibh->soffset + sizeof(struct fileIdentDesc) + liu +
+			    lfi;
 
 			if (poffset >= lfi)
-				nameptr = (char *)(fibh->ebh->b_data + poffset - lfi);
-			else
-			{
+				nameptr =
+				    (char *)(fibh->ebh->b_data + poffset - lfi);
+			else {
 				nameptr = fname;
-				memcpy(nameptr, fi->fileIdent + liu, lfi - poffset);
-				memcpy(nameptr + lfi - poffset, fibh->ebh->b_data, poffset);
+				memcpy(nameptr, fi->fileIdent + liu,
+				       lfi - poffset);
+				memcpy(nameptr + lfi - poffset,
+				       fibh->ebh->b_data, poffset);
 			}
 		}
 
-		if ( (cfi->fileCharacteristics & FID_FILE_CHAR_DELETED) != 0 )
-		{
-			if (((sizeof(struct fileIdentDesc) + liu + lfi + 3) & ~3) == nfidlen)
-			{
+		if ((cfi->fileCharacteristics & FID_FILE_CHAR_DELETED) != 0) {
+			if (((sizeof(struct fileIdentDesc) + liu + lfi +
+			      3) & ~3) == nfidlen) {
 				brelse(epos.bh);
 				cfi->descTag.tagSerialNum = cpu_to_le16(1);
 				cfi->fileVersionNum = cpu_to_le16(1);
 				cfi->fileCharacteristics = 0;
 				cfi->lengthFileIdent = namelen;
 				cfi->lengthOfImpUse = cpu_to_le16(0);
-				if (!udf_write_fi(dir, cfi, fi, fibh, NULL, name))
+				if (!udf_write_fi
+				    (dir, cfi, fi, fibh, NULL, name))
 					return fi;
-				else
-				{
+				else {
 					*err = -EIO;
 					return NULL;
 				}
@@ -476,8 +467,8 @@ udf_add_entry(struct inode *dir, struct 
 			continue;
 
 		if ((flen = udf_get_filename(dir->i_sb, nameptr, fname, lfi)) &&
-			udf_match(flen, fname, dentry->d_name.len, dentry->d_name.name))
-		{
+		    udf_match(flen, fname, dentry->d_name.len,
+			      dentry->d_name.name)) {
 			if (fibh->sbh != fibh->ebh)
 				brelse(fibh->ebh);
 			brelse(fibh->sbh);
@@ -487,12 +478,11 @@ udf_add_entry(struct inode *dir, struct 
 		}
 	}
 
-add:
+      add:
 	f_pos += nfidlen;
 
 	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB &&
-		sb->s_blocksize - fibh->eoffset < nfidlen)
-	{
+	    sb->s_blocksize - fibh->eoffset < nfidlen) {
 		brelse(epos.bh);
 		epos.bh = NULL;
 		fibh->soffset -= udf_ext0_offset(dir);
@@ -501,11 +491,14 @@ add:
 		if (fibh->sbh != fibh->ebh)
 			brelse(fibh->ebh);
 		brelse(fibh->sbh);
-		if (!(fibh->sbh = fibh->ebh = udf_expand_dir_adinicb(dir, &block, err)))
+		if (!
+		    (fibh->sbh = fibh->ebh =
+		     udf_expand_dir_adinicb(dir, &block, err)))
 			return NULL;
 		epos.block = UDF_I_LOCATION(dir);
 		eloc.logicalBlockNum = block;
-		eloc.partitionReferenceNum = UDF_I_LOCATION(dir).partitionReferenceNum;
+		eloc.partitionReferenceNum =
+		    UDF_I_LOCATION(dir).partitionReferenceNum;
 		elen = dir->i_sb->s_blocksize;
 		epos.offset = udf_file_entry_alloc_offset(dir);
 		if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_SHORT)
@@ -514,89 +507,84 @@ add:
 			epos.offset += sizeof(long_ad);
 	}
 
-	if (sb->s_blocksize - fibh->eoffset >= nfidlen)
-	{
+	if (sb->s_blocksize - fibh->eoffset >= nfidlen) {
 		fibh->soffset = fibh->eoffset;
 		fibh->eoffset += nfidlen;
-		if (fibh->sbh != fibh->ebh)
-		{
+		if (fibh->sbh != fibh->ebh) {
 			brelse(fibh->sbh);
 			fibh->sbh = fibh->ebh;
 		}
 
-		if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
-		{
+		if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
 			block = UDF_I_LOCATION(dir).logicalBlockNum;
-			fi = (struct fileIdentDesc *)(UDF_I_DATA(dir) + fibh->soffset - udf_ext0_offset(dir) + UDF_I_LENEATTR(dir));
-		}
-		else
-		{
+			fi = (struct fileIdentDesc *)(UDF_I_DATA(dir) +
+						      fibh->soffset -
+						      udf_ext0_offset(dir) +
+						      UDF_I_LENEATTR(dir));
+		} else {
 			block = eloc.logicalBlockNum + ((elen - 1) >>
-				dir->i_sb->s_blocksize_bits);
-			fi = (struct fileIdentDesc *)(fibh->sbh->b_data + fibh->soffset);
+							dir->i_sb->
+							s_blocksize_bits);
+			fi = (struct fileIdentDesc *)(fibh->sbh->b_data +
+						      fibh->soffset);
 		}
-	}
-	else
-	{
+	} else {
 		fibh->soffset = fibh->eoffset - sb->s_blocksize;
 		fibh->eoffset += nfidlen - sb->s_blocksize;
-		if (fibh->sbh != fibh->ebh)
-		{
+		if (fibh->sbh != fibh->ebh) {
 			brelse(fibh->sbh);
 			fibh->sbh = fibh->ebh;
 		}
 
 		block = eloc.logicalBlockNum + ((elen - 1) >>
-			dir->i_sb->s_blocksize_bits);
+						dir->i_sb->s_blocksize_bits);
 
-		if (!(fibh->ebh = udf_bread(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2), 1, err)))
-		{
+		if (!
+		    (fibh->ebh =
+		     udf_bread(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
+			       1, err))) {
 			brelse(epos.bh);
 			brelse(fibh->sbh);
 			return NULL;
 		}
 
-		if (!(fibh->soffset))
-		{
+		if (!(fibh->soffset)) {
 			if (udf_next_aext(dir, &epos, &eloc, &elen, 1) ==
-				(EXT_RECORDED_ALLOCATED >> 30))
-			{
+			    (EXT_RECORDED_ALLOCATED >> 30)) {
 				block = eloc.logicalBlockNum + ((elen - 1) >>
-					dir->i_sb->s_blocksize_bits);
-			}
-			else
-				block ++;
+								dir->i_sb->
+								s_blocksize_bits);
+			} else
+				block++;
 
 			brelse(fibh->sbh);
 			fibh->sbh = fibh->ebh;
 			fi = (struct fileIdentDesc *)(fibh->sbh->b_data);
-		}
-		else
-		{
+		} else {
 			fi = (struct fileIdentDesc *)
-				(fibh->sbh->b_data + sb->s_blocksize + fibh->soffset);
+			    (fibh->sbh->b_data + sb->s_blocksize +
+			     fibh->soffset);
 		}
 	}
 
 	memset(cfi, 0, sizeof(struct fileIdentDesc));
 	if (UDF_SB_UDFREV(sb) >= 0x0200)
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
-	if (!udf_write_fi(dir, cfi, fi, fibh, NULL, name))
-	{
+	if (!udf_write_fi(dir, cfi, fi, fibh, NULL, name)) {
 		brelse(epos.bh);
 		dir->i_size += nfidlen;
 		if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
 			UDF_I_LENALLOC(dir) += nfidlen;
 		mark_inode_dirty(dir);
 		return fi;
-	}
-	else
-	{
+	} else {
 		brelse(epos.bh);
 		if (fibh->sbh != fibh->ebh)
 			brelse(fibh->ebh);
@@ -607,7 +595,8 @@ add:
 }
 
 static int udf_delete_entry(struct inode *inode, struct fileIdentDesc *fi,
-	struct udf_fileident_bh *fibh, struct fileIdentDesc *cfi)
+			    struct udf_fileident_bh *fibh,
+			    struct fileIdentDesc *cfi)
 {
 	cfi->fileCharacteristics |= FID_FILE_CHAR_DELETED;
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT))
@@ -615,7 +604,8 @@ static int udf_delete_entry(struct inode
 	return udf_write_fi(inode, cfi, fi, fibh, NULL, NULL);
 }
 
-static int udf_create(struct inode *dir, struct dentry *dentry, int mode, struct nameidata *nd)
+static int udf_create(struct inode *dir, struct dentry *dentry, int mode,
+		      struct nameidata *nd)
 {
 	struct udf_fileident_bh fibh;
 	struct inode *inode;
@@ -624,8 +614,7 @@ static int udf_create(struct inode *dir,
 
 	lock_kernel();
 	inode = udf_new_inode(dir, mode, &err);
-	if (!inode)
-	{
+	if (!inode) {
 		unlock_kernel();
 		return err;
 	}
@@ -639,9 +628,8 @@ static int udf_create(struct inode *dir,
 	inode->i_mode = mode;
 	mark_inode_dirty(inode);
 
-	if (!(fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err)))
-	{
-		inode->i_nlink --;
+	if (!(fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err))) {
+		inode->i_nlink--;
 		mark_inode_dirty(inode);
 		iput(inode);
 		unlock_kernel();
@@ -649,11 +637,10 @@ static int udf_create(struct inode *dir,
 	}
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
 	cfi.icb.extLocation = cpu_to_lelb(UDF_I_LOCATION(inode));
-	*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
-		cpu_to_le32(UDF_I_UNIQUE(inode) & 0x00000000FFFFFFFFUL);
+	*(__le32 *) ((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
+	    cpu_to_le32(UDF_I_UNIQUE(inode) & 0x00000000FFFFFFFFUL);
 	udf_write_fi(dir, &cfi, fi, &fibh, NULL, NULL);
-	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
-	{
+	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
 		mark_inode_dirty(dir);
 	}
 	if (fibh.sbh != fibh.ebh)
@@ -664,9 +651,10 @@ static int udf_create(struct inode *dir,
 	return 0;
 }
 
-static int udf_mknod(struct inode * dir, struct dentry * dentry, int mode, dev_t rdev)
+static int udf_mknod(struct inode *dir, struct dentry *dentry, int mode,
+		     dev_t rdev)
 {
-	struct inode * inode;
+	struct inode *inode;
 	struct udf_fileident_bh fibh;
 	struct fileIdentDesc cfi, *fi;
 	int err;
@@ -682,9 +670,8 @@ static int udf_mknod(struct inode * dir,
 
 	inode->i_uid = current->fsuid;
 	init_special_inode(inode, mode, rdev);
-	if (!(fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err)))
-	{
-		inode->i_nlink --;
+	if (!(fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err))) {
+		inode->i_nlink--;
 		mark_inode_dirty(inode);
 		iput(inode);
 		unlock_kernel();
@@ -692,11 +679,10 @@ static int udf_mknod(struct inode * dir,
 	}
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
 	cfi.icb.extLocation = cpu_to_lelb(UDF_I_LOCATION(inode));
-	*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
-		cpu_to_le32(UDF_I_UNIQUE(inode) & 0x00000000FFFFFFFFUL);
+	*(__le32 *) ((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
+	    cpu_to_le32(UDF_I_UNIQUE(inode) & 0x00000000FFFFFFFFUL);
 	udf_write_fi(dir, &cfi, fi, &fibh, NULL, NULL);
-	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
-	{
+	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
 		mark_inode_dirty(dir);
 	}
 	mark_inode_dirty(inode);
@@ -706,21 +692,21 @@ static int udf_mknod(struct inode * dir,
 	brelse(fibh.sbh);
 	d_instantiate(dentry, inode);
 	err = 0;
-out:
+      out:
 	unlock_kernel();
 	return err;
 }
 
-static int udf_mkdir(struct inode * dir, struct dentry * dentry, int mode)
+static int udf_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
-	struct inode * inode;
+	struct inode *inode;
 	struct udf_fileident_bh fibh;
 	struct fileIdentDesc cfi, *fi;
 	int err;
 
 	lock_kernel();
 	err = -EMLINK;
-	if (dir->i_nlink >= (256<<sizeof(dir->i_nlink))-1)
+	if (dir->i_nlink >= (256 << sizeof(dir->i_nlink)) - 1)
 		goto out;
 
 	err = -EIO;
@@ -730,8 +716,7 @@ static int udf_mkdir(struct inode * dir,
 
 	inode->i_op = &udf_dir_inode_operations;
 	inode->i_fop = &udf_dir_operations;
-	if (!(fi = udf_add_entry(inode, NULL, &fibh, &cfi, &err)))
-	{
+	if (!(fi = udf_add_entry(inode, NULL, &fibh, &cfi, &err))) {
 		inode->i_nlink--;
 		mark_inode_dirty(inode);
 		iput(inode);
@@ -740,9 +725,10 @@ static int udf_mkdir(struct inode * dir,
 	inode->i_nlink = 2;
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
 	cfi.icb.extLocation = cpu_to_lelb(UDF_I_LOCATION(dir));
-	*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
-		cpu_to_le32(UDF_I_UNIQUE(dir) & 0x00000000FFFFFFFFUL);
-	cfi.fileCharacteristics = FID_FILE_CHAR_DIRECTORY | FID_FILE_CHAR_PARENT;
+	*(__le32 *) ((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
+	    cpu_to_le32(UDF_I_UNIQUE(dir) & 0x00000000FFFFFFFFUL);
+	cfi.fileCharacteristics =
+	    FID_FILE_CHAR_DIRECTORY | FID_FILE_CHAR_PARENT;
 	udf_write_fi(inode, &cfi, fi, &fibh, NULL, NULL);
 	brelse(fibh.sbh);
 	inode->i_mode = S_IFDIR | mode;
@@ -750,8 +736,7 @@ static int udf_mkdir(struct inode * dir,
 		inode->i_mode |= S_ISGID;
 	mark_inode_dirty(inode);
 
-	if (!(fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err)))
-	{
+	if (!(fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err))) {
 		inode->i_nlink = 0;
 		mark_inode_dirty(inode);
 		iput(inode);
@@ -759,8 +744,8 @@ static int udf_mkdir(struct inode * dir,
 	}
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
 	cfi.icb.extLocation = cpu_to_lelb(UDF_I_LOCATION(inode));
-	*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
-		cpu_to_le32(UDF_I_UNIQUE(inode) & 0x00000000FFFFFFFFUL);
+	*(__le32 *) ((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
+	    cpu_to_le32(UDF_I_UNIQUE(inode) & 0x00000000FFFFFFFFUL);
 	cfi.fileCharacteristics |= FID_FILE_CHAR_DIRECTORY;
 	udf_write_fi(dir, &cfi, fi, &fibh, NULL, NULL);
 	inc_nlink(dir);
@@ -770,7 +755,7 @@ static int udf_mkdir(struct inode * dir,
 		brelse(fibh.ebh);
 	brelse(fibh.sbh);
 	err = 0;
-out:
+      out:
 	unlock_kernel();
 	return err;
 }
@@ -785,47 +770,41 @@ static int empty_dir(struct inode *dir)
 	kernel_lb_addr eloc;
 	uint32_t elen;
 	sector_t offset;
-	struct extent_position epos = { NULL, 0, { 0, 0}};
+	struct extent_position epos = { NULL, 0, {0, 0} };
 
 	f_pos = (udf_ext0_offset(dir) >> 2);
 
-	fibh.soffset = fibh.eoffset = (f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
+	fibh.soffset = fibh.eoffset =
+	    (f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
 
 	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
 		fibh.sbh = fibh.ebh = NULL;
 	else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
-		&epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30))
-	{
+			    &epos, &eloc, &elen,
+			    &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
-		if ((++offset << dir->i_sb->s_blocksize_bits) < elen)
-		{
+		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
 			if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_SHORT)
 				epos.offset -= sizeof(short_ad);
 			else if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_LONG)
 				epos.offset -= sizeof(long_ad);
-		}
-		else
+		} else
 			offset = 0;
 
-		if (!(fibh.sbh = fibh.ebh = udf_tread(dir->i_sb, block)))
-		{
+		if (!(fibh.sbh = fibh.ebh = udf_tread(dir->i_sb, block))) {
 			brelse(epos.bh);
 			return 0;
 		}
-	}
-	else
-	{
+	} else {
 		brelse(epos.bh);
 		return 0;
 	}
 
+	while ((f_pos < size)) {
+		fi = udf_fileident_read(dir, &f_pos, &fibh, &cfi, &epos, &eloc,
+					&elen, &offset);
 
-	while ( (f_pos < size) )
-	{
-		fi = udf_fileident_read(dir, &f_pos, &fibh, &cfi, &epos, &eloc, &elen, &offset);
-
-		if (!fi)
-		{
+		if (!fi) {
 			if (fibh.sbh != fibh.ebh)
 				brelse(fibh.ebh);
 			brelse(fibh.sbh);
@@ -833,8 +812,8 @@ static int empty_dir(struct inode *dir)
 			return 0;
 		}
 
-		if (cfi.lengthFileIdent && (cfi.fileCharacteristics & FID_FILE_CHAR_DELETED) == 0)
-		{
+		if (cfi.lengthFileIdent
+		    && (cfi.fileCharacteristics & FID_FILE_CHAR_DELETED) == 0) {
 			if (fibh.sbh != fibh.ebh)
 				brelse(fibh.ebh);
 			brelse(fibh.sbh);
@@ -849,10 +828,10 @@ static int empty_dir(struct inode *dir)
 	return 1;
 }
 
-static int udf_rmdir(struct inode * dir, struct dentry * dentry)
+static int udf_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	int retval;
-	struct inode * inode = dentry->d_inode;
+	struct inode *inode = dentry->d_inode;
 	struct udf_fileident_bh fibh;
 	struct fileIdentDesc *fi, cfi;
 	kernel_lb_addr tloc;
@@ -875,27 +854,28 @@ static int udf_rmdir(struct inode * dir,
 		goto end_rmdir;
 	if (inode->i_nlink != 2)
 		udf_warning(inode->i_sb, "udf_rmdir",
-			"empty directory has nlink != 2 (%d)",
-			inode->i_nlink);
+			    "empty directory has nlink != 2 (%d)",
+			    inode->i_nlink);
 	clear_nlink(inode);
 	inode->i_size = 0;
 	inode_dec_link_count(dir);
-	inode->i_ctime = dir->i_ctime = dir->i_mtime = current_fs_time(dir->i_sb);
+	inode->i_ctime = dir->i_ctime = dir->i_mtime =
+	    current_fs_time(dir->i_sb);
 	mark_inode_dirty(dir);
 
-end_rmdir:
+      end_rmdir:
 	if (fibh.sbh != fibh.ebh)
 		brelse(fibh.ebh);
 	brelse(fibh.sbh);
-out:
+      out:
 	unlock_kernel();
 	return retval;
 }
 
-static int udf_unlink(struct inode * dir, struct dentry * dentry)
+static int udf_unlink(struct inode *dir, struct dentry *dentry)
 {
 	int retval;
-	struct inode * inode = dentry->d_inode;
+	struct inode *inode = dentry->d_inode;
 	struct udf_fileident_bh fibh;
 	struct fileIdentDesc *fi;
 	struct fileIdentDesc cfi;
@@ -912,10 +892,9 @@ static int udf_unlink(struct inode * dir
 	if (udf_get_lb_pblock(dir->i_sb, tloc, 0) != inode->i_ino)
 		goto end_unlink;
 
-	if (!inode->i_nlink)
-	{
+	if (!inode->i_nlink) {
 		udf_debug("Deleting nonexistent file (%lu), %d\n",
-			inode->i_ino, inode->i_nlink);
+			  inode->i_ino, inode->i_nlink);
 		inode->i_nlink = 1;
 	}
 	retval = udf_delete_entry(dir, fi, &fibh, &cfi);
@@ -927,22 +906,23 @@ static int udf_unlink(struct inode * dir
 	inode->i_ctime = dir->i_ctime;
 	retval = 0;
 
-end_unlink:
+      end_unlink:
 	if (fibh.sbh != fibh.ebh)
 		brelse(fibh.ebh);
 	brelse(fibh.sbh);
-out:
+      out:
 	unlock_kernel();
 	return retval;
 }
 
-static int udf_symlink(struct inode * dir, struct dentry * dentry, const char * symname)
+static int udf_symlink(struct inode *dir, struct dentry *dentry,
+		       const char *symname)
 {
-	struct inode * inode;
+	struct inode *inode;
 	struct pathComponent *pc;
 	char *compstart;
 	struct udf_fileident_bh fibh;
-	struct extent_position epos = { NULL,  0, {0, 0}};
+	struct extent_position epos = { NULL, 0, {0, 0} };
 	int eoffset, elen = 0;
 	struct fileIdentDesc *fi;
 	struct fileIdentDesc cfi;
@@ -960,28 +940,31 @@ static int udf_symlink(struct inode * di
 	inode->i_data.a_ops = &udf_symlink_aops;
 	inode->i_op = &page_symlink_inode_operations;
 
-	if (UDF_I_ALLOCTYPE(inode) != ICBTAG_FLAG_AD_IN_ICB)
-	{
+	if (UDF_I_ALLOCTYPE(inode) != ICBTAG_FLAG_AD_IN_ICB) {
 		kernel_lb_addr eloc;
 		uint32_t elen;
 
 		block = udf_new_block(inode->i_sb, inode,
-			UDF_I_LOCATION(inode).partitionReferenceNum,
-			UDF_I_LOCATION(inode).logicalBlockNum, &err);
+				      UDF_I_LOCATION(inode).
+				      partitionReferenceNum,
+				      UDF_I_LOCATION(inode).logicalBlockNum,
+				      &err);
 		if (!block)
 			goto out_no_entry;
 		epos.block = UDF_I_LOCATION(inode);
 		epos.offset = udf_file_entry_alloc_offset(inode);
 		epos.bh = NULL;
 		eloc.logicalBlockNum = block;
-		eloc.partitionReferenceNum = UDF_I_LOCATION(inode).partitionReferenceNum;
+		eloc.partitionReferenceNum =
+		    UDF_I_LOCATION(inode).partitionReferenceNum;
 		elen = inode->i_sb->s_blocksize;
 		UDF_I_LENEXTENTS(inode) = elen;
 		udf_add_aext(inode, &epos, eloc, elen, 0);
 		brelse(epos.bh);
 
 		block = udf_get_pblock(inode->i_sb, block,
-			UDF_I_LOCATION(inode).partitionReferenceNum, 0);
+				       UDF_I_LOCATION(inode).
+				       partitionReferenceNum, 0);
 		epos.bh = udf_tread(inode->i_sb, block);
 		lock_buffer(epos.bh);
 		memset(epos.bh->b_data, 0x00, inode->i_sb->s_blocksize);
@@ -989,17 +972,14 @@ static int udf_symlink(struct inode * di
 		unlock_buffer(epos.bh);
 		mark_buffer_dirty_inode(epos.bh, inode);
 		ea = epos.bh->b_data + udf_ext0_offset(inode);
-	}
-	else
+	} else
 		ea = UDF_I_DATA(inode) + UDF_I_LENEATTR(inode);
 
 	eoffset = inode->i_sb->s_blocksize - udf_ext0_offset(inode);
 	pc = (struct pathComponent *)ea;
 
-	if (*symname == '/')
-	{
-		do
-		{
+	if (*symname == '/') {
+		do {
 			symname++;
 		} while (*symname == '/');
 
@@ -1012,8 +992,7 @@ static int udf_symlink(struct inode * di
 
 	err = -ENAMETOOLONG;
 
-	while (*symname)
-	{
+	while (*symname) {
 		if (elen + sizeof(struct pathComponent) > eoffset)
 			goto out_no_entry;
 
@@ -1021,28 +1000,30 @@ static int udf_symlink(struct inode * di
 
 		compstart = (char *)symname;
 
-		do
-		{
+		do {
 			symname++;
 		} while (*symname && *symname != '/');
 
 		pc->componentType = 5;
 		pc->lengthComponentIdent = 0;
 		pc->componentFileVersionNum = 0;
-		if (compstart[0] == '.')
-		{
-			if ((symname-compstart) == 1)
+		if (compstart[0] == '.') {
+			if ((symname - compstart) == 1)
 				pc->componentType = 4;
-			else if ((symname-compstart) == 2 && compstart[1] == '.')
+			else if ((symname - compstart) == 2
+				 && compstart[1] == '.')
 				pc->componentType = 3;
 		}
 
-		if (pc->componentType == 5)
-		{
-			if ( !(namelen = udf_put_filename(inode->i_sb, compstart, name, symname-compstart)))
+		if (pc->componentType == 5) {
+			if (!
+			    (namelen =
+			     udf_put_filename(inode->i_sb, compstart, name,
+					      symname - compstart)))
 				goto out_no_entry;
 
-			if (elen + sizeof(struct pathComponent) + namelen > eoffset)
+			if (elen + sizeof(struct pathComponent) + namelen >
+			    eoffset)
 				goto out_no_entry;
 			else
 				pc->lengthComponentIdent = namelen;
@@ -1052,10 +1033,8 @@ static int udf_symlink(struct inode * di
 
 		elen += sizeof(struct pathComponent) + pc->lengthComponentIdent;
 
-		if (*symname)
-		{
-			do
-			{
+		if (*symname) {
+			do {
 				symname++;
 			} while (*symname == '/');
 		}
@@ -1071,22 +1050,22 @@ static int udf_symlink(struct inode * di
 		goto out_no_entry;
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
 	cfi.icb.extLocation = cpu_to_lelb(UDF_I_LOCATION(inode));
-	if (UDF_SB_LVIDBH(inode->i_sb))
-	{
+	if (UDF_SB_LVIDBH(inode->i_sb)) {
 		struct logicalVolHeaderDesc *lvhd;
 		uint64_t uniqueID;
-		lvhd = (struct logicalVolHeaderDesc *)(UDF_SB_LVID(inode->i_sb)->logicalVolContentsUse);
+		lvhd =
+		    (struct logicalVolHeaderDesc *)(UDF_SB_LVID(inode->i_sb)->
+						    logicalVolContentsUse);
 		uniqueID = le64_to_cpu(lvhd->uniqueID);
-		*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
-			cpu_to_le32(uniqueID & 0x00000000FFFFFFFFUL);
+		*(__le32 *) ((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
+		    cpu_to_le32(uniqueID & 0x00000000FFFFFFFFUL);
 		if (!(++uniqueID & 0x00000000FFFFFFFFUL))
 			uniqueID += 16;
 		lvhd->uniqueID = cpu_to_le64(uniqueID);
 		mark_buffer_dirty(UDF_SB_LVIDBH(inode->i_sb));
 	}
 	udf_write_fi(dir, &cfi, fi, &fibh, NULL, NULL);
-	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
-	{
+	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
 		mark_inode_dirty(dir);
 	}
 	if (fibh.sbh != fibh.ebh)
@@ -1095,18 +1074,18 @@ static int udf_symlink(struct inode * di
 	d_instantiate(dentry, inode);
 	err = 0;
 
-out:
+      out:
 	unlock_kernel();
 	return err;
 
-out_no_entry:
+      out_no_entry:
 	inode_dec_link_count(inode);
 	iput(inode);
 	goto out;
 }
 
-static int udf_link(struct dentry * old_dentry, struct inode * dir,
-	 struct dentry *dentry)
+static int udf_link(struct dentry *old_dentry, struct inode *dir,
+		    struct dentry *dentry)
 {
 	struct inode *inode = old_dentry->d_inode;
 	struct udf_fileident_bh fibh;
@@ -1114,35 +1093,33 @@ static int udf_link(struct dentry * old_
 	int err;
 
 	lock_kernel();
-	if (inode->i_nlink >= (256<<sizeof(inode->i_nlink))-1)
-	{
+	if (inode->i_nlink >= (256 << sizeof(inode->i_nlink)) - 1) {
 		unlock_kernel();
 		return -EMLINK;
 	}
 
-	if (!(fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err)))
-	{
+	if (!(fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err))) {
 		unlock_kernel();
 		return err;
 	}
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
 	cfi.icb.extLocation = cpu_to_lelb(UDF_I_LOCATION(inode));
-	if (UDF_SB_LVIDBH(inode->i_sb))
-	{
+	if (UDF_SB_LVIDBH(inode->i_sb)) {
 		struct logicalVolHeaderDesc *lvhd;
 		uint64_t uniqueID;
-		lvhd = (struct logicalVolHeaderDesc *)(UDF_SB_LVID(inode->i_sb)->logicalVolContentsUse);
+		lvhd =
+		    (struct logicalVolHeaderDesc *)(UDF_SB_LVID(inode->i_sb)->
+						    logicalVolContentsUse);
 		uniqueID = le64_to_cpu(lvhd->uniqueID);
-		*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
-			cpu_to_le32(uniqueID & 0x00000000FFFFFFFFUL);
+		*(__le32 *) ((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
+		    cpu_to_le32(uniqueID & 0x00000000FFFFFFFFUL);
 		if (!(++uniqueID & 0x00000000FFFFFFFFUL))
 			uniqueID += 16;
 		lvhd->uniqueID = cpu_to_le64(uniqueID);
 		mark_buffer_dirty(UDF_SB_LVIDBH(inode->i_sb));
 	}
 	udf_write_fi(dir, &cfi, fi, &fibh, NULL, NULL);
-	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
-	{
+	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
 		mark_inode_dirty(dir);
 	}
 	if (fibh.sbh != fibh.ebh)
@@ -1160,80 +1137,80 @@ static int udf_link(struct dentry * old_
 /* Anybody can rename anything with this: the permission checks are left to the
  * higher-level routines.
  */
-static int udf_rename (struct inode * old_dir, struct dentry * old_dentry,
-	struct inode * new_dir, struct dentry * new_dentry)
+static int udf_rename(struct inode *old_dir, struct dentry *old_dentry,
+		      struct inode *new_dir, struct dentry *new_dentry)
 {
-	struct inode * old_inode = old_dentry->d_inode;
-	struct inode * new_inode = new_dentry->d_inode;
+	struct inode *old_inode = old_dentry->d_inode;
+	struct inode *new_inode = new_dentry->d_inode;
 	struct udf_fileident_bh ofibh, nfibh;
-	struct fileIdentDesc *ofi = NULL, *nfi = NULL, *dir_fi = NULL, ocfi, ncfi;
+	struct fileIdentDesc *ofi = NULL, *nfi = NULL, *dir_fi =
+	    NULL, ocfi, ncfi;
 	struct buffer_head *dir_bh = NULL;
 	int retval = -ENOENT;
 	kernel_lb_addr tloc;
 
 	lock_kernel();
-	if ((ofi = udf_find_entry(old_dir, old_dentry, &ofibh, &ocfi)))
-	{
+	if ((ofi = udf_find_entry(old_dir, old_dentry, &ofibh, &ocfi))) {
 		if (ofibh.sbh != ofibh.ebh)
 			brelse(ofibh.ebh);
 		brelse(ofibh.sbh);
 	}
 	tloc = lelb_to_cpu(ocfi.icb.extLocation);
 	if (!ofi || udf_get_lb_pblock(old_dir->i_sb, tloc, 0)
-					!= old_inode->i_ino)
+	    != old_inode->i_ino)
 		goto end_rename;
 
 	nfi = udf_find_entry(new_dir, new_dentry, &nfibh, &ncfi);
-	if (nfi)
-	{
-		if (!new_inode)
-		{
+	if (nfi) {
+		if (!new_inode) {
 			if (nfibh.sbh != nfibh.ebh)
 				brelse(nfibh.ebh);
 			brelse(nfibh.sbh);
 			nfi = NULL;
 		}
 	}
-	if (S_ISDIR(old_inode->i_mode))
-	{
+	if (S_ISDIR(old_inode->i_mode)) {
 		uint32_t offset = udf_ext0_offset(old_inode);
 
-		if (new_inode)
-		{
+		if (new_inode) {
 			retval = -ENOTEMPTY;
 			if (!empty_dir(new_inode))
 				goto end_rename;
 		}
 		retval = -EIO;
-		if (UDF_I_ALLOCTYPE(old_inode) == ICBTAG_FLAG_AD_IN_ICB)
-		{
+		if (UDF_I_ALLOCTYPE(old_inode) == ICBTAG_FLAG_AD_IN_ICB) {
 			dir_fi = udf_get_fileident(UDF_I_DATA(old_inode) -
-				(UDF_I_EFE(old_inode) ?
-					sizeof(struct extendedFileEntry) :
-					sizeof(struct fileEntry)),
-				old_inode->i_sb->s_blocksize, &offset);
-		}
-		else
-		{
+						   (UDF_I_EFE(old_inode) ?
+						    sizeof(struct
+							   extendedFileEntry) :
+						    sizeof(struct fileEntry)),
+						   old_inode->i_sb->s_blocksize,
+						   &offset);
+		} else {
 			dir_bh = udf_bread(old_inode, 0, 0, &retval);
 			if (!dir_bh)
 				goto end_rename;
-			dir_fi = udf_get_fileident(dir_bh->b_data, old_inode->i_sb->s_blocksize, &offset);
+			dir_fi =
+			    udf_get_fileident(dir_bh->b_data,
+					      old_inode->i_sb->s_blocksize,
+					      &offset);
 		}
 		if (!dir_fi)
 			goto end_rename;
 		tloc = lelb_to_cpu(dir_fi->icb.extLocation);
 		if (udf_get_lb_pblock(old_inode->i_sb, tloc, 0)
-					!= old_dir->i_ino)
+		    != old_dir->i_ino)
 			goto end_rename;
 
 		retval = -EMLINK;
-		if (!new_inode && new_dir->i_nlink >= (256<<sizeof(new_dir->i_nlink))-1)
+		if (!new_inode
+		    && new_dir->i_nlink >=
+		    (256 << sizeof(new_dir->i_nlink)) - 1)
 			goto end_rename;
 	}
-	if (!nfi)
-	{
-		nfi = udf_add_entry(new_dir, new_dentry, &nfibh, &ncfi, &retval);
+	if (!nfi) {
+		nfi =
+		    udf_add_entry(new_dir, new_dentry, &nfibh, &ncfi, &retval);
 		if (!nfi)
 			goto end_rename;
 	}
@@ -1257,39 +1234,33 @@ static int udf_rename (struct inode * ol
 	ofi = udf_find_entry(old_dir, old_dentry, &ofibh, &ocfi);
 	udf_delete_entry(old_dir, ofi, &ofibh, &ocfi);
 
-	if (new_inode)
-	{
+	if (new_inode) {
 		new_inode->i_ctime = current_fs_time(new_inode->i_sb);
 		inode_dec_link_count(new_inode);
 	}
 	old_dir->i_ctime = old_dir->i_mtime = current_fs_time(old_dir->i_sb);
 	mark_inode_dirty(old_dir);
 
-	if (dir_fi)
-	{
+	if (dir_fi) {
 		dir_fi->icb.extLocation = cpu_to_lelb(UDF_I_LOCATION(new_dir));
 		udf_update_tag((char *)dir_fi, (sizeof(struct fileIdentDesc) +
-			le16_to_cpu(dir_fi->lengthOfImpUse) + 3) & ~3);
-		if (UDF_I_ALLOCTYPE(old_inode) == ICBTAG_FLAG_AD_IN_ICB)
-		{
+						le16_to_cpu(dir_fi->
+							    lengthOfImpUse) +
+						3) & ~3);
+		if (UDF_I_ALLOCTYPE(old_inode) == ICBTAG_FLAG_AD_IN_ICB) {
 			mark_inode_dirty(old_inode);
-		}
-		else
+		} else
 			mark_buffer_dirty_inode(dir_bh, old_inode);
 		inode_dec_link_count(old_dir);
-		if (new_inode)
-		{
+		if (new_inode) {
 			inode_dec_link_count(new_inode);
-		}
-		else
-		{
+		} else {
 			inc_nlink(new_dir);
 			mark_inode_dirty(new_dir);
 		}
 	}
 
-	if (ofi)
-	{
+	if (ofi) {
 		if (ofibh.sbh != ofibh.ebh)
 			brelse(ofibh.ebh);
 		brelse(ofibh.sbh);
@@ -1297,10 +1268,9 @@ static int udf_rename (struct inode * ol
 
 	retval = 0;
 
-end_rename:
+      end_rename:
 	brelse(dir_bh);
-	if (nfi)
-	{
+	if (nfi) {
 		if (nfibh.sbh != nfibh.ebh)
 			brelse(nfibh.ebh);
 		brelse(nfibh.sbh);
@@ -1310,13 +1280,13 @@ end_rename:
 }
 
 const struct inode_operations udf_dir_inode_operations = {
-	.lookup				= udf_lookup,
-	.create				= udf_create,
-	.link				= udf_link,
-	.unlink				= udf_unlink,
-	.symlink			= udf_symlink,
-	.mkdir				= udf_mkdir,
-	.rmdir				= udf_rmdir,
-	.mknod				= udf_mknod,
-	.rename				= udf_rename,
+	.lookup = udf_lookup,
+	.create = udf_create,
+	.link = udf_link,
+	.unlink = udf_unlink,
+	.symlink = udf_symlink,
+	.mkdir = udf_mkdir,
+	.rmdir = udf_rmdir,
+	.mknod = udf_mknod,
+	.rename = udf_rename,
 };
diff -puN fs/udf/osta_udf.h~udf-coding-style-conversion-lindent fs/udf/osta_udf.h
--- a/fs/udf/osta_udf.h~udf-coding-style-conversion-lindent
+++ a/fs/udf/osta_udf.h
@@ -65,153 +65,140 @@
 #define IS_DF_HARD_WRITE_PROTECT	0x01
 #define IS_DF_SOFT_WRITE_PROTECT	0x02
 
-struct UDFIdentSuffix
-{
-	__le16		UDFRevision;
-	uint8_t		OSClass;
-	uint8_t		OSIdentifier;
-	uint8_t		reserved[4];
-} __attribute__ ((packed));
-
-struct impIdentSuffix
-{
-	uint8_t		OSClass;
-	uint8_t		OSIdentifier;
-	uint8_t		reserved[6];
-} __attribute__ ((packed));
-
-struct appIdentSuffix
-{
-	uint8_t		impUse[8];
+struct UDFIdentSuffix {
+	__le16 UDFRevision;
+	uint8_t OSClass;
+	uint8_t OSIdentifier;
+	uint8_t reserved[4];
+} __attribute__ ((packed));
+
+struct impIdentSuffix {
+	uint8_t OSClass;
+	uint8_t OSIdentifier;
+	uint8_t reserved[6];
+} __attribute__ ((packed));
+
+struct appIdentSuffix {
+	uint8_t impUse[8];
 } __attribute__ ((packed));
 
 /* Logical Volume Integrity Descriptor (UDF 2.50 2.2.6) */
 /* Implementation Use (UDF 2.50 2.2.6.4) */
-struct logicalVolIntegrityDescImpUse
-{
-	regid		impIdent;
-	__le32		numFiles;
-	__le32		numDirs;
-	__le16		minUDFReadRev;
-	__le16		minUDFWriteRev;
-	__le16		maxUDFWriteRev;
-	uint8_t		impUse[0];
+struct logicalVolIntegrityDescImpUse {
+	regid impIdent;
+	__le32 numFiles;
+	__le32 numDirs;
+	__le16 minUDFReadRev;
+	__le16 minUDFWriteRev;
+	__le16 maxUDFWriteRev;
+	uint8_t impUse[0];
 } __attribute__ ((packed));
 
 /* Implementation Use Volume Descriptor (UDF 2.50 2.2.7) */
 /* Implementation Use (UDF 2.50 2.2.7.2) */
-struct impUseVolDescImpUse
-{
-	charspec	LVICharset;
-	dstring		logicalVolIdent[128];
-	dstring		LVInfo1[36];
-	dstring		LVInfo2[36];
-	dstring		LVInfo3[36];
-	regid		impIdent;
-	uint8_t		impUse[128];
-} __attribute__ ((packed));
-
-struct udfPartitionMap2
-{
-	uint8_t		partitionMapType;
-	uint8_t		partitionMapLength;
-	uint8_t		reserved1[2];
-	regid		partIdent;
-	__le16		volSeqNum;
-	__le16		partitionNum;
+struct impUseVolDescImpUse {
+	charspec LVICharset;
+	dstring logicalVolIdent[128];
+	dstring LVInfo1[36];
+	dstring LVInfo2[36];
+	dstring LVInfo3[36];
+	regid impIdent;
+	uint8_t impUse[128];
+} __attribute__ ((packed));
+
+struct udfPartitionMap2 {
+	uint8_t partitionMapType;
+	uint8_t partitionMapLength;
+	uint8_t reserved1[2];
+	regid partIdent;
+	__le16 volSeqNum;
+	__le16 partitionNum;
 } __attribute__ ((packed));
 
 /* Virtual Partition Map (UDF 2.50 2.2.8) */
-struct virtualPartitionMap
-{
-	uint8_t		partitionMapType;
-	uint8_t		partitionMapLength;
-	uint8_t		reserved1[2];
-	regid		partIdent;
-	__le16		volSeqNum;
-	__le16		partitionNum;
-	uint8_t		reserved2[24];
+struct virtualPartitionMap {
+	uint8_t partitionMapType;
+	uint8_t partitionMapLength;
+	uint8_t reserved1[2];
+	regid partIdent;
+	__le16 volSeqNum;
+	__le16 partitionNum;
+	uint8_t reserved2[24];
 } __attribute__ ((packed));
 
 /* Sparable Partition Map (UDF 2.50 2.2.9) */
-struct sparablePartitionMap
-{
-	uint8_t		partitionMapType;
-	uint8_t		partitionMapLength;
-	uint8_t		reserved1[2];
-	regid		partIdent;
-	__le16		volSeqNum;
-	__le16		partitionNum;
-	__le16		packetLength;
-	uint8_t		numSparingTables;
-	uint8_t		reserved2[1];
-	__le32		sizeSparingTable;
-	__le32		locSparingTable[4];
+struct sparablePartitionMap {
+	uint8_t partitionMapType;
+	uint8_t partitionMapLength;
+	uint8_t reserved1[2];
+	regid partIdent;
+	__le16 volSeqNum;
+	__le16 partitionNum;
+	__le16 packetLength;
+	uint8_t numSparingTables;
+	uint8_t reserved2[1];
+	__le32 sizeSparingTable;
+	__le32 locSparingTable[4];
 } __attribute__ ((packed));
 
 /* Metadata Partition Map (UDF 2.4.0 2.2.10) */
-struct metadataPartitionMap
-{
-	uint8_t		partitionMapType;
-	uint8_t		partitionMapLength;
-	uint8_t		reserved1[2];
-	regid		partIdent;
-	__le16		volSeqNum;
-	__le16		partitionNum;
-	__le32		metadataFileLoc;
-	__le32		metadataMirrorFileLoc;
-	__le32		metadataBitmapFileLoc;
-	__le32		allocUnitSize;
-	__le16		alignUnitSize;
-	uint8_t		flags;
-	uint8_t		reserved2[5];
+struct metadataPartitionMap {
+	uint8_t partitionMapType;
+	uint8_t partitionMapLength;
+	uint8_t reserved1[2];
+	regid partIdent;
+	__le16 volSeqNum;
+	__le16 partitionNum;
+	__le32 metadataFileLoc;
+	__le32 metadataMirrorFileLoc;
+	__le32 metadataBitmapFileLoc;
+	__le32 allocUnitSize;
+	__le16 alignUnitSize;
+	uint8_t flags;
+	uint8_t reserved2[5];
 } __attribute__ ((packed));
 
 /* Virtual Allocation Table (UDF 1.5 2.2.10) */
-struct virtualAllocationTable15
-{
-	__le32		VirtualSector[0];
-	regid		vatIdent;
-	__le32		previousVATICBLoc;
-} __attribute__ ((packed));  
+struct virtualAllocationTable15 {
+	__le32 VirtualSector[0];
+	regid vatIdent;
+	__le32 previousVATICBLoc;
+} __attribute__ ((packed));
 
 #define ICBTAG_FILE_TYPE_VAT15		0x00U
 
 /* Virtual Allocation Table (UDF 2.50 2.2.11) */
-struct virtualAllocationTable20
-{
-	__le16		lengthHeader;
-	__le16		lengthImpUse;
-	dstring		logicalVolIdent[128];
-	__le32		previousVATICBLoc;
-	__le32		numFiles;
-	__le32		numDirs;
-	__le16		minReadRevision;
-	__le16		minWriteRevision;
-	__le16		maxWriteRevision;
-	__le16		reserved;
-	uint8_t		impUse[0];
-	__le32		vatEntry[0];
+struct virtualAllocationTable20 {
+	__le16 lengthHeader;
+	__le16 lengthImpUse;
+	dstring logicalVolIdent[128];
+	__le32 previousVATICBLoc;
+	__le32 numFiles;
+	__le32 numDirs;
+	__le16 minReadRevision;
+	__le16 minWriteRevision;
+	__le16 maxWriteRevision;
+	__le16 reserved;
+	uint8_t impUse[0];
+	__le32 vatEntry[0];
 } __attribute__ ((packed));
 
 #define ICBTAG_FILE_TYPE_VAT20		0xF8U
 
 /* Sparing Table (UDF 2.50 2.2.12) */
-struct sparingEntry
-{
-	__le32		origLocation;
-	__le32		mappedLocation;
+struct sparingEntry {
+	__le32 origLocation;
+	__le32 mappedLocation;
 } __attribute__ ((packed));
 
-struct sparingTable
-{
-	tag 		descTag;
-	regid		sparingIdent;
-	__le16		reallocationTableLen;
-	__le16		reserved;
-	__le32		sequenceNum;
+struct sparingTable {
+	tag descTag;
+	regid sparingIdent;
+	__le16 reallocationTableLen;
+	__le16 reserved;
+	__le32 sequenceNum;
 	struct sparingEntry
-			mapEntry[0];
+	 mapEntry[0];
 } __attribute__ ((packed));
 
 /* Metadata File (and Metadata Mirror File) (UDF 2.50 2.2.13.1) */
@@ -220,10 +207,9 @@ struct sparingTable
 #define ICBTAG_FILE_TYPE_BITMAP		0xFC
 
 /* struct long_ad ICB - ADImpUse (UDF 2.50 2.2.4.3) */
-struct allocDescImpUse
-{
-	__le16		flags;
-	uint8_t		impUse[4];
+struct allocDescImpUse {
+	__le16 flags;
+	uint8_t impUse[4];
 } __attribute__ ((packed));
 
 #define AD_IU_EXT_ERASED		0x0001
@@ -233,27 +219,24 @@ struct allocDescImpUse
 
 /* Implementation Use Extended Attribute (UDF 2.50 3.3.4.5) */
 /* FreeEASpace (UDF 2.50 3.3.4.5.1.1) */
-struct freeEaSpace
-{
-	__le16		headerChecksum;
-	uint8_t		freeEASpace[0];
+struct freeEaSpace {
+	__le16 headerChecksum;
+	uint8_t freeEASpace[0];
 } __attribute__ ((packed));
 
 /* DVD Copyright Management Information (UDF 2.50 3.3.4.5.1.2) */
-struct DVDCopyrightImpUse 
-{
-	__le16		headerChecksum;
-	uint8_t		CGMSInfo;
-	uint8_t		dataType;
-	uint8_t		protectionSystemInfo[4];
+struct DVDCopyrightImpUse {
+	__le16 headerChecksum;
+	uint8_t CGMSInfo;
+	uint8_t dataType;
+	uint8_t protectionSystemInfo[4];
 } __attribute__ ((packed));
 
 /* Application Use Extended Attribute (UDF 2.50 3.3.4.6) */
 /* FreeAppEASpace (UDF 2.50 3.3.4.6.1) */
-struct freeAppEASpace
-{
-	__le16		headerChecksum;
-	uint8_t		freeEASpace[0];
+struct freeAppEASpace {
+	__le16 headerChecksum;
+	uint8_t freeEASpace[0];
 } __attribute__ ((packed));
 
 /* UDF Defined System Stream (UDF 2.50 3.3.7) */
@@ -293,4 +276,4 @@ struct freeAppEASpace
 #define UDF_OS_ID_BEOS			0x00U
 #define UDF_OS_ID_WINCE			0x00U
 
-#endif /* _OSTA_UDF_H */
+#endif				/* _OSTA_UDF_H */
diff -puN fs/udf/partition.c~udf-coding-style-conversion-lindent fs/udf/partition.c
--- a/fs/udf/partition.c~udf-coding-style-conversion-lindent
+++ a/fs/udf/partition.c
@@ -28,106 +28,120 @@
 #include <linux/slab.h>
 #include <linux/buffer_head.h>
 
-inline uint32_t udf_get_pblock(struct super_block *sb, uint32_t block, uint16_t partition, uint32_t offset)
+inline uint32_t udf_get_pblock(struct super_block *sb, uint32_t block,
+			       uint16_t partition, uint32_t offset)
 {
-	if (partition >= UDF_SB_NUMPARTS(sb))
-	{
-		udf_debug("block=%d, partition=%d, offset=%d: invalid partition\n",
-			block, partition, offset);
+	if (partition >= UDF_SB_NUMPARTS(sb)) {
+		udf_debug
+		    ("block=%d, partition=%d, offset=%d: invalid partition\n",
+		     block, partition, offset);
 		return 0xFFFFFFFF;
 	}
 	if (UDF_SB_PARTFUNC(sb, partition))
-		return UDF_SB_PARTFUNC(sb, partition)(sb, block, partition, offset);
+		return UDF_SB_PARTFUNC(sb, partition) (sb, block, partition,
+						       offset);
 	else
 		return UDF_SB_PARTROOT(sb, partition) + block + offset;
 }
 
-uint32_t udf_get_pblock_virt15(struct super_block *sb, uint32_t block, uint16_t partition, uint32_t offset)
+uint32_t udf_get_pblock_virt15(struct super_block * sb, uint32_t block,
+			       uint16_t partition, uint32_t offset)
 {
 	struct buffer_head *bh = NULL;
 	uint32_t newblock;
 	uint32_t index;
 	uint32_t loc;
 
-	index = (sb->s_blocksize - UDF_SB_TYPEVIRT(sb,partition).s_start_offset) / sizeof(uint32_t);
-
-	if (block > UDF_SB_TYPEVIRT(sb,partition).s_num_entries)
-	{
-		udf_debug("Trying to access block beyond end of VAT (%d max %d)\n",
-			block, UDF_SB_TYPEVIRT(sb,partition).s_num_entries);
+	index =
+	    (sb->s_blocksize -
+	     UDF_SB_TYPEVIRT(sb, partition).s_start_offset) / sizeof(uint32_t);
+
+	if (block > UDF_SB_TYPEVIRT(sb, partition).s_num_entries) {
+		udf_debug
+		    ("Trying to access block beyond end of VAT (%d max %d)\n",
+		     block, UDF_SB_TYPEVIRT(sb, partition).s_num_entries);
 		return 0xFFFFFFFF;
 	}
 
-	if (block >= index)
-	{
+	if (block >= index) {
 		block -= index;
 		newblock = 1 + (block / (sb->s_blocksize / sizeof(uint32_t)));
 		index = block % (sb->s_blocksize / sizeof(uint32_t));
-	}
-	else
-	{
+	} else {
 		newblock = 0;
-		index = UDF_SB_TYPEVIRT(sb,partition).s_start_offset / sizeof(uint32_t) + block;
+		index =
+		    UDF_SB_TYPEVIRT(sb,
+				    partition).s_start_offset /
+		    sizeof(uint32_t) + block;
 	}
 
 	loc = udf_block_map(UDF_SB_VAT(sb), newblock);
 
-	if (!(bh = sb_bread(sb, loc)))
-	{
+	if (!(bh = sb_bread(sb, loc))) {
 		udf_debug("get_pblock(UDF_VIRTUAL_MAP:%p,%d,%d) VAT: %d[%d]\n",
-			sb, block, partition, loc, index);
+			  sb, block, partition, loc, index);
 		return 0xFFFFFFFF;
 	}
 
-	loc = le32_to_cpu(((__le32 *)bh->b_data)[index]);
+	loc = le32_to_cpu(((__le32 *) bh->b_data)[index]);
 
 	brelse(bh);
 
-	if (UDF_I_LOCATION(UDF_SB_VAT(sb)).partitionReferenceNum == partition)
-	{
+	if (UDF_I_LOCATION(UDF_SB_VAT(sb)).partitionReferenceNum == partition) {
 		udf_debug("recursive call to udf_get_pblock!\n");
 		return 0xFFFFFFFF;
 	}
 
-	return udf_get_pblock(sb, loc, UDF_I_LOCATION(UDF_SB_VAT(sb)).partitionReferenceNum, offset);
+	return udf_get_pblock(sb, loc,
+			      UDF_I_LOCATION(UDF_SB_VAT(sb)).
+			      partitionReferenceNum, offset);
 }
 
-inline uint32_t udf_get_pblock_virt20(struct super_block *sb, uint32_t block, uint16_t partition, uint32_t offset)
+inline uint32_t udf_get_pblock_virt20(struct super_block * sb, uint32_t block,
+				      uint16_t partition, uint32_t offset)
 {
 	return udf_get_pblock_virt15(sb, block, partition, offset);
 }
 
-uint32_t udf_get_pblock_spar15(struct super_block *sb, uint32_t block, uint16_t partition, uint32_t offset)
+uint32_t udf_get_pblock_spar15(struct super_block * sb, uint32_t block,
+			       uint16_t partition, uint32_t offset)
 {
 	int i;
 	struct sparingTable *st = NULL;
-	uint32_t packet = (block + offset) & ~(UDF_SB_TYPESPAR(sb,partition).s_packet_len - 1);
-
-	for (i=0; i<4; i++)
-	{
-		if (UDF_SB_TYPESPAR(sb,partition).s_spar_map[i] != NULL)
-		{
-			st = (struct sparingTable *)UDF_SB_TYPESPAR(sb,partition).s_spar_map[i]->b_data;
+	uint32_t packet =
+	    (block + offset) & ~(UDF_SB_TYPESPAR(sb, partition).s_packet_len -
+				 1);
+
+	for (i = 0; i < 4; i++) {
+		if (UDF_SB_TYPESPAR(sb, partition).s_spar_map[i] != NULL) {
+			st = (struct sparingTable *)UDF_SB_TYPESPAR(sb,
+								    partition).
+			    s_spar_map[i]->b_data;
 			break;
 		}
 	}
 
-	if (st)
-	{
-		for (i=0; i<le16_to_cpu(st->reallocationTableLen); i++)
-		{
-			if (le32_to_cpu(st->mapEntry[i].origLocation) >= 0xFFFFFFF0)
+	if (st) {
+		for (i = 0; i < le16_to_cpu(st->reallocationTableLen); i++) {
+			if (le32_to_cpu(st->mapEntry[i].origLocation) >=
+			    0xFFFFFFF0)
 				break;
-			else if (le32_to_cpu(st->mapEntry[i].origLocation) == packet)
-			{
-				return le32_to_cpu(st->mapEntry[i].mappedLocation) +
-					((block + offset) & (UDF_SB_TYPESPAR(sb,partition).s_packet_len - 1));
-			}
-			else if (le32_to_cpu(st->mapEntry[i].origLocation) > packet)
+			else if (le32_to_cpu(st->mapEntry[i].origLocation) ==
+				 packet) {
+				return le32_to_cpu(st->mapEntry[i].
+						   mappedLocation) + ((block +
+								       offset) &
+								      (UDF_SB_TYPESPAR
+								       (sb,
+									partition).
+								       s_packet_len
+								       - 1));
+			} else if (le32_to_cpu(st->mapEntry[i].origLocation) >
+				   packet)
 				break;
 		}
 	}
-	return UDF_SB_PARTROOT(sb,partition) + block + offset;
+	return UDF_SB_PARTROOT(sb, partition) + block + offset;
 }
 
 int udf_relocate_blocks(struct super_block *sb, long old_block, long *new_block)
@@ -138,19 +152,21 @@ int udf_relocate_blocks(struct super_blo
 	uint32_t packet;
 	int i, j, k, l;
 
-	for (i=0; i<UDF_SB_NUMPARTS(sb); i++)
-	{
-		if (old_block > UDF_SB_PARTROOT(sb,i) &&
-		    old_block < UDF_SB_PARTROOT(sb,i) + UDF_SB_PARTLEN(sb,i))
+	for (i = 0; i < UDF_SB_NUMPARTS(sb); i++) {
+		if (old_block > UDF_SB_PARTROOT(sb, i) &&
+		    old_block < UDF_SB_PARTROOT(sb, i) + UDF_SB_PARTLEN(sb, i))
 		{
-			sdata = &UDF_SB_TYPESPAR(sb,i);
-			packet = (old_block - UDF_SB_PARTROOT(sb,i)) & ~(sdata->s_packet_len - 1);
-
-			for (j=0; j<4; j++)
-			{
-				if (UDF_SB_TYPESPAR(sb,i).s_spar_map[j] != NULL)
-				{
-					st = (struct sparingTable *)sdata->s_spar_map[j]->b_data;
+			sdata = &UDF_SB_TYPESPAR(sb, i);
+			packet =
+			    (old_block -
+			     UDF_SB_PARTROOT(sb,
+					     i)) & ~(sdata->s_packet_len - 1);
+
+			for (j = 0; j < 4; j++) {
+				if (UDF_SB_TYPESPAR(sb, i).s_spar_map[j] !=
+				    NULL) {
+					st = (struct sparingTable *)sdata->
+					    s_spar_map[j]->b_data;
 					break;
 				}
 			}
@@ -158,60 +174,123 @@ int udf_relocate_blocks(struct super_blo
 			if (!st)
 				return 1;
 
-			for (k=0; k<le16_to_cpu(st->reallocationTableLen); k++)
-			{
-				if (le32_to_cpu(st->mapEntry[k].origLocation) == 0xFFFFFFFF)
-				{
-					for (; j<4; j++)
-					{
-						if (sdata->s_spar_map[j])
-						{
-							st = (struct sparingTable *)sdata->s_spar_map[j]->b_data;
-							st->mapEntry[k].origLocation = cpu_to_le32(packet);
-							udf_update_tag((char *)st, sizeof(struct sparingTable) + le16_to_cpu(st->reallocationTableLen) * sizeof(struct sparingEntry));
-							mark_buffer_dirty(sdata->s_spar_map[j]);
+			for (k = 0; k < le16_to_cpu(st->reallocationTableLen);
+			     k++) {
+				if (le32_to_cpu(st->mapEntry[k].origLocation) ==
+				    0xFFFFFFFF) {
+					for (; j < 4; j++) {
+						if (sdata->s_spar_map[j]) {
+							st = (struct
+							      sparingTable *)
+							    sdata->
+							    s_spar_map[j]->
+							    b_data;
+							st->mapEntry[k].
+							    origLocation =
+							    cpu_to_le32(packet);
+							udf_update_tag((char *)
+								       st,
+								       sizeof
+								       (struct
+									sparingTable)
+								       +
+								       le16_to_cpu
+								       (st->
+									reallocationTableLen)
+								       *
+								       sizeof
+								       (struct
+									sparingEntry));
+							mark_buffer_dirty
+							    (sdata->
+							     s_spar_map[j]);
 						}
 					}
-					*new_block = le32_to_cpu(st->mapEntry[k].mappedLocation) +
-						((old_block - UDF_SB_PARTROOT(sb,i)) & (sdata->s_packet_len - 1));
+					*new_block =
+					    le32_to_cpu(st->mapEntry[k].
+							mappedLocation) +
+					    ((old_block -
+					      UDF_SB_PARTROOT(sb,
+							      i)) & (sdata->
+								     s_packet_len
+								     - 1));
 					return 0;
-				}
-				else if (le32_to_cpu(st->mapEntry[k].origLocation) == packet)
-				{
-					*new_block = le32_to_cpu(st->mapEntry[k].mappedLocation) +
-						((old_block - UDF_SB_PARTROOT(sb,i)) & (sdata->s_packet_len - 1));
+				} else
+				    if (le32_to_cpu
+					(st->mapEntry[k].origLocation) ==
+					packet) {
+					*new_block =
+					    le32_to_cpu(st->mapEntry[k].
+							mappedLocation) +
+					    ((old_block -
+					      UDF_SB_PARTROOT(sb,
+							      i)) & (sdata->
+								     s_packet_len
+								     - 1));
 					return 0;
-				}
-				else if (le32_to_cpu(st->mapEntry[k].origLocation) > packet)
+				} else
+				    if (le32_to_cpu
+					(st->mapEntry[k].origLocation) > packet)
 					break;
 			}
-			for (l=k; l<le16_to_cpu(st->reallocationTableLen); l++)
-			{
-				if (le32_to_cpu(st->mapEntry[l].origLocation) == 0xFFFFFFFF)
-				{
-					for (; j<4; j++)
-					{
-						if (sdata->s_spar_map[j])
-						{
-							st = (struct sparingTable *)sdata->s_spar_map[j]->b_data;
-							mapEntry = st->mapEntry[l];
-							mapEntry.origLocation = cpu_to_le32(packet);
-							memmove(&st->mapEntry[k+1], &st->mapEntry[k], (l-k)*sizeof(struct sparingEntry));
-							st->mapEntry[k] = mapEntry;
-							udf_update_tag((char *)st, sizeof(struct sparingTable) + le16_to_cpu(st->reallocationTableLen) * sizeof(struct sparingEntry));
-							mark_buffer_dirty(sdata->s_spar_map[j]);
+			for (l = k; l < le16_to_cpu(st->reallocationTableLen);
+			     l++) {
+				if (le32_to_cpu(st->mapEntry[l].origLocation) ==
+				    0xFFFFFFFF) {
+					for (; j < 4; j++) {
+						if (sdata->s_spar_map[j]) {
+							st = (struct
+							      sparingTable *)
+							    sdata->
+							    s_spar_map[j]->
+							    b_data;
+							mapEntry =
+							    st->mapEntry[l];
+							mapEntry.origLocation =
+							    cpu_to_le32(packet);
+							memmove(&st->
+								mapEntry[k + 1],
+								&st->
+								mapEntry[k],
+								(l -
+								 k) *
+								sizeof(struct
+								       sparingEntry));
+							st->mapEntry[k] =
+							    mapEntry;
+							udf_update_tag((char *)
+								       st,
+								       sizeof
+								       (struct
+									sparingTable)
+								       +
+								       le16_to_cpu
+								       (st->
+									reallocationTableLen)
+								       *
+								       sizeof
+								       (struct
+									sparingEntry));
+							mark_buffer_dirty
+							    (sdata->
+							     s_spar_map[j]);
 						}
 					}
-					*new_block = le32_to_cpu(st->mapEntry[k].mappedLocation) +
-						((old_block - UDF_SB_PARTROOT(sb,i)) & (sdata->s_packet_len - 1));
+					*new_block =
+					    le32_to_cpu(st->mapEntry[k].
+							mappedLocation) +
+					    ((old_block -
+					      UDF_SB_PARTROOT(sb,
+							      i)) & (sdata->
+								     s_packet_len
+								     - 1));
 					return 0;
 				}
 			}
 			return 1;
 		}
 	}
-	if (i == UDF_SB_NUMPARTS(sb))
-	{
+	if (i == UDF_SB_NUMPARTS(sb)) {
 		/* outside of partitions */
 		/* for now, fail =) */
 		return 1;
diff -puN fs/udf/super.c~udf-coding-style-conversion-lindent fs/udf/super.c
--- a/fs/udf/super.c~udf-coding-style-conversion-lindent
+++ a/fs/udf/super.c
@@ -38,7 +38,7 @@
  *  12/20/98      find the free space bitmap (if it exists)
  */
 
-#include "udfdecl.h"    
+#include "udfdecl.h"
 
 #include <linux/blkdev.h>
 #include <linux/slab.h>
@@ -80,12 +80,15 @@ static int udf_remount_fs(struct super_b
 static int udf_check_valid(struct super_block *, int, int);
 static int udf_vrs(struct super_block *sb, int silent);
 static int udf_load_partition(struct super_block *, kernel_lb_addr *);
-static int udf_load_logicalvol(struct super_block *, struct buffer_head *, kernel_lb_addr *);
+static int udf_load_logicalvol(struct super_block *, struct buffer_head *,
+			       kernel_lb_addr *);
 static void udf_load_logicalvolint(struct super_block *, kernel_extent_ad);
 static void udf_find_anchor(struct super_block *);
-static int udf_find_fileset(struct super_block *, kernel_lb_addr *, kernel_lb_addr *);
+static int udf_find_fileset(struct super_block *, kernel_lb_addr *,
+			    kernel_lb_addr *);
 static void udf_load_pvoldesc(struct super_block *, struct buffer_head *);
-static void udf_load_fileset(struct super_block *, struct buffer_head *, kernel_lb_addr *);
+static void udf_load_fileset(struct super_block *, struct buffer_head *,
+			     kernel_lb_addr *);
 static void udf_load_partdesc(struct super_block *, struct buffer_head *);
 static void udf_open_lvid(struct super_block *);
 static void udf_close_lvid(struct super_block *);
@@ -94,25 +97,27 @@ static int udf_statfs(struct dentry *, s
 
 /* UDF filesystem type */
 static int udf_get_sb(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
+		      int flags, const char *dev_name, void *data,
+		      struct vfsmount *mnt)
 {
 	return get_sb_bdev(fs_type, flags, dev_name, data, udf_fill_super, mnt);
 }
 
 static struct file_system_type udf_fstype = {
-	.owner		= THIS_MODULE,
-	.name		= "udf",
-	.get_sb		= udf_get_sb,
-	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.owner = THIS_MODULE,
+	.name = "udf",
+	.get_sb = udf_get_sb,
+	.kill_sb = kill_block_super,
+	.fs_flags = FS_REQUIRES_DEV,
 };
 
-static struct kmem_cache * udf_inode_cachep;
+static struct kmem_cache *udf_inode_cachep;
 
 static struct inode *udf_alloc_inode(struct super_block *sb)
 {
 	struct udf_inode_info *ei;
-	ei = (struct udf_inode_info *)kmem_cache_alloc(udf_inode_cachep, GFP_KERNEL);
+	ei = (struct udf_inode_info *)kmem_cache_alloc(udf_inode_cachep,
+						       GFP_KERNEL);
 	if (!ei)
 		return NULL;
 
@@ -130,9 +135,9 @@ static void udf_destroy_inode(struct ino
 	kmem_cache_free(udf_inode_cachep, UDF_I(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
 {
-	struct udf_inode_info *ei = (struct udf_inode_info *) foo;
+	struct udf_inode_info *ei = (struct udf_inode_info *)foo;
 
 	ei->i_ext.i_data = NULL;
 	inode_init_once(&ei->vfs_inode);
@@ -142,8 +147,8 @@ static int init_inodecache(void)
 {
 	udf_inode_cachep = kmem_cache_create("udf_inode_cache",
 					     sizeof(struct udf_inode_info),
-					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+					     0, (SLAB_RECLAIM_ACCOUNT |
+						 SLAB_MEM_SPREAD),
 					     init_once, NULL);
 	if (udf_inode_cachep == NULL)
 		return -ENOMEM;
@@ -157,19 +162,18 @@ static void destroy_inodecache(void)
 
 /* Superblock operations */
 static const struct super_operations udf_sb_ops = {
-	.alloc_inode		= udf_alloc_inode,
-	.destroy_inode		= udf_destroy_inode,
-	.write_inode		= udf_write_inode,
-	.delete_inode		= udf_delete_inode,
-	.clear_inode		= udf_clear_inode,
-	.put_super		= udf_put_super,
-	.write_super		= udf_write_super,
-	.statfs			= udf_statfs,
-	.remount_fs		= udf_remount_fs,
+	.alloc_inode = udf_alloc_inode,
+	.destroy_inode = udf_destroy_inode,
+	.write_inode = udf_write_inode,
+	.delete_inode = udf_delete_inode,
+	.clear_inode = udf_clear_inode,
+	.put_super = udf_put_super,
+	.write_super = udf_write_super,
+	.statfs = udf_statfs,
+	.remount_fs = udf_remount_fs,
 };
 
-struct udf_options
-{
+struct udf_options {
 	unsigned char novrs;
 	unsigned int blocksize;
 	unsigned int session;
@@ -196,9 +200,9 @@ static int __init init_udf_fs(void)
 	if (err)
 		goto out;
 	return 0;
-out:
+      out:
 	destroy_inodecache();
-out1:
+      out1:
 	return err;
 }
 
@@ -209,7 +213,7 @@ static void __exit exit_udf_fs(void)
 }
 
 module_init(init_udf_fs)
-module_exit(exit_udf_fs)
+    module_exit(exit_udf_fs)
 
 /*
  * udf_parse_options
@@ -264,7 +268,6 @@ module_exit(exit_udf_fs)
  *	July 1, 1997 - Andrew E. Mileski
  *	Written, tested, and released.
  */
-
 enum {
 	Opt_novrs, Opt_nostrict, Opt_bs, Opt_unhide, Opt_undelete,
 	Opt_noadinicb, Opt_adinicb, Opt_shortad, Opt_longad,
@@ -303,8 +306,7 @@ static match_table_t tokens = {
 	{Opt_err, NULL}
 };
 
-static int
-udf_parse_options(char *options, struct udf_options *uopt)
+static int udf_parse_options(char *options, struct udf_options *uopt)
 {
 	char *p;
 	int option;
@@ -323,126 +325,123 @@ udf_parse_options(char *options, struct 
 	if (!options)
 		return 1;
 
-	while ((p = strsep(&options, ",")) != NULL)
-	{
+	while ((p = strsep(&options, ",")) != NULL) {
 		substring_t args[MAX_OPT_ARGS];
 		int token;
 		if (!*p)
 			continue;
 
 		token = match_token(p, tokens, args);
-		switch (token)
-		{
-			case Opt_novrs:
-				uopt->novrs = 1;
-			case Opt_bs:
-				if (match_int(&args[0], &option))
-					return 0;
-				uopt->blocksize = option;
-				break;
-			case Opt_unhide:
-				uopt->flags |= (1 << UDF_FLAG_UNHIDE);
-				break;
-			case Opt_undelete:
-				uopt->flags |= (1 << UDF_FLAG_UNDELETE);
-				break;
-			case Opt_noadinicb:
-				uopt->flags &= ~(1 << UDF_FLAG_USE_AD_IN_ICB);
-				break;
-			case Opt_adinicb:
-				uopt->flags |= (1 << UDF_FLAG_USE_AD_IN_ICB);
-				break;
-			case Opt_shortad:
-				uopt->flags |= (1 << UDF_FLAG_USE_SHORT_AD);
-				break;
-			case Opt_longad:
-				uopt->flags &= ~(1 << UDF_FLAG_USE_SHORT_AD);
-				break;
-			case Opt_gid:
-				if (match_int(args, &option))
-					return 0;
-				uopt->gid = option;
-				break;
-			case Opt_uid:
-				if (match_int(args, &option))
-					return 0;
-				uopt->uid = option;
-				break;
-			case Opt_umask:
-				if (match_octal(args, &option))
-					return 0;
-				uopt->umask = option;
-				break;
-			case Opt_nostrict:
-				uopt->flags &= ~(1 << UDF_FLAG_STRICT);
-				break;
-			case Opt_session:
-				if (match_int(args, &option))
-					return 0;
-				uopt->session = option;
-				break;
-			case Opt_lastblock:
-				if (match_int(args, &option))
-					return 0;
-				uopt->lastblock = option;
-				break;
-			case Opt_anchor:
-				if (match_int(args, &option))
-					return 0;
-				uopt->anchor = option;
-				break;
-			case Opt_volume:
-				if (match_int(args, &option))
-					return 0;
-				uopt->volume = option;
-				break;
-			case Opt_partition:
-				if (match_int(args, &option))
-					return 0;
-				uopt->partition = option;
-				break;
-			case Opt_fileset:
-				if (match_int(args, &option))
-					return 0;
-				uopt->fileset = option;
-				break;
-			case Opt_rootdir:
-				if (match_int(args, &option))
-					return 0;
-				uopt->rootdir = option;
-				break;
-			case Opt_utf8:
-				uopt->flags |= (1 << UDF_FLAG_UTF8);
-				break;
+		switch (token) {
+		case Opt_novrs:
+			uopt->novrs = 1;
+		case Opt_bs:
+			if (match_int(&args[0], &option))
+				return 0;
+			uopt->blocksize = option;
+			break;
+		case Opt_unhide:
+			uopt->flags |= (1 << UDF_FLAG_UNHIDE);
+			break;
+		case Opt_undelete:
+			uopt->flags |= (1 << UDF_FLAG_UNDELETE);
+			break;
+		case Opt_noadinicb:
+			uopt->flags &= ~(1 << UDF_FLAG_USE_AD_IN_ICB);
+			break;
+		case Opt_adinicb:
+			uopt->flags |= (1 << UDF_FLAG_USE_AD_IN_ICB);
+			break;
+		case Opt_shortad:
+			uopt->flags |= (1 << UDF_FLAG_USE_SHORT_AD);
+			break;
+		case Opt_longad:
+			uopt->flags &= ~(1 << UDF_FLAG_USE_SHORT_AD);
+			break;
+		case Opt_gid:
+			if (match_int(args, &option))
+				return 0;
+			uopt->gid = option;
+			break;
+		case Opt_uid:
+			if (match_int(args, &option))
+				return 0;
+			uopt->uid = option;
+			break;
+		case Opt_umask:
+			if (match_octal(args, &option))
+				return 0;
+			uopt->umask = option;
+			break;
+		case Opt_nostrict:
+			uopt->flags &= ~(1 << UDF_FLAG_STRICT);
+			break;
+		case Opt_session:
+			if (match_int(args, &option))
+				return 0;
+			uopt->session = option;
+			break;
+		case Opt_lastblock:
+			if (match_int(args, &option))
+				return 0;
+			uopt->lastblock = option;
+			break;
+		case Opt_anchor:
+			if (match_int(args, &option))
+				return 0;
+			uopt->anchor = option;
+			break;
+		case Opt_volume:
+			if (match_int(args, &option))
+				return 0;
+			uopt->volume = option;
+			break;
+		case Opt_partition:
+			if (match_int(args, &option))
+				return 0;
+			uopt->partition = option;
+			break;
+		case Opt_fileset:
+			if (match_int(args, &option))
+				return 0;
+			uopt->fileset = option;
+			break;
+		case Opt_rootdir:
+			if (match_int(args, &option))
+				return 0;
+			uopt->rootdir = option;
+			break;
+		case Opt_utf8:
+			uopt->flags |= (1 << UDF_FLAG_UTF8);
+			break;
 #ifdef CONFIG_UDF_NLS
-			case Opt_iocharset:
-				uopt->nls_map = load_nls(args[0].from);
-				uopt->flags |= (1 << UDF_FLAG_NLS_MAP);
-				break;
+		case Opt_iocharset:
+			uopt->nls_map = load_nls(args[0].from);
+			uopt->flags |= (1 << UDF_FLAG_NLS_MAP);
+			break;
 #endif
-			case Opt_uignore:
-				uopt->flags |= (1 << UDF_FLAG_UID_IGNORE);
-				break;
-			case Opt_uforget:
-				uopt->flags |= (1 << UDF_FLAG_UID_FORGET);
-				break;
-			case Opt_gignore:
-			    uopt->flags |= (1 << UDF_FLAG_GID_IGNORE);
-				break;
-			case Opt_gforget:
-			    uopt->flags |= (1 << UDF_FLAG_GID_FORGET);
-				break;
-			default:
-				printk(KERN_ERR "udf: bad mount option \"%s\" "
-						"or missing value\n", p);
+		case Opt_uignore:
+			uopt->flags |= (1 << UDF_FLAG_UID_IGNORE);
+			break;
+		case Opt_uforget:
+			uopt->flags |= (1 << UDF_FLAG_UID_FORGET);
+			break;
+		case Opt_gignore:
+			uopt->flags |= (1 << UDF_FLAG_GID_IGNORE);
+			break;
+		case Opt_gforget:
+			uopt->flags |= (1 << UDF_FLAG_GID_FORGET);
+			break;
+		default:
+			printk(KERN_ERR "udf: bad mount option \"%s\" "
+			       "or missing value\n", p);
 			return 0;
 		}
 	}
 	return 1;
 }
 
-void
-udf_write_super(struct super_block *sb)
+void udf_write_super(struct super_block *sb)
 {
 	lock_kernel();
 	if (!(sb->s_flags & MS_RDONLY))
@@ -451,22 +450,21 @@ udf_write_super(struct super_block *sb)
 	unlock_kernel();
 }
 
-static int
-udf_remount_fs(struct super_block *sb, int *flags, char *options)
+static int udf_remount_fs(struct super_block *sb, int *flags, char *options)
 {
 	struct udf_options uopt;
 
-	uopt.flags = UDF_SB(sb)->s_flags ;
-	uopt.uid   = UDF_SB(sb)->s_uid ;
-	uopt.gid   = UDF_SB(sb)->s_gid ;
-	uopt.umask = UDF_SB(sb)->s_umask ;
+	uopt.flags = UDF_SB(sb)->s_flags;
+	uopt.uid = UDF_SB(sb)->s_uid;
+	uopt.gid = UDF_SB(sb)->s_gid;
+	uopt.umask = UDF_SB(sb)->s_umask;
 
-	if ( !udf_parse_options(options, &uopt) )
+	if (!udf_parse_options(options, &uopt))
 		return -EINVAL;
 
 	UDF_SB(sb)->s_flags = uopt.flags;
-	UDF_SB(sb)->s_uid   = uopt.uid;
-	UDF_SB(sb)->s_gid   = uopt.gid;
+	UDF_SB(sb)->s_uid = uopt.uid;
+	UDF_SB(sb)->s_gid = uopt.gid;
 	UDF_SB(sb)->s_umask = uopt.umask;
 
 	if (UDF_SB_LVIDBH(sb)) {
@@ -512,8 +510,7 @@ udf_remount_fs(struct super_block *sb, i
  *	July 1, 1997 - Andrew E. Mileski
  *	Written, tested, and released.
  */
-static  int
-udf_set_blocksize(struct super_block *sb, int bsize)
+static int udf_set_blocksize(struct super_block *sb, int bsize)
 {
 	if (!sb_min_blocksize(sb, bsize)) {
 		udf_debug("Bad block size (%d)\n", bsize);
@@ -523,16 +520,15 @@ udf_set_blocksize(struct super_block *sb
 	return sb->s_blocksize;
 }
 
-static int
-udf_vrs(struct super_block *sb, int silent)
+static int udf_vrs(struct super_block *sb, int silent)
 {
 	struct volStructDesc *vsd = NULL;
 	int sector = 32768;
 	int sectorsize;
 	struct buffer_head *bh = NULL;
-	int iso9660=0;
-	int nsr02=0;
-	int nsr03=0;
+	int iso9660 = 0;
+	int nsr02 = 0;
+	int nsr03 = 0;
 
 	/* Block size must be a multiple of 512 */
 	if (sb->s_blocksize & 511)
@@ -546,10 +542,9 @@ udf_vrs(struct super_block *sb, int sile
 	sector += (UDF_SB_SESSION(sb) << sb->s_blocksize_bits);
 
 	udf_debug("Starting at sector %u (%ld byte sectors)\n",
-		(sector >> sb->s_blocksize_bits), sb->s_blocksize);
+		  (sector >> sb->s_blocksize_bits), sb->s_blocksize);
 	/* Process the sequence (if applicable) */
-	for (;!nsr02 && !nsr03; sector += sectorsize)
-	{
+	for (; !nsr02 && !nsr03; sector += sectorsize) {
 		/* Read a block */
 		bh = udf_tread(sb, sector >> sb->s_blocksize_bits);
 		if (!bh)
@@ -557,52 +552,56 @@ udf_vrs(struct super_block *sb, int sile
 
 		/* Look for ISO  descriptors */
 		vsd = (struct volStructDesc *)(bh->b_data +
-			(sector & (sb->s_blocksize - 1)));
+					       (sector &
+						(sb->s_blocksize - 1)));
 
-		if (vsd->stdIdent[0] == 0)
-		{
+		if (vsd->stdIdent[0] == 0) {
 			brelse(bh);
 			break;
-		}
-		else if (!strncmp(vsd->stdIdent, VSD_STD_ID_CD001, VSD_STD_ID_LEN))
-		{
+		} else
+		    if (!strncmp
+			(vsd->stdIdent, VSD_STD_ID_CD001, VSD_STD_ID_LEN)) {
 			iso9660 = sector;
-			switch (vsd->structType)
-			{
-				case 0: 
-					udf_debug("ISO9660 Boot Record found\n");
-					break;
-				case 1: 
-					udf_debug("ISO9660 Primary Volume Descriptor found\n");
-					break;
-				case 2: 
-					udf_debug("ISO9660 Supplementary Volume Descriptor found\n");
-					break;
-				case 3: 
-					udf_debug("ISO9660 Volume Partition Descriptor found\n");
-					break;
-				case 255: 
-					udf_debug("ISO9660 Volume Descriptor Set Terminator found\n");
-					break;
-				default: 
-					udf_debug("ISO9660 VRS (%u) found\n", vsd->structType);
-					break;
+			switch (vsd->structType) {
+			case 0:
+				udf_debug("ISO9660 Boot Record found\n");
+				break;
+			case 1:
+				udf_debug
+				    ("ISO9660 Primary Volume Descriptor found\n");
+				break;
+			case 2:
+				udf_debug
+				    ("ISO9660 Supplementary Volume Descriptor found\n");
+				break;
+			case 3:
+				udf_debug
+				    ("ISO9660 Volume Partition Descriptor found\n");
+				break;
+			case 255:
+				udf_debug
+				    ("ISO9660 Volume Descriptor Set Terminator found\n");
+				break;
+			default:
+				udf_debug("ISO9660 VRS (%u) found\n",
+					  vsd->structType);
+				break;
 			}
-		}
-		else if (!strncmp(vsd->stdIdent, VSD_STD_ID_BEA01, VSD_STD_ID_LEN))
-		{
-		}
-		else if (!strncmp(vsd->stdIdent, VSD_STD_ID_TEA01, VSD_STD_ID_LEN))
-		{
+		} else
+		    if (!strncmp
+			(vsd->stdIdent, VSD_STD_ID_BEA01, VSD_STD_ID_LEN)) {
+		} else
+		    if (!strncmp
+			(vsd->stdIdent, VSD_STD_ID_TEA01, VSD_STD_ID_LEN)) {
 			brelse(bh);
 			break;
-		}
-		else if (!strncmp(vsd->stdIdent, VSD_STD_ID_NSR02, VSD_STD_ID_LEN))
-		{
+		} else
+		    if (!strncmp
+			(vsd->stdIdent, VSD_STD_ID_NSR02, VSD_STD_ID_LEN)) {
 			nsr02 = sector;
-		}
-		else if (!strncmp(vsd->stdIdent, VSD_STD_ID_NSR03, VSD_STD_ID_LEN))
-		{
+		} else
+		    if (!strncmp
+			(vsd->stdIdent, VSD_STD_ID_NSR03, VSD_STD_ID_LEN)) {
 			nsr03 = sector;
 		}
 		brelse(bh);
@@ -635,8 +634,7 @@ udf_vrs(struct super_block *sb, int sile
  *	July 1, 1997 - Andrew E. Mileski
  *	Written, tested, and released.
  */
-static void
-udf_find_anchor(struct super_block *sb)
+static void udf_find_anchor(struct super_block *sb)
 {
 	int lastblock = UDF_SB_LASTBLOCK(sb);
 	struct buffer_head *bh = NULL;
@@ -644,13 +642,13 @@ udf_find_anchor(struct super_block *sb)
 	uint32_t location;
 	int i;
 
-	if (lastblock)
-	{
+	if (lastblock) {
 		int varlastblock = udf_variable_to_fixed(lastblock);
-		int last[] =  { lastblock, lastblock - 2,
-				lastblock - 150, lastblock - 152,
-				varlastblock, varlastblock - 2,
-				varlastblock - 150, varlastblock - 152 };
+		int last[] = { lastblock, lastblock - 2,
+			lastblock - 150, lastblock - 152,
+			varlastblock, varlastblock - 2,
+			varlastblock - 150, varlastblock - 152
+		};
 
 		lastblock = 0;
 
@@ -663,90 +661,103 @@ udf_find_anchor(struct super_block *sb)
 		 *  however, if the disc isn't closed, it could be 512 */
 
 		for (i = 0; !lastblock && i < ARRAY_SIZE(last); i++) {
-			if (last[i] < 0 || !(bh = sb_bread(sb, last[i])))
-			{
+			if (last[i] < 0 || !(bh = sb_bread(sb, last[i]))) {
 				ident = location = 0;
-			}
-			else
-			{
-				ident = le16_to_cpu(((tag *)bh->b_data)->tagIdent);
-				location = le32_to_cpu(((tag *)bh->b_data)->tagLocation);
+			} else {
+				ident =
+				    le16_to_cpu(((tag *) bh->b_data)->tagIdent);
+				location =
+				    le32_to_cpu(((tag *) bh->b_data)->
+						tagLocation);
 				brelse(bh);
 			}
 
-			if (ident == TAG_IDENT_AVDP)
-			{
-				if (location == last[i] - UDF_SB_SESSION(sb))
-				{
-					lastblock = UDF_SB_ANCHOR(sb)[0] = last[i] - UDF_SB_SESSION(sb);
-					UDF_SB_ANCHOR(sb)[1] = last[i] - 256 - UDF_SB_SESSION(sb);
-				}
-				else if (location == udf_variable_to_fixed(last[i]) - UDF_SB_SESSION(sb))
-				{
+			if (ident == TAG_IDENT_AVDP) {
+				if (location == last[i] - UDF_SB_SESSION(sb)) {
+					lastblock = UDF_SB_ANCHOR(sb)[0] =
+					    last[i] - UDF_SB_SESSION(sb);
+					UDF_SB_ANCHOR(sb)[1] =
+					    last[i] - 256 - UDF_SB_SESSION(sb);
+				} else if (location ==
+					   udf_variable_to_fixed(last[i]) -
+					   UDF_SB_SESSION(sb)) {
 					UDF_SET_FLAG(sb, UDF_FLAG_VARCONV);
-					lastblock = UDF_SB_ANCHOR(sb)[0] = udf_variable_to_fixed(last[i]) - UDF_SB_SESSION(sb);
-					UDF_SB_ANCHOR(sb)[1] = lastblock - 256 - UDF_SB_SESSION(sb);
-				}
-				else
-					udf_debug("Anchor found at block %d, location mismatch %d.\n",
-						last[i], location);
-			}
-			else if (ident == TAG_IDENT_FE || ident == TAG_IDENT_EFE)
-			{
+					lastblock = UDF_SB_ANCHOR(sb)[0] =
+					    udf_variable_to_fixed(last[i]) -
+					    UDF_SB_SESSION(sb);
+					UDF_SB_ANCHOR(sb)[1] =
+					    lastblock - 256 -
+					    UDF_SB_SESSION(sb);
+				} else
+					udf_debug
+					    ("Anchor found at block %d, location mismatch %d.\n",
+					     last[i], location);
+			} else if (ident == TAG_IDENT_FE
+				   || ident == TAG_IDENT_EFE) {
 				lastblock = last[i];
 				UDF_SB_ANCHOR(sb)[3] = 512;
-			}
-			else
-			{
-				if (last[i] < 256 || !(bh = sb_bread(sb, last[i] - 256)))
-				{
+			} else {
+				if (last[i] < 256
+				    || !(bh = sb_bread(sb, last[i] - 256))) {
 					ident = location = 0;
-				}
-				else
-				{
-					ident = le16_to_cpu(((tag *)bh->b_data)->tagIdent);
-					location = le32_to_cpu(((tag *)bh->b_data)->tagLocation);
+				} else {
+					ident =
+					    le16_to_cpu(((tag *) bh->b_data)->
+							tagIdent);
+					location =
+					    le32_to_cpu(((tag *) bh->b_data)->
+							tagLocation);
 					brelse(bh);
 				}
-	
+
 				if (ident == TAG_IDENT_AVDP &&
-					location == last[i] - 256 - UDF_SB_SESSION(sb))
-				{
+				    location ==
+				    last[i] - 256 - UDF_SB_SESSION(sb)) {
 					lastblock = last[i];
 					UDF_SB_ANCHOR(sb)[1] = last[i] - 256;
-				}
-				else
-				{
-					if (last[i] < 312 + UDF_SB_SESSION(sb) || !(bh = sb_bread(sb, last[i] - 312 - UDF_SB_SESSION(sb))))
+				} else {
+					if (last[i] < 312 + UDF_SB_SESSION(sb)
+					    || !(bh =
+						 sb_bread(sb,
+							  last[i] - 312 -
+							  UDF_SB_SESSION(sb))))
 					{
 						ident = location = 0;
-					}
-					else
-					{
-						ident = le16_to_cpu(((tag *)bh->b_data)->tagIdent);
-						location = le32_to_cpu(((tag *)bh->b_data)->tagLocation);
+					} else {
+						ident =
+						    le16_to_cpu(((tag *) bh->
+								 b_data)->
+								tagIdent);
+						location =
+						    le32_to_cpu(((tag *) bh->
+								 b_data)->
+								tagLocation);
 						brelse(bh);
 					}
-	
+
 					if (ident == TAG_IDENT_AVDP &&
-						location == udf_variable_to_fixed(last[i]) - 256)
-					{
-						UDF_SET_FLAG(sb, UDF_FLAG_VARCONV);
-						lastblock = udf_variable_to_fixed(last[i]);
-						UDF_SB_ANCHOR(sb)[1] = lastblock - 256;
+					    location ==
+					    udf_variable_to_fixed(last[i]) -
+					    256) {
+						UDF_SET_FLAG(sb,
+							     UDF_FLAG_VARCONV);
+						lastblock =
+						    udf_variable_to_fixed(last
+									  [i]);
+						UDF_SB_ANCHOR(sb)[1] =
+						    lastblock - 256;
 					}
 				}
 			}
 		}
 	}
 
-	if (!lastblock)
-	{
+	if (!lastblock) {
 		/* We havn't found the lastblock. check 312 */
-		if ((bh = sb_bread(sb, 312 + UDF_SB_SESSION(sb))))
-		{
-			ident = le16_to_cpu(((tag *)bh->b_data)->tagIdent);
-			location = le32_to_cpu(((tag *)bh->b_data)->tagLocation);
+		if ((bh = sb_bread(sb, 312 + UDF_SB_SESSION(sb)))) {
+			ident = le16_to_cpu(((tag *) bh->b_data)->tagIdent);
+			location =
+			    le32_to_cpu(((tag *) bh->b_data)->tagLocation);
 			brelse(bh);
 
 			if (ident == TAG_IDENT_AVDP && location == 256)
@@ -755,18 +766,19 @@ udf_find_anchor(struct super_block *sb)
 	}
 
 	for (i = 0; i < ARRAY_SIZE(UDF_SB_ANCHOR(sb)); i++) {
-		if (UDF_SB_ANCHOR(sb)[i])
-		{
+		if (UDF_SB_ANCHOR(sb)[i]) {
 			if (!(bh = udf_read_tagged(sb,
-				UDF_SB_ANCHOR(sb)[i], UDF_SB_ANCHOR(sb)[i], &ident)))
-			{
+						   UDF_SB_ANCHOR(sb)[i],
+						   UDF_SB_ANCHOR(sb)[i],
+						   &ident))) {
 				UDF_SB_ANCHOR(sb)[i] = 0;
-			}
-			else
-			{
+			} else {
 				brelse(bh);
 				if ((ident != TAG_IDENT_AVDP) && (i ||
-					(ident != TAG_IDENT_FE && ident != TAG_IDENT_EFE)))
+								  (ident !=
+								   TAG_IDENT_FE
+								   && ident !=
+								   TAG_IDENT_EFE)))
 				{
 					UDF_SB_ANCHOR(sb)[i] = 0;
 				}
@@ -777,72 +789,75 @@ udf_find_anchor(struct super_block *sb)
 	UDF_SB_LASTBLOCK(sb) = lastblock;
 }
 
-static int 
-udf_find_fileset(struct super_block *sb, kernel_lb_addr *fileset, kernel_lb_addr *root)
+static int
+udf_find_fileset(struct super_block *sb, kernel_lb_addr * fileset,
+		 kernel_lb_addr * root)
 {
 	struct buffer_head *bh = NULL;
 	long lastblock;
 	uint16_t ident;
 
 	if (fileset->logicalBlockNum != 0xFFFFFFFF ||
-		fileset->partitionReferenceNum != 0xFFFF)
-	{
+	    fileset->partitionReferenceNum != 0xFFFF) {
 		bh = udf_read_ptagged(sb, *fileset, 0, &ident);
 
 		if (!bh)
 			return 1;
-		else if (ident != TAG_IDENT_FSD)
-		{
+		else if (ident != TAG_IDENT_FSD) {
 			brelse(bh);
 			return 1;
 		}
-			
+
 	}
 
-	if (!bh) /* Search backwards through the partitions */
-	{
+	if (!bh) {		/* Search backwards through the partitions */
 		kernel_lb_addr newfileset;
 
 		return 1;
-		
-		for (newfileset.partitionReferenceNum=UDF_SB_NUMPARTS(sb)-1;
-			(newfileset.partitionReferenceNum != 0xFFFF &&
-				fileset->logicalBlockNum == 0xFFFFFFFF &&
-				fileset->partitionReferenceNum == 0xFFFF);
-			newfileset.partitionReferenceNum--)
-		{
-			lastblock = UDF_SB_PARTLEN(sb, newfileset.partitionReferenceNum);
+
+		for (newfileset.partitionReferenceNum = UDF_SB_NUMPARTS(sb) - 1;
+		     (newfileset.partitionReferenceNum != 0xFFFF &&
+		      fileset->logicalBlockNum == 0xFFFFFFFF &&
+		      fileset->partitionReferenceNum == 0xFFFF);
+		     newfileset.partitionReferenceNum--) {
+			lastblock =
+			    UDF_SB_PARTLEN(sb,
+					   newfileset.partitionReferenceNum);
 			newfileset.logicalBlockNum = 0;
 
-			do
-			{
-				bh = udf_read_ptagged(sb, newfileset, 0, &ident);
-				if (!bh)
-				{
-					newfileset.logicalBlockNum ++;
+			do {
+				bh = udf_read_ptagged(sb, newfileset, 0,
+						      &ident);
+				if (!bh) {
+					newfileset.logicalBlockNum++;
 					continue;
 				}
 
-				switch (ident)
-				{
-					case TAG_IDENT_SBD:
+				switch (ident) {
+				case TAG_IDENT_SBD:
 					{
 						struct spaceBitmapDesc *sp;
-						sp = (struct spaceBitmapDesc *)bh->b_data;
-						newfileset.logicalBlockNum += 1 +
-							((le32_to_cpu(sp->numOfBytes) + sizeof(struct spaceBitmapDesc) - 1)
-								>> sb->s_blocksize_bits);
+						sp = (struct spaceBitmapDesc *)
+						    bh->b_data;
+						newfileset.logicalBlockNum +=
+						    1 +
+						    ((le32_to_cpu
+						      (sp->numOfBytes) +
+						      sizeof(struct
+							     spaceBitmapDesc) -
+						      1)
+						     >> sb->s_blocksize_bits);
 						brelse(bh);
 						break;
 					}
-					case TAG_IDENT_FSD:
+				case TAG_IDENT_FSD:
 					{
 						*fileset = newfileset;
 						break;
 					}
-					default:
+				default:
 					{
-						newfileset.logicalBlockNum ++;
+						newfileset.logicalBlockNum++;
 						brelse(bh);
 						bh = NULL;
 						break;
@@ -850,16 +865,16 @@ udf_find_fileset(struct super_block *sb,
 				}
 			}
 			while (newfileset.logicalBlockNum < lastblock &&
-				fileset->logicalBlockNum == 0xFFFFFFFF &&
-				fileset->partitionReferenceNum == 0xFFFF);
+			       fileset->logicalBlockNum == 0xFFFFFFFF &&
+			       fileset->partitionReferenceNum == 0xFFFF);
 		}
 	}
 
 	if ((fileset->logicalBlockNum != 0xFFFFFFFF ||
-		fileset->partitionReferenceNum != 0xFFFF) && bh)
-	{
+	     fileset->partitionReferenceNum != 0xFFFF) && bh) {
 		udf_debug("Fileset at block=%d, partition=%d\n",
-			fileset->logicalBlockNum, fileset->partitionReferenceNum);
+			  fileset->logicalBlockNum,
+			  fileset->partitionReferenceNum);
 
 		UDF_SB_PARTITION(sb) = fileset->partitionReferenceNum;
 		udf_load_fileset(sb, bh, root);
@@ -869,8 +884,7 @@ udf_find_fileset(struct super_block *sb,
 	return 1;
 }
 
-static void 
-udf_load_pvoldesc(struct super_block *sb, struct buffer_head *bh)
+static void udf_load_pvoldesc(struct super_block *sb, struct buffer_head *bh)
 {
 	struct primaryVolDesc *pvoldesc;
 	time_t recording;
@@ -880,37 +894,35 @@ udf_load_pvoldesc(struct super_block *sb
 
 	pvoldesc = (struct primaryVolDesc *)bh->b_data;
 
-	if ( udf_stamp_to_time(&recording, &recording_usec,
-		lets_to_cpu(pvoldesc->recordingDateAndTime)) )
-	{
+	if (udf_stamp_to_time(&recording, &recording_usec,
+			      lets_to_cpu(pvoldesc->recordingDateAndTime))) {
 		kernel_timestamp ts;
 		ts = lets_to_cpu(pvoldesc->recordingDateAndTime);
-		udf_debug("recording time %ld/%ld, %04u/%02u/%02u %02u:%02u (%x)\n",
-			recording, recording_usec,
-			ts.year, ts.month, ts.day, ts.hour, ts.minute, ts.typeAndTimezone);
+		udf_debug
+		    ("recording time %ld/%ld, %04u/%02u/%02u %02u:%02u (%x)\n",
+		     recording, recording_usec, ts.year, ts.month, ts.day,
+		     ts.hour, ts.minute, ts.typeAndTimezone);
 		UDF_SB_RECORDTIME(sb).tv_sec = recording;
 		UDF_SB_RECORDTIME(sb).tv_nsec = recording_usec * 1000;
 	}
 
-	if ( !udf_build_ustr(&instr, pvoldesc->volIdent, 32) )
-	{
-		if (udf_CS0toUTF8(&outstr, &instr))
-		{
-			strncpy( UDF_SB_VOLIDENT(sb), outstr.u_name,
+	if (!udf_build_ustr(&instr, pvoldesc->volIdent, 32)) {
+		if (udf_CS0toUTF8(&outstr, &instr)) {
+			strncpy(UDF_SB_VOLIDENT(sb), outstr.u_name,
 				outstr.u_len > 31 ? 31 : outstr.u_len);
 			udf_debug("volIdent[] = '%s'\n", UDF_SB_VOLIDENT(sb));
 		}
 	}
 
-	if ( !udf_build_ustr(&instr, pvoldesc->volSetIdent, 128) )
-	{
+	if (!udf_build_ustr(&instr, pvoldesc->volSetIdent, 128)) {
 		if (udf_CS0toUTF8(&outstr, &instr))
 			udf_debug("volSetIdent[] = '%s'\n", outstr.u_name);
 	}
 }
 
-static void 
-udf_load_fileset(struct super_block *sb, struct buffer_head *bh, kernel_lb_addr *root)
+static void
+udf_load_fileset(struct super_block *sb, struct buffer_head *bh,
+		 kernel_lb_addr * root)
 {
 	struct fileSetDesc *fset;
 
@@ -920,109 +932,154 @@ udf_load_fileset(struct super_block *sb,
 
 	UDF_SB_SERIALNUM(sb) = le16_to_cpu(fset->descTag.tagSerialNum);
 
-	udf_debug("Rootdir at block=%d, partition=%d\n", 
-		root->logicalBlockNum, root->partitionReferenceNum);
+	udf_debug("Rootdir at block=%d, partition=%d\n",
+		  root->logicalBlockNum, root->partitionReferenceNum);
 }
 
-static void 
-udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
+static void udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
 {
 	struct partitionDesc *p;
 	int i;
 
 	p = (struct partitionDesc *)bh->b_data;
 
-	for (i=0; i<UDF_SB_NUMPARTS(sb); i++)
-	{
-		udf_debug("Searching map: (%d == %d)\n", 
-			UDF_SB_PARTMAPS(sb)[i].s_partition_num, le16_to_cpu(p->partitionNumber));
-		if (UDF_SB_PARTMAPS(sb)[i].s_partition_num == le16_to_cpu(p->partitionNumber))
-		{
-			UDF_SB_PARTLEN(sb,i) = le32_to_cpu(p->partitionLength); /* blocks */
-			UDF_SB_PARTROOT(sb,i) = le32_to_cpu(p->partitionStartingLocation);
-			if (le32_to_cpu(p->accessType) == PD_ACCESS_TYPE_READ_ONLY)
-				UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_READ_ONLY;
-			if (le32_to_cpu(p->accessType) == PD_ACCESS_TYPE_WRITE_ONCE)
-				UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_WRITE_ONCE;
-			if (le32_to_cpu(p->accessType) == PD_ACCESS_TYPE_REWRITABLE)
-				UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_REWRITABLE;
-			if (le32_to_cpu(p->accessType) == PD_ACCESS_TYPE_OVERWRITABLE)
-				UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_OVERWRITABLE;
-
-			if (!strcmp(p->partitionContents.ident, PD_PARTITION_CONTENTS_NSR02) ||
-				!strcmp(p->partitionContents.ident, PD_PARTITION_CONTENTS_NSR03))
-			{
+	for (i = 0; i < UDF_SB_NUMPARTS(sb); i++) {
+		udf_debug("Searching map: (%d == %d)\n",
+			  UDF_SB_PARTMAPS(sb)[i].s_partition_num,
+			  le16_to_cpu(p->partitionNumber));
+		if (UDF_SB_PARTMAPS(sb)[i].s_partition_num ==
+		    le16_to_cpu(p->partitionNumber)) {
+			UDF_SB_PARTLEN(sb, i) = le32_to_cpu(p->partitionLength);	/* blocks */
+			UDF_SB_PARTROOT(sb, i) =
+			    le32_to_cpu(p->partitionStartingLocation);
+			if (le32_to_cpu(p->accessType) ==
+			    PD_ACCESS_TYPE_READ_ONLY)
+				UDF_SB_PARTFLAGS(sb, i) |=
+				    UDF_PART_FLAG_READ_ONLY;
+			if (le32_to_cpu(p->accessType) ==
+			    PD_ACCESS_TYPE_WRITE_ONCE)
+				UDF_SB_PARTFLAGS(sb, i) |=
+				    UDF_PART_FLAG_WRITE_ONCE;
+			if (le32_to_cpu(p->accessType) ==
+			    PD_ACCESS_TYPE_REWRITABLE)
+				UDF_SB_PARTFLAGS(sb, i) |=
+				    UDF_PART_FLAG_REWRITABLE;
+			if (le32_to_cpu(p->accessType) ==
+			    PD_ACCESS_TYPE_OVERWRITABLE)
+				UDF_SB_PARTFLAGS(sb, i) |=
+				    UDF_PART_FLAG_OVERWRITABLE;
+
+			if (!strcmp
+			    (p->partitionContents.ident,
+			     PD_PARTITION_CONTENTS_NSR02)
+			    || !strcmp(p->partitionContents.ident,
+				       PD_PARTITION_CONTENTS_NSR03)) {
 				struct partitionHeaderDesc *phd;
 
-				phd = (struct partitionHeaderDesc *)(p->partitionContentsUse);
-				if (phd->unallocSpaceTable.extLength)
-				{
-					kernel_lb_addr loc = { le32_to_cpu(phd->unallocSpaceTable.extPosition), i };
-
-					UDF_SB_PARTMAPS(sb)[i].s_uspace.s_table =
-						udf_iget(sb, loc);
-					UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_UNALLOC_TABLE;
-					udf_debug("unallocSpaceTable (part %d) @ %ld\n",
-						i, UDF_SB_PARTMAPS(sb)[i].s_uspace.s_table->i_ino);
+				phd =
+				    (struct partitionHeaderDesc *)(p->
+								   partitionContentsUse);
+				if (phd->unallocSpaceTable.extLength) {
+					kernel_lb_addr loc =
+					    { le32_to_cpu(phd->
+							  unallocSpaceTable.
+							  extPosition), i };
+
+					UDF_SB_PARTMAPS(sb)[i].s_uspace.
+					    s_table = udf_iget(sb, loc);
+					UDF_SB_PARTFLAGS(sb, i) |=
+					    UDF_PART_FLAG_UNALLOC_TABLE;
+					udf_debug
+					    ("unallocSpaceTable (part %d) @ %ld\n",
+					     i,
+					     UDF_SB_PARTMAPS(sb)[i].s_uspace.
+					     s_table->i_ino);
 				}
-				if (phd->unallocSpaceBitmap.extLength)
-				{
+				if (phd->unallocSpaceBitmap.extLength) {
 					UDF_SB_ALLOC_BITMAP(sb, i, s_uspace);
-					if (UDF_SB_PARTMAPS(sb)[i].s_uspace.s_bitmap != NULL)
-					{
-						UDF_SB_PARTMAPS(sb)[i].s_uspace.s_bitmap->s_extLength =
-							le32_to_cpu(phd->unallocSpaceBitmap.extLength);
-						UDF_SB_PARTMAPS(sb)[i].s_uspace.s_bitmap->s_extPosition =
-							le32_to_cpu(phd->unallocSpaceBitmap.extPosition);
-						UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_UNALLOC_BITMAP;
-						udf_debug("unallocSpaceBitmap (part %d) @ %d\n",
-							i, UDF_SB_PARTMAPS(sb)[i].s_uspace.s_bitmap->s_extPosition);
+					if (UDF_SB_PARTMAPS(sb)[i].s_uspace.
+					    s_bitmap != NULL) {
+						UDF_SB_PARTMAPS(sb)[i].s_uspace.
+						    s_bitmap->s_extLength =
+						    le32_to_cpu(phd->
+								unallocSpaceBitmap.
+								extLength);
+						UDF_SB_PARTMAPS(sb)[i].s_uspace.
+						    s_bitmap->s_extPosition =
+						    le32_to_cpu(phd->
+								unallocSpaceBitmap.
+								extPosition);
+						UDF_SB_PARTFLAGS(sb, i) |=
+						    UDF_PART_FLAG_UNALLOC_BITMAP;
+						udf_debug
+						    ("unallocSpaceBitmap (part %d) @ %d\n",
+						     i,
+						     UDF_SB_PARTMAPS(sb)[i].
+						     s_uspace.s_bitmap->
+						     s_extPosition);
 					}
 				}
 				if (phd->partitionIntegrityTable.extLength)
-					udf_debug("partitionIntegrityTable (part %d)\n", i);
-				if (phd->freedSpaceTable.extLength)
-				{
-					kernel_lb_addr loc = { le32_to_cpu(phd->freedSpaceTable.extPosition), i };
-
-					UDF_SB_PARTMAPS(sb)[i].s_fspace.s_table =
-						udf_iget(sb, loc);
-					UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_FREED_TABLE;
-					udf_debug("freedSpaceTable (part %d) @ %ld\n",
-						i, UDF_SB_PARTMAPS(sb)[i].s_fspace.s_table->i_ino);
+					udf_debug
+					    ("partitionIntegrityTable (part %d)\n",
+					     i);
+				if (phd->freedSpaceTable.extLength) {
+					kernel_lb_addr loc =
+					    { le32_to_cpu(phd->freedSpaceTable.
+							  extPosition), i };
+
+					UDF_SB_PARTMAPS(sb)[i].s_fspace.
+					    s_table = udf_iget(sb, loc);
+					UDF_SB_PARTFLAGS(sb, i) |=
+					    UDF_PART_FLAG_FREED_TABLE;
+					udf_debug
+					    ("freedSpaceTable (part %d) @ %ld\n",
+					     i,
+					     UDF_SB_PARTMAPS(sb)[i].s_fspace.
+					     s_table->i_ino);
 				}
-				if (phd->freedSpaceBitmap.extLength)
-				{
+				if (phd->freedSpaceBitmap.extLength) {
 					UDF_SB_ALLOC_BITMAP(sb, i, s_fspace);
-					if (UDF_SB_PARTMAPS(sb)[i].s_fspace.s_bitmap != NULL)
-					{
-						UDF_SB_PARTMAPS(sb)[i].s_fspace.s_bitmap->s_extLength =
-							le32_to_cpu(phd->freedSpaceBitmap.extLength);
-						UDF_SB_PARTMAPS(sb)[i].s_fspace.s_bitmap->s_extPosition =
-							le32_to_cpu(phd->freedSpaceBitmap.extPosition);
-						UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_FREED_BITMAP;
-						udf_debug("freedSpaceBitmap (part %d) @ %d\n",
-							i, UDF_SB_PARTMAPS(sb)[i].s_fspace.s_bitmap->s_extPosition);
+					if (UDF_SB_PARTMAPS(sb)[i].s_fspace.
+					    s_bitmap != NULL) {
+						UDF_SB_PARTMAPS(sb)[i].s_fspace.
+						    s_bitmap->s_extLength =
+						    le32_to_cpu(phd->
+								freedSpaceBitmap.
+								extLength);
+						UDF_SB_PARTMAPS(sb)[i].s_fspace.
+						    s_bitmap->s_extPosition =
+						    le32_to_cpu(phd->
+								freedSpaceBitmap.
+								extPosition);
+						UDF_SB_PARTFLAGS(sb, i) |=
+						    UDF_PART_FLAG_FREED_BITMAP;
+						udf_debug
+						    ("freedSpaceBitmap (part %d) @ %d\n",
+						     i,
+						     UDF_SB_PARTMAPS(sb)[i].
+						     s_fspace.s_bitmap->
+						     s_extPosition);
 					}
 				}
 			}
 			break;
 		}
 	}
-	if (i == UDF_SB_NUMPARTS(sb))
-	{
-		udf_debug("Partition (%d) not found in partition map\n", le16_to_cpu(p->partitionNumber));
-	}
-	else
-	{
-		udf_debug("Partition (%d:%d type %x) starts at physical %d, block length %d\n",
-			le16_to_cpu(p->partitionNumber), i, UDF_SB_PARTTYPE(sb,i),
-			UDF_SB_PARTROOT(sb,i), UDF_SB_PARTLEN(sb,i));
+	if (i == UDF_SB_NUMPARTS(sb)) {
+		udf_debug("Partition (%d) not found in partition map\n",
+			  le16_to_cpu(p->partitionNumber));
+	} else {
+		udf_debug
+		    ("Partition (%d:%d type %x) starts at physical %d, block length %d\n",
+		     le16_to_cpu(p->partitionNumber), i, UDF_SB_PARTTYPE(sb, i),
+		     UDF_SB_PARTROOT(sb, i), UDF_SB_PARTLEN(sb, i));
 	}
 }
 
-static int 
-udf_load_logicalvol(struct super_block *sb, struct buffer_head * bh, kernel_lb_addr *fileset)
+static int
+udf_load_logicalvol(struct super_block *sb, struct buffer_head *bh,
+		    kernel_lb_addr * fileset)
 {
 	struct logicalVolDesc *lvd;
 	int i, j, offset;
@@ -1032,82 +1089,114 @@ udf_load_logicalvol(struct super_block *
 
 	UDF_SB_ALLOC_PARTMAPS(sb, le32_to_cpu(lvd->numPartitionMaps));
 
-	for (i=0,offset=0;
-		 i<UDF_SB_NUMPARTS(sb) && offset<le32_to_cpu(lvd->mapTableLength);
-		 i++,offset+=((struct genericPartitionMap *)&(lvd->partitionMaps[offset]))->partitionMapLength)
-	{
-		type = ((struct genericPartitionMap *)&(lvd->partitionMaps[offset]))->partitionMapType;
-		if (type == 1)
-		{
-			struct genericPartitionMap1 *gpm1 = (struct genericPartitionMap1 *)&(lvd->partitionMaps[offset]);
-			UDF_SB_PARTTYPE(sb,i) = UDF_TYPE1_MAP15;
-			UDF_SB_PARTVSN(sb,i) = le16_to_cpu(gpm1->volSeqNum);
-			UDF_SB_PARTNUM(sb,i) = le16_to_cpu(gpm1->partitionNum);
-			UDF_SB_PARTFUNC(sb,i) = NULL;
-		}
-		else if (type == 2)
-		{
-			struct udfPartitionMap2 *upm2 = (struct udfPartitionMap2 *)&(lvd->partitionMaps[offset]);
-			if (!strncmp(upm2->partIdent.ident, UDF_ID_VIRTUAL, strlen(UDF_ID_VIRTUAL)))
-			{
-				if (le16_to_cpu(((__le16 *)upm2->partIdent.identSuffix)[0]) == 0x0150)
-				{
-					UDF_SB_PARTTYPE(sb,i) = UDF_VIRTUAL_MAP15;
-					UDF_SB_PARTFUNC(sb,i) = udf_get_pblock_virt15;
-				}
-				else if (le16_to_cpu(((__le16 *)upm2->partIdent.identSuffix)[0]) == 0x0200)
-				{
-					UDF_SB_PARTTYPE(sb,i) = UDF_VIRTUAL_MAP20;
-					UDF_SB_PARTFUNC(sb,i) = udf_get_pblock_virt20;
-				}
-			}
-			else if (!strncmp(upm2->partIdent.ident, UDF_ID_SPARABLE, strlen(UDF_ID_SPARABLE)))
-			{
+	for (i = 0, offset = 0;
+	     i < UDF_SB_NUMPARTS(sb)
+	     && offset < le32_to_cpu(lvd->mapTableLength);
+	     i++, offset +=
+	     ((struct genericPartitionMap *)&(lvd->partitionMaps[offset]))->
+	     partitionMapLength) {
+		type =
+		    ((struct genericPartitionMap *)
+		     &(lvd->partitionMaps[offset]))->partitionMapType;
+		if (type == 1) {
+			struct genericPartitionMap1 *gpm1 =
+			    (struct genericPartitionMap1 *)&(lvd->
+							     partitionMaps
+							     [offset]);
+			UDF_SB_PARTTYPE(sb, i) = UDF_TYPE1_MAP15;
+			UDF_SB_PARTVSN(sb, i) = le16_to_cpu(gpm1->volSeqNum);
+			UDF_SB_PARTNUM(sb, i) = le16_to_cpu(gpm1->partitionNum);
+			UDF_SB_PARTFUNC(sb, i) = NULL;
+		} else if (type == 2) {
+			struct udfPartitionMap2 *upm2 =
+			    (struct udfPartitionMap2 *)&(lvd->
+							 partitionMaps[offset]);
+			if (!strncmp
+			    (upm2->partIdent.ident, UDF_ID_VIRTUAL,
+			     strlen(UDF_ID_VIRTUAL))) {
+				if (le16_to_cpu
+				    (((__le16 *) upm2->partIdent.
+				      identSuffix)[0]) == 0x0150) {
+					UDF_SB_PARTTYPE(sb, i) =
+					    UDF_VIRTUAL_MAP15;
+					UDF_SB_PARTFUNC(sb, i) =
+					    udf_get_pblock_virt15;
+				} else
+				    if (le16_to_cpu
+					(((__le16 *) upm2->partIdent.
+					  identSuffix)[0]) == 0x0200) {
+					UDF_SB_PARTTYPE(sb, i) =
+					    UDF_VIRTUAL_MAP20;
+					UDF_SB_PARTFUNC(sb, i) =
+					    udf_get_pblock_virt20;
+				}
+			} else
+			    if (!strncmp
+				(upm2->partIdent.ident, UDF_ID_SPARABLE,
+				 strlen(UDF_ID_SPARABLE))) {
 				uint32_t loc;
 				uint16_t ident;
 				struct sparingTable *st;
-				struct sparablePartitionMap *spm = (struct sparablePartitionMap *)&(lvd->partitionMaps[offset]);
-
-				UDF_SB_PARTTYPE(sb,i) = UDF_SPARABLE_MAP15;
-				UDF_SB_TYPESPAR(sb,i).s_packet_len = le16_to_cpu(spm->packetLength);
-				for (j=0; j<spm->numSparingTables; j++)
-				{
-					loc = le32_to_cpu(spm->locSparingTable[j]);
-					UDF_SB_TYPESPAR(sb,i).s_spar_map[j] =
-						udf_read_tagged(sb, loc, loc, &ident);
-					if (UDF_SB_TYPESPAR(sb,i).s_spar_map[j] != NULL)
-					{
-						st = (struct sparingTable *)UDF_SB_TYPESPAR(sb,i).s_spar_map[j]->b_data;
-						if (ident != 0 ||
-							strncmp(st->sparingIdent.ident, UDF_ID_SPARING, strlen(UDF_ID_SPARING)))
+				struct sparablePartitionMap *spm =
+				    (struct sparablePartitionMap *)&(lvd->
+								     partitionMaps
+								     [offset]);
+
+				UDF_SB_PARTTYPE(sb, i) = UDF_SPARABLE_MAP15;
+				UDF_SB_TYPESPAR(sb, i).s_packet_len =
+				    le16_to_cpu(spm->packetLength);
+				for (j = 0; j < spm->numSparingTables; j++) {
+					loc =
+					    le32_to_cpu(spm->
+							locSparingTable[j]);
+					UDF_SB_TYPESPAR(sb, i).s_spar_map[j] =
+					    udf_read_tagged(sb, loc, loc,
+							    &ident);
+					if (UDF_SB_TYPESPAR(sb, i).
+					    s_spar_map[j] != NULL) {
+						st = (struct sparingTable *)
+						    UDF_SB_TYPESPAR(sb,
+								    i).
+						    s_spar_map[j]->b_data;
+						if (ident != 0
+						    || strncmp(st->sparingIdent.
+							       ident,
+							       UDF_ID_SPARING,
+							       strlen
+							       (UDF_ID_SPARING)))
 						{
-							brelse(UDF_SB_TYPESPAR(sb,i).s_spar_map[j]);
-							UDF_SB_TYPESPAR(sb,i).s_spar_map[j] = NULL;
+							brelse(UDF_SB_TYPESPAR
+							       (sb,
+								i).
+							       s_spar_map[j]);
+							UDF_SB_TYPESPAR(sb,
+									i).
+							    s_spar_map[j] =
+							    NULL;
 						}
 					}
 				}
-				UDF_SB_PARTFUNC(sb,i) = udf_get_pblock_spar15;
-			}
-			else
-			{
-				udf_debug("Unknown ident: %s\n", upm2->partIdent.ident);
+				UDF_SB_PARTFUNC(sb, i) = udf_get_pblock_spar15;
+			} else {
+				udf_debug("Unknown ident: %s\n",
+					  upm2->partIdent.ident);
 				continue;
 			}
-			UDF_SB_PARTVSN(sb,i) = le16_to_cpu(upm2->volSeqNum);
-			UDF_SB_PARTNUM(sb,i) = le16_to_cpu(upm2->partitionNum);
+			UDF_SB_PARTVSN(sb, i) = le16_to_cpu(upm2->volSeqNum);
+			UDF_SB_PARTNUM(sb, i) = le16_to_cpu(upm2->partitionNum);
 		}
 		udf_debug("Partition (%d:%d) type %d on volume %d\n",
-			i, UDF_SB_PARTNUM(sb,i), type, UDF_SB_PARTVSN(sb,i));
+			  i, UDF_SB_PARTNUM(sb, i), type, UDF_SB_PARTVSN(sb,
+									 i));
 	}
 
-	if (fileset)
-	{
-		long_ad *la = (long_ad *)&(lvd->logicalVolContentsUse[0]);
+	if (fileset) {
+		long_ad *la = (long_ad *) & (lvd->logicalVolContentsUse[0]);
 
 		*fileset = lelb_to_cpu(la->extLocation);
-		udf_debug("FileSet found in LogicalVolDesc at block=%d, partition=%d\n",
-			fileset->logicalBlockNum,
-			fileset->partitionReferenceNum);
+		udf_debug
+		    ("FileSet found in LogicalVolDesc at block=%d, partition=%d\n",
+		     fileset->logicalBlockNum, fileset->partitionReferenceNum);
 	}
 	if (lvd->integritySeqExt.extLength)
 		udf_load_logicalvolint(sb, leea_to_cpu(lvd->integritySeqExt));
@@ -1118,26 +1207,26 @@ udf_load_logicalvol(struct super_block *
  * udf_load_logicalvolint
  *
  */
-static void
-udf_load_logicalvolint(struct super_block *sb, kernel_extent_ad loc)
+static void udf_load_logicalvolint(struct super_block *sb, kernel_extent_ad loc)
 {
 	struct buffer_head *bh = NULL;
 	uint16_t ident;
 
 	while (loc.extLength > 0 &&
-		(bh = udf_read_tagged(sb, loc.extLocation,
-			loc.extLocation, &ident)) &&
-		ident == TAG_IDENT_LVID)
-	{
+	       (bh = udf_read_tagged(sb, loc.extLocation,
+				     loc.extLocation, &ident)) &&
+	       ident == TAG_IDENT_LVID) {
 		UDF_SB_LVIDBH(sb) = bh;
-		
+
 		if (UDF_SB_LVID(sb)->nextIntegrityExt.extLength)
-			udf_load_logicalvolint(sb, leea_to_cpu(UDF_SB_LVID(sb)->nextIntegrityExt));
-		
+			udf_load_logicalvolint(sb,
+					       leea_to_cpu(UDF_SB_LVID(sb)->
+							   nextIntegrityExt));
+
 		if (UDF_SB_LVIDBH(sb) != bh)
 			brelse(bh);
 		loc.extLength -= sb->s_blocksize;
-		loc.extLocation ++;
+		loc.extLocation++;
 	}
 	if (UDF_SB_LVIDBH(sb) != bh)
 		brelse(bh);
@@ -1158,15 +1247,16 @@ udf_load_logicalvolint(struct super_bloc
  *	July 1, 1997 - Andrew E. Mileski
  *	Written, tested, and released.
  */
-static  int
-udf_process_sequence(struct super_block *sb, long block, long lastblock, kernel_lb_addr *fileset)
+static int
+udf_process_sequence(struct super_block *sb, long block, long lastblock,
+		     kernel_lb_addr * fileset)
 {
 	struct buffer_head *bh = NULL;
 	struct udf_vds_record vds[VDS_POS_LENGTH];
 	struct generic_desc *gd;
 	struct volDescPtr *vdp;
-	int done=0;
-	int i,j;
+	int done = 0;
+	int i, j;
 	uint32_t vdsn;
 	uint16_t ident;
 	long next_s = 0, next_e = 0;
@@ -1174,93 +1264,92 @@ udf_process_sequence(struct super_block 
 	memset(vds, 0, sizeof(struct udf_vds_record) * VDS_POS_LENGTH);
 
 	/* Read the main descriptor sequence */
-	for (;(!done && block <= lastblock); block++)
-	{
+	for (; (!done && block <= lastblock); block++) {
 
 		bh = udf_read_tagged(sb, block, block, &ident);
-		if (!bh) 
+		if (!bh)
 			break;
 
 		/* Process each descriptor (ISO 13346 3/8.3-8.4) */
 		gd = (struct generic_desc *)bh->b_data;
 		vdsn = le32_to_cpu(gd->volDescSeqNum);
-		switch (ident)
-		{
-			case TAG_IDENT_PVD: /* ISO 13346 3/10.1 */
-				if (vdsn >= vds[VDS_POS_PRIMARY_VOL_DESC].volDescSeqNum)
-				{
-					vds[VDS_POS_PRIMARY_VOL_DESC].volDescSeqNum = vdsn;
-					vds[VDS_POS_PRIMARY_VOL_DESC].block = block;
-				}
-				break;
-			case TAG_IDENT_VDP: /* ISO 13346 3/10.3 */
-				if (vdsn >= vds[VDS_POS_VOL_DESC_PTR].volDescSeqNum)
-				{
-					vds[VDS_POS_VOL_DESC_PTR].volDescSeqNum = vdsn;
-					vds[VDS_POS_VOL_DESC_PTR].block = block;
-
-					vdp = (struct volDescPtr *)bh->b_data;
-					next_s = le32_to_cpu(vdp->nextVolDescSeqExt.extLocation);
-					next_e = le32_to_cpu(vdp->nextVolDescSeqExt.extLength);
-					next_e = next_e >> sb->s_blocksize_bits;
-					next_e += next_s;
-				}
-				break;
-			case TAG_IDENT_IUVD: /* ISO 13346 3/10.4 */
-				if (vdsn >= vds[VDS_POS_IMP_USE_VOL_DESC].volDescSeqNum)
-				{
-					vds[VDS_POS_IMP_USE_VOL_DESC].volDescSeqNum = vdsn;
-					vds[VDS_POS_IMP_USE_VOL_DESC].block = block;
-				}
-				break;
-			case TAG_IDENT_PD: /* ISO 13346 3/10.5 */
-				if (!vds[VDS_POS_PARTITION_DESC].block)
-					vds[VDS_POS_PARTITION_DESC].block = block;
-				break;
-			case TAG_IDENT_LVD: /* ISO 13346 3/10.6 */
-				if (vdsn >= vds[VDS_POS_LOGICAL_VOL_DESC].volDescSeqNum)
-				{
-					vds[VDS_POS_LOGICAL_VOL_DESC].volDescSeqNum = vdsn;
-					vds[VDS_POS_LOGICAL_VOL_DESC].block = block;
-				}
-				break;
-			case TAG_IDENT_USD: /* ISO 13346 3/10.8 */
-				if (vdsn >= vds[VDS_POS_UNALLOC_SPACE_DESC].volDescSeqNum)
-				{
-					vds[VDS_POS_UNALLOC_SPACE_DESC].volDescSeqNum = vdsn;
-					vds[VDS_POS_UNALLOC_SPACE_DESC].block = block;
-				}
-				break;
-			case TAG_IDENT_TD: /* ISO 13346 3/10.9 */
-				vds[VDS_POS_TERMINATING_DESC].block = block;
-				if (next_e)
-				{
-					block = next_s;
-					lastblock = next_e;
-					next_s = next_e = 0;
-				}
-				else
-					done = 1;
-				break;
+		switch (ident) {
+		case TAG_IDENT_PVD:	/* ISO 13346 3/10.1 */
+			if (vdsn >= vds[VDS_POS_PRIMARY_VOL_DESC].volDescSeqNum) {
+				vds[VDS_POS_PRIMARY_VOL_DESC].volDescSeqNum =
+				    vdsn;
+				vds[VDS_POS_PRIMARY_VOL_DESC].block = block;
+			}
+			break;
+		case TAG_IDENT_VDP:	/* ISO 13346 3/10.3 */
+			if (vdsn >= vds[VDS_POS_VOL_DESC_PTR].volDescSeqNum) {
+				vds[VDS_POS_VOL_DESC_PTR].volDescSeqNum = vdsn;
+				vds[VDS_POS_VOL_DESC_PTR].block = block;
+
+				vdp = (struct volDescPtr *)bh->b_data;
+				next_s =
+				    le32_to_cpu(vdp->nextVolDescSeqExt.
+						extLocation);
+				next_e =
+				    le32_to_cpu(vdp->nextVolDescSeqExt.
+						extLength);
+				next_e = next_e >> sb->s_blocksize_bits;
+				next_e += next_s;
+			}
+			break;
+		case TAG_IDENT_IUVD:	/* ISO 13346 3/10.4 */
+			if (vdsn >= vds[VDS_POS_IMP_USE_VOL_DESC].volDescSeqNum) {
+				vds[VDS_POS_IMP_USE_VOL_DESC].volDescSeqNum =
+				    vdsn;
+				vds[VDS_POS_IMP_USE_VOL_DESC].block = block;
+			}
+			break;
+		case TAG_IDENT_PD:	/* ISO 13346 3/10.5 */
+			if (!vds[VDS_POS_PARTITION_DESC].block)
+				vds[VDS_POS_PARTITION_DESC].block = block;
+			break;
+		case TAG_IDENT_LVD:	/* ISO 13346 3/10.6 */
+			if (vdsn >= vds[VDS_POS_LOGICAL_VOL_DESC].volDescSeqNum) {
+				vds[VDS_POS_LOGICAL_VOL_DESC].volDescSeqNum =
+				    vdsn;
+				vds[VDS_POS_LOGICAL_VOL_DESC].block = block;
+			}
+			break;
+		case TAG_IDENT_USD:	/* ISO 13346 3/10.8 */
+			if (vdsn >=
+			    vds[VDS_POS_UNALLOC_SPACE_DESC].volDescSeqNum) {
+				vds[VDS_POS_UNALLOC_SPACE_DESC].volDescSeqNum =
+				    vdsn;
+				vds[VDS_POS_UNALLOC_SPACE_DESC].block = block;
+			}
+			break;
+		case TAG_IDENT_TD:	/* ISO 13346 3/10.9 */
+			vds[VDS_POS_TERMINATING_DESC].block = block;
+			if (next_e) {
+				block = next_s;
+				lastblock = next_e;
+				next_s = next_e = 0;
+			} else
+				done = 1;
+			break;
 		}
 		brelse(bh);
 	}
-	for (i=0; i<VDS_POS_LENGTH; i++)
-	{
-		if (vds[i].block)
-		{
-			bh = udf_read_tagged(sb, vds[i].block, vds[i].block, &ident);
+	for (i = 0; i < VDS_POS_LENGTH; i++) {
+		if (vds[i].block) {
+			bh = udf_read_tagged(sb, vds[i].block, vds[i].block,
+					     &ident);
 
 			if (i == VDS_POS_PRIMARY_VOL_DESC)
 				udf_load_pvoldesc(sb, bh);
 			else if (i == VDS_POS_LOGICAL_VOL_DESC)
 				udf_load_logicalvol(sb, bh, fileset);
-			else if (i == VDS_POS_PARTITION_DESC)
-			{
+			else if (i == VDS_POS_PARTITION_DESC) {
 				struct buffer_head *bh2 = NULL;
 				udf_load_partdesc(sb, bh);
-				for (j=vds[i].block+1; j<vds[VDS_POS_TERMINATING_DESC].block; j++)
-				{
+				for (j = vds[i].block + 1;
+				     j < vds[VDS_POS_TERMINATING_DESC].block;
+				     j++) {
 					bh2 = udf_read_tagged(sb, j, j, &ident);
 					gd = (struct generic_desc *)bh2->b_data;
 					if (ident == TAG_IDENT_PD)
@@ -1278,31 +1367,27 @@ udf_process_sequence(struct super_block 
 /*
  * udf_check_valid()
  */
-static int
-udf_check_valid(struct super_block *sb, int novrs, int silent)
+static int udf_check_valid(struct super_block *sb, int novrs, int silent)
 {
 	long block;
 
-	if (novrs)
-	{
+	if (novrs) {
 		udf_debug("Validity check skipped because of novrs option\n");
 		return 0;
 	}
 	/* Check that it is NSR02 compliant */
 	/* Process any "CD-ROM Volume Descriptor Set" (ECMA 167 2/8.3.1) */
-	else if ((block = udf_vrs(sb, silent)) == -1)
-	{
-		udf_debug("Failed to read byte 32768. Assuming open disc. Skipping validity check\n");
+	else if ((block = udf_vrs(sb, silent)) == -1) {
+		udf_debug
+		    ("Failed to read byte 32768. Assuming open disc. Skipping validity check\n");
 		if (!UDF_SB_LASTBLOCK(sb))
 			UDF_SB_LASTBLOCK(sb) = udf_get_last_block(sb);
 		return 0;
-	}
-	else 
+	} else
 		return !block;
 }
 
-static int
-udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
+static int udf_load_partition(struct super_block *sb, kernel_lb_addr * fileset)
 {
 	struct anchorVolDescPtr *anchor;
 	uint16_t ident;
@@ -1315,19 +1400,27 @@ udf_load_partition(struct super_block *s
 
 	for (i = 0; i < ARRAY_SIZE(UDF_SB_ANCHOR(sb)); i++) {
 		if (UDF_SB_ANCHOR(sb)[i] && (bh = udf_read_tagged(sb,
-			UDF_SB_ANCHOR(sb)[i], UDF_SB_ANCHOR(sb)[i], &ident)))
-		{
+								  UDF_SB_ANCHOR
+								  (sb)[i],
+								  UDF_SB_ANCHOR
+								  (sb)[i],
+								  &ident))) {
 			anchor = (struct anchorVolDescPtr *)bh->b_data;
 
 			/* Locate the main sequence */
-			main_s = le32_to_cpu( anchor->mainVolDescSeqExt.extLocation );
-			main_e = le32_to_cpu( anchor->mainVolDescSeqExt.extLength );
+			main_s =
+			    le32_to_cpu(anchor->mainVolDescSeqExt.extLocation);
+			main_e =
+			    le32_to_cpu(anchor->mainVolDescSeqExt.extLength);
 			main_e = main_e >> sb->s_blocksize_bits;
 			main_e += main_s;
 
 			/* Locate the reserve sequence */
-			reserve_s = le32_to_cpu(anchor->reserveVolDescSeqExt.extLocation);
-			reserve_e = le32_to_cpu(anchor->reserveVolDescSeqExt.extLength);
+			reserve_s =
+			    le32_to_cpu(anchor->reserveVolDescSeqExt.
+					extLocation);
+			reserve_e =
+			    le32_to_cpu(anchor->reserveVolDescSeqExt.extLength);
 			reserve_e = reserve_e >> sb->s_blocksize_bits;
 			reserve_e += reserve_s;
 
@@ -1335,9 +1428,10 @@ udf_load_partition(struct super_block *s
 
 			/* Process the main & reserve sequences */
 			/* responsible for finding the PartitionDesc(s) */
-			if (!(udf_process_sequence(sb, main_s, main_e, fileset) &&
-				udf_process_sequence(sb, reserve_s, reserve_e, fileset)))
-			{
+			if (!
+			    (udf_process_sequence(sb, main_s, main_e, fileset)
+			     && udf_process_sequence(sb, reserve_s, reserve_e,
+						     fileset))) {
 				break;
 			}
 		}
@@ -1349,36 +1443,37 @@ udf_load_partition(struct super_block *s
 	} else
 		udf_debug("Using anchor in block %d\n", UDF_SB_ANCHOR(sb)[i]);
 
-	for (i=0; i<UDF_SB_NUMPARTS(sb); i++)
-	{
-		switch (UDF_SB_PARTTYPE(sb, i))
-		{
-			case UDF_VIRTUAL_MAP15:
-			case UDF_VIRTUAL_MAP20:
+	for (i = 0; i < UDF_SB_NUMPARTS(sb); i++) {
+		switch (UDF_SB_PARTTYPE(sb, i)) {
+		case UDF_VIRTUAL_MAP15:
+		case UDF_VIRTUAL_MAP20:
 			{
 				kernel_lb_addr uninitialized_var(ino);
 
-				if (!UDF_SB_LASTBLOCK(sb))
-				{
-					UDF_SB_LASTBLOCK(sb) = udf_get_last_block(sb);
+				if (!UDF_SB_LASTBLOCK(sb)) {
+					UDF_SB_LASTBLOCK(sb) =
+					    udf_get_last_block(sb);
 					udf_find_anchor(sb);
 				}
 
-				if (!UDF_SB_LASTBLOCK(sb))
-				{
-					udf_debug("Unable to determine Lastblock (For Virtual Partition)\n");
+				if (!UDF_SB_LASTBLOCK(sb)) {
+					udf_debug
+					    ("Unable to determine Lastblock (For Virtual Partition)\n");
 					return 1;
 				}
 
-				for (j=0; j<UDF_SB_NUMPARTS(sb); j++)
-				{
+				for (j = 0; j < UDF_SB_NUMPARTS(sb); j++) {
 					if (j != i &&
-						UDF_SB_PARTVSN(sb,i) == UDF_SB_PARTVSN(sb,j) &&
-						UDF_SB_PARTNUM(sb,i) == UDF_SB_PARTNUM(sb,j))
-					{
+					    UDF_SB_PARTVSN(sb,
+							   i) ==
+					    UDF_SB_PARTVSN(sb, j)
+					    && UDF_SB_PARTNUM(sb,
+							      i) ==
+					    UDF_SB_PARTNUM(sb, j)) {
 						ino.partitionReferenceNum = j;
-						ino.logicalBlockNum = UDF_SB_LASTBLOCK(sb) -
-							UDF_SB_PARTROOT(sb,j);
+						ino.logicalBlockNum =
+						    UDF_SB_LASTBLOCK(sb) -
+						    UDF_SB_PARTROOT(sb, j);
 						break;
 					}
 				}
@@ -1389,13 +1484,13 @@ udf_load_partition(struct super_block *s
 				if (!(UDF_SB_VAT(sb) = udf_iget(sb, ino)))
 					return 1;
 
-				if (UDF_SB_PARTTYPE(sb,i) == UDF_VIRTUAL_MAP15)
-				{
-					UDF_SB_TYPEVIRT(sb,i).s_start_offset = udf_ext0_offset(UDF_SB_VAT(sb));
-					UDF_SB_TYPEVIRT(sb,i).s_num_entries = (UDF_SB_VAT(sb)->i_size - 36) >> 2;
-				}
-				else if (UDF_SB_PARTTYPE(sb,i) == UDF_VIRTUAL_MAP20)
-				{
+				if (UDF_SB_PARTTYPE(sb, i) == UDF_VIRTUAL_MAP15) {
+					UDF_SB_TYPEVIRT(sb, i).s_start_offset =
+					    udf_ext0_offset(UDF_SB_VAT(sb));
+					UDF_SB_TYPEVIRT(sb, i).s_num_entries =
+					    (UDF_SB_VAT(sb)->i_size - 36) >> 2;
+				} else if (UDF_SB_PARTTYPE(sb, i) ==
+					   UDF_VIRTUAL_MAP20) {
 					struct buffer_head *bh = NULL;
 					uint32_t pos;
 
@@ -1403,15 +1498,26 @@ udf_load_partition(struct super_block *s
 					bh = sb_bread(sb, pos);
 					if (!bh)
 						return 1;
-					UDF_SB_TYPEVIRT(sb,i).s_start_offset =
-						le16_to_cpu(((struct virtualAllocationTable20 *)bh->b_data + udf_ext0_offset(UDF_SB_VAT(sb)))->lengthHeader) +
-							udf_ext0_offset(UDF_SB_VAT(sb));
-					UDF_SB_TYPEVIRT(sb,i).s_num_entries = (UDF_SB_VAT(sb)->i_size -
-						UDF_SB_TYPEVIRT(sb,i).s_start_offset) >> 2;
+					UDF_SB_TYPEVIRT(sb, i).s_start_offset =
+					    le16_to_cpu(((struct
+							  virtualAllocationTable20
+							  *)bh->b_data +
+							 udf_ext0_offset
+							 (UDF_SB_VAT(sb)))->
+							lengthHeader) +
+					    udf_ext0_offset(UDF_SB_VAT(sb));
+					UDF_SB_TYPEVIRT(sb, i).s_num_entries =
+					    (UDF_SB_VAT(sb)->i_size -
+					     UDF_SB_TYPEVIRT(sb,
+							     i).
+					     s_start_offset) >> 2;
 					brelse(bh);
 				}
-				UDF_SB_PARTROOT(sb,i) = udf_get_pblock(sb, 0, i, 0);
-				UDF_SB_PARTLEN(sb,i) = UDF_SB_PARTLEN(sb,ino.partitionReferenceNum);
+				UDF_SB_PARTROOT(sb, i) =
+				    udf_get_pblock(sb, 0, i, 0);
+				UDF_SB_PARTLEN(sb, i) =
+				    UDF_SB_PARTLEN(sb,
+						   ino.partitionReferenceNum);
 			}
 		}
 	}
@@ -1420,26 +1526,28 @@ udf_load_partition(struct super_block *s
 
 static void udf_open_lvid(struct super_block *sb)
 {
-	if (UDF_SB_LVIDBH(sb))
-	{
+	if (UDF_SB_LVIDBH(sb)) {
 		int i;
 		kernel_timestamp cpu_time;
 
 		UDF_SB_LVIDIU(sb)->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
 		UDF_SB_LVIDIU(sb)->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
 		if (udf_time_to_stamp(&cpu_time, CURRENT_TIME))
-			UDF_SB_LVID(sb)->recordingDateAndTime = cpu_to_lets(cpu_time);
+			UDF_SB_LVID(sb)->recordingDateAndTime =
+			    cpu_to_lets(cpu_time);
 		UDF_SB_LVID(sb)->integrityType = LVID_INTEGRITY_TYPE_OPEN;
 
 		UDF_SB_LVID(sb)->descTag.descCRC =
-			cpu_to_le16(udf_crc((char *)UDF_SB_LVID(sb) + sizeof(tag),
-			le16_to_cpu(UDF_SB_LVID(sb)->descTag.descCRCLength), 0));
+		    cpu_to_le16(udf_crc((char *)UDF_SB_LVID(sb) + sizeof(tag),
+					le16_to_cpu(UDF_SB_LVID(sb)->descTag.
+						    descCRCLength), 0));
 
 		UDF_SB_LVID(sb)->descTag.tagChecksum = 0;
-		for (i=0; i<16; i++)
+		for (i = 0; i < 16; i++)
 			if (i != 4)
 				UDF_SB_LVID(sb)->descTag.tagChecksum +=
-					((uint8_t *)&(UDF_SB_LVID(sb)->descTag))[i];
+				    ((uint8_t *) &
+				     (UDF_SB_LVID(sb)->descTag))[i];
 
 		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
 	}
@@ -1448,32 +1556,41 @@ static void udf_open_lvid(struct super_b
 static void udf_close_lvid(struct super_block *sb)
 {
 	if (UDF_SB_LVIDBH(sb) &&
-		UDF_SB_LVID(sb)->integrityType == LVID_INTEGRITY_TYPE_OPEN)
-	{
+	    UDF_SB_LVID(sb)->integrityType == LVID_INTEGRITY_TYPE_OPEN) {
 		int i;
 		kernel_timestamp cpu_time;
 
 		UDF_SB_LVIDIU(sb)->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
 		UDF_SB_LVIDIU(sb)->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
 		if (udf_time_to_stamp(&cpu_time, CURRENT_TIME))
-			UDF_SB_LVID(sb)->recordingDateAndTime = cpu_to_lets(cpu_time);
-		if (UDF_MAX_WRITE_VERSION > le16_to_cpu(UDF_SB_LVIDIU(sb)->maxUDFWriteRev))
-			UDF_SB_LVIDIU(sb)->maxUDFWriteRev = cpu_to_le16(UDF_MAX_WRITE_VERSION);
-		if (UDF_SB_UDFREV(sb) > le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFReadRev))
-			UDF_SB_LVIDIU(sb)->minUDFReadRev = cpu_to_le16(UDF_SB_UDFREV(sb));
-		if (UDF_SB_UDFREV(sb) > le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFWriteRev))
-			UDF_SB_LVIDIU(sb)->minUDFWriteRev = cpu_to_le16(UDF_SB_UDFREV(sb));
-		UDF_SB_LVID(sb)->integrityType = cpu_to_le32(LVID_INTEGRITY_TYPE_CLOSE);
+			UDF_SB_LVID(sb)->recordingDateAndTime =
+			    cpu_to_lets(cpu_time);
+		if (UDF_MAX_WRITE_VERSION >
+		    le16_to_cpu(UDF_SB_LVIDIU(sb)->maxUDFWriteRev))
+			UDF_SB_LVIDIU(sb)->maxUDFWriteRev =
+			    cpu_to_le16(UDF_MAX_WRITE_VERSION);
+		if (UDF_SB_UDFREV(sb) >
+		    le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFReadRev))
+			UDF_SB_LVIDIU(sb)->minUDFReadRev =
+			    cpu_to_le16(UDF_SB_UDFREV(sb));
+		if (UDF_SB_UDFREV(sb) >
+		    le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFWriteRev))
+			UDF_SB_LVIDIU(sb)->minUDFWriteRev =
+			    cpu_to_le16(UDF_SB_UDFREV(sb));
+		UDF_SB_LVID(sb)->integrityType =
+		    cpu_to_le32(LVID_INTEGRITY_TYPE_CLOSE);
 
 		UDF_SB_LVID(sb)->descTag.descCRC =
-			cpu_to_le16(udf_crc((char *)UDF_SB_LVID(sb) + sizeof(tag),
-			le16_to_cpu(UDF_SB_LVID(sb)->descTag.descCRCLength), 0));
+		    cpu_to_le16(udf_crc((char *)UDF_SB_LVID(sb) + sizeof(tag),
+					le16_to_cpu(UDF_SB_LVID(sb)->descTag.
+						    descCRCLength), 0));
 
 		UDF_SB_LVID(sb)->descTag.tagChecksum = 0;
-		for (i=0; i<16; i++)
+		for (i = 0; i < 16; i++)
 			if (i != 4)
 				UDF_SB_LVID(sb)->descTag.tagChecksum +=
-					((uint8_t *)&(UDF_SB_LVID(sb)->descTag))[i];
+				    ((uint8_t *) &
+				     (UDF_SB_LVID(sb)->descTag))[i];
 
 		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
 	}
@@ -1498,7 +1615,7 @@ static void udf_close_lvid(struct super_
 static int udf_fill_super(struct super_block *sb, void *options, int silent)
 {
 	int i;
-	struct inode *inode=NULL;
+	struct inode *inode = NULL;
 	struct udf_options uopt;
 	kernel_lb_addr rootdir, fileset;
 	struct udf_sb_info *sbi;
@@ -1520,15 +1637,13 @@ static int udf_fill_super(struct super_b
 		goto error_out;
 
 	if (uopt.flags & (1 << UDF_FLAG_UTF8) &&
-	    uopt.flags & (1 << UDF_FLAG_NLS_MAP))
-	{
+	    uopt.flags & (1 << UDF_FLAG_NLS_MAP)) {
 		udf_error(sb, "udf_read_super",
-			"utf8 cannot be combined with iocharset\n");
+			  "utf8 cannot be combined with iocharset\n");
 		goto error_out;
 	}
 #ifdef CONFIG_UDF_NLS
-	if ((uopt.flags & (1 << UDF_FLAG_NLS_MAP)) && !uopt.nls_map)
-	{
+	if ((uopt.flags & (1 << UDF_FLAG_NLS_MAP)) && !uopt.nls_map) {
 		uopt.nls_map = load_nls_default();
 		if (!uopt.nls_map)
 			uopt.flags &= ~(1 << UDF_FLAG_NLS_MAP);
@@ -1552,7 +1667,7 @@ static int udf_fill_super(struct super_b
 	if (!udf_set_blocksize(sb, uopt.blocksize))
 		goto error_out;
 
-	if ( uopt.session == 0xFFFFFFFF )
+	if (uopt.session == 0xFFFFFFFF)
 		UDF_SB_SESSION(sb) = udf_get_last_session(sb);
 	else
 		UDF_SB_SESSION(sb) = uopt.session;
@@ -1564,10 +1679,9 @@ static int udf_fill_super(struct super_b
 	UDF_SB_ANCHOR(sb)[2] = uopt.anchor;
 	UDF_SB_ANCHOR(sb)[3] = 256;
 
-	if (udf_check_valid(sb, uopt.novrs, silent)) /* read volume recognition sequences */
-	{
+	if (udf_check_valid(sb, uopt.novrs, silent)) {	/* read volume recognition sequences */
 		printk("UDF-fs: No VRS found\n");
- 		goto error_out;
+		goto error_out;
 	}
 
 	udf_find_anchor(sb);
@@ -1579,29 +1693,26 @@ static int udf_fill_super(struct super_b
 	sb->s_magic = UDF_SUPER_MAGIC;
 	sb->s_time_gran = 1000;
 
-	if (udf_load_partition(sb, &fileset))
-	{
+	if (udf_load_partition(sb, &fileset)) {
 		printk("UDF-fs: No partition found (1)\n");
 		goto error_out;
 	}
 
 	udf_debug("Lastblock=%d\n", UDF_SB_LASTBLOCK(sb));
 
-	if ( UDF_SB_LVIDBH(sb) )
-	{
-		uint16_t minUDFReadRev = le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFReadRev);
-		uint16_t minUDFWriteRev = le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFWriteRev);
+	if (UDF_SB_LVIDBH(sb)) {
+		uint16_t minUDFReadRev =
+		    le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFReadRev);
+		uint16_t minUDFWriteRev =
+		    le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFWriteRev);
 		/* uint16_t maxUDFWriteRev = le16_to_cpu(UDF_SB_LVIDIU(sb)->maxUDFWriteRev); */
 
-		if (minUDFReadRev > UDF_MAX_READ_VERSION)
-		{
+		if (minUDFReadRev > UDF_MAX_READ_VERSION) {
 			printk("UDF-fs: minUDFReadRev=%x (max is %x)\n",
-				le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFReadRev),
-				UDF_MAX_READ_VERSION);
+			       le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFReadRev),
+			       UDF_MAX_READ_VERSION);
 			goto error_out;
-		}
-		else if (minUDFWriteRev > UDF_MAX_WRITE_VERSION)
-		{
+		} else if (minUDFWriteRev > UDF_MAX_WRITE_VERSION) {
 			sb->s_flags |= MS_RDONLY;
 		}
 
@@ -1613,31 +1724,30 @@ static int udf_fill_super(struct super_b
 			UDF_SET_FLAG(sb, UDF_FLAG_USE_STREAMS);
 	}
 
-	if ( !UDF_SB_NUMPARTS(sb) )
-	{
+	if (!UDF_SB_NUMPARTS(sb)) {
 		printk("UDF-fs: No partition found (2)\n");
 		goto error_out;
 	}
 
-	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_READ_ONLY) {
-		printk("UDF-fs: Partition marked readonly; forcing readonly mount\n");
+	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) &
+	    UDF_PART_FLAG_READ_ONLY) {
+		printk
+		    ("UDF-fs: Partition marked readonly; forcing readonly mount\n");
 		sb->s_flags |= MS_RDONLY;
 	}
 
-	if ( udf_find_fileset(sb, &fileset, &rootdir) )
-	{
+	if (udf_find_fileset(sb, &fileset, &rootdir)) {
 		printk("UDF-fs: No fileset found\n");
 		goto error_out;
 	}
 
-	if (!silent)
-	{
+	if (!silent) {
 		kernel_timestamp ts;
 		udf_time_to_stamp(&ts, UDF_SB_RECORDTIME(sb));
-		udf_info("UDF %s (%s) Mounting volume '%s', timestamp %04u/%02u/%02u %02u:%02u (%x)\n",
-			UDFFS_VERSION, UDFFS_DATE,
-			UDF_SB_VOLIDENT(sb), ts.year, ts.month, ts.day, ts.hour, ts.minute,
-			ts.typeAndTimezone);
+		udf_info
+		    ("UDF %s (%s) Mounting volume '%s', timestamp %04u/%02u/%02u %02u:%02u (%x)\n",
+		     UDFFS_VERSION, UDFFS_DATE, UDF_SB_VOLIDENT(sb), ts.year,
+		     ts.month, ts.day, ts.hour, ts.minute, ts.typeAndTimezone);
 	}
 	if (!(sb->s_flags & MS_RDONLY))
 		udf_open_lvid(sb);
@@ -1645,18 +1755,16 @@ static int udf_fill_super(struct super_b
 	/* Assign the root inode */
 	/* assign inodes by physical block number */
 	/* perhaps it's not extensible enough, but for now ... */
-	inode = udf_iget(sb, rootdir); 
-	if (!inode)
-	{
+	inode = udf_iget(sb, rootdir);
+	if (!inode) {
 		printk("UDF-fs: Error in udf_iget, block=%d, partition=%d\n",
-			rootdir.logicalBlockNum, rootdir.partitionReferenceNum);
+		       rootdir.logicalBlockNum, rootdir.partitionReferenceNum);
 		goto error_out;
 	}
 
 	/* Allocate a dentry for the root inode */
 	sb->s_root = d_alloc_root(inode);
-	if (!sb->s_root)
-	{
+	if (!sb->s_root) {
 		printk("UDF-fs: Couldn't allocate root dentry\n");
 		iput(inode);
 		goto error_out;
@@ -1664,23 +1772,30 @@ static int udf_fill_super(struct super_b
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	return 0;
 
-error_out:
+      error_out:
 	if (UDF_SB_VAT(sb))
 		iput(UDF_SB_VAT(sb));
-	if (UDF_SB_NUMPARTS(sb))
-	{
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_TABLE)
-			iput(UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_table);
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_TABLE)
-			iput(UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_table);
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_BITMAP)
-			UDF_SB_FREE_BITMAP(sb,UDF_SB_PARTITION(sb),s_uspace);
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP)
-			UDF_SB_FREE_BITMAP(sb,UDF_SB_PARTITION(sb),s_fspace);
-		if (UDF_SB_PARTTYPE(sb, UDF_SB_PARTITION(sb)) == UDF_SPARABLE_MAP15)
-		{
-			for (i=0; i<4; i++)
-				brelse(UDF_SB_TYPESPAR(sb, UDF_SB_PARTITION(sb)).s_spar_map[i]);
+	if (UDF_SB_NUMPARTS(sb)) {
+		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) &
+		    UDF_PART_FLAG_UNALLOC_TABLE)
+			iput(UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_uspace.
+			     s_table);
+		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) &
+		    UDF_PART_FLAG_FREED_TABLE)
+			iput(UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_fspace.
+			     s_table);
+		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) &
+		    UDF_PART_FLAG_UNALLOC_BITMAP)
+			UDF_SB_FREE_BITMAP(sb, UDF_SB_PARTITION(sb), s_uspace);
+		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) &
+		    UDF_PART_FLAG_FREED_BITMAP)
+			UDF_SB_FREE_BITMAP(sb, UDF_SB_PARTITION(sb), s_fspace);
+		if (UDF_SB_PARTTYPE(sb, UDF_SB_PARTITION(sb)) ==
+		    UDF_SPARABLE_MAP15) {
+			for (i = 0; i < 4; i++)
+				brelse(UDF_SB_TYPESPAR
+				       (sb,
+					UDF_SB_PARTITION(sb)).s_spar_map[i]);
 		}
 	}
 #ifdef CONFIG_UDF_NLS
@@ -1697,32 +1812,31 @@ error_out:
 }
 
 void udf_error(struct super_block *sb, const char *function,
-	const char *fmt, ...)
+	       const char *fmt, ...)
 {
 	va_list args;
 
-	if (!(sb->s_flags & MS_RDONLY))
-	{
+	if (!(sb->s_flags & MS_RDONLY)) {
 		/* mark sb error */
 		sb->s_dirt = 1;
 	}
 	va_start(args, fmt);
 	vsnprintf(error_buf, sizeof(error_buf), fmt, args);
 	va_end(args);
-	printk (KERN_CRIT "UDF-fs error (device %s): %s: %s\n",
-		sb->s_id, function, error_buf);
+	printk(KERN_CRIT "UDF-fs error (device %s): %s: %s\n",
+	       sb->s_id, function, error_buf);
 }
 
 void udf_warning(struct super_block *sb, const char *function,
-	const char *fmt, ...)
+		 const char *fmt, ...)
 {
 	va_list args;
 
-	va_start (args, fmt);
+	va_start(args, fmt);
 	vsnprintf(error_buf, sizeof(error_buf), fmt, args);
 	va_end(args);
 	printk(KERN_WARNING "UDF-fs warning (device %s): %s: %s\n",
-		sb->s_id, function, error_buf);
+	       sb->s_id, function, error_buf);
 }
 
 /*
@@ -1738,27 +1852,33 @@ void udf_warning(struct super_block *sb,
  *	July 1, 1997 - Andrew E. Mileski
  *	Written, tested, and released.
  */
-static void
-udf_put_super(struct super_block *sb)
+static void udf_put_super(struct super_block *sb)
 {
 	int i;
 
 	if (UDF_SB_VAT(sb))
 		iput(UDF_SB_VAT(sb));
-	if (UDF_SB_NUMPARTS(sb))
-	{
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_TABLE)
-			iput(UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_table);
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_TABLE)
-			iput(UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_table);
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_BITMAP)
-			UDF_SB_FREE_BITMAP(sb,UDF_SB_PARTITION(sb),s_uspace);
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP)
-			UDF_SB_FREE_BITMAP(sb,UDF_SB_PARTITION(sb),s_fspace);
-		if (UDF_SB_PARTTYPE(sb, UDF_SB_PARTITION(sb)) == UDF_SPARABLE_MAP15)
-		{
-			for (i=0; i<4; i++)
-				brelse(UDF_SB_TYPESPAR(sb, UDF_SB_PARTITION(sb)).s_spar_map[i]);
+	if (UDF_SB_NUMPARTS(sb)) {
+		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) &
+		    UDF_PART_FLAG_UNALLOC_TABLE)
+			iput(UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_uspace.
+			     s_table);
+		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) &
+		    UDF_PART_FLAG_FREED_TABLE)
+			iput(UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_fspace.
+			     s_table);
+		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) &
+		    UDF_PART_FLAG_UNALLOC_BITMAP)
+			UDF_SB_FREE_BITMAP(sb, UDF_SB_PARTITION(sb), s_uspace);
+		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) &
+		    UDF_PART_FLAG_FREED_BITMAP)
+			UDF_SB_FREE_BITMAP(sb, UDF_SB_PARTITION(sb), s_fspace);
+		if (UDF_SB_PARTTYPE(sb, UDF_SB_PARTITION(sb)) ==
+		    UDF_SPARABLE_MAP15) {
+			for (i = 0; i < 4; i++)
+				brelse(UDF_SB_TYPESPAR
+				       (sb,
+					UDF_SB_PARTITION(sb)).s_spar_map[i]);
 		}
 	}
 #ifdef CONFIG_UDF_NLS
@@ -1786,8 +1906,7 @@ udf_put_super(struct super_block *sb)
  *	July 1, 1997 - Andrew E. Mileski
  *	Written, tested, and released.
  */
-static int
-udf_statfs(struct dentry *dentry, struct kstatfs *buf)
+static int udf_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
 
@@ -1797,11 +1916,12 @@ udf_statfs(struct dentry *dentry, struct
 	buf->f_bfree = udf_count_free(sb);
 	buf->f_bavail = buf->f_bfree;
 	buf->f_files = (UDF_SB_LVIDBH(sb) ?
-		(le32_to_cpu(UDF_SB_LVIDIU(sb)->numFiles) +
-		le32_to_cpu(UDF_SB_LVIDIU(sb)->numDirs)) : 0) + buf->f_bfree;
+			(le32_to_cpu(UDF_SB_LVIDIU(sb)->numFiles) +
+			 le32_to_cpu(UDF_SB_LVIDIU(sb)->numDirs)) : 0) +
+	    buf->f_bfree;
 	buf->f_ffree = buf->f_bfree;
 	/* __kernel_fsid_t f_fsid */
-	buf->f_namelen = UDF_NAME_LEN-2;
+	buf->f_namelen = UDF_NAME_LEN - 2;
 
 	return 0;
 }
@@ -1830,13 +1950,10 @@ udf_count_free_bitmap(struct super_block
 	loc.partitionReferenceNum = UDF_SB_PARTITION(sb);
 	bh = udf_read_ptagged(sb, loc, 0, &ident);
 
-	if (!bh)
-	{
+	if (!bh) {
 		printk(KERN_ERR "udf: udf_count_free failed\n");
 		goto out;
-	}
-	else if (ident != TAG_IDENT_SBD)
-	{
+	} else if (ident != TAG_IDENT_SBD) {
 		brelse(bh);
 		printk(KERN_ERR "udf: udf_count_free failed\n");
 		goto out;
@@ -1844,43 +1961,39 @@ udf_count_free_bitmap(struct super_block
 
 	bm = (struct spaceBitmapDesc *)bh->b_data;
 	bytes = le32_to_cpu(bm->numOfBytes);
-	index = sizeof(struct spaceBitmapDesc); /* offset in first block only */
-	ptr = (uint8_t *)bh->b_data;
+	index = sizeof(struct spaceBitmapDesc);	/* offset in first block only */
+	ptr = (uint8_t *) bh->b_data;
 
-	while ( bytes > 0 )
-	{
-		while ((bytes > 0) && (index < sb->s_blocksize))
-		{
+	while (bytes > 0) {
+		while ((bytes > 0) && (index < sb->s_blocksize)) {
 			value = ptr[index];
-			accum += udf_bitmap_lookup[ value & 0x0f ];
-			accum += udf_bitmap_lookup[ value >> 4 ];
+			accum += udf_bitmap_lookup[value & 0x0f];
+			accum += udf_bitmap_lookup[value >> 4];
 			index++;
 			bytes--;
 		}
-		if ( bytes )
-		{
+		if (bytes) {
 			brelse(bh);
 			newblock = udf_get_lb_pblock(sb, loc, ++block);
 			bh = udf_tread(sb, newblock);
-			if (!bh)
-			{
+			if (!bh) {
 				udf_debug("read failed\n");
 				goto out;
 			}
 			index = 0;
-			ptr = (uint8_t *)bh->b_data;
+			ptr = (uint8_t *) bh->b_data;
 		}
 	}
 	brelse(bh);
 
-out:
+      out:
 	unlock_kernel();
 
 	return accum;
 }
 
 static unsigned int
-udf_count_free_table(struct super_block *sb, struct inode * table)
+udf_count_free_table(struct super_block *sb, struct inode *table)
 {
 	unsigned int accum = 0;
 	uint32_t elen;
@@ -1902,17 +2015,17 @@ udf_count_free_table(struct super_block 
 
 	return accum;
 }
-	
-static unsigned int
-udf_count_free(struct super_block *sb)
+
+static unsigned int udf_count_free(struct super_block *sb)
 {
 	unsigned int accum = 0;
 
-	if (UDF_SB_LVIDBH(sb))
-	{
-		if (le32_to_cpu(UDF_SB_LVID(sb)->numOfPartitions) > UDF_SB_PARTITION(sb))
-		{
-			accum = le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[UDF_SB_PARTITION(sb)]);
+	if (UDF_SB_LVIDBH(sb)) {
+		if (le32_to_cpu(UDF_SB_LVID(sb)->numOfPartitions) >
+		    UDF_SB_PARTITION(sb)) {
+			accum =
+			    le32_to_cpu(UDF_SB_LVID(sb)->
+					freeSpaceTable[UDF_SB_PARTITION(sb)]);
 
 			if (accum == 0xFFFFFFFF)
 				accum = 0;
@@ -1922,28 +2035,40 @@ udf_count_free(struct super_block *sb)
 	if (accum)
 		return accum;
 
-	if (UDF_SB_PARTFLAGS(sb,UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_BITMAP)
-	{
-		accum += udf_count_free_bitmap(sb,
-			UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_bitmap);
-	}
-	if (UDF_SB_PARTFLAGS(sb,UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP)
-	{
-		accum += udf_count_free_bitmap(sb,
-			UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_bitmap);
+	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) &
+	    UDF_PART_FLAG_UNALLOC_BITMAP) {
+		accum +=
+		    udf_count_free_bitmap(sb,
+					  UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION
+							      (sb)].s_uspace.
+					  s_bitmap);
+	}
+	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) &
+	    UDF_PART_FLAG_FREED_BITMAP) {
+		accum +=
+		    udf_count_free_bitmap(sb,
+					  UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION
+							      (sb)].s_fspace.
+					  s_bitmap);
 	}
 	if (accum)
 		return accum;
 
-	if (UDF_SB_PARTFLAGS(sb,UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_TABLE)
-	{
-		accum += udf_count_free_table(sb,
-			UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_table);
-	}
-	if (UDF_SB_PARTFLAGS(sb,UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_TABLE)
-	{
-		accum += udf_count_free_table(sb,
-			UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_table);
+	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) &
+	    UDF_PART_FLAG_UNALLOC_TABLE) {
+		accum +=
+		    udf_count_free_table(sb,
+					 UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION
+							     (sb)].s_uspace.
+					 s_table);
+	}
+	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) &
+	    UDF_PART_FLAG_FREED_TABLE) {
+		accum +=
+		    udf_count_free_table(sb,
+					 UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION
+							     (sb)].s_fspace.
+					 s_table);
 	}
 
 	return accum;
diff -puN fs/udf/symlink.c~udf-coding-style-conversion-lindent fs/udf/symlink.c
--- a/fs/udf/symlink.c~udf-coding-style-conversion-lindent
+++ a/fs/udf/symlink.c
@@ -33,41 +33,40 @@
 #include <linux/buffer_head.h>
 #include "udf_i.h"
 
-static void udf_pc_to_char(struct super_block *sb, char *from, int fromlen, char *to)
+static void udf_pc_to_char(struct super_block *sb, char *from, int fromlen,
+			   char *to)
 {
 	struct pathComponent *pc;
 	int elen = 0;
 	char *p = to;
 
-	while (elen < fromlen)
-	{
+	while (elen < fromlen) {
 		pc = (struct pathComponent *)(from + elen);
-		switch (pc->componentType)
-		{
-			case 1:
-				if (pc->lengthComponentIdent == 0)
-				{
-					p = to;
-					*p++ = '/';
-				}
-				break;
-			case 3:
-				memcpy(p, "../", 3);
-				p += 3;
-				break;
-			case 4:
-				memcpy(p, "./", 2);
-				p += 2;
-				/* that would be . - just ignore */
-				break;
-			case 5:
-				p += udf_get_filename(sb, pc->componentIdent, p, pc->lengthComponentIdent);
+		switch (pc->componentType) {
+		case 1:
+			if (pc->lengthComponentIdent == 0) {
+				p = to;
 				*p++ = '/';
-				break;
+			}
+			break;
+		case 3:
+			memcpy(p, "../", 3);
+			p += 3;
+			break;
+		case 4:
+			memcpy(p, "./", 2);
+			p += 2;
+			/* that would be . - just ignore */
+			break;
+		case 5:
+			p += udf_get_filename(sb, pc->componentIdent, p,
+					      pc->lengthComponentIdent);
+			*p++ = '/';
+			break;
 		}
 		elen += sizeof(struct pathComponent) + pc->lengthComponentIdent;
 	}
-	if (p > to+1)
+	if (p > to + 1)
 		p[-1] = '\0';
 	else
 		p[0] = '\0';
@@ -84,8 +83,7 @@ static int udf_symlink_filler(struct fil
 	lock_kernel();
 	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB)
 		symlink = UDF_I_DATA(inode) + UDF_I_LENEATTR(inode);
-	else
-	{
+	else {
 		bh = sb_bread(inode->i_sb, udf_block_map(inode, 0));
 
 		if (!bh)
@@ -102,7 +100,7 @@ static int udf_symlink_filler(struct fil
 	kunmap(page);
 	unlock_page(page);
 	return 0;
-out:
+      out:
 	unlock_kernel();
 	SetPageError(page);
 	kunmap(page);
@@ -114,5 +112,5 @@ out:
  * symlinks can't do much...
  */
 const struct address_space_operations udf_symlink_aops = {
-	.readpage		= udf_symlink_filler,
+	.readpage = udf_symlink_filler,
 };
diff -puN fs/udf/truncate.c~udf-coding-style-conversion-lindent fs/udf/truncate.c
--- a/fs/udf/truncate.c~udf-coding-style-conversion-lindent
+++ a/fs/udf/truncate.c
@@ -28,35 +28,38 @@
 #include "udf_i.h"
 #include "udf_sb.h"
 
-static void extent_trunc(struct inode * inode, struct extent_position *epos,
-	kernel_lb_addr eloc, int8_t etype, uint32_t elen, uint32_t nelen)
+static void extent_trunc(struct inode *inode, struct extent_position *epos,
+			 kernel_lb_addr eloc, int8_t etype, uint32_t elen,
+			 uint32_t nelen)
 {
 	kernel_lb_addr neloc = { 0, 0 };
-	int last_block = (elen + inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits;
-	int first_block = (nelen + inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits;
-
-	if (nelen)
-	{
-		if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30))
-		{
-			udf_free_blocks(inode->i_sb, inode, eloc, 0, last_block);
+	int last_block =
+	    (elen + inode->i_sb->s_blocksize -
+	     1) >> inode->i_sb->s_blocksize_bits;
+	int first_block =
+	    (nelen + inode->i_sb->s_blocksize -
+	     1) >> inode->i_sb->s_blocksize_bits;
+
+	if (nelen) {
+		if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
+			udf_free_blocks(inode->i_sb, inode, eloc, 0,
+					last_block);
 			etype = (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30);
-		}
-		else
+		} else
 			neloc = eloc;
 		nelen = (etype << 30) | nelen;
 	}
 
-	if (elen != nelen)
-	{
+	if (elen != nelen) {
 		udf_write_aext(inode, epos, neloc, nelen, 0);
-		if (last_block - first_block > 0)
-		{
+		if (last_block - first_block > 0) {
 			if (etype == (EXT_RECORDED_ALLOCATED >> 30))
 				mark_inode_dirty(inode);
 
 			if (etype != (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30))
-				udf_free_blocks(inode->i_sb, inode, eloc, first_block, last_block - first_block);
+				udf_free_blocks(inode->i_sb, inode, eloc,
+						first_block,
+						last_block - first_block);
 		}
 	}
 }
@@ -67,7 +70,7 @@ static void extent_trunc(struct inode * 
  */
 void udf_truncate_tail_extent(struct inode *inode)
 {
-	struct extent_position epos = { NULL, 0, {0, 0}};
+	struct extent_position epos = { NULL, 0, {0, 0} };
 	kernel_lb_addr eloc;
 	uint32_t elen, nelen;
 	uint64_t lbcount = 0;
@@ -89,8 +92,7 @@ void udf_truncate_tail_extent(struct ino
 		BUG();
 
 	/* Find the last extent in the file */
-	while ((netype = udf_next_aext(inode, &epos, &eloc, &elen, 1)) != -1)
-	{
+	while ((netype = udf_next_aext(inode, &epos, &eloc, &elen, 1)) != -1) {
 		etype = netype;
 		lbcount += elen;
 		if (lbcount > inode->i_size) {
@@ -123,7 +125,7 @@ void udf_truncate_tail_extent(struct ino
 
 void udf_discard_prealloc(struct inode *inode)
 {
-	struct extent_position epos = { NULL, 0, {0, 0}};
+	struct extent_position epos = { NULL, 0, {0, 0} };
 	kernel_lb_addr eloc;
 	uint32_t elen;
 	uint64_t lbcount = 0;
@@ -131,7 +133,7 @@ void udf_discard_prealloc(struct inode *
 	int adsize;
 
 	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB ||
-		inode->i_size == UDF_I_LENEXTENTS(inode))
+	    inode->i_size == UDF_I_LENEXTENTS(inode))
 		return;
 
 	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_SHORT)
@@ -153,15 +155,21 @@ void udf_discard_prealloc(struct inode *
 		lbcount -= elen;
 		extent_trunc(inode, &epos, eloc, etype, elen, 0);
 		if (!epos.bh) {
-			UDF_I_LENALLOC(inode) = epos.offset - udf_file_entry_alloc_offset(inode);
+			UDF_I_LENALLOC(inode) =
+			    epos.offset - udf_file_entry_alloc_offset(inode);
 			mark_inode_dirty(inode);
 		} else {
-			struct allocExtDesc *aed = (struct allocExtDesc *)(epos.bh->b_data);
-			aed->lengthAllocDescs = cpu_to_le32(epos.offset - sizeof(struct allocExtDesc));
-			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) || UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
+			struct allocExtDesc *aed =
+			    (struct allocExtDesc *)(epos.bh->b_data);
+			aed->lengthAllocDescs =
+			    cpu_to_le32(epos.offset -
+					sizeof(struct allocExtDesc));
+			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT)
+			    || UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
 				udf_update_tag(epos.bh->b_data, epos.offset);
 			else
-				udf_update_tag(epos.bh->b_data, sizeof(struct allocExtDesc));
+				udf_update_tag(epos.bh->b_data,
+					       sizeof(struct allocExtDesc));
 			mark_buffer_dirty_inode(epos.bh, inode);
 		}
 	}
@@ -171,7 +179,7 @@ void udf_discard_prealloc(struct inode *
 	brelse(epos.bh);
 }
 
-void udf_truncate_extents(struct inode * inode)
+void udf_truncate_extents(struct inode *inode)
 {
 	struct extent_position epos;
 	kernel_lb_addr eloc, neloc = { 0, 0 };
@@ -190,9 +198,10 @@ void udf_truncate_extents(struct inode *
 		BUG();
 
 	etype = inode_bmap(inode, first_block, &epos, &eloc, &elen, &offset);
-	byte_offset = (offset << sb->s_blocksize_bits) + (inode->i_size & (sb->s_blocksize-1));
-	if (etype != -1)
-	{
+	byte_offset =
+	    (offset << sb->s_blocksize_bits) +
+	    (inode->i_size & (sb->s_blocksize - 1));
+	if (etype != -1) {
 		epos.offset -= adsize;
 		extent_trunc(inode, &epos, eloc, etype, elen, byte_offset);
 		epos.offset += adsize;
@@ -206,86 +215,98 @@ void udf_truncate_extents(struct inode *
 		else
 			lenalloc -= sizeof(struct allocExtDesc);
 
-		while ((etype = udf_current_aext(inode, &epos, &eloc, &elen, 0)) != -1)
-		{
-			if (etype == (EXT_NEXT_EXTENT_ALLOCDECS >> 30))
-			{
+		while ((etype =
+			udf_current_aext(inode, &epos, &eloc, &elen,
+					 0)) != -1) {
+			if (etype == (EXT_NEXT_EXTENT_ALLOCDECS >> 30)) {
 				udf_write_aext(inode, &epos, neloc, nelen, 0);
-				if (indirect_ext_len)
-				{
+				if (indirect_ext_len) {
 					/* We managed to free all extents in the
 					 * indirect extent - free it too */
 					if (!epos.bh)
 						BUG();
-					udf_free_blocks(sb, inode, epos.block, 0, indirect_ext_len);
-				}
-				else
-				{
-					if (!epos.bh)
-					{
-						UDF_I_LENALLOC(inode) = lenalloc;
+					udf_free_blocks(sb, inode, epos.block,
+							0, indirect_ext_len);
+				} else {
+					if (!epos.bh) {
+						UDF_I_LENALLOC(inode) =
+						    lenalloc;
 						mark_inode_dirty(inode);
-					}
-					else
-					{
-						struct allocExtDesc *aed = (struct allocExtDesc *)(epos.bh->b_data);
-						aed->lengthAllocDescs = cpu_to_le32(lenalloc);
-						if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT) || UDF_SB_UDFREV(sb) >= 0x0201)
-							udf_update_tag(epos.bh->b_data, lenalloc +
-								sizeof(struct allocExtDesc));
+					} else {
+						struct allocExtDesc *aed =
+						    (struct allocExtDesc
+						     *)(epos.bh->b_data);
+						aed->lengthAllocDescs =
+						    cpu_to_le32(lenalloc);
+						if (!UDF_QUERY_FLAG
+						    (sb, UDF_FLAG_STRICT)
+						    || UDF_SB_UDFREV(sb) >=
+						    0x0201)
+							udf_update_tag(epos.bh->
+								       b_data,
+								       lenalloc
+								       +
+								       sizeof
+								       (struct
+									allocExtDesc));
 						else
-							udf_update_tag(epos.bh->b_data, sizeof(struct allocExtDesc));
-						mark_buffer_dirty_inode(epos.bh, inode);
+							udf_update_tag(epos.bh->
+								       b_data,
+								       sizeof
+								       (struct
+									allocExtDesc));
+						mark_buffer_dirty_inode(epos.bh,
+									inode);
 					}
 				}
 				brelse(epos.bh);
 				epos.offset = sizeof(struct allocExtDesc);
 				epos.block = eloc;
-				epos.bh = udf_tread(sb, udf_get_lb_pblock(sb, eloc, 0));
+				epos.bh =
+				    udf_tread(sb,
+					      udf_get_lb_pblock(sb, eloc, 0));
 				if (elen)
 					indirect_ext_len = (elen +
-						sb->s_blocksize - 1) >>
-						sb->s_blocksize_bits;
+							    sb->s_blocksize -
+							    1) >> sb->
+					    s_blocksize_bits;
 				else
 					indirect_ext_len = 1;
-			}
-			else
-			{
-				extent_trunc(inode, &epos, eloc, etype, elen, 0);
+			} else {
+				extent_trunc(inode, &epos, eloc, etype, elen,
+					     0);
 				epos.offset += adsize;
 			}
 		}
 
-		if (indirect_ext_len)
-		{
+		if (indirect_ext_len) {
 			if (!epos.bh)
 				BUG();
-			udf_free_blocks(sb, inode, epos.block, 0, indirect_ext_len);
-		}
-		else
-		{
-			if (!epos.bh)
-			{
+			udf_free_blocks(sb, inode, epos.block, 0,
+					indirect_ext_len);
+		} else {
+			if (!epos.bh) {
 				UDF_I_LENALLOC(inode) = lenalloc;
 				mark_inode_dirty(inode);
-			}
-			else
-			{
-				struct allocExtDesc *aed = (struct allocExtDesc *)(epos.bh->b_data);
+			} else {
+				struct allocExtDesc *aed =
+				    (struct allocExtDesc *)(epos.bh->b_data);
 				aed->lengthAllocDescs = cpu_to_le32(lenalloc);
-				if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT) || UDF_SB_UDFREV(sb) >= 0x0201)
-					udf_update_tag(epos.bh->b_data, lenalloc +
-						sizeof(struct allocExtDesc));
+				if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT)
+				    || UDF_SB_UDFREV(sb) >= 0x0201)
+					udf_update_tag(epos.bh->b_data,
+						       lenalloc +
+						       sizeof(struct
+							      allocExtDesc));
 				else
-					udf_update_tag(epos.bh->b_data, sizeof(struct allocExtDesc));
+					udf_update_tag(epos.bh->b_data,
+						       sizeof(struct
+							      allocExtDesc));
 				mark_buffer_dirty_inode(epos.bh, inode);
 			}
 		}
-	}
-	else if (inode->i_size)
-	{
-		if (byte_offset)
-		{
+	} else if (inode->i_size) {
+		if (byte_offset) {
 			kernel_long_ad extent;
 
 			/*
@@ -293,21 +314,33 @@ void udf_truncate_extents(struct inode *
 			 *  no extent above inode->i_size => truncate is
 			 *  extending the file by 'offset' blocks.
 			 */
-			if ((!epos.bh && epos.offset == udf_file_entry_alloc_offset(inode)) ||
-			    (epos.bh && epos.offset == sizeof(struct allocExtDesc))) {
+			if ((!epos.bh
+			     && epos.offset ==
+			     udf_file_entry_alloc_offset(inode)) || (epos.bh
+								     && epos.
+								     offset ==
+								     sizeof
+								     (struct
+								      allocExtDesc)))
+			{
 				/* File has no extents at all or has empty last
 				 * indirect extent! Create a fake extent... */
 				extent.extLocation.logicalBlockNum = 0;
 				extent.extLocation.partitionReferenceNum = 0;
-				extent.extLength = EXT_NOT_RECORDED_NOT_ALLOCATED;
-			}
-			else {
+				extent.extLength =
+				    EXT_NOT_RECORDED_NOT_ALLOCATED;
+			} else {
 				epos.offset -= adsize;
 				etype = udf_next_aext(inode, &epos,
-					&extent.extLocation, &extent.extLength, 0);
+						      &extent.extLocation,
+						      &extent.extLength, 0);
 				extent.extLength |= etype << 30;
 			}
-			udf_extend_file(inode, &epos, &extent, offset+((inode->i_size & (sb->s_blocksize-1)) != 0));
+			udf_extend_file(inode, &epos, &extent,
+					offset +
+					((inode->
+					  i_size & (sb->s_blocksize - 1)) !=
+					 0));
 		}
 	}
 	UDF_I_LENEXTENTS(inode) = inode->i_size;
diff -puN fs/udf/udf_i.h~udf-coding-style-conversion-lindent fs/udf/udf_i.h
--- a/fs/udf/udf_i.h~udf-coding-style-conversion-lindent
+++ a/fs/udf/udf_i.h
@@ -23,4 +23,4 @@ static inline struct udf_inode_info *UDF
 #define UDF_I_LAD(X)		( UDF_I(X)->i_ext.i_lad )
 #define UDF_I_DATA(X)		( UDF_I(X)->i_ext.i_data )
 
-#endif /* !defined(_LINUX_UDF_I_H) */
+#endif				/* !defined(_LINUX_UDF_I_H) */
diff -puN fs/udf/udf_sb.h~udf-coding-style-conversion-lindent fs/udf/udf_sb.h
--- a/fs/udf/udf_sb.h~udf-coding-style-conversion-lindent
+++ a/fs/udf/udf_sb.h
@@ -20,8 +20,8 @@
 #define UDF_FLAG_VARCONV		8
 #define UDF_FLAG_NLS_MAP		9
 #define UDF_FLAG_UTF8			10
-#define UDF_FLAG_UID_FORGET     11    /* save -1 for uid to disk */
-#define UDF_FLAG_UID_IGNORE     12    /* use sb uid instead of on disk uid */
+#define UDF_FLAG_UID_FORGET     11	/* save -1 for uid to disk */
+#define UDF_FLAG_UID_IGNORE     12	/* use sb uid instead of on disk uid */
 #define UDF_FLAG_GID_FORGET     13
 #define UDF_FLAG_GID_IGNORE     14
 
@@ -139,4 +139,4 @@ static inline struct udf_sb_info *UDF_SB
 #define UDF_SB_FLAGS(X)				( UDF_SB(X)->s_flags )
 #define UDF_SB_VAT(X)				( UDF_SB(X)->s_vat )
 
-#endif /* __LINUX_UDF_SB_H */
+#endif				/* __LINUX_UDF_SB_H */
diff -puN fs/udf/udfdecl.h~udf-coding-style-conversion-lindent fs/udf/udfdecl.h
--- a/fs/udf/udfdecl.h~udf-coding-style-conversion-lindent
+++ a/fs/udf/udfdecl.h
@@ -50,30 +50,26 @@ extern const struct address_space_operat
 extern const struct address_space_operations udf_adinicb_aops;
 extern const struct address_space_operations udf_symlink_aops;
 
-struct udf_fileident_bh
-{
+struct udf_fileident_bh {
 	struct buffer_head *sbh;
 	struct buffer_head *ebh;
 	int soffset;
 	int eoffset;
 };
 
-struct udf_vds_record
-{
+struct udf_vds_record {
 	uint32_t block;
 	uint32_t volDescSeqNum;
 };
 
-struct generic_desc
-{
-	tag		descTag;
-	__le32		volDescSeqNum;
+struct generic_desc {
+	tag descTag;
+	__le32 volDescSeqNum;
 };
 
-struct ustr
-{
+struct ustr {
 	uint8_t u_cmpID;
-	uint8_t u_name[UDF_NAME_LEN-2];
+	uint8_t u_name[UDF_NAME_LEN - 2];
 	uint8_t u_len;
 };
 
@@ -83,44 +79,58 @@ struct extent_position {
 	kernel_lb_addr block;
 };
 
-
 /* super.c */
 extern void udf_error(struct super_block *, const char *, const char *, ...);
 extern void udf_warning(struct super_block *, const char *, const char *, ...);
 
 /* namei.c */
-extern int udf_write_fi(struct inode *inode, struct fileIdentDesc *, struct fileIdentDesc *, struct udf_fileident_bh *, uint8_t *, uint8_t *);
+extern int udf_write_fi(struct inode *inode, struct fileIdentDesc *,
+			struct fileIdentDesc *, struct udf_fileident_bh *,
+			uint8_t *, uint8_t *);
 
 /* file.c */
-extern int udf_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
+extern int udf_ioctl(struct inode *, struct file *, unsigned int,
+		     unsigned long);
 
 /* inode.c */
 extern struct inode *udf_iget(struct super_block *, kernel_lb_addr);
 extern int udf_sync_inode(struct inode *);
 extern void udf_expand_file_adinicb(struct inode *, int, int *);
-extern struct buffer_head * udf_expand_dir_adinicb(struct inode *, int *, int *);
-extern struct buffer_head * udf_bread(struct inode *, int, int, int *);
+extern struct buffer_head *udf_expand_dir_adinicb(struct inode *, int *, int *);
+extern struct buffer_head *udf_bread(struct inode *, int, int, int *);
 extern void udf_truncate(struct inode *);
 extern void udf_read_inode(struct inode *);
 extern void udf_delete_inode(struct inode *);
 extern void udf_clear_inode(struct inode *);
 extern int udf_write_inode(struct inode *, int);
 extern long udf_block_map(struct inode *, sector_t);
-extern int udf_extend_file(struct inode *, struct extent_position *, kernel_long_ad *, sector_t);
-extern int8_t inode_bmap(struct inode *, sector_t, struct extent_position *, kernel_lb_addr *, uint32_t *, sector_t *);
-extern int8_t udf_add_aext(struct inode *, struct extent_position *, kernel_lb_addr, uint32_t, int);
-extern int8_t udf_write_aext(struct inode *, struct extent_position *, kernel_lb_addr, uint32_t, int);
-extern int8_t udf_delete_aext(struct inode *, struct extent_position, kernel_lb_addr, uint32_t);
-extern int8_t udf_next_aext(struct inode *, struct extent_position *, kernel_lb_addr *, uint32_t *, int);
-extern int8_t udf_current_aext(struct inode *, struct extent_position *, kernel_lb_addr *, uint32_t *, int);
+extern int udf_extend_file(struct inode *, struct extent_position *,
+			   kernel_long_ad *, sector_t);
+extern int8_t inode_bmap(struct inode *, sector_t, struct extent_position *,
+			 kernel_lb_addr *, uint32_t *, sector_t *);
+extern int8_t udf_add_aext(struct inode *, struct extent_position *,
+			   kernel_lb_addr, uint32_t, int);
+extern int8_t udf_write_aext(struct inode *, struct extent_position *,
+			     kernel_lb_addr, uint32_t, int);
+extern int8_t udf_delete_aext(struct inode *, struct extent_position,
+			      kernel_lb_addr, uint32_t);
+extern int8_t udf_next_aext(struct inode *, struct extent_position *,
+			    kernel_lb_addr *, uint32_t *, int);
+extern int8_t udf_current_aext(struct inode *, struct extent_position *,
+			       kernel_lb_addr *, uint32_t *, int);
 
 /* misc.c */
 extern struct buffer_head *udf_tgetblk(struct super_block *, int);
 extern struct buffer_head *udf_tread(struct super_block *, int);
-extern struct genericFormat *udf_add_extendedattr(struct inode *, uint32_t, uint32_t, uint8_t);
-extern struct genericFormat *udf_get_extendedattr(struct inode *, uint32_t, uint8_t);
-extern struct buffer_head *udf_read_tagged(struct super_block *, uint32_t, uint32_t, uint16_t *);
-extern struct buffer_head *udf_read_ptagged(struct super_block *, kernel_lb_addr, uint32_t, uint16_t *);
+extern struct genericFormat *udf_add_extendedattr(struct inode *, uint32_t,
+						  uint32_t, uint8_t);
+extern struct genericFormat *udf_get_extendedattr(struct inode *, uint32_t,
+						  uint8_t);
+extern struct buffer_head *udf_read_tagged(struct super_block *, uint32_t,
+					   uint32_t, uint16_t *);
+extern struct buffer_head *udf_read_ptagged(struct super_block *,
+					    kernel_lb_addr, uint32_t,
+					    uint16_t *);
 extern void udf_update_tag(char *, int);
 extern void udf_new_tag(char *, uint16_t, uint16_t, uint16_t, uint32_t, int);
 
@@ -129,21 +139,26 @@ extern unsigned int udf_get_last_session
 extern unsigned long udf_get_last_block(struct super_block *);
 
 /* partition.c */
-extern uint32_t udf_get_pblock(struct super_block *, uint32_t, uint16_t, uint32_t);
-extern uint32_t udf_get_pblock_virt15(struct super_block *, uint32_t, uint16_t, uint32_t);
-extern uint32_t udf_get_pblock_virt20(struct super_block *, uint32_t, uint16_t, uint32_t);
-extern uint32_t udf_get_pblock_spar15(struct super_block *, uint32_t, uint16_t, uint32_t);
+extern uint32_t udf_get_pblock(struct super_block *, uint32_t, uint16_t,
+			       uint32_t);
+extern uint32_t udf_get_pblock_virt15(struct super_block *, uint32_t, uint16_t,
+				      uint32_t);
+extern uint32_t udf_get_pblock_virt20(struct super_block *, uint32_t, uint16_t,
+				      uint32_t);
+extern uint32_t udf_get_pblock_spar15(struct super_block *, uint32_t, uint16_t,
+				      uint32_t);
 extern int udf_relocate_blocks(struct super_block *, long, long *);
 
 /* unicode.c */
 extern int udf_get_filename(struct super_block *, uint8_t *, uint8_t *, int);
-extern int udf_put_filename(struct super_block *, const uint8_t *, uint8_t *, int);
+extern int udf_put_filename(struct super_block *, const uint8_t *, uint8_t *,
+			    int);
 extern int udf_build_ustr(struct ustr *, dstring *, int);
 extern int udf_CS0toUTF8(struct ustr *, struct ustr *);
 
 /* ialloc.c */
 extern void udf_free_inode(struct inode *);
-extern struct inode * udf_new_inode (struct inode *, int, int *);
+extern struct inode *udf_new_inode(struct inode *, int, int *);
 
 /* truncate.c */
 extern void udf_truncate_tail_extent(struct inode *);
@@ -151,18 +166,27 @@ extern void udf_discard_prealloc(struct 
 extern void udf_truncate_extents(struct inode *);
 
 /* balloc.c */
-extern void udf_free_blocks(struct super_block *, struct inode *, kernel_lb_addr, uint32_t, uint32_t);
-extern int udf_prealloc_blocks(struct super_block *, struct inode *, uint16_t, uint32_t, uint32_t);
-extern int udf_new_block(struct super_block *, struct inode *, uint16_t, uint32_t, int *);
+extern void udf_free_blocks(struct super_block *, struct inode *,
+			    kernel_lb_addr, uint32_t, uint32_t);
+extern int udf_prealloc_blocks(struct super_block *, struct inode *, uint16_t,
+			       uint32_t, uint32_t);
+extern int udf_new_block(struct super_block *, struct inode *, uint16_t,
+			 uint32_t, int *);
 
 /* fsync.c */
 extern int udf_fsync_file(struct file *, struct dentry *, int);
 
 /* directory.c */
-extern struct fileIdentDesc * udf_fileident_read(struct inode *, loff_t *, struct udf_fileident_bh *, struct fileIdentDesc *, struct extent_position *, kernel_lb_addr *, uint32_t *, sector_t *);
-extern struct fileIdentDesc * udf_get_fileident(void * buffer, int bufsize, int * offset);
-extern long_ad * udf_get_filelongad(uint8_t *, int, int *, int);
-extern short_ad * udf_get_fileshortad(uint8_t *, int, int *, int);
+extern struct fileIdentDesc *udf_fileident_read(struct inode *, loff_t *,
+						struct udf_fileident_bh *,
+						struct fileIdentDesc *,
+						struct extent_position *,
+						kernel_lb_addr *, uint32_t *,
+						sector_t *);
+extern struct fileIdentDesc *udf_get_fileident(void *buffer, int bufsize,
+					       int *offset);
+extern long_ad *udf_get_filelongad(uint8_t *, int, int *, int);
+extern short_ad *udf_get_fileshortad(uint8_t *, int, int *, int);
 
 /* crc.c */
 extern uint16_t udf_crc(uint8_t *, uint32_t, uint16_t);
@@ -171,4 +195,4 @@ extern uint16_t udf_crc(uint8_t *, uint3
 extern time_t *udf_stamp_to_time(time_t *, long *, kernel_timestamp);
 extern kernel_timestamp *udf_time_to_stamp(kernel_timestamp *, struct timespec);
 
-#endif /* __UDF_DECL_H */
+#endif				/* __UDF_DECL_H */
diff -puN fs/udf/udfend.h~udf-coding-style-conversion-lindent fs/udf/udfend.h
--- a/fs/udf/udfend.h~udf-coding-style-conversion-lindent
+++ a/fs/udf/udfend.h
@@ -78,4 +78,4 @@ static inline timestamp cpu_to_lets(kern
 	return out;
 }
 
-#endif /* __UDF_ENDIAN_H */
+#endif				/* __UDF_ENDIAN_H */
diff -puN fs/udf/udftime.c~udf-coding-style-conversion-lindent fs/udf/udftime.c
--- a/fs/udf/udftime.c~udf-coding-style-conversion-lindent
+++ a/fs/udf/udftime.c
@@ -46,37 +46,36 @@
 #endif
 
 /* How many days come before each month (0-12).  */
-static const unsigned short int __mon_yday[2][13] =
-{
+static const unsigned short int __mon_yday[2][13] = {
 	/* Normal years.  */
-	{ 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365 },
+	{0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365},
 	/* Leap years.  */
-	{ 0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366 }
+	{0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366}
 };
 
 #define MAX_YEAR_SECONDS	69
-#define SPD 0x15180 /*3600*24*/
+#define SPD 0x15180		/*3600*24 */
 #define SPY(y,l,s) (SPD * (365*y+l)+s)
 
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
+/*1970*/ SPY(0, 0, 0), SPY(1, 0, 0), SPY(2, 0, 0), SPY(3, 1, 0),
+/*1974*/ SPY(4, 1, 0), SPY(5, 1, 0), SPY(6, 1, 0), SPY(7, 2, 0),
+/*1978*/ SPY(8, 2, 0), SPY(9, 2, 0), SPY(10, 2, 0), SPY(11, 3, 0),
+/*1982*/ SPY(12, 3, 0), SPY(13, 3, 0), SPY(14, 3, 0), SPY(15, 4, 0),
+/*1986*/ SPY(16, 4, 0), SPY(17, 4, 0), SPY(18, 4, 0), SPY(19, 5, 0),
+/*1990*/ SPY(20, 5, 0), SPY(21, 5, 0), SPY(22, 5, 0), SPY(23, 6, 0),
+/*1994*/ SPY(24, 6, 0), SPY(25, 6, 0), SPY(26, 6, 0), SPY(27, 7, 0),
+/*1998*/ SPY(28, 7, 0), SPY(29, 7, 0), SPY(30, 7, 0), SPY(31, 8, 0),
+/*2002*/ SPY(32, 8, 0), SPY(33, 8, 0), SPY(34, 8, 0), SPY(35, 9, 0),
+/*2006*/ SPY(36, 9, 0), SPY(37, 9, 0), SPY(38, 9, 0), SPY(39, 10, 0),
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
@@ -84,27 +83,23 @@ extern struct timezone sys_tz;
 #define SECS_PER_HOUR	(60 * 60)
 #define SECS_PER_DAY	(SECS_PER_HOUR * 24)
 
-time_t *
-udf_stamp_to_time(time_t *dest, long *dest_usec, kernel_timestamp src)
+time_t *udf_stamp_to_time(time_t * dest, long *dest_usec, kernel_timestamp src)
 {
 	int yday;
 	uint8_t type = src.typeAndTimezone >> 12;
 	int16_t offset;
 
-	if (type == 1)
-	{
+	if (type == 1) {
 		offset = src.typeAndTimezone << 4;
 		/* sign extent offset */
 		offset = (offset >> 4);
-		if (offset == -2047) /* unspecified offset */
+		if (offset == -2047)	/* unspecified offset */
 			offset = 0;
-	}
-	else
+	} else
 		offset = 0;
 
 	if ((src.year < EPOCH_YEAR) ||
-		(src.year >= EPOCH_YEAR+MAX_YEAR_SECONDS))
-	{
+	    (src.year >= EPOCH_YEAR + MAX_YEAR_SECONDS)) {
 		*dest = -1;
 		*dest_usec = -1;
 		return NULL;
@@ -112,16 +107,16 @@ udf_stamp_to_time(time_t *dest, long *de
 	*dest = year_seconds[src.year - EPOCH_YEAR];
 	*dest -= offset * 60;
 
-	yday = ((__mon_yday[__isleap (src.year)]
-		[src.month-1]) + (src.day-1));
-	*dest += ( ( (yday* 24) + src.hour ) * 60 + src.minute ) * 60 + src.second;
-	*dest_usec = src.centiseconds * 10000 + src.hundredsOfMicroseconds * 100 + src.microseconds;
+	yday = ((__mon_yday[__isleap(src.year)]
+		 [src.month - 1]) + (src.day - 1));
+	*dest += (((yday * 24) + src.hour) * 60 + src.minute) * 60 + src.second;
+	*dest_usec =
+	    src.centiseconds * 10000 + src.hundredsOfMicroseconds * 100 +
+	    src.microseconds;
 	return dest;
 }
 
-
-kernel_timestamp *
-udf_time_to_stamp(kernel_timestamp *dest, struct timespec ts)
+kernel_timestamp *udf_time_to_stamp(kernel_timestamp * dest, struct timespec ts)
 {
 	long int days, rem, y;
 	const unsigned short int *ip;
@@ -146,28 +141,28 @@ udf_time_to_stamp(kernel_timestamp *dest
 #define DIV(a,b) ((a) / (b) - ((a) % (b) < 0))
 #define LEAPS_THRU_END_OF(y) (DIV (y, 4) - DIV (y, 100) + DIV (y, 400))
 
-	while (days < 0 || days >= (__isleap(y) ? 366 : 365))
-	{
+	while (days < 0 || days >= (__isleap(y) ? 366 : 365)) {
 		long int yg = y + days / 365 - (days % 365 < 0);
 
 		/* Adjust DAYS and Y to match the guessed year.  */
-		days -= ((yg - y) * 365
-			+ LEAPS_THRU_END_OF (yg - 1)
-			- LEAPS_THRU_END_OF (y - 1));
+		days -= ((yg - y) * 365 + LEAPS_THRU_END_OF(yg - 1)
+			 - LEAPS_THRU_END_OF(y - 1));
 		y = yg;
 	}
 	dest->year = y;
 	ip = __mon_yday[__isleap(y)];
-	for (y = 11; days < (long int) ip[y]; --y)
+	for (y = 11; days < (long int)ip[y]; --y)
 		continue;
 	days -= ip[y];
 	dest->month = y + 1;
 	dest->day = days + 1;
 
 	dest->centiseconds = ts.tv_nsec / 10000000;
-	dest->hundredsOfMicroseconds = (ts.tv_nsec / 1000 - dest->centiseconds * 10000) / 100;
-	dest->microseconds = (ts.tv_nsec / 1000 - dest->centiseconds * 10000 -
-		dest->hundredsOfMicroseconds * 100);
+	dest->hundredsOfMicroseconds =
+	    (ts.tv_nsec / 1000 - dest->centiseconds * 10000) / 100;
+	dest->microseconds =
+	    (ts.tv_nsec / 1000 - dest->centiseconds * 10000 -
+	     dest->hundredsOfMicroseconds * 100);
 	return dest;
 }
 
diff -puN fs/udf/unicode.c~udf-coding-style-conversion-lindent fs/udf/unicode.c
--- a/fs/udf/unicode.c~udf-coding-style-conversion-lindent
+++ a/fs/udf/unicode.c
@@ -29,9 +29,9 @@
 
 static int udf_translate_to_linux(uint8_t *, uint8_t *, int, uint8_t *, int);
 
-static int udf_char_to_ustr(struct ustr *dest, const uint8_t *src, int strlen)
+static int udf_char_to_ustr(struct ustr *dest, const uint8_t * src, int strlen)
 {
-	if ( (!dest) || (!src) || (!strlen) || (strlen > UDF_NAME_LEN-2) )
+	if ((!dest) || (!src) || (!strlen) || (strlen > UDF_NAME_LEN - 2))
 		return 0;
 	memset(dest, 0, sizeof(struct ustr));
 	memcpy(dest->u_name, src, strlen);
@@ -43,33 +43,33 @@ static int udf_char_to_ustr(struct ustr 
 /*
  * udf_build_ustr
  */
-int udf_build_ustr(struct ustr *dest, dstring *ptr, int size)
+int udf_build_ustr(struct ustr *dest, dstring * ptr, int size)
 {
 	int usesize;
 
-	if ( (!dest) || (!ptr) || (!size) )
+	if ((!dest) || (!ptr) || (!size))
 		return -1;
 
 	memset(dest, 0, sizeof(struct ustr));
-	usesize= (size > UDF_NAME_LEN) ? UDF_NAME_LEN : size;
-	dest->u_cmpID=ptr[0];
-	dest->u_len=ptr[size-1];
-	memcpy(dest->u_name, ptr+1, usesize-1);
+	usesize = (size > UDF_NAME_LEN) ? UDF_NAME_LEN : size;
+	dest->u_cmpID = ptr[0];
+	dest->u_len = ptr[size - 1];
+	memcpy(dest->u_name, ptr + 1, usesize - 1);
 	return 0;
 }
 
 /*
  * udf_build_ustr_exact
  */
-static int udf_build_ustr_exact(struct ustr *dest, dstring *ptr, int exactsize)
+static int udf_build_ustr_exact(struct ustr *dest, dstring * ptr, int exactsize)
 {
-	if ( (!dest) || (!ptr) || (!exactsize) )
+	if ((!dest) || (!ptr) || (!exactsize))
 		return -1;
 
 	memset(dest, 0, sizeof(struct ustr));
-	dest->u_cmpID=ptr[0];
-	dest->u_len=exactsize-1;
-	memcpy(dest->u_name, ptr+1, exactsize-1);
+	dest->u_cmpID = ptr[0];
+	dest->u_len = exactsize - 1;
+	memcpy(dest->u_name, ptr + 1, exactsize - 1);
 	return 0;
 }
 
@@ -108,22 +108,20 @@ int udf_CS0toUTF8(struct ustr *utf_o, st
 	cmp_id = ocu_i->u_cmpID;
 	utf_o->u_len = 0;
 
-	if (ocu_len == 0)
-	{
+	if (ocu_len == 0) {
 		memset(utf_o, 0, sizeof(struct ustr));
 		utf_o->u_cmpID = 0;
 		utf_o->u_len = 0;
 		return 0;
 	}
 
-	if ((cmp_id != 8) && (cmp_id != 16))
-	{
-		printk(KERN_ERR "udf: unknown compression code (%d) stri=%s\n", cmp_id, ocu_i->u_name);
+	if ((cmp_id != 8) && (cmp_id != 16)) {
+		printk(KERN_ERR "udf: unknown compression code (%d) stri=%s\n",
+		       cmp_id, ocu_i->u_name);
 		return 0;
 	}
 
-	for (i = 0; (i < ocu_len) && (utf_o->u_len <= (UDF_NAME_LEN-3)) ;)
-	{
+	for (i = 0; (i < ocu_len) && (utf_o->u_len <= (UDF_NAME_LEN - 3));) {
 
 		/* Expand OSTA compressed Unicode to Unicode */
 		c = ocu[i++];
@@ -132,20 +130,22 @@ int udf_CS0toUTF8(struct ustr *utf_o, st
 
 		/* Compress Unicode to UTF-8 */
 		if (c < 0x80U)
-			utf_o->u_name[utf_o->u_len++] = (uint8_t)c;
-		else if (c < 0x800U)
-		{
-			utf_o->u_name[utf_o->u_len++] = (uint8_t)(0xc0 | (c >> 6));
-			utf_o->u_name[utf_o->u_len++] = (uint8_t)(0x80 | (c & 0x3f));
-		}
-		else
-		{
-			utf_o->u_name[utf_o->u_len++] = (uint8_t)(0xe0 | (c >> 12));
-			utf_o->u_name[utf_o->u_len++] = (uint8_t)(0x80 | ((c >> 6) & 0x3f));
-			utf_o->u_name[utf_o->u_len++] = (uint8_t)(0x80 | (c & 0x3f));
+			utf_o->u_name[utf_o->u_len++] = (uint8_t) c;
+		else if (c < 0x800U) {
+			utf_o->u_name[utf_o->u_len++] =
+			    (uint8_t) (0xc0 | (c >> 6));
+			utf_o->u_name[utf_o->u_len++] =
+			    (uint8_t) (0x80 | (c & 0x3f));
+		} else {
+			utf_o->u_name[utf_o->u_len++] =
+			    (uint8_t) (0xe0 | (c >> 12));
+			utf_o->u_name[utf_o->u_len++] =
+			    (uint8_t) (0x80 | ((c >> 6) & 0x3f));
+			utf_o->u_name[utf_o->u_len++] =
+			    (uint8_t) (0x80 | (c & 0x3f));
 		}
 	}
-	utf_o->u_cmpID=8;
+	utf_o->u_cmpID = 8;
 
 	return utf_o->u_len;
 }
@@ -173,7 +173,7 @@ int udf_CS0toUTF8(struct ustr *utf_o, st
  *	November 12, 1997 - Andrew E. Mileski
  *	Written, tested, and released.
  */
-static int udf_UTF8toCS0(dstring *ocu, struct ustr *utf, int length)
+static int udf_UTF8toCS0(dstring * ocu, struct ustr *utf, int length)
 {
 	unsigned c, i, max_val, utf_char;
 	int utf_cnt, u_len;
@@ -182,53 +182,38 @@ static int udf_UTF8toCS0(dstring *ocu, s
 	ocu[0] = 8;
 	max_val = 0xffU;
 
-try_again:
+      try_again:
 	u_len = 0U;
 	utf_char = 0U;
 	utf_cnt = 0U;
-	for (i = 0U; i < utf->u_len; i++)
-	{
-		c = (uint8_t)utf->u_name[i];
+	for (i = 0U; i < utf->u_len; i++) {
+		c = (uint8_t) utf->u_name[i];
 
 		/* Complete a multi-byte UTF-8 character */
-		if (utf_cnt)
-		{
+		if (utf_cnt) {
 			utf_char = (utf_char << 6) | (c & 0x3fU);
 			if (--utf_cnt)
 				continue;
-		}
-		else
-		{
+		} else {
 			/* Check for a multi-byte UTF-8 character */
-			if (c & 0x80U)
-			{
+			if (c & 0x80U) {
 				/* Start a multi-byte UTF-8 character */
-				if ((c & 0xe0U) == 0xc0U)
-				{
+				if ((c & 0xe0U) == 0xc0U) {
 					utf_char = c & 0x1fU;
 					utf_cnt = 1;
-				}
-				else if ((c & 0xf0U) == 0xe0U)
-				{
+				} else if ((c & 0xf0U) == 0xe0U) {
 					utf_char = c & 0x0fU;
 					utf_cnt = 2;
-				}
-				else if ((c & 0xf8U) == 0xf0U)
-				{
+				} else if ((c & 0xf8U) == 0xf0U) {
 					utf_char = c & 0x07U;
 					utf_cnt = 3;
-				}
-				else if ((c & 0xfcU) == 0xf8U)
-				{
+				} else if ((c & 0xfcU) == 0xf8U) {
 					utf_char = c & 0x03U;
 					utf_cnt = 4;
-				}
-				else if ((c & 0xfeU) == 0xfcU)
-				{
+				} else if ((c & 0xfeU) == 0xfcU) {
 					utf_char = c & 0x01U;
 					utf_cnt = 5;
-				}
-				else
+				} else
 					goto error_out;
 				continue;
 			} else
@@ -237,37 +222,33 @@ try_again:
 		}
 
 		/* Choose no compression if necessary */
-		if (utf_char > max_val)
-		{
-			if ( 0xffU == max_val )
-			{
+		if (utf_char > max_val) {
+			if (0xffU == max_val) {
 				max_val = 0xffffU;
-				ocu[0] = (uint8_t)0x10U;
+				ocu[0] = (uint8_t) 0x10U;
 				goto try_again;
 			}
 			goto error_out;
 		}
 
-		if (max_val == 0xffffU)
-		{
-			ocu[++u_len] = (uint8_t)(utf_char >> 8);
+		if (max_val == 0xffffU) {
+			ocu[++u_len] = (uint8_t) (utf_char >> 8);
 		}
-		ocu[++u_len] = (uint8_t)(utf_char & 0xffU);
+		ocu[++u_len] = (uint8_t) (utf_char & 0xffU);
 	}
 
-
-	if (utf_cnt)
-	{
-error_out:
+	if (utf_cnt) {
+	      error_out:
 		ocu[++u_len] = '?';
 		printk(KERN_DEBUG "udf: bad UTF-8 character\n");
 	}
 
-	ocu[length - 1] = (uint8_t)u_len + 1;
+	ocu[length - 1] = (uint8_t) u_len + 1;
 	return u_len + 1;
 }
 
-static int udf_CS0toNLS(struct nls_table *nls, struct ustr *utf_o, struct ustr *ocu_i)
+static int udf_CS0toNLS(struct nls_table *nls, struct ustr *utf_o,
+			struct ustr *ocu_i)
 {
 	uint8_t *ocu;
 	uint32_t c;
@@ -280,36 +261,35 @@ static int udf_CS0toNLS(struct nls_table
 	cmp_id = ocu_i->u_cmpID;
 	utf_o->u_len = 0;
 
-	if (ocu_len == 0)
-	{
+	if (ocu_len == 0) {
 		memset(utf_o, 0, sizeof(struct ustr));
 		utf_o->u_cmpID = 0;
 		utf_o->u_len = 0;
 		return 0;
 	}
 
-	if ((cmp_id != 8) && (cmp_id != 16))
-	{
-		printk(KERN_ERR "udf: unknown compression code (%d) stri=%s\n", cmp_id, ocu_i->u_name);
+	if ((cmp_id != 8) && (cmp_id != 16)) {
+		printk(KERN_ERR "udf: unknown compression code (%d) stri=%s\n",
+		       cmp_id, ocu_i->u_name);
 		return 0;
 	}
 
-	for (i = 0; (i < ocu_len) && (utf_o->u_len <= (UDF_NAME_LEN-3)) ;)
-	{
+	for (i = 0; (i < ocu_len) && (utf_o->u_len <= (UDF_NAME_LEN - 3));) {
 		/* Expand OSTA compressed Unicode to Unicode */
 		c = ocu[i++];
 		if (cmp_id == 16)
 			c = (c << 8) | ocu[i++];
 
-		utf_o->u_len += nls->uni2char(c, &utf_o->u_name[utf_o->u_len], 
-			UDF_NAME_LEN - utf_o->u_len);
+		utf_o->u_len += nls->uni2char(c, &utf_o->u_name[utf_o->u_len],
+					      UDF_NAME_LEN - utf_o->u_len);
 	}
-	utf_o->u_cmpID=8;
+	utf_o->u_cmpID = 8;
 
 	return utf_o->u_len;
 }
 
-static int udf_NLStoCS0(struct nls_table *nls, dstring *ocu, struct ustr *uni, int length)
+static int udf_NLStoCS0(struct nls_table *nls, dstring * ocu, struct ustr *uni,
+			int length)
 {
 	unsigned len, i, max_val;
 	uint16_t uni_char;
@@ -319,93 +299,87 @@ static int udf_NLStoCS0(struct nls_table
 	ocu[0] = 8;
 	max_val = 0xffU;
 
-try_again:
+      try_again:
 	u_len = 0U;
-	for (i = 0U; i < uni->u_len; i++)
-	{
-		len = nls->char2uni(&uni->u_name[i], uni->u_len-i, &uni_char);
+	for (i = 0U; i < uni->u_len; i++) {
+		len = nls->char2uni(&uni->u_name[i], uni->u_len - i, &uni_char);
 		if (len <= 0)
 			continue;
 
-		if (uni_char > max_val)
-		{
+		if (uni_char > max_val) {
 			max_val = 0xffffU;
-			ocu[0] = (uint8_t)0x10U;
+			ocu[0] = (uint8_t) 0x10U;
 			goto try_again;
 		}
-		
+
 		if (max_val == 0xffffU)
-			ocu[++u_len] = (uint8_t)(uni_char >> 8);
-		ocu[++u_len] = (uint8_t)(uni_char & 0xffU);
+			ocu[++u_len] = (uint8_t) (uni_char >> 8);
+		ocu[++u_len] = (uint8_t) (uni_char & 0xffU);
 		i += len - 1;
 	}
 
-	ocu[length - 1] = (uint8_t)u_len + 1;
+	ocu[length - 1] = (uint8_t) u_len + 1;
 	return u_len + 1;
 }
 
-int udf_get_filename(struct super_block *sb, uint8_t *sname, uint8_t *dname, int flen)
+int udf_get_filename(struct super_block *sb, uint8_t * sname, uint8_t * dname,
+		     int flen)
 {
 	struct ustr filename, unifilename;
 	int len;
 
-	if (udf_build_ustr_exact(&unifilename, sname, flen))
-	{
+	if (udf_build_ustr_exact(&unifilename, sname, flen)) {
 		return 0;
 	}
 
-	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UTF8))
-	{
-		if (!udf_CS0toUTF8(&filename, &unifilename) )
-		{
-			udf_debug("Failed in udf_get_filename: sname = %s\n", sname);
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UTF8)) {
+		if (!udf_CS0toUTF8(&filename, &unifilename)) {
+			udf_debug("Failed in udf_get_filename: sname = %s\n",
+				  sname);
 			return 0;
 		}
-	}
-	else if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP))
-	{
-		if (!udf_CS0toNLS(UDF_SB(sb)->s_nls_map, &filename, &unifilename) )
-		{
-			udf_debug("Failed in udf_get_filename: sname = %s\n", sname);
+	} else if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP)) {
+		if (!udf_CS0toNLS
+		    (UDF_SB(sb)->s_nls_map, &filename, &unifilename)) {
+			udf_debug("Failed in udf_get_filename: sname = %s\n",
+				  sname);
 			return 0;
 		}
-	}
-	else
+	} else
 		return 0;
 
-	if ((len = udf_translate_to_linux(dname, filename.u_name, filename.u_len,
-		unifilename.u_name, unifilename.u_len)))
-	{
+	if ((len =
+	     udf_translate_to_linux(dname, filename.u_name, filename.u_len,
+				    unifilename.u_name, unifilename.u_len))) {
 		return len;
 	}
 	return 0;
 }
 
-int udf_put_filename(struct super_block *sb, const uint8_t *sname, uint8_t *dname, int flen)
+int udf_put_filename(struct super_block *sb, const uint8_t * sname,
+		     uint8_t * dname, int flen)
 {
 	struct ustr unifilename;
 	int namelen;
 
-	if ( !(udf_char_to_ustr(&unifilename, sname, flen)) )
-	{
+	if (!(udf_char_to_ustr(&unifilename, sname, flen))) {
 		return 0;
 	}
 
-	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UTF8))
-	{
-		if ( !(namelen = udf_UTF8toCS0(dname, &unifilename, UDF_NAME_LEN)) )
-		{
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UTF8)) {
+		if (!
+		    (namelen =
+		     udf_UTF8toCS0(dname, &unifilename, UDF_NAME_LEN))) {
 			return 0;
 		}
-	}
-	else if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP))
-	{
-		if ( !(namelen = udf_NLStoCS0(UDF_SB(sb)->s_nls_map, dname, &unifilename, UDF_NAME_LEN)) )
-		{
+	} else if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP)) {
+		if (!
+		    (namelen =
+		     udf_NLStoCS0(UDF_SB(sb)->s_nls_map, dname, &unifilename,
+				  UDF_NAME_LEN))) {
 			return 0;
 		}
-	}
-	else
+	} else
 		return 0;
 
 	return namelen;
@@ -416,40 +390,36 @@ int udf_put_filename(struct super_block 
 #define CRC_MARK			'#'
 #define EXT_SIZE			5
 
-static int udf_translate_to_linux(uint8_t *newName, uint8_t *udfName, int udfLen, uint8_t *fidName, int fidNameLen)
+static int udf_translate_to_linux(uint8_t * newName, uint8_t * udfName,
+				  int udfLen, uint8_t * fidName, int fidNameLen)
 {
-	int index, newIndex = 0, needsCRC = 0;	
+	int index, newIndex = 0, needsCRC = 0;
 	int extIndex = 0, newExtIndex = 0, hasExt = 0;
 	unsigned short valueCRC;
 	uint8_t curr;
 	const uint8_t hexChar[] = "0123456789ABCDEF";
 
 	if (udfName[0] == '.' && (udfLen == 1 ||
-		(udfLen == 2 && udfName[1] == '.')))
-	{
+				  (udfLen == 2 && udfName[1] == '.'))) {
 		needsCRC = 1;
 		newIndex = udfLen;
 		memcpy(newName, udfName, udfLen);
-	}
-	else
-	{	
-		for (index = 0; index < udfLen; index++)
-		{
+	} else {
+		for (index = 0; index < udfLen; index++) {
 			curr = udfName[index];
-			if (curr == '/' || curr == 0)
-			{
+			if (curr == '/' || curr == 0) {
 				needsCRC = 1;
 				curr = ILLEGAL_CHAR_MARK;
-				while (index+1 < udfLen && (udfName[index+1] == '/' ||
-					udfName[index+1] == 0))
+				while (index + 1 < udfLen
+				       && (udfName[index + 1] == '/'
+					   || udfName[index + 1] == 0))
 					index++;
 			}
-			if (curr == EXT_MARK && (udfLen - index - 1) <= EXT_SIZE)
-			{
+			if (curr == EXT_MARK
+			    && (udfLen - index - 1) <= EXT_SIZE) {
 				if (udfLen == index + 1)
 					hasExt = 0;
-				else
-				{
+				else {
 					hasExt = 1;
 					extIndex = index;
 					newExtIndex = newIndex;
@@ -461,26 +431,29 @@ static int udf_translate_to_linux(uint8_
 				needsCRC = 1;
 		}
 	}
-	if (needsCRC)
-	{
+	if (needsCRC) {
 		uint8_t ext[EXT_SIZE];
 		int localExtIndex = 0;
 
-		if (hasExt)
-		{
+		if (hasExt) {
 			int maxFilenameLen;
-			for(index = 0; index<EXT_SIZE && extIndex + index +1 < udfLen;
-				index++ )
-			{
+			for (index = 0;
+			     index < EXT_SIZE && extIndex + index + 1 < udfLen;
+			     index++) {
 				curr = udfName[extIndex + index + 1];
 
-				if (curr == '/' || curr == 0)
-				{
+				if (curr == '/' || curr == 0) {
 					needsCRC = 1;
 					curr = ILLEGAL_CHAR_MARK;
-					while(extIndex + index + 2 < udfLen && (index + 1 < EXT_SIZE
-						&& (udfName[extIndex + index + 2] == '/' ||
-							udfName[extIndex + index + 2] == 0)))
+					while (extIndex + index + 2 < udfLen
+					       && (index + 1 < EXT_SIZE
+						   &&
+						   (udfName
+						    [extIndex + index + 2] ==
+						    '/'
+						    || udfName[extIndex +
+							       index + 2] ==
+						    0)))
 						index++;
 				}
 				ext[localExtIndex++] = curr;
@@ -490,8 +463,7 @@ static int udf_translate_to_linux(uint8_
 				newIndex = maxFilenameLen;
 			else
 				newIndex = newExtIndex;
-		}
-		else if (newIndex > 250)
+		} else if (newIndex > 250)
 			newIndex = 250;
 		newName[newIndex++] = CRC_MARK;
 		valueCRC = udf_crc(fidName, fidNameLen, 0);
@@ -500,10 +472,9 @@ static int udf_translate_to_linux(uint8_
 		newName[newIndex++] = hexChar[(valueCRC & 0x00f0) >> 4];
 		newName[newIndex++] = hexChar[(valueCRC & 0x000f)];
 
-		if (hasExt)
-		{
+		if (hasExt) {
 			newName[newIndex++] = EXT_MARK;
-			for (index = 0;index < localExtIndex ;index++ )
+			for (index = 0; index < localExtIndex; index++)
 				newName[newIndex++] = ext[index];
 		}
 	}
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
sky-cpu-and-nexus-code-style-improvement.patch
sky-cpu-and-nexus-include-ioh.patch
sky-cpu-and-nexus-check-for-platform_get_resource-ret.patch
sky-cpu-and-nexus-check-for-create_proc_entry-ret-code.patch
sky-cpu-use-c99-style-for-struct-init.patch
sky-cpu-and-nexus-get-rid-of-useless-null-init.patch
sky-cpu-and-nexus-use-seq_file-single_open-on-proc-interface.patch
git-dvb.patch
