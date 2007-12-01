From: akpm@linux-foundation.org
Subject: - acpi-avoid-references-to-impossible-processors.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:24:12 -0800
Message-ID: <200712010024.lB10OCeu032050@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49831 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757404AbXLAA1h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:27:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, ak@suse.de, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ACPI: avoid references to impossible processors.
has been removed from the -mm tree.  Its filename was
     acpi-avoid-references-to-impossible-processors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ACPI: avoid references to impossible processors.
From: Christoph Lameter <clameter@sgi.com>

ACPI uses NR_CPUS in various loops and in some it accesses per cpu data of
processors that are not present(!) and that will never be present.

The pointers to per cpu data are typically not initialized for processors
that are not present.  So we seem to be reading something here from offset
0 in memory.

Make ACPI use nr_cpu_ids instead. That stops at the end of the possible
processors.

Convert one loop to NR_CPUS to use the cpu_possible map instead.  That way
ranges of processor that can never be brought online are skipped during the
loop.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Len Brown <lenb@kernel.org>
Acked-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_core.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/acpi/processor_core.c~acpi-avoid-references-to-impossible-processors drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~acpi-avoid-references-to-impossible-processors
+++ a/drivers/acpi/processor_core.c
@@ -494,7 +494,7 @@ static int get_cpu_id(acpi_handle handle
 	if (apic_id == -1)
 		return apic_id;
 
-	for (i = 0; i < NR_CPUS; ++i) {
+	for_each_possible_cpu(i) {
 		if (cpu_physical_id(i) == apic_id)
 			return i;
 	}
@@ -632,7 +632,7 @@ static int __cpuinit acpi_processor_star
 		return 0;
 	}
 
-	BUG_ON((pr->id >= NR_CPUS) || (pr->id < 0));
+	BUG_ON((pr->id >= nr_cpu_ids) || (pr->id < 0));
 
 	/*
 	 * Buggy BIOS check
@@ -774,7 +774,7 @@ static int acpi_processor_remove(struct 
 
 	pr = acpi_driver_data(device);
 
-	if (pr->id >= NR_CPUS) {
+	if (pr->id >= nr_cpu_ids) {
 		kfree(pr);
 		return 0;
 	}
@@ -845,7 +845,7 @@ int acpi_processor_device_add(acpi_handl
 	if (!pr)
 		return -ENODEV;
 
-	if ((pr->id >= 0) && (pr->id < NR_CPUS)) {
+	if ((pr->id >= 0) && (pr->id < nr_cpu_ids)) {
 		kobject_uevent(&(*device)->dev.kobj, KOBJ_ONLINE);
 	}
 	return 0;
@@ -883,13 +883,13 @@ acpi_processor_hotplug_notify(acpi_handl
 			break;
 		}
 
-		if (pr->id >= 0 && (pr->id < NR_CPUS)) {
+		if (pr->id >= 0 && (pr->id < nr_cpu_ids)) {
 			kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
 			break;
 		}
 
 		result = acpi_processor_start(device);
-		if ((!result) && ((pr->id >= 0) && (pr->id < NR_CPUS))) {
+		if ((!result) && ((pr->id >= 0) && (pr->id < nr_cpu_ids))) {
 			kobject_uevent(&device->dev.kobj, KOBJ_ONLINE);
 		} else {
 			printk(KERN_ERR PREFIX "Device [%s] failed to start\n",
@@ -912,7 +912,7 @@ acpi_processor_hotplug_notify(acpi_handl
 			return;
 		}
 
-		if ((pr->id < NR_CPUS) && (cpu_present(pr->id)))
+		if ((pr->id < nr_cpu_ids) && (cpu_present(pr->id)))
 			kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
 		break;
 	default:
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slab-fix-kmem_cache_free-performance-regression.patch
ia64-slim-down-__clear_bit_unlock.patch
git-unionfs.patch
git-x86.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
vmalloc-add-const-to-void-parameters-fix.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
vunmap-return-page-array-passed-on-vmap.patch
slub-move-count_partial.patch
slub-rename-numa-defrag_ratio-to-remote_node_defrag_ratio.patch
slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch
slub-use-non-atomic-bit-unlock.patch
slub-fix-coding-style-violations.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-noinline-some-functions-to-avoid-them-being-folded-into-alloc-free.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial-slub-workaround-for-lockdep-confusion.patch
slub-avoid-checking-for-a-valid-object-before-zeroing-on-the-fast-path.patch
slub-__slab_alloc-exit-path-consolidation.patch
slub-provide-unique-end-marker-for-each-slab.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch
slub-optional-fast-path-using-cmpxchg_local.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-fix.patch
slub-restructure-slab-alloc.patch
slub-comment-kmem_cache_cpu-structure.patch
vm-allow-get_page_unless_zero-on-compound-pages.patch
bufferhead-revert-constructor-removal.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
swapin_readahead-excise-numa-bogosity.patch
page-allocator-clean-up-pcp-draining-functions.patch
vmstat-small-revisions-to-refresh_cpu_vm_stats.patch
page-allocator-get-rid-of-the-list-of-cold-pages.patch
page-allocator-get-rid-of-the-list-of-cold-pages-fix.patch
mm-sparsec-check-the-return-value-of-sparse_index_alloc.patch
vmstat-remove-prefetch.patch
mm-sparsec-improve-the-error-handling-for-sparse_add_one_section.patch
percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup-bugfix-for-memory-cgroup-per-zone-struct-allocation.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-include-sectionsh-to-avoid-defining-linker-variables.patch
modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
