From: akpm@osdl.org
Subject: + slab-fix-sleeping-in-atomic-bug.patch added to -mm tree
Date: Mon, 11 Dec 2006 14:34:55 -0800
Message-ID: <200612112234.kBBMYtg7010731@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:44519 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937683AbWLKWfC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 17:35:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, jacliburn@bellsouth.net


The patch titled
     slab: fix sleeping in atomic bug
has been added to the -mm tree.  Its filename is
     slab-fix-sleeping-in-atomic-bug.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 6 insertions(+)

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

origin.patch
slab-fix-sleeping-in-atomic-bug.patch
cleanup-slab-headers--api-to-allow-easy-addition-of-new-slab.patch
more-slabh-cleanups.patch
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
workstruct-implement-generic-up-cmpxchg-where-an-arch-doesnt-support-it.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch

