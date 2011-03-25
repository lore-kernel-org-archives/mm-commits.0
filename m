From: akpm@linux-foundation.org
Subject: [merged] m68k-introduce-little-endian-bitops.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:23:51 -0700
Message-ID: <201103250723.p2P7Njs4025752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402Ab1CYHXw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:23:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, geert@linux-m68k.org, hpa@zytor.com, schwab@linux-m68k.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: introduce little-endian bitops
has been removed from the -mm tree.  Its filename was
     m68k-introduce-little-endian-bitops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68k: introduce little-endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>

Introduce little-endian bit operations by renaming native ext2 bit
operations and changing find_*_bit_le() to take a "void *".  The ext2 bit
operations are kept as wrapper macros using little-endian bit operations
to maintain bisectability until the conversions are finished.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/bitops_mm.h |   93 ++++++++++++++++++++--------
 1 file changed, 67 insertions(+), 26 deletions(-)

diff -puN arch/m68k/include/asm/bitops_mm.h~m68k-introduce-little-endian-bitops arch/m68k/include/asm/bitops_mm.h
--- a/arch/m68k/include/asm/bitops_mm.h~m68k-introduce-little-endian-bitops
+++ a/arch/m68k/include/asm/bitops_mm.h
@@ -359,24 +359,45 @@ static inline int minix_test_bit(int nr,
 	return (p[nr >> 4] & (1U << (nr & 15))) != 0;
 }
 
-/* Bitmap functions for the ext2 filesystem. */
+/* Bitmap functions for the little endian bitmap. */
 
-#define ext2_set_bit(nr, addr)			__test_and_set_bit((nr) ^ 24, (unsigned long *)(addr))
-#define ext2_set_bit_atomic(lock, nr, addr)	test_and_set_bit((nr) ^ 24, (unsigned long *)(addr))
-#define ext2_clear_bit(nr, addr)		__test_and_clear_bit((nr) ^ 24, (unsigned long *)(addr))
-#define ext2_clear_bit_atomic(lock, nr, addr)	test_and_clear_bit((nr) ^ 24, (unsigned long *)(addr))
-#define ext2_find_next_zero_bit(addr, size, offset) \
-	find_next_zero_bit_le((unsigned long *)addr, size, offset)
-#define ext2_find_next_bit(addr, size, offset) \
-	find_next_bit_le((unsigned long *)addr, size, offset)
+static inline void __set_bit_le(int nr, void *addr)
+{
+	__set_bit(nr ^ 24, addr);
+}
 
-static inline int ext2_test_bit(int nr, const void *vaddr)
+static inline void __clear_bit_le(int nr, void *addr)
+{
+	__clear_bit(nr ^ 24, addr);
+}
+
+static inline int __test_and_set_bit_le(int nr, void *addr)
+{
+	return __test_and_set_bit(nr ^ 24, addr);
+}
+
+static inline int test_and_set_bit_le(int nr, void *addr)
+{
+	return test_and_set_bit(nr ^ 24, addr);
+}
+
+static inline int __test_and_clear_bit_le(int nr, void *addr)
+{
+	return __test_and_clear_bit(nr ^ 24, addr);
+}
+
+static inline int test_and_clear_bit_le(int nr, void *addr)
+{
+	return test_and_clear_bit(nr ^ 24, addr);
+}
+
+static inline int test_bit_le(int nr, const void *vaddr)
 {
 	const unsigned char *p = vaddr;
 	return (p[nr >> 3] & (1U << (nr & 7))) != 0;
 }
 
-static inline int ext2_find_first_zero_bit(const void *vaddr, unsigned size)
+static inline int find_first_zero_bit_le(const void *vaddr, unsigned size)
 {
 	const unsigned long *p = vaddr, *addr = vaddr;
 	int res;
@@ -393,33 +414,36 @@ static inline int ext2_find_first_zero_b
 
 	--p;
 	for (res = 0; res < 32; res++)
-		if (!ext2_test_bit (res, p))
+		if (!test_bit_le(res, p))
 			break;
 	return (p - addr) * 32 + res;
 }
 
-static inline unsigned long find_next_zero_bit_le(const unsigned long *addr,
+static inline unsigned long find_next_zero_bit_le(const void *addr,
 		unsigned long size, unsigned long offset)
 {
-	const unsigned long *p = addr + (offset >> 5);
+	const unsigned long *p = addr;
 	int bit = offset & 31UL, res;
 
 	if (offset >= size)
 		return size;
 
+	p += offset >> 5;
+
 	if (bit) {
+		offset -= bit;
 		/* Look for zero in first longword */
 		for (res = bit; res < 32; res++)
-			if (!ext2_test_bit (res, p))
-				return (p - addr) * 32 + res;
+			if (!test_bit_le(res, p))
+				return offset + res;
 		p++;
+		offset += 32;
 	}
 	/* No zero yet, search remaining full bytes for a zero */
-	res = ext2_find_first_zero_bit (p, size - 32 * (p - addr));
-	return (p - addr) * 32 + res;
+	return offset + find_first_zero_bit_le(p, size - offset);
 }
 
-static inline int ext2_find_first_bit(const void *vaddr, unsigned size)
+static inline int find_first_bit_le(const void *vaddr, unsigned size)
 {
 	const unsigned long *p = vaddr, *addr = vaddr;
 	int res;
@@ -435,32 +459,49 @@ static inline int ext2_find_first_bit(co
 
 	--p;
 	for (res = 0; res < 32; res++)
-		if (ext2_test_bit(res, p))
+		if (test_bit_le(res, p))
 			break;
 	return (p - addr) * 32 + res;
 }
 
-static inline unsigned long find_next_bit_le(const unsigned long *addr,
+static inline unsigned long find_next_bit_le(const void *addr,
 		unsigned long size, unsigned long offset)
 {
-	const unsigned long *p = addr + (offset >> 5);
+	const unsigned long *p = addr;
 	int bit = offset & 31UL, res;
 
 	if (offset >= size)
 		return size;
 
+	p += offset >> 5;
+
 	if (bit) {
+		offset -= bit;
 		/* Look for one in first longword */
 		for (res = bit; res < 32; res++)
-			if (ext2_test_bit(res, p))
-				return (p - addr) * 32 + res;
+			if (test_bit_le(res, p))
+				return offset + res;
 		p++;
+		offset += 32;
 	}
 	/* No set bit yet, search remaining full bytes for a set bit */
-	res = ext2_find_first_bit(p, size - 32 * (p - addr));
-	return (p - addr) * 32 + res;
+	return offset + find_first_bit_le(p, size - offset);
 }
 
+/* Bitmap functions for the ext2 filesystem. */
+
+#define ext2_set_bit __test_and_set_bit_le
+#define ext2_set_bit_atomic(lock, nr, addr)	\
+	test_and_set_bit_le(nr, addr)
+#define ext2_clear_bit __test_and_clear_bit_le
+#define ext2_clear_bit_atomic(lock, nr, addr)	\
+	test_and_clear_bit_le(nr, addr)
+#define ext2_find_next_zero_bit find_next_zero_bit_le
+#define ext2_find_next_bit find_next_bit_le
+#define ext2_test_bit test_bit_le
+#define ext2_find_first_zero_bit find_first_zero_bit_le
+#define ext2_find_first_bit find_first_bit_le
+
 #endif /* __KERNEL__ */
 
 #endif /* _M68K_BITOPS_H */
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch

