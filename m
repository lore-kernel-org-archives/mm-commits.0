From: akpm@linux-foundation.org
Subject: + add-cmpxchg64-and-cmpxchg64_local-to-powerpc.patch added to -mm tree
Date: Wed, 31 Oct 2007 14:15:35 -0700
Message-ID: <200710312115.l9VLFZsb028439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39953 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760667AbXJaVQT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 17:16:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     Add cmpxchg64 and cmpxchg64_local to powerpc
has been added to the -mm tree.  Its filename is
     add-cmpxchg64-and-cmpxchg64_local-to-powerpc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add cmpxchg64 and cmpxchg64_local to powerpc
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Make sure that at least cmpxchg64_local is available on all architectures to
use for unsigned long long values.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-powerpc/system.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/asm-powerpc/system.h~add-cmpxchg64-and-cmpxchg64_local-to-powerpc include/asm-powerpc/system.h
--- a/include/asm-powerpc/system.h~add-cmpxchg64-and-cmpxchg64_local-to-powerpc
+++ a/include/asm-powerpc/system.h
@@ -490,6 +490,12 @@ __cmpxchg_local(volatile void *ptr, unsi
  */
 #define NET_IP_ALIGN	0
 #define NET_SKB_PAD	L1_CACHE_BYTES
+
+#define cmpxchg64	cmpxchg
+#define cmpxchg64_local	cmpxchg_local
+#else
+#include <asm-generic/cmpxchg-local.h>
+#define cmpxchg64_local(ptr,o,n) __cmpxchg64_local_generic((ptr), (o), (n))
 #endif
 
 #define arch_align_stack(x) (x)
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
