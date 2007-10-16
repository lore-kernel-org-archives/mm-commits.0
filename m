From: akpm@linux-foundation.org
Subject: - slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:35:17 -0700
Message-ID: <200710162035.l9GKZHs4015047@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39149 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965802AbXJPVfd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:35:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, adobriyan@sw.ru, mm-commits@vger.kernel.org


The patch titled
     SLUB: Avoid touching page struct when freeing to per cpu slab
has been removed from the -mm tree.  Its filename was
     slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: Avoid touching page struct when freeing to per cpu slab
From: Christoph Lameter <clameter@sgi.com>

Set c->node to -1 if we allocate from a debug slab instead for SlabDebug
which requires access the page struct cacheline.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Tested-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN mm/slub.c~slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab mm/slub.c
--- a/mm/slub.c~slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab
+++ a/mm/slub.c
@@ -1537,6 +1537,7 @@ debug:
 
 	c->page->inuse++;
 	c->page->freelist = object[c->offset];
+	c->node = -1;
 	slab_unlock(c->page);
 	return object;
 }
@@ -1560,8 +1561,7 @@ static void __always_inline *slab_alloc(
 
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
-	if (unlikely(!c->page || !c->freelist ||
-					!node_match(c, node)))
+	if (unlikely(!c->freelist || !node_match(c, node)))
 
 		object = __slab_alloc(s, gfpflags, node, addr, c);
 
@@ -1670,7 +1670,7 @@ static void __always_inline slab_free(st
 	local_irq_save(flags);
 	debug_check_no_locks_freed(object, s->objsize);
 	c = get_cpu_slab(s, smp_processor_id());
-	if (likely(page == c->page && !SlabDebug(page))) {
+	if (likely(page == c->page && c->node >= 0)) {
 		object[c->offset] = c->freelist;
 		c->freelist = object;
 	} else
@@ -3250,12 +3250,16 @@ static unsigned long slab_objects(struct
 
 	for_each_possible_cpu(cpu) {
 		struct page *page;
+		int node;
 		struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
 
 		if (!c)
 			continue;
 
 		page = c->page;
+		node = c->node;
+		if (node < 0)
+			continue;
 		if (page) {
 			if (flags & SO_CPU) {
 				int x = 0;
@@ -3265,9 +3269,9 @@ static unsigned long slab_objects(struct
 				else
 					x = 1;
 				total += x;
-				nodes[c->node] += x;
+				nodes[node] += x;
 			}
-			per_cpu[c->node]++;
+			per_cpu[node]++;
 		}
 	}
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86-fix-cpu_to_node-references.patch
x86-convert-x86_cpu_to_apicid-to-be-a-per-cpu-variable.patch
x86-convert-cpu_llc_id-to-be-a-per-cpu-variable.patch
x86-acpi-use-cpu_physical_id.patch
x86-convert-cpuinfo_x86-array-to-a-per_cpu-array.patch
slub-simplify-irq-off-handling.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix-2.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
oom-move-prototypes-to-appropriate-header-file.patch
oom-move-constraints-to-enum.patch
oom-change-all_unreclaimable-zone-member-to-flags.patch
oom-change-all_unreclaimable-zone-member-to-flags-fix.patch
oom-add-per-zone-locking.patch
oom-serialize-out-of-memory-calls.patch
oom-add-oom_kill_allocating_task-sysctl.patch
oom-suppress-extraneous-stack-and-memory-dump.patch
oom-compare-cpuset-mems_allowed-instead-of-exclusive.patch
oom-do-not-take-callback_mutex.patch
oom-do-not-take-callback_mutex-fix.patch
oom-prevent-including-schedh-in-header-file.patch
oom-add-header-file-to-kbuild-as-unifdef.patch
oom-convert-zone_scan_lock-from-mutex-to-spinlock.patch
mm-test-and-set-zone-reclaim-lock-before-starting.patch
mm-test-and-set-zone-reclaim-lock-before-starting-cleanup.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
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
documentation-vm-slabinfoc-clean-up-this-code.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
bit_spin_lock-use-lock-bitops.patch
ext3-support-large-blocksize-up-to-pagesize.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
