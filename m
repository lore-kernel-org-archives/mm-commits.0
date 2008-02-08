From: akpm@linux-foundation.org
Subject: - add-cmpxchg_local-to-frv.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:08:54 -0800
Message-ID: <200802080808.m1888Z0w014659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37623 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761948AbYBHIUJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Add cmpxchg_local to frv
has been removed from the -mm tree.  Its filename was
     add-cmpxchg_local-to-frv.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add cmpxchg_local to frv
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Use the new generic cmpxchg_local (disables interrupt) for 8, 16 and 64 bits
arguments. Use the 32 bits cmpxchg available on the architecture for 32 bits
arguments.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-frv/system.h |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN include/asm-frv/system.h~add-cmpxchg_local-to-frv include/asm-frv/system.h
--- a/include/asm-frv/system.h~add-cmpxchg_local-to-frv
+++ a/include/asm-frv/system.h
@@ -268,5 +268,29 @@ extern uint32_t __cmpxchg_32(uint32_t *v
 
 #endif
 
+#include <asm-generic/cmpxchg-local.h>
+
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+				      unsigned long old,
+				      unsigned long new, int size)
+{
+	switch (size) {
+	case 4:
+		return cmpxchg(ptr, old, new);
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
 
 #endif /* _ASM_SYSTEM_H */
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-handle-symbols-that-have-a-zero-value-fix.patch
linux-kernel-markers-support-multiple-probes.patch
linux-kernel-markers-support-multiple-probes-update.patch
linux-kernel-markers-create-modpost-file.patch
