From: akpm@linux-foundation.org
Subject: [merged] mm-slb-correct-allocation-type-check-in-kmalloc_slab.patch removed from -mm tree
Date: Wed, 13 Feb 2013 12:35:51 -0800
Message-ID: <20130213203552.0E1FB31C1D6@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:38941 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab3BMUfx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Feb 2013 15:35:53 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so165520vch.0
        for <mm-commits@vger.kernel.org>; Wed, 13 Feb 2013 12:35:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, cl@linux.com, fengguang.wu@intel.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sl[au]b: correct allocation type check in kmalloc_slab()
has been removed from the -mm tree.  Its filename was
     mm-slb-correct-allocation-type-check-in-kmalloc_slab.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm/sl[au]b: correct allocation type check in kmalloc_slab()

commit "slab: Common Kmalloc cache determination" made mistake
in kmalloc_slab(). SLAB_CACHE_DMA is for kmem_cache creation,
not for allocation. For allocation, we should use GFP_XXX to identify
type of allocation. So, change SLAB_CACHE_DMA to GFP_DMA.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab_common.c~mm-slb-correct-allocation-type-check-in-kmalloc_slab mm/slab_common.c
--- a/mm/slab_common.c~mm-slb-correct-allocation-type-check-in-kmalloc_slab
+++ a/mm/slab_common.c
@@ -382,7 +382,7 @@ struct kmem_cache *kmalloc_slab(size_t s
 		index = fls(size - 1);
 
 #ifdef CONFIG_ZONE_DMA
-	if (unlikely((flags & SLAB_CACHE_DMA)))
+	if (unlikely((flags & GFP_DMA)))
 		return kmalloc_dma_caches[index];
 
 #endif
_

Patches currently in -mm which might be from js1304@gmail.com are

linux-next.patch

