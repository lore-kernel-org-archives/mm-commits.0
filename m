From: akpm@linux-foundation.org
Subject: +
 mm-ksm-convert-write_protect_page-to-use-page_vma_mapped_walk.patch added
 to -mm tree
Date: Tue, 31 Jan 2017 16:10:19 -0800
Message-ID: <5891276b.M5X5z8xMRNwssBxe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36054 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751061AbdBAAKf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 19:10:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, srikar@linux.vnet.ibm.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, ksm: convert write_protect_page() to use page_vma_mapped_walk()
has been added to the -mm tree.  Its filename is
     mm-ksm-convert-write_protect_page-to-use-page_vma_mapped_walk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-ksm-convert-write_protect_page-to-use-page_vma_mapped_walk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-ksm-convert-write_protect_page-to-use-page_vma_mapped_walk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-sleeping-function-called-from-invalid-context-shmem_undo_range.patch
mm-drop-zap_details-ignore_dirty.patch
mm-drop-zap_details-check_swap_entries.patch
mm-drop-unused-argument-of-zap_page_range.patch
oom-reaper-use-madvise_dontneed-logic-to-decide-if-unmap-the-vma.patch
uprobes-split-thps-before-trying-replace-them.patch
mm-introduce-page_vma_mapped_walk.patch
mm-fix-handling-pte-mapped-thps-in-page_referenced.patch
mm-fix-handling-pte-mapped-thps-in-page_idle_clear_pte_refs.patch
mm-rmap-check-all-vmas-that-pte-mapped-thp-can-be-part-of.patch
mm-convert-page_mkclean_one-to-use-page_vma_mapped_walk.patch
mm-convert-try_to_unmap_one-to-use-page_vma_mapped_walk.patch
mm-ksm-convert-write_protect_page-to-use-page_vma_mapped_walk.patch
mm-uprobes-convert-__replace_page-to-use-page_vma_mapped_walk.patch
mm-convert-page_mapped_in_vma-to-use-page_vma_mapped_walk.patch
mm-drop-page_check_address_transhuge.patch
mm-convert-remove_migration_pte-to-use-page_vma_mapped_walk.patch

