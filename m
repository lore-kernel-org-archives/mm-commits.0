From: akpm@linux-foundation.org
Subject: - slub-optimize-cacheline-use-for-zeroing.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:35:22 -0700
Message-ID: <200710162035.l9GKZM7u015053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49203 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965571AbXJPVcY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:32:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: Optimize cacheline use for zeroing
has been removed from the -mm tree.  Its filename was
     slub-optimize-cacheline-use-for-zeroing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: Optimize cacheline use for zeroing
From: Christoph Lameter <clameter@sgi.com>

We touch a cacheline in the kmem_cache structure for zeroing to get the
size. However, the hot paths in slab_alloc and slab_free do not reference
any other fields in kmem_cache, so we may have to just bring in the
cacheline for this one access.

Add a new field to kmem_cache_cpu that contains the object size. That
cacheline must already be used in the hotpaths. So we save one cacheline
on every slab_alloc if we zero.

We need to update the kmem_cache_cpu object size if an aliasing operation
changes the objsize of an non debug slab.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |    1 +
 mm/slub.c                |   14 ++++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff -puN include/linux/slub_def.h~slub-optimize-cacheline-use-for-zeroing include/linux/slub_def.h
--- a/include/linux/slub_def.h~slub-optimize-cacheline-use-for-zeroing
+++ a/include/linux/slub_def.h
@@ -16,6 +16,7 @@ struct kmem_cache_cpu {
 	struct page *page;
 	int node;
 	unsigned int offset;
+	unsigned int objsize;
 };
 
 struct kmem_cache_node {
diff -puN mm/slub.c~slub-optimize-cacheline-use-for-zeroing mm/slub.c
--- a/mm/slub.c~slub-optimize-cacheline-use-for-zeroing
+++ a/mm/slub.c
@@ -1576,7 +1576,7 @@ static void __always_inline *slab_alloc(
 	local_irq_restore(flags);
 
 	if (unlikely((gfpflags & __GFP_ZERO) && object))
-		memset(object, 0, s->objsize);
+		memset(object, 0, c->objsize);
 
 	return object;
 }
@@ -1858,8 +1858,9 @@ static void init_kmem_cache_cpu(struct k
 {
 	c->page = NULL;
 	c->freelist = NULL;
-	c->offset = s->offset / sizeof(void *);
 	c->node = 0;
+	c->offset = s->offset / sizeof(void *);
+	c->objsize = s->objsize;
 }
 
 static void init_kmem_cache_node(struct kmem_cache_node *n)
@@ -2852,12 +2853,21 @@ struct kmem_cache *kmem_cache_create(con
 	down_write(&slub_lock);
 	s = find_mergeable(size, align, flags, name, ctor);
 	if (s) {
+		int cpu;
+
 		s->refcount++;
 		/*
 		 * Adjust the object sizes so that we clear
 		 * the complete object on kzalloc.
 		 */
 		s->objsize = max(s->objsize, (int)size);
+
+		/*
+		 * And then we need to update the object size in the
+		 * per cpu structures
+		 */
+		for_each_online_cpu(cpu)
+			get_cpu_slab(s, cpu)->objsize = s->objsize;
 		s->inuse = max_t(int, s->inuse, ALIGN(size, sizeof(void *)));
 		up_write(&slub_lock);
 		if (sysfs_slab_alias(s, name))
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
