From: akpm@osdl.org
Subject: - slab-fix-sleeping-in-atomic-bug.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:04:20 -0800
Message-ID: <200612140604.kBE64KNx001806@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51733 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbWLNGEh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:04:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, jacliburn@bellsouth.net, mm-commits@vger.kernel.org


The patch titled
     slab: fix sleeping in atomic bug
has been removed from the -mm tree.  Its filename was
     slab-fix-sleeping-in-atomic-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab: fix sleeping in atomic bug
From: Christoph Lameter <clameter@sgi.com>

Fallback_alloc() does not do the check for GFP_WAIT as done in
cache_grow().  Thus interrupts are disabled when we call kmem_getpages()
which results in the failure.

Duplicate the handling of GFP_WAIT in cache_grow().

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/slab.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/slab.c~slab-fix-sleeping-in-atomic-bug mm/slab.c
--- a/mm/slab.c~slab-fix-sleeping-in-atomic-bug
+++ a/mm/slab.c
@@ -3252,6 +3252,7 @@ void *fallback_alloc(struct kmem_cache *
 	struct zone **z;
 	void *obj = NULL;
 	int nid;
+	gfp_t local_flags = (flags & GFP_LEVEL_MASK);
 
 retry:
 	/*
@@ -3275,7 +3276,12 @@ retry:
 		 * We may trigger various forms of reclaim on the allowed
 		 * set and go into memory reserves if necessary.
 		 */
+		if (local_flags & __GFP_WAIT)
+			local_irq_enable();
+		kmem_flagcheck(cache, flags);
 		obj = kmem_getpages(cache, flags, -1);
+		if (local_flags & __GFP_WAIT)
+			local_irq_disable();
 		if (obj) {
 			/*
 			 * Insert into the appropriate per node queues
_

Patches currently in -mm which might be from clameter@sgi.com are

config_vm_event_counter-comment-decrustify.patch
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
workstruct-implement-generic-up-cmpxchg-where-an-arch-doesnt-support-it.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch

