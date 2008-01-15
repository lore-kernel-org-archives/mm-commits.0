From: akpm@linux-foundation.org
Subject: + udf-cache-struct-udf_inode_info.patch added to -mm tree
Date: Tue, 15 Jan 2008 02:46:59 -0800
Message-ID: <200801151046.m0FAkdDu011681@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60749 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751055AbYAOKrD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 05:47:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, hch@lst.de, jack@suse.cz


The patch titled
     udf: cache struct udf_inode_info
has been added to the -mm tree.  Its filename is
     udf-cache-struct-udf_inode_info.patch

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
Subject: udf: cache struct udf_inode_info
From: Marcin Slusarz <marcin.slusarz@gmail.com>

cache UDF_I(struct inode *) return values when there are
at least 2 uses in one function

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/balloc.c    |   35 ++--
 fs/udf/dir.c       |    8 -
 fs/udf/directory.c |    7 
 fs/udf/file.c      |   21 +-
 fs/udf/ialloc.c    |   49 +++---
 fs/udf/inode.c     |  309 ++++++++++++++++++++++---------------------
 fs/udf/misc.c      |   40 ++---
 fs/udf/namei.c     |  112 ++++++++-------
 fs/udf/partition.c |    8 -
 fs/udf/symlink.c   |    6 
 fs/udf/truncate.c  |   37 ++---
 11 files changed, 340 insertions(+), 292 deletions(-)

diff -puN fs/udf/balloc.c~udf-cache-struct-udf_inode_info fs/udf/balloc.c
--- a/fs/udf/balloc.c~udf-cache-struct-udf_inode_info
+++ a/fs/udf/balloc.c
@@ -436,6 +436,7 @@ static void udf_table_free_blocks(struct
 	struct extent_position oepos, epos;
 	int8_t etype;
 	int i;
+	struct udf_inode_info *iinfo;
 
 	mutex_lock(&sbi->s_alloc_mutex);
 	if (bloc.logicalBlockNum < 0 ||
@@ -448,6 +449,7 @@ static void udf_table_free_blocks(struct
 		goto error_return;
 	}
 
+	iinfo = UDF_I(table);
 	/* We do this up front - There are some error conditions that
 	   could occure, but.. oh well */
 	if (inode)
@@ -460,7 +462,7 @@ static void udf_table_free_blocks(struct
 
 	epos.offset = oepos.offset = sizeof(struct unallocSpaceEntry);
 	elen = 0;
-	epos.block = oepos.block = UDF_I(table)->i_location;
+	epos.block = oepos.block = iinfo->i_location;
 	epos.bh = oepos.bh = NULL;
 
 	while (count &&
@@ -539,11 +541,11 @@ static void udf_table_free_blocks(struct
 		elen = EXT_RECORDED_ALLOCATED |
 			(count << sb->s_blocksize_bits);
 
-		if (UDF_I(table)->i_alloc_type == ICBTAG_FLAG_AD_SHORT) {
+		if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 			adsize = sizeof(short_ad);
-		} else if (UDF_I(table)->i_alloc_type == ICBTAG_FLAG_AD_LONG) {
+		else if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
 			adsize = sizeof(long_ad);
-		} else {
+		else {
 			brelse(oepos.bh);
 			brelse(epos.bh);
 			goto error_return;
@@ -573,7 +575,7 @@ static void udf_table_free_blocks(struct
 			if (epos.offset + adsize > sb->s_blocksize) {
 				loffset = epos.offset;
 				aed->lengthAllocDescs = cpu_to_le32(adsize);
-				sptr = UDF_I(table)->i_ext.i_data + epos.offset
+				sptr = iinfo->i_ext.i_data + epos.offset
 								- adsize;
 				dptr = epos.bh->b_data +
 					sizeof(struct allocExtDesc);
@@ -592,9 +594,9 @@ static void udf_table_free_blocks(struct
 							aed->lengthAllocDescs) +
 								adsize);
 				} else {
-					sptr = UDF_I(table)->i_ext.i_data +
+					sptr = iinfo->i_ext.i_data +
 								epos.offset;
-					UDF_I(table)->i_lenAlloc += adsize;
+					iinfo->i_lenAlloc += adsize;
 					mark_inode_dirty(table);
 				}
 				epos.offset = sizeof(struct allocExtDesc);
@@ -608,7 +610,7 @@ static void udf_table_free_blocks(struct
 					    2, 1, epos.block.logicalBlockNum,
 					    sizeof(tag));
 
-			switch (UDF_I(table)->i_alloc_type) {
+			switch (iinfo->i_alloc_type) {
 			case ICBTAG_FLAG_AD_SHORT:
 				sad = (short_ad *)sptr;
 				sad->extLength = cpu_to_le32(
@@ -639,7 +641,7 @@ static void udf_table_free_blocks(struct
 			udf_write_aext(table, &epos, eloc, elen, 1);
 
 			if (!epos.bh) {
-				UDF_I(table)->i_lenAlloc += adsize;
+				iinfo->i_lenAlloc += adsize;
 				mark_inode_dirty(table);
 			} else {
 				aed = (struct allocExtDesc *)epos.bh->b_data;
@@ -672,21 +674,23 @@ static int udf_table_prealloc_blocks(str
 	kernel_lb_addr eloc;
 	struct extent_position epos;
 	int8_t etype = -1;
+	struct udf_inode_info *iinfo;
 
 	if (first_block < 0 ||
 		first_block >= sbi->s_partmaps[partition].s_partition_len)
 		return 0;
 
-	if (UDF_I(table)->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
+	iinfo = UDF_I(table);
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 		adsize = sizeof(short_ad);
-	else if (UDF_I(table)->i_alloc_type == ICBTAG_FLAG_AD_LONG)
+	else if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
 		adsize = sizeof(long_ad);
 	else
 		return 0;
 
 	mutex_lock(&sbi->s_alloc_mutex);
 	epos.offset = sizeof(struct unallocSpaceEntry);
-	epos.block = UDF_I(table)->i_location;
+	epos.block = iinfo->i_location;
 	epos.bh = NULL;
 	eloc.logicalBlockNum = 0xFFFFFFFF;
 
@@ -739,12 +743,13 @@ static int udf_table_new_block(struct su
 	kernel_lb_addr eloc, uninitialized_var(goal_eloc);
 	struct extent_position epos, goal_epos;
 	int8_t etype;
+	struct udf_inode_info *iinfo = UDF_I(table);
 
 	*err = -ENOSPC;
 
-	if (UDF_I(table)->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 		adsize = sizeof(short_ad);
-	else if (UDF_I(table)->i_alloc_type == ICBTAG_FLAG_AD_LONG)
+	else if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
 		adsize = sizeof(long_ad);
 	else
 		return newblock;
@@ -759,7 +764,7 @@ static int udf_table_new_block(struct su
 	   of the current closest match and use that when we are done.
 	 */
 	epos.offset = sizeof(struct unallocSpaceEntry);
-	epos.block = UDF_I(table)->i_location;
+	epos.block = iinfo->i_location;
 	epos.bh = goal_epos.bh = NULL;
 
 	while (spread &&
diff -puN fs/udf/dir.c~udf-cache-struct-udf_inode_info fs/udf/dir.c
--- a/fs/udf/dir.c~udf-cache-struct-udf_inode_info
+++ a/fs/udf/dir.c
@@ -117,6 +117,7 @@ do_udf_readdir(struct inode *dir, struct
 	int i, num;
 	unsigned int dt_type;
 	struct extent_position epos = { NULL, 0, {0, 0} };
+	struct udf_inode_info *iinfo;
 
 	if (nf_pos >= size)
 		return 0;
@@ -125,15 +126,16 @@ do_udf_readdir(struct inode *dir, struct
 		nf_pos = (udf_ext0_offset(dir) >> 2);
 
 	fibh.soffset = fibh.eoffset = (nf_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
-	if (UDF_I(dir)->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
+	iinfo = UDF_I(dir);
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
 		fibh.sbh = fibh.ebh = NULL;
 	} else if (inode_bmap(dir, nf_pos >> (dir->i_sb->s_blocksize_bits - 2),
 			      &epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
 		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
-			if (UDF_I(dir)->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
+			if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 				epos.offset -= sizeof(short_ad);
-			else if (UDF_I(dir)->i_alloc_type ==
+			else if (iinfo->i_alloc_type ==
 					ICBTAG_FLAG_AD_LONG)
 				epos.offset -= sizeof(long_ad);
 		} else {
diff -puN fs/udf/directory.c~udf-cache-struct-udf_inode_info fs/udf/directory.c
--- a/fs/udf/directory.c~udf-cache-struct-udf_inode_info
+++ a/fs/udf/directory.c
@@ -81,12 +81,13 @@ struct fileIdentDesc *udf_fileident_read
 	struct fileIdentDesc *fi;
 	int i, num, block;
 	struct buffer_head *tmp, *bha[16];
+	struct udf_inode_info *iinfo = UDF_I(dir);
 
 	fibh->soffset = fibh->eoffset;
 
-	if (UDF_I(dir)->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
-		fi = udf_get_fileident(UDF_I(dir)->i_ext.i_data -
-				       (UDF_I(dir)->i_efe ?
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
+		fi = udf_get_fileident(iinfo->i_ext.i_data -
+				       (iinfo->i_efe ?
 					sizeof(struct extendedFileEntry) :
 					sizeof(struct fileEntry)),
 				       dir->i_sb->s_blocksize,
diff -puN fs/udf/file.c~udf-cache-struct-udf_inode_info fs/udf/file.c
--- a/fs/udf/file.c~udf-cache-struct-udf_inode_info
+++ a/fs/udf/file.c
@@ -45,13 +45,13 @@ static int udf_adinicb_readpage(struct f
 {
 	struct inode *inode = page->mapping->host;
 	char *kaddr;
+	struct udf_inode_info *iinfo = UDF_I(inode);
 
 	BUG_ON(!PageLocked(page));
 
 	kaddr = kmap(page);
 	memset(kaddr, 0, PAGE_CACHE_SIZE);
-	memcpy(kaddr, UDF_I(inode)->i_ext.i_data + UDF_I(inode)->i_lenEAttr,
-								inode->i_size);
+	memcpy(kaddr, iinfo->i_ext.i_data + iinfo->i_lenEAttr, inode->i_size);
 	flush_dcache_page(page);
 	SetPageUptodate(page);
 	kunmap(page);
@@ -65,12 +65,12 @@ static int udf_adinicb_writepage(struct 
 {
 	struct inode *inode = page->mapping->host;
 	char *kaddr;
+	struct udf_inode_info *iinfo = UDF_I(inode);
 
 	BUG_ON(!PageLocked(page));
 
 	kaddr = kmap(page);
-	memcpy(UDF_I(inode)->i_ext.i_data + UDF_I(inode)->i_lenEAttr, kaddr,
-								inode->i_size);
+	memcpy(iinfo->i_ext.i_data + iinfo->i_lenEAttr, kaddr, inode->i_size);
 	mark_inode_dirty(inode);
 	SetPageUptodate(page);
 	kunmap(page);
@@ -87,9 +87,10 @@ static int udf_adinicb_write_end(struct 
 	struct inode *inode = mapping->host;
 	unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
 	char *kaddr;
+	struct udf_inode_info *iinfo = UDF_I(inode);
 
 	kaddr = kmap_atomic(page, KM_USER0);
-	memcpy(UDF_I(inode)->i_ext.i_data + UDF_I(inode)->i_lenEAttr + offset,
+	memcpy(iinfo->i_ext.i_data + iinfo->i_lenEAttr + offset,
 		kaddr + offset, copied);
 	kunmap_atomic(kaddr, KM_USER0);
 
@@ -112,8 +113,9 @@ static ssize_t udf_file_aio_write(struct
 	struct inode *inode = file->f_path.dentry->d_inode;
 	int err, pos;
 	size_t count = iocb->ki_left;
+	struct udf_inode_info *iinfo = UDF_I(inode);
 
-	if (UDF_I(inode)->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
 		if (file->f_flags & O_APPEND)
 			pos = inode->i_size;
 		else
@@ -123,16 +125,15 @@ static ssize_t udf_file_aio_write(struct
 				(udf_file_entry_alloc_offset(inode) +
 						pos + count)) {
 			udf_expand_file_adinicb(inode, pos + count, &err);
-			if (UDF_I(inode)->i_alloc_type ==
-							ICBTAG_FLAG_AD_IN_ICB) {
+			if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
 				udf_debug("udf_expand_adinicb: err=%d\n", err);
 				return err;
 			}
 		} else {
 			if (pos + count > inode->i_size)
-				UDF_I(inode)->i_lenAlloc = pos + count;
+				iinfo->i_lenAlloc = pos + count;
 			else
-				UDF_I(inode)->i_lenAlloc = inode->i_size;
+				iinfo->i_lenAlloc = inode->i_size;
 		}
 	}
 
diff -puN fs/udf/ialloc.c~udf-cache-struct-udf_inode_info fs/udf/ialloc.c
--- a/fs/udf/ialloc.c~udf-cache-struct-udf_inode_info
+++ a/fs/udf/ialloc.c
@@ -67,6 +67,8 @@ struct inode *udf_new_inode(struct inode
 	struct inode *inode;
 	int block;
 	uint32_t start = UDF_I(dir)->i_location.logicalBlockNum;
+	struct udf_inode_info *iinfo;
+	struct udf_inode_info *dinfo = UDF_I(dir);
 
 	inode = new_inode(sb);
 
@@ -76,14 +78,15 @@ struct inode *udf_new_inode(struct inode
 	}
 	*err = -ENOSPC;
 
-	UDF_I(inode)->i_unique = 0;
-	UDF_I(inode)->i_lenExtents = 0;
-	UDF_I(inode)->i_next_alloc_block = 0;
-	UDF_I(inode)->i_next_alloc_goal = 0;
-	UDF_I(inode)->i_strat4096 = 0;
+	iinfo = UDF_I(inode);
+	iinfo->i_unique = 0;
+	iinfo->i_lenExtents = 0;
+	iinfo->i_next_alloc_block = 0;
+	iinfo->i_next_alloc_goal = 0;
+	iinfo->i_strat4096 = 0;
 
 	block = udf_new_block(dir->i_sb, NULL,
-			      UDF_I(dir)->i_location.partitionReferenceNum,
+			      dinfo->i_location.partitionReferenceNum,
 			      start, err);
 	if (*err) {
 		iput(inode);
@@ -107,7 +110,7 @@ struct inode *udf_new_inode(struct inode
 		else
 			lvidiu->numFiles =
 				cpu_to_le32(le32_to_cpu(lvidiu->numFiles) + 1);
-		UDF_I(inode)->i_unique = uniqueID = le64_to_cpu(lvhd->uniqueID);
+		iinfo->i_unique = uniqueID = le64_to_cpu(lvhd->uniqueID);
 		if (!(++uniqueID & 0x00000000FFFFFFFFUL))
 			uniqueID += 16;
 		lvhd->uniqueID = cpu_to_le64(uniqueID);
@@ -123,41 +126,41 @@ struct inode *udf_new_inode(struct inode
 		inode->i_gid = current->fsgid;
 	}
 
-	UDF_I(inode)->i_location.logicalBlockNum = block;
-	UDF_I(inode)->i_location.partitionReferenceNum =
-				UDF_I(dir)->i_location.partitionReferenceNum;
-	inode->i_ino = udf_get_lb_pblock(sb, UDF_I(inode)->i_location, 0);
+	iinfo->i_location.logicalBlockNum = block;
+	iinfo->i_location.partitionReferenceNum =
+				dinfo->i_location.partitionReferenceNum;
+	inode->i_ino = udf_get_lb_pblock(sb, iinfo->i_location, 0);
 	inode->i_blocks = 0;
-	UDF_I(inode)->i_lenEAttr = 0;
-	UDF_I(inode)->i_lenAlloc = 0;
-	UDF_I(inode)->i_use = 0;
+	iinfo->i_lenEAttr = 0;
+	iinfo->i_lenAlloc = 0;
+	iinfo->i_use = 0;
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_EXTENDED_FE)) {
-		UDF_I(inode)->i_efe = 1;
+		iinfo->i_efe = 1;
 		if (UDF_VERS_USE_EXTENDED_FE > sbi->s_udfrev)
 			sbi->s_udfrev = UDF_VERS_USE_EXTENDED_FE;
-		UDF_I(inode)->i_ext.i_data = kzalloc(inode->i_sb->s_blocksize -
+		iinfo->i_ext.i_data = kzalloc(inode->i_sb->s_blocksize -
 					    sizeof(struct extendedFileEntry),
 					    GFP_KERNEL);
 	} else {
-		UDF_I(inode)->i_efe = 0;
-		UDF_I(inode)->i_ext.i_data = kzalloc(inode->i_sb->s_blocksize -
+		iinfo->i_efe = 0;
+		iinfo->i_ext.i_data = kzalloc(inode->i_sb->s_blocksize -
 					    sizeof(struct fileEntry),
 					    GFP_KERNEL);
 	}
-	if (!UDF_I(inode)->i_ext.i_data) {
+	if (!iinfo->i_ext.i_data) {
 		iput(inode);
 		*err = -ENOMEM;
 		mutex_unlock(&sbi->s_alloc_mutex);
 		return NULL;
 	}
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_AD_IN_ICB))
-		UDF_I(inode)->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
+		iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
 	else if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
-		UDF_I(inode)->i_alloc_type = ICBTAG_FLAG_AD_SHORT;
+		iinfo->i_alloc_type = ICBTAG_FLAG_AD_SHORT;
 	else
-		UDF_I(inode)->i_alloc_type = ICBTAG_FLAG_AD_LONG;
+		iinfo->i_alloc_type = ICBTAG_FLAG_AD_LONG;
 	inode->i_mtime = inode->i_atime = inode->i_ctime =
-		UDF_I(inode)->i_crtime = current_fs_time(inode->i_sb);
+		iinfo->i_crtime = current_fs_time(inode->i_sb);
 	insert_inode_hash(inode);
 	mark_inode_dirty(inode);
 	mutex_unlock(&sbi->s_alloc_mutex);
diff -puN fs/udf/inode.c~udf-cache-struct-udf_inode_info fs/udf/inode.c
--- a/fs/udf/inode.c~udf-cache-struct-udf_inode_info
+++ a/fs/udf/inode.c
@@ -112,6 +112,7 @@ no_delete:
  */
 void udf_clear_inode(struct inode *inode)
 {
+	struct udf_inode_info *iinfo;
 	if (!(inode->i_sb->s_flags & MS_RDONLY)) {
 		lock_kernel();
 		/* Discard preallocation for directories, symlinks, etc. */
@@ -120,8 +121,9 @@ void udf_clear_inode(struct inode *inode
 		unlock_kernel();
 		write_inode_now(inode, 1);
 	}
-	kfree(UDF_I(inode)->i_ext.i_data);
-	UDF_I(inode)->i_ext.i_data = NULL;
+	iinfo = UDF_I(inode);
+	kfree(iinfo->i_ext.i_data);
+	iinfo->i_ext.i_data = NULL;
 }
 
 static int udf_writepage(struct page *page, struct writeback_control *wbc)
@@ -161,6 +163,7 @@ void udf_expand_file_adinicb(struct inod
 {
 	struct page *page;
 	char *kaddr;
+	struct udf_inode_info *iinfo = UDF_I(inode);
 	struct writeback_control udf_wbc = {
 		.sync_mode = WB_SYNC_NONE,
 		.nr_to_write = 1,
@@ -169,11 +172,11 @@ void udf_expand_file_adinicb(struct inod
 	/* from now on we have normal address_space methods */
 	inode->i_data.a_ops = &udf_aops;
 
-	if (!UDF_I(inode)->i_lenAlloc) {
+	if (!iinfo->i_lenAlloc) {
 		if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
-			UDF_I(inode)->i_alloc_type = ICBTAG_FLAG_AD_SHORT;
+			iinfo->i_alloc_type = ICBTAG_FLAG_AD_SHORT;
 		else
-			UDF_I(inode)->i_alloc_type = ICBTAG_FLAG_AD_LONG;
+			iinfo->i_alloc_type = ICBTAG_FLAG_AD_LONG;
 		mark_inode_dirty(inode);
 		return;
 	}
@@ -183,21 +186,21 @@ void udf_expand_file_adinicb(struct inod
 
 	if (!PageUptodate(page)) {
 		kaddr = kmap(page);
-		memset(kaddr + UDF_I(inode)->i_lenAlloc, 0x00,
-		       PAGE_CACHE_SIZE - UDF_I(inode)->i_lenAlloc);
-		memcpy(kaddr, UDF_I(inode)->i_ext.i_data +
-			UDF_I(inode)->i_lenEAttr, UDF_I(inode)->i_lenAlloc);
+		memset(kaddr + iinfo->i_lenAlloc, 0x00,
+		       PAGE_CACHE_SIZE - iinfo->i_lenAlloc);
+		memcpy(kaddr, iinfo->i_ext.i_data + iinfo->i_lenEAttr,
+			iinfo->i_lenAlloc);
 		flush_dcache_page(page);
 		SetPageUptodate(page);
 		kunmap(page);
 	}
-	memset(UDF_I(inode)->i_ext.i_data + UDF_I(inode)->i_lenEAttr, 0x00,
-	       UDF_I(inode)->i_lenAlloc);
-	UDF_I(inode)->i_lenAlloc = 0;
+	memset(iinfo->i_ext.i_data + iinfo->i_lenEAttr, 0x00,
+	       iinfo->i_lenAlloc);
+	iinfo->i_lenAlloc = 0;
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
-		UDF_I(inode)->i_alloc_type = ICBTAG_FLAG_AD_SHORT;
+		iinfo->i_alloc_type = ICBTAG_FLAG_AD_SHORT;
 	else
-		UDF_I(inode)->i_alloc_type = ICBTAG_FLAG_AD_LONG;
+		iinfo->i_alloc_type = ICBTAG_FLAG_AD_LONG;
 
 	inode->i_data.a_ops->writepage(page, &udf_wbc);
 	page_cache_release(page);
@@ -219,6 +222,7 @@ struct buffer_head *udf_expand_dir_adini
 	loff_t f_pos = udf_ext0_offset(inode) >> 2;
 	int size = (udf_ext0_offset(inode) + inode->i_size) >> 2;
 	struct fileIdentDesc cfi, *sfi, *dfi;
+	struct udf_inode_info *iinfo = UDF_I(inode);
 
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
 		alloctype = ICBTAG_FLAG_AD_SHORT;
@@ -226,19 +230,19 @@ struct buffer_head *udf_expand_dir_adini
 		alloctype = ICBTAG_FLAG_AD_LONG;
 
 	if (!inode->i_size) {
-		UDF_I(inode)->i_alloc_type = alloctype;
+		iinfo->i_alloc_type = alloctype;
 		mark_inode_dirty(inode);
 		return NULL;
 	}
 
 	/* alloc block, and copy data to it */
 	*block = udf_new_block(inode->i_sb, inode,
-			       UDF_I(inode)->i_location.partitionReferenceNum,
-			       UDF_I(inode)->i_location.logicalBlockNum, err);
+			       iinfo->i_location.partitionReferenceNum,
+			       iinfo->i_location.logicalBlockNum, err);
 	if (!(*block))
 		return NULL;
 	newblock = udf_get_pblock(inode->i_sb, *block,
-				UDF_I(inode)->i_location.partitionReferenceNum,
+				  iinfo->i_location.partitionReferenceNum,
 				0);
 	if (!newblock)
 		return NULL;
@@ -257,14 +261,14 @@ struct buffer_head *udf_expand_dir_adini
 	dfibh.soffset = dfibh.eoffset = 0;
 	dfibh.sbh = dfibh.ebh = dbh;
 	while ((f_pos < size)) {
-		UDF_I(inode)->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
+		iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
 		sfi = udf_fileident_read(inode, &f_pos, &sfibh, &cfi, NULL,
 					 NULL, NULL, NULL);
 		if (!sfi) {
 			brelse(dbh);
 			return NULL;
 		}
-		UDF_I(inode)->i_alloc_type = alloctype;
+		iinfo->i_alloc_type = alloctype;
 		sfi->descTag.tagLocation = cpu_to_le32(*block);
 		dfibh.soffset = dfibh.eoffset;
 		dfibh.eoffset += (sfibh.eoffset - sfibh.soffset);
@@ -272,23 +276,23 @@ struct buffer_head *udf_expand_dir_adini
 		if (udf_write_fi(inode, sfi, dfi, &dfibh, sfi->impUse,
 				 sfi->fileIdent +
 					le16_to_cpu(sfi->lengthOfImpUse))) {
-			UDF_I(inode)->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
+			iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
 			brelse(dbh);
 			return NULL;
 		}
 	}
 	mark_buffer_dirty_inode(dbh, inode);
 
-	memset(UDF_I(inode)->i_ext.i_data + UDF_I(inode)->i_lenEAttr, 0,
-		UDF_I(inode)->i_lenAlloc);
-	UDF_I(inode)->i_lenAlloc = 0;
+	memset(iinfo->i_ext.i_data + iinfo->i_lenEAttr, 0,
+		iinfo->i_lenAlloc);
+	iinfo->i_lenAlloc = 0;
 	eloc.logicalBlockNum = *block;
 	eloc.partitionReferenceNum =
-				UDF_I(inode)->i_location.partitionReferenceNum;
+				iinfo->i_location.partitionReferenceNum;
 	elen = inode->i_size;
-	UDF_I(inode)->i_lenExtents = elen;
+	iinfo->i_lenExtents = elen;
 	epos.bh = NULL;
-	epos.block = UDF_I(inode)->i_location;
+	epos.block = iinfo->i_location;
 	epos.offset = udf_file_entry_alloc_offset(inode);
 	udf_add_aext(inode, &epos, eloc, elen, 0);
 	/* UniqueID stuff */
@@ -304,6 +308,7 @@ static int udf_get_block(struct inode *i
 	int err, new;
 	struct buffer_head *bh;
 	unsigned long phys;
+	struct udf_inode_info *iinfo;
 
 	if (!create) {
 		phys = udf_block_map(inode, block);
@@ -321,9 +326,10 @@ static int udf_get_block(struct inode *i
 	if (block < 0)
 		goto abort_negative;
 
-	if (block == UDF_I(inode)->i_next_alloc_block + 1) {
-		UDF_I(inode)->i_next_alloc_block++;
-		UDF_I(inode)->i_next_alloc_goal++;
+	iinfo = UDF_I(inode);
+	if (block == iinfo->i_next_alloc_block + 1) {
+		iinfo->i_next_alloc_block++;
+		iinfo->i_next_alloc_goal++;
 	}
 
 	err = 0;
@@ -380,20 +386,22 @@ int udf_extend_file(struct inode *inode,
 	struct super_block *sb = inode->i_sb;
 	kernel_lb_addr prealloc_loc = {};
 	int prealloc_len = 0;
+	struct udf_inode_info *iinfo;
 
 	/* The previous extent is fake and we should not extend by anything
 	 * - there's nothing to do... */
 	if (!blocks && fake)
 		return 0;
 
+	iinfo = UDF_I(inode);
 	/* Round the last extent up to a multiple of block size */
 	if (last_ext->extLength & (sb->s_blocksize - 1)) {
 		last_ext->extLength =
 			(last_ext->extLength & UDF_EXTENT_FLAG_MASK) |
 			(((last_ext->extLength & UDF_EXTENT_LENGTH_MASK) +
 			  sb->s_blocksize - 1) & ~(sb->s_blocksize - 1));
-		UDF_I(inode)->i_lenExtents =
-			(UDF_I(inode)->i_lenExtents + sb->s_blocksize - 1) &
+		iinfo->i_lenExtents =
+			(iinfo->i_lenExtents + sb->s_blocksize - 1) &
 			~(sb->s_blocksize - 1);
 	}
 
@@ -470,9 +478,9 @@ out:
 	}
 
 	/* last_pos should point to the last written extent... */
-	if (UDF_I(inode)->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 		last_pos->offset -= sizeof(short_ad);
-	else if (UDF_I(inode)->i_alloc_type == ICBTAG_FLAG_AD_LONG)
+	else if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
 		last_pos->offset -= sizeof(long_ad);
 	else
 		return -1;
@@ -495,11 +503,12 @@ static struct buffer_head *inode_getblk(
 	uint32_t newblocknum, newblock;
 	sector_t offset = 0;
 	int8_t etype;
-	int goal = 0, pgoal = UDF_I(inode)->i_location.logicalBlockNum;
+	struct udf_inode_info *iinfo = UDF_I(inode);
+	int goal = 0, pgoal = iinfo->i_location.logicalBlockNum;
 	int lastblock = 0;
 
 	prev_epos.offset = udf_file_entry_alloc_offset(inode);
-	prev_epos.block = UDF_I(inode)->i_location;
+	prev_epos.block = iinfo->i_location;
 	prev_epos.bh = NULL;
 	cur_epos = next_epos = prev_epos;
 	b_off = (loff_t)block << inode->i_sb->s_blocksize_bits;
@@ -649,24 +658,23 @@ static struct buffer_head *inode_getblk(
 	if ((laarr[c].extLength >> 30) == (EXT_NOT_RECORDED_ALLOCATED >> 30))
 		newblocknum = laarr[c].extLocation.logicalBlockNum + offset;
 	else { /* otherwise, allocate a new block */
-		if (UDF_I(inode)->i_next_alloc_block == block)
-			goal = UDF_I(inode)->i_next_alloc_goal;
+		if (iinfo->i_next_alloc_block == block)
+			goal = iinfo->i_next_alloc_goal;
 
 		if (!goal) {
 			if (!(goal = pgoal)) /* XXX: what was intended here? */
-				goal = UDF_I(inode)->
-						i_location.logicalBlockNum + 1;
+				goal = iinfo->i_location.logicalBlockNum + 1;
 		}
 
 		newblocknum = udf_new_block(inode->i_sb, inode,
-				UDF_I(inode)->i_location.partitionReferenceNum,
+				iinfo->i_location.partitionReferenceNum,
 				goal, err);
 		if (!newblocknum) {
 			brelse(prev_epos.bh);
 			*err = -ENOSPC;
 			return NULL;
 		}
-		UDF_I(inode)->i_lenExtents += inode->i_sb->s_blocksize;
+		iinfo->i_lenExtents += inode->i_sb->s_blocksize;
 	}
 
 	/* if the extent the requsted block is located in contains multiple
@@ -691,14 +699,14 @@ static struct buffer_head *inode_getblk(
 	brelse(prev_epos.bh);
 
 	newblock = udf_get_pblock(inode->i_sb, newblocknum,
-			UDF_I(inode)->i_location.partitionReferenceNum, 0);
+				iinfo->i_location.partitionReferenceNum, 0);
 	if (!newblock)
 		return NULL;
 	*phys = newblock;
 	*err = 0;
 	*new = 1;
-	UDF_I(inode)->i_next_alloc_block = block;
-	UDF_I(inode)->i_next_alloc_goal = newblocknum;
+	iinfo->i_next_alloc_block = block;
+	iinfo->i_next_alloc_goal = newblocknum;
 	inode->i_ctime = current_fs_time(inode->i_sb);
 
 	if (IS_SYNC(inode))
@@ -1027,6 +1035,7 @@ void udf_truncate(struct inode *inode)
 {
 	int offset;
 	int err;
+	struct udf_inode_info *iinfo;
 
 	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
 	      S_ISLNK(inode->i_mode)))
@@ -1035,25 +1044,24 @@ void udf_truncate(struct inode *inode)
 		return;
 
 	lock_kernel();
-	if (UDF_I(inode)->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
+	iinfo = UDF_I(inode);
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
 		if (inode->i_sb->s_blocksize <
 				(udf_file_entry_alloc_offset(inode) +
 				 inode->i_size)) {
 			udf_expand_file_adinicb(inode, inode->i_size, &err);
-			if (UDF_I(inode)->i_alloc_type ==
-							ICBTAG_FLAG_AD_IN_ICB) {
-				inode->i_size = UDF_I(inode)->i_lenAlloc;
+			if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
+				inode->i_size = iinfo->i_lenAlloc;
 				unlock_kernel();
 				return;
 			} else
 				udf_truncate_extents(inode);
 		} else {
 			offset = inode->i_size & (inode->i_sb->s_blocksize - 1);
-			memset(UDF_I(inode)->i_ext.i_data +
-				UDF_I(inode)->i_lenEAttr + offset,
+			memset(iinfo->i_ext.i_data + iinfo->i_lenEAttr + offset,
 				0x00, inode->i_sb->s_blocksize -
 				offset - udf_file_entry_alloc_offset(inode));
-			UDF_I(inode)->i_lenAlloc = inode->i_size;
+			iinfo->i_lenAlloc = inode->i_size;
 		}
 	} else {
 		block_truncate_page(inode->i_mapping, inode->i_size,
@@ -1074,6 +1082,7 @@ static void __udf_read_inode(struct inod
 	struct buffer_head *bh = NULL;
 	struct fileEntry *fe;
 	uint16_t ident;
+	struct udf_inode_info *iinfo = UDF_I(inode);
 
 	/*
 	 * Set defaults, but the inode is still incomplete!
@@ -1087,7 +1096,7 @@ static void __udf_read_inode(struct inod
 	 *      i_nlink = 1
 	 *      i_op = NULL;
 	 */
-	bh = udf_read_ptagged(inode->i_sb, UDF_I(inode)->i_location, 0, &ident);
+	bh = udf_read_ptagged(inode->i_sb, iinfo->i_location, 0, &ident);
 	if (!bh) {
 		printk(KERN_ERR "udf: udf_read_inode(ino %ld) failed !bh\n",
 		       inode->i_ino);
@@ -1110,7 +1119,7 @@ static void __udf_read_inode(struct inod
 		struct buffer_head *ibh = NULL, *nbh = NULL;
 		struct indirectEntry *ie;
 
-		ibh = udf_read_ptagged(inode->i_sb, UDF_I(inode)->i_location, 1,
+		ibh = udf_read_ptagged(inode->i_sb, iinfo->i_location, 1,
 					&ident);
 		if (ident == TAG_IDENT_IE) {
 			if (ibh) {
@@ -1124,7 +1133,7 @@ static void __udf_read_inode(struct inod
 							    &ident))) {
 					if (ident == TAG_IDENT_FE ||
 					    ident == TAG_IDENT_EFE) {
-						memcpy(&UDF_I(inode)->i_location,
+						memcpy(&iinfo->i_location,
 						       &loc,
 						       sizeof(kernel_lb_addr));
 						brelse(bh);
@@ -1163,50 +1172,51 @@ static void udf_fill_inode(struct inode 
 	long convtime_usec;
 	int offset;
 	struct udf_sb_info *sbi = UDF_SB(inode->i_sb);
+	struct udf_inode_info *iinfo = UDF_I(inode);
 
 	fe = (struct fileEntry *)bh->b_data;
 	efe = (struct extendedFileEntry *)bh->b_data;
 
 	if (fe->icbTag.strategyType == cpu_to_le16(4))
-		UDF_I(inode)->i_strat4096 = 0;
+		iinfo->i_strat4096 = 0;
 	else /* if (fe->icbTag.strategyType == cpu_to_le16(4096)) */
-		UDF_I(inode)->i_strat4096 = 1;
+		iinfo->i_strat4096 = 1;
 
-	UDF_I(inode)->i_alloc_type = le16_to_cpu(fe->icbTag.flags) &
+	iinfo->i_alloc_type = le16_to_cpu(fe->icbTag.flags) &
 							ICBTAG_FLAG_AD_MASK;
-	UDF_I(inode)->i_unique = 0;
-	UDF_I(inode)->i_lenEAttr = 0;
-	UDF_I(inode)->i_lenExtents = 0;
-	UDF_I(inode)->i_lenAlloc = 0;
-	UDF_I(inode)->i_next_alloc_block = 0;
-	UDF_I(inode)->i_next_alloc_goal = 0;
+	iinfo->i_unique = 0;
+	iinfo->i_lenEAttr = 0;
+	iinfo->i_lenExtents = 0;
+	iinfo->i_lenAlloc = 0;
+	iinfo->i_next_alloc_block = 0;
+	iinfo->i_next_alloc_goal = 0;
 	if (fe->descTag.tagIdent == cpu_to_le16(TAG_IDENT_EFE)) {
-		UDF_I(inode)->i_efe = 1;
-		UDF_I(inode)->i_use = 0;
+		iinfo->i_efe = 1;
+		iinfo->i_use = 0;
 		if (udf_alloc_i_data(inode, inode->i_sb->s_blocksize -
 					sizeof(struct extendedFileEntry))) {
 			make_bad_inode(inode);
 			return;
 		}
-		memcpy(UDF_I(inode)->i_ext.i_data,
+		memcpy(iinfo->i_ext.i_data,
 		       bh->b_data + sizeof(struct extendedFileEntry),
 		       inode->i_sb->s_blocksize -
 					sizeof(struct extendedFileEntry));
 	} else if (fe->descTag.tagIdent == cpu_to_le16(TAG_IDENT_FE)) {
-		UDF_I(inode)->i_efe = 0;
-		UDF_I(inode)->i_use = 0;
+		iinfo->i_efe = 0;
+		iinfo->i_use = 0;
 		if (udf_alloc_i_data(inode, inode->i_sb->s_blocksize -
 						sizeof(struct fileEntry))) {
 			make_bad_inode(inode);
 			return;
 		}
-		memcpy(UDF_I(inode)->i_ext.i_data,
+		memcpy(iinfo->i_ext.i_data,
 		       bh->b_data + sizeof(struct fileEntry),
 		       inode->i_sb->s_blocksize - sizeof(struct fileEntry));
 	} else if (fe->descTag.tagIdent == cpu_to_le16(TAG_IDENT_USE)) {
-		UDF_I(inode)->i_efe = 0;
-		UDF_I(inode)->i_use = 1;
-		UDF_I(inode)->i_lenAlloc = le32_to_cpu(
+		iinfo->i_efe = 0;
+		iinfo->i_use = 1;
+		iinfo->i_lenAlloc = le32_to_cpu(
 				((struct unallocSpaceEntry *)bh->b_data)->
 				 lengthAllocDescs);
 		if (udf_alloc_i_data(inode, inode->i_sb->s_blocksize -
@@ -1214,7 +1224,7 @@ static void udf_fill_inode(struct inode 
 			make_bad_inode(inode);
 			return;
 		}
-		memcpy(UDF_I(inode)->i_ext.i_data,
+		memcpy(iinfo->i_ext.i_data,
 		       bh->b_data + sizeof(struct unallocSpaceEntry),
 		       inode->i_sb->s_blocksize -
 					sizeof(struct unallocSpaceEntry));
@@ -1238,12 +1248,12 @@ static void udf_fill_inode(struct inode 
 		inode->i_nlink = 1;
 
 	inode->i_size = le64_to_cpu(fe->informationLength);
-	UDF_I(inode)->i_lenExtents = inode->i_size;
+	iinfo->i_lenExtents = inode->i_size;
 
 	inode->i_mode = udf_convert_permissions(fe);
 	inode->i_mode &= ~UDF_SB(inode->i_sb)->s_umask;
 
-	if (UDF_I(inode)->i_efe == 0) {
+	if (iinfo->i_efe == 0) {
 		inode->i_blocks = le64_to_cpu(fe->logicalBlocksRecorded) <<
 			(inode->i_sb->s_blocksize_bits - 9);
 
@@ -1271,10 +1281,10 @@ static void udf_fill_inode(struct inode 
 			inode->i_ctime = sbi->s_record_time;
 		}
 
-		UDF_I(inode)->i_unique = le64_to_cpu(fe->uniqueID);
-		UDF_I(inode)->i_lenEAttr = le32_to_cpu(fe->lengthExtendedAttr);
-		UDF_I(inode)->i_lenAlloc = le32_to_cpu(fe->lengthAllocDescs);
-		offset = sizeof(struct fileEntry) + UDF_I(inode)->i_lenEAttr;
+		iinfo->i_unique = le64_to_cpu(fe->uniqueID);
+		iinfo->i_lenEAttr = le32_to_cpu(fe->lengthExtendedAttr);
+		iinfo->i_lenAlloc = le32_to_cpu(fe->lengthAllocDescs);
+		offset = sizeof(struct fileEntry) + iinfo->i_lenEAttr;
 	} else {
 		inode->i_blocks = le64_to_cpu(efe->logicalBlocksRecorded) <<
 		    (inode->i_sb->s_blocksize_bits - 9);
@@ -1297,10 +1307,10 @@ static void udf_fill_inode(struct inode 
 
 		if (udf_stamp_to_time(&convtime, &convtime_usec,
 				      lets_to_cpu(efe->createTime))) {
-			UDF_I(inode)->i_crtime.tv_sec = convtime;
-			UDF_I(inode)->i_crtime.tv_nsec = convtime_usec * 1000;
+			iinfo->i_crtime.tv_sec = convtime;
+			iinfo->i_crtime.tv_nsec = convtime_usec * 1000;
 		} else {
-			UDF_I(inode)->i_crtime = sbi->s_record_time;
+			iinfo->i_crtime = sbi->s_record_time;
 		}
 
 		if (udf_stamp_to_time(&convtime, &convtime_usec,
@@ -1311,11 +1321,11 @@ static void udf_fill_inode(struct inode 
 			inode->i_ctime = sbi->s_record_time;
 		}
 
-		UDF_I(inode)->i_unique = le64_to_cpu(efe->uniqueID);
-		UDF_I(inode)->i_lenEAttr = le32_to_cpu(efe->lengthExtendedAttr);
-		UDF_I(inode)->i_lenAlloc = le32_to_cpu(efe->lengthAllocDescs);
+		iinfo->i_unique = le64_to_cpu(efe->uniqueID);
+		iinfo->i_lenEAttr = le32_to_cpu(efe->lengthExtendedAttr);
+		iinfo->i_lenAlloc = le32_to_cpu(efe->lengthAllocDescs);
 		offset = sizeof(struct extendedFileEntry) +
-						UDF_I(inode)->i_lenEAttr;
+							iinfo->i_lenEAttr;
 	}
 
 	switch (fe->icbTag.fileType) {
@@ -1328,7 +1338,7 @@ static void udf_fill_inode(struct inode 
 	case ICBTAG_FILE_TYPE_REALTIME:
 	case ICBTAG_FILE_TYPE_REGULAR:
 	case ICBTAG_FILE_TYPE_UNDEF:
-		if (UDF_I(inode)->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
+		if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
 			inode->i_data.a_ops = &udf_adinicb_aops;
 		else
 			inode->i_data.a_ops = &udf_aops;
@@ -1375,9 +1385,10 @@ static void udf_fill_inode(struct inode 
 
 static int udf_alloc_i_data(struct inode *inode, size_t size)
 {
-	UDF_I(inode)->i_ext.i_data = kmalloc(size, GFP_KERNEL);
+	struct udf_inode_info *iinfo = UDF_I(inode);
+	iinfo->i_ext.i_data = kmalloc(size, GFP_KERNEL);
 
-	if (!UDF_I(inode)->i_ext.i_data) {
+	if (!iinfo->i_ext.i_data) {
 		printk(KERN_ERR "udf:udf_alloc_i_data (ino %ld) "
 				"no free memory\n", inode->i_ino);
 		return -ENOMEM;
@@ -1448,10 +1459,11 @@ static int udf_update_inode(struct inode
 	int err = 0;
 	struct udf_sb_info *sbi = UDF_SB(inode->i_sb);
 	unsigned char blocksize_bits = inode->i_sb->s_blocksize_bits;
+	struct udf_inode_info *iinfo = UDF_I(inode);
 
 	bh = udf_tread(inode->i_sb,
 			udf_get_lb_pblock(inode->i_sb,
-					  UDF_I(inode)->i_location, 0));
+					  iinfo->i_location, 0));
 	if (!bh) {
 		udf_debug("bread failure\n");
 		return -EIO;
@@ -1466,14 +1478,14 @@ static int udf_update_inode(struct inode
 		struct unallocSpaceEntry *use =
 			(struct unallocSpaceEntry *)bh->b_data;
 
-		use->lengthAllocDescs = cpu_to_le32(UDF_I(inode)->i_lenAlloc);
+		use->lengthAllocDescs = cpu_to_le32(iinfo->i_lenAlloc);
 		memcpy(bh->b_data + sizeof(struct unallocSpaceEntry),
-		       UDF_I(inode)->i_ext.i_data, inode->i_sb->s_blocksize -
+		       iinfo->i_ext.i_data, inode->i_sb->s_blocksize -
 					sizeof(struct unallocSpaceEntry));
 		crclen = sizeof(struct unallocSpaceEntry) +
-				UDF_I(inode)->i_lenAlloc - sizeof(tag);
+				iinfo->i_lenAlloc - sizeof(tag);
 		use->descTag.tagLocation = cpu_to_le32(
-						UDF_I(inode)->i_location.
+						iinfo->i_location.
 							logicalBlockNum);
 		use->descTag.descCRCLength = cpu_to_le16(crclen);
 		use->descTag.descCRC = cpu_to_le16(udf_crc((char *)use +
@@ -1538,9 +1550,9 @@ static int udf_update_inode(struct inode
 		dsea->minorDeviceIdent = cpu_to_le32(iminor(inode));
 	}
 
-	if (UDF_I(inode)->i_efe == 0) {
+	if (iinfo->i_efe == 0) {
 		memcpy(bh->b_data + sizeof(struct fileEntry),
-		       UDF_I(inode)->i_ext.i_data,
+		       iinfo->i_ext.i_data,
 		       inode->i_sb->s_blocksize - sizeof(struct fileEntry));
 		fe->logicalBlocksRecorded = cpu_to_le64(
 			(inode->i_blocks + (1 << (blocksize_bits - 9)) - 1) >>
@@ -1556,14 +1568,14 @@ static int udf_update_inode(struct inode
 		strcpy(fe->impIdent.ident, UDF_ID_DEVELOPER);
 		fe->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
 		fe->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
-		fe->uniqueID = cpu_to_le64(UDF_I(inode)->i_unique);
-		fe->lengthExtendedAttr = cpu_to_le32(UDF_I(inode)->i_lenEAttr);
-		fe->lengthAllocDescs = cpu_to_le32(UDF_I(inode)->i_lenAlloc);
+		fe->uniqueID = cpu_to_le64(iinfo->i_unique);
+		fe->lengthExtendedAttr = cpu_to_le32(iinfo->i_lenEAttr);
+		fe->lengthAllocDescs = cpu_to_le32(iinfo->i_lenAlloc);
 		fe->descTag.tagIdent = cpu_to_le16(TAG_IDENT_FE);
 		crclen = sizeof(struct fileEntry);
 	} else {
 		memcpy(bh->b_data + sizeof(struct extendedFileEntry),
-		       UDF_I(inode)->i_ext.i_data,
+		       iinfo->i_ext.i_data,
 		       inode->i_sb->s_blocksize -
 					sizeof(struct extendedFileEntry));
 		efe->objectSize = cpu_to_le64(inode->i_size);
@@ -1571,26 +1583,26 @@ static int udf_update_inode(struct inode
 			(inode->i_blocks + (1 << (blocksize_bits - 9)) - 1) >>
 			(blocksize_bits - 9));
 
-		if (UDF_I(inode)->i_crtime.tv_sec > inode->i_atime.tv_sec ||
-		    (UDF_I(inode)->i_crtime.tv_sec == inode->i_atime.tv_sec &&
-		     UDF_I(inode)->i_crtime.tv_nsec > inode->i_atime.tv_nsec))
-			UDF_I(inode)->i_crtime = inode->i_atime;
-
-		if (UDF_I(inode)->i_crtime.tv_sec > inode->i_mtime.tv_sec ||
-		    (UDF_I(inode)->i_crtime.tv_sec == inode->i_mtime.tv_sec &&
-		     UDF_I(inode)->i_crtime.tv_nsec > inode->i_mtime.tv_nsec))
-			UDF_I(inode)->i_crtime = inode->i_mtime;
-
-		if (UDF_I(inode)->i_crtime.tv_sec > inode->i_ctime.tv_sec ||
-		    (UDF_I(inode)->i_crtime.tv_sec == inode->i_ctime.tv_sec &&
-		     UDF_I(inode)->i_crtime.tv_nsec > inode->i_ctime.tv_nsec))
-			UDF_I(inode)->i_crtime = inode->i_ctime;
+		if (iinfo->i_crtime.tv_sec > inode->i_atime.tv_sec ||
+		    (iinfo->i_crtime.tv_sec == inode->i_atime.tv_sec &&
+		     iinfo->i_crtime.tv_nsec > inode->i_atime.tv_nsec))
+			iinfo->i_crtime = inode->i_atime;
+
+		if (iinfo->i_crtime.tv_sec > inode->i_mtime.tv_sec ||
+		    (iinfo->i_crtime.tv_sec == inode->i_mtime.tv_sec &&
+		     iinfo->i_crtime.tv_nsec > inode->i_mtime.tv_nsec))
+			iinfo->i_crtime = inode->i_mtime;
+
+		if (iinfo->i_crtime.tv_sec > inode->i_ctime.tv_sec ||
+		    (iinfo->i_crtime.tv_sec == inode->i_ctime.tv_sec &&
+		     iinfo->i_crtime.tv_nsec > inode->i_ctime.tv_nsec))
+			iinfo->i_crtime = inode->i_ctime;
 
 		if (udf_time_to_stamp(&cpu_time, inode->i_atime))
 			efe->accessTime = cpu_to_lets(cpu_time);
 		if (udf_time_to_stamp(&cpu_time, inode->i_mtime))
 			efe->modificationTime = cpu_to_lets(cpu_time);
-		if (udf_time_to_stamp(&cpu_time, UDF_I(inode)->i_crtime))
+		if (udf_time_to_stamp(&cpu_time, iinfo->i_crtime))
 			efe->createTime = cpu_to_lets(cpu_time);
 		if (udf_time_to_stamp(&cpu_time, inode->i_ctime))
 			efe->attrTime = cpu_to_lets(cpu_time);
@@ -1599,13 +1611,13 @@ static int udf_update_inode(struct inode
 		strcpy(efe->impIdent.ident, UDF_ID_DEVELOPER);
 		efe->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
 		efe->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
-		efe->uniqueID = cpu_to_le64(UDF_I(inode)->i_unique);
-		efe->lengthExtendedAttr = cpu_to_le32(UDF_I(inode)->i_lenEAttr);
-		efe->lengthAllocDescs = cpu_to_le32(UDF_I(inode)->i_lenAlloc);
+		efe->uniqueID = cpu_to_le64(iinfo->i_unique);
+		efe->lengthExtendedAttr = cpu_to_le32(iinfo->i_lenEAttr);
+		efe->lengthAllocDescs = cpu_to_le32(iinfo->i_lenAlloc);
 		efe->descTag.tagIdent = cpu_to_le16(TAG_IDENT_EFE);
 		crclen = sizeof(struct extendedFileEntry);
 	}
-	if (UDF_I(inode)->i_strat4096) {
+	if (iinfo->i_strat4096) {
 		fe->icbTag.strategyType = cpu_to_le16(4096);
 		fe->icbTag.strategyParameter = cpu_to_le16(1);
 		fe->icbTag.numEntries = cpu_to_le16(2);
@@ -1629,7 +1641,7 @@ static int udf_update_inode(struct inode
 	else if (S_ISSOCK(inode->i_mode))
 		fe->icbTag.fileType = ICBTAG_FILE_TYPE_SOCKET;
 
-	icbflags =	UDF_I(inode)->i_alloc_type |
+	icbflags =	iinfo->i_alloc_type |
 			((inode->i_mode & S_ISUID) ? ICBTAG_FLAG_SETUID : 0) |
 			((inode->i_mode & S_ISGID) ? ICBTAG_FLAG_SETGID : 0) |
 			((inode->i_mode & S_ISVTX) ? ICBTAG_FLAG_STICKY : 0) |
@@ -1644,8 +1656,8 @@ static int udf_update_inode(struct inode
 		fe->descTag.descVersion = cpu_to_le16(2);
 	fe->descTag.tagSerialNum = cpu_to_le16(sbi->s_serial_number);
 	fe->descTag.tagLocation = cpu_to_le32(
-				      UDF_I(inode)->i_location.logicalBlockNum);
-	crclen += UDF_I(inode)->i_lenEAttr + UDF_I(inode)->i_lenAlloc -
+					iinfo->i_location.logicalBlockNum);
+	crclen += iinfo->i_lenEAttr + iinfo->i_lenAlloc -
 								sizeof(tag);
 	fe->descTag.descCRCLength = cpu_to_le16(crclen);
 	fe->descTag.descCRC = cpu_to_le16(udf_crc((char *)fe + sizeof(tag),
@@ -1709,17 +1721,18 @@ int8_t udf_add_aext(struct inode *inode,
 	struct allocExtDesc *aed;
 	int8_t etype;
 	uint8_t *ptr;
+	struct udf_inode_info *iinfo = UDF_I(inode);
 
 	if (!epos->bh)
-		ptr = UDF_I(inode)->i_ext.i_data + epos->offset -
+		ptr = iinfo->i_ext.i_data + epos->offset -
 			udf_file_entry_alloc_offset(inode) +
-			UDF_I(inode)->i_lenEAttr;
+			iinfo->i_lenEAttr;
 	else
 		ptr = epos->bh->b_data + epos->offset;
 
-	if (UDF_I(inode)->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 		adsize = sizeof(short_ad);
-	else if (UDF_I(inode)->i_alloc_type == ICBTAG_FLAG_AD_LONG)
+	else if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
 		adsize = sizeof(long_ad);
 	else
 		return -1;
@@ -1769,7 +1782,7 @@ int8_t udf_add_aext(struct inode *inode,
 					cpu_to_le32(le32_to_cpu(
 					aed->lengthAllocDescs) + adsize);
 			} else {
-				UDF_I(inode)->i_lenAlloc += adsize;
+				iinfo->i_lenAlloc += adsize;
 				mark_inode_dirty(inode);
 			}
 		}
@@ -1779,7 +1792,7 @@ int8_t udf_add_aext(struct inode *inode,
 		else
 			udf_new_tag(nbh->b_data, TAG_IDENT_AED, 2, 1,
 				    epos->block.logicalBlockNum, sizeof(tag));
-		switch (UDF_I(inode)->i_alloc_type) {
+		switch (iinfo->i_alloc_type) {
 		case ICBTAG_FLAG_AD_SHORT:
 			sad = (short_ad *)sptr;
 			sad->extLength = cpu_to_le32(EXT_NEXT_EXTENT_ALLOCDECS |
@@ -1813,7 +1826,7 @@ int8_t udf_add_aext(struct inode *inode,
 	etype = udf_write_aext(inode, epos, eloc, elen, inc);
 
 	if (!epos->bh) {
-		UDF_I(inode)->i_lenAlloc += adsize;
+		iinfo->i_lenAlloc += adsize;
 		mark_inode_dirty(inode);
 	} else {
 		aed = (struct allocExtDesc *)epos->bh->b_data;
@@ -1840,15 +1853,16 @@ int8_t udf_write_aext(struct inode *inod
 	uint8_t *ptr;
 	short_ad *sad;
 	long_ad *lad;
+	struct udf_inode_info *iinfo = UDF_I(inode);
 
 	if (!epos->bh)
-		ptr = UDF_I(inode)->i_ext.i_data + epos->offset -
+		ptr = iinfo->i_ext.i_data + epos->offset -
 			udf_file_entry_alloc_offset(inode) +
-			UDF_I(inode)->i_lenEAttr;
+			iinfo->i_lenEAttr;
 	else
 		ptr = epos->bh->b_data + epos->offset;
 
-	switch (UDF_I(inode)->i_alloc_type) {
+	switch (iinfo->i_alloc_type) {
 	case ICBTAG_FLAG_AD_SHORT:
 		sad = (short_ad *)ptr;
 		sad->extLength = cpu_to_le32(elen);
@@ -1916,15 +1930,16 @@ int8_t udf_current_aext(struct inode *in
 	uint8_t *ptr;
 	short_ad *sad;
 	long_ad *lad;
+	struct udf_inode_info *iinfo = UDF_I(inode);
 
 	if (!epos->bh) {
 		if (!epos->offset)
 			epos->offset = udf_file_entry_alloc_offset(inode);
-		ptr = UDF_I(inode)->i_ext.i_data + epos->offset -
+		ptr = iinfo->i_ext.i_data + epos->offset -
 			udf_file_entry_alloc_offset(inode) +
-			UDF_I(inode)->i_lenEAttr;
+			iinfo->i_lenEAttr;
 		alen = udf_file_entry_alloc_offset(inode) +
-						UDF_I(inode)->i_lenAlloc;
+							iinfo->i_lenAlloc;
 	} else {
 		if (!epos->offset)
 			epos->offset = sizeof(struct allocExtDesc);
@@ -1934,7 +1949,7 @@ int8_t udf_current_aext(struct inode *in
 							lengthAllocDescs);
 	}
 
-	switch (UDF_I(inode)->i_alloc_type) {
+	switch (iinfo->i_alloc_type) {
 	case ICBTAG_FLAG_AD_SHORT:
 		sad = udf_get_fileshortad(ptr, alen, &epos->offset, inc);
 		if (!sad)
@@ -1942,7 +1957,7 @@ int8_t udf_current_aext(struct inode *in
 		etype = le32_to_cpu(sad->extLength) >> 30;
 		eloc->logicalBlockNum = le32_to_cpu(sad->extPosition);
 		eloc->partitionReferenceNum =
-				UDF_I(inode)->i_location.partitionReferenceNum;
+				iinfo->i_location.partitionReferenceNum;
 		*elen = le32_to_cpu(sad->extLength) & UDF_EXTENT_LENGTH_MASK;
 		break;
 	case ICBTAG_FLAG_AD_LONG:
@@ -1955,7 +1970,7 @@ int8_t udf_current_aext(struct inode *in
 		break;
 	default:
 		udf_debug("alloc_type = %d unsupported\n",
-				UDF_I(inode)->i_alloc_type);
+				iinfo->i_alloc_type);
 		return -1;
 	}
 
@@ -1990,15 +2005,17 @@ int8_t udf_delete_aext(struct inode *ino
 	int adsize;
 	int8_t etype;
 	struct allocExtDesc *aed;
+	struct udf_inode_info *iinfo;
 
 	if (epos.bh) {
 		get_bh(epos.bh);
 		get_bh(epos.bh);
 	}
 
-	if (UDF_I(inode)->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
+	iinfo = UDF_I(inode);
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 		adsize = sizeof(short_ad);
-	else if (UDF_I(inode)->i_alloc_type == ICBTAG_FLAG_AD_LONG)
+	else if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
 		adsize = sizeof(long_ad);
 	else
 		adsize = 0;
@@ -2025,7 +2042,7 @@ int8_t udf_delete_aext(struct inode *ino
 		udf_write_aext(inode, &oepos, eloc, elen, 1);
 		udf_write_aext(inode, &oepos, eloc, elen, 1);
 		if (!oepos.bh) {
-			UDF_I(inode)->i_lenAlloc -= (adsize * 2);
+			iinfo->i_lenAlloc -= (adsize * 2);
 			mark_inode_dirty(inode);
 		} else {
 			aed = (struct allocExtDesc *)oepos.bh->b_data;
@@ -2044,7 +2061,7 @@ int8_t udf_delete_aext(struct inode *ino
 	} else {
 		udf_write_aext(inode, &oepos, eloc, elen, 1);
 		if (!oepos.bh) {
-			UDF_I(inode)->i_lenAlloc -= adsize;
+			iinfo->i_lenAlloc -= adsize;
 			mark_inode_dirty(inode);
 		} else {
 			aed = (struct allocExtDesc *)oepos.bh->b_data;
@@ -2076,14 +2093,16 @@ int8_t inode_bmap(struct inode *inode, s
 	loff_t lbcount = 0, bcount =
 	    (loff_t) block << blocksize_bits;
 	int8_t etype;
+	struct udf_inode_info *iinfo;
 
 	if (block < 0) {
 		printk(KERN_ERR "udf: inode_bmap: block < 0\n");
 		return -1;
 	}
 
+	iinfo = UDF_I(inode);
 	pos->offset = 0;
-	pos->block = UDF_I(inode)->i_location;
+	pos->block = iinfo->i_location;
 	pos->bh = NULL;
 	*elen = 0;
 
@@ -2091,7 +2110,7 @@ int8_t inode_bmap(struct inode *inode, s
 		etype = udf_next_aext(inode, pos, eloc, elen, 1);
 		if (etype == -1) {
 			*offset = (bcount - lbcount) >> blocksize_bits;
-			UDF_I(inode)->i_lenExtents = lbcount;
+			iinfo->i_lenExtents = lbcount;
 			return -1;
 		}
 		lbcount += *elen;
diff -puN fs/udf/misc.c~udf-cache-struct-udf_inode_info fs/udf/misc.c
--- a/fs/udf/misc.c~udf-cache-struct-udf_inode_info
+++ a/fs/udf/misc.c
@@ -51,17 +51,18 @@ struct genericFormat *udf_add_extendedat
 	uint8_t *ea = NULL, *ad = NULL;
 	int offset;
 	uint16_t crclen;
+	struct udf_inode_info *iinfo = UDF_I(inode);
 
-	ea = UDF_I(inode)->i_ext.i_data;
-	if (UDF_I(inode)->i_lenEAttr) {
-		ad = UDF_I(inode)->i_ext.i_data + UDF_I(inode)->i_lenEAttr;
+	ea = iinfo->i_ext.i_data;
+	if (iinfo->i_lenEAttr) {
+		ad = iinfo->i_ext.i_data + iinfo->i_lenEAttr;
 	} else {
 		ad = ea;
 		size += sizeof(struct extendedAttrHeaderDesc);
 	}
 
 	offset = inode->i_sb->s_blocksize - udf_file_entry_alloc_offset(inode) -
-		UDF_I(inode)->i_lenAlloc;
+		iinfo->i_lenAlloc;
 
 	/* TODO - Check for FreeEASpace */
 
@@ -69,21 +70,21 @@ struct genericFormat *udf_add_extendedat
 		struct extendedAttrHeaderDesc *eahd;
 		eahd = (struct extendedAttrHeaderDesc *)ea;
 
-		if (UDF_I(inode)->i_lenAlloc)
-			memmove(&ad[size], ad, UDF_I(inode)->i_lenAlloc);
+		if (iinfo->i_lenAlloc)
+			memmove(&ad[size], ad, iinfo->i_lenAlloc);
 
-		if (UDF_I(inode)->i_lenEAttr) {
+		if (iinfo->i_lenEAttr) {
 			/* check checksum/crc */
 			if (eahd->descTag.tagIdent !=
 					cpu_to_le16(TAG_IDENT_EAHD) ||
 			    le32_to_cpu(eahd->descTag.tagLocation) !=
-					UDF_I(inode)->i_location.logicalBlockNum)
+					iinfo->i_location.logicalBlockNum)
 				return NULL;
 		} else {
 			struct udf_sb_info *sbi = UDF_SB(inode->i_sb);
 
 			size -= sizeof(struct extendedAttrHeaderDesc);
-			UDF_I(inode)->i_lenEAttr +=
+			iinfo->i_lenEAttr +=
 				sizeof(struct extendedAttrHeaderDesc);
 			eahd->descTag.tagIdent = cpu_to_le16(TAG_IDENT_EAHD);
 			if (sbi->s_udfrev >= 0x0200)
@@ -93,15 +94,15 @@ struct genericFormat *udf_add_extendedat
 			eahd->descTag.tagSerialNum =
 					cpu_to_le16(sbi->s_serial_number);
 			eahd->descTag.tagLocation = cpu_to_le32(
-				UDF_I(inode)->i_location.logicalBlockNum);
+					iinfo->i_location.logicalBlockNum);
 			eahd->impAttrLocation = cpu_to_le32(0xFFFFFFFF);
 			eahd->appAttrLocation = cpu_to_le32(0xFFFFFFFF);
 		}
 
-		offset = UDF_I(inode)->i_lenEAttr;
+		offset = iinfo->i_lenEAttr;
 		if (type < 2048) {
 			if (le32_to_cpu(eahd->appAttrLocation) <
-					UDF_I(inode)->i_lenEAttr) {
+					iinfo->i_lenEAttr) {
 				uint32_t aal =
 					le32_to_cpu(eahd->appAttrLocation);
 				memmove(&ea[offset - aal + size],
@@ -111,7 +112,7 @@ struct genericFormat *udf_add_extendedat
 						cpu_to_le32(aal + size);
 			}
 			if (le32_to_cpu(eahd->impAttrLocation) <
-					UDF_I(inode)->i_lenEAttr) {
+					iinfo->i_lenEAttr) {
 				uint32_t ial =
 					le32_to_cpu(eahd->impAttrLocation);
 				memmove(&ea[offset - ial + size],
@@ -122,7 +123,7 @@ struct genericFormat *udf_add_extendedat
 			}
 		} else if (type < 65536) {
 			if (le32_to_cpu(eahd->appAttrLocation) <
-					UDF_I(inode)->i_lenEAttr) {
+					iinfo->i_lenEAttr) {
 				uint32_t aal =
 					le32_to_cpu(eahd->appAttrLocation);
 				memmove(&ea[offset - aal + size],
@@ -138,7 +139,7 @@ struct genericFormat *udf_add_extendedat
 		eahd->descTag.descCRC = cpu_to_le16(udf_crc((char *)eahd +
 						sizeof(tag), crclen, 0));
 		eahd->descTag.tagChecksum = udf_tag_checksum(&eahd->descTag);
-		UDF_I(inode)->i_lenEAttr += size;
+		iinfo->i_lenEAttr += size;
 		return (struct genericFormat *)&ea[offset];
 	}
 	if (loc & 0x02)
@@ -153,10 +154,11 @@ struct genericFormat *udf_get_extendedat
 	struct genericFormat *gaf;
 	uint8_t *ea = NULL;
 	uint32_t offset;
+	struct udf_inode_info *iinfo = UDF_I(inode);
 
-	ea = UDF_I(inode)->i_ext.i_data;
+	ea = iinfo->i_ext.i_data;
 
-	if (UDF_I(inode)->i_lenEAttr) {
+	if (iinfo->i_lenEAttr) {
 		struct extendedAttrHeaderDesc *eahd;
 		eahd = (struct extendedAttrHeaderDesc *)ea;
 
@@ -164,7 +166,7 @@ struct genericFormat *udf_get_extendedat
 		if (eahd->descTag.tagIdent !=
 				cpu_to_le16(TAG_IDENT_EAHD) ||
 		    le32_to_cpu(eahd->descTag.tagLocation) !=
-				UDF_I(inode)->i_location.logicalBlockNum)
+				iinfo->i_location.logicalBlockNum)
 			return NULL;
 
 		if (type < 2048)
@@ -174,7 +176,7 @@ struct genericFormat *udf_get_extendedat
 		else
 			offset = le32_to_cpu(eahd->appAttrLocation);
 
-		while (offset < UDF_I(inode)->i_lenEAttr) {
+		while (offset < iinfo->i_lenEAttr) {
 			gaf = (struct genericFormat *)&ea[offset];
 			if (le32_to_cpu(gaf->attrType) == type &&
 					gaf->attrSubtype == subtype)
diff -puN fs/udf/namei.c~udf-cache-struct-udf_inode_info fs/udf/namei.c
--- a/fs/udf/namei.c~udf-cache-struct-udf_inode_info
+++ a/fs/udf/namei.c
@@ -158,23 +158,23 @@ static struct fileIdentDesc *udf_find_en
 	uint32_t elen;
 	sector_t offset;
 	struct extent_position epos = {};
+	struct udf_inode_info *dinfo = UDF_I(dir);
 
 	size = (udf_ext0_offset(dir) + dir->i_size) >> 2;
 	f_pos = (udf_ext0_offset(dir) >> 2);
 
 	fibh->soffset = fibh->eoffset =
 		(f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
-	if (UDF_I(dir)->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
+	if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
 		fibh->sbh = fibh->ebh = NULL;
 	else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
 			      &epos, &eloc, &elen, &offset) ==
 					(EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
 		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
-			if (UDF_I(dir)->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
+			if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 				epos.offset -= sizeof(short_ad);
-			else if (UDF_I(dir)->i_alloc_type ==
-							ICBTAG_FLAG_AD_LONG)
+			else if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
 				epos.offset -= sizeof(long_ad);
 		} else
 			offset = 0;
@@ -351,6 +351,7 @@ static struct fileIdentDesc *udf_add_ent
 	uint32_t elen;
 	sector_t offset;
 	struct extent_position epos = {};
+	struct udf_inode_info *dinfo;
 
 	if (dentry) {
 		if (!dentry->d_name.len) {
@@ -373,17 +374,17 @@ static struct fileIdentDesc *udf_add_ent
 
 	fibh->soffset = fibh->eoffset =
 			(f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
-	if (UDF_I(dir)->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
+	dinfo = UDF_I(dir);
+	if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
 		fibh->sbh = fibh->ebh = NULL;
 	else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
 			      &epos, &eloc, &elen, &offset) ==
 					(EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
 		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
-			if (UDF_I(dir)->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
+			if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 				epos.offset -= sizeof(short_ad);
-			else if (UDF_I(dir)->i_alloc_type ==
-							ICBTAG_FLAG_AD_LONG)
+			else if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
 				epos.offset -= sizeof(long_ad);
 		} else
 			offset = 0;
@@ -395,10 +396,10 @@ static struct fileIdentDesc *udf_add_ent
 			return NULL;
 		}
 
-		block = UDF_I(dir)->i_location.logicalBlockNum;
+		block = dinfo->i_location.logicalBlockNum;
 
 	} else {
-		block = udf_get_lb_pblock(dir->i_sb, UDF_I(dir)->i_location, 0);
+		block = udf_get_lb_pblock(dir->i_sb, dinfo->i_location, 0);
 		fibh->sbh = fibh->ebh = NULL;
 		fibh->soffset = fibh->eoffset = sb->s_blocksize;
 		goto add;
@@ -477,7 +478,7 @@ static struct fileIdentDesc *udf_add_ent
 add:
 	f_pos += nfidlen;
 
-	if (UDF_I(dir)->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB &&
+	if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB &&
 	    sb->s_blocksize - fibh->eoffset < nfidlen) {
 		brelse(epos.bh);
 		epos.bh = NULL;
@@ -491,15 +492,15 @@ add:
 				udf_expand_dir_adinicb(dir, &block, err);
 		if (!fibh->sbh)
 			return NULL;
-		epos.block = UDF_I(dir)->i_location;
+		epos.block = dinfo->i_location;
 		eloc.logicalBlockNum = block;
 		eloc.partitionReferenceNum =
-				UDF_I(dir)->i_location.partitionReferenceNum;
+				dinfo->i_location.partitionReferenceNum;
 		elen = dir->i_sb->s_blocksize;
 		epos.offset = udf_file_entry_alloc_offset(dir);
-		if (UDF_I(dir)->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
+		if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 			epos.offset += sizeof(short_ad);
-		else if (UDF_I(dir)->i_alloc_type == ICBTAG_FLAG_AD_LONG)
+		else if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
 			epos.offset += sizeof(long_ad);
 	}
 
@@ -511,13 +512,13 @@ add:
 			fibh->sbh = fibh->ebh;
 		}
 
-		if (UDF_I(dir)->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
-			block = UDF_I(dir)->i_location.logicalBlockNum;
+		if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
+			block = dinfo->i_location.logicalBlockNum;
 			fi = (struct fileIdentDesc *)
-					(UDF_I(dir)->i_ext.i_data +
+					(dinfo->i_ext.i_data +
 					 fibh->soffset -
 					 udf_ext0_offset(dir) +
-					 UDF_I(dir)->i_lenEAttr);
+					 dinfo->i_lenEAttr);
 		} else {
 			block = eloc.logicalBlockNum +
 					((elen - 1) >>
@@ -575,8 +576,8 @@ add:
 	if (!udf_write_fi(dir, cfi, fi, fibh, NULL, name)) {
 		brelse(epos.bh);
 		dir->i_size += nfidlen;
-		if (UDF_I(dir)->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
-			UDF_I(dir)->i_lenAlloc += nfidlen;
+		if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
+			dinfo->i_lenAlloc += nfidlen;
 		mark_inode_dirty(dir);
 		return fi;
 	} else {
@@ -608,6 +609,7 @@ static int udf_create(struct inode *dir,
 	struct inode *inode;
 	struct fileIdentDesc cfi, *fi;
 	int err;
+	struct udf_inode_info *iinfo;
 
 	lock_kernel();
 	inode = udf_new_inode(dir, mode, &err);
@@ -616,7 +618,8 @@ static int udf_create(struct inode *dir,
 		return err;
 	}
 
-	if (UDF_I(inode)->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
+	iinfo = UDF_I(inode);
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
 		inode->i_data.a_ops = &udf_adinicb_aops;
 	else
 		inode->i_data.a_ops = &udf_aops;
@@ -634,9 +637,9 @@ static int udf_create(struct inode *dir,
 		return err;
 	}
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
-	cfi.icb.extLocation = cpu_to_lelb(UDF_I(inode)->i_location);
+	cfi.icb.extLocation = cpu_to_lelb(iinfo->i_location);
 	*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
-		cpu_to_le32(UDF_I(inode)->i_unique & 0x00000000FFFFFFFFUL);
+		cpu_to_le32(iinfo->i_unique & 0x00000000FFFFFFFFUL);
 	udf_write_fi(dir, &cfi, fi, &fibh, NULL, NULL);
 	if (UDF_I(dir)->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
 		mark_inode_dirty(dir);
@@ -656,6 +659,7 @@ static int udf_mknod(struct inode *dir, 
 	struct udf_fileident_bh fibh;
 	struct fileIdentDesc cfi, *fi;
 	int err;
+	struct udf_inode_info *iinfo;
 
 	if (!old_valid_dev(rdev))
 		return -EINVAL;
@@ -666,6 +670,7 @@ static int udf_mknod(struct inode *dir, 
 	if (!inode)
 		goto out;
 
+	iinfo = UDF_I(inode);
 	inode->i_uid = current->fsuid;
 	init_special_inode(inode, mode, rdev);
 	fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err);
@@ -677,9 +682,9 @@ static int udf_mknod(struct inode *dir, 
 		return err;
 	}
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
-	cfi.icb.extLocation = cpu_to_lelb(UDF_I(inode)->i_location);
+	cfi.icb.extLocation = cpu_to_lelb(iinfo->i_location);
 	*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
-		cpu_to_le32(UDF_I(inode)->i_unique & 0x00000000FFFFFFFFUL);
+		cpu_to_le32(iinfo->i_unique & 0x00000000FFFFFFFFUL);
 	udf_write_fi(dir, &cfi, fi, &fibh, NULL, NULL);
 	if (UDF_I(dir)->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
 		mark_inode_dirty(dir);
@@ -702,6 +707,8 @@ static int udf_mkdir(struct inode *dir, 
 	struct udf_fileident_bh fibh;
 	struct fileIdentDesc cfi, *fi;
 	int err;
+	struct udf_inode_info *dinfo = UDF_I(dir);
+	struct udf_inode_info *iinfo;
 
 	lock_kernel();
 	err = -EMLINK;
@@ -713,6 +720,7 @@ static int udf_mkdir(struct inode *dir, 
 	if (!inode)
 		goto out;
 
+	iinfo = UDF_I(inode);
 	inode->i_op = &udf_dir_inode_operations;
 	inode->i_fop = &udf_dir_operations;
 	fi = udf_add_entry(inode, NULL, &fibh, &cfi, &err);
@@ -724,9 +732,9 @@ static int udf_mkdir(struct inode *dir, 
 	}
 	inode->i_nlink = 2;
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
-	cfi.icb.extLocation = cpu_to_lelb(UDF_I(dir)->i_location);
+	cfi.icb.extLocation = cpu_to_lelb(dinfo->i_location);
 	*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
-		cpu_to_le32(UDF_I(dir)->i_unique & 0x00000000FFFFFFFFUL);
+		cpu_to_le32(dinfo->i_unique & 0x00000000FFFFFFFFUL);
 	cfi.fileCharacteristics =
 			FID_FILE_CHAR_DIRECTORY | FID_FILE_CHAR_PARENT;
 	udf_write_fi(inode, &cfi, fi, &fibh, NULL, NULL);
@@ -744,9 +752,9 @@ static int udf_mkdir(struct inode *dir, 
 		goto out;
 	}
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
-	cfi.icb.extLocation = cpu_to_lelb(UDF_I(inode)->i_location);
+	cfi.icb.extLocation = cpu_to_lelb(iinfo->i_location);
 	*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
-		cpu_to_le32(UDF_I(inode)->i_unique & 0x00000000FFFFFFFFUL);
+		cpu_to_le32(iinfo->i_unique & 0x00000000FFFFFFFFUL);
 	cfi.fileCharacteristics |= FID_FILE_CHAR_DIRECTORY;
 	udf_write_fi(dir, &cfi, fi, &fibh, NULL, NULL);
 	inc_nlink(dir);
@@ -773,23 +781,23 @@ static int empty_dir(struct inode *dir)
 	uint32_t elen;
 	sector_t offset;
 	struct extent_position epos = {};
+	struct udf_inode_info *dinfo = UDF_I(dir);
 
 	f_pos = (udf_ext0_offset(dir) >> 2);
 
 	fibh.soffset = fibh.eoffset =
 			(f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
 
-	if (UDF_I(dir)->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
+	if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
 		fibh.sbh = fibh.ebh = NULL;
 	else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
 			      &epos, &eloc, &elen, &offset) ==
 					(EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
 		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
-			if (UDF_I(dir)->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
+			if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 				epos.offset -= sizeof(short_ad);
-			else if (UDF_I(dir)->i_alloc_type ==
-							ICBTAG_FLAG_AD_LONG)
+			else if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
 				epos.offset -= sizeof(long_ad);
 		} else
 			offset = 0;
@@ -939,38 +947,40 @@ static int udf_symlink(struct inode *dir
 	char name[UDF_NAME_LEN];
 	int namelen;
 	struct buffer_head *bh;
+	struct udf_inode_info *iinfo;
 
 	lock_kernel();
 	inode = udf_new_inode(dir, S_IFLNK, &err);
 	if (!inode)
 		goto out;
 
+	iinfo = UDF_I(inode);
 	inode->i_mode = S_IFLNK | S_IRWXUGO;
 	inode->i_data.a_ops = &udf_symlink_aops;
 	inode->i_op = &page_symlink_inode_operations;
 
-	if (UDF_I(inode)->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB) {
+	if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB) {
 		kernel_lb_addr eloc;
 		uint32_t elen;
 
 		block = udf_new_block(inode->i_sb, inode,
-				UDF_I(inode)->i_location.partitionReferenceNum,
-				UDF_I(inode)->i_location.logicalBlockNum, &err);
+				iinfo->i_location.partitionReferenceNum,
+				iinfo->i_location.logicalBlockNum, &err);
 		if (!block)
 			goto out_no_entry;
-		epos.block = UDF_I(inode)->i_location;
+		epos.block = iinfo->i_location;
 		epos.offset = udf_file_entry_alloc_offset(inode);
 		epos.bh = NULL;
 		eloc.logicalBlockNum = block;
 		eloc.partitionReferenceNum =
-				UDF_I(inode)->i_location.partitionReferenceNum;
+				iinfo->i_location.partitionReferenceNum;
 		elen = inode->i_sb->s_blocksize;
-		UDF_I(inode)->i_lenExtents = elen;
+		iinfo->i_lenExtents = elen;
 		udf_add_aext(inode, &epos, eloc, elen, 0);
 		brelse(epos.bh);
 
 		block = udf_get_pblock(inode->i_sb, block,
-				UDF_I(inode)->i_location.partitionReferenceNum,
+				iinfo->i_location.partitionReferenceNum,
 				0);
 		epos.bh = udf_tread(inode->i_sb, block);
 		lock_buffer(epos.bh);
@@ -979,9 +989,8 @@ static int udf_symlink(struct inode *dir
 		unlock_buffer(epos.bh);
 		mark_buffer_dirty_inode(epos.bh, inode);
 		ea = epos.bh->b_data + udf_ext0_offset(inode);
-	} else {
-		ea = UDF_I(inode)->i_ext.i_data + UDF_I(inode)->i_lenEAttr;
-	}
+	} else
+		ea = iinfo->i_ext.i_data + iinfo->i_lenEAttr;
 
 	eoffset = inode->i_sb->s_blocksize - udf_ext0_offset(inode);
 	pc = (struct pathComponent *)ea;
@@ -1049,15 +1058,15 @@ static int udf_symlink(struct inode *dir
 
 	brelse(epos.bh);
 	inode->i_size = elen;
-	if (UDF_I(inode)->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
-		UDF_I(inode)->i_lenAlloc = inode->i_size;
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
+		iinfo->i_lenAlloc = inode->i_size;
 	mark_inode_dirty(inode);
 
 	fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err);
 	if (!fi)
 		goto out_no_entry;
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
-	cfi.icb.extLocation = cpu_to_lelb(UDF_I(inode)->i_location);
+	cfi.icb.extLocation = cpu_to_lelb(iinfo->i_location);
 	bh = UDF_SB(inode->i_sb)->s_lvid_bh;
 	if (bh) {
 		struct logicalVolIntegrityDesc *lvid =
@@ -1162,6 +1171,7 @@ static int udf_rename(struct inode *old_
 	struct buffer_head *dir_bh = NULL;
 	int retval = -ENOENT;
 	kernel_lb_addr tloc;
+	struct udf_inode_info *old_iinfo = UDF_I(old_inode);
 
 	lock_kernel();
 	ofi = udf_find_entry(old_dir, old_dentry, &ofibh, &ocfi);
@@ -1193,10 +1203,10 @@ static int udf_rename(struct inode *old_
 				goto end_rename;
 		}
 		retval = -EIO;
-		if (UDF_I(old_inode)->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
+		if (old_iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
 			dir_fi = udf_get_fileident(
-					UDF_I(old_inode)->i_ext.i_data -
-					  (UDF_I(old_inode)->i_efe ?
+					old_iinfo->i_ext.i_data -
+					  (old_iinfo->i_efe ?
 					   sizeof(struct extendedFileEntry) :
 					   sizeof(struct fileEntry)),
 					old_inode->i_sb->s_blocksize, &offset);
@@ -1258,7 +1268,7 @@ static int udf_rename(struct inode *old_
 		udf_update_tag((char *)dir_fi,
 				(sizeof(struct fileIdentDesc) +
 				le16_to_cpu(dir_fi->lengthOfImpUse) + 3) & ~3);
-		if (UDF_I(old_inode)->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
+		if (old_iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
 			mark_inode_dirty(old_inode);
 		else
 			mark_buffer_dirty_inode(dir_bh, old_inode);
diff -puN fs/udf/partition.c~udf-cache-struct-udf_inode_info fs/udf/partition.c
--- a/fs/udf/partition.c~udf-cache-struct-udf_inode_info
+++ a/fs/udf/partition.c
@@ -55,6 +55,7 @@ uint32_t udf_get_pblock_virt15(struct su
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct udf_part_map *map;
 	struct udf_virtual_data *vdata;
+	struct udf_inode_info *iinfo;
 
 	map = &sbi->s_partmaps[partition];
 	vdata = &map->s_type_specific.s_virtual;
@@ -88,15 +89,14 @@ uint32_t udf_get_pblock_virt15(struct su
 
 	brelse(bh);
 
-	if (UDF_I(sbi->s_vat_inode)->i_location.partitionReferenceNum ==
-								partition) {
+	iinfo = UDF_I(sbi->s_vat_inode);
+	if (iinfo->i_location.partitionReferenceNum == partition) {
 		udf_debug("recursive call to udf_get_pblock!\n");
 		return 0xFFFFFFFF;
 	}
 
 	return udf_get_pblock(sb, loc,
-			      UDF_I(sbi->s_vat_inode)->i_location.
-							partitionReferenceNum,
+			      iinfo->i_location.partitionReferenceNum,
 			      offset);
 }
 
diff -puN fs/udf/symlink.c~udf-cache-struct-udf_inode_info fs/udf/symlink.c
--- a/fs/udf/symlink.c~udf-cache-struct-udf_inode_info
+++ a/fs/udf/symlink.c
@@ -79,10 +79,12 @@ static int udf_symlink_filler(struct fil
 	char *symlink;
 	int err = -EIO;
 	char *p = kmap(page);
+	struct udf_inode_info *iinfo;
 
 	lock_kernel();
-	if (UDF_I(inode)->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
-		symlink = UDF_I(inode)->i_ext.i_data + UDF_I(inode)->i_lenEAttr;
+	iinfo = UDF_I(inode);
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
+		symlink = iinfo->i_ext.i_data + iinfo->i_lenEAttr;
 	} else {
 		bh = sb_bread(inode->i_sb, udf_block_map(inode, 0));
 
diff -puN fs/udf/truncate.c~udf-cache-struct-udf_inode_info fs/udf/truncate.c
--- a/fs/udf/truncate.c~udf-cache-struct-udf_inode_info
+++ a/fs/udf/truncate.c
@@ -74,17 +74,18 @@ void udf_truncate_tail_extent(struct ino
 	uint64_t lbcount = 0;
 	int8_t etype = -1, netype;
 	int adsize;
+	struct udf_inode_info *iinfo = UDF_I(inode);
 
-	if (UDF_I(inode)->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB ||
-	    inode->i_size == UDF_I(inode)->i_lenExtents)
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB ||
+	    inode->i_size == iinfo->i_lenExtents)
 		return;
 	/* Are we going to delete the file anyway? */
 	if (inode->i_nlink == 0)
 		return;
 
-	if (UDF_I(inode)->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 		adsize = sizeof(short_ad);
-	else if (UDF_I(inode)->i_alloc_type == ICBTAG_FLAG_AD_LONG)
+	else if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
 		adsize = sizeof(long_ad);
 	else
 		BUG();
@@ -117,7 +118,7 @@ void udf_truncate_tail_extent(struct ino
 	}
 	/* This inode entry is in-memory only and thus we don't have to mark
 	 * the inode dirty */
-	UDF_I(inode)->i_lenExtents = inode->i_size;
+	iinfo->i_lenExtents = inode->i_size;
 	brelse(epos.bh);
 }
 
@@ -129,19 +130,20 @@ void udf_discard_prealloc(struct inode *
 	uint64_t lbcount = 0;
 	int8_t etype = -1, netype;
 	int adsize;
+	struct udf_inode_info *iinfo = UDF_I(inode);
 
-	if (UDF_I(inode)->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB ||
-	    inode->i_size == UDF_I(inode)->i_lenExtents)
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB ||
+	    inode->i_size == iinfo->i_lenExtents)
 		return;
 
-	if (UDF_I(inode)->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 		adsize = sizeof(short_ad);
-	else if (UDF_I(inode)->i_alloc_type == ICBTAG_FLAG_AD_LONG)
+	else if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
 		adsize = sizeof(long_ad);
 	else
 		adsize = 0;
 
-	epos.block = UDF_I(inode)->i_location;
+	epos.block = iinfo->i_location;
 
 	/* Find the last extent in the file */
 	while ((netype = udf_next_aext(inode, &epos, &eloc, &elen, 1)) != -1) {
@@ -153,7 +155,7 @@ void udf_discard_prealloc(struct inode *
 		lbcount -= elen;
 		extent_trunc(inode, &epos, eloc, etype, elen, 0);
 		if (!epos.bh) {
-			UDF_I(inode)->i_lenAlloc =
+			iinfo->i_lenAlloc =
 				epos.offset -
 				udf_file_entry_alloc_offset(inode);
 			mark_inode_dirty(inode);
@@ -174,7 +176,7 @@ void udf_discard_prealloc(struct inode *
 	}
 	/* This inode entry is in-memory only and thus we don't have to mark
 	 * the inode dirty */
-	UDF_I(inode)->i_lenExtents = lbcount;
+	iinfo->i_lenExtents = lbcount;
 	brelse(epos.bh);
 }
 
@@ -189,10 +191,11 @@ void udf_truncate_extents(struct inode *
 	sector_t first_block = inode->i_size >> sb->s_blocksize_bits, offset;
 	loff_t byte_offset;
 	int adsize;
+	struct udf_inode_info *iinfo = UDF_I(inode);
 
-	if (UDF_I(inode)->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 		adsize = sizeof(short_ad);
-	else if (UDF_I(inode)->i_alloc_type == ICBTAG_FLAG_AD_LONG)
+	else if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
 		adsize = sizeof(long_ad);
 	else
 		BUG();
@@ -227,7 +230,7 @@ void udf_truncate_extents(struct inode *
 							0, indirect_ext_len);
 				} else {
 					if (!epos.bh) {
-						UDF_I(inode)->i_lenAlloc =
+						iinfo->i_lenAlloc =
 								lenalloc;
 						mark_inode_dirty(inode);
 					} else {
@@ -275,7 +278,7 @@ void udf_truncate_extents(struct inode *
 					indirect_ext_len);
 		} else {
 			if (!epos.bh) {
-				UDF_I(inode)->i_lenAlloc = lenalloc;
+				iinfo->i_lenAlloc = lenalloc;
 				mark_inode_dirty(inode);
 			} else {
 				struct allocExtDesc *aed =
@@ -325,7 +328,7 @@ void udf_truncate_extents(struct inode *
 						(sb->s_blocksize - 1)) != 0));
 		}
 	}
-	UDF_I(inode)->i_lenExtents = inode->i_size;
+	iinfo->i_lenExtents = inode->i_size;
 
 	brelse(epos.bh);
 }
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
