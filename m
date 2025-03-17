Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4BA215782
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188299; cv=none; b=kboJLqsgxPkF2e56TfLjmCmDixDfNh6joh2j/hm9BUn5Tg5QMcCDs4hehVnkPFo0qjQJNhehwkZYu6Cu6R04344+I4xWqTR3PvPiF5wjjPNZKEKxiyOorDCS9I96t2QjLi/xWlVIoZ7b5YmN2CGvo7m6t2SFRcbrQqEfxZxW4jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188299; c=relaxed/simple;
	bh=8VM+P0JCXZkW7Fp/bAI9ltDgDDvxfbhMtxmZfARo9do=;
	h=Date:To:From:Subject:Message-Id; b=aU++hS43cxh7OkNjr2xADSo+OMc9mR9bS5waUick8s4rEWdmNN45mgvWZrU5wvd3dKkwhnsbv6RfaOBQNtSj4KqkMhyTCaN6hcvLaREMSW2g0l5kdYGvVisiuIXTXc9BR4smS393zpw7JR4xZy9w9AXERNgzX5TlGNcVimYOSCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s1XRHAqR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s1XRHAqR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A95C4CEEC;
	Mon, 17 Mar 2025 05:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188299;
	bh=8VM+P0JCXZkW7Fp/bAI9ltDgDDvxfbhMtxmZfARo9do=;
	h=Date:To:From:Subject:From;
	b=s1XRHAqRGWNBYKNO/qrTfd0bkP5V0NAV/nnzmRQTWFQlUJgj5/dIsVA5SfsrIc2eH
	 3tcxURTcpEDZqOVZeh5rt4JGiEGKCH+mYi8XyrtrhhGkJS0orTGeiyfPoQ3+doEzUZ
	 b1MqzSSna7HAU35bVOA7HmK5ZDueHYt96Gr1wC5M=
Date: Sun, 16 Mar 2025 22:11:38 -0700
To: mm-commits@vger.kernel.org,zhengtangquan@oppo.com,yosryahmed@google.com,ying.huang@intel.com,yangyicong@hisilicon.com,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shahuang@redhat.com,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,mingo@redhat.com,mfo@canonical.com,mark.rutland@arm.com,lorenzo.stoakes@oracle.com,kirill.shutemov@linux.intel.com,kasong@tencent.com,ioworker0@gmail.com,hpa@zytor.com,gshan@redhat.com,david@redhat.com,dave.hansen@linux.intel.com,chrisl@kernel.org,catalin.marinas@arm.com,bp@alien8.de,baolin.wang@linux.alibaba.com,aou@eecs.berkeley.edu,anshuman.khandual@arm.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-support-tlbbatch-flush-for-a-range-of-ptes.patch removed from -mm tree
Message-Id: <20250317051139.45A95C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: support tlbbatch flush for a range of PTEs
has been removed from the -mm tree.  Its filename was
     mm-support-tlbbatch-flush-for-a-range-of-ptes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: support tlbbatch flush for a range of PTEs
Date: Fri, 14 Feb 2025 22:30:13 +1300

This patch lays the groundwork for supporting batch PTE unmapping in
try_to_unmap_one().  It introduces range handling for TLB batch flushing,
with the range currently set to the size of PAGE_SIZE.

The function __flush_tlb_range_nosync() is architecture-specific and is
only used within arch/arm64.  This function requires the mm structure
instead of the vma structure.  To allow its reuse by
arch_tlbbatch_add_pending(), which operates with mm but not vma, this
patch modifies the argument of __flush_tlb_range_nosync() to take mm as
its parameter.

Link: https://lkml.kernel.org/r/20250214093015.51024-3-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shaoqin Huang <shahuang@redhat.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chis Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mauricio Faria de Oliveira <mfo@canonical.com>
Cc: Tangquan Zheng <zhengtangquan@oppo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/tlbflush.h |   23 +++++++++++------------
 arch/arm64/mm/contpte.c           |    2 +-
 arch/riscv/include/asm/tlbflush.h |    3 +--
 arch/riscv/mm/tlbflush.c          |    3 +--
 arch/x86/include/asm/tlbflush.h   |    3 +--
 mm/rmap.c                         |   10 +++++-----
 6 files changed, 20 insertions(+), 24 deletions(-)

--- a/arch/arm64/include/asm/tlbflush.h~mm-support-tlbbatch-flush-for-a-range-of-ptes
+++ a/arch/arm64/include/asm/tlbflush.h
@@ -322,13 +322,6 @@ static inline bool arch_tlbbatch_should_
 	return true;
 }
 
-static inline void arch_tlbbatch_add_pending(struct arch_tlbflush_unmap_batch *batch,
-					     struct mm_struct *mm,
-					     unsigned long uaddr)
-{
-	__flush_tlb_page_nosync(mm, uaddr);
-}
-
 /*
  * If mprotect/munmap/etc occurs during TLB batched flushing, we need to
  * synchronise all the TLBI issued with a DSB to avoid the race mentioned in
@@ -448,7 +441,7 @@ static inline bool __flush_tlb_range_lim
 	return false;
 }
 
-static inline void __flush_tlb_range_nosync(struct vm_area_struct *vma,
+static inline void __flush_tlb_range_nosync(struct mm_struct *mm,
 				     unsigned long start, unsigned long end,
 				     unsigned long stride, bool last_level,
 				     int tlb_level)
@@ -460,12 +453,12 @@ static inline void __flush_tlb_range_nos
 	pages = (end - start) >> PAGE_SHIFT;
 
 	if (__flush_tlb_range_limit_excess(start, end, pages, stride)) {
-		flush_tlb_mm(vma->vm_mm);
+		flush_tlb_mm(mm);
 		return;
 	}
 
 	dsb(ishst);
-	asid = ASID(vma->vm_mm);
+	asid = ASID(mm);
 
 	if (last_level)
 		__flush_tlb_range_op(vale1is, start, pages, stride, asid,
@@ -474,7 +467,7 @@ static inline void __flush_tlb_range_nos
 		__flush_tlb_range_op(vae1is, start, pages, stride, asid,
 				     tlb_level, true, lpa2_is_enabled());
 
-	mmu_notifier_arch_invalidate_secondary_tlbs(vma->vm_mm, start, end);
+	mmu_notifier_arch_invalidate_secondary_tlbs(mm, start, end);
 }
 
 static inline void __flush_tlb_range(struct vm_area_struct *vma,
@@ -482,7 +475,7 @@ static inline void __flush_tlb_range(str
 				     unsigned long stride, bool last_level,
 				     int tlb_level)
 {
-	__flush_tlb_range_nosync(vma, start, end, stride,
+	__flush_tlb_range_nosync(vma->vm_mm, start, end, stride,
 				 last_level, tlb_level);
 	dsb(ish);
 }
@@ -533,6 +526,12 @@ static inline void __flush_tlb_kernel_pg
 	dsb(ish);
 	isb();
 }
+
+static inline void arch_tlbbatch_add_pending(struct arch_tlbflush_unmap_batch *batch,
+		struct mm_struct *mm, unsigned long start, unsigned long end)
+{
+	__flush_tlb_range_nosync(mm, start, end, PAGE_SIZE, true, 3);
+}
 #endif
 
 #endif
--- a/arch/arm64/mm/contpte.c~mm-support-tlbbatch-flush-for-a-range-of-ptes
+++ a/arch/arm64/mm/contpte.c
@@ -335,7 +335,7 @@ int contpte_ptep_clear_flush_young(struc
 		 * eliding the trailing DSB applies here.
 		 */
 		addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
-		__flush_tlb_range_nosync(vma, addr, addr + CONT_PTE_SIZE,
+		__flush_tlb_range_nosync(vma->vm_mm, addr, addr + CONT_PTE_SIZE,
 					 PAGE_SIZE, true, 3);
 	}
 
--- a/arch/riscv/include/asm/tlbflush.h~mm-support-tlbbatch-flush-for-a-range-of-ptes
+++ a/arch/riscv/include/asm/tlbflush.h
@@ -60,8 +60,7 @@ void flush_pmd_tlb_range(struct vm_area_
 
 bool arch_tlbbatch_should_defer(struct mm_struct *mm);
 void arch_tlbbatch_add_pending(struct arch_tlbflush_unmap_batch *batch,
-			       struct mm_struct *mm,
-			       unsigned long uaddr);
+		struct mm_struct *mm, unsigned long start, unsigned long end);
 void arch_flush_tlb_batched_pending(struct mm_struct *mm);
 void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch);
 
--- a/arch/riscv/mm/tlbflush.c~mm-support-tlbbatch-flush-for-a-range-of-ptes
+++ a/arch/riscv/mm/tlbflush.c
@@ -186,8 +186,7 @@ bool arch_tlbbatch_should_defer(struct m
 }
 
 void arch_tlbbatch_add_pending(struct arch_tlbflush_unmap_batch *batch,
-			       struct mm_struct *mm,
-			       unsigned long uaddr)
+		struct mm_struct *mm, unsigned long start, unsigned long end)
 {
 	cpumask_or(&batch->cpumask, &batch->cpumask, mm_cpumask(mm));
 }
--- a/arch/x86/include/asm/tlbflush.h~mm-support-tlbbatch-flush-for-a-range-of-ptes
+++ a/arch/x86/include/asm/tlbflush.h
@@ -279,8 +279,7 @@ static inline u64 inc_mm_tlb_gen(struct
 }
 
 static inline void arch_tlbbatch_add_pending(struct arch_tlbflush_unmap_batch *batch,
-					     struct mm_struct *mm,
-					     unsigned long uaddr)
+		struct mm_struct *mm, unsigned long start, unsigned long end)
 {
 	inc_mm_tlb_gen(mm);
 	cpumask_or(&batch->cpumask, &batch->cpumask, mm_cpumask(mm));
--- a/mm/rmap.c~mm-support-tlbbatch-flush-for-a-range-of-ptes
+++ a/mm/rmap.c
@@ -672,7 +672,7 @@ void try_to_unmap_flush_dirty(void)
 	(TLB_FLUSH_BATCH_PENDING_MASK / 2)
 
 static void set_tlb_ubc_flush_pending(struct mm_struct *mm, pte_t pteval,
-				      unsigned long uaddr)
+		unsigned long start, unsigned long end)
 {
 	struct tlbflush_unmap_batch *tlb_ubc = &current->tlb_ubc;
 	int batch;
@@ -681,7 +681,7 @@ static void set_tlb_ubc_flush_pending(st
 	if (!pte_accessible(mm, pteval))
 		return;
 
-	arch_tlbbatch_add_pending(&tlb_ubc->arch, mm, uaddr);
+	arch_tlbbatch_add_pending(&tlb_ubc->arch, mm, start, end);
 	tlb_ubc->flush_required = true;
 
 	/*
@@ -757,7 +757,7 @@ void flush_tlb_batched_pending(struct mm
 }
 #else
 static void set_tlb_ubc_flush_pending(struct mm_struct *mm, pte_t pteval,
-				      unsigned long uaddr)
+		unsigned long start, unsigned long end)
 {
 }
 
@@ -1887,7 +1887,7 @@ static bool try_to_unmap_one(struct foli
 				 */
 				pteval = ptep_get_and_clear(mm, address, pvmw.pte);
 
-				set_tlb_ubc_flush_pending(mm, pteval, address);
+				set_tlb_ubc_flush_pending(mm, pteval, address, address + PAGE_SIZE);
 			} else {
 				pteval = ptep_clear_flush(vma, address, pvmw.pte);
 			}
@@ -2270,7 +2270,7 @@ static bool try_to_migrate_one(struct fo
 				 */
 				pteval = ptep_get_and_clear(mm, address, pvmw.pte);
 
-				set_tlb_ubc_flush_pending(mm, pteval, address);
+				set_tlb_ubc_flush_pending(mm, pteval, address, address + PAGE_SIZE);
 			} else {
 				pteval = ptep_clear_flush(vma, address, pvmw.pte);
 			}
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are


