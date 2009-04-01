From: akpm@linux-foundation.org
Subject: [merged] alpha-xchg-cmpxchg-cleanup-and-fixes.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:39:10 -0700
Message-ID: <200904011839.n31IdAaE008537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765678AbZDASmF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:42:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: xchg/cmpxchg cleanup and fixes
has been removed from the -mm tree.  Its filename was
     alpha-xchg-cmpxchg-cleanup-and-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: xchg/cmpxchg cleanup and fixes
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

- "_local" versions of xchg/cmpxchg functions duplicate code
  of non-local ones (quite a few pages of assembler), except
  memory barriers. We can generate these two variants from a
  single header file using simple macros;

- convert xchg macro back to inline function using always_inline
  attribute;

- use proper argument types for cmpxchg_u8/u16 functions
  to fix a problem with negative arguments.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/system.h |  549 ++----------------------------
 arch/alpha/include/asm/xchg.h   |  258 ++++++++++++++
 2 files changed, 309 insertions(+), 498 deletions(-)

diff -puN arch/alpha/include/asm/system.h~alpha-xchg-cmpxchg-cleanup-and-fixes arch/alpha/include/asm/system.h
--- a/arch/alpha/include/asm/system.h~alpha-xchg-cmpxchg-cleanup-and-fixes
+++ a/arch/alpha/include/asm/system.h
@@ -309,518 +309,71 @@ extern int __min_ipl;
 #define tbia()		__tbi(-2, /* no second argument */)
 
 /*
- * Atomic exchange.
- * Since it can be used to implement critical sections
- * it must clobber "memory" (also for interrupts in UP).
+ * Atomic exchange routines.
  */
 
-static inline unsigned long
-__xchg_u8(volatile char *m, unsigned long val)
-{
-	unsigned long ret, tmp, addr64;
-
-	__asm__ __volatile__(
-	"	andnot	%4,7,%3\n"
-	"	insbl	%1,%4,%1\n"
-	"1:	ldq_l	%2,0(%3)\n"
-	"	extbl	%2,%4,%0\n"
-	"	mskbl	%2,%4,%2\n"
-	"	or	%1,%2,%2\n"
-	"	stq_c	%2,0(%3)\n"
-	"	beq	%2,2f\n"
-#ifdef CONFIG_SMP
-	"	mb\n"
-#endif
-	".subsection 2\n"
-	"2:	br	1b\n"
-	".previous"
-	: "=&r" (ret), "=&r" (val), "=&r" (tmp), "=&r" (addr64)
-	: "r" ((long)m), "1" (val) : "memory");
-
-	return ret;
-}
-
-static inline unsigned long
-__xchg_u16(volatile short *m, unsigned long val)
-{
-	unsigned long ret, tmp, addr64;
-
-	__asm__ __volatile__(
-	"	andnot	%4,7,%3\n"
-	"	inswl	%1,%4,%1\n"
-	"1:	ldq_l	%2,0(%3)\n"
-	"	extwl	%2,%4,%0\n"
-	"	mskwl	%2,%4,%2\n"
-	"	or	%1,%2,%2\n"
-	"	stq_c	%2,0(%3)\n"
-	"	beq	%2,2f\n"
-#ifdef CONFIG_SMP
-	"	mb\n"
-#endif
-	".subsection 2\n"
-	"2:	br	1b\n"
-	".previous"
-	: "=&r" (ret), "=&r" (val), "=&r" (tmp), "=&r" (addr64)
-	: "r" ((long)m), "1" (val) : "memory");
-
-	return ret;
-}
-
-static inline unsigned long
-__xchg_u32(volatile int *m, unsigned long val)
-{
-	unsigned long dummy;
-
-	__asm__ __volatile__(
-	"1:	ldl_l %0,%4\n"
-	"	bis $31,%3,%1\n"
-	"	stl_c %1,%2\n"
-	"	beq %1,2f\n"
-#ifdef CONFIG_SMP
-	"	mb\n"
-#endif
-	".subsection 2\n"
-	"2:	br 1b\n"
-	".previous"
-	: "=&r" (val), "=&r" (dummy), "=m" (*m)
-	: "rI" (val), "m" (*m) : "memory");
-
-	return val;
-}
-
-static inline unsigned long
-__xchg_u64(volatile long *m, unsigned long val)
-{
-	unsigned long dummy;
-
-	__asm__ __volatile__(
-	"1:	ldq_l %0,%4\n"
-	"	bis $31,%3,%1\n"
-	"	stq_c %1,%2\n"
-	"	beq %1,2f\n"
-#ifdef CONFIG_SMP
-	"	mb\n"
-#endif
-	".subsection 2\n"
-	"2:	br 1b\n"
-	".previous"
-	: "=&r" (val), "=&r" (dummy), "=m" (*m)
-	: "rI" (val), "m" (*m) : "memory");
-
-	return val;
-}
-
-/* This function doesn't exist, so you'll get a linker error
-   if something tries to do an invalid xchg().  */
-extern void __xchg_called_with_bad_pointer(void);
-
-#define __xchg(ptr, x, size) \
-({ \
-	unsigned long __xchg__res; \
-	volatile void *__xchg__ptr = (ptr); \
-	switch (size) { \
-		case 1: __xchg__res = __xchg_u8(__xchg__ptr, x); break; \
-		case 2: __xchg__res = __xchg_u16(__xchg__ptr, x); break; \
-		case 4: __xchg__res = __xchg_u32(__xchg__ptr, x); break; \
-		case 8: __xchg__res = __xchg_u64(__xchg__ptr, x); break; \
-		default: __xchg_called_with_bad_pointer(); __xchg__res = x; \
-	} \
-	__xchg__res; \
-})
-
-#define xchg(ptr,x)							     \
-  ({									     \
-     __typeof__(*(ptr)) _x_ = (x);					     \
-     (__typeof__(*(ptr))) __xchg((ptr), (unsigned long)_x_, sizeof(*(ptr))); \
-  })
+#define __ASM__MB
+#define ____xchg(type, args...)		__xchg ## type ## _local(args)
+#define ____cmpxchg(type, args...)	__cmpxchg ## type ## _local(args)
+#include <asm/xchg.h>
 
-static inline unsigned long
-__xchg_u8_local(volatile char *m, unsigned long val)
-{
-	unsigned long ret, tmp, addr64;
-
-	__asm__ __volatile__(
-	"	andnot	%4,7,%3\n"
-	"	insbl	%1,%4,%1\n"
-	"1:	ldq_l	%2,0(%3)\n"
-	"	extbl	%2,%4,%0\n"
-	"	mskbl	%2,%4,%2\n"
-	"	or	%1,%2,%2\n"
-	"	stq_c	%2,0(%3)\n"
-	"	beq	%2,2f\n"
-	".subsection 2\n"
-	"2:	br	1b\n"
-	".previous"
-	: "=&r" (ret), "=&r" (val), "=&r" (tmp), "=&r" (addr64)
-	: "r" ((long)m), "1" (val) : "memory");
-
-	return ret;
-}
-
-static inline unsigned long
-__xchg_u16_local(volatile short *m, unsigned long val)
-{
-	unsigned long ret, tmp, addr64;
-
-	__asm__ __volatile__(
-	"	andnot	%4,7,%3\n"
-	"	inswl	%1,%4,%1\n"
-	"1:	ldq_l	%2,0(%3)\n"
-	"	extwl	%2,%4,%0\n"
-	"	mskwl	%2,%4,%2\n"
-	"	or	%1,%2,%2\n"
-	"	stq_c	%2,0(%3)\n"
-	"	beq	%2,2f\n"
-	".subsection 2\n"
-	"2:	br	1b\n"
-	".previous"
-	: "=&r" (ret), "=&r" (val), "=&r" (tmp), "=&r" (addr64)
-	: "r" ((long)m), "1" (val) : "memory");
-
-	return ret;
-}
-
-static inline unsigned long
-__xchg_u32_local(volatile int *m, unsigned long val)
-{
-	unsigned long dummy;
-
-	__asm__ __volatile__(
-	"1:	ldl_l %0,%4\n"
-	"	bis $31,%3,%1\n"
-	"	stl_c %1,%2\n"
-	"	beq %1,2f\n"
-	".subsection 2\n"
-	"2:	br 1b\n"
-	".previous"
-	: "=&r" (val), "=&r" (dummy), "=m" (*m)
-	: "rI" (val), "m" (*m) : "memory");
-
-	return val;
-}
-
-static inline unsigned long
-__xchg_u64_local(volatile long *m, unsigned long val)
-{
-	unsigned long dummy;
-
-	__asm__ __volatile__(
-	"1:	ldq_l %0,%4\n"
-	"	bis $31,%3,%1\n"
-	"	stq_c %1,%2\n"
-	"	beq %1,2f\n"
-	".subsection 2\n"
-	"2:	br 1b\n"
-	".previous"
-	: "=&r" (val), "=&r" (dummy), "=m" (*m)
-	: "rI" (val), "m" (*m) : "memory");
-
-	return val;
-}
-
-#define __xchg_local(ptr, x, size) \
-({ \
-	unsigned long __xchg__res; \
-	volatile void *__xchg__ptr = (ptr); \
-	switch (size) { \
-		case 1: __xchg__res = __xchg_u8_local(__xchg__ptr, x); break; \
-		case 2: __xchg__res = __xchg_u16_local(__xchg__ptr, x); break; \
-		case 4: __xchg__res = __xchg_u32_local(__xchg__ptr, x); break; \
-		case 8: __xchg__res = __xchg_u64_local(__xchg__ptr, x); break; \
-		default: __xchg_called_with_bad_pointer(); __xchg__res = x; \
-	} \
-	__xchg__res; \
-})
-
-#define xchg_local(ptr,x)						     \
-  ({									     \
-     __typeof__(*(ptr)) _x_ = (x);					     \
-     (__typeof__(*(ptr))) __xchg_local((ptr), (unsigned long)_x_,	     \
-     		sizeof(*(ptr))); \
+#define xchg_local(ptr,x)						\
+  ({									\
+     __typeof__(*(ptr)) _x_ = (x);					\
+     (__typeof__(*(ptr))) __xchg_local((ptr), (unsigned long)_x_,	\
+				       sizeof(*(ptr)));			\
   })
 
-/* 
- * Atomic compare and exchange.  Compare OLD with MEM, if identical,
- * store NEW in MEM.  Return the initial value in MEM.  Success is
- * indicated by comparing RETURN with OLD.
- *
- * The memory barrier should be placed in SMP only when we actually
- * make the change. If we don't change anything (so if the returned
- * prev is equal to old) then we aren't acquiring anything new and
- * we don't need any memory barrier as far I can tell.
- */
+#define cmpxchg_local(ptr, o, n)					\
+  ({									\
+     __typeof__(*(ptr)) _o_ = (o);					\
+     __typeof__(*(ptr)) _n_ = (n);					\
+     (__typeof__(*(ptr))) __cmpxchg_local((ptr), (unsigned long)_o_,	\
+					  (unsigned long)_n_,		\
+					  sizeof(*(ptr)));		\
+  })
 
-#define __HAVE_ARCH_CMPXCHG 1
+#define cmpxchg64_local(ptr, o, n)					\
+  ({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	cmpxchg_local((ptr), (o), (n));					\
+  })
 
-static inline unsigned long
-__cmpxchg_u8(volatile char *m, long old, long new)
-{
-	unsigned long prev, tmp, cmp, addr64;
-
-	__asm__ __volatile__(
-	"	andnot	%5,7,%4\n"
-	"	insbl	%1,%5,%1\n"
-	"1:	ldq_l	%2,0(%4)\n"
-	"	extbl	%2,%5,%0\n"
-	"	cmpeq	%0,%6,%3\n"
-	"	beq	%3,2f\n"
-	"	mskbl	%2,%5,%2\n"
-	"	or	%1,%2,%2\n"
-	"	stq_c	%2,0(%4)\n"
-	"	beq	%2,3f\n"
-#ifdef CONFIG_SMP
-	"	mb\n"
-#endif
-	"2:\n"
-	".subsection 2\n"
-	"3:	br	1b\n"
-	".previous"
-	: "=&r" (prev), "=&r" (new), "=&r" (tmp), "=&r" (cmp), "=&r" (addr64)
-	: "r" ((long)m), "Ir" (old), "1" (new) : "memory");
-
-	return prev;
-}
-
-static inline unsigned long
-__cmpxchg_u16(volatile short *m, long old, long new)
-{
-	unsigned long prev, tmp, cmp, addr64;
-
-	__asm__ __volatile__(
-	"	andnot	%5,7,%4\n"
-	"	inswl	%1,%5,%1\n"
-	"1:	ldq_l	%2,0(%4)\n"
-	"	extwl	%2,%5,%0\n"
-	"	cmpeq	%0,%6,%3\n"
-	"	beq	%3,2f\n"
-	"	mskwl	%2,%5,%2\n"
-	"	or	%1,%2,%2\n"
-	"	stq_c	%2,0(%4)\n"
-	"	beq	%2,3f\n"
-#ifdef CONFIG_SMP
-	"	mb\n"
-#endif
-	"2:\n"
-	".subsection 2\n"
-	"3:	br	1b\n"
-	".previous"
-	: "=&r" (prev), "=&r" (new), "=&r" (tmp), "=&r" (cmp), "=&r" (addr64)
-	: "r" ((long)m), "Ir" (old), "1" (new) : "memory");
-
-	return prev;
-}
-
-static inline unsigned long
-__cmpxchg_u32(volatile int *m, int old, int new)
-{
-	unsigned long prev, cmp;
-
-	__asm__ __volatile__(
-	"1:	ldl_l %0,%5\n"
-	"	cmpeq %0,%3,%1\n"
-	"	beq %1,2f\n"
-	"	mov %4,%1\n"
-	"	stl_c %1,%2\n"
-	"	beq %1,3f\n"
-#ifdef CONFIG_SMP
-	"	mb\n"
-#endif
-	"2:\n"
-	".subsection 2\n"
-	"3:	br 1b\n"
-	".previous"
-	: "=&r"(prev), "=&r"(cmp), "=m"(*m)
-	: "r"((long) old), "r"(new), "m"(*m) : "memory");
-
-	return prev;
-}
-
-static inline unsigned long
-__cmpxchg_u64(volatile long *m, unsigned long old, unsigned long new)
-{
-	unsigned long prev, cmp;
-
-	__asm__ __volatile__(
-	"1:	ldq_l %0,%5\n"
-	"	cmpeq %0,%3,%1\n"
-	"	beq %1,2f\n"
-	"	mov %4,%1\n"
-	"	stq_c %1,%2\n"
-	"	beq %1,3f\n"
 #ifdef CONFIG_SMP
-	"	mb\n"
+#undef __ASM__MB
+#define __ASM__MB	"\tmb\n"
 #endif
-	"2:\n"
-	".subsection 2\n"
-	"3:	br 1b\n"
-	".previous"
-	: "=&r"(prev), "=&r"(cmp), "=m"(*m)
-	: "r"((long) old), "r"(new), "m"(*m) : "memory");
-
-	return prev;
-}
-
-/* This function doesn't exist, so you'll get a linker error
-   if something tries to do an invalid cmpxchg().  */
-extern void __cmpxchg_called_with_bad_pointer(void);
-
-static __always_inline unsigned long
-__cmpxchg(volatile void *ptr, unsigned long old, unsigned long new, int size)
-{
-	switch (size) {
-		case 1:
-			return __cmpxchg_u8(ptr, old, new);
-		case 2:
-			return __cmpxchg_u16(ptr, old, new);
-		case 4:
-			return __cmpxchg_u32(ptr, old, new);
-		case 8:
-			return __cmpxchg_u64(ptr, old, new);
-	}
-	__cmpxchg_called_with_bad_pointer();
-	return old;
-}
-
-#define cmpxchg(ptr, o, n)						 \
-  ({									 \
-     __typeof__(*(ptr)) _o_ = (o);					 \
-     __typeof__(*(ptr)) _n_ = (n);					 \
-     (__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,		 \
-				    (unsigned long)_n_, sizeof(*(ptr))); \
-  })
-#define cmpxchg64(ptr, o, n)						 \
-  ({									 \
-	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				 \
-	cmpxchg((ptr), (o), (n));					 \
+#undef ____xchg
+#undef ____cmpxchg
+#define ____xchg(type, args...)		__xchg ##type(args)
+#define ____cmpxchg(type, args...)	__cmpxchg ##type(args)
+#include <asm/xchg.h>
+
+#define xchg(ptr,x)							\
+  ({									\
+     __typeof__(*(ptr)) _x_ = (x);					\
+     (__typeof__(*(ptr))) __xchg((ptr), (unsigned long)_x_,		\
+				 sizeof(*(ptr)));			\
   })
 
-static inline unsigned long
-__cmpxchg_u8_local(volatile char *m, long old, long new)
-{
-	unsigned long prev, tmp, cmp, addr64;
-
-	__asm__ __volatile__(
-	"	andnot	%5,7,%4\n"
-	"	insbl	%1,%5,%1\n"
-	"1:	ldq_l	%2,0(%4)\n"
-	"	extbl	%2,%5,%0\n"
-	"	cmpeq	%0,%6,%3\n"
-	"	beq	%3,2f\n"
-	"	mskbl	%2,%5,%2\n"
-	"	or	%1,%2,%2\n"
-	"	stq_c	%2,0(%4)\n"
-	"	beq	%2,3f\n"
-	"2:\n"
-	".subsection 2\n"
-	"3:	br	1b\n"
-	".previous"
-	: "=&r" (prev), "=&r" (new), "=&r" (tmp), "=&r" (cmp), "=&r" (addr64)
-	: "r" ((long)m), "Ir" (old), "1" (new) : "memory");
-
-	return prev;
-}
-
-static inline unsigned long
-__cmpxchg_u16_local(volatile short *m, long old, long new)
-{
-	unsigned long prev, tmp, cmp, addr64;
-
-	__asm__ __volatile__(
-	"	andnot	%5,7,%4\n"
-	"	inswl	%1,%5,%1\n"
-	"1:	ldq_l	%2,0(%4)\n"
-	"	extwl	%2,%5,%0\n"
-	"	cmpeq	%0,%6,%3\n"
-	"	beq	%3,2f\n"
-	"	mskwl	%2,%5,%2\n"
-	"	or	%1,%2,%2\n"
-	"	stq_c	%2,0(%4)\n"
-	"	beq	%2,3f\n"
-	"2:\n"
-	".subsection 2\n"
-	"3:	br	1b\n"
-	".previous"
-	: "=&r" (prev), "=&r" (new), "=&r" (tmp), "=&r" (cmp), "=&r" (addr64)
-	: "r" ((long)m), "Ir" (old), "1" (new) : "memory");
-
-	return prev;
-}
-
-static inline unsigned long
-__cmpxchg_u32_local(volatile int *m, int old, int new)
-{
-	unsigned long prev, cmp;
-
-	__asm__ __volatile__(
-	"1:	ldl_l %0,%5\n"
-	"	cmpeq %0,%3,%1\n"
-	"	beq %1,2f\n"
-	"	mov %4,%1\n"
-	"	stl_c %1,%2\n"
-	"	beq %1,3f\n"
-	"2:\n"
-	".subsection 2\n"
-	"3:	br 1b\n"
-	".previous"
-	: "=&r"(prev), "=&r"(cmp), "=m"(*m)
-	: "r"((long) old), "r"(new), "m"(*m) : "memory");
-
-	return prev;
-}
-
-static inline unsigned long
-__cmpxchg_u64_local(volatile long *m, unsigned long old, unsigned long new)
-{
-	unsigned long prev, cmp;
-
-	__asm__ __volatile__(
-	"1:	ldq_l %0,%5\n"
-	"	cmpeq %0,%3,%1\n"
-	"	beq %1,2f\n"
-	"	mov %4,%1\n"
-	"	stq_c %1,%2\n"
-	"	beq %1,3f\n"
-	"2:\n"
-	".subsection 2\n"
-	"3:	br 1b\n"
-	".previous"
-	: "=&r"(prev), "=&r"(cmp), "=m"(*m)
-	: "r"((long) old), "r"(new), "m"(*m) : "memory");
-
-	return prev;
-}
-
-static __always_inline unsigned long
-__cmpxchg_local(volatile void *ptr, unsigned long old, unsigned long new,
-		int size)
-{
-	switch (size) {
-		case 1:
-			return __cmpxchg_u8_local(ptr, old, new);
-		case 2:
-			return __cmpxchg_u16_local(ptr, old, new);
-		case 4:
-			return __cmpxchg_u32_local(ptr, old, new);
-		case 8:
-			return __cmpxchg_u64_local(ptr, old, new);
-	}
-	__cmpxchg_called_with_bad_pointer();
-	return old;
-}
-
-#define cmpxchg_local(ptr, o, n)					 \
-  ({									 \
-     __typeof__(*(ptr)) _o_ = (o);					 \
-     __typeof__(*(ptr)) _n_ = (n);					 \
-     (__typeof__(*(ptr))) __cmpxchg_local((ptr), (unsigned long)_o_,	 \
-				    (unsigned long)_n_, sizeof(*(ptr))); \
+#define cmpxchg(ptr, o, n)						\
+  ({									\
+     __typeof__(*(ptr)) _o_ = (o);					\
+     __typeof__(*(ptr)) _n_ = (n);					\
+     (__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,		\
+				    (unsigned long)_n_,	sizeof(*(ptr)));\
   })
-#define cmpxchg64_local(ptr, o, n)					 \
-  ({									 \
-	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				 \
-	cmpxchg_local((ptr), (o), (n));					 \
+
+#define cmpxchg64(ptr, o, n)						\
+  ({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	cmpxchg((ptr), (o), (n));					\
   })
 
+#undef __ASM__MB
+#undef ____cmpxchg
+
+#define __HAVE_ARCH_CMPXCHG 1
 
 #endif /* __ASSEMBLY__ */
 
diff -puN /dev/null arch/alpha/include/asm/xchg.h
--- /dev/null
+++ a/arch/alpha/include/asm/xchg.h
@@ -0,0 +1,258 @@
+#ifndef __ALPHA_SYSTEM_H
+#error Do not include xchg.h directly!
+#else
+/*
+ * xchg/xchg_local and cmpxchg/cmpxchg_local share the same code
+ * except that local version do not have the expensive memory barrier.
+ * So this file is included twice from asm/system.h.
+ */
+
+/*
+ * Atomic exchange.
+ * Since it can be used to implement critical sections
+ * it must clobber "memory" (also for interrupts in UP).
+ */
+
+static inline unsigned long
+____xchg(_u8, volatile char *m, unsigned long val)
+{
+	unsigned long ret, tmp, addr64;
+
+	__asm__ __volatile__(
+	"	andnot	%4,7,%3\n"
+	"	insbl	%1,%4,%1\n"
+	"1:	ldq_l	%2,0(%3)\n"
+	"	extbl	%2,%4,%0\n"
+	"	mskbl	%2,%4,%2\n"
+	"	or	%1,%2,%2\n"
+	"	stq_c	%2,0(%3)\n"
+	"	beq	%2,2f\n"
+		__ASM__MB
+	".subsection 2\n"
+	"2:	br	1b\n"
+	".previous"
+	: "=&r" (ret), "=&r" (val), "=&r" (tmp), "=&r" (addr64)
+	: "r" ((long)m), "1" (val) : "memory");
+
+	return ret;
+}
+
+static inline unsigned long
+____xchg(_u16, volatile short *m, unsigned long val)
+{
+	unsigned long ret, tmp, addr64;
+
+	__asm__ __volatile__(
+	"	andnot	%4,7,%3\n"
+	"	inswl	%1,%4,%1\n"
+	"1:	ldq_l	%2,0(%3)\n"
+	"	extwl	%2,%4,%0\n"
+	"	mskwl	%2,%4,%2\n"
+	"	or	%1,%2,%2\n"
+	"	stq_c	%2,0(%3)\n"
+	"	beq	%2,2f\n"
+		__ASM__MB
+	".subsection 2\n"
+	"2:	br	1b\n"
+	".previous"
+	: "=&r" (ret), "=&r" (val), "=&r" (tmp), "=&r" (addr64)
+	: "r" ((long)m), "1" (val) : "memory");
+
+	return ret;
+}
+
+static inline unsigned long
+____xchg(_u32, volatile int *m, unsigned long val)
+{
+	unsigned long dummy;
+
+	__asm__ __volatile__(
+	"1:	ldl_l %0,%4\n"
+	"	bis $31,%3,%1\n"
+	"	stl_c %1,%2\n"
+	"	beq %1,2f\n"
+		__ASM__MB
+	".subsection 2\n"
+	"2:	br 1b\n"
+	".previous"
+	: "=&r" (val), "=&r" (dummy), "=m" (*m)
+	: "rI" (val), "m" (*m) : "memory");
+
+	return val;
+}
+
+static inline unsigned long
+____xchg(_u64, volatile long *m, unsigned long val)
+{
+	unsigned long dummy;
+
+	__asm__ __volatile__(
+	"1:	ldq_l %0,%4\n"
+	"	bis $31,%3,%1\n"
+	"	stq_c %1,%2\n"
+	"	beq %1,2f\n"
+		__ASM__MB
+	".subsection 2\n"
+	"2:	br 1b\n"
+	".previous"
+	: "=&r" (val), "=&r" (dummy), "=m" (*m)
+	: "rI" (val), "m" (*m) : "memory");
+
+	return val;
+}
+
+/* This function doesn't exist, so you'll get a linker error
+   if something tries to do an invalid xchg().  */
+extern void __xchg_called_with_bad_pointer(void);
+
+static __always_inline unsigned long
+____xchg(, volatile void *ptr, unsigned long x, int size)
+{
+	switch (size) {
+		case 1:
+			return ____xchg(_u8, ptr, x);
+		case 2:
+			return ____xchg(_u16, ptr, x);
+		case 4:
+			return ____xchg(_u32, ptr, x);
+		case 8:
+			return ____xchg(_u64, ptr, x);
+	}
+	__xchg_called_with_bad_pointer();
+	return x;
+}
+
+/*
+ * Atomic compare and exchange.  Compare OLD with MEM, if identical,
+ * store NEW in MEM.  Return the initial value in MEM.  Success is
+ * indicated by comparing RETURN with OLD.
+ *
+ * The memory barrier should be placed in SMP only when we actually
+ * make the change. If we don't change anything (so if the returned
+ * prev is equal to old) then we aren't acquiring anything new and
+ * we don't need any memory barrier as far I can tell.
+ */
+
+static inline unsigned long
+____cmpxchg(_u8, volatile char *m, unsigned char old, unsigned char new)
+{
+	unsigned long prev, tmp, cmp, addr64;
+
+	__asm__ __volatile__(
+	"	andnot	%5,7,%4\n"
+	"	insbl	%1,%5,%1\n"
+	"1:	ldq_l	%2,0(%4)\n"
+	"	extbl	%2,%5,%0\n"
+	"	cmpeq	%0,%6,%3\n"
+	"	beq	%3,2f\n"
+	"	mskbl	%2,%5,%2\n"
+	"	or	%1,%2,%2\n"
+	"	stq_c	%2,0(%4)\n"
+	"	beq	%2,3f\n"
+		__ASM__MB
+	"2:\n"
+	".subsection 2\n"
+	"3:	br	1b\n"
+	".previous"
+	: "=&r" (prev), "=&r" (new), "=&r" (tmp), "=&r" (cmp), "=&r" (addr64)
+	: "r" ((long)m), "Ir" (old), "1" (new) : "memory");
+
+	return prev;
+}
+
+static inline unsigned long
+____cmpxchg(_u16, volatile short *m, unsigned short old, unsigned short new)
+{
+	unsigned long prev, tmp, cmp, addr64;
+
+	__asm__ __volatile__(
+	"	andnot	%5,7,%4\n"
+	"	inswl	%1,%5,%1\n"
+	"1:	ldq_l	%2,0(%4)\n"
+	"	extwl	%2,%5,%0\n"
+	"	cmpeq	%0,%6,%3\n"
+	"	beq	%3,2f\n"
+	"	mskwl	%2,%5,%2\n"
+	"	or	%1,%2,%2\n"
+	"	stq_c	%2,0(%4)\n"
+	"	beq	%2,3f\n"
+		__ASM__MB
+	"2:\n"
+	".subsection 2\n"
+	"3:	br	1b\n"
+	".previous"
+	: "=&r" (prev), "=&r" (new), "=&r" (tmp), "=&r" (cmp), "=&r" (addr64)
+	: "r" ((long)m), "Ir" (old), "1" (new) : "memory");
+
+	return prev;
+}
+
+static inline unsigned long
+____cmpxchg(_u32, volatile int *m, int old, int new)
+{
+	unsigned long prev, cmp;
+
+	__asm__ __volatile__(
+	"1:	ldl_l %0,%5\n"
+	"	cmpeq %0,%3,%1\n"
+	"	beq %1,2f\n"
+	"	mov %4,%1\n"
+	"	stl_c %1,%2\n"
+	"	beq %1,3f\n"
+		__ASM__MB
+	"2:\n"
+	".subsection 2\n"
+	"3:	br 1b\n"
+	".previous"
+	: "=&r"(prev), "=&r"(cmp), "=m"(*m)
+	: "r"((long) old), "r"(new), "m"(*m) : "memory");
+
+	return prev;
+}
+
+static inline unsigned long
+____cmpxchg(_u64, volatile long *m, unsigned long old, unsigned long new)
+{
+	unsigned long prev, cmp;
+
+	__asm__ __volatile__(
+	"1:	ldq_l %0,%5\n"
+	"	cmpeq %0,%3,%1\n"
+	"	beq %1,2f\n"
+	"	mov %4,%1\n"
+	"	stq_c %1,%2\n"
+	"	beq %1,3f\n"
+		__ASM__MB
+	"2:\n"
+	".subsection 2\n"
+	"3:	br 1b\n"
+	".previous"
+	: "=&r"(prev), "=&r"(cmp), "=m"(*m)
+	: "r"((long) old), "r"(new), "m"(*m) : "memory");
+
+	return prev;
+}
+
+/* This function doesn't exist, so you'll get a linker error
+   if something tries to do an invalid cmpxchg().  */
+extern void __cmpxchg_called_with_bad_pointer(void);
+
+static __always_inline unsigned long
+____cmpxchg(, volatile void *ptr, unsigned long old, unsigned long new,
+	      int size)
+{
+	switch (size) {
+		case 1:
+			return ____cmpxchg(_u8, ptr, old, new);
+		case 2:
+			return ____cmpxchg(_u16, ptr, old, new);
+		case 4:
+			return ____cmpxchg(_u32, ptr, old, new);
+		case 8:
+			return ____cmpxchg(_u64, ptr, old, new);
+	}
+	__cmpxchg_called_with_bad_pointer();
+	return old;
+}
+
+#endif
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

origin.patch
make-sure-nobodys-leaking-resources.patch

