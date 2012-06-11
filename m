From: akpm@linux-foundation.org
Subject: + qnx4fs-use-memweight.patch added to -mm tree
Date: Mon, 11 Jun 2012 16:17:39 -0700
Message-ID: <20120611231739.D73D1A0137@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:52325 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab2FKXRm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 19:17:42 -0400
Received: by eaao13 with SMTP id o13so254130eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 16:17:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, al@alarsen.net


The patch titled
     Subject: qnx4fs: use memweight()
has been added to the -mm tree.  Its filename is
     qnx4fs-use-memweight.patch

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
Subject: qnx4fs: use memweight()

Use memweight() to count the total number of bits clear in memory area.

Note that this memweight() call can't be replaced with a single
bitmap_weight() call, although the pointer to the memory area is aligned
to long-word boundary.  Because the size of the memory area may not be a
multiple of BITS_PER_LONG, then it returns wrong value on big-endian
architecture.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Anders Larsen <al@alarsen.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/qnx4/bitmap.c |   24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff -puN fs/qnx4/bitmap.c~qnx4fs-use-memweight fs/qnx4/bitmap.c
--- a/fs/qnx4/bitmap.c~qnx4fs-use-memweight
+++ a/fs/qnx4/bitmap.c
@@ -17,23 +17,6 @@
 #include <linux/bitops.h>
 #include "qnx4.h"
 
-static void count_bits(register const char *bmPart, register int size,
-		       int *const tf)
-{
-	char b;
-	int tot = *tf;
-
-	if (size > QNX4_BLOCK_SIZE) {
-		size = QNX4_BLOCK_SIZE;
-	}
-	do {
-		b = *bmPart++;
-		tot += 8 - hweight8(b);
-		size--;
-	} while (size != 0);
-	*tf = tot;
-}
-
 unsigned long qnx4_count_free_blocks(struct super_block *sb)
 {
 	int start = le32_to_cpu(qnx4_sb(sb)->BitMap->di_first_xtnt.xtnt_blk) - 1;
@@ -44,13 +27,16 @@ unsigned long qnx4_count_free_blocks(str
 	struct buffer_head *bh;
 
 	while (total < size) {
+		int bytes = min(size - total, QNX4_BLOCK_SIZE);
+
 		if ((bh = sb_bread(sb, start + offset)) == NULL) {
 			printk(KERN_ERR "qnx4: I/O error in counting free blocks\n");
 			break;
 		}
-		count_bits(bh->b_data, size - total, &total_free);
+		total_free += bytes * BITS_PER_BYTE -
+				memweight(bh->b_data, bytes);
 		brelse(bh);
-		total += QNX4_BLOCK_SIZE;
+		total += bytes;
 		offset++;
 	}
 
_
Subject: Subject: qnx4fs: use memweight()

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

