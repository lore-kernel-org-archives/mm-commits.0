From: akpm@linux-foundation.org
Subject: [merged] arch-add-define-for-each-of-optimized-find-bitops.patch removed from -mm tree
Date: Fri, 27 May 2011 12:59:25 -0700
Message-ID: <201105271957.p4RJvUTJ017681@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751551Ab1E0UQr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 16:16:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, arnd@arndb.de, geert@linux-m68k.org, gerg@uclinux.org, hans-christian.egtvedt@atmel.com, heiko.carstens@de.ibm.com, rmk+kernel@arm.linux.org.uk, schwidefsky@de


The patch titled
     arch: add #define for each of optimized find bitops
has been removed from the -mm tree.  Its filename was
     arch-add-define-for-each-of-optimized-find-bitops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/bitops.h     |    3 +++
 arch/avr32/include/asm/bitops.h   |   15 +++++++++++++++
 arch/m68k/include/asm/bitops_mm.h |    8 ++++++++
 arch/m68k/include/asm/bitops_no.h |    2 ++
 arch/s390/include/asm/bitops.h    |    8 ++++++++
 5 files changed, 36 insertions(+)

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
@@ -200,6 +200,7 @@ out:
 	res += ((long)p - (long)vaddr - 4) * 8;
 	return res < size ? res : size;
 }
+#define find_first_zero_bit find_first_zero_bit
 
 static inline int find_next_zero_bit(const unsigned long *vaddr, int size,
 				     int offset)
@@ -229,6 +230,7 @@ static inline int find_next_zero_bit(con
 	/* No zero yet, search remaining full bytes for a zero */
 	return offset + find_first_zero_bit(p, size - offset);
 }
+#define find_next_zero_bit find_next_zero_bit
 
 static inline int find_first_bit(const unsigned long *vaddr, unsigned size)
 {
@@ -253,6 +255,7 @@ out:
 	res += ((long)p - (long)vaddr - 4) * 8;
 	return res < size ? res : size;
 }
+#define find_first_bit find_first_bit
 
 static inline int find_next_bit(const unsigned long *vaddr, int size,
 				int offset)
@@ -282,6 +285,7 @@ static inline int find_next_bit(const un
 	/* No one yet, search remaining full bytes for a one */
 	return offset + find_first_bit(p, size - offset);
 }
+#define find_next_bit find_next_bit
 
 /*
  * ffz = Find First Zero in word. Undefined if no zero exists,
@@ -398,6 +402,7 @@ out:
 	res += (p - addr) * 32;
 	return res < size ? res : size;
 }
+#define find_first_zero_bit_le find_first_zero_bit_le
 
 static inline unsigned long find_next_zero_bit_le(const void *addr,
 		unsigned long size, unsigned long offset)
@@ -427,6 +432,7 @@ static inline unsigned long find_next_ze
 	/* No zero yet, search remaining full bytes for a zero */
 	return offset + find_first_zero_bit_le(p, size - offset);
 }
+#define find_next_zero_bit_le find_next_zero_bit_le
 
 static inline int find_first_bit_le(const void *vaddr, unsigned size)
 {
@@ -451,6 +457,7 @@ out:
 	res += (p - addr) * 32;
 	return res < size ? res : size;
 }
+#define find_first_bit_le find_first_bit_le
 
 static inline unsigned long find_next_bit_le(const void *addr,
 		unsigned long size, unsigned long offset)
@@ -480,6 +487,7 @@ static inline unsigned long find_next_bi
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
 
 static inline unsigned long find_next_bit_le(const void *addr, unsigned
 		long size, unsigned long offset)
@@ -363,6 +364,7 @@ found_middle:
 found_middle_swap:
 	return result + __ffs(__swab32(tmp));
 }
+#define find_next_bit_le find_next_bit_le
 
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

origin.patch

