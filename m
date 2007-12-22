From: akpm@linux-foundation.org
Subject: - udf-fix-sparse-warnings-shadowing-mismatch-between-declaration-and-definition.patch removed from -mm tree
Date: Fri, 21 Dec 2007 16:21:48 -0800
Message-ID: <200712220021.lBM0LmZJ006385@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54306 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757649AbXLVAWB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 19:22:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, bfennema@falcon.csc.calpoly.edu, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     udf: fix sparse warnings (shadowing & mismatch between declaration and definition)
has been removed from the -mm tree.  Its filename was
     udf-fix-sparse-warnings-shadowing-mismatch-between-declaration-and-definition.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: udf: fix sparse warnings (shadowing & mismatch between declaration and definition)
From: Marcin Slusarz <marcin.slusarz@gmail.com>

fix warnings:
fs/udf/super.c:1320:24: warning: symbol 'bh' shadows an earlier one
fs/udf/super.c:1240:21: originally declared here
fs/udf/super.c:1583:4: warning: symbol 'i' shadows an earlier one
fs/udf/super.c:1418:6: originally declared here
fs/udf/super.c:1585:4: warning: symbol 'i' shadows an earlier one
fs/udf/super.c:1418:6: originally declared here
fs/udf/super.c:1658:4: warning: symbol 'i' shadows an earlier one
fs/udf/super.c:1648:6: originally declared here
fs/udf/super.c:1660:4: warning: symbol 'i' shadows an earlier one
fs/udf/super.c:1648:6: originally declared here
fs/udf/super.c:450:6: warning: symbol 'udf_write_super' was not declared. Should it be static?

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/super.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN fs/udf/super.c~udf-fix-sparse-warnings-shadowing-mismatch-between-declaration-and-definition fs/udf/super.c
--- a/fs/udf/super.c~udf-fix-sparse-warnings-shadowing-mismatch-between-declaration-and-definition
+++ a/fs/udf/super.c
@@ -447,7 +447,7 @@ static int udf_parse_options(char *optio
 	return 1;
 }
 
-void udf_write_super(struct super_block *sb)
+static void udf_write_super(struct super_block *sb)
 {
 	lock_kernel();
 
@@ -1317,7 +1317,6 @@ static int udf_load_partition(struct sup
 				UDF_SB_TYPEVIRT(sb, i).s_num_entries =
 					(UDF_SB_VAT(sb)->i_size - 36) >> 2;
 			} else if (UDF_SB_PARTTYPE(sb, i) == UDF_VIRTUAL_MAP20) {
-				struct buffer_head *bh = NULL;
 				uint32_t pos;
 
 				pos = udf_block_map(UDF_SB_VAT(sb), 0);
@@ -1415,7 +1414,7 @@ static void udf_close_lvid(struct super_
  */
 static int udf_fill_super(struct super_block *sb, void *options, int silent)
 {
-	int i;
+	int idx;
 	struct inode *inode = NULL;
 	struct udf_options uopt;
 	kernel_lb_addr rootdir, fileset;
@@ -1583,8 +1582,8 @@ error_out:
 		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP)
 			UDF_SB_FREE_BITMAP(sb,UDF_SB_PARTITION(sb), s_fspace);
 		if (UDF_SB_PARTTYPE(sb, UDF_SB_PARTITION(sb)) == UDF_SPARABLE_MAP15) {
-			for (i = 0; i < 4; i++)
-				brelse(UDF_SB_TYPESPAR(sb, UDF_SB_PARTITION(sb)).s_spar_map[i]);
+			for (idx = 0; idx < 4; idx++)
+				brelse(UDF_SB_TYPESPAR(sb, UDF_SB_PARTITION(sb)).s_spar_map[idx]);
 		}
 	}
 #ifdef CONFIG_UDF_NLS
@@ -1644,7 +1643,7 @@ void udf_warning(struct super_block *sb,
  */
 static void udf_put_super(struct super_block *sb)
 {
-	int i;
+	int idx;
 
 	if (UDF_SB_VAT(sb))
 		iput(UDF_SB_VAT(sb));
@@ -1658,8 +1657,8 @@ static void udf_put_super(struct super_b
 		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP)
 			UDF_SB_FREE_BITMAP(sb,UDF_SB_PARTITION(sb), s_fspace);
 		if (UDF_SB_PARTTYPE(sb, UDF_SB_PARTITION(sb)) == UDF_SPARABLE_MAP15) {
-			for (i = 0; i < 4; i++)
-				brelse(UDF_SB_TYPESPAR(sb, UDF_SB_PARTITION(sb)).s_spar_map[i]);
+			for (idx = 0; idx < 4; idx++)
+				brelse(UDF_SB_TYPESPAR(sb, UDF_SB_PARTITION(sb)).s_spar_map[idx]);
 		}
 	}
 #ifdef CONFIG_UDF_NLS
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

git-alsa.patch
ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol-checkpatch-fixes.patch
vgacon-fix-sparse-warning-about-shadowing-i-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-p-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-rotate-symbol.patch
logo-move-declarations-of-logos-to-linux_logoh.patch
logo-move-declarations-of-logos-to-linux_logoh-fix.patch
udf-fix-sparse-warnings-shadowing-mismatch-between-declaration-and-definition.patch
