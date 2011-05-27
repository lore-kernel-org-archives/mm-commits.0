From: akpm@linux-foundation.org
Subject: [merged] arch-remove-config_generic_find_next_bitbit_lelast_bit.patch removed from -mm tree
Date: Fri, 27 May 2011 12:59:28 -0700
Message-ID: <201105271957.p4RJvXOl017687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752180Ab1E0UP6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 16:15:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, arnd@arndb.de, gerg@uclinux.org, heiko.carstens@de.ibm.com, linux@arm.linux.org.uk, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     arch: remove CONFIG_GENERIC_FIND_{NEXT_BIT,BIT_LE,LAST_BIT}
has been removed from the -mm tree.  Its filename was
     arch-remove-config_generic_find_next_bitbit_lelast_bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch: remove CONFIG_GENERIC_FIND_{NEXT_BIT,BIT_LE,LAST_BIT}
From: Akinobu Mita <akinobu.mita@gmail.com>

By the previous style change, CONFIG_GENERIC_FIND_NEXT_BIT,
CONFIG_GENERIC_FIND_BIT_LE, and CONFIG_GENERIC_FIND_LAST_BIT are not used
to test for existence of find bitops anymore.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig      |    4 ----
 arch/blackfin/Kconfig   |    3 ---
 arch/cris/Kconfig       |    4 ----
 arch/frv/Kconfig        |    8 --------
 arch/h8300/Kconfig      |    8 --------
 arch/ia64/Kconfig       |    4 ----
 arch/m32r/Kconfig       |    8 --------
 arch/m68k/Kconfig.nommu |    4 ----
 arch/microblaze/Kconfig |    6 ------
 arch/mips/Kconfig       |    8 --------
 arch/mn10300/Kconfig    |    3 ---
 arch/parisc/Kconfig     |    8 --------
 arch/powerpc/Kconfig    |    8 --------
 arch/score/Kconfig      |    3 ---
 arch/sh/Kconfig         |    6 ------
 arch/sparc/Kconfig      |    8 --------
 arch/tile/Kconfig       |    1 -
 arch/um/Kconfig.x86     |    1 -
 arch/x86/Kconfig        |    1 -
 arch/xtensa/Kconfig     |    6 ------
 include/linux/bitops.h  |    2 --
 lib/Kconfig             |   10 ----------
 lib/Makefile            |    8 ++------
 lib/find_next_bit.c     |    6 ------
 24 files changed, 2 insertions(+), 126 deletions(-)

diff -puN arch/alpha/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit
+++ a/arch/alpha/Kconfig
@@ -41,10 +41,6 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default n
 
-config GENERIC_FIND_NEXT_BIT
-	bool
-	default y
-
 config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
diff -puN arch/blackfin/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit arch/blackfin/Kconfig
--- a/arch/blackfin/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit
+++ a/arch/blackfin/Kconfig
@@ -47,9 +47,6 @@ config GENERIC_BUG
 config ZONE_DMA
 	def_bool y
 
-config GENERIC_FIND_NEXT_BIT
-	def_bool y
-
 config GENERIC_GPIO
 	def_bool y
 
diff -puN arch/cris/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit arch/cris/Kconfig
--- a/arch/cris/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit
+++ a/arch/cris/Kconfig
@@ -31,10 +31,6 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default n
 
-config GENERIC_FIND_NEXT_BIT
-	bool
-	default y
-
 config GENERIC_HWEIGHT
 	bool
 	default y
diff -puN arch/frv/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit arch/frv/Kconfig
--- a/arch/frv/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit
+++ a/arch/frv/Kconfig
@@ -19,14 +19,6 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 
-config GENERIC_FIND_NEXT_BIT
-	bool
-	default y
-
-config GENERIC_FIND_BIT_LE
-	bool
-	default y
-
 config GENERIC_HWEIGHT
 	bool
 	default y
diff -puN arch/h8300/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit
+++ a/arch/h8300/Kconfig
@@ -41,14 +41,6 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default n
 
-config GENERIC_FIND_NEXT_BIT
-	bool
-	default y
-
-config GENERIC_FIND_BIT_LE
-	bool
-	default y
-
 config GENERIC_HWEIGHT
 	bool
 	default y
diff -puN arch/ia64/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit
+++ a/arch/ia64/Kconfig
@@ -78,10 +78,6 @@ config HUGETLB_PAGE_SIZE_VARIABLE
 	depends on HUGETLB_PAGE
 	default y
 
-config GENERIC_FIND_NEXT_BIT
-	bool
-	default y
-
 config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
diff -puN arch/m32r/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit
+++ a/arch/m32r/Kconfig
@@ -256,14 +256,6 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default n
 
-config GENERIC_FIND_NEXT_BIT
-	bool
-	default y
-
-config GENERIC_FIND_BIT_LE
-	bool
-	default y
-
 config GENERIC_HWEIGHT
 	bool
 	default y
diff -puN arch/m68k/Kconfig.nommu~arch-remove-config_generic_find_next_bitbit_lelast_bit arch/m68k/Kconfig.nommu
--- a/arch/m68k/Kconfig.nommu~arch-remove-config_generic_find_next_bitbit_lelast_bit
+++ a/arch/m68k/Kconfig.nommu
@@ -2,10 +2,6 @@ config FPU
 	bool
 	default n
 
-config GENERIC_FIND_NEXT_BIT
-	bool
-	default y
-
 config GENERIC_GPIO
 	bool
 	default n
diff -puN arch/microblaze/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit arch/microblaze/Kconfig
--- a/arch/microblaze/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit
+++ a/arch/microblaze/Kconfig
@@ -33,12 +33,6 @@ config ARCH_HAS_ILOG2_U32
 config ARCH_HAS_ILOG2_U64
 	def_bool n
 
-config GENERIC_FIND_NEXT_BIT
-	def_bool y
-
-config GENERIC_FIND_BIT_LE
-	def_bool y
-
 config GENERIC_HWEIGHT
 	def_bool y
 
diff -puN arch/mips/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit arch/mips/Kconfig
--- a/arch/mips/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit
+++ a/arch/mips/Kconfig
@@ -821,14 +821,6 @@ config ARCH_SUPPORTS_OPROFILE
 	bool
 	default y if !MIPS_MT_SMTC
 
-config GENERIC_FIND_NEXT_BIT
-	bool
-	default y
-
-config GENERIC_FIND_BIT_LE
-	bool
-	default y
-
 config GENERIC_HWEIGHT
 	bool
 	default y
diff -puN arch/mn10300/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit arch/mn10300/Kconfig
--- a/arch/mn10300/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit
+++ a/arch/mn10300/Kconfig
@@ -44,9 +44,6 @@ config GENERIC_CALIBRATE_DELAY
 config GENERIC_CMOS_UPDATE
         def_bool n
 
-config GENERIC_FIND_NEXT_BIT
-	def_bool y
-
 config GENERIC_HWEIGHT
 	def_bool y
 
diff -puN arch/parisc/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit
+++ a/arch/parisc/Kconfig
@@ -47,14 +47,6 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default n
 
-config GENERIC_FIND_NEXT_BIT
-	bool
-	default y
-
-config GENERIC_FIND_BIT_LE
-	bool
-	default y
-
 config GENERIC_BUG
 	bool
 	default y
diff -puN arch/powerpc/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit
+++ a/arch/powerpc/Kconfig
@@ -91,14 +91,6 @@ config GENERIC_HWEIGHT
 	bool
 	default y
 
-config GENERIC_FIND_NEXT_BIT
-	bool
-	default y
-
-config GENERIC_FIND_BIT_LE
-	bool
-	default y
-
 config GENERIC_GPIO
 	bool
 	help
diff -puN arch/score/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit arch/score/Kconfig
--- a/arch/score/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit
+++ a/arch/score/Kconfig
@@ -43,9 +43,6 @@ config NO_DMA
 config RWSEM_GENERIC_SPINLOCK
 	def_bool y
 
-config GENERIC_FIND_NEXT_BIT
-	def_bool y
-
 config GENERIC_HWEIGHT
 	def_bool y
 
diff -puN arch/sh/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit arch/sh/Kconfig
--- a/arch/sh/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit
+++ a/arch/sh/Kconfig
@@ -71,12 +71,6 @@ config GENERIC_CSUM
 	def_bool y
 	depends on SUPERH64
 
-config GENERIC_FIND_NEXT_BIT
-	def_bool y
-
-config GENERIC_FIND_BIT_LE
-	def_bool y
-
 config GENERIC_HWEIGHT
 	def_bool y
 
diff -puN arch/sparc/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit
+++ a/arch/sparc/Kconfig
@@ -190,14 +190,6 @@ config RWSEM_XCHGADD_ALGORITHM
 	bool
 	default y if SPARC64
 
-config GENERIC_FIND_NEXT_BIT
-	bool
-	default y
-
-config GENERIC_FIND_BIT_LE
-	bool
-	default y
-
 config GENERIC_HWEIGHT
 	bool
 	default y if !ULTRA_HAS_POPULATION_COUNT
diff -puN arch/tile/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit arch/tile/Kconfig
--- a/arch/tile/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit
+++ a/arch/tile/Kconfig
@@ -5,7 +5,6 @@ config TILE
 	def_bool y
 	select HAVE_KVM if !TILEGX
 	select GENERIC_FIND_FIRST_BIT
-	select GENERIC_FIND_NEXT_BIT
 	select USE_GENERIC_SMP_HELPERS
 	select CC_OPTIMIZE_FOR_SIZE
 	select HAVE_GENERIC_HARDIRQS
diff -puN arch/um/Kconfig.x86~arch-remove-config_generic_find_next_bitbit_lelast_bit arch/um/Kconfig.x86
--- a/arch/um/Kconfig.x86~arch-remove-config_generic_find_next_bitbit_lelast_bit
+++ a/arch/um/Kconfig.x86
@@ -15,7 +15,6 @@ endmenu
 config UML_X86
 	def_bool y
 	select GENERIC_FIND_FIRST_BIT
-	select GENERIC_FIND_NEXT_BIT
 
 config 64BIT
 	bool
diff -puN arch/x86/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit arch/x86/Kconfig
--- a/arch/x86/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit
+++ a/arch/x86/Kconfig
@@ -64,7 +64,6 @@ config X86
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_SPARSE_IRQ
 	select GENERIC_FIND_FIRST_BIT
-	select GENERIC_FIND_NEXT_BIT
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_IRQ_SHOW
diff -puN arch/xtensa/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit
+++ a/arch/xtensa/Kconfig
@@ -20,12 +20,6 @@ config XTENSA
 config RWSEM_XCHGADD_ALGORITHM
 	def_bool y
 
-config GENERIC_FIND_NEXT_BIT
-	def_bool y
-
-config GENERIC_FIND_BIT_LE
-	def_bool y
-
 config GENERIC_HWEIGHT
 	def_bool y
 
diff -puN include/linux/bitops.h~arch-remove-config_generic_find_next_bitbit_lelast_bit include/linux/bitops.h
--- a/include/linux/bitops.h~arch-remove-config_generic_find_next_bitbit_lelast_bit
+++ a/include/linux/bitops.h
@@ -148,7 +148,6 @@ static inline unsigned long __ffs64(u64 
 
 #ifdef __KERNEL__
 
-#ifdef CONFIG_GENERIC_FIND_LAST_BIT
 #ifndef find_last_bit
 /**
  * find_last_bit - find the last set bit in a memory region
@@ -160,7 +159,6 @@ static inline unsigned long __ffs64(u64 
 extern unsigned long find_last_bit(const unsigned long *addr,
 				   unsigned long size);
 #endif
-#endif /* CONFIG_GENERIC_FIND_LAST_BIT */
 
 #endif /* __KERNEL__ */
 #endif
diff -puN lib/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit lib/Kconfig
--- a/lib/Kconfig~arch-remove-config_generic_find_next_bitbit_lelast_bit
+++ a/lib/Kconfig
@@ -19,16 +19,6 @@ config RATIONAL
 config GENERIC_FIND_FIRST_BIT
 	bool
 
-config GENERIC_FIND_NEXT_BIT
-	bool
-
-config GENERIC_FIND_BIT_LE
-	bool
-
-config GENERIC_FIND_LAST_BIT
-	bool
-	default y
-
 config CRC_CCITT
 	tristate "CRC-CCITT functions"
 	help
diff -puN lib/Makefile~arch-remove-config_generic_find_next_bitbit_lelast_bit lib/Makefile
--- a/lib/Makefile~arch-remove-config_generic_find_next_bitbit_lelast_bit
+++ a/lib/Makefile
@@ -12,7 +12,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o prio_heap.o ratelimit.o show_mem.o \
-	 is_single_threaded.o plist.o decompress.o
+	 is_single_threaded.o plist.o decompress.o find_next_bit.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
@@ -22,7 +22,7 @@ lib-y	+= kobject.o kref.o klist.o
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
 	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o flex_array.o \
-	 bsearch.o
+	 bsearch.o find_last_bit.o
 obj-y += kstrtox.o
 obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
 
@@ -39,10 +39,6 @@ obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
 lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
-lib-$(CONFIG_GENERIC_FIND_FIRST_BIT) += find_next_bit.o
-lib-$(CONFIG_GENERIC_FIND_NEXT_BIT) += find_next_bit.o
-lib-$(CONFIG_GENERIC_FIND_BIT_LE) += find_next_bit.o
-obj-$(CONFIG_GENERIC_FIND_LAST_BIT) += find_last_bit.o
 
 CFLAGS_hweight.o = $(subst $(quote),,$(CONFIG_ARCH_HWEIGHT_CFLAGS))
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
diff -puN lib/find_next_bit.c~arch-remove-config_generic_find_next_bitbit_lelast_bit lib/find_next_bit.c
--- a/lib/find_next_bit.c~arch-remove-config_generic_find_next_bitbit_lelast_bit
+++ a/lib/find_next_bit.c
@@ -16,7 +16,6 @@
 
 #define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
 
-#ifdef CONFIG_GENERIC_FIND_NEXT_BIT
 #ifndef find_next_bit
 /*
  * Find the next set bit in a memory region.
@@ -107,9 +106,7 @@ found_middle:
 }
 EXPORT_SYMBOL(find_next_zero_bit);
 #endif
-#endif /* CONFIG_GENERIC_FIND_NEXT_BIT */
 
-#ifdef CONFIG_GENERIC_FIND_FIRST_BIT
 #ifndef find_first_bit
 /*
  * Find the first set bit in a memory region.
@@ -165,10 +162,8 @@ found:
 }
 EXPORT_SYMBOL(find_first_zero_bit);
 #endif
-#endif /* CONFIG_GENERIC_FIND_FIRST_BIT */
 
 #ifdef __BIG_ENDIAN
-#ifdef CONFIG_GENERIC_FIND_BIT_LE
 
 /* include/linux/byteorder does not support "unsigned long" type */
 static inline unsigned long ext2_swabp(const unsigned long * x)
@@ -287,5 +282,4 @@ found_middle_swap:
 EXPORT_SYMBOL(find_next_bit_le);
 #endif
 
-#endif /* CONFIG_GENERIC_FIND_BIT_LE */
 #endif /* __BIG_ENDIAN */
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch

