From: akpm@linux-foundation.org
Subject: + mm-writeback-prevent-race-when-calculating-dirty-limits.patch
 added to -mm tree
Date: Thu, 17 Jul 2014 15:38:00 -0700
Message-ID: <53c85048./kxUj6F2YNdCg6nb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:46425 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbaGQWiC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jul 2014 18:38:02 -0400
Received: by mail-ie0-f201.google.com with SMTP id tr6so1204852ieb.4
        for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2014 15:38:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hannes@cmpxchg.org, mhocko@suse.cz, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, writeback: prevent race when calculating dirty limits
has been added to the -mm tree.  Its filename is
     mm-writeback-prevent-race-when-calculating-dirty-limits.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-writeback-prevent-race-when-calculating-dirty-limits.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-writeback-prevent-race-when-calculating-dirty-limits.patch

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
Subject: mm, writeback: prevent race when calculating dirty limits

Setting vm_dirty_bytes and dirty_background_bytes is not protected by any
serialization.

Therefore, it's possible for either variable to change value after the
test in global_dirty_limits() to determine whether available_memory needs
to be initialized or not.

Always ensure that available_memory is properly initialized.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/page-writeback.c~mm-writeback-prevent-race-when-calculating-dirty-limits mm/page-writeback.c
--- a/mm/page-writeback.c~mm-writeback-prevent-race-when-calculating-dirty-limits
+++ a/mm/page-writeback.c
@@ -261,14 +261,11 @@ static unsigned long global_dirtyable_me
  */
 void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty)
 {
+	const unsigned long available_memory = global_dirtyable_memory();
 	unsigned long background;
 	unsigned long dirty;
-	unsigned long uninitialized_var(available_memory);
 	struct task_struct *tsk;
 
-	if (!vm_dirty_bytes || !dirty_background_bytes)
-		available_memory = global_dirtyable_memory();
-
 	if (vm_dirty_bytes)
 		dirty = DIV_ROUND_UP(vm_dirty_bytes, PAGE_SIZE);
 	else
_

Patches currently in -mm which might be from rientjes@google.com are

revert-fs-seq_file-fallback-to-vmalloc-allocation.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function-v2.patch
mm-slabc-add-__init-to-init_lock_keys.patch
slab-common-add-functions-for-kmem_cache_node-access.patch
slab-common-add-functions-for-kmem_cache_node-access-fix.patch
slub-use-new-node-functions.patch
slub-use-new-node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
mm-slub-mark-resiliency_test-as-init-text.patch
mm-slub-slub_debug=n-use-the-same-alloc-free-hooks-as-for-slub_debug=y.patch
slab-add-unlikely-macro-to-help-compiler.patch
slab-move-up-code-to-get-kmem_cache_node-in-free_block.patch
slab-defer-slab_destroy-in-free_block.patch
slab-defer-slab_destroy-in-free_block-v4.patch
slab-factor-out-initialization-of-arracy-cache.patch
slab-introduce-alien_cache.patch
slab-use-the-lock-on-alien_cache-instead-of-the-lock-on-array_cache.patch
slab-destroy-a-slab-without-holding-any-alien-cache-lock.patch
slab-remove-a-useless-lockdep-annotation.patch
slab-remove-bad_alien_magic.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
slub-reduce-duplicate-creation-on-the-first-object.patch
mm-move-slab-related-stuff-from-utilc-to-slab_commonc.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
mm-page_alloc-simplify-drain_zone_pages-by-using-min.patch
mm-mem-hotplug-replace-simple_strtoull-with-kstrtoull.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
mm-vmalloc-constify-allocation-mask.patch
mmhugetlb-make-unmap_ref_private-return-void.patch
mmhugetlb-simplify-error-handling-in-hugetlb_cow.patch
mm-hugetlb-generalize-writes-to-nr_hugepages.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch
mm-make-copy_pte_range-static-again.patch
mm-thp-only-collapse-hugepages-to-nodes-with-affinity-for-zone_reclaim_mode.patch
mm-writeback-prevent-race-when-calculating-dirty-limits.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
lib-add-size-unit-t-p-e-to-memparse.patch
mm-utilc-add-kstrimdup.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
linux-next.patch

