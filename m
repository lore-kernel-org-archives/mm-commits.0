From: akpm@linux-foundation.org
Subject: [merged] thp-verify-pmd_trans_huge-isnt-leaking.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:47:24 -0800
Message-ID: <201101142250.p0EMoEBo005389@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753877Ab1ANWu1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:50:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: verify pmd_trans_huge isn't leaking
has been removed from the -mm tree.  Its filename was
     thp-verify-pmd_trans_huge-isnt-leaking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: verify pmd_trans_huge isn't leaking
From: Andrea Arcangeli <aarcange@redhat.com>

pte_trans_huge must not leak in certain vmas like the mmio special pfn or
filebacked mappings.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/memory.c~thp-verify-pmd_trans_huge-isnt-leaking mm/memory.c
--- a/mm/memory.c~thp-verify-pmd_trans_huge-isnt-leaking
+++ a/mm/memory.c
@@ -1451,6 +1451,7 @@ int __get_user_pages(struct task_struct 
 			pmd = pmd_offset(pud, pg);
 			if (pmd_none(*pmd))
 				return i ? : -EFAULT;
+			VM_BUG_ON(pmd_trans_huge(*pmd));
 			pte = pte_offset_map(pmd, pg);
 			if (pte_none(*pte)) {
 				pte_unmap(pte);
@@ -1675,8 +1676,10 @@ pte_t *__get_locked_pte(struct mm_struct
 	pud_t * pud = pud_alloc(mm, pgd, addr);
 	if (pud) {
 		pmd_t * pmd = pmd_alloc(mm, pud, addr);
-		if (pmd)
+		if (pmd) {
+			VM_BUG_ON(pmd_trans_huge(*pmd));
 			return pte_alloc_map_lock(mm, pmd, addr, ptl);
+		}
 	}
 	return NULL;
 }
@@ -1895,6 +1898,7 @@ static inline int remap_pmd_range(struct
 	pmd = pmd_alloc(mm, pud, addr);
 	if (!pmd)
 		return -ENOMEM;
+	VM_BUG_ON(pmd_trans_huge(*pmd));
 	do {
 		next = pmd_addr_end(addr, end);
 		if (remap_pte_range(mm, pmd, addr, next,
@@ -3471,6 +3475,7 @@ static int __follow_pte(struct mm_struct
 		goto out;
 
 	pmd = pmd_offset(pud, address);
+	VM_BUG_ON(pmd_trans_huge(*pmd));
 	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
 		goto out;
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

