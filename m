From: akpm@linux-foundation.org
Subject: - add-cmpxchg_local-to-sh64.patch removed from -mm tree
Date: Mon, 26 Nov 2007 13:41:15 -0800
Message-ID: <200711262141.lAQLfGfC024328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59279 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754169AbXKZVlb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 16:41:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     Add cmpxchg_local to sh64
has been removed from the -mm tree.  Its filename was
     add-cmpxchg_local-to-sh64.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Add cmpxchg_local to sh64
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Use the new generic cmpxchg_local (disables interrupt). Also use the generic
cmpxchg as fallback if SMP is not set.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-sh64/system.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN include/asm-sh64/system.h~add-cmpxchg_local-to-sh64 include/asm-sh64/system.h
--- a/include/asm-sh64/system.h~add-cmpxchg_local-to-sh64
+++ a/include/asm-sh64/system.h
@@ -163,6 +163,21 @@ static __inline__ unsigned long __xchg(u
 	return x;
 }
 
+#include <asm-generic/cmpxchg-local.h>
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr, o, n)				  	       \
+	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
+			(unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+
+#ifndef CONFIG_SMP
+#include <asm-generic/cmpxchg.h>
+#endif
+
 /* XXX
  * disable hlt during certain critical i/o operations
  */
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

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
