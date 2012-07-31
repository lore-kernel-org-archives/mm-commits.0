From: akpm@linux-foundation.org
Subject: [merged] ext4-use-memweight.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:51:22 -0700
Message-ID: <20120731185122.C115910007F@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323Ab2GaSvX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:51:23 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:51:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, adilger.kernel@dilger.ca, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: ext4: use memweight()
has been removed from the -mm tree.  Its filename was
     ext4-use-memweight.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 fs/ext4/bitmap.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff -puN fs/ext4/bitmap.c~ext4-use-memweight fs/ext4/bitmap.c
--- a/fs/ext4/bitmap.c~ext4-use-memweight
+++ a/fs/ext4/bitmap.c
@@ -11,16 +11,9 @@
 #include <linux/jbd2.h>
 #include "ext4.h"
 
-static const int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0};
-
 unsigned int ext4_count_free(char *bitmap, unsigned int numchars)
 {
-	unsigned int i, sum = 0;
