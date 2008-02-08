From: akpm@linux-foundation.org
Subject: - udf-create-common-function-for-tag-checksumming.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:17:24 -0800
Message-ID: <200802082017.m18KH5d8010788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47104 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754939AbYBHVCj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:02:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, hch@infradead.org, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     udf: create common function for tag checksumming
has been removed from the -mm tree.  Its filename was
     udf-create-common-function-for-tag-checksumming.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix.patch
