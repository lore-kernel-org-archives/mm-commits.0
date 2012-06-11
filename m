From: akpm@linux-foundation.org
Subject: + affs-use-memweight.patch added to -mm tree
Date: Mon, 11 Jun 2012 16:17:43 -0700
Message-ID: <20120611231743.D53CDA0137@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:38639 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab2FKXRp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 19:17:45 -0400
Received: by were53 with SMTP id e53so254203wer.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 16:17:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     Subject: affs: use memweight()
has been added to the -mm tree.  Its filename is
     affs-use-memweight.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: affs: use memweight()

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch
string-introduce-memweight.patch
string-introduce-memweight-fix.patch
qnx4fs-use-memweight.patch
dm-use-memweight.patch
affs-use-memweight.patch
video-uvc-use-memweight.patch
ocfs2-use-memweight.patch
ext2-use-memweight.patch
ext3-use-memweight.patch
ext4-use-memweight.patch

