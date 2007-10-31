From: akpm@linux-foundation.org
Subject: + add-cmpxchg_local-to-sh-use-generic-cmpxchg-instead-of-cmpxchg_u32.patch added to -mm tree
Date: Wed, 31 Oct 2007 14:16:28 -0700
Message-ID: <200710312116.l9VLGSiO028539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42129 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755496AbXJaVXB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 17:23:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, lethal@linux-sh.org


The patch titled
     Add cmpxchg_local to sh, use generic cmpxchg() instead of cmpxchg_u32
has been added to the -mm tree.  Its filename is
     add-cmpxchg_local-to-sh-use-generic-cmpxchg-instead-of-cmpxchg_u32.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add cmpxchg_local to sh, use generic cmpxchg() instead of cmpxchg_u32
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Use the new generic cmpxchg_local (disables interrupt). Also use the generic
cmpxchg as fallback if SMP is not set.

Since cmpxchg_u32 is _exactly_ the cmpxchg_local generic implementation, remove
it and use the generic version instead.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-sh/system.h |   48 +++++++++-----------------------------
 1 file changed, 12 insertions(+), 36 deletions(-)

diff -puN include/asm-sh/system.h~add-cmpxchg_local-to-sh-use-generic-cmpxchg-instead-of-cmpxchg_u32 include/asm-sh/system.h
--- a/include/asm-sh/system.h~add-cmpxchg_local-to-sh-use-generic-cmpxchg-instead-of-cmpxchg_u32
+++ a/include/asm-sh/system.h
@@ -202,44 +202,20 @@ extern void __xchg_called_with_bad_point
 #define xchg(ptr,x)	\
 	((__typeof__(*(ptr)))__xchg((ptr),(unsigned long)(x), sizeof(*(ptr))))
 
-static inline unsigned long __cmpxchg_u32(volatile int * m, unsigned long old,
-	unsigned long new)
-{
-	__u32 retval;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	retval = *m;
-	if (retval == old)
-		*m = new;
-	local_irq_restore(flags);       /* implies memory barrier  */
-	return retval;
-}
-
-/* This function doesn't exist, so you'll get a linker error
- * if something tries to do an invalid cmpxchg(). */
-extern void __cmpxchg_called_with_bad_pointer(void);
-
-#define __HAVE_ARCH_CMPXCHG 1
+#include <asm-generic/cmpxchg-local.h>
 
-static inline unsigned long __cmpxchg(volatile void * ptr, unsigned long old,
-		unsigned long new, int size)
-{
-	switch (size) {
-	case 4:
-		return __cmpxchg_u32(ptr, old, new);
-	}
-	__cmpxchg_called_with_bad_pointer();
-	return old;
-}
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr,o,n)					  	    \
+     (__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o), \
+			   	 (unsigned long)(n), sizeof(*(ptr)))
+#define cmpxchg64_local(ptr,o,n) __cmpxchg64_local_generic((ptr), (o), (n))
 
-#define cmpxchg(ptr,o,n)						 \
-  ({									 \
-     __typeof__(*(ptr)) _o_ = (o);					 \
-     __typeof__(*(ptr)) _n_ = (n);					 \
-     (__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,		 \
-				    (unsigned long)_n_, sizeof(*(ptr))); \
-  })
+#ifndef CONFIG_SMP
+#include <asm-generic/cmpxchg.h>
+#endif
 
 extern void die(const char *str, struct pt_regs *regs, long err) __attribute__ ((noreturn));
 
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
