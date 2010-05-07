From: akpm@linux-foundation.org
Subject: [alternative-merged] bitops-optimize-hweight-by-making-use-of-compile-time-evaluation.patch removed from -mm tree
Date: Fri, 07 May 2010 11:46:23 -0400
Message-ID: <201005071847.o47IlrS8005475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752803Ab0EGSsk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 May 2010 14:48:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, bp@amd64.org, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     bitops: optimize hweight() by making use of compile-time evaluation
has been removed from the -mm tree.  Its filename was
     bitops-optimize-hweight-by-making-use-of-compile-time-evaluation.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bitops: optimize hweight() by making use of compile-time evaluation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Rename the extisting runtime hweight() implementations to
__arch_hweight(), rename the compile-time versions to __const_hweight()
and then have hweight() pick between them.

Suggested-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Borislav Petkov <bp@amd64.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/bitops.h            |   18 ++++----
 arch/ia64/include/asm/bitops.h             |   11 ++--
 arch/sparc/include/asm/bitops_64.h         |   11 ++--
 include/asm-generic/bitops/arch_hweight.h  |   11 ++++
 include/asm-generic/bitops/const_hweight.h |   42 +++++++++++++++++++
 include/asm-generic/bitops/hweight.h       |    8 ---
 include/linux/bitops.h                     |   25 -----------
 lib/hweight.c                              |   19 ++++----
 8 files changed, 87 insertions(+), 58 deletions(-)

diff -puN arch/alpha/include/asm/bitops.h~bitops-optimize-hweight-by-making-use-of-compile-time-evaluation arch/alpha/include/asm/bitops.h
--- a/arch/alpha/include/asm/bitops.h~bitops-optimize-hweight-by-making-use-of-compile-time-evaluation
+++ a/arch/alpha/include/asm/bitops.h
@@ -405,29 +405,31 @@ static inline int fls(int x)
 
 #if defined(CONFIG_ALPHA_EV6) && defined(CONFIG_ALPHA_EV67)
 /* Whee.  EV67 can calculate it directly.  */
-static inline unsigned long hweight64(unsigned long w)
+static inline unsigned long __arch_hweight64(unsigned long w)
 {
 	return __kernel_ctpop(w);
 }
 
-static inline unsigned int hweight32(unsigned int w)
+static inline unsigned int __arch_weight32(unsigned int w)
 {
-	return hweight64(w);
+	return __arch_hweight64(w);
 }
 
-static inline unsigned int hweight16(unsigned int w)
+static inline unsigned int __arch_hweight16(unsigned int w)
 {
-	return hweight64(w & 0xffff);
+	return __arch_hweight64(w & 0xffff);
 }
 
-static inline unsigned int hweight8(unsigned int w)
+static inline unsigned int __arch_hweight8(unsigned int w)
 {
-	return hweight64(w & 0xff);
+	return __arch_hweight64(w & 0xff);
 }
 #else
-#include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/arch_hweight.h>
 #endif
 
+#include <asm-generic/bitops/const_hweight.h>
+
 #endif /* __KERNEL__ */
 
 #include <asm-generic/bitops/find.h>
diff -puN arch/ia64/include/asm/bitops.h~bitops-optimize-hweight-by-making-use-of-compile-time-evaluation arch/ia64/include/asm/bitops.h
--- a/arch/ia64/include/asm/bitops.h~bitops-optimize-hweight-by-making-use-of-compile-time-evaluation
+++ a/arch/ia64/include/asm/bitops.h
@@ -437,17 +437,18 @@ __fls (unsigned long x)
  * hweightN: returns the hamming weight (i.e. the number
  * of bits set) of a N-bit word
  */
-static __inline__ unsigned long
-hweight64 (unsigned long x)
+static __inline__ unsigned long __arch_hweight64(unsigned long x)
 {
 	unsigned long result;
 	result = ia64_popcnt(x);
 	return result;
 }
 
-#define hweight32(x)	(unsigned int) hweight64((x) & 0xfffffffful)
-#define hweight16(x)	(unsigned int) hweight64((x) & 0xfffful)
-#define hweight8(x)	(unsigned int) hweight64((x) & 0xfful)
+#define __arch_hweight32(x) ((unsigned int) __arch_hweight64((x) & 0xfffffffful))
+#define __arch_hweight16(x) ((unsigned int) __arch_hweight64((x) & 0xfffful))
+#define __arch_hweight8(x)  ((unsigned int) __arch_hweight64((x) & 0xfful))
+
+#include <asm-generic/bitops/const_hweight.h>
 
 #endif /* __KERNEL__ */
 
diff -puN arch/sparc/include/asm/bitops_64.h~bitops-optimize-hweight-by-making-use-of-compile-time-evaluation arch/sparc/include/asm/bitops_64.h
--- a/arch/sparc/include/asm/bitops_64.h~bitops-optimize-hweight-by-making-use-of-compile-time-evaluation
+++ a/arch/sparc/include/asm/bitops_64.h
@@ -44,7 +44,7 @@ extern void change_bit(unsigned long nr,
 
 #ifdef ULTRA_HAS_POPULATION_COUNT
 
-static inline unsigned int hweight64(unsigned long w)
+static inline unsigned int __arch_hweight64(unsigned long w)
 {
 	unsigned int res;
 
@@ -52,7 +52,7 @@ static inline unsigned int hweight64(uns
 	return res;
 }
 
-static inline unsigned int hweight32(unsigned int w)
+static inline unsigned int __arch_hweight32(unsigned int w)
 {
 	unsigned int res;
 
@@ -60,7 +60,7 @@ static inline unsigned int hweight32(uns
 	return res;
 }
 
-static inline unsigned int hweight16(unsigned int w)
+static inline unsigned int __arch_hweight16(unsigned int w)
 {
 	unsigned int res;
 
@@ -68,7 +68,7 @@ static inline unsigned int hweight16(uns
 	return res;
 }
 
-static inline unsigned int hweight8(unsigned int w)
+static inline unsigned int __arch_hweight8(unsigned int w)
 {
 	unsigned int res;
 
@@ -78,9 +78,10 @@ static inline unsigned int hweight8(unsi
 
 #else
 
-#include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/arch_hweight.h>
 
 #endif
+#include <asm-generic/bitops/const_hweight.h>
 #include <asm-generic/bitops/lock.h>
 #endif /* __KERNEL__ */
 
diff -puN /dev/null include/asm-generic/bitops/arch_hweight.h
--- /dev/null
+++ a/include/asm-generic/bitops/arch_hweight.h
@@ -0,0 +1,11 @@
+#ifndef _ASM_GENERIC_BITOPS_ARCH_HWEIGHT_H_
+#define _ASM_GENERIC_BITOPS_ARCH_HWEIGHT_H_
+
+#include <asm/types.h>
+
+extern unsigned int __arch_hweight32(unsigned int w);
+extern unsigned int __arch_hweight16(unsigned int w);
+extern unsigned int __arch_hweight8(unsigned int w);
+extern unsigned long __arch_hweight64(__u64 w);
+
+#endif /* _ASM_GENERIC_BITOPS_HWEIGHT_H_ */
diff -puN /dev/null include/asm-generic/bitops/const_hweight.h
--- /dev/null
+++ a/include/asm-generic/bitops/const_hweight.h
@@ -0,0 +1,42 @@
+#ifndef _ASM_GENERIC_BITOPS_CONST_HWEIGHT_H_
+#define _ASM_GENERIC_BITOPS_CONST_HWEIGHT_H_
+
+/*
+ * Compile time versions of __arch_hweightN()
+ */
+#define __const_hweight8(w)		\
+      (	(!!((w) & (1ULL << 0))) +	\
+	(!!((w) & (1ULL << 1))) +	\
+	(!!((w) & (1ULL << 2))) +	\
+	(!!((w) & (1ULL << 3))) +	\
+	(!!((w) & (1ULL << 4))) +	\
+	(!!((w) & (1ULL << 5))) +	\
+	(!!((w) & (1ULL << 6))) +	\
+	(!!((w) & (1ULL << 7)))	)
+
+#define __const_hweight16(w) (__const_hweight8(w)  + __const_hweight8((w)  >> 8 ))
+#define __const_hweight32(w) (__const_hweight16(w) + __const_hweight16((w) >> 16))
+#define __const_hweight64(w) (__const_hweight32(w) + __const_hweight32((w) >> 32))
+
+/*
+ * Generic interface.
+ */
+#define hweight8(w)  (__builtin_constant_p(w) ? __const_hweight8(w)  : __arch_hweight8(w))
+#define hweight16(w) (__builtin_constant_p(w) ? __const_hweight16(w) : __arch_hweight16(w))
+#define hweight32(w) (__builtin_constant_p(w) ? __const_hweight32(w) : __arch_hweight32(w))
+#define hweight64(w) (__builtin_constant_p(w) ? __const_hweight64(w) : __arch_hweight64(w))
+
+/*
+ * Interface for known constant arguments
+ */
+#define HWEIGHT8(w)  (BUILD_BUG_ON_ZERO(!__builtin_constant_p(w)) + __const_hweight8(w))
+#define HWEIGHT16(w) (BUILD_BUG_ON_ZERO(!__builtin_constant_p(w)) + __const_hweight16(w))
+#define HWEIGHT32(w) (BUILD_BUG_ON_ZERO(!__builtin_constant_p(w)) + __const_hweight32(w))
+#define HWEIGHT64(w) (BUILD_BUG_ON_ZERO(!__builtin_constant_p(w)) + __const_hweight64(w))
+
+/*
+ * Type invariant interface to the compile time constant hweight functions.
+ */
+#define HWEIGHT(w)   HWEIGHT64((u64)w)
+
+#endif /* _ASM_GENERIC_BITOPS_CONST_HWEIGHT_H_ */
diff -puN include/asm-generic/bitops/hweight.h~bitops-optimize-hweight-by-making-use-of-compile-time-evaluation include/asm-generic/bitops/hweight.h
--- a/include/asm-generic/bitops/hweight.h~bitops-optimize-hweight-by-making-use-of-compile-time-evaluation
+++ a/include/asm-generic/bitops/hweight.h
@@ -1,11 +1,7 @@
 #ifndef _ASM_GENERIC_BITOPS_HWEIGHT_H_
 #define _ASM_GENERIC_BITOPS_HWEIGHT_H_
 
-#include <asm/types.h>
-
-extern unsigned int hweight32(unsigned int w);
-extern unsigned int hweight16(unsigned int w);
-extern unsigned int hweight8(unsigned int w);
-extern unsigned long hweight64(__u64 w);
+#include <asm-generic/bitops/arch_hweight.h>
+#include <asm-generic/bitops/const_hweight.h>
 
 #endif /* _ASM_GENERIC_BITOPS_HWEIGHT_H_ */
diff -puN include/linux/bitops.h~bitops-optimize-hweight-by-making-use-of-compile-time-evaluation include/linux/bitops.h
--- a/include/linux/bitops.h~bitops-optimize-hweight-by-making-use-of-compile-time-evaluation
+++ a/include/linux/bitops.h
@@ -44,31 +44,6 @@ static inline unsigned long hweight_long
 	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
 }
 
-/*
- * Clearly slow versions of the hweightN() functions, their benefit is
- * of course compile time evaluation of constant arguments.
- */
-#define HWEIGHT8(w)					\
-      (	BUILD_BUG_ON_ZERO(!__builtin_constant_p(w)) +	\
-	(!!((w) & (1ULL << 0))) +			\
-	(!!((w) & (1ULL << 1))) +			\
-	(!!((w) & (1ULL << 2))) +			\
-	(!!((w) & (1ULL << 3))) +			\
-	(!!((w) & (1ULL << 4))) +			\
-	(!!((w) & (1ULL << 5))) +			\
-	(!!((w) & (1ULL << 6))) +			\
-	(!!((w) & (1ULL << 7)))	)
-
-#define HWEIGHT16(w) (HWEIGHT8(w)  + HWEIGHT8((w) >> 8))
-#define HWEIGHT32(w) (HWEIGHT16(w) + HWEIGHT16((w) >> 16))
-#define HWEIGHT64(w) (HWEIGHT32(w) + HWEIGHT32((w) >> 32))
-
-/*
- * Type invariant version that simply casts things to the
- * largest type.
- */
-#define HWEIGHT(w)   HWEIGHT64((u64)(w))
-
 /**
  * rol32 - rotate a 32-bit value left
  * @word: value to rotate
diff -puN lib/hweight.c~bitops-optimize-hweight-by-making-use-of-compile-time-evaluation lib/hweight.c
--- a/lib/hweight.c~bitops-optimize-hweight-by-making-use-of-compile-time-evaluation
+++ a/lib/hweight.c
@@ -9,7 +9,7 @@
  * The Hamming Weight of a number is the total number of bits set in it.
  */
 
-unsigned int hweight32(unsigned int w)
+unsigned int __arch_hweight32(unsigned int w)
 {
 #ifdef ARCH_HAS_FAST_MULTIPLIER
 	w -= (w >> 1) & 0x55555555;
@@ -24,29 +24,30 @@ unsigned int hweight32(unsigned int w)
 	return (res + (res >> 16)) & 0x000000FF;
 #endif
 }
-EXPORT_SYMBOL(hweight32);
+EXPORT_SYMBOL(__arch_hweight32);
 
-unsigned int hweight16(unsigned int w)
+unsigned int __arch_hweight16(unsigned int w)
 {
 	unsigned int res = w - ((w >> 1) & 0x5555);
 	res = (res & 0x3333) + ((res >> 2) & 0x3333);
 	res = (res + (res >> 4)) & 0x0F0F;
 	return (res + (res >> 8)) & 0x00FF;
 }
-EXPORT_SYMBOL(hweight16);
+EXPORT_SYMBOL(__arch_hweight16);
 
-unsigned int hweight8(unsigned int w)
+unsigned int __arch_hweight8(unsigned int w)
 {
 	unsigned int res = w - ((w >> 1) & 0x55);
 	res = (res & 0x33) + ((res >> 2) & 0x33);
 	return (res + (res >> 4)) & 0x0F;
 }
-EXPORT_SYMBOL(hweight8);
+EXPORT_SYMBOL(__arch_hweight8);
 
-unsigned long hweight64(__u64 w)
+unsigned long __arch_hweight64(__u64 w)
 {
 #if BITS_PER_LONG == 32
-	return hweight32((unsigned int)(w >> 32)) + hweight32((unsigned int)w);
+	return __arch_hweight32((unsigned int)(w >> 32)) +
+	       __arch_hweight32((unsigned int)w);
 #elif BITS_PER_LONG == 64
 #ifdef ARCH_HAS_FAST_MULTIPLIER
 	w -= (w >> 1) & 0x5555555555555555ul;
@@ -63,4 +64,4 @@ unsigned long hweight64(__u64 w)
 #endif
 #endif
 }
-EXPORT_SYMBOL(hweight64);
+EXPORT_SYMBOL(__arch_hweight64);
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
linux-next.patch
x86-remove-last-traces-of-quicklist-usage.patch
cpu-timers-optimize-run_posix_cpu_timers.patch
rcu-remove-init_rcu_head-rcu_head_init-rcu_head.patch
mm-revalidate-anon_vma-in-page_lock_anon_vma.patch
bitops-optimize-hweight-by-making-use-of-compile-time-evaluation.patch
x86-add-optimized-popcnt-variants.patch

