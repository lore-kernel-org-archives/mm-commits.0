Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A135422A1D4
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 02:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783562787; cv=none; b=NS/Vzc/nvYlxRZ/azqJ9o7vIOnVaMYjOvByLpfcfXbnQ1zaNwve3YR0XGTDeAMDWIdunLpwkSlc+Iix3RGlsDWKFFFDgU0fI3fYrR8UkWGFJovTUxLUIa6G3wQ/Lbl2s7FrIo4UwehcgMQg6F/uRw80BtN/D+Xo7O1orS6KJTWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783562787; c=relaxed/simple;
	bh=yIsjsi+Y442LAyWpYbee1elbMnphHNQOahQuiUblmrk=;
	h=Date:To:From:Subject:Message-Id; b=plChKua5efBrG7jtKD+14YcLlBie9T0fV34FXaDL3gt/HHUdTg1dnrOLrd7uM+s5/EFppP++UuAA1T0m4h4OEerhkJHLrKgOjoXpb+MU8X4N5qh8SqMQJWw8kbhm3TnUSuABXYRDbZq0Pl/ZZEFKsfrZ5/VEk6tDjP+rVppLGdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BGVNw3jI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BGVNw3jI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4D41F000E9;
	Thu,  9 Jul 2026 02:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783562785;
	bh=8d9TdU7GdQ2WOA9mmw30A5j4m44qtbhDxBWR8LsjIns=;
	h=Date:To:From:Subject;
	b=BGVNw3jI49gVNsatXFN6kVVg64CVd7t+A0rLIq2QzRrvF8wGlRDZGnG8DUzPLbe6X
	 T6MIFXdlamo9ooott3bT8ULKWLOMPQ5q4Y+RKP/80eHi9fbr8/Q9ZSIMdVchLzjgww
	 P9rvl/2C4Ia2mEmu9nqhMFtPjR+EhXfro90umrXs=
Date: Wed, 08 Jul 2026 19:06:24 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-decouple-protnone-helpers-from-config_numa_balancing.patch added to mm-new branch
Message-Id: <20260709020625.1F4D41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: decouple protnone helpers from CONFIG_NUMA_BALANCING
has been added to the -mm mm-new branch.  Its filename is
     mm-decouple-protnone-helpers-from-config_numa_balancing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-decouple-protnone-helpers-from-config_numa_balancing.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm: decouple protnone helpers from CONFIG_NUMA_BALANCING
Date: Wed, 8 Jul 2026 12:14:02 +0100

Patch series "userfaultfd: working set tracking for VM guest memory", v10.

This series adds userfaultfd support for tracking the working set of VM
guest memory, so a VMM can identify hot pages and reclaim cold ones to
tiered or remote storage.


This patch (of 15):

pte_protnone() and pmd_protnone() detect present-but-inaccessible page
table entries.  This capability is useful beyond NUMA balancing -- for
example, userfaultfd working set tracking uses protnone PTEs to track page
access without unmapping pages.

Introduce CONFIG_ARCH_HAS_PTE_PROTNONE to decouple the protnone PTE
infrastructure from CONFIG_NUMA_BALANCING.  The six architectures that
support protnone PTEs (x86_64, arm64, powerpc, s390, riscv, loongarch) now
select this option, and CONFIG_NUMA_BALANCING depends on it.

No functional change -- the same set of architectures continues to have
working protnone support, but the infrastructure is now available
independently of NUMA balancing.

Link: https://lore.kernel.org/20260708111417.173443-1-kirill@shutemov.name
Link: https://lore.kernel.org/20260708111417.173443-2-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: James Houghton <jthoughton@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig                           |    1 
 arch/arm64/include/asm/pgtable.h             |    7 +--
 arch/loongarch/Kconfig                       |    1 
 arch/loongarch/include/asm/pgtable.h         |    4 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h |    8 ++--
 arch/powerpc/platforms/Kconfig.cputype       |    1 
 arch/riscv/Kconfig                           |    1 
 arch/riscv/include/asm/pgtable.h             |    7 +--
 arch/s390/Kconfig                            |    1 
 arch/s390/include/asm/pgtable.h              |    4 +-
 arch/x86/Kconfig                             |    1 
 arch/x86/include/asm/pgtable.h               |    8 +---
 include/linux/pgtable.h                      |   32 +++++++++++------
 init/Kconfig                                 |    8 ++++
 mm/debug_vm_pgtable.c                        |    4 +-
 15 files changed, 52 insertions(+), 36 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-decouple-protnone-helpers-from-config_numa_balancing
+++ a/arch/arm64/include/asm/pgtable.h
@@ -553,10 +553,7 @@ static inline pte_t pte_swp_clear_uffd_w
 }
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
-#ifdef CONFIG_NUMA_BALANCING
-/*
- * See the comment in include/linux/pgtable.h
- */
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pte_protnone(pte_t pte)
 {
 	/*
@@ -575,7 +572,7 @@ static inline int pmd_protnone(pmd_t pmd
 {
 	return pte_protnone(pmd_pte(pmd));
 }
-#endif
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 #define pmd_present(pmd)	pte_present(pmd_pte(pmd))
 #define pmd_dirty(pmd)		pte_dirty(pmd_pte(pmd))
--- a/arch/arm64/Kconfig~mm-decouple-protnone-helpers-from-config_numa_balancing
+++ a/arch/arm64/Kconfig
@@ -78,6 +78,7 @@ config ARM64
 	select ARCH_SUPPORTS_CFI
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
+	select ARCH_HAS_PTE_PROTNONE
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK
 	select ARCH_SUPPORTS_PER_VMA_LOCK
--- a/arch/loongarch/include/asm/pgtable.h~mm-decouple-protnone-helpers-from-config_numa_balancing
+++ a/arch/loongarch/include/asm/pgtable.h
@@ -623,7 +623,7 @@ static inline pmd_t pmdp_huge_get_and_cl
 
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline long pte_protnone(pte_t pte)
 {
 	return (pte_val(pte) & _PAGE_PROTNONE);
@@ -633,7 +633,7 @@ static inline long pmd_protnone(pmd_t pm
 {
 	return (pmd_val(pmd) & _PAGE_PROTNONE);
 }
-#endif /* CONFIG_NUMA_BALANCING */
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 #define pmd_leaf(pmd)		((pmd_val(pmd) & _PAGE_HUGE) != 0)
 #define pud_leaf(pud)		((pud_val(pud) & _PAGE_HUGE) != 0)
--- a/arch/loongarch/Kconfig~mm-decouple-protnone-helpers-from-config_numa_balancing
+++ a/arch/loongarch/Kconfig
@@ -67,6 +67,7 @@ config LOONGARCH
 	select ARCH_SUPPORTS_LTO_CLANG
 	select ARCH_SUPPORTS_LTO_CLANG_THIN
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
+	select ARCH_HAS_PTE_PROTNONE if 64BIT
 	select ARCH_SUPPORTS_NUMA_BALANCING if NUMA
 	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select ARCH_SUPPORTS_RT
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~mm-decouple-protnone-helpers-from-config_numa_balancing
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -490,13 +490,13 @@ static inline pte_t pte_clear_soft_dirty
 }
 #endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
 
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pte_protnone(pte_t pte)
 {
 	return (pte_raw(pte) & cpu_to_be64(_PAGE_PRESENT | _PAGE_PTE | _PAGE_RWX)) ==
 		cpu_to_be64(_PAGE_PRESENT | _PAGE_PTE);
 }
-#endif /* CONFIG_NUMA_BALANCING */
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 static inline bool pte_hw_valid(pte_t pte)
 {
@@ -1067,12 +1067,12 @@ static inline pte_t *pmdp_ptep(pmd_t *pm
 #endif
 #endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
 
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pmd_protnone(pmd_t pmd)
 {
 	return pte_protnone(pmd_pte(pmd));
 }
-#endif /* CONFIG_NUMA_BALANCING */
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 #define pmd_write(pmd)		pte_write(pmd_pte(pmd))
 
--- a/arch/powerpc/platforms/Kconfig.cputype~mm-decouple-protnone-helpers-from-config_numa_balancing
+++ a/arch/powerpc/platforms/Kconfig.cputype
@@ -87,6 +87,7 @@ config PPC_BOOK3S_64
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK
 	select ARCH_SUPPORTS_HUGETLBFS
+	select ARCH_HAS_PTE_PROTNONE
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select HAVE_MOVE_PMD
 	select HAVE_MOVE_PUD
--- a/arch/riscv/include/asm/pgtable.h~mm-decouple-protnone-helpers-from-config_numa_balancing
+++ a/arch/riscv/include/asm/pgtable.h
@@ -534,10 +534,7 @@ static inline pte_t pte_swp_clear_soft_d
 					PAGE_SIZE)
 #endif
 
-#ifdef CONFIG_NUMA_BALANCING
-/*
- * See the comment in include/asm-generic/pgtable.h
- */
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pte_protnone(pte_t pte)
 {
 	return (pte_val(pte) & (_PAGE_PRESENT | _PAGE_PROT_NONE)) == _PAGE_PROT_NONE;
@@ -547,7 +544,7 @@ static inline int pmd_protnone(pmd_t pmd
 {
 	return pte_protnone(pmd_pte(pmd));
 }
-#endif
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 /* Modify page protection bits */
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
--- a/arch/riscv/Kconfig~mm-decouple-protnone-helpers-from-config_numa_balancing
+++ a/arch/riscv/Kconfig
@@ -71,6 +71,7 @@ config RISCV
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS if 64BIT && MMU
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK if MMU
 	select ARCH_SUPPORTS_PER_VMA_LOCK if MMU
+	select ARCH_HAS_PTE_PROTNONE if MMU
 	select ARCH_SUPPORTS_RT
 	select ARCH_SUPPORTS_SHADOW_CALL_STACK if HAVE_SHADOW_CALL_STACK
 	select ARCH_SUPPORTS_SCHED_MC if SMP
--- a/arch/s390/include/asm/pgtable.h~mm-decouple-protnone-helpers-from-config_numa_balancing
+++ a/arch/s390/include/asm/pgtable.h
@@ -842,7 +842,7 @@ static inline int pte_same(pte_t a, pte_
 	return pte_val(a) == pte_val(b);
 }
 
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pte_protnone(pte_t pte)
 {
 	return pte_present(pte) && !(pte_val(pte) & _PAGE_READ);
@@ -853,7 +853,7 @@ static inline int pmd_protnone(pmd_t pmd
 	/* pmd_leaf(pmd) implies pmd_present(pmd) */
 	return pmd_leaf(pmd) && !(pmd_val(pmd) & _SEGMENT_ENTRY_READ);
 }
-#endif
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 static inline bool pte_swp_exclusive(pte_t pte)
 {
--- a/arch/s390/Kconfig~mm-decouple-protnone-helpers-from-config_numa_balancing
+++ a/arch/s390/Kconfig
@@ -148,6 +148,7 @@ config S390
 	select ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128 && CC_IS_CLANG
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
+	select ARCH_HAS_PTE_PROTNONE
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK
 	select ARCH_SUPPORTS_PER_VMA_LOCK
--- a/arch/x86/include/asm/pgtable.h~mm-decouple-protnone-helpers-from-config_numa_balancing
+++ a/arch/x86/include/asm/pgtable.h
@@ -985,11 +985,7 @@ static inline int pmd_present(pmd_t pmd)
 	return pmd_flags(pmd) & (_PAGE_PRESENT | _PAGE_PROTNONE | _PAGE_PSE);
 }
 
-#ifdef CONFIG_NUMA_BALANCING
-/*
- * These work without NUMA balancing but the kernel does not care. See the
- * comment in include/linux/pgtable.h
- */
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pte_protnone(pte_t pte)
 {
 	return (pte_flags(pte) & (_PAGE_PROTNONE | _PAGE_PRESENT))
@@ -1001,7 +997,7 @@ static inline int pmd_protnone(pmd_t pmd
 	return (pmd_flags(pmd) & (_PAGE_PROTNONE | _PAGE_PRESENT))
 		== _PAGE_PROTNONE;
 }
-#endif /* CONFIG_NUMA_BALANCING */
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 static inline int pmd_none(pmd_t pmd)
 {
--- a/arch/x86/Kconfig~mm-decouple-protnone-helpers-from-config_numa_balancing
+++ a/arch/x86/Kconfig
@@ -124,6 +124,7 @@ config X86
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	select ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK	if X86_64
+	select ARCH_HAS_PTE_PROTNONE		if X86_64
 	select ARCH_SUPPORTS_NUMA_BALANCING	if X86_64
 	select ARCH_SUPPORTS_KMAP_LOCAL_FORCE_MAP	if NR_CPUS <= 4096
 	select ARCH_SUPPORTS_CFI		if X86_64
--- a/include/linux/pgtable.h~mm-decouple-protnone-helpers-from-config_numa_balancing
+++ a/include/linux/pgtable.h
@@ -2110,18 +2110,26 @@ static inline int pud_trans_unstable(pud
 	return 0;
 }
 
-#ifndef CONFIG_NUMA_BALANCING
+#ifndef CONFIG_ARCH_HAS_PTE_PROTNONE
 /*
- * In an inaccessible (PROT_NONE) VMA, pte_protnone() may indicate "yes". It is
- * perfectly valid to indicate "no" in that case, which is why our default
- * implementation defaults to "always no".
+ * In an inaccessible (PROT_NONE) VMA, pte_protnone() may indicate "yes". It
+ * is perfectly valid to indicate "no" in that case, which is why our
+ * default implementation defaults to "always no".
  *
- * In an accessible VMA, however, pte_protnone() reliably indicates PROT_NONE
- * page protection due to NUMA hinting. NUMA hinting faults only apply in
- * accessible VMAs.
+ * In an accessible VMA, pte_protnone() reliably indicates a present
+ * PROT_NONE page protection. Today the kernel uses such PTEs for two
+ * purposes: NUMA hinting faults, and userfaultfd RWP tracking on
+ * VM_UFFD_RWP VMAs. The two are distinguished by the uffd PTE bit and
+ * the VMA flag; see include/linux/userfaultfd_k.h.
  *
- * So, to reliably identify PROT_NONE PTEs that require a NUMA hinting fault,
- * looking at the VMA accessibility is sufficient.
+ * So, to reliably identify PROT_NONE PTEs that require kernel handling,
+ * looking at the VMA accessibility (and the uffd bit on RWP VMAs) is
+ * sufficient.
+ *
+ * Architectures without CONFIG_ARCH_HAS_PTE_PROTNONE get the always-zero
+ * stubs below; PAGE_NONE references that survive to runtime fire the
+ * BUILD_BUG() fallback, since callers should have folded such paths to
+ * dead code via IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE).
  */
 static inline int pte_protnone(pte_t pte)
 {
@@ -2132,7 +2140,11 @@ static inline int pmd_protnone(pmd_t pmd
 {
 	return 0;
 }
-#endif /* CONFIG_NUMA_BALANCING */
+
+#ifndef PAGE_NONE
+#define PAGE_NONE ({ BUILD_BUG(); (pgprot_t){0}; })
+#endif
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 #endif /* CONFIG_MMU */
 
--- a/init/Kconfig~mm-decouple-protnone-helpers-from-config_numa_balancing
+++ a/init/Kconfig
@@ -945,6 +945,13 @@ config SCHED_PROXY_EXEC
 endmenu
 
 #
+# For architectures that support present-but-inaccessible (PROT_NONE) page
+# table entries detectable via pte_protnone() / pmd_protnone():
+#
+config ARCH_HAS_PTE_PROTNONE
+	bool
+
+#
 # For architectures that want to enable the support for NUMA-affine scheduler
 # balancing logic:
 #
@@ -1010,6 +1017,7 @@ config ARCH_WANT_NUMA_VARIABLE_LOCALITY
 config NUMA_BALANCING
 	bool "Memory placement aware NUMA scheduler"
 	depends on ARCH_SUPPORTS_NUMA_BALANCING
+	depends on ARCH_HAS_PTE_PROTNONE
 	depends on !ARCH_WANT_NUMA_VARIABLE_LOCALITY
 	depends on SMP && NUMA_MIGRATION && !PREEMPT_RT
 	help
--- a/mm/debug_vm_pgtable.c~mm-decouple-protnone-helpers-from-config_numa_balancing
+++ a/mm/debug_vm_pgtable.c
@@ -672,7 +672,7 @@ static void __init pte_protnone_tests(st
 {
 	pte_t pte = pfn_pte(args->fixed_pte_pfn, args->page_prot_none);
 
-	if (!IS_ENABLED(CONFIG_NUMA_BALANCING))
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE))
 		return;
 
 	pr_debug("Validating PTE protnone\n");
@@ -685,7 +685,7 @@ static void __init pmd_protnone_tests(st
 {
 	pmd_t pmd;
 
-	if (!IS_ENABLED(CONFIG_NUMA_BALANCING))
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE))
 		return;
 
 	if (!has_transparent_hugepage())
_

Patches currently in -mm which might be from kas@kernel.org are

mm-hugetlb-fix-swap-entry-corruption-when-clearing-uffd-wp-at-fork.patch
fs-proc-task_mmu-fix-pagemap_scan-written-state-for-unpopulated-ptes.patch
mm-decouple-protnone-helpers-from-config_numa_balancing.patch
mm-rename-uffd-wp-pte-bit-macros-to-uffd.patch
mm-rename-uffd-wp-pte-accessors-to-uffd.patch
userfaultfd-test-uffd-vma-flags-through-the-vma_flags_t-api.patch
mm-add-vm_uffd_rwp-vma-flag.patch
mm-add-mm_cp_uffd_rwp-change_protection-flag.patch
mm-preserve-rwp-marker-across-pte-rewrites.patch
mm-handle-vm_uffd_rwp-in-khugepaged-rmap-and-gup.patch
userfaultfd-add-uffdio_register_mode_rwp-and-uffdio_rwprotect-plumbing.patch
mm-userfaultfd-add-rwp-fault-delivery-and-expose-uffdio_register_mode_rwp.patch
mm-pagemap-add-page_is_accessed-for-rwp-tracking.patch
userfaultfd-add-uffd_feature_rwp_async-for-async-fault-resolution.patch
userfaultfd-add-uffdio_set_mode-for-runtime-sync-async-toggle.patch
selftests-mm-add-userfaultfd-rwp-tests.patch
documentation-userfaultfd-document-rwp-working-set-tracking.patch

