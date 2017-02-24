From: akpm@linux-foundation.org
Subject: [folded-merged]
 userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2.patch removed from -mm tree
Date: Fri, 24 Feb 2017 14:38:41 -0800
Message-ID: <58b0b5f1.2d9PYCcNmXgC7Z1b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34098 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751356AbdBXWim (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:38:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2
has been removed from the -mm tree.  Its filename was
     userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2.patch

This patch was dropped because it was folded into userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found.patch

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2

merge fix

Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/userfaultfd.c~userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2 mm/userfaultfd.c
--- a/mm/userfaultfd.c~userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2
+++ a/mm/userfaultfd.c
@@ -201,6 +201,12 @@ retry:
 		dst_vma = find_vma(dst_mm, dst_start);
 		if (!dst_vma || !is_vm_hugetlb_page(dst_vma))
 			goto out_unlock;
+		/*
+		 * Only allow __mcopy_atomic_hugetlb on userfaultfd
+		 * registered ranges.
+		 */
+		if (!dst_vma->vm_userfaultfd_ctx.ctx)
+			goto out_unlock;
 
 		if (dst_start < dst_vma->vm_start ||
 		    dst_start + len > dst_vma->vm_end)
@@ -217,12 +223,6 @@ retry:
 		    (len - copied) & (vma_hpagesize - 1)))
 		goto out_unlock;
 
-	/*
-	 * Only allow __mcopy_atomic_hugetlb on userfaultfd registered ranges.
-	 */
-	if (!dst_vma->vm_userfaultfd_ctx.ctx)
-		goto out_unlock;
