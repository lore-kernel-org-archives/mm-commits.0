From: akpm@linux-foundation.org
Subject: + udf-fix-coding-style-of-superc.patch added to -mm tree
Date: Tue, 15 Jan 2008 02:46:23 -0800
Message-ID: <200801151046.m0FAk4BA011601@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42700 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751278AbYAOKqy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 05:46:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, bfennema@falcon.csc.calpoly.edu, hch@lst.de, jack@suse.cz


The patch titled
     udf: fix coding style of super.c
has been added to the -mm tree.  Its filename is
     udf-fix-coding-style-of-superc.patch

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
Subject: udf: fix coding style of super.c
From: Marcin Slusarz <marcin.slusarz@gmail.com>

fix coding style errors found by checkpatch:
- assignments in if conditions
- braces {} around single statement blocks
- no spaces after commas
- printks without KERN_*
- lines longer than 80 characters
before: total: 50 errors, 207 warnings, 1835 lines checked
after:  total: 0 errors, 164 warnings, 1872 lines checked

all 164 warnings left are lines longer than 80 characters;
this file has too much indentation with really long expressions
to break all those lines now; will fix later

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Acked-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/super.c |  295 ++++++++++++++++++++++++++---------------------
 1 file changed, 166 insertions(+), 129 deletions(-)

diff -puN fs/udf/super.c~udf-fix-coding-style-of-superc fs/udf/super.c
--- a/fs/udf/super.c~udf-fix-coding-style-of-superc
+++ a/fs/udf/super.c
@@ -33,8 +33,8 @@
  *  10/17/98      added freespace count for "df"
  *  11/11/98 gr   added novrs option
  *  11/26/98 dgb  added fileset,anchor mount options
- *  12/06/98 blf  really hosed things royally. vat/sparing support. sequenced vol descs
- *                rewrote option handling based on isofs
+ *  12/06/98 blf  really hosed things royally. vat/sparing support. sequenced
+ *                vol descs. rewrote option handling based on isofs
  *  12/20/98      find the free space bitmap (if it exists)
  */
 
@@ -116,7 +116,7 @@ static struct kmem_cache *udf_inode_cach
 static struct inode *udf_alloc_inode(struct super_block *sb)
 {
 	struct udf_inode_info *ei;
-	ei = (struct udf_inode_info *)kmem_cache_alloc(udf_inode_cachep, GFP_KERNEL);
+	ei = kmem_cache_alloc(udf_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 
@@ -561,47 +561,52 @@ static int udf_vrs(struct super_block *s
 
 		/* Look for ISO  descriptors */
 		vsd = (struct volStructDesc *)(bh->b_data +
-					       (sector & (sb->s_blocksize - 1)));
+					      (sector & (sb->s_blocksize - 1)));
 
 		if (vsd->stdIdent[0] == 0) {
 			brelse(bh);
 			break;
-		} else if (!strncmp(vsd->stdIdent, VSD_STD_ID_CD001, VSD_STD_ID_LEN)) {
+		} else if (!strncmp(vsd->stdIdent, VSD_STD_ID_CD001,
+				    VSD_STD_ID_LEN)) {
 			iso9660 = sector;
 			switch (vsd->structType) {
 			case 0:
 				udf_debug("ISO9660 Boot Record found\n");
 				break;
 			case 1:
-				udf_debug
-				    ("ISO9660 Primary Volume Descriptor found\n");
+				udf_debug("ISO9660 Primary Volume Descriptor "
+					  "found\n");
 				break;
 			case 2:
-				udf_debug
-				    ("ISO9660 Supplementary Volume Descriptor found\n");
+				udf_debug("ISO9660 Supplementary Volume "
+					  "Descriptor found\n");
 				break;
 			case 3:
-				udf_debug
-				    ("ISO9660 Volume Partition Descriptor found\n");
+				udf_debug("ISO9660 Volume Partition Descriptor "
+					  "found\n");
 				break;
 			case 255:
-				udf_debug
-				    ("ISO9660 Volume Descriptor Set Terminator found\n");
+				udf_debug("ISO9660 Volume Descriptor Set "
+					  "Terminator found\n");
 				break;
 			default:
 				udf_debug("ISO9660 VRS (%u) found\n",
 					  vsd->structType);
 				break;
 			}
-		} else if (!strncmp(vsd->stdIdent, VSD_STD_ID_BEA01, VSD_STD_ID_LEN)) {
-		} else if (!strncmp(vsd->stdIdent, VSD_STD_ID_TEA01, VSD_STD_ID_LEN)) {
+		} else if (!strncmp(vsd->stdIdent, VSD_STD_ID_BEA01,
+				    VSD_STD_ID_LEN))
+			; /* nothing */
+		else if (!strncmp(vsd->stdIdent, VSD_STD_ID_TEA01,
+				    VSD_STD_ID_LEN)) {
 			brelse(bh);
 			break;
-		} else if (!strncmp(vsd->stdIdent, VSD_STD_ID_NSR02, VSD_STD_ID_LEN)) {
+		} else if (!strncmp(vsd->stdIdent, VSD_STD_ID_NSR02,
+				    VSD_STD_ID_LEN))
 			nsr02 = sector;
-		} else if (!strncmp(vsd->stdIdent, VSD_STD_ID_NSR03, VSD_STD_ID_LEN)) {
+		else if (!strncmp(vsd->stdIdent, VSD_STD_ID_NSR03,
+				    VSD_STD_ID_LEN))
 			nsr03 = sector;
-		}
 		brelse(bh);
 	}
 
@@ -658,21 +663,26 @@ static void udf_find_anchor(struct super
 		 *  however, if the disc isn't closed, it could be 512 */
 
 		for (i = 0; !lastblock && i < ARRAY_SIZE(last); i++) {
-			if (last[i] < 0 || !(bh = sb_bread(sb, last[i]))) {
-				ident = location = 0;
-			} else {
-				ident = le16_to_cpu(((tag *)bh->b_data)->tagIdent);
-				location = le32_to_cpu(((tag *)bh->b_data)->tagLocation);
-				brelse(bh);
+			ident = location = 0;
+			if (last[i] >= 0) {
+				bh = sb_bread(sb, last[i]);
+				if (bh) {
+					tag *t = (tag *)bh->b_data;
+					ident = le16_to_cpu(t->tagIdent);
+					location = le32_to_cpu(t->tagLocation);
+					brelse(bh);
+				}
 			}
 
 			if (ident == TAG_IDENT_AVDP) {
 				if (location == last[i] - UDF_SB_SESSION(sb)) {
-					lastblock = UDF_SB_ANCHOR(sb)[0] = last[i] - UDF_SB_SESSION(sb);
-					UDF_SB_ANCHOR(sb)[1] = last[i] - 256 - UDF_SB_SESSION(sb);
+					lastblock = last[i] - UDF_SB_SESSION(sb);
+					UDF_SB_ANCHOR(sb)[0] = lastblock;
+					UDF_SB_ANCHOR(sb)[1] = lastblock - 256;
 				} else if (location == udf_variable_to_fixed(last[i]) - UDF_SB_SESSION(sb)) {
 					UDF_SET_FLAG(sb, UDF_FLAG_VARCONV);
-					lastblock = UDF_SB_ANCHOR(sb)[0] = udf_variable_to_fixed(last[i]) - UDF_SB_SESSION(sb);
+					lastblock = udf_variable_to_fixed(last[i]) - UDF_SB_SESSION(sb);
+					UDF_SB_ANCHOR(sb)[0] = lastblock;
 					UDF_SB_ANCHOR(sb)[1] = lastblock - 256 - UDF_SB_SESSION(sb);
 				} else {
 					udf_debug("Anchor found at block %d, location mismatch %d.\n",
@@ -682,12 +692,15 @@ static void udf_find_anchor(struct super
 				lastblock = last[i];
 				UDF_SB_ANCHOR(sb)[3] = 512;
 			} else {
-				if (last[i] < 256 || !(bh = sb_bread(sb, last[i] - 256))) {
-					ident = location = 0;
-				} else {
-					ident = le16_to_cpu(((tag *)bh->b_data)->tagIdent);
-					location = le32_to_cpu(((tag *)bh->b_data)->tagLocation);
-					brelse(bh);
+				ident = location = 0;
+				if (last[i] >= 256) {
+					bh = sb_bread(sb, last[i] - 256);
+					if (bh) {
+						tag *t = (tag *)bh->b_data;
+						ident = le16_to_cpu(t->tagIdent);
+						location = le32_to_cpu(t->tagLocation);
+						brelse(bh);
+					}
 				}
 
 				if (ident == TAG_IDENT_AVDP &&
@@ -695,13 +708,15 @@ static void udf_find_anchor(struct super
 					lastblock = last[i];
 					UDF_SB_ANCHOR(sb)[1] = last[i] - 256;
 				} else {
-					if (last[i] < 312 + UDF_SB_SESSION(sb) ||
-					    !(bh = sb_bread(sb, last[i] - 312 - UDF_SB_SESSION(sb)))) {
-						ident = location = 0;
-					} else {
-						ident = le16_to_cpu(((tag *)bh->b_data)->tagIdent);
-						location = le32_to_cpu(((tag *)bh->b_data)->tagLocation);
-						brelse(bh);
+					ident = location = 0;
+					if (last[i] >= 312 + UDF_SB_SESSION(sb)) {
+						bh = sb_bread(sb, last[i] - 312 - UDF_SB_SESSION(sb));
+						if (bh) {
+							tag *t = (tag *)bh->b_data;
+							ident = le16_to_cpu(t->tagIdent);
+							location = le32_to_cpu(t->tagLocation);
+							brelse(bh);
+						}
 					}
 
 					if (ident == TAG_IDENT_AVDP &&
@@ -716,10 +731,12 @@ static void udf_find_anchor(struct super
 	}
 
 	if (!lastblock) {
-		/* We havn't found the lastblock. check 312 */
-		if ((bh = sb_bread(sb, 312 + UDF_SB_SESSION(sb)))) {
-			ident = le16_to_cpu(((tag *)bh->b_data)->tagIdent);
-			location = le32_to_cpu(((tag *)bh->b_data)->tagLocation);
+		/* We haven't found the lastblock. check 312 */
+		bh = sb_bread(sb, 312 + UDF_SB_SESSION(sb));
+		if (bh) {
+			tag *t = (tag *)bh->b_data;
+			ident = le16_to_cpu(t->tagIdent);
+			location = le32_to_cpu(t->tagLocation);
 			brelse(bh);
 
 			if (ident == TAG_IDENT_AVDP && location == 256)
@@ -729,15 +746,15 @@ static void udf_find_anchor(struct super
 
 	for (i = 0; i < ARRAY_SIZE(UDF_SB_ANCHOR(sb)); i++) {
 		if (UDF_SB_ANCHOR(sb)[i]) {
-			if (!(bh = udf_read_tagged(sb, UDF_SB_ANCHOR(sb)[i],
-						   UDF_SB_ANCHOR(sb)[i], &ident))) {
+			bh = udf_read_tagged(sb, UDF_SB_ANCHOR(sb)[i],
+					     UDF_SB_ANCHOR(sb)[i], &ident);
+			if (!bh)
 				UDF_SB_ANCHOR(sb)[i] = 0;
-			} else {
+			else {
 				brelse(bh);
 				if ((ident != TAG_IDENT_AVDP) &&
-				    (i || (ident != TAG_IDENT_FE && ident != TAG_IDENT_EFE))) {
+				    (i || (ident != TAG_IDENT_FE && ident != TAG_IDENT_EFE)))
 					UDF_SB_ANCHOR(sb)[i] = 0;
-				}
 			}
 		}
 	}
@@ -745,7 +762,9 @@ static void udf_find_anchor(struct super
 	UDF_SB_LASTBLOCK(sb) = lastblock;
 }
 
-static int udf_find_fileset(struct super_block *sb, kernel_lb_addr *fileset, kernel_lb_addr *root)
+static int udf_find_fileset(struct super_block *sb,
+			    kernel_lb_addr *fileset,
+			    kernel_lb_addr *root)
 {
 	struct buffer_head *bh = NULL;
 	long lastblock;
@@ -764,7 +783,8 @@ static int udf_find_fileset(struct super
 
 	}
 
-	if (!bh) { /* Search backwards through the partitions */
+	if (!bh) {
+		/* Search backwards through the partitions */
 		kernel_lb_addr newfileset;
 
 /* --> cvg: FIXME - is it reasonable? */
@@ -775,11 +795,13 @@ static int udf_find_fileset(struct super
 		      fileset->logicalBlockNum == 0xFFFFFFFF &&
 		      fileset->partitionReferenceNum == 0xFFFF);
 		     newfileset.partitionReferenceNum--) {
-			lastblock = UDF_SB_PARTLEN(sb, newfileset.partitionReferenceNum);
+			lastblock = UDF_SB_PARTLEN(sb,
+					newfileset.partitionReferenceNum);
 			newfileset.logicalBlockNum = 0;
 
 			do {
-				bh = udf_read_ptagged(sb, newfileset, 0, &ident);
+				bh = udf_read_ptagged(sb, newfileset, 0,
+						      &ident);
 				if (!bh) {
 					newfileset.logicalBlockNum++;
 					continue;
@@ -840,7 +862,8 @@ static void udf_load_pvoldesc(struct sup
 			      lets_to_cpu(pvoldesc->recordingDateAndTime))) {
 		kernel_timestamp ts;
 		ts = lets_to_cpu(pvoldesc->recordingDateAndTime);
-		udf_debug("recording time %ld/%ld, %04u/%02u/%02u %02u:%02u (%x)\n",
+		udf_debug("recording time %ld/%ld, %04u/%02u/%02u"
+			  " %02u:%02u (%x)\n",
 			  recording, recording_usec,
 			  ts.year, ts.month, ts.day, ts.hour,
 			  ts.minute, ts.typeAndTimezone);
@@ -888,19 +911,21 @@ static int udf_load_partdesc(struct supe
 		udf_debug("Searching map: (%d == %d)\n",
 			  UDF_SB_PARTMAPS(sb)[i].s_partition_num, le16_to_cpu(p->partitionNumber));
 		if (UDF_SB_PARTMAPS(sb)[i].s_partition_num == le16_to_cpu(p->partitionNumber)) {
-			UDF_SB_PARTLEN(sb,i) = le32_to_cpu(p->partitionLength); /* blocks */
-			UDF_SB_PARTROOT(sb,i) = le32_to_cpu(p->partitionStartingLocation);
+			UDF_SB_PARTLEN(sb, i) = le32_to_cpu(p->partitionLength); /* blocks */
+			UDF_SB_PARTROOT(sb, i) = le32_to_cpu(p->partitionStartingLocation);
 			if (le32_to_cpu(p->accessType) == PD_ACCESS_TYPE_READ_ONLY)
-				UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_READ_ONLY;
+				UDF_SB_PARTFLAGS(sb, i) |= UDF_PART_FLAG_READ_ONLY;
 			if (le32_to_cpu(p->accessType) == PD_ACCESS_TYPE_WRITE_ONCE)
-				UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_WRITE_ONCE;
+				UDF_SB_PARTFLAGS(sb, i) |= UDF_PART_FLAG_WRITE_ONCE;
 			if (le32_to_cpu(p->accessType) == PD_ACCESS_TYPE_REWRITABLE)
-				UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_REWRITABLE;
+				UDF_SB_PARTFLAGS(sb, i) |= UDF_PART_FLAG_REWRITABLE;
 			if (le32_to_cpu(p->accessType) == PD_ACCESS_TYPE_OVERWRITABLE)
-				UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_OVERWRITABLE;
+				UDF_SB_PARTFLAGS(sb, i) |= UDF_PART_FLAG_OVERWRITABLE;
 
-			if (!strcmp(p->partitionContents.ident, PD_PARTITION_CONTENTS_NSR02) ||
-			    !strcmp(p->partitionContents.ident, PD_PARTITION_CONTENTS_NSR03)) {
+			if (!strcmp(p->partitionContents.ident,
+				    PD_PARTITION_CONTENTS_NSR02) ||
+			    !strcmp(p->partitionContents.ident,
+				    PD_PARTITION_CONTENTS_NSR03)) {
 				struct partitionHeaderDesc *phd;
 
 				phd = (struct partitionHeaderDesc *)(p->partitionContentsUse);
@@ -916,7 +941,7 @@ static int udf_load_partdesc(struct supe
 						udf_debug("cannot load unallocSpaceTable (part %d)\n", i);
 						return 1;
 					}
-					UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_UNALLOC_TABLE;
+					UDF_SB_PARTFLAGS(sb, i) |= UDF_PART_FLAG_UNALLOC_TABLE;
 					udf_debug("unallocSpaceTable (part %d) @ %ld\n",
 						  i, UDF_SB_PARTMAPS(sb)[i].s_uspace.s_table->i_ino);
 				}
@@ -927,7 +952,7 @@ static int udf_load_partdesc(struct supe
 							le32_to_cpu(phd->unallocSpaceBitmap.extLength);
 						UDF_SB_PARTMAPS(sb)[i].s_uspace.s_bitmap->s_extPosition =
 							le32_to_cpu(phd->unallocSpaceBitmap.extPosition);
-						UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_UNALLOC_BITMAP;
+						UDF_SB_PARTFLAGS(sb, i) |= UDF_PART_FLAG_UNALLOC_BITMAP;
 						udf_debug("unallocSpaceBitmap (part %d) @ %d\n",
 							  i, UDF_SB_PARTMAPS(sb)[i].s_uspace.s_bitmap->s_extPosition);
 					}
@@ -946,7 +971,7 @@ static int udf_load_partdesc(struct supe
 						udf_debug("cannot load freedSpaceTable (part %d)\n", i);
 						return 1;
 					}
-					UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_FREED_TABLE;
+					UDF_SB_PARTFLAGS(sb, i) |= UDF_PART_FLAG_FREED_TABLE;
 					udf_debug("freedSpaceTable (part %d) @ %ld\n",
 						  i, UDF_SB_PARTMAPS(sb)[i].s_fspace.s_table->i_ino);
 				}
@@ -957,7 +982,7 @@ static int udf_load_partdesc(struct supe
 							le32_to_cpu(phd->freedSpaceBitmap.extLength);
 						UDF_SB_PARTMAPS(sb)[i].s_fspace.s_bitmap->s_extPosition =
 							le32_to_cpu(phd->freedSpaceBitmap.extPosition);
-						UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_FREED_BITMAP;
+						UDF_SB_PARTFLAGS(sb, i) |= UDF_PART_FLAG_FREED_BITMAP;
 						udf_debug("freedSpaceBitmap (part %d) @ %d\n",
 							  i, UDF_SB_PARTMAPS(sb)[i].s_fspace.s_bitmap->s_extPosition);
 					}
@@ -970,9 +995,11 @@ static int udf_load_partdesc(struct supe
 		udf_debug("Partition (%d) not found in partition map\n",
 			  le16_to_cpu(p->partitionNumber));
 	} else {
-		udf_debug("Partition (%d:%d type %x) starts at physical %d, block length %d\n",
-			  le16_to_cpu(p->partitionNumber), i, UDF_SB_PARTTYPE(sb,i),
-			  UDF_SB_PARTROOT(sb,i), UDF_SB_PARTLEN(sb,i));
+		udf_debug("Partition (%d:%d type %x) starts at physical %d, "
+			  "block length %d\n",
+			  le16_to_cpu(p->partitionNumber), i,
+			  UDF_SB_PARTTYPE(sb, i), UDF_SB_PARTROOT(sb, i),
+			  UDF_SB_PARTLEN(sb, i));
 	}
 	return 0;
 }
@@ -994,19 +1021,19 @@ static int udf_load_logicalvol(struct su
 		type = ((struct genericPartitionMap *)&(lvd->partitionMaps[offset]))->partitionMapType;
 		if (type == 1) {
 			struct genericPartitionMap1 *gpm1 = (struct genericPartitionMap1 *)&(lvd->partitionMaps[offset]);
-			UDF_SB_PARTTYPE(sb,i) = UDF_TYPE1_MAP15;
-			UDF_SB_PARTVSN(sb,i) = le16_to_cpu(gpm1->volSeqNum);
-			UDF_SB_PARTNUM(sb,i) = le16_to_cpu(gpm1->partitionNum);
-			UDF_SB_PARTFUNC(sb,i) = NULL;
+			UDF_SB_PARTTYPE(sb, i) = UDF_TYPE1_MAP15;
+			UDF_SB_PARTVSN(sb, i) = le16_to_cpu(gpm1->volSeqNum);
+			UDF_SB_PARTNUM(sb, i) = le16_to_cpu(gpm1->partitionNum);
+			UDF_SB_PARTFUNC(sb, i) = NULL;
 		} else if (type == 2) {
 			struct udfPartitionMap2 *upm2 = (struct udfPartitionMap2 *)&(lvd->partitionMaps[offset]);
 			if (!strncmp(upm2->partIdent.ident, UDF_ID_VIRTUAL, strlen(UDF_ID_VIRTUAL))) {
 				if (le16_to_cpu(((__le16 *)upm2->partIdent.identSuffix)[0]) == 0x0150) {
-					UDF_SB_PARTTYPE(sb,i) = UDF_VIRTUAL_MAP15;
-					UDF_SB_PARTFUNC(sb,i) = udf_get_pblock_virt15;
+					UDF_SB_PARTTYPE(sb, i) = UDF_VIRTUAL_MAP15;
+					UDF_SB_PARTFUNC(sb, i) = udf_get_pblock_virt15;
 				} else if (le16_to_cpu(((__le16 *)upm2->partIdent.identSuffix)[0]) == 0x0200) {
-					UDF_SB_PARTTYPE(sb,i) = UDF_VIRTUAL_MAP20;
-					UDF_SB_PARTFUNC(sb,i) = udf_get_pblock_virt20;
+					UDF_SB_PARTTYPE(sb, i) = UDF_VIRTUAL_MAP20;
+					UDF_SB_PARTFUNC(sb, i) = udf_get_pblock_virt20;
 				}
 			} else if (!strncmp(upm2->partIdent.ident, UDF_ID_SPARABLE, strlen(UDF_ID_SPARABLE))) {
 				uint32_t loc;
@@ -1014,39 +1041,41 @@ static int udf_load_logicalvol(struct su
 				struct sparingTable *st;
 				struct sparablePartitionMap *spm = (struct sparablePartitionMap *)&(lvd->partitionMaps[offset]);
 
-				UDF_SB_PARTTYPE(sb,i) = UDF_SPARABLE_MAP15;
-				UDF_SB_TYPESPAR(sb,i).s_packet_len = le16_to_cpu(spm->packetLength);
+				UDF_SB_PARTTYPE(sb, i) = UDF_SPARABLE_MAP15;
+				UDF_SB_TYPESPAR(sb, i).s_packet_len = le16_to_cpu(spm->packetLength);
 				for (j = 0; j < spm->numSparingTables; j++) {
 					loc = le32_to_cpu(spm->locSparingTable[j]);
-					UDF_SB_TYPESPAR(sb,i).s_spar_map[j] =
+					UDF_SB_TYPESPAR(sb, i).s_spar_map[j] =
 						udf_read_tagged(sb, loc, loc, &ident);
-					if (UDF_SB_TYPESPAR(sb,i).s_spar_map[j] != NULL) {
-						st = (struct sparingTable *)UDF_SB_TYPESPAR(sb,i).s_spar_map[j]->b_data;
+					if (UDF_SB_TYPESPAR(sb, i).s_spar_map[j] != NULL) {
+						st = (struct sparingTable *)UDF_SB_TYPESPAR(sb, i).s_spar_map[j]->b_data;
 						if (ident != 0 ||
 						    strncmp(st->sparingIdent.ident, UDF_ID_SPARING, strlen(UDF_ID_SPARING))) {
-							brelse(UDF_SB_TYPESPAR(sb,i).s_spar_map[j]);
-							UDF_SB_TYPESPAR(sb,i).s_spar_map[j] = NULL;
+							brelse(UDF_SB_TYPESPAR(sb, i).s_spar_map[j]);
+							UDF_SB_TYPESPAR(sb, i).s_spar_map[j] = NULL;
 						}
 					}
 				}
-				UDF_SB_PARTFUNC(sb,i) = udf_get_pblock_spar15;
+				UDF_SB_PARTFUNC(sb, i) = udf_get_pblock_spar15;
 			} else {
-				udf_debug("Unknown ident: %s\n", upm2->partIdent.ident);
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
-			  i, UDF_SB_PARTNUM(sb,i), type, UDF_SB_PARTVSN(sb,i));
+			  i, UDF_SB_PARTNUM(sb, i), type,
+			  UDF_SB_PARTVSN(sb, i));
 	}
 
 	if (fileset) {
 		long_ad *la = (long_ad *)&(lvd->logicalVolContentsUse[0]);
 
 		*fileset = lelb_to_cpu(la->extLocation);
-		udf_debug("FileSet found in LogicalVolDesc at block=%d, partition=%d\n",
-			  fileset->logicalBlockNum,
+		udf_debug("FileSet found in LogicalVolDesc at block=%d, "
+			  "partition=%d\n", fileset->logicalBlockNum,
 			  fileset->partitionReferenceNum);
 	}
 	if (lvd->integritySeqExt.extLength)
@@ -1071,7 +1100,8 @@ static void udf_load_logicalvolint(struc
 		UDF_SB_LVIDBH(sb) = bh;
 
 		if (UDF_SB_LVID(sb)->nextIntegrityExt.extLength)
-			udf_load_logicalvolint(sb, leea_to_cpu(UDF_SB_LVID(sb)->nextIntegrityExt));
+			udf_load_logicalvolint(sb,
+				leea_to_cpu(UDF_SB_LVID(sb)->nextIntegrityExt));
 
 		if (UDF_SB_LVIDBH(sb) != bh)
 			brelse(bh);
@@ -1097,8 +1127,8 @@ static void udf_load_logicalvolint(struc
  *	July 1, 1997 - Andrew E. Mileski
  *	Written, tested, and released.
  */
-static int udf_process_sequence(struct super_block *sb, long block, long lastblock,
-				 kernel_lb_addr *fileset)
+static int udf_process_sequence(struct super_block *sb, long block,
+				long lastblock, kernel_lb_addr *fileset)
 {
 	struct buffer_head *bh = NULL;
 	struct udf_vds_record vds[VDS_POS_LENGTH];
@@ -1178,7 +1208,8 @@ static int udf_process_sequence(struct s
 	}
 	for (i = 0; i < VDS_POS_LENGTH; i++) {
 		if (vds[i].block) {
-			bh = udf_read_tagged(sb, vds[i].block, vds[i].block, &ident);
+			bh = udf_read_tagged(sb, vds[i].block, vds[i].block,
+					     &ident);
 
 			if (i == VDS_POS_PRIMARY_VOL_DESC) {
 				udf_load_pvoldesc(sb, bh);
@@ -1190,11 +1221,14 @@ static int udf_process_sequence(struct s
 					brelse(bh);
 					return 1;
 				}
-				for (j = vds[i].block + 1; j <  vds[VDS_POS_TERMINATING_DESC].block; j++) {
+				for (j = vds[i].block + 1;
+				     j <  vds[VDS_POS_TERMINATING_DESC].block;
+				     j++) {
 					bh2 = udf_read_tagged(sb, j, j, &ident);
 					gd = (struct generic_desc *)bh2->b_data;
 					if (ident == TAG_IDENT_PD)
-						if (udf_load_partdesc(sb, bh2)) {
+						if (udf_load_partdesc(sb,
+								      bh2)) {
 							brelse(bh);
 							brelse(bh2);
 							return 1;
@@ -1222,14 +1256,16 @@ static int udf_check_valid(struct super_
 	}
 	/* Check that it is NSR02 compliant */
 	/* Process any "CD-ROM Volume Descriptor Set" (ECMA 167 2/8.3.1) */
-	else if ((block = udf_vrs(sb, silent)) == -1) {
-		udf_debug("Failed to read byte 32768. Assuming open disc. "
-			  "Skipping validity check\n");
-		if (!UDF_SB_LASTBLOCK(sb))
-			UDF_SB_LASTBLOCK(sb) = udf_get_last_block(sb);
-		return 0;
-	} else {
-		return !block;
+	else {
+		block = udf_vrs(sb, silent);
+		if (block == -1) {
+			udf_debug("Failed to read byte 32768. Assuming open "
+				  "disc. Skipping validity check\n");
+			if (!UDF_SB_LASTBLOCK(sb))
+				UDF_SB_LASTBLOCK(sb) = udf_get_last_block(sb);
+			return 0;
+		} else
+			return !block;
 	}
 }
 
@@ -1252,7 +1288,7 @@ static int udf_load_partition(struct sup
 
 			/* Locate the main sequence */
 			main_s = le32_to_cpu(anchor->mainVolDescSeqExt.extLocation);
-			main_e = le32_to_cpu(anchor->mainVolDescSeqExt.extLength );
+			main_e = le32_to_cpu(anchor->mainVolDescSeqExt.extLength);
 			main_e = main_e >> sb->s_blocksize_bits;
 			main_e += main_s;
 
@@ -1267,9 +1303,8 @@ static int udf_load_partition(struct sup
 			/* Process the main & reserve sequences */
 			/* responsible for finding the PartitionDesc(s) */
 			if (!(udf_process_sequence(sb, main_s, main_e, fileset) &&
-			      udf_process_sequence(sb, reserve_s, reserve_e, fileset))) {
+			      udf_process_sequence(sb, reserve_s, reserve_e, fileset)))
 				break;
-			}
 		}
 	}
 
@@ -1308,7 +1343,8 @@ static int udf_load_partition(struct sup
 			if (j == UDF_SB_NUMPARTS(sb))
 				return 1;
 
-			if (!(UDF_SB_VAT(sb) = udf_iget(sb, ino)))
+			UDF_SB_VAT(sb) = udf_iget(sb, ino);
+			if (!UDF_SB_VAT(sb))
 				return 1;
 
 			if (UDF_SB_PARTTYPE(sb, i) == UDF_VIRTUAL_MAP15) {
@@ -1481,8 +1517,9 @@ static int udf_fill_super(struct super_b
 	UDF_SB_ANCHOR(sb)[2] = uopt.anchor;
 	UDF_SB_ANCHOR(sb)[3] = 256;
 
-	if (udf_check_valid(sb, uopt.novrs, silent)) { /* read volume recognition sequences */
-		printk("UDF-fs: No VRS found\n");
+	if (udf_check_valid(sb, uopt.novrs, silent)) {
+		/* read volume recognition sequences */
+		printk(KERN_WARNING "UDF-fs: No VRS found\n");
 		goto error_out;
 	}
 
@@ -1496,7 +1533,7 @@ static int udf_fill_super(struct super_b
 	sb->s_time_gran = 1000;
 
 	if (udf_load_partition(sb, &fileset)) {
-		printk("UDF-fs: No partition found (1)\n");
+		printk(KERN_WARNING "UDF-fs: No partition found (1)\n");
 		goto error_out;
 	}
 
@@ -1508,7 +1545,7 @@ static int udf_fill_super(struct super_b
 		/* uint16_t maxUDFWriteRev = le16_to_cpu(UDF_SB_LVIDIU(sb)->maxUDFWriteRev); */
 
 		if (minUDFReadRev > UDF_MAX_READ_VERSION) {
-			printk("UDF-fs: minUDFReadRev=%x (max is %x)\n",
+			printk(KERN_ERR "UDF-fs: minUDFReadRev=%x (max is %x)\n",
 			       le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFReadRev),
 			       UDF_MAX_READ_VERSION);
 			goto error_out;
@@ -1525,17 +1562,17 @@ static int udf_fill_super(struct super_b
 	}
 
 	if (!UDF_SB_NUMPARTS(sb)) {
-		printk("UDF-fs: No partition found (2)\n");
+		printk(KERN_WARNING "UDF-fs: No partition found (2)\n");
 		goto error_out;
 	}
 
 	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_READ_ONLY) {
-		printk("UDF-fs: Partition marked readonly; forcing readonly mount\n");
+		printk(KERN_NOTICE "UDF-fs: Partition marked readonly; forcing readonly mount\n");
 		sb->s_flags |= MS_RDONLY;
 	}
 
 	if (udf_find_fileset(sb, &fileset, &rootdir)) {
-		printk("UDF-fs: No fileset found\n");
+		printk(KERN_WARNING "UDF-fs: No fileset found\n");
 		goto error_out;
 	}
 
@@ -1556,7 +1593,7 @@ static int udf_fill_super(struct super_b
 	/* perhaps it's not extensible enough, but for now ... */
 	inode = udf_iget(sb, rootdir);
 	if (!inode) {
-		printk("UDF-fs: Error in udf_iget, block=%d, partition=%d\n",
+		printk(KERN_ERR "UDF-fs: Error in udf_iget, block=%d, partition=%d\n",
 		       rootdir.logicalBlockNum, rootdir.partitionReferenceNum);
 		goto error_out;
 	}
@@ -1564,7 +1601,7 @@ static int udf_fill_super(struct super_b
 	/* Allocate a dentry for the root inode */
 	sb->s_root = d_alloc_root(inode);
 	if (!sb->s_root) {
-		printk("UDF-fs: Couldn't allocate root dentry\n");
+		printk(KERN_ERR "UDF-fs: Couldn't allocate root dentry\n");
 		iput(inode);
 		goto error_out;
 	}
@@ -1580,9 +1617,9 @@ error_out:
 		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_TABLE)
 			iput(UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_table);
 		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_BITMAP)
-			UDF_SB_FREE_BITMAP(sb,UDF_SB_PARTITION(sb), s_uspace);
+			UDF_SB_FREE_BITMAP(sb, UDF_SB_PARTITION(sb), s_uspace);
 		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP)
-			UDF_SB_FREE_BITMAP(sb,UDF_SB_PARTITION(sb), s_fspace);
+			UDF_SB_FREE_BITMAP(sb, UDF_SB_PARTITION(sb), s_fspace);
 		if (UDF_SB_PARTTYPE(sb, UDF_SB_PARTITION(sb)) == UDF_SPARABLE_MAP15) {
 			for (i = 0; i < 4; i++)
 				brelse(UDF_SB_TYPESPAR(sb, UDF_SB_PARTITION(sb)).s_spar_map[i]);
@@ -1614,7 +1651,7 @@ void udf_error(struct super_block *sb, c
 	va_start(args, fmt);
 	vsnprintf(error_buf, sizeof(error_buf), fmt, args);
 	va_end(args);
-	printk (KERN_CRIT "UDF-fs error (device %s): %s: %s\n",
+	printk(KERN_CRIT "UDF-fs error (device %s): %s: %s\n",
 		sb->s_id, function, error_buf);
 }
 
@@ -1655,9 +1692,9 @@ static void udf_put_super(struct super_b
 		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_TABLE)
 			iput(UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_table);
 		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_BITMAP)
-			UDF_SB_FREE_BITMAP(sb,UDF_SB_PARTITION(sb), s_uspace);
+			UDF_SB_FREE_BITMAP(sb, UDF_SB_PARTITION(sb), s_uspace);
 		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP)
-			UDF_SB_FREE_BITMAP(sb,UDF_SB_PARTITION(sb), s_fspace);
+			UDF_SB_FREE_BITMAP(sb, UDF_SB_PARTITION(sb), s_fspace);
 		if (UDF_SB_PARTTYPE(sb, UDF_SB_PARTITION(sb)) == UDF_SPARABLE_MAP15) {
 			for (i = 0; i < 4; i++)
 				brelse(UDF_SB_TYPESPAR(sb, UDF_SB_PARTITION(sb)).s_spar_map[i]);
@@ -1786,9 +1823,9 @@ static unsigned int udf_count_free_table
 	epos.offset = sizeof(struct unallocSpaceEntry);
 	epos.bh = NULL;
 
-	while ((etype = udf_next_aext(table, &epos, &eloc, &elen, 1)) != -1) {
+	while ((etype = udf_next_aext(table, &epos, &eloc, &elen, 1)) != -1)
 		accum += (elen >> table->i_sb->s_blocksize_bits);
-	}
+
 	brelse(epos.bh);
 
 	unlock_kernel();
@@ -1811,22 +1848,22 @@ static unsigned int udf_count_free(struc
 	if (accum)
 		return accum;
 
-	if (UDF_SB_PARTFLAGS(sb,UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_BITMAP) {
+	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_BITMAP) {
 		accum += udf_count_free_bitmap(sb,
 					       UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_bitmap);
 	}
-	if (UDF_SB_PARTFLAGS(sb,UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP) {
+	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP) {
 		accum += udf_count_free_bitmap(sb,
 					       UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_bitmap);
 	}
 	if (accum)
 		return accum;
 
-	if (UDF_SB_PARTFLAGS(sb,UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_TABLE) {
+	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_TABLE) {
 		accum += udf_count_free_table(sb,
 					      UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_table);
 	}
-	if (UDF_SB_PARTFLAGS(sb,UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_TABLE) {
+	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_TABLE) {
 		accum += udf_count_free_table(sb,
 					      UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_table);
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
