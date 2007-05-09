From: akpm@linux-foundation.org
Subject: - udf-use-sector_t-and-loff_t-for-file-offsets.patch removed from -mm tree
Date: Tue, 08 May 2007 19:55:56 -0700
Message-ID: <200705090255.l492tuLa009986@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032381AbXEIC4G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:56:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, hch@infradead.org, mm-commits@vger.kernel.org


The patch titled
     udf: use sector_t and loff_t for file offsets
has been removed from the -mm tree.  Its filename was
     udf-use-sector_t-and-loff_t-for-file-offsets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: udf: use sector_t and loff_t for file offsets
From: Jan Kara <jack@suse.cz>

Use sector_t and loff_t for file offsets in UDF filesystem.  Otherwise an
overflow may occur for long files.  Also make inode_bmap() return offset in
the extent in number of blocks instead of number of bytes - for most
callers this is more convenient.

Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/dir.c       |    4 ++--
 fs/udf/directory.c |    2 +-
 fs/udf/inode.c     |   28 +++++++++++++++-------------
 fs/udf/namei.c     |   12 ++++++------
 fs/udf/truncate.c  |   21 +++++++++++----------
 fs/udf/udfdecl.h   |    6 +++---
 6 files changed, 38 insertions(+), 35 deletions(-)

diff -puN fs/udf/dir.c~udf-use-sector_t-and-loff_t-for-file-offsets fs/udf/dir.c
--- a/fs/udf/dir.c~udf-use-sector_t-and-loff_t-for-file-offsets
+++ a/fs/udf/dir.c
@@ -113,7 +113,8 @@ do_udf_readdir(struct inode * dir, struc
 	loff_t size = (udf_ext0_offset(dir) + dir->i_size) >> 2;
 	struct buffer_head * bh = NULL, * tmp, * bha[16];
 	kernel_lb_addr bloc, eloc;
-	uint32_t extoffset, elen, offset;
+	uint32_t extoffset, elen;
+	sector_t offset;
 	int i, num;
 	unsigned int dt_type;
 
@@ -129,7 +130,6 @@ do_udf_readdir(struct inode * dir, struc
 	else if (inode_bmap(dir, nf_pos >> (dir->i_sb->s_blocksize_bits - 2),
 		&bloc, &extoffset, &eloc, &elen, &offset, &bh) == (EXT_RECORDED_ALLOCATED >> 30))
 	{
-		offset >>= dir->i_sb->s_blocksize_bits;
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
 		if ((++offset << dir->i_sb->s_blocksize_bits) < elen)
 		{
diff -puN fs/udf/directory.c~udf-use-sector_t-and-loff_t-for-file-offsets fs/udf/directory.c
--- a/fs/udf/directory.c~udf-use-sector_t-and-loff_t-for-file-offsets
+++ a/fs/udf/directory.c
@@ -77,7 +77,7 @@ udf_fileident_read(struct inode *dir, lo
 	struct fileIdentDesc *cfi,
 	kernel_lb_addr *bloc, uint32_t *extoffset, 
 	kernel_lb_addr *eloc, uint32_t *elen,
-	uint32_t *offset, struct buffer_head **bh)
+	sector_t *offset, struct buffer_head **bh)
 {
 	struct fileIdentDesc *fi;
 	int i, num, block;
diff -puN fs/udf/inode.c~udf-use-sector_t-and-loff_t-for-file-offsets fs/udf/inode.c
--- a/fs/udf/inode.c~udf-use-sector_t-and-loff_t-for-file-offsets
+++ a/fs/udf/inode.c
@@ -49,7 +49,7 @@ MODULE_LICENSE("GPL");
 static mode_t udf_convert_permissions(struct fileEntry *);
 static int udf_update_inode(struct inode *, int);
 static void udf_fill_inode(struct inode *, struct buffer_head *);
-static struct buffer_head *inode_getblk(struct inode *, long, int *,
+static struct buffer_head *inode_getblk(struct inode *, sector_t, int *,
 	long *, int *);
 static int8_t udf_insert_aext(struct inode *, kernel_lb_addr, int,
 	kernel_lb_addr, uint32_t, struct buffer_head *);
@@ -354,7 +354,7 @@ udf_getblk(struct inode *inode, long blo
 	return NULL;
 }
 
-static struct buffer_head * inode_getblk(struct inode * inode, long block,
+static struct buffer_head * inode_getblk(struct inode * inode, sector_t block,
 	int *err, long *phys, int *new)
 {
 	struct buffer_head *pbh = NULL, *cbh = NULL, *nbh = NULL, *result = NULL;
@@ -364,14 +364,15 @@ static struct buffer_head * inode_getblk
 	uint32_t elen = 0;
 	kernel_lb_addr eloc, pbloc, cbloc, nbloc;
 	int c = 1;
-	uint64_t lbcount = 0, b_off = 0;
-	uint32_t newblocknum, newblock, offset = 0;
+	loff_t lbcount = 0, b_off = 0;
+	uint32_t newblocknum, newblock;
+	sector_t offset = 0;
 	int8_t etype;
 	int goal = 0, pgoal = UDF_I_LOCATION(inode).logicalBlockNum;
 	char lastblock = 0;
 
 	pextoffset = cextoffset = nextoffset = udf_file_entry_alloc_offset(inode);
-	b_off = (uint64_t)block << inode->i_sb->s_blocksize_bits;
+	b_off = (loff_t)block << inode->i_sb->s_blocksize_bits;
 	pbloc = cbloc = nbloc = UDF_I_LOCATION(inode);
 
 	/* find the extent which contains the block we are looking for.
@@ -1948,10 +1949,10 @@ int8_t udf_delete_aext(struct inode *ino
 	return (elen >> 30);
 }
 
-int8_t inode_bmap(struct inode *inode, int block, kernel_lb_addr *bloc, uint32_t *extoffset,
-	kernel_lb_addr *eloc, uint32_t *elen, uint32_t *offset, struct buffer_head **bh)
+int8_t inode_bmap(struct inode *inode, sector_t block, kernel_lb_addr *bloc, uint32_t *extoffset,
+	kernel_lb_addr *eloc, uint32_t *elen, sector_t *offset, struct buffer_head **bh)
 {
-	uint64_t lbcount = 0, bcount = (uint64_t)block << inode->i_sb->s_blocksize_bits;
+	loff_t lbcount = 0, bcount = (loff_t)block << inode->i_sb->s_blocksize_bits;
 	int8_t etype;
 
 	if (block < 0)
@@ -1968,29 +1969,30 @@ int8_t inode_bmap(struct inode *inode, i
 	{
 		if ((etype = udf_next_aext(inode, bloc, extoffset, eloc, elen, bh, 1)) == -1)
 		{
-			*offset = bcount - lbcount;
+			*offset = (bcount - lbcount) >> inode->i_sb->s_blocksize_bits;
 			UDF_I_LENEXTENTS(inode) = lbcount;
 			return -1;
 		}
 		lbcount += *elen;
 	} while (lbcount <= bcount);
 
-	*offset = bcount + *elen - lbcount;
+	*offset = (bcount + *elen - lbcount) >> inode->i_sb->s_blocksize_bits;
 
 	return etype;
 }
 
-long udf_block_map(struct inode *inode, long block)
+long udf_block_map(struct inode *inode, sector_t block)
 {
 	kernel_lb_addr eloc, bloc;
-	uint32_t offset, extoffset, elen;
+	uint32_t extoffset, elen;
+	sector_t offset;
 	struct buffer_head *bh = NULL;
 	int ret;
 
 	lock_kernel();
 
 	if (inode_bmap(inode, block, &bloc, &extoffset, &eloc, &elen, &offset, &bh) == (EXT_RECORDED_ALLOCATED >> 30))
-		ret = udf_get_lb_pblock(inode->i_sb, eloc, offset >> inode->i_sb->s_blocksize_bits);
+		ret = udf_get_lb_pblock(inode->i_sb, eloc, offset);
 	else
 		ret = 0;
 
diff -puN fs/udf/namei.c~udf-use-sector_t-and-loff_t-for-file-offsets fs/udf/namei.c
--- a/fs/udf/namei.c~udf-use-sector_t-and-loff_t-for-file-offsets
+++ a/fs/udf/namei.c
@@ -156,7 +156,8 @@ udf_find_entry(struct inode *dir, struct
 	uint16_t liu;
 	loff_t size;
 	kernel_lb_addr bloc, eloc;
-	uint32_t extoffset, elen, offset;
+	uint32_t extoffset, elen;
+	sector_t offset;
 	struct buffer_head *bh = NULL;
 
 	size = (udf_ext0_offset(dir) + dir->i_size) >> 2;
@@ -168,7 +169,6 @@ udf_find_entry(struct inode *dir, struct
 	else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
 		&bloc, &extoffset, &eloc, &elen, &offset, &bh) == (EXT_RECORDED_ALLOCATED >> 30))
 	{
-		offset >>= dir->i_sb->s_blocksize_bits;
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
 		if ((++offset << dir->i_sb->s_blocksize_bits) < elen)
 		{
@@ -354,7 +354,8 @@ udf_add_entry(struct inode *dir, struct 
 	uint16_t liu;
 	int block;
 	kernel_lb_addr bloc, eloc;
-	uint32_t extoffset, elen, offset;
+	uint32_t extoffset, elen;
+	sector_t offset;
 	struct buffer_head *bh = NULL;
 
 	sb = dir->i_sb;
@@ -386,7 +387,6 @@ udf_add_entry(struct inode *dir, struct 
 	else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
 		&bloc, &extoffset, &eloc, &elen, &offset, &bh) == (EXT_RECORDED_ALLOCATED >> 30))
 	{
-		offset >>= dir->i_sb->s_blocksize_bits;
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
 		if ((++offset << dir->i_sb->s_blocksize_bits) < elen)
 		{
@@ -782,7 +782,8 @@ static int empty_dir(struct inode *dir)
 	loff_t size = (udf_ext0_offset(dir) + dir->i_size) >> 2;
 	int block;
 	kernel_lb_addr bloc, eloc;
-	uint32_t extoffset, elen, offset;
+	uint32_t extoffset, elen;
+	sector_t offset;
 	struct buffer_head *bh = NULL;
 
 	f_pos = (udf_ext0_offset(dir) >> 2);
@@ -794,7 +795,6 @@ static int empty_dir(struct inode *dir)
 	else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
 		&bloc, &extoffset, &eloc, &elen, &offset, &bh) == (EXT_RECORDED_ALLOCATED >> 30))
 	{
-		offset >>= dir->i_sb->s_blocksize_bits;
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
 		if ((++offset << dir->i_sb->s_blocksize_bits) < elen)
 		{
diff -puN fs/udf/truncate.c~udf-use-sector_t-and-loff_t-for-file-offsets fs/udf/truncate.c
--- a/fs/udf/truncate.c~udf-use-sector_t-and-loff_t-for-file-offsets
+++ a/fs/udf/truncate.c
@@ -125,9 +125,10 @@ void udf_discard_prealloc(struct inode *
 void udf_truncate_extents(struct inode * inode)
 {
 	kernel_lb_addr bloc, eloc, neloc = { 0, 0 };
-	uint32_t extoffset, elen, offset, nelen = 0, lelen = 0, lenalloc;
+	uint32_t extoffset, elen, nelen = 0, lelen = 0, lenalloc;
 	int8_t etype;
-	int first_block = inode->i_size >> inode->i_sb->s_blocksize_bits;
+	sector_t first_block = inode->i_size >> inode->i_sb->s_blocksize_bits, offset;
+	loff_t byte_offset;
 	struct buffer_head *bh = NULL;
 	int adsize;
 
@@ -139,14 +140,14 @@ void udf_truncate_extents(struct inode *
 		adsize = 0;
 
 	etype = inode_bmap(inode, first_block, &bloc, &extoffset, &eloc, &elen, &offset, &bh);
-	offset += (inode->i_size & (inode->i_sb->s_blocksize - 1));
+	byte_offset = (offset << inode->i_sb->s_blocksize_bits) + (inode->i_size & (inode->i_sb->s_blocksize-1));
 	if (etype != -1)
 	{
 		extoffset -= adsize;
-		extent_trunc(inode, bloc, extoffset, eloc, etype, elen, bh, offset);
+		extent_trunc(inode, bloc, extoffset, eloc, etype, elen, bh, byte_offset);
 		extoffset += adsize;
 
-		if (offset)
+		if (byte_offset)
 			lenalloc = extoffset;
 		else
 			lenalloc = extoffset - adsize;
@@ -237,7 +238,7 @@ void udf_truncate_extents(struct inode *
 	}
 	else if (inode->i_size)
 	{
-		if (offset)
+		if (byte_offset)
 		{
 			/*
 			 *  OK, there is not extent covering inode->i_size and
@@ -248,7 +249,7 @@ void udf_truncate_extents(struct inode *
 			    (bh && extoffset == sizeof(struct allocExtDesc))) {
 				/* File has no extents at all! */
 				memset(&eloc, 0x00, sizeof(kernel_lb_addr));
-				elen = EXT_NOT_RECORDED_NOT_ALLOCATED | offset;
+				elen = EXT_NOT_RECORDED_NOT_ALLOCATED | byte_offset;
 				udf_add_aext(inode, &bloc, &extoffset, eloc, elen, &bh, 1);
 			}
 			else {
@@ -257,7 +258,7 @@ void udf_truncate_extents(struct inode *
 				if (etype == (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30))
 				{
 					extoffset -= adsize;
-					elen = EXT_NOT_RECORDED_NOT_ALLOCATED | (elen + offset);
+					elen = EXT_NOT_RECORDED_NOT_ALLOCATED | (elen + byte_offset);
 					udf_write_aext(inode, bloc, &extoffset, eloc, elen, bh, 0);
 				}
 				else if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30))
@@ -265,7 +266,7 @@ void udf_truncate_extents(struct inode *
 					kernel_lb_addr neloc = { 0, 0 };
 					extoffset -= adsize;
 					nelen = EXT_NOT_RECORDED_NOT_ALLOCATED |
-						((elen + offset + inode->i_sb->s_blocksize - 1) &
+						((elen + byte_offset + inode->i_sb->s_blocksize - 1) &
 						~(inode->i_sb->s_blocksize - 1));
 					udf_write_aext(inode, bloc, &extoffset, neloc, nelen, bh, 1);
 					udf_add_aext(inode, &bloc, &extoffset, eloc, (etype << 30) | elen, &bh, 1);
@@ -281,7 +282,7 @@ void udf_truncate_extents(struct inode *
 						udf_write_aext(inode, bloc, &extoffset, eloc, elen, bh, 1);
 					}
 					memset(&eloc, 0x00, sizeof(kernel_lb_addr));
-					elen = EXT_NOT_RECORDED_NOT_ALLOCATED | offset;
+					elen = EXT_NOT_RECORDED_NOT_ALLOCATED | byte_offset;
 					udf_add_aext(inode, &bloc, &extoffset, eloc, elen, &bh, 1);
 				}
 			}
diff -puN fs/udf/udfdecl.h~udf-use-sector_t-and-loff_t-for-file-offsets fs/udf/udfdecl.h
--- a/fs/udf/udfdecl.h~udf-use-sector_t-and-loff_t-for-file-offsets
+++ a/fs/udf/udfdecl.h
@@ -98,8 +98,8 @@ extern void udf_read_inode(struct inode 
 extern void udf_delete_inode(struct inode *);
 extern void udf_clear_inode(struct inode *);
 extern int udf_write_inode(struct inode *, int);
-extern long udf_block_map(struct inode *, long);
-extern int8_t inode_bmap(struct inode *, int, kernel_lb_addr *, uint32_t *, kernel_lb_addr *, uint32_t *, uint32_t *, struct buffer_head **);
+extern long udf_block_map(struct inode *, sector_t);
+extern int8_t inode_bmap(struct inode *, sector_t, kernel_lb_addr *, uint32_t *, kernel_lb_addr *, uint32_t *, sector_t *, struct buffer_head **);
 extern int8_t udf_add_aext(struct inode *, kernel_lb_addr *, int *, kernel_lb_addr, uint32_t, struct buffer_head **, int);
 extern int8_t udf_write_aext(struct inode *, kernel_lb_addr, int *, kernel_lb_addr, uint32_t, struct buffer_head *, int);
 extern int8_t udf_delete_aext(struct inode *, kernel_lb_addr, int, kernel_lb_addr, uint32_t, struct buffer_head *);
@@ -151,7 +151,7 @@ extern int udf_new_block(struct super_bl
 extern int udf_fsync_file(struct file *, struct dentry *, int);
 
 /* directory.c */
-extern struct fileIdentDesc * udf_fileident_read(struct inode *, loff_t *, struct udf_fileident_bh *, struct fileIdentDesc *, kernel_lb_addr *, uint32_t *, kernel_lb_addr *, uint32_t *, uint32_t *, struct buffer_head **);
+extern struct fileIdentDesc * udf_fileident_read(struct inode *, loff_t *, struct udf_fileident_bh *, struct fileIdentDesc *, kernel_lb_addr *, uint32_t *, kernel_lb_addr *, uint32_t *, sector_t *, struct buffer_head **);
 extern struct fileIdentDesc * udf_get_fileident(void * buffer, int bufsize, int * offset);
 extern long_ad * udf_get_filelongad(uint8_t *, int, int *, int);
 extern short_ad * udf_get_fileshortad(uint8_t *, int, int *, int);
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
ext4-copy-i_flags-to-inode-flags-on-write.patch
