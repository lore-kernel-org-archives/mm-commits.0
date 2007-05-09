From: akpm@linux-foundation.org
Subject: - atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch removed from -mm tree
Date: Tue, 08 May 2007 19:55:02 -0700
Message-ID: <200705090255.l492t27j009878@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34824 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032370AbXEIC4J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:56:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, grundler@parisc-linux.org, kyle@mcmartin.ca, willy@debian.org, mm-commits@vger.kernel.org


The patch titled
     atomic.h: add atomic64 cmpxchg, xchg and add_unless to parisc
has been removed from the -mm tree.  Its filename was
     atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atomic.h: add atomic64 cmpxchg, xchg and add_unless to parisc
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <willy@debian.org>
Acked-by: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-parisc/atomic.h |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff -puN include/asm-parisc/atomic.h~atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc include/asm-parisc/atomic.h
--- a/include/asm-parisc/atomic.h~atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc
+++ a/include/asm-parisc/atomic.h
@@ -6,7 +6,6 @@
 #define _ASM_PARISC_ATOMIC_H_
 
 #include <linux/types.h>
-#include <asm/system.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -163,7 +162,7 @@ static __inline__ int atomic_read(const 
 }
 
 /* exported interface */
-#define atomic_cmpxchg(v, o, n) ((int)cmpxchg(&((v)->counter), (o), (n)))
+#define atomic_cmpxchg(v, o, n) (cmpxchg(&((v)->counter), (o), (n)))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
 /**
@@ -177,7 +176,7 @@ static __inline__ int atomic_read(const 
  */
 #define atomic_add_unless(v, a, u)				\
 ({								\
-	int c, old;						\
+	__typeof__((v)->counter) c, old;						\
 	c = atomic_read(v);					\
 	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
 		c = old;					\
@@ -270,6 +269,30 @@ atomic64_read(const atomic64_t *v)
 #define atomic64_dec_and_test(v)	(atomic64_dec_return(v) == 0)
 #define atomic64_sub_and_test(i,v)	(atomic64_sub_return((i),(v)) == 0)
 
+/* exported interface */
+#define atomic64_cmpxchg(v, o, n) \
+	((__typeof__((v)->counter))cmpxchg(&((v)->counter), (o), (n)))
+#define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
+
+/**
+ * atomic64_add_unless - add unless the number is a given value
+ * @v: pointer of type atomic64_t
+ * @a: the amount to add to v...
+ * @u: ...unless v is equal to u.
+ *
+ * Atomically adds @a to @v, so long as it was not @u.
+ * Returns non-zero if @v was not @u, and zero otherwise.
+ */
+#define atomic64_add_unless(v, a, u)				\
+({								\
+	__typeof__((v)->counter) c, old;						\
+	c = atomic64_read(v);					\
+	while (c != (u) && (old = atomic64_cmpxchg((v), c, c + (a))) != c) \
+		c = old;					\
+	c != (u);						\
+})
+#define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
+
 #endif /* CONFIG_64BIT */
 
 #include <asm-generic/atomic.h>
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
git-avr32.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-i386-optimization.patch
markers-add-instrumentation-markers-menus-to-avr32.patch
linux-kernel-markers-non-optimized-architectures.patch
markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh.patch
linux-kernel-markers-documentation.patch
markers-define-the-linker-macro-extra_rwdata.patch
markers-use-extra_rwdata-in-architectures.patch
