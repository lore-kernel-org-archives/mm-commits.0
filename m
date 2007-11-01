From: akpm@linux-foundation.org
Subject: + add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch added to -mm tree
Date: Thu, 01 Nov 2007 12:08:55 -0700
Message-ID: <20071101190855.B1189432BDE@localhost>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:30149 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbXKATKb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 15:10:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, bryan.wu@analog.com, michael.frysinger@analog.com


The patch titled
     Add cmpxchg_local to blackfin, replace __cmpxchg by generic cmpxchg
has been added to the -mm tree.  Its filename is
     add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add cmpxchg_local to blackfin, replace __cmpxchg by generic cmpxchg
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Use the new generic cmpxchg_local (disables interrupt). Also use the generic
cmpxchg as fallback if SMP is not set since nobody seems to know why __cmpxchg
has been implemented in assembly in the first place thather than in plain C.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Bryan Wu <bryan.wu@analog.com>
Cc: Michael Frysinger <michael.frysinger@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-blackfin/system.h |   59 ++++++--------------------------
 1 file changed, 12 insertions(+), 47 deletions(-)

diff -puN include/asm-blackfin/system.h~add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg include/asm-blackfin/system.h
--- a/include/asm-blackfin/system.h~add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg
+++ a/include/asm-blackfin/system.h
@@ -183,55 +183,20 @@ static inline unsigned long __xchg(unsig
 	return tmp;
 }
 
+#include <asm-generic/cmpxchg-local.h>
+
 /*
- * Atomic compare and exchange.  Compare OLD with MEM, if identical,
- * store NEW in MEM.  Return the initial value in MEM.  Success is
- * indicated by comparing RETURN with OLD.
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
  */
-static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
-				      unsigned long new, int size)
-{
-	unsigned long tmp = 0;
-	unsigned long flags = 0;
-
-	local_irq_save(flags);
-
-	switch (size) {
-	case 1:
-		__asm__ __volatile__
-			("%0 = b%3 (z);\n\t"
-			 "CC = %1 == %0;\n\t"
-			 "IF !CC JUMP 1f;\n\t"
-			 "b%3 = %2;\n\t"
-			 "1:\n\t"
-			 : "=&d" (tmp) : "d" (old), "d" (new), "m" (*__xg(ptr)) : "memory");
-		break;
-	case 2:
-		__asm__ __volatile__
-			("%0 = w%3 (z);\n\t"
-			 "CC = %1 == %0;\n\t"
-			 "IF !CC JUMP 1f;\n\t"
-			 "w%3 = %2;\n\t"
-			 "1:\n\t"
-			 : "=&d" (tmp) : "d" (old), "d" (new), "m" (*__xg(ptr)) : "memory");
-		break;
-	case 4:
-		__asm__ __volatile__
-			("%0 = %3;\n\t"
-			 "CC = %1 == %0;\n\t"
-			 "IF !CC JUMP 1f;\n\t"
-			 "%3 = %2;\n\t"
-			 "1:\n\t"
-			 : "=&d" (tmp) : "d" (old), "d" (new), "m" (*__xg(ptr)) : "memory");
-		break;
-	}
-	local_irq_restore(flags);
-	return tmp;
-}
-
-#define cmpxchg(ptr,o,n)\
-        ((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
-                                        (unsigned long)(n),sizeof(*(ptr))))
+#define cmpxchg_local(ptr, o, n)				  	       \
+	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
+			(unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+
+#ifndef CONFIG_SMP
+#include <asm-generic/cmpxchg.h>
+#endif
 
 #define prepare_to_switch()     do { } while(0)
 
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
