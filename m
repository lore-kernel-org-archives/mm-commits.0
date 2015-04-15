From: akpm@linux-foundation.org
Subject: [merged] kernel-cpuset-remove-exception-for-__gfp_thisnode.patch
 removed from -mm tree
Date: Wed, 15 Apr 2015 12:10:59 -0700
Message-ID: <552eb7c3.daZTMY6qXDvb+qjk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48298 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933527AbbDOTLA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:11:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, cl@linux.com, gthelen@google.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, jrajahalme@nicira.com, lizefan@huawei.com, mgorman@suse.de, penberg@kernel.org, pshelar@nicira.com, tj@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel, cpuset: remove exception for __GFP_THISNODE
has been removed from the -mm tree.  Its filename was
     kernel-cpuset-remove-exception-for-__gfp_thisnode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: kernel, cpuset: remove exception for __GFP_THISNODE

Nothing calls __cpuset_node_allowed() with __GFP_THISNODE set anymore, so
remove the obscure comment about it and its special-case exception.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pravin Shelar <pshelar@nicira.com>
Cc: Jarno Rajahalme <jrajahalme@nicira.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff -puN kernel/cpuset.c~kernel-cpuset-remove-exception-for-__gfp_thisnode kernel/cpuset.c
--- a/kernel/cpuset.c~kernel-cpuset-remove-exception-for-__gfp_thisnode
+++ a/kernel/cpuset.c
@@ -2453,20 +2453,12 @@ static struct cpuset *nearest_hardwall_a
  * @node: is this an allowed node?
  * @gfp_mask: memory allocation flags
  *
- * If we're in interrupt, yes, we can always allocate.  If __GFP_THISNODE is
- * set, yes, we can always allocate.  If node is in our task's mems_allowed,
- * yes.  If it's not a __GFP_HARDWALL request and this node is in the nearest
- * hardwalled cpuset ancestor to this task's cpuset, yes.  If the task has been
- * OOM killed and has access to memory reserves as specified by the TIF_MEMDIE
- * flag, yes.
+ * If we're in interrupt, yes, we can always allocate.  If @node is set in
+ * current's mems_allowed, yes.  If it's not a __GFP_HARDWALL request and this
+ * node is set in the nearest hardwalled cpuset ancestor to current's cpuset,
+ * yes.  If current has access to memory reserves due to TIF_MEMDIE, yes.
  * Otherwise, no.
  *
- * The __GFP_THISNODE placement logic is really handled elsewhere,
- * by forcibly using a zonelist starting at a specified node, and by
- * (in get_page_from_freelist()) refusing to consider the zones for
- * any node on the zonelist except the first.  By the time any such
- * calls get to this routine, we should just shut up and say 'yes'.
- *
  * GFP_USER allocations are marked with the __GFP_HARDWALL bit,
  * and do not allow allocations outside the current tasks cpuset
  * unless the task has been OOM killed as is marked TIF_MEMDIE.
@@ -2502,7 +2494,7 @@ int __cpuset_node_allowed(int node, gfp_
 	int allowed;			/* is allocation in zone z allowed? */
 	unsigned long flags;
 
-	if (in_interrupt() || (gfp_mask & __GFP_THISNODE))
+	if (in_interrupt())
 		return 1;
 	if (node_isset(node, current->mems_allowed))
 		return 1;
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-mempool-do-not-allow-atomic-resizing.patch
mm-hugetlb-abort-__get_user_pages-if-current-has-been-oom-killed.patch
cxgb4-drop-__gfp_nofail-allocation.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
slub-bulk-allocation-from-per-cpu-partial-pages.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-refactor-zone_movable_is_highmem.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
allow-compaction-of-unevictable-pages.patch
document-interaction-between-compaction-and-the-unevictable-lru.patch
document-interaction-between-compaction-and-the-unevictable-lru-fix.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix-fix.patch
mm-compaction-reset-compaction-scanner-positions.patch
hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure.patch
hugetlbfs-add-minimum-size-accounting-to-subpools.patch
hugetlbfs-accept-subpool-min_size-mount-option-and-setup-accordingly.patch
hugetlbfs-document-min_size-mount-option-and-cleanup.patch
mm-vmalloc-fix-possible-exhaustion-of-vmalloc-space-caused-by-vm_map_ram-allocator.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-vmalloc-get-rid-of-dirty-bitmap-inside-vmap_block-structure.patch
mremap-should-return-enomem-when-__vm_enough_memory-fail.patch
clean-up-goto-just-return-err_ptr.patch
fs-jfs-remove-slab-object-constructor.patch
mm-mempool-disallow-mempools-based-on-slab-caches-with-constructors.patch
mm-mempool-poison-elements-backed-by-slab-allocator.patch
mm-mempool-poison-elements-backed-by-page-allocator.patch
mm-mempool-poison-elements-backed-by-page-allocator-fix.patch
mm-mempool-poison-elements-backed-by-page-allocator-fix-fix.patch
mm-mempool-poison-elements-backed-by-page-allocator-fix-fix-fix.patch
thp-handle-errors-in-hugepage_init-properly.patch
thp-do-not-adjust-zone-water-marks-if-khugepaged-is-not-started.patch
mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory.patch
mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory-fix.patch
mm-selftests-test-return-value-of-munmap-for-map_hugetlb-memory.patch
mm-dont-call-__page_cache_release-for-hugetlb.patch
mm-hugetlb-introduce-pagehugeactive-flag.patch
mm-hugetlb-introduce-pagehugeactive-flag-fix.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag-fix.patch
thp-cleanup-khugepaged-startup.patch
mm-mempool-kasan-poison-mempool-elements.patch
hung_task-change-hung_taskc-to-use-for_each_process_thread.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

