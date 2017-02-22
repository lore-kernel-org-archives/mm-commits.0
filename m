From: akpm@linux-foundation.org
Subject: [patch 076/142] userfaultfd: shmem: use shmem_mcopy_atomic_pte
 for shared memory
Date: Wed, 22 Feb 2017 15:43:34 -0800
Message-ID: <58ae2226.6iRPcbpNfERciol1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48772 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934171AbdBVXnf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:43:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rppt@linux.vnet.ibm.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@parallels.com

From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: shmem: use shmem_mcopy_atomic_pte for shared memory

The shmem_mcopy_atomic_pte implements low lever part of UFFDIO_COPY
operation for shared memory VMAs.  It's based on mcopy_atomic_pte with
adjustments necessary for shared memory pages.

Link: http://lkml.kernel.org/r/20161216144821.5183-32-aarcange@redhat.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff -puN mm/userfaultfd.c~userfaultfd-shmem-use-shmem_mcopy_atomic_pte-for-shared-memory mm/userfaultfd.c
--- a/mm/userfaultfd.c~userfaultfd-shmem-use-shmem_mcopy_atomic_pte-for-shared-memory
+++ a/mm/userfaultfd.c
@@ -16,6 +16,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/hugetlb.h>
 #include <linux/pagemap.h>
+#include <linux/shmem_fs.h>
 #include <asm/tlbflush.h>
 #include "internal.h"
 
@@ -369,7 +370,9 @@ retry:
 	 */
 	err = -EINVAL;
 	dst_vma = find_vma(dst_mm, dst_start);
-	if (!dst_vma || (dst_vma->vm_flags & VM_SHARED))
+	if (!dst_vma)
+		goto out_unlock;
+	if (!vma_is_shmem(dst_vma) && dst_vma->vm_flags & VM_SHARED)
 		goto out_unlock;
 	if (dst_start < dst_vma->vm_start ||
 	    dst_start + len > dst_vma->vm_end)
@@ -394,11 +397,7 @@ retry:
 	if (!dst_vma->vm_userfaultfd_ctx.ctx)
 		goto out_unlock;
 
-	/*
-	 * FIXME: only allow copying on anonymous vmas, tmpfs should
-	 * be added.
-	 */
-	if (!vma_is_anonymous(dst_vma))
+	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
 		goto out_unlock;
 
 	/*
@@ -407,7 +406,7 @@ retry:
 	 * dst_vma.
 	 */
 	err = -ENOMEM;
-	if (unlikely(anon_vma_prepare(dst_vma)))
+	if (vma_is_anonymous(dst_vma) && unlikely(anon_vma_prepare(dst_vma)))
 		goto out_unlock;
 
 	while (src_addr < src_start + len) {
@@ -444,12 +443,21 @@ retry:
 		BUG_ON(pmd_none(*dst_pmd));
 		BUG_ON(pmd_trans_huge(*dst_pmd));
 
-		if (!zeropage)
-			err = mcopy_atomic_pte(dst_mm, dst_pmd, dst_vma,
-					       dst_addr, src_addr, &page);
-		else
-			err = mfill_zeropage_pte(dst_mm, dst_pmd, dst_vma,
-						 dst_addr);
+		if (vma_is_anonymous(dst_vma)) {
+			if (!zeropage)
+				err = mcopy_atomic_pte(dst_mm, dst_pmd, dst_vma,
+						       dst_addr, src_addr,
+						       &page);
+			else
+				err = mfill_zeropage_pte(dst_mm, dst_pmd,
+							 dst_vma, dst_addr);
+		} else {
+			err = -EINVAL; /* if zeropage is true return -EINVAL */
+			if (likely(!zeropage))
+				err = shmem_mcopy_atomic_pte(dst_mm, dst_pmd,
+							     dst_vma, dst_addr,
+							     src_addr, &page);
+		}
 
 		cond_resched();
 
_
