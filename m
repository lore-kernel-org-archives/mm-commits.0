From: akpm@linux-foundation.org
Subject: +
 mm-mempool-disallow-mempools-based-on-slab-caches-with-constructors.patch
 added to -mm tree
Date: Wed, 25 Mar 2015 14:55:37 -0700
Message-ID: <55132ed9.UXJSU17tkPg1UN9L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbbCYVzi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Mar 2015 17:55:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, catalin.marinas@arm.com, hch@lst.de, mpatocka@redhat.com, sebott@linux.vnet.ibm.com, shaggy@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, mempool: disallow mempools based on slab caches with constructors
has been added to the -mm tree.  Its filename is
     mm-mempool-disallow-mempools-based-on-slab-caches-with-constructors.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempool-disallow-mempools-based-on-slab-caches-with-constructors.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempool-disallow-mempools-based-on-slab-caches-with-constructors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, mempool: disallow mempools based on slab caches with constructors

All occurrences of mempools based on slab caches with object constructors
have been removed from the tree, so disallow creating them.

We can only dereference mem->ctor in mm/mempool.c without including
mm/slab.h in include/linux/mempool.h.  So simply note the restriction,
just like the comment restricting usage of __GFP_ZERO, and warn on kernels
with CONFIG_DEBUG_VM() if such a mempool is allocated from.

We don't want to incur this check on every element allocation, so use
VM_BUG_ON().

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Dave Kleikamp <shaggy@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempool.h |    3 ++-
 mm/mempool.c            |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN include/linux/mempool.h~mm-mempool-disallow-mempools-based-on-slab-caches-with-constructors include/linux/mempool.h
--- a/include/linux/mempool.h~mm-mempool-disallow-mempools-based-on-slab-caches-with-constructors
+++ a/include/linux/mempool.h
@@ -36,7 +36,8 @@ extern void mempool_free(void *element,
 
 /*
  * A mempool_alloc_t and mempool_free_t that get the memory from
- * a slab that is passed in through pool_data.
+ * a slab cache that is passed in through pool_data.
+ * Note: the slab cache may not have a ctor function.
  */
 void *mempool_alloc_slab(gfp_t gfp_mask, void *pool_data);
 void mempool_free_slab(void *element, void *pool_data);
diff -puN mm/mempool.c~mm-mempool-disallow-mempools-based-on-slab-caches-with-constructors mm/mempool.c
--- a/mm/mempool.c~mm-mempool-disallow-mempools-based-on-slab-caches-with-constructors
+++ a/mm/mempool.c
@@ -15,6 +15,7 @@
 #include <linux/mempool.h>
 #include <linux/blkdev.h>
 #include <linux/writeback.h>
+#include "slab.h"
 
 static void add_element(mempool_t *pool, void *element)
 {
@@ -334,6 +335,7 @@ EXPORT_SYMBOL(mempool_free);
 void *mempool_alloc_slab(gfp_t gfp_mask, void *pool_data)
 {
 	struct kmem_cache *mem = pool_data;
+	VM_BUG_ON(mem->ctor);
 	return kmem_cache_alloc(mem, gfp_mask);
 }
 EXPORT_SYMBOL(mempool_alloc_slab);
_

Patches currently in -mm which might be from rientjes@google.com are

mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention.patch
mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention-v2.patch
mm-pagewalk-prevent-positive-return-value-of-walk_page_test-from-being-passed-to-callers.patch
mm-memory-hotplog-postpone-the-reset-of-obsolete-pgdat.patch
mm-slub-fix-lockups-on-preempt-smp-kernels.patch
cxgb4-drop-__gfp_nofail-allocation.patch
sh-dwarf-destroy-mempools-on-cleanup.patch
sh-dwarf-use-mempool_create_slab_pool.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
mm-slub-parse-slub_debug-o-option-in-switch-statement.patch
mm-slab-correct-config-option-in-comment.patch
mm-rename-foll_mlock-to-foll_populate.patch
mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range.patch
mm-move-gup-posix-mlock-error-conversion-out-of-__mm_populate.patch
mm-move-mm_populate-related-code-to-mm-gupc.patch
mm-hotplug-fix-concurrent-memory-hot-add-deadlock.patch
mm-cma-change-fallback-behaviour-for-cma-freepage.patch
mm-page_alloc-factor-out-fallback-freepage-checking.patch
mm-compaction-enhance-compaction-finish-condition.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
mm-incorporate-zero-pages-into-transparent-huge-pages.patch
mm-incorporate-zero-pages-into-transparent-huge-pages-fix.patch
mm-completely-remove-dumping-per-cpu-lists-from-show_mem.patch
mm-mempolicy-migrate_to_node-should-only-migrate-to-node.patch
mm-remove-gfp_thisnode.patch
mm-thp-really-limit-transparent-hugepage-allocation-to-local-node.patch
kernel-cpuset-remove-exception-for-__gfp_thisnode.patch
mm-clarify-__gfp_nofail-deprecation-status.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
sparc-clarify-__gfp_nofail-allocation.patch
mm-mempool-do-not-allow-atomic-resizing.patch
mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch
mm-hugetlb-abort-__get_user_pages-if-current-has-been-oom-killed.patch
mm-refactor-zone_movable_is_highmem.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place-fix-2.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
allow-compaction-of-unevictable-pages.patch
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
hung_task-change-hung_taskc-to-use-for_each_process_thread.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

