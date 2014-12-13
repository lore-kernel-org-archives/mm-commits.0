From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation-fix.patch removed from -mm tree
Date: Fri, 12 Dec 2014 16:40:57 -0800
Message-ID: <548b8b19.wczowgD4MhJe3t0G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38376 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaLMAk6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Dec 2014 19:40:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation-fix
has been removed from the -mm tree.  Its filename was
     mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation-fix.patch

This patch was dropped because it was folded into mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation-fix

Fix following warning from 0-day kernel test infrastructure.

  make.cross ARCH=m32r

All warnings:

   mm/nommu.c: In function 'do_mmap_private':
>> mm/nommu.c:1193:8: warning: assignment makes pointer (snip)...
      base = __get_free_pages(GFP_KERNEL, order);
           ^

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/nommu.c~mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation-fix mm/nommu.c
--- a/mm/nommu.c~mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation-fix
+++ a/mm/nommu.c
@@ -1190,7 +1190,7 @@ static int do_mmap_private(struct vm_are
 		kdebug("try to alloc exact %lu pages", total);
 		base = alloc_pages_exact(len, GFP_KERNEL);
 	} else {
-		base = __get_free_pages(GFP_KERNEL, order);
+		base = (void *)__get_free_pages(GFP_KERNEL, order);
 	}
 
 	if (!base)
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
lib-bitmap-added-alignment-offset-for-bitmap_find_next_zero_area.patch
mm-cma-align-to-physical-address-not-cma-region-position.patch
mm-debug-pagealloc-cleanup-page-guard-code.patch
include-linux-kmemleakh-needs-slabh.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging.patch
mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch
mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch
stacktrace-introduce-snprint_stack_trace-for-buffer-output.patch
mm-page_owner-keep-track-of-page-owners.patch
mm-page_owner-correct-owner-information-for-early-allocated-pages.patch
documentation-add-new-page_owner-document.patch
fix-memory-ordering-bug-in-mm-vmallocc.patch
memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache.patch
zsmalloc-merge-size_class-to-reduce-fragmentation.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch

