From: akpm@linux-foundation.org
Subject: [patch 045/124] mm: fix handling PTE-mapped THPs in
 page_referenced()
Date: Fri, 24 Feb 2017 14:57:48 -0800
Message-ID: <58b0ba6c.QS8D2fsVdOkzaND6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38216 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751470AbdBXW5u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:57:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, aarcange@redhat.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, srikar@linux.vnet.ibm.com, vdavydov.dev@gmail.com

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: fix handling PTE-mapped THPs in page_referenced()

For PTE-mapped THP page_check_address_transhuge() is not adequate: it
cannot find all relevant PTEs, only the first one.  It means we can miss
some references of the page and it can result in suboptimal decisions by
vmscan.

Let's switch it to page_vma_mapped_walk().

I don't think it's subject for stable@: it's not fatal.  The only side
effect is that THP can be swapped out when it shouldn't.

Link: http://lkml.kernel.org/r/20170129173858.45174-4-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   66 ++++++++++++++++++++++++++--------------------------
 1 file changed, 34 insertions(+), 32 deletions(-)

diff -puN mm/rmap.c~mm-fix-handling-pte-mapped-thps-in-page_referenced mm/rmap.c
--- a/mm/rmap.c~mm-fix-handling-pte-mapped-thps-in-page_referenced
+++ a/mm/rmap.c
@@ -886,45 +886,48 @@ struct page_referenced_arg {
 static int page_referenced_one(struct page *page, struct vm_area_struct *vma,
 			unsigned long address, void *arg)
 {
-	struct mm_struct *mm = vma->vm_mm;
 	struct page_referenced_arg *pra = arg;
-	pmd_t *pmd;
-	pte_t *pte;
-	spinlock_t *ptl;
+	struct page_vma_mapped_walk pvmw = {
+		.page = page,
+		.vma = vma,
+		.address = address,
+	};
 	int referenced = 0;
 
-	if (!page_check_address_transhuge(page, mm, address, &pmd, &pte, &ptl))
-		return SWAP_AGAIN;
+	while (page_vma_mapped_walk(&pvmw)) {
+		address = pvmw.address;
 
-	if (vma->vm_flags & VM_LOCKED) {
-		if (pte)
-			pte_unmap(pte);
-		spin_unlock(ptl);
-		pra->vm_flags |= VM_LOCKED;
-		return SWAP_FAIL; /* To break the loop */
-	}
+		if (vma->vm_flags & VM_LOCKED) {
+			page_vma_mapped_walk_done(&pvmw);
+			pra->vm_flags |= VM_LOCKED;
+			return SWAP_FAIL; /* To break the loop */
+		}
 
-	if (pte) {
-		if (ptep_clear_flush_young_notify(vma, address, pte)) {
-			/*
-			 * Don't treat a reference through a sequentially read
-			 * mapping as such.  If the page has been used in
-			 * another mapping, we will catch it; if this other
-			 * mapping is already gone, the unmap path will have
-			 * set PG_referenced or activated the page.
-			 */
-			if (likely(!(vma->vm_flags & VM_SEQ_READ)))
+		if (pvmw.pte) {
+			if (ptep_clear_flush_young_notify(vma, address,
+						pvmw.pte)) {
+				/*
+				 * Don't treat a reference through
+				 * a sequentially read mapping as such.
+				 * If the page has been used in another mapping,
+				 * we will catch it; if this other mapping is
+				 * already gone, the unmap path will have set
+				 * PG_referenced or activated the page.
+				 */
+				if (likely(!(vma->vm_flags & VM_SEQ_READ)))
+					referenced++;
+			}
+		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+			if (pmdp_clear_flush_young_notify(vma, address,
+						pvmw.pmd))
 				referenced++;
+		} else {
+			/* unexpected pmd-mapped page? */
+			WARN_ON_ONCE(1);
 		}
-		pte_unmap(pte);
-	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
-		if (pmdp_clear_flush_young_notify(vma, address, pmd))
-			referenced++;
-	} else {
-		/* unexpected pmd-mapped page? */
-		WARN_ON_ONCE(1);
+
+		pra->mapcount--;
 	}
-	spin_unlock(ptl);
 
 	if (referenced)
 		clear_page_idle(page);
@@ -936,7 +939,6 @@ static int page_referenced_one(struct pa
 		pra->vm_flags |= vma->vm_flags;
 	}
 
-	pra->mapcount--;
 	if (!pra->mapcount)
 		return SWAP_SUCCESS; /* To break the loop */
 
_
