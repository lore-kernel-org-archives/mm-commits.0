From: akpm@linux-foundation.org
Subject: +
 userfaultfd-non-cooperative-wake-userfaults-after-uffdio_unregister.patch
 added to -mm tree
Date: Wed, 04 Jan 2017 16:53:50 -0800
Message-ID: <586d991e.tBk89sGo9jkDvseK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36186 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933125AbdAEAyV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 19:54:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: non-cooperative: wake userfaults after UFFDIO_UNREGISTER
has been added to the -mm tree.  Its filename is
     userfaultfd-non-cooperative-wake-userfaults-after-uffdio_unregister.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-non-cooperative-wake-userfaults-after-uffdio_unregister.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-non-cooperative-wake-userfaults-after-uffdio_unregister.patch

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
Subject: userfaultfd: non-cooperative: wake userfaults after UFFDIO_UNREGISTER

Userfaults may still happen after the userfaultfd monitor thread received
a UFFD_EVENT_MADVDONTNEED until UFFDIO_UNREGISTER is run.

Wake any pending userfault within UFFDIO_UNREGISTER protected by the
mmap_sem for writing, so they will not be reported to userland leading to
UFFDIO_COPY returning -EINVAL (as the range was already unregistered) and
they will not hang permanently either.

Link: http://lkml.kernel.org/r/20161216144821.5183-16-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN fs/userfaultfd.c~userfaultfd-non-cooperative-wake-userfaults-after-uffdio_unregister fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-non-cooperative-wake-userfaults-after-uffdio_unregister
+++ a/fs/userfaultfd.c
@@ -1269,6 +1269,19 @@ static int userfaultfd_unregister(struct
 			start = vma->vm_start;
 		vma_end = min(end, vma->vm_end);
 
+		if (userfaultfd_missing(vma)) {
+			/*
+			 * Wake any concurrent pending userfault while
+			 * we unregister, so they will not hang
+			 * permanently and it avoids userland to call
+			 * UFFDIO_WAKE explicitly.
+			 */
+			struct userfaultfd_wake_range range;
+			range.start = start;
+			range.len = vma_end - start;
+			wake_userfault(vma->vm_userfaultfd_ctx.ctx, &range);
+		}
+
 		new_flags = vma->vm_flags & ~(VM_UFFD_MISSING | VM_UFFD_WP);
 		prev = vma_merge(mm, prev, start, vma_end, new_flags,
 				 vma->anon_vma, vma->vm_file, vma->vm_pgoff,
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

