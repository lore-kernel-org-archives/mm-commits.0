From: akpm@linux-foundation.org
Subject: [to-be-updated] arch-add-define-for-each-of-optimized-find-bitops.patch removed from -mm tree
Date: Fri, 29 Apr 2011 12:58:44 -0700
Message-ID: <201104291958.p3TJwj9s012417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932601Ab1D2T7k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Apr 2011 15:59:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, arnd@arndb.de, geert@linux-m68k.org, gerg@uclinux.org, hans-christian.egtvedt@atmel.com, heiko.carstens@de.ibm.com, rmk+kernel@arm.linux.org.uk, schwidefsky@de


The patch titled
     arch: add #define for each of optimized find bitops
has been removed from the -mm tree.  Its filename was
     arch-add-define-for-each-of-optimized-find-bitops.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch: add #define for each of optimized find bitops
From: Akinobu Mita <akinobu.mita@gmail.com>

The style that we normally use in asm-generic is to test the macro itself
for existence, so in asm-generic, do:

	#ifndef find_next_zero_bit_le
	extern unsigned long find_next_zero_bit_le(const void *addr,
		unsigned long size, unsigned long offset);
	#endif

and in the architectures, write

	static inline unsigned long find_next_zero_bit_le(const void *addr,
		unsigned long size, unsigned long offset)
	#define find_next_zero_bit_le find_next_zero_bit_le

This adds the #define for each of the optimized find bitops in the
architectures.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/bitops.h     |    3 +++
 arch/avr32/include/asm/bitops.h   |   15 +++++++++++++++
 arch/m68k/include/asm/bitops_mm.h |    8 ++++++++
 arch/m68k/include/asm/bitops_no.h |    1 +
 arch/s390/include/asm/bitops.h    |    8 ++++++++
 5 files changed, 35 insertions(+)

diff -puN arch/arm/include/asm/bitops.h~arch-add-define-for-each-of-optimized-find-bitops arch/arm/include/asm/bitops.h
--- a/arch/arm/include/asm/bitops.h~arch-add-define-for-each-of-optimized-find-bitops
+++ a/arch/arm/include/asm/bitops.h
@@ -326,16 +326,19 @@ static inline int find_first_zero_bit_le
 {
 	return _find_first_zero_bit_le(p, size);
 }
+#define find_first_zero_bit_le find_first_zero_bit_le
 
 static inline int find_next_zero_bit_le(const void *p, int size, int offset)
 {
 	return _find_next_zero_bit_le(p, size, offset);
 }
+#define find_next_zero_bit_le find_next_zero_bit_le
 
 static inline int find_next_bit_le(const void *p, int size, int offset)
 {
 	return _find_next_bit_le(p, size, offset);
 }
+#define find_next_bit_le find_next_bit_le
 
 /*
  * Ext2 is defined to use little-endian byte ordering.
diff -puN arch/avr32/include/asm/bitops.h~arch-add-define-for-each-of-optimized-find-bitops arch/avr32/include/asm/bitops.h
--- a/arch/avr32/include/asm/bitops.h~arch-add-define-for-each-of-optimized-find-bitops
+++ a/arch/avr32/include/asm/bitops.h
@@ -270,14 +270,21 @@ static inline int __fls(unsigned long wo
 
 unsigned long find_first_zero_bit(const unsigned long *addr,
 				  unsigned long size);
+#define find_first_zero_bit find_first_zero_bit
+
 unsigned long find_next_zero_bit(const unsigned long *addr,
 				 unsigned long size,
 				 unsigned long offset);
+#define find_next_zero_bit find_next_zero_bit
+
 unsigned long find_first_bit(const unsigned long *addr,
 			     unsigned long size);
+#define find_first_bit find_first_bit
+
 unsigned long find_next_bit(const unsigned long *addr,
 				 unsigned long size,
 				 unsigned long offset);
+#define find_next_bit find_next_bit
 
 /*
  * ffs: find first bit set. This is defined the same way as
@@ -299,6 +306,14 @@ static inline int ffs(unsigned long word
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 
+extern unsigned long find_next_zero_bit_le(const void *addr,
+		unsigned long size, unsigned long offset);
+#define find_next_zero_bit_le find_next_zero_bit_le
+
+extern unsigned long find_next_bit_le(const void *addr,
+		unsigned long size, unsigned long offset);
+#define find_next_bit_le find_next_bit_le
+
 #include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 
diff -puN arch/m68k/include/asm/bitops_mm.h~arch-add-define-for-each-of-optimized-find-bitops arch/m68k/include/asm/bitops_mm.h
--- a/arch/m68k/include/asm/bitops_mm.h~arch-add-define-for-each-of-optimized-find-bitops
+++ a/arch/m68k/include/asm/bitops_mm.h
@@ -198,6 +198,7 @@ static inline int find_first_zero_bit(co
 out:
 	return ((long)p - (long)vaddr - 4) * 8 + res;
 }
+#define find_first_zero_bit find_first_zero_bit
 
 static inline int find_next_zero_bit(const unsigned long *vaddr, int size,
 				     int offset)
@@ -223,6 +224,7 @@ static inline int find_next_zero_bit(con
 	res = find_first_zero_bit(p, size - ((long)p - (long)vaddr) * 8);
 	return offset + res;
 }
+#define find_next_zero_bit find_next_zero_bit
 
 static inline int find_first_bit(const unsigned long *vaddr, unsigned size)
 {
@@ -245,6 +247,7 @@ static inline int find_first_bit(const u
 out:
 	return ((long)p - (long)vaddr - 4) * 8 + res;
 }
+#define find_first_bit find_first_bit
 
 static inline int find_next_bit(const unsigned long *vaddr, int size,
 				int offset)
@@ -270,6 +273,7 @@ static inline int find_next_bit(const un
 	res = find_first_bit(p, size - ((long)p - (long)vaddr) * 8);
 	return offset + res;
 }
+#define find_next_bit find_next_bit
 
 /*
  * ffz = Find First Zero in word. Undefined if no zero exists,
@@ -384,6 +388,7 @@ static inline int find_first_zero_bit_le
 			break;
 	return (p - addr) * 32 + res;
 }
+#define find_first_zero_bit_le find_first_zero_bit_le
 
 static inline unsigned long find_next_zero_bit_le(const void *addr,
 		unsigned long size, unsigned long offset)
@@ -408,6 +413,7 @@ static inline unsigned long find_next_ze
 	/* No zero yet, search remaining full bytes for a zero */
 	return offset + find_first_zero_bit_le(p, size - offset);
 }
+#define find_next_zero_bit_le find_next_zero_bit_le
 
 static inline int find_first_bit_le(const void *vaddr, unsigned size)
 {
@@ -429,6 +435,7 @@ static inline int find_first_bit_le(cons
 			break;
 	return (p - addr) * 32 + res;
 }
+#define find_first_bit_le find_first_bit_le
 
 static inline unsigned long find_next_bit_le(const void *addr,
 		unsigned long size, unsigned long offset)
@@ -453,6 +460,7 @@ static inline unsigned long find_next_bi
 	/* No set bit yet, search remaining full bytes for a set bit */
 	return offset + find_first_bit_le(p, size - offset);
 }
+#define find_next_bit_le find_next_bit_le
 
 /* Bitmap functions for the ext2 filesystem. */
 
diff -puN arch/m68k/include/asm/bitops_no.h~arch-add-define-for-each-of-optimized-find-bitops arch/m68k/include/asm/bitops_no.h
--- a/arch/m68k/include/asm/bitops_no.h~arch-add-define-for-each-of-optimized-find-bitops
+++ a/arch/m68k/include/asm/bitops_no.h
@@ -319,6 +319,7 @@ found_first:
 found_middle:
 	return result + ffz(__swab32(tmp));
 }
+#define find_next_zero_bit_le find_next_zero_bit_le
 
 #endif /* __KERNEL__ */
 
diff -puN arch/s390/include/asm/bitops.h~arch-add-define-for-each-of-optimized-find-bitops arch/s390/include/asm/bitops.h
--- a/arch/s390/include/asm/bitops.h~arch-add-define-for-each-of-optimized-find-bitops
+++ a/arch/s390/include/asm/bitops.h
@@ -621,6 +621,7 @@ static inline unsigned long find_first_z
 	bits = __ffz_word(bytes*8, __load_ulong_be(addr, bytes));
 	return (bits < size) ? bits : size;
 }
+#define find_first_zero_bit find_first_zero_bit
 
 /**
  * find_first_bit - find the first set bit in a memory region
@@ -641,6 +642,7 @@ static inline unsigned long find_first_b
 	bits = __ffs_word(bytes*8, __load_ulong_be(addr, bytes));
 	return (bits < size) ? bits : size;
 }
+#define find_first_bit find_first_bit
 
 /**
  * find_next_zero_bit - find the first zero bit in a memory region
@@ -677,6 +679,7 @@ static inline int find_next_zero_bit (co
 	}
 	return offset + find_first_zero_bit(p, size);
 }
+#define find_next_zero_bit find_next_zero_bit
 
 /**
  * find_next_bit - find the first set bit in a memory region
@@ -713,6 +716,7 @@ static inline int find_next_bit (const u
 	}
 	return offset + find_first_bit(p, size);
 }
+#define find_next_bit find_next_bit
 
 /*
  * Every architecture must define this function. It's the fastest
@@ -787,6 +791,7 @@ static inline int find_first_zero_bit_le
 	bits = __ffz_word(bytes*8, __load_ulong_le(vaddr, bytes));
 	return (bits < size) ? bits : size;
 }
+#define find_first_zero_bit_le find_first_zero_bit_le
 
 static inline int find_next_zero_bit_le(void *vaddr, unsigned long size,
 					  unsigned long offset)
@@ -816,6 +821,7 @@ static inline int find_next_zero_bit_le(
         }
 	return offset + find_first_zero_bit_le(p, size);
 }
+#define find_next_zero_bit_le find_next_zero_bit_le
 
 static inline unsigned long find_first_bit_le(void *vaddr, unsigned long size)
 {
@@ -827,6 +833,7 @@ static inline unsigned long find_first_b
 	bits = __ffs_word(bytes*8, __load_ulong_le(vaddr, bytes));
 	return (bits < size) ? bits : size;
 }
+#define find_first_bit_le find_first_bit_le
 
 static inline int find_next_bit_le(void *vaddr, unsigned long size,
 				     unsigned long offset)
@@ -856,6 +863,7 @@ static inline int find_next_bit_le(void 
 	}
 	return offset + find_first_bit_le(p, size);
 }
+#define find_next_bit_le find_next_bit_le
 
 #define ext2_set_bit_atomic(lock, nr, addr)	\
 	test_and_set_bit_le(nr, addr)
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
bitops-add-ifndef-for-each-of-find-bitops.patch
arch-remove-config_generic_find_next_bitbit_lelast_bit.patch
arm-use-asm-generic-bitops-leh.patch
s390-use-asm-generic-bitops-leh.patch
m68knommu-fix-build-error-due-to-the-lack-of-find_next_bit_le.patch

