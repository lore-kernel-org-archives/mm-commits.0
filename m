From: akpm@linux-foundation.org
Subject: [merged] powerpc-introduce-little-endian-bitops.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:23:46 -0700
Message-ID: <201103250723.p2P7NewJ025741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402Ab1CYHXp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:23:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, benh@kernel.crashing.org, hpa@zytor.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: introduce little-endian bitops
has been removed from the -mm tree.  Its filename was
     powerpc-introduce-little-endian-bitops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: introduce little-endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>

Introduce little-endian bit operations by renaming existing powerpc native
little-endian bit operations and changing them to take any pointer types.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/bitops.h |   65 +++++++++++++++++-----------
 1 file changed, 40 insertions(+), 25 deletions(-)

diff -puN arch/powerpc/include/asm/bitops.h~powerpc-introduce-little-endian-bitops arch/powerpc/include/asm/bitops.h
--- a/arch/powerpc/include/asm/bitops.h~powerpc-introduce-little-endian-bitops
+++ a/arch/powerpc/include/asm/bitops.h
@@ -281,27 +281,42 @@ unsigned long __arch_hweight64(__u64 w);
 
 /* Little-endian versions */
 
-static __inline__ int test_le_bit(unsigned long nr,
-				  __const__ unsigned long *addr)
+static __inline__ int test_bit_le(unsigned long nr,
+				  __const__ void *addr)
 {
 	__const__ unsigned char	*tmp = (__const__ unsigned char *) addr;
 	return (tmp[nr >> 3] >> (nr & 7)) & 1;
 }
 
-#define __set_le_bit(nr, addr) \
-	__set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define __clear_le_bit(nr, addr) \
-	__clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-
-#define test_and_set_le_bit(nr, addr) \
-	test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define test_and_clear_le_bit(nr, addr) \
-	test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-
-#define __test_and_set_le_bit(nr, addr) \
-	__test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define __test_and_clear_le_bit(nr, addr) \
-	__test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
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
+static inline int test_and_set_bit_le(int nr, void *addr)
+{
+	return test_and_set_bit(nr ^ BITOP_LE_SWIZZLE, addr);
+}
+
+static inline int test_and_clear_bit_le(int nr, void *addr)
+{
+	return test_and_clear_bit(nr ^ BITOP_LE_SWIZZLE, addr);
+}
+
+static inline int __test_and_set_bit_le(int nr, void *addr)
+{
+	return __test_and_set_bit(nr ^ BITOP_LE_SWIZZLE, addr);
+}
+
+static inline int __test_and_clear_bit_le(int nr, void *addr)
+{
+	return __test_and_clear_bit(nr ^ BITOP_LE_SWIZZLE, addr);
+}
 
 #define find_first_zero_bit_le(addr, size) \
 	find_next_zero_bit_le((addr), (size), 0)
@@ -313,16 +328,16 @@ unsigned long find_next_bit_le(const voi
 /* Bitmap functions for the ext2 filesystem */
 
 #define ext2_set_bit(nr,addr) \
-	__test_and_set_le_bit((nr), (unsigned long*)addr)
+	__test_and_set_bit_le((nr), (unsigned long*)addr)
 #define ext2_clear_bit(nr, addr) \
-	__test_and_clear_le_bit((nr), (unsigned long*)addr)
+	__test_and_clear_bit_le((nr), (unsigned long*)addr)
 
 #define ext2_set_bit_atomic(lock, nr, addr) \
-	test_and_set_le_bit((nr), (unsigned long*)addr)
+	test_and_set_bit_le((nr), (unsigned long*)addr)
 #define ext2_clear_bit_atomic(lock, nr, addr) \
-	test_and_clear_le_bit((nr), (unsigned long*)addr)
+	test_and_clear_bit_le((nr), (unsigned long*)addr)
 
-#define ext2_test_bit(nr, addr)      test_le_bit((nr),(unsigned long*)addr)
+#define ext2_test_bit(nr, addr)      test_bit_le((nr),(unsigned long*)addr)
 
 #define ext2_find_first_zero_bit(addr, size) \
 	find_first_zero_bit_le((unsigned long*)addr, size)
@@ -334,13 +349,13 @@ unsigned long find_next_bit_le(const voi
 /* Bitmap functions for the minix filesystem.  */
 
 #define minix_test_and_set_bit(nr,addr) \
-	__test_and_set_le_bit(nr, (unsigned long *)addr)
+	__test_and_set_bit_le(nr, (unsigned long *)addr)
 #define minix_set_bit(nr,addr) \
-	__set_le_bit(nr, (unsigned long *)addr)
+	__set_bit_le(nr, (unsigned long *)addr)
 #define minix_test_and_clear_bit(nr,addr) \
-	__test_and_clear_le_bit(nr, (unsigned long *)addr)
+	__test_and_clear_bit_le(nr, (unsigned long *)addr)
 #define minix_test_bit(nr,addr) \
-	test_le_bit(nr, (unsigned long *)addr)
+	test_bit_le(nr, (unsigned long *)addr)
 
 #define minix_find_first_zero_bit(addr,size) \
 	find_first_zero_bit_le((unsigned long *)addr, size)
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch

