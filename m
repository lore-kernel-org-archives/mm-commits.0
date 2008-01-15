From: akpm@linux-foundation.org
Subject: + udf-improve-readability-of-udf_load_partition.patch added to -mm tree
Date: Tue, 15 Jan 2008 02:47:04 -0800
Message-ID: <200801151046.m0FAkiM3011689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40253 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753883AbYAOKrO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 05:47:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, hch@infradead.org, jack@suse.cz


The patch titled
     udf: improve readability of udf_load_partition
has been added to the -mm tree.  Its filename is
     udf-improve-readability-of-udf_load_partition.patch

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
Subject: udf: improve readability of udf_load_partition
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/super.c |   57 +++++++++++++++++++++++------------------------
 1 file changed, 29 insertions(+), 28 deletions(-)

diff -puN fs/udf/super.c~udf-improve-readability-of-udf_load_partition fs/udf/super.c
--- a/fs/udf/super.c~udf-improve-readability-of-udf_load_partition
+++ a/fs/udf/super.c
@@ -1447,44 +1447,45 @@ static int udf_load_partition(struct sup
 	sbi = UDF_SB(sb);
 
 	for (i = 0; i < ARRAY_SIZE(sbi->s_anchor); i++) {
-		if (sbi->s_anchor[i] &&
-		    (bh = udf_read_tagged(sb, sbi->s_anchor[i],
-					  sbi->s_anchor[i], &ident))) {
-			anchor = (struct anchorVolDescPtr *)bh->b_data;
-
-			/* Locate the main sequence */
-			main_s = le32_to_cpu(
-					anchor->mainVolDescSeqExt.extLocation);
-			main_e = le32_to_cpu(
-					anchor->mainVolDescSeqExt.extLength);
-			main_e = main_e >> sb->s_blocksize_bits;
-			main_e += main_s;
+		if (!sbi->s_anchor[i])
+			continue;
+		bh = udf_read_tagged(sb, sbi->s_anchor[i], sbi->s_anchor[i],
+				     &ident);
+		if (!bh)
+			continue;
+
+		anchor = (struct anchorVolDescPtr *)bh->b_data;
+
+		/* Locate the main sequence */
+		main_s = le32_to_cpu(anchor->mainVolDescSeqExt.extLocation);
+		main_e = le32_to_cpu(anchor->mainVolDescSeqExt.extLength);
+		main_e = main_e >> sb->s_blocksize_bits;
+		main_e += main_s;
 
-			/* Locate the reserve sequence */
-			reserve_s = le32_to_cpu(
+		/* Locate the reserve sequence */
+		reserve_s = le32_to_cpu(
 				anchor->reserveVolDescSeqExt.extLocation);
-			reserve_e = le32_to_cpu(
+		reserve_e = le32_to_cpu(
 				anchor->reserveVolDescSeqExt.extLength);
-			reserve_e = reserve_e >> sb->s_blocksize_bits;
-			reserve_e += reserve_s;
+		reserve_e = reserve_e >> sb->s_blocksize_bits;
+		reserve_e += reserve_s;
 
-			brelse(bh);
+		brelse(bh);
 
-			/* Process the main & reserve sequences */
-			/* responsible for finding the PartitionDesc(s) */
-			if (!(udf_process_sequence(sb, main_s, main_e,
-						   fileset) &&
-			      udf_process_sequence(sb, reserve_s, reserve_e,
-						   fileset)))
-				break;
-		}
+		/* Process the main & reserve sequences */
+		/* responsible for finding the PartitionDesc(s) */
+		if (!(udf_process_sequence(sb, main_s, main_e,
+					   fileset) &&
+		      udf_process_sequence(sb, reserve_s, reserve_e,
+					   fileset)))
+			break;
 	}
 
 	if (i == ARRAY_SIZE(sbi->s_anchor)) {
 		udf_debug("No Anchor block found\n");
 		return 1;
-	} else
-		udf_debug("Using anchor in block %d\n", sbi->s_anchor[i]);
+	}
+	udf_debug("Using anchor in block %d\n", sbi->s_anchor[i]);
 
 	for (i = 0; i < sbi->s_partitions; i++) {
 		kernel_lb_addr uninitialized_var(ino);
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
