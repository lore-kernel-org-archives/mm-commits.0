From: akpm@linux-foundation.org
Subject: + mm-slb-correct-allocation-type-check-in-kmalloc_slab.patch added to -mm tree
Date: Mon, 04 Feb 2013 14:07:31 -0800
Message-ID: <20130204220731.A2F855A40F3@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:35815 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab3BDWHc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2013 17:07:32 -0500
Received: by mail-vb0-f73.google.com with SMTP id fj18so211126vbb.4
        for <mm-commits@vger.kernel.org>; Mon, 04 Feb 2013 14:07:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: js1304@gmail.com, cl@linux.com, fengguang.wu@intel.com, penberg@kernel.org


The patch titled
     Subject: mm/sl[au]b: correct allocation type check in kmalloc_slab()
has been added to the -mm tree.  Its filename is
     mm-slb-correct-allocation-type-check-in-kmalloc_slab.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-slb-correct-allocation-type-check-in-kmalloc_slab.patch

