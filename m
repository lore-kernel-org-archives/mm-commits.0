From: akpm@linux-foundation.org
Subject: [merged] atomic-move-atomic_add_unless-to-generic-code.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:29:57 -0700
Message-ID: <201107271928.p6RJSiDA003327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755070Ab1G0T3X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:29:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: asharma@fb.com, davem@davemloft.net, eric.dumazet@gmail.com, hans-christian.egtvedt@atmel.com, mingo@elte.hu, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     atomic: move atomic_add_unless to generic code
has been removed from the -mm tree.  Its filename was
     atomic-move-atomic_add_unless-to-generic-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atomic: move atomic_add_unless to generic code
From: Arun Sharma <asharma@fb.com>

This is in preparation for more generic atomic
primitives based on __atomic_add_unless.

Signed-off-by: Arun Sharma <asharma@fb.com>
Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Reviewed-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/atomic.h    |   10 ++--
 arch/arm/include/asm/atomic.h      |    4 -
 arch/avr32/include/asm/atomic.h    |   57 +++++++++++----------------
 arch/blackfin/include/asm/atomic.h |    4 -
 arch/cris/include/asm/atomic.h     |    4 -
 arch/frv/include/asm/atomic.h      |    4 -
 arch/h8300/include/asm/atomic.h    |    4 -
 arch/ia64/include/asm/atomic.h     |    4 -
 arch/m32r/include/asm/atomic.h     |    8 +--
 arch/m68k/include/asm/atomic.h     |    4 -
 arch/mips/include/asm/atomic.h     |   10 ++--
 arch/mn10300/include/asm/atomic.h  |    4 -
 arch/parisc/include/asm/atomic.h   |   10 ++--
 arch/powerpc/include/asm/atomic.h  |   14 +++---
 arch/s390/include/asm/atomic.h     |    4 -
 arch/sh/include/asm/atomic.h       |    8 +--
 arch/sparc/include/asm/atomic_32.h |    2 
 arch/sparc/include/asm/atomic_64.h |    4 -
 arch/tile/include/asm/atomic_32.h  |   10 ++--
 arch/tile/include/asm/atomic_64.h  |    4 -
 arch/x86/include/asm/atomic.h      |    8 +--
 arch/x86/include/asm/atomic64_32.h |    2 
 arch/x86/include/asm/atomic64_64.h |    2 
 arch/xtensa/include/asm/atomic.h   |    8 +--
 include/asm-generic/atomic.h       |    4 -
 include/linux/atomic.h             |   14 ++++++
 26 files changed, 109 insertions(+), 102 deletions(-)

diff -puN arch/alpha/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code arch/alpha/include/asm/atomic.h
--- a/arch/alpha/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code
+++ a/arch/alpha/include/asm/atomic.h
@@ -176,15 +176,15 @@ static __inline__ long atomic64_sub_retu
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
 /**
- * atomic_add_unless - add unless the number is a given value
+ * __atomic_add_unless - add unless the number is a given value
  * @v: pointer of type atomic_t
  * @a: the amount to add to v...
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
-static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
 	c = atomic_read(v);
@@ -196,7 +196,7 @@ static __inline__ int atomic_add_unless(
 			break;
 		c = old;
 	}
-	return c != (u);
+	return c;
 }
 
 
@@ -207,7 +207,7 @@ static __inline__ int atomic_add_unless(
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
 static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
 {
diff -puN arch/arm/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code arch/arm/include/asm/atomic.h
--- a/arch/arm/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code
+++ a/arch/arm/include/asm/atomic.h
@@ -208,14 +208,14 @@ static inline void atomic_clear_mask(uns
 
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
-static inline int atomic_add_unless(atomic_t *v, int a, int u)
+static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
 
 	c = atomic_read(v);
 	while (c != u && (old = atomic_cmpxchg((v), c, c + a)) != c)
 		c = old;
-	return c != u;
+	return c;
 }
 
 #define atomic_inc(v)		atomic_add(1, v)
diff -puN arch/avr32/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code arch/avr32/include/asm/atomic.h
--- a/arch/avr32/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code
+++ a/arch/avr32/include/asm/atomic.h
@@ -78,70 +78,63 @@ static inline int atomic_add_return(int 
 /*
  * atomic_sub_unless - sub unless the number is a given value
  * @v: pointer of type atomic_t
- * @a: the amount to add to v...
+ * @a: the amount to subtract from v...
  * @u: ...unless v is equal to u.
  *
- * If the atomic value v is not equal to u, this function subtracts a
- * from v, and returns non zero. If v is equal to u then it returns
- * zero. This is done as an atomic operation.
+ * Atomically subtract @a from @v, so long as it was not @u.
+ * Returns the old value of @v.
 */
-static inline int atomic_sub_unless(atomic_t *v, int a, int u)
+static inline void atomic_sub_unless(atomic_t *v, int a, int u)
 {
-	int tmp, result = 0;
+	int tmp;
 
 	asm volatile(
 		"/* atomic_sub_unless */\n"
 		"1:	ssrf	5\n"
-		"	ld.w	%0, %3\n"
-		"	cp.w	%0, %5\n"
+		"	ld.w	%0, %2\n"
+		"	cp.w	%0, %4\n"
 		"	breq	1f\n"
-		"	sub	%0, %4\n"
-		"	stcond	%2, %0\n"
+		"	sub	%0, %3\n"
+		"	stcond	%1, %0\n"
 		"	brne	1b\n"
-		"	mov	%1, 1\n"
 		"1:"
-		: "=&r"(tmp), "=&r"(result), "=o"(v->counter)
-		: "m"(v->counter), "rKs21"(a), "rKs21"(u), "1"(result)
+		: "=&r"(tmp), "=o"(v->counter)
+		: "m"(v->counter), "rKs21"(a), "rKs21"(u)
 		: "cc", "memory");
-
-	return result;
 }
 
 /*
- * atomic_add_unless - add unless the number is a given value
+ * __atomic_add_unless - add unless the number is a given value
  * @v: pointer of type atomic_t
  * @a: the amount to add to v...
  * @u: ...unless v is equal to u.
  *
- * If the atomic value v is not equal to u, this function adds a to v,
- * and returns non zero. If v is equal to u then it returns zero. This
- * is done as an atomic operation.
+ * Atomically adds @a to @v, so long as it was not @u.
+ * Returns the old value of @v.
 */
-static inline int atomic_add_unless(atomic_t *v, int a, int u)
+static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
-	int tmp, result;
+	int tmp, old = atomic_read(v);
 
 	if (__builtin_constant_p(a) && (a >= -1048575) && (a <= 1048576))
-		result = atomic_sub_unless(v, -a, u);
+		atomic_sub_unless(v, -a, u);
 	else {
-		result = 0;
 		asm volatile(
-			"/* atomic_add_unless */\n"
+			"/* __atomic_add_unless */\n"
 			"1:	ssrf	5\n"
-			"	ld.w	%0, %3\n"
-			"	cp.w	%0, %5\n"
+			"	ld.w	%0, %2\n"
+			"	cp.w	%0, %4\n"
 			"	breq	1f\n"
-			"	add	%0, %4\n"
-			"	stcond	%2, %0\n"
+			"	add	%0, %3\n"
+			"	stcond	%1, %0\n"
 			"	brne	1b\n"
-			"	mov	%1, 1\n"
 			"1:"
-			: "=&r"(tmp), "=&r"(result), "=o"(v->counter)
-			: "m"(v->counter), "r"(a), "ir"(u), "1"(result)
+			: "=&r"(tmp), "=o"(v->counter)
+			: "m"(v->counter), "r"(a), "ir"(u)
 			: "cc", "memory");
 	}
 
-	return result;
+	return old;
 }
 
 /*
diff -puN arch/blackfin/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code arch/blackfin/include/asm/atomic.h
--- a/arch/blackfin/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code
+++ a/arch/blackfin/include/asm/atomic.h
@@ -89,13 +89,13 @@ static inline void atomic_set_mask(int m
 #define atomic_cmpxchg(v, o, n) ((int)cmpxchg(&((v)->counter), (o), (n)))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
-#define atomic_add_unless(v, a, u)				\
+#define __atomic_add_unless(v, a, u)				\
 ({								\
 	int c, old;						\
 	c = atomic_read(v);					\
 	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
 		c = old;					\
-	c != (u);						\
+	c;							\
 })
 
 /*
diff -puN arch/cris/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code arch/cris/include/asm/atomic.h
--- a/arch/cris/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code
+++ a/arch/cris/include/asm/atomic.h
@@ -138,7 +138,7 @@ static inline int atomic_cmpxchg(atomic_
 
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
-static inline int atomic_add_unless(atomic_t *v, int a, int u)
+static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int ret;
 	unsigned long flags;
@@ -148,7 +148,7 @@ static inline int atomic_add_unless(atom
 	if (ret != u)
 		v->counter += a;
 	cris_atomic_restore(v, flags);
-	return ret != u;
+	return ret;
 }
 
 /* Atomic operations are already serializing */
diff -puN arch/frv/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code arch/frv/include/asm/atomic.h
--- a/arch/frv/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code
+++ a/arch/frv/include/asm/atomic.h
@@ -241,7 +241,7 @@ extern uint32_t __xchg_32(uint32_t i, vo
 #define atomic64_cmpxchg(v, old, new)	(__cmpxchg_64(old, new, &(v)->counter))
 #define atomic64_xchg(v, new)		(__xchg_64(new, &(v)->counter))
 
-static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
 	c = atomic_read(v);
@@ -253,7 +253,7 @@ static __inline__ int atomic_add_unless(
 			break;
 		c = old;
 	}
-	return c != (u);
+	return c;
 }
 
 
diff -puN arch/h8300/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code arch/h8300/include/asm/atomic.h
--- a/arch/h8300/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code
+++ a/arch/h8300/include/asm/atomic.h
@@ -104,7 +104,7 @@ static inline int atomic_cmpxchg(atomic_
 
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
-static inline int atomic_add_unless(atomic_t *v, int a, int u)
+static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int ret;
 	unsigned long flags;
@@ -114,7 +114,7 @@ static inline int atomic_add_unless(atom
 	if (ret != u)
 		v->counter += a;
 	local_irq_restore(flags);
-	return ret != u;
+	return ret;
 }
 
 static __inline__ void atomic_clear_mask(unsigned long mask, unsigned long *v)
diff -puN arch/ia64/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code arch/ia64/include/asm/atomic.h
--- a/arch/ia64/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code
+++ a/arch/ia64/include/asm/atomic.h
@@ -90,7 +90,7 @@ ia64_atomic64_sub (__s64 i, atomic64_t *
 	(cmpxchg(&((v)->counter), old, new))
 #define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
 
-static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
 	c = atomic_read(v);
@@ -102,7 +102,7 @@ static __inline__ int atomic_add_unless(
 			break;
 		c = old;
 	}
-	return c != (u);
+	return c;
 }
 
 
diff -puN arch/m32r/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code arch/m32r/include/asm/atomic.h
--- a/arch/m32r/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code
+++ a/arch/m32r/include/asm/atomic.h
@@ -239,15 +239,15 @@ static __inline__ int atomic_dec_return(
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
 /**
- * atomic_add_unless - add unless the number is a given value
+ * __atomic_add_unless - add unless the number is a given value
  * @v: pointer of type atomic_t
  * @a: the amount to add to v...
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
-static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
 	c = atomic_read(v);
@@ -259,7 +259,7 @@ static __inline__ int atomic_add_unless(
 			break;
 		c = old;
 	}
-	return c != (u);
+	return c;
 }
 
 
diff -puN arch/m68k/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code arch/m68k/include/asm/atomic.h
--- a/arch/m68k/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code
+++ a/arch/m68k/include/asm/atomic.h
@@ -183,7 +183,7 @@ static inline void atomic_set_mask(unsig
 	__asm__ __volatile__("orl %1,%0" : "+m" (*v) : ASM_DI (mask));
 }
 
-static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
 	c = atomic_read(v);
@@ -195,7 +195,7 @@ static __inline__ int atomic_add_unless(
 			break;
 		c = old;
 	}
-	return c != (u);
+	return c;
 }
 
 
diff -puN arch/mips/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code arch/mips/include/asm/atomic.h
--- a/arch/mips/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code
+++ a/arch/mips/include/asm/atomic.h
@@ -303,15 +303,15 @@ static __inline__ int atomic_sub_if_posi
 #define atomic_xchg(v, new) (xchg(&((v)->counter), (new)))
 
 /**
- * atomic_add_unless - add unless the number is a given value
+ * __atomic_add_unless - add unless the number is a given value
  * @v: pointer of type atomic_t
  * @a: the amount to add to v...
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
-static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
 	c = atomic_read(v);
@@ -323,7 +323,7 @@ static __inline__ int atomic_add_unless(
 			break;
 		c = old;
 	}
-	return c != (u);
+	return c;
 }
 
 #define atomic_dec_return(v) atomic_sub_return(1, (v))
@@ -679,7 +679,7 @@ static __inline__ long atomic64_sub_if_p
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
 static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
 {
diff -puN arch/mn10300/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code arch/mn10300/include/asm/atomic.h
--- a/arch/mn10300/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code
+++ a/arch/mn10300/include/asm/atomic.h
@@ -260,13 +260,13 @@ static inline void atomic_dec(atomic_t *
 #define atomic_dec_and_test(v)		(atomic_sub_return(1, (v)) == 0)
 #define atomic_inc_and_test(v)		(atomic_add_return(1, (v)) == 0)
 
-#define atomic_add_unless(v, a, u)				\
+#define __atomic_add_unless(v, a, u)				\
 ({								\
 	int c, old;						\
 	c = atomic_read(v);					\
 	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
 		c = old;					\
-	c != (u);						\
+	c;							\
 })
 
 
diff -puN arch/parisc/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code arch/parisc/include/asm/atomic.h
--- a/arch/parisc/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code
+++ a/arch/parisc/include/asm/atomic.h
@@ -197,15 +197,15 @@ static __inline__ int atomic_read(const 
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
 /**
- * atomic_add_unless - add unless the number is a given value
+ * __atomic_add_unless - add unless the number is a given value
  * @v: pointer of type atomic_t
  * @a: the amount to add to v...
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
-static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
 	c = atomic_read(v);
@@ -217,7 +217,7 @@ static __inline__ int atomic_add_unless(
 			break;
 		c = old;
 	}
-	return c != (u);
+	return c;
 }
 
 
@@ -316,7 +316,7 @@ atomic64_read(const atomic64_t *v)
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
 static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
 {
diff -puN arch/powerpc/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code arch/powerpc/include/asm/atomic.h
--- a/arch/powerpc/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code
+++ a/arch/powerpc/include/asm/atomic.h
@@ -181,21 +181,21 @@ static __inline__ int atomic_dec_return(
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
 /**
- * atomic_add_unless - add unless the number is a given value
+ * __atomic_add_unless - add unless the number is a given value
  * @v: pointer of type atomic_t
  * @a: the amount to add to v...
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
-static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int t;
 
 	__asm__ __volatile__ (
 	PPC_RELEASE_BARRIER
-"1:	lwarx	%0,0,%1		# atomic_add_unless\n\
+"1:	lwarx	%0,0,%1		# __atomic_add_unless\n\
 	cmpw	0,%0,%3 \n\
 	beq-	2f \n\
 	add	%0,%2,%0 \n"
@@ -209,7 +209,7 @@ static __inline__ int atomic_add_unless(
 	: "r" (&v->counter), "r" (a), "r" (u)
 	: "cc", "memory");
 
-	return t != u;
+	return t;
 }
 
 
@@ -443,7 +443,7 @@ static __inline__ long atomic64_dec_if_p
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
 static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
 {
@@ -451,7 +451,7 @@ static __inline__ int atomic64_add_unles
 
 	__asm__ __volatile__ (
 	PPC_RELEASE_BARRIER
-"1:	ldarx	%0,0,%1		# atomic_add_unless\n\
+"1:	ldarx	%0,0,%1		# __atomic_add_unless\n\
 	cmpd	0,%0,%3 \n\
 	beq-	2f \n\
 	add	%0,%2,%0 \n"
diff -puN arch/s390/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code arch/s390/include/asm/atomic.h
--- a/arch/s390/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code
+++ a/arch/s390/include/asm/atomic.h
@@ -93,7 +93,7 @@ static inline int atomic_cmpxchg(atomic_
 	return old;
 }
 
-static inline int atomic_add_unless(atomic_t *v, int a, int u)
+static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
 	c = atomic_read(v);
@@ -105,7 +105,7 @@ static inline int atomic_add_unless(atom
 			break;
 		c = old;
 	}
-	return c != u;
+	return c;
 }
 
 
diff -puN arch/sh/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code arch/sh/include/asm/atomic.h
--- a/arch/sh/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code
+++ a/arch/sh/include/asm/atomic.h
@@ -38,15 +38,15 @@
 #define atomic_cmpxchg(v, o, n)		(cmpxchg(&((v)->counter), (o), (n)))
 
 /**
- * atomic_add_unless - add unless the number is a given value
+ * __atomic_add_unless - add unless the number is a given value
  * @v: pointer of type atomic_t
  * @a: the amount to add to v...
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
-static inline int atomic_add_unless(atomic_t *v, int a, int u)
+static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
 	c = atomic_read(v);
@@ -59,7 +59,7 @@ static inline int atomic_add_unless(atom
 		c = old;
 	}
 
-	return c != (u);
+	return c;
 }
 
 #define smp_mb__before_atomic_dec()	smp_mb()
diff -puN arch/sparc/include/asm/atomic_32.h~atomic-move-atomic_add_unless-to-generic-code arch/sparc/include/asm/atomic_32.h
--- a/arch/sparc/include/asm/atomic_32.h~atomic-move-atomic_add_unless-to-generic-code
+++ a/arch/sparc/include/asm/atomic_32.h
@@ -22,7 +22,7 @@
 extern int __atomic_add_return(int, atomic_t *);
 extern int atomic_cmpxchg(atomic_t *, int, int);
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
-extern int atomic_add_unless(atomic_t *, int, int);
+extern int __atomic_add_unless(atomic_t *, int, int);
 extern void atomic_set(atomic_t *, int);
 
 #define atomic_read(v)          (*(volatile int *)&(v)->counter)
diff -puN arch/sparc/include/asm/atomic_64.h~atomic-move-atomic_add_unless-to-generic-code arch/sparc/include/asm/atomic_64.h
--- a/arch/sparc/include/asm/atomic_64.h~atomic-move-atomic_add_unless-to-generic-code
+++ a/arch/sparc/include/asm/atomic_64.h
@@ -70,7 +70,7 @@ extern long atomic64_sub_ret(long, atomi
 #define atomic_cmpxchg(v, o, n) (cmpxchg(&((v)->counter), (o), (n)))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
-static inline int atomic_add_unless(atomic_t *v, int a, int u)
+static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
 	c = atomic_read(v);
@@ -82,7 +82,7 @@ static inline int atomic_add_unless(atom
 			break;
 		c = old;
 	}
-	return c != (u);
+	return c;
 }
 
 
diff -puN arch/tile/include/asm/atomic_32.h~atomic-move-atomic_add_unless-to-generic-code arch/tile/include/asm/atomic_32.h
--- a/arch/tile/include/asm/atomic_32.h~atomic-move-atomic_add_unless-to-generic-code
+++ a/arch/tile/include/asm/atomic_32.h
@@ -81,18 +81,18 @@ static inline int atomic_add_return(int 
 }
 
 /**
- * atomic_add_unless - add unless the number is already a given value
+ * __atomic_add_unless - add unless the number is already a given value
  * @v: pointer of type atomic_t
  * @a: the amount to add to v...
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as @v was not already @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
-static inline int atomic_add_unless(atomic_t *v, int a, int u)
+static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	smp_mb();  /* barrier for proper semantics */
-	return _atomic_xchg_add_unless(v, a, u) != u;
+	return _atomic_xchg_add_unless(v, a, u);
 }
 
 /**
@@ -199,7 +199,7 @@ static inline u64 atomic64_add_return(u6
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as @v was not already @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
 static inline u64 atomic64_add_unless(atomic64_t *v, u64 a, u64 u)
 {
diff -puN arch/tile/include/asm/atomic_64.h~atomic-move-atomic_add_unless-to-generic-code arch/tile/include/asm/atomic_64.h
--- a/arch/tile/include/asm/atomic_64.h~atomic-move-atomic_add_unless-to-generic-code
+++ a/arch/tile/include/asm/atomic_64.h
@@ -64,7 +64,7 @@ static inline int atomic_add_return(int 
 	return val;
 }
 
-static inline int atomic_add_unless(atomic_t *v, int a, int u)
+static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int guess, oldval = v->counter;
 	do {
@@ -73,7 +73,7 @@ static inline int atomic_add_unless(atom
 		guess = oldval;
 		oldval = atomic_cmpxchg(v, guess, guess + a);
 	} while (guess != oldval);
-	return oldval != u;
+	return oldval;
 }
 
 /* Now the true 64-bit operations. */
diff -puN arch/x86/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code arch/x86/include/asm/atomic.h
--- a/arch/x86/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code
+++ a/arch/x86/include/asm/atomic.h
@@ -221,15 +221,15 @@ static inline int atomic_xchg(atomic_t *
 }
 
 /**
- * atomic_add_unless - add unless the number is already a given value
+ * __atomic_add_unless - add unless the number is already a given value
  * @v: pointer of type atomic_t
  * @a: the amount to add to v...
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as @v was not already @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
-static inline int atomic_add_unless(atomic_t *v, int a, int u)
+static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
 	c = atomic_read(v);
@@ -241,7 +241,7 @@ static inline int atomic_add_unless(atom
 			break;
 		c = old;
 	}
-	return c != (u);
+	return c;
 }
 
 
diff -puN arch/x86/include/asm/atomic64_32.h~atomic-move-atomic_add_unless-to-generic-code arch/x86/include/asm/atomic64_32.h
--- a/arch/x86/include/asm/atomic64_32.h~atomic-move-atomic_add_unless-to-generic-code
+++ a/arch/x86/include/asm/atomic64_32.h
@@ -263,7 +263,7 @@ static inline int atomic64_add_negative(
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
 static inline int atomic64_add_unless(atomic64_t *v, long long a, long long u)
 {
diff -puN arch/x86/include/asm/atomic64_64.h~atomic-move-atomic_add_unless-to-generic-code arch/x86/include/asm/atomic64_64.h
--- a/arch/x86/include/asm/atomic64_64.h~atomic-move-atomic_add_unless-to-generic-code
+++ a/arch/x86/include/asm/atomic64_64.h
@@ -202,7 +202,7 @@ static inline long atomic64_xchg(atomic6
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
 static inline int atomic64_add_unless(atomic64_t *v, long a, long u)
 {
diff -puN arch/xtensa/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code arch/xtensa/include/asm/atomic.h
--- a/arch/xtensa/include/asm/atomic.h~atomic-move-atomic_add_unless-to-generic-code
+++ a/arch/xtensa/include/asm/atomic.h
@@ -225,15 +225,15 @@ static inline int atomic_sub_return(int 
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
 /**
- * atomic_add_unless - add unless the number is a given value
+ * __atomic_add_unless - add unless the number is a given value
  * @v: pointer of type atomic_t
  * @a: the amount to add to v...
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
+ * Returns the old value of @v.
  */
-static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
 	c = atomic_read(v);
@@ -245,7 +245,7 @@ static __inline__ int atomic_add_unless(
 			break;
 		c = old;
 	}
-	return c != (u);
+	return c;
 }
 
 
diff -puN include/asm-generic/atomic.h~atomic-move-atomic_add_unless-to-generic-code include/asm-generic/atomic.h
--- a/include/asm-generic/atomic.h~atomic-move-atomic_add_unless-to-generic-code
+++ a/include/asm-generic/atomic.h
@@ -129,13 +129,13 @@ static inline void atomic_dec(atomic_t *
 
 #define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
 
-static inline int atomic_add_unless(atomic_t *v, int a, int u)
+static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
   int c, old;
   c = atomic_read(v);
   while (c != u && (old = atomic_cmpxchg(v, c, c + a)) != c)
     c = old;
-  return c != u;
+  return c;
 }
 
 static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
diff -puN include/linux/atomic.h~atomic-move-atomic_add_unless-to-generic-code include/linux/atomic.h
--- a/include/linux/atomic.h~atomic-move-atomic_add_unless-to-generic-code
+++ a/include/linux/atomic.h
@@ -3,6 +3,20 @@
 #include <asm/atomic.h>
 
 /**
+ * atomic_add_unless - add unless the number is already a given value
+ * @v: pointer of type atomic_t
+ * @a: the amount to add to v...
+ * @u: ...unless v is equal to u.
+ *
+ * Atomically adds @a to @v, so long as @v was not already @u.
+ * Returns non-zero if @v was not @u, and zero otherwise.
+ */
+static inline int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	return __atomic_add_unless(v, a, u) != u;
+}
+
+/**
  * atomic_inc_not_zero - increment unless the number is zero
  * @v: pointer of type atomic_t
  *
_

Patches currently in -mm which might be from asharma@fb.com are

origin.patch
sparc-rename-atomic_add_unless.patch

