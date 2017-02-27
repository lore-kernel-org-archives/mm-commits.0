From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found.patch
 removed from -mm tree
Date: Mon, 27 Feb 2017 12:26:41 -0800
Message-ID: <58b48b81.4XHM3RtRv+752065%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60552 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751740AbdB0U16 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:27:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: mcopy_atomic: return -ENOENT when no compatible VMA found
has been removed from the -mm tree.  Its filename was
     userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[rppt@linux.vnet.ibm.com: update cases returning -ENOENT]
  Link: http://lkml.kernel.org/r/20170207150249.GA6709@rapoport-lnx
[aarcange@redhat.com: merge fix]
[akpm@linux-foundation.org: fix the merge fix]
Link: http://lkml.kernel.org/r/1485542673-24387-5-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   58 +++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 30 deletions(-)

diff -puN mm/userfaultfd.c~userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found mm/userfaultfd.c
--- a/mm/userfaultfd.c~userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found
+++ a/mm/userfaultfd.c
@@ -197,22 +197,25 @@ retry:
 	 * retry, dst_vma will be set to NULL and we must lookup again.
 	 */
 	if (!dst_vma) {
-		err = -EINVAL;
+		err = -ENOENT;
 		dst_vma = find_vma(dst_mm, dst_start);
 		if (!dst_vma || !is_vm_hugetlb_page(dst_vma))
 			goto out_unlock;
-
-		if (vma_hpagesize != vma_kernel_pagesize(dst_vma))
-			goto out_unlock;
-
 		/*
-		 * Make sure the remaining dst range is both valid and
-		 * fully within a single existing vma.
+		 * Only allow __mcopy_atomic_hugetlb on userfaultfd
+		 * registered ranges.
 		 */
+		if (!dst_vma->vm_userfaultfd_ctx.ctx)
+			goto out_unlock;
+
 		if (dst_start < dst_vma->vm_start ||
 		    dst_start + len > dst_vma->vm_end)
 			goto out_unlock;
 
+		err = -EINVAL;
+		if (vma_hpagesize != vma_kernel_pagesize(dst_vma))
+			goto out_unlock;
+
 		vm_shared = dst_vma->vm_flags & VM_SHARED;
 	}
 
@@ -221,12 +224,6 @@ retry:
 		goto out_unlock;
 
 	/*
-	 * Only allow __mcopy_atomic_hugetlb on userfaultfd registered ranges.
-	 */
-	if (!dst_vma->vm_userfaultfd_ctx.ctx)
-		goto out_unlock;
-
-	/*
 	 * If not shared, ensure the dst_vma has a anon_vma.
 	 */
 	err = -ENOMEM;
@@ -404,22 +401,35 @@ retry:
 	 * Make sure the vma is not shared, that the dst range is
 	 * both valid and fully within a single existing vma.
 	 */
-	err = -EINVAL;
+	err = -ENOENT;
 	dst_vma = find_vma(dst_mm, dst_start);
 	if (!dst_vma)
 		goto out_unlock;
 	/*
-	 * shmem_zero_setup is invoked in mmap for MAP_ANONYMOUS|MAP_SHARED but
-	 * it will overwrite vm_ops, so vma_is_anonymous must return false.
+	 * Be strict and only allow __mcopy_atomic on userfaultfd
+	 * registered ranges to prevent userland errors going
+	 * unnoticed. As far as the VM consistency is concerned, it
+	 * would be perfectly safe to remove this check, but there's
+	 * no useful usage for __mcopy_atomic ouside of userfaultfd
+	 * registered ranges. This is after all why these are ioctls
+	 * belonging to the userfaultfd and not syscalls.
 	 */
-	if (WARN_ON_ONCE(vma_is_anonymous(dst_vma) &&
-	    dst_vma->vm_flags & VM_SHARED))
+	if (!dst_vma->vm_userfaultfd_ctx.ctx)
 		goto out_unlock;
 
 	if (dst_start < dst_vma->vm_start ||
 	    dst_start + len > dst_vma->vm_end)
 		goto out_unlock;
 
+	err = -EINVAL;
+	/*
+	 * shmem_zero_setup is invoked in mmap for MAP_ANONYMOUS|MAP_SHARED but
+	 * it will overwrite vm_ops, so vma_is_anonymous must return false.
+	 */
+	if (WARN_ON_ONCE(vma_is_anonymous(dst_vma) &&
+	    dst_vma->vm_flags & VM_SHARED))
+		goto out_unlock;
+
 	/*
 	 * If this is a HUGETLB vma, pass off to appropriate routine
 	 */
@@ -427,18 +437,6 @@ retry:
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
