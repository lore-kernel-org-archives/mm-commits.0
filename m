From: akpm@linux-foundation.org
Subject: [merged] s390-introduce-little-endian-bitops.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:23:48 -0700
Message-ID: <201103250723.p2P7NguO025746@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754729Ab1CYHXw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:23:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, arnd@arndb.de, heiko.carstens@de.ibm.com, hpa@zytor.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     s390: introduce little-endian bitops
has been removed from the -mm tree.  Its filename was
     s390-introduce-little-endian-bitops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s390: introduce little-endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>

Introduce little-endian bit operations by renaming native ext2 bit
operations.  The ext2 bit operations are kept as wrapper macros using
little-endian bit operations to maintain bisectability until the
conversions are finished.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/bitops.h |   69 +++++++++++++++++++++++--------
 1 file changed, 52 insertions(+), 17 deletions(-)

diff -puN arch/s390/include/asm/bitops.h~s390-introduce-little-endian-bitops arch/s390/include/asm/bitops.h
--- a/arch/s390/include/asm/bitops.h~s390-introduce-little-endian-bitops
+++ a/arch/s390/include/asm/bitops.h
@@ -742,18 +742,42 @@ static inline int sched_find_first_bit(u
  *    23 22 21 20 19 18 17 16 31 30 29 28 27 26 25 24
  */
 
-#define ext2_set_bit(nr, addr)       \
-	__test_and_set_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
-#define ext2_set_bit_atomic(lock, nr, addr)       \
-	test_and_set_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
-#define ext2_clear_bit(nr, addr)     \
-	__test_and_clear_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
-#define ext2_clear_bit_atomic(lock, nr, addr)     \
-	test_and_clear_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
-#define ext2_test_bit(nr, addr)      \
-	test_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
+static inline void __set_bit_le(unsigned long nr, void *addr)
+{
+	__set_bit(nr ^ (__BITOPS_WORDSIZE - 8), addr);
+}
+
+static inline void __clear_bit_le(unsigned long nr, void *addr)
+{
+	__clear_bit(nr ^ (__BITOPS_WORDSIZE - 8), addr);
+}
+
+static inline int __test_and_set_bit_le(unsigned long nr, void *addr)
+{
+	return __test_and_set_bit(nr ^ (__BITOPS_WORDSIZE - 8), addr);
+}
+
+static inline int test_and_set_bit_le(unsigned long nr, void *addr)
+{
+	return test_and_set_bit(nr ^ (__BITOPS_WORDSIZE - 8), addr);
+}
 
-static inline int ext2_find_first_zero_bit(void *vaddr, unsigned int size)
+static inline int __test_and_clear_bit_le(unsigned long nr, void *addr)
+{
+	return __test_and_clear_bit(nr ^ (__BITOPS_WORDSIZE - 8), addr);
+}
+
+static inline int test_and_clear_bit_le(unsigned long nr, void *addr)
+{
+	return test_and_clear_bit(nr ^ (__BITOPS_WORDSIZE - 8), addr);
+}
+
+static inline int test_bit_le(unsigned long nr, const void *addr)
+{
+	return test_bit(nr ^ (__BITOPS_WORDSIZE - 8), addr);
+}
+
+static inline int find_first_zero_bit_le(void *vaddr, unsigned int size)
 {
 	unsigned long bytes, bits;
 
@@ -764,7 +788,7 @@ static inline int ext2_find_first_zero_b
 	return (bits < size) ? bits : size;
 }
 
-static inline int ext2_find_next_zero_bit(void *vaddr, unsigned long size,
+static inline int find_next_zero_bit_le(void *vaddr, unsigned long size,
 					  unsigned long offset)
 {
         unsigned long *addr = vaddr, *p;
@@ -790,11 +814,10 @@ static inline int ext2_find_next_zero_bi
 		size -= __BITOPS_WORDSIZE;
 		p++;
         }
-	return offset + ext2_find_first_zero_bit(p, size);
+	return offset + find_first_zero_bit_le(p, size);
 }
 
-static inline unsigned long ext2_find_first_bit(void *vaddr,
-						unsigned long size)
+static inline unsigned long find_first_bit_le(void *vaddr, unsigned long size)
 {
 	unsigned long bytes, bits;
 
@@ -805,7 +828,7 @@ static inline unsigned long ext2_find_fi
 	return (bits < size) ? bits : size;
 }
 
-static inline int ext2_find_next_bit(void *vaddr, unsigned long size,
+static inline int find_next_bit_le(void *vaddr, unsigned long size,
 				     unsigned long offset)
 {
 	unsigned long *addr = vaddr, *p;
@@ -831,9 +854,21 @@ static inline int ext2_find_next_bit(voi
 		size -= __BITOPS_WORDSIZE;
 		p++;
 	}
-	return offset + ext2_find_first_bit(p, size);
+	return offset + find_first_bit_le(p, size);
 }
 
+#define ext2_set_bit __test_and_set_bit_le
+#define ext2_set_bit_atomic(lock, nr, addr)	\
+	test_and_set_bit_le(nr, addr)
+#define ext2_clear_bit __test_and_clear_bit_le
+#define ext2_clear_bit_atomic(lock, nr, addr)	\
+	test_and_clear_bit_le(nr, addr)
+#define ext2_test_bit test_bit_le
+#define ext2_find_first_zero_bit find_first_zero_bit_le
+#define ext2_find_next_zero_bit find_next_zero_bit_le
+#define ext2_find_first_bit find_first_bit_le
+#define ext2_find_next_bit find_next_bit_le
+
 #include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch

