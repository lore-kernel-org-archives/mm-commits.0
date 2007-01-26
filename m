From: akpm@osdl.org
Subject: + atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch added to -mm tree
Date: Thu, 25 Jan 2007 21:41:43 -0800
Message-ID: <200701260541.l0Q5fhi0008485@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46524 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030770AbXAZFlw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 00:41:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, ak@suse.de


The patch titled
     atomic.h: add atomic64 cmpxchg, xchg and add_unless to x86_64
has been added to the -mm tree.  Its filename is
     atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atomic.h: add atomic64 cmpxchg, xchg and add_unless to x86_64
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-x86_64/atomic.h |   38 ++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff -puN include/asm-x86_64/atomic.h~atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64 include/asm-x86_64/atomic.h
--- a/include/asm-x86_64/atomic.h~atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64
+++ a/include/asm-x86_64/atomic.h
@@ -375,8 +375,8 @@ static __inline__ long atomic64_add_retu
 	long __i = i;
 	__asm__ __volatile__(
 		LOCK_PREFIX "xaddq %0, %1;"
-		:"=r"(i)
-		:"m"(v->counter), "0"(i));
+		:"+r" (i), "+m" (v->counter)
+		: : "memory");
 	return i + __i;
 }
 
@@ -388,7 +388,12 @@ static __inline__ long atomic64_sub_retu
 #define atomic64_inc_return(v)  (atomic64_add_return(1,v))
 #define atomic64_dec_return(v)  (atomic64_sub_return(1,v))
 
-#define atomic_cmpxchg(v, old, new) ((int)cmpxchg(&((v)->counter), old, new))
+#define atomic64_cmpxchg(v, old, new) \
+	((__typeof__((v)->counter))cmpxchg(&((v)->counter), old, new))
+#define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
+
+#define atomic_cmpxchg(v, old, new) \
+	((__typeof__((v)->counter))cmpxchg(&((v)->counter), old, new))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
 /**
@@ -402,7 +407,7 @@ static __inline__ long atomic64_sub_retu
  */
 #define atomic_add_unless(v, a, u)				\
 ({								\
-	int c, old;						\
+	__typeof__((v)->counter) c, old;			\
 	c = atomic_read(v);					\
 	for (;;) {						\
 		if (unlikely(c == (u)))				\
@@ -416,6 +421,31 @@ static __inline__ long atomic64_sub_retu
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
 /* These are x86-specific, used by some header files */
 #define atomic_clear_mask(mask, addr) \
 __asm__ __volatile__(LOCK_PREFIX "andl %0,%1" \
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
atomich-i386-type-safety-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch
local_t-architecture-independant-extension.patch
