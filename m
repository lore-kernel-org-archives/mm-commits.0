From: akpm@linux-foundation.org
Subject: +
 frontswap-fix-incorrect-zeroing-and-allocation-size-for-frontswap_map.patch added to -mm tree
Date: Mon, 03 Jun 2013 16:31:31 -0700
Message-ID: <51ad2753.dgkzFQqy60J77x9v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41122 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757860Ab3FCXbm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jun 2013 19:31:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, konrad.wilk@oracle.com, akinobu.mita@gmail.com

Subject: + frontswap-fix-incorrect-zeroing-and-allocation-size-for-frontswap_map.patch added to -mm tree
To: akinobu.mita@gmail.com,konrad.wilk@oracle.com
From: akpm@linux-foundation.org
Date: Mon, 03 Jun 2013 16:31:31 -0700


The patch titled
     Subject: frontswap: fix incorrect zeroing and allocation size for frontswap_map
has been added to the -mm tree.  Its filename is
     frontswap-fix-incorrect-zeroing-and-allocation-size-for-frontswap_map.patch

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
@@ -2130,7 +2130,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 	}
 	/* frontswap enabled? set up bit-per-page map for frontswap */
 	if (frontswap_enabled)
-		frontswap_map = vzalloc(maxpages / sizeof(long));
+		frontswap_map = vzalloc(BITS_TO_LONGS(maxpages) * sizeof(long));
 
 	if (p->bdev) {
 		if (blk_queue_nonrot(bdev_get_queue(p->bdev))) {
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
frontswap-fix-incorrect-zeroing-and-allocation-size-for-frontswap_map.patch

