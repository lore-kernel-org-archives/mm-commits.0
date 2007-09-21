From: akpm@linux-foundation.org
Subject: + udf-code-style-fixup-v3.patch added to -mm tree
Date: Fri, 21 Sep 2007 12:24:48 -0700
Message-ID: <200709211924.l8LJOmau018710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60967 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761309AbXIUTZS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 15:25:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, jack@suse.cz


The patch titled
     UDF: coding style fixups
has been added to the -mm tree.  Its filename is
     udf-code-style-fixup-v3.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: UDF: coding style fixups
From: Cyrill Gorcunov <gorcunov@gmail.com>

This patch does additional coding style fixup.  Initially the code is being
distorted by Lindent (in my patches sent not very long ago) and fixed in
the followup patches but this stuff was accidently missed.

New and old compiled files were compared with cmp to check for being
identically.  So the patch will not break the kernel.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/super.c   |   51 ++++++++++++++++-----------------------------
 fs/udf/udftime.c |    8 +++----
 2 files changed, 23 insertions(+), 36 deletions(-)

diff -puN fs/udf/super.c~udf-code-style-fixup-v3 fs/udf/super.c
--- a/fs/udf/super.c~udf-code-style-fixup-v3
+++ a/fs/udf/super.c
@@ -913,8 +913,7 @@ static int udf_load_partdesc(struct supe
 					UDF_SB_PARTMAPS(sb)[i].s_uspace.s_table =
 						udf_iget(sb, loc);
 					if (!UDF_SB_PARTMAPS(sb)[i].s_uspace.s_table) {
-						udf_debug("cannot load unallocSpaceTable (part %d)\n",
-							i);
+						udf_debug("cannot load unallocSpaceTable (part %d)\n", i);
 						return 1;
 					}
 					UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_UNALLOC_TABLE;
@@ -944,8 +943,7 @@ static int udf_load_partdesc(struct supe
 					UDF_SB_PARTMAPS(sb)[i].s_fspace.s_table =
 						udf_iget(sb, loc);
 					if (!UDF_SB_PARTMAPS(sb)[i].s_fspace.s_table) {
-						udf_debug("cannot load freedSpaceTable (part %d)\n",
-							i);
+						udf_debug("cannot load freedSpaceTable (part %d)\n", i);
 						return 1;
 					}
 					UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_FREED_TABLE;
@@ -1293,19 +1291,16 @@ static int udf_load_partition(struct sup
 
 			if (!UDF_SB_LASTBLOCK(sb)) {
 				udf_debug("Unable to determine Lastblock (For "
-						"Virtual Partition)\n");
+					  "Virtual Partition)\n");
 				return 1;
 			}
 
 			for (j = 0; j < UDF_SB_NUMPARTS(sb); j++) {
-				if (j != i && UDF_SB_PARTVSN(sb, i) ==
-					UDF_SB_PARTVSN(sb, j) &&
-				    	UDF_SB_PARTNUM(sb, i) ==
-						UDF_SB_PARTNUM(sb, j)) {
+				if (j != i &&
+				    UDF_SB_PARTVSN(sb, i) == UDF_SB_PARTVSN(sb, j) &&
+				    UDF_SB_PARTNUM(sb, i) == UDF_SB_PARTNUM(sb, j)) {
 					ino.partitionReferenceNum = j;
-					ino.logicalBlockNum =
-					    UDF_SB_LASTBLOCK(sb) -
-					    UDF_SB_PARTROOT(sb, j);
+					ino.logicalBlockNum = UDF_SB_LASTBLOCK(sb) - UDF_SB_PARTROOT(sb, j);
 					break;
 				}
 			}
@@ -1318,9 +1313,9 @@ static int udf_load_partition(struct sup
 
 			if (UDF_SB_PARTTYPE(sb, i) == UDF_VIRTUAL_MAP15) {
 				UDF_SB_TYPEVIRT(sb, i).s_start_offset =
-				    udf_ext0_offset(UDF_SB_VAT(sb));
+					udf_ext0_offset(UDF_SB_VAT(sb));
 				UDF_SB_TYPEVIRT(sb, i).s_num_entries =
-				    (UDF_SB_VAT(sb)->i_size - 36) >> 2;
+					(UDF_SB_VAT(sb)->i_size - 36) >> 2;
 			} else if (UDF_SB_PARTTYPE(sb, i) == UDF_VIRTUAL_MAP20) {
 				struct buffer_head *bh = NULL;
 				uint32_t pos;
@@ -1330,19 +1325,15 @@ static int udf_load_partition(struct sup
 				if (!bh)
 					return 1;
 				UDF_SB_TYPEVIRT(sb, i).s_start_offset =
-				    le16_to_cpu(((struct
-					virtualAllocationTable20 *)bh->b_data +
-					  udf_ext0_offset(UDF_SB_VAT(sb)))->
-						lengthHeader) +
-					  udf_ext0_offset(UDF_SB_VAT(sb));
-				UDF_SB_TYPEVIRT(sb, i).s_num_entries =
-				    (UDF_SB_VAT(sb)->i_size -
-				     UDF_SB_TYPEVIRT(sb, i).s_start_offset) >> 2;
+					le16_to_cpu(((struct virtualAllocationTable20 *)bh->b_data +
+						     udf_ext0_offset(UDF_SB_VAT(sb)))->lengthHeader) +
+					udf_ext0_offset(UDF_SB_VAT(sb));
+				UDF_SB_TYPEVIRT(sb, i).s_num_entries = (UDF_SB_VAT(sb)->i_size -
+									UDF_SB_TYPEVIRT(sb, i).s_start_offset) >> 2;
 				brelse(bh);
 			}
 			UDF_SB_PARTROOT(sb, i) = udf_get_pblock(sb, 0, i, 0);
-			UDF_SB_PARTLEN(sb, i) = UDF_SB_PARTLEN(sb,
-						ino.partitionReferenceNum);
+			UDF_SB_PARTLEN(sb, i) = UDF_SB_PARTLEN(sb, ino.partitionReferenceNum);
 		}
 	}
 	return 0;
@@ -1357,21 +1348,17 @@ static void udf_open_lvid(struct super_b
 		UDF_SB_LVIDIU(sb)->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
 		UDF_SB_LVIDIU(sb)->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
 		if (udf_time_to_stamp(&cpu_time, CURRENT_TIME))
-			UDF_SB_LVID(sb)->recordingDateAndTime =
-			    cpu_to_lets(cpu_time);
+			UDF_SB_LVID(sb)->recordingDateAndTime = cpu_to_lets(cpu_time);
 		UDF_SB_LVID(sb)->integrityType = LVID_INTEGRITY_TYPE_OPEN;
 
-		UDF_SB_LVID(sb)->descTag.descCRC =
-		    cpu_to_le16(udf_crc((char *)UDF_SB_LVID(sb) + sizeof(tag),
-					le16_to_cpu(UDF_SB_LVID(sb)->descTag.
-						    descCRCLength), 0));
+		UDF_SB_LVID(sb)->descTag.descCRC = cpu_to_le16(udf_crc((char *)UDF_SB_LVID(sb) + sizeof(tag),
+								       le16_to_cpu(UDF_SB_LVID(sb)->descTag.descCRCLength), 0));
 
 		UDF_SB_LVID(sb)->descTag.tagChecksum = 0;
 		for (i = 0; i < 16; i++)
 			if (i != 4)
 				UDF_SB_LVID(sb)->descTag.tagChecksum +=
-				    ((uint8_t *) &
-				     (UDF_SB_LVID(sb)->descTag))[i];
+					((uint8_t *) &(UDF_SB_LVID(sb)->descTag))[i];
 
 		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
 	}
diff -puN fs/udf/udftime.c~udf-code-style-fixup-v3 fs/udf/udftime.c
--- a/fs/udf/udftime.c~udf-code-style-fixup-v3
+++ a/fs/udf/udftime.c
@@ -108,10 +108,10 @@ time_t *udf_stamp_to_time(time_t *dest, 
 	*dest = year_seconds[src.year - EPOCH_YEAR];
 	*dest -= offset * 60;
 
-	yday = ((__mon_yday[__isleap (src.year)]
-		 [src.month - 1]) + (src.day - 1));
-	*dest += ( ( (yday * 24) + src.hour ) * 60 + src.minute ) * 60 + src.second;
-	*dest_usec = src.centiseconds * 10000 + src.hundredsOfMicroseconds * 100 + src.microseconds;
+	yday = ((__mon_yday[__isleap(src.year)][src.month - 1]) + src.day - 1);
+	*dest += (((yday * 24) + src.hour) * 60 + src.minute) * 60 + src.second;
+	*dest_usec = src.centiseconds * 10000 +
+			src.hundredsOfMicroseconds * 100 + src.microseconds;
 	return dest;
 }
 
_

Patches currently in -mm which might be from gorcunov@gmail.com are

git-cifs.patch
sky-cpu-and-nexus-code-style-improvement.patch
sky-cpu-and-nexus-include-ioh.patch
sky-cpu-and-nexus-check-for-platform_get_resource-ret.patch
sky-cpu-and-nexus-check-for-create_proc_entry-ret-code.patch
sky-cpu-use-c99-style-for-struct-init.patch
sky-cpu-and-nexus-get-rid-of-useless-null-init.patch
sky-cpu-and-nexus-use-seq_file-single_open-on-proc-interface.patch
udf-code-style-fixup-v3.patch
