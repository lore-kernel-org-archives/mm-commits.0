From: akpm@linux-foundation.org
Subject: [to-be-updated] bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh.patch removed from -mm tree
Date: Thu, 13 Jan 2011 11:44:26 -0800
Message-ID: <201101131947.p0DJl6bn028835@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757072Ab1AMTrN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 14:47:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     bitops: remove ext2 non-atomic bitops from asm/bitops.h
has been removed from the -mm tree.  Its filename was
     bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bitops: remove ext2 non-atomic bitops from asm/bitops.h
From: Akinobu Mita <akinobu.mita@gmail.com>

As the result of conversions, there are no users of ext2 non-atomic bit
operations except for ext2 file system itself.  Now we can put them into
architecture independent code in ext2 file system, and remove from
asm/bitops.h for all architectures.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/bitops.h              |    1 
 arch/arm/include/asm/bitops.h                |   12 ----------
 arch/avr32/include/asm/bitops.h              |    1 
 arch/blackfin/include/asm/bitops.h           |    1 
 arch/cris/include/asm/bitops.h               |    1 
 arch/frv/include/asm/bitops.h                |    1 
 arch/h8300/include/asm/bitops.h              |    1 
 arch/ia64/include/asm/bitops.h               |    1 
 arch/m32r/include/asm/bitops.h               |    1 
 arch/m68k/include/asm/bitops_mm.h            |   13 -----------
 arch/m68k/include/asm/bitops_no.h            |   20 -----------------
 arch/mips/include/asm/bitops.h               |    1 
 arch/mn10300/include/asm/bitops.h            |    1 
 arch/parisc/include/asm/bitops.h             |    1 
 arch/powerpc/include/asm/bitops.h            |   14 -----------
 arch/s390/include/asm/bitops.h               |   15 ------------
 arch/sh/include/asm/bitops.h                 |    1 
 arch/sparc/include/asm/bitops_32.h           |    1 
 arch/sparc/include/asm/bitops_64.h           |    1 
 arch/tile/include/asm/bitops.h               |    1 
 arch/x86/include/asm/bitops.h                |    1 
 arch/xtensa/include/asm/bitops.h             |    1 
 fs/ext2/ext2.h                               |   11 +++++++++
 include/asm-generic/bitops.h                 |    1 
 include/asm-generic/bitops/ext2-non-atomic.h |   18 ---------------
 25 files changed, 11 insertions(+), 110 deletions(-)

diff -puN arch/alpha/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh arch/alpha/include/asm/bitops.h
--- a/arch/alpha/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh
+++ a/arch/alpha/include/asm/bitops.h
@@ -455,7 +455,6 @@ sched_find_first_bit(const unsigned long
 }
 
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 
 #define ext2_set_bit_atomic(l,n,a)   test_and_set_bit(n,a)
 #define ext2_clear_bit_atomic(l,n,a) test_and_clear_bit(n,a)
diff -puN arch/arm/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh arch/arm/include/asm/bitops.h
--- a/arch/arm/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh
+++ a/arch/arm/include/asm/bitops.h
@@ -327,22 +327,10 @@ static inline int fls(int x)
  * Ext2 is defined to use little-endian byte ordering.
  * These do not need to be atomic.
  */
-#define ext2_set_bit(nr,p)			\
-		__test_and_set_le_bit(nr, (unsigned long *)(p))
 #define ext2_set_bit_atomic(lock,nr,p)          \
 		test_and_set_le_bit(nr, (unsigned long *)(p))
-#define ext2_clear_bit(nr,p)			\
-		__test_and_clear_le_bit(nr, (unsigned long *)(p))
 #define ext2_clear_bit_atomic(lock,nr,p)        \
 		test_and_clear_le_bit(nr, (unsigned long *)(p))
-#define ext2_test_bit(nr,p)			\
-		test_le_bit(nr, (unsigned long *)(p))
-#define ext2_find_first_zero_bit(p,sz)		\
-		find_first_zero_le_bit((unsigned long *)(p), sz)
-#define ext2_find_next_zero_bit(p,sz,off)	\
-		find_next_zero_le_bit((unsigned long *)(p), sz, off)
-#define ext2_find_next_bit(p, sz, off) \
-		find_next_le_bit((unsigned long *)(p), sz, off)
 
 /*
  * Minix is defined to use little-endian byte ordering.
diff -puN arch/avr32/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh arch/avr32/include/asm/bitops.h
--- a/arch/avr32/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh
+++ a/arch/avr32/include/asm/bitops.h
@@ -300,7 +300,6 @@ static inline int ffs(unsigned long word
 #include <asm-generic/bitops/lock.h>
 
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix-le.h>
 
diff -puN arch/blackfin/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh arch/blackfin/include/asm/bitops.h
--- a/arch/blackfin/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh
+++ a/arch/blackfin/include/asm/bitops.h
@@ -26,7 +26,6 @@
 #include <asm-generic/bitops/lock.h>
 
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
 
diff -puN arch/cris/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh arch/cris/include/asm/bitops.h
--- a/arch/cris/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh
+++ a/arch/cris/include/asm/bitops.h
@@ -155,7 +155,6 @@ static inline int test_and_change_bit(in
 #include <asm-generic/bitops/lock.h>
 
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 
 #define ext2_set_bit_atomic(l,n,a)   test_and_set_bit(n,a)
 #define ext2_clear_bit_atomic(l,n,a) test_and_clear_bit(n,a)
diff -puN arch/frv/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh arch/frv/include/asm/bitops.h
--- a/arch/frv/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh
+++ a/arch/frv/include/asm/bitops.h
@@ -402,7 +402,6 @@ int __ilog2_u64(u64 n)
 #include <asm-generic/bitops/lock.h>
 
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 
 #define ext2_set_bit_atomic(lock,nr,addr)	test_and_set_bit  ((nr) ^ 0x18, (addr))
 #define ext2_clear_bit_atomic(lock,nr,addr)	test_and_clear_bit((nr) ^ 0x18, (addr))
diff -puN arch/h8300/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh arch/h8300/include/asm/bitops.h
--- a/arch/h8300/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh
+++ a/arch/h8300/include/asm/bitops.h
@@ -201,7 +201,6 @@ static __inline__ unsigned long __ffs(un
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
 
diff -puN arch/ia64/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh arch/ia64/include/asm/bitops.h
--- a/arch/ia64/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh
+++ a/arch/ia64/include/asm/bitops.h
@@ -457,7 +457,6 @@ static __inline__ unsigned long __arch_h
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 
 #define ext2_set_bit_atomic(l,n,a)	test_and_set_bit(n,a)
 #define ext2_clear_bit_atomic(l,n,a)	test_and_clear_bit(n,a)
diff -puN arch/m32r/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh arch/m32r/include/asm/bitops.h
--- a/arch/m32r/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh
+++ a/arch/m32r/include/asm/bitops.h
@@ -267,7 +267,6 @@ static __inline__ int test_and_change_bi
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
 
diff -puN arch/m68k/include/asm/bitops_mm.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh arch/m68k/include/asm/bitops_mm.h
--- a/arch/m68k/include/asm/bitops_mm.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh
+++ a/arch/m68k/include/asm/bitops_mm.h
@@ -467,23 +467,10 @@ static inline unsigned long find_next_le
 
 /* Bitmap functions for the ext2 filesystem. */
 
-#define ext2_set_bit(nr, addr)	\
-	__test_and_set_le_bit(nr, (unsigned long *)(addr))
 #define ext2_set_bit_atomic(lock, nr, addr)	\
 	test_and_set_le_bit(nr, (unsigned long *)(addr))
-#define ext2_clear_bit(nr, addr)	\
-	__test_and_clear_le_bit(nr, (unsigned long *)(addr))
 #define ext2_clear_bit_atomic(lock, nr, addr)	\
 	test_and_clear_le_bit(nr, (unsigned long *)(addr))
-#define ext2_find_next_zero_bit(addr, size, offset) \
-	find_next_zero_le_bit((unsigned long *)(addr), size, offset)
-#define ext2_find_next_bit(addr, size, offset) \
-	find_next_le_bit((unsigned long *)(addr), size, offset)
-#define ext2_test_bit(nr, vaddr)	test_le_bit(nr, vaddr)
-#define ext2_find_first_zero_bit(vaddr, size)	\
-	find_first_zero_le_bit((unsigned long *)(vaddr), size)
-#define ext2_find_first_bit(vaddr, size)	\
-	find_first_le_bit((unsigned long *)(vaddr), size)
 
 #endif /* __KERNEL__ */
 
diff -puN arch/m68k/include/asm/bitops_no.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh arch/m68k/include/asm/bitops_no.h
--- a/arch/m68k/include/asm/bitops_no.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh
+++ a/arch/m68k/include/asm/bitops_no.h
@@ -332,26 +332,6 @@ found_middle:
 	return result + ffz(__swab32(tmp));
 }
 
-#define ext2_set_bit(nr, addr)	\
-	__test_and_set_le_bit(nr, addr)
-
-#define ext2_clear_bit(nr, addr)	\
-	test_and_clear_le_bit(nr, addr)
-
-#define ext2_test_bit(nr, addr)	\
-	test_le_bit(nr, addr)
-
-#define ext2_find_first_zero_bit(addr, size) \
-	find_first_zero_le_bit(addr, size)
-
-#define ext2_find_next_zero_bit(addr, size, offset)	\
-	find_next_zero_le_bit(addr, size, offset)
-
-#define ext2_find_next_bit(addr, size, off) \
-	find_next_le_bit((unsigned long *)(addr), (size), (off))
-
-#include <asm-generic/bitops/minix.h>
-
 #endif /* __KERNEL__ */
 
 #include <asm-generic/bitops/fls.h>
diff -puN arch/mips/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh arch/mips/include/asm/bitops.h
--- a/arch/mips/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh
+++ a/arch/mips/include/asm/bitops.h
@@ -677,7 +677,6 @@ static inline int ffs(int word)
 #include <asm-generic/bitops/const_hweight.h>
 
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
 
diff -puN arch/mn10300/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh arch/mn10300/include/asm/bitops.h
--- a/arch/mn10300/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh
+++ a/arch/mn10300/include/asm/bitops.h
@@ -234,7 +234,6 @@ int ffs(int x)
 	test_and_clear_bit((nr), (addr))
 
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/minix-le.h>
 
 #endif /* __KERNEL__ */
diff -puN arch/parisc/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh arch/parisc/include/asm/bitops.h
--- a/arch/parisc/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh
+++ a/arch/parisc/include/asm/bitops.h
@@ -223,7 +223,6 @@ static __inline__ int fls(int x)
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 
 /* '3' is bits per byte */
 #define LE_BYTE_ADDR ((sizeof(unsigned long) - 1) << 3)
diff -puN arch/powerpc/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh arch/powerpc/include/asm/bitops.h
--- a/arch/powerpc/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh
+++ a/arch/powerpc/include/asm/bitops.h
@@ -312,25 +312,11 @@ unsigned long find_next_le_bit(const uns
 				    unsigned long size, unsigned long offset);
 /* Bitmap functions for the ext2 filesystem */
 
-#define ext2_set_bit(nr,addr) \
-	__test_and_set_le_bit((nr), (unsigned long*)addr)
-#define ext2_clear_bit(nr, addr) \
-	__test_and_clear_le_bit((nr), (unsigned long*)addr)
-
 #define ext2_set_bit_atomic(lock, nr, addr) \
 	test_and_set_le_bit((nr), (unsigned long*)addr)
 #define ext2_clear_bit_atomic(lock, nr, addr) \
 	test_and_clear_le_bit((nr), (unsigned long*)addr)
 
-#define ext2_test_bit(nr, addr)      test_le_bit((nr),(unsigned long*)addr)
-
-#define ext2_find_first_zero_bit(addr, size) \
-	find_first_zero_le_bit((unsigned long*)addr, size)
-#define ext2_find_next_zero_bit(addr, size, off) \
-	find_next_zero_le_bit((unsigned long *)addr, size, off)
-
-#define ext2_find_next_bit(addr, size, off) \
-	find_next_le_bit((unsigned long *)addr, size, off)
 /* Bitmap functions for the minix filesystem.  */
 
 #define minix_test_and_set_bit(nr,addr) \
diff -puN arch/s390/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh arch/s390/include/asm/bitops.h
--- a/arch/s390/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh
+++ a/arch/s390/include/asm/bitops.h
@@ -837,25 +837,10 @@ static inline int find_next_le_bit(void 
 	return offset + find_first_le_bit(p, size);
 }
 
-#define ext2_set_bit(nr, addr)       \
-	__test_and_set_le_bit((nr), (unsigned long *)(addr))
 #define ext2_set_bit_atomic(lock, nr, addr)       \
 	test_and_set_le_bit((nr), (unsigned long *)(addr))
-#define ext2_clear_bit(nr, addr)     \
-	__test_and_clear_le_bit((nr), (unsigned long *)(addr))
 #define ext2_clear_bit_atomic(lock, nr, addr)     \
 	test_and_clear_le_bit((nr), (unsigned long *)(addr))
-#define ext2_test_bit(nr, addr)      \
-	test_le_bit((nr), (unsigned long *)(addr))
-
-#define ext2_find_first_zero_bit(vaddr, size)	\
-	find_first_zero_le_bit((unsigned long *)(vaddr), (size))
-#define ext2_find_next_zero_bit(vaddr, size, offset)	\
-	find_next_zero_le_bit((unsigned long *)(vaddr), (size), (offset))
-#define ext2_find_first_bit(vaddr, size)	\
-	find_first_le_bit((unsigned long *)(vaddr), (size))
-#define ext2_find_next_bit(vaddr, size, offset)	\
-	find_next_le_bit((unsigned long *)(vaddr), (size), (offset))
 
 #include <asm-generic/bitops/minix.h>
 
diff -puN arch/sh/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh arch/sh/include/asm/bitops.h
--- a/arch/sh/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh
+++ a/arch/sh/include/asm/bitops.h
@@ -95,7 +95,6 @@ static inline unsigned long ffz(unsigned
 #include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
 #include <asm-generic/bitops/fls.h>
diff -puN arch/sparc/include/asm/bitops_32.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh arch/sparc/include/asm/bitops_32.h
--- a/arch/sparc/include/asm/bitops_32.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh
+++ a/arch/sparc/include/asm/bitops_32.h
@@ -104,7 +104,6 @@ static inline void change_bit(unsigned l
 #include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
 
diff -puN arch/sparc/include/asm/bitops_64.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh arch/sparc/include/asm/bitops_64.h
--- a/arch/sparc/include/asm/bitops_64.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh
+++ a/arch/sparc/include/asm/bitops_64.h
@@ -90,7 +90,6 @@ static inline unsigned int __arch_hweigh
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 
 #define ext2_set_bit_atomic(lock,nr,addr) \
 	test_and_set_bit((nr) ^ 0x38,(unsigned long *)(addr))
diff -puN arch/tile/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh arch/tile/include/asm/bitops.h
--- a/arch/tile/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh
+++ a/arch/tile/include/asm/bitops.h
@@ -123,7 +123,6 @@ static inline unsigned long __arch_hweig
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/minix.h>
 
 #endif /* _ASM_TILE_BITOPS_H */
diff -puN arch/x86/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh arch/x86/include/asm/bitops.h
--- a/arch/x86/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh
+++ a/arch/x86/include/asm/bitops.h
@@ -457,7 +457,6 @@ static inline int fls(int x)
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 
 #define ext2_set_bit_atomic(lock, nr, addr)			\
 	test_and_set_bit((nr), (unsigned long *)(addr))
diff -puN arch/xtensa/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh arch/xtensa/include/asm/bitops.h
--- a/arch/xtensa/include/asm/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh
+++ a/arch/xtensa/include/asm/bitops.h
@@ -107,7 +107,6 @@ static inline unsigned long __fls(unsign
 #include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 
 #ifdef __XTENSA_EL__
 # define ext2_set_bit_atomic(lock,nr,addr)				\
diff -puN fs/ext2/ext2.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh fs/ext2/ext2.h
--- a/fs/ext2/ext2.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh
+++ a/fs/ext2/ext2.h
@@ -174,3 +174,14 @@ ext2_group_first_block_no(struct super_b
 	return group_no * (ext2_fsblk_t)EXT2_BLOCKS_PER_GROUP(sb) +
 		le32_to_cpu(EXT2_SB(sb)->s_es->s_first_data_block);
 }
+
+#define ext2_set_bit(nr, addr)  \
+	__test_and_set_le_bit((nr), (unsigned long *)(addr))
+#define ext2_clear_bit(nr, addr) \
+	__test_and_clear_le_bit((nr), (unsigned long *)(addr))
+#define ext2_test_bit(nr, addr) \
+	test_le_bit((nr), (unsigned long *)(addr))
+#define ext2_find_first_zero_bit(addr, size)    \
+	find_first_zero_le_bit((unsigned long *)(addr), (size))
+#define ext2_find_next_zero_bit(addr, size, off)        \
+	find_next_zero_le_bit((unsigned long *)(addr), (size), (off))
diff -puN include/asm-generic/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh include/asm-generic/bitops.h
--- a/include/asm-generic/bitops.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh
+++ a/include/asm-generic/bitops.h
@@ -39,7 +39,6 @@
 #include <asm-generic/bitops/atomic.h>
 #include <asm-generic/bitops/non-atomic.h>
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
 
diff -puN include/asm-generic/bitops/ext2-non-atomic.h~bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh /dev/null
--- a/include/asm-generic/bitops/ext2-non-atomic.h
+++ /dev/null
@@ -1,18 +0,0 @@
-#ifndef _ASM_GENERIC_BITOPS_EXT2_NON_ATOMIC_H_
-#define _ASM_GENERIC_BITOPS_EXT2_NON_ATOMIC_H_
-
-#define ext2_set_bit(nr,addr)	\
-	__test_and_set_le_bit((nr), (unsigned long *)(addr))
-#define ext2_clear_bit(nr,addr)	\
-	__test_and_clear_le_bit((nr), (unsigned long *)(addr))
-
-#define ext2_test_bit(nr,addr)	\
-	test_le_bit((nr), (unsigned long *)(addr))
-#define ext2_find_first_zero_bit(addr, size) \
-	find_first_zero_le_bit((unsigned long *)(addr), (size))
-#define ext2_find_next_zero_bit(addr, size, off) \
-	find_next_zero_le_bit((unsigned long *)(addr), (size), (off))
-#define ext2_find_next_bit(addr, size, off) \
-	find_next_le_bit((unsigned long *)(addr), (size), (off))
