From: akpm@linux-foundation.org
Subject: - add-cmpxchg_local-to-avr32.patch removed from -mm tree
Date: Wed, 31 Oct 2007 15:41:00 -0700
Message-ID: <20071031224100.8595E432BF5@localhost>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:61539 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759777AbXJaWmi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 31 Oct 2007 18:42:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     Add cmpxchg_local to avr32
has been removed from the -mm tree.  Its filename was
     add-cmpxchg_local-to-avr32.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Add cmpxchg_local to avr32
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Use the new generic cmpxchg_local (disables interrupt) for 8, 16 and 64 bits
cmpxchg_local. Use the __cmpxchg_u32 primitive for 32 bits cmpxchg_local.

Note that cmpxchg only uses the __cmpxchg_u32 or __cmpxchg_u64 and will cause
a linker error if called with 8 or 16 bits argument.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-avr32/system.h |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN include/asm-avr32/system.h~add-cmpxchg_local-to-avr32 include/asm-avr32/system.h
--- a/include/asm-avr32/system.h~add-cmpxchg_local-to-avr32
+++ a/include/asm-avr32/system.h
@@ -145,6 +145,29 @@ static inline unsigned long __cmpxchg(vo
 				   (unsigned long)(new),	\
 				   sizeof(*(ptr))))
 
+#include <asm-generic/cmpxchg-local.h>
+
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
+
+	return old;
+}
+
+#define cmpxchg_local(ptr, old, new)					\
+	((typeof(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(old),	\
+				   (unsigned long)(new),		\
+				   sizeof(*(ptr))))
+
+#define cmpxchg64_local(ptr,o,n) __cmpxchg64_local_generic((ptr), (o), (n))
+
 struct pt_regs;
 void NORET_TYPE die(const char *str, struct pt_regs *regs, long err);
 void _exception(long signr, struct pt_regs *regs, int code,
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

local_t-documentation-update-2.patch
markers-fix-warnings.patch
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
