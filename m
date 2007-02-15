From: akpm@linux-foundation.org
Subject: + atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch added to -mm tree
Date: Wed, 14 Feb 2007 23:06:06 -0800
Message-ID: <200702150706.l1F766Ya022519@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37343 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964943AbXBOHG7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 02:06:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, grundler@parisc-linux.org, kyle@mcmartin.ca, willy@debian.org


The patch titled
     atomic.h: add atomic64 cmpxchg, xchg and add_unless to parisc
has been added to the -mm tree.  Its filename is
     atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atomic.h: add atomic64 cmpxchg, xchg and add_unless to parisc
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <willy@debian.org>
Cc: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-parisc/atomic.h |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

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
@@ -270,6 +269,31 @@ atomic64_read(const atomic64_t *v)
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
+
 #endif /* __LP64__ */
 
 #include <asm-generic/atomic.h>
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
git-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
atomich-complete-atomic_long-operations-in-asm-generic.patch
atomich-i386-type-safety-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
atomich-add-atomic64_xchg-to-s390.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch
atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency.patch
local_t-architecture-independant-extension.patch
local_t-alpha-extension.patch
local_t-i386-extension.patch
local_t-ia64-extension.patch
local_t-mips-extension.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-s390-cleanup.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
