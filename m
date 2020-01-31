From: akpm@linux-foundation.org
Subject: [merged] lib-find_bitc-join-_find_next_bit_le.patch
 removed from -mm tree
Date: Fri, 31 Jan 2020 15:20:36 -0800
Message-ID: <20200131232036.t0yk0_bEh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgAaXUh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:20:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: allison@lohutok.net, joe@perches.com, mm-commits@vger.kernel.org, tglx@linutronix.de, vilhelm.gray@gmail.com, yury.norov@gmail.com


The patch titled
     Subject: lib/find_bit.c: join _find_next_bit{_le}
has been removed from the -mm tree.  Its filename was
     lib-find_bitc-join-_find_next_bit_le.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: lib/find_bit.c: join _find_next_bit{_le}

_find_next_bit and _find_next_bit_le are very similar functions.  It's
possible to join them by adding 1 parameter and a couple of simple checks.
It's simplify maintenance and make possible to shrink the size of .text
by un-inlining the unified function (in the following patch).

Link: http://lkml.kernel.org/r/20200103202846.21616-2-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Cc: Allison Randal <allison@lohutok.net>
Cc: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: William Breathitt Gray <vilhelm.gray@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/find_bit.c |   64 +++++++++++++----------------------------------
 1 file changed, 19 insertions(+), 45 deletions(-)

--- a/lib/find_bit.c~lib-find_bitc-join-_find_next_bit_le
+++ a/lib/find_bit.c
@@ -17,9 +17,9 @@
 #include <linux/export.h>
 #include <linux/kernel.h>
 
-#if !defined(find_next_bit) || !defined(find_next_zero_bit) || \
-		!defined(find_next_and_bit)
-
+#if !defined(find_next_bit) || !defined(find_next_zero_bit) ||			\
+	!defined(find_next_bit_le) || !defined(find_next_zero_bit_le) ||	\
+	!defined(find_next_and_bit)
 /*
  * This is a common helper function for find_next_bit, find_next_zero_bit, and
  * find_next_and_bit. The differences are:
@@ -29,9 +29,9 @@
  */
 static inline unsigned long _find_next_bit(const unsigned long *addr1,
 		const unsigned long *addr2, unsigned long nbits,
-		unsigned long start, unsigned long invert)
+		unsigned long start, unsigned long invert, unsigned long le)
 {
-	unsigned long tmp;
+	unsigned long tmp, mask;
 
 	if (unlikely(start >= nbits))
 		return nbits;
@@ -42,7 +42,12 @@ static inline unsigned long _find_next_b
 	tmp ^= invert;
 
 	/* Handle 1st word. */
-	tmp &= BITMAP_FIRST_WORD_MASK(start);
+	mask = BITMAP_FIRST_WORD_MASK(start);
+	if (le)
+		mask = swab(mask);
+
+	tmp &= mask;
+
 	start = round_down(start, BITS_PER_LONG);
 
 	while (!tmp) {
@@ -56,6 +61,9 @@ static inline unsigned long _find_next_b
 		tmp ^= invert;
 	}
 
+	if (le)
+		tmp = swab(tmp);
+
 	return min(start + __ffs(tmp), nbits);
 }
 #endif
@@ -67,7 +75,7 @@ static inline unsigned long _find_next_b
 unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
 			    unsigned long offset)
 {
-	return _find_next_bit(addr, NULL, size, offset, 0UL);
+	return _find_next_bit(addr, NULL, size, offset, 0UL, 0);
 }
 EXPORT_SYMBOL(find_next_bit);
 #endif
@@ -76,7 +84,7 @@ EXPORT_SYMBOL(find_next_bit);
 unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
 				 unsigned long offset)
 {
-	return _find_next_bit(addr, NULL, size, offset, ~0UL);
+	return _find_next_bit(addr, NULL, size, offset, ~0UL, 0);
 }
 EXPORT_SYMBOL(find_next_zero_bit);
 #endif
@@ -86,7 +94,7 @@ unsigned long find_next_and_bit(const un
 		const unsigned long *addr2, unsigned long size,
 		unsigned long offset)
 {
-	return _find_next_bit(addr1, addr2, size, offset, 0UL);
+	return _find_next_bit(addr1, addr2, size, offset, 0UL, 0);
 }
 EXPORT_SYMBOL(find_next_and_bit);
 #endif
@@ -149,45 +157,11 @@ EXPORT_SYMBOL(find_last_bit);
 
 #ifdef __BIG_ENDIAN
 
-#if !defined(find_next_bit_le) || !defined(find_next_zero_bit_le)
-static inline unsigned long _find_next_bit_le(const unsigned long *addr1,
-		const unsigned long *addr2, unsigned long nbits,
-		unsigned long start, unsigned long invert)
-{
-	unsigned long tmp;
-
-	if (unlikely(start >= nbits))
-		return nbits;
-
-	tmp = addr1[start / BITS_PER_LONG];
-	if (addr2)
-		tmp &= addr2[start / BITS_PER_LONG];
-	tmp ^= invert;
-
-	/* Handle 1st word. */
-	tmp &= swab(BITMAP_FIRST_WORD_MASK(start));
-	start = round_down(start, BITS_PER_LONG);
-
-	while (!tmp) {
-		start += BITS_PER_LONG;
-		if (start >= nbits)
-			return nbits;
-
-		tmp = addr1[start / BITS_PER_LONG];
-		if (addr2)
-			tmp &= addr2[start / BITS_PER_LONG];
-		tmp ^= invert;
-	}
-
-	return min(start + __ffs(swab(tmp)), nbits);
-}
-#endif
-
 #ifndef find_next_zero_bit_le
 unsigned long find_next_zero_bit_le(const void *addr, unsigned
 		long size, unsigned long offset)
 {
-	return _find_next_bit_le(addr, NULL, size, offset, ~0UL);
+	return _find_next_bit(addr, NULL, size, offset, ~0UL, 1);
 }
 EXPORT_SYMBOL(find_next_zero_bit_le);
 #endif
@@ -196,7 +170,7 @@ EXPORT_SYMBOL(find_next_zero_bit_le);
 unsigned long find_next_bit_le(const void *addr, unsigned
 		long size, unsigned long offset)
 {
-	return _find_next_bit_le(addr, NULL, size, offset, 0UL);
+	return _find_next_bit(addr, NULL, size, offset, 0UL, 1);
 }
 EXPORT_SYMBOL(find_next_bit_le);
 #endif
_

Patches currently in -mm which might be from yury.norov@gmail.com are

lib-string-add-strnchrnul.patch
bitops-more-bits_to_-macros.patch
lib-add-test-for-bitmap_parse.patch
lib-add-test-for-bitmap_parse-fix.patch
lib-make-bitmap_parse_user-a-wrapper-on-bitmap_parse.patch
lib-rework-bitmap_parse.patch
lib-new-testcases-for-bitmap_parse_user.patch
cpumask-dont-calculate-length-of-the-input-string.patch
