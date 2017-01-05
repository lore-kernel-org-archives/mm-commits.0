From: akpm@linux-foundation.org
Subject: +
 mm-mprotect-use-pmd_trans_unstable-instead-of-taking-the-pmd_lock.patch
 added to -mm tree
Date: Wed, 04 Jan 2017 16:54:46 -0800
Message-ID: <586d9956.BWGWg3jE6Qlk49cy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36182 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937524AbdAEAyb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 19:54:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mprotect: use pmd_trans_unstable instead of taking the pmd_lock
has been added to the -mm tree.  Its filename is
     mm-mprotect-use-pmd_trans_unstable-instead-of-taking-the-pmd_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mprotect-use-pmd_trans_unstable-instead-of-taking-the-pmd_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mprotect-use-pmd_trans_unstable-instead-of-taking-the-pmd_lock.patch

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
Subject: mm: mprotect: use pmd_trans_unstable instead of taking the pmd_lock

pmd_trans_unstable does an atomic read on the pmd so it doesn't
require the pmd_lock for the same check.

This also removes the special assumption that the mmap_sem is hold for
writing if prot_numa is not set. userfaultfd will hold the mmap_sem
only for reading in change_pte_range like prot_numa, but it will not
set prot_numa.

This is always a valid micro-optimization regardless of userfaultfd.

Link: http://lkml.kernel.org/r/20161216144821.5183-43-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   44 +++++++++++++++-----------------------------
 1 file changed, 15 insertions(+), 29 deletions(-)

diff -puN mm/mprotect.c~mm-mprotect-use-pmd_trans_unstable-instead-of-taking-the-pmd_lock mm/mprotect.c
--- a/mm/mprotect.c~mm-mprotect-use-pmd_trans_unstable-instead-of-taking-the-pmd_lock
+++ a/mm/mprotect.c
@@ -33,34 +33,6 @@
 
 #include "internal.h"
 
-/*
- * For a prot_numa update we only hold mmap_sem for read so there is a
- * potential race with faulting where a pmd was temporarily none. This
- * function checks for a transhuge pmd under the appropriate lock. It
- * returns a pte if it was successfully locked or NULL if it raced with
- * a transhuge insertion.
- */
-static pte_t *lock_pte_protection(struct vm_area_struct *vma, pmd_t *pmd,
-			unsigned long addr, int prot_numa, spinlock_t **ptl)
-{
-	pte_t *pte;
-	spinlock_t *pmdl;
-
-	/* !prot_numa is protected by mmap_sem held for write */
-	if (!prot_numa)
-		return pte_offset_map_lock(vma->vm_mm, pmd, addr, ptl);
-
-	pmdl = pmd_lock(vma->vm_mm, pmd);
-	if (unlikely(pmd_trans_huge(*pmd) || pmd_none(*pmd))) {
-		spin_unlock(pmdl);
-		return NULL;
-	}
-
-	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, ptl);
-	spin_unlock(pmdl);
-	return pte;
-}
-
 static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long addr, unsigned long end, pgprot_t newprot,
 		int dirty_accountable, int prot_numa)
@@ -71,7 +43,21 @@ static unsigned long change_pte_range(st
 	unsigned long pages = 0;
 	int target_node = NUMA_NO_NODE;
 
-	pte = lock_pte_protection(vma, pmd, addr, prot_numa, &ptl);
+	/*
+	 * Can be called with only the mmap_sem for reading by
+	 * prot_numa so we must check the pmd isn't constantly
+	 * changing from under us from pmd_none to pmd_trans_huge
+	 * and/or the other way around.
+	 */
+	if (pmd_trans_unstable(pmd))
+		return 0;
+
+	/*
+	 * The pmd points to a regular pte so the pmd can't change
+	 * from under us even if the mmap_sem is only hold for
+	 * reading.
+	 */
+	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	if (!pte)
 		return 0;
 
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

