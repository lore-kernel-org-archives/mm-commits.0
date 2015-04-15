From: akpm@linux-foundation.org
Subject: [merged] sh-dwarf-use-mempool_create_slab_pool.patch removed from -mm tree
Date: Wed, 15 Apr 2015 12:07:48 -0700
Message-ID: <552eb704.BbtHSYG/MU2IwyD+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47786 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314AbbDOTHs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:07:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/sh/kernel/dwarf.c: use mempool_create_slab_pool()
has been removed from the -mm tree.  Its filename was
     sh-dwarf-use-mempool_create_slab_pool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: arch/sh/kernel/dwarf.c: use mempool_create_slab_pool()

Mempools created for slab caches should use mempool_create_slab_pool().

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/dwarf.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN arch/sh/kernel/dwarf.c~sh-dwarf-use-mempool_create_slab_pool arch/sh/kernel/dwarf.c
--- a/arch/sh/kernel/dwarf.c~sh-dwarf-use-mempool_create_slab_pool
+++ a/arch/sh/kernel/dwarf.c
@@ -1180,17 +1180,13 @@ static int __init dwarf_unwinder_init(vo
 			sizeof(struct dwarf_reg), 0,
 			SLAB_PANIC | SLAB_HWCACHE_ALIGN | SLAB_NOTRACK, NULL);
 
-	dwarf_frame_pool = mempool_create(DWARF_FRAME_MIN_REQ,
-					  mempool_alloc_slab,
-					  mempool_free_slab,
-					  dwarf_frame_cachep);
+	dwarf_frame_pool = mempool_create_slab_pool(DWARF_FRAME_MIN_REQ,
+						    dwarf_frame_cachep);
 	if (!dwarf_frame_pool)
 		goto out;
 
-	dwarf_reg_pool = mempool_create(DWARF_REG_MIN_REQ,
-					 mempool_alloc_slab,
-					 mempool_free_slab,
-					 dwarf_reg_cachep);
+	dwarf_reg_pool = mempool_create_slab_pool(DWARF_REG_MIN_REQ,
+						  dwarf_reg_cachep);
 	if (!dwarf_reg_pool)
 		goto out;
 
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

