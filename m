From: akpm@linux-foundation.org
Subject: + ext3-use-memweight.patch added to -mm tree
Date: Mon, 11 Jun 2012 16:17:53 -0700
Message-ID: <20120611231753.D4B30A0137@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:55824 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab2FKXRz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 19:17:55 -0400
Received: by mail-bk0-f74.google.com with SMTP id y5so253004bkt.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 16:17:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, adilger.kernel@dilger.ca, jack@suse.cz


The patch titled
     Subject: ext3: use memweight()
has been added to the -mm tree.  Its filename is
     ext3-use-memweight.patch

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
Cc: Jan Kara <jack@suse.cz>
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
-
-	if (!map)
-		return (0);
-	for (i = 0; i < numchars; i++)
-		sum += nibblemap[map->b_data[i] & 0xf] +
-			nibblemap[(map->b_data[i] >> 4) & 0xf];
-	return (sum);
+	return numchars * BITS_PER_BYTE - memweight(map->b_data, numchars);
 }
 
 #endif  /*  EXT3FS_DEBUG  */
_
Subject: Subject: ext3: use memweight()

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

