From: akpm@linux-foundation.org
Subject: [merged] md-use-proper-little-endian-bitops.patch removed from -mm tree
Date: Wed, 29 Jun 2011 12:13:06 -0700
Message-ID: <201106291912.p5TJClqD005875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752277Ab1F2TMx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jun 2011 15:12:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: use proper little-endian bitops
has been removed from the -mm tree.  Its filename was
     md-use-proper-little-endian-bitops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: use proper little-endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>

Using __test_and_{set,clear}_bit_le() with ignoring its return value can
be replaced with __{set,clear}_bit_le().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: NeilBrown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bitmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/md/bitmap.c~md-use-proper-little-endian-bitops drivers/md/bitmap.c
--- a/drivers/md/bitmap.c~md-use-proper-little-endian-bitops
+++ a/drivers/md/bitmap.c
@@ -932,7 +932,7 @@ static void bitmap_file_set_bit(struct b
 		if (bitmap->flags & BITMAP_HOSTENDIAN)
 			set_bit(bit, kaddr);
 		else
-			__test_and_set_bit_le(bit, kaddr);
+			__set_bit_le(bit, kaddr);
 		kunmap_atomic(kaddr, KM_USER0);
 		PRINTK("set file bit %lu page %lu\n", bit, page->index);
 	}
@@ -1304,7 +1304,7 @@ void bitmap_daemon_work(mddev_t *mddev)
 						clear_bit(file_page_offset(bitmap, j),
 							  paddr);
 					else
-						__test_and_clear_bit_le(file_page_offset(bitmap, j),
+						__clear_bit_le(file_page_offset(bitmap, j),
 							       paddr);
 					kunmap_atomic(paddr, KM_USER0);
 				} else
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch
reiserfs-use-proper-little-endian-bitops.patch
reiserfs-use-hweight_long.patch
asm-generic-add-another-generic-ext2-atomic-bitops.patch

