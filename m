From: akpm@linux-foundation.org
Subject: - udf-coding-style-conversion-lindent-fixups-2.patch removed from -mm tree
Date: Mon, 09 Jul 2007 14:50:46 -0700
Message-ID: <200707092150.l69LokN7014238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53730 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754439AbXGIVvY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 17:51:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     UDF: coding style conversion - lindent fixups 2
has been removed from the -mm tree.  Its filename was
     udf-coding-style-conversion-lindent-fixups-2.patch

This patch was dropped because it was folded into udf-coding-style-conversion-lindent.patch

------------------------------------------------------
Subject: UDF: coding style conversion - lindent fixups 2
From: Cyrill Gorcunov <gorcunov@gmail.com>

This patch fixes sources were converted to kernel coding style by Lindent
for first and then by hands.  But some messed things were accidentally
skipped.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/inode.c    |   14 +++--
 fs/udf/truncate.c |  109 ++++++++++++++------------------------------
 2 files changed, 45 insertions(+), 78 deletions(-)

diff -puN fs/udf/inode.c~udf-coding-style-conversion-lindent-fixups-2 fs/udf/inode.c
--- a/fs/udf/inode.c~udf-coding-style-conversion-lindent-fixups-2
+++ a/fs/udf/inode.c
@@ -1103,7 +1103,8 @@ static void udf_fill_inode(struct inode 
 			make_bad_inode(inode);
 			return;
 		}
-		memcpy(UDF_I_DATA(inode), bh->b_data + sizeof(struct extendedFileEntry), inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry));
+		memcpy(UDF_I_DATA(inode), bh->b_data + sizeof(struct extendedFileEntry),
+		       inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry));
 	} else if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_FE) {
 		UDF_I_EFE(inode) = 0;
 		UDF_I_USE(inode) = 0;
@@ -1805,7 +1806,8 @@ int8_t udf_current_aext(struct inode * i
 		if (!epos->offset)
 			epos->offset = sizeof(struct allocExtDesc);
 		ptr = epos->bh->b_data + epos->offset;
-		alen = sizeof(struct allocExtDesc) + le32_to_cpu(((struct allocExtDesc *)epos->bh->b_data)->lengthAllocDescs);
+		alen = sizeof(struct allocExtDesc) +
+			le32_to_cpu(((struct allocExtDesc *)epos->bh->b_data)->lengthAllocDescs);
 	}
 
 	switch (UDF_I_ALLOCTYPE(inode)) {
@@ -1832,9 +1834,8 @@ int8_t udf_current_aext(struct inode * i
 	return etype;
 }
 
-static int8_t
-udf_insert_aext(struct inode *inode, struct extent_position epos,
-		kernel_lb_addr neloc, uint32_t nelen)
+static int8_t udf_insert_aext(struct inode *inode, struct extent_position epos,
+			      kernel_lb_addr neloc, uint32_t nelen)
 {
 	kernel_lb_addr oeloc;
 	uint32_t oelen;
@@ -1918,7 +1919,8 @@ int8_t udf_delete_aext(struct inode * in
 			aed = (struct allocExtDesc *)oepos.bh->b_data;
 			aed->lengthAllocDescs =
 				cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) - adsize);
-			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) || UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
+			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
+			    UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
 				udf_update_tag(oepos.bh->b_data, epos.offset - adsize);
 			else
 				udf_update_tag(oepos.bh->b_data, sizeof(struct allocExtDesc));
diff -puN fs/udf/truncate.c~udf-coding-style-conversion-lindent-fixups-2 fs/udf/truncate.c
--- a/fs/udf/truncate.c~udf-coding-style-conversion-lindent-fixups-2
+++ a/fs/udf/truncate.c
@@ -33,12 +33,10 @@ static void extent_trunc(struct inode *i
 			 uint32_t nelen)
 {
 	kernel_lb_addr neloc = {};
-	int last_block =
-	    (elen + inode->i_sb->s_blocksize -
-	     1) >> inode->i_sb->s_blocksize_bits;
-	int first_block =
-	    (nelen + inode->i_sb->s_blocksize -
-	     1) >> inode->i_sb->s_blocksize_bits;
+	int last_block = (elen + inode->i_sb->s_blocksize - 1) >>
+		inode->i_sb->s_blocksize_bits;
+	int first_block = (nelen + inode->i_sb->s_blocksize - 1) >>
+		inode->i_sb->s_blocksize_bits;
 
 	if (nelen) {
 		if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
@@ -156,16 +154,16 @@ void udf_discard_prealloc(struct inode *
 		extent_trunc(inode, &epos, eloc, etype, elen, 0);
 		if (!epos.bh) {
 			UDF_I_LENALLOC(inode) =
-			    epos.offset - udf_file_entry_alloc_offset(inode);
+				epos.offset - udf_file_entry_alloc_offset(inode);
 			mark_inode_dirty(inode);
 		} else {
 			struct allocExtDesc *aed =
-			    (struct allocExtDesc *)(epos.bh->b_data);
+				(struct allocExtDesc *)(epos.bh->b_data);
 			aed->lengthAllocDescs =
-			    cpu_to_le32(epos.offset -
-					sizeof(struct allocExtDesc));
-			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT)
-			    || UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
+				cpu_to_le32(epos.offset -
+					    sizeof(struct allocExtDesc));
+			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
+			    UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
 				udf_update_tag(epos.bh->b_data, epos.offset);
 			else
 				udf_update_tag(epos.bh->b_data,
@@ -182,7 +180,7 @@ void udf_discard_prealloc(struct inode *
 void udf_truncate_extents(struct inode *inode)
 {
 	struct extent_position epos;
-	kernel_lb_addr eloc, neloc = { 0, 0 };
+	kernel_lb_addr eloc, neloc = {};
 	uint32_t elen, nelen = 0, indirect_ext_len = 0, lenalloc;
 	int8_t etype;
 	struct super_block *sb = inode->i_sb;
@@ -198,9 +196,8 @@ void udf_truncate_extents(struct inode *
 		BUG();
 
 	etype = inode_bmap(inode, first_block, &epos, &eloc, &elen, &offset);
-	byte_offset =
-	    (offset << sb->s_blocksize_bits) +
-	    (inode->i_size & (sb->s_blocksize - 1));
+	byte_offset = (offset << sb->s_blocksize_bits) +
+		(inode->i_size & (sb->s_blocksize - 1));
 	if (etype != -1) {
 		epos.offset -= adsize;
 		extent_trunc(inode, &epos, eloc, etype, elen, byte_offset);
@@ -215,9 +212,7 @@ void udf_truncate_extents(struct inode *
 		else
 			lenalloc -= sizeof(struct allocExtDesc);
 
-		while ((etype =
-			udf_current_aext(inode, &epos, &eloc, &elen,
-					 0)) != -1) {
+		while ((etype = udf_current_aext(inode, &epos, &eloc, &elen, 0)) != -1) {
 			if (etype == (EXT_NEXT_EXTENT_ALLOCDECS >> 30)) {
 				udf_write_aext(inode, &epos, neloc, nelen, 0);
 				if (indirect_ext_len) {
@@ -229,52 +224,35 @@ void udf_truncate_extents(struct inode *
 							0, indirect_ext_len);
 				} else {
 					if (!epos.bh) {
-						UDF_I_LENALLOC(inode) =
-						    lenalloc;
+						UDF_I_LENALLOC(inode) = lenalloc;
 						mark_inode_dirty(inode);
 					} else {
 						struct allocExtDesc *aed =
-						    (struct allocExtDesc
-						     *)(epos.bh->b_data);
+							(struct allocExtDesc *)(epos.bh->b_data);
 						aed->lengthAllocDescs =
 						    cpu_to_le32(lenalloc);
-						if (!UDF_QUERY_FLAG
-						    (sb, UDF_FLAG_STRICT)
-						    || UDF_SB_UDFREV(sb) >=
-						    0x0201)
-							udf_update_tag(epos.bh->
-								       b_data,
-								       lenalloc
-								       +
-								       sizeof
-								       (struct
-									allocExtDesc));
+						if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT) ||
+						    UDF_SB_UDFREV(sb) >= 0x0201)
+							udf_update_tag(epos.bh->b_data,
+								       lenalloc +
+								       sizeof(struct allocExtDesc));
 						else
-							udf_update_tag(epos.bh->
-								       b_data,
-								       sizeof
-								       (struct
-									allocExtDesc));
-						mark_buffer_dirty_inode(epos.bh,
-									inode);
+							udf_update_tag(epos.bh->b_data,
+								       sizeof(struct allocExtDesc));
+						mark_buffer_dirty_inode(epos.bh, inode);
 					}
 				}
 				brelse(epos.bh);
 				epos.offset = sizeof(struct allocExtDesc);
 				epos.block = eloc;
-				epos.bh =
-				    udf_tread(sb,
-					      udf_get_lb_pblock(sb, eloc, 0));
+				epos.bh = udf_tread(sb, udf_get_lb_pblock(sb, eloc, 0));
 				if (elen)
-					indirect_ext_len = (elen +
-							    sb->s_blocksize -
-							    1) >> sb->
-					    s_blocksize_bits;
+					indirect_ext_len = (elen + sb->s_blocksize -1) >>
+						sb->s_blocksize_bits;
 				else
 					indirect_ext_len = 1;
 			} else {
-				extent_trunc(inode, &epos, eloc, etype, elen,
-					     0);
+				extent_trunc(inode, &epos, eloc, etype, elen, 0);
 				epos.offset += adsize;
 			}
 		}
@@ -292,16 +270,13 @@ void udf_truncate_extents(struct inode *
 				struct allocExtDesc *aed =
 				    (struct allocExtDesc *)(epos.bh->b_data);
 				aed->lengthAllocDescs = cpu_to_le32(lenalloc);
-				if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT)
-				    || UDF_SB_UDFREV(sb) >= 0x0201)
+				if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT) ||
+				    UDF_SB_UDFREV(sb) >= 0x0201)
 					udf_update_tag(epos.bh->b_data,
-						       lenalloc +
-						       sizeof(struct
-							      allocExtDesc));
+						       lenalloc + sizeof(struct allocExtDesc));
 				else
 					udf_update_tag(epos.bh->b_data,
-						       sizeof(struct
-							      allocExtDesc));
+						       sizeof(struct allocExtDesc));
 				mark_buffer_dirty_inode(epos.bh, inode);
 			}
 		}
@@ -314,21 +289,14 @@ void udf_truncate_extents(struct inode *
 			 *  no extent above inode->i_size => truncate is
 			 *  extending the file by 'offset' blocks.
 			 */
-			if ((!epos.bh
-			     && epos.offset ==
-			     udf_file_entry_alloc_offset(inode)) || (epos.bh
-								     && epos.
-								     offset ==
-								     sizeof
-								     (struct
-								      allocExtDesc)))
-			{
+			if ((!epos.bh &&
+			     epos.offset == udf_file_entry_alloc_offset(inode)) ||
+			    (epos.bh && epos.offset == sizeof(struct allocExtDesc))) {
 				/* File has no extents at all or has empty last
 				 * indirect extent! Create a fake extent... */
 				extent.extLocation.logicalBlockNum = 0;
 				extent.extLocation.partitionReferenceNum = 0;
-				extent.extLength =
-				    EXT_NOT_RECORDED_NOT_ALLOCATED;
+				extent.extLength = EXT_NOT_RECORDED_NOT_ALLOCATED;
 			} else {
 				epos.offset -= adsize;
 				etype = udf_next_aext(inode, &epos,
@@ -337,10 +305,7 @@ void udf_truncate_extents(struct inode *
 				extent.extLength |= etype << 30;
 			}
 			udf_extend_file(inode, &epos, &extent,
-					offset +
-					((inode->
-					  i_size & (sb->s_blocksize - 1)) !=
-					 0));
+					offset + ((inode->i_size & (sb->s_blocksize - 1)) != 0));
 		}
 	}
 	UDF_I_LENEXTENTS(inode) = inode->i_size;
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
udf-coding-style-conversion-lindent-fixups-2.patch
udf-fix-function-name-from-udf_crc16-to-udf_crc.patch
