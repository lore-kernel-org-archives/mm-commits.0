From: akpm@linux-foundation.org
Subject: [merged] ext3-use-memweight.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:51:18 -0700
Message-ID: <20120731185119.211735C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:47750 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317Ab2GaSvV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:51:21 -0400
Received: by weyr1 with SMTP id r1so292367wey.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:51:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, adilger.kernel@dilger.ca, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: ext3: use memweight()
has been removed from the -mm tree.  Its filename was
     ext3-use-memweight.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: ext3: use memweight()

Convert ext3_count_free() to use memweight() instead of table lookup based
counting clear bits implementation.  This change only affects the code
segments enabled by EXT3FS_DEBUG.

Note that this memweight() call can't be replaced with a single
bitmap_weight() call, although the pointer to the memory area is aligned
to long-word boundary.  Because the size of the memory area may not be a
multiple of BITS_PER_LONG, then it returns wrong value on big-endian
architecture.

This also includes the following changes.

- Remove unnecessary map == NULL check in ext3_count_free() which
  always takes non-null pointer as the memory area.

- Fix printk format warning that only reveals with EXT3FS_DEBUG.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/balloc.c |    2 +-
 fs/ext3/bitmap.c |   12 +-----------
 2 files changed, 2 insertions(+), 12 deletions(-)

diff -puN fs/ext3/balloc.c~ext3-use-memweight fs/ext3/balloc.c
--- a/fs/ext3/balloc.c~ext3-use-memweight
+++ a/fs/ext3/balloc.c
@@ -1813,7 +1813,7 @@ ext3_fsblk_t ext3_count_free_blocks(stru
 	brelse(bitmap_bh);
 	printk("ext3_count_free_blocks: stored = "E3FSBLK
 		", computed = "E3FSBLK", "E3FSBLK"\n",
-	       le32_to_cpu(es->s_free_blocks_count),
+	       (ext3_fsblk_t)le32_to_cpu(es->s_free_blocks_count),
 		desc_count, bitmap_count);
 	return bitmap_count;
 #else
diff -puN fs/ext3/bitmap.c~ext3-use-memweight fs/ext3/bitmap.c
--- a/fs/ext3/bitmap.c~ext3-use-memweight
+++ a/fs/ext3/bitmap.c
@@ -11,19 +11,9 @@
 
 #ifdef EXT3FS_DEBUG
 
-static const int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0};
-
 unsigned long ext3_count_free (struct buffer_head * map, unsigned int numchars)
 {
-	unsigned int i;
-	unsigned long sum = 0;
