From: akpm@linux-foundation.org
Subject: +
 userfaultfd-shmem-avoid-a-lockup-resulting-from-corrupted-page-flags.patch
 added to -mm tree
Date: Tue, 17 Jan 2017 12:05:54 -0800
Message-ID: <587e7922.t7piKqRgr1dj1v+h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38276 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751030AbdAQUNa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2017 15:13:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, rppt@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: shmem: avoid a lockup resulting from corrupted page->flags
has been added to the -mm tree.  Its filename is
     userfaultfd-shmem-avoid-a-lockup-resulting-from-corrupted-page-flags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-shmem-avoid-a-lockup-resulting-from-corrupted-page-flags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-shmem-avoid-a-lockup-resulting-from-corrupted-page-flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: shmem: avoid a lockup resulting from corrupted page->flags

Use the non atomic version of __SetPageUptodate while the page is still
private and not visible to lookup operations.  Using the non atomic
version after the page is already visible to lookups is unsafe as there
would be concurrent lock_page operation modifying the page->flags while it
runs.

This solves a lockup in find_lock_entry with the userfaultfd_shmem
selftest.

userfaultfd_shm D14296   691      1 0x00000004
Call Trace:
 ? __schedule+0x311/0xb60
 schedule+0x3d/0x90
 schedule_timeout+0x228/0x420
 ? mark_held_locks+0x71/0x90
 ? ktime_get+0x134/0x170
 ? kvm_clock_read+0x25/0x30
 ? kvm_clock_get_cycles+0x9/0x10
 ? ktime_get+0xd6/0x170
 ? __delayacct_blkio_start+0x1f/0x30
 io_schedule_timeout+0xa4/0x110
 ? trace_hardirqs_on+0xd/0x10
 __lock_page+0x12d/0x170
 ? add_to_page_cache_lru+0xe0/0xe0
 find_lock_entry+0xa4/0x190
 shmem_getpage_gfp+0xb9/0xc30
 ? alloc_set_pte+0x56e/0x610
 ? radix_tree_next_chunk+0xf6/0x2d0
 shmem_fault+0x70/0x1c0
 ? filemap_map_pages+0x3bd/0x530
 __do_fault+0x21/0x150
 handle_mm_fault+0xec9/0x1490
 __do_page_fault+0x20d/0x520
 trace_do_page_fault+0x61/0x270
 do_async_page_fault+0x19/0x80
 async_page_fault+0x25/0x30

Link: http://lkml.kernel.org/r/20170116180408.12184-2-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/shmem.c~userfaultfd-shmem-avoid-a-lockup-resulting-from-corrupted-page-flags mm/shmem.c
--- a/mm/shmem.c~userfaultfd-shmem-avoid-a-lockup-resulting-from-corrupted-page-flags
+++ a/mm/shmem.c
@@ -2241,6 +2241,7 @@ int shmem_mcopy_atomic_pte(struct mm_str
 	VM_BUG_ON(PageLocked(page) || PageSwapBacked(page));
 	__SetPageLocked(page);
 	__SetPageSwapBacked(page);
+	__SetPageUptodate(page);
 
 	ret = mem_cgroup_try_charge(page, dst_mm, gfp, &memcg, false);
 	if (ret)
@@ -2265,8 +2266,6 @@ int shmem_mcopy_atomic_pte(struct mm_str
 	if (!pte_none(*dst_pte))
 		goto out_release_uncharge_unlock;
 
-	__SetPageUptodate(page);
-
 	lru_cache_add_anon(page);
 
 	spin_lock(&info->lock);
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-fix-sigbus-resulting-from-false-rwsem-wakeups.patch
userfaultfd-document-_ior-_iow.patch
userfaultfd-correct-comment-about-uffd_feature_pagefault_flag_wp.patch
userfaultfd-convert-bug-to-warn_on_once.patch
userfaultfd-use-vma_is_anonymous.patch
userfaultfd-non-cooperative-report-all-available-features-to-userland.patch
userfaultfd-non-cooperative-add-fork-event-build-warning-fix.patch
userfaultfd-non-cooperative-optimize-mremap_userfaultfd_complete.patch
userfaultfd-non-cooperative-avoid-madv_dontneed-race-condition.patch
userfaultfd-non-cooperative-wake-userfaults-after-uffdio_unregister.patch
userfaultfd-hugetlbfs-gup-support-vm_fault_retry.patch
userfaultfd-hugetlbfs-uffd_feature_missing_hugetlbfs.patch
userfaultfd-shmem-add-tlbflushh-header-for-microblaze.patch
userfaultfd-shmem-lock-the-page-before-adding-it-to-pagecache.patch
userfaultfd-shmem-avoid-a-lockup-resulting-from-corrupted-page-flags.patch
userfaultfd-shmem-avoid-leaking-blocks-and-used-blocks-in-uffdio_copy.patch
userfaultfd-hugetlbfs-uffd_feature_missing_shmem.patch
userfaultfd-selftest-test-uffdio_zeropage-on-all-memory-types.patch
mm-mprotect-use-pmd_trans_unstable-instead-of-taking-the-pmd_lock.patch

