From: akpm@linux-foundation.org
Subject: [merged] bitmap-bitmap_equal-memcmp-optimization-fix.patch
 removed from -mm tree
Date: Thu, 04 Aug 2016 13:03:22 -0700
Message-ID: <57a39f8a.fyEXTWkkjJIh4DQ4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934140AbcHDUDX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Aug 2016 16:03:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dahi@linux.vnet.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/bitmap.h: cleanup
has been removed from the -mm tree.  Its filename was
     bitmap-bitmap_equal-memcmp-optimization-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/bitmap.h: cleanup

Remove two unneeded `else's.

Cc: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN include/linux/bitmap.h~bitmap-bitmap_equal-memcmp-optimization-fix include/linux/bitmap.h
--- a/include/linux/bitmap.h~bitmap-bitmap_equal-memcmp-optimization-fix
+++ a/include/linux/bitmap.h
@@ -266,13 +266,12 @@ static inline int bitmap_equal(const uns
 			const unsigned long *src2, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
-		return ! ((*src1 ^ *src2) & BITMAP_LAST_WORD_MASK(nbits));
+		return !((*src1 ^ *src2) & BITMAP_LAST_WORD_MASK(nbits));
 #ifdef CONFIG_S390
-	else if (__builtin_constant_p(nbits) && (nbits % BITS_PER_LONG) == 0)
+	if (__builtin_constant_p(nbits) && (nbits % BITS_PER_LONG) == 0)
 		return !memcmp(src1, src2, nbits / 8);
 #endif
-	else
-		return __bitmap_equal(src1, src2, nbits);
+	return __bitmap_equal(src1, src2, nbits);
 }
 
 static inline int bitmap_intersects(const unsigned long *src1,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

