From: akpm@linux-foundation.org
Subject: [patch 050/124] mm, ksm: convert write_protect_page() to use
 page_vma_mapped_walk()
Date: Fri, 24 Feb 2017 14:58:04 -0800
Message-ID: <58b0ba7c.bD29mlHjp/ybxffb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38304 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751486AbdBXW6F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:58:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, aarcange@redhat.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, srikar@linux.vnet.ibm.com, vdavydov.dev@gmail.com

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm, ksm: convert write_protect_page() to use page_vma_mapped_walk()

For consistency, it worth converting all page_check_address() to
page_vma_mapped_walk(), so we could drop the former.

Link: http://lkml.kernel.org/r/20170129173858.45174-9-kirill.shutemov@linux.intel.com
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

 mm/ksm.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff -puN mm/ksm.c~mm-ksm-convert-write_protect_page-to-use-page_vma_mapped_walk mm/ksm.c
--- a/mm/ksm.c~mm-ksm-convert-write_protect_page-to-use-page_vma_mapped_walk
+++ a/mm/ksm.c
@@ -856,33 +856,35 @@ static int write_protect_page(struct vm_
 			      pte_t *orig_pte)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	unsigned long addr;
-	pte_t *ptep;
-	spinlock_t *ptl;
+	struct page_vma_mapped_walk pvmw = {
+		.page = page,
+		.vma = vma,
+	};
 	int swapped;
 	int err = -EFAULT;
 	unsigned long mmun_start;	/* For mmu_notifiers */
 	unsigned long mmun_end;		/* For mmu_notifiers */
 
-	addr = page_address_in_vma(page, vma);
-	if (addr == -EFAULT)
+	pvmw.address = page_address_in_vma(page, vma);
+	if (pvmw.address == -EFAULT)
 		goto out;
 
 	BUG_ON(PageTransCompound(page));
 
-	mmun_start = addr;
-	mmun_end   = addr + PAGE_SIZE;
+	mmun_start = pvmw.address;
+	mmun_end   = pvmw.address + PAGE_SIZE;
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 
-	ptep = page_check_address(page, mm, addr, &ptl, 0);
-	if (!ptep)
+	if (!page_vma_mapped_walk(&pvmw))
 		goto out_mn;
+	if (WARN_ONCE(!pvmw.pte, "Unexpected PMD mapping?"))
+		goto out_unlock;
 
-	if (pte_write(*ptep) || pte_dirty(*ptep)) {
+	if (pte_write(*pvmw.pte) || pte_dirty(*pvmw.pte)) {
 		pte_t entry;
 
 		swapped = PageSwapCache(page);
-		flush_cache_page(vma, addr, page_to_pfn(page));
+		flush_cache_page(vma, pvmw.address, page_to_pfn(page));
 		/*
 		 * Ok this is tricky, when get_user_pages_fast() run it doesn't
 		 * take any lock, therefore the check that we are going to make
@@ -892,25 +894,25 @@ static int write_protect_page(struct vm_
 		 * this assure us that no O_DIRECT can happen after the check
 		 * or in the middle of the check.
 		 */
-		entry = ptep_clear_flush_notify(vma, addr, ptep);
+		entry = ptep_clear_flush_notify(vma, pvmw.address, pvmw.pte);
 		/*
 		 * Check that no O_DIRECT or similar I/O is in progress on the
 		 * page
 		 */
 		if (page_mapcount(page) + 1 + swapped != page_count(page)) {
-			set_pte_at(mm, addr, ptep, entry);
+			set_pte_at(mm, pvmw.address, pvmw.pte, entry);
 			goto out_unlock;
 		}
 		if (pte_dirty(entry))
 			set_page_dirty(page);
 		entry = pte_mkclean(pte_wrprotect(entry));
-		set_pte_at_notify(mm, addr, ptep, entry);
+		set_pte_at_notify(mm, pvmw.address, pvmw.pte, entry);
 	}
-	*orig_pte = *ptep;
+	*orig_pte = *pvmw.pte;
 	err = 0;
 
 out_unlock:
-	pte_unmap_unlock(ptep, ptl);
+	page_vma_mapped_walk_done(&pvmw);
 out_mn:
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 out:
_
