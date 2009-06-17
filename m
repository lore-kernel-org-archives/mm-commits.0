From: akpm@linux-foundation.org
Subject: [merged] mm-use-generic-follow_pte-in-follow_phys.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:35:10 -0700
Message-ID: <200906171835.n5HIZAlb001184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757032AbZFQSza (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:55:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hch@infradead.org, hugh.dickins@tiscali.co.uk, hverkuil@xs4all.nl, lethal@linux-sh.org, magnus.damm@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: use generic follow_pte() in follow_phys()
has been removed from the -mm tree.  Its filename was
     mm-use-generic-follow_pte-in-follow_phys.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: use generic follow_pte() in follow_phys()
From: Johannes Weiner <hannes@cmpxchg.org>

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Hellwig <hch@infradead.org>
Acked-by: Magnus Damm <magnus.damm@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   36 +++++-------------------------------
 1 file changed, 5 insertions(+), 31 deletions(-)

diff -puN mm/memory.c~mm-use-generic-follow_pte-in-follow_phys mm/memory.c
--- a/mm/memory.c~mm-use-generic-follow_pte-in-follow_phys
+++ a/mm/memory.c
@@ -3145,50 +3145,24 @@ int follow_phys(struct vm_area_struct *v
 		unsigned long address, unsigned int flags,
 		unsigned long *prot, resource_size_t *phys)
 {
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
+	int ret = -EINVAL;
 	pte_t *ptep, pte;
 	spinlock_t *ptl;
-	resource_size_t phys_addr = 0;
-	struct mm_struct *mm = vma->vm_mm;
-	int ret = -EINVAL;
 
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
 		goto out;
 
-	pgd = pgd_offset(mm, address);
-	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
-		goto out;
-
-	pud = pud_offset(pgd, address);
-	if (pud_none(*pud) || unlikely(pud_bad(*pud)))
-		goto out;
-
-	pmd = pmd_offset(pud, address);
-	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
-		goto out;
-
-	/* We cannot handle huge page PFN maps. Luckily they don't exist. */
-	if (pmd_huge(*pmd))
+	if (follow_pte(vma->vm_mm, address, &ptep, &ptl))
 		goto out;
-
-	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
-	if (!ptep)
-		goto out;
-
 	pte = *ptep;
-	if (!pte_present(pte))
-		goto unlock;
+
 	if ((flags & FOLL_WRITE) && !pte_write(pte))
 		goto unlock;
-	phys_addr = pte_pfn(pte);
-	phys_addr <<= PAGE_SHIFT; /* Shift here to avoid overflow on PAE */
 
 	*prot = pgprot_val(pte_pgprot(pte));
-	*phys = phys_addr;
-	ret = 0;
+	*phys = (resource_size_t)pte_pfn(pte) << PAGE_SHIFT;
 
+	ret = 0;
 unlock:
 	pte_unmap_unlock(ptep, ptl);
 out:
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
memcg-fix-swap-accounting.patch
memcg-fix-swap-accounting-update.patch

