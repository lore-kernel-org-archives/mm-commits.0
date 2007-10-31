From: akpm@linux-foundation.org
Subject: + add-cmpxchg_local-to-sparc-move-__cmpxchg-to-systemh.patch added to -mm tree
Date: Wed, 31 Oct 2007 14:16:32 -0700
Message-ID: <200710312116.l9VLGWCA028552@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48223 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753516AbXJaVYS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 17:24:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, davem@davemloft.net, wli@holomorphy.com


The patch titled
     Add cmpxchg_local to sparc, move __cmpxchg to system.h
has been added to the -mm tree.  Its filename is
     add-cmpxchg_local-to-sparc-move-__cmpxchg-to-systemh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add cmpxchg_local to sparc, move __cmpxchg to system.h
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Move cmpxchg and add cmpxchg_local to system.h.
Use the new generic cmpxchg_local (disables interrupt).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-sparc/atomic.h |   36 --------------------------
 include/asm-sparc/system.h |   47 +++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 36 deletions(-)

diff -puN include/asm-sparc/atomic.h~add-cmpxchg_local-to-sparc-move-__cmpxchg-to-systemh include/asm-sparc/atomic.h
--- a/include/asm-sparc/atomic.h~add-cmpxchg_local-to-sparc-move-__cmpxchg-to-systemh
+++ a/include/asm-sparc/atomic.h
@@ -17,42 +17,6 @@ typedef struct { volatile int counter; }
 
 #ifdef __KERNEL__
 
-/* Emulate cmpxchg() the same way we emulate atomics,
- * by hashing the object address and indexing into an array
- * of spinlocks to get a bit of performance...
- *
- * See arch/sparc/lib/atomic32.c for implementation.
- *
- * Cribbed from <asm-parisc/atomic.h>
- */
-#define __HAVE_ARCH_CMPXCHG	1
-
-/* bug catcher for when unsupported size is used - won't link */
-extern void __cmpxchg_called_with_bad_pointer(void);
-/* we only need to support cmpxchg of a u32 on sparc */
-extern unsigned long __cmpxchg_u32(volatile u32 *m, u32 old, u32 new_);
-
-/* don't worry...optimizer will get rid of most of this */
-static inline unsigned long
-__cmpxchg(volatile void *ptr, unsigned long old, unsigned long new_, int size)
-{
-	switch(size) {
-	case 4:
-		return __cmpxchg_u32((u32 *)ptr, (u32)old, (u32)new_);
-	default:
-		__cmpxchg_called_with_bad_pointer();
-		break;
-	}
-	return old;
-}
-
-#define cmpxchg(ptr,o,n) ({						\
-	__typeof__(*(ptr)) _o_ = (o);					\
-	__typeof__(*(ptr)) _n_ = (n);					\
-	(__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,	\
-			(unsigned long)_n_, sizeof(*(ptr)));		\
-})
-
 #define ATOMIC_INIT(i)  { (i) }
 
 extern int __atomic_add_return(int, atomic_t *);
diff -puN include/asm-sparc/system.h~add-cmpxchg_local-to-sparc-move-__cmpxchg-to-systemh include/asm-sparc/system.h
--- a/include/asm-sparc/system.h~add-cmpxchg_local-to-sparc-move-__cmpxchg-to-systemh
+++ a/include/asm-sparc/system.h
@@ -225,6 +225,53 @@ static inline unsigned long __xchg(unsig
 	return x;
 }
 
+/* Emulate cmpxchg() the same way we emulate atomics,
+ * by hashing the object address and indexing into an array
+ * of spinlocks to get a bit of performance...
+ *
+ * See arch/sparc/lib/atomic32.c for implementation.
+ *
+ * Cribbed from <asm-parisc/atomic.h>
+ */
+#define __HAVE_ARCH_CMPXCHG	1
+
+/* bug catcher for when unsupported size is used - won't link */
+extern void __cmpxchg_called_with_bad_pointer(void);
+/* we only need to support cmpxchg of a u32 on sparc */
+extern unsigned long __cmpxchg_u32(volatile u32 *m, u32 old, u32 new_);
+
+/* don't worry...optimizer will get rid of most of this */
+static __inline__ unsigned long
+__cmpxchg(volatile void *ptr, unsigned long old, unsigned long new_, int size)
+{
+	switch(size) {
+	case 4:
+		return __cmpxchg_u32((u32 *)ptr, (u32)old, (u32)new_);
+	default:
+		__cmpxchg_called_with_bad_pointer();
+		break;
+	}
+	return old;
+}
+
+#define cmpxchg(ptr,o,n) ({						\
+	__typeof__(*(ptr)) _o_ = (o);					\
+	__typeof__(*(ptr)) _n_ = (n);					\
+	(__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,	\
+			(unsigned long)_n_, sizeof(*(ptr)));		\
+})
+
+#include <asm-generic/cmpxchg-local.h>
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr,o,n)					  	    \
+     (__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o), \
+			   	 (unsigned long)(n), sizeof(*(ptr)))
+#define cmpxchg64_local(ptr,o,n) __cmpxchg64_local_generic((ptr), (o), (n))
+
 extern void die_if_kernel(char *str, struct pt_regs *regs) __attribute__ ((noreturn));
 
 #endif /* __KERNEL__ */
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

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
