From: akpm@linux-foundation.org
Subject: - udf-fix-sparse-warnings-shadowing-mismatch-between-declaration-and-definition.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:17:17 -0800
Message-ID: <200802082016.m18KGweG010774@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55703 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755006AbYBHVCy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:02:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, bfennema@falcon.csc.calpoly.edu, hch@infradead.org, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     udf: fix sparse warnings (shadowing & mismatch between declaration and definition)
has been removed from the -mm tree.  Its filename was
     udf-fix-sparse-warnings-shadowing-mismatch-between-declaration-and-definition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix.patch
