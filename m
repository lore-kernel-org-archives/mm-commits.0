From: akpm@linux-foundation.org
Subject: - add-cmpxchg_local-to-xtensa.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:09:16 -0800
Message-ID: <200802080808.m1888vmi014713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37358 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756868AbYBHITA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, chris@zankel.net, mm-commits@vger.kernel.org


The patch titled
     Add cmpxchg_local to xtensa
has been removed from the -mm tree.  Its filename was
     add-cmpxchg_local-to-xtensa.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add cmpxchg_local to xtensa
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Use the architecture specific __cmpxchg_u32 for 32 bits cmpxchg)_local. Else,
use the new generic cmpxchg_local (disables interrupt).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-xtensa/system.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN include/asm-xtensa/system.h~add-cmpxchg_local-to-xtensa include/asm-xtensa/system.h
--- a/include/asm-xtensa/system.h~add-cmpxchg_local-to-xtensa
+++ a/include/asm-xtensa/system.h
@@ -156,8 +156,30 @@ __cmpxchg(volatile void *ptr, unsigned l
 	   			        (unsigned long)_n_, sizeof (*(ptr))); \
 	})
 
+#include <asm-generic/cmpxchg-local.h>
 
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+				      unsigned long old,
+				      unsigned long new, int size)
+{
+	switch (size) {
+	case 4:
+		return __cmpxchg_u32(ptr, old, new);
+	default:
+		return __cmpxchg_local_generic(ptr, old, new, size);
+	}
 
+	return old;
+}
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr, o, n)				  	       \
+	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
+			(unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
 
 /*
  * xchg_u32
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-handle-symbols-that-have-a-zero-value-fix.patch
linux-kernel-markers-support-multiple-probes.patch
linux-kernel-markers-support-multiple-probes-update.patch
linux-kernel-markers-create-modpost-file.patch
