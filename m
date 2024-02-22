Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7437B224EE
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644496; cv=none; b=obmOkAEL4MaVltrUrlZGo7IUikaY/yvw5j0rf/yv9jagMewXlWfgMKonWAw5pqGNXf82tVUuuIkb0QFR/NkTly7S9+uF7fUJywTIzI1MszzXciIZ9e/HUXfQlki8Nk+cHHywmIlhD/37OIWpPGPqrmgjDEdQKNlPxCl6VlTFQNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644496; c=relaxed/simple;
	bh=WFdfEPnynxaWtBHHjnUMKYEPhgQnEfQQvOKSz1HOTs8=;
	h=Date:To:From:Subject:Message-Id; b=nZWhVSFv9fLVEAGrZNMYhRqaqOUMCsfkY9NLnUNUEVVV/eOKvX3dsSfDczCcAh2pdE2CUTpn7+shb8xWYwK7WuaMdmA1XAWdnlEvMzhhpif3xxgTgrKRKZOSeS+WTm0mcfGs39uWqskkfjDfNKG+NB7xZUItufPd7TOi1uyWNBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1t3jTzbI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1t3jTzbI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5DDC43390;
	Thu, 22 Feb 2024 23:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644496;
	bh=WFdfEPnynxaWtBHHjnUMKYEPhgQnEfQQvOKSz1HOTs8=;
	h=Date:To:From:Subject:From;
	b=1t3jTzbIFuo11btfiwsFMlNsAC35TxKaFpqyAKk1g8eCgL/vIkdxcPZPQGKdca9O1
	 GL9y++4I865P2yXBnFFm3udrbRKZSye3iYqabwc80Y7JDHb9MNvwuQkyvO5N2RT3p9
	 X7jrSsnOkwQBQEtKoI71QBNcH+1r2KRzlaIqxx34=
Date: Thu, 22 Feb 2024 15:28:15 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,hpa@zytor.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,apopple@nvidia.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-implement-new-wrprotect_ptes-batch-api.patch removed from -mm tree
Message-Id: <20240222232816.3E5DDC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64/mm: implement new wrprotect_ptes() batch API
has been removed from the -mm tree.  Its filename was
     arm64-mm-implement-new-wrprotect_ptes-batch-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
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


