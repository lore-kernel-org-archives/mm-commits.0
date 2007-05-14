From: akpm@linux-foundation.org
Subject: + udf-check-for-allocated-memory-for-inode-data-v2.patch added to -mm tree
Date: Mon, 14 May 2007 14:37:02 -0700
Message-ID: <200705142137.l4ELb2Ex026787@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754418AbXENVhp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 17:37:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, hch@lst.de, jack@ucw.cz


The patch titled
     UDF: check for allocated memory for inode data
has been added to the -mm tree.  Its filename is
     udf-check-for-allocated-memory-for-inode-data-v2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: UDF: check for allocated memory for inode data
From: Cyrill Gorcunov <gorcunov@gmail.com>

This patch adds checking for granted memory while filling up inode data to
prevent possible NULL pointer usage.  If there is not enough memory to fill
inode data we just mark it as "bad".  Also some whitespace cleanup.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Jan Kara <jack@ucw.cz>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/inode.c |   51 +++++++++++++++++++++++++++++++++++------------
 1 files changed, 39 insertions(+), 12 deletions(-)

diff -puN fs/udf/inode.c~udf-check-for-allocated-memory-for-inode-data-v2 fs/udf/inode.c
--- a/fs/udf/inode.c~udf-check-for-allocated-memory-for-inode-data-v2
+++ a/fs/udf/inode.c
@@ -49,6 +49,7 @@ MODULE_LICENSE("GPL");
 static mode_t udf_convert_permissions(struct fileEntry *);
 static int udf_update_inode(struct inode *, int);
 static void udf_fill_inode(struct inode *, struct buffer_head *);
+static int udf_alloc_i_data(struct inode *inode, size_t size);
 static struct buffer_head *inode_getblk(struct inode *, sector_t, int *,
 	long *, int *);
 static int8_t udf_insert_aext(struct inode *, struct extent_position,
@@ -721,7 +722,7 @@ static void udf_split_extents(struct ino
 			(*c) ++;
 			(*endnum) ++;
 		}
-		
+
 		laarr[curr].extLocation.logicalBlockNum = newblocknum;
 		if (etype == (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30))
 			laarr[curr].extLocation.partitionReferenceNum =
@@ -823,7 +824,7 @@ static void udf_prealloc_extents(struct 
 				{
 					numalloc -= elen;
 					if (*endnum > (i+1))
-						memmove(&laarr[i], &laarr[i+1], 
+						memmove(&laarr[i], &laarr[i+1],
 							sizeof(long_ad) * (*endnum - (i+1)));
 					i --;
 					(*endnum) --;
@@ -1011,7 +1012,7 @@ void udf_truncate(struct inode * inode)
 	{
 		block_truncate_page(inode->i_mapping, inode->i_size, udf_get_block);
 		udf_truncate_extents(inode);
-	}	
+	}
 
 	inode->i_mtime = inode->i_ctime = current_fs_time(inode->i_sb);
 	if (IS_SYNC(inode))
@@ -1074,10 +1075,10 @@ __udf_read_inode(struct inode *inode)
 			{
 				kernel_lb_addr loc;
 				ie = (struct indirectEntry *)ibh->b_data;
-	
+
 				loc = lelb_to_cpu(ie->indirectICB.extLocation);
-	
-				if (ie->indirectICB.extLength && 
+
+				if (ie->indirectICB.extLength &&
 					(nbh = udf_read_ptagged(inode->i_sb, loc, 0, &ident)))
 				{
 					if (ident == TAG_IDENT_FE ||
@@ -1143,14 +1144,22 @@ static void udf_fill_inode(struct inode 
 	{
 		UDF_I_EFE(inode) = 1;
 		UDF_I_USE(inode) = 0;
-		UDF_I_DATA(inode) = kmalloc(inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry), GFP_KERNEL);
+		if (udf_alloc_i_data(inode, inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry)))
+		{
+			make_bad_inode(inode);
+			return;
+		}
 		memcpy(UDF_I_DATA(inode), bh->b_data + sizeof(struct extendedFileEntry), inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry));
 	}
 	else if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_FE)
 	{
 		UDF_I_EFE(inode) = 0;
 		UDF_I_USE(inode) = 0;
-		UDF_I_DATA(inode) = kmalloc(inode->i_sb->s_blocksize - sizeof(struct fileEntry), GFP_KERNEL);
+		if (udf_alloc_i_data(inode, inode->i_sb->s_blocksize - sizeof(struct fileEntry)))
+		{
+			make_bad_inode(inode);
+			return;
+		}
 		memcpy(UDF_I_DATA(inode), bh->b_data + sizeof(struct fileEntry), inode->i_sb->s_blocksize - sizeof(struct fileEntry));
 	}
 	else if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_USE)
@@ -1160,7 +1169,11 @@ static void udf_fill_inode(struct inode 
 		UDF_I_LENALLOC(inode) =
 			le32_to_cpu(
 				((struct unallocSpaceEntry *)bh->b_data)->lengthAllocDescs);
-		UDF_I_DATA(inode) = kmalloc(inode->i_sb->s_blocksize - sizeof(struct unallocSpaceEntry), GFP_KERNEL);
+		if (udf_alloc_i_data(inode, inode->i_sb->s_blocksize - sizeof(struct unallocSpaceEntry)))
+		{
+			make_bad_inode(inode);
+			return;
+		}
 		memcpy(UDF_I_DATA(inode), bh->b_data + sizeof(struct unallocSpaceEntry), inode->i_sb->s_blocksize - sizeof(struct unallocSpaceEntry));
 		return;
 	}
@@ -1178,7 +1191,7 @@ static void udf_fill_inode(struct inode 
 	inode->i_nlink = le16_to_cpu(fe->fileLinkCount);
 	if (!inode->i_nlink)
 		inode->i_nlink = 1;
-	
+
 	inode->i_size = le64_to_cpu(fe->informationLength);
 	UDF_I_LENEXTENTS(inode) = inode->i_size;
 
@@ -1230,7 +1243,7 @@ static void udf_fill_inode(struct inode 
 	}
 	else
 	{
-		inode->i_blocks = le64_to_cpu(efe->logicalBlocksRecorded) << 
+		inode->i_blocks = le64_to_cpu(efe->logicalBlocksRecorded) <<
 			(inode->i_sb->s_blocksize_bits - 9);
 
 		if ( udf_stamp_to_time(&convtime, &convtime_usec,
@@ -1361,6 +1374,20 @@ static void udf_fill_inode(struct inode 
 	}
 }
 
+static int udf_alloc_i_data(struct inode *inode, size_t size)
+{
+	UDF_I_DATA(inode) = kmalloc(size, GFP_KERNEL);
+
+	if (!UDF_I_DATA(inode))
+	{
+		printk(KERN_ERR "udf:udf_alloc_i_data (ino %ld) no free memory\n",
+		       inode->i_ino);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
 static mode_t
 udf_convert_permissions(struct fileEntry *fe)
 {
@@ -2059,7 +2086,7 @@ int8_t udf_delete_aext(struct inode *ino
 			mark_buffer_dirty_inode(oepos.bh, inode);
 		}
 	}
-	
+
 	brelse(epos.bh);
 	brelse(oepos.bh);
 	return (elen >> 30);
_

Patches currently in -mm which might be from gorcunov@gmail.com are

udf-check-for-allocated-memory-for-data-of-new-inodes.patch
udf-check-for-allocated-memory-for-inode-data-v2.patch
