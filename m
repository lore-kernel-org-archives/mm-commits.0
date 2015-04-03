From: akpm@linux-foundation.org
Subject: +
 mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory-fix.patch
 added to -mm tree
Date: Fri, 03 Apr 2015 14:27:32 -0700
Message-ID: <551f05c4.trwCTlBIdxojjGUu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48621 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbbDCV1d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Apr 2015 17:27:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hillf.zj@alibaba-inc.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, doc: cleanup and clarify munmap behavior for hugetlb memory fix
has been added to the -mm tree.  Its filename is
     mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory-fix.patch

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
Subject: mm, doc: cleanup and clarify munmap behavior for hugetlb memory fix

Don't only specify munmap(2) behavior with respect the hugetlb memory, all
other syscalls get naturally aligned to the native page size of the
processor.  Rather, pick out munmap(2) as a specific example.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/hugetlbpage.txt |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN Documentation/vm/hugetlbpage.txt~mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory-fix Documentation/vm/hugetlbpage.txt
--- a/Documentation/vm/hugetlbpage.txt~mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory-fix
+++ a/Documentation/vm/hugetlbpage.txt
@@ -313,8 +313,11 @@ into /proc/sys/vm/hugetlb_shm_group.  It
 applications to use any combination of mmaps and shm* calls, though the mount of
 filesystem will be required for using mmap calls without MAP_HUGETLB.
 
-When using munmap(2) to unmap hugetlb memory, the length specified must be
-hugepage aligned, otherwise it will fail with errno set to EINVAL.
+Syscalls that operate on memory backed by hugetlb pages only have their lengths
+aligned to the native page size of the processor; they will normally fail with
+errno set to EINVAL or exclude hugetlb pages that extend beyond the length if
+not hugepage aligned.  For example, munmap(2) will fail if memory is backed by
+a hugetlb page and the length is smaller than the hugepage size.
 
 
 Examples
_

Patches currently in -mm which might be from rientjes@google.com are

mm-move-zone-lock-to-a-different-cache-line-than-order-0-free-page-lists.patch
mm-numa-disable-change-protection-for-vmavm_hugetlb.patch
cxgb4-drop-__gfp_nofail-allocation.patch
sh-dwarf-destroy-mempools-on-cleanup.patch
sh-dwarf-use-mempool_create_slab_pool.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
mm-slub-parse-slub_debug-o-option-in-switch-statement.patch
mm-slab-correct-config-option-in-comment.patch
slub-use-bool-function-return-values-of-true-false-not-1-0.patch
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
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
allow-compaction-of-unevictable-pages.patch
document-interaction-between-compaction-and-the-unevictable-lru.patch
document-interaction-between-compaction-and-the-unevictable-lru-fix.patch
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
hung_task-change-hung_taskc-to-use-for_each_process_thread.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

