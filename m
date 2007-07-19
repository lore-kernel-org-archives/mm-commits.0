From: akpm@linux-foundation.org
Subject: - readahead-convert-ext3-ext4-invocations.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:01:18 -0700
Message-ID: <200707192001.l6JK1IfF019525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41616 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932149AbXGSU2S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:28:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, linuxram@us.ibm.com, rusty@rustcorp.com.au, slpratt@austin.ibm.com, mm-commits@vger.kernel.org


The patch titled
     readahead: convert ext3/ext4 invocations
has been removed from the -mm tree.  Its filename was
     readahead-convert-ext3-ext4-invocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Rusty Russell <rusty@rustcorp.com.au>
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

origin.patch
