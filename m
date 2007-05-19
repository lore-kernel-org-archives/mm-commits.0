From: akpm@linux-foundation.org
Subject: + readahead-convert-ext3-ext4-invocations.patch added to -mm tree
Date: Fri, 18 May 2007 23:29:11 -0700
Message-ID: <200705190629.l4J6TAE5031283@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42844 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754338AbXESGb3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 19 May 2007 02:31:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn, linuxram@us.ibm.com, slpratt@austin.ibm.com


The patch titled
     readahead: convert ext3/ext4 invocations
has been added to the -mm tree.  Its filename is
     readahead-convert-ext3-ext4-invocations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead: convert ext3/ext4 invocations
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Convert ext3/ext4 dir reads to use on-demand readahead.

Readahead for dirs operates _not_ on file level, but on blockdev level.  This
makes a difference when the data blocks are not continuous.  And the read
routine is somehow opaque: there's no handy info about the status of current
page.  So a simplified call scheme is employed: to call into readahead
whenever the current page falls out of readahead windows.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Steven Pratt <slpratt@austin.ibm.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/dir.c |   14 ++++++++------
 fs/ext4/dir.c |   14 ++++++++------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff -puN fs/ext3/dir.c~readahead-convert-ext3-ext4-invocations fs/ext3/dir.c
--- a/fs/ext3/dir.c~readahead-convert-ext3-ext4-invocations
+++ a/fs/ext3/dir.c
@@ -136,12 +136,14 @@ static int ext3_readdir(struct file * fi
 		err = ext3_get_blocks_handle(NULL, inode, blk, 1,
 						&map_bh, 0, 0);
 		if (err > 0) {
-			page_cache_readahead(sb->s_bdev->bd_inode->i_mapping,
-				&filp->f_ra,
-				filp,
-				map_bh.b_blocknr >>
-					(PAGE_CACHE_SHIFT - inode->i_blkbits),
-				1);
+			pgoff_t index = map_bh.b_blocknr >>
+					(PAGE_CACHE_SHIFT - inode->i_blkbits);
+			if (!ra_has_index(&filp->f_ra, index))
+				page_cache_readahead_ondemand(
+					sb->s_bdev->bd_inode->i_mapping,
+					&filp->f_ra, filp,
+					NULL, index, 1);
+			filp->f_ra.prev_index = index;
 			bh = ext3_bread(NULL, inode, blk, 0, &err);
 		}
 
diff -puN fs/ext4/dir.c~readahead-convert-ext3-ext4-invocations fs/ext4/dir.c
--- a/fs/ext4/dir.c~readahead-convert-ext3-ext4-invocations
+++ a/fs/ext4/dir.c
@@ -135,12 +135,14 @@ static int ext4_readdir(struct file * fi
 		map_bh.b_state = 0;
 		err = ext4_get_blocks_wrap(NULL, inode, blk, 1, &map_bh, 0, 0);
 		if (err > 0) {
-			page_cache_readahead(sb->s_bdev->bd_inode->i_mapping,
-				&filp->f_ra,
-				filp,
-				map_bh.b_blocknr >>
-					(PAGE_CACHE_SHIFT - inode->i_blkbits),
-				1);
+			pgoff_t index = map_bh.b_blocknr >>
+					(PAGE_CACHE_SHIFT - inode->i_blkbits);
+			if (!ra_has_index(&filp->f_ra, index))
+				page_cache_readahead_ondemand(
+					sb->s_bdev->bd_inode->i_mapping,
+					&filp->f_ra, filp,
+					NULL, index, 1);
+			filp->f_ra.prev_index = index;
 			bh = ext4_bread(NULL, inode, blk, 0, &err);
 		}
 
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

readahead-introduce-pg_readahead.patch
readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch
readahead-min_ra_pages-max_ra_pages-macros.patch
readahead-data-structure-and-routines.patch
readahead-on-demand-readahead-logic.patch
readahead-convert-filemap-invocations.patch
readahead-convert-splice-invocations.patch
readahead-convert-ext3-ext4-invocations.patch
readahead-remove-the-old-algorithm.patch
