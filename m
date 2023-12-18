Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E425BFA6
	for <mm-commits@vger.kernel.org>; Mon, 18 Dec 2023 17:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZUoW/Uqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F7DC433CA;
	Mon, 18 Dec 2023 17:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702920216;
	bh=PpNfliEb8Tiod6BndQX4OK26hPSEGD8r/pGrPUIkq2c=;
	h=Date:To:From:Subject:From;
	b=ZUoW/Uqv+PTeK/wfZqmgiC+F2cAnrJP10bvxHZZfCaDOXUlWJyiXa+YnQcxzTQSjF
	 FSCLSnViCc2K1H/2HI9LVaywZRA5H3EJw01WFDq91cg4MvHX5257ckiHgJ/np6RViX
	 /2Uxc5V3OuzA6g8FRLDQBIrM6+a/3vPsDNMq5BFQ=
Date: Mon, 18 Dec 2023 09:23:36 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yuzenghui@huawei.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vincenzo.frascino@arm.com,suzuki.poulose@arm.com,shy828301@gmail.com,ryabinin.a.a@gmail.com,oliver.upton@linux.dev,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,glider@google.com,dvyukov@google.com,david@redhat.com,catalin.marinas@arm.com,ardb@kernel.org,apopple@nvidia.com,anshuman.khandual@arm.com,andreyknvl@gmail.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-ptep_get-new-layer-to-manage-contig-bit.patch added to mm-unstable branch
Message-Id: <20231218172336.C8F7DC433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64/mm: ptep_get(): new layer to manage contig bit
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-mm-ptep_get-new-layer-to-manage-contig-bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-ptep_get-new-layer-to-manage-contig-bit.patch

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
Subject: arm64/mm: ptep_get(): new layer to manage contig bit
Date: Mon, 18 Dec 2023 10:50:56 +0000

Create a new layer for the in-table PTE manipulation APIs.  For now, The
existing API is prefixed with double underscore to become the arch-private
API and the public API is just a simple wrapper that calls the private
API.

The public API implementation will subsequently be used to transparently
manipulate the contiguous bit where appropriate.  But since there are
already some contig-aware users (e.g.  hugetlb, kernel mapper), we must
first ensure those users use the private API directly so that the future
contig-bit manipulations in the public API do not interfere with those
existing uses.

arm64 did not previously define an arch-specific ptep_get(), so override
the default version in the arch code, and also define the private
__ptep_get() version.  Currently they both do the same thing that the
default version does (READ_ONCE()).  Some arch users (hugetlb) were
already using ptep_get() so convert those to the private API.  While other
callsites were doing direct READ_ONCE(), so convert those to use the
appropriate (public/private) API too.

Link: https://lkml.kernel.org/r/20231218105100.172635-13-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Suzuki Poulouse <suzuki.poulose@arm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |   12 +++++++++---
 arch/arm64/kernel/efi.c          |    2 +-
 arch/arm64/mm/fault.c            |    4 ++--
 arch/arm64/mm/hugetlbpage.c      |   18 +++++++++---------
 arch/arm64/mm/kasan_init.c       |    2 +-
 arch/arm64/mm/mmu.c              |   12 ++++++------
 arch/arm64/mm/pageattr.c         |    4 ++--
 arch/arm64/mm/trans_pgd.c        |    2 +-
 8 files changed, 31 insertions(+), 25 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-ptep_get-new-layer-to-manage-contig-bit
+++ a/arch/arm64/include/asm/pgtable.h
@@ -276,6 +276,11 @@ static inline void __set_pte(pte_t *ptep
 	}
 }
 
+static inline pte_t __ptep_get(pte_t *ptep)
+{
+	return READ_ONCE(*ptep);
+}
+
 extern void __sync_icache_dcache(pte_t pteval);
 bool pgattr_change_is_safe(u64 old, u64 new);
 
@@ -303,7 +308,7 @@ static inline void __check_safe_pte_upda
 	if (!IS_ENABLED(CONFIG_DEBUG_VM))
 		return;
 
-	old_pte = READ_ONCE(*ptep);
+	old_pte = __ptep_get(ptep);
 
 	if (!pte_valid(old_pte) || !pte_valid(pte))
 		return;
@@ -893,7 +898,7 @@ static inline int __ptep_test_and_clear_
 {
 	pte_t old_pte, pte;
 
-	pte = READ_ONCE(*ptep);
+	pte = __ptep_get(ptep);
 	do {
 		old_pte = pte;
 		pte = pte_mkold(pte);
@@ -966,7 +971,7 @@ static inline void __ptep_set_wrprotect(
 {
 	pte_t old_pte, pte;
 
-	pte = READ_ONCE(*ptep);
+	pte = __ptep_get(ptep);
 	do {
 		old_pte = pte;
 		pte = pte_wrprotect(pte);
@@ -1111,6 +1116,7 @@ extern void ptep_modify_prot_commit(stru
 				    unsigned long addr, pte_t *ptep,
 				    pte_t old_pte, pte_t new_pte);
 
+#define ptep_get				__ptep_get
 #define set_pte					__set_pte
 #define set_ptes				__set_ptes
 #define pte_clear				__pte_clear
--- a/arch/arm64/kernel/efi.c~arm64-mm-ptep_get-new-layer-to-manage-contig-bit
+++ a/arch/arm64/kernel/efi.c
@@ -103,7 +103,7 @@ static int __init set_permissions(pte_t
 {
 	struct set_perm_data *spd = data;
 	const efi_memory_desc_t *md = spd->md;
-	pte_t pte = READ_ONCE(*ptep);
+	pte_t pte = __ptep_get(ptep);
 
 	if (md->attribute & EFI_MEMORY_RO)
 		pte = set_pte_bit(pte, __pgprot(PTE_RDONLY));
--- a/arch/arm64/mm/fault.c~arm64-mm-ptep_get-new-layer-to-manage-contig-bit
+++ a/arch/arm64/mm/fault.c
@@ -191,7 +191,7 @@ static void show_pte(unsigned long addr)
 		if (!ptep)
 			break;
 
-		pte = READ_ONCE(*ptep);
+		pte = __ptep_get(ptep);
 		pr_cont(", pte=%016llx", pte_val(pte));
 		pte_unmap(ptep);
 	} while(0);
@@ -214,7 +214,7 @@ int __ptep_set_access_flags(struct vm_ar
 			    pte_t entry, int dirty)
 {
 	pteval_t old_pteval, pteval;
-	pte_t pte = READ_ONCE(*ptep);
+	pte_t pte = __ptep_get(ptep);
 
 	if (pte_same(pte, entry))
 		return 0;
--- a/arch/arm64/mm/hugetlbpage.c~arm64-mm-ptep_get-new-layer-to-manage-contig-bit
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -152,14 +152,14 @@ pte_t huge_ptep_get(pte_t *ptep)
 {
 	int ncontig, i;
 	size_t pgsize;
-	pte_t orig_pte = ptep_get(ptep);
+	pte_t orig_pte = __ptep_get(ptep);
 
 	if (!pte_present(orig_pte) || !pte_cont(orig_pte))
 		return orig_pte;
 
 	ncontig = num_contig_ptes(page_size(pte_page(orig_pte)), &pgsize);
 	for (i = 0; i < ncontig; i++, ptep++) {
-		pte_t pte = ptep_get(ptep);
+		pte_t pte = __ptep_get(ptep);
 
 		if (pte_dirty(pte))
 			orig_pte = pte_mkdirty(orig_pte);
@@ -184,7 +184,7 @@ static pte_t get_clear_contig(struct mm_
 			     unsigned long pgsize,
 			     unsigned long ncontig)
 {
-	pte_t orig_pte = ptep_get(ptep);
+	pte_t orig_pte = __ptep_get(ptep);
 	unsigned long i;
 
 	for (i = 0; i < ncontig; i++, addr += pgsize, ptep++) {
@@ -408,7 +408,7 @@ pte_t huge_ptep_get_and_clear(struct mm_
 {
 	int ncontig;
 	size_t pgsize;
-	pte_t orig_pte = ptep_get(ptep);
+	pte_t orig_pte = __ptep_get(ptep);
 
 	if (!pte_cont(orig_pte))
 		return __ptep_get_and_clear(mm, addr, ptep);
@@ -431,11 +431,11 @@ static int __cont_access_flags_changed(p
 {
 	int i;
 
-	if (pte_write(pte) != pte_write(ptep_get(ptep)))
+	if (pte_write(pte) != pte_write(__ptep_get(ptep)))
 		return 1;
 
 	for (i = 0; i < ncontig; i++) {
-		pte_t orig_pte = ptep_get(ptep + i);
+		pte_t orig_pte = __ptep_get(ptep + i);
 
 		if (pte_dirty(pte) != pte_dirty(orig_pte))
 			return 1;
@@ -492,7 +492,7 @@ void huge_ptep_set_wrprotect(struct mm_s
 	size_t pgsize;
 	pte_t pte;
 
-	if (!pte_cont(READ_ONCE(*ptep))) {
+	if (!pte_cont(__ptep_get(ptep))) {
 		__ptep_set_wrprotect(mm, addr, ptep);
 		return;
 	}
@@ -517,7 +517,7 @@ pte_t huge_ptep_clear_flush(struct vm_ar
 	size_t pgsize;
 	int ncontig;
 
-	if (!pte_cont(READ_ONCE(*ptep)))
+	if (!pte_cont(__ptep_get(ptep)))
 		return ptep_clear_flush(vma, addr, ptep);
 
 	ncontig = find_num_contig(mm, addr, ptep, &pgsize);
@@ -550,7 +550,7 @@ pte_t huge_ptep_modify_prot_start(struct
 		 * when the permission changes from executable to non-executable
 		 * in cases where cpu is affected with errata #2645198.
 		 */
-		if (pte_user_exec(READ_ONCE(*ptep)))
+		if (pte_user_exec(__ptep_get(ptep)))
 			return huge_ptep_clear_flush(vma, addr, ptep);
 	}
 	return huge_ptep_get_and_clear(vma->vm_mm, addr, ptep);
--- a/arch/arm64/mm/kasan_init.c~arm64-mm-ptep_get-new-layer-to-manage-contig-bit
+++ a/arch/arm64/mm/kasan_init.c
@@ -113,7 +113,7 @@ static void __init kasan_pte_populate(pm
 			memset(__va(page_phys), KASAN_SHADOW_INIT, PAGE_SIZE);
 		next = addr + PAGE_SIZE;
 		__set_pte(ptep, pfn_pte(__phys_to_pfn(page_phys), PAGE_KERNEL));
-	} while (ptep++, addr = next, addr != end && pte_none(READ_ONCE(*ptep)));
+	} while (ptep++, addr = next, addr != end && pte_none(__ptep_get(ptep)));
 }
 
 static void __init kasan_pmd_populate(pud_t *pudp, unsigned long addr,
--- a/arch/arm64/mm/mmu.c~arm64-mm-ptep_get-new-layer-to-manage-contig-bit
+++ a/arch/arm64/mm/mmu.c
@@ -176,7 +176,7 @@ static void init_pte(pmd_t *pmdp, unsign
 
 	ptep = pte_set_fixmap_offset(pmdp, addr);
 	do {
-		pte_t old_pte = READ_ONCE(*ptep);
+		pte_t old_pte = __ptep_get(ptep);
 
 		__set_pte(ptep, pfn_pte(__phys_to_pfn(phys), prot));
 
@@ -185,7 +185,7 @@ static void init_pte(pmd_t *pmdp, unsign
 		 * only allow updates to the permission attributes.
 		 */
 		BUG_ON(!pgattr_change_is_safe(pte_val(old_pte),
-					      READ_ONCE(pte_val(*ptep))));
+					      pte_val(__ptep_get(ptep))));
 
 		phys += PAGE_SIZE;
 	} while (ptep++, addr += PAGE_SIZE, addr != end);
@@ -854,7 +854,7 @@ static void unmap_hotplug_pte_range(pmd_
 
 	do {
 		ptep = pte_offset_kernel(pmdp, addr);
-		pte = READ_ONCE(*ptep);
+		pte = __ptep_get(ptep);
 		if (pte_none(pte))
 			continue;
 
@@ -987,7 +987,7 @@ static void free_empty_pte_table(pmd_t *
 
 	do {
 		ptep = pte_offset_kernel(pmdp, addr);
-		pte = READ_ONCE(*ptep);
+		pte = __ptep_get(ptep);
 
 		/*
 		 * This is just a sanity check here which verifies that
@@ -1006,7 +1006,7 @@ static void free_empty_pte_table(pmd_t *
 	 */
 	ptep = pte_offset_kernel(pmdp, 0UL);
 	for (i = 0; i < PTRS_PER_PTE; i++) {
-		if (!pte_none(READ_ONCE(ptep[i])))
+		if (!pte_none(__ptep_get(&ptep[i])))
 			return;
 	}
 
@@ -1475,7 +1475,7 @@ pte_t ptep_modify_prot_start(struct vm_a
 		 * when the permission changes from executable to non-executable
 		 * in cases where cpu is affected with errata #2645198.
 		 */
-		if (pte_user_exec(READ_ONCE(*ptep)))
+		if (pte_user_exec(ptep_get(ptep)))
 			return ptep_clear_flush(vma, addr, ptep);
 	}
 	return ptep_get_and_clear(vma->vm_mm, addr, ptep);
--- a/arch/arm64/mm/pageattr.c~arm64-mm-ptep_get-new-layer-to-manage-contig-bit
+++ a/arch/arm64/mm/pageattr.c
@@ -36,7 +36,7 @@ bool can_set_direct_map(void)
 static int change_page_range(pte_t *ptep, unsigned long addr, void *data)
 {
 	struct page_change_data *cdata = data;
-	pte_t pte = READ_ONCE(*ptep);
+	pte_t pte = __ptep_get(ptep);
 
 	pte = clear_pte_bit(pte, cdata->clear_mask);
 	pte = set_pte_bit(pte, cdata->set_mask);
@@ -245,5 +245,5 @@ bool kernel_page_present(struct page *pa
 		return true;
 
 	ptep = pte_offset_kernel(pmdp, addr);
-	return pte_valid(READ_ONCE(*ptep));
+	return pte_valid(__ptep_get(ptep));
 }
--- a/arch/arm64/mm/trans_pgd.c~arm64-mm-ptep_get-new-layer-to-manage-contig-bit
+++ a/arch/arm64/mm/trans_pgd.c
@@ -33,7 +33,7 @@ static void *trans_alloc(struct trans_pg
 
 static void _copy_pte(pte_t *dst_ptep, pte_t *src_ptep, unsigned long addr)
 {
-	pte_t pte = READ_ONCE(*src_ptep);
+	pte_t pte = __ptep_get(src_ptep);
 
 	if (pte_valid(pte)) {
 		/*
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-allow-deferred-splitting-of-arbitrary-anon-large-folios.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
mm-thp-introduce-multi-size-thp-sysfs-interface.patch
mm-thp-introduce-multi-size-thp-sysfs-interface-fix.patch
mm-thp-support-allocation-of-anonymous-multi-size-thp.patch
mm-thp-support-allocation-of-anonymous-multi-size-thp-fix.patch
selftests-mm-kugepaged-restore-thp-settings-at-exit.patch
selftests-mm-factor-out-thp-settings-management.patch
selftests-mm-support-multi-size-thp-interface-in-thp_settings.patch
selftests-mm-khugepaged-enlighten-for-multi-size-thp.patch
selftests-mm-cow-generalize-do_run_with_thp-helper.patch
selftests-mm-cow-add-tests-for-anonymous-multi-size-thp.patch
mm-thp-batch-collapse-pmd-with-set_ptes.patch
mm-batch-copy-pte-ranges-during-fork.patch
mm-batch-clear-pte-ranges-during-zap_pte_range.patch
arm64-mm-set_pte-new-layer-to-manage-contig-bit.patch
arm64-mm-set_ptes-set_pte_at-new-layer-to-manage-contig-bit.patch
arm64-mm-pte_clear-new-layer-to-manage-contig-bit.patch
arm64-mm-ptep_get_and_clear-new-layer-to-manage-contig-bit.patch
arm64-mm-ptep_test_and_clear_young-new-layer-to-manage-contig-bit.patch
arm64-mm-ptep_clear_flush_young-new-layer-to-manage-contig-bit.patch
arm64-mm-ptep_set_wrprotect-new-layer-to-manage-contig-bit.patch
arm64-mm-ptep_set_access_flags-new-layer-to-manage-contig-bit.patch
arm64-mm-ptep_get-new-layer-to-manage-contig-bit.patch
arm64-mm-split-__flush_tlb_range-to-elide-trailing-dsb.patch
arm64-mm-wire-up-pte_cont-for-user-mappings.patch
arm64-mm-implement-new-helpers-to-optimize-fork.patch
arm64-mm-implement-clear_ptes-to-optimize-exit-munmap-dontneed.patch
selftests-mm-log-run_vmtestssh-results-in-tap-format.patch

