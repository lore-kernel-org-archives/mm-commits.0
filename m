From: akpm@linux-foundation.org
Subject: - slab-allocators-fail-if-ksize-is-called-with-a-null-parameter.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:31:35 -0700
Message-ID: <200710162031.l9GKVZoZ014513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53563 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965508AbXJPVgw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:36:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mpm@selenic.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     Slab allocators: fail if ksize is called with a NULL parameter
has been removed from the -mm tree.  Its filename was
     slab-allocators-fail-if-ksize-is-called-with-a-null-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Slab allocators: fail if ksize is called with a NULL parameter
From: Christoph Lameter <clameter@sgi.com>

A NULL pointer means that the object was not allocated.  One cannot
determine the size of an object that has not been allocated.  Currently we
return 0 but we really should BUG() on attempts to determine the size of
something nonexistent.

krealloc() interprets NULL to mean a zero sized object.  Handle that
separately in krealloc().

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    3 ++-
 mm/slob.c |    3 ++-
 mm/slub.c |    3 ++-
 mm/util.c |    6 ++++--
 4 files changed, 10 insertions(+), 5 deletions(-)

diff -puN mm/slab.c~slab-allocators-fail-if-ksize-is-called-with-a-null-parameter mm/slab.c
--- a/mm/slab.c~slab-allocators-fail-if-ksize-is-called-with-a-null-parameter
+++ a/mm/slab.c
@@ -4446,7 +4446,8 @@ const struct seq_operations slabstats_op
  */
 size_t ksize(const void *objp)
 {
-	if (unlikely(ZERO_OR_NULL_PTR(objp)))
+	BUG_ON(!objp);
+	if (unlikely(objp == ZERO_SIZE_PTR))
 		return 0;
 
 	return obj_size(virt_to_cache(objp));
diff -puN mm/slob.c~slab-allocators-fail-if-ksize-is-called-with-a-null-parameter mm/slob.c
--- a/mm/slob.c~slab-allocators-fail-if-ksize-is-called-with-a-null-parameter
+++ a/mm/slob.c
@@ -484,7 +484,8 @@ size_t ksize(const void *block)
 {
 	struct slob_page *sp;
 
-	if (unlikely(ZERO_OR_NULL_PTR(block)))
+	BUG_ON(!block);
+	if (unlikely(block == ZERO_SIZE_PTR))
 		return 0;
 
 	sp = (struct slob_page *)virt_to_page(block);
diff -puN mm/slub.c~slab-allocators-fail-if-ksize-is-called-with-a-null-parameter mm/slub.c
--- a/mm/slub.c~slab-allocators-fail-if-ksize-is-called-with-a-null-parameter
+++ a/mm/slub.c
@@ -2449,7 +2449,8 @@ size_t ksize(const void *object)
 	struct page *page;
 	struct kmem_cache *s;
 
-	if (unlikely(ZERO_OR_NULL_PTR(object)))
+	BUG_ON(!object);
+	if (unlikely(object == ZERO_SIZE_PTR))
 		return 0;
 
 	page = get_object_page(object);
diff -puN mm/util.c~slab-allocators-fail-if-ksize-is-called-with-a-null-parameter mm/util.c
--- a/mm/util.c~slab-allocators-fail-if-ksize-is-called-with-a-null-parameter
+++ a/mm/util.c
@@ -81,14 +81,16 @@ EXPORT_SYMBOL(kmemdup);
 void *krealloc(const void *p, size_t new_size, gfp_t flags)
 {
 	void *ret;
-	size_t ks;
+	size_t ks = 0;
 
 	if (unlikely(!new_size)) {
 		kfree(p);
 		return ZERO_SIZE_PTR;
 	}
 
-	ks = ksize(p);
+	if (p)
+		ks = ksize(p);
+
 	if (ks >= new_size)
 		return (void *)p;
 
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
