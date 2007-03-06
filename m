From: akpm@linux-foundation.org
Subject: - local_t-powerpc-extension-shrink-powerpc-localh.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:32:33 -0800
Message-ID: <200703060132.l261WXSU007796@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45507 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933786AbXCFBdE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:33:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     local_t: powerpc extension: shrink powerpc local.h
has been removed from the -mm tree.  Its filename was
     local_t-powerpc-extension-shrink-powerpc-localh.patch

This patch was dropped because it was folded into local_t-powerpc-extension.patch

------------------------------------------------------
Subject: local_t: powerpc extension: shrink powerpc local.h
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

By using PPC_LLARX and PPC_STLCX, we can cut in half the size of powerpc
local.h.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-powerpc/local.h |  190 ++++------------------------------
 1 files changed, 24 insertions(+), 166 deletions(-)

diff -puN include/asm-powerpc/local.h~local_t-powerpc-extension-shrink-powerpc-localh include/asm-powerpc/local.h
--- a/include/asm-powerpc/local.h~local_t-powerpc-extension-shrink-powerpc-localh
+++ a/include/asm-powerpc/local.h
@@ -19,17 +19,15 @@ typedef struct
 #define local_inc(l)	atomic_long_inc(&(l)->a)
 #define local_dec(l)	atomic_long_dec(&(l)->a)
 
-#ifndef __powerpc64__
-
-static __inline__ int local_add_return(int a, local_t *l)
+static __inline__ long local_add_return(long a, local_t *l)
 {
-	int t;
+	long t;
 
 	__asm__ __volatile__(
-"1:	lwarx	%0,0,%2		# local_add_return\n\
+"1:"	PPC_LLARX	"%0,0,%2		# local_add_return\n\
 	add	%0,%1,%0\n"
 	PPC405_ERR77(0,%2)
-"	stwcx.	%0,0,%2 \n\
+	PPC_STLCX	"%0,0,%2 \n\
 	bne-	1b"
 	: "=&r" (t)
 	: "r" (a), "r" (&(l->a.counter))
@@ -40,15 +38,15 @@ static __inline__ int local_add_return(i
 
 #define local_add_negative(a, l)	(local_add_return((a), (l)) < 0)
 
-static __inline__ int local_sub_return(int a, local_t *l)
+static __inline__ long local_sub_return(long a, local_t *l)
 {
-	int t;
+	long t;
 
 	__asm__ __volatile__(
-"1:	lwarx	%0,0,%2		# local_sub_return\n\
+"1:"	PPC_LLARX	"%0,0,%2		# local_sub_return\n\
 	subf	%0,%1,%0\n"
 	PPC405_ERR77(0,%2)
-"	stwcx.	%0,0,%2 \n\
+	PPC_STLCX	"%0,0,%2 \n\
 	bne-	1b"
 	: "=&r" (t)
 	: "r" (a), "r" (&(l->a.counter))
@@ -57,15 +55,15 @@ static __inline__ int local_sub_return(i
 	return t;
 }
 
-static __inline__ int local_inc_return(local_t *l)
+static __inline__ long local_inc_return(local_t *l)
 {
-	int t;
+	long t;
 
 	__asm__ __volatile__(
-"1:	lwarx	%0,0,%1		# local_inc_return\n\
+"1:"	PPC_LLARX	"%0,0,%1		# local_inc_return\n\
 	addic	%0,%0,1\n"
 	PPC405_ERR77(0,%1)
-"	stwcx.	%0,0,%1 \n\
+	PPC_STLCX	"%0,0,%1 \n\
 	bne-	1b"
 	: "=&r" (t)
 	: "r" (&(l->a.counter))
@@ -84,15 +82,15 @@ static __inline__ int local_inc_return(l
  */
 #define local_inc_and_test(l) (local_inc_return(l) == 0)
 
-static __inline__ int local_dec_return(local_t *l)
+static __inline__ long local_dec_return(local_t *l)
 {
-	int t;
+	long t;
 
 	__asm__ __volatile__(
-"1:	lwarx	%0,0,%1		# local_dec_return\n\
+"1:"	PPC_LLARX	"%0,0,%1		# local_dec_return\n\
 	addic	%0,%0,-1\n"
 	PPC405_ERR77(0,%1)
-"	stwcx.	%0,0,%1\n\
+	PPC_STLCX	"%0,0,%1\n\
 	bne-	1b"
 	: "=&r" (t)
 	: "r" (&(l->a.counter))
@@ -114,17 +112,17 @@ static __inline__ int local_dec_return(l
  * Atomically adds @a to @l, so long as it was not @u.
  * Returns non-zero if @l was not @u, and zero otherwise.
  */
-static __inline__ int local_add_unless(local_t *l, int a, int u)
+static __inline__ int local_add_unless(local_t *l, long a, long u)
 {
-	int t;
+	long t;
 
 	__asm__ __volatile__ (
-"1:	lwarx	%0,0,%1		# local_add_unless\n\
+"1:"	PPC_LLARX	"%0,0,%1		# local_add_unless\n\
 	cmpw	0,%0,%3 \n\
 	beq-	2f \n\
 	add	%0,%2,%0 \n"
 	PPC405_ERR77(0,%2)
-"	stwcx.	%0,0,%1 \n\
+	PPC_STLCX	"%0,0,%1 \n\
 	bne-	1b \n"
 "	subf	%0,%2,%0 \n\
 2:"
@@ -144,17 +142,17 @@ static __inline__ int local_add_unless(l
  * Atomically test *l and decrement if it is greater than 0.
  * The function returns the old value of *l minus 1.
  */
-static __inline__ int local_dec_if_positive(local_t *l)
+static __inline__ long local_dec_if_positive(local_t *l)
 {
-	int t;
+	long t;
 
 	__asm__ __volatile__(
-"1:	lwarx	%0,0,%1		# local_dec_if_positive\n\
+"1:"	PPC_LLARX	"%0,0,%1		# local_dec_if_positive\n\
 	cmpwi	%0,1\n\
 	addi	%0,%0,-1\n\
 	blt-	2f\n"
 	PPC405_ERR77(0,%1)
-"	stwcx.	%0,0,%1\n\
+	PPC_STLCX	"%0,0,%1\n\
 	bne-	1b"
 	"\n\
 2:"	: "=&b" (t)
@@ -164,146 +162,6 @@ static __inline__ int local_dec_if_posit
 	return t;
 }
 
-#else /* __powerpc64__ */
-
-static __inline__ long local_add_return(long a, local_t *l)
-{
-	long t;
-
-	__asm__ __volatile__(
-"1:	ldarx	%0,0,%2		# local_add_return\n\
-	add	%0,%1,%0\n\
-	stdcx.	%0,0,%2 \n\
-	bne-	1b"
-	: "=&r" (t)
-	: "r" (a), "r" (&(l->a.counter))
-	: "cc", "memory");
-
-	return t;
-}
-
-#define local_add_negative(a, l)	(local_add_return((a), (l)) < 0)
-
-static __inline__ long local_sub_return(long a, local_t *l)
-{
-	long t;
-
-	__asm__ __volatile__(
-"1:	ldarx	%0,0,%2		# local_sub_return\n\
-	subf	%0,%1,%0\n\
-	stdcx.	%0,0,%2 \n\
-	bne-	1b"
-	: "=&r" (t)
-	: "r" (a), "r" (&(l->a.counter))
-	: "cc", "memory");
-
-	return t;
-}
-
-static __inline__ long local_inc_return(local_t *l)
-{
-	long t;
-
-	__asm__ __volatile__(
-"1:	ldarx	%0,0,%1		# local_inc_return\n\
-	addic	%0,%0,1\n\
-	stdcx.	%0,0,%1 \n\
-	bne-	1b"
-	: "=&r" (t)
-	: "r" (&(l->a.counter))
-	: "cc", "memory");
-
-	return t;
-}
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
-static __inline__ long local_dec_return(local_t *l)
-{
-	long t;
-
-	__asm__ __volatile__(
-"1:	ldarx	%0,0,%1		# local_dec_return\n\
-	addic	%0,%0,-1\n\
-	stdcx.	%0,0,%1\n\
-	bne-	1b"
-	: "=&r" (t)
-	: "r" (&(l->a.counter))
-	: "cc", "memory");
-
-	return t;
-}
-
-#define local_sub_and_test(a, l)	(local_sub_return((a), (l)) == 0)
-#define local_dec_and_test(l)	(local_dec_return((l)) == 0)
-
-/*
- * Atomically test *l and decrement if it is greater than 0.
- * The function returns the old value of *l minus 1.
- */
-static __inline__ long local_dec_if_positive(local_t *l)
-{
-	long t;
-
-	__asm__ __volatile__(
-"1:	ldarx	%0,0,%1		# local_dec_if_positive\n\
-	addic.	%0,%0,-1\n\
-	blt-	2f\n\
-	stdcx.	%0,0,%1\n\
-	bne-	1b"
-	"\n\
-2:"	: "=&r" (t)
-	: "r" (&(l->a.counter))
-	: "cc", "memory");
-
-	return t;
-}
-
-#define local_cmpxchg(l, o, n) \
-	((long)cmpxchg_local(&((l)->a.counter), (o), (n)))
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
-static __inline__ int local_add_unless(local_t *l, long a, long u)
-{
-	long t;
-
-	__asm__ __volatile__ (
-"1:	ldarx	%0,0,%1		# local_add_unless\n\
-	cmpd	0,%0,%3 \n\
-	beq-	2f \n\
-	add	%0,%2,%0 \n"
-"	stdcx.	%0,0,%1 \n\
-	bne-	1b \n"
-"	subf	%0,%2,%0 \n\
-2:"
-	: "=&r" (t)
-	: "r" (&(l->a.counter)), "r" (a), "r" (u)
-	: "cc", "memory");
-
-	return t != u;
-}
-
-#define local_inc_not_zero(l) local_add_unless((l), 1, 0)
-
-#endif /* !__powerpc64__ */
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
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
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
