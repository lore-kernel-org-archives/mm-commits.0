From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch
 added to -mm tree
Date: Wed, 22 Jul 2015 15:07:13 -0700
Message-ID: <55b01411.E8aR6HdIHrHV7hz0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbbGVWHO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jul 2015 18:07:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix
has been added to the -mm tree.  Its filename is
     mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix

fix typo in comment, use more cols

Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix
+++ a/mm/hugetlb.c
@@ -339,15 +339,13 @@ out_locked:
  * so that the subsequent region_add call will have all the
  * regions it needs and will not fail.
  *
- * Upon entry, region_chg will also examine the cache of
- * region descriptors associated with the map.  If there
- * not enough descriptors cached, one will be allocated
- * for the in progress add operation.
+ * Upon entry, region_chg will also examine the cache of region descriptors
+ * associated with the map.  If there are not enough descriptors cached, one
+ * will be allocated for the in progress add operation.
  *
- * Returns the number of huge pages that need to be added
- * to the existing reservation map for the range [f, t).
- * This number is greater or equal to zero.  -ENOMEM is
- * returned if a new file_region structure or cache entry
+ * Returns the number of huge pages that need to be added to the existing
+ * reservation map for the range [f, t).  This number is greater or equal to
+ * zero.  -ENOMEM is returned if a new file_region structure or cache entry
  * is needed and can not be allocated.
  */
 static long region_chg(struct resv_map *resv, long f, long t)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
ocfs2-sysfile-interfaces-for-online-file-check-fix.patch
mm.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
mm-mlock-refactor-mlock-munlock-and-munlockall-code-checkpatch-fixes.patch
mm-gup-add-mm_lock_present-checkpatch-fixes.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4-checkpatch-fixes.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault-v4-fix.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
genalloc-add-support-of-multiple-gen_pools-per-device-fix.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
dax-revert-userfaultfd-change.patch
thp-prepare-for-dax-huge-pages-fix.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.patch
pagemap-update-documentation-fix.patch
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

