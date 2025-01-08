Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B181A83E4
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 06:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736317665; cv=none; b=trQ1+ewYf9Tk0tz7ppZrvkLqCEQafcwMmefoQDr3zXxr+ewEYwJJVFfBKvpXlCVUovpFxQxIqMfcuZyj30H7u4dNMS8HONfR9c1MKP44T/53mZYWV/lfwD2Nv+oIWg3MWiteTDH1IohzBoBZlodfweZWduvsHvdmPbTyU2nGcbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736317665; c=relaxed/simple;
	bh=tFAUoxXfGKftPjJjYITsyHx60fxk3TN2C2KVAuTJQi0=;
	h=Date:To:From:Subject:Message-Id; b=VtVXgGkExIMEHwbyWb3iFyqLESarIxVoQ7qHoCFlocD/KboA0pAZ1ZiIYXuozJ0FnqzDum6Ic7F4QBbPb6cokztuqACwxOAStEs1f5w87snSg2hmT6/s8mCXwrqkVdAaNUygBs2UjRAzRqSKxh+zqcg2PHd8PzJ5J8gpx/dphSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uWAanFIr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uWAanFIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748C3C4CED0;
	Wed,  8 Jan 2025 06:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736317665;
	bh=tFAUoxXfGKftPjJjYITsyHx60fxk3TN2C2KVAuTJQi0=;
	h=Date:To:From:Subject:From;
	b=uWAanFIrMN6l6yicILUXkwYibaXkGRuciI8Y04iS1SGENvpjHTZVYVIS1Bmplm0Lv
	 Puvv2zhI177irdjvEKuDIbu2Rzt3I7oZd8ohRNqe0DQvHUa+NGEsn6z7zoXnGDhddQ
	 Wsgs9iK8hQQGH4HzDDO3s/Bpvik4wbHfNShIi7Js=
Date: Tue, 07 Jan 2025 22:27:44 -0800
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,bjorn@rivosinc.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-riscv-mm-add-support-for-zone_device.patch added to mm-unstable branch
Message-Id: <20250108062745.748C3C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "riscv: mm: add support for ZONE_DEVICE"
has been added to the -mm mm-unstable branch.  Its filename is
     revert-riscv-mm-add-support-for-zone_device.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-riscv-mm-add-support-for-zone_device.patch

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
From: Alistair Popple <apopple@nvidia.com>
Subject: Revert "riscv: mm: add support for ZONE_DEVICE"
Date: Tue, 7 Jan 2025 14:42:41 +1100

DEVMAP PTEs are no longer required to support ZONE_DEVICE so remove them.

Link: https://lkml.kernel.org/r/dd557b20d49a08f6172e6cff76753850300fda57.1736221254.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Suggested-by: Chunyan Zhang <zhang.lyra@gmail.com>
Reviewed-by: Björn Töpel <bjorn@rivosinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/Kconfig                    |    1 -
 arch/riscv/include/asm/pgtable-64.h   |   20 --------------------
 arch/riscv/include/asm/pgtable-bits.h |    1 -
 arch/riscv/include/asm/pgtable.h      |   17 -----------------
 4 files changed, 39 deletions(-)

--- a/arch/riscv/include/asm/pgtable-64.h~revert-riscv-mm-add-support-for-zone_device
+++ a/arch/riscv/include/asm/pgtable-64.h
@@ -398,24 +398,4 @@ static inline struct page *pgd_page(pgd_
 #define p4d_offset p4d_offset
 p4d_t *p4d_offset(pgd_t *pgd, unsigned long address);
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static inline int pte_devmap(pte_t pte);
-static inline pte_t pmd_pte(pmd_t pmd);
-
-static inline int pmd_devmap(pmd_t pmd)
-{
-	return pte_devmap(pmd_pte(pmd));
-}
-
-static inline int pud_devmap(pud_t pud)
-{
-	return 0;
-}
-
-static inline int pgd_devmap(pgd_t pgd)
-{
-	return 0;
-}
-#endif
-
 #endif /* _ASM_RISCV_PGTABLE_64_H */
--- a/arch/riscv/include/asm/pgtable-bits.h~revert-riscv-mm-add-support-for-zone_device
+++ a/arch/riscv/include/asm/pgtable-bits.h
@@ -19,7 +19,6 @@
 #define _PAGE_SOFT      (3 << 8)    /* Reserved for software */
 
 #define _PAGE_SPECIAL   (1 << 8)    /* RSW: 0x1 */
-#define _PAGE_DEVMAP    (1 << 9)    /* RSW, devmap */
 #define _PAGE_TABLE     _PAGE_PRESENT
 
 /*
--- a/arch/riscv/include/asm/pgtable.h~revert-riscv-mm-add-support-for-zone_device
+++ a/arch/riscv/include/asm/pgtable.h
@@ -399,13 +399,6 @@ static inline int pte_special(pte_t pte)
 	return pte_val(pte) & _PAGE_SPECIAL;
 }
 
-#ifdef CONFIG_ARCH_HAS_PTE_DEVMAP
-static inline int pte_devmap(pte_t pte)
-{
-	return pte_val(pte) & _PAGE_DEVMAP;
-}
-#endif
-
 /* static inline pte_t pte_rdprotect(pte_t pte) */
 
 static inline pte_t pte_wrprotect(pte_t pte)
@@ -447,11 +440,6 @@ static inline pte_t pte_mkspecial(pte_t
 	return __pte(pte_val(pte) | _PAGE_SPECIAL);
 }
 
-static inline pte_t pte_mkdevmap(pte_t pte)
-{
-	return __pte(pte_val(pte) | _PAGE_DEVMAP);
-}
-
 static inline pte_t pte_mkhuge(pte_t pte)
 {
 	return pte;
@@ -763,11 +751,6 @@ static inline pmd_t pmd_mkdirty(pmd_t pm
 	return pte_pmd(pte_mkdirty(pmd_pte(pmd)));
 }
 
-static inline pmd_t pmd_mkdevmap(pmd_t pmd)
-{
-	return pte_pmd(pte_mkdevmap(pmd_pte(pmd)));
-}
-
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 				pmd_t *pmdp, pmd_t pmd)
 {
--- a/arch/riscv/Kconfig~revert-riscv-mm-add-support-for-zone_device
+++ a/arch/riscv/Kconfig
@@ -42,7 +42,6 @@ config RISCV
 	select ARCH_HAS_PMEM_API
 	select ARCH_HAS_PREEMPT_LAZY
 	select ARCH_HAS_PREPARE_SYNC_CORE_CMD
-	select ARCH_HAS_PTE_DEVMAP if 64BIT && MMU
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_SET_DIRECT_MAP if MMU
 	select ARCH_HAS_SET_MEMORY if MMU
_

Patches currently in -mm which might be from apopple@nvidia.com are

fuse-fix-dax-truncate-punch_hole-fault-path.patch
fs-dax-return-unmapped-busy-pages-from-dax_layout_busy_page_range.patch
fs-dax-dont-skip-locked-entries-when-scanning-entries.patch
fs-dax-refactor-wait-for-dax-idle-page.patch
fs-dax-create-a-common-implementation-to-break-dax-layouts.patch
fs-dax-always-remove-dax-page-cache-entries-when-breaking-layouts.patch
fs-dax-ensure-all-pages-are-idle-prior-to-filesystem-unmount.patch
fs-dax-remove-page_mapping_dax_shared-mapping-flag.patch
mm-gup-remove-redundant-check-for-pci-p2pdma-page.patch
mm-mm_init-move-p2pdma-page-refcount-initialisation-to-p2pdma.patch
mm-allow-compound-zone-device-pages.patch
mm-memory-enhance-insert_page_into_pte_locked-to-create-writable-mappings.patch
mm-memory-add-vmf_insert_page_mkwrite.patch
rmap-add-support-for-pud-sized-mappings-to-rmap.patch
huge_memory-add-vmf_insert_folio_pud.patch
huge_memory-add-vmf_insert_folio_pmd.patch
memremap-add-is_devdax_page-and-is_fsdax_page-helpers.patch
mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages.patch
proc-task_mmu-mark-devdax-and-fsdax-pages-as-always-unpinned.patch
mm-mlock-skip-zone_device-pmds-during-mlock.patch
fs-dax-properly-refcount-fs-dax-pages.patch
device-dax-properly-refcount-device-dax-pages-when-mapping.patch
mm-remove-pxx_devmap-callers.patch
mm-remove-devmap-related-functions-and-page-table-bits.patch
revert-riscv-mm-add-support-for-zone_device.patch

