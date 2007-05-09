From: akpm@linux-foundation.org
Subject: - atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch removed from -mm tree
Date: Tue, 08 May 2007 19:54:54 -0700
Message-ID: <200705090254.l492ssSt009859@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44569 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032319AbXEICzm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:55:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     atomic.h: add atomic64 cmpxchg, xchg and add_unless to alpha
has been removed from the -mm tree.  Its filename was
     atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atomic.h: add atomic64 cmpxchg, xchg and add_unless to alpha
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

This series mainly adds support for missing 64 bits cmpxchg and 64 bits atomic
add unless.  Therefore, principally 64 bits architectures are targeted by
these patches.  It also adds the complete list of atomic operations on the
atomic_long type.



This patch:

atomic.h: add atomic64 cmpxchg, xchg and add_unless to alpha

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/atomic.h |   49 ++++++++++++++++++++++++++++++++---
 1 file changed, 46 insertions(+), 3 deletions(-)

diff -puN include/asm-alpha/atomic.h~atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha include/asm-alpha/atomic.h
--- a/include/asm-alpha/atomic.h~atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha
+++ a/include/asm-alpha/atomic.h
@@ -175,19 +175,62 @@ static __inline__ long atomic64_sub_retu
 	return result;
 }
 
-#define atomic_cmpxchg(v, o, n) ((int)cmpxchg(&((v)->counter), (o), (n)))
+#define atomic64_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), old, new))
+#define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
+
+#define atomic_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), old, new))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
+/**
+ * atomic_add_unless - add unless the number is a given value
+ * @v: pointer of type atomic_t
+ * @a: the amount to add to v...
+ * @u: ...unless v is equal to u.
+ *
+ * Atomically adds @a to @v, so long as it was not @u.
+ * Returns non-zero if @v was not @u, and zero otherwise.
+ */
 #define atomic_add_unless(v, a, u)				\
 ({								\
-	int c, old;						\
+	__typeof__((v)->counter) c, old;			\
 	c = atomic_read(v);					\
-	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
+	for (;;) {						\
+		if (unlikely(c == (u)))				\
+			break;					\
+		old = atomic_cmpxchg((v), c, c + (a));		\
+		if (likely(old == c))				\
+			break;					\
 		c = old;					\
+	}							\
 	c != (u);						\
 })
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
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
+	c = atomic64_read(v);					\
+	for (;;) {						\
+		if (unlikely(c == (u)))				\
+			break;					\
+		old = atomic64_cmpxchg((v), c, c + (a));	\
+		if (likely(old == c))				\
+			break;					\
+		c = old;					\
+	}							\
+	c != (u);						\
+})
+#define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
+
 #define atomic_add_negative(a, v) (atomic_add_return((a), (v)) < 0)
 #define atomic64_add_negative(a, v) (atomic64_add_return((a), (v)) < 0)
 
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
