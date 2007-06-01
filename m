From: akpm@linux-foundation.org
Subject: - fix-possible-udf-data-corruption.patch removed from -mm tree
Date: Fri, 01 Jun 2007 10:47:00 -0700
Message-ID: <200706011746.l51Hkxf4015099@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759665AbXFARrD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 13:47:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Fix possible UDF data corruption
has been removed from the -mm tree.  Its filename was
     fix-possible-udf-data-corruption.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix possible UDF data corruption
From: Jan Kara <jack@suse.cz>

update_next_aext() could possibly rewrite values in elen and eloc, possibly
leading to data corruption when rewriting a file.  Use temporary variables
instead.  Also advance cur_epos as it can also point to an indirect extent
pointer.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/inode.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN fs/udf/inode.c~fix-possible-udf-data-corruption fs/udf/inode.c
--- a/fs/udf/inode.c~fix-possible-udf-data-corruption
+++ a/fs/udf/inode.c
@@ -460,8 +460,8 @@ static struct buffer_head * inode_getblk
 	kernel_long_ad laarr[EXTENT_MERGE_SIZE];
 	struct extent_position prev_epos, cur_epos, next_epos;
 	int count = 0, startnum = 0, endnum = 0;
-	uint32_t elen = 0;
-	kernel_lb_addr eloc;
+	uint32_t elen = 0, tmpelen;
+	kernel_lb_addr eloc, tmpeloc;
 	int c = 1;
 	loff_t lbcount = 0, b_off = 0;
 	uint32_t newblocknum, newblock;
@@ -520,8 +520,12 @@ static struct buffer_head * inode_getblk
 
 	b_off -= lbcount;
 	offset = b_off >> inode->i_sb->s_blocksize_bits;
-	/* Move into indirect extent if we are at a pointer to it */
-	udf_next_aext(inode, &prev_epos, &eloc, &elen, 0);
+	/*
+	 * Move prev_epos and cur_epos into indirect extent if we are at
+	 * the pointer to it
+	 */
+	udf_next_aext(inode, &prev_epos, &tmpeloc, &tmpelen, 0);
+	udf_next_aext(inode, &cur_epos, &tmpeloc, &tmpelen, 0);
 
 	/* if the extent is allocated and recorded, return the block
        if the extent is not a multiple of the blocksize, round up */
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
fix-possible-leakage-of-blocks-in-udf.patch
fix-possible-leakage-of-blocks-in-udf-tidy.patch
ext2-fix-a-comment-when-ext2_release_file-is-called.patch
