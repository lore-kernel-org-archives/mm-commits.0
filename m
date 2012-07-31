From: akpm@linux-foundation.org
Subject: [merged] affs-use-memweight.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:51:02 -0700
Message-ID: <20120731185103.01CFF200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:58281 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254Ab2GaSvE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:51:04 -0400
Received: by fat25 with SMTP id 25so290581fat.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:51:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: affs: use memweight()
has been removed from the -mm tree.  Its filename was
     affs-use-memweight.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: affs: use memweight()

Use memweight() to count the total number of bits set in memory area.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/bitmap.c |   28 ++--------------------------
 1 file changed, 2 insertions(+), 26 deletions(-)

diff -puN fs/affs/bitmap.c~affs-use-memweight fs/affs/bitmap.c
--- a/fs/affs/bitmap.c~affs-use-memweight
+++ a/fs/affs/bitmap.c
@@ -10,30 +10,6 @@
 #include <linux/slab.h>
 #include "affs.h"
 
-/* This is, of course, shamelessly stolen from fs/minix */
-
-static const int nibblemap[] = { 0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4 };
-
-static u32
-affs_count_free_bits(u32 blocksize, const void *data)
-{
-	const u32 *map;
-	u32 free;
-	u32 tmp;
-
-	map = data;
-	free = 0;
-	for (blocksize /= 4; blocksize > 0; blocksize--) {
-		tmp = *map++;
-		while (tmp) {
-			free += nibblemap[tmp & 0xf];
-			tmp >>= 4;
-		}
-	}
-
-	return free;
-}
-
 u32
 affs_count_free_blocks(struct super_block *sb)
 {
@@ -317,7 +293,7 @@ int affs_init_bitmap(struct super_block 
 			goto out;
 		}
 		pr_debug("AFFS: read bitmap block %d: %d\n", blk, bm->bm_key);
-		bm->bm_free = affs_count_free_bits(sb->s_blocksize - 4, bh->b_data + 4);
+		bm->bm_free = memweight(bh->b_data + 4, sb->s_blocksize - 4);
 
 		/* Don't try read the extension if this is the last block,
 		 * but we also need the right bm pointer below
@@ -367,7 +343,7 @@ int affs_init_bitmap(struct super_block 
 
 	/* recalculate bitmap count for last block */
 	bm--;
-	bm->bm_free = affs_count_free_bits(sb->s_blocksize - 4, bh->b_data + 4);
+	bm->bm_free = memweight(bh->b_data + 4, sb->s_blocksize - 4);
 
 out:
 	affs_brelse(bh);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
fault-injection-fix-failcmdsh-warning.patch
linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch

