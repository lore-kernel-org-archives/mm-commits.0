From: akpm@linux-foundation.org
Subject: [merged] mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:13:40 -0800
Message-ID: <569e98f4.5PZMJM87iIm4Ydib%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44351 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143AbcASUNl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:13:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, airlied@linux.ie, dave@sr71.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, dax, gpu: convert vm_insert_mixed to pfn_t
has been removed from the -mm tree.  Its filename was
     mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm, dax, gpu: convert vm_insert_mixed to pfn_t

Convert the raw unsigned long 'pfn' argument to pfn_t for the purpose of
evaluating the PFN_MAP and PFN_DEV flags.  When both are set it triggers
_PAGE_DEVMAP to be set in the resulting pte.

There are no functional changes to the gpu drivers as a result of this
conversion.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave@sr71.net>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h          |    5 ++++
 drivers/gpu/drm/exynos/exynos_drm_gem.c |    4 ++-
 drivers/gpu/drm/gma500/framebuffer.c    |    4 ++-
 drivers/gpu/drm/msm/msm_gem.c           |    4 ++-
 drivers/gpu/drm/omapdrm/omap_gem.c      |    7 ++++-
 drivers/gpu/drm/ttm/ttm_bo_vm.c         |    4 ++-
 fs/dax.c                                |    2 -
 include/linux/mm.h                      |    2 -
 include/linux/pfn_t.h                   |   27 ++++++++++++++++++++++
 mm/memory.c                             |   16 ++++++++-----
 10 files changed, 61 insertions(+), 14 deletions(-)

diff -puN arch/x86/include/asm/pgtable.h~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t
+++ a/arch/x86/include/asm/pgtable.h
@@ -247,6 +247,11 @@ static inline pte_t pte_mkspecial(pte_t
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
diff -puN drivers/gpu/drm/exynos/exynos_drm_gem.c~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t drivers/gpu/drm/exynos/exynos_drm_gem.c
--- a/drivers/gpu/drm/exynos/exynos_drm_gem.c~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t
+++ a/drivers/gpu/drm/exynos/exynos_drm_gem.c
@@ -14,6 +14,7 @@
 
 #include <linux/shmem_fs.h>
 #include <linux/dma-buf.h>
+#include <linux/pfn_t.h>
 #include <drm/exynos_drm.h>
 
 #include "exynos_drm_drv.h"
@@ -490,7 +491,8 @@ int exynos_drm_gem_fault(struct vm_area_
 	}
 
 	pfn = page_to_pfn(exynos_gem->pages[page_offset]);
-	ret = vm_insert_mixed(vma, (unsigned long)vmf->virtual_address, pfn);
+	ret = vm_insert_mixed(vma, (unsigned long)vmf->virtual_address,
+			__pfn_to_pfn_t(pfn, PFN_DEV));
 
 out:
 	switch (ret) {
diff -puN drivers/gpu/drm/gma500/framebuffer.c~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t drivers/gpu/drm/gma500/framebuffer.c
--- a/drivers/gpu/drm/gma500/framebuffer.c~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t
+++ a/drivers/gpu/drm/gma500/framebuffer.c
@@ -21,6 +21,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/string.h>
+#include <linux/pfn_t.h>
 #include <linux/mm.h>
 #include <linux/tty.h>
 #include <linux/slab.h>
@@ -132,7 +133,8 @@ static int psbfb_vm_fault(struct vm_area
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
@@ -18,6 +18,7 @@
 #include <linux/spinlock.h>
 #include <linux/shmem_fs.h>
 #include <linux/dma-buf.h>
+#include <linux/pfn_t.h>
 
 #include "msm_drv.h"
 #include "msm_gem.h"
@@ -222,7 +223,8 @@ int msm_gem_fault(struct vm_area_struct
 	VERB("Inserting %p pfn %lx, pa %lx", vmf->virtual_address,
 			pfn, pfn << PAGE_SHIFT);
 
-	ret = vm_insert_mixed(vma, (unsigned long)vmf->virtual_address, pfn);
+	ret = vm_insert_mixed(vma, (unsigned long)vmf->virtual_address,
+			__pfn_to_pfn_t(pfn, PFN_DEV));
 
 out_unlock:
 	mutex_unlock(&dev->struct_mutex);
diff -puN drivers/gpu/drm/omapdrm/omap_gem.c~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t drivers/gpu/drm/omapdrm/omap_gem.c
--- a/drivers/gpu/drm/omapdrm/omap_gem.c~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t
+++ a/drivers/gpu/drm/omapdrm/omap_gem.c
@@ -19,6 +19,7 @@
 
 #include <linux/shmem_fs.h>
 #include <linux/spinlock.h>
+#include <linux/pfn_t.h>
 
 #include <drm/drm_vma_manager.h>
 
@@ -385,7 +386,8 @@ static int fault_1d(struct drm_gem_objec
 	VERB("Inserting %p pfn %lx, pa %lx", vmf->virtual_address,
 			pfn, pfn << PAGE_SHIFT);
 
-	return vm_insert_mixed(vma, (unsigned long)vmf->virtual_address, pfn);
+	return vm_insert_mixed(vma, (unsigned long)vmf->virtual_address,
+			__pfn_to_pfn_t(pfn, PFN_DEV));
 }
 
 /* Special handling for the case of faulting in 2d tiled buffers */
@@ -478,7 +480,8 @@ static int fault_2d(struct drm_gem_objec
 			pfn, pfn << PAGE_SHIFT);
 
 	for (i = n; i > 0; i--) {
-		vm_insert_mixed(vma, (unsigned long)vaddr, pfn);
+		vm_insert_mixed(vma, (unsigned long)vaddr,
+				__pfn_to_pfn_t(pfn, PFN_DEV));
 		pfn += usergart[fmt].stride_pfn;
 		vaddr += PAGE_SIZE * m;
 	}
diff -puN drivers/gpu/drm/ttm/ttm_bo_vm.c~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t drivers/gpu/drm/ttm/ttm_bo_vm.c
--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t
+++ a/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -35,6 +35,7 @@
 #include <ttm/ttm_placement.h>
 #include <drm/drm_vma_manager.h>
 #include <linux/mm.h>
+#include <linux/pfn_t.h>
 #include <linux/rbtree.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
@@ -229,7 +230,8 @@ static int ttm_bo_vm_fault(struct vm_are
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
@@ -363,7 +363,7 @@ static int dax_insert_mapping(struct ino
 	}
 	dax_unmap_atomic(bdev, &dax);
 
-	error = vm_insert_mixed(vma, vaddr, pfn_t_to_pfn(dax.pfn));
+	error = vm_insert_mixed(vma, vaddr, dax.pfn);
 
  out:
 	i_mmap_unlock_read(mapping);
diff -puN include/linux/mm.h~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t include/linux/mm.h
--- a/include/linux/mm.h~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t
+++ a/include/linux/mm.h
@@ -2107,7 +2107,7 @@ int vm_insert_page(struct vm_area_struct
 int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
 int vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
-			unsigned long pfn);
+			pfn_t pfn);
 int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len);
 
 
diff -puN include/linux/pfn_t.h~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t include/linux/pfn_t.h
--- a/include/linux/pfn_t.h~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t
+++ a/include/linux/pfn_t.h
@@ -64,4 +64,31 @@ static inline pfn_t page_to_pfn_t(struct
 {
 	return pfn_to_pfn_t(page_to_pfn(page));
 }
+
+static inline int pfn_t_valid(pfn_t pfn)
+{
+	return pfn_valid(pfn_t_to_pfn(pfn));
+}
+
+#ifdef CONFIG_MMU
+static inline pte_t pfn_t_pte(pfn_t pfn, pgprot_t pgprot)
+{
+	return pfn_pte(pfn_t_to_pfn(pfn), pgprot);
+}
+#endif
+
+#ifdef __HAVE_ARCH_PTE_DEVMAP
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
 #endif /* _LINUX_PFN_T_H_ */
diff -puN mm/memory.c~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t mm/memory.c
--- a/mm/memory.c~mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t
+++ a/mm/memory.c
@@ -50,6 +50,7 @@
 #include <linux/export.h>
 #include <linux/delayacct.h>
 #include <linux/init.h>
+#include <linux/pfn_t.h>
 #include <linux/writeback.h>
 #include <linux/memcontrol.h>
 #include <linux/mmu_notifier.h>
@@ -1500,7 +1501,7 @@ int vm_insert_page(struct vm_area_struct
 EXPORT_SYMBOL(vm_insert_page);
 
 static int insert_pfn(struct vm_area_struct *vma, unsigned long addr,
-			unsigned long pfn, pgprot_t prot)
+			pfn_t pfn, pgprot_t prot)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	int retval;
@@ -1516,7 +1517,10 @@ static int insert_pfn(struct vm_area_str
 		goto out_unlock;
 
 	/* Ok, finally just insert the thing.. */
-	entry = pte_mkspecial(pfn_pte(pfn, prot));
+	if (pfn_t_devmap(pfn))
+		entry = pte_mkdevmap(pfn_t_pte(pfn, prot));
+	else
+		entry = pte_mkspecial(pfn_t_pte(pfn, prot));
 	set_pte_at(mm, addr, pte, entry);
 	update_mmu_cache(vma, addr, pte); /* XXX: why not for insert_page? */
 
@@ -1566,14 +1570,14 @@ int vm_insert_pfn(struct vm_area_struct
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
 
@@ -1587,10 +1591,10 @@ int vm_insert_mixed(struct vm_area_struc
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

dax-add-support-for-fsync-sync-v6-fix.patch

