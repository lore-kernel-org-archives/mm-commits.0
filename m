From: akpm@linux-foundation.org
Subject: - add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:08:52 -0800
Message-ID: <200802080808.m1888XOm014653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56512 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932417AbYBHIUH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, bryan.wu@analog.com, michael.frysinger@analog.com, mm-commits@vger.kernel.org


The patch titled
     Add cmpxchg_local to blackfin, replace __cmpxchg by generic cmpxchg
has been removed from the -mm tree.  Its filename was
     add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-handle-symbols-that-have-a-zero-value-fix.patch
linux-kernel-markers-support-multiple-probes.patch
linux-kernel-markers-support-multiple-probes-update.patch
linux-kernel-markers-create-modpost-file.patch
