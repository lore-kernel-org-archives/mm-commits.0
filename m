From: akpm@linux-foundation.org
Subject: - vmstat-small-revisions-to-refresh_cpu_vm_stats.patch removed from -mm tree
Date: Tue, 13 Nov 2007 03:33:40 -0800
Message-ID: <200711131140.lADBebFi008511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51464 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757893AbXKMLkm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Nov 2007 06:40:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     vmstat: small revisions to refresh_cpu_vm_stats()
has been removed from the -mm tree.  Its filename was
     vmstat-small-revisions-to-refresh_cpu_vm_stats.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: vmstat: small revisions to refresh_cpu_vm_stats()
From: Christoph Lameter <clameter@sgi.com>

1. Add comments explaining how the function can be called.

2. Avoid interrupt enable / disable through the use of xchg.

3. Collect global diffs in a local array and only spill
   them once into the global counters when the zone scan
   is finished. This means that we only touch each global
   counter once instead of each time we fold cpu counters
   into zone counters.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff -puN mm/vmstat.c~vmstat-small-revisions-to-refresh_cpu_vm_stats mm/vmstat.c
--- a/mm/vmstat.c~vmstat-small-revisions-to-refresh_cpu_vm_stats
+++ a/mm/vmstat.c
@@ -284,6 +284,10 @@ EXPORT_SYMBOL(dec_zone_page_state);
 /*
  * Update the zone counters for one cpu.
  *
+ * The cpu specified must be either the current cpu or a processor that
+ * is not online. If it is the current cpu then the execution thread must
+ * be pinned to the current cpu.
+ *
  * Note that refresh_cpu_vm_stats strives to only access
  * node local memory. The per cpu pagesets on remote zones are placed
  * in the memory local to the processor using that pageset. So the
@@ -299,7 +303,7 @@ void refresh_cpu_vm_stats(int cpu)
 {
 	struct zone *zone;
 	int i;
-	unsigned long flags;
+	int global_diff[NR_VM_ZONE_STAT_ITEMS] = { 0, };
 
 	for_each_zone(zone) {
 		struct per_cpu_pageset *p;
@@ -311,15 +315,14 @@ void refresh_cpu_vm_stats(int cpu)
 
 		for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
 			if (p->vm_stat_diff[i]) {
-				local_irq_save(flags);
-				zone_page_state_add(p->vm_stat_diff[i],
-					zone, i);
-				p->vm_stat_diff[i] = 0;
+				int v = xchg(&p->vm_stat_diff[i], 0);
+
+				atomic_long_add(v, &zone->vm_stat[i]);
+				global_diff[i] += v;
 #ifdef CONFIG_NUMA
 				/* 3 seconds idle till flush */
 				p->expire = 3;
 #endif
-				local_irq_restore(flags);
 			}
 #ifdef CONFIG_NUMA
 		/*
@@ -351,6 +354,10 @@ void refresh_cpu_vm_stats(int cpu)
 			drain_zone_pages(zone, p->pcp + 1);
 #endif
 	}
+
+	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
+		if (global_diff[i])
+			atomic_long_add(global_diff[i], &vm_stat[i]);
 }
 
 #endif
_

Patches currently in -mm which might be from clameter@sgi.com are

slab-fix-typo-in-allocation-failure-handling.patch
migration-find-correct-vma-in-new_vma_page.patch
ia64-slim-down-__clear_bit_unlock.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
mem-policy-fix-mempolicy-usage-in-pci-driver.patch
git-unionfs.patch
git-x86.patch
x86_64-clean-up-stack-allocation-and-free.patch
x86_64-configure-stack-size.patch
fix-mm-utilckrealloc.patch
vmstat-fix-section-mismatch-warning.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
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
vmstat-small-revisions-to-refresh_cpu_vm_stats.patch
vmstat-small-revisions-to-refresh_cpu_vm_stats-fix.patch
page-allocator-clean-up-pcp-draining-functions.patch
revoke-core-code.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
