From: akpm@linux-foundation.org
Subject: [merged]
 mm-slab-initialize-object-alignment-on-cache-creation.patch removed from
 -mm tree
Date: Mon, 29 Sep 2014 13:22:28 -0700
Message-ID: <5429bf84.HHNbcPaM3B7tIJv8%akpm__45860.8763212853$1412022203$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40268 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaI2UWa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Sep 2014 16:22:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, a.elovikov@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slab: initialize object alignment on cache creation
has been removed from the -mm tree.  Its filename was
     mm-slab-initialize-object-alignment-on-cache-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, slab: initialize object alignment on cache creation

Since 4590685546a3 ("mm/sl[aou]b: Common alignment code"), the "ralign"
automatic variable in __kmem_cache_create() may be used as uninitialized.

The proper alignment defaults to BYTES_PER_WORD and can be overridden by
SLAB_RED_ZONE or the alignment specified by the caller.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=85031

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Andrei Elovikov <a.elovikov@gmail.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff -puN mm/slab.c~mm-slab-initialize-object-alignment-on-cache-creation mm/slab.c
--- a/mm/slab.c~mm-slab-initialize-object-alignment-on-cache-creation
+++ a/mm/slab.c
@@ -2124,7 +2124,8 @@ static int __init_refok setup_cpu_cache(
 int
 __kmem_cache_create (struct kmem_cache *cachep, unsigned long flags)
 {
-	size_t left_over, freelist_size, ralign;
+	size_t left_over, freelist_size;
+	size_t ralign = BYTES_PER_WORD;
 	gfp_t gfp;
 	int err;
 	size_t size = cachep->size;
@@ -2157,14 +2158,6 @@ __kmem_cache_create (struct kmem_cache *
 		size &= ~(BYTES_PER_WORD - 1);
 	}
 
-	/*
-	 * Redzoning and user store require word alignment or possibly larger.
-	 * Note this will be overridden by architecture or caller mandated
-	 * alignment if either is greater than BYTES_PER_WORD.
-	 */
-	if (flags & SLAB_STORE_USER)
-		ralign = BYTES_PER_WORD;
-
 	if (flags & SLAB_RED_ZONE) {
 		ralign = REDZONE_ALIGN;
 		/* If redzoning, ensure that the second redzone is suitably
_

Patches currently in -mm which might be from rientjes@google.com are

mm-slab_commonc-suppress-warning.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header-fix.patch
mm-slb-always-track-caller-in-kmalloc_node_track_caller.patch
mm-slab-move-cache_flusharray-out-of-unlikelytext-section.patch
mm-slab-noinline-__ac_put_obj.patch
mm-slab-factor-out-unlikely-part-of-cache_free_alien.patch
slub-disable-tracing-and-failslab-for-merged-slabs.patch
topology-add-support-for-node_to_mem_node-to-determine-the-fallback-node.patch
slub-fallback-to-node_to_mem_node-node-if-allocating-on-memoryless-node.patch
partial-revert-of-81c98869faa5-kthread-ensure-locality-of-task_struct-allocations.patch
slab-fix-for_each_kmem_cache_node.patch
mm-slab_common-commonize-slab-merge-logic.patch
mm-slab_common-commonize-slab-merge-logic-fix.patch
mm-slab-support-slab-merge.patch
mm-slab-use-percpu-allocator-for-cpu-cache.patch
memory-hotplug-add-sysfs-zones_online_to-attribute.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-4.patch
mm-page_alloc-determine-migratetype-only-once.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-reduce-zone-checking-frequency-in-the-migration-scanner.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
mm-compaction-periodically-drop-lock-and-restore-irqs-in-scanners.patch
mm-compaction-skip-rechecks-when-lock-was-already-held.patch
mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch
mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
mm-rename-allocflags_to_migratetype-for-clarity.patch
mm-compaction-pass-gfp-mask-to-compact_control.patch
mempolicy-change-alloc_pages_vma-to-use-mpol_cond_put.patch
mempolicy-change-get_task_policy-to-return-default_policy-rather-than-null.patch
mempolicy-sanitize-the-usage-of-get_task_policy.patch
mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it.patch
mempolicy-introduce-__get_vma_policy-export-get_task_policy.patch
mempolicy-fix-show_numa_map-vs-exec-do_set_mempolicy-race.patch
mempolicy-kill-do_set_mempolicy-down_writemm-mmap_sem.patch
mempolicy-unexport-get_vma_policy-and-remove-its-task-arg.patch
mm-use-__seq_open_private-instead-of-seq_open.patch
mm-page_alloc-avoid-wakeup-kswapd-on-the-unintended-node.patch
mm-clean-up-zone-flags.patch
mm-compaction-fix-warning-of-flags-may-be-used-uninitialized.patch
mm-page_alloc-make-paranoid-check-in-move_freepages-a-vm_bug_on.patch
mm-page_alloc-default-node-ordering-on-64-bit-numa-zone-ordering-on-32-bit-v2.patch
memcg-move-memcg_allocfree_cache_params-to-slab_commonc.patch
memcg-dont-call-memcg_update_all_caches-if-new-cache-id-fits.patch
memcg-move-memcg_update_cache_size-to-slab_commonc.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

