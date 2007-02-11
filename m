From: akpm@linux-foundation.org
Subject: - m32r-fix-do_page_fault-and-update_mmu_cache.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:47:35 -0800
Message-ID: <200702112247.l1BMlZ5U015561@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59631 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932643AbXBKWrl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:47:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: takata@linux-m32r.org, inaoka@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     m32r: fix do_page_fault and update_mmu_cache
has been removed from the -mm tree.  Its filename was
     m32r-fix-do_page_fault-and-update_mmu_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: m32r: fix do_page_fault and update_mmu_cache
From: Hirokazu Takata <takata@linux-m32r.org>

Fix do_page_fault and update_mmu_cache.

  * Fix do_page_fault (vmalloc_fault:) to pass error_code correctly
    to update_mmu_cache by using a thread-fault code for all m32r chips.

  * Fix update_mmu_cache for OPSP chip
    - #ifdef CONFIG_CHIP_OPSP portion is a workaround of OPSP;
      Add a notfound-case operation to update_mmu_cache for OPSP
      like other m32r chip.
    - Fix pte_data that was not initialized if no entry found.

Signed-off-by: Kazuhiro Inaoka <inaoka@linux-m32r.org>
Signed-off-by: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/mm/fault.c |   40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff -puN arch/m32r/mm/fault.c~m32r-fix-do_page_fault-and-update_mmu_cache arch/m32r/mm/fault.c
--- a/arch/m32r/mm/fault.c~m32r-fix-do_page_fault-and-update_mmu_cache
+++ a/arch/m32r/mm/fault.c
@@ -362,8 +362,10 @@ vmalloc_fault:
 		if (!pte_present(*pte_k))
 			goto no_context;
 
-		addr = (address & PAGE_MASK) | (error_code & ACE_INSTRUCTION);
+		addr = (address & PAGE_MASK);
+		set_thread_fault_code(error_code);
 		update_mmu_cache(NULL, addr, *pte_k);
+		set_thread_fault_code(0);
 		return;
 	}
 }
@@ -377,7 +379,7 @@ vmalloc_fault:
 void update_mmu_cache(struct vm_area_struct *vma, unsigned long vaddr,
 	pte_t pte)
 {
-	unsigned long *entry1, *entry2;
+	volatile unsigned long *entry1, *entry2;
 	unsigned long pte_data, flags;
 	unsigned int *entry_dat;
 	int inst = get_thread_fault_code() & ACE_INSTRUCTION;
@@ -391,30 +393,26 @@ void update_mmu_cache(struct vm_area_str
 
 	vaddr = (vaddr & PAGE_MASK) | get_asid();
 
+	pte_data = pte_val(pte);
+
 #ifdef CONFIG_CHIP_OPSP
 	entry1 = (unsigned long *)ITLB_BASE;
-	for(i = 0 ; i < NR_TLB_ENTRIES; i++) {
-	        if(*entry1++ == vaddr) {
-	                pte_data = pte_val(pte);
-	                set_tlb_data(entry1, pte_data);
-	                break;
-	        }
-	        entry1++;
+	for (i = 0; i < NR_TLB_ENTRIES; i++) {
+		if (*entry1++ == vaddr) {
+			set_tlb_data(entry1, pte_data);
+			break;
+		}
+		entry1++;
 	}
 	entry2 = (unsigned long *)DTLB_BASE;
-	for(i = 0 ; i < NR_TLB_ENTRIES ; i++) {
-	        if(*entry2++ == vaddr) {
-	                pte_data = pte_val(pte);
-	                set_tlb_data(entry2, pte_data);
-	                break;
-	        }
-	        entry2++;
+	for (i = 0; i < NR_TLB_ENTRIES; i++) {
+		if (*entry2++ == vaddr) {
+			set_tlb_data(entry2, pte_data);
+			break;
+		}
+		entry2++;
 	}
-	local_irq_restore(flags);
-	return;
 #else
-	pte_data = pte_val(pte);
-
 	/*
 	 * Update TLB entries
 	 *  entry1: ITLB entry address
@@ -439,6 +437,7 @@ void update_mmu_cache(struct vm_area_str
 		"i" (MSVA_offset), "i" (MTOP_offset), "i" (MIDXI_offset)
 		: "r4", "memory"
 	);
+#endif
 
 	if ((!inst && entry2 >= DTLB_END) || (inst && entry1 >= ITLB_END))
 		goto notfound;
@@ -482,7 +481,6 @@ notfound:
 	set_tlb_data(entry1, pte_data);
 
 	goto found;
-#endif
 }
 
 /*======================================================================*
_

Patches currently in -mm which might be from takata@linux-m32r.org are

origin.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-m32r.patch
