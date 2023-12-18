Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9962E1E4A4
	for <mm-commits@vger.kernel.org>; Mon, 18 Dec 2023 17:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u0BNKTBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08623C433C8;
	Mon, 18 Dec 2023 17:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702920196;
	bh=qrq5+eKoSUDOe/Wp93nOaWJV05N7DYUfyPNPY4V1Dls=;
	h=Date:To:From:Subject:From;
	b=u0BNKTBRL++gOSQ3enuiIZ6MOfkhevmOP7fQXkAS+cERAwstwo08jl+wfOPMAHaru
	 pxr8rx46gY5+6x3fHVJv0TQ5/afDgAWSPUwsRBzu+XkPo4PyOS/cYEGADNhuGj4nW2
	 kK0jKc5YPSSuyuBnlMpdaHdX93EXE9ybEj0WoN0I=
Date: Mon, 18 Dec 2023 09:23:15 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yuzenghui@huawei.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vincenzo.frascino@arm.com,suzuki.poulose@arm.com,shy828301@gmail.com,ryabinin.a.a@gmail.com,oliver.upton@linux.dev,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,glider@google.com,dvyukov@google.com,david@redhat.com,catalin.marinas@arm.com,ardb@kernel.org,apopple@nvidia.com,anshuman.khandual@arm.com,andreyknvl@gmail.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-set_pte-new-layer-to-manage-contig-bit.patch added to mm-unstable branch
Message-Id: <20231218172316.08623C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64/mm: set_pte(): new layer to manage contig bit
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-mm-set_pte-new-layer-to-manage-contig-bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-set_pte-new-layer-to-manage-contig-bit.patch

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
Subject: arm64/mm: set_pte(): new layer to manage contig bit
Date: Mon, 18 Dec 2023 10:50:48 +0000

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

Link: https://lkml.kernel.org/r/20231218105100.172635-5-ryan.roberts@arm.com
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

 arch/arm64/include/asm/pgtable.h |   12 ++++++++----
 arch/arm64/kernel/efi.c          |    2 +-
 arch/arm64/mm/fixmap.c           |    2 +-
 arch/arm64/mm/kasan_init.c       |    4 ++--
 arch/arm64/mm/mmu.c              |    2 +-
 arch/arm64/mm/pageattr.c         |    2 +-
 arch/arm64/mm/trans_pgd.c        |    4 ++--
 7 files changed, 16 insertions(+), 12 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-set_pte-new-layer-to-manage-contig-bit
+++ a/arch/arm64/include/asm/pgtable.h
@@ -93,7 +93,8 @@ static inline pteval_t __phys_to_pte_val
 	__pte(__phys_to_pte_val((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot))
 
 #define pte_none(pte)		(!pte_val(pte))
-#define pte_clear(mm,addr,ptep)	set_pte(ptep, __pte(0))
+#define pte_clear(mm, addr, ptep) \
+				__set_pte(ptep, __pte(0))
 #define pte_page(pte)		(pfn_to_page(pte_pfn(pte)))
 
 /*
@@ -261,7 +262,7 @@ static inline pte_t pte_mkdevmap(pte_t p
 	return set_pte_bit(pte, __pgprot(PTE_DEVMAP | PTE_SPECIAL));
 }
 
-static inline void set_pte(pte_t *ptep, pte_t pte)
+static inline void __set_pte(pte_t *ptep, pte_t pte)
 {
 	WRITE_ONCE(*ptep, pte);
 
@@ -350,7 +351,7 @@ static inline void set_ptes(struct mm_st
 
 	for (;;) {
 		__check_safe_pte_update(mm, ptep, pte);
-		set_pte(ptep, pte);
+		__set_pte(ptep, pte);
 		if (--nr == 0)
 			break;
 		ptep++;
@@ -534,7 +535,7 @@ static inline void __set_pte_at(struct m
 {
 	__sync_cache_and_tags(pte, nr);
 	__check_safe_pte_update(mm, ptep, pte);
-	set_pte(ptep, pte);
+	__set_pte(ptep, pte);
 }
 
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
@@ -1118,6 +1119,9 @@ extern pte_t ptep_modify_prot_start(stru
 extern void ptep_modify_prot_commit(struct vm_area_struct *vma,
 				    unsigned long addr, pte_t *ptep,
 				    pte_t old_pte, pte_t new_pte);
+
+#define set_pte					__set_pte
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* __ASM_PGTABLE_H */
--- a/arch/arm64/kernel/efi.c~arm64-mm-set_pte-new-layer-to-manage-contig-bit
+++ a/arch/arm64/kernel/efi.c
@@ -111,7 +111,7 @@ static int __init set_permissions(pte_t
 		pte = set_pte_bit(pte, __pgprot(PTE_PXN));
 	else if (system_supports_bti_kernel() && spd->has_bti)
 		pte = set_pte_bit(pte, __pgprot(PTE_GP));
-	set_pte(ptep, pte);
+	__set_pte(ptep, pte);
 	return 0;
 }
 
--- a/arch/arm64/mm/fixmap.c~arm64-mm-set_pte-new-layer-to-manage-contig-bit
+++ a/arch/arm64/mm/fixmap.c
@@ -121,7 +121,7 @@ void __set_fixmap(enum fixed_addresses i
 	ptep = fixmap_pte(addr);
 
 	if (pgprot_val(flags)) {
-		set_pte(ptep, pfn_pte(phys >> PAGE_SHIFT, flags));
+		__set_pte(ptep, pfn_pte(phys >> PAGE_SHIFT, flags));
 	} else {
 		pte_clear(&init_mm, addr, ptep);
 		flush_tlb_kernel_range(addr, addr+PAGE_SIZE);
--- a/arch/arm64/mm/kasan_init.c~arm64-mm-set_pte-new-layer-to-manage-contig-bit
+++ a/arch/arm64/mm/kasan_init.c
@@ -112,7 +112,7 @@ static void __init kasan_pte_populate(pm
 		if (!early)
 			memset(__va(page_phys), KASAN_SHADOW_INIT, PAGE_SIZE);
 		next = addr + PAGE_SIZE;
-		set_pte(ptep, pfn_pte(__phys_to_pfn(page_phys), PAGE_KERNEL));
+		__set_pte(ptep, pfn_pte(__phys_to_pfn(page_phys), PAGE_KERNEL));
 	} while (ptep++, addr = next, addr != end && pte_none(READ_ONCE(*ptep)));
 }
 
@@ -266,7 +266,7 @@ static void __init kasan_init_shadow(voi
 	 * so we should make sure that it maps the zero page read-only.
 	 */
 	for (i = 0; i < PTRS_PER_PTE; i++)
-		set_pte(&kasan_early_shadow_pte[i],
+		__set_pte(&kasan_early_shadow_pte[i],
 			pfn_pte(sym_to_pfn(kasan_early_shadow_page),
 				PAGE_KERNEL_RO));
 
--- a/arch/arm64/mm/mmu.c~arm64-mm-set_pte-new-layer-to-manage-contig-bit
+++ a/arch/arm64/mm/mmu.c
@@ -178,7 +178,7 @@ static void init_pte(pmd_t *pmdp, unsign
 	do {
 		pte_t old_pte = READ_ONCE(*ptep);
 
-		set_pte(ptep, pfn_pte(__phys_to_pfn(phys), prot));
+		__set_pte(ptep, pfn_pte(__phys_to_pfn(phys), prot));
 
 		/*
 		 * After the PTE entry has been populated once, we
--- a/arch/arm64/mm/pageattr.c~arm64-mm-set_pte-new-layer-to-manage-contig-bit
+++ a/arch/arm64/mm/pageattr.c
@@ -41,7 +41,7 @@ static int change_page_range(pte_t *ptep
 	pte = clear_pte_bit(pte, cdata->clear_mask);
 	pte = set_pte_bit(pte, cdata->set_mask);
 
-	set_pte(ptep, pte);
+	__set_pte(ptep, pte);
 	return 0;
 }
 
--- a/arch/arm64/mm/trans_pgd.c~arm64-mm-set_pte-new-layer-to-manage-contig-bit
+++ a/arch/arm64/mm/trans_pgd.c
@@ -41,7 +41,7 @@ static void _copy_pte(pte_t *dst_ptep, p
 		 * read only (code, rodata). Clear the RDONLY bit from
 		 * the temporary mappings we use during restore.
 		 */
-		set_pte(dst_ptep, pte_mkwrite_novma(pte));
+		__set_pte(dst_ptep, pte_mkwrite_novma(pte));
 	} else if ((debug_pagealloc_enabled() ||
 		   is_kfence_address((void *)addr)) && !pte_none(pte)) {
 		/*
@@ -55,7 +55,7 @@ static void _copy_pte(pte_t *dst_ptep, p
 		 */
 		BUG_ON(!pfn_valid(pte_pfn(pte)));
 
-		set_pte(dst_ptep, pte_mkpresent(pte_mkwrite_novma(pte)));
+		__set_pte(dst_ptep, pte_mkpresent(pte_mkwrite_novma(pte)));
 	}
 }
 
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

