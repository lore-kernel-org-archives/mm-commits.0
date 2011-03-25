From: akpm@linux-foundation.org
Subject: [merged] m68knommu-introduce-little-endian-bitops.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:23:54 -0700
Message-ID: <201103250723.p2P7NmZl025758@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933822Ab1CYHX5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:23:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, arnd@arndb.de, geert@linux-m68k.org, gerg@uclinux.org, hpa@zytor.com, schwab@linux-m68k.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68knommu: introduce little-endian bitops
has been removed from the -mm tree.  Its filename was
     m68knommu-introduce-little-endian-bitops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68knommu: introduce little-endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>

Introduce little-endian bit operations by renaming native ext2 bit
operations.  The ext2 bit operations are kept as wrapper macros using
little-endian bit operations to maintain bisectability until the
conversions are finished.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/bitops_no.h |   37 ++++++++++++++++++++--------
 arch/m68knommu/Kconfig            |    4 ---
 2 files changed, 27 insertions(+), 14 deletions(-)

diff -puN arch/m68k/include/asm/bitops_no.h~m68knommu-introduce-little-endian-bitops arch/m68k/include/asm/bitops_no.h
--- a/arch/m68k/include/asm/bitops_no.h~m68knommu-introduce-little-endian-bitops
+++ a/arch/m68k/include/asm/bitops_no.h
@@ -196,7 +196,19 @@ static __inline__ int __test_bit(int nr,
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 
-static __inline__ int ext2_set_bit(int nr, volatile void * addr)
+#define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
+
+static inline void __set_bit_le(int nr, void *addr)
+{
+	__set_bit(nr ^ BITOP_LE_SWIZZLE, addr);
+}
+
+static inline void __clear_bit_le(int nr, void *addr)
+{
+	__clear_bit(nr ^ BITOP_LE_SWIZZLE, addr);
+}
+
+static inline int __test_and_set_bit_le(int nr, volatile void *addr)
 {
 	char retval;
 
@@ -215,7 +227,7 @@ static __inline__ int ext2_set_bit(int n
 	return retval;
 }
 
-static __inline__ int ext2_clear_bit(int nr, volatile void * addr)
+static inline int __test_and_clear_bit_le(int nr, volatile void *addr)
 {
 	char retval;
 
@@ -238,7 +250,7 @@ static __inline__ int ext2_clear_bit(int
 	({						\
 		int ret;				\
 		spin_lock(lock);			\
-		ret = ext2_set_bit((nr), (addr));	\
+		ret = __test_and_set_bit_le((nr), (addr));	\
 		spin_unlock(lock);			\
 		ret;					\
 	})
@@ -247,12 +259,12 @@ static __inline__ int ext2_clear_bit(int
 	({						\
 		int ret;				\
 		spin_lock(lock);			\
-		ret = ext2_clear_bit((nr), (addr));	\
+		ret = __test_and_clear_bit_le((nr), (addr));	\
 		spin_unlock(lock);			\
 		ret;					\
 	})
 
-static __inline__ int ext2_test_bit(int nr, const volatile void * addr)
+static inline int test_bit_le(int nr, const volatile void *addr)
 {
 	char retval;
 
@@ -271,10 +283,10 @@ static __inline__ int ext2_test_bit(int 
 	return retval;
 }
 
-#define ext2_find_first_zero_bit(addr, size) \
-        ext2_find_next_zero_bit((addr), (size), 0)
+#define find_first_zero_bit_le(addr, size)	\
+	find_next_zero_bit_le((addr), (size), 0)
 
-static __inline__ unsigned long ext2_find_next_zero_bit(void *addr, unsigned long size, unsigned long offset)
+static inline unsigned long find_next_zero_bit_le(void *addr, unsigned long size, unsigned long offset)
 {
 	unsigned long *p = ((unsigned long *) addr) + (offset >> 5);
 	unsigned long result = offset & ~31UL;
@@ -324,8 +336,13 @@ found_middle:
 	return result + ffz(__swab32(tmp));
 }
 
-#define ext2_find_next_bit(addr, size, off) \
-	find_next_bit_le((unsigned long *)(addr), (size), (off))
+#define ext2_set_bit __test_and_set_bit_le
+#define ext2_clear_bit __test_and_clear_bit_le
+#define ext2_test_bit test_bit_le
+#define ext2_find_first_zero_bit find_first_zero_bit_le
+#define ext2_find_next_zero_bit find_next_zero_bit_le
+#define ext2_find_next_bit find_next_bit_le
+
 #include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
diff -puN arch/m68knommu/Kconfig~m68knommu-introduce-little-endian-bitops arch/m68knommu/Kconfig
--- a/arch/m68knommu/Kconfig~m68knommu-introduce-little-endian-bitops
+++ a/arch/m68knommu/Kconfig
@@ -42,10 +42,6 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
-config GENERIC_FIND_BIT_LE
-	bool
-	default y
