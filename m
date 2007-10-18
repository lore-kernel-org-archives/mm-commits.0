From: akpm@linux-foundation.org
Subject: - slub-simplify-irq-off-handling.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:51:31 -0700
Message-ID: <200710180651.l9I6pV3G030196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55629 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932123AbXJRHhv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:37:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: simplify IRQ off handling
has been removed from the -mm tree.  Its filename was
     slub-simplify-irq-off-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: simplify IRQ off handling
From: Christoph Lameter <clameter@sgi.com>

Move irq handling out of new slab into __slab_alloc.  That is useful for
Mathieu's cmpxchg_local patchset and also allows us to remove the crude
local_irq_off in early_kmem_cache_alloc().

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff -puN mm/slub.c~slub-simplify-irq-off-handling mm/slub.c
--- a/mm/slub.c~slub-simplify-irq-off-handling
+++ a/mm/slub.c
@@ -1085,9 +1085,6 @@ static struct page *new_slab(struct kmem
 
 	BUG_ON(flags & GFP_SLAB_BUG_MASK);
 
-	if (flags & __GFP_WAIT)
-		local_irq_enable();
-
 	page = allocate_slab(s,
 		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);
 	if (!page)
@@ -1120,8 +1117,6 @@ static struct page *new_slab(struct kmem
 	page->freelist = start;
 	page->inuse = 0;
 out:
-	if (flags & __GFP_WAIT)
-		local_irq_disable();
 	return page;
 }
 
@@ -1505,7 +1500,14 @@ new_slab:
 		goto load_freelist;
 	}
 
+	if (gfpflags & __GFP_WAIT)
+		local_irq_enable();
+
 	new = new_slab(s, gfpflags, node);
+
+	if (gfpflags & __GFP_WAIT)
+		local_irq_disable();
+
 	if (new) {
 		c = get_cpu_slab(s, smp_processor_id());
 		if (c->page) {
@@ -2039,12 +2041,6 @@ static struct kmem_cache_node *early_kme
 	init_kmem_cache_node(n);
 	atomic_long_inc(&n->nr_slabs);
 	add_partial(n, page);
-
-	/*
-	 * new_slab() disables interupts. If we do not reenable interrupts here
-	 * then bootup would continue with interrupts disabled.
-	 */
-	local_irq_enable();
 	return n;
 }
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
mem-policy-fix-mempolicy-usage-in-pci-driver.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
git-x86.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-core-code.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-whitespace-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
bit_spin_lock-use-lock-bitops.patch
ext3-support-large-blocksize-up-to-pagesize.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
