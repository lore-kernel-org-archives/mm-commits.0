Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C826930FC0F
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465720; cv=none; b=Fb686n4Q8spWFRsvA+wPiM6buCTCLDC4P6hEdeMzmuRsmwkvjArWXOMrJ1lCvHGtMO9nYd3av3hmI9Z/9EHEzZCeAKLYA0ZydkmKbcgoz1yiuAR0mKoZqy8hJY/89F7zUSb3Lg8tTMnxcl9CRXbNrXjoltlG7Lnj9ZaYu9aW/0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465720; c=relaxed/simple;
	bh=Bx/IP9nkbOXE9z3/dmiKykWPwHuZyA54HK4UKLEWQHU=;
	h=Date:To:From:Subject:Message-Id; b=pkL5WsB61ET6zo4auQOkAu9xvajmWj+LhzJ6UTC3q7+wZtdnWHy+BastmHzn4l79gm9qli9DhD/xbaeJauMJ5F+w3FnW2X15xm0kkispSx1hzb2JiwjC/TcJ6LNI/qqYQ8MGooxK149junPF/Qo9MnOKq6hsN47OxZCwHNsVF9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z8f9akay; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z8f9akay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25BF11F00A3A;
	Fri, 31 Jul 2026 02:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465718;
	bh=OYaVlqXGxdT1h1CtJM7LuuqXqai+HPfTK9p8Yabq3KQ=;
	h=Date:To:From:Subject;
	b=Z8f9akayYge2bNVihvBbu+McUr8K/Gp5Hx/P9X1IOCaV33Q7Zzfdd8f9UcGxdUMN9
	 gj06CyyS1dbPBU4U7+KK+OjB7Y+VuQiiXmSAC55EAmLiDwdl/15NYCvi9Hb5fFHaAx
	 DctgHX4zVAsubj4lARw2fIt1HvudEH7cMbauaTts=
Date: Thu, 30 Jul 2026 19:41:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,willy@infradead.org,vbabka@kernel.org,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,riel@surriel.com,nphamcs@gmail.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,kas@kernel.org,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,alex@ghiti.fr,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves.patch removed from -mm tree
Message-Id: <20260731024158.25BF11F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rename ARCH_ENABLE_THP_MIGRATION to ARCH_HAS_PMD_SOFTLEAVES
has been removed from the -mm tree.  Its filename was
     mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usama.arif@linux.dev>
Subject: mm: rename ARCH_ENABLE_THP_MIGRATION to ARCH_HAS_PMD_SOFTLEAVES
Date: Mon, 6 Jul 2026 04:42:08 -0700

CONFIG_ARCH_ENABLE_THP_MIGRATION gates PMD-level migration entries. 
PMD-level device-private entries use the same migration mechanism and
therefore require the same architecture support.

Upcoming PMD-level swap entries can use the same PMD softleaf helpers
without depending on page migration, so rename the architecture gate to
CONFIG_ARCH_HAS_PMD_SOFTLEAVES.  This describes the PMD entry capability
rather than one current user of it.

This is a pure rename: the set of selecting architectures (x86, arm64,
s390, riscv, loongarch, and powerpc on PPC_BOOK3S_64) and the gating
semantics are unchanged.

No functional change intended.

Link: https://lore.kernel.org/20260706114320.1643046-7-usama.arif@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig                           |    2 +-
 arch/arm64/include/asm/pgtable.h             |    4 ++--
 arch/loongarch/Kconfig                       |    2 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h |    2 +-
 arch/powerpc/platforms/Kconfig.cputype       |    2 +-
 arch/riscv/Kconfig                           |    2 +-
 arch/riscv/include/asm/pgtable.h             |    8 ++++----
 arch/s390/Kconfig                            |    2 +-
 arch/s390/include/asm/pgtable.h              |    2 +-
 arch/x86/Kconfig                             |    2 +-
 arch/x86/include/asm/pgtable.h               |    2 +-
 include/linux/huge_mm.h                      |    2 +-
 include/linux/leafops.h                      |    8 ++++----
 include/linux/pgtable.h                      |    2 +-
 include/linux/swapops.h                      |    6 +++---
 mm/Kconfig                                   |    2 +-
 mm/debug_vm_pgtable.c                        |    8 ++++----
 mm/hmm.c                                     |    4 ++--
 mm/huge_memory.c                             |    2 +-
 mm/migrate.c                                 |    4 ++--
 mm/migrate_device.c                          |    6 +++---
 mm/rmap.c                                    |    2 +-
 22 files changed, 38 insertions(+), 38 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1534,10 +1534,10 @@ static inline pmd_t pmdp_establish(struc
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(swp)	((pte_t) { (swp).val })
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 #define __pmd_to_swp_entry(pmd)		((swp_entry_t) { pmd_val(pmd) })
 #define __swp_entry_to_pmd(swp)		__pmd((swp).val)
-#endif /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#endif /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 
 /*
  * Ensure that there are not more swap files than can be encoded in the kernel
--- a/arch/arm64/Kconfig~mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves
+++ a/arch/arm64/Kconfig
@@ -17,7 +17,7 @@ config ARM64
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
-	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
+	select ARCH_HAS_PMD_SOFTLEAVES if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_CC_PLATFORM
 	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
--- a/arch/loongarch/Kconfig~mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves
+++ a/arch/loongarch/Kconfig
@@ -12,7 +12,7 @@ config LOONGARCH
 	select ARCH_NEEDS_DEFER_KASAN
 	select ARCH_DISABLE_KASAN_INLINE
 	select ARCH_ENABLE_MEMORY_HOTPLUG
-	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
+	select ARCH_HAS_PMD_SOFTLEAVES if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
 	select ARCH_HAS_CPU_FINALIZE_INIT
 	select ARCH_HAS_CURRENT_STACK_POINTER
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1060,7 +1060,7 @@ static inline pte_t *pmdp_ptep(pmd_t *pm
 #define pmd_mksoft_dirty(pmd)  pte_pmd(pte_mksoft_dirty(pmd_pte(pmd)))
 #define pmd_clear_soft_dirty(pmd) pte_pmd(pte_clear_soft_dirty(pmd_pte(pmd)))
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 #define pmd_swp_mksoft_dirty(pmd)	pte_pmd(pte_swp_mksoft_dirty(pmd_pte(pmd)))
 #define pmd_swp_soft_dirty(pmd)		pte_swp_soft_dirty(pmd_pte(pmd))
 #define pmd_swp_clear_soft_dirty(pmd)	pte_pmd(pte_swp_clear_soft_dirty(pmd_pte(pmd)))
--- a/arch/powerpc/platforms/Kconfig.cputype~mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves
+++ a/arch/powerpc/platforms/Kconfig.cputype
@@ -112,7 +112,7 @@ config PPC_THP
        depends on PPC_RADIX_MMU || (PPC_64S_HASH_MMU && PAGE_SIZE_64KB)
        select HAVE_ARCH_TRANSPARENT_HUGEPAGE
        select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
-       select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
+       select ARCH_HAS_PMD_SOFTLEAVES if TRANSPARENT_HUGEPAGE
 
 choice
 	prompt "CPU selection"
--- a/arch/riscv/include/asm/pgtable.h~mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves
+++ a/arch/riscv/include/asm/pgtable.h
@@ -946,7 +946,7 @@ static inline pmd_t pmd_clear_soft_dirty
 	return pte_pmd(pte_clear_soft_dirty(pmd_pte(pmd)));
 }
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 static inline bool pmd_swp_soft_dirty(pmd_t pmd)
 {
 	return pte_swp_soft_dirty(pmd_pte(pmd));
@@ -961,7 +961,7 @@ static inline pmd_t pmd_swp_clear_soft_d
 {
 	return pte_pmd(pte_swp_clear_soft_dirty(pmd_pte(pmd)));
 }
-#endif /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#endif /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 #endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
 
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
@@ -1208,10 +1208,10 @@ static inline pte_t pte_swp_clear_exclus
 	return __pte(pte_val(pte) & ~_PAGE_SWP_EXCLUSIVE);
 }
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 #define __pmd_to_swp_entry(pmd) ((swp_entry_t) { pmd_val(pmd) })
 #define __swp_entry_to_pmd(swp) __pmd((swp).val)
-#endif /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#endif /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 
 /*
  * In the RV64 Linux scheme, we give the user half of the virtual-address space
--- a/arch/riscv/Kconfig~mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves
+++ a/arch/riscv/Kconfig
@@ -22,7 +22,7 @@ config RISCV
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG if SPARSEMEM_VMEMMAP
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
-	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
+	select ARCH_HAS_PMD_SOFTLEAVES if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_BINFMT_FLAT
 	select ARCH_HAS_CC_CAN_LINK
 	select ARCH_HAS_CURRENT_STACK_POINTER
--- a/arch/s390/include/asm/pgtable.h~mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves
+++ a/arch/s390/include/asm/pgtable.h
@@ -903,7 +903,7 @@ static inline pmd_t pmd_clear_soft_dirty
 	return clear_pmd_bit(pmd, __pgprot(_SEGMENT_ENTRY_SOFT_DIRTY));
 }
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 #define pmd_swp_soft_dirty(pmd)		pmd_soft_dirty(pmd)
 #define pmd_swp_mksoft_dirty(pmd)	pmd_mksoft_dirty(pmd)
 #define pmd_swp_clear_soft_dirty(pmd)	pmd_clear_soft_dirty(pmd)
--- a/arch/s390/Kconfig~mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves
+++ a/arch/s390/Kconfig
@@ -82,7 +82,7 @@ config S390
 	select ARCH_CORRECT_STACKTRACE_ON_KRETPROBE
 	select ARCH_ENABLE_MEMORY_HOTPLUG if SPARSEMEM
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
-	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
+	select ARCH_HAS_PMD_SOFTLEAVES if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_CC_CAN_LINK
 	select ARCH_HAS_CPU_FINALIZE_INIT
 	select ARCH_HAS_CURRENT_STACK_POINTER
--- a/arch/x86/include/asm/pgtable.h~mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves
+++ a/arch/x86/include/asm/pgtable.h
@@ -1545,7 +1545,7 @@ static inline pte_t pte_swp_clear_soft_d
 	return pte_clear_flags(pte, _PAGE_SWP_SOFT_DIRTY);
 }
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
 {
 	return pmd_set_flags(pmd, _PAGE_SWP_SOFT_DIRTY);
--- a/arch/x86/Kconfig~mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves
+++ a/arch/x86/Kconfig
@@ -70,7 +70,7 @@ config X86
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if X86_64 && HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG if X86_64
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if (PGTABLE_LEVELS > 2) && (X86_64 || X86_PAE)
-	select ARCH_ENABLE_THP_MIGRATION if X86_64 && TRANSPARENT_HUGEPAGE
+	select ARCH_HAS_PMD_SOFTLEAVES if X86_64 && TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
 	select ARCH_HAS_CPU_ATTACK_VECTORS	if CPU_MITIGATIONS
 	select ARCH_HAS_CACHE_LINE_SIZE
--- a/include/linux/huge_mm.h~mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves
+++ a/include/linux/huge_mm.h
@@ -567,7 +567,7 @@ static inline struct folio *get_persiste
 
 static inline bool thp_migration_supported(void)
 {
-	return IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION);
+	return IS_ENABLED(CONFIG_ARCH_HAS_PMD_SOFTLEAVES);
 }
 
 void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
--- a/include/linux/leafops.h~mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves
+++ a/include/linux/leafops.h
@@ -81,7 +81,7 @@ static inline pte_t softleaf_to_pte(soft
 	return swp_entry_to_pte(entry);
 }
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 /**
  * softleaf_from_pmd() - Obtain a leaf entry from a PMD entry.
  * @pmd: PMD entry.
@@ -587,7 +587,7 @@ static inline bool pte_is_uffd_marker(pt
 	return false;
 }
 
-#if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_ARCH_ENABLE_THP_MIGRATION)
+#if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_ARCH_HAS_PMD_SOFTLEAVES)
 
 /**
  * pmd_is_device_private_entry() - Check if PMD contains a device private swap
@@ -606,14 +606,14 @@ static inline bool pmd_is_device_private
 	return softleaf_is_device_private(softleaf_from_pmd(pmd));
 }
 
-#else  /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#else  /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 
 static inline bool pmd_is_device_private_entry(pmd_t pmd)
 {
 	return false;
 }
 
-#endif /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#endif /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 
 /**
  * pmd_is_migration_entry() - Does this PMD entry encode a migration entry?
--- a/include/linux/pgtable.h~mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves
+++ a/include/linux/pgtable.h
@@ -1839,7 +1839,7 @@ static inline pgprot_t pgprot_modify(pgp
 #endif
 
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
-#ifndef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifndef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
 {
 	return pmd;
--- a/include/linux/swapops.h~mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves
+++ a/include/linux/swapops.h
@@ -321,7 +321,7 @@ static inline swp_entry_t make_guard_swp
 
 struct page_vma_mapped_walk;
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 extern int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 		struct page *page);
 
@@ -338,7 +338,7 @@ static inline pmd_t swp_entry_to_pmd(swp
 	return __swp_entry_to_pmd(arch_entry);
 }
 
-#else  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#else  /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 static inline int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 		struct page *page)
 {
@@ -358,7 +358,7 @@ static inline pmd_t swp_entry_to_pmd(swp
 	return __pmd(0);
 }
 
-#endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#endif  /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 
 #endif /* CONFIG_MMU */
 #endif /* _LINUX_SWAPOPS_H */
--- a/mm/debug_vm_pgtable.c~mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves
+++ a/mm/debug_vm_pgtable.c
@@ -751,7 +751,7 @@ static void __init pmd_leaf_soft_dirty_t
 	pmd_t pmd;
 
 	if (!pgtable_supports_soft_dirty() ||
-	    !IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION))
+	    !IS_ENABLED(CONFIG_ARCH_HAS_PMD_SOFTLEAVES))
 		return;
 
 	if (!has_transparent_hugepage())
@@ -819,7 +819,7 @@ static void __init pte_swap_tests(struct
 	WARN_ON(memcmp(&pte1, &pte2, sizeof(pte1)));
 }
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 static void __init pmd_softleaf_tests(struct pgtable_debug_args *args)
 {
 	swp_entry_t arch_entry;
@@ -837,9 +837,9 @@ static void __init pmd_softleaf_tests(st
 	pmd2 = __swp_entry_to_pmd(arch_entry);
 	WARN_ON(memcmp(&pmd1, &pmd2, sizeof(pmd1)));
 }
-#else  /* !CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#else  /* !CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 static void __init pmd_softleaf_tests(struct pgtable_debug_args *args) { }
-#endif /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#endif /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 
 static void __init swap_migration_tests(struct pgtable_debug_args *args)
 {
--- a/mm/hmm.c~mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves
+++ a/mm/hmm.c
@@ -331,7 +331,7 @@ fault:
 	return hmm_vma_fault(addr, end, required_fault, walk);
 }
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 				     unsigned long end, unsigned long *hmm_pfns,
 				     pmd_t pmd)
@@ -391,7 +391,7 @@ static int hmm_vma_handle_absent_pmd(str
 		return -EFAULT;
 	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
 }
-#endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#endif  /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 
 static int hmm_vma_walk_pmd(pmd_t *pmdp,
 			    unsigned long start,
--- a/mm/huge_memory.c~mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves
+++ a/mm/huge_memory.c
@@ -4868,7 +4868,7 @@ static int __init split_huge_pages_debug
 late_initcall(split_huge_pages_debugfs);
 #endif
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 		struct page *page)
 {
--- a/mm/Kconfig~mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves
+++ a/mm/Kconfig
@@ -703,7 +703,7 @@ config DEVICE_MIGRATION
 config ARCH_ENABLE_HUGEPAGE_MIGRATION
 	bool
 
-config ARCH_ENABLE_THP_MIGRATION
+config ARCH_HAS_PMD_SOFTLEAVES
 	bool
 
 config HUGETLB_PAGE_SIZE_VARIABLE
--- a/mm/migrate.c~mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves
+++ a/mm/migrate.c
@@ -362,7 +362,7 @@ static bool remove_migration_pte(struct
 			idx = linear_page_index(vma, pvmw.address) - pvmw.pgoff;
 		new = folio_page(folio, idx);
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 		/* PMD-mapped THP migration entry */
 		if (!pvmw.pte) {
 			VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
@@ -545,7 +545,7 @@ fail:
 }
 #endif
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 void pmd_migration_entry_wait(struct mm_struct *mm, pmd_t *pmd)
 {
 	spinlock_t *ptl;
--- a/mm/migrate_device.c~mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves
+++ a/mm/migrate_device.c
@@ -772,7 +772,7 @@ int migrate_vma_setup(struct migrate_vma
 }
 EXPORT_SYMBOL(migrate_vma_setup);
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 /**
  * migrate_vma_insert_huge_pmd_page: Insert a huge folio into @migrate->vma->vm_mm
  * at @addr. folio is already allocated as a part of the migration process with
@@ -927,7 +927,7 @@ static int migrate_vma_split_unmapped_fo
 		migrate->src[i+idx] = migrate_pfn(pfn + i) | flags;
 	return ret;
 }
-#else /* !CONFIG_ARCH_ENABLE_THP_MIGRATION */
+#else /* !CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 					 unsigned long addr,
 					 struct page *page,
@@ -948,7 +948,7 @@ static int migrate_vma_split_unmapped_fo
 static unsigned long migrate_vma_nr_pages(unsigned long *src)
 {
 	unsigned long nr = 1;
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 	if (*src & MIGRATE_PFN_COMPOUND)
 		nr = HPAGE_PMD_NR;
 #else
--- a/mm/rmap.c~mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves
+++ a/mm/rmap.c
@@ -2472,7 +2472,7 @@ static bool try_to_migrate_one(struct fo
 				page_vma_mapped_walk_restart(&pvmw);
 				continue;
 			}
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 			pmdval = pmdp_get(pvmw.pmd);
 			if (likely(pmd_present(pmdval)))
 				pfn = pmd_pfn(pmdval);
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-mempolicy-skip-non-present-pmds-when-queueing-folios.patch
mm-madvise-skip-device-private-pmds-in-cold-and-pageout-walks.patch
mm-huge_memory-skip-device-private-pmds-in-madvise_free_huge_pmd.patch
mm-vmstat-mm-memcontrol-add-_monotonic-vmstat-readers.patch
mm-vmscan-reduce-lru_lock-contention-via-vmstat-derived-scan-balance-cost.patch

