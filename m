From: akpm@linux-foundation.org
Subject: + m68k-introduce-little-endian-bitops.patch added to -mm tree
Date: Wed, 24 Nov 2010 14:39:37 -0800
Message-ID: <201011242239.oAOMdb3c008130@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754674Ab0KXWkW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Nov 2010 17:40:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, geert@linux-m68k.org, schwab@linux-m68k.org, zippel@linux-m68k.org


The patch titled
     m68k: introduce little-endian bitops
has been added to the -mm tree.  Its filename is
     m68k-introduce-little-endian-bitops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68k: introduce little-endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>

Introduce little-endian bit operations by renaming native ext2 bit
operations.  The ext2 bit operations are kept as wrapper macros using
little-endian bit operations to maintain bisectability until the
conversions are finished.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/bitops_mm.h |   60 +++++++++++++++++++---------
 1 file changed, 42 insertions(+), 18 deletions(-)

diff -puN arch/m68k/include/asm/bitops_mm.h~m68k-introduce-little-endian-bitops arch/m68k/include/asm/bitops_mm.h
--- a/arch/m68k/include/asm/bitops_mm.h~m68k-introduce-little-endian-bitops
+++ a/arch/m68k/include/asm/bitops_mm.h
@@ -359,24 +359,28 @@ static inline int minix_test_bit(int nr,
 	return (p[nr >> 4] & (1U << (nr & 15))) != 0;
 }
 
-/* Bitmap functions for the ext2 filesystem. */
+/* Bitmap functions for little endian. */
 
-#define ext2_set_bit(nr, addr)			__test_and_set_bit((nr) ^ 24, (unsigned long *)(addr))
-#define ext2_set_bit_atomic(lock, nr, addr)	test_and_set_bit((nr) ^ 24, (unsigned long *)(addr))
-#define ext2_clear_bit(nr, addr)		__test_and_clear_bit((nr) ^ 24, (unsigned long *)(addr))
-#define ext2_clear_bit_atomic(lock, nr, addr)	test_and_clear_bit((nr) ^ 24, (unsigned long *)(addr))
-#define ext2_find_next_zero_bit(addr, size, offset) \
-	find_next_zero_le_bit((unsigned long *)addr, size, offset)
-#define ext2_find_next_bit(addr, size, offset) \
-	find_next_le_bit((unsigned long *)addr, size, offset)
+#define __set_le_bit(nr, addr)	\
+	__set_bit((nr) ^ 24, (addr))
+#define __clear_le_bit(nr, addr)	\
+	__clear_bit((nr) ^ 24, (addr))
+#define __test_and_set_le_bit(nr, addr)	\
+	__test_and_set_bit((nr) ^ 24, (addr))
+#define test_and_set_le_bit(nr, addr)	\
+	test_and_set_bit((nr) ^ 24, (addr))
+#define __test_and_clear_le_bit(nr, addr)	\
+	__test_and_clear_bit((nr) ^ 24, (addr))
+#define test_and_clear_le_bit(nr, addr)	\
+	test_and_clear_bit((nr) ^ 24, (addr))
 
-static inline int ext2_test_bit(int nr, const void *vaddr)
+static inline int test_le_bit(int nr, const void *vaddr)
 {
 	const unsigned char *p = vaddr;
 	return (p[nr >> 3] & (1U << (nr & 7))) != 0;
 }
 
-static inline int ext2_find_first_zero_bit(const void *vaddr, unsigned size)
+static inline int find_first_zero_le_bit(const void *vaddr, unsigned size)
 {
 	const unsigned long *p = vaddr, *addr = vaddr;
 	int res;
@@ -393,7 +397,7 @@ static inline int ext2_find_first_zero_b
 
 	--p;
 	for (res = 0; res < 32; res++)
-		if (!ext2_test_bit (res, p))
+		if (!test_le_bit(res, p))
 			break;
 	return (p - addr) * 32 + res;
 }
@@ -410,16 +414,16 @@ static inline unsigned long find_next_ze
 	if (bit) {
 		/* Look for zero in first longword */
 		for (res = bit; res < 32; res++)
-			if (!ext2_test_bit (res, p))
+			if (!test_le_bit(res, p))
 				return (p - addr) * 32 + res;
 		p++;
 	}
 	/* No zero yet, search remaining full bytes for a zero */
-	res = ext2_find_first_zero_bit (p, size - 32 * (p - addr));
+	res = find_first_zero_le_bit(p, size - 32 * (p - addr));
 	return (p - addr) * 32 + res;
 }
 
-static inline int ext2_find_first_bit(const void *vaddr, unsigned size)
+static inline int find_first_le_bit(const void *vaddr, unsigned size)
 {
 	const unsigned long *p = vaddr, *addr = vaddr;
 	int res;
@@ -435,7 +439,7 @@ static inline int ext2_find_first_bit(co
 
 	--p;
 	for (res = 0; res < 32; res++)
-		if (ext2_test_bit(res, p))
+		if (test_le_bit(res, p))
 			break;
 	return (p - addr) * 32 + res;
 }
@@ -452,15 +456,35 @@ static inline unsigned long find_next_le
 	if (bit) {
 		/* Look for one in first longword */
 		for (res = bit; res < 32; res++)
-			if (ext2_test_bit(res, p))
+			if (test_le_bit(res, p))
 				return (p - addr) * 32 + res;
 		p++;
 	}
 	/* No set bit yet, search remaining full bytes for a set bit */
-	res = ext2_find_first_bit(p, size - 32 * (p - addr));
+	res = find_first_le_bit(p, size - 32 * (p - addr));
 	return (p - addr) * 32 + res;
 }
 
+/* Bitmap functions for the ext2 filesystem. */
+
+#define ext2_set_bit(nr, addr)	\
+	__test_and_set_le_bit(nr, (unsigned long *)(addr))
+#define ext2_set_bit_atomic(lock, nr, addr)	\
+	test_and_set_le_bit(nr, (unsigned long *)(addr))
+#define ext2_clear_bit(nr, addr)	\
+	__test_and_clear_le_bit(nr, (unsigned long *)(addr))
+#define ext2_clear_bit_atomic(lock, nr, addr)	\
+	test_and_clear_le_bit(nr, (unsigned long *)(addr))
+#define ext2_find_next_zero_bit(addr, size, offset) \
+	find_next_zero_le_bit((unsigned long *)(addr), size, offset)
+#define ext2_find_next_bit(addr, size, offset) \
+	find_next_le_bit((unsigned long *)(addr), size, offset)
+#define ext2_test_bit(nr, vaddr)	test_le_bit(nr, vaddr)
+#define ext2_find_first_zero_bit(vaddr, size)	\
+	find_first_zero_le_bit((unsigned long *)(vaddr), size)
+#define ext2_find_first_bit(vaddr, size)	\
+	find_first_le_bit((unsigned long *)(vaddr), size)
+
 #endif /* __KERNEL__ */
 
 #endif /* _M68K_BITOPS_H */
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

bitops-merge-little-and-big-endian-definisions-in-asm-generic-bitops-leh.patch
bitops-rename-generic-little-endian-bitops-functions.patch
s390-introduce-little-endian-bitops.patch
arm-introduce-little-endian-bitops.patch
m68k-introduce-little-endian-bitops.patch
m68knommu-introduce-little-endian-bitops.patch
bitops-introduce-little-endian-bitops-for-most-architectures.patch
rds-stop-including-asm-generic-bitops-leh.patch
kvm-stop-including-asm-generic-bitops-leh.patch
asm-generic-use-little-endian-bitops.patch
ext3-use-little-endian-bitops.patch
ext4-use-little-endian-bitops.patch
ocfs2-use-little-endian-bitops.patch
nilfs2-use-little-endian-bitops.patch
reiserfs-use-little-endian-bitops.patch
udf-use-little-endian-bitops.patch
ufs-use-little-endian-bitops.patch
md-use-little-endian-bit-operations.patch
dm-use-little-endian-bit-operations.patch
bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh.patch
m68k-remove-inline-asm-from-minix_find_first_zero_bit.patch
bitops-remove-minix-bitops-from-asm-bitopsh.patch

