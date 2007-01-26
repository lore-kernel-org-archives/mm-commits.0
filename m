From: akpm@osdl.org
Subject: + local_t-x86_64-extension.patch added to -mm tree
Date: Thu, 25 Jan 2007 21:47:45 -0800
Message-ID: <200701260547.l0Q5ljqV008662@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46769 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030782AbXAZFry (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 00:47:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, ak@suse.de


The patch titled
     local_t: x86_64 extension
has been added to the -mm tree.  Its filename is
     local_t-x86_64-extension.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: local_t: x86_64 extension
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-x86_64/local.h  |  198 ++++++++++++++++++++++++++++------
 include/asm-x86_64/system.h |   36 ++++++
 2 files changed, 202 insertions(+), 32 deletions(-)

diff -puN include/asm-x86_64/local.h~local_t-x86_64-extension include/asm-x86_64/local.h
--- a/include/asm-x86_64/local.h~local_t-x86_64-extension
+++ a/include/asm-x86_64/local.h
@@ -2,49 +2,183 @@
 #define _ARCH_X8664_LOCAL_H
 
 #include <linux/percpu.h>
+#include <asm/atomic.h>
 
 typedef struct
 {
-	volatile long counter;
+	atomic_long_t a;
 } local_t;
 
-#define LOCAL_INIT(i)	{ (i) }
+#define LOCAL_INIT(i)	{ ATOMIC_LONG_INIT(i) }
 
-#define local_read(v)	((v)->counter)
-#define local_set(v,i)	(((v)->counter) = (i))
+#define local_read(l)	atomic_long_read(&(l)->a)
+#define local_set(l,i)	atomic_long_set(&(l)->a, (i))
 
-static inline void local_inc(local_t *v)
+static inline void local_inc(local_t *l)
 {
 	__asm__ __volatile__(
 		"incq %0"
-		:"=m" (v->counter)
-		:"m" (v->counter));
+		:"=m" (l->a.counter)
+		:"m" (l->a.counter));
 }
 
-static inline void local_dec(local_t *v)
+static inline void local_dec(local_t *l)
 {
 	__asm__ __volatile__(
 		"decq %0"
-		:"=m" (v->counter)
-		:"m" (v->counter));
+		:"=m" (l->a.counter)
+		:"m" (l->a.counter));
 }
 
-static inline void local_add(long i, local_t *v)
+static inline void local_add(long i, local_t *l)
 {
 	__asm__ __volatile__(
 		"addq %1,%0"
-		:"=m" (v->counter)
-		:"ir" (i), "m" (v->counter));
+		:"=m" (l->a.counter)
+		:"ir" (i), "m" (l->a.counter));
 }
 
-static inline void local_sub(long i, local_t *v)
+static inline void local_sub(long i, local_t *l)
 {
 	__asm__ __volatile__(
 		"subq %1,%0"
-		:"=m" (v->counter)
-		:"ir" (i), "m" (v->counter));
+		:"=m" (l->a.counter)
+		:"ir" (i), "m" (l->a.counter));
 }
 
+/**
+ * local_sub_and_test - subtract value from variable and test result
+ * @i: integer value to subtract
+ * @l: pointer to type local_t
+ *
+ * Atomically subtracts @i from @l and returns
+ * true if the result is zero, or false for all
+ * other cases.
+ */
+static __inline__ int local_sub_and_test(long i, local_t *l)
+{
+	unsigned char c;
+
+	__asm__ __volatile__(
+		"subq %2,%0; sete %1"
+		:"=m" (l->a.counter), "=qm" (c)
+		:"ir" (i), "m" (l->a.counter) : "memory");
+	return c;
+}
+
+/**
+ * local_dec_and_test - decrement and test
+ * @l: pointer to type local_t
+ *
+ * Atomically decrements @l by 1 and
+ * returns true if the result is 0, or false for all other
+ * cases.
+ */
+static __inline__ int local_dec_and_test(local_t *l)
+{
+	unsigned char c;
+
+	__asm__ __volatile__(
+		"decq %0; sete %1"
+		:"=m" (l->a.counter), "=qm" (c)
+		:"m" (l->a.counter) : "memory");
+	return c != 0;
+}
+
+/**
+ * local_inc_and_test - increment and test
+ * @l: pointer to type local_t
+ *
+ * Atomically increments @l by 1
+ * and returns true if the result is zero, or false for all
+ * other cases.
+ */
+static __inline__ int local_inc_and_test(local_t *l)
+{
+	unsigned char c;
+
+	__asm__ __volatile__(
+		"incq %0; sete %1"
+		:"=m" (l->a.counter), "=qm" (c)
+		:"m" (l->a.counter) : "memory");
+	return c != 0;
+}
+
+/**
+ * local_add_negative - add and test if negative
+ * @i: integer value to add
+ * @l: pointer to type local_t
+ *
+ * Atomically adds @i to @l and returns true
+ * if the result is negative, or false when
+ * result is greater than or equal to zero.
+ */
+static __inline__ int local_add_negative(long i, local_t *l)
+{
+	unsigned char c;
+
+	__asm__ __volatile__(
+		"addq %2,%0; sets %1"
+		:"=m" (l->a.counter), "=qm" (c)
+		:"ir" (i), "m" (l->a.counter) : "memory");
+	return c;
+}
+
+/**
+ * local_add_return - add and return
+ * @i: integer value to add
+ * @l: pointer to type local_t
+ *
+ * Atomically adds @i to @l and returns @i + @l
+ */
+static __inline__ long local_add_return(long i, local_t *l)
+{
+	long __i = i;
+	__asm__ __volatile__(
+		"xaddq %0, %1;"
+		:"+r" (i), "+m" (l->a.counter)
+		: : "memory");
+	return i + __i;
+}
+
+static __inline__ long local_sub_return(long i, local_t *l)
+{
+	return local_add_return(-i,l);
+}
+
+#define local_inc_return(l)  (local_add_return(1,l))
+#define local_dec_return(l)  (local_sub_return(1,l))
+
+#define local_cmpxchg(l, o, n) \
+	((long)cmpxchg_local(&((l)->a.counter), (o), (n)))
+/* Always has a lock prefix anyway */
+#define local_xchg(l, new) (xchg(&((l)->a.counter), new))
+
+/**
+ * atomic_up_add_unless - add unless the number is a given value
+ * @l: pointer of type local_t
+ * @a: the amount to add to l...
+ * @u: ...unless l is equal to u.
+ *
+ * Atomically adds @a to @l, so long as it was not @u.
+ * Returns non-zero if @l was not @u, and zero otherwise.
+ */
+#define local_add_unless(l, a, u)				\
+({								\
+	long c, old;						\
+	c = local_read(l);					\
+	for (;;) {						\
+		if (unlikely(c == (u)))				\
+			break;					\
+		old = local_cmpxchg((l), c, c + (a));	\
+		if (likely(old == c))				\
+			break;					\
+		c = old;					\
+	}							\
+	c != (u);						\
+})
+#define local_inc_not_zero(l) local_add_unless((l), 1, 0)
+
 /* On x86-64 these are better than the atomic variants on SMP kernels
    because they dont use a lock prefix. */
 #define __local_inc(l)		local_inc(l)
@@ -62,27 +196,27 @@ static inline void local_sub(long i, loc
 
 /* Need to disable preemption for the cpu local counters otherwise we could
    still access a variable of a previous CPU in a non atomic way. */
-#define cpu_local_wrap_v(v)	 	\
+#define cpu_local_wrap_v(l)	 	\
 	({ local_t res__;		\
 	   preempt_disable(); 		\
-	   res__ = (v);			\
+	   res__ = (l);			\
 	   preempt_enable();		\
 	   res__; })
-#define cpu_local_wrap(v)		\
+#define cpu_local_wrap(l)		\
 	({ preempt_disable();		\
-	   v;				\
+	   l;				\
 	   preempt_enable(); })		\
 
-#define cpu_local_read(v)    cpu_local_wrap_v(local_read(&__get_cpu_var(v)))
-#define cpu_local_set(v, i)  cpu_local_wrap(local_set(&__get_cpu_var(v), (i)))
-#define cpu_local_inc(v)     cpu_local_wrap(local_inc(&__get_cpu_var(v)))
-#define cpu_local_dec(v)     cpu_local_wrap(local_dec(&__get_cpu_var(v)))
-#define cpu_local_add(i, v)  cpu_local_wrap(local_add((i), &__get_cpu_var(v)))
-#define cpu_local_sub(i, v)  cpu_local_wrap(local_sub((i), &__get_cpu_var(v)))
-
-#define __cpu_local_inc(v)	cpu_local_inc(v)
-#define __cpu_local_dec(v)	cpu_local_dec(v)
-#define __cpu_local_add(i, v)	cpu_local_add((i), (v))
-#define __cpu_local_sub(i, v)	cpu_local_sub((i), (v))
+#define cpu_local_read(l)    cpu_local_wrap_v(local_read(&__get_cpu_var(l)))
+#define cpu_local_set(l, i)  cpu_local_wrap(local_set(&__get_cpu_var(l), (i)))
+#define cpu_local_inc(l)     cpu_local_wrap(local_inc(&__get_cpu_var(l)))
+#define cpu_local_dec(l)     cpu_local_wrap(local_dec(&__get_cpu_var(l)))
+#define cpu_local_add(i, l)  cpu_local_wrap(local_add((i), &__get_cpu_var(l)))
+#define cpu_local_sub(i, l)  cpu_local_wrap(local_sub((i), &__get_cpu_var(l)))
+
+#define __cpu_local_inc(l)	cpu_local_inc(l)
+#define __cpu_local_dec(l)	cpu_local_dec(l)
+#define __cpu_local_add(i, l)	cpu_local_add((i), (l))
+#define __cpu_local_sub(i, l)	cpu_local_sub((i), (l))
 
-#endif /* _ARCH_I386_LOCAL_H */
+#endif /* _ARCH_X8664_LOCAL_H */
diff -puN include/asm-x86_64/system.h~local_t-x86_64-extension include/asm-x86_64/system.h
--- a/include/asm-x86_64/system.h~local_t-x86_64-extension
+++ a/include/asm-x86_64/system.h
@@ -209,9 +209,45 @@ static inline unsigned long __cmpxchg(vo
 	return old;
 }
 
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+			unsigned long old, unsigned long new, int size)
+{
+	unsigned long prev;
+	switch (size) {
+	case 1:
+		__asm__ __volatile__("cmpxchgb %b1,%2"
+				     : "=a"(prev)
+				     : "q"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	case 2:
+		__asm__ __volatile__("cmpxchgw %w1,%2"
+				     : "=a"(prev)
+				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	case 4:
+		__asm__ __volatile__("cmpxchgl %k1,%2"
+				     : "=a"(prev)
+				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	case 8:
+		__asm__ __volatile__("cmpxchgq %1,%2"
+				     : "=a"(prev)
+				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	}
+	return old;
+}
+
 #define cmpxchg(ptr,o,n)\
 	((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
 					(unsigned long)(n),sizeof(*(ptr))))
+#define cmpxchg_local(ptr,o,n)\
+	((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
+					(unsigned long)(n),sizeof(*(ptr))))
 
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
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
local_t-architecture-independent-extension.patch
local_t-alpha-extension.patch
local_t-i386-extension.patch
local_t-ia64-extension.patch
local_t-mips-extension.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-s390-cleanup.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
