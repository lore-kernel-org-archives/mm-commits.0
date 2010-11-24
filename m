From: akpm@linux-foundation.org
Subject: + bitops-remove-minix-bitops-from-asm-bitopsh.patch added to -mm tree
Date: Wed, 24 Nov 2010 14:40:23 -0800
Message-ID: <201011242240.oAOMeNXk008211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751691Ab0KXWut (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Nov 2010 17:50:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, arnd@arndb.de, chris@zankel.net, davem@davemloft.net, geert@linux-m68k.org, gerg@uclinux.org, heiko.carstens@de.ibm.com, lethal@linux-sh.org, monstr@monstr.eu, ralf@linux-mips.org, schwab@linux-m68k.org, schwidefsky@de.ibm.com, takata@linux-m32r.org, ysato@users.sourceforge.jp, zippel@linux-m68k.org


The patch titled
     bitops: remove minix bitops from asm/bitops.h
has been added to the -mm tree.  Its filename is
     bitops-remove-minix-bitops-from-asm-bitopsh.patch

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
Subject: bitops: remove minix bitops from asm/bitops.h
From: Akinobu Mita <akinobu.mita@gmail.com>

minix bit operations are only used by minix filesystem and useless by
other modules.  Because byte order of inode and block bitmaps is defferent
on each architecture like below:

m68k:
	big-endian 16bit indexed bitmaps

h8300, microblaze, s390, sparc, m68knommu:
	big-endian 32 or 64bit indexed bitmaps

m32r, mips, sh, xtensa:
	big-endian 32 or 64bit indexed bitmaps for big-endian mode
	little-endian bitmaps for little-endian mode

Others:
	little-endian bitmaps

In order to move minix bit operations from asm/bitops.h to architecture
independent code in minix file system, this provides two config options.

CONFIG_MINIX_FS_BIG_ENDIAN_16BIT_INDEXED is only selected by m68k. 
CONFIG_MINIX_FS_NATIVE_ENDIAN is selected by the architectures which use
native byte order bitmaps (h8300, microblaze, s390, sparc, m68knommu,
m32r, mips, sh, xtensa).  The architectures which always use little-endian
bitmaps do not select these options.

Finally, we can remove minix bit operations from asm/bitops.h for all
architectures.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Michal Simek <monstr@monstr.eu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/bitops.h       |    2 
 arch/arm/include/asm/bitops.h         |   14 ----
 arch/avr32/include/asm/bitops.h       |    1 
 arch/blackfin/include/asm/bitops.h    |    1 
 arch/cris/include/asm/bitops.h        |    1 
 arch/frv/include/asm/bitops.h         |    2 
 arch/h8300/include/asm/bitops.h       |    1 
 arch/ia64/include/asm/bitops.h        |    1 
 arch/m32r/include/asm/bitops.h        |    1 
 arch/m68k/include/asm/bitops_mm.h     |   30 ---------
 arch/mips/include/asm/bitops.h        |    1 
 arch/mn10300/include/asm/bitops.h     |    1 
 arch/parisc/include/asm/bitops.h      |    2 
 arch/powerpc/include/asm/bitops.h     |   14 ----
 arch/s390/include/asm/bitops.h        |    1 
 arch/sh/include/asm/bitops.h          |    1 
 arch/sparc/include/asm/bitops_32.h    |    1 
 arch/sparc/include/asm/bitops_64.h    |    2 
 arch/tile/include/asm/bitops.h        |    1 
 arch/x86/include/asm/bitops.h         |    2 
 arch/xtensa/include/asm/bitops.h      |    1 
 fs/minix/Kconfig                      |    8 ++
 fs/minix/minix.h                      |   79 ++++++++++++++++++++++++
 include/asm-generic/bitops.h          |    1 
 include/asm-generic/bitops/minix-le.h |   15 ----
 include/asm-generic/bitops/minix.h    |   15 ----
 26 files changed, 87 insertions(+), 112 deletions(-)

diff -puN arch/alpha/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh arch/alpha/include/asm/bitops.h
--- a/arch/alpha/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh
+++ a/arch/alpha/include/asm/bitops.h
@@ -459,8 +459,6 @@ sched_find_first_bit(const unsigned long
 #define ext2_set_bit_atomic(l,n,a)   test_and_set_bit(n,a)
 #define ext2_clear_bit_atomic(l,n,a) test_and_clear_bit(n,a)
 
-#include <asm-generic/bitops/minix.h>
-
 #endif /* __KERNEL__ */
 
 #endif /* _ALPHA_BITOPS_H */
diff -puN arch/arm/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh arch/arm/include/asm/bitops.h
--- a/arch/arm/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh
+++ a/arch/arm/include/asm/bitops.h
@@ -332,20 +332,6 @@ static inline int fls(int x)
 #define ext2_clear_bit_atomic(lock,nr,p)        \
 		test_and_clear_le_bit(nr, (unsigned long *)(p))
 
-/*
- * Minix is defined to use little-endian byte ordering.
- * These do not need to be atomic.
- */
-#define minix_set_bit(nr,p)			\
-		__set_le_bit(nr, (unsigned long *)(p))
-#define minix_test_bit(nr,p)			\
-		test_le_bit(nr, (unsigned long *)(p))
-#define minix_test_and_set_bit(nr,p)		\
-		__test_and_set_le_bit(nr, (unsigned long *)(p))
-#define minix_test_and_clear_bit(nr,p)		\
-		__test_and_clear_le_bit(nr, (unsigned long *)(p))
-#define minix_find_first_zero_bit(p,sz)		\
-		find_first_zero_le_bit((unsigned long *)(p), sz)
 
 #endif /* __KERNEL__ */
 
diff -puN arch/avr32/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh arch/avr32/include/asm/bitops.h
--- a/arch/avr32/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh
+++ a/arch/avr32/include/asm/bitops.h
@@ -301,6 +301,5 @@ static inline int ffs(unsigned long word
 
 #include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-atomic.h>
-#include <asm-generic/bitops/minix-le.h>
 
 #endif /* __ASM_AVR32_BITOPS_H */
diff -puN arch/blackfin/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh arch/blackfin/include/asm/bitops.h
--- a/arch/blackfin/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh
+++ a/arch/blackfin/include/asm/bitops.h
@@ -27,7 +27,6 @@
 
 #include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-atomic.h>
-#include <asm-generic/bitops/minix.h>
 
 #ifndef CONFIG_SMP
 #include <linux/irqflags.h>
diff -puN arch/cris/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh arch/cris/include/asm/bitops.h
--- a/arch/cris/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh
+++ a/arch/cris/include/asm/bitops.h
@@ -159,7 +159,6 @@ static inline int test_and_change_bit(in
 #define ext2_set_bit_atomic(l,n,a)   test_and_set_bit(n,a)
 #define ext2_clear_bit_atomic(l,n,a) test_and_clear_bit(n,a)
 
-#include <asm-generic/bitops/minix.h>
 #include <asm-generic/bitops/sched.h>
 
 #endif /* __KERNEL__ */
diff -puN arch/frv/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh arch/frv/include/asm/bitops.h
--- a/arch/frv/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh
+++ a/arch/frv/include/asm/bitops.h
@@ -406,8 +406,6 @@ int __ilog2_u64(u64 n)
 #define ext2_set_bit_atomic(lock,nr,addr)	test_and_set_bit  ((nr) ^ 0x18, (addr))
 #define ext2_clear_bit_atomic(lock,nr,addr)	test_and_clear_bit((nr) ^ 0x18, (addr))
 
-#include <asm-generic/bitops/minix-le.h>
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_BITOPS_H */
diff -puN arch/h8300/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh arch/h8300/include/asm/bitops.h
--- a/arch/h8300/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh
+++ a/arch/h8300/include/asm/bitops.h
@@ -202,7 +202,6 @@ static __inline__ unsigned long __ffs(un
 #include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-atomic.h>
-#include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
 
diff -puN arch/ia64/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh arch/ia64/include/asm/bitops.h
--- a/arch/ia64/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh
+++ a/arch/ia64/include/asm/bitops.h
@@ -461,7 +461,6 @@ static __inline__ unsigned long __arch_h
 #define ext2_set_bit_atomic(l,n,a)	test_and_set_bit(n,a)
 #define ext2_clear_bit_atomic(l,n,a)	test_and_clear_bit(n,a)
 
-#include <asm-generic/bitops/minix.h>
 #include <asm-generic/bitops/sched.h>
 
 #endif /* __KERNEL__ */
diff -puN arch/m32r/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh arch/m32r/include/asm/bitops.h
--- a/arch/m32r/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh
+++ a/arch/m32r/include/asm/bitops.h
@@ -268,7 +268,6 @@ static __inline__ int test_and_change_bi
 
 #include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-atomic.h>
-#include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
 
diff -puN arch/m68k/include/asm/bitops_mm.h~bitops-remove-minix-bitops-from-asm-bitopsh arch/m68k/include/asm/bitops_mm.h
--- a/arch/m68k/include/asm/bitops_mm.h~bitops-remove-minix-bitops-from-asm-bitopsh
+++ a/arch/m68k/include/asm/bitops_mm.h
@@ -325,36 +325,6 @@ static inline int __fls(int x)
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 
-/* Bitmap functions for the minix filesystem */
-
-static inline int minix_find_first_zero_bit(const void *vaddr, unsigned size)
-{
-	const unsigned short *p = vaddr, *addr = vaddr;
-	unsigned short num;
-
-	if (!size)
-		return 0;
-
-	size = (size >> 4) + ((size & 15) > 0);
-	while (*p++ == 0xffff) {
-		if (--size == 0)
-			return (p - addr) << 4;
-	}
-
-	num = *--p;
-	return ((p - addr) << 4) + ffz(num);
-}
-
-#define minix_test_and_set_bit(nr, addr)	__test_and_set_bit((nr) ^ 16, (unsigned long *)(addr))
-#define minix_set_bit(nr,addr)			__set_bit((nr) ^ 16, (unsigned long *)(addr))
-#define minix_test_and_clear_bit(nr, addr)	__test_and_clear_bit((nr) ^ 16, (unsigned long *)(addr))
-
-static inline int minix_test_bit(int nr, const void *vaddr)
-{
-	const unsigned short *p = vaddr;
-	return (p[nr >> 4] & (1U << (nr & 15))) != 0;
-}
-
 /* Bitmap functions for little endian. */
 
 #define __set_le_bit(nr, addr)	\
diff -puN arch/mips/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh arch/mips/include/asm/bitops.h
--- a/arch/mips/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh
+++ a/arch/mips/include/asm/bitops.h
@@ -678,7 +678,6 @@ static inline int ffs(int word)
 
 #include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-atomic.h>
-#include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
 
diff -puN arch/mn10300/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh arch/mn10300/include/asm/bitops.h
--- a/arch/mn10300/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh
+++ a/arch/mn10300/include/asm/bitops.h
@@ -234,7 +234,6 @@ int ffs(int x)
 	test_and_clear_bit((nr), (addr))
 
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/minix-le.h>
 
 #endif /* __KERNEL__ */
 #endif /* __ASM_BITOPS_H */
diff -puN arch/parisc/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh arch/parisc/include/asm/bitops.h
--- a/arch/parisc/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh
+++ a/arch/parisc/include/asm/bitops.h
@@ -234,6 +234,4 @@ static __inline__ int fls(int x)
 
 #endif	/* __KERNEL__ */
 
-#include <asm-generic/bitops/minix-le.h>
-
 #endif /* _PARISC_BITOPS_H */
diff -puN arch/powerpc/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh arch/powerpc/include/asm/bitops.h
--- a/arch/powerpc/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh
+++ a/arch/powerpc/include/asm/bitops.h
@@ -308,20 +308,6 @@ unsigned long find_next_le_bit(const uns
 #define ext2_clear_bit_atomic(lock, nr, addr) \
 	test_and_clear_le_bit((nr), (unsigned long*)addr)
 
-/* Bitmap functions for the minix filesystem.  */
-
-#define minix_test_and_set_bit(nr,addr) \
-	__test_and_set_le_bit(nr, (unsigned long *)addr)
-#define minix_set_bit(nr,addr) \
-	__set_le_bit(nr, (unsigned long *)addr)
-#define minix_test_and_clear_bit(nr,addr) \
-	__test_and_clear_le_bit(nr, (unsigned long *)addr)
-#define minix_test_bit(nr,addr) \
-	test_le_bit(nr, (unsigned long *)addr)
-
-#define minix_find_first_zero_bit(addr,size) \
-	find_first_zero_le_bit((unsigned long *)addr, size)
-
 #include <asm-generic/bitops/sched.h>
 
 #endif /* __KERNEL__ */
diff -puN arch/s390/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh arch/s390/include/asm/bitops.h
--- a/arch/s390/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh
+++ a/arch/s390/include/asm/bitops.h
@@ -842,7 +842,6 @@ static inline int find_next_le_bit(void 
 #define ext2_clear_bit_atomic(lock, nr, addr)     \
 	test_and_clear_le_bit((nr), (unsigned long *)(addr))
 
-#include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
 
diff -puN arch/sh/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh arch/sh/include/asm/bitops.h
--- a/arch/sh/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh
+++ a/arch/sh/include/asm/bitops.h
@@ -96,7 +96,6 @@ static inline unsigned long ffz(unsigned
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-atomic.h>
-#include <asm-generic/bitops/minix.h>
 #include <asm-generic/bitops/fls.h>
 #include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
diff -puN arch/sparc/include/asm/bitops_32.h~bitops-remove-minix-bitops-from-asm-bitopsh arch/sparc/include/asm/bitops_32.h
--- a/arch/sparc/include/asm/bitops_32.h~bitops-remove-minix-bitops-from-asm-bitopsh
+++ a/arch/sparc/include/asm/bitops_32.h
@@ -105,7 +105,6 @@ static inline void change_bit(unsigned l
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-atomic.h>
-#include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
 
diff -puN arch/sparc/include/asm/bitops_64.h~bitops-remove-minix-bitops-from-asm-bitopsh arch/sparc/include/asm/bitops_64.h
--- a/arch/sparc/include/asm/bitops_64.h~bitops-remove-minix-bitops-from-asm-bitopsh
+++ a/arch/sparc/include/asm/bitops_64.h
@@ -96,8 +96,6 @@ static inline unsigned int __arch_hweigh
 #define ext2_clear_bit_atomic(lock,nr,addr) \
 	test_and_clear_bit((nr) ^ 0x38,(unsigned long *)(addr))
 
-#include <asm-generic/bitops/minix.h>
-
 #endif /* __KERNEL__ */
 
 #endif /* defined(_SPARC64_BITOPS_H) */
diff -puN arch/tile/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh arch/tile/include/asm/bitops.h
--- a/arch/tile/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh
+++ a/arch/tile/include/asm/bitops.h
@@ -123,6 +123,5 @@ static inline unsigned long __arch_hweig
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/le.h>
-#include <asm-generic/bitops/minix.h>
 
 #endif /* _ASM_TILE_BITOPS_H */
diff -puN arch/x86/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh arch/x86/include/asm/bitops.h
--- a/arch/x86/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh
+++ a/arch/x86/include/asm/bitops.h
@@ -463,7 +463,5 @@ static inline int fls(int x)
 #define ext2_clear_bit_atomic(lock, nr, addr)			\
 	test_and_clear_bit((nr), (unsigned long *)(addr))
 
-#include <asm-generic/bitops/minix.h>
-
 #endif /* __KERNEL__ */
 #endif /* _ASM_X86_BITOPS_H */
diff -puN arch/xtensa/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh arch/xtensa/include/asm/bitops.h
--- a/arch/xtensa/include/asm/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh
+++ a/arch/xtensa/include/asm/bitops.h
@@ -125,7 +125,6 @@ static inline unsigned long __fls(unsign
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/sched.h>
-#include <asm-generic/bitops/minix.h>
 
 #endif	/* __KERNEL__ */
 
diff -puN fs/minix/Kconfig~bitops-remove-minix-bitops-from-asm-bitopsh fs/minix/Kconfig
--- a/fs/minix/Kconfig~bitops-remove-minix-bitops-from-asm-bitopsh
+++ a/fs/minix/Kconfig
@@ -15,3 +15,11 @@ config MINIX_FS
 	  module will be called minix.  Note that the file system of your root
 	  partition (the one containing the directory /) cannot be compiled as
 	  a module.
+
+config MINIX_FS_NATIVE_ENDIAN
+	def_bool MINIX_FS
+	depends on H8300 || M32R || MICROBLAZE || MIPS || S390 || SUPERH || SPARC || XTENSA || (M68K && !MMU)
+
+config MINIX_FS_BIG_ENDIAN_16BIT_INDEXED
+	def_bool MINIX_FS
+	depends on M68K && MMU
diff -puN fs/minix/minix.h~bitops-remove-minix-bitops-from-asm-bitopsh fs/minix/minix.h
--- a/fs/minix/minix.h~bitops-remove-minix-bitops-from-asm-bitopsh
+++ a/fs/minix/minix.h
@@ -88,4 +88,83 @@ static inline struct minix_inode_info *m
 	return list_entry(inode, struct minix_inode_info, vfs_inode);
 }
 
+#if defined(CONFIG_MINIX_FS_NATIVE_ENDIAN) && \
+	defined(CONFIG_MINIX_FS_BIG_ENDIAN_16BIT_INDEXED)
+
+#error Minix file system byte order broken
+
+#elif defined(CONFIG_MINIX_FS_NATIVE_ENDIAN)
+
+/*
+ * big-endian 32 or 64 bit indexed bitmaps on big-endian system or
+ * little-endian bitmaps on little-endian system
+ */
+
+#define minix_test_and_set_bit(nr, addr)	\
+	__test_and_set_bit((nr), (unsigned long *)(addr))
+#define minix_set_bit(nr, addr)		\
+	__set_bit((nr), (unsigned long *)(addr))
+#define minix_test_and_clear_bit(nr, addr) \
+	__test_and_clear_bit((nr), (unsigned long *)(addr))
+#define minix_test_bit(nr, addr)		\
+	test_bit((nr), (unsigned long *)(addr))
+#define minix_find_first_zero_bit(addr, size) \
+	find_first_zero_bit((unsigned long *)(addr), (size))
+
+#elif defined(CONFIG_MINIX_FS_BIG_ENDIAN_16BIT_INDEXED)
+
+/*
+ * big-endian 16bit indexed bitmaps
+ */
+
+static inline int minix_find_first_zero_bit(const void *vaddr, unsigned size)
+{
+	const unsigned short *p = vaddr, *addr = vaddr;
+	unsigned short num;
+
+	if (!size)
+		return 0;
+
+	size = (size >> 4) + ((size & 15) > 0);
+	while (*p++ == 0xffff) {
+		if (--size == 0)
+			return (p - addr) << 4;
+	}
+
+	num = *--p;
+	return ((p - addr) << 4) + ffz(num);
+}
+
+#define minix_test_and_set_bit(nr, addr)	\
+	__test_and_set_bit((nr) ^ 16, (unsigned long *)(addr))
+#define minix_set_bit(nr, addr)	\
+	__set_bit((nr) ^ 16, (unsigned long *)(addr))
+#define minix_test_and_clear_bit(nr, addr)	\
+	__test_and_clear_bit((nr) ^ 16, (unsigned long *)(addr))
+
+static inline int minix_test_bit(int nr, const void *vaddr)
+{
+	const unsigned short *p = vaddr;
+	return (p[nr >> 4] & (1U << (nr & 15))) != 0;
+}
+
+#else
+
+/*
+ * little-endian bitmaps
+ */
+
+#define minix_test_and_set_bit(nr, addr)	\
+	__test_and_set_le_bit((nr), (unsigned long *)(addr))
+#define minix_set_bit(nr, addr)		\
+	__set_le_bit((nr), (unsigned long *)(addr))
+#define minix_test_and_clear_bit(nr, addr) \
+	__test_and_clear_le_bit((nr), (unsigned long *)(addr))
+#define minix_test_bit(nr, addr)		\
+	test_le_bit((nr), (unsigned long *)(addr))
+#define minix_find_first_zero_bit(addr, size) \
+	find_first_zero_le_bit((unsigned long *)(addr), (size))
+
+#endif
+
 #endif /* FS_MINIX_H */
diff -puN include/asm-generic/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh include/asm-generic/bitops.h
--- a/include/asm-generic/bitops.h~bitops-remove-minix-bitops-from-asm-bitopsh
+++ a/include/asm-generic/bitops.h
@@ -40,6 +40,5 @@
 #include <asm-generic/bitops/non-atomic.h>
 #include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-atomic.h>
-#include <asm-generic/bitops/minix.h>
 
 #endif /* __ASM_GENERIC_BITOPS_H */
diff -puN include/asm-generic/bitops/minix-le.h~bitops-remove-minix-bitops-from-asm-bitopsh /dev/null
--- a/include/asm-generic/bitops/minix-le.h
+++ /dev/null
@@ -1,15 +0,0 @@
-#ifndef _ASM_GENERIC_BITOPS_MINIX_LE_H_
-#define _ASM_GENERIC_BITOPS_MINIX_LE_H_
-
-#define minix_test_and_set_bit(nr,addr)	\
-	__test_and_set_le_bit((nr), (unsigned long *)(addr))
-#define minix_set_bit(nr,addr)		\
-	__set_le_bit((nr), (unsigned long *)(addr))
-#define minix_test_and_clear_bit(nr,addr) \
-	__test_and_clear_le_bit((nr), (unsigned long *)(addr))
-#define minix_test_bit(nr,addr)		\
-	test_le_bit((nr), (unsigned long *)(addr))
-#define minix_find_first_zero_bit(addr,size) \
-	find_first_zero_le_bit((unsigned long *)(addr), (size))
-
-#endif /* _ASM_GENERIC_BITOPS_MINIX_LE_H_ */
diff -puN include/asm-generic/bitops/minix.h~bitops-remove-minix-bitops-from-asm-bitopsh /dev/null
--- a/include/asm-generic/bitops/minix.h
+++ /dev/null
@@ -1,15 +0,0 @@
-#ifndef _ASM_GENERIC_BITOPS_MINIX_H_
-#define _ASM_GENERIC_BITOPS_MINIX_H_
-
-#define minix_test_and_set_bit(nr,addr)	\
-	__test_and_set_bit((nr),(unsigned long *)(addr))
-#define minix_set_bit(nr,addr)		\
-	__set_bit((nr),(unsigned long *)(addr))
-#define minix_test_and_clear_bit(nr,addr) \
-	__test_and_clear_bit((nr),(unsigned long *)(addr))
-#define minix_test_bit(nr,addr)		\
-	test_bit((nr),(unsigned long *)(addr))
-#define minix_find_first_zero_bit(addr,size) \
-	find_first_zero_bit((unsigned long *)(addr),(size))
-
-#endif /* _ASM_GENERIC_BITOPS_MINIX_H_ */
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

