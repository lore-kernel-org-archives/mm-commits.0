From: akpm@linux-foundation.org
Subject: - add-cmpxchg_local-to-sparc64.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:09:13 -0800
Message-ID: <200802080808.m1888sX4014707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38756 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755253AbYBHISw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:18:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Add cmpxchg_local to sparc64
has been removed from the -mm tree.  Its filename was
     add-cmpxchg_local-to-sparc64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add cmpxchg_local to sparc64
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Use cmpxchg_u32 and cmpxchg_u64 for cmpxchg_local and cmpxchg64_local. For other
type sizes, use the new generic cmpxchg_local (disables interrupt).

Change:
Since the header depends on local_irqsave/local_irqrestore, it must be
included after their declaration.

Actually, being below the
#include <linux/irqflags.h> should be enough, and on sparc64 it is
included at the beginning of system.h.

So it makes sense to move it up for sparc64.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-sparc64/system.h |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff -puN include/asm-sparc64/system.h~add-cmpxchg_local-to-sparc64 include/asm-sparc64/system.h
--- a/include/asm-sparc64/system.h~add-cmpxchg_local-to-sparc64
+++ a/include/asm-sparc64/system.h
@@ -8,6 +8,7 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/irqflags.h>
+#include <asm-generic/cmpxchg-local.h>
 
 /*
  * Sparc (general) CPU types
@@ -315,6 +316,34 @@ __cmpxchg(volatile void *ptr, unsigned l
 				    (unsigned long)_n_, sizeof(*(ptr))); \
   })
 
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+				      unsigned long old,
+				      unsigned long new, int size)
+{
+	switch (size) {
+	case 4:
+	case 8:	return __cmpxchg(ptr, old, new, size);
+	default:
+		return __cmpxchg_local_generic(ptr, old, new, size);
+	}
+
+	return old;
+}
+
+#define cmpxchg_local(ptr, o, n)				  	\
+	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
+			(unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg64_local(ptr, o, n)					\
+  ({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	cmpxchg_local((ptr), (o), (n));					\
+  })
+
 #endif /* !(__ASSEMBLY__) */
 
 #define arch_align_stack(x) (x)
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-handle-symbols-that-have-a-zero-value-fix.patch
linux-kernel-markers-support-multiple-probes.patch
linux-kernel-markers-support-multiple-probes-update.patch
linux-kernel-markers-create-modpost-file.patch
