From: akpm@linux-foundation.org
Subject: + bitmap-bitmap_equal-memcmp-optimization.patch added to -mm tree
Date: Wed, 08 Jun 2016 13:42:22 -0700
Message-ID: <5758832e.NnBn9eFlKaqB9spj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35981 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423655AbcFHUm2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2016 16:42:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: schwidefsky@de.ibm.com, benh@kernel.crashing.org, dahi@linux.vnet.ibm.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: bitmap: bitmap_equal() memcmp() optimization
has been added to the -mm tree.  Its filename is
     bitmap-bitmap_equal-memcmp-optimization.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bitmap-bitmap_equal-memcmp-optimization.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bitmap-bitmap_equal-memcmp-optimization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: bitmap: bitmap_equal() memcmp() optimization

bitmap_equal*( has optimized code for small bitmaps with less than
BITS_PER_LONG bits.  For larger bitmaps the out-of-line function
__bitmap_equal is called.

For a constant number of bits divisible by BITS_PER_LONG the memcmp
function can be used.  For s390 gcc knows how to optimize this function,
memcmp calls with up to 256 bytes / 2048 bits are translated into a single
instruction.

Link: http://lkml.kernel.org/r/201606070837.u578YJKt047781@mx0a-001b2d01.pphosted.com
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/linux/bitmap.h~bitmap-bitmap_equal-memcmp-optimization include/linux/bitmap.h
--- a/include/linux/bitmap.h~bitmap-bitmap_equal-memcmp-optimization
+++ a/include/linux/bitmap.h
@@ -267,6 +267,10 @@ static inline int bitmap_equal(const uns
 {
 	if (small_const_nbits(nbits))
 		return ! ((*src1 ^ *src2) & BITMAP_LAST_WORD_MASK(nbits));
+#ifdef CONFIG_S390
+	else if (__builtin_constant_p(nbits) && (nbits % BITS_PER_LONG) == 0)
+		return !memcmp(src1, src2, nbits / 8);
+#endif
 	else
 		return __bitmap_equal(src1, src2, nbits);
 }
_

Patches currently in -mm which might be from schwidefsky@de.ibm.com are

bitmap-bitmap_equal-memcmp-optimization.patch

