From: akpm@linux-foundation.org
Subject: + add-cmpxchg_local-to-ppc.patch added to -mm tree
Date: Thu, 01 Nov 2007 12:09:14 -0700
Message-ID: <20071101190914.97905432BDE@localhost>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:44419 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485AbXKATLT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 15:11:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gl@denx.de, benh@kernel.crashing.org, galak@gate.crashing.org, mathieu.desnoyers@polymtl.ca, paulus@samba.org


The patch titled
     Add cmpxchg_local to ppc
has been added to the -mm tree.  Its filename is
     add-cmpxchg_local-to-ppc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add cmpxchg_local to ppc
From: Gunnar Larisch <gl@denx.de>

Add a local processor version of cmpxchg for ppc.

Implements __cmpxchg_u32_local and uses it for 32 bits cmpxchg_local.
It uses the non NMI safe cmpxchg_local_generic for 1, 2 and 8 bytes
cmpxchg_local.

Signed-off-by: Gunnar Larisch <gl@denx.de>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ppc/system.h |   51 +++++++++++++++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 2 deletions(-)

diff -puN include/asm-ppc/system.h~add-cmpxchg_local-to-ppc include/asm-ppc/system.h
--- a/include/asm-ppc/system.h~add-cmpxchg_local-to-ppc
+++ a/include/asm-ppc/system.h
@@ -209,12 +209,34 @@ __cmpxchg_u32(volatile unsigned int *p, 
 	return prev;
 }
 
+static inline unsigned long
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
@@ -228,7 +250,7 @@ __cmpxchg(volatile void *ptr, unsigned l
 	return old;
 }
 
-#define cmpxchg(ptr,o,n)						 \
+#define cmpxchg(ptr, o, n)						 \
   ({									 \
      __typeof__(*(ptr)) _o_ = (o);					 \
      __typeof__(*(ptr)) _n_ = (n);					 \
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
+#define cmpxchg_local(ptr, o, n)				  	\
+	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
+			(unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+
 #define arch_align_stack(x) (x)
 
 #endif /* __KERNEL__ */
_

Patches currently in -mm which might be from gl@denx.de are

add-cmpxchg_local-to-ppc.patch
