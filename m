From: akpm@linux-foundation.org
Subject: +
 mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory.patch added
 to -mm tree
Date: Fri, 27 Mar 2015 15:05:24 -0700
Message-ID: <5515d424.Xh5JevqkYHmRvgus%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbbC0WFZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Mar 2015 18:05:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, aarcange@redhat.com, corbet@lwn.net, davidel@xmailserver.org, emunson@akamai.com, hughd@google.com, joern@logfs.org, lcapitulino@redhat.com, mpe@ellerman.id.au, shuahkh@osg.samsung.com, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, doc: cleanup and clarify munmap behavior for hugetlb memory
has been added to the -mm tree.  Its filename is
     mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory.patch

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
Subject: mm, doc: cleanup and clarify munmap behavior for hugetlb memory

munmap(2) of hugetlb memory requires a length that is hugepage aligned,
otherwise it may fail.  Add this to the documentation.

This also cleans up the documentation and separates it into logical units:
one part refers to MAP_HUGETLB and another part refers to requirements for
shared memory segments.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Joern Engel <joern@logfs.org>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Eric B Munson <emunson@akamai.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/hugetlbpage.txt |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff -puN Documentation/vm/hugetlbpage.txt~mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory Documentation/vm/hugetlbpage.txt
--- a/Documentation/vm/hugetlbpage.txt~mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory
+++ a/Documentation/vm/hugetlbpage.txt
@@ -302,15 +302,20 @@ file systems, write system calls are not
 Regular chown, chgrp, and chmod commands (with right permissions) could be
 used to change the file attributes on hugetlbfs.
 
-Also, it is important to note that no such mount command is required if the
+Also, it is important to note that no such mount command is required if
 applications are going to use only shmat/shmget system calls or mmap with
-MAP_HUGETLB.  Users who wish to use hugetlb page via shared memory segment
-should be a member of a supplementary group and system admin needs to
-configure that gid into /proc/sys/vm/hugetlb_shm_group.  It is possible for
-same or different applications to use any combination of mmaps and shm*
-calls, though the mount of filesystem will be required for using mmap calls
-without MAP_HUGETLB.  For an example of how to use mmap with MAP_HUGETLB see
-map_hugetlb.c.
+MAP_HUGETLB.  For an example of how to use mmap with MAP_HUGETLB see map_hugetlb
+below.
+
+Users who wish to use hugetlb memory via shared memory segment should be a
+member of a supplementary group and system admin needs to configure that gid
+into /proc/sys/vm/hugetlb_shm_group.  It is possible for same or different
+applications to use any combination of mmaps and shm* calls, though the mount of
+filesystem will be required for using mmap calls without MAP_HUGETLB.
+
+When using munmap(2) to unmap hugetlb memory, the length specified must be
+hugepage aligned, otherwise it will fail with errno set to EINVAL.
+
 
 Examples
 ========
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
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
thp-handle-errors-in-hugepage_init-properly.patch
thp-do-not-adjust-zone-water-marks-if-khugepaged-is-not-started.patch
mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory.patch
mm-selftests-test-return-value-of-munmap-for-map_hugetlb-memory.patch
hung_task-change-hung_taskc-to-use-for_each_process_thread.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

