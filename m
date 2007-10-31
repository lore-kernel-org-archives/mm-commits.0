From: akpm@linux-foundation.org
Subject: - add-cmpxchg_local-to-ppc.patch removed from -mm tree
Date: Wed, 31 Oct 2007 15:41:26 -0700
Message-ID: <20071031224126.64C0D432BF5@localhost>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:61624 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760262AbXJaWnF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 31 Oct 2007 18:43:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, benh@kernel.crashing.org, gl@denx.de, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Add cmpxchg_local to ppc
has been removed from the -mm tree.  Its filename was
     add-cmpxchg_local-to-ppc.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Add cmpxchg_local to ppc
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Add a local processor version of cmpxchg for ppc.

Implements __cmpxchg_u32_local and uses it for 32 bits cmpxchg_local.
It uses the non NMI safe cmpxchg_local_generic for 1, 2 and 8 bytes
cmpxchg_local.

Signed-off-by: Gunnar Larisch <gl@denx.de>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ppc/system.h |   49 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff -puN include/asm-ppc/system.h~add-cmpxchg_local-to-ppc include/asm-ppc/system.h
--- a/include/asm-ppc/system.h~add-cmpxchg_local-to-ppc
+++ a/include/asm-ppc/system.h
@@ -209,12 +209,34 @@ __cmpxchg_u32(volatile unsigned int *p, 
 	return prev;
 }
 
+static __inline__ unsigned long
+__cmpxchg_u32_local(volatile unsigned int *p, unsigned int old,
+	unsigned int new)
+{
+	unsigned int prev;
+
+	__asm__ __volatile__ ("\n\
+1:	lwarx	%0,0,%2 \n\
+	cmpw	0,%0,%3 \n\
+	bne	2f \n"
+	PPC405_ERR77(0,%2)
+"	stwcx.	%4,0,%2 \n\
+	bne-	1b\n"
+"2:"
+	: "=&r" (prev), "=m" (*p)
+	: "r" (p), "r" (old), "r" (new), "m" (*p)
+	: "cc", "memory");
+
+	return prev;
+}
+
 /* This function doesn't exist, so you'll get a linker error
    if something tries to do an invalid cmpxchg().  */
 extern void __cmpxchg_called_with_bad_pointer(void);
 
 static __inline__ unsigned long
-__cmpxchg(volatile void *ptr, unsigned long old, unsigned long new, int size)
+__cmpxchg(volatile void *ptr, unsigned long old, unsigned long new,
+	unsigned int size)
 {
 	switch (size) {
 	case 4:
@@ -236,6 +258,31 @@ __cmpxchg(volatile void *ptr, unsigned l
 				    (unsigned long)_n_, sizeof(*(ptr))); \
   })
 
+#include <asm-generic/cmpxchg-local.h>
+
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+				      unsigned long old,
+				      unsigned long new, int size)
+{
+	switch (size) {
+	case 4:
+		return __cmpxchg_u32_local(ptr, old, new);
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
+#define cmpxchg_local(ptr,o,n)					  	\
+     (__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
+			   	 (unsigned long)(n), sizeof(*(ptr)))
+#define cmpxchg64_local(ptr,o,n) __cmpxchg64_local_generic((ptr), (o), (n))
+
 #define arch_align_stack(x) (x)
 
 #endif /* __KERNEL__ */
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

local_t-documentation-update-2.patch
markers-fix-warnings.patch
add-cmpxchg_local-to-ppc.patch
add-cmpxchg_local-to-s390.patch
add-cmpxchg_local-to-sh-use-generic-cmpxchg-instead-of-cmpxchg_u32.patch
add-cmpxchg_local-to-sh64.patch
add-cmpxchg_local-to-sparc-move-__cmpxchg-to-systemh.patch
add-cmpxchg_local-to-sparc64.patch
add-cmpxchg_local-to-v850.patch
add-cmpxchg_local-to-xtensa.patch
