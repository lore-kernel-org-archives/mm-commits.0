From: akpm@linux-foundation.org
Subject: +
 userfaultfd-shmem-use-shmem_mcopy_atomic_pte-for-shared-memory.patch added
 to -mm tree
Date: Wed, 04 Jan 2017 16:54:24 -0800
Message-ID: <586d9940.2Z0pALHWf1RprNd/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36186 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933361AbdAEAy1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 19:54:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: shmem: use shmem_mcopy_atomic_pte for shared memory
has been added to the -mm tree.  Its filename is
     userfaultfd-shmem-use-shmem_mcopy_atomic_pte-for-shared-memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-shmem-use-shmem_mcopy_atomic_pte-for-shared-memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-shmem-use-shmem_mcopy_atomic_pte-for-shared-memory.patch

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

