From: akpm@linux-foundation.org
Subject: - atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch removed from -mm tree
Date: Tue, 08 May 2007 19:55:00 -0700
Message-ID: <200705090255.l492t0A7009874@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032307AbXEICzS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:55:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     atomic.h: add atomic64 cmpxchg, xchg and add_unless to mips
has been removed from the -mm tree.  Its filename was
     atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atomic.h: add atomic64 cmpxchg, xchg and add_unless to mips
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mips/atomic.h |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff -puN include/asm-mips/atomic.h~atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips include/asm-mips/atomic.h
--- a/include/asm-mips/atomic.h~atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips
+++ a/include/asm-mips/atomic.h
@@ -306,8 +306,8 @@ static __inline__ int atomic_sub_if_posi
 	return result;
 }
 
-#define atomic_cmpxchg(v, o, n) ((int)cmpxchg(&((v)->counter), (o), (n)))
-#define atomic_xchg(v, new) (xchg(&((v)->counter), new))
+#define atomic_cmpxchg(v, o, n) (cmpxchg(&((v)->counter), (o), (n)))
+#define atomic_xchg(v, new) (xchg(&((v)->counter), (new)))
 
 /**
  * atomic_add_unless - add unless the number is a given value
@@ -320,7 +320,7 @@ static __inline__ int atomic_sub_if_posi
  */
 #define atomic_add_unless(v, a, u)				\
 ({								\
-	int c, old;						\
+	__typeof__((v)->counter) c, old;			\
 	c = atomic_read(v);					\
 	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
 		c = old;					\
@@ -681,6 +681,29 @@ static __inline__ long atomic64_sub_if_p
 	return result;
 }
 
+#define atomic64_cmpxchg(v, o, n) \
+	(((__typeof__((v)->counter)))cmpxchg(&((v)->counter), (o), (n)))
+#define atomic64_xchg(v, new) (xchg(&((v)->counter), (new)))
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
+	__typeof__((v)->counter) c, old;			\
+	c = atomic_read(v);					\
+	while (c != (u) && (old = atomic64_cmpxchg((v), c, c + (a))) != c) \
+		c = old;					\
+	c != (u);						\
+})
+#define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
+
 #define atomic64_dec_return(v) atomic64_sub_return(1,(v))
 #define atomic64_inc_return(v) atomic64_add_return(1,(v))
 
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
