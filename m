From: akpm@linux-foundation.org
Subject: [merged] arm-introduce-little-endian-bitops.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:23:50 -0700
Message-ID: <201103250723.p2P7Niwr025749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402Ab1CYHXu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:23:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, hpa@zytor.com, rmk+kernel@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     arm: introduce little-endian bitops
has been removed from the -mm tree.  Its filename was
     arm-introduce-little-endian-bitops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm: introduce little-endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>

Introduce little-endian bit operations by renaming native ext2 bit
operations.  The ext2 and minix bit operations are kept as wrapper macros
using little-endian bit operations to maintain bisectability until the
conversions are finished.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/bitops.h |   91 ++++++++++++++++++++++----------
 1 file changed, 65 insertions(+), 26 deletions(-)

diff -puN arch/arm/include/asm/bitops.h~arm-introduce-little-endian-bitops arch/arm/include/asm/bitops.h
--- a/arch/arm/include/asm/bitops.h~arm-introduce-little-endian-bitops
+++ a/arch/arm/include/asm/bitops.h
@@ -287,41 +287,80 @@ static inline int fls(int x)
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 
+static inline void __set_bit_le(int nr, void *addr)
+{
+	__set_bit(WORD_BITOFF_TO_LE(nr), addr);
+}
+
+static inline void __clear_bit_le(int nr, void *addr)
+{
+	__clear_bit(WORD_BITOFF_TO_LE(nr), addr);
+}
+
+static inline int __test_and_set_bit_le(int nr, void *addr)
+{
+	return __test_and_set_bit(WORD_BITOFF_TO_LE(nr), addr);
+}
+
+static inline int test_and_set_bit_le(int nr, void *addr)
+{
+	return test_and_set_bit(WORD_BITOFF_TO_LE(nr), addr);
+}
+
+static inline int __test_and_clear_bit_le(int nr, void *addr)
+{
+	return __test_and_clear_bit(WORD_BITOFF_TO_LE(nr), addr);
+}
+
+static inline int test_and_clear_bit_le(int nr, void *addr)
+{
+	return test_and_clear_bit(WORD_BITOFF_TO_LE(nr), addr);
+}
+
+static inline int test_bit_le(int nr, const void *addr)
+{
+	return test_bit(WORD_BITOFF_TO_LE(nr), addr);
+}
+
+static inline int find_first_zero_bit_le(const void *p, unsigned size)
+{
+	return _find_first_zero_bit_le(p, size);
+}
+
+static inline int find_next_zero_bit_le(const void *p, int size, int offset)
+{
+	return _find_next_zero_bit_le(p, size, offset);
+}
+
+static inline int find_next_bit_le(const void *p, int size, int offset)
+{
+	return _find_next_bit_le(p, size, offset);
+}
+
 /*
  * Ext2 is defined to use little-endian byte ordering.
  * These do not need to be atomic.
  */
-#define ext2_set_bit(nr,p)			\
-		__test_and_set_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
-#define ext2_set_bit_atomic(lock,nr,p)          \
-                test_and_set_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
-#define ext2_clear_bit(nr,p)			\
-		__test_and_clear_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
-#define ext2_clear_bit_atomic(lock,nr,p)        \
-                test_and_clear_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
-#define ext2_test_bit(nr,p)			\
-		test_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
-#define ext2_find_first_zero_bit(p,sz)		\
-		_find_first_zero_bit_le(p,sz)
-#define ext2_find_next_zero_bit(p,sz,off)	\
-		_find_next_zero_bit_le(p,sz,off)
-#define ext2_find_next_bit(p, sz, off) \
-		_find_next_bit_le(p, sz, off)
+#define ext2_set_bit __test_and_set_bit_le
+#define ext2_set_bit_atomic(lock, nr, p)	\
+		test_and_set_bit_le(nr, p)
+#define ext2_clear_bit __test_and_clear_bit_le
+#define ext2_clear_bit_atomic(lock, nr, p)	\
+		test_and_clear_bit_le(nr, p)
+#define ext2_test_bit test_bit_le
+#define ext2_find_first_zero_bit find_first_zero_bit_le
+#define ext2_find_next_zero_bit find_next_zero_bit_le
+#define ext2_find_next_bit find_next_bit_le
 
 /*
  * Minix is defined to use little-endian byte ordering.
  * These do not need to be atomic.
  */
-#define minix_set_bit(nr,p)			\
-		__set_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
-#define minix_test_bit(nr,p)			\
-		test_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
-#define minix_test_and_set_bit(nr,p)		\
-		__test_and_set_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
-#define minix_test_and_clear_bit(nr,p)		\
-		__test_and_clear_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
-#define minix_find_first_zero_bit(p,sz)		\
-		_find_first_zero_bit_le(p,sz)
+#define minix_set_bit __set_bit_le
+#define minix_test_bit test_bit_le
+#define minix_test_and_set_bit __test_and_set_bit_le
+#define minix_test_and_clear_bit __test_and_clear_bit_le
+#define minix_find_first_zero_bit find_first_zero_bit_le
 
 #endif /* __KERNEL__ */
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch

