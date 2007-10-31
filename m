From: akpm@linux-foundation.org
Subject: - add-cmpxchg_local-to-parisc.patch removed from -mm tree
Date: Wed, 31 Oct 2007 15:41:24 -0700
Message-ID: <20071031224124.53CC0432BF5@localhost>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:61615 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760699AbXJaWnD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 31 Oct 2007 18:43:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, grundler@parisc-linux.org, kyle@mcmartin.ca, willy@debian.org, mm-commits@vger.kernel.org


The patch titled
     Add cmpxchg_local to parisc
has been removed from the -mm tree.  Its filename was
     add-cmpxchg_local-to-parisc.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Add cmpxchg_local to parisc
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Use the new generic cmpxchg_local (disables interrupt). Also use the generic
cmpxchg as fallback if SMP is not set.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <willy@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-parisc/atomic.h |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff -puN include/asm-parisc/atomic.h~add-cmpxchg_local-to-parisc include/asm-parisc/atomic.h
--- a/include/asm-parisc/atomic.h~add-cmpxchg_local-to-parisc
+++ a/include/asm-parisc/atomic.h
@@ -122,6 +122,35 @@ __cmpxchg(volatile void *ptr, unsigned l
 				    (unsigned long)_n_, sizeof(*(ptr))); \
   })
 
+#include <asm-generic/cmpxchg-local.h>
+
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+				      unsigned long old,
+				      unsigned long new_, int size)
+{
+	switch (size) {
+#ifdef CONFIG_64BIT
+	case 8:	return __cmpxchg_u64((unsigned long *)ptr, old, new_);
+#endif
+	case 4:	return __cmpxchg_u32(ptr, old, new_);
+	default:
+		return __cmpxchg_local_generic(ptr, old, new_, size);
+	}
+}
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr,o,n)					  	\
+     (__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
+			   	 (unsigned long)(n), sizeof(*(ptr)))
+#ifdef CONFIG_64BIT
+#define cmpxchg64_local(ptr,o,n) cmpxchg_local((ptr), (o), (n))
+#else
+#define cmpxchg64_local(ptr,o,n) __cmpxchg64_local_generic((ptr), (o), (n))
+#endif
+
 /* Note that we need not lock read accesses - aligned word writes/reads
  * are atomic, so a reader never sees unconsistent values.
  *
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

local_t-documentation-update-2.patch
markers-fix-warnings.patch
add-cmpxchg_local-to-parisc.patch
add-cmpxchg_local-to-ppc.patch
add-cmpxchg_local-to-s390.patch
add-cmpxchg_local-to-sh-use-generic-cmpxchg-instead-of-cmpxchg_u32.patch
add-cmpxchg_local-to-sh64.patch
add-cmpxchg_local-to-sparc-move-__cmpxchg-to-systemh.patch
add-cmpxchg_local-to-sparc64.patch
add-cmpxchg_local-to-v850.patch
add-cmpxchg_local-to-xtensa.patch
