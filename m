From: akpm@linux-foundation.org
Subject: + ext4-use-memweight.patch added to -mm tree
Date: Mon, 11 Jun 2012 16:17:55 -0700
Message-ID: <20120611231755.D8EE2A0137@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:42548 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752701Ab2FKXR5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2012 19:17:57 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id r15so252541lag.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 16:17:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, adilger.kernel@dilger.ca, tytso@mit.edu


The patch titled
     Subject: ext4: use memweight()
has been added to the -mm tree.  Its filename is
     ext4-use-memweight.patch

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
Subject: ext4: use memweight()

Convert ext4_count_free() to use memweight() instead of table lookup based
counting clear bits implementation.  This change only affects the code
segments enabled by EXT4FS_DEBUG.

Note that this memweight() call can't be replaced with a single
bitmap_weight() call, although the pointer to the memory area is aligned
to long-word boundary.  Because the size of the memory area may not be a
multiple of BITS_PER_LONG, then it returns wrong value on big-endian
architecture.

This also includes the following change.

- Remove unnecessary map == NULL check in ext4_count_free() which
  always takes non-null pointer as the memory area.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/bitmap.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff -puN fs/ext4/bitmap.c~ext4-use-memweight fs/ext4/bitmap.c
--- a/fs/ext4/bitmap.c~ext4-use-memweight
+++ a/fs/ext4/bitmap.c
@@ -13,18 +13,9 @@
 
 #ifdef EXT4FS_DEBUG
 
-static const int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0};
-
 unsigned int ext4_count_free(struct buffer_head *map, unsigned int numchars)
 {
-	unsigned int i, sum = 0;
-
-	if (!map)
-		return 0;
-	for (i = 0; i < numchars; i++)
-		sum += nibblemap[map->b_data[i] & 0xf] +
-			nibblemap[(map->b_data[i] >> 4) & 0xf];
-	return sum;
+	return numchars * BITS_PER_BYTE - memweight(map->b_data, numchars);
 }
 
 #endif  /*  EXT4FS_DEBUG  */
_
Subject: Subject: ext4: use memweight()

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

