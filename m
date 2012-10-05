From: akpm@linux-foundation.org
Subject: + mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code.patch added to -mm tree
Date: Fri, 05 Oct 2012 15:01:00 -0700
Message-ID: <20121005220101.4B58E1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:52773 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459Ab2JEWBC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 18:01:02 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so249417vbi.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 15:01:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davem@davemloft.net, aarcange@redhat.com, gerald.schaefer@de.ibm.com, hannes@cmpxchg.org


The patch titled
     Subject: mm: Add and use update_mmu_cache_pmd() in transparent huge page code.
has been added to the -mm tree.  Its filename is
     mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Miller <davem@davemloft.net>
Subject: mm: Add and use update_mmu_cache_pmd() in transparent huge page code.

The transparent huge page code passes a PMD pointer in as the third
argument of update_mmu_cache(), which expects a PTE pointer.

This never got noticed because X86 implements update_mmu_cache() as a
macro and thus we don't get any type checking, and X86 is the only
architecture which supports transparent huge pages currently.

Before other architectures can support transparent huge pages properly we
need to add a new interface which will take a PMD pointer as the third
argument rather than a PTE pointer.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable_32.h |    1 +
 arch/x86/include/asm/pgtable_64.h |    1 +
 mm/huge_memory.c                  |    6 +++---
 3 files changed, 5 insertions(+), 3 deletions(-)

diff -puN arch/x86/include/asm/pgtable_32.h~mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code arch/x86/include/asm/pgtable_32.h
--- a/arch/x86/include/asm/pgtable_32.h~mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code
+++ a/arch/x86/include/asm/pgtable_32.h
@@ -71,6 +71,7 @@ do {						\
  * tables contain all the necessary information.
  */
 #define update_mmu_cache(vma, address, ptep) do { } while (0)
+#define update_mmu_cache_pmd(vma, address, pmd) do { } while (0)
 
 #endif /* !__ASSEMBLY__ */
 
diff -puN arch/x86/include/asm/pgtable_64.h~mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h~mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code
+++ a/arch/x86/include/asm/pgtable_64.h
@@ -143,6 +143,7 @@ static inline int pgd_large(pgd_t pgd) {
 #define pte_unmap(pte) ((void)(pte))/* NOP */
 
 #define update_mmu_cache(vma, address, ptep) do { } while (0)
+#define update_mmu_cache_pmd(vma, address, pmd) do { } while (0)
 
 /* Encode and de-code a swap entry */
 #if _PAGE_BIT_FILE < _PAGE_BIT_PROTNONE
diff -puN mm/huge_memory.c~mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code mm/huge_memory.c
--- a/mm/huge_memory.c~mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code
+++ a/mm/huge_memory.c
@@ -969,7 +969,7 @@ int do_huge_pmd_wp_page(struct mm_struct
 		entry = pmd_mkyoung(orig_pmd);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 		if (pmdp_set_access_flags(vma, haddr, pmd, entry,  1))
-			update_mmu_cache(vma, address, pmd);
+			update_mmu_cache_pmd(vma, address, pmd);
 		ret |= VM_FAULT_WRITE;
 		goto out_unlock;
 	}
@@ -1025,7 +1025,7 @@ int do_huge_pmd_wp_page(struct mm_struct
 		pmdp_clear_flush(vma, haddr, pmd);
 		page_add_new_anon_rmap(new_page, vma, haddr);
 		set_pmd_at(mm, haddr, pmd, entry);
-		update_mmu_cache(vma, address, pmd);
+		update_mmu_cache_pmd(vma, address, pmd);
 		page_remove_rmap(page);
 		put_page(page);
 		ret |= VM_FAULT_WRITE;
@@ -2108,7 +2108,7 @@ static void collapse_huge_page(struct mm
 	BUG_ON(!pmd_none(*pmd));
 	page_add_new_anon_rmap(new_page, vma, address);
 	set_pmd_at(mm, address, pmd, _pmd);
-	update_mmu_cache(vma, address, pmd);
+	update_mmu_cache_pmd(vma, address, pmd);
 	pgtable_trans_huge_deposit(mm, pgtable);
 	spin_unlock(&mm->page_table_lock);
 
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
linux-next.patch
kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option.patch
kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option.patch
kconfig-clean-up-the-long-arch-list-for-the-debug_bugverbose-config-option.patch
kconfig-clean-up-the-if-definedarch-list-for-exception-trace-sysctl-entry.patch
atomic-implement-generic-atomic_dec_if_positive.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
sparc64-only-support-4mb-huge-pages-and-8kb-base-pages.patch
sparc64-halve-the-size-of-pte-tables.patch
sparc64-eliminate-pte-table-memory-wastage.patch
sparc64-document-pgd-and-pmd-layout.patch
mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code.patch
mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code-fix.patch
mm-thp-use-more-portable-pmd-clearing-sequenece-in-zap_huge_pmd.patch
sparc64-support-transparent-huge-pages.patch
compat-generic-compat_sys_sched_rr_get_interval-implementation.patch

