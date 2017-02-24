From: akpm@linux-foundation.org
Subject: [patch 046/124] mm: fix handling PTE-mapped THPs in
 page_idle_clear_pte_refs()
Date: Fri, 24 Feb 2017 14:57:51 -0800
Message-ID: <58b0ba6f.HNs/IKSDFJR0JjR4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38228 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751470AbdBXW5x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:57:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, aarcange@redhat.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, srikar@linux.vnet.ibm.com, vdavydov.dev@gmail.com

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: fix handling PTE-mapped THPs in page_idle_clear_pte_refs()

For PTE-mapped THP page_check_address_transhuge() is not adequate: it
cannot find all relevant PTEs, only the first one.i

Let's switch it to page_vma_mapped_walk().

I don't think it's subject for stable@: it's not fatal.

Link: http://lkml.kernel.org/r/20170129173858.45174-5-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_idle.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff -puN mm/page_idle.c~mm-fix-handling-pte-mapped-thps-in-page_idle_clear_pte_refs mm/page_idle.c
--- a/mm/page_idle.c~mm-fix-handling-pte-mapped-thps-in-page_idle_clear_pte_refs
+++ a/mm/page_idle.c
@@ -54,27 +54,27 @@ static int page_idle_clear_pte_refs_one(
 					struct vm_area_struct *vma,
 					unsigned long addr, void *arg)
 {
-	struct mm_struct *mm = vma->vm_mm;
-	pmd_t *pmd;
-	pte_t *pte;
-	spinlock_t *ptl;
+	struct page_vma_mapped_walk pvmw = {
+		.page = page,
+		.vma = vma,
+		.address = addr,
+	};
 	bool referenced = false;
 
-	if (!page_check_address_transhuge(page, mm, addr, &pmd, &pte, &ptl))
-		return SWAP_AGAIN;
-
-	if (pte) {
-		referenced = ptep_clear_young_notify(vma, addr, pte);
-		pte_unmap(pte);
-	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
-		referenced = pmdp_clear_young_notify(vma, addr, pmd);
-	} else {
-		/* unexpected pmd-mapped page? */
-		WARN_ON_ONCE(1);
+	while (page_vma_mapped_walk(&pvmw)) {
+		addr = pvmw.address;
+		if (pvmw.pte) {
+			referenced = ptep_clear_young_notify(vma, addr,
+					pvmw.pte);
+		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+			referenced = pmdp_clear_young_notify(vma, addr,
+					pvmw.pmd);
+		} else {
+			/* unexpected pmd-mapped page? */
+			WARN_ON_ONCE(1);
+		}
 	}
 
-	spin_unlock(ptl);
