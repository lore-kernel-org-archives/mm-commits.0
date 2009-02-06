From: akpm@linux-foundation.org
Subject: + bitmap-fix-size-test-in-bitmap_find_free_region.patch added to -mm tree
Date: Fri, 06 Feb 2009 13:31:37 -0800
Message-ID: <200902062131.n16LVbw3003233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752163AbZBFVbl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 16:31:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lg@denx.de


The patch titled
     bitmap: fix size test in bitmap_find_free_region()
has been added to the -mm tree.  Its filename is
     bitmap-fix-size-test-in-bitmap_find_free_region.patch

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

linux-next.patch
bitmap-fix-size-test-in-bitmap_find_free_region.patch

