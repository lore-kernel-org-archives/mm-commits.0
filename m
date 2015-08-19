From: akpm@linux-foundation.org
Subject: + mm-fix-potential-data-race-in-sys_swapon.patch added to -mm
 tree
Date: Wed, 19 Aug 2015 14:52:09 -0700
Message-ID: <55d4fa89.2MjBpV+rfmaakdQS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44849 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbbHSVwK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Aug 2015 17:52:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, andreyknvl@google.com, cesarb@cesarb.net, dvyukov@google.com, glider@google.com, hannes@cmpxchg.org, jason.low2@hp.com, kcc@google.com, mhocko@suse.cz, stable@vger.kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix potential data race in SyS_swapon
has been added to the -mm tree.  Its filename is
     mm-fix-potential-data-race-in-sys_swapon.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-potential-data-race-in-sys_swapon.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-potential-data-race-in-sys_swapon.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: fix potential data race in SyS_swapon

While running KernelThreadSanitizer (ktsan) on upstream kernel with
trinity, we got a few reports from SyS_swapon, here is one of them:

Read of size 8 by thread T307 (K7621):
 [<     inlined    >] SyS_swapon+0x3c0/0x1850 SYSC_swapon mm/swapfile.c:2395
 [<ffffffff812242c0>] SyS_swapon+0x3c0/0x1850 mm/swapfile.c:2345
 [<ffffffff81e97c8a>] ia32_do_call+0x1b/0x25

Looks like the swap_lock should be taken when iterating through the
swap_info array on lines 2392 - 2401: q->swap_file may be reset to NULL by
another thread before it is dereferenced for f_mapping.

But why is that iteration needed at all?  Doesn't the claim_swapfile()
which follows do all that is needed to check for a duplicate entry -
FMODE_EXCL on a bdev, testing IS_SWAPFILE under i_mutex on a regfile?

Well, not quite: bd_may_claim() allows the same "holder" to claim the bdev
again, so we do need to use a different holder than "sys_swapon"; and we
should not replace appropriate -EBUSY by inappropriate -EINVAL.

Index i was reused in a cpu loop further down: renamed cpu there.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Jason Low <jason.low2@hp.com>
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kostya Serebryany <kcc@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff -puN mm/swapfile.c~mm-fix-potential-data-race-in-sys_swapon mm/swapfile.c
--- a/mm/swapfile.c~mm-fix-potential-data-race-in-sys_swapon
+++ a/mm/swapfile.c
@@ -2185,11 +2185,10 @@ static int claim_swapfile(struct swap_in
 	if (S_ISBLK(inode->i_mode)) {
 		p->bdev = bdgrab(I_BDEV(inode));
 		error = blkdev_get(p->bdev,
-				   FMODE_READ | FMODE_WRITE | FMODE_EXCL,
-				   sys_swapon);
+				   FMODE_READ | FMODE_WRITE | FMODE_EXCL, p);
 		if (error < 0) {
 			p->bdev = NULL;
-			return -EINVAL;
+			return error;
 		}
 		p->old_block_size = block_size(p->bdev);
 		error = set_blocksize(p->bdev, PAGE_SIZE);
@@ -2390,7 +2389,6 @@ SYSCALL_DEFINE2(swapon, const char __use
 	struct filename *name;
 	struct file *swap_file = NULL;
 	struct address_space *mapping;
-	int i;
 	int prio;
 	int error;
 	union swap_header *swap_header;
@@ -2430,19 +2428,8 @@ SYSCALL_DEFINE2(swapon, const char __use
 
 	p->swap_file = swap_file;
 	mapping = swap_file->f_mapping;
-
-	for (i = 0; i < nr_swapfiles; i++) {
-		struct swap_info_struct *q = swap_info[i];
-
-		if (q == p || !q->swap_file)
-			continue;
-		if (mapping == q->swap_file->f_mapping) {
-			error = -EBUSY;
-			goto bad_swap;
-		}
-	}
-
 	inode = mapping->host;
+
 	/* If S_ISREG(inode->i_mode) will do mutex_lock(&inode->i_mutex); */
 	error = claim_swapfile(p, inode);
 	if (unlikely(error))
@@ -2475,6 +2462,8 @@ SYSCALL_DEFINE2(swapon, const char __use
 		goto bad_swap;
 	}
 	if (p->bdev && blk_queue_nonrot(bdev_get_queue(p->bdev))) {
+		int cpu;
+
 		p->flags |= SWP_SOLIDSTATE;
 		/*
 		 * select a random position to start with to help wear leveling
@@ -2493,9 +2482,9 @@ SYSCALL_DEFINE2(swapon, const char __use
 			error = -ENOMEM;
 			goto bad_swap;
 		}
-		for_each_possible_cpu(i) {
+		for_each_possible_cpu(cpu) {
 			struct percpu_cluster *cluster;
-			cluster = per_cpu_ptr(p->percpu_cluster, i);
+			cluster = per_cpu_ptr(p->percpu_cluster, cpu);
 			cluster_set_null(&cluster->index);
 		}
 	}
_

Patches currently in -mm which might be from hughd@google.com are

userfaultfd-linux-documentation-vm-userfaultfdtxt.patch
userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch
userfaultfd-uapi.patch
userfaultfd-linux-userfaultfd_kh.patch
userfaultfd-add-vm_userfaultfd_ctx-to-the-vm_area_struct.patch
userfaultfd-add-vm_uffd_missing-and-vm_uffd_wp.patch
userfaultfd-call-handle_userfault-for-userfaultfd_missing-faults.patch
userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx.patch
userfaultfd-prevent-khugepaged-to-merge-if-userfaultfd-is-armed.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization.patch
userfaultfd-rename-uffd_apibits-into-features.patch
userfaultfd-rename-uffd_apibits-into-features-fixup.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch
userfaultfd-wake-pending-userfaults.patch
userfaultfd-optimize-read-and-poll-to-be-o1.patch
userfaultfd-allocate-the-userfaultfd_ctx-cacheline-aligned.patch
userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read.patch
userfaultfd-buildsystem-activation.patch
userfaultfd-activate-syscall.patch
userfaultfd-uffdio_copyuffdio_zeropage-uapi.patch
userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch
userfaultfd-uffdio_copy-and-uffdio_zeropage.patch
mm-fix-status-code-move_pages-returns-for-zero-page.patch
mremap-dont-leak-new_vma-if-f_op-mremap-fails.patch
mm-move-mremap-from-file_operations-to-vm_operations_struct.patch
mremap-dont-do-mm_populatenew_addr-on-failure.patch
mremap-dont-do-uneccesary-checks-if-new_len-==-old_len.patch
mremap-simplify-the-overlap-check-in-mremap_to.patch
mm-introduce-vma_is_anonymousvma-helper.patch
mmap-fix-the-usage-of-vm_pgoff-in-special_mapping-paths.patch
mremap-fix-the-wrong-vma-vm_file-check-in-copy_vma.patch
mm-show-proportional-swap-share-of-the-mapping.patch
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add.patch
mm-hugetlb-add-region_del-to-delete-a-specific-range-of-entries.patch
mm-hugetlb-expose-hugetlb-fault-mutex-for-use-by-fallocate.patch
hugetlbfs-hugetlb_vmtruncate_list-needs-to-take-a-range-to-delete.patch
hugetlbfs-truncate_hugepages-takes-a-range-of-pages.patch
mm-hugetlb-vma_has_reserves-needs-to-handle-fallocate-hole-punch.patch
mm-hugetlb-alloc_huge_page-handle-areas-hole-punched-by-fallocate.patch
hugetlbfs-new-huge_add_to_page_cache-helper-routine.patch
hugetlbfs-add-hugetlbfs_fallocate.patch
mm-madvise-allow-remove-operation-for-hugetlbfs.patch
shmem-recalculate-file-inode-when-fstat.patch
mm-fix-potential-data-race-in-sys_swapon.patch
mm-swap-zswap-maybe_preload-refactoring.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch

