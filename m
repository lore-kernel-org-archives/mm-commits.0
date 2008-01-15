From: akpm@linux-foundation.org
Subject: + udf-convert-byte-order-of-constant-instead-of-variable.patch added to -mm tree
Date: Tue, 15 Jan 2008 02:46:54 -0800
Message-ID: <200801151046.m0FAkY8i011675@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52779 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751541AbYAOKqt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 05:46:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, hch@lst.de, jack@suse.cz


The patch titled
     udf: convert byte order of constant instead of variable
has been added to the -mm tree.  Its filename is
     udf-convert-byte-order-of-constant-instead-of-variable.patch

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
Subject: udf: convert byte order of constant instead of variable
From: Marcin Slusarz <marcin.slusarz@gmail.com>

convert byte order of constant instead of variable,
which can be done at compile time (vs run time)

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/directory.c |    4 ++--
 fs/udf/inode.c     |   16 ++++++++--------
 fs/udf/misc.c      |   12 ++++++------
 fs/udf/super.c     |   16 ++++++++--------
 4 files changed, 24 insertions(+), 24 deletions(-)

diff -puN fs/udf/directory.c~udf-convert-byte-order-of-constant-instead-of-variable fs/udf/directory.c
--- a/fs/udf/directory.c~udf-convert-byte-order-of-constant-instead-of-variable
+++ a/fs/udf/directory.c
@@ -225,7 +225,7 @@ struct fileIdentDesc *udf_get_fileident(
 	if ((*offset > 0) && (*offset < bufsize))
 		ptr += *offset;
 	fi = (struct fileIdentDesc *)ptr;
-	if (le16_to_cpu(fi->descTag.tagIdent) != TAG_IDENT_FID) {
+	if (fi->descTag.tagIdent != cpu_to_le16(TAG_IDENT_FID)) {
 		udf_debug("0x%x != TAG_IDENT_FID\n",
 			  le16_to_cpu(fi->descTag.tagIdent));
 		udf_debug("offset: %u sizeof: %lu bufsize: %u\n",
@@ -262,7 +262,7 @@ static extent_ad *udf_get_fileextent(voi
 
 	fe = (struct fileEntry *)buffer;
 
-	if (le16_to_cpu(fe->descTag.tagIdent) != TAG_IDENT_FE) {
+	if (fe->descTag.tagIdent != cpu_to_le16(TAG_IDENT_FE)) {
 		udf_debug("0x%x != TAG_IDENT_FE\n",
 			  le16_to_cpu(fe->descTag.tagIdent));
 		return NULL;
diff -puN fs/udf/inode.c~udf-convert-byte-order-of-constant-instead-of-variable fs/udf/inode.c
--- a/fs/udf/inode.c~udf-convert-byte-order-of-constant-instead-of-variable
+++ a/fs/udf/inode.c
@@ -1103,7 +1103,7 @@ static void __udf_read_inode(struct inod
 
 	fe = (struct fileEntry *)bh->b_data;
 
-	if (le16_to_cpu(fe->icbTag.strategyType) == 4096) {
+	if (fe->icbTag.strategyType == cpu_to_le16(4096)) {
 		struct buffer_head *ibh = NULL, *nbh = NULL;
 		struct indirectEntry *ie;
 
@@ -1140,7 +1140,7 @@ static void __udf_read_inode(struct inod
 		} else {
 			brelse(ibh);
 		}
-	} else if (le16_to_cpu(fe->icbTag.strategyType) != 4) {
+	} else if (fe->icbTag.strategyType != cpu_to_le16(4)) {
 		printk(KERN_ERR "udf: unsupported strategy type: %d\n",
 		       le16_to_cpu(fe->icbTag.strategyType));
 		brelse(bh);
@@ -1164,9 +1164,9 @@ static void udf_fill_inode(struct inode 
 	fe = (struct fileEntry *)bh->b_data;
 	efe = (struct extendedFileEntry *)bh->b_data;
 
-	if (le16_to_cpu(fe->icbTag.strategyType) == 4)
+	if (fe->icbTag.strategyType == cpu_to_le16(4))
 		UDF_I_STRAT4096(inode) = 0;
-	else /* if (le16_to_cpu(fe->icbTag.strategyType) == 4096) */
+	else /* if (fe->icbTag.strategyType == cpu_to_le16(4096)) */
 		UDF_I_STRAT4096(inode) = 1;
 
 	UDF_I_ALLOCTYPE(inode) = le16_to_cpu(fe->icbTag.flags) &
@@ -1177,7 +1177,7 @@ static void udf_fill_inode(struct inode 
 	UDF_I_LENALLOC(inode) = 0;
 	UDF_I_NEXT_ALLOC_BLOCK(inode) = 0;
 	UDF_I_NEXT_ALLOC_GOAL(inode) = 0;
-	if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_EFE) {
+	if (fe->descTag.tagIdent == cpu_to_le16(TAG_IDENT_EFE)) {
 		UDF_I_EFE(inode) = 1;
 		UDF_I_USE(inode) = 0;
 		if (udf_alloc_i_data(inode, inode->i_sb->s_blocksize -
@@ -1189,7 +1189,7 @@ static void udf_fill_inode(struct inode 
 		       bh->b_data + sizeof(struct extendedFileEntry),
 		       inode->i_sb->s_blocksize -
 					sizeof(struct extendedFileEntry));
-	} else if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_FE) {
+	} else if (fe->descTag.tagIdent == cpu_to_le16(TAG_IDENT_FE)) {
 		UDF_I_EFE(inode) = 0;
 		UDF_I_USE(inode) = 0;
 		if (udf_alloc_i_data(inode, inode->i_sb->s_blocksize -
@@ -1199,7 +1199,7 @@ static void udf_fill_inode(struct inode 
 		}
 		memcpy(UDF_I_DATA(inode), bh->b_data + sizeof(struct fileEntry),
 		       inode->i_sb->s_blocksize - sizeof(struct fileEntry));
-	} else if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_USE) {
+	} else if (fe->descTag.tagIdent == cpu_to_le16(TAG_IDENT_USE)) {
 		UDF_I_EFE(inode) = 0;
 		UDF_I_USE(inode) = 1;
 		UDF_I_LENALLOC(inode) = le32_to_cpu(
@@ -1458,7 +1458,7 @@ static int udf_update_inode(struct inode
 	fe = (struct fileEntry *)bh->b_data;
 	efe = (struct extendedFileEntry *)bh->b_data;
 
-	if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_USE) {
+	if (fe->descTag.tagIdent == cpu_to_le16(TAG_IDENT_USE)) {
 		struct unallocSpaceEntry *use =
 			(struct unallocSpaceEntry *)bh->b_data;
 
diff -puN fs/udf/misc.c~udf-convert-byte-order-of-constant-instead-of-variable fs/udf/misc.c
--- a/fs/udf/misc.c~udf-convert-byte-order-of-constant-instead-of-variable
+++ a/fs/udf/misc.c
@@ -74,8 +74,8 @@ struct genericFormat *udf_add_extendedat
 
 		if (UDF_I_LENEATTR(inode)) {
 			/* check checksum/crc */
-			if (le16_to_cpu(eahd->descTag.tagIdent) !=
-					TAG_IDENT_EAHD ||
+			if (eahd->descTag.tagIdent !=
+					cpu_to_le16(TAG_IDENT_EAHD) ||
 			    le32_to_cpu(eahd->descTag.tagLocation) !=
 					UDF_I_LOCATION(inode).logicalBlockNum)
 				return NULL;
@@ -161,8 +161,8 @@ struct genericFormat *udf_get_extendedat
 		eahd = (struct extendedAttrHeaderDesc *)ea;
 
 		/* check checksum/crc */
-		if (le16_to_cpu(eahd->descTag.tagIdent) !=
-				TAG_IDENT_EAHD ||
+		if (eahd->descTag.tagIdent !=
+				cpu_to_le16(TAG_IDENT_EAHD) ||
 		    le32_to_cpu(eahd->descTag.tagLocation) !=
 				UDF_I_LOCATION(inode).logicalBlockNum)
 			return NULL;
@@ -233,8 +233,8 @@ struct buffer_head *udf_read_tagged(stru
 	}
 
 	/* Verify the tag version */
-	if (le16_to_cpu(tag_p->descVersion) != 0x0002U &&
-	    le16_to_cpu(tag_p->descVersion) != 0x0003U) {
+	if (tag_p->descVersion != cpu_to_le16(0x0002U) &&
+	    tag_p->descVersion != cpu_to_le16(0x0003U)) {
 		udf_debug("tag version 0x%04x != 0x0002 || 0x0003 block %d\n",
 			  le16_to_cpu(tag_p->descVersion), block);
 		goto error_out;
diff -puN fs/udf/super.c~udf-convert-byte-order-of-constant-instead-of-variable fs/udf/super.c
--- a/fs/udf/super.c~udf-convert-byte-order-of-constant-instead-of-variable
+++ a/fs/udf/super.c
@@ -1014,20 +1014,20 @@ static int udf_load_partdesc(struct supe
 				le32_to_cpu(p->partitionLength); /* blocks */
 			map->s_partition_root =
 				le32_to_cpu(p->partitionStartingLocation);
-			if (le32_to_cpu(p->accessType) ==
-					PD_ACCESS_TYPE_READ_ONLY)
+			if (p->accessType ==
+					cpu_to_le32(PD_ACCESS_TYPE_READ_ONLY))
 				map->s_partition_flags |=
 						UDF_PART_FLAG_READ_ONLY;
-			if (le32_to_cpu(p->accessType) ==
-					PD_ACCESS_TYPE_WRITE_ONCE)
+			if (p->accessType ==
+					cpu_to_le32(PD_ACCESS_TYPE_WRITE_ONCE))
 				map->s_partition_flags |=
 						UDF_PART_FLAG_WRITE_ONCE;
-			if (le32_to_cpu(p->accessType) ==
-					PD_ACCESS_TYPE_REWRITABLE)
+			if (p->accessType ==
+					cpu_to_le32(PD_ACCESS_TYPE_REWRITABLE))
 				map->s_partition_flags |=
 						UDF_PART_FLAG_REWRITABLE;
-			if (le32_to_cpu(p->accessType) ==
-					PD_ACCESS_TYPE_OVERWRITABLE)
+			if (p->accessType ==
+				    cpu_to_le32(PD_ACCESS_TYPE_OVERWRITABLE))
 				map->s_partition_flags |=
 						UDF_PART_FLAG_OVERWRITABLE;
 
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
