Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58584C64EC4
	for <mm-commits@archiver.kernel.org>; Mon,  6 Mar 2023 20:44:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjCFUow (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Mar 2023 15:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjCFUov (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Mar 2023 15:44:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73776422A
        for <mm-commits@vger.kernel.org>; Mon,  6 Mar 2023 12:44:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DC2DB80EC2
        for <mm-commits@vger.kernel.org>; Mon,  6 Mar 2023 20:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD24C4339B;
        Mon,  6 Mar 2023 20:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678135487;
        bh=VIvVgwyGW030QwSBqLlernag7LkKLwYIQDqQrgEVdGE=;
        h=Date:To:From:Subject:From;
        b=IJ/QUwvFsdvoLT/YHYVaZn2q/uAWiliWfMIVQsgsQ4W34K0e/1S2Uvura9seOoXHJ
         wCJa5fwpsc78EXate1vMzB8OsKafUyWqdMbf7xnsW70V9VoyfcMJex+twfomvL0udE
         ZxOFQUImy6yX4ydGWDL1Nhay8nSk5PRhrVwP8O3I=
Date:   Mon, 06 Mar 2023 12:44:46 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        tsbogend@alpha.franken.de, tglx@linutronix.de, npiggin@gmail.com,
        mpe@ellerman.id.au, mingo@redhat.com, david@redhat.com,
        dave.hansen@linux.intel.com, christophe.leroy@csgroup.eu,
        catalin.marinas@arm.com, bp@alien8.de, anshuman.khandual@arm.com,
        agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-pte-pointer-parameter-to-flush_tlb_fix_spurious_fault.patch added to mm-unstable branch
Message-Id: <20230306204447.0CD24C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add PTE pointer parameter to flush_tlb_fix_spurious_fault()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-pte-pointer-parameter-to-flush_tlb_fix_spurious_fault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-pte-pointer-parameter-to-flush_tlb_fix_spurious_fault.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Subject: mm: add PTE pointer parameter to flush_tlb_fix_spurious_fault()
Date: Mon, 6 Mar 2023 17:15:48 +0100

s390 can do more fine-grained handling of spurious TLB protection faults,
when there also is the PTE pointer available.

Therefore, pass on the PTE pointer to flush_tlb_fix_spurious_fault() as an
additional parameter.

This will add no functional change to other architectures, but those with
private flush_tlb_fix_spurious_fault() implementations need to be made
aware of the new parameter.

Link: https://lkml.kernel.org/r/20230306161548.661740-1-gerald.schaefer@linux.ibm.com
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>	[arm64]
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/arm64/include/asm/pgtable.h~mm-add-pte-pointer-parameter-to-flush_tlb_fix_spurious_fault
+++ a/arch/arm64/include/asm/pgtable.h
@@ -57,7 +57,7 @@ static inline bool arch_thp_swp_supporte
  * fault on one CPU which has been handled concurrently by another CPU
  * does not need to perform additional invalidation.
  */
-#define flush_tlb_fix_spurious_fault(vma, address) do { } while (0)
+#define flush_tlb_fix_spurious_fault(vma, address, ptep) do { } while (0)
 
 /*
  * ZERO_PAGE is a global shared page that is always zero: used
--- a/arch/mips/include/asm/pgtable.h~mm-add-pte-pointer-parameter-to-flush_tlb_fix_spurious_fault
+++ a/arch/mips/include/asm/pgtable.h
@@ -469,7 +469,8 @@ static inline pgprot_t pgprot_writecombi
 }
 
 static inline void flush_tlb_fix_spurious_fault(struct vm_area_struct *vma,
-						unsigned long address)
+						unsigned long address,
+						pte_t *ptep)
 {
 }
 
--- a/arch/powerpc/include/asm/book3s/64/tlbflush.h~mm-add-pte-pointer-parameter-to-flush_tlb_fix_spurious_fault
+++ a/arch/powerpc/include/asm/book3s/64/tlbflush.h
@@ -121,7 +121,8 @@ static inline void flush_tlb_page(struct
 
 #define flush_tlb_fix_spurious_fault flush_tlb_fix_spurious_fault
 static inline void flush_tlb_fix_spurious_fault(struct vm_area_struct *vma,
-						unsigned long address)
+						unsigned long address,
+						pte_t *ptep)
 {
 	/*
 	 * Book3S 64 does not require spurious fault flushes because the PTE
--- a/arch/s390/include/asm/pgtable.h~mm-add-pte-pointer-parameter-to-flush_tlb_fix_spurious_fault
+++ a/arch/s390/include/asm/pgtable.h
@@ -1239,7 +1239,8 @@ static inline int pte_allow_rdp(pte_t ol
 }
 
 static inline void flush_tlb_fix_spurious_fault(struct vm_area_struct *vma,
-						unsigned long address)
+						unsigned long address,
+						pte_t *ptep)
 {
 	/*
 	 * RDP might not have propagated the PTE protection reset to all CPUs,
@@ -1247,11 +1248,12 @@ static inline void flush_tlb_fix_spuriou
 	 * NOTE: This will also be called when a racing pagetable update on
 	 * another thread already installed the correct PTE. Both cases cannot
 	 * really be distinguished.
-	 * Therefore, only do the local TLB flush when RDP can be used, to avoid
-	 * unnecessary overhead.
+	 * Therefore, only do the local TLB flush when RDP can be used, and the
+	 * PTE does not have _PAGE_PROTECT set, to avoid unnecessary overhead.
+	 * A local RDP can be used to do the flush.
 	 */
-	if (MACHINE_HAS_RDP)
-		asm volatile("ptlb" : : : "memory");
+	if (MACHINE_HAS_RDP && !(pte_val(*ptep) & _PAGE_PROTECT))
+		__ptep_rdp(address, ptep, 0, 0, 1);
 }
 #define flush_tlb_fix_spurious_fault flush_tlb_fix_spurious_fault
 
--- a/arch/x86/include/asm/pgtable.h~mm-add-pte-pointer-parameter-to-flush_tlb_fix_spurious_fault
+++ a/arch/x86/include/asm/pgtable.h
@@ -1097,7 +1097,7 @@ static inline void ptep_set_wrprotect(st
 	clear_bit(_PAGE_BIT_RW, (unsigned long *)&ptep->pte);
 }
 
-#define flush_tlb_fix_spurious_fault(vma, address) do { } while (0)
+#define flush_tlb_fix_spurious_fault(vma, address, ptep) do { } while (0)
 
 #define mk_pmd(page, pgprot)   pfn_pmd(page_to_pfn(page), (pgprot))
 
--- a/include/linux/pgtable.h~mm-add-pte-pointer-parameter-to-flush_tlb_fix_spurious_fault
+++ a/include/linux/pgtable.h
@@ -817,7 +817,7 @@ static inline void arch_swap_restore(swp
 #endif
 
 #ifndef flush_tlb_fix_spurious_fault
-#define flush_tlb_fix_spurious_fault(vma, address) flush_tlb_page(vma, address)
+#define flush_tlb_fix_spurious_fault(vma, address, ptep) flush_tlb_page(vma, address)
 #endif
 
 /*
--- a/mm/memory.c~mm-add-pte-pointer-parameter-to-flush_tlb_fix_spurious_fault
+++ a/mm/memory.c
@@ -4956,7 +4956,8 @@ static vm_fault_t handle_pte_fault(struc
 		 * with threads.
 		 */
 		if (vmf->flags & FAULT_FLAG_WRITE)
-			flush_tlb_fix_spurious_fault(vmf->vma, vmf->address);
+			flush_tlb_fix_spurious_fault(vmf->vma, vmf->address,
+						     vmf->pte);
 	}
 unlock:
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
--- a/mm/pgtable-generic.c~mm-add-pte-pointer-parameter-to-flush_tlb_fix_spurious_fault
+++ a/mm/pgtable-generic.c
@@ -69,7 +69,7 @@ int ptep_set_access_flags(struct vm_area
 	int changed = !pte_same(*ptep, entry);
 	if (changed) {
 		set_pte_at(vma->vm_mm, address, ptep, entry);
-		flush_tlb_fix_spurious_fault(vma, address);
+		flush_tlb_fix_spurious_fault(vma, address, ptep);
 	}
 	return changed;
 }
_

Patches currently in -mm which might be from gerald.schaefer@linux.ibm.com are

mm-add-pte-pointer-parameter-to-flush_tlb_fix_spurious_fault.patch

