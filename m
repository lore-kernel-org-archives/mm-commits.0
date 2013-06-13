From: akpm@linux-foundation.org
Subject: [merged]
 frontswap-fix-incorrect-zeroing-and-allocation-size-for-frontswap_map.patch removed from -mm tree
Date: Thu, 13 Jun 2013 11:58:10 -0700
Message-ID: <51ba1642.EgYB53uQ9PKmVzy0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37140 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646Ab3FMS6K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jun 2013 14:58:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, konrad.wilk@oracle.com, akinobu.mita@gmail.com

Subject: [merged] frontswap-fix-incorrect-zeroing-and-allocation-size-for-frontswap_map.patch removed from -mm tree
To: akinobu.mita@gmail.com,konrad.wilk@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Jun 2013 11:58:10 -0700


The patch titled
     Subject: frontswap: fix incorrect zeroing and allocation size for frontswap_map
has been removed from the -mm tree.  Its filename was
     frontswap-fix-incorrect-zeroing-and-allocation-size-for-frontswap_map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: frontswap: fix incorrect zeroing and allocation size for frontswap_map

The bitmap accessed by bitops must have enough size to hold the required
numbers of bits rounded up to a multiple of BITS_PER_LONG.  And the bitmap
must not be zeroed by memset() if the number of bits cleared is not a
multiple of BITS_PER_LONG.

This fixes incorrect zeroing and allocation size for frontswap_map.  The
incorrect zeroing part doesn't cause any problem because frontswap_map is
freed just after zeroing.  But the wrongly calculated allocation size may
cause the problem.

For 32bit systems, the allocation size of frontswap_map is about twice as
large as required size.  For 64bit systems, the allocation size is smaller
than requeired if the number of bits is not a multiple of BITS_PER_LONG.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/frontswap.c |    2 +-
 mm/swapfile.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/frontswap.c~frontswap-fix-incorrect-zeroing-and-allocation-size-for-frontswap_map mm/frontswap.c
--- a/mm/frontswap.c~frontswap-fix-incorrect-zeroing-and-allocation-size-for-frontswap_map
+++ a/mm/frontswap.c
@@ -319,7 +319,7 @@ void __frontswap_invalidate_area(unsigne
 			return;
 		frontswap_ops->invalidate_area(type);
 		atomic_set(&sis->frontswap_pages, 0);
-		memset(sis->frontswap_map, 0, sis->max / sizeof(long));
+		bitmap_zero(sis->frontswap_map, sis->max);
 	}
 	clear_bit(type, need_init);
 }
diff -puN mm/swapfile.c~frontswap-fix-incorrect-zeroing-and-allocation-size-for-frontswap_map mm/swapfile.c
--- a/mm/swapfile.c~frontswap-fix-incorrect-zeroing-and-allocation-size-for-frontswap_map
+++ a/mm/swapfile.c
@@ -2116,7 +2116,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 	}
 	/* frontswap enabled? set up bit-per-page map for frontswap */
 	if (frontswap_enabled)
-		frontswap_map = vzalloc(maxpages / sizeof(long));
+		frontswap_map = vzalloc(BITS_TO_LONGS(maxpages) * sizeof(long));
 
 	if (p->bdev) {
 		if (blk_queue_nonrot(bdev_get_queue(p->bdev))) {
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch

