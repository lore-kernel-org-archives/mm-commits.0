From: akpm@linux-foundation.org
Subject: [merged] md-use-little-endian-bitops.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:24:14 -0700
Message-ID: <201103250724.p2P7O8B3025818@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933837Ab1CYHYM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:24:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: use little-endian bitops
has been removed from the -mm tree.  Its filename was
     md-use-little-endian-bitops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: use little-endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h.  This converts ext2 non-atomic bit operations to
little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: NeilBrown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bitmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/md/bitmap.c~md-use-little-endian-bitops drivers/md/bitmap.c
--- a/drivers/md/bitmap.c~md-use-little-endian-bitops
+++ a/drivers/md/bitmap.c
@@ -854,7 +854,7 @@ static void bitmap_file_set_bit(struct b
 		if (bitmap->flags & BITMAP_HOSTENDIAN)
 			set_bit(bit, kaddr);
 		else
-			ext2_set_bit(bit, kaddr);
+			__test_and_set_bit_le(bit, kaddr);
 		kunmap_atomic(kaddr, KM_USER0);
 		PRINTK("set file bit %lu page %lu\n", bit, page->index);
 	}
@@ -1050,7 +1050,7 @@ static int bitmap_init_from_disk(struct 
 		if (bitmap->flags & BITMAP_HOSTENDIAN)
 			b = test_bit(bit, paddr);
 		else
-			b = ext2_test_bit(bit, paddr);
+			b = test_bit_le(bit, paddr);
 		kunmap_atomic(paddr, KM_USER0);
 		if (b) {
 			/* if the disk bit is set, set the memory bit */
@@ -1226,7 +1226,7 @@ void bitmap_daemon_work(mddev_t *mddev)
 						clear_bit(file_page_offset(bitmap, j),
 							  paddr);
 					else
-						ext2_clear_bit(file_page_offset(bitmap, j),
+						__test_and_clear_bit_le(file_page_offset(bitmap, j),
 							       paddr);
 					kunmap_atomic(paddr, KM_USER0);
 				} else
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch

