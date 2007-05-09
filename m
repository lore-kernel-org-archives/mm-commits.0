From: akpm@linux-foundation.org
Subject: - atomich-complete-atomic_long-operations-in-asm-generic.patch removed from -mm tree
Date: Tue, 08 May 2007 19:55:48 -0700
Message-ID: <200705090255.l492tmg1009968@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032336AbXEICzz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:55:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     atomic.h: complete atomic_long operations in asm-generic
has been removed from the -mm tree.  Its filename was
     atomich-complete-atomic_long-operations-in-asm-generic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atomic.h: complete atomic_long operations in asm-generic
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/atomic.h |  133 +++++++++++++++++++++++++++++++++
 1 file changed, 133 insertions(+)

diff -puN include/asm-generic/atomic.h~atomich-complete-atomic_long-operations-in-asm-generic include/asm-generic/atomic.h
--- a/include/asm-generic/atomic.h~atomich-complete-atomic_long-operations-in-asm-generic
+++ a/include/asm-generic/atomic.h
@@ -9,6 +9,7 @@
  */
 
 #include <asm/types.h>
+#include <asm/system.h>
 
 /*
  * Suppport for atomic_long_t
@@ -66,6 +67,72 @@ static inline void atomic_long_sub(long 
 	atomic64_sub(i, v);
 }
 
+static inline int atomic_long_sub_and_test(long i, atomic_long_t *l)
+{
+	atomic64_t *v = (atomic64_t *)l;
+
+	return atomic64_sub_and_test(i, v);
+}
+
+static inline int atomic_long_dec_and_test(atomic_long_t *l)
+{
+	atomic64_t *v = (atomic64_t *)l;
+
+	return atomic64_dec_and_test(v);
+}
+
+static inline int atomic_long_inc_and_test(atomic_long_t *l)
+{
+	atomic64_t *v = (atomic64_t *)l;
+
+	return atomic64_inc_and_test(v);
+}
+
+static inline int atomic_long_add_negative(long i, atomic_long_t *l)
+{
+	atomic64_t *v = (atomic64_t *)l;
+
+	return atomic64_add_negative(i, v);
+}
+
+static inline long atomic_long_add_return(long i, atomic_long_t *l)
+{
+	atomic64_t *v = (atomic64_t *)l;
+
+	return (long)atomic64_add_return(i, v);
+}
+
+static inline long atomic_long_sub_return(long i, atomic_long_t *l)
+{
+	atomic64_t *v = (atomic64_t *)l;
+
+	return (long)atomic64_sub_return(i, v);
+}
+
+static inline long atomic_long_inc_return(atomic_long_t *l)
+{
+	atomic64_t *v = (atomic64_t *)l;
+
+	return (long)atomic64_inc_return(v);
+}
+
+static inline long atomic_long_dec_return(atomic_long_t *l)
+{
+	atomic64_t *v = (atomic64_t *)l;
+
+	return (long)atomic64_dec_return(v);
+}
+
+#define atomic_long_add_unless(l, a, u) \
+	atomic64_add_unless((atomic64_t *)(l), (a), (u))
+
+#define atomic_long_inc_not_zero(l) atomic64_inc_not_zero((atomic64_t *)(l))
+
+#define atomic_long_cmpxchg(l, old, new) \
+	(atomic_cmpxchg((atomic64_t *)(l), (old), (new)))
+#define atomic_long_xchg(v, new) \
+	(atomic_xchg((atomic64_t *)(l), (new)))
+
 #else  /*  BITS_PER_LONG == 64  */
 
 typedef atomic_t atomic_long_t;
@@ -113,6 +180,72 @@ static inline void atomic_long_sub(long 
 	atomic_sub(i, v);
 }
 
+static inline int atomic_long_sub_and_test(long i, atomic_long_t *l)
+{
+	atomic_t *v = (atomic_t *)l;
+
+	return atomic_sub_and_test(i, v);
+}
+
+static inline int atomic_long_dec_and_test(atomic_long_t *l)
+{
+	atomic_t *v = (atomic_t *)l;
+
+	return atomic_dec_and_test(v);
+}
+
+static inline int atomic_long_inc_and_test(atomic_long_t *l)
+{
+	atomic_t *v = (atomic_t *)l;
+
+	return atomic_inc_and_test(v);
+}
+
+static inline int atomic_long_add_negative(long i, atomic_long_t *l)
+{
+	atomic_t *v = (atomic_t *)l;
+
+	return atomic_add_negative(i, v);
+}
+
+static inline long atomic_long_add_return(long i, atomic_long_t *l)
+{
+	atomic_t *v = (atomic_t *)l;
+
+	return (long)atomic_add_return(i, v);
+}
+
+static inline long atomic_long_sub_return(long i, atomic_long_t *l)
+{
+	atomic_t *v = (atomic_t *)l;
+
+	return (long)atomic_sub_return(i, v);
+}
+
+static inline long atomic_long_inc_return(atomic_long_t *l)
+{
+	atomic_t *v = (atomic_t *)l;
+
+	return (long)atomic_inc_return(v);
+}
+
+static inline long atomic_long_dec_return(atomic_long_t *l)
+{
+	atomic_t *v = (atomic_t *)l;
+
+	return (long)atomic_dec_return(v);
+}
+
+#define atomic_long_add_unless(l, a, u) \
+	atomic_add_unless((atomic_t *)(l), (a), (u))
+
+#define atomic_long_inc_not_zero(l) atomic_inc_not_zero((atomic_t *)(l))
+
+#define atomic_long_cmpxchg(l, old, new) \
+	(atomic_cmpxchg((atomic_t *)(l), (old), (new)))
+#define atomic_long_xchg(v, new) \
+	(atomic_xchg((atomic_t *)(l), (new)))
+
 #endif  /*  BITS_PER_LONG == 64  */
 
 #endif  /*  _ASM_GENERIC_ATOMIC_H  */
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
