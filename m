From: akpm@linux-foundation.org
Subject: - fix-possible-null-pointer-dereference-in-udf_table_free_blocks.patch removed from -mm tree
Date: Fri, 31 Aug 2007 09:55:49 -0700
Message-ID: <200708311655.l7VGtnp4017433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59358 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760210AbXHaQzy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 12:55:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Fix possible NULL pointer dereference in udf_table_free_blocks()
has been removed from the -mm tree.  Its filename was
     fix-possible-null-pointer-dereference-in-udf_table_free_blocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix possible NULL pointer dereference in udf_table_free_blocks()
From: Jan Kara <jack@suse.cz>

Fix possible NULL pointer dereference when freeing blocks in case table of
free space is used.  Also fix handling of the case when we need to move
extent from one block to another one to make space for indirect extent. 
BTW: Nobody seem to have ever used this code.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/balloc.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN fs/udf/balloc.c~fix-possible-null-pointer-dereference-in-udf_table_free_blocks fs/udf/balloc.c
--- a/fs/udf/balloc.c~fix-possible-null-pointer-dereference-in-udf_table_free_blocks
+++ a/fs/udf/balloc.c
@@ -540,26 +540,24 @@ static void udf_table_free_blocks(struct
 			if (epos.offset + adsize > sb->s_blocksize) {
 				loffset = epos.offset;
 				aed->lengthAllocDescs = cpu_to_le32(adsize);
-				sptr = UDF_I_DATA(inode) + epos.offset -
-					udf_file_entry_alloc_offset(inode) +
-					UDF_I_LENEATTR(inode) - adsize;
+				sptr = UDF_I_DATA(table) + epos.offset - adsize;
 				dptr = epos.bh->b_data + sizeof(struct allocExtDesc);
 				memcpy(dptr, sptr, adsize);
 				epos.offset = sizeof(struct allocExtDesc) + adsize;
 			} else {
 				loffset = epos.offset + adsize;
 				aed->lengthAllocDescs = cpu_to_le32(0);
-				sptr = oepos.bh->b_data + epos.offset;
-				epos.offset = sizeof(struct allocExtDesc);
-
 				if (oepos.bh) {
+					sptr = oepos.bh->b_data + epos.offset;
 					aed = (struct allocExtDesc *)oepos.bh->b_data;
 					aed->lengthAllocDescs =
 						cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) + adsize);
 				} else {
+					sptr = UDF_I_DATA(table) + epos.offset;
 					UDF_I_LENALLOC(table) += adsize;
 					mark_inode_dirty(table);
 				}
+				epos.offset = sizeof(struct allocExtDesc);
 			}
 			if (UDF_SB_UDFREV(sb) >= 0x0200)
 				udf_new_tag(epos.bh->b_data, TAG_IDENT_AED, 3, 1,
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
