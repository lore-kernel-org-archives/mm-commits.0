From: akpm@linux-foundation.org
Subject: +
 asm-generic-add-kasan-instrumentation-to-atomic-operations.patch added to
 -mm tree
Date: Tue, 14 Mar 2017 14:06:58 -0700
Message-ID: <58c85b72.4c4Oy1oD1I0nyUPG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50770 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753043AbdCNVHA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Mar 2017 17:07:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, aryabinin@virtuozzo.com, mark.rutland@arm.com, mingo@redhat.com, peterz@infradead.org, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: asm-generic: add KASAN instrumentation to atomic operations
has been added to the -mm tree.  Its filename is
     asm-generic-add-kasan-instrumentation-to-atomic-operations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/asm-generic-add-kasan-instrumentation-to-atomic-operations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/asm-generic-add-kasan-instrumentation-to-atomic-operations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Vyukov <dvyukov@google.com>
Subject: asm-generic: add KASAN instrumentation to atomic operations

KASAN uses compiler instrumentation to intercept all memory accesses.  But
it does not see memory accesses done in assembly code.  One notable user
of assembly code is atomic operations.  Frequently, for example, an atomic
reference decrement is the last access to an object and a good candidate
for a racy use-after-free.

Add manual KASAN checks to atomic operations.

Link: http://lkml.kernel.org/r/7e450175a324bf93c602909c711bc34715d8e8f2.1489519233.git.dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/atomic-instrumented.h |   36 ++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff -puN include/asm-generic/atomic-instrumented.h~asm-generic-add-kasan-instrumentation-to-atomic-operations include/asm-generic/atomic-instrumented.h
--- a/include/asm-generic/atomic-instrumented.h~asm-generic-add-kasan-instrumentation-to-atomic-operations
+++ a/include/asm-generic/atomic-instrumented.h
@@ -1,50 +1,72 @@
+/*
+ * This file provides wrappers with KASAN instrumentation for atomic operations.
+ * To use this functionality an arch's atomic.h file needs to define all
+ * atomic operations with arch_ prefix (e.g. arch_atomic_read()) and include
+ * this file at the end. This file provides atomic_read() that forwards to
+ * arch_atomic_read() for actual atomic operation.
+ * Note: if an arch atomic operation is implemented by means of other atomic
+ * operations (e.g. atomic_read()/atomic_cmpxchg() loop), then it needs to use
+ * arch_ variants (i.e. arch_atomic_read()/arch_atomic_cmpxchg()) to avoid
+ * double instrumentation.
+ */
 #ifndef _LINUX_ATOMIC_INSTRUMENTED_H
 #define _LINUX_ATOMIC_INSTRUMENTED_H
 
+#include <linux/kasan-checks.h>
+
 static __always_inline int atomic_read(const atomic_t *v)
 {
+	kasan_check_read(v, sizeof(*v));
 	return arch_atomic_read(v);
 }
 
 static __always_inline long long atomic64_read(const atomic64_t *v)
 {
+	kasan_check_read(v, sizeof(*v));
 	return arch_atomic64_read(v);
 }
 
 
 static __always_inline void atomic_set(atomic_t *v, int i)
 {
+	kasan_check_write(v, sizeof(*v));
 	arch_atomic_set(v, i);
 }
 
 static __always_inline void atomic64_set(atomic64_t *v, long long i)
 {
+	kasan_check_write(v, sizeof(*v));
 	arch_atomic64_set(v, i);
 }
 
 static __always_inline int atomic_xchg(atomic_t *v, int i)
 {
+	kasan_check_write(v, sizeof(*v));
 	return arch_atomic_xchg(v, i);
 }
 
 static __always_inline long long atomic64_xchg(atomic64_t *v, long long i)
 {
+	kasan_check_write(v, sizeof(*v));
 	return arch_atomic64_xchg(v, i);
 }
 
 static __always_inline int atomic_cmpxchg(atomic_t *v, int old, int new)
 {
+	kasan_check_write(v, sizeof(*v));
 	return arch_atomic_cmpxchg(v, old, new);
 }
 
 static __always_inline long long atomic64_cmpxchg(atomic64_t *v, long long old,
 						  long long new)
 {
+	kasan_check_write(v, sizeof(*v));
 	return arch_atomic64_cmpxchg(v, old, new);
 }
 
 static __always_inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
+	kasan_check_write(v, sizeof(*v));
 	return __arch_atomic_add_unless(v, a, u);
 }
 
@@ -52,17 +74,20 @@ static __always_inline int __atomic_add_
 static __always_inline bool atomic64_add_unless(atomic64_t *v, long long a,
 						long long u)
 {
+	kasan_check_write(v, sizeof(*v));
 	return arch_atomic64_add_unless(v, a, u);
 }
 
 static __always_inline short int atomic_inc_short(short int *v)
 {
+	kasan_check_write(v, sizeof(*v));
 	return arch_atomic_inc_short(v);
 }
 
 #define __INSTR_VOID1(op, sz)						\
 static __always_inline void atomic##sz##_##op(atomic##sz##_t *v)	\
 {									\
+	kasan_check_write(v, sizeof(*v));				\
 	arch_atomic##sz##_##op(v);					\
 }
 
@@ -79,6 +104,7 @@ INSTR_VOID1(dec);
 #define __INSTR_VOID2(op, sz, type)					\
 static __always_inline void atomic##sz##_##op(type i, atomic##sz##_t *v)\
 {									\
+	kasan_check_write(v, sizeof(*v));				\
 	arch_atomic##sz##_##op(i, v);					\
 }
 
@@ -98,6 +124,7 @@ INSTR_VOID2(xor);
 #define __INSTR_RET1(op, sz, type, rtype)				\
 static __always_inline rtype atomic##sz##_##op(atomic##sz##_t *v)	\
 {									\
+	kasan_check_write(v, sizeof(*v));				\
 	return arch_atomic##sz##_##op(v);				\
 }
 
@@ -124,6 +151,7 @@ INSTR_RET_BOOL1(inc_and_test);
 #define __INSTR_RET2(op, sz, type, rtype)				\
 static __always_inline rtype atomic##sz##_##op(type i, atomic##sz##_t *v) \
 {									\
+	kasan_check_write(v, sizeof(*v));				\
 	return arch_atomic##sz##_##op(i, v);				\
 }
 
@@ -162,48 +190,56 @@ INSTR_RET_BOOL2(add_negative);
 #define xchg(ptr, v)					\
 ({							\
 	__typeof__(ptr) ____ptr = (ptr);		\
+	kasan_check_write(____ptr, sizeof(*____ptr));	\
 	arch_xchg(____ptr, (v));			\
 })
 
 #define cmpxchg(ptr, old, new)				\
 ({							\
 	__typeof__(ptr) ___ptr = (ptr);			\
+	kasan_check_write(___ptr, sizeof(*___ptr));	\
 	arch_cmpxchg(___ptr, (old), (new));		\
 })
 
 #define sync_cmpxchg(ptr, old, new)			\
 ({							\
 	__typeof__(ptr) ___ptr = (ptr);			\
+	kasan_check_write(___ptr, sizeof(*___ptr));	\
 	arch_sync_cmpxchg(___ptr, (old), (new));	\
 })
 
 #define cmpxchg_local(ptr, old, new)			\
 ({							\
 	__typeof__(ptr) ____ptr = (ptr);		\
+	kasan_check_write(____ptr, sizeof(*____ptr));	\
 	arch_cmpxchg_local(____ptr, (old), (new));	\
 })
 
 #define cmpxchg64(ptr, old, new)			\
 ({							\
 	__typeof__(ptr) ____ptr = (ptr);		\
+	kasan_check_write(____ptr, sizeof(*____ptr));	\
 	arch_cmpxchg64(____ptr, (old), (new));		\
 })
 
 #define cmpxchg64_local(ptr, old, new)			\
 ({							\
 	__typeof__(ptr) ____ptr = (ptr);		\
+	kasan_check_write(____ptr, sizeof(*____ptr));	\
 	arch_cmpxchg64_local(____ptr, (old), (new));	\
 })
 
 #define cmpxchg_double(p1, p2, o1, o2, n1, n2)				\
 ({									\
 	__typeof__(p1) ____p1 = (p1);					\
+	kasan_check_write(____p1, 2 * sizeof(*____p1));			\
 	arch_cmpxchg_double(____p1, (p2), (o1), (o2), (n1), (n2));	\
 })
 
 #define cmpxchg_double_local(p1, p2, o1, o2, n1, n2)			\
 ({									\
 	__typeof__(p1) ____p1 = (p1);					\
+	kasan_check_write(____p1, 2 * sizeof(*____p1));			\
 	arch_cmpxchg_double_local(____p1, (p2), (o1), (o2), (n1), (n2));\
 })
 
_

Patches currently in -mm which might be from dvyukov@google.com are

mm-dont-warn-when-vmalloc-fails-due-to-a-fatal-signal.patch
kasan-allow-kasan_check_read-write-to-accept-pointers-to-volatiles.patch
asm-generic-x86-wrap-atomic-operations.patch
asm-generic-add-kasan-instrumentation-to-atomic-operations.patch

