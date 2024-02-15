Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D391213A248
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2024 19:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708026186; cv=none; b=sh1hZ7S2U4G334gSKzDJZcrW6WHNQ9Omv13RCjZDNcwsWtVbffuHt7FOBdvjmKyO9T9ix4cd32nCopS0q9WsR/p8actmWam7qApwbDD2ksvRrHr9dQqQi4yWDFbDyZDks1eNkFV4DPzN1VMjsuj6IMVVhLCsoQXeQWKUGJzH3hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708026186; c=relaxed/simple;
	bh=q3XrVtkzSulKQHc1Qn7DyeY8MPP5AsytcH87Qk+BRHk=;
	h=Date:To:From:Subject:Message-Id; b=CqoZRMbUZeNfsMgvaW5dB5SCzAEgrakCYuHVOGbcFoIZblbsi2k7wJR4s7j3GsdeoTr8/9MWLmi5lhWzRe0fubmalsLOTgMlRhuoba7i6nqzvT3lojbg3d7mChnDU6utD8eatrfISMUJJdQ+vIY9xzn7UDaJzCCg/y3nwkOuV5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BkSqgBDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BkSqgBDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC1EC433F1;
	Thu, 15 Feb 2024 19:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708026186;
	bh=q3XrVtkzSulKQHc1Qn7DyeY8MPP5AsytcH87Qk+BRHk=;
	h=Date:To:From:Subject:From;
	b=BkSqgBDhE9hB2EhXtW8APAzFOckUo5BRrNLaNNrof38A1hI0lvKSXLVkuTwJw/z1e
	 K1BXcMadDxse868QDJ4+OjRPtDIRgHxa1m9rqvmOS6hKwPx719RDv6Hiw8RfzQjA1i
	 FObTosm4w1BStQXuZAQ2dLymaP6SZNKjzQ/XzgYQ=
Date: Thu, 15 Feb 2024 11:43:06 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,hpa@zytor.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,apopple@nvidia.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-implement-new-wrprotect_ptes-batch-api.patch added to mm-unstable branch
Message-Id: <20240215194306.9CC1EC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64/mm: implement new wrprotect_ptes() batch API
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-mm-implement-new-wrprotect_ptes-batch-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-implement-new-wrprotect_ptes-batch-api.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: arm64/mm: implement new wrprotect_ptes() batch API
Date: Thu, 15 Feb 2024 10:32:00 +0000

Optimize the contpte implementation to fix some of the fork performance
regression introduced by the initial contpte commit.  Subsequent patches
will solve it entirely.

During fork(), any private memory in the parent must be write-protected. 
Previously this was done 1 PTE at a time.  But the core-mm supports
batched wrprotect via the new wrprotect_ptes() API.  So let's implement
that API and for fully covered contpte mappings, we no longer need to
unfold the contpte.  This has 2 benefits:

  - reduced unfolding, reduces the number of tlbis that must be issued.
  - The memory remains contpte-mapped ("folded") in the parent, so it
    continues to benefit from the more efficient use of the TLB after
    the fork.

The optimization to wrprotect a whole contpte block without unfolding is
possible thanks to the tightening of the Arm ARM in respect to the
definition and behaviour when 'Misprogramming the Contiguous bit'.  See
section D21194 at https://developer.arm.com/documentation/102105/ja-07/

Link: https://lkml.kernel.org/r/20240215103205.2607016-14-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Morse <james.morse@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |   61 ++++++++++++++++++++++++-----
 arch/arm64/mm/contpte.c          |   38 ++++++++++++++++++
 2 files changed, 89 insertions(+), 10 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-implement-new-wrprotect_ptes-batch-api
+++ a/arch/arm64/include/asm/pgtable.h
@@ -978,16 +978,12 @@ static inline pmd_t pmdp_huge_get_and_cl
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-/*
- * __ptep_set_wrprotect - mark read-only while trasferring potential hardware
- * dirty status (PTE_DBM && !PTE_RDONLY) to the software PTE_DIRTY bit.
- */
-static inline void __ptep_set_wrprotect(struct mm_struct *mm,
-					unsigned long address, pte_t *ptep)
+static inline void ___ptep_set_wrprotect(struct mm_struct *mm,
+					unsigned long address, pte_t *ptep,
+					pte_t pte)
 {
-	pte_t old_pte, pte;
+	pte_t old_pte;
 
-	pte = __ptep_get(ptep);
 	do {
 		old_pte = pte;
 		pte = pte_wrprotect(pte);
@@ -996,6 +992,25 @@ static inline void __ptep_set_wrprotect(
 	} while (pte_val(pte) != pte_val(old_pte));
 }
 
+/*
+ * __ptep_set_wrprotect - mark read-only while trasferring potential hardware
+ * dirty status (PTE_DBM && !PTE_RDONLY) to the software PTE_DIRTY bit.
+ */
+static inline void __ptep_set_wrprotect(struct mm_struct *mm,
+					unsigned long address, pte_t *ptep)
+{
+	___ptep_set_wrprotect(mm, address, ptep, __ptep_get(ptep));
+}
+
+static inline void __wrprotect_ptes(struct mm_struct *mm, unsigned long address,
+				pte_t *ptep, unsigned int nr)
+{
+	unsigned int i;
+
+	for (i = 0; i < nr; i++, address += PAGE_SIZE, ptep++)
+		__ptep_set_wrprotect(mm, address, ptep);
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define __HAVE_ARCH_PMDP_SET_WRPROTECT
 static inline void pmdp_set_wrprotect(struct mm_struct *mm,
@@ -1149,6 +1164,8 @@ extern int contpte_ptep_test_and_clear_y
 				unsigned long addr, pte_t *ptep);
 extern int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
 				unsigned long addr, pte_t *ptep);
+extern void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
+				pte_t *ptep, unsigned int nr);
 extern int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
 				unsigned long addr, pte_t *ptep,
 				pte_t entry, int dirty);
@@ -1268,12 +1285,35 @@ static inline int ptep_clear_flush_young
 	return contpte_ptep_clear_flush_young(vma, addr, ptep);
 }
 
+#define wrprotect_ptes wrprotect_ptes
+static inline void wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
+				pte_t *ptep, unsigned int nr)
+{
+	if (likely(nr == 1)) {
+		/*
+		 * Optimization: wrprotect_ptes() can only be called for present
+		 * ptes so we only need to check contig bit as condition for
+		 * unfold, and we can remove the contig bit from the pte we read
+		 * to avoid re-reading. This speeds up fork() which is sensitive
+		 * for order-0 folios. Equivalent to contpte_try_unfold().
+		 */
+		pte_t orig_pte = __ptep_get(ptep);
+
+		if (unlikely(pte_cont(orig_pte))) {
+			__contpte_try_unfold(mm, addr, ptep, orig_pte);
+			orig_pte = pte_mknoncont(orig_pte);
+		}
+		___ptep_set_wrprotect(mm, addr, ptep, orig_pte);
+	} else {
+		contpte_wrprotect_ptes(mm, addr, ptep, nr);
+	}
+}
+
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
 static inline void ptep_set_wrprotect(struct mm_struct *mm,
 				unsigned long addr, pte_t *ptep)
 {
-	contpte_try_unfold(mm, addr, ptep, __ptep_get(ptep));
-	__ptep_set_wrprotect(mm, addr, ptep);
+	wrprotect_ptes(mm, addr, ptep, 1);
 }
 
 #define __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
@@ -1305,6 +1345,7 @@ static inline int ptep_set_access_flags(
 #define ptep_clear_flush_young			__ptep_clear_flush_young
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
 #define ptep_set_wrprotect			__ptep_set_wrprotect
+#define wrprotect_ptes				__wrprotect_ptes
 #define __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 #define ptep_set_access_flags			__ptep_set_access_flags
 
--- a/arch/arm64/mm/contpte.c~arm64-mm-implement-new-wrprotect_ptes-batch-api
+++ a/arch/arm64/mm/contpte.c
@@ -26,6 +26,26 @@ static inline pte_t *contpte_align_down(
 	return PTR_ALIGN_DOWN(ptep, sizeof(*ptep) * CONT_PTES);
 }
 
+static void contpte_try_unfold_partial(struct mm_struct *mm, unsigned long addr,
+					pte_t *ptep, unsigned int nr)
+{
+	/*
+	 * Unfold any partially covered contpte block at the beginning and end
+	 * of the range.
+	 */
+
+	if (ptep != contpte_align_down(ptep) || nr < CONT_PTES)
+		contpte_try_unfold(mm, addr, ptep, __ptep_get(ptep));
+
+	if (ptep + nr != contpte_align_down(ptep + nr)) {
+		unsigned long last_addr = addr + PAGE_SIZE * (nr - 1);
+		pte_t *last_ptep = ptep + nr - 1;
+
+		contpte_try_unfold(mm, last_addr, last_ptep,
+				   __ptep_get(last_ptep));
+	}
+}
+
 static void contpte_convert(struct mm_struct *mm, unsigned long addr,
 			    pte_t *ptep, pte_t pte)
 {
@@ -238,6 +258,24 @@ int contpte_ptep_clear_flush_young(struc
 }
 EXPORT_SYMBOL(contpte_ptep_clear_flush_young);
 
+void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
+					pte_t *ptep, unsigned int nr)
+{
+	/*
+	 * If wrprotecting an entire contig range, we can avoid unfolding. Just
+	 * set wrprotect and wait for the later mmu_gather flush to invalidate
+	 * the tlb. Until the flush, the page may or may not be wrprotected.
+	 * After the flush, it is guaranteed wrprotected. If it's a partial
+	 * range though, we must unfold, because we can't have a case where
+	 * CONT_PTE is set but wrprotect applies to a subset of the PTEs; this
+	 * would cause it to continue to be unpredictable after the flush.
+	 */
+
+	contpte_try_unfold_partial(mm, addr, ptep, nr);
+	__wrprotect_ptes(mm, addr, ptep, nr);
+}
+EXPORT_SYMBOL(contpte_wrprotect_ptes);
+
 int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
 					unsigned long addr, pte_t *ptep,
 					pte_t entry, int dirty)
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

tools-mm-add-thpmaps-script-to-dump-thp-usage-info.patch
arm64-mm-make-set_ptes-robust-when-oas-cross-48-bit-boundary.patch
mm-clarify-the-spec-for-set_ptes.patch
mm-thp-batch-collapse-pmd-with-set_ptes.patch
mm-introduce-pte_advance_pfn-and-use-for-pte_next_pfn.patch
arm64-mm-convert-pte_next_pfn-to-pte_advance_pfn.patch
x86-mm-convert-pte_next_pfn-to-pte_advance_pfn.patch
mm-tidy-up-pte_next_pfn-definition.patch
arm64-mm-convert-read_onceptep-to-ptep_getptep.patch
arm64-mm-convert-set_pte_at-to-set_ptes-1.patch
arm64-mm-convert-ptep_clear-to-ptep_get_and_clear.patch
arm64-mm-new-ptep-layer-to-manage-contig-bit.patch
arm64-mm-split-__flush_tlb_range-to-elide-trailing-dsb.patch
arm64-mm-wire-up-pte_cont-for-user-mappings.patch
arm64-mm-implement-new-wrprotect_ptes-batch-api.patch
arm64-mm-implement-new-clear_full_ptes-batch-apis.patch
mm-add-pte_batch_hint-to-reduce-scanning-in-folio_pte_batch.patch
arm64-mm-implement-pte_batch_hint.patch
arm64-mm-__always_inline-to-improve-fork-perf.patch
arm64-mm-automatically-fold-contpte-mappings.patch

