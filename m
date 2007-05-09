From: akpm@linux-foundation.org
Subject: - atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch removed from -mm tree
Date: Tue, 08 May 2007 19:55:05 -0700
Message-ID: <200705090255.l492t5Di009883@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970009AbXEICzQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:55:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     atomic.h: add atomic64 cmpxchg, xchg and add_unless to powerpc
has been removed from the -mm tree.  Its filename was
     atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atomic.h: add atomic64 cmpxchg, xchg and add_unless to powerpc
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

[akpm@linux-foundation.org: build fixes]
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-powerpc/atomic.h |    6 -
 include/asm-powerpc/bitops.h |    1 
 include/asm-powerpc/system.h |  130 ++++++++++++++++++++++++++++++++-
 3 files changed, 131 insertions(+), 6 deletions(-)

diff -puN include/asm-powerpc/atomic.h~atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc include/asm-powerpc/atomic.h
--- a/include/asm-powerpc/atomic.h~atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc
+++ a/include/asm-powerpc/atomic.h
@@ -165,8 +165,7 @@ static __inline__ int atomic_dec_return(
 	return t;
 }
 
-#define atomic_cmpxchg(v, o, n) \
-	((__typeof__((v)->counter))cmpxchg(&((v)->counter), (o), (n)))
+#define atomic_cmpxchg(v, o, n) (cmpxchg(&((v)->counter), (o), (n)))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
 /**
@@ -414,8 +413,7 @@ static __inline__ long atomic64_dec_if_p
 	return t;
 }
 
-#define atomic64_cmpxchg(v, o, n) \
-	((__typeof__((v)->counter))cmpxchg(&((v)->counter), (o), (n)))
+#define atomic64_cmpxchg(v, o, n) (cmpxchg(&((v)->counter), (o), (n)))
 #define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
 
 /**
diff -puN include/asm-powerpc/bitops.h~atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc include/asm-powerpc/bitops.h
--- a/include/asm-powerpc/bitops.h~atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc
+++ a/include/asm-powerpc/bitops.h
@@ -39,7 +39,6 @@
 #ifdef __KERNEL__
 
 #include <linux/compiler.h>
-#include <asm/atomic.h>
 #include <asm/asm-compat.h>
 #include <asm/synch.h>
 
diff -puN include/asm-powerpc/system.h~atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc include/asm-powerpc/system.h
--- a/include/asm-powerpc/system.h~atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc
+++ a/include/asm-powerpc/system.h
@@ -7,7 +7,6 @@
 #include <linux/kernel.h>
 
 #include <asm/hw_irq.h>
-#include <asm/atomic.h>
 
 /*
  * Memory barrier.
@@ -227,6 +226,29 @@ __xchg_u32(volatile void *p, unsigned lo
 	return prev;
 }
 
+/*
+ * Atomic exchange
+ *
+ * Changes the memory location '*ptr' to be val and returns
+ * the previous value stored there.
+ */
+static __inline__ unsigned long
+__xchg_u32_local(volatile void *p, unsigned long val)
+{
+	unsigned long prev;
+
+	__asm__ __volatile__(
+"1:	lwarx	%0,0,%2 \n"
+	PPC405_ERR77(0,%2)
+"	stwcx.	%3,0,%2 \n\
+	bne-	1b"
+	: "=&r" (prev), "+m" (*(volatile unsigned int *)p)
+	: "r" (p), "r" (val)
+	: "cc", "memory");
+
+	return prev;
+}
+
 #ifdef CONFIG_PPC64
 static __inline__ unsigned long
 __xchg_u64(volatile void *p, unsigned long val)
@@ -246,6 +268,23 @@ __xchg_u64(volatile void *p, unsigned lo
 
 	return prev;
 }
+
+static __inline__ unsigned long
+__xchg_u64_local(volatile void *p, unsigned long val)
+{
+	unsigned long prev;
+
+	__asm__ __volatile__(
+"1:	ldarx	%0,0,%2 \n"
+	PPC405_ERR77(0,%2)
+"	stdcx.	%3,0,%2 \n\
+	bne-	1b"
+	: "=&r" (prev), "+m" (*(volatile unsigned long *)p)
+	: "r" (p), "r" (val)
+	: "cc", "memory");
+
+	return prev;
+}
 #endif
 
 /*
@@ -269,12 +308,33 @@ __xchg(volatile void *ptr, unsigned long
 	return x;
 }
 
+static __inline__ unsigned long
+__xchg_local(volatile void *ptr, unsigned long x, unsigned int size)
+{
+	switch (size) {
+	case 4:
+		return __xchg_u32_local(ptr, x);
+#ifdef CONFIG_PPC64
+	case 8:
+		return __xchg_u64_local(ptr, x);
+#endif
+	}
+	__xchg_called_with_bad_pointer();
+	return x;
+}
 #define xchg(ptr,x)							     \
   ({									     \
      __typeof__(*(ptr)) _x_ = (x);					     \
      (__typeof__(*(ptr))) __xchg((ptr), (unsigned long)_x_, sizeof(*(ptr))); \
   })
 
+#define xchg_local(ptr,x)						     \
+  ({									     \
+     __typeof__(*(ptr)) _x_ = (x);					     \
+     (__typeof__(*(ptr))) __xchg_local((ptr),				     \
+     		(unsigned long)_x_, sizeof(*(ptr))); 			     \
+  })
+
 #define tas(ptr) (xchg((ptr),1))
 
 /*
@@ -306,6 +366,28 @@ __cmpxchg_u32(volatile unsigned int *p, 
 	return prev;
 }
 
+static __inline__ unsigned long
+__cmpxchg_u32_local(volatile unsigned int *p, unsigned long old,
+			unsigned long new)
+{
+	unsigned int prev;
+
+	__asm__ __volatile__ (
+"1:	lwarx	%0,0,%2		# __cmpxchg_u32\n\
+	cmpw	0,%0,%3\n\
+	bne-	2f\n"
+	PPC405_ERR77(0,%2)
+"	stwcx.	%4,0,%2\n\
+	bne-	1b"
+	"\n\
+2:"
+	: "=&r" (prev), "+m" (*p)
+	: "r" (p), "r" (old), "r" (new)
+	: "cc", "memory");
+
+	return prev;
+}
+
 #ifdef CONFIG_PPC64
 static __inline__ unsigned long
 __cmpxchg_u64(volatile unsigned long *p, unsigned long old, unsigned long new)
@@ -328,6 +410,27 @@ __cmpxchg_u64(volatile unsigned long *p,
 
 	return prev;
 }
+
+static __inline__ unsigned long
+__cmpxchg_u64_local(volatile unsigned long *p, unsigned long old,
+			unsigned long new)
+{
+	unsigned long prev;
+
+	__asm__ __volatile__ (
+"1:	ldarx	%0,0,%2		# __cmpxchg_u64\n\
+	cmpd	0,%0,%3\n\
+	bne-	2f\n\
+	stdcx.	%4,0,%2\n\
+	bne-	1b"
+	"\n\
+2:"
+	: "=&r" (prev), "+m" (*p)
+	: "r" (p), "r" (old), "r" (new)
+	: "cc", "memory");
+
+	return prev;
+}
 #endif
 
 /* This function doesn't exist, so you'll get a linker error
@@ -350,6 +453,22 @@ __cmpxchg(volatile void *ptr, unsigned l
 	return old;
 }
 
+static __inline__ unsigned long
+__cmpxchg_local(volatile void *ptr, unsigned long old, unsigned long new,
+	  unsigned int size)
+{
+	switch (size) {
+	case 4:
+		return __cmpxchg_u32_local(ptr, old, new);
+#ifdef CONFIG_PPC64
+	case 8:
+		return __cmpxchg_u64_local(ptr, old, new);
+#endif
+	}
+	__cmpxchg_called_with_bad_pointer();
+	return old;
+}
+
 #define cmpxchg(ptr,o,n)						 \
   ({									 \
      __typeof__(*(ptr)) _o_ = (o);					 \
@@ -358,6 +477,15 @@ __cmpxchg(volatile void *ptr, unsigned l
 				    (unsigned long)_n_, sizeof(*(ptr))); \
   })
 
+
+#define cmpxchg_local(ptr,o,n)						 \
+  ({									 \
+     __typeof__(*(ptr)) _o_ = (o);					 \
+     __typeof__(*(ptr)) _n_ = (n);					 \
+     (__typeof__(*(ptr))) __cmpxchg_local((ptr), (unsigned long)_o_,	 \
+				    (unsigned long)_n_, sizeof(*(ptr))); \
+  })
+
 #ifdef CONFIG_PPC64
 /*
  * We handle most unaligned accesses in hardware. On the other hand 
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
