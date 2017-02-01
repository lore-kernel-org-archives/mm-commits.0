From: akpm@linux-foundation.org
Subject: +
 userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found.patch
 added to -mm tree
Date: Tue, 31 Jan 2017 16:46:51 -0800
Message-ID: <58912ffb.4xgkfq3uHoKA/zhE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39954 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751064AbdBAAqw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 19:46:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: mcopy_atomic: return -ENOENT when no compatible VMA found
has been added to the -mm tree.  Its filename is
     userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found.patch

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
Subject: userfaultfd: mcopy_atomic: return -ENOENT when no compatible VMA found

The memory mapping of a process may change between #PF event and the call
to mcopy_atomic that comes to resolve the page fault.  In such case, there
will be no VMA covering the range passed to mcopy_atomic or the VMA will
not have userfaultfd context.

To allow uffd monitor to distinguish those case from other errors, let's
return -ENOENT instead of -EINVAL.

Note, that despite availability of UFFD_EVENT_UNMAP there still might be
race between the processing of UFFD_EVENT_UNMAP and outstanding
mcopy_atomic in case of non-cooperative uffd usage.

Link: http://lkml.kernel.org/r/1485542673-24387-5-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff -puN mm/userfaultfd.c~userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found mm/userfaultfd.c
--- a/mm/userfaultfd.c~userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found
+++ a/mm/userfaultfd.c
@@ -195,11 +195,18 @@ retry:
 	 * retry, dst_vma will be set to NULL and we must lookup again.
 	 */
 	if (!dst_vma) {
-		err = -EINVAL;
+		err = -ENOENT;
 		dst_vma = find_vma(dst_mm, dst_start);
 		if (!dst_vma || !is_vm_hugetlb_page(dst_vma))
 			goto out_unlock;
+		/*
+		 * Only allow __mcopy_atomic_hugetlb on userfaultfd
+		 * registered ranges.
+		 */
+		if (!dst_vma->vm_userfaultfd_ctx.ctx)
+			goto out_unlock;
 
+		err = -EINVAL;
 		if (vma_hpagesize != vma_kernel_pagesize(dst_vma))
 			goto out_unlock;
 
@@ -219,12 +226,6 @@ retry:
 		goto out_unlock;
 
 	/*
-	 * Only allow __mcopy_atomic_hugetlb on userfaultfd registered ranges.
-	 */
-	if (!dst_vma->vm_userfaultfd_ctx.ctx)
-		goto out_unlock;
-
-	/*
 	 * Ensure the dst_vma has a anon_vma.
 	 */
 	err = -ENOMEM;
@@ -368,10 +369,23 @@ retry:
 	 * Make sure the vma is not shared, that the dst range is
 	 * both valid and fully within a single existing vma.
 	 */
-	err = -EINVAL;
+	err = -ENOENT;
 	dst_vma = find_vma(dst_mm, dst_start);
 	if (!dst_vma)
 		goto out_unlock;
+	/*
+	 * Be strict and only allow __mcopy_atomic on userfaultfd
+	 * registered ranges to prevent userland errors going
+	 * unnoticed. As far as the VM consistency is concerned, it
+	 * would be perfectly safe to remove this check, but there's
+	 * no useful usage for __mcopy_atomic ouside of userfaultfd
+	 * registered ranges. This is after all why these are ioctls
+	 * belonging to the userfaultfd and not syscalls.
+	 */
+	if (!dst_vma->vm_userfaultfd_ctx.ctx)
+		goto out_unlock;
+
+	err = -EINVAL;
 	if (!vma_is_shmem(dst_vma) && dst_vma->vm_flags & VM_SHARED)
 		goto out_unlock;
 	if (dst_start < dst_vma->vm_start ||
@@ -385,18 +399,6 @@ retry:
 		return  __mcopy_atomic_hugetlb(dst_mm, dst_vma, dst_start,
 						src_start, len, zeropage);
 
-	/*
-	 * Be strict and only allow __mcopy_atomic on userfaultfd
-	 * registered ranges to prevent userland errors going
-	 * unnoticed. As far as the VM consistency is concerned, it
-	 * would be perfectly safe to remove this check, but there's
-	 * no useful usage for __mcopy_atomic ouside of userfaultfd
-	 * registered ranges. This is after all why these are ioctls
-	 * belonging to the userfaultfd and not syscalls.
-	 */
-	if (!dst_vma->vm_userfaultfd_ctx.ctx)
-		goto out_unlock;
-
 	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
 		goto out_unlock;
 
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
userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found.patch
userfaultfd_copy-return-enospc-in-case-mm-has-gone.patch

