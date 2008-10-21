From: akpm@linux-foundation.org
Subject: + atomic_t-unify-all-arch-definitions.patch added to -mm tree
Date: Mon, 20 Oct 2008 17:07:52 -0700
Message-ID: <200810210007.m9L07qDZ017585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751767AbYJUAH4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 20:07:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthew@wil.cx, linux-arch@vger.kernel.org, willy@linux.intel.com, ying.huang@intel.com


The patch titled
     atomic_t: unify all arch definitions
has been added to the -mm tree.  Its filename is
     atomic_t-unify-all-arch-definitions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atomic_t: unify all arch definitions
From: Matthew Wilcox <matthew@wil.cx>

The atomic_t type cannot currently be used in some header files because it
would create an include loop with asm/atomic.h.  Move the type definition
to linux/types.h to break the loop.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/atomic.h     |    9 +--------
 arch/arm/include/asm/atomic.h       |    3 +--
 arch/avr32/include/asm/atomic.h     |    2 +-
 arch/blackfin/include/asm/atomic.h  |    4 +---
 arch/h8300/include/asm/atomic.h     |    3 ++-
 arch/ia64/include/asm/atomic.h      |    6 ------
 arch/m68knommu/include/asm/atomic.h |    2 +-
 arch/mips/include/asm/atomic.h      |    5 +----
 arch/parisc/include/asm/atomic.h    |   11 +++--------
 arch/powerpc/include/asm/atomic.h   |    4 +---
 arch/s390/include/asm/atomic.h      |    7 +------
 arch/sh/include/asm/atomic.h        |    7 +++----
 arch/sparc/include/asm/atomic_32.h  |    2 --
 arch/sparc/include/asm/atomic_64.h  |    3 ---
 include/asm-cris/atomic.h           |    4 +---
 include/asm-frv/atomic.h            |    4 ----
 include/asm-m32r/atomic.h           |    8 +-------
 include/asm-m68k/atomic.h           |    3 +--
 include/asm-mn10300/atomic.h        |    9 ---------
 include/asm-x86/atomic_32.h         |   10 +---------
 include/asm-x86/atomic_64.h         |   18 ++----------------
 include/asm-xtensa/atomic.h         |    3 +--
 include/linux/types.h               |   10 ++++++++++
 23 files changed, 33 insertions(+), 104 deletions(-)

diff -puN arch/alpha/include/asm/atomic.h~atomic_t-unify-all-arch-definitions arch/alpha/include/asm/atomic.h
--- a/arch/alpha/include/asm/atomic.h~atomic_t-unify-all-arch-definitions
+++ a/arch/alpha/include/asm/atomic.h
@@ -1,6 +1,7 @@
 #ifndef _ALPHA_ATOMIC_H
 #define _ALPHA_ATOMIC_H
 
+#include <linux/types.h>
 #include <asm/barrier.h>
 #include <asm/system.h>
 
@@ -13,14 +14,6 @@
  */
 
 
-/*
- * Counter is volatile to make sure gcc doesn't try to be clever
- * and move things around on us. We need to use _exactly_ the address
- * the user gave us, not some alias that contains the same information.
- */
-typedef struct { volatile int counter; } atomic_t;
-typedef struct { volatile long counter; } atomic64_t;
-
 #define ATOMIC_INIT(i)		( (atomic_t) { (i) } )
 #define ATOMIC64_INIT(i)	( (atomic64_t) { (i) } )
 
diff -puN arch/arm/include/asm/atomic.h~atomic_t-unify-all-arch-definitions arch/arm/include/asm/atomic.h
--- a/arch/arm/include/asm/atomic.h~atomic_t-unify-all-arch-definitions
+++ a/arch/arm/include/asm/atomic.h
@@ -12,10 +12,9 @@
 #define __ASM_ARM_ATOMIC_H
 
 #include <linux/compiler.h>
+#include <linux/types.h>
 #include <asm/system.h>
 
-typedef struct { volatile int counter; } atomic_t;
-
 #define ATOMIC_INIT(i)	{ (i) }
 
 #ifdef __KERNEL__
diff -puN arch/avr32/include/asm/atomic.h~atomic_t-unify-all-arch-definitions arch/avr32/include/asm/atomic.h
--- a/arch/avr32/include/asm/atomic.h~atomic_t-unify-all-arch-definitions
+++ a/arch/avr32/include/asm/atomic.h
@@ -14,9 +14,9 @@
 #ifndef __ASM_AVR32_ATOMIC_H
 #define __ASM_AVR32_ATOMIC_H
 
+#include <linux/types.h>
 #include <asm/system.h>
 
-typedef struct { volatile int counter; } atomic_t;
 #define ATOMIC_INIT(i)  { (i) }
 
 #define atomic_read(v)		((v)->counter)
diff -puN arch/blackfin/include/asm/atomic.h~atomic_t-unify-all-arch-definitions arch/blackfin/include/asm/atomic.h
--- a/arch/blackfin/include/asm/atomic.h~atomic_t-unify-all-arch-definitions
+++ a/arch/blackfin/include/asm/atomic.h
@@ -1,6 +1,7 @@
 #ifndef __ARCH_BLACKFIN_ATOMIC__
 #define __ARCH_BLACKFIN_ATOMIC__
 
+#include <linux/types.h>
 #include <asm/system.h>	/* local_irq_XXX() */
 
 /*
@@ -13,9 +14,6 @@
  * Tony Kou (tonyko@lineo.ca)   Lineo Inc.   2001
  */
 
-typedef struct {
-	int counter;
-} atomic_t;
 #define ATOMIC_INIT(i)	{ (i) }
 
 #define atomic_read(v)		((v)->counter)
diff -puN arch/h8300/include/asm/atomic.h~atomic_t-unify-all-arch-definitions arch/h8300/include/asm/atomic.h
--- a/arch/h8300/include/asm/atomic.h~atomic_t-unify-all-arch-definitions
+++ a/arch/h8300/include/asm/atomic.h
@@ -1,12 +1,13 @@
 #ifndef __ARCH_H8300_ATOMIC__
 #define __ARCH_H8300_ATOMIC__
 
+#include <linux/types.h>
+
 /*
  * Atomic operations that C can't guarantee us.  Useful for
  * resource counting etc..
  */
 
-typedef struct { int counter; } atomic_t;
 #define ATOMIC_INIT(i)	{ (i) }
 
 #define atomic_read(v)		((v)->counter)
diff -puN arch/ia64/include/asm/atomic.h~atomic_t-unify-all-arch-definitions arch/ia64/include/asm/atomic.h
--- a/arch/ia64/include/asm/atomic.h~atomic_t-unify-all-arch-definitions
+++ a/arch/ia64/include/asm/atomic.h
@@ -17,12 +17,6 @@
 #include <asm/intrinsics.h>
 #include <asm/system.h>
 
-/*
- * On IA-64, counter must always be volatile to ensure that that the
- * memory accesses are ordered.
- */
-typedef struct { volatile __s32 counter; } atomic_t;
-typedef struct { volatile __s64 counter; } atomic64_t;
 
 #define ATOMIC_INIT(i)		((atomic_t) { (i) })
 #define ATOMIC64_INIT(i)	((atomic64_t) { (i) })
diff -puN arch/m68knommu/include/asm/atomic.h~atomic_t-unify-all-arch-definitions arch/m68knommu/include/asm/atomic.h
--- a/arch/m68knommu/include/asm/atomic.h~atomic_t-unify-all-arch-definitions
+++ a/arch/m68knommu/include/asm/atomic.h
@@ -1,6 +1,7 @@
 #ifndef __ARCH_M68KNOMMU_ATOMIC__
 #define __ARCH_M68KNOMMU_ATOMIC__
 
+#include <linux/types.h>
 #include <asm/system.h>
 
 /*
@@ -12,7 +13,6 @@
  * We do not have SMP m68k systems, so we don't have to deal with that.
  */
 
-typedef struct { int counter; } atomic_t;
 #define ATOMIC_INIT(i)	{ (i) }
 
 #define atomic_read(v)		((v)->counter)
diff -puN arch/mips/include/asm/atomic.h~atomic_t-unify-all-arch-definitions arch/mips/include/asm/atomic.h
--- a/arch/mips/include/asm/atomic.h~atomic_t-unify-all-arch-definitions
+++ a/arch/mips/include/asm/atomic.h
@@ -15,13 +15,12 @@
 #define _ASM_ATOMIC_H
 
 #include <linux/irqflags.h>
+#include <linux/types.h>
 #include <asm/barrier.h>
 #include <asm/cpu-features.h>
 #include <asm/war.h>
 #include <asm/system.h>
 
-typedef struct { volatile int counter; } atomic_t;
-
 #define ATOMIC_INIT(i)    { (i) }
 
 /*
@@ -404,8 +403,6 @@ static __inline__ int atomic_add_unless(
 
 #ifdef CONFIG_64BIT
 
-typedef struct { volatile long counter; } atomic64_t;
-
 #define ATOMIC64_INIT(i)    { (i) }
 
 /*
diff -puN arch/parisc/include/asm/atomic.h~atomic_t-unify-all-arch-definitions arch/parisc/include/asm/atomic.h
--- a/arch/parisc/include/asm/atomic.h~atomic_t-unify-all-arch-definitions
+++ a/arch/parisc/include/asm/atomic.h
@@ -155,14 +155,11 @@ static inline unsigned long __cmpxchg_lo
 #define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
 #endif
 
-/* Note that we need not lock read accesses - aligned word writes/reads
- * are atomic, so a reader never sees unconsistent values.
- *
- * Cache-line alignment would conflict with, for example, linux/module.h
+/*
+ * Note that we need not lock read accesses - aligned word writes/reads
+ * are atomic, so a reader never sees inconsistent values.
  */
 
-typedef struct { volatile int counter; } atomic_t;
-
 /* It's possible to reduce all atomic operations to either
  * __atomic_add_return, atomic_set and atomic_read (the latter
  * is there only for consistency).
@@ -260,8 +257,6 @@ static __inline__ int atomic_add_unless(
 
 #ifdef CONFIG_64BIT
 
-typedef struct { volatile s64 counter; } atomic64_t;
-
 #define ATOMIC64_INIT(i) ((atomic64_t) { (i) })
 
 static __inline__ int
diff -puN arch/powerpc/include/asm/atomic.h~atomic_t-unify-all-arch-definitions arch/powerpc/include/asm/atomic.h
--- a/arch/powerpc/include/asm/atomic.h~atomic_t-unify-all-arch-definitions
+++ a/arch/powerpc/include/asm/atomic.h
@@ -5,7 +5,7 @@
  * PowerPC atomic operations
  */
 
-typedef struct { int counter; } atomic_t;
+#include <linux/types.h>
 
 #ifdef __KERNEL__
 #include <linux/compiler.h>
@@ -251,8 +251,6 @@ static __inline__ int atomic_dec_if_posi
 
 #ifdef __powerpc64__
 
-typedef struct { long counter; } atomic64_t;
-
 #define ATOMIC64_INIT(i)	{ (i) }
 
 static __inline__ long atomic64_read(const atomic64_t *v)
diff -puN arch/s390/include/asm/atomic.h~atomic_t-unify-all-arch-definitions arch/s390/include/asm/atomic.h
--- a/arch/s390/include/asm/atomic.h~atomic_t-unify-all-arch-definitions
+++ a/arch/s390/include/asm/atomic.h
@@ -2,6 +2,7 @@
 #define __ARCH_S390_ATOMIC__
 
 #include <linux/compiler.h>
+#include <linux/types.h>
 
 /*
  *  include/asm-s390/atomic.h
@@ -23,9 +24,6 @@
  * S390 uses 'Compare And Swap' for atomicity in SMP enviroment
  */
 
-typedef struct {
-	int counter;
-} __attribute__ ((aligned (4))) atomic_t;
 #define ATOMIC_INIT(i)  { (i) }
 
 #ifdef __KERNEL__
@@ -149,9 +147,6 @@ static __inline__ int atomic_add_unless(
 #undef __CS_LOOP
 
 #ifdef __s390x__
-typedef struct {
-	long long counter;
-} __attribute__ ((aligned (8))) atomic64_t;
 #define ATOMIC64_INIT(i)  { (i) }
 
 #if __GNUC__ > 3 || (__GNUC__ == 3 && __GNUC_MINOR__ > 2)
diff -puN arch/sh/include/asm/atomic.h~atomic_t-unify-all-arch-definitions arch/sh/include/asm/atomic.h
--- a/arch/sh/include/asm/atomic.h~atomic_t-unify-all-arch-definitions
+++ a/arch/sh/include/asm/atomic.h
@@ -7,16 +7,15 @@
  *
  */
 
-typedef struct { volatile int counter; } atomic_t;
+#include <linux/compiler.h>
+#include <linux/types.h>
+#include <asm/system.h>
 
 #define ATOMIC_INIT(i)	( (atomic_t) { (i) } )
 
 #define atomic_read(v)		((v)->counter)
 #define atomic_set(v,i)		((v)->counter = (i))
 
-#include <linux/compiler.h>
-#include <asm/system.h>
-
 #if defined(CONFIG_GUSA_RB)
 #include <asm/atomic-grb.h>
 #elif defined(CONFIG_CPU_SH4A)
diff -puN arch/sparc/include/asm/atomic_32.h~atomic_t-unify-all-arch-definitions arch/sparc/include/asm/atomic_32.h
--- a/arch/sparc/include/asm/atomic_32.h~atomic_t-unify-all-arch-definitions
+++ a/arch/sparc/include/asm/atomic_32.h
@@ -13,8 +13,6 @@
 
 #include <linux/types.h>
 
-typedef struct { volatile int counter; } atomic_t;
-
 #ifdef __KERNEL__
 
 #define ATOMIC_INIT(i)  { (i) }
diff -puN arch/sparc/include/asm/atomic_64.h~atomic_t-unify-all-arch-definitions arch/sparc/include/asm/atomic_64.h
--- a/arch/sparc/include/asm/atomic_64.h~atomic_t-unify-all-arch-definitions
+++ a/arch/sparc/include/asm/atomic_64.h
@@ -10,9 +10,6 @@
 #include <linux/types.h>
 #include <asm/system.h>
 
-typedef struct { volatile int counter; } atomic_t;
-typedef struct { volatile __s64 counter; } atomic64_t;
-
 #define ATOMIC_INIT(i)		{ (i) }
 #define ATOMIC64_INIT(i)	{ (i) }
 
diff -puN include/asm-cris/atomic.h~atomic_t-unify-all-arch-definitions include/asm-cris/atomic.h
--- a/include/asm-cris/atomic.h~atomic_t-unify-all-arch-definitions
+++ a/include/asm-cris/atomic.h
@@ -4,7 +4,7 @@
 #define __ASM_CRIS_ATOMIC__
 
 #include <linux/compiler.h>
-
+#include <linux/types.h>
 #include <asm/system.h>
 #include <asm/arch/atomic.h>
 
@@ -13,8 +13,6 @@
  * resource counting etc..
  */
 
-typedef struct { volatile int counter; } atomic_t;
-
 #define ATOMIC_INIT(i)  { (i) }
 
 #define atomic_read(v) ((v)->counter)
diff -puN include/asm-frv/atomic.h~atomic_t-unify-all-arch-definitions include/asm-frv/atomic.h
--- a/include/asm-frv/atomic.h~atomic_t-unify-all-arch-definitions
+++ a/include/asm-frv/atomic.h
@@ -35,10 +35,6 @@
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-typedef struct {
-	int counter;
-} atomic_t;
-
 #define ATOMIC_INIT(i)		{ (i) }
 #define atomic_read(v)		((v)->counter)
 #define atomic_set(v, i)	(((v)->counter) = (i))
diff -puN include/asm-m32r/atomic.h~atomic_t-unify-all-arch-definitions include/asm-m32r/atomic.h
--- a/include/asm-m32r/atomic.h~atomic_t-unify-all-arch-definitions
+++ a/include/asm-m32r/atomic.h
@@ -9,6 +9,7 @@
  *    Copyright (C) 2004  Hirokazu Takata <takata at linux-m32r.org>
  */
 
+#include <linux/types.h>
 #include <asm/assembler.h>
 #include <asm/system.h>
 
@@ -17,13 +18,6 @@
  * resource counting etc..
  */
 
-/*
- * Make sure gcc doesn't try to be clever and move things around
- * on us. We need to use _exactly_ the address the user gave us,
- * not some alias that contains the same information.
- */
-typedef struct { volatile int counter; } atomic_t;
-
 #define ATOMIC_INIT(i)	{ (i) }
 
 /**
diff -puN include/asm-m68k/atomic.h~atomic_t-unify-all-arch-definitions include/asm-m68k/atomic.h
--- a/include/asm-m68k/atomic.h~atomic_t-unify-all-arch-definitions
+++ a/include/asm-m68k/atomic.h
@@ -1,7 +1,7 @@
 #ifndef __ARCH_M68K_ATOMIC__
 #define __ARCH_M68K_ATOMIC__
 
-
+#include <linux/types.h>
 #include <asm/system.h>
 
 /*
@@ -13,7 +13,6 @@
  * We do not have SMP m68k systems, so we don't have to deal with that.
  */
 
-typedef struct { int counter; } atomic_t;
 #define ATOMIC_INIT(i)	{ (i) }
 
 #define atomic_read(v)		((v)->counter)
diff -puN include/asm-mn10300/atomic.h~atomic_t-unify-all-arch-definitions include/asm-mn10300/atomic.h
--- a/include/asm-mn10300/atomic.h~atomic_t-unify-all-arch-definitions
+++ a/include/asm-mn10300/atomic.h
@@ -20,15 +20,6 @@
  * resource counting etc..
  */
 
-/*
- * Make sure gcc doesn't try to be clever and move things around
- * on us. We need to use _exactly_ the address the user gave us,
- * not some alias that contains the same information.
- */
-typedef struct {
-	int	counter;
-} atomic_t;
-
 #define ATOMIC_INIT(i)	{ (i) }
 
 #ifdef __KERNEL__
diff -puN include/asm-x86/atomic_32.h~atomic_t-unify-all-arch-definitions include/asm-x86/atomic_32.h
--- a/include/asm-x86/atomic_32.h~atomic_t-unify-all-arch-definitions
+++ a/include/asm-x86/atomic_32.h
@@ -2,6 +2,7 @@
 #define ASM_X86__ATOMIC_32_H
 
 #include <linux/compiler.h>
+#include <linux/types.h>
 #include <asm/processor.h>
 #include <asm/cmpxchg.h>
 
@@ -10,15 +11,6 @@
  * resource counting etc..
  */
 
-/*
- * Make sure gcc doesn't try to be clever and move things around
- * on us. We need to use _exactly_ the address the user gave us,
- * not some alias that contains the same information.
- */
-typedef struct {
-	int counter;
-} atomic_t;
-
 #define ATOMIC_INIT(i)	{ (i) }
 
 /**
diff -puN include/asm-x86/atomic_64.h~atomic_t-unify-all-arch-definitions include/asm-x86/atomic_64.h
--- a/include/asm-x86/atomic_64.h~atomic_t-unify-all-arch-definitions
+++ a/include/asm-x86/atomic_64.h
@@ -1,25 +1,15 @@
 #ifndef ASM_X86__ATOMIC_64_H
 #define ASM_X86__ATOMIC_64_H
 
+#include <linux/types.h>
 #include <asm/alternative.h>
 #include <asm/cmpxchg.h>
 
-/* atomic_t should be 32 bit signed type */
-
 /*
  * Atomic operations that C can't guarantee us.  Useful for
  * resource counting etc..
  */
 
-/*
- * Make sure gcc doesn't try to be clever and move things around
- * on us. We need to use _exactly_ the address the user gave us,
- * not some alias that contains the same information.
- */
-typedef struct {
-	int counter;
-} atomic_t;
-
 #define ATOMIC_INIT(i)	{ (i) }
 
 /**
@@ -191,11 +181,7 @@ static inline int atomic_sub_return(int 
 #define atomic_inc_return(v)  (atomic_add_return(1, v))
 #define atomic_dec_return(v)  (atomic_sub_return(1, v))
 
-/* An 64bit atomic type */
-
-typedef struct {
-	long counter;
-} atomic64_t;
+/* The 64-bit atomic type */
 
 #define ATOMIC64_INIT(i)	{ (i) }
 
diff -puN include/asm-xtensa/atomic.h~atomic_t-unify-all-arch-definitions include/asm-xtensa/atomic.h
--- a/include/asm-xtensa/atomic.h~atomic_t-unify-all-arch-definitions
+++ a/include/asm-xtensa/atomic.h
@@ -14,8 +14,7 @@
 #define _XTENSA_ATOMIC_H
 
 #include <linux/stringify.h>
-
-typedef struct { volatile int counter; } atomic_t;
+#include <linux/types.h>
 
 #ifdef __KERNEL__
 #include <asm/processor.h>
diff -puN include/linux/types.h~atomic_t-unify-all-arch-definitions include/linux/types.h
--- a/include/linux/types.h~atomic_t-unify-all-arch-definitions
+++ a/include/linux/types.h
@@ -199,6 +199,16 @@ typedef u32 phys_addr_t;
 
 typedef phys_addr_t resource_size_t;
 
+typedef struct {
+	volatile int counter;
+} atomic_t;
+
+#ifdef CONFIG_64BIT
+typedef struct {
+	volatile long counter;
+} atomic64_t;
+#endif
+
 struct ustat {
 	__kernel_daddr_t	f_tfree;
 	__kernel_ino_t		f_tinode;
_

Patches currently in -mm which might be from matthew@wil.cx are

origin.patch
linux-next.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
atomic_t-unify-all-arch-definitions.patch
make-sure-nobodys-leaking-resources.patch

