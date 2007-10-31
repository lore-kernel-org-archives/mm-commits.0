From: akpm@linux-foundation.org
Subject: - add-cmpxchg_local-to-v850.patch removed from -mm tree
Date: Wed, 31 Oct 2007 15:41:38 -0700
Message-ID: <20071031224138.4F3B6432BF5@localhost>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:24554 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760841AbXJaWnX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 31 Oct 2007 18:43:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, miles.bader@necel.com, uclinux-v850@lsi.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     Add cmpxchg_local to v850
has been removed from the -mm tree.  Its filename was
     add-cmpxchg_local-to-v850.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Add cmpxchg_local to v850
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Use the new generic cmpxchg_local (disables interrupt).  Also use the generic
cmpxchg as fallback if SMP is not set.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Miles Bader <uclinux-v850@lsi.nec.co.jp>
Cc: Miles Bader <miles.bader@necel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-v850/system.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN include/asm-v850/system.h~add-cmpxchg_local-to-v850 include/asm-v850/system.h
--- a/include/asm-v850/system.h~add-cmpxchg_local-to-v850
+++ a/include/asm-v850/system.h
@@ -103,6 +103,21 @@ static inline unsigned long __xchg (unsi
 	return tmp;
 }
 
+#include <asm-generic/cmpxchg-local.h>
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr,o,n)					  	    \
+     (__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o), \
+			   	 (unsigned long)(n), sizeof(*(ptr)))
+#define cmpxchg64_local(ptr,o,n) __cmpxchg64_local_generic((ptr), (o), (n))
+
+#ifndef CONFIG_SMP
+#include <asm-generic/cmpxchg.h>
+#endif
+
 #define arch_align_stack(x) (x)
 
 #endif /* __V850_SYSTEM_H__ */
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

local_t-documentation-update-2.patch
markers-fix-warnings.patch
add-cmpxchg_local-to-v850.patch
add-cmpxchg_local-to-xtensa.patch
