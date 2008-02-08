From: akpm@linux-foundation.org
Subject: - add-cmpxchg64-and-cmpxchg64_local-to-mips.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:08:46 -0800
Message-ID: <200802080808.m1888Rjv014638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52385 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760756AbYBHITh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Add cmpxchg64 and cmpxchg64_local to mips
has been removed from the -mm tree.  Its filename was
     add-cmpxchg64-and-cmpxchg64_local-to-mips.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add cmpxchg64 and cmpxchg64_local to mips
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Make sure that at least cmpxchg64_local is available on all architectures to use
for unsigned long long values.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mips/cmpxchg.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN include/asm-mips/cmpxchg.h~add-cmpxchg64-and-cmpxchg64_local-to-mips include/asm-mips/cmpxchg.h
--- a/include/asm-mips/cmpxchg.h~add-cmpxchg64-and-cmpxchg64_local-to-mips
+++ a/include/asm-mips/cmpxchg.h
@@ -104,4 +104,21 @@ extern void __cmpxchg_called_with_bad_po
 #define cmpxchg(ptr, old, new)		__cmpxchg(ptr, old, new, smp_llsc_mb())
 #define cmpxchg_local(ptr, old, new)	__cmpxchg(ptr, old, new, )
 
+#define cmpxchg64(ptr, o, n)						\
+  ({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	cmpxchg((ptr), (o), (n));					\
+  })
+
+#ifdef CONFIG_64BIT
+#define cmpxchg64_local(ptr, o, n)					\
+  ({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	cmpxchg_local((ptr), (o), (n));					\
+  })
+#else
+#include <asm-generic/cmpxchg-local.h>
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+#endif
+
 #endif /* __ASM_CMPXCHG_H */
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-handle-symbols-that-have-a-zero-value-fix.patch
linux-kernel-markers-support-multiple-probes.patch
linux-kernel-markers-support-multiple-probes-update.patch
linux-kernel-markers-create-modpost-file.patch
