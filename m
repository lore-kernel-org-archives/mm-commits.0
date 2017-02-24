From: akpm@linux-foundation.org
Subject: [folded-merged]
 userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix.patch removed from -mm tree
Date: Fri, 24 Feb 2017 14:38:38 -0800
Message-ID: <58b0b5ee.jPvsyYwJzb2rqmds%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34082 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751356AbdBXWij (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:38:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: mcopy_atomic: update cases returning -ENOENT
has been removed from the -mm tree.  Its filename was
     userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix.patch

This patch was dropped because it was folded into userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found.patch

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

 mm/userfaultfd.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/userfaultfd.c~userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix mm/userfaultfd.c
--- a/mm/userfaultfd.c~userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix
+++ a/mm/userfaultfd.c
@@ -202,19 +202,15 @@ retry:
 		if (!dst_vma || !is_vm_hugetlb_page(dst_vma))
 			goto out_unlock;
 
-		err = -EINVAL;
-		if (vma_hpagesize != vma_kernel_pagesize(dst_vma))
-			goto out_unlock;
-
-		/*
-		 * Make sure the remaining dst range is both valid and
-		 * fully within a single existing vma.
-		 */
 		if (dst_start < dst_vma->vm_start ||
 		    dst_start + len > dst_vma->vm_end)
 			goto out_unlock;
 
 		vm_shared = dst_vma->vm_flags & VM_SHARED;
+
+		err = -EINVAL;
+		if (vma_hpagesize != vma_kernel_pagesize(dst_vma))
+			goto out_unlock;
 	}
 
 	if (WARN_ON(dst_addr & (vma_hpagesize - 1) ||
@@ -227,6 +223,10 @@ retry:
 	if (!dst_vma->vm_userfaultfd_ctx.ctx)
 		goto out_unlock;
 
+	if (dst_start < dst_vma->vm_start ||
+	    dst_start + len > dst_vma->vm_end)
+		goto out_unlock;
+
 	/*
 	 * If not shared, ensure the dst_vma has a anon_vma.
 	 */
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are

userfaultfd-non-cooperative-rename-event_madvdontneed-to-event_remove.patch
userfaultfd-non-cooperative-add-madvise-event-for-madv_remove-request.patch
userfaultfd-non-cooperative-selftest-enable-remove-event-test-for-shmem.patch
mm-call-vm_munmap-in-munmap-syscall-instead-of-using-open-coded-version.patch
userfaultfd-non-cooperative-add-event-for-memory-unmaps.patch
userfaultfd-non-cooperative-add-event-for-exit-notification.patch
userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found.patch
userfaultfd_copy-return-enospc-in-case-mm-has-gone.patch
userfaultfd-documentation-update.patch

