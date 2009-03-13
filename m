From: akpm@linux-foundation.org
Subject: [alternative-merged] bitmap-fix-size-test-in-bitmap_find_free_region.patch removed from -mm tree
Date: Fri, 13 Mar 2009 11:08:33 -0700
Message-ID: <200903131808.n2DI8Xc9007356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223AbZCMSKI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Mar 2009 14:10:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lg@denx.de, mm-commits@vger.kernel.org


The patch titled
     bitmap: fix size test in bitmap_find_free_region()
has been removed from the -mm tree.  Its filename was
     bitmap-fix-size-test-in-bitmap_find_free_region.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bitmap: fix size test in bitmap_find_free_region()
From: Guennadi Liakhovetski <lg@denx.de>

This loop and test in bitmap_find_free_region()

	for (pos = 0; pos < bits; pos += (1 << order))
		if (__reg_op(bitmap, pos, order, REG_OP_ISFREE))
			break;
	if (pos == bits)
		return -ENOMEM;

can only return an error (-ENOMEM) if bits is a multiple of (1 << order),
which is true only if bits is (also) a power of 2.  This is not
necessarily the case with dma_alloc_from_coherent().  A failure to
recognise too large a request leads to dma_alloc_from_coherent() accessing
beyond available memory, and writing beyond the bitmap.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/bitmap.c~bitmap-fix-size-test-in-bitmap_find_free_region lib/bitmap.c
--- a/lib/bitmap.c~bitmap-fix-size-test-in-bitmap_find_free_region
+++ a/lib/bitmap.c
@@ -953,7 +953,7 @@ int bitmap_find_free_region(unsigned lon
 	for (pos = 0; pos < bits; pos += (1 << order))
 		if (__reg_op(bitmap, pos, order, REG_OP_ISFREE))
 			break;
-	if (pos == bits)
+	if (pos + (1 << order) > bits)
 		return -ENOMEM;
 	__reg_op(bitmap, pos, order, REG_OP_ALLOC);
 	return pos;
_

Patches currently in -mm which might be from lg@denx.de are

origin.patch
bitmap-fix-size-test-in-bitmap_find_free_region.patch
linux-next.patch

