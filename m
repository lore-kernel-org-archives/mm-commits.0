From: akpm@linux-foundation.org
Subject: + fix-m32r-__xchg.patch added to -mm tree
Date: Wed, 31 Oct 2007 14:16:07 -0700
Message-ID: <200710312116.l9VLG78c028501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56514 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754288AbXJaVX7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 17:23:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, bunk@kernel.org, takata@linux-m32r.org


The patch titled
     Fix m32r __xchg
has been added to the -mm tree.  Its filename is
     fix-m32r-__xchg.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix m32r __xchg
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

the #endif  /* CONFIG_SMP */ should cover the default condition, or it may cause
bad parameter to be silently missed.

To make it work correctly, we have to remove the ifdef CONFIG SMP surrounding
__xchg_called_with_bad_pointer declaration. Thanks to Adrian Bunk for detecting
this.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Hirokazu Takata <takata@linux-m32r.org>
Cc: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-m32r/system.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN include/asm-m32r/system.h~fix-m32r-__xchg include/asm-m32r/system.h
--- a/include/asm-m32r/system.h~fix-m32r-__xchg
+++ a/include/asm-m32r/system.h
@@ -127,9 +127,7 @@ static inline void local_irq_disable(voi
 	((__typeof__(*(ptr)))__xchg_local((unsigned long)(x),(ptr), \
 			sizeof(*(ptr))))
 
-#ifdef CONFIG_SMP
 extern void  __xchg_called_with_bad_pointer(void);
-#endif
 
 #ifdef CONFIG_CHIP_M32700_TS1
 #define DCACHE_CLEAR(reg0, reg1, addr)				\
@@ -189,9 +187,9 @@ __xchg(unsigned long x, volatile void * 
 #endif	/* CONFIG_CHIP_M32700_TS1 */
 		);
 		break;
+#endif  /* CONFIG_SMP */
 	default:
 		__xchg_called_with_bad_pointer();
-#endif  /* CONFIG_SMP */
 	}
 
 	local_irq_restore(flags);
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
