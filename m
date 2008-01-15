From: akpm@linux-foundation.org
Subject: + udf-convert-udf_sb_alloc_partmaps-macro-to-udf_sb_alloc_partition_maps-function.patch added to -mm tree
Date: Tue, 15 Jan 2008 02:46:32 -0800
Message-ID: <200801151046.m0FAkCpH011629@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44958 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753807AbYAOKrO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 05:47:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, bfennema@falcon.csc.calpoly.edu, hch@infradead.org, jack@suse.cz


The patch titled
     udf: convert UDF_SB_ALLOC_PARTMAPS macro to udf_sb_alloc_partition_maps function
has been added to the -mm tree.  Its filename is
     udf-convert-udf_sb_alloc_partmaps-macro-to-udf_sb_alloc_partition_maps-function.patch

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
Subject: udf: convert UDF_SB_ALLOC_PARTMAPS macro to udf_sb_alloc_partition_maps function
From: Marcin Slusarz <marcin.slusarz@gmail.com>

- convert UDF_SB_ALLOC_PARTMAPS macro to udf_sb_alloc_partition_maps function
- convert kmalloc + memset to kcalloc
- check if kcalloc failed (partially)

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Cc: Jan Kara <jack@suse.cz>
Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/super.c  |   25 +++++++++++++++++++++++--
 fs/udf/udf_sb.h |   13 -------------
 2 files changed, 23 insertions(+), 15 deletions(-)

diff -puN fs/udf/super.c~udf-convert-udf_sb_alloc_partmaps-macro-to-udf_sb_alloc_partition_maps-function fs/udf/super.c
--- a/fs/udf/super.c~udf-convert-udf_sb_alloc_partmaps-macro-to-udf_sb_alloc_partition_maps-function
+++ a/fs/udf/super.c
@@ -52,6 +52,7 @@
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
 #include <linux/vmalloc.h>
+#include <linux/errno.h>
 #include <asm/byteorder.h>
 
 #include <linux/udf_fs.h>
@@ -226,6 +227,24 @@ static void __exit exit_udf_fs(void)
 module_init(init_udf_fs)
 module_exit(exit_udf_fs)
 
+static int udf_sb_alloc_partition_maps(struct super_block *sb, u32 count)
+{
+	struct udf_sb_info *sbi = UDF_SB(sb);
+
+	sbi->s_partmaps = kcalloc(count, sizeof(struct udf_part_map),
+				  GFP_KERNEL);
+	if (!sbi->s_partmaps) {
+		udf_error(sb, __FUNCTION__,
+			  "Unable to allocate space for %d partition maps",
+			  count);
+		sbi->s_partitions = 0;
+		return -ENOMEM;
+	}
+
+	sbi->s_partitions = count;
+	return 0;
+}
+
 /*
  * udf_parse_options
  *
@@ -1037,7 +1056,9 @@ static int udf_load_logicalvol(struct su
 
 	lvd = (struct logicalVolDesc *)bh->b_data;
 
-	UDF_SB_ALLOC_PARTMAPS(sb, le32_to_cpu(lvd->numPartitionMaps));
+	i = udf_sb_alloc_partition_maps(sb, le32_to_cpu(lvd->numPartitionMaps));
+	if (i != 0)
+		return i;
 
 	for (i = 0, offset = 0;
 	     i < sbi->s_partitions && offset < le32_to_cpu(lvd->mapTableLength);
@@ -1242,7 +1263,7 @@ static int udf_process_sequence(struct s
 			if (i == VDS_POS_PRIMARY_VOL_DESC) {
 				udf_load_pvoldesc(sb, bh);
 			} else if (i == VDS_POS_LOGICAL_VOL_DESC) {
-				udf_load_logicalvol(sb, bh, fileset);
+				udf_load_logicalvol(sb, bh, fileset); /* TODO: check return value */
 			} else if (i == VDS_POS_PARTITION_DESC) {
 				struct buffer_head *bh2 = NULL;
 				if (udf_load_partdesc(sb, bh)) {
diff -puN fs/udf/udf_sb.h~udf-convert-udf_sb_alloc_partmaps-macro-to-udf_sb_alloc_partition_maps-function fs/udf/udf_sb.h
--- a/fs/udf/udf_sb.h~udf-convert-udf_sb_alloc_partmaps-macro-to-udf_sb_alloc_partition_maps-function
+++ a/fs/udf/udf_sb.h
@@ -43,19 +43,6 @@ static inline struct udf_sb_info *UDF_SB
 
 struct logicalVolIntegrityDescImpUse *udf_sb_lvidiu(struct udf_sb_info *sbi);
 
-#define UDF_SB_ALLOC_PARTMAPS(X,Y)\
-{\
-	struct udf_sb_info *sbi = UDF_SB(X);\
-	sbi->s_partmaps = kmalloc(sizeof(struct udf_part_map) * Y, GFP_KERNEL);\
-	if (sbi->s_partmaps != NULL) {\
-		sbi->s_partitions = Y;\
-		memset(sbi->s_partmaps, 0x00, sizeof(struct udf_part_map) * Y);\
-	} else {\
-		sbi->s_partitions = 0;\
-		udf_error(X, __FUNCTION__, "Unable to allocate space for %d partition maps", Y);\
-	}\
-}
-
 #define UDF_SB_ALLOC_BITMAP(X,Y,Z)\
 {\
 	struct udf_sb_info *sbi = UDF_SB(X);\
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
