From: akpm@linux-foundation.org
Subject: - m68knommu-remove-old-cache-management-cruft-from-mm-code.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:50:24 -0700
Message-ID: <200707162050.l6GKoOHT001311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50562 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760076AbXGPV1q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:27:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerg@snapgear.com, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     m68knommu: remove old cache management cruft from mm code
has been removed from the -mm tree.  Its filename was
     m68knommu-remove-old-cache-management-cruft-from-mm-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: m68knommu: remove old cache management cruft from mm code
From: Greg Ungerer <gerg@snapgear.com>

Remove cache management cruft.  This code is dead, all the cache manangement
functions for the ColdFire exist in the header file
include/asm-m68knommu/cacheflush.h.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/mm/memory.c |   80 -----------------------------------
 1 file changed, 2 insertions(+), 78 deletions(-)

diff -puN arch/m68knommu/mm/memory.c~m68knommu-remove-old-cache-management-cruft-from-mm-code arch/m68knommu/mm/memory.c
--- a/arch/m68knommu/mm/memory.c~m68knommu-remove-old-cache-management-cruft-from-mm-code
+++ a/arch/m68knommu/mm/memory.c
@@ -17,90 +17,14 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 
-#include <asm/setup.h>
 #include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/system.h>
-#include <asm/traps.h>
-#include <asm/io.h>
 
 /*
- * cache_clear() semantics: Clear any cache entries for the area in question,
- * without writing back dirty entries first. This is useful if the data will
- * be overwritten anyway, e.g. by DMA to memory. The range is defined by a
- * _physical_ address.
- */
-
-void cache_clear (unsigned long paddr, int len)
-{
-}
-
-
-/*
- *	Define cache invalidate functions. The ColdFire 5407 is really
- *	the only processor that needs to do some work here. Anything
- *	that has separate data and instruction caches will be a problem.
- */
-#ifdef CONFIG_M5407
-
-static __inline__ void cache_invalidate_lines(unsigned long paddr, int len)
-{
-	unsigned long	sset, eset;
-
-	sset = (paddr & 0x00000ff0);
-	eset = ((paddr + len) & 0x0000ff0) + 0x10;
-
-	__asm__ __volatile__ (
-		"nop\n\t"
-		"clrl	%%d0\n\t"
-		"1:\n\t"
-		"movel	%0,%%a0\n\t"
-		"addl	%%d0,%%a0\n\t"
-		"2:\n\t"
-		".word	0xf4e8\n\t"
-		"addl	#0x10,%%a0\n\t"
-		"cmpl	%1,%%a0\n\t"
-		"blt	2b\n\t"
-		"addql	#1,%%d0\n\t"
-		"cmpil	#4,%%d0\n\t"
-		"bne	1b"
-		: : "a" (sset), "a" (eset) : "d0", "a0" );
-}
-
-#else
-#define	cache_invalidate_lines(a,b)
-#endif
-
-
-/*
- * cache_push() semantics: Write back any dirty cache data in the given area,
- * and invalidate the range in the instruction cache. It needs not (but may)
- * invalidate those entries also in the data cache. The range is defined by a
- * _physical_ address.
- */
-
-void cache_push (unsigned long paddr, int len)
-{
-	cache_invalidate_lines(paddr, len);
-}
-
-
-/*
- * cache_push_v() semantics: Write back any dirty cache data in the given
- * area, and invalidate those entries at least in the instruction cache. This
- * is intended to be used after data has been written that can be executed as
- * code later. The range is defined by a _user_mode_ _virtual_ address  (or,
- * more exactly, the space is defined by the %sfc/%dfc register.)
- */
-
-void cache_push_v (unsigned long vaddr, int len)
-{
-	cache_invalidate_lines(vaddr, len);
-}
-
-/* Map some physical address range into the kernel address space. The
- * code is copied and adapted from map_chunk().
+ * Map some physical address range into the kernel address space.
+ * The code is copied and adapted from map_chunk().
  */
 
 unsigned long kernel_map(unsigned long paddr, unsigned long size,
_

Patches currently in -mm which might be from gerg@snapgear.com are

origin.patch
git-mtd.patch
