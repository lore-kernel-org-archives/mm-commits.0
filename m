Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174B71DA4E
	for <mm-commits@vger.kernel.org>; Wed, 29 Jan 2025 04:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738123799; cv=none; b=EdeGWbnnZeQTC5R7sz8u82VN8t9Ppycq3YRCZKtWGUJInLxKsmsqmmYljfJju4+iFf5kZYqA6JE9467A5MyNAdd3kCJUsXx8NwIKTNSnXFBBXeYQL5ZT2VXLZ9SHqna24gdRUAy8BVt4q1suIymnANnSAPG47bKtkpkSFpyBEA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738123799; c=relaxed/simple;
	bh=6e/ST+eKXAdZ7XfcMMPIqoC0OtbL3iuRUBTQfEqNQOM=;
	h=Date:To:From:Subject:Message-Id; b=rCSEV13o035PoX7hBwbzYuM3JEWC7ky+guMoExvzvUiu8RYnLggTCaca0vwj4ZgDbGIAWiKXA8BWQmOBeGjNzTcviVhFv83vhAyCUyhOo+s5SkLsyJSqS5mHjXbk35QlBb61VzBLctSduwCWO/GzfDEC0g5kh5b2Zq/I3Z8+3Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UieHdUdS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UieHdUdS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7011FC4CED3;
	Wed, 29 Jan 2025 04:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738123798;
	bh=6e/ST+eKXAdZ7XfcMMPIqoC0OtbL3iuRUBTQfEqNQOM=;
	h=Date:To:From:Subject:From;
	b=UieHdUdS38XotMqW4G3GikkkKbPAK6DUs8L2ude3/Jbipu0Hg8wI8InBYcs1lH3us
	 U8HDS2S0HvM8DG582VZMebwWPy8fSgxhIJ7KpCP71r+jm9V/yjWUO5JissO7kX1Fd5
	 +Dcmw2mkDbaxr+MuFqm7Erc1IGhfs7SjkZqCzv5c=
Date: Tue, 28 Jan 2025 20:09:57 -0800
To: mm-commits@vger.kernel.org,zhengtangquan@oppo.com,yosryahmed@google.com,ying.huang@intel.com,yangyicong@hisilicon.com,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shahuang@redhat.com,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,mingo@redhat.com,mfo@canonical.com,mark.rutland@arm.com,lorenzo.stoakes@oracle.com,kirill.shutemov@linux.intel.com,kasong@tencent.com,ioworker0@gmail.com,hpa@zytor.com,gshan@redhat.com,david@redhat.com,dave.hansen@linux.intel.com,chrisl@kernel.org,catalin.marinas@arm.com,bp@alien8.de,baolin.wang@linux.alibaba.com,aou@eecs.berkeley.edu,anshuman.khandual@arm.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-support-tlbbatch-flush-for-a-range-of-ptes.patch added to mm-unstable branch
Message-Id: <20250129040958.7011FC4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: support tlbbatch flush for a range of PTEs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-support-tlbbatch-flush-for-a-range-of-ptes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-support-tlbbatch-flush-for-a-range-of-ptes.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: support tlbbatch flush for a range of PTEs
Date: Wed, 15 Jan 2025 16:38:06 +1300

This patch lays the groundwork for supporting batch PTE unmapping in
try_to_unmap_one().  It introduces range handling for TLB batch flushing,
with the range currently set to the size of PAGE_SIZE.

The function __flush_tlb_range_nosync() is architecture-specific and is
only used within arch/arm64.  This function requires the mm structure
instead of the vma structure.  To allow its reuse by
arch_tlbbatch_add_pending(), which operates with mm but not vma, this
patch modifies the argument of __flush_tlb_range_nosync() to take mm as
its parameter.

Link: https://lkml.kernel.org/r/20250115033808.40641-3-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Acked-by: Will Deacon <will@kernel.org>
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
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
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

 arch/arm64/include/asm/tlbflush.h |   25 +++++++++++++------------
 arch/arm64/mm/contpte.c           |    2 +-
 arch/riscv/include/asm/tlbflush.h |    5 +++--
 arch/riscv/mm/tlbflush.c          |    5 +++--
 arch/x86/include/asm/tlbflush.h   |    5 +++--
 mm/rmap.c                         |   12 +++++++-----
 6 files changed, 30 insertions(+), 24 deletions(-)

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
@@ -533,6 +526,14 @@ static inline void __flush_tlb_kernel_pg
 	dsb(ish);
 	isb();
 }
+
+static inline void arch_tlbbatch_add_pending(struct arch_tlbflush_unmap_batch *batch,
+		struct mm_struct *mm,
+		unsigned long start,
+		unsigned long end)
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
@@ -60,8 +60,9 @@ void flush_pmd_tlb_range(struct vm_area_
 
 bool arch_tlbbatch_should_defer(struct mm_struct *mm);
 void arch_tlbbatch_add_pending(struct arch_tlbflush_unmap_batch *batch,
-			       struct mm_struct *mm,
-			       unsigned long uaddr);
+		struct mm_struct *mm,
+		unsigned long start,
+		unsigned long end);
 void arch_flush_tlb_batched_pending(struct mm_struct *mm);
 void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch);
 
--- a/arch/riscv/mm/tlbflush.c~mm-support-tlbbatch-flush-for-a-range-of-ptes
+++ a/arch/riscv/mm/tlbflush.c
@@ -186,8 +186,9 @@ bool arch_tlbbatch_should_defer(struct m
 }
 
 void arch_tlbbatch_add_pending(struct arch_tlbflush_unmap_batch *batch,
-			       struct mm_struct *mm,
-			       unsigned long uaddr)
+		struct mm_struct *mm,
+		unsigned long start,
+		unsigned long end)
 {
 	cpumask_or(&batch->cpumask, &batch->cpumask, mm_cpumask(mm));
 }
--- a/arch/x86/include/asm/tlbflush.h~mm-support-tlbbatch-flush-for-a-range-of-ptes
+++ a/arch/x86/include/asm/tlbflush.h
@@ -278,8 +278,9 @@ static inline u64 inc_mm_tlb_gen(struct
 }
 
 static inline void arch_tlbbatch_add_pending(struct arch_tlbflush_unmap_batch *batch,
-					     struct mm_struct *mm,
-					     unsigned long uaddr)
+		struct mm_struct *mm,
+		unsigned long start,
+		unsigned long end)
 {
 	inc_mm_tlb_gen(mm);
 	cpumask_or(&batch->cpumask, &batch->cpumask, mm_cpumask(mm));
--- a/mm/rmap.c~mm-support-tlbbatch-flush-for-a-range-of-ptes
+++ a/mm/rmap.c
@@ -672,7 +672,8 @@ void try_to_unmap_flush_dirty(void)
 	(TLB_FLUSH_BATCH_PENDING_MASK / 2)
 
 static void set_tlb_ubc_flush_pending(struct mm_struct *mm, pte_t pteval,
-				      unsigned long uaddr)
+		unsigned long start,
+		unsigned long end)
 {
 	struct tlbflush_unmap_batch *tlb_ubc = &current->tlb_ubc;
 	int batch;
@@ -681,7 +682,7 @@ static void set_tlb_ubc_flush_pending(st
 	if (!pte_accessible(mm, pteval))
 		return;
 
-	arch_tlbbatch_add_pending(&tlb_ubc->arch, mm, uaddr);
+	arch_tlbbatch_add_pending(&tlb_ubc->arch, mm, start, end);
 	tlb_ubc->flush_required = true;
 
 	/*
@@ -757,7 +758,8 @@ void flush_tlb_batched_pending(struct mm
 }
 #else
 static void set_tlb_ubc_flush_pending(struct mm_struct *mm, pte_t pteval,
-				      unsigned long uaddr)
+		unsigned long start,
+		unsigned long end)
 {
 }
 
@@ -1792,7 +1794,7 @@ static bool try_to_unmap_one(struct foli
 				 */
 				pteval = ptep_get_and_clear(mm, address, pvmw.pte);
 
-				set_tlb_ubc_flush_pending(mm, pteval, address);
+				set_tlb_ubc_flush_pending(mm, pteval, address, address + PAGE_SIZE);
 			} else {
 				pteval = ptep_clear_flush(vma, address, pvmw.pte);
 			}
@@ -2164,7 +2166,7 @@ static bool try_to_migrate_one(struct fo
 				 */
 				pteval = ptep_get_and_clear(mm, address, pvmw.pte);
 
-				set_tlb_ubc_flush_pending(mm, pteval, address);
+				set_tlb_ubc_flush_pending(mm, pteval, address, address + PAGE_SIZE);
 			} else {
 				pteval = ptep_clear_flush(vma, address, pvmw.pte);
 			}
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-set-folio-swapbacked-iff-folios-are-dirty-in-try_to_unmap_one.patch
mm-support-tlbbatch-flush-for-a-range-of-ptes.patch
mm-support-batched-unmap-for-lazyfree-large-folios-during-reclamation.patch
mm-avoid-splitting-pmd-for-lazyfree-pmd-mapped-thp-in-try_to_unmap.patch

