From: akpm@linux-foundation.org
Subject: - udf-handle-wrong-superblock-better.patch removed from -mm tree
Date: Fri, 31 Aug 2007 09:55:47 -0700
Message-ID: <200708311655.l7VGtlxh017430@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34507 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759852AbXHaQzw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 12:55:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     UDF: handle wrong superblock better
has been removed from the -mm tree.  Its filename was
     udf-handle-wrong-superblock-better.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: UDF: handle wrong superblock better
From: Jan Kara <jack@suse.cz>

If UDF superblock is incorrect, we can fail to find a table of free /
allocated space and consequently Oops.  Handle this situation more
gracefully by ignoring the broken UDF partition.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/super.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff -puN fs/udf/super.c~udf-handle-wrong-superblock-better fs/udf/super.c
--- a/fs/udf/super.c~udf-handle-wrong-superblock-better
+++ a/fs/udf/super.c
@@ -89,7 +89,7 @@ static int udf_find_fileset(struct super
 static void udf_load_pvoldesc(struct super_block *, struct buffer_head *);
 static void udf_load_fileset(struct super_block *, struct buffer_head *,
 			     kernel_lb_addr *);
-static void udf_load_partdesc(struct super_block *, struct buffer_head *);
+static int udf_load_partdesc(struct super_block *, struct buffer_head *);
 static void udf_open_lvid(struct super_block *);
 static void udf_close_lvid(struct super_block *);
 static unsigned int udf_count_free(struct super_block *);
@@ -877,7 +877,7 @@ static void udf_load_fileset(struct supe
 		  root->logicalBlockNum, root->partitionReferenceNum);
 }
 
-static void udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
+static int udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
 {
 	struct partitionDesc *p;
 	int i;
@@ -912,6 +912,11 @@ static void udf_load_partdesc(struct sup
 
 					UDF_SB_PARTMAPS(sb)[i].s_uspace.s_table =
 						udf_iget(sb, loc);
+					if (!UDF_SB_PARTMAPS(sb)[i].s_uspace.s_table) {
+						udf_debug("cannot load unallocSpaceTable (part %d)\n",
+							i);
+						return 1;
+					}
 					UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_UNALLOC_TABLE;
 					udf_debug("unallocSpaceTable (part %d) @ %ld\n",
 						  i, UDF_SB_PARTMAPS(sb)[i].s_uspace.s_table->i_ino);
@@ -938,6 +943,11 @@ static void udf_load_partdesc(struct sup
 
 					UDF_SB_PARTMAPS(sb)[i].s_fspace.s_table =
 						udf_iget(sb, loc);
+					if (!UDF_SB_PARTMAPS(sb)[i].s_fspace.s_table) {
+						udf_debug("cannot load freedSpaceTable (part %d)\n",
+							i);
+						return 1;
+					}
 					UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_FREED_TABLE;
 					udf_debug("freedSpaceTable (part %d) @ %ld\n",
 						  i, UDF_SB_PARTMAPS(sb)[i].s_fspace.s_table->i_ino);
@@ -966,6 +976,7 @@ static void udf_load_partdesc(struct sup
 			  le16_to_cpu(p->partitionNumber), i, UDF_SB_PARTTYPE(sb,i),
 			  UDF_SB_PARTROOT(sb,i), UDF_SB_PARTLEN(sb,i));
 	}
+	return 0;
 }
 
 static int udf_load_logicalvol(struct super_block *sb, struct buffer_head *bh,
@@ -1177,12 +1188,19 @@ static int udf_process_sequence(struct s
 				udf_load_logicalvol(sb, bh, fileset);
 			} else if (i == VDS_POS_PARTITION_DESC) {
 				struct buffer_head *bh2 = NULL;
-				udf_load_partdesc(sb, bh);
+				if (udf_load_partdesc(sb, bh)) {
+					brelse(bh);
+					return 1;
+				}
 				for (j = vds[i].block + 1; j <  vds[VDS_POS_TERMINATING_DESC].block; j++) {
 					bh2 = udf_read_tagged(sb, j, j, &ident);
 					gd = (struct generic_desc *)bh2->b_data;
 					if (ident == TAG_IDENT_PD)
-						udf_load_partdesc(sb, bh2);
+						if (udf_load_partdesc(sb, bh2)) {
+							brelse(bh);
+							brelse(bh2);
+							return 1;
+						}
 					brelse(bh2);
 				}
 			}
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
