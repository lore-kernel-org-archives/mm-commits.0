From: akpm@linux-foundation.org
Subject: + add-the-common-dma_addr_t-typedef-to-include-linux-typesh.patch added to -mm tree
Date: Fri, 03 Sep 2010 15:10:19 -0700
Message-ID: <201009032210.o83MAJZV015295@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753256Ab0ICWLp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2010 18:11:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, arnd@arndb.de, benh@kernel.crashing.org, cmetcalf@tilera.com, heiko.carstens@de.ibm.com, hpa@zytor.com, ink@jurassic.park.msu.ru, mattst88@gmail.com, mingo@elte.hu, ralf@linux-mips.org, rth@twiddle.net, schwidefsky@de.ibm.com, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     add the common dma_addr_t typedef to include/linux/types.h
has been added to the -mm tree.  Its filename is
     add-the-common-dma_addr_t-typedef-to-include-linux-typesh.patch

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
Subject: add the common dma_addr_t typedef to include/linux/types.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

All architectures can use the common dma_addr_t typedef now. We can
remove the arch specific dma_addr_t.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Matt Turner <mattst88@gmail.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/types.h   |    1 -
 arch/arm/include/asm/types.h     |    3 ---
 arch/avr32/include/asm/types.h   |    8 --------
 arch/cris/include/asm/types.h    |    3 ---
 arch/frv/include/asm/types.h     |    8 --------
 arch/h8300/include/asm/types.h   |    4 ----
 arch/ia64/include/asm/types.h    |    3 ---
 arch/m32r/include/asm/types.h    |    3 ---
 arch/m68k/include/asm/types.h    |    3 ---
 arch/mips/include/asm/types.h    |    6 ------
 arch/mn10300/include/asm/types.h |    7 -------
 arch/parisc/include/asm/types.h  |    3 ---
 arch/powerpc/include/asm/types.h |    5 -----
 arch/s390/include/asm/types.h    |    6 ------
 arch/sparc/include/asm/types.h   |    4 ----
 arch/x86/include/asm/types.h     |    8 --------
 arch/xtensa/include/asm/types.h  |    4 ----
 include/asm-generic/types.h      |   27 ---------------------------
 include/linux/types.h            |    6 ++++++
 19 files changed, 6 insertions(+), 106 deletions(-)

diff -puN arch/alpha/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh arch/alpha/include/asm/types.h
--- a/arch/alpha/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh
+++ a/arch/alpha/include/asm/types.h
@@ -27,7 +27,6 @@ typedef unsigned int umode_t;
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
-typedef u64 dma_addr_t;
 typedef u64 dma64_addr_t;
 
 #endif /* __ASSEMBLY__ */
diff -puN arch/arm/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh arch/arm/include/asm/types.h
--- a/arch/arm/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh
+++ a/arch/arm/include/asm/types.h
@@ -18,9 +18,6 @@ typedef unsigned short umode_t;
 
 #ifndef __ASSEMBLY__
 
-/* Dma addresses are 32-bits wide.  */
-
-typedef u32 dma_addr_t;
 typedef u32 dma64_addr_t;
 
 #endif /* __ASSEMBLY__ */
diff -puN arch/avr32/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh arch/avr32/include/asm/types.h
--- a/arch/avr32/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh
+++ a/arch/avr32/include/asm/types.h
@@ -23,14 +23,6 @@ typedef unsigned short umode_t;
 
 #define BITS_PER_LONG 32
 
-#ifndef __ASSEMBLY__
-
-/* Dma addresses are 32-bits wide.  */
-
-typedef u32 dma_addr_t;
-
-#endif /* __ASSEMBLY__ */
-
 #endif /* __KERNEL__ */
 
 
diff -puN arch/cris/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh arch/cris/include/asm/types.h
--- a/arch/cris/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh
+++ a/arch/cris/include/asm/types.h
@@ -18,9 +18,6 @@ typedef unsigned short umode_t;
 
 #ifndef __ASSEMBLY__
 
-/* Dma addresses are 32-bits wide, just like our other addresses.  */
- 
-typedef u32 dma_addr_t;
 typedef u32 dma64_addr_t;
 
 #endif /* __ASSEMBLY__ */
diff -puN arch/frv/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh arch/frv/include/asm/types.h
--- a/arch/frv/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh
+++ a/arch/frv/include/asm/types.h
@@ -27,14 +27,6 @@ typedef unsigned short umode_t;
 
 #define BITS_PER_LONG 32
 
-#ifndef __ASSEMBLY__
-
-/* Dma addresses are 32-bits wide.  */
-
-typedef u32 dma_addr_t;
-
-#endif /* __ASSEMBLY__ */
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_TYPES_H */
diff -puN arch/h8300/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh arch/h8300/include/asm/types.h
--- a/arch/h8300/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh
+++ a/arch/h8300/include/asm/types.h
@@ -22,10 +22,6 @@ typedef unsigned short umode_t;
 
 #define BITS_PER_LONG 32
 
-/* Dma addresses are 32-bits wide.  */
-
-typedef u32 dma_addr_t;
-
 #endif /* __KERNEL__ */
 
 #endif /* __ASSEMBLY__ */
diff -puN arch/ia64/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh arch/ia64/include/asm/types.h
--- a/arch/ia64/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh
+++ a/arch/ia64/include/asm/types.h
@@ -40,9 +40,6 @@ struct fnptr {
 	unsigned long gp;
 };
 
-/* DMA addresses are 64-bits wide, in general.  */
-typedef u64 dma_addr_t;
-
 # endif /* __KERNEL__ */
 #endif /* !__ASSEMBLY__ */
 
diff -puN arch/m32r/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh arch/m32r/include/asm/types.h
--- a/arch/m32r/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh
+++ a/arch/m32r/include/asm/types.h
@@ -18,9 +18,6 @@ typedef unsigned short umode_t;
 
 #ifndef __ASSEMBLY__
 
-/* DMA addresses are 32-bits wide.  */
-
-typedef u32 dma_addr_t;
 typedef u64 dma64_addr_t;
 
 #endif /* __ASSEMBLY__ */
diff -puN arch/m68k/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh arch/m68k/include/asm/types.h
--- a/arch/m68k/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh
+++ a/arch/m68k/include/asm/types.h
@@ -25,9 +25,6 @@ typedef unsigned short umode_t;
 
 #ifndef __ASSEMBLY__
 
-/* DMA addresses are always 32-bits wide */
-
-typedef u32 dma_addr_t;
 typedef u32 dma64_addr_t;
 
 #endif /* __ASSEMBLY__ */
diff -puN arch/mips/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh arch/mips/include/asm/types.h
--- a/arch/mips/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh
+++ a/arch/mips/include/asm/types.h
@@ -33,12 +33,6 @@ typedef unsigned short umode_t;
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
-#if (defined(CONFIG_HIGHMEM) && defined(CONFIG_64BIT_PHYS_ADDR)) \
-    || defined(CONFIG_64BIT)
-typedef u64 dma_addr_t;
-#else
-typedef u32 dma_addr_t;
-#endif
 typedef u64 dma64_addr_t;
 
 /*
diff -puN arch/mn10300/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh arch/mn10300/include/asm/types.h
--- a/arch/mn10300/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh
+++ a/arch/mn10300/include/asm/types.h
@@ -26,13 +26,6 @@ typedef unsigned short umode_t;
 
 #define BITS_PER_LONG 32
 
-#ifndef __ASSEMBLY__
-
-/* Dma addresses are 32-bits wide.  */
-typedef u32 dma_addr_t;
-
-#endif /* __ASSEMBLY__ */
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_TYPES_H */
diff -puN arch/parisc/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh arch/parisc/include/asm/types.h
--- a/arch/parisc/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh
+++ a/arch/parisc/include/asm/types.h
@@ -16,9 +16,6 @@ typedef unsigned short umode_t;
 
 #ifndef __ASSEMBLY__
 
-/* Dma addresses are 32-bits wide.  */
-
-typedef u32 dma_addr_t;
 typedef u64 dma64_addr_t;
 
 #endif /* __ASSEMBLY__ */
diff -puN arch/powerpc/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh arch/powerpc/include/asm/types.h
--- a/arch/powerpc/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh
+++ a/arch/powerpc/include/asm/types.h
@@ -44,11 +44,6 @@ typedef struct {
 
 typedef __vector128 vector128;
 
-#if defined(__powerpc64__) || defined(CONFIG_PHYS_64BIT)
-typedef u64 dma_addr_t;
-#else
-typedef u32 dma_addr_t;
-#endif
 typedef u64 dma64_addr_t;
 
 typedef struct {
diff -puN arch/s390/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh arch/s390/include/asm/types.h
--- a/arch/s390/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh
+++ a/arch/s390/include/asm/types.h
@@ -31,12 +31,6 @@ typedef __signed__ long saddr_t;
 #ifndef __ASSEMBLY__
 
 typedef u64 dma64_addr_t;
-#ifdef __s390x__
-/* DMA addresses come in 32-bit and 64-bit flavours. */
-typedef u64 dma_addr_t;
-#else
-typedef u32 dma_addr_t;
-#endif
 
 #ifndef __s390x__
 typedef union {
diff -puN arch/sparc/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh arch/sparc/include/asm/types.h
--- a/arch/sparc/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh
+++ a/arch/sparc/include/asm/types.h
@@ -22,10 +22,6 @@ typedef unsigned short umode_t;
 
 #ifndef __ASSEMBLY__
 
-/* Dma addresses come in generic and 64-bit flavours.  */
-
-typedef u32 dma_addr_t;
-
 #if defined(__arch64__)
 
 /*** SPARC 64 bit ***/
diff -puN arch/x86/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh arch/x86/include/asm/types.h
--- a/arch/x86/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh
+++ a/arch/x86/include/asm/types.h
@@ -1,20 +1,12 @@
 #ifndef _ASM_X86_TYPES_H
 #define _ASM_X86_TYPES_H
 
-#define dma_addr_t	dma_addr_t
-
 #include <asm-generic/types.h>
 
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
 typedef u64 dma64_addr_t;
-#if defined(CONFIG_X86_64) || defined(CONFIG_HIGHMEM64G)
-/* DMA addresses come in 32-bit and 64-bit flavours. */
-typedef u64 dma_addr_t;
-#else
-typedef u32 dma_addr_t;
-#endif
 
 #endif /* __ASSEMBLY__ */
 #endif /* __KERNEL__ */
diff -puN arch/xtensa/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh arch/xtensa/include/asm/types.h
--- a/arch/xtensa/include/asm/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh
+++ a/arch/xtensa/include/asm/types.h
@@ -32,10 +32,6 @@ typedef unsigned short umode_t;
 
 #define BITS_PER_LONG 32
 
-/* Dma addresses are 32-bits wide.  */
-
-typedef u32 dma_addr_t;
-
 #endif	/* __KERNEL__ */
 #endif
 
diff -puN include/asm-generic/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh include/asm-generic/types.h
--- a/include/asm-generic/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh
+++ a/include/asm-generic/types.h
@@ -12,31 +12,4 @@ typedef unsigned short umode_t;
 
 #endif /* __ASSEMBLY__ */
 
-/*
- * These aren't exported outside the kernel to avoid name space clashes
- */
-#ifdef __KERNEL__
-#ifndef __ASSEMBLY__
-/*
- * DMA addresses may be very different from physical addresses
- * and pointers. i386 and powerpc may have 64 bit DMA on 32 bit
- * systems, while sparc64 uses 32 bit DMA addresses for 64 bit
- * physical addresses.
- * This default defines dma_addr_t to have the same size as
- * phys_addr_t, which is the most common way.
- * Do not define the dma64_addr_t type, which never really
- * worked.
- */
-#ifndef dma_addr_t
-#ifdef CONFIG_PHYS_ADDR_T_64BIT
-typedef u64 dma_addr_t;
-#else
-typedef u32 dma_addr_t;
-#endif /* CONFIG_PHYS_ADDR_T_64BIT */
-#endif /* dma_addr_t */
-
-#endif /* __ASSEMBLY__ */
-
-#endif /* __KERNEL__ */
-
 #endif /* _ASM_GENERIC_TYPES_H */
diff -puN include/linux/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh include/linux/types.h
--- a/include/linux/types.h~add-the-common-dma_addr_t-typedef-to-include-linux-typesh
+++ a/include/linux/types.h
@@ -150,6 +150,12 @@ typedef unsigned long blkcnt_t;
 #define pgoff_t unsigned long
 #endif
 
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+typedef u64 dma_addr_t;
+#else
+typedef u32 dma_addr_t;
+#endif /* dma_addr_t */
+
 #endif /* __KERNEL__ */
 
 /*
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
x86-enable-arch_dma_addr_t_64bit-with-x86_64-highmem64g.patch
alpha-enable-arch_dma_addr_t_64bit.patch
ia64-enable-arch_dma_addr_t_64bit.patch
mips-enable-arch_dma_addr_t_64bit-with-highmem-64bit_phys_addr-64bit.patch
powerpc-enable-arch_dma_addr_t_64bit-with-arch_phys_addr_t_64bit.patch
s390-enable-arch_dma_addr_t_64bit-with-64bit.patch
tile-enable-arch_dma_addr_t_64bit.patch
add-the-common-dma_addr_t-typedef-to-include-linux-typesh.patch

