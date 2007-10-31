From: akpm@linux-foundation.org
Subject: - add-cmpxchg64-and-cmpxchg64_local-to-mips.patch removed from -mm tree
Date: Wed, 31 Oct 2007 15:40:51 -0700
Message-ID: <20071031224051.4D92E432BF7@localhost>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:24769 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760988AbXJaWn4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 31 Oct 2007 18:43:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Add cmpxchg64 and cmpxchg64_local to mips
has been removed from the -mm tree.  Its filename was
     add-cmpxchg64-and-cmpxchg64_local-to-mips.patch

This patch was dropped because an updated version will be merged

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
 
+#define cmpxchg64(ptr,o,n)						\
+  ({									\
+  	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+  	cmpxchg((ptr),(o),(n));						\
+  })
+
+#ifdef CONFIG_64BIT
+#define cmpxchg64_local(ptr,o,n)					\
+  ({									\
+  	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+  	cmpxchg_local((ptr),(o),(n));					\
+  })
+#else
+#include <asm-generic/cmpxchg-local.h>
+#define cmpxchg64_local(ptr,o,n)	__cmpxchg64_local_generic((ptr),(o),(n))
+#endif
+
 #endif /* __ASM_CMPXCHG_H */
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

local_t-documentation-update-2.patch
markers-fix-warnings.patch
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
