From: akpm@osdl.org
Subject: + atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch added to -mm tree
Date: Thu, 25 Jan 2007 21:41:37 -0800
Message-ID: <200701260541.l0Q5fbeV008476@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46517 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030767AbXAZFlp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 00:41:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, kyle@mcmartin.ca


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
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-parisc/atomic.h |   30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff -puN include/asm-parisc/atomic.h~atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc include/asm-parisc/atomic.h
--- a/include/asm-parisc/atomic.h~atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc
+++ a/include/asm-parisc/atomic.h
@@ -163,7 +163,8 @@ static __inline__ int atomic_read(const 
 }
 
 /* exported interface */
-#define atomic_cmpxchg(v, o, n) ((int)cmpxchg(&((v)->counter), (o), (n)))
+#define atomic_cmpxchg(v, o, n) \
+	((__typeof__((v)->counter))cmpxchg(&((v)->counter), (o), (n)))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
 /**
@@ -177,7 +178,7 @@ static __inline__ int atomic_read(const 
  */
 #define atomic_add_unless(v, a, u)				\
 ({								\
-	int c, old;						\
+	__typeof__((v)->counter) c, old;						\
 	c = atomic_read(v);					\
 	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
 		c = old;					\
@@ -270,6 +271,31 @@ atomic64_read(const atomic64_t *v)
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
