From: akpm@linux-foundation.org
Subject: + add-cmpxchg_local-to-s390.patch added to -mm tree
Date: Thu, 01 Nov 2007 12:09:15 -0700
Message-ID: <20071101190915.8ED01432BFE@localhost>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:44389 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbXKATLJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 15:11:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com


The patch titled
     Add cmpxchg_local to s390
has been added to the -mm tree.  Its filename is
     add-cmpxchg_local-to-s390.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add cmpxchg_local to s390
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Use the standard __cmpxchg for every type that can be updated atomically.
Use the new generic cmpxchg_local (disables interrupt) for other types.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-s390/system.h |   44 +++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

diff -puN include/asm-s390/system.h~add-cmpxchg_local-to-s390 include/asm-s390/system.h
--- a/include/asm-s390/system.h~add-cmpxchg_local-to-s390
+++ a/include/asm-s390/system.h
@@ -201,9 +201,9 @@ static inline unsigned long __xchg(unsig
 
 #define __HAVE_ARCH_CMPXCHG 1
 
-#define cmpxchg(ptr,o,n)\
-	((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
-					(unsigned long)(n),sizeof(*(ptr))))
+#define cmpxchg(ptr, o, n)						\
+	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o),	\
+					(unsigned long)(n), sizeof(*(ptr))))
 
 extern void __cmpxchg_called_with_bad_pointer(void);
 
@@ -355,6 +355,44 @@ __cmpxchg(volatile void *ptr, unsigned l
 
 #include <linux/irqflags.h>
 
+#include <asm-generic/cmpxchg-local.h>
+
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+				      unsigned long old,
+				      unsigned long new, int size)
+{
+	switch (size) {
+	case 1:
+	case 2:
+	case 4:
+#ifdef __s390x__
+	case 8:
+#endif
+		return __cmpxchg(ptr, old, new, size);
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
+#define cmpxchg_local(ptr, o, n)					\
+	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
+			(unsigned long)(n), sizeof(*(ptr))))
+#ifdef __s390x__
+#define cmpxchg64_local(ptr, o, n)					\
+  ({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	cmpxchg_local((ptr), (o), (n));					\
+  })
+#else
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+#endif
+
 /*
  * Use to set psw mask except for the first byte which
  * won't be changed by this function.
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
