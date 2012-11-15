From: akpm@linux-foundation.org
Subject: + thp-do_huge_pmd_wp_page-handle-huge-zero-page-v6.patch added to -mm tree
Date: Thu, 15 Nov 2012 12:49:30 -0800
Message-ID: <20121115204931.35AC3100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:54636 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab2KOVlr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Nov 2012 16:41:47 -0500
Received: by mail-vc0-f202.google.com with SMTP id fy27so226697vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Nov 2012 13:41:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, hpa@linux.intel.com, mel@csn.ul.ie, rientjes@google.com


The patch titled
     Subject: thp-do_huge_pmd_wp_page-handle-huge-zero-page-v6
has been added to the -mm tree.  Its filename is
     thp-do_huge_pmd_wp_page-handle-huge-zero-page-v6.patch

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
@@ -1008,25 +1008,6 @@ unlock:
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
@@ -1061,7 +1042,7 @@ static int do_huge_pmd_wp_zero_page_fall
 	pmdp_clear_flush(vma, haddr, pmd);
 	/* leave pmd empty until pte is filled */
 
-	pgtable = get_pmd_huge_pte(mm);
+	pgtable = pgtable_trans_huge_withdraw(mm);
 	pmd_populate(mm, &_pmd, pgtable);
 
 	for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
@@ -1276,7 +1257,6 @@ alloc:
 		goto out_mn;
 	} else {
 		pmd_t entry;
-
 		entry = mk_huge_pmd(new_page, vma);
 		pmdp_clear_flush(vma, haddr, pmd);
 		page_add_new_anon_rmap(new_page, vma, haddr);
@@ -1284,7 +1264,7 @@ alloc:
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

linux-next.patch
mm-use-is_enabledconfig_numa-instead-of-numa_build.patch
mm-use-is_enabledconfig_compaction-instead-of-compaction_build.patch
thp-huge-zero-page-basic-preparation.patch
thp-huge-zero-page-basic-preparation-v6.patch
thp-zap_huge_pmd-zap-huge-zero-pmd.patch
thp-copy_huge_pmd-copy-huge-zero-page.patch
thp-copy_huge_pmd-copy-huge-zero-page-v6.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page-v6.patch
thp-change_huge_pmd-keep-huge-zero-page-write-protected.patch
thp-change-split_huge_page_pmd-interface.patch
thp-change-split_huge_page_pmd-interface-v6.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
thp-implement-splitting-pmd-for-huge-zero-page-v6.patch
thp-setup-huge-zero-page-on-non-write-page-fault.patch
thp-lazy-huge-zero-page-allocation.patch
thp-implement-refcounting-for-huge-zero-page.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events-v6.patch
thp-introduce-sysfs-knob-to-disable-huge-zero-page.patch

