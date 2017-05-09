From: akpm@linux-foundation.org
Subject: [merged]
 mm-huge_memory-deposit-a-pgtable-for-dax-pmd-faults-when-required.patch
 removed from -mm tree
Date: Tue, 09 May 2017 11:04:22 -0700
Message-ID: <20170509180422.b0nZW77Zi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35660 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751838AbdEISEY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:04:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, arbab@linux.vnet.ibm.com, bsingharora@gmail.com, heiko.carstens@de.ibm.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, oohall@gmail.com, schwidefsky@de.ibm.com


The patch titled
     Subject: mm/huge_memory.c: deposit a pgtable for DAX PMD faults when required
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-deposit-a-pgtable-for-dax-pmd-faults-when-required.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Oliver O'Halloran" <oohall@gmail.com>
Subject: mm/huge_memory.c: deposit a pgtable for DAX PMD faults when required

Although all architectures use a deposited page table for THP on anonymous VMAs
some architectures (s390 and powerpc) require the deposited storage even for
file backed VMAs due to quirks of their MMUs. This patch adds support for
depositing a table in DAX PMD fault handling path for archs that require it.
Other architectures should see no functional changes.

Link: http://lkml.kernel.org/r/20170411174233.21902-3-oohall@gmail.com
Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: linux-nvdimm@ml01.01.org
Cc: Oliver O'Halloran <oohall@gmail.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-huge_memory-deposit-a-pgtable-for-dax-pmd-faults-when-required mm/huge_memory.c
--- a/mm/huge_memory.c~mm-huge_memory-deposit-a-pgtable-for-dax-pmd-faults-when-required
+++ a/mm/huge_memory.c
@@ -715,7 +715,8 @@ int do_huge_pmd_anonymous_page(struct vm
 }
 
 static void insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
-		pmd_t *pmd, pfn_t pfn, pgprot_t prot, bool write)
+		pmd_t *pmd, pfn_t pfn, pgprot_t prot, bool write,
+		pgtable_t pgtable)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t entry;
@@ -729,6 +730,12 @@ static void insert_pfn_pmd(struct vm_are
 		entry = pmd_mkyoung(pmd_mkdirty(entry));
 		entry = maybe_pmd_mkwrite(entry, vma);
 	}
+
+	if (pgtable) {
+		pgtable_trans_huge_deposit(mm, pmd, pgtable);
+		atomic_long_inc(&mm->nr_ptes);
+	}
+
 	set_pmd_at(mm, addr, pmd, entry);
 	update_mmu_cache_pmd(vma, addr, pmd);
 	spin_unlock(ptl);
@@ -738,6 +745,7 @@ int vmf_insert_pfn_pmd(struct vm_area_st
 			pmd_t *pmd, pfn_t pfn, bool write)
 {
 	pgprot_t pgprot = vma->vm_page_prot;
+	pgtable_t pgtable = NULL;
 	/*
 	 * If we had pmd_special, we could avoid all these restrictions,
 	 * but we need to be consistent with PTEs and architectures that
@@ -752,9 +760,15 @@ int vmf_insert_pfn_pmd(struct vm_area_st
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return VM_FAULT_SIGBUS;
 
+	if (arch_needs_pgtable_deposit()) {
+		pgtable = pte_alloc_one(vma->vm_mm, addr);
+		if (!pgtable)
+			return VM_FAULT_OOM;
+	}
+
 	track_pfn_insert(vma, &pgprot, pfn);
 
-	insert_pfn_pmd(vma, addr, pmd, pfn, pgprot, write);
+	insert_pfn_pmd(vma, addr, pmd, pfn, pgprot, write, pgtable);
 	return VM_FAULT_NOPAGE;
 }
 EXPORT_SYMBOL_GPL(vmf_insert_pfn_pmd);
@@ -1611,6 +1625,8 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 			tlb->fullmm);
 	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 	if (vma_is_dax(vma)) {
+		if (arch_needs_pgtable_deposit())
+			zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
 		if (is_huge_zero_pmd(orig_pmd))
 			tlb_remove_page_size(tlb, pmd_page(orig_pmd), HPAGE_PMD_SIZE);
_

Patches currently in -mm which might be from oohall@gmail.com are


