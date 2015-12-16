From: akpm@linux-foundation.org
Subject: + mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t.patch added to -mm
 tree
Date: Tue, 15 Dec 2015 16:17:10 -0800
Message-ID: <5670ad86.4XslxeRd1mU1FM9j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47312 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727AbbLPARL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2015 19:17:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, dave.hansen@linux.intel.com, viro@zeniv.linux.org.uk, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, dax: convert vmf_insert_pfn_pmd() to pfn_t
has been added to the -mm tree.  Its filename is
     mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm, dax: convert vmf_insert_pfn_pmd() to pfn_t

Similar to the conversion of vm_insert_mixed() use pfn_t in the
vmf_insert_pfn_pmd() to tag the resulting pte with _PAGE_DEVICE when the
pfn is backed by a devm_memremap_pages() mapping.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgtable_64.h     |    1 +
 arch/x86/include/asm/pgtable.h          |    6 ++++++
 arch/x86/mm/pat.c                       |    4 ++--
 drivers/gpu/drm/exynos/exynos_drm_gem.c |    2 +-
 drivers/gpu/drm/msm/msm_gem.c           |    2 +-
 drivers/gpu/drm/omapdrm/omap_gem.c      |    4 ++--
 fs/dax.c                                |    2 +-
 include/asm-generic/pgtable.h           |    6 ++++--
 include/linux/huge_mm.h                 |    2 +-
 include/linux/mm.h                      |   10 +++++++++-
 mm/huge_memory.c                        |   10 ++++++----
 mm/memory.c                             |    2 +-
 12 files changed, 35 insertions(+), 16 deletions(-)

diff -puN arch/sparc/include/asm/pgtable_64.h~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t arch/sparc/include/asm/pgtable_64.h
--- a/arch/sparc/include/asm/pgtable_64.h~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -245,6 +245,7 @@ static inline pte_t pfn_pte(unsigned lon
 #define mk_pte(page, pgprot)	pfn_pte(page_to_pfn(page), (pgprot))
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#define pfn_pmd pfn_pmd
 static inline pmd_t pfn_pmd(unsigned long page_nr, pgprot_t pgprot)
 {
 	pte_t pte = pfn_pte(page_nr, pgprot);
diff -puN arch/x86/include/asm/pgtable.h~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t
+++ a/arch/x86/include/asm/pgtable.h
@@ -289,6 +289,11 @@ static inline pmd_t pmd_mkdirty(pmd_t pm
 	return pmd_set_flags(pmd, _PAGE_DIRTY | _PAGE_SOFT_DIRTY);
 }
 
+static inline pmd_t pmd_mkdevmap(pmd_t pmd)
+{
+	return pmd_set_flags(pmd, _PAGE_DEVMAP);
+}
+
 static inline pmd_t pmd_mkhuge(pmd_t pmd)
 {
 	return pmd_set_flags(pmd, _PAGE_PSE);
@@ -363,6 +368,7 @@ static inline pte_t pfn_pte(unsigned lon
 		     massage_pgprot(pgprot));
 }
 
+#define pfn_pmd pfn_pmd
 static inline pmd_t pfn_pmd(unsigned long page_nr, pgprot_t pgprot)
 {
 	return __pmd(((phys_addr_t)page_nr << PAGE_SHIFT) |
diff -puN arch/x86/mm/pat.c~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t arch/x86/mm/pat.c
--- a/arch/x86/mm/pat.c~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t
+++ a/arch/x86/mm/pat.c
@@ -949,7 +949,7 @@ int track_pfn_remap(struct vm_area_struc
 }
 
 int track_pfn_insert(struct vm_area_struct *vma, pgprot_t *prot,
-		     unsigned long pfn)
+		     pfn_t pfn)
 {
 	enum page_cache_mode pcm;
 
@@ -957,7 +957,7 @@ int track_pfn_insert(struct vm_area_stru
 		return 0;
 
 	/* Set prot based on lookup */
-	pcm = lookup_memtype((resource_size_t)pfn << PAGE_SHIFT);
+	pcm = lookup_memtype(pfn_t_to_phys(pfn));
 	*prot = __pgprot((pgprot_val(vma->vm_page_prot) & (~_PAGE_CACHE_MASK)) |
 			 cachemode2protval(pcm));
 
diff -puN drivers/gpu/drm/exynos/exynos_drm_gem.c~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t drivers/gpu/drm/exynos/exynos_drm_gem.c
--- a/drivers/gpu/drm/exynos/exynos_drm_gem.c~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t
+++ a/drivers/gpu/drm/exynos/exynos_drm_gem.c
@@ -491,7 +491,7 @@ int exynos_drm_gem_fault(struct vm_area_
 
 	pfn = page_to_pfn(exynos_gem->pages[page_offset]);
 	ret = vm_insert_mixed(vma, (unsigned long)vmf->virtual_address,
-			pfn_to_pfn_t(pfn, PFN_DEV));
+			__pfn_to_pfn_t(pfn, PFN_DEV));
 
 out:
 	switch (ret) {
diff -puN drivers/gpu/drm/msm/msm_gem.c~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t drivers/gpu/drm/msm/msm_gem.c
--- a/drivers/gpu/drm/msm/msm_gem.c~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t
+++ a/drivers/gpu/drm/msm/msm_gem.c
@@ -223,7 +223,7 @@ int msm_gem_fault(struct vm_area_struct
 			pfn, pfn << PAGE_SHIFT);
 
 	ret = vm_insert_mixed(vma, (unsigned long)vmf->virtual_address,
-			pfn_to_pfn_t(pfn, PFN_DEV));
+			__pfn_to_pfn_t(pfn, PFN_DEV));
 
 out_unlock:
 	mutex_unlock(&dev->struct_mutex);
diff -puN drivers/gpu/drm/omapdrm/omap_gem.c~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t drivers/gpu/drm/omapdrm/omap_gem.c
--- a/drivers/gpu/drm/omapdrm/omap_gem.c~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t
+++ a/drivers/gpu/drm/omapdrm/omap_gem.c
@@ -386,7 +386,7 @@ static int fault_1d(struct drm_gem_objec
 			pfn, pfn << PAGE_SHIFT);
 
 	return vm_insert_mixed(vma, (unsigned long)vmf->virtual_address,
-			pfn_to_pfn_t(pfn, PFN_DEV));
+			__pfn_to_pfn_t(pfn, PFN_DEV));
 }
 
 /* Special handling for the case of faulting in 2d tiled buffers */
@@ -480,7 +480,7 @@ static int fault_2d(struct drm_gem_objec
 
 	for (i = n; i > 0; i--) {
 		vm_insert_mixed(vma, (unsigned long)vaddr,
-				pfn_to_pfn_t(pfn, PFN_DEV));
+				__pfn_to_pfn_t(pfn, PFN_DEV));
 		pfn += usergart[fmt].stride_pfn;
 		vaddr += PAGE_SIZE * m;
 	}
diff -puN fs/dax.c~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t fs/dax.c
--- a/fs/dax.c~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t
+++ a/fs/dax.c
@@ -692,7 +692,7 @@ int __dax_pmd_fault(struct vm_area_struc
 		dax_unmap_atomic(bdev, &dax);
 
 		result |= vmf_insert_pfn_pmd(vma, address, pmd,
-				pfn_t_to_pfn(dax.pfn), write);
+				dax.pfn, write);
 	}
 
  out:
diff -puN include/asm-generic/pgtable.h~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t
+++ a/include/asm-generic/pgtable.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_GENERIC_PGTABLE_H
 #define _ASM_GENERIC_PGTABLE_H
 
+#include <linux/pfn.h>
+
 #ifndef __ASSEMBLY__
 #ifdef CONFIG_MMU
 
@@ -549,7 +551,7 @@ static inline int track_pfn_remap(struct
  * by vm_insert_pfn().
  */
 static inline int track_pfn_insert(struct vm_area_struct *vma, pgprot_t *prot,
-				   unsigned long pfn)
+				   pfn_t pfn)
 {
 	return 0;
 }
@@ -577,7 +579,7 @@ extern int track_pfn_remap(struct vm_are
 			   unsigned long pfn, unsigned long addr,
 			   unsigned long size);
 extern int track_pfn_insert(struct vm_area_struct *vma, pgprot_t *prot,
-			    unsigned long pfn);
+			    pfn_t pfn);
 extern int track_pfn_copy(struct vm_area_struct *vma);
 extern void untrack_pfn(struct vm_area_struct *vma, unsigned long pfn,
 			unsigned long size);
diff -puN include/linux/huge_mm.h~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t
+++ a/include/linux/huge_mm.h
@@ -37,7 +37,7 @@ extern int change_huge_pmd(struct vm_are
 			unsigned long addr, pgprot_t newprot,
 			int prot_numa);
 int vmf_insert_pfn_pmd(struct vm_area_struct *, unsigned long addr, pmd_t *,
-			unsigned long pfn, bool write);
+			pfn_t pfn, bool write);
 
 enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_FLAG,
diff -puN include/linux/mm.h~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t include/linux/mm.h
--- a/include/linux/mm.h~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t
+++ a/include/linux/mm.h
@@ -1081,7 +1081,14 @@ static inline pte_t pfn_t_pte(pfn_t pfn,
 }
 #endif
 
-#ifdef __HAVE_ARCH_PTE_DEVICE
+#ifdef pfn_pmd
+static inline pmd_t pfn_t_pmd(pfn_t pfn, pgprot_t pgprot)
+{
+	return pfn_pmd(pfn_t_to_pfn(pfn), pgprot);
+}
+#endif
+
+#ifdef __HAVE_ARCH_PTE_DEVMAP
 static inline bool pfn_t_devmap(pfn_t pfn)
 {
 	const unsigned long flags = PFN_DEV|PFN_MAP;
@@ -1094,6 +1101,7 @@ static inline bool pfn_t_devmap(pfn_t pf
 	return false;
 }
 pte_t pte_mkdevmap(pte_t pte);
+pmd_t pmd_mkdevmap(pmd_t pmd);
 #endif
 
 /*
diff -puN mm/huge_memory.c~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t mm/huge_memory.c
--- a/mm/huge_memory.c~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t
+++ a/mm/huge_memory.c
@@ -960,14 +960,16 @@ int do_huge_pmd_anonymous_page(struct mm
 }
 
 static void insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
-		pmd_t *pmd, unsigned long pfn, pgprot_t prot, bool write)
+		pmd_t *pmd, pfn_t pfn, pgprot_t prot, bool write)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t entry;
 	spinlock_t *ptl;
 
 	ptl = pmd_lock(mm, pmd);
-	entry = pmd_mkhuge(pfn_pmd(pfn, prot));
+	entry = pmd_mkhuge(pfn_t_pmd(pfn, prot));
+	if (pfn_t_devmap(pfn))
+		entry = pmd_mkdevmap(entry);
 	if (write) {
 		entry = pmd_mkyoung(pmd_mkdirty(entry));
 		entry = maybe_pmd_mkwrite(entry, vma);
@@ -978,7 +980,7 @@ static void insert_pfn_pmd(struct vm_are
 }
 
 int vmf_insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
-			pmd_t *pmd, unsigned long pfn, bool write)
+			pmd_t *pmd, pfn_t pfn, bool write)
 {
 	pgprot_t pgprot = vma->vm_page_prot;
 	/*
@@ -990,7 +992,7 @@ int vmf_insert_pfn_pmd(struct vm_area_st
 	BUG_ON((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) ==
 						(VM_PFNMAP|VM_MIXEDMAP));
 	BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));
-	BUG_ON((vma->vm_flags & VM_MIXEDMAP) && pfn_valid(pfn));
+	BUG_ON(!pfn_t_devmap(pfn));
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return VM_FAULT_SIGBUS;
diff -puN mm/memory.c~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t mm/memory.c
--- a/mm/memory.c~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t
+++ a/mm/memory.c
@@ -1566,7 +1566,7 @@ int vm_insert_pfn(struct vm_area_struct
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return -EFAULT;
-	if (track_pfn_insert(vma, &pgprot, pfn))
+	if (track_pfn_insert(vma, &pgprot, __pfn_to_pfn_t(pfn, PFN_DEV)))
 		return -EINVAL;
 
 	ret = insert_pfn(vma, addr, __pfn_to_pfn_t(pfn, PFN_DEV), pgprot);
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

scatterlist-fix-sg_phys-masking.patch
pmem-dax-clean-up-clear_pmem.patch
dax-increase-granularity-of-dax_clear_blocks-operations.patch
dax-guarantee-page-aligned-results-from-bdev_direct_access.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic-v3.patch
um-kill-pfn_t.patch
kvm-rename-pfn_t-to-kvm_pfn_t.patch
mm-dax-pmem-introduce-pfn_t.patch
mm-dax-pmem-introduce-pfn_t-v3.patch
mm-introduce-find_dev_pagemap.patch
x86-mm-introduce-vmem_altmap-to-augment-vmemmap_populate.patch
libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory.patch
avr32-convert-to-asm-generic-memory_modelh.patch
hugetlb-fix-compile-error-on-tile.patch
frv-fix-compiler-warning-from-definition-of-__pmd.patch
x86-mm-introduce-_page_devmap.patch
mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t.patch
mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t.patch
list-introduce-list_del_poison.patch
libnvdimm-pmem-move-request_queue-allocation-earlier-in-probe.patch
mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup.patch
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd.patch
mm-x86-get_user_pages-for-dax-mappings.patch
dax-provide-diagnostics-for-pmd-mapping-failures.patch
dax-re-enable-dax-pmd-mappings.patch

