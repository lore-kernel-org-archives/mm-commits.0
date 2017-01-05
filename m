From: akpm@linux-foundation.org
Subject: +
 userfaultfd-shmem-lock-the-page-before-adding-it-to-pagecache.patch added
 to -mm tree
Date: Wed, 04 Jan 2017 16:54:32 -0800
Message-ID: <586d9948.2qmMqdHdqa+Xy34T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36246 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937520AbdAEAya (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 19:54:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: shmem: lock the page before adding it to pagecache
has been added to the -mm tree.  Its filename is
     userfaultfd-shmem-lock-the-page-before-adding-it-to-pagecache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-shmem-lock-the-page-before-adding-it-to-pagecache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-shmem-lock-the-page-before-adding-it-to-pagecache.patch

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
Subject: userfaultfd: shmem: lock the page before adding it to pagecache

A VM_BUG_ON triggered on the shmem selftest.

Link: http://lkml.kernel.org/r/20161216144821.5183-36-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/shmem.c~userfaultfd-shmem-lock-the-page-before-adding-it-to-pagecache mm/shmem.c
--- a/mm/shmem.c~userfaultfd-shmem-lock-the-page-before-adding-it-to-pagecache
+++ a/mm/shmem.c
@@ -2238,6 +2238,10 @@ int shmem_mcopy_atomic_pte(struct mm_str
 		*pagep = NULL;
 	}
 
+	VM_BUG_ON(PageLocked(page) || PageSwapBacked(page));
+	__SetPageLocked(page);
+	__SetPageSwapBacked(page);
+
 	ret = mem_cgroup_try_charge(page, dst_mm, gfp, &memcg, false);
 	if (ret)
 		goto out_release;
@@ -2287,6 +2291,7 @@ out_release_uncharge_unlock:
 out_release_uncharge:
 	mem_cgroup_cancel_charge(page, memcg, false);
 out_release:
+	unlock_page(page);
 	put_page(page);
 out_dec_used_blocks:
 	if (sbinfo->max_blocks)
_

Patches currently in -mm which might be from aarcange@redhat.com are

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
userfaultfd-shmem-avoid-leaking-blocks-and-used-blocks-in-uffdio_copy.patch
userfaultfd-hugetlbfs-uffd_feature_missing_shmem.patch
userfaultfd-selftest-test-uffdio_zeropage-on-all-memory-types.patch
mm-mprotect-use-pmd_trans_unstable-instead-of-taking-the-pmd_lock.patch

