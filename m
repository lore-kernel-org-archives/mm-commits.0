From: akpm@linux-foundation.org
Subject: - ext2-return-after-ext2_error-in-case-of-failures.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:20:48 -0800
Message-ID: <200802070020.m170KTd8006142@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57097 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763273AbYBGAVE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:21:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ext2: return after ext2_error in case of failures
has been removed from the -mm tree.  Its filename was
     ext2-return-after-ext2_error-in-case-of-failures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2: return after ext2_error in case of failures
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

This fixes some instances where we were continuing after calling
ext2_error.  ext2_error call panic only if errors=panic mount option is
set.  So we need to make sure we return correctly after ext2_error call.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/balloc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/ext2/balloc.c~ext2-return-after-ext2_error-in-case-of-failures fs/ext2/balloc.c
--- a/fs/ext2/balloc.c~ext2-return-after-ext2_error-in-case-of-failures
+++ a/fs/ext2/balloc.c
@@ -474,11 +474,13 @@ do_more:
 	    in_range (block, le32_to_cpu(desc->bg_inode_table),
 		      sbi->s_itb_per_group) ||
 	    in_range (block + count - 1, le32_to_cpu(desc->bg_inode_table),
-		      sbi->s_itb_per_group))
+		      sbi->s_itb_per_group)) {
 		ext2_error (sb, "ext2_free_blocks",
 			    "Freeing blocks in system zones - "
 			    "Block = %lu, count = %lu",
 			    block, count);
+		goto error_return;
+	}
 
 	for (i = 0, group_freed = 0; i < count; i++) {
 		if (!ext2_clear_bit_atomic(sb_bgl_lock(sbi, block_group),
@@ -1311,11 +1313,13 @@ allocated:
 	    in_range(ret_block, le32_to_cpu(gdp->bg_inode_table),
 		      EXT2_SB(sb)->s_itb_per_group) ||
 	    in_range(ret_block + num - 1, le32_to_cpu(gdp->bg_inode_table),
-		      EXT2_SB(sb)->s_itb_per_group))
+		      EXT2_SB(sb)->s_itb_per_group)) {
 		ext2_error(sb, "ext2_new_blocks",
 			    "Allocating block in system zone - "
 			    "blocks from "E2FSBLK", length %lu",
 			    ret_block, num);
+		goto out;
+	}
 
 	performed_allocation = 1;
 
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

origin.patch
