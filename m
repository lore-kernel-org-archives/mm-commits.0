From: akpm@linux-foundation.org
Subject: +
 userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix.patch added to -mm tree
Date: Tue, 07 Feb 2017 13:40:54 -0800
Message-ID: <589a3ee6.uiQy+tRG1GOKRkC/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57122 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932472AbdBGVkz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Feb 2017 16:40:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: mcopy_atomic: update cases returning -ENOENT
has been added to the -mm tree.  Its filename is
     userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: mcopy_atomic: update cases returning -ENOENT

As Andrea commented in [1], if the VMA covering the address was unmapped,
we may end up with a VMA a way above the faulting address. In this case we
would like to return -ENOENT to allow uffd monitor detection of VMA
removal.

[1] http://www.spinics.net/lists/linux-mm/msg121267.html

Link: http://lkml.kernel.org/r/20170207150249.GA6709@rapoport-lnx
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN mm/userfaultfd.c~userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix mm/userfaultfd.c
--- a/mm/userfaultfd.c~userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix
+++ a/mm/userfaultfd.c
@@ -206,6 +206,10 @@ retry:
 		if (!dst_vma->vm_userfaultfd_ctx.ctx)
 			goto out_unlock;
 
+		if (dst_start < dst_vma->vm_start ||
+		    dst_start + len > dst_vma->vm_end)
+			goto out_unlock;
+
 		err = -EINVAL;
 		if (vma_hpagesize != vma_kernel_pagesize(dst_vma))
 			goto out_unlock;
@@ -216,9 +220,6 @@ retry:
 		 */
 		if (dst_vma->vm_flags & VM_SHARED)
 			goto out_unlock;
-		if (dst_start < dst_vma->vm_start ||
-		    dst_start + len > dst_vma->vm_end)
-			goto out_unlock;
 	}
 
 	if (WARN_ON(dst_addr & (vma_hpagesize - 1) ||
@@ -385,13 +386,14 @@ retry:
 	if (!dst_vma->vm_userfaultfd_ctx.ctx)
 		goto out_unlock;
 
-	err = -EINVAL;
-	if (!vma_is_shmem(dst_vma) && dst_vma->vm_flags & VM_SHARED)
-		goto out_unlock;
 	if (dst_start < dst_vma->vm_start ||
 	    dst_start + len > dst_vma->vm_end)
 		goto out_unlock;
 
+	err = -EINVAL;
+	if (!vma_is_shmem(dst_vma) && dst_vma->vm_flags & VM_SHARED)
+		goto out_unlock;
+
 	/*
 	 * If this is a HUGETLB vma, pass off to appropriate routine
 	 */
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are

userfaultfd-non-cooperative-dup_userfaultfd-use-mm_count-instead-of-mm_users.patch
userfaultfd-introduce-vma_can_userfault.patch
userfaultfd-shmem-add-shmem_mcopy_atomic_pte-for-userfaultfd-support.patch
userfaultfd-shmem-introduce-vma_is_shmem.patch
userfaultfd-shmem-use-shmem_mcopy_atomic_pte-for-shared-memory.patch
userfaultfd-shmem-add-userfaultfd-hook-for-shared-memory-faults.patch
userfaultfd-shmem-allow-registration-of-shared-memory-ranges.patch
userfaultfd-shmem-add-userfaultfd_shmem-test.patch
userfaultfd-non-cooperative-selftest-introduce-userfaultfd_open.patch
userfaultfd-non-cooperative-selftest-add-ufd-parameter-to-copy_page.patch
userfaultfd-non-cooperative-selftest-add-test-for-fork-madvdontneed-and-remap-events.patch
userfaultfd-non-cooperative-rename-event_madvdontneed-to-event_remove.patch
userfaultfd-non-cooperative-add-madvise-event-for-madv_remove-request.patch
userfaultfd-non-cooperative-selftest-enable-remove-event-test-for-shmem.patch
mm-call-vm_munmap-in-munmap-syscall-instead-of-using-open-coded-version.patch
userfaultfd-non-cooperative-add-event-for-memory-unmaps.patch
userfaultfd-non-cooperative-add-event-for-exit-notification.patch
userfaultfd-non-cooperative-add-event-for-exit-notification-fix.patch
userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found.patch
userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix.patch
userfaultfd_copy-return-enospc-in-case-mm-has-gone.patch

