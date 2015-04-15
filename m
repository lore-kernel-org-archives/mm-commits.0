From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory-fix.patch
 removed from -mm tree
Date: Wed, 15 Apr 2015 15:39:04 -0700
Message-ID: <552ee888.8r1VPL+dghWvUARa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51872 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756497AbbDOWjF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 18:39:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, corbet@lwn.net, hillf.zj@alibaba-inc.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, doc: cleanup and clarify munmap behavior for hugetlb memory fix
has been removed from the -mm tree.  Its filename was
     mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory-fix.patch

This patch was dropped because it was folded into mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory.patch

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, doc: cleanup and clarify munmap behavior for hugetlb memory fix

Don't only specify munmap(2) behavior with respect the hugetlb memory, all
other syscalls get naturally aligned to the native page size of the
processor.  Rather, pick out munmap(2) as a specific example.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Jonathan Corbet <corbet@lwn.net>
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

origin.patch
mm-refactor-zone_movable_is_highmem.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
allow-compaction-of-unevictable-pages.patch
document-interaction-between-compaction-and-the-unevictable-lru.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp.patch
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
thp-handle-errors-in-hugepage_init-properly.patch
thp-do-not-adjust-zone-water-marks-if-khugepaged-is-not-started.patch
mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory.patch
mm-selftests-test-return-value-of-munmap-for-map_hugetlb-memory.patch
mm-dont-call-__page_cache_release-for-hugetlb.patch
mm-hugetlb-introduce-pagehugeactive-flag.patch
mm-hugetlb-introduce-pagehugeactive-flag-fix.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag-fix.patch
thp-cleanup-khugepaged-startup.patch
mm-mempool-kasan-poison-mempool-elements.patch
hung_task-change-hung_taskc-to-use-for_each_process_thread.patch

