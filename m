From: akpm@linux-foundation.org
Subject: [merged]
 mm-mprotect-use-pmd_trans_unstable-instead-of-taking-the-pmd_lock.patch
 removed from -mm tree
Date: Thu, 23 Feb 2017 13:15:19 -0800
Message-ID: <58af50e7.iUBM3wc7A3O0BNAo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40158 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751237AbdBWVPU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:15:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, kirill@shutemov.name, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mprotect: use pmd_trans_unstable instead of taking the pmd_lock
has been removed from the -mm tree.  Its filename was
     mm-mprotect-use-pmd_trans_unstable-instead-of-taking-the-pmd_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[kirill@shutemov.name: drop unneeded pmd_trans_unstable(pmd) check after __split_huge_pmd()]
  Link: http://lkml.kernel.org/r/20170208120421.GE5578@node.shutemov.name
Link: http://lkml.kernel.org/r/20161216144821.5183-43-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   46 +++++++++++++++-------------------------------
 1 file changed, 15 insertions(+), 31 deletions(-)

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
 
@@ -177,8 +163,6 @@ static inline unsigned long change_pmd_r
 		if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE) {
 				__split_huge_pmd(vma, pmd, addr, false, NULL);
-				if (pmd_trans_unstable(pmd))
-					continue;
 			} else {
 				int nr_ptes = change_huge_pmd(vma, pmd, addr,
 						newprot, prot_numa);
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2.patch
userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2-fix-fix.patch

