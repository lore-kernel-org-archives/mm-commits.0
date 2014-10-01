From: akpm@linux-foundation.org
Subject: + mm-slab-use-percpu-allocator-for-cpu-cache-fix.patch added to
 -mm tree
Date: Wed, 01 Oct 2014 14:57:31 -0700
Message-ID: <542c78cb.52mN50Y7M69IlZk8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44950 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaJAV5b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 17:57:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, jmmahler@gmail.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: fix cpu on/off handling
has been added to the -mm tree.  Its filename is
     mm-slab-use-percpu-allocator-for-cpu-cache-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-use-percpu-allocator-for-cpu-cache-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-use-percpu-allocator-for-cpu-cache-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: fix cpu on/off handling

When cpu off, we flush all cpu cached objects to it's own slab. 
free_block() is used for this purpose and it's role is just to flush
objects from array_cache to proper slab.  It doesn't adjust array_cache's
internal fields so we should manually reset them to proper value.  Without
this fix, we maintain free objects duplicately, one is in cpu cache, and,
the other one is in the slab.  So system would be broken.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reported-by: Jeremiah Mahler <jmmahler@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/slab.c~mm-slab-use-percpu-allocator-for-cpu-cache-fix mm/slab.c
--- a/mm/slab.c~mm-slab-use-percpu-allocator-for-cpu-cache-fix
+++ a/mm/slab.c
@@ -1102,8 +1102,10 @@ static void cpuup_canceled(long cpu)
 
 		/* cpu is dead; no one can alloc from it. */
 		nc = per_cpu_ptr(cachep->cpu_cache, cpu);
-		if (nc)
+		if (nc) {
 			free_block(cachep, nc->entry, nc->avail, node, &list);
+			nc->avail = 0;
+		}
 
 		if (!cpumask_empty(mask)) {
 			spin_unlock_irq(&n->list_lock);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slab_commonc-suppress-warning.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header-fix.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2-fix.patch
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
mm-slab-use-percpu-allocator-for-cpu-cache-fix.patch
mm-cma-adjust-address-limit-to-avoid-hitting-low-high-memory-boundary.patch
arm-mm-dont-limit-default-cma-region-only-to-low-memory.patch
mm-page_alloc-determine-migratetype-only-once.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range-fix.patch
mm-compaction-reduce-zone-checking-frequency-in-the-migration-scanner.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch
mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
mm-rename-allocflags_to_migratetype-for-clarity.patch
mm-compaction-pass-gfp-mask-to-compact_control.patch
mm-use-__seq_open_private-instead-of-seq_open.patch
memcg-move-memcg_allocfree_cache_params-to-slab_commonc.patch
memcg-dont-call-memcg_update_all_caches-if-new-cache-id-fits.patch
memcg-move-memcg_update_cache_size-to-slab_commonc.patch
drivers-dma-coherent-add-initialization-from-device-tree.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes.patch
drivers-dma-contiguous-add-initialization-from-device-tree.patch
drivers-dma-contiguous-add-initialization-from-device-tree-checkpatch-fixes.patch
zsmalloc-move-pages_allocated-to-zs_pool.patch
zsmalloc-change-return-value-unit-of-zs_get_total_size_bytes.patch
zram-zram-memory-size-limitation.patch
zram-report-maximum-used-memory.patch
page-owners-correct-page-order-when-to-free-page.patch

