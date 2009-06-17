From: akpm@linux-foundation.org
Subject: [merged] mm-introduce-follow_pte.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:35:07 -0700
Message-ID: <200906171835.n5HIZ75e001112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760191AbZFQSgH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:36:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hch@infradead.org, hugh.dickins@tiscali.co.uk, hverkuil@xs4all.nl, lethal@linux-sh.org, magnus.damm@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: introduce follow_pte()
has been removed from the -mm tree.  Its filename was
     mm-introduce-follow_pte.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: introduce follow_pte()
From: Johannes Weiner <hannes@cmpxchg.org>

A generic readonly page table lookup helper to map an address space and an
address from it to a pte.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Hellwig <hch@infradead.org>
Acked-by: Magnus Damm <magnus.damm@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff -puN mm/memory.c~mm-introduce-follow_pte mm/memory.c
--- a/mm/memory.c~mm-introduce-follow_pte
+++ a/mm/memory.c
@@ -3103,6 +3103,43 @@ int in_gate_area_no_task(unsigned long a
 
 #endif	/* __HAVE_ARCH_GATE_AREA */
 
+static int follow_pte(struct mm_struct *mm, unsigned long address,
+		pte_t **ptepp, spinlock_t **ptlp)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *ptep;
+
+	pgd = pgd_offset(mm, address);
+	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
+		goto out;
+
+	pud = pud_offset(pgd, address);
+	if (pud_none(*pud) || unlikely(pud_bad(*pud)))
+		goto out;
+
+	pmd = pmd_offset(pud, address);
+	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
+		goto out;
+
+	/* We cannot handle huge page PFN maps. Luckily they don't exist. */
+	if (pmd_huge(*pmd))
+		goto out;
+
+	ptep = pte_offset_map_lock(mm, pmd, address, ptlp);
+	if (!ptep)
+		goto out;
+	if (!pte_present(*ptep))
+		goto unlock;
+	*ptepp = ptep;
+	return 0;
+unlock:
+	pte_unmap_unlock(ptep, *ptlp);
+out:
+	return -EINVAL;
+}
+
 #ifdef CONFIG_HAVE_IOREMAP_PROT
 int follow_phys(struct vm_area_struct *vma,
 		unsigned long address, unsigned int flags,
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
memcg-fix-swap-accounting.patch
memcg-fix-swap-accounting-update.patch

