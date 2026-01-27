Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59131E5702
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486753; cv=none; b=X8wD+pU8GNE74pz3cYe2K+yl//x/EZWMDa7/HPh5NOIETO7AxyNBsiwNRAAvRvh+INPD4ryCC6E6c3N+iseBx9s3QS7odmGssXGv/VjwOqxclL+IFPjs2h8SzR3YioS7AqGL/9m/QDYNCVB1Yjm4vtxACbfA9nPy5XBmtgw/rns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486753; c=relaxed/simple;
	bh=MO8sZW/n8hwEvMUGQRWZ/hd/gTZ/e2WJk582lD7OjyU=;
	h=Date:To:From:Subject:Message-Id; b=YLdim5fPvGZ9chVyLidjqydNRU7VzO32bFrFOPpSHVNcf5OZrEc9rvoVJvF5okQDwTWowmCLV6p2dpnT7jugucmnEtNC84HtlGDk06+ElgfWfHIDncnDSCxd6I+Iz3/GnYH0uoV9YnpjohyWmasxnnNeWKHdUcsqW0JNXFIG4xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E6K3Xe12; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E6K3Xe12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4954C116C6;
	Tue, 27 Jan 2026 04:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486752;
	bh=MO8sZW/n8hwEvMUGQRWZ/hd/gTZ/e2WJk582lD7OjyU=;
	h=Date:To:From:Subject:From;
	b=E6K3Xe12QOP/V4q7cJ3R2dbYbU81PmNX15+uHboMS8mkw4wlviUC0itVhWe5xTU6b
	 VfWN4w90493U0bW/5rTAxPnJWwHSFrsIVIUbGpGY9CMbKLsfDGNAxAzKWXTVOP/qnV
	 s5emGqA1vNa7JcJpjLGpVlzolIXnGaVsw1IvvgJY=
Date: Mon, 26 Jan 2026 20:05:52 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,willy@infradead.org,vishal.moola@gmail.com,thuth@redhat.com,sweettea-kernel@dorminy.me,ritesh.list@gmail.com,paulus@ozlabs.org,pasha.tatashin@soleen.com,npiggin@gmail.com,nicholas@linux.ibm.com,mpe@ellerman.id.au,mingo@kernel.org,maddy@linux.ibm.com,linmag7@gmail.com,kevin.brodsky@arm.com,jgg@ziepe.ca,guoweikang.kernel@gmail.com,donettom@linux.ibm.com,david@kernel.org,christophe.leroy@csgroup.eu,chleroy@kernel.org,apopple@nvidia.com,alexghiti@rivosinc.com,alex@ghiti.fr,ajd@linux.ibm.com,agordeev@linux.ibm.com,rmclure@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-mm-support-page-table-check.patch removed from -mm tree
Message-Id: <20260127040552.B4954C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/mm: support page table check
has been removed from the -mm tree.  Its filename was
     powerpc-mm-support-page-table-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rohan McLure <rmclure@linux.ibm.com>
Subject: powerpc/mm: support page table check
Date: Fri, 19 Dec 2025 04:09:44 +1100

On creation and clearing of a page table mapping, instrument such calls by
invoking page_table_check_pte_set and page_table_check_pte_clear
respectively.  These calls serve as a sanity check against illegal
mappings.

Enable ARCH_SUPPORTS_PAGE_TABLE_CHECK on powerpc, except when HUGETLB_PAGE
is enabled (powerpc has some weirdness in how it implements
set_huge_pte_at(), which may require some further work).

See also:

riscv support in commit 3fee229a8eb9 ("riscv/mm: enable
ARCH_SUPPORTS_PAGE_TABLE_CHECK")
arm64 in commit 42b2547137f5 ("arm64/mm: enable
ARCH_SUPPORTS_PAGE_TABLE_CHECK")
x86_64 in commit d283d422c6c4 ("x86: mm: add x86_64 support for page table
check")

[ajd@linux.ibm.com: rebase, add additional instrumentation, misc fixes]
Link: https://lkml.kernel.org/r/20251219-pgtable_check_v18rebase-v18-12-755bc151a50b@linux.ibm.com
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Guo Weikang <guoweikang.kernel@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Miehlbradt <nicholas@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Thomas Huth <thuth@redhat.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig                         |    1 
 arch/powerpc/include/asm/book3s/32/pgtable.h |    7 ++
 arch/powerpc/include/asm/book3s/64/pgtable.h |   45 +++++++++++++----
 arch/powerpc/include/asm/nohash/pgtable.h    |    8 ++-
 arch/powerpc/mm/book3s64/hash_pgtable.c      |    4 +
 arch/powerpc/mm/book3s64/pgtable.c           |   19 ++++---
 arch/powerpc/mm/book3s64/radix_pgtable.c     |    3 +
 arch/powerpc/mm/pgtable.c                    |    4 +
 8 files changed, 73 insertions(+), 18 deletions(-)

--- a/arch/powerpc/include/asm/book3s/32/pgtable.h~powerpc-mm-support-page-table-check
+++ a/arch/powerpc/include/asm/book3s/32/pgtable.h
@@ -202,6 +202,7 @@ void unmap_kernel_page(unsigned long va)
 #ifndef __ASSEMBLER__
 #include <linux/sched.h>
 #include <linux/threads.h>
+#include <linux/page_table_check.h>
 
 /* Bits to mask out from a PGD to get to the PUD page */
 #define PGD_MASKED_BITS		0
@@ -315,7 +316,11 @@ static inline int __ptep_test_and_clear_
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
 				       pte_t *ptep)
 {
-	return __pte(pte_update(mm, addr, ptep, ~_PAGE_HASHPTE, 0, 0));
+	pte_t old_pte = __pte(pte_update(mm, addr, ptep, ~_PAGE_HASHPTE, 0, 0));
+
+	page_table_check_pte_clear(mm, addr, old_pte);
+
+	return old_pte;
 }
 
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~powerpc-mm-support-page-table-check
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -144,6 +144,8 @@
 #define PAGE_KERNEL_ROX	__pgprot(_PAGE_BASE | _PAGE_KERNEL_ROX)
 
 #ifndef __ASSEMBLER__
+#include <linux/page_table_check.h>
+
 /*
  * page table defines
  */
@@ -416,8 +418,11 @@ static inline void huge_ptep_set_wrprote
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 				       unsigned long addr, pte_t *ptep)
 {
-	unsigned long old = pte_update(mm, addr, ptep, ~0UL, 0, 0);
-	return __pte(old);
+	pte_t old_pte = __pte(pte_update(mm, addr, ptep, ~0UL, 0, 0));
+
+	page_table_check_pte_clear(mm, addr, old_pte);
+
+	return old_pte;
 }
 
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR_FULL
@@ -426,11 +431,16 @@ static inline pte_t ptep_get_and_clear_f
 					    pte_t *ptep, int full)
 {
 	if (full && radix_enabled()) {
+		pte_t old_pte;
+
 		/*
 		 * We know that this is a full mm pte clear and
 		 * hence can be sure there is no parallel set_pte.
 		 */
-		return radix__ptep_get_and_clear_full(mm, addr, ptep, full);
+		old_pte = radix__ptep_get_and_clear_full(mm, addr, ptep, full);
+		page_table_check_pte_clear(mm, addr, old_pte);
+
+		return old_pte;
 	}
 	return ptep_get_and_clear(mm, addr, ptep);
 }
@@ -1301,19 +1311,34 @@ extern int pudp_test_and_clear_young(str
 static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 					    unsigned long addr, pmd_t *pmdp)
 {
-	if (radix_enabled())
-		return radix__pmdp_huge_get_and_clear(mm, addr, pmdp);
-	return hash__pmdp_huge_get_and_clear(mm, addr, pmdp);
+	pmd_t old_pmd;
+
+	if (radix_enabled()) {
+		old_pmd = radix__pmdp_huge_get_and_clear(mm, addr, pmdp);
+	} else {
+		old_pmd = hash__pmdp_huge_get_and_clear(mm, addr, pmdp);
+	}
+
+	page_table_check_pmd_clear(mm, addr, old_pmd);
+
+	return old_pmd;
 }
 
 #define __HAVE_ARCH_PUDP_HUGE_GET_AND_CLEAR
 static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
 					    unsigned long addr, pud_t *pudp)
 {
-	if (radix_enabled())
-		return radix__pudp_huge_get_and_clear(mm, addr, pudp);
-	BUG();
-	return *pudp;
+	pud_t old_pud;
+
+	if (radix_enabled()) {
+		old_pud = radix__pudp_huge_get_and_clear(mm, addr, pudp);
+	} else {
+		BUG();
+	}
+
+	page_table_check_pud_clear(mm, addr, old_pud);
+
+	return old_pud;
 }
 
 static inline pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
--- a/arch/powerpc/include/asm/nohash/pgtable.h~powerpc-mm-support-page-table-check
+++ a/arch/powerpc/include/asm/nohash/pgtable.h
@@ -29,6 +29,8 @@ static inline pte_basic_t pte_update(str
 
 #ifndef __ASSEMBLER__
 
+#include <linux/page_table_check.h>
+
 extern int icache_44x_need_flush;
 
 #ifndef pte_huge_size
@@ -122,7 +124,11 @@ static inline void ptep_set_wrprotect(st
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
 				       pte_t *ptep)
 {
-	return __pte(pte_update(mm, addr, ptep, ~0UL, 0, 0));
+	pte_t old_pte = __pte(pte_update(mm, addr, ptep, ~0UL, 0, 0));
+
+	page_table_check_pte_clear(mm, addr, old_pte);
+
+	return old_pte;
 }
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 
--- a/arch/powerpc/Kconfig~powerpc-mm-support-page-table-check
+++ a/arch/powerpc/Kconfig
@@ -172,6 +172,7 @@ config PPC
 	select ARCH_STACKWALK
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC	if PPC_BOOK3S || PPC_8xx
+	select ARCH_SUPPORTS_PAGE_TABLE_CHECK	if !HUGETLB_PAGE
 	select ARCH_SUPPORTS_SCHED_MC		if SMP
 	select ARCH_SUPPORTS_SCHED_SMT		if PPC64 && SMP
 	select SCHED_MC				if ARCH_SUPPORTS_SCHED_MC
--- a/arch/powerpc/mm/book3s64/hash_pgtable.c~powerpc-mm-support-page-table-check
+++ a/arch/powerpc/mm/book3s64/hash_pgtable.c
@@ -8,6 +8,7 @@
 #include <linux/sched.h>
 #include <linux/mm_types.h>
 #include <linux/mm.h>
+#include <linux/page_table_check.h>
 #include <linux/stop_machine.h>
 
 #include <asm/sections.h>
@@ -230,6 +231,9 @@ pmd_t hash__pmdp_collapse_flush(struct v
 
 	pmd = *pmdp;
 	pmd_clear(pmdp);
+
+	page_table_check_pmd_clear(vma->vm_mm, address, pmd);
+
 	/*
 	 * Wait for all pending hash_page to finish. This is needed
 	 * in case of subpage collapse. When we collapse normal pages
--- a/arch/powerpc/mm/book3s64/pgtable.c~powerpc-mm-support-page-table-check
+++ a/arch/powerpc/mm/book3s64/pgtable.c
@@ -10,6 +10,7 @@
 #include <linux/pkeys.h>
 #include <linux/debugfs.h>
 #include <linux/proc_fs.h>
+#include <linux/page_table_check.h>
 
 #include <asm/pgalloc.h>
 #include <asm/tlb.h>
@@ -127,6 +128,7 @@ void set_pmd_at(struct mm_struct *mm, un
 	WARN_ON(!(pmd_leaf(pmd)));
 #endif
 	trace_hugepage_set_pmd(addr, pmd_val(pmd));
+	page_table_check_pmd_set(mm, addr, pmdp, pmd);
 	return set_pte_at_unchecked(mm, addr, pmdp_ptep(pmdp), pmd_pte(pmd));
 }
 
@@ -144,6 +146,7 @@ void set_pud_at(struct mm_struct *mm, un
 	WARN_ON(!(pud_leaf(pud)));
 #endif
 	trace_hugepage_set_pud(addr, pud_val(pud));
+	page_table_check_pud_set(mm, addr, pudp, pud);
 	return set_pte_at_unchecked(mm, addr, pudp_ptep(pudp), pud_pte(pud));
 }
 
@@ -179,23 +182,27 @@ void serialize_against_pte_lookup(struct
 pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
 		     pmd_t *pmdp)
 {
-	unsigned long old_pmd;
+	pmd_t old_pmd;
 
 	VM_WARN_ON_ONCE(!pmd_present(*pmdp));
-	old_pmd = pmd_hugepage_update(vma->vm_mm, address, pmdp, _PAGE_PRESENT, _PAGE_INVALID);
+	old_pmd = __pmd(pmd_hugepage_update(vma->vm_mm, address, pmdp, _PAGE_PRESENT, _PAGE_INVALID));
 	flush_pmd_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
-	return __pmd(old_pmd);
+	page_table_check_pmd_clear(vma->vm_mm, address, old_pmd);
+
+	return old_pmd;
 }
 
 pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
 		      pud_t *pudp)
 {
-	unsigned long old_pud;
+	pud_t old_pud;
 
 	VM_WARN_ON_ONCE(!pud_present(*pudp));
-	old_pud = pud_hugepage_update(vma->vm_mm, address, pudp, _PAGE_PRESENT, _PAGE_INVALID);
+	old_pud = __pud(pud_hugepage_update(vma->vm_mm, address, pudp, _PAGE_PRESENT, _PAGE_INVALID));
 	flush_pud_tlb_range(vma, address, address + HPAGE_PUD_SIZE);
-	return __pud(old_pud);
+	page_table_check_pud_clear(vma->vm_mm, address, old_pud);
+
+	return old_pud;
 }
 
 pmd_t pmdp_huge_get_and_clear_full(struct vm_area_struct *vma,
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c~powerpc-mm-support-page-table-check
+++ a/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -14,6 +14,7 @@
 #include <linux/of.h>
 #include <linux/of_fdt.h>
 #include <linux/mm.h>
+#include <linux/page_table_check.h>
 #include <linux/hugetlb.h>
 #include <linux/string_helpers.h>
 #include <linux/memory.h>
@@ -1474,6 +1475,8 @@ pmd_t radix__pmdp_collapse_flush(struct
 	pmd = *pmdp;
 	pmd_clear(pmdp);
 
+	page_table_check_pmd_clear(vma->vm_mm, address, pmd);
+
 	radix__flush_tlb_collapsed_pmd(vma->vm_mm, address);
 
 	return pmd;
--- a/arch/powerpc/mm/pgtable.c~powerpc-mm-support-page-table-check
+++ a/arch/powerpc/mm/pgtable.c
@@ -22,6 +22,7 @@
 #include <linux/mm.h>
 #include <linux/percpu.h>
 #include <linux/hardirq.h>
+#include <linux/page_table_check.h>
 #include <linux/hugetlb.h>
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
@@ -206,6 +207,9 @@ void set_ptes(struct mm_struct *mm, unsi
 	 * and not hw_valid ptes. Hence there is no translation cache flush
 	 * involved that need to be batched.
 	 */
+
+	page_table_check_ptes_set(mm, addr, ptep, pte, nr);
+
 	for (;;) {
 
 		/*
_

Patches currently in -mm which might be from rmclure@linux.ibm.com are


