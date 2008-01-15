From: akpm@linux-foundation.org
Subject: + udf-create-common-function-for-tag-checksumming.patch added to -mm tree
Date: Tue, 15 Jan 2008 02:46:48 -0800
Message-ID: <200801151046.m0FAkSIm011666@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58639 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751291AbYAOKrG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 05:47:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, hch@infradead.org, jack@suse.cz


The patch titled
     udf: create common function for tag checksumming
has been added to the -mm tree.  Its filename is
     udf-create-common-function-for-tag-checksumming.patch

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
Subject: udf: create common function for tag checksumming
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/inode.c   |   15 ++-------------
 fs/udf/misc.c    |   35 ++++++++++++++---------------------
 fs/udf/namei.c   |    9 +--------
 fs/udf/super.c   |   16 ++--------------
 fs/udf/udfdecl.h |    3 +++
 5 files changed, 22 insertions(+), 56 deletions(-)

diff -puN fs/udf/inode.c~udf-create-common-function-for-tag-checksumming fs/udf/inode.c
--- a/fs/udf/inode.c~udf-create-common-function-for-tag-checksumming
+++ a/fs/udf/inode.c
@@ -1440,7 +1440,6 @@ static int udf_update_inode(struct inode
 	uint32_t udfperms;
 	uint16_t icbflags;
 	uint16_t crclen;
-	int i;
 	kernel_timestamp cpu_time;
 	int err = 0;
 	struct udf_sb_info *sbi = UDF_SB(inode->i_sb);
@@ -1476,12 +1475,7 @@ static int udf_update_inode(struct inode
 		use->descTag.descCRC = cpu_to_le16(udf_crc((char *)use +
 							   sizeof(tag), crclen,
 							   0));
-
-		use->descTag.tagChecksum = 0;
-		for (i = 0; i < 16; i++)
-			if (i != 4)
-				use->descTag.tagChecksum +=
-						((uint8_t *)&(use->descTag))[i];
+		use->descTag.tagChecksum = udf_tag_checksum(&use->descTag);
 
 		mark_buffer_dirty(bh);
 		brelse(bh);
@@ -1650,12 +1644,7 @@ static int udf_update_inode(struct inode
 	fe->descTag.descCRCLength = cpu_to_le16(crclen);
 	fe->descTag.descCRC = cpu_to_le16(udf_crc((char *)fe + sizeof(tag),
 						  crclen, 0));
-
-	fe->descTag.tagChecksum = 0;
-	for (i = 0; i < 16; i++)
-		if (i != 4)
-			fe->descTag.tagChecksum +=
-				((uint8_t *)&(fe->descTag))[i];
+	fe->descTag.tagChecksum = udf_tag_checksum(&fe->descTag);
 
 	/* write the data blocks */
 	mark_buffer_dirty(bh);
diff -puN fs/udf/misc.c~udf-create-common-function-for-tag-checksumming fs/udf/misc.c
--- a/fs/udf/misc.c~udf-create-common-function-for-tag-checksumming
+++ a/fs/udf/misc.c
@@ -51,7 +51,6 @@ struct genericFormat *udf_add_extendedat
 	uint8_t *ea = NULL, *ad = NULL;
 	int offset;
 	uint16_t crclen;
-	int i;
 
 	ea = UDF_I_DATA(inode);
 	if (UDF_I_LENEATTR(inode)) {
@@ -138,11 +137,7 @@ struct genericFormat *udf_add_extendedat
 		eahd->descTag.descCRCLength = cpu_to_le16(crclen);
 		eahd->descTag.descCRC = cpu_to_le16(udf_crc((char *)eahd +
 						sizeof(tag), crclen, 0));
-		eahd->descTag.tagChecksum = 0;
-		for (i = 0; i < 16; i++)
-			if (i != 4)
-				eahd->descTag.tagChecksum +=
-					((uint8_t *)&(eahd->descTag))[i];
+		eahd->descTag.tagChecksum = udf_tag_checksum(&eahd->descTag);
 		UDF_I_LENEATTR(inode) += size;
 		return (struct genericFormat *)&ea[offset];
 	}
@@ -207,8 +202,6 @@ struct buffer_head *udf_read_tagged(stru
 {
 	tag *tag_p;
 	struct buffer_head *bh = NULL;
-	register uint8_t checksum;
-	register int i;
 	struct udf_sb_info *sbi = UDF_SB(sb);
 
 	/* Read the block */
@@ -234,12 +227,7 @@ struct buffer_head *udf_read_tagged(stru
 	}
 
 	/* Verify the tag checksum */
-	checksum = 0U;
-	for (i = 0; i < 4; i++)
-		checksum += (uint8_t)(bh->b_data[i]);
-	for (i = 5; i < 16; i++)
-		checksum += (uint8_t)(bh->b_data[i]);
-	if (checksum != tag_p->tagChecksum) {
+	if (udf_tag_checksum(tag_p) != tag_p->tagChecksum) {
 		printk(KERN_ERR "udf: tag checksum failed block %d\n", block);
 		goto error_out;
 	}
@@ -277,17 +265,11 @@ struct buffer_head *udf_read_ptagged(str
 void udf_update_tag(char *data, int length)
 {
 	tag *tptr = (tag *)data;
-	int i;
-
 	length -= sizeof(tag);
 
-	tptr->tagChecksum = 0;
 	tptr->descCRCLength = cpu_to_le16(length);
 	tptr->descCRC = cpu_to_le16(udf_crc(data + sizeof(tag), length, 0));
-
-	for (i = 0; i < 16; i++)
-		if (i != 4)
-			tptr->tagChecksum += (uint8_t)(data[i]);
+	tptr->tagChecksum = udf_tag_checksum(tptr);
 }
 
 void udf_new_tag(char *data, uint16_t ident, uint16_t version, uint16_t snum,
@@ -300,3 +282,14 @@ void udf_new_tag(char *data, uint16_t id
 	tptr->tagLocation = cpu_to_le32(loc);
 	udf_update_tag(data, length);
 }
+
+u8 udf_tag_checksum(const tag *t)
+{
+	u8 *data = (u8 *)t;
+	u8 checksum = 0;
+	int i;
+	for (i = 0; i < sizeof(tag); ++i)
+		if (i != 4) /* position of checksum */
+			checksum += data[i];
+	return checksum;
+}
diff -puN fs/udf/namei.c~udf-create-common-function-for-tag-checksumming fs/udf/namei.c
--- a/fs/udf/namei.c~udf-create-common-function-for-tag-checksumming
+++ a/fs/udf/namei.c
@@ -47,8 +47,6 @@ int udf_write_fi(struct inode *inode, st
 {
 	uint16_t crclen = fibh->eoffset - fibh->soffset - sizeof(tag);
 	uint16_t crc;
-	uint8_t checksum = 0;
-	int i;
 	int offset;
 	uint16_t liu = le16_to_cpu(cfi->lengthOfImpUse);
 	uint8_t lfi = cfi->lengthFileIdent;
@@ -122,13 +120,8 @@ int udf_write_fi(struct inode *inode, st
 
 	cfi->descTag.descCRC = cpu_to_le16(crc);
 	cfi->descTag.descCRCLength = cpu_to_le16(crclen);
+	cfi->descTag.tagChecksum = udf_tag_checksum(&cfi->descTag);
 
-	for (i = 0; i < 16; i++) {
-		if (i != 4)
-			checksum += ((uint8_t *)&cfi->descTag)[i];
-	}
-
-	cfi->descTag.tagChecksum = checksum;
 	if (adinicb || (sizeof(struct fileIdentDesc) <= -fibh->soffset)) {
 		memcpy((uint8_t *)sfi, (uint8_t *)cfi,
 			sizeof(struct fileIdentDesc));
diff -puN fs/udf/super.c~udf-create-common-function-for-tag-checksumming fs/udf/super.c
--- a/fs/udf/super.c~udf-create-common-function-for-tag-checksumming
+++ a/fs/udf/super.c
@@ -1564,7 +1564,6 @@ static void udf_open_lvid(struct super_b
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct buffer_head *bh = sbi->s_lvid_bh;
 	if (bh) {
-		int i;
 		kernel_timestamp cpu_time;
 		struct logicalVolIntegrityDesc *lvid =
 				(struct logicalVolIntegrityDesc *)bh->b_data;
@@ -1582,12 +1581,7 @@ static void udf_open_lvid(struct super_b
 				le16_to_cpu(lvid->descTag.descCRCLength),
 				0));
 
-		lvid->descTag.tagChecksum = 0;
-		for (i = 0; i < 16; i++)
-			if (i != 4)
-				lvid->descTag.tagChecksum +=
-					((uint8_t *) &(lvid->descTag))[i];
-
+		lvid->descTag.tagChecksum = udf_tag_checksum(&lvid->descTag);
 		mark_buffer_dirty(bh);
 	}
 }
@@ -1595,7 +1589,6 @@ static void udf_open_lvid(struct super_b
 static void udf_close_lvid(struct super_block *sb)
 {
 	kernel_timestamp cpu_time;
-	int i;
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct buffer_head *bh = sbi->s_lvid_bh;
 	struct logicalVolIntegrityDesc *lvid;
@@ -1626,12 +1619,7 @@ static void udf_close_lvid(struct super_
 				le16_to_cpu(lvid->descTag.descCRCLength),
 				0));
 
-		lvid->descTag.tagChecksum = 0;
-		for (i = 0; i < 16; i++)
-			if (i != 4)
-				lvid->descTag.tagChecksum +=
-					((uint8_t *)&(lvid->descTag))[i];
-
+		lvid->descTag.tagChecksum = udf_tag_checksum(&lvid->descTag);
 		mark_buffer_dirty(bh);
 	}
 }
diff -puN fs/udf/udfdecl.h~udf-create-common-function-for-tag-checksumming fs/udf/udfdecl.h
--- a/fs/udf/udfdecl.h~udf-create-common-function-for-tag-checksumming
+++ a/fs/udf/udfdecl.h
@@ -36,6 +36,9 @@
 
 #define udf_get_lb_pblock(sb,loc,offset) udf_get_pblock((sb), (loc).logicalBlockNum, (loc).partitionReferenceNum, (offset))
 
+/* computes tag checksum */
+u8 udf_tag_checksum(const tag *t);
+
 struct dentry;
 struct inode;
 struct task_struct;
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
