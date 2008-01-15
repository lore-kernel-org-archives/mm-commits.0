From: akpm@linux-foundation.org
Subject: + udf-fix-sparse-warnings-shadowing-mismatch-between-declaration-and-definition.patch added to -mm tree
Date: Tue, 15 Jan 2008 02:46:40 -0800
Message-ID: <200801151046.m0FAkKAf011660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49140 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252AbYAOKrF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 05:47:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, bfennema@falcon.csc.calpoly.edu, hch@infradead.org, jack@suse.cz


The patch titled
     udf: fix sparse warnings (shadowing & mismatch between declaration and definition)
has been added to the -mm tree.  Its filename is
     udf-fix-sparse-warnings-shadowing-mismatch-between-declaration-and-definition.patch

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
Subject: udf: fix sparse warnings (shadowing & mismatch between declaration and definition)
From: Marcin Slusarz <marcin.slusarz@gmail.com>

fix sparse warnings:
fs/udf/super.c:1431:24: warning: symbol 'bh' shadows an earlier one
fs/udf/super.c:1347:21: originally declared here
fs/udf/super.c:472:6: warning: symbol 'udf_write_super' was not declared. Should it be static?

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Cc: Jan Kara <jack@suse.cz>
Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/super.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/udf/super.c~udf-fix-sparse-warnings-shadowing-mismatch-between-declaration-and-definition fs/udf/super.c
--- a/fs/udf/super.c~udf-fix-sparse-warnings-shadowing-mismatch-between-declaration-and-definition
+++ a/fs/udf/super.c
@@ -474,7 +474,7 @@ static int udf_parse_options(char *optio
 	return 1;
 }
 
-void udf_write_super(struct super_block *sb)
+static void udf_write_super(struct super_block *sb)
 {
 	lock_kernel();
 
@@ -1447,7 +1447,6 @@ static int udf_load_partition(struct sup
 				map->s_type_specific.s_virtual.s_num_entries =
 					(sbi->s_vat_inode->i_size - 36) >> 2;
 			} else if (map->s_partition_type == UDF_VIRTUAL_MAP20) {
-				struct buffer_head *bh = NULL;
 				uint32_t pos;
 
 				pos = udf_block_map(sbi->s_vat_inode, 0);
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
