From: akpm@linux-foundation.org
Subject: [merged] ext2-use-memweight.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:51:14 -0700
Message-ID: <20120731185115.167775C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:42658 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293Ab2GaSvR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:51:17 -0400
Received: by wibhr14 with SMTP id hr14so147100wib.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:51:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: ext2: use memweight()
has been removed from the -mm tree.  Its filename was
     ext2-use-memweight.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Jan Kara <jack@suse.cz>
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

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
fault-injection-fix-failcmdsh-warning.patch
linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch

