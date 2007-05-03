From: akpm@linux-foundation.org
Subject: + x86-create-asm-cmpxchgh.patch added to -mm tree
Date: Wed, 02 May 2007 23:08:45 -0700
Message-ID: <200705030608.l4368jZM006028@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:32805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754540AbXECGIw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 02:08:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, ak@suse.de, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     x86: create asm/cmpxchg.h
has been added to the -mm tree.  Its filename is
     x86-create-asm-cmpxchgh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86: create asm/cmpxchg.h
From: Jeff Dike <jdike@addtoit.com>

i386:

  Rearrange the cmpxchg code to allow atomic.h to get it without needing to
  include system.h.  This kills warnings in the UML build from atomic.h about
  implicit declarations of cmpxchg symbols.  The i386 build presumably isn't
  seeing this because a separate inclusion of system.h is covering it over.

  The cmpxchg stuff is moved to asm-i386/cmpxchg.h, with an include left in
  system.h for the benefit of generic code which expects cmpxchg there.

  Meanwhile, atomic.h includes cmpxchg.h.

  This causes no noticable damage to the i386 build.


x86_64:

  Move cmpxchg into its own header.  atomic.h already included system.h, so
  this is changed to include cmpxchg.h.

  This is purely cleanup - it's not fixing any warnings - so if the x86_64
  system.h isn't considered as cleanup-worthy as i386, then this can be
  dropped.

  It causes no noticable damage to the x86_64 build.


uml:

  The i386 and x86_64 cmpxchg patches require an asm-um/cmpxchg.h for the
  UML build.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/atomic.h    |    1 
 include/asm-i386/cmpxchg.h   |  293 +++++++++++++++++++++++++++++++++
 include/asm-i386/system.h    |  289 --------------------------------
 include/asm-um/cmpxchg.h     |    6 
 include/asm-x86_64/atomic.h  |    2 
 include/asm-x86_64/cmpxchg.h |  134 +++++++++++++++
 include/asm-x86_64/system.h  |  130 --------------
 7 files changed, 437 insertions(+), 418 deletions(-)

diff -puN include/asm-i386/atomic.h~x86-create-asm-cmpxchgh include/asm-i386/atomic.h
--- a/include/asm-i386/atomic.h~x86-create-asm-cmpxchgh
+++ a/include/asm-i386/atomic.h
@@ -3,6 +3,7 @@
 
 #include <linux/compiler.h>
 #include <asm/processor.h>
+#include <asm/cmpxchg.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
diff -puN /dev/null include/asm-i386/cmpxchg.h
--- /dev/null
+++ a/include/asm-i386/cmpxchg.h
@@ -0,0 +1,293 @@
+#ifndef __ASM_CMPXCHG_H
+#define __ASM_CMPXCHG_H
+
+#include <linux/bitops.h> /* for LOCK_PREFIX */
+
+#define xchg(ptr,v) ((__typeof__(*(ptr)))__xchg((unsigned long)(v),(ptr),sizeof(*(ptr))))
+
+struct __xchg_dummy { unsigned long a[100]; };
+#define __xg(x) ((struct __xchg_dummy *)(x))
+
+
+#ifdef CONFIG_X86_CMPXCHG64
+
+/*
+ * The semantics of XCHGCMP8B are a bit strange, this is why
+ * there is a loop and the loading of %%eax and %%edx has to
+ * be inside. This inlines well in most cases, the cached
+ * cost is around ~38 cycles. (in the future we might want
+ * to do an SIMD/3DNOW!/MMX/FPU 64-bit store here, but that
+ * might have an implicit FPU-save as a cost, so it's not
+ * clear which path to go.)
+ *
+ * cmpxchg8b must be used with the lock prefix here to allow
+ * the instruction to be executed atomically, see page 3-102
+ * of the instruction set reference 24319102.pdf. We need
+ * the reader side to see the coherent 64bit value.
+ */
+static inline void __set_64bit (unsigned long long * ptr,
+		unsigned int low, unsigned int high)
+{
+	__asm__ __volatile__ (
+		"\n1:\t"
+		"movl (%0), %%eax\n\t"
+		"movl 4(%0), %%edx\n\t"
+		"lock cmpxchg8b (%0)\n\t"
+		"jnz 1b"
+		: /* no outputs */
+		:	"D"(ptr),
+			"b"(low),
+			"c"(high)
+		:	"ax","dx","memory");
+}
+
+static inline void __set_64bit_constant (unsigned long long *ptr,
+						 unsigned long long value)
+{
+	__set_64bit(ptr,(unsigned int)(value), (unsigned int)((value)>>32ULL));
+}
+#define ll_low(x)	*(((unsigned int*)&(x))+0)
+#define ll_high(x)	*(((unsigned int*)&(x))+1)
+
+static inline void __set_64bit_var (unsigned long long *ptr,
+			 unsigned long long value)
+{
+	__set_64bit(ptr,ll_low(value), ll_high(value));
+}
+
+#define set_64bit(ptr,value) \
+(__builtin_constant_p(value) ? \
+ __set_64bit_constant(ptr, value) : \
+ __set_64bit_var(ptr, value) )
+
+#define _set_64bit(ptr,value) \
+(__builtin_constant_p(value) ? \
+ __set_64bit(ptr, (unsigned int)(value), (unsigned int)((value)>>32ULL) ) : \
+ __set_64bit(ptr, ll_low(value), ll_high(value)) )
+
+#endif
+
+/*
+ * Note: no "lock" prefix even on SMP: xchg always implies lock anyway
+ * Note 2: xchg has side effect, so that attribute volatile is necessary,
+ *	  but generally the primitive is invalid, *ptr is output argument. --ANK
+ */
+static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int size)
+{
+	switch (size) {
+		case 1:
+			__asm__ __volatile__("xchgb %b0,%1"
+				:"=q" (x)
+				:"m" (*__xg(ptr)), "0" (x)
+				:"memory");
+			break;
+		case 2:
+			__asm__ __volatile__("xchgw %w0,%1"
+				:"=r" (x)
+				:"m" (*__xg(ptr)), "0" (x)
+				:"memory");
+			break;
+		case 4:
+			__asm__ __volatile__("xchgl %0,%1"
+				:"=r" (x)
+				:"m" (*__xg(ptr)), "0" (x)
+				:"memory");
+			break;
+	}
+	return x;
+}
+
+/*
+ * Atomic compare and exchange.  Compare OLD with MEM, if identical,
+ * store NEW in MEM.  Return the initial value in MEM.  Success is
+ * indicated by comparing RETURN with OLD.
+ */
+
+#ifdef CONFIG_X86_CMPXCHG
+#define __HAVE_ARCH_CMPXCHG 1
+#define cmpxchg(ptr,o,n)\
+	((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
+					(unsigned long)(n),sizeof(*(ptr))))
+#define sync_cmpxchg(ptr,o,n)\
+	((__typeof__(*(ptr)))__sync_cmpxchg((ptr),(unsigned long)(o),\
+					(unsigned long)(n),sizeof(*(ptr))))
+#define cmpxchg_local(ptr,o,n)\
+	((__typeof__(*(ptr)))__cmpxchg_local((ptr),(unsigned long)(o),\
+					(unsigned long)(n),sizeof(*(ptr))))
+#endif
+
+static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
+				      unsigned long new, int size)
+{
+	unsigned long prev;
+	switch (size) {
+	case 1:
+		__asm__ __volatile__(LOCK_PREFIX "cmpxchgb %b1,%2"
+				     : "=a"(prev)
+				     : "q"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	case 2:
+		__asm__ __volatile__(LOCK_PREFIX "cmpxchgw %w1,%2"
+				     : "=a"(prev)
+				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	case 4:
+		__asm__ __volatile__(LOCK_PREFIX "cmpxchgl %1,%2"
+				     : "=a"(prev)
+				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	}
+	return old;
+}
+
+/*
+ * Always use locked operations when touching memory shared with a
+ * hypervisor, since the system may be SMP even if the guest kernel
+ * isn't.
+ */
+static inline unsigned long __sync_cmpxchg(volatile void *ptr,
+					    unsigned long old,
+					    unsigned long new, int size)
+{
+	unsigned long prev;
+	switch (size) {
+	case 1:
+		__asm__ __volatile__("lock; cmpxchgb %b1,%2"
+				     : "=a"(prev)
+				     : "q"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	case 2:
+		__asm__ __volatile__("lock; cmpxchgw %w1,%2"
+				     : "=a"(prev)
+				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	case 4:
+		__asm__ __volatile__("lock; cmpxchgl %1,%2"
+				     : "=a"(prev)
+				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	}
+	return old;
+}
+
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
+		__asm__ __volatile__("cmpxchgl %1,%2"
+				     : "=a"(prev)
+				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	}
+	return old;
+}
+
+#ifndef CONFIG_X86_CMPXCHG
+/*
+ * Building a kernel capable running on 80386. It may be necessary to
+ * simulate the cmpxchg on the 80386 CPU. For that purpose we define
+ * a function for each of the sizes we support.
+ */
+
+extern unsigned long cmpxchg_386_u8(volatile void *, u8, u8);
+extern unsigned long cmpxchg_386_u16(volatile void *, u16, u16);
+extern unsigned long cmpxchg_386_u32(volatile void *, u32, u32);
+
+static inline unsigned long cmpxchg_386(volatile void *ptr, unsigned long old,
+				      unsigned long new, int size)
+{
+	switch (size) {
+	case 1:
+		return cmpxchg_386_u8(ptr, old, new);
+	case 2:
+		return cmpxchg_386_u16(ptr, old, new);
+	case 4:
+		return cmpxchg_386_u32(ptr, old, new);
+	}
+	return old;
+}
+
+#define cmpxchg(ptr,o,n)						\
+({									\
+	__typeof__(*(ptr)) __ret;					\
+	if (likely(boot_cpu_data.x86 > 3))				\
+		__ret = __cmpxchg((ptr), (unsigned long)(o),		\
+					(unsigned long)(n), sizeof(*(ptr))); \
+	else								\
+		__ret = cmpxchg_386((ptr), (unsigned long)(o),		\
+					(unsigned long)(n), sizeof(*(ptr))); \
+	__ret;								\
+})
+#define cmpxchg_local(ptr,o,n)						\
+({									\
+	__typeof__(*(ptr)) __ret;					\
+	if (likely(boot_cpu_data.x86 > 3))				\
+		__ret = __cmpxchg_local((ptr), (unsigned long)(o),	\
+					(unsigned long)(n), sizeof(*(ptr))); \
+	else								\
+		__ret = cmpxchg_386((ptr), (unsigned long)(o),		\
+					(unsigned long)(n), sizeof(*(ptr))); \
+	__ret;								\
+})
+#endif
+
+#ifdef CONFIG_X86_CMPXCHG64
+
+static inline unsigned long long __cmpxchg64(volatile void *ptr, unsigned long long old,
+				      unsigned long long new)
+{
+	unsigned long long prev;
+	__asm__ __volatile__(LOCK_PREFIX "cmpxchg8b %3"
+			     : "=A"(prev)
+			     : "b"((unsigned long)new),
+			       "c"((unsigned long)(new >> 32)),
+			       "m"(*__xg(ptr)),
+			       "0"(old)
+			     : "memory");
+	return prev;
+}
+
+static inline unsigned long long __cmpxchg64_local(volatile void *ptr,
+			unsigned long long old, unsigned long long new)
+{
+	unsigned long long prev;
+	__asm__ __volatile__("cmpxchg8b %3"
+			     : "=A"(prev)
+			     : "b"((unsigned long)new),
+			       "c"((unsigned long)(new >> 32)),
+			       "m"(*__xg(ptr)),
+			       "0"(old)
+			     : "memory");
+	return prev;
+}
+
+#define cmpxchg64(ptr,o,n)\
+	((__typeof__(*(ptr)))__cmpxchg64((ptr),(unsigned long long)(o),\
+					(unsigned long long)(n)))
+#define cmpxchg64_local(ptr,o,n)\
+	((__typeof__(*(ptr)))__cmpxchg64_local((ptr),(unsigned long long)(o),\
+					(unsigned long long)(n)))
+#endif
+
+#endif
diff -puN include/asm-i386/system.h~x86-create-asm-cmpxchgh include/asm-i386/system.h
--- a/include/asm-i386/system.h~x86-create-asm-cmpxchgh
+++ a/include/asm-i386/system.h
@@ -4,7 +4,7 @@
 #include <linux/kernel.h>
 #include <asm/segment.h>
 #include <asm/cpufeature.h>
-#include <linux/bitops.h> /* for LOCK_PREFIX */
+#include <asm/cmpxchg.h>
 
 #ifdef __KERNEL__
 
@@ -195,293 +195,6 @@ static inline unsigned long get_limit(un
 
 #define nop() __asm__ __volatile__ ("nop")
 
-#define xchg(ptr,v) ((__typeof__(*(ptr)))__xchg((unsigned long)(v),(ptr),sizeof(*(ptr))))
-
-struct __xchg_dummy { unsigned long a[100]; };
-#define __xg(x) ((struct __xchg_dummy *)(x))
-
-
-#ifdef CONFIG_X86_CMPXCHG64
-
-/*
- * The semantics of XCHGCMP8B are a bit strange, this is why
- * there is a loop and the loading of %%eax and %%edx has to
- * be inside. This inlines well in most cases, the cached
- * cost is around ~38 cycles. (in the future we might want
- * to do an SIMD/3DNOW!/MMX/FPU 64-bit store here, but that
- * might have an implicit FPU-save as a cost, so it's not
- * clear which path to go.)
- *
- * cmpxchg8b must be used with the lock prefix here to allow
- * the instruction to be executed atomically, see page 3-102
- * of the instruction set reference 24319102.pdf. We need
- * the reader side to see the coherent 64bit value.
- */
-static inline void __set_64bit (unsigned long long * ptr,
-		unsigned int low, unsigned int high)
-{
-	__asm__ __volatile__ (
-		"\n1:\t"
-		"movl (%0), %%eax\n\t"
-		"movl 4(%0), %%edx\n\t"
-		"lock cmpxchg8b (%0)\n\t"
-		"jnz 1b"
-		: /* no outputs */
-		:	"D"(ptr),
-			"b"(low),
-			"c"(high)
-		:	"ax","dx","memory");
-}
-
-static inline void __set_64bit_constant (unsigned long long *ptr,
-						 unsigned long long value)
-{
-	__set_64bit(ptr,(unsigned int)(value), (unsigned int)((value)>>32ULL));
-}
-#define ll_low(x)	*(((unsigned int*)&(x))+0)
-#define ll_high(x)	*(((unsigned int*)&(x))+1)
-
-static inline void __set_64bit_var (unsigned long long *ptr,
-			 unsigned long long value)
-{
-	__set_64bit(ptr,ll_low(value), ll_high(value));
-}
-
-#define set_64bit(ptr,value) \
-(__builtin_constant_p(value) ? \
- __set_64bit_constant(ptr, value) : \
- __set_64bit_var(ptr, value) )
-
-#define _set_64bit(ptr,value) \
-(__builtin_constant_p(value) ? \
- __set_64bit(ptr, (unsigned int)(value), (unsigned int)((value)>>32ULL) ) : \
- __set_64bit(ptr, ll_low(value), ll_high(value)) )
-
-#endif
-
-/*
- * Note: no "lock" prefix even on SMP: xchg always implies lock anyway
- * Note 2: xchg has side effect, so that attribute volatile is necessary,
- *	  but generally the primitive is invalid, *ptr is output argument. --ANK
- */
-static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int size)
-{
-	switch (size) {
-		case 1:
-			__asm__ __volatile__("xchgb %b0,%1"
-				:"=q" (x)
-				:"m" (*__xg(ptr)), "0" (x)
-				:"memory");
-			break;
-		case 2:
-			__asm__ __volatile__("xchgw %w0,%1"
-				:"=r" (x)
-				:"m" (*__xg(ptr)), "0" (x)
-				:"memory");
-			break;
-		case 4:
-			__asm__ __volatile__("xchgl %0,%1"
-				:"=r" (x)
-				:"m" (*__xg(ptr)), "0" (x)
-				:"memory");
-			break;
-	}
-	return x;
-}
-
-/*
- * Atomic compare and exchange.  Compare OLD with MEM, if identical,
- * store NEW in MEM.  Return the initial value in MEM.  Success is
- * indicated by comparing RETURN with OLD.
- */
-
-#ifdef CONFIG_X86_CMPXCHG
-#define __HAVE_ARCH_CMPXCHG 1
-#define cmpxchg(ptr,o,n)\
-	((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
-					(unsigned long)(n),sizeof(*(ptr))))
-#define sync_cmpxchg(ptr,o,n)\
-	((__typeof__(*(ptr)))__sync_cmpxchg((ptr),(unsigned long)(o),\
-					(unsigned long)(n),sizeof(*(ptr))))
-#define cmpxchg_local(ptr,o,n)\
-	((__typeof__(*(ptr)))__cmpxchg_local((ptr),(unsigned long)(o),\
-					(unsigned long)(n),sizeof(*(ptr))))
-#endif
-
-static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
-				      unsigned long new, int size)
-{
-	unsigned long prev;
-	switch (size) {
-	case 1:
-		__asm__ __volatile__(LOCK_PREFIX "cmpxchgb %b1,%2"
-				     : "=a"(prev)
-				     : "q"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	case 2:
-		__asm__ __volatile__(LOCK_PREFIX "cmpxchgw %w1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	case 4:
-		__asm__ __volatile__(LOCK_PREFIX "cmpxchgl %1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	}
-	return old;
-}
-
-/*
- * Always use locked operations when touching memory shared with a
- * hypervisor, since the system may be SMP even if the guest kernel
- * isn't.
- */
-static inline unsigned long __sync_cmpxchg(volatile void *ptr,
-					    unsigned long old,
-					    unsigned long new, int size)
-{
-	unsigned long prev;
-	switch (size) {
-	case 1:
-		__asm__ __volatile__("lock; cmpxchgb %b1,%2"
-				     : "=a"(prev)
-				     : "q"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	case 2:
-		__asm__ __volatile__("lock; cmpxchgw %w1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	case 4:
-		__asm__ __volatile__("lock; cmpxchgl %1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	}
-	return old;
-}
-
-static inline unsigned long __cmpxchg_local(volatile void *ptr,
-			unsigned long old, unsigned long new, int size)
-{
-	unsigned long prev;
-	switch (size) {
-	case 1:
-		__asm__ __volatile__("cmpxchgb %b1,%2"
-				     : "=a"(prev)
-				     : "q"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	case 2:
-		__asm__ __volatile__("cmpxchgw %w1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	case 4:
-		__asm__ __volatile__("cmpxchgl %1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	}
-	return old;
-}
-
-#ifndef CONFIG_X86_CMPXCHG
-/*
- * Building a kernel capable running on 80386. It may be necessary to
- * simulate the cmpxchg on the 80386 CPU. For that purpose we define
- * a function for each of the sizes we support.
- */
-
-extern unsigned long cmpxchg_386_u8(volatile void *, u8, u8);
-extern unsigned long cmpxchg_386_u16(volatile void *, u16, u16);
-extern unsigned long cmpxchg_386_u32(volatile void *, u32, u32);
-
-static inline unsigned long cmpxchg_386(volatile void *ptr, unsigned long old,
-				      unsigned long new, int size)
-{
-	switch (size) {
-	case 1:
-		return cmpxchg_386_u8(ptr, old, new);
-	case 2:
-		return cmpxchg_386_u16(ptr, old, new);
-	case 4:
-		return cmpxchg_386_u32(ptr, old, new);
-	}
-	return old;
-}
-
-#define cmpxchg(ptr,o,n)						\
-({									\
-	__typeof__(*(ptr)) __ret;					\
-	if (likely(boot_cpu_data.x86 > 3))				\
-		__ret = __cmpxchg((ptr), (unsigned long)(o),		\
-					(unsigned long)(n), sizeof(*(ptr))); \
-	else								\
-		__ret = cmpxchg_386((ptr), (unsigned long)(o),		\
-					(unsigned long)(n), sizeof(*(ptr))); \
-	__ret;								\
-})
-#define cmpxchg_local(ptr,o,n)						\
-({									\
-	__typeof__(*(ptr)) __ret;					\
-	if (likely(boot_cpu_data.x86 > 3))				\
-		__ret = __cmpxchg_local((ptr), (unsigned long)(o),	\
-					(unsigned long)(n), sizeof(*(ptr))); \
-	else								\
-		__ret = cmpxchg_386((ptr), (unsigned long)(o),		\
-					(unsigned long)(n), sizeof(*(ptr))); \
-	__ret;								\
-})
-#endif
-
-#ifdef CONFIG_X86_CMPXCHG64
-
-static inline unsigned long long __cmpxchg64(volatile void *ptr, unsigned long long old,
-				      unsigned long long new)
-{
-	unsigned long long prev;
-	__asm__ __volatile__(LOCK_PREFIX "cmpxchg8b %3"
-			     : "=A"(prev)
-			     : "b"((unsigned long)new),
-			       "c"((unsigned long)(new >> 32)),
-			       "m"(*__xg(ptr)),
-			       "0"(old)
-			     : "memory");
-	return prev;
-}
-
-static inline unsigned long long __cmpxchg64_local(volatile void *ptr,
-			unsigned long long old, unsigned long long new)
-{
-	unsigned long long prev;
-	__asm__ __volatile__("cmpxchg8b %3"
-			     : "=A"(prev)
-			     : "b"((unsigned long)new),
-			       "c"((unsigned long)(new >> 32)),
-			       "m"(*__xg(ptr)),
-			       "0"(old)
-			     : "memory");
-	return prev;
-}
-
-#define cmpxchg64(ptr,o,n)\
-	((__typeof__(*(ptr)))__cmpxchg64((ptr),(unsigned long long)(o),\
-					(unsigned long long)(n)))
-#define cmpxchg64_local(ptr,o,n)\
-	((__typeof__(*(ptr)))__cmpxchg64_local((ptr),(unsigned long long)(o),\
-					(unsigned long long)(n)))
-#endif
-    
 /*
  * Force strict CPU ordering.
  * And yes, this is required on UP too when we're talking
diff -puN include/asm-x86_64/atomic.h~x86-create-asm-cmpxchgh include/asm-x86_64/atomic.h
--- a/include/asm-x86_64/atomic.h~x86-create-asm-cmpxchgh
+++ a/include/asm-x86_64/atomic.h
@@ -2,7 +2,7 @@
 #define __ARCH_X86_64_ATOMIC__
 
 #include <asm/alternative.h>
-#include <asm/system.h>
+#include <asm/cmpxchg.h>
 
 /* atomic_t should be 32 bit signed type */
 
diff -puN /dev/null include/asm-x86_64/cmpxchg.h
--- /dev/null
+++ a/include/asm-x86_64/cmpxchg.h
@@ -0,0 +1,134 @@
+#ifndef __ASM_CMPXCHG_H
+#define __ASM_CMPXCHG_H
+
+#include <asm/alternative.h> /* Provides LOCK_PREFIX */
+
+#define xchg(ptr,v) ((__typeof__(*(ptr)))__xchg((unsigned long)(v),(ptr),sizeof(*(ptr))))
+
+#define __xg(x) ((volatile long *)(x))
+
+static inline void set_64bit(volatile unsigned long *ptr, unsigned long val)
+{
+	*ptr = val;
+}
+
+#define _set_64bit set_64bit
+
+/*
+ * Note: no "lock" prefix even on SMP: xchg always implies lock anyway
+ * Note 2: xchg has side effect, so that attribute volatile is necessary,
+ *	  but generally the primitive is invalid, *ptr is output argument. --ANK
+ */
+static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int size)
+{
+	switch (size) {
+		case 1:
+			__asm__ __volatile__("xchgb %b0,%1"
+				:"=q" (x)
+				:"m" (*__xg(ptr)), "0" (x)
+				:"memory");
+			break;
+		case 2:
+			__asm__ __volatile__("xchgw %w0,%1"
+				:"=r" (x)
+				:"m" (*__xg(ptr)), "0" (x)
+				:"memory");
+			break;
+		case 4:
+			__asm__ __volatile__("xchgl %k0,%1"
+				:"=r" (x)
+				:"m" (*__xg(ptr)), "0" (x)
+				:"memory");
+			break;
+		case 8:
+			__asm__ __volatile__("xchgq %0,%1"
+				:"=r" (x)
+				:"m" (*__xg(ptr)), "0" (x)
+				:"memory");
+			break;
+	}
+	return x;
+}
+
+/*
+ * Atomic compare and exchange.  Compare OLD with MEM, if identical,
+ * store NEW in MEM.  Return the initial value in MEM.  Success is
+ * indicated by comparing RETURN with OLD.
+ */
+
+#define __HAVE_ARCH_CMPXCHG 1
+
+static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
+				      unsigned long new, int size)
+{
+	unsigned long prev;
+	switch (size) {
+	case 1:
+		__asm__ __volatile__(LOCK_PREFIX "cmpxchgb %b1,%2"
+				     : "=a"(prev)
+				     : "q"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	case 2:
+		__asm__ __volatile__(LOCK_PREFIX "cmpxchgw %w1,%2"
+				     : "=a"(prev)
+				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	case 4:
+		__asm__ __volatile__(LOCK_PREFIX "cmpxchgl %k1,%2"
+				     : "=a"(prev)
+				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	case 8:
+		__asm__ __volatile__(LOCK_PREFIX "cmpxchgq %1,%2"
+				     : "=a"(prev)
+				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	}
+	return old;
+}
+
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
+#define cmpxchg(ptr,o,n)\
+	((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
+					(unsigned long)(n),sizeof(*(ptr))))
+#define cmpxchg_local(ptr,o,n)\
+	((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
+					(unsigned long)(n),sizeof(*(ptr))))
+
+#endif
diff -puN include/asm-x86_64/system.h~x86-create-asm-cmpxchgh include/asm-x86_64/system.h
--- a/include/asm-x86_64/system.h~x86-create-asm-cmpxchgh
+++ a/include/asm-x86_64/system.h
@@ -3,7 +3,7 @@
 
 #include <linux/kernel.h>
 #include <asm/segment.h>
-#include <asm/alternative.h>
+#include <asm/cmpxchg.h>
 
 #ifdef __KERNEL__
 
@@ -124,134 +124,6 @@ static inline void sched_cacheflush(void
 
 #define nop() __asm__ __volatile__ ("nop")
 
-#define xchg(ptr,v) ((__typeof__(*(ptr)))__xchg((unsigned long)(v),(ptr),sizeof(*(ptr))))
-
-#define __xg(x) ((volatile long *)(x))
-
-static inline void set_64bit(volatile unsigned long *ptr, unsigned long val)
-{
-	*ptr = val;
-}
-
-#define _set_64bit set_64bit
-
-/*
- * Note: no "lock" prefix even on SMP: xchg always implies lock anyway
- * Note 2: xchg has side effect, so that attribute volatile is necessary,
- *	  but generally the primitive is invalid, *ptr is output argument. --ANK
- */
-static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int size)
-{
-	switch (size) {
-		case 1:
-			__asm__ __volatile__("xchgb %b0,%1"
-				:"=q" (x)
-				:"m" (*__xg(ptr)), "0" (x)
-				:"memory");
-			break;
-		case 2:
-			__asm__ __volatile__("xchgw %w0,%1"
-				:"=r" (x)
-				:"m" (*__xg(ptr)), "0" (x)
-				:"memory");
-			break;
-		case 4:
-			__asm__ __volatile__("xchgl %k0,%1"
-				:"=r" (x)
-				:"m" (*__xg(ptr)), "0" (x)
-				:"memory");
-			break;
-		case 8:
-			__asm__ __volatile__("xchgq %0,%1"
-				:"=r" (x)
-				:"m" (*__xg(ptr)), "0" (x)
-				:"memory");
-			break;
-	}
-	return x;
-}
-
-/*
- * Atomic compare and exchange.  Compare OLD with MEM, if identical,
- * store NEW in MEM.  Return the initial value in MEM.  Success is
- * indicated by comparing RETURN with OLD.
- */
-
-#define __HAVE_ARCH_CMPXCHG 1
-
-static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
-				      unsigned long new, int size)
-{
-	unsigned long prev;
-	switch (size) {
-	case 1:
-		__asm__ __volatile__(LOCK_PREFIX "cmpxchgb %b1,%2"
-				     : "=a"(prev)
-				     : "q"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	case 2:
-		__asm__ __volatile__(LOCK_PREFIX "cmpxchgw %w1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	case 4:
-		__asm__ __volatile__(LOCK_PREFIX "cmpxchgl %k1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	case 8:
-		__asm__ __volatile__(LOCK_PREFIX "cmpxchgq %1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	}
-	return old;
-}
-
-static inline unsigned long __cmpxchg_local(volatile void *ptr,
-			unsigned long old, unsigned long new, int size)
-{
-	unsigned long prev;
-	switch (size) {
-	case 1:
-		__asm__ __volatile__("cmpxchgb %b1,%2"
-				     : "=a"(prev)
-				     : "q"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	case 2:
-		__asm__ __volatile__("cmpxchgw %w1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	case 4:
-		__asm__ __volatile__("cmpxchgl %k1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	case 8:
-		__asm__ __volatile__("cmpxchgq %1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	}
-	return old;
-}
-
-#define cmpxchg(ptr,o,n)\
-	((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
-					(unsigned long)(n),sizeof(*(ptr))))
-#define cmpxchg_local(ptr,o,n)\
-	((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
-					(unsigned long)(n),sizeof(*(ptr))))
-
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
 #define smp_rmb()	rmb()
diff -puN /dev/null include/asm-um/cmpxchg.h
--- /dev/null
+++ a/include/asm-um/cmpxchg.h
@@ -0,0 +1,6 @@
+#ifndef __UM_CMPXCHG_H
+#define __UM_CMPXCHG_H
+
+#include "asm/arch/cmpxchg.h"
+
+#endif
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
array_size-check-for-type.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-speed-up-exec.patch
uml-no-locking-needed-in-tlsc.patch
uml-tidy-processc.patch
uml-remove-page_size.patch
uml-kernel_thread-shouldnt-panic.patch
uml-tidy-fault-code.patch
uml-kernel-segfaults-should-dump-proper-registers.patch
uml-comment-early-boot-locking.patch
uml-irq-locking-commentary.patch
uml-delete-host_frame_size.patch
uml-drivers-get-release-methods.patch
uml-dump-registers-on-ptrace-or-wait-failure.patch
uml-speed-up-page-table-walking.patch
uml-remove-unused-x86_64-code.patch
uml-start-fixing-os_read_file-and-os_write_file.patch
uml-tidy-libc-code.patch
uml-convert-libc-layer-to-call-read-and-write.patch
uml-batch-i-o-requests.patch
uml-send-pointers-instead-of-structures-to-i-o-thread.patch
uml-send-pointers-instead-of-structures-to-i-o-thread-fix.patch
uml-dump-core-on-panic.patch
uml-dont-try-to-handle-signals-on-initial-process-stack.patch
uml-change-remaining-callers-of-os_read_write_file.patch
uml-formatting-fixes-around-os_read_write_file-callers.patch
uml-remove-debugging-remnants.patch
uml-rename-os_read_write_file_k-back-to-os_read_write_file.patch
uml-aio-deadlock-avoidance.patch
uml-speed-page-fault-path.patch
uml-eliminate-a-piece-of-debugging-code.patch
uml-more-page-fault-path-trimming.patch
uml-only-flush-areas-covered-by-vma.patch
uml-out-of-tmpfs-space-error-clarification.patch
uml-virtualized-time-fix.patch
uml-fix-prototypes.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
