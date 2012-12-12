From: akpm@linux-foundation.org
Subject: [folded-merged] thp-do_huge_pmd_wp_page-handle-huge-zero-page-v6.patch removed from -mm tree
Date: Wed, 12 Dec 2012 13:35:40 -0800
Message-ID: <20121212213541.7C14E20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:48052 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227Ab2LLVfo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 16:35:44 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so68265wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 13:35:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, hpa@linux.intel.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp-do_huge_pmd_wp_page-handle-huge-zero-page-v6
has been removed from the -mm tree.  Its filename was
     thp-do_huge_pmd_wp_page-handle-huge-zero-page-v6.patch

This patch was dropped because it was folded into thp-do_huge_pmd_wp_page-handle-huge-zero-page.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp-do_huge_pmd_wp_page-handle-huge-zero-page-v6

On write access to huge zero page we alloc a new huge page and clear it.

If ENOMEM, graceful fallback: we create a new pmd table and set pte
around fault address to newly allocated normal (4k) page. All other ptes
in the pmd set to normal zero page.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff -puN mm/huge_memory.c~thp-do_huge_pmd_wp_page-handle-huge-zero-page-v6 mm/huge_memory.c
--- a/mm/huge_memory.c~thp-do_huge_pmd_wp_page-handle-huge-zero-page-v6
+++ a/mm/huge_memory.c
@@ -1019,25 +1019,6 @@ unlock:
 	spin_unlock(&mm->page_table_lock);
 }
 
-/* no "address" argument so destroys page coloring of some arch */
-pgtable_t get_pmd_huge_pte(struct mm_struct *mm)
-{
-	pgtable_t pgtable;
-
-	assert_spin_locked(&mm->page_table_lock);
-
-	/* FIFO */
-	pgtable = mm->pmd_huge_pte;
-	if (list_empty(&pgtable->lru))
-		mm->pmd_huge_pte = NULL;
-	else {
-		mm->pmd_huge_pte = list_entry(pgtable->lru.next,
-					      struct page, lru);
-		list_del(&pgtable->lru);
-	}
-	return pgtable;
-}
-
 static int do_huge_pmd_wp_zero_page_fallback(struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long address,
 		pmd_t *pmd, unsigned long haddr)
@@ -1072,7 +1053,7 @@ static int do_huge_pmd_wp_zero_page_fall
 	pmdp_clear_flush(vma, haddr, pmd);
 	/* leave pmd empty until pte is filled */
 
-	pgtable = get_pmd_huge_pte(mm);
+	pgtable = pgtable_trans_huge_withdraw(mm);
 	pmd_populate(mm, &_pmd, pgtable);
 
 	for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
@@ -1287,7 +1268,6 @@ alloc:
 		goto out_mn;
 	} else {
 		pmd_t entry;
-
 		entry = mk_huge_pmd(new_page, vma);
 		pmdp_clear_flush(vma, haddr, pmd);
 		page_add_new_anon_rmap(new_page, vma, haddr);
@@ -1295,7 +1275,7 @@ alloc:
 		update_mmu_cache_pmd(vma, address, pmd);
 		if (is_huge_zero_pmd(orig_pmd))
 			add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR);
-		if (page) {
+		else {
 			VM_BUG_ON(!PageHead(page));
 			page_remove_rmap(page);
 			put_page(page);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
thp-huge-zero-page-basic-preparation.patch
thp-zap_huge_pmd-zap-huge-zero-pmd.patch
thp-copy_huge_pmd-copy-huge-zero-page.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page-thp-fix-anononymous-page-accounting-in-fallback-path-for-cow-of-hzp.patch
thp-change_huge_pmd-make-sure-we-dont-try-to-make-a-page-writable.patch
thp-change-split_huge_page_pmd-interface.patch
thp-change-split_huge_page_pmd-interface-v6.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
thp-implement-splitting-pmd-for-huge-zero-page-fix.patch
thp-implement-splitting-pmd-for-huge-zero-page-v6.patch
thp-setup-huge-zero-page-on-non-write-page-fault.patch
thp-setup-huge-zero-page-on-non-write-page-fault-fix.patch
thp-lazy-huge-zero-page-allocation.patch
thp-implement-refcounting-for-huge-zero-page.patch
thp-implement-refcounting-for-huge-zero-page-fix.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events-v6.patch
thp-introduce-sysfs-knob-to-disable-huge-zero-page.patch
thp-avoid-race-on-multiple-parallel-page-faults-to-the-same-page.patch
asm-generic-mm-pgtable-consolidate-zero-page-helpers.patch

