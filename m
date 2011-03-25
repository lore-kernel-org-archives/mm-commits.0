From: akpm@linux-foundation.org
Subject: [merged] asm-generic-rename-generic-little-endian-bitops-functions.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:23:34 -0700
Message-ID: <201103250723.p2P7NS6R025730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933648Ab1CYHXy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:23:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, arnd@arndb.de, benh@kernel.crashing.org, geert@linux-m68k.org, gerg@uclinux.org, hans-christian.egtvedt@atmel.com, paulus@samba.org, schwab@linux-m68k.org, zip


The patch titled
     asm-generic: rename generic little-endian bitops functions
has been removed from the -mm tree.  Its filename was
     asm-generic-rename-generic-little-endian-bitops-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asm-generic: rename generic little-endian bitops functions
From: Akinobu Mita <akinobu.mita@gmail.com>

As a preparation for providing little-endian bitops for all architectures,
This renames generic implementation of little-endian bitops.  (remove
"generic_" prefix and postfix "_le")

s/generic_find_next_le_bit/find_next_bit_le/
s/generic_find_next_zero_le_bit/find_next_zero_bit_le/
s/generic_find_first_zero_le_bit/find_first_zero_bit_le/
s/generic___test_and_set_le_bit/__test_and_set_bit_le/
s/generic___test_and_clear_le_bit/__test_and_clear_bit_le/
s/generic_test_le_bit/test_bit_le/
s/generic___set_le_bit/__set_bit_le/
s/generic___clear_le_bit/__clear_bit_le/
s/generic_test_and_set_le_bit/test_and_set_bit_le/
s/generic_test_and_clear_le_bit/test_and_clear_bit_le/

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/kernel/avr32_ksyms.c              |    4 +-
 arch/avr32/lib/findbit.S                     |    4 +-
 arch/m68k/include/asm/bitops_mm.h            |    8 ++--
 arch/m68k/include/asm/bitops_no.h            |    2 -
 arch/powerpc/include/asm/bitops.h            |   15 ++++-----
 include/asm-generic/bitops/ext2-non-atomic.h |   12 +++----
 include/asm-generic/bitops/le.h              |   28 ++++++++---------
 include/asm-generic/bitops/minix-le.h        |   10 +++---
 lib/find_next_bit.c                          |    9 ++---
 9 files changed, 46 insertions(+), 46 deletions(-)

diff -puN arch/avr32/kernel/avr32_ksyms.c~asm-generic-rename-generic-little-endian-bitops-functions arch/avr32/kernel/avr32_ksyms.c
--- a/arch/avr32/kernel/avr32_ksyms.c~asm-generic-rename-generic-little-endian-bitops-functions
+++ a/arch/avr32/kernel/avr32_ksyms.c
@@ -58,8 +58,8 @@ EXPORT_SYMBOL(find_first_zero_bit);
 EXPORT_SYMBOL(find_next_zero_bit);
 EXPORT_SYMBOL(find_first_bit);
 EXPORT_SYMBOL(find_next_bit);
-EXPORT_SYMBOL(generic_find_next_le_bit);
-EXPORT_SYMBOL(generic_find_next_zero_le_bit);
+EXPORT_SYMBOL(find_next_bit_le);
+EXPORT_SYMBOL(find_next_zero_bit_le);
 
 /* I/O primitives (lib/io-*.S) */
 EXPORT_SYMBOL(__raw_readsb);
diff -puN arch/avr32/lib/findbit.S~asm-generic-rename-generic-little-endian-bitops-functions arch/avr32/lib/findbit.S
--- a/arch/avr32/lib/findbit.S~asm-generic-rename-generic-little-endian-bitops-functions
+++ a/arch/avr32/lib/findbit.S
@@ -123,7 +123,7 @@ ENTRY(find_next_bit)
 	brgt	1b
 	retal	r11
 
-ENTRY(generic_find_next_le_bit)
+ENTRY(find_next_bit_le)
 	lsr	r8, r10, 5
 	sub	r9, r11, r10
 	retle	r11
@@ -153,7 +153,7 @@ ENTRY(generic_find_next_le_bit)
 	brgt	1b
 	retal	r11
 
-ENTRY(generic_find_next_zero_le_bit)
+ENTRY(find_next_zero_bit_le)
 	lsr	r8, r10, 5
 	sub	r9, r11, r10
 	retle	r11
diff -puN arch/m68k/include/asm/bitops_mm.h~asm-generic-rename-generic-little-endian-bitops-functions arch/m68k/include/asm/bitops_mm.h
--- a/arch/m68k/include/asm/bitops_mm.h~asm-generic-rename-generic-little-endian-bitops-functions
+++ a/arch/m68k/include/asm/bitops_mm.h
@@ -366,9 +366,9 @@ static inline int minix_test_bit(int nr,
 #define ext2_clear_bit(nr, addr)		__test_and_clear_bit((nr) ^ 24, (unsigned long *)(addr))
 #define ext2_clear_bit_atomic(lock, nr, addr)	test_and_clear_bit((nr) ^ 24, (unsigned long *)(addr))
 #define ext2_find_next_zero_bit(addr, size, offset) \
-	generic_find_next_zero_le_bit((unsigned long *)addr, size, offset)
+	find_next_zero_bit_le((unsigned long *)addr, size, offset)
 #define ext2_find_next_bit(addr, size, offset) \
-	generic_find_next_le_bit((unsigned long *)addr, size, offset)
+	find_next_bit_le((unsigned long *)addr, size, offset)
 
 static inline int ext2_test_bit(int nr, const void *vaddr)
 {
@@ -398,7 +398,7 @@ static inline int ext2_find_first_zero_b
 	return (p - addr) * 32 + res;
 }
 
-static inline unsigned long generic_find_next_zero_le_bit(const unsigned long *addr,
+static inline unsigned long find_next_zero_bit_le(const unsigned long *addr,
 		unsigned long size, unsigned long offset)
 {
 	const unsigned long *p = addr + (offset >> 5);
@@ -440,7 +440,7 @@ static inline int ext2_find_first_bit(co
 	return (p - addr) * 32 + res;
 }
 
-static inline unsigned long generic_find_next_le_bit(const unsigned long *addr,
+static inline unsigned long find_next_bit_le(const unsigned long *addr,
 		unsigned long size, unsigned long offset)
 {
 	const unsigned long *p = addr + (offset >> 5);
diff -puN arch/m68k/include/asm/bitops_no.h~asm-generic-rename-generic-little-endian-bitops-functions arch/m68k/include/asm/bitops_no.h
--- a/arch/m68k/include/asm/bitops_no.h~asm-generic-rename-generic-little-endian-bitops-functions
+++ a/arch/m68k/include/asm/bitops_no.h
@@ -325,7 +325,7 @@ found_middle:
 }
 
 #define ext2_find_next_bit(addr, size, off) \
-	generic_find_next_le_bit((unsigned long *)(addr), (size), (off))
+	find_next_bit_le((unsigned long *)(addr), (size), (off))
 #include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
diff -puN arch/powerpc/include/asm/bitops.h~asm-generic-rename-generic-little-endian-bitops-functions arch/powerpc/include/asm/bitops.h
--- a/arch/powerpc/include/asm/bitops.h~asm-generic-rename-generic-little-endian-bitops-functions
+++ a/arch/powerpc/include/asm/bitops.h
@@ -303,11 +303,12 @@ static __inline__ int test_le_bit(unsign
 #define __test_and_clear_le_bit(nr, addr) \
 	__test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
 
-#define find_first_zero_le_bit(addr, size) generic_find_next_zero_le_bit((addr), (size), 0)
-unsigned long generic_find_next_zero_le_bit(const unsigned long *addr,
+#define find_first_zero_bit_le(addr, size) \
+	find_next_zero_bit_le((addr), (size), 0)
+unsigned long find_next_zero_bit_le(const unsigned long *addr,
 				    unsigned long size, unsigned long offset);
 
-unsigned long generic_find_next_le_bit(const unsigned long *addr,
+unsigned long find_next_bit_le(const unsigned long *addr,
 				    unsigned long size, unsigned long offset);
 /* Bitmap functions for the ext2 filesystem */
 
@@ -324,12 +325,12 @@ unsigned long generic_find_next_le_bit(c
 #define ext2_test_bit(nr, addr)      test_le_bit((nr),(unsigned long*)addr)
 
 #define ext2_find_first_zero_bit(addr, size) \
-	find_first_zero_le_bit((unsigned long*)addr, size)
+	find_first_zero_bit_le((unsigned long*)addr, size)
 #define ext2_find_next_zero_bit(addr, size, off) \
-	generic_find_next_zero_le_bit((unsigned long*)addr, size, off)
+	find_next_zero_bit_le((unsigned long *)addr, size, off)
 
 #define ext2_find_next_bit(addr, size, off) \
-	generic_find_next_le_bit((unsigned long *)addr, size, off)
+	find_next_bit_le((unsigned long *)addr, size, off)
 /* Bitmap functions for the minix filesystem.  */
 
 #define minix_test_and_set_bit(nr,addr) \
@@ -342,7 +343,7 @@ unsigned long generic_find_next_le_bit(c
 	test_le_bit(nr, (unsigned long *)addr)
 
 #define minix_find_first_zero_bit(addr,size) \
-	find_first_zero_le_bit((unsigned long *)addr, size)
+	find_first_zero_bit_le((unsigned long *)addr, size)
 
 #include <asm-generic/bitops/sched.h>
 
diff -puN include/asm-generic/bitops/ext2-non-atomic.h~asm-generic-rename-generic-little-endian-bitops-functions include/asm-generic/bitops/ext2-non-atomic.h
--- a/include/asm-generic/bitops/ext2-non-atomic.h~asm-generic-rename-generic-little-endian-bitops-functions
+++ a/include/asm-generic/bitops/ext2-non-atomic.h
@@ -4,17 +4,17 @@
 #include <asm-generic/bitops/le.h>
 
 #define ext2_set_bit(nr,addr)	\
-	generic___test_and_set_le_bit((nr),(unsigned long *)(addr))
+	__test_and_set_bit_le((nr), (unsigned long *)(addr))
 #define ext2_clear_bit(nr,addr)	\
-	generic___test_and_clear_le_bit((nr),(unsigned long *)(addr))
+	__test_and_clear_bit_le((nr), (unsigned long *)(addr))
 
 #define ext2_test_bit(nr,addr)	\
-	generic_test_le_bit((nr),(unsigned long *)(addr))
+	test_bit_le((nr), (unsigned long *)(addr))
 #define ext2_find_first_zero_bit(addr, size) \
-	generic_find_first_zero_le_bit((unsigned long *)(addr), (size))
+	find_first_zero_bit_le((unsigned long *)(addr), (size))
 #define ext2_find_next_zero_bit(addr, size, off) \
-	generic_find_next_zero_le_bit((unsigned long *)(addr), (size), (off))
+	find_next_zero_bit_le((unsigned long *)(addr), (size), (off))
 #define ext2_find_next_bit(addr, size, off) \
-	generic_find_next_le_bit((unsigned long *)(addr), (size), (off))
+	find_next_bit_le((unsigned long *)(addr), (size), (off))
 
 #endif /* _ASM_GENERIC_BITOPS_EXT2_NON_ATOMIC_H_ */
diff -puN include/asm-generic/bitops/le.h~asm-generic-rename-generic-little-endian-bitops-functions include/asm-generic/bitops/le.h
--- a/include/asm-generic/bitops/le.h~asm-generic-rename-generic-little-endian-bitops-functions
+++ a/include/asm-generic/bitops/le.h
@@ -8,44 +8,44 @@
 
 #define BITOP_LE_SWIZZLE	0
 
-#define generic_find_next_zero_le_bit(addr, size, offset) \
+#define find_next_zero_bit_le(addr, size, offset) \
 	find_next_zero_bit(addr, size, offset)
-#define generic_find_next_le_bit(addr, size, offset) \
+#define find_next_bit_le(addr, size, offset) \
 	find_next_bit(addr, size, offset)
-#define generic_find_first_zero_le_bit(addr, size) \
+#define find_first_zero_bit_le(addr, size) \
 	find_first_zero_bit(addr, size)
 
 #elif defined(__BIG_ENDIAN)
 
 #define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
 
-extern unsigned long generic_find_next_zero_le_bit(const unsigned long *addr,
+extern unsigned long find_next_zero_bit_le(const unsigned long *addr,
 		unsigned long size, unsigned long offset);
-extern unsigned long generic_find_next_le_bit(const unsigned long *addr,
+extern unsigned long find_next_bit_le(const unsigned long *addr,
 		unsigned long size, unsigned long offset);
 
-#define generic_find_first_zero_le_bit(addr, size) \
-	generic_find_next_zero_le_bit((addr), (size), 0)
+#define find_first_zero_bit_le(addr, size) \
+	find_next_zero_bit_le((addr), (size), 0)
 
 #else
 #error "Please fix <asm/byteorder.h>"
 #endif
 
-#define generic_test_le_bit(nr, addr) \
+#define test_bit_le(nr, addr) \
 	test_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define generic___set_le_bit(nr, addr) \
+#define __set_bit_le(nr, addr) \
 	__set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define generic___clear_le_bit(nr, addr) \
+#define __clear_bit_le(nr, addr) \
 	__clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
 
-#define generic_test_and_set_le_bit(nr, addr) \
+#define test_and_set_bit_le(nr, addr) \
 	test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define generic_test_and_clear_le_bit(nr, addr) \
+#define test_and_clear_bit_le(nr, addr) \
 	test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
 
-#define generic___test_and_set_le_bit(nr, addr) \
+#define __test_and_set_bit_le(nr, addr) \
 	__test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define generic___test_and_clear_le_bit(nr, addr) \
+#define __test_and_clear_bit_le(nr, addr) \
 	__test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
 
 #endif /* _ASM_GENERIC_BITOPS_LE_H_ */
diff -puN include/asm-generic/bitops/minix-le.h~asm-generic-rename-generic-little-endian-bitops-functions include/asm-generic/bitops/minix-le.h
--- a/include/asm-generic/bitops/minix-le.h~asm-generic-rename-generic-little-endian-bitops-functions
+++ a/include/asm-generic/bitops/minix-le.h
@@ -4,14 +4,14 @@
 #include <asm-generic/bitops/le.h>
 
 #define minix_test_and_set_bit(nr,addr)	\
-	generic___test_and_set_le_bit((nr),(unsigned long *)(addr))
+	__test_and_set_bit_le((nr), (unsigned long *)(addr))
 #define minix_set_bit(nr,addr)		\
-	generic___set_le_bit((nr),(unsigned long *)(addr))
+	__set_bit_le((nr), (unsigned long *)(addr))
 #define minix_test_and_clear_bit(nr,addr) \
-	generic___test_and_clear_le_bit((nr),(unsigned long *)(addr))
+	__test_and_clear_bit_le((nr), (unsigned long *)(addr))
 #define minix_test_bit(nr,addr)		\
-	generic_test_le_bit((nr),(unsigned long *)(addr))
+	test_bit_le((nr), (unsigned long *)(addr))
 #define minix_find_first_zero_bit(addr,size) \
-	generic_find_first_zero_le_bit((unsigned long *)(addr),(size))
+	find_first_zero_bit_le((unsigned long *)(addr), (size))
 
 #endif /* _ASM_GENERIC_BITOPS_MINIX_LE_H_ */
diff -puN lib/find_next_bit.c~asm-generic-rename-generic-little-endian-bitops-functions lib/find_next_bit.c
--- a/lib/find_next_bit.c~asm-generic-rename-generic-little-endian-bitops-functions
+++ a/lib/find_next_bit.c
@@ -185,7 +185,7 @@ static inline unsigned long ext2_swab(co
 #endif
 }
 
-unsigned long generic_find_next_zero_le_bit(const unsigned long *addr, unsigned
+unsigned long find_next_zero_bit_le(const unsigned long *addr, unsigned
 		long size, unsigned long offset)
 {
 	const unsigned long *p = addr + BITOP_WORD(offset);
@@ -226,10 +226,9 @@ found_middle:
 found_middle_swap:
 	return result + ffz(ext2_swab(tmp));
 }
+EXPORT_SYMBOL(find_next_zero_bit_le);
 
-EXPORT_SYMBOL(generic_find_next_zero_le_bit);
