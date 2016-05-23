From: akpm@linux-foundation.org
Subject: [patch 06/84] fs/befs/datastream.c:befs_find_brun_dblindirect():
 remove unneeded initializations to NULL
Date: Mon, 23 May 2016 16:22:38 -0700
Message-ID: <574390be.HLElP8TnVYngohuC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbcEWXWj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:22:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, salah.triki@acm.org

From: Salah Triki <salah.triki@acm.org>
Subject: fs/befs/datastream.c:befs_find_brun_dblindirect(): remove unneeded initializations to NULL

iaddr_array is unconditionally initialized to NULL in
befs_find_brun_dblindirect().

Link: http://lkml.kernel.org/r/940def273e30ef37957fba9da6981a10fb3c9741.1462649034.git.salah.triki@acm.org
Signed-off-by: Salah Triki <salah.triki@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/datastream.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/befs/datastream.c~fs-befs-datastreamc-befs_find_brun_dblindirect-remove-unneeded-initializations-to-null fs/befs/datastream.c
--- a/fs/befs/datastream.c~fs-befs-datastreamc-befs_find_brun_dblindirect-remove-unneeded-initializations-to-null
+++ a/fs/befs/datastream.c
@@ -429,7 +429,7 @@ befs_find_brun_dblindirect(struct super_
 	struct buffer_head *dbl_indir_block;
 	struct buffer_head *indir_block;
 	befs_block_run indir_run;
-	befs_disk_inode_addr *iaddr_array = NULL;
+	befs_disk_inode_addr *iaddr_array;
 	struct befs_sb_info *befs_sb = BEFS_SB(sb);
 
 	befs_blocknr_t indir_start_blk =
@@ -488,7 +488,6 @@ befs_find_brun_dblindirect(struct super_
 	iaddr_array = (befs_disk_inode_addr *) dbl_indir_block->b_data;
 	indir_run = fsrun_to_cpu(sb, iaddr_array[dbl_block_indx]);
 	brelse(dbl_indir_block);
-	iaddr_array = NULL;
 
 	/* Read indirect block */
 	which_block = indir_indx / befs_iaddrs_per_block(sb);
@@ -513,7 +512,6 @@ befs_find_brun_dblindirect(struct super_
 	iaddr_array = (befs_disk_inode_addr *) indir_block->b_data;
 	*run = fsrun_to_cpu(sb, iaddr_array[block_indx]);
 	brelse(indir_block);
-	iaddr_array = NULL;
 
 	blockno_at_run_start = indir_start_blk;
 	blockno_at_run_start += diblklen * dblindir_indx;
_
