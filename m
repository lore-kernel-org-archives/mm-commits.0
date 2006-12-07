From: akpm@osdl.org
Subject: - slab-remove-slab_dma.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:58:17 -0800
Message-ID: <200612072258.kB7MwHo6029380@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50719 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163640AbWLGW6U (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:58:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slab: remove SLAB_DMA
has been removed from the -mm tree.  Its filename was
     slab-remove-slab_dma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab: remove SLAB_DMA
From: Christoph Lameter <clameter@sgi.com>

SLAB_DMA is an alias of GFP_DMA. This is the last one so we
remove the leftover comment too.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/atm/he.c               |    6 +++---
 drivers/s390/block/dasd_eckd.c |    2 +-
 drivers/s390/block/dasd_fba.c  |    2 +-
 drivers/usb/core/buffer.c      |    2 +-
 include/linux/slab.h           |    3 ---
 mm/slab.c                      |    4 ++--
 6 files changed, 8 insertions(+), 11 deletions(-)

diff -puN drivers/atm/he.c~slab-remove-slab_dma drivers/atm/he.c
--- a/drivers/atm/he.c~slab-remove-slab_dma
+++ a/drivers/atm/he.c
@@ -820,7 +820,7 @@ he_init_group(struct he_dev *he_dev, int
 		void *cpuaddr;
 
 #ifdef USE_RBPS_POOL 
-		cpuaddr = pci_pool_alloc(he_dev->rbps_pool, GFP_KERNEL|SLAB_DMA, &dma_handle);
+		cpuaddr = pci_pool_alloc(he_dev->rbps_pool, GFP_KERNEL|GFP_DMA, &dma_handle);
 		if (cpuaddr == NULL)
 			return -ENOMEM;
 #else
@@ -884,7 +884,7 @@ he_init_group(struct he_dev *he_dev, int
 		void *cpuaddr;
 
 #ifdef USE_RBPL_POOL
-		cpuaddr = pci_pool_alloc(he_dev->rbpl_pool, GFP_KERNEL|SLAB_DMA, &dma_handle);
+		cpuaddr = pci_pool_alloc(he_dev->rbpl_pool, GFP_KERNEL|GFP_DMA, &dma_handle);
 		if (cpuaddr == NULL)
 			return -ENOMEM;
 #else
@@ -1724,7 +1724,7 @@ __alloc_tpd(struct he_dev *he_dev)
 	struct he_tpd *tpd;
 	dma_addr_t dma_handle; 
 
-	tpd = pci_pool_alloc(he_dev->tpd_pool, GFP_ATOMIC|SLAB_DMA, &dma_handle);
+	tpd = pci_pool_alloc(he_dev->tpd_pool, GFP_ATOMIC|GFP_DMA, &dma_handle);
 	if (tpd == NULL)
 		return NULL;
 			
diff -puN drivers/s390/block/dasd_eckd.c~slab-remove-slab_dma drivers/s390/block/dasd_eckd.c
--- a/drivers/s390/block/dasd_eckd.c~slab-remove-slab_dma
+++ a/drivers/s390/block/dasd_eckd.c
@@ -1215,7 +1215,7 @@ dasd_eckd_build_cp(struct dasd_device * 
 		dst = page_address(bv->bv_page) + bv->bv_offset;
 		if (dasd_page_cache) {
 			char *copy = kmem_cache_alloc(dasd_page_cache,
-						      SLAB_DMA | __GFP_NOWARN);
+						      GFP_DMA | __GFP_NOWARN);
 			if (copy && rq_data_dir(req) == WRITE)
 				memcpy(copy + bv->bv_offset, dst, bv->bv_len);
 			if (copy)
diff -puN drivers/s390/block/dasd_fba.c~slab-remove-slab_dma drivers/s390/block/dasd_fba.c
--- a/drivers/s390/block/dasd_fba.c~slab-remove-slab_dma
+++ a/drivers/s390/block/dasd_fba.c
@@ -308,7 +308,7 @@ dasd_fba_build_cp(struct dasd_device * d
 		dst = page_address(bv->bv_page) + bv->bv_offset;
 		if (dasd_page_cache) {
 			char *copy = kmem_cache_alloc(dasd_page_cache,
-						      SLAB_DMA | __GFP_NOWARN);
+						      GFP_DMA | __GFP_NOWARN);
 			if (copy && rq_data_dir(req) == WRITE)
 				memcpy(copy + bv->bv_offset, dst, bv->bv_len);
 			if (copy)
diff -puN drivers/usb/core/buffer.c~slab-remove-slab_dma drivers/usb/core/buffer.c
--- a/drivers/usb/core/buffer.c~slab-remove-slab_dma
+++ a/drivers/usb/core/buffer.c
@@ -93,7 +93,7 @@ void hcd_buffer_destroy (struct usb_hcd 
 }
 
 
-/* sometimes alloc/free could use kmalloc with SLAB_DMA, for
+/* sometimes alloc/free could use kmalloc with GFP_DMA, for
  * better sharing and to leverage mm/slab.c intelligence.
  */
 
diff -puN include/linux/slab.h~slab-remove-slab_dma include/linux/slab.h
--- a/include/linux/slab.h~slab-remove-slab_dma
+++ a/include/linux/slab.h
@@ -18,9 +18,6 @@ typedef struct kmem_cache kmem_cache_t;
 #include	<asm/page.h>		/* kmalloc_sizes.h needs PAGE_SIZE */
 #include	<asm/cache.h>		/* kmalloc_sizes.h needs L1_CACHE_BYTES */
 
-/* flags for kmem_cache_alloc() */
-#define	SLAB_DMA		GFP_DMA
-
 /* flags to pass to kmem_cache_create().
  * The first 3 are only valid when the allocator as been build
  * SLAB_DEBUG_SUPPORT.
diff -puN mm/slab.c~slab-remove-slab_dma mm/slab.c
--- a/mm/slab.c~slab-remove-slab_dma
+++ a/mm/slab.c
@@ -2637,7 +2637,7 @@ static void cache_init_objs(struct kmem_
 
 static void kmem_flagcheck(struct kmem_cache *cachep, gfp_t flags)
 {
-	if (flags & SLAB_DMA)
+	if (flags & GFP_DMA)
 		BUG_ON(!(cachep->gfpflags & GFP_DMA));
 	else
 		BUG_ON(cachep->gfpflags & GFP_DMA);
@@ -2721,7 +2721,7 @@ static int cache_grow(struct kmem_cache 
 	 * Be lazy and only check for valid flags here,  keeping it out of the
 	 * critical path in kmem_cache_alloc().
 	 */
-	BUG_ON(flags & ~(SLAB_DMA | GFP_LEVEL_MASK | __GFP_NO_GROW));
+	BUG_ON(flags & ~(GFP_DMA | GFP_LEVEL_MASK | __GFP_NO_GROW));
 	if (flags & __GFP_NO_GROW)
 		return 0;
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
workstruct-implement-generic-up-cmpxchg-where-an-arch-doesnt-support-it.patch
ia64-resolve-name-clash-by-renaming-is_available_memory.patch
deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
introduce-config_zone_dma.patch
optional-zone_dma-in-the-vm.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs.patch
optional-zone_dma-for-ia64.patch
remove-zone_dma-remains-from-parisc.patch
remove-zone_dma-remains-from-sh-sh64.patch
set-config_zone_dma-for-arches-with-generic_isa_dma.patch
zoneid-fix-up-calculations-for-zoneid_pgshift.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch
sched-domain-move-sched-group-allocations-to-percpu-area.patch
sched-avoid-taking-rq-lock-in-wake_priority_sleeper.patch
sched-remove-staggering-of-load-balancing.patch
sched-disable-interrupts-for-locking-in-load_balance.patch
sched-extract-load-calculation-from-rebalance_tick.patch
sched-move-idle-status-calculation-into-rebalance_tick.patch
sched-use-softirq-for-load-balancing.patch
sched-call-tasklet-less-frequently.patch
sched-add-option-to-serialize-load-balancing.patch
sched-add-option-to-serialize-load-balancing-fix.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch

