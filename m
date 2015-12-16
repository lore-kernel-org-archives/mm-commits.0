From: akpm@linux-foundation.org
Subject: + mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t.patch added to -mm
 tree
Date: Tue, 15 Dec 2015 16:17:08 -0800
Message-ID: <5670ad84.wbXNuZa0wmvDFI5U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47308 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727AbbLPARJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2015 19:17:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, airlied@linux.ie, dave.hansen@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, dax, gpu: convert vm_insert_mixed to pfn_t
has been added to the -mm tree.  Its filename is
     mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t.patch

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
Subject: mm, dax, gpu: convert vm_insert_mixed to pfn_t

Convert the raw unsigned long 'pfn' argument to pfn_t for the purpose of
evaluating the PFN_MAP and PFN_DEV flags.  When both are set it triggers
_PAGE_DEVMAP to be set in the resulting pte.

There are no functional changes to the gpu drivers as a result of this
conversion.

This uncovered several architectures with no local definition for
pfn_pte(), in response pfn_t_pte() is only defined when an arch opts-in by
"#define pfn_pte pfn_pte".

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/pgtable.h        |    1 
 arch/parisc/include/asm/pgtable.h       |    1 
 arch/powerpc/include/asm/pgtable.h      |    1 
 arch/sparc/include/asm/pgtable_64.h     |    1 
 arch/tile/include/asm/pgtable.h         |    1 
 arch/um/include/asm/pgtable-3level.h    |    1 
 arch/x86/include/asm/pgtable.h          |   12 ++++++++
 drivers/gpu/drm/exynos/exynos_drm_gem.c |    3 +-
 drivers/gpu/drm/gma500/framebuffer.c    |    3 +-
 drivers/gpu/drm/msm/msm_gem.c           |    3 +-
 drivers/gpu/drm/omapdrm/omap_gem.c      |    6 ++--
 drivers/gpu/drm/ttm/ttm_bo_vm.c         |    3 +-
 fs/dax.c                                |    2 -
 include/linux/mm.h                      |   33 +++++++++++++++++++++-
 mm/memory.c                             |   15 ++++++----
 15 files changed, 72 insertions(+), 14 deletions(-)

diff -puN arch/alpha/include/asm/pgtable.h~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t arch/alpha/include/asm/pgtable.h
--- a/arch/alpha/include/asm/pgtable.h~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t
+++ a/arch/alpha/include/asm/pgtable.h
@@ -216,6 +216,7 @@ extern unsigned long __zero_page(void);
 })
 #endif
 
+#define pfn_pte pfn_pte
 extern inline pte_t pfn_pte(unsigned long physpfn, pgprot_t pgprot)
 { pte_t pte; pte_val(pte) = (PHYS_TWIDDLE(physpfn) << 32) | pgprot_val(pgprot); return pte; }
 
diff -puN arch/parisc/include/asm/pgtable.h~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t arch/parisc/include/asm/pgtable.h
--- a/arch/parisc/include/asm/pgtable.h~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t
+++ a/arch/parisc/include/asm/pgtable.h
@@ -395,6 +395,7 @@ static inline pte_t pte_mkspecial(pte_t
 
 #define mk_pte(page, pgprot)	pfn_pte(page_to_pfn(page), (pgprot))
 
+#define pfn_pte pfn_pte
 static inline pte_t pfn_pte(unsigned long pfn, pgprot_t pgprot)
 {
 	pte_t pte;
diff -puN arch/powerpc/include/asm/pgtable.h~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t arch/powerpc/include/asm/pgtable.h
--- a/arch/powerpc/include/asm/pgtable.h~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -67,6 +67,7 @@ static inline int pte_present(pte_t pte)
  * Even if PTEs can be unsigned long long, a PFN is always an unsigned
  * long for now.
  */
+#define pfn_pte pfn_pte
 static inline pte_t pfn_pte(unsigned long pfn, pgprot_t pgprot) {
 	return __pte(((pte_basic_t)(pfn) << PTE_RPN_SHIFT) |
 		     pgprot_val(pgprot)); }
diff -puN arch/sparc/include/asm/pgtable_64.h~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t arch/sparc/include/asm/pgtable_64.h
--- a/arch/sparc/include/asm/pgtable_64.h~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -234,6 +234,7 @@ extern struct page *mem_map_zero;
  * the first physical page in the machine is at some huge physical address,
  * such as 4GB.   This is common on a partitioned E10000, for example.
  */
+#define pfn_pte pfn_pte
 static inline pte_t pfn_pte(unsigned long pfn, pgprot_t prot)
 {
 	unsigned long paddr = pfn << PAGE_SHIFT;
diff -puN arch/tile/include/asm/pgtable.h~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t arch/tile/include/asm/pgtable.h
--- a/arch/tile/include/asm/pgtable.h~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t
+++ a/arch/tile/include/asm/pgtable.h
@@ -275,6 +275,7 @@ static inline unsigned long pte_pfn(pte_
 extern pgprot_t set_remote_cache_cpu(pgprot_t prot, int cpu);
 extern int get_remote_cache_cpu(pgprot_t prot);
 
+#define pfn_pte pfn_pte
 static inline pte_t pfn_pte(unsigned long pfn, pgprot_t prot)
 {
 	return hv_pte_set_pa(prot, PFN_PHYS(pfn));
diff -puN arch/um/include/asm/pgtable-3level.h~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t arch/um/include/asm/pgtable-3level.h
--- a/arch/um/include/asm/pgtable-3level.h~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t
+++ a/arch/um/include/asm/pgtable-3level.h
@@ -98,6 +98,7 @@ static inline unsigned long pte_pfn(pte_
 	return phys_to_pfn(pte_val(pte));
 }
 
+#define pfn_pte pfn_pte
 static inline pte_t pfn_pte(unsigned long page_nr, pgprot_t pgprot)
 {
 	pte_t pte;
diff -puN arch/x86/include/asm/pgtable.h~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t
+++ a/arch/x86/include/asm/pgtable.h
@@ -250,6 +250,11 @@ static inline pte_t pte_mkspecial(pte_t
 	return pte_set_flags(pte, _PAGE_SPECIAL);
 }
 
+static inline pte_t pte_mkdevmap(pte_t pte)
+{
+	return pte_set_flags(pte, _PAGE_SPECIAL|_PAGE_DEVMAP);
+}
+
 static inline pmd_t pmd_set_flags(pmd_t pmd, pmdval_t set)
 {
 	pmdval_t v = native_pmd_val(pmd);
@@ -351,6 +356,7 @@ static inline pgprotval_t massage_pgprot
 	return protval;
 }
 
+#define pfn_pte pfn_pte
 static inline pte_t pfn_pte(unsigned long page_nr, pgprot_t pgprot)
 {
 	return __pte(((phys_addr_t)page_nr << PAGE_SHIFT) |
@@ -465,6 +471,12 @@ static inline int pte_present(pte_t a)
 	return pte_flags(a) & (_PAGE_PRESENT | _PAGE_PROTNONE);
 }
 
+#define pte_devmap pte_devmap
+static inline int pte_devmap(pte_t a)
+{
+	return (pte_flags(a) & _PAGE_DEVMAP) == _PAGE_DEVMAP;
+}
+
 #define pte_accessible pte_accessible
 static inline bool pte_accessible(struct mm_struct *mm, pte_t a)
 {
diff -puN drivers/gpu/drm/exynos/exynos_drm_gem.c~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t drivers/gpu/drm/exynos/exynos_drm_gem.c
--- a/drivers/gpu/drm/exynos/exynos_drm_gem.c~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t
+++ a/drivers/gpu/drm/exynos/exynos_drm_gem.c
@@ -490,7 +490,8 @@ int exynos_drm_gem_fault(struct vm_area_
 	}
 
 	pfn = page_to_pfn(exynos_gem->pages[page_offset]);
-	ret = vm_insert_mixed(vma, (unsigned long)vmf->virtual_address, pfn);
+	ret = vm_insert_mixed(vma, (unsigned long)vmf->virtual_address,
+			pfn_to_pfn_t(pfn, PFN_DEV));
 
 out:
 	switch (ret) {
diff -puN drivers/gpu/drm/gma500/framebuffer.c~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t drivers/gpu/drm/gma500/framebuffer.c
--- a/drivers/gpu/drm/gma500/framebuffer.c~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t
+++ a/drivers/gpu/drm/gma500/framebuffer.c
@@ -132,7 +132,8 @@ static int psbfb_vm_fault(struct vm_area
 	for (i = 0; i < page_num; i++) {
 		pfn = (phys_addr >> PAGE_SHIFT);
 
-		ret = vm_insert_mixed(vma, address, pfn);
+		ret = vm_insert_mixed(vma, address,
+				__pfn_to_pfn_t(pfn, PFN_DEV));
 		if (unlikely((ret == -EBUSY) || (ret != 0 && i > 0)))
 			break;
 		else if (unlikely(ret != 0)) {
diff -puN drivers/gpu/drm/msm/msm_gem.c~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t drivers/gpu/drm/msm/msm_gem.c
--- a/drivers/gpu/drm/msm/msm_gem.c~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t
+++ a/drivers/gpu/drm/msm/msm_gem.c
@@ -222,7 +222,8 @@ int msm_gem_fault(struct vm_area_struct
 	VERB("Inserting %p pfn %lx, pa %lx", vmf->virtual_address,
 			pfn, pfn << PAGE_SHIFT);
 
-	ret = vm_insert_mixed(vma, (unsigned long)vmf->virtual_address, pfn);
+	ret = vm_insert_mixed(vma, (unsigned long)vmf->virtual_address,
+			pfn_to_pfn_t(pfn, PFN_DEV));
 
 out_unlock:
 	mutex_unlock(&dev->struct_mutex);
diff -puN drivers/gpu/drm/omapdrm/omap_gem.c~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t drivers/gpu/drm/omapdrm/omap_gem.c
--- a/drivers/gpu/drm/omapdrm/omap_gem.c~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t
+++ a/drivers/gpu/drm/omapdrm/omap_gem.c
@@ -385,7 +385,8 @@ static int fault_1d(struct drm_gem_objec
 	VERB("Inserting %p pfn %lx, pa %lx", vmf->virtual_address,
 			pfn, pfn << PAGE_SHIFT);
 
-	return vm_insert_mixed(vma, (unsigned long)vmf->virtual_address, pfn);
+	return vm_insert_mixed(vma, (unsigned long)vmf->virtual_address,
+			pfn_to_pfn_t(pfn, PFN_DEV));
 }
 
 /* Special handling for the case of faulting in 2d tiled buffers */
@@ -478,7 +479,8 @@ static int fault_2d(struct drm_gem_objec
 			pfn, pfn << PAGE_SHIFT);
 
 	for (i = n; i > 0; i--) {
-		vm_insert_mixed(vma, (unsigned long)vaddr, pfn);
+		vm_insert_mixed(vma, (unsigned long)vaddr,
+				pfn_to_pfn_t(pfn, PFN_DEV));
 		pfn += usergart[fmt].stride_pfn;
 		vaddr += PAGE_SIZE * m;
 	}
diff -puN drivers/gpu/drm/ttm/ttm_bo_vm.c~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t drivers/gpu/drm/ttm/ttm_bo_vm.c
--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t
+++ a/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -229,7 +229,8 @@ static int ttm_bo_vm_fault(struct vm_are
 		}
 
 		if (vma->vm_flags & VM_MIXEDMAP)
-			ret = vm_insert_mixed(&cvma, address, pfn);
+			ret = vm_insert_mixed(&cvma, address,
+					__pfn_to_pfn_t(pfn, PFN_DEV));
 		else
 			ret = vm_insert_pfn(&cvma, address, pfn);
 
diff -puN fs/dax.c~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t fs/dax.c
--- a/fs/dax.c~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t
+++ a/fs/dax.c
@@ -362,7 +362,7 @@ static int dax_insert_mapping(struct ino
 	}
 	dax_unmap_atomic(bdev, &dax);
 
-	error = vm_insert_mixed(vma, vaddr, pfn_t_to_pfn(dax.pfn));
+	error = vm_insert_mixed(vma, vaddr, dax.pfn);
 
  out:
 	i_mmap_unlock_read(mapping);
diff -puN include/linux/mm.h~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t include/linux/mm.h
--- a/include/linux/mm.h~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t
+++ a/include/linux/mm.h
@@ -1069,6 +1069,33 @@ static inline pfn_t page_to_pfn_t(struct
 	return pfn_to_pfn_t(page_to_pfn(page));
 }
 
+static inline int pfn_t_valid(pfn_t pfn)
+{
+	return pfn_valid(pfn_t_to_pfn(pfn));
+}
+
+#ifdef pfn_pte
+static inline pte_t pfn_t_pte(pfn_t pfn, pgprot_t pgprot)
+{
+	return pfn_pte(pfn_t_to_pfn(pfn), pgprot);
+}
+#endif
+
+#ifdef __HAVE_ARCH_PTE_DEVICE
+static inline bool pfn_t_devmap(pfn_t pfn)
+{
+	const unsigned long flags = PFN_DEV|PFN_MAP;
+
+	return (pfn.val & flags) == flags;
+}
+#else
+static inline bool pfn_t_devmap(pfn_t pfn)
+{
+	return false;
+}
+pte_t pte_mkdevmap(pte_t pte);
+#endif
+
 /*
  * Some inline functions in vmstat.h depend on page_zone()
  */
@@ -1860,6 +1887,10 @@ static inline void pgtable_pmd_page_dtor
 
 #endif
 
+#ifndef pte_devmap
+#define pte_devmap(x) (0)
+#endif
+
 static inline spinlock_t *pmd_lock(struct mm_struct *mm, pmd_t *pmd)
 {
 	spinlock_t *ptl = pmd_lockptr(mm, pmd);
@@ -2279,7 +2310,7 @@ int vm_insert_page(struct vm_area_struct
 int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
 int vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
-			unsigned long pfn);
+			pfn_t pfn);
 int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len);
 
 
diff -puN mm/memory.c~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t mm/memory.c
--- a/mm/memory.c~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t
+++ a/mm/memory.c
@@ -1500,7 +1500,7 @@ int vm_insert_page(struct vm_area_struct
 EXPORT_SYMBOL(vm_insert_page);
 
 static int insert_pfn(struct vm_area_struct *vma, unsigned long addr,
-			unsigned long pfn, pgprot_t prot)
+			pfn_t pfn, pgprot_t prot)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	int retval;
@@ -1516,7 +1516,10 @@ static int insert_pfn(struct vm_area_str
 		goto out_unlock;
 
 	/* Ok, finally just insert the thing.. */
-	entry = pte_mkspecial(pfn_pte(pfn, prot));
+	if (pfn_t_devmap(pfn))
+		entry = pte_mkdevmap(pfn_t_pte(pfn, prot));
+	else
+		entry = pte_mkspecial(pfn_t_pte(pfn, prot));
 	set_pte_at(mm, addr, pte, entry);
 	update_mmu_cache(vma, addr, pte); /* XXX: why not for insert_page? */
 
@@ -1566,14 +1569,14 @@ int vm_insert_pfn(struct vm_area_struct
 	if (track_pfn_insert(vma, &pgprot, pfn))
 		return -EINVAL;
 
-	ret = insert_pfn(vma, addr, pfn, pgprot);
+	ret = insert_pfn(vma, addr, __pfn_to_pfn_t(pfn, PFN_DEV), pgprot);
 
 	return ret;
 }
 EXPORT_SYMBOL(vm_insert_pfn);
 
 int vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
-			unsigned long pfn)
+			pfn_t pfn)
 {
 	BUG_ON(!(vma->vm_flags & VM_MIXEDMAP));
 
@@ -1587,10 +1590,10 @@ int vm_insert_mixed(struct vm_area_struc
 	 * than insert_pfn).  If a zero_pfn were inserted into a VM_MIXEDMAP
 	 * without pte special, it would there be refcounted as a normal page.
 	 */
-	if (!HAVE_PTE_SPECIAL && pfn_valid(pfn)) {
+	if (!HAVE_PTE_SPECIAL && pfn_t_valid(pfn)) {
 		struct page *page;
 
-		page = pfn_to_page(pfn);
+		page = pfn_t_to_page(pfn);
 		return insert_page(vma, addr, page, vma->vm_page_prot);
 	}
 	return insert_pfn(vma, addr, pfn, vma->vm_page_prot);
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

