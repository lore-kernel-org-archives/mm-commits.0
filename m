From: akpm@linux-foundation.org
Subject: [merged]
 bitops-avoid-integer-overflow-in-genmask_ull.patch removed from -mm tree
Date: Mon, 11 Sep 2017 12:41:25 -0700
Message-ID: <20170911194125.SE5MrM935%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49926 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751027AbdIKTl0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:41:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mka@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: bitops: avoid integer overflow in GENMASK(_ULL)
has been removed from the -mm tree.  Its filename was
     bitops-avoid-integer-overflow-in-genmask_ull.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthias Kaehlcke <mka@chromium.org>
Subject: bitops: avoid integer overflow in GENMASK(_ULL)

GENMASK(_ULL) performs a left-shift of ~0UL(L), which technically results
in an integer overflow.  clang raises a warning if the overflow occurs in
a preprocessor expression.  Clear the low-order bits through a
substraction instead of the left-shift to avoid the overflow.

(akpm: no change in .text size in my testing)

Link: http://lkml.kernel.org/r/20170803212020.24939-1-mka@chromium.org
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitops.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/bitops.h~bitops-avoid-integer-overflow-in-genmask_ull include/linux/bitops.h
--- a/include/linux/bitops.h~bitops-avoid-integer-overflow-in-genmask_ull
+++ a/include/linux/bitops.h
@@ -19,10 +19,11 @@
  * GENMASK_ULL(39, 21) gives us the 64bit vector 0x000000ffffe00000.
  */
 #define GENMASK(h, l) \
-	(((~0UL) << (l)) & (~0UL >> (BITS_PER_LONG - 1 - (h))))
+	(((~0UL) - (1UL << (l)) + 1) & (~0UL >> (BITS_PER_LONG - 1 - (h))))
 
 #define GENMASK_ULL(h, l) \
-	(((~0ULL) << (l)) & (~0ULL >> (BITS_PER_LONG_LONG - 1 - (h))))
+	(((~0ULL) - (1ULL << (l)) + 1) & \
+	 (~0ULL >> (BITS_PER_LONG_LONG - 1 - (h))))
 
 extern unsigned int __sw_hweight8(unsigned int w);
 extern unsigned int __sw_hweight16(unsigned int w);
_

Patches currently in -mm which might be from mka@chromium.org are


