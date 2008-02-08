From: akpm@linux-foundation.org
Subject: - add-cmpxchg_local-to-m86k.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:09:04 -0800
Message-ID: <200802080808.m1888jwh014681@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50176 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759624AbYBHITV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, geert@linux-m68k.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Add cmpxchg_local to m86k
has been removed from the -mm tree.  Its filename was
     add-cmpxchg_local-to-m86k.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add cmpxchg_local to m86k
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Use the new generic cmpxchg_local (disables interrupt). Also use the generic
cmpxchg as fallback if SMP is not set.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-m68k/system.h |   27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff -puN include/asm-m68k/system.h~add-cmpxchg_local-to-m86k include/asm-m68k/system.h
--- a/include/asm-m68k/system.h~add-cmpxchg_local-to-m86k
+++ a/include/asm-m68k/system.h
@@ -154,6 +154,10 @@ static inline unsigned long __xchg(unsig
 }
 #endif
 
+#include <asm-generic/cmpxchg-local.h>
+
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+
 /*
  * Atomic compare and exchange.  Compare OLD with MEM, if identical,
  * store NEW in MEM.  Return the initial value in MEM.  Success is
@@ -185,9 +189,26 @@ static inline unsigned long __cmpxchg(vo
 	return old;
 }
 
-#define cmpxchg(ptr,o,n)\
-	((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
-					(unsigned long)(n),sizeof(*(ptr))))
+#define cmpxchg(ptr, o, n)						    \
+	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o),	    \
+			(unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg_local(ptr, o, n)					    \
+	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o),	    \
+			(unsigned long)(n), sizeof(*(ptr))))
+#else
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr, o, n)				  	       \
+	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
+			(unsigned long)(n), sizeof(*(ptr))))
+
+#ifndef CONFIG_SMP
+#include <asm-generic/cmpxchg.h>
+#endif
+
 #endif
 
 #define arch_align_stack(x) (x)
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-handle-symbols-that-have-a-zero-value-fix.patch
linux-kernel-markers-support-multiple-probes.patch
linux-kernel-markers-support-multiple-probes-update.patch
linux-kernel-markers-create-modpost-file.patch
