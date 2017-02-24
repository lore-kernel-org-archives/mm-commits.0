From: akpm@linux-foundation.org
Subject: [folded-merged]
 userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2-fix-fix.patch removed from -mm tree
Date: Fri, 24 Feb 2017 14:38:47 -0800
Message-ID: <58b0b5f7.HBCAZzyos+4iP2jb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34110 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751356AbdBXWis (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:38:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2-fix-fix
has been removed from the -mm tree.  Its filename was
     userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2-fix-fix.patch

This patch was dropped because it was folded into userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found.patch

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2-fix-fix

Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff -puN mm/userfaultfd.c~userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2-fix-fix mm/userfaultfd.c
--- a/mm/userfaultfd.c~userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2-fix-fix
+++ a/mm/userfaultfd.c
@@ -212,22 +212,17 @@ retry:
 		    dst_start + len > dst_vma->vm_end)
 			goto out_unlock;
 
-		vm_shared = dst_vma->vm_flags & VM_SHARED;
-
 		err = -EINVAL;
 		if (vma_hpagesize != vma_kernel_pagesize(dst_vma))
 			goto out_unlock;
+
+		vm_shared = dst_vma->vm_flags & VM_SHARED;
 	}
 
-	err = -EINVAL;
 	if (WARN_ON(dst_addr & (vma_hpagesize - 1) ||
 		    (len - copied) & (vma_hpagesize - 1)))
 		goto out_unlock;
 
-	if (dst_start < dst_vma->vm_start ||
-	    dst_start + len > dst_vma->vm_end)
-		goto out_unlock;
-
 	/*
 	 * If not shared, ensure the dst_vma has a anon_vma.
 	 */
@@ -410,9 +405,6 @@ retry:
 	dst_vma = find_vma(dst_mm, dst_start);
 	if (!dst_vma)
 		goto out_unlock;
-
-	err = -EINVAL;
-
 	/*
 	 * Be strict and only allow __mcopy_atomic on userfaultfd
 	 * registered ranges to prevent userland errors going
@@ -425,6 +417,11 @@ retry:
 	if (!dst_vma->vm_userfaultfd_ctx.ctx)
 		goto out_unlock;
 
+	if (dst_start < dst_vma->vm_start ||
+	    dst_start + len > dst_vma->vm_end)
+		goto out_unlock;
+
+	err = -EINVAL;
 	/*
 	 * shmem_zero_setup is invoked in mmap for MAP_ANONYMOUS|MAP_SHARED but
 	 * it will overwrite vm_ops, so vma_is_anonymous must return false.
@@ -433,10 +430,6 @@ retry:
 	    dst_vma->vm_flags & VM_SHARED))
 		goto out_unlock;
 
-	if (dst_start < dst_vma->vm_start ||
-	    dst_start + len > dst_vma->vm_end)
-		goto out_unlock;
