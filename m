From: akpm@linux-foundation.org
Subject: - local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:31:37 -0800
Message-ID: <200703060131.l261Vctw007777@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45686 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932863AbXCFBfT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:35:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Shrink duplicated mips 32/64 bits functions from local.h
has been removed from the -mm tree.  Its filename was
     local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh.patch

This patch was dropped because it was folded into local_t-mips-extension.patch

------------------------------------------------------
Subject: Shrink duplicated mips 32/64 bits functions from local.h
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

We can use __LL and __SC to select the assembly instruction, which
divide by 2 the size of mips local.h.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mips/local.h |  262 +------------------------------------
 1 files changed, 13 insertions(+), 249 deletions(-)

diff -puN include/asm-mips/local.h~local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh include/asm-mips/local.h
--- a/include/asm-mips/local.h~local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh
+++ a/include/asm-mips/local.h
@@ -2,6 +2,7 @@
 #define _ARCH_MIPS_LOCAL_H
 
 #include <linux/percpu.h>
+#include <linux/bitops.h>
 #include <asm/atomic.h>
 #include <asm/war.h>
 
@@ -20,240 +21,6 @@ typedef struct
 #define local_inc(l)	local_long_inc(&(l)->a)
 #define local_dec(l)	local_long_dec(&(l)->a)
 
-
-#ifndef CONFIG_64BIT
-
-/*
- * Same as above, but return the result value
- */
-static __inline__ int local_add_return(int i, local_t * l)
-{
-	unsigned long result;
-
-	if (cpu_has_llsc && R10000_LLSC_WAR) {
-		unsigned long temp;
-
-		__asm__ __volatile__(
-		"	.set	mips3					\n"
-		"1:	ll	%1, %2		# local_add_return	\n"
-		"	addu	%0, %1, %3				\n"
-		"	sc	%0, %2					\n"
-		"	beqzl	%0, 1b					\n"
-		"	addu	%0, %1, %3				\n"
-		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
-		: "Ir" (i), "m" (l->a.counter)
-		: "memory");
-	} else if (cpu_has_llsc) {
-		unsigned long temp;
-
-		__asm__ __volatile__(
-		"	.set	mips3					\n"
-		"1:	ll	%1, %2		# local_add_return	\n"
-		"	addu	%0, %1, %3				\n"
-		"	sc	%0, %2					\n"
-		"	beqz	%0, 1b					\n"
-		"	addu	%0, %1, %3				\n"
-		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
-		: "Ir" (i), "m" (l->a.counter)
-		: "memory");
-	} else {
-		unsigned long flags;
-
-		local_irq_save(flags);
-		result = l->a.counter;
-		result += i;
-		l->a.counter = result;
-		local_irq_restore(flags);
-	}
-
-	return result;
-}
-
-static __inline__ int local_sub_return(int i, local_t * l)
-{
-	unsigned long result;
-
-	if (cpu_has_llsc && R10000_LLSC_WAR) {
-		unsigned long temp;
-
-		__asm__ __volatile__(
-		"	.set	mips3					\n"
-		"1:	ll	%1, %2		# local_sub_return	\n"
-		"	subu	%0, %1, %3				\n"
-		"	sc	%0, %2					\n"
-		"	beqzl	%0, 1b					\n"
-		"	subu	%0, %1, %3				\n"
-		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
-		: "Ir" (i), "m" (l->a.counter)
-		: "memory");
-	} else if (cpu_has_llsc) {
-		unsigned long temp;
-
-		__asm__ __volatile__(
-		"	.set	mips3					\n"
-		"1:	ll	%1, %2		# local_sub_return	\n"
-		"	subu	%0, %1, %3				\n"
-		"	sc	%0, %2					\n"
-		"	beqz	%0, 1b					\n"
-		"	subu	%0, %1, %3				\n"
-		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
-		: "Ir" (i), "m" (l->a.counter)
-		: "memory");
-	} else {
-		unsigned long flags;
-
-		local_irq_save(flags);
-		result = l->a.counter;
-		result -= i;
-		l->a.counter = result;
-		local_irq_restore(flags);
-	}
-
-	return result;
-}
-
-/*
- * local_sub_if_positive - conditionally subtract integer from atomic variable
- * @i: integer value to subtract
- * @l: pointer of type local_t
- *
- * Atomically test @l and subtract @i if @l is greater or equal than @i.
- * The function returns the old value of @l minus @i.
- */
-static __inline__ int local_sub_if_positive(int i, local_t * l)
-{
-	unsigned long result;
-
-	if (cpu_has_llsc && R10000_LLSC_WAR) {
-		unsigned long temp;
-
-		__asm__ __volatile__(
-		"	.set	mips3					\n"
-		"1:	ll	%1, %2		# local_sub_if_positive\n"
-		"	subu	%0, %1, %3				\n"
-		"	bltz	%0, 1f					\n"
-		"	sc	%0, %2					\n"
-		"	.set	noreorder				\n"
-		"	beqzl	%0, 1b					\n"
-		"	 subu	%0, %1, %3				\n"
-		"	.set	reorder					\n"
-		"1:							\n"
-		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
-		: "Ir" (i), "m" (l->a.counter)
-		: "memory");
-	} else if (cpu_has_llsc) {
-		unsigned long temp;
-
-		__asm__ __volatile__(
-		"	.set	mips3					\n"
-		"1:	ll	%1, %2		# local_sub_if_positive\n"
-		"	subu	%0, %1, %3				\n"
-		"	bltz	%0, 1f					\n"
-		"	sc	%0, %2					\n"
-		"	.set	noreorder				\n"
-		"	beqz	%0, 1b					\n"
-		"	 subu	%0, %1, %3				\n"
-		"	.set	reorder					\n"
-		"1:							\n"
-		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
-		: "Ir" (i), "m" (l->a.counter)
-		: "memory");
-	} else {
-		unsigned long flags;
-
-		local_irq_save(flags);
-		result = l->a.counter;
-		result -= i;
-		if (result >= 0)
-			l->a.counter = result;
-		local_irq_restore(flags);
-	}
-
-	return result;
-}
-
-#define local_cmpxchg(l, o, n) \
-	(cmpxchg_local(&((l)->a.counter), (o), (n)))
-#define local_xchg(l, n) (xchg_local(&((l)->a.counter), (n)))
-
-/**
- * local_add_unless - add unless the number is a given value
- * @l: pointer of type local_t
- * @a: the amount to add to l...
- * @u: ...unless l is equal to u.
- *
- * Atomically adds @a to @l, so long as it was not @u.
- * Returns non-zero if @l was not @u, and zero otherwise.
- */
-#define local_add_unless(l, a, u)				\
-({								\
-	long c, old;						\
-	c = local_read(l);					\
-	while (c != (u) && (old = local_cmpxchg((l), c, c + (a))) != c) \
-		c = old;					\
-	c != (u);						\
-})
-#define local_inc_not_zero(l) local_add_unless((l), 1, 0)
-
-#define local_dec_return(l) local_sub_return(1,(l))
-#define local_inc_return(l) local_add_return(1,(l))
-
-/*
- * local_sub_and_test - subtract value from variable and test result
- * @i: integer value to subtract
- * @l: pointer of type local_t
- *
- * Atomically subtracts @i from @l and returns
- * true if the result is zero, or false for all
- * other cases.
- */
-#define local_sub_and_test(i,l) (local_sub_return((i), (l)) == 0)
-
-/*
- * local_inc_and_test - increment and test
- * @l: pointer of type local_t
- *
- * Atomically increments @l by 1
- * and returns true if the result is zero, or false for all
- * other cases.
- */
-#define local_inc_and_test(l) (local_inc_return(l) == 0)
-
-/*
- * local_dec_and_test - decrement by 1 and test
- * @l: pointer of type local_t
- *
- * Atomically decrements @l by 1 and
- * returns true if the result is 0, or false for all other
- * cases.
- */
-#define local_dec_and_test(l) (local_sub_return(1, (l)) == 0)
-
-/*
- * local_dec_if_positive - decrement by 1 if old value positive
- * @l: pointer of type local_t
- */
-#define local_dec_if_positive(l)	local_sub_if_positive(1, l)
-
-/*
- * local_add_negative - add and test if negative
- * @l: pointer of type local_t
- * @i: integer value to add
- *
- * Atomically adds @i to @l and returns true
- * if the result is negative, or false when
- * result is greater than or equal to zero.
- */
-#define local_add_negative(i,l) (local_add_return(i, (l)) < 0)
-
-#else /* CONFIG_64BIT */
-
 /*
  * Same as above, but return the result value
  */
@@ -266,9 +33,9 @@ static __inline__ long local_add_return(
 
 		__asm__ __volatile__(
 		"	.set	mips3					\n"
-		"1:	lld	%1, %2		# local_add_return	\n"
+		"1:"	__LL	"%1, %2		# local_add_return	\n"
 		"	addu	%0, %1, %3				\n"
-		"	scd	%0, %2					\n"
+			__SC	"%0, %2					\n"
 		"	beqzl	%0, 1b					\n"
 		"	addu	%0, %1, %3				\n"
 		"	.set	mips0					\n"
@@ -280,9 +47,9 @@ static __inline__ long local_add_return(
 
 		__asm__ __volatile__(
 		"	.set	mips3					\n"
-		"1:	lld	%1, %2		# local_add_return	\n"
+		"1:"	__LL	"%1, %2		# local_add_return	\n"
 		"	addu	%0, %1, %3				\n"
-		"	scd	%0, %2					\n"
+			__SC	"%0, %2					\n"
 		"	beqz	%0, 1b					\n"
 		"	addu	%0, %1, %3				\n"
 		"	.set	mips0					\n"
@@ -311,9 +78,9 @@ static __inline__ long local_sub_return(
 
 		__asm__ __volatile__(
 		"	.set	mips3					\n"
-		"1:	lld	%1, %2		# local_sub_return	\n"
+		"1:"	__LL	"%1, %2		# local_sub_return	\n"
 		"	subu	%0, %1, %3				\n"
-		"	scd	%0, %2					\n"
+			__SC	"%0, %2					\n"
 		"	beqzl	%0, 1b					\n"
 		"	subu	%0, %1, %3				\n"
 		"	.set	mips0					\n"
@@ -325,9 +92,9 @@ static __inline__ long local_sub_return(
 
 		__asm__ __volatile__(
 		"	.set	mips3					\n"
-		"1:	lld	%1, %2		# local_sub_return	\n"
+		"1:"	__LL	"%1, %2		# local_sub_return	\n"
 		"	subu	%0, %1, %3				\n"
-		"	scd	%0, %2					\n"
+			__SC	"%0, %2					\n"
 		"	beqz	%0, 1b					\n"
 		"	subu	%0, %1, %3				\n"
 		"	.set	mips0					\n"
@@ -364,10 +131,10 @@ static __inline__ long local_sub_if_posi
 
 		__asm__ __volatile__(
 		"	.set	mips3					\n"
-		"1:	lld	%1, %2		# local_sub_if_positive\n"
+		"1:"	__LL	"%1, %2		# local_sub_if_positive\n"
 		"	dsubu	%0, %1, %3				\n"
 		"	bltz	%0, 1f					\n"
-		"	scd	%0, %2					\n"
+			__SC	"%0, %2					\n"
 		"	.set	noreorder				\n"
 		"	beqzl	%0, 1b					\n"
 		"	 dsubu	%0, %1, %3				\n"
@@ -382,10 +149,10 @@ static __inline__ long local_sub_if_posi
 
 		__asm__ __volatile__(
 		"	.set	mips3					\n"
-		"1:	lld	%1, %2		# local_sub_if_positive\n"
+		"1:"	__LL	"%1, %2		# local_sub_if_positive\n"
 		"	dsubu	%0, %1, %3				\n"
 		"	bltz	%0, 1f					\n"
-		"	scd	%0, %2					\n"
+			__SC	"%0, %2					\n"
 		"	.set	noreorder				\n"
 		"	beqz	%0, 1b					\n"
 		"	 dsubu	%0, %1, %3				\n"
@@ -483,9 +250,6 @@ static __inline__ long local_sub_if_posi
  */
 #define local_add_negative(i,l) (local_add_return(i, (l)) < 0)
 
-#endif /* !CONFIG_64BIT */
-
-
 /* Use these for per-cpu local_t variables: on some archs they are
  * much more efficient than these naive implementations.  Note they take
  * a variable, not an address.
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
atomich-complete-atomic_long-operations-in-asm-generic.patch
atomich-i386-type-safety-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch
atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency.patch
local_t-architecture-independant-extension.patch
local_t-alpha-extension.patch
local_t-i386-extension.patch
local_t-ia64-extension.patch
local_t-mips-extension.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix-2.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-powerpc-extension-fix.patch
local_t-powerpc-extension-shrink-powerpc-localh.patch
local_t-powerpc-extension-fix-build-fix.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-kconfig-menus-fix.patch
linux-kernel-markers-kconfig-menus-fix-2.patch
linux-kernel-markers-kconfig-menus-fix-3.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
linux-kernel-markers-kconfig-menus-fix-5.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-architecture-independant-code-license-fix.patch
linux-kernel-markers-architecture-independant-code-flags.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-powerpc-optimization-flags.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-i386-optimization-fix.patch
linux-kernel-markers-i386-optimization-export-fix.patch
linux-kernel-markers-i386-optimization-flags.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-non-optimized-architures-fallback-flags.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-fix.patch
linux-kernel-markers-documentation-update-adds-context.patch
linux-kernel-markers-documentation-update-markerh.patch
linux-kernel-markers-documentation-update-flags.patch
