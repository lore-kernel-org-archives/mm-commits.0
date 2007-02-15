From: akpm@linux-foundation.org
Subject: + atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency.patch added to -mm tree
Date: Wed, 14 Feb 2007 23:06:18 -0800
Message-ID: <200702150706.l1F76Iua022534@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37303 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964934AbXBOHGa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 02:06:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: compudj@krystal.dyndns.org, mathieu.desnoyers@polymtl.ca


The patch titled
     atomic.h: atomic_add_unless as inline. Remove system.h atomic.h circular dependency
has been added to the -mm tree.  Its filename is
     atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atomic.h: atomic_add_unless as inline. Remove system.h atomic.h circular dependency
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>

atomic_add_unless as inline. Remove system.h atomic.h circular dependency.
I agree (with Andi Kleen) this typeof is not needed and more error
prone. All the original atomic.h code that uses cmpxchg (which includes
the atomic_add_unless) uses defines instead of inline functions,
probably to circumvent a circular dependency between system.h and
atomic.h on powerpc (which my patch addresses). Therefore, it makes
sense to use inline functions that will provide type checking.

atomic_add_unless as inline. Remove system.h atomic.h circular dependency.
Digging into the FRV architecture shows me that it is also affected by
such a circular dependency. Here is the diff applying this against the
rest of my atomic.h patches.

It applies over the atomic.h standardization patches.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/atomic.h     |   59 ++++++++++----------
 include/asm-arm/atomic.h       |    1 
 include/asm-arm26/atomic.h     |    1 
 include/asm-frv/atomic.h       |   91 +++++--------------------------
 include/asm-frv/system.h       |   70 +++++++++++++++++++++++
 include/asm-generic/atomic.h   |   17 ++++-
 include/asm-i386/atomic.h      |   29 +++++----
 include/asm-ia64/atomic.h      |   59 ++++++++++----------
 include/asm-m32r/atomic.h      |   23 +++++--
 include/asm-m68k/atomic.h      |   31 +++++-----
 include/asm-m68knommu/atomic.h |   25 +++++---
 include/asm-mips/atomic.h      |   46 ++++++++++-----
 include/asm-parisc/atomic.h    |   47 ++++++++++------
 include/asm-powerpc/atomic.h   |    1 
 include/asm-ppc/system.h       |    1 
 include/asm-sparc64/atomic.h   |   59 ++++++++++----------
 include/asm-x86_64/atomic.h    |   59 ++++++++++----------
 include/asm-xtensa/atomic.h    |   23 +++++--
 18 files changed, 360 insertions(+), 282 deletions(-)

diff -puN include/asm-alpha/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency include/asm-alpha/atomic.h
--- a/include/asm-alpha/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency
+++ a/include/asm-alpha/atomic.h
@@ -2,6 +2,7 @@
 #define _ALPHA_ATOMIC_H
 
 #include <asm/barrier.h>
+#include <asm/system.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -190,20 +191,21 @@ static __inline__ long atomic64_sub_retu
  * Atomically adds @a to @v, so long as it was not @u.
  * Returns non-zero if @v was not @u, and zero otherwise.
  */
-#define atomic_add_unless(v, a, u)				\
-({								\
-	__typeof__((v)->counter) c, old;			\
-	c = atomic_read(v);					\
-	for (;;) {						\
-		if (unlikely(c == (u)))				\
-			break;					\
-		old = atomic_cmpxchg((v), c, c + (a));		\
-		if (likely(old == c))				\
-			break;					\
-		c = old;					\
-	}							\
-	c != (u);						\
-})
+static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+	c = atomic_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 /**
@@ -215,20 +217,21 @@ static __inline__ long atomic64_sub_retu
  * Atomically adds @a to @v, so long as it was not @u.
  * Returns non-zero if @v was not @u, and zero otherwise.
  */
-#define atomic64_add_unless(v, a, u)				\
-({								\
-	__typeof__((v)->counter) c, old;			\
-	c = atomic64_read(v);					\
-	for (;;) {						\
-		if (unlikely(c == (u)))				\
-			break;					\
-		old = atomic64_cmpxchg((v), c, c + (a));	\
-		if (likely(old == c))				\
-			break;					\
-		c = old;					\
-	}							\
-	c != (u);						\
-})
+static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
+{
+	long c, old;
+	c = atomic64_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic64_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
 
 #define atomic_add_negative(a, v) (atomic_add_return((a), (v)) < 0)
diff -puN include/asm-arm/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency include/asm-arm/atomic.h
--- a/include/asm-arm/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency
+++ a/include/asm-arm/atomic.h
@@ -12,6 +12,7 @@
 #define __ASM_ARM_ATOMIC_H
 
 #include <linux/compiler.h>
+#include <asm/system.h>
 
 typedef struct { volatile int counter; } atomic_t;
 
diff -puN include/asm-arm26/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency include/asm-arm26/atomic.h
--- a/include/asm-arm26/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency
+++ a/include/asm-arm26/atomic.h
@@ -20,7 +20,6 @@
 #ifndef __ASM_ARM_ATOMIC_H
 #define __ASM_ARM_ATOMIC_H
 
-
 #ifdef CONFIG_SMP
 #error SMP is NOT supported
 #endif
diff -puN include/asm-frv/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency include/asm-frv/atomic.h
--- a/include/asm-frv/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency
+++ a/include/asm-frv/atomic.h
@@ -16,6 +16,7 @@
 
 #include <linux/types.h>
 #include <asm/spr-regs.h>
+#include <asm/system.h>
 
 #ifdef CONFIG_SMP
 #error not SMP safe
@@ -258,85 +259,23 @@ extern uint32_t __xchg_32(uint32_t i, vo
 
 #define tas(ptr) (xchg((ptr), 1))
 
-/*****************************************************************************/
-/*
- * compare and conditionally exchange value with memory
- * - if (*ptr == test) then orig = *ptr; *ptr = test;
- * - if (*ptr != test) then orig = *ptr;
- */
-#ifndef CONFIG_FRV_OUTOFLINE_ATOMIC_OPS
-
-#define cmpxchg(ptr, test, new)							\
-({										\
-	__typeof__(ptr) __xg_ptr = (ptr);					\
-	__typeof__(*(ptr)) __xg_orig, __xg_tmp;					\
-	__typeof__(*(ptr)) __xg_test = (test);					\
-	__typeof__(*(ptr)) __xg_new = (new);					\
-										\
-	switch (sizeof(__xg_orig)) {						\
-	case 4:									\
-		asm volatile(							\
-			"0:						\n"	\
-			"	orcc		gr0,gr0,gr0,icc3	\n"	\
-			"	ckeq		icc3,cc7		\n"	\
-			"	ld.p		%M0,%1			\n"	\
-			"	orcr		cc7,cc7,cc3		\n"	\
-			"	sub%I4cc	%1,%4,%2,icc0		\n"	\
-			"	bne		icc0,#0,1f		\n"	\
-			"	cst.p		%3,%M0		,cc3,#1	\n"	\
-			"	corcc		gr29,gr29,gr0	,cc3,#1	\n"	\
-			"	beq		icc3,#0,0b		\n"	\
-			"1:						\n"	\
-			: "+U"(*__xg_ptr), "=&r"(__xg_orig), "=&r"(__xg_tmp)	\
-			: "r"(__xg_new), "NPr"(__xg_test)			\
-			: "memory", "cc7", "cc3", "icc3", "icc0"		\
-			);							\
-		break;								\
-										\
-	default:								\
-		__xg_orig = 0;							\
-		asm volatile("break");						\
-		break;								\
-	}									\
-										\
-	__xg_orig;								\
-})
-
-#else
-
-extern uint32_t __cmpxchg_32(uint32_t *v, uint32_t test, uint32_t new);
-
-#define cmpxchg(ptr, test, new)							\
-({										\
-	__typeof__(ptr) __xg_ptr = (ptr);					\
-	__typeof__(*(ptr)) __xg_orig;						\
-	__typeof__(*(ptr)) __xg_test = (test);					\
-	__typeof__(*(ptr)) __xg_new = (new);					\
-										\
-	switch (sizeof(__xg_orig)) {						\
-	case 4: __xg_orig = __cmpxchg_32(__xg_ptr, __xg_test, __xg_new); break;	\
-	default:								\
-		__xg_orig = 0;							\
-		asm volatile("break");						\
-		break;								\
-	}									\
-										\
-	__xg_orig;								\
-})
-
-#endif
-
 #define atomic_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), old, new))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
-#define atomic_add_unless(v, a, u)				\
-({								\
-	int c, old;						\
-	c = atomic_read(v);					\
-	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
-		c = old;					\
-	c != (u);						\
-})
+static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+	c = atomic_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
 
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
diff -puN include/asm-frv/system.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency include/asm-frv/system.h
--- a/include/asm-frv/system.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency
+++ a/include/asm-frv/system.h
@@ -13,7 +13,6 @@
 #define _ASM_SYSTEM_H
 
 #include <linux/linkage.h>
-#include <asm/atomic.h>
 
 struct thread_struct;
 
@@ -197,4 +196,73 @@ extern void free_initmem(void);
 
 #define arch_align_stack(x) (x)
 
+/*****************************************************************************/
+/*
+ * compare and conditionally exchange value with memory
+ * - if (*ptr == test) then orig = *ptr; *ptr = test;
+ * - if (*ptr != test) then orig = *ptr;
+ */
+#ifndef CONFIG_FRV_OUTOFLINE_ATOMIC_OPS
+
+#define cmpxchg(ptr, test, new)							\
+({										\
+	__typeof__(ptr) __xg_ptr = (ptr);					\
+	__typeof__(*(ptr)) __xg_orig, __xg_tmp;					\
+	__typeof__(*(ptr)) __xg_test = (test);					\
+	__typeof__(*(ptr)) __xg_new = (new);					\
+										\
+	switch (sizeof(__xg_orig)) {						\
+	case 4:									\
+		asm volatile(							\
+			"0:						\n"	\
+			"	orcc		gr0,gr0,gr0,icc3	\n"	\
+			"	ckeq		icc3,cc7		\n"	\
+			"	ld.p		%M0,%1			\n"	\
+			"	orcr		cc7,cc7,cc3		\n"	\
+			"	sub%I4cc	%1,%4,%2,icc0		\n"	\
+			"	bne		icc0,#0,1f		\n"	\
+			"	cst.p		%3,%M0		,cc3,#1	\n"	\
+			"	corcc		gr29,gr29,gr0	,cc3,#1	\n"	\
+			"	beq		icc3,#0,0b		\n"	\
+			"1:						\n"	\
+			: "+U"(*__xg_ptr), "=&r"(__xg_orig), "=&r"(__xg_tmp)	\
+			: "r"(__xg_new), "NPr"(__xg_test)			\
+			: "memory", "cc7", "cc3", "icc3", "icc0"		\
+			);							\
+		break;								\
+										\
+	default:								\
+		__xg_orig = 0;							\
+		asm volatile("break");						\
+		break;								\
+	}									\
+										\
+	__xg_orig;								\
+})
+
+#else
+
+extern uint32_t __cmpxchg_32(uint32_t *v, uint32_t test, uint32_t new);
+
+#define cmpxchg(ptr, test, new)							\
+({										\
+	__typeof__(ptr) __xg_ptr = (ptr);					\
+	__typeof__(*(ptr)) __xg_orig;						\
+	__typeof__(*(ptr)) __xg_test = (test);					\
+	__typeof__(*(ptr)) __xg_new = (new);					\
+										\
+	switch (sizeof(__xg_orig)) {						\
+	case 4: __xg_orig = __cmpxchg_32(__xg_ptr, __xg_test, __xg_new); break;	\
+	default:								\
+		__xg_orig = 0;							\
+		asm volatile("break");						\
+		break;								\
+	}									\
+										\
+	__xg_orig;								\
+})
+
+#endif
+
+
 #endif /* _ASM_SYSTEM_H */
diff -puN include/asm-generic/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency include/asm-generic/atomic.h
--- a/include/asm-generic/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency
+++ a/include/asm-generic/atomic.h
@@ -9,7 +9,6 @@
  */
 
 #include <asm/types.h>
-#include <asm/system.h>
 
 /*
  * Suppport for atomic_long_t
@@ -123,8 +122,12 @@ static inline long atomic_long_dec_retur
 	return (long)atomic64_dec_return(v);
 }
 
-#define atomic_long_add_unless(l, a, u) \
-	atomic64_add_unless((atomic64_t *)(l), (a), (u))
+static inline long atomic_long_add_unless(atomic_long_t *l, long a, long u)
+{
+	atomic64_t *v = (atomic64_t *)l;
+
+	return (long)atomic64_add_unless(v, a, u);
+}
 
 #define atomic_long_inc_not_zero(l) atomic64_inc_not_zero((atomic64_t *)(l))
 
@@ -236,8 +239,12 @@ static inline long atomic_long_dec_retur
 	return (long)atomic_dec_return(v);
 }
 
-#define atomic_long_add_unless(l, a, u) \
-	atomic_add_unless((atomic_t *)(l), (a), (u))
+static inline long atomic_long_add_unless(atomic_long_t *l, long a, long u)
+{
+	atomic_t *v = (atomic_t *)l;
+
+	return (long)atomic_add_unless(v, a, u);
+}
 
 #define atomic_long_inc_not_zero(l) atomic_inc_not_zero((atomic_t *)(l))
 
diff -puN include/asm-i386/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency include/asm-i386/atomic.h
--- a/include/asm-i386/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency
+++ a/include/asm-i386/atomic.h
@@ -219,20 +219,21 @@ static __inline__ int atomic_sub_return(
  * Atomically adds @a to @v, so long as @v was not already @u.
  * Returns non-zero if @v was not @u, and zero otherwise.
  */
-#define atomic_add_unless(v, a, u)				\
-({								\
-	__typeof__((v)->counter) c, old;			\
-	c = atomic_read(v);					\
-	for (;;) {						\
-		if (unlikely(c == (u)))				\
-			break;					\
-		old = atomic_cmpxchg((v), c, c + (a));		\
-		if (likely(old == c))				\
-			break;					\
-		c = old;					\
-	}							\
-	c != (u);						\
-})
+static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+	c = atomic_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 #define atomic_inc_return(v)  (atomic_add_return(1,v))
diff -puN include/asm-ia64/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency include/asm-ia64/atomic.h
--- a/include/asm-ia64/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency
+++ a/include/asm-ia64/atomic.h
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 
 #include <asm/intrinsics.h>
+#include <asm/system.h>
 
 /*
  * On IA-64, counter must always be volatile to ensure that that the
@@ -95,36 +96,38 @@ ia64_atomic64_sub (__s64 i, atomic64_t *
 	(cmpxchg(&((v)->counter), old, new))
 #define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
 
-#define atomic_add_unless(v, a, u)				\
-({								\
-	__typeof__(v->counter) c, old;				\
-	c = atomic_read(v);					\
-	for (;;) {						\
-		if (unlikely(c == (u)))				\
-			break;					\
-		old = atomic_cmpxchg((v), c, c + (a));		\
-		if (likely(old == c))				\
-			break;					\
-		c = old;					\
-	}							\
-	c != (u);						\
-})
+static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+	c = atomic_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
-#define atomic64_add_unless(v, a, u)				\
-({								\
-	__typeof__(v->counter) c, old;				\
-	c = atomic64_read(v);					\
-	for (;;) {						\
-		if (unlikely(c == (u)))				\
-			break;					\
-		old = atomic64_cmpxchg((v), c, c + (a));	\
-		if (likely(old == c))				\
-			break;					\
-		c = old;					\
-	}							\
-	c != (u);						\
-})
+static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
+{
+	long c, old;
+	c = atomic64_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic64_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
 
 #define atomic_add_return(i,v)						\
diff -puN include/asm-m32r/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency include/asm-m32r/atomic.h
--- a/include/asm-m32r/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency
+++ a/include/asm-m32r/atomic.h
@@ -253,14 +253,21 @@ static __inline__ int atomic_dec_return(
  * Atomically adds @a to @v, so long as it was not @u.
  * Returns non-zero if @v was not @u, and zero otherwise.
  */
-#define atomic_add_unless(v, a, u)				\
-({								\
-	int c, old;						\
-	c = atomic_read(v);					\
-	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
-		c = old;					\
-	c != (u);						\
-})
+static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+	c = atomic_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 static __inline__ void atomic_clear_mask(unsigned long  mask, atomic_t *addr)
diff -puN include/asm-m68k/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency include/asm-m68k/atomic.h
--- a/include/asm-m68k/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency
+++ a/include/asm-m68k/atomic.h
@@ -2,7 +2,7 @@
 #define __ARCH_M68K_ATOMIC__
 
 
-#include <asm/system.h>	/* local_irq_XXX() */
+#include <asm/system.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -170,20 +170,21 @@ static inline void atomic_set_mask(unsig
 	__asm__ __volatile__("orl %1,%0" : "+m" (*v) : "id" (mask));
 }
 
-#define atomic_add_unless(v, a, u)				\
-({								\
-	int c, old;						\
-	c = atomic_read(v);					\
-	for (;;) {						\
-		if (unlikely(c == (u)))				\
-			break;					\
-		old = atomic_cmpxchg((v), c, c + (a));		\
-		if (likely(old == c))				\
-			break;					\
-		c = old;					\
-	}							\
-	c != (u);						\
-})
+static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+	c = atomic_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 /* Atomic operations are already serializing */
diff -puN include/asm-m68knommu/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency include/asm-m68knommu/atomic.h
--- a/include/asm-m68knommu/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency
+++ a/include/asm-m68knommu/atomic.h
@@ -1,7 +1,7 @@
 #ifndef __ARCH_M68KNOMMU_ATOMIC__
 #define __ARCH_M68KNOMMU_ATOMIC__
 
-#include <asm/system.h>	/* local_irq_XXX() */
+#include <asm/system.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -131,14 +131,21 @@ static inline int atomic_sub_return(int 
 #define atomic_cmpxchg(v, o, n) ((int)cmpxchg(&((v)->counter), (o), (n)))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
-#define atomic_add_unless(v, a, u)				\
-({								\
-	int c, old;						\
-	c = atomic_read(v);					\
-	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
-		c = old;					\
-	c != (u);						\
-})
+static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+	c = atomic_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 #define atomic_dec_return(v) atomic_sub_return(1,(v))
diff -puN include/asm-mips/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency include/asm-mips/atomic.h
--- a/include/asm-mips/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency
+++ a/include/asm-mips/atomic.h
@@ -18,6 +18,7 @@
 #include <asm/barrier.h>
 #include <asm/cpu-features.h>
 #include <asm/war.h>
+#include <asm/system.h>
 
 typedef struct { volatile int counter; } atomic_t;
 
@@ -318,14 +319,20 @@ static __inline__ int atomic_sub_if_posi
  * Atomically adds @a to @v, so long as it was not @u.
  * Returns non-zero if @v was not @u, and zero otherwise.
  */
-#define atomic_add_unless(v, a, u)				\
-({								\
-	__typeof__((v)->counter) c, old;			\
-	c = atomic_read(v);					\
-	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
-		c = old;					\
-	c != (u);						\
-})
+static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+	c = atomic_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 #define atomic_dec_return(v) atomic_sub_return(1,(v))
@@ -694,14 +701,21 @@ static __inline__ long atomic64_sub_if_p
  * Atomically adds @a to @v, so long as it was not @u.
  * Returns non-zero if @v was not @u, and zero otherwise.
  */
-#define atomic64_add_unless(v, a, u)				\
-({								\
-	__typeof__((v)->counter) c, old;			\
-	c = atomic_read(v);					\
-	while (c != (u) && (old = atomic64_cmpxchg((v), c, c + (a))) != c) \
-		c = old;					\
-	c != (u);						\
-})
+static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
+{
+	long c, old;
+	c = atomic64_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic64_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
 
 #define atomic64_dec_return(v) atomic64_sub_return(1,(v))
diff -puN include/asm-parisc/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency include/asm-parisc/atomic.h
--- a/include/asm-parisc/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency
+++ a/include/asm-parisc/atomic.h
@@ -6,6 +6,7 @@
 #define _ASM_PARISC_ATOMIC_H_
 
 #include <linux/types.h>
+#include <asm/system.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -174,14 +175,21 @@ static __inline__ int atomic_read(const 
  * Atomically adds @a to @v, so long as it was not @u.
  * Returns non-zero if @v was not @u, and zero otherwise.
  */
-#define atomic_add_unless(v, a, u)				\
-({								\
-	__typeof__((v)->counter) c, old;						\
-	c = atomic_read(v);					\
-	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
-		c = old;					\
-	c != (u);						\
-})
+static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+	c = atomic_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 #define atomic_add(i,v)	((void)(__atomic_add_return( ((int)i),(v))))
@@ -283,14 +291,21 @@ atomic64_read(const atomic64_t *v)
  * Atomically adds @a to @v, so long as it was not @u.
  * Returns non-zero if @v was not @u, and zero otherwise.
  */
-#define atomic64_add_unless(v, a, u)				\
-({								\
-	__typeof__((v)->counter) c, old;						\
-	c = atomic64_read(v);					\
-	while (c != (u) && (old = atomic64_cmpxchg((v), c, c + (a))) != c) \
-		c = old;					\
-	c != (u);						\
-})
+static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
+{
+	long c, old;
+	c = atomic64_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic64_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
 
 
diff -puN include/asm-powerpc/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency include/asm-powerpc/atomic.h
--- a/include/asm-powerpc/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency
+++ a/include/asm-powerpc/atomic.h
@@ -11,6 +11,7 @@ typedef struct { volatile int counter; }
 #include <linux/compiler.h>
 #include <asm/synch.h>
 #include <asm/asm-compat.h>
+#include <asm/system.h>
 
 #define ATOMIC_INIT(i)		{ (i) }
 
diff -puN include/asm-ppc/system.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency include/asm-ppc/system.h
--- a/include/asm-ppc/system.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency
+++ a/include/asm-ppc/system.h
@@ -6,7 +6,6 @@
 
 #include <linux/kernel.h>
 
-#include <asm/atomic.h>
 #include <asm/hw_irq.h>
 
 /*
diff -puN include/asm-sparc64/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency include/asm-sparc64/atomic.h
--- a/include/asm-sparc64/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency
+++ a/include/asm-sparc64/atomic.h
@@ -9,6 +9,7 @@
 #define __ARCH_SPARC64_ATOMIC__
 
 #include <linux/types.h>
+#include <asm/system.h>
 
 typedef struct { volatile int counter; } atomic_t;
 typedef struct { volatile __s64 counter; } atomic64_t;
@@ -73,40 +74,42 @@ extern int atomic64_sub_ret(int, atomic6
 #define atomic_cmpxchg(v, o, n) (cmpxchg(&((v)->counter), (o), (n)))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
-#define atomic_add_unless(v, a, u)				\
-({								\
-	__typeof__((v)->counter) c, old;			\
-	c = atomic_read(v);					\
-	for (;;) {						\
-		if (unlikely(c == (u)))				\
-			break;					\
-		old = atomic_cmpxchg((v), c, c + (a));		\
-		if (likely(old == c))				\
-			break;					\
-		c = old;					\
-	}							\
-	likely(c != (u));					\
-})
+static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+	c = atomic_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 #define atomic64_cmpxchg(v, o, n) \
 	((__typeof__((v)->counter))cmpxchg(&((v)->counter), (o), (n)))
 #define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
 
-#define atomic64_add_unless(v, a, u)				\
-({								\
-	__typeof__((v)->counter) c, old;			\
-	c = atomic64_read(v);					\
-	for (;;) {						\
-		if (unlikely(c == (u)))				\
-			break;					\
-		old = atomic64_cmpxchg((v), c, c + (a));	\
-		if (likely(old == c))				\
-			break;					\
-		c = old;					\
-	}							\
-	likely(c != (u));					\
-})
+static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
+{
+	long c, old;
+	c = atomic64_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic64_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
 
 /* Atomic operations are already serializing */
diff -puN include/asm-x86_64/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency include/asm-x86_64/atomic.h
--- a/include/asm-x86_64/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency
+++ a/include/asm-x86_64/atomic.h
@@ -2,6 +2,7 @@
 #define __ARCH_X86_64_ATOMIC__
 
 #include <asm/alternative.h>
+#include <asm/system.h>
 
 /* atomic_t should be 32 bit signed type */
 
@@ -403,20 +404,21 @@ static __inline__ long atomic64_sub_retu
  * Atomically adds @a to @v, so long as it was not @u.
  * Returns non-zero if @v was not @u, and zero otherwise.
  */
-#define atomic_add_unless(v, a, u)				\
-({								\
-	__typeof__((v)->counter) c, old;			\
-	c = atomic_read(v);					\
-	for (;;) {						\
-		if (unlikely(c == (u)))				\
-			break;					\
-		old = atomic_cmpxchg((v), c, c + (a));		\
-		if (likely(old == c))				\
-			break;					\
-		c = old;					\
-	}							\
-	c != (u);						\
-})
+static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+	c = atomic_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 /**
@@ -428,20 +430,21 @@ static __inline__ long atomic64_sub_retu
  * Atomically adds @a to @v, so long as it was not @u.
  * Returns non-zero if @v was not @u, and zero otherwise.
  */
-#define atomic64_add_unless(v, a, u)				\
-({								\
-	__typeof__((v)->counter) c, old;			\
-	c = atomic64_read(v);					\
-	for (;;) {						\
-		if (unlikely(c == (u)))				\
-			break;					\
-		old = atomic64_cmpxchg((v), c, c + (a));	\
-		if (likely(old == c))				\
-			break;					\
-		c = old;					\
-	}							\
-	c != (u);						\
-})
+static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
+{
+	long c, old;
+	c = atomic64_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic64_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
 
 /* These are x86-specific, used by some header files */
diff -puN include/asm-xtensa/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency include/asm-xtensa/atomic.h
--- a/include/asm-xtensa/atomic.h~atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency
+++ a/include/asm-xtensa/atomic.h
@@ -234,14 +234,21 @@ static inline int atomic_sub_return(int 
  * Atomically adds @a to @v, so long as it was not @u.
  * Returns non-zero if @v was not @u, and zero otherwise.
  */
-#define atomic_add_unless(v, a, u)				\
-({								\
-	int c, old;						\
-	c = atomic_read(v);					\
-	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
-		c = old;					\
-	c != (u);						\
-})
+static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+	c = atomic_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
_

Patches currently in -mm which might be from compudj@krystal.dyndns.org are

origin.patch
atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency.patch
