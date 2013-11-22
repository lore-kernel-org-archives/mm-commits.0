From: akpm@linux-foundation.org
Subject: [merged] x86-mm-do-not-leak-page-ptl-for-pmd-page-tables.patch
 removed from -mm tree
Date: Fri, 22 Nov 2013 13:22:03 -0800
Message-ID: <528fcafb.6xsFpibA5IJt8nmt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab3KVVWE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 16:22:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peterz@infradead.org, mingo@redhat.com, avagin@openvz.org, kirill.shutemov@linux.intel.com

Subject: [merged] x86-mm-do-not-leak-page-ptl-for-pmd-page-tables.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,avagin@openvz.org,mingo@redhat.com,peterz@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 13:22:03 -0800


The patch titled
     Subject: x86, mm: do not leak page->ptl for pmd page tables
has been removed from the -mm tree.  Its filename was
     x86-mm-do-not-leak-page-ptl-for-pmd-page-tables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: x86, mm: do not leak page->ptl for pmd page tables

There are two code paths how page with pmd page table can be freed:
pmd_free() and pmd_free_tlb().

I've missed the second one and didn't add page table destructor call
there.  It leads to leak of page->ptl for pmd page tables, if dynamically
allocated page->ptl is in use.

The patch adds the missed destructor and modifies documentation
accordingly.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Andrey Vagin <avagin@openvz.org>
Tested-by: Andrey Vagin <avagin@openvz.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/split_page_table_lock |    6 +++---
 arch/x86/mm/pgtable.c                  |    4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff -puN Documentation/vm/split_page_table_lock~x86-mm-do-not-leak-page-ptl-for-pmd-page-tables Documentation/vm/split_page_table_lock
--- a/Documentation/vm/split_page_table_lock~x86-mm-do-not-leak-page-ptl-for-pmd-page-tables
+++ a/Documentation/vm/split_page_table_lock
@@ -63,9 +63,9 @@ levels.
 PMD split lock enabling requires pgtable_pmd_page_ctor() call on PMD table
 allocation and pgtable_pmd_page_dtor() on freeing.
 
-Allocation usually happens in pmd_alloc_one(), freeing in pmd_free(), but
-make sure you cover all PMD table allocation / freeing paths: i.e X86_PAE
-preallocate few PMDs on pgd_alloc().
+Allocation usually happens in pmd_alloc_one(), freeing in pmd_free() and
+pmd_free_tlb(), but make sure you cover all PMD table allocation / freeing
+paths: i.e X86_PAE preallocate few PMDs on pgd_alloc().
 
 With everything in place you can set CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK.
 
diff -puN arch/x86/mm/pgtable.c~x86-mm-do-not-leak-page-ptl-for-pmd-page-tables arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c~x86-mm-do-not-leak-page-ptl-for-pmd-page-tables
+++ a/arch/x86/mm/pgtable.c
@@ -61,6 +61,7 @@ void ___pte_free_tlb(struct mmu_gather *
 #if PAGETABLE_LEVELS > 2
 void ___pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
 {
+	struct page *page = virt_to_page(pmd);
 	paravirt_release_pmd(__pa(pmd) >> PAGE_SHIFT);
 	/*
 	 * NOTE! For PAE, any changes to the top page-directory-pointer-table
@@ -69,7 +70,8 @@ void ___pmd_free_tlb(struct mmu_gather *
 #ifdef CONFIG_X86_PAE
 	tlb->need_flush_all = 1;
 #endif
-	tlb_remove_page(tlb, virt_to_page(pmd));
+	pgtable_pmd_page_dtor(page);
+	tlb_remove_page(tlb, page);
 }
 
 #if PAGETABLE_LEVELS > 3
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch

