From: akpm@linux-foundation.org
Subject: [merged] mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:15:37 -0700
Message-ID: <20121009181537.B8A4A1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:62033 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871Ab2JISPi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:15:38 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so663107qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:15:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, aarcange@redhat.com, gerald.schaefer@de.ibm.com, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: Add and use update_mmu_cache_pmd() in transparent huge page code.
has been removed from the -mm tree.  Its filename was
     mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: implement update_mm_cache_pmd() for s390]
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/pgtable.h   |    1 +
 arch/x86/include/asm/pgtable_32.h |    1 +
 arch/x86/include/asm/pgtable_64.h |    1 +
 mm/huge_memory.c                  |    6 +++---
 4 files changed, 6 insertions(+), 3 deletions(-)

diff -puN arch/s390/include/asm/pgtable.h~mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code arch/s390/include/asm/pgtable.h
--- a/arch/s390/include/asm/pgtable.h~mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code
+++ a/arch/s390/include/asm/pgtable.h
@@ -42,6 +42,7 @@ extern void fault_init(void);
  * tables contain all the necessary information.
  */
 #define update_mmu_cache(vma, address, ptep)     do { } while (0)
+#define update_mmu_cache_pmd(vma, address, ptep) do { } while (0)
 
 /*
  * ZERO_PAGE is a global shared page that is always zero; used
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
@@ -900,7 +900,7 @@ int do_huge_pmd_wp_page(struct mm_struct
 		entry = pmd_mkyoung(orig_pmd);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 		if (pmdp_set_access_flags(vma, haddr, pmd, entry,  1))
-			update_mmu_cache(vma, address, pmd);
+			update_mmu_cache_pmd(vma, address, pmd);
 		ret |= VM_FAULT_WRITE;
 		goto out_unlock;
 	}
@@ -956,7 +956,7 @@ int do_huge_pmd_wp_page(struct mm_struct
 		pmdp_clear_flush(vma, haddr, pmd);
 		page_add_new_anon_rmap(new_page, vma, haddr);
 		set_pmd_at(mm, haddr, pmd, entry);
-		update_mmu_cache(vma, address, pmd);
+		update_mmu_cache_pmd(vma, address, pmd);
 		page_remove_rmap(page);
 		put_page(page);
 		ret |= VM_FAULT_WRITE;
@@ -2041,7 +2041,7 @@ static void collapse_huge_page(struct mm
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
compat-generic-compat_sys_sched_rr_get_interval-implementation.patch

