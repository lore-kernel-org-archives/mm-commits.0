From: akpm@linux-foundation.org
Subject: + md-use-little-endian-bit-operations.patch added to -mm tree
Date: Wed, 24 Nov 2010 14:40:13 -0800
Message-ID: <201011242240.oAOMeDMm008199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755949Ab0KXWkq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Nov 2010 17:40:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, neilb@suse.de


The patch titled
     md: use little-endian bit operations
has been added to the -mm tree.  Its filename is
     md-use-little-endian-bit-operations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: use little-endian bit operations
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

diff -puN drivers/md/bitmap.c~md-use-little-endian-bit-operations drivers/md/bitmap.c
--- a/drivers/md/bitmap.c~md-use-little-endian-bit-operations
+++ a/drivers/md/bitmap.c
@@ -850,7 +850,7 @@ static void bitmap_file_set_bit(struct b
 		if (bitmap->flags & BITMAP_HOSTENDIAN)
 			set_bit(bit, kaddr);
 		else
-			ext2_set_bit(bit, kaddr);
+			__test_and_set_le_bit(bit, kaddr);
 		kunmap_atomic(kaddr, KM_USER0);
 		PRINTK("set file bit %lu page %lu\n", bit, page->index);
 	}
@@ -1046,7 +1046,7 @@ static int bitmap_init_from_disk(struct 
 		if (bitmap->flags & BITMAP_HOSTENDIAN)
 			b = test_bit(bit, paddr);
 		else
-			b = ext2_test_bit(bit, paddr);
+			b = test_le_bit(bit, paddr);
 		kunmap_atomic(paddr, KM_USER0);
 		if (b) {
 			/* if the disk bit is set, set the memory bit */
@@ -1222,7 +1222,7 @@ void bitmap_daemon_work(mddev_t *mddev)
 						clear_bit(file_page_offset(bitmap, j),
 							  paddr);
 					else
-						ext2_clear_bit(file_page_offset(bitmap, j),
+						__test_and_clear_le_bit(file_page_offset(bitmap, j),
 							       paddr);
 					kunmap_atomic(paddr, KM_USER0);
 				} else
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

bitops-merge-little-and-big-endian-definisions-in-asm-generic-bitops-leh.patch
bitops-rename-generic-little-endian-bitops-functions.patch
s390-introduce-little-endian-bitops.patch
arm-introduce-little-endian-bitops.patch
m68k-introduce-little-endian-bitops.patch
m68knommu-introduce-little-endian-bitops.patch
bitops-introduce-little-endian-bitops-for-most-architectures.patch
rds-stop-including-asm-generic-bitops-leh.patch
kvm-stop-including-asm-generic-bitops-leh.patch
asm-generic-use-little-endian-bitops.patch
ext3-use-little-endian-bitops.patch
ext4-use-little-endian-bitops.patch
ocfs2-use-little-endian-bitops.patch
nilfs2-use-little-endian-bitops.patch
reiserfs-use-little-endian-bitops.patch
udf-use-little-endian-bitops.patch
ufs-use-little-endian-bitops.patch
md-use-little-endian-bit-operations.patch
dm-use-little-endian-bit-operations.patch
bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh.patch
m68k-remove-inline-asm-from-minix_find_first_zero_bit.patch
bitops-remove-minix-bitops-from-asm-bitopsh.patch

