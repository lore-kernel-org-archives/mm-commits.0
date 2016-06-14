From: akpm@linux-foundation.org
Subject: [merged] bitmap-bitmap_equal-memcmp-optimization.patch removed
 from -mm tree
Date: Tue, 14 Jun 2016 11:38:32 -0700
Message-ID: <57604f28.tOduY6G56MKteJDS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48688 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbcFNSid (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jun 2016 14:38:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: schwidefsky@de.ibm.com, benh@kernel.crashing.org, dahi@linux.vnet.ibm.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: bitmap: bitmap_equal() memcmp() optimization
has been removed from the -mm tree.  Its filename was
     bitmap-bitmap_equal-memcmp-optimization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


