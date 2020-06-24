From: akpm@linux-foundation.org
Subject: + mm-set-page-fault-address-for-update_mmu_cache_pmd.patch
 added to -mm tree
Date: Wed, 24 Jun 2020 12:52:34 -0700
Message-ID: <20200624195234.o44gZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406243AbgFXTwf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 15:52:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tsbogend@alpha.franken.de, rppt@linux.ibm.com, ralf@linux-mips.org, paulburton@kernel.org, mike.kravetz@oracle.com, kirill.shutemov@linux.intel.com, dansilsby@gmail.com, anshuman.khandual@arm.com, maobibo@loongson.cn


The patch titled
     Subject: mm: set page fault address for update_mmu_cache_pmd()
has been added to the -mm tree.  Its filename is
     mm-set-page-fault-address-for-update_mmu_cache_pmd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-set-page-fault-address-for-update_mmu_cache_pmd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-set-page-fault-address-for-update_mmu_cache_pmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bibo Mao <maobibo@loongson.cn>
Subject: mm: set page fault address for update_mmu_cache_pmd()

update_mmu_cache_pmd is used to update tlb for the pmd entry by software. 
On MIPS system, the tlb entry indexed by page fault address maybe exists
already, only that tlb entry may be small page, also it may be huge page. 
Before updating pmd entry with huge page size, older tlb entry need to be
invalidated.

Here page fault address is passed to function update_mmu_cache_pmd, rather
than pmd huge page start address.  The page fault address can be used for
invalidating older tlb entry.

Link: http://lkml.kernel.org/r/1592990792-1923-1-git-send-email-maobibo@loongson.cn
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Paul Burton <paulburton@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Daniel Silsby <dansilsby@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/pgtable.h |    9 +++++++++
 mm/huge_memory.c                |    7 ++++---
 mm/memory.c                     |    2 +-
 3 files changed, 14 insertions(+), 4 deletions(-)

--- a/arch/mips/include/asm/pgtable.h~mm-set-page-fault-address-for-update_mmu_cache_pmd
+++ a/arch/mips/include/asm/pgtable.h
@@ -554,11 +554,20 @@ static inline void update_mmu_cache(stru
 #define	__HAVE_ARCH_UPDATE_MMU_TLB
 #define update_mmu_tlb	update_mmu_cache
 
+extern void local_flush_tlb_page(struct vm_area_struct *vma,
+				unsigned long page);
 static inline void update_mmu_cache_pmd(struct vm_area_struct *vma,
 	unsigned long address, pmd_t *pmdp)
 {
 	pte_t pte = *(pte_t *)pmdp;
 
+	/*
+	 * If pmd_none is true, older tlb entry will be normal page.
+	 * here to invalidate older tlb entry indexed by address
+	 * parameter address must be page fault address rather than
+	 * start address of pmd huge page
+	 */
+	local_flush_tlb_page(vma, address);
 	__update_tlb(vma, address, pte);
 }
 
--- a/mm/huge_memory.c~mm-set-page-fault-address-for-update_mmu_cache_pmd
+++ a/mm/huge_memory.c
@@ -780,6 +780,7 @@ static void insert_pfn_pmd(struct vm_are
 		pgtable_t pgtable)
 {
 	struct mm_struct *mm = vma->vm_mm;
+	unsigned long start = addr & PMD_MASK;
 	pmd_t entry;
 	spinlock_t *ptl;
 
@@ -792,7 +793,7 @@ static void insert_pfn_pmd(struct vm_are
 			}
 			entry = pmd_mkyoung(*pmd);
 			entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
-			if (pmdp_set_access_flags(vma, addr, pmd, entry, 1))
+			if (pmdp_set_access_flags(vma, start, pmd, entry, 1))
 				update_mmu_cache_pmd(vma, addr, pmd);
 		}
 
@@ -813,7 +814,7 @@ static void insert_pfn_pmd(struct vm_are
 		pgtable = NULL;
 	}
 
-	set_pmd_at(mm, addr, pmd, entry);
+	set_pmd_at(mm, start, pmd, entry);
 	update_mmu_cache_pmd(vma, addr, pmd);
 
 out_unlock:
@@ -864,7 +865,7 @@ vm_fault_t vmf_insert_pfn_pmd_prot(struc
 
 	track_pfn_insert(vma, &pgprot, pfn);
 
-	insert_pfn_pmd(vma, addr, vmf->pmd, pfn, pgprot, write, pgtable);
+	insert_pfn_pmd(vma, vmf->address, vmf->pmd, pfn, pgprot, write, pgtable);
 	return VM_FAULT_NOPAGE;
 }
 EXPORT_SYMBOL_GPL(vmf_insert_pfn_pmd_prot);
--- a/mm/memory.c~mm-set-page-fault-address-for-update_mmu_cache_pmd
+++ a/mm/memory.c
@@ -3606,7 +3606,7 @@ static vm_fault_t do_set_pmd(struct vm_f
 
 	set_pmd_at(vma->vm_mm, haddr, vmf->pmd, entry);
 
-	update_mmu_cache_pmd(vma, haddr, vmf->pmd);
+	update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
 
 	/* fault is handled */
 	ret = 0;
_

Patches currently in -mm which might be from maobibo@loongson.cn are

mm-set-page-fault-address-for-update_mmu_cache_pmd.patch
mm-huge_memoryc-update-tlb-entry-if-pmd-is-changed.patch
mips-do-not-call-flush_tlb_all-when-setting-pmd-entry.patch
