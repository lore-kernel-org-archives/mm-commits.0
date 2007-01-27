From: akpm@osdl.org
Subject: - atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch removed from -mm tree
Date: Sat, 27 Jan 2007 02:18:26 -0800
Message-ID: <200701271019.l0RAJGiq007054@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47607 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbXA0KTa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Jan 2007 05:19:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     atomic.h: add atomic64 cmpxchg, xchg and add_unless to alpha
has been removed from the -mm tree.  Its filename was
     atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: atomic.h: add atomic64 cmpxchg, xchg and add_unless to alpha
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

The series mainly adds support for missing 64 bits cmpxchg and 64 bits atomic
add unless.  Therefore, principally 64 bits architectures are targeted by
these patches.  It also adds the complete list of atomic operations on the
atomic_long type.

This patch:

Add atomic64 cmpxchg, xchg and add_unless to alpha


Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-alpha/atomic.h |   51 ++++++++++++++++++++++++++++++++---
 1 file changed, 48 insertions(+), 3 deletions(-)

diff -puN include/asm-alpha/atomic.h~atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha include/asm-alpha/atomic.h
--- a/include/asm-alpha/atomic.h~atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha
+++ a/include/asm-alpha/atomic.h
@@ -175,19 +175,64 @@ static __inline__ long atomic64_sub_retu
 	return result;
 }
 
-#define atomic_cmpxchg(v, o, n) ((int)cmpxchg(&((v)->counter), (o), (n)))
+#define atomic64_cmpxchg(v, old, new) \
+	((__typeof__((v)->counter))cmpxchg(&((v)->counter), old, new))
+#define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
+
+#define atomic_cmpxchg(v, old, new) \
+	((__typeof__((v)->counter))cmpxchg(&((v)->counter), old, new))
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

relay-add-cpu-hotplug-support.patch
local_t-documentation.patch
local_t-documentation-fix.patch
order-of-lockdep-off-on-in-vprintk-should-be-changed.patch
minimize-lockdep_on-off-side-effect.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
atomich-complete-atomic_long-operations-in-asm-generic.patch
atomich-complete-atomic_long-operations-in-asm-generic-fix.patch
atomich-complete-atomic_long-operations-in-asm-generic-fix-2.patch
atomich-complete-atomic_long-operations-in-asm-generic-fix-3.patch
atomich-complete-atomic_long-operations-in-asm-generic-sparc-fix.patch
atomich-i386-type-safety-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64-fix.patch
local_t-architecture-independent-extension.patch
local_t-alpha-extension.patch
local_t-alpha-extension-fix.patch
local_t-i386-extension.patch
local_t-ia64-extension.patch
local_t-mips-extension.patch
local_t-mips-extension-fix.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-s390-cleanup.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
