From: akpm@osdl.org
Subject: - slab-remove-slab_noio.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:58:07 -0800
Message-ID: <200612072258.kB7Mw7wg029358@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50700 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163574AbWLGW6J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:58:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slab: remove SLAB_NOIO
has been removed from the -mm tree.  Its filename was
     slab-remove-slab_noio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab: remove SLAB_NOIO
From: Christoph Lameter <clameter@sgi.com>

SLAB_NOIO is an alias of GFP_NOIO with a single instance of use.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/storage/transport.c |    2 +-
 include/linux/slab.h            |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/usb/storage/transport.c~slab-remove-slab_noio drivers/usb/storage/transport.c
--- a/drivers/usb/storage/transport.c~slab-remove-slab_noio
+++ a/drivers/usb/storage/transport.c
@@ -427,7 +427,7 @@ static int usb_stor_bulk_transfer_sglist
 	US_DEBUGP("%s: xfer %u bytes, %d entries\n", __FUNCTION__,
 			length, num_sg);
 	result = usb_sg_init(&us->current_sg, us->pusb_dev, pipe, 0,
-			sg, num_sg, length, SLAB_NOIO);
+			sg, num_sg, length, GFP_NOIO);
 	if (result) {
 		US_DEBUGP("usb_sg_init returned %d\n", result);
 		return USB_STOR_XFER_ERROR;
diff -puN include/linux/slab.h~slab-remove-slab_noio include/linux/slab.h
--- a/include/linux/slab.h~slab-remove-slab_noio
+++ a/include/linux/slab.h
@@ -20,7 +20,6 @@ typedef struct kmem_cache kmem_cache_t;
 
 /* flags for kmem_cache_alloc() */
 #define	SLAB_NOFS		GFP_NOFS
-#define	SLAB_NOIO		GFP_NOIO
 #define	SLAB_ATOMIC		GFP_ATOMIC
 #define	SLAB_USER		GFP_USER
 #define	SLAB_KERNEL		GFP_KERNEL
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

