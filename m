From: akpm@linux-foundation.org
Subject: - add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch removed from -mm tree
Date: Wed, 31 Oct 2007 15:41:10 -0700
Message-ID: <20071031224110.76064432BF5@localhost>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:61600 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760673AbXJaWm4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 31 Oct 2007 18:42:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, clameter@sgi.com, kaos@ocs.com.au, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Add cmpxchg_local, cmpxchg64 and cmpxchg64_local to ia64
has been removed from the -mm tree.  Its filename was
     add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Add cmpxchg_local, cmpxchg64 and cmpxchg64_local to ia64
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Add the primitives cmpxchg_local, cmpxchg64 and cmpxchg64_local to ia64. They
use cmpxchg_acq as underlying macro, just like the already existing ia64
cmpxchg().

Changelog:

ia64 cmpxchg_local coding style fix
Quoting Keith Owens:

As a matter of coding style, I prefer

#define cmpxchg_local   cmpxchg
#define cmpxchg64_local cmpxchg64

Which makes it absolutely clear that they are the same code.  With your
patch, humans have to do a string compare of two defines to see if they
are the same.

Note cmpxchg is *not* a performance win vs interrupt disable / enable on IA64.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Christoph Lameter <clameter@sgi.com>
Cc: Keith Owens <kaos@ocs.com.au>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/intrinsics.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/asm-ia64/intrinsics.h~add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64 include/asm-ia64/intrinsics.h
--- a/include/asm-ia64/intrinsics.h~add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64
+++ a/include/asm-ia64/intrinsics.h
@@ -158,6 +158,10 @@ extern long ia64_cmpxchg_called_with_bad
 
 /* for compatibility with other platforms: */
 #define cmpxchg(ptr,o,n)	cmpxchg_acq(ptr,o,n)
+#define cmpxchg64(ptr,o,n)	cmpxchg_acq(ptr,o,n)
+
+#define cmpxchg_local		cmpxchg
+#define cmpxchg64_local		cmpxchg64
 
 #ifdef CONFIG_IA64_DEBUG_CMPXCHG
 # define CMPXCHG_BUGCHECK_DECL	int _cmpxchg_bugcheck_count = 128;
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

local_t-documentation-update-2.patch
markers-fix-warnings.patch
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
