From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-slab_common-commonize-slab-merge-logic-fix.patch removed from -mm tree
Date: Thu, 09 Oct 2014 13:31:27 -0700
Message-ID: <5436f09f.11+pn1ljxN+PX106%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35425 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaJIUb2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:31:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rdunlap@infradead.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab_common: fix build failure if CONFIG_SLUB
has been removed from the -mm tree.  Its filename was
     mm-slab_common-commonize-slab-merge-logic-fix.patch

This patch was dropped because it was folded into mm-slab_common-commonize-slab-merge-logic.patch

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab_common: fix build failure if CONFIG_SLUB

Commit 'mm/slab_common: commonize slab merge logic' introduces following
build failure if CONFIG_SLUB.

mm/slab_common.c:59:1: error: redefinition of `__setup_str_setup_slab_nomerge'
mm/slab_common.c:56:1: note: previous definition of `__setup_str_setup_slab_nomerge' was here
mm/slab_common.c:59:1: error: redefinition of `__setup_setup_slab_nomerge'
mm/slab_common.c:56:1: note: previous definition of `__setup_setup_slab_nomerge' was here
make[1]: *** [mm/slab_common.o] Error 1
make: *** [mm/slab_common.o] Error 2

It is caused by using one function for two kernel parameter,
slab_nomerge and slub_nomerg. In expanding
__setup(parameter name, function name), function name is used for unique
id so that using one function for two kernel parameter makes redefinition
error. To provide unique id and overcome this issue, this patch uses
__setup_param() rather than __setup() for slub_nomerge kernel parameter.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab_common.c~mm-slab_common-commonize-slab-merge-logic-fix mm/slab_common.c
--- a/mm/slab_common.c~mm-slab_common-commonize-slab-merge-logic-fix
+++ a/mm/slab_common.c
@@ -53,7 +53,7 @@ static int __init setup_slab_nomerge(cha
 }
 
 #ifdef CONFIG_SLUB
-__setup("slub_nomerge", setup_slab_nomerge);
+__setup_param("slub_nomerge", slub_nomerge, setup_slab_nomerge, 0);
 #endif
 
 __setup("slab_nomerge", setup_slab_nomerge);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slab_commonc-suppress-warning.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header.patch
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
mm-slab-support-slab-merge.patch
mm-slab-support-slab-merge-fix.patch
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
cma-document-cma=0.patch
zsmalloc-move-pages_allocated-to-zs_pool.patch
zsmalloc-change-return-value-unit-of-zs_get_total_size_bytes.patch
zram-zram-memory-size-limitation.patch
zram-report-maximum-used-memory.patch

