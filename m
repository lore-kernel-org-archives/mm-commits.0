From: akpm@linux-foundation.org
Subject: + new-cmpxchg_local-optimized-for-up-case-for-m32r.patch added to -mm tree
Date: Thu, 01 Nov 2007 12:09:03 -0700
Message-ID: <20071101190903.B97D4432BDE@localhost>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:30194 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbXKATKk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 15:10:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, takata@linux-m32r.org


The patch titled
     New cmpxchg_local (optimized for UP case) for m32r
has been added to the -mm tree.  Its filename is
     new-cmpxchg_local-optimized-for-up-case-for-m32r.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: New cmpxchg_local (optimized for UP case) for m32r
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Add __xchg_local, xchg_local (define), __cmpxchg_local_u32, __cmpxchg_local,
cmpxchg_local(macro).

cmpxchg_local and cmpxchg64_local will use the architecture specific
__cmpxchg_local_u32 for 32 bits arguments, and use the generic
__cmpxchg_local_generic for 8, 16 and 64 bits arguments.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-m32r/system.h |  111 ++++++++++++++++++++++++++++++++----
 1 file changed, 101 insertions(+), 10 deletions(-)

diff -puN include/asm-m32r/system.h~new-cmpxchg_local-optimized-for-up-case-for-m32r include/asm-m32r/system.h
--- a/include/asm-m32r/system.h~new-cmpxchg_local-optimized-for-up-case-for-m32r
+++ a/include/asm-m32r/system.h
@@ -121,8 +121,11 @@ static inline void local_irq_disable(voi
 
 #define nop()	__asm__ __volatile__ ("nop" : : )
 
-#define xchg(ptr,x) \
-	((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
+#define xchg(ptr, x)							\
+	((__typeof__(*(ptr)))__xchg((unsigned long)(x), (ptr), sizeof(*(ptr))))
+#define xchg_local(ptr, x)						\
+	((__typeof__(*(ptr)))__xchg_local((unsigned long)(x), (ptr),	\
+			sizeof(*(ptr))))
 
 #ifdef CONFIG_SMP
 extern void  __xchg_called_with_bad_pointer(void);
@@ -146,7 +149,7 @@ extern void  __xchg_called_with_bad_poin
 #endif	/* CONFIG_CHIP_M32700_TS1 */
 
 static __always_inline unsigned long
-__xchg(unsigned long x, volatile void * ptr, int size)
+__xchg(unsigned long x, volatile void *ptr, int size)
 {
 	unsigned long flags;
 	unsigned long tmp = 0;
@@ -196,6 +199,42 @@ __xchg(unsigned long x, volatile void * 
 	return (tmp);
 }
 
+static __always_inline unsigned long
+__xchg_local(unsigned long x, volatile void *ptr, int size)
+{
+	unsigned long flags;
+	unsigned long tmp = 0;
+
+	local_irq_save(flags);
+
+	switch (size) {
+	case 1:
+		__asm__ __volatile__ (
+			"ldb	%0, @%2 \n\t"
+			"stb	%1, @%2 \n\t"
+			: "=&r" (tmp) : "r" (x), "r" (ptr) : "memory");
+		break;
+	case 2:
+		__asm__ __volatile__ (
+			"ldh	%0, @%2 \n\t"
+			"sth	%1, @%2 \n\t"
+			: "=&r" (tmp) : "r" (x), "r" (ptr) : "memory");
+		break;
+	case 4:
+		__asm__ __volatile__ (
+			"ld	%0, @%2 \n\t"
+			"st	%1, @%2 \n\t"
+			: "=&r" (tmp) : "r" (x), "r" (ptr) : "memory");
+		break;
+	default:
+		__xchg_called_with_bad_pointer();
+	}
+
+	local_irq_restore(flags);
+
+	return (tmp);
+}
+
 #define __HAVE_ARCH_CMPXCHG	1
 
 static inline unsigned long
@@ -228,6 +267,37 @@ __cmpxchg_u32(volatile unsigned int *p, 
 	return retval;
 }
 
+static inline unsigned long
+__cmpxchg_local_u32(volatile unsigned int *p, unsigned int old,
+			unsigned int new)
+{
+	unsigned long flags;
+	unsigned int retval;
+
+	local_irq_save(flags);
+	__asm__ __volatile__ (
+			DCACHE_CLEAR("%0", "r4", "%1")
+			"ld %0, @%1;		\n"
+		"	bne	%0, %2, 1f;	\n"
+			"st %3, @%1;		\n"
+		"	bra	2f;		\n"
+		"       .fillinsn		\n"
+		"1:"
+			"st %0, @%1;		\n"
+		"       .fillinsn		\n"
+		"2:"
+			: "=&r" (retval)
+			: "r" (p), "r" (old), "r" (new)
+			: "cbit", "memory"
+#ifdef CONFIG_CHIP_M32700_TS1
+			, "r4"
+#endif  /* CONFIG_CHIP_M32700_TS1 */
+		);
+	local_irq_restore(flags);
+
+	return retval;
+}
+
 /* This function doesn't exist, so you'll get a linker error
    if something tries to do an invalid cmpxchg().  */
 extern void __cmpxchg_called_with_bad_pointer(void);
@@ -247,13 +317,34 @@ __cmpxchg(volatile void *ptr, unsigned l
 	return old;
 }
 
-#define cmpxchg(ptr,o,n)						 \
-  ({									 \
-     __typeof__(*(ptr)) _o_ = (o);					 \
-     __typeof__(*(ptr)) _n_ = (n);					 \
-     (__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,		 \
-				    (unsigned long)_n_, sizeof(*(ptr))); \
-  })
+#define cmpxchg(ptr, o, n)						 \
+	((__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)(o),	 \
+			(unsigned long)(n), sizeof(*(ptr))))
+
+#include <asm-generic/cmpxchg-local.h>
+
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+				      unsigned long old,
+				      unsigned long new, int size)
+{
+	switch (size) {
+	case 4:
+		return __cmpxchg_local_u32(ptr, old, new);
+	default:
+		return __cmpxchg_local_generic(ptr, old, new, size);
+	}
+
+	return old;
+}
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr, o, n)				  	    \
+	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	    \
+			(unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
 
 #endif  /* __KERNEL__ */
 
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

local_t-documentation-update-2.patch
markers-fix-warnings.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
fall-back-on-interrupt-disable-in-cmpxchg8b-on-80386-and-80486.patch
add-cmpxchg64-and-cmpxchg64_local-to-alpha.patch
add-cmpxchg64-and-cmpxchg64_local-to-mips.patch
add-cmpxchg64-and-cmpxchg64_local-to-powerpc.patch
add-cmpxchg64-and-cmpxchg64_local-to-x86_64.patch
add-cmpxchg_local-to-arm.patch
add-cmpxchg_local-to-avr32.patch
add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
add-cmpxchg_local-to-cris.patch
add-cmpxchg_local-to-frv.patch
add-cmpxchg_local-to-h8300.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
new-cmpxchg_local-optimized-for-up-case-for-m32r.patch
fix-m32r-__xchg.patch
m32r-build-fix-of-arch-m32r-kernel-smpbootc.patch
local_t-m32r-use-architecture-specific-cmpxchg_local.patch
add-cmpxchg_local-to-m86k.patch
add-cmpxchg_local-to-m68knommu.patch
add-cmpxchg_local-to-parisc.patch
add-cmpxchg_local-to-ppc.patch
add-cmpxchg_local-to-s390.patch
add-cmpxchg_local-to-sh-use-generic-cmpxchg-instead-of-cmpxchg_u32.patch
add-cmpxchg_local-to-sh64.patch
add-cmpxchg_local-to-sparc-move-__cmpxchg-to-systemh.patch
add-cmpxchg_local-to-sparc64.patch
add-cmpxchg_local-to-v850.patch
add-cmpxchg_local-to-xtensa.patch
