From: akpm@linux-foundation.org
Subject: [merged] mm-slab-remove-zone_dma_flag.patch removed from -mm tree
Date: Fri, 20 May 2016 14:03:44 -0700
Message-ID: <573f7bb0.x6Xu8t0/Uomc90du%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETVDp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:03:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yang.shi@linaro.org, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slab: remove ZONE_DMA_FLAG
has been removed from the -mm tree.  Its filename was
     mm-slab-remove-zone_dma_flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <yang.shi@linaro.org>
Subject: mm: slab: remove ZONE_DMA_FLAG

Now we have IS_ENABLED helper to check if a Kconfig option is enabled or
not, so ZONE_DMA_FLAG sounds no longer useful.

And, the use of ZONE_DMA_FLAG in slab looks pointless according to the
comment [1] from Johannes Weiner, so remove them and ORing passed in flags with
the cache gfp flags has been done in kmem_getpages().

[1] https://lkml.org/lkml/2014/9/25/553

Link: http://lkml.kernel.org/r/1462381297-11009-1-git-send-email-yang.shi@linaro.org
Signed-off-by: Yang Shi <yang.shi@linaro.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    5 -----
 mm/slab.c  |   23 +----------------------
 2 files changed, 1 insertion(+), 27 deletions(-)

diff -puN mm/Kconfig~mm-slab-remove-zone_dma_flag mm/Kconfig
--- a/mm/Kconfig~mm-slab-remove-zone_dma_flag
+++ a/mm/Kconfig
@@ -268,11 +268,6 @@ config ARCH_ENABLE_HUGEPAGE_MIGRATION
 config PHYS_ADDR_T_64BIT
 	def_bool 64BIT || ARCH_PHYS_ADDR_T_64BIT
 
-config ZONE_DMA_FLAG
-	int
-	default "0" if !ZONE_DMA
-	default "1"
-
 config BOUNCE
 	bool "Enable bounce buffers"
 	default y
diff -puN mm/slab.c~mm-slab-remove-zone_dma_flag mm/slab.c
--- a/mm/slab.c~mm-slab-remove-zone_dma_flag
+++ a/mm/slab.c
@@ -2236,7 +2236,7 @@ done:
 	cachep->freelist_size = cachep->num * sizeof(freelist_idx_t);
 	cachep->flags = flags;
 	cachep->allocflags = __GFP_COMP;
-	if (CONFIG_ZONE_DMA_FLAG && (flags & SLAB_CACHE_DMA))
+	if (flags & SLAB_CACHE_DMA)
 		cachep->allocflags |= GFP_DMA;
 	cachep->size = size;
 	cachep->reciprocal_buffer_size = reciprocal_value(size);
@@ -2664,16 +2664,6 @@ static void cache_init_objs(struct kmem_
 	}
 }
 
-static void kmem_flagcheck(struct kmem_cache *cachep, gfp_t flags)
-{
-	if (CONFIG_ZONE_DMA_FLAG) {
-		if (flags & GFP_DMA)
-			BUG_ON(!(cachep->allocflags & GFP_DMA));
-		else
-			BUG_ON(cachep->allocflags & GFP_DMA);
-	}
-}
-
 static void *slab_get_obj(struct kmem_cache *cachep, struct page *page)
 {
 	void *objp;
@@ -2753,14 +2743,6 @@ static struct page *cache_grow_begin(str
 		local_irq_enable();
 
 	/*
-	 * The test for missing atomic flag is performed here, rather than
-	 * the more obvious place, simply to reduce the critical path length
-	 * in kmem_cache_alloc(). If a caller is seriously mis-behaving they
-	 * will eventually be caught here (where it matters).
-	 */
-	kmem_flagcheck(cachep, flags);
