From: akpm@linux-foundation.org
Subject: - slub-do-not-use-page-mapping.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:35:13 -0700
Message-ID: <200710162035.l9GKZDJ5015041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59261 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965732AbXJPVcQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:32:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: Do not use page->mapping
has been removed from the -mm tree.  Its filename was
     slub-do-not-use-page-mapping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: Do not use page->mapping
From: Christoph Lameter <clameter@sgi.com>

After moving the lockless_freelist to kmem_cache_cpu we no longer need
page->lockless_freelist. Restructure the use of the struct page fields in
such a way that we never touch the mapping field.

This is turn allows us to remove the special casing of SLUB when determining
the mapping of a page (needed for corner cases of virtual caches machines that
need to flush caches of processors mapping a page).

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |    4 ----
 include/linux/mm_types.h |    9 ++-------
 mm/slub.c                |    2 --
 3 files changed, 2 insertions(+), 13 deletions(-)

diff -puN include/linux/mm.h~slub-do-not-use-page-mapping include/linux/mm.h
--- a/include/linux/mm.h~slub-do-not-use-page-mapping
+++ a/include/linux/mm.h
@@ -568,10 +568,6 @@ static inline struct address_space *page
 	VM_BUG_ON(PageSlab(page));
 	if (unlikely(PageSwapCache(page)))
 		mapping = &swapper_space;
-#ifdef CONFIG_SLUB
-	else if (unlikely(PageSlab(page)))
-		mapping = NULL;
-#endif
 	else if (unlikely((unsigned long)mapping & PAGE_MAPPING_ANON))
 		mapping = NULL;
 	return mapping;
diff -puN include/linux/mm_types.h~slub-do-not-use-page-mapping include/linux/mm_types.h
--- a/include/linux/mm_types.h~slub-do-not-use-page-mapping
+++ a/include/linux/mm_types.h
@@ -62,13 +62,8 @@ struct page {
 #if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS
 	    spinlock_t ptl;
 #endif
-	    struct {			/* SLUB uses */
-	    	void **lockless_freelist;
-		struct kmem_cache *slab;	/* Pointer to slab */
-	    };
-	    struct {
-		struct page *first_page;	/* Compound pages */
-	    };
+	    struct kmem_cache *slab;	/* SLUB: Pointer to slab */
+	    struct page *first_page;	/* Compound tail pages */
 	};
 	union {
 		pgoff_t index;		/* Our offset within mapping. */
diff -puN mm/slub.c~slub-do-not-use-page-mapping mm/slub.c
--- a/mm/slub.c~slub-do-not-use-page-mapping
+++ a/mm/slub.c
@@ -1127,7 +1127,6 @@ static struct page *new_slab(struct kmem
 	set_freepointer(s, last, NULL);
 
 	page->freelist = start;
-	page->lockless_freelist = NULL;
 	page->inuse = 0;
 out:
 	if (flags & __GFP_WAIT)
@@ -1153,7 +1152,6 @@ static void __free_slab(struct kmem_cach
 		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
 		- pages);
 
-	page->mapping = NULL;
 	__free_pages(page, s->order);
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
