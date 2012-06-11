From: akpm@linux-foundation.org
Subject: + ext2-use-memweight.patch added to -mm tree
Date: Mon, 11 Jun 2012 16:17:50 -0700
Message-ID: <20120611231751.1D03DA0137@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:35653 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2FKXRy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 19:17:54 -0400
Received: by yenl3 with SMTP id l3so426240yen.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 16:17:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, jack@suse.cz


The patch titled
     Subject: ext2: use memweight()
has been added to the -mm tree.  Its filename is
     ext2-use-memweight.patch

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
Subject: ext2: use memweight()

Convert ext2_count_free() to use memweight() instead of table lookup based
counting clear bits implementation.  This change only affects the code
segments enabled by EXT2FS_DEBUG.

Note that this memweight() call can't be replaced with a single
bitmap_weight() call, although the pointer to the memory area is aligned
to long-word boundary.  Because the size of the memory area may not be a
multiple of BITS_PER_LONG, then it returns wrong value on big-endian
architecture.

This also includes the following changes.

- Remove unnecessary map == NULL check in ext2_count_free() which
  always takes non-null pointer as the memory area.

- Fix printk format warning that only reveals with EXT2FS_DEBUG.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/balloc.c |   14 ++------------
 fs/ext2/ialloc.c |    1 +
 2 files changed, 3 insertions(+), 12 deletions(-)

diff -puN fs/ext2/balloc.c~ext2-use-memweight fs/ext2/balloc.c
--- a/fs/ext2/balloc.c~ext2-use-memweight
+++ a/fs/ext2/balloc.c
@@ -1444,19 +1444,9 @@ ext2_fsblk_t ext2_new_block(struct inode
 
 #ifdef EXT2FS_DEBUG
 
-static const int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0};
-
-unsigned long ext2_count_free (struct buffer_head * map, unsigned int numchars)
+unsigned long ext2_count_free(struct buffer_head *map, unsigned int numchars)
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
 
 #endif  /*  EXT2FS_DEBUG  */
diff -puN fs/ext2/ialloc.c~ext2-use-memweight fs/ext2/ialloc.c
--- a/fs/ext2/ialloc.c~ext2-use-memweight
+++ a/fs/ext2/ialloc.c
@@ -644,6 +644,7 @@ unsigned long ext2_count_free_inodes (st
 	}
 	brelse(bitmap_bh);
 	printk("ext2_count_free_inodes: stored = %lu, computed = %lu, %lu\n",
+		(unsigned long)
 		percpu_counter_read(&EXT2_SB(sb)->s_freeinodes_counter),
 		desc_count, bitmap_count);
 	return desc_count;
_
Subject: Subject: ext2: use memweight()

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

