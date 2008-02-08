From: akpm@linux-foundation.org
Subject: - add-cmpxchg_local-to-m68knommu.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:09:05 -0800
Message-ID: <200802080808.m1888k89014689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39485 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755796AbYBHITE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, gerg@snapgear.com, mm-commits@vger.kernel.org


The patch titled
     Add cmpxchg_local to m68knommu
has been removed from the -mm tree.  Its filename was
     add-cmpxchg_local-to-m68knommu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add cmpxchg_local to m68knommu
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Use the new generic cmpxchg_local (disables interrupt). Also use the generic
cmpxchg as fallback if SMP is not set.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-m68knommu/system.h |   28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff -puN include/asm-m68knommu/system.h~add-cmpxchg_local-to-m68knommu include/asm-m68knommu/system.h
--- a/include/asm-m68knommu/system.h~add-cmpxchg_local-to-m68knommu
+++ a/include/asm-m68knommu/system.h
@@ -186,26 +186,20 @@ static inline unsigned long __xchg(unsig
 }
 #endif
 
+#include <asm-generic/cmpxchg-local.h>
+
 /*
- * Atomic compare and exchange.  Compare OLD with MEM, if identical,
- * store NEW in MEM.  Return the initial value in MEM.  Success is
- * indicated by comparing RETURN with OLD.
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
  */
-#define __HAVE_ARCH_CMPXCHG	1
-
-static __inline__ unsigned long
-cmpxchg(volatile int *p, int old, int new)
-{
-	unsigned long flags;
-	int prev;
-
-	local_irq_save(flags);
-	if ((prev = *p) == old)
-		*p = new;
-	local_irq_restore(flags);
-	return(prev);
-}
+#define cmpxchg_local(ptr, o, n)				  	       \
+	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
+			(unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
 
+#ifndef CONFIG_SMP
+#include <asm-generic/cmpxchg.h>
+#endif
 
 #if defined( CONFIG_M68328 ) || defined( CONFIG_M68EZ328 ) || \
 	defined (CONFIG_M68360) || defined( CONFIG_M68VZ328 )
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-handle-symbols-that-have-a-zero-value-fix.patch
linux-kernel-markers-support-multiple-probes.patch
linux-kernel-markers-support-multiple-probes-update.patch
linux-kernel-markers-create-modpost-file.patch
