From: akpm@linux-foundation.org
Subject: [patch 061/114] mm: use vmf->address instead of of
 vmf->virtual_address
Date: Wed, 14 Dec 2016 15:07:01 -0800
Message-ID: <5851d095.duOcrJiftn3pEKNf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35096 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756892AbcLNXH1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:07:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jack@suse.cz, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com

From: Jan Kara <jack@suse.cz>
Subject: mm: use vmf->address instead of of vmf->virtual_address

Every single user of vmf->virtual_address typed that entry to unsigned
long before doing anything with it so the type of virtual_address does not
really provide us any additional safety.  Just use masked vmf->address
which already has the appropriate type.

Link: http://lkml.kernel.org/r/1479460644-25076-3-git-send-email-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/file.c     |    8 ++----
 arch/x86/entry/vdso/vma.c                    |    4 +--
 drivers/char/agp/alpha-agp.c                 |    3 --
 drivers/char/mspec.c                         |    2 -
 drivers/dax/dax.c                            |    3 --
 drivers/gpu/drm/armada/armada_gem.c          |    5 +---
 drivers/gpu/drm/drm_vm.c                     |   10 ++++----
 drivers/gpu/drm/etnaviv/etnaviv_gem.c        |    7 ++---
 drivers/gpu/drm/exynos/exynos_drm_gem.c      |    6 +----
 drivers/gpu/drm/gma500/framebuffer.c         |    2 -
 drivers/gpu/drm/gma500/gem.c                 |    5 +---
 drivers/gpu/drm/i915/i915_gem.c              |    3 --
 drivers/gpu/drm/msm/msm_gem.c                |    8 ++----
 drivers/gpu/drm/omapdrm/omap_gem.c           |   20 ++++++-----------
 drivers/gpu/drm/tegra/gem.c                  |    4 +--
 drivers/gpu/drm/ttm/ttm_bo_vm.c              |    2 -
 drivers/gpu/drm/udl/udl_gem.c                |    5 +---
 drivers/gpu/drm/vgem/vgem_drv.c              |    2 -
 drivers/media/v4l2-core/videobuf-dma-sg.c    |    5 +---
 drivers/misc/cxl/context.c                   |    5 +---
 drivers/misc/sgi-gru/grumain.c               |    2 -
 drivers/staging/android/ion/ion.c            |    2 -
 drivers/staging/lustre/lustre/llite/vvp_io.c |    6 ++---
 drivers/xen/privcmd.c                        |    2 -
 fs/dax.c                                     |    4 +--
 include/linux/mm.h                           |    2 -
 mm/memory.c                                  |    9 +++----
 27 files changed, 57 insertions(+), 79 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/file.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address arch/powerpc/platforms/cell/spufs/file.c
--- a/arch/powerpc/platforms/cell/spufs/file.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address
+++ a/arch/powerpc/platforms/cell/spufs/file.c
@@ -236,7 +236,6 @@ static int
 spufs_mem_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct spu_context *ctx	= vma->vm_file->private_data;
-	unsigned long address = (unsigned long)vmf->virtual_address;
 	unsigned long pfn, offset;
 
 	offset = vmf->pgoff << PAGE_SHIFT;
@@ -244,7 +243,7 @@ spufs_mem_mmap_fault(struct vm_area_stru
 		return VM_FAULT_SIGBUS;
 
 	pr_debug("spufs_mem_mmap_fault address=0x%lx, offset=0x%lx\n",
-			address, offset);
+			vmf->address, offset);
 
 	if (spu_acquire(ctx))
 		return VM_FAULT_NOPAGE;
@@ -256,7 +255,7 @@ spufs_mem_mmap_fault(struct vm_area_stru
 		vma->vm_page_prot = pgprot_noncached_wc(vma->vm_page_prot);
 		pfn = (ctx->spu->local_store_phys + offset) >> PAGE_SHIFT;
 	}
-	vm_insert_pfn(vma, address, pfn);
+	vm_insert_pfn(vma, vmf->address, pfn);
 
 	spu_release(ctx);
 
@@ -355,8 +354,7 @@ static int spufs_ps_fault(struct vm_area
 		down_read(&current->mm->mmap_sem);
 	} else {
 		area = ctx->spu->problem_phys + ps_offs;
-		vm_insert_pfn(vma, (unsigned long)vmf->virtual_address,
-					(area + offset) >> PAGE_SHIFT);
+		vm_insert_pfn(vma, vmf->address, (area + offset) >> PAGE_SHIFT);
 		spu_context_trace(spufs_ps_fault__insert, ctx, ctx->spu);
 	}
 
diff -puN arch/x86/entry/vdso/vma.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address arch/x86/entry/vdso/vma.c
--- a/arch/x86/entry/vdso/vma.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address
+++ a/arch/x86/entry/vdso/vma.c
@@ -109,7 +109,7 @@ static int vvar_fault(const struct vm_sp
 		return VM_FAULT_SIGBUS;
 
 	if (sym_offset == image->sym_vvar_page) {
-		ret = vm_insert_pfn(vma, (unsigned long)vmf->virtual_address,
+		ret = vm_insert_pfn(vma, vmf->address,
 				    __pa_symbol(&__vvar_page) >> PAGE_SHIFT);
 	} else if (sym_offset == image->sym_pvclock_page) {
 		struct pvclock_vsyscall_time_info *pvti =
@@ -117,7 +117,7 @@ static int vvar_fault(const struct vm_sp
 		if (pvti && vclock_was_used(VCLOCK_PVCLOCK)) {
 			ret = vm_insert_pfn(
 				vma,
-				(unsigned long)vmf->virtual_address,
+				vmf->address,
 				__pa(pvti) >> PAGE_SHIFT);
 		}
 	}
diff -puN drivers/char/agp/alpha-agp.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address drivers/char/agp/alpha-agp.c
--- a/drivers/char/agp/alpha-agp.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address
+++ a/drivers/char/agp/alpha-agp.c
@@ -19,8 +19,7 @@ static int alpha_core_agp_vm_fault(struc
 	unsigned long pa;
 	struct page *page;
 
-	dma_addr = (unsigned long)vmf->virtual_address - vma->vm_start
-						+ agp->aperture.bus_base;
+	dma_addr = vmf->address - vma->vm_start + agp->aperture.bus_base;
 	pa = agp->ops->translate(agp, dma_addr);
 
 	if (pa == (unsigned long)-EINVAL)
diff -puN drivers/char/mspec.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address drivers/char/mspec.c
--- a/drivers/char/mspec.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address
+++ a/drivers/char/mspec.c
@@ -227,7 +227,7 @@ mspec_fault(struct vm_area_struct *vma,
 	 * be because another thread has installed the pte first, so it
 	 * is no problem.
 	 */
-	vm_insert_pfn(vma, (unsigned long)vmf->virtual_address, pfn);
+	vm_insert_pfn(vma, vmf->address, pfn);
 
 	return VM_FAULT_NOPAGE;
 }
diff -puN drivers/dax/dax.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address drivers/dax/dax.c
--- a/drivers/dax/dax.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address
+++ a/drivers/dax/dax.c
@@ -328,7 +328,6 @@ static phys_addr_t pgoff_to_phys(struct
 static int __dax_dev_fault(struct dax_dev *dax_dev, struct vm_area_struct *vma,
 		struct vm_fault *vmf)
 {
-	unsigned long vaddr = (unsigned long) vmf->virtual_address;
 	struct device *dev = &dax_dev->dev;
 	struct dax_region *dax_region;
 	int rc = VM_FAULT_SIGBUS;
@@ -353,7 +352,7 @@ static int __dax_dev_fault(struct dax_de
 
 	pfn = phys_to_pfn_t(phys, dax_region->pfn_flags);
 
-	rc = vm_insert_mixed(vma, vaddr, pfn);
+	rc = vm_insert_mixed(vma, vmf->address, pfn);
 
 	if (rc == -ENOMEM)
 		return VM_FAULT_OOM;
diff -puN drivers/gpu/drm/armada/armada_gem.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address drivers/gpu/drm/armada/armada_gem.c
--- a/drivers/gpu/drm/armada/armada_gem.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address
+++ a/drivers/gpu/drm/armada/armada_gem.c
@@ -17,12 +17,11 @@
 static int armada_gem_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct armada_gem_object *obj = drm_to_armada_gem(vma->vm_private_data);
-	unsigned long addr = (unsigned long)vmf->virtual_address;
 	unsigned long pfn = obj->phys_addr >> PAGE_SHIFT;
 	int ret;
 
-	pfn += (addr - vma->vm_start) >> PAGE_SHIFT;
-	ret = vm_insert_pfn(vma, addr, pfn);
+	pfn += (vmf->address - vma->vm_start) >> PAGE_SHIFT;
+	ret = vm_insert_pfn(vma, vmf->address, pfn);
 
 	switch (ret) {
 	case 0:
diff -puN drivers/gpu/drm/drm_vm.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address drivers/gpu/drm/drm_vm.c
--- a/drivers/gpu/drm/drm_vm.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address
+++ a/drivers/gpu/drm/drm_vm.c
@@ -124,8 +124,7 @@ static int drm_do_vm_fault(struct vm_are
 		 * Using vm_pgoff as a selector forces us to use this unusual
 		 * addressing scheme.
 		 */
-		resource_size_t offset = (unsigned long)vmf->virtual_address -
-			vma->vm_start;
+		resource_size_t offset = vmf->address - vma->vm_start;
 		resource_size_t baddr = map->offset + offset;
 		struct drm_agp_mem *agpmem;
 		struct page *page;
@@ -195,7 +194,7 @@ static int drm_do_vm_shm_fault(struct vm
 	if (!map)
 		return VM_FAULT_SIGBUS;	/* Nothing allocated */
 
-	offset = (unsigned long)vmf->virtual_address - vma->vm_start;
+	offset = vmf->address - vma->vm_start;
 	i = (unsigned long)map->handle + offset;
 	page = vmalloc_to_page((void *)i);
 	if (!page)
@@ -301,7 +300,8 @@ static int drm_do_vm_dma_fault(struct vm
 	if (!dma->pagelist)
 		return VM_FAULT_SIGBUS;	/* Nothing allocated */
 
-	offset = (unsigned long)vmf->virtual_address - vma->vm_start;	/* vm_[pg]off[set] should be 0 */
+	offset = vmf->address - vma->vm_start;
+					/* vm_[pg]off[set] should be 0 */
 	page_nr = offset >> PAGE_SHIFT; /* page_nr could just be vmf->pgoff */
 	page = virt_to_page((void *)dma->pagelist[page_nr]);
 
@@ -337,7 +337,7 @@ static int drm_do_vm_sg_fault(struct vm_
 	if (!entry->pagelist)
 		return VM_FAULT_SIGBUS;	/* Nothing allocated */
 
-	offset = (unsigned long)vmf->virtual_address - vma->vm_start;
+	offset = vmf->address - vma->vm_start;
 	map_offset = map->offset - (unsigned long)dev->sg->virtual;
 	page_offset = (offset >> PAGE_SHIFT) + (map_offset >> PAGE_SHIFT);
 	page = entry->pagelist[page_offset];
diff -puN drivers/gpu/drm/etnaviv/etnaviv_gem.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address drivers/gpu/drm/etnaviv/etnaviv_gem.c
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address
+++ a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
@@ -202,15 +202,14 @@ int etnaviv_gem_fault(struct vm_area_str
 	}
 
 	/* We don't use vmf->pgoff since that has the fake offset: */
-	pgoff = ((unsigned long)vmf->virtual_address -
-			vma->vm_start) >> PAGE_SHIFT;
+	pgoff = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
 
 	page = pages[pgoff];
 
-	VERB("Inserting %p pfn %lx, pa %lx", vmf->virtual_address,
+	VERB("Inserting %p pfn %lx, pa %lx", (void *)vmf->address,
 	     page_to_pfn(page), page_to_pfn(page) << PAGE_SHIFT);
 
-	ret = vm_insert_page(vma, (unsigned long)vmf->virtual_address, page);
+	ret = vm_insert_page(vma, vmf->address, page);
 
 out:
 	switch (ret) {
diff -puN drivers/gpu/drm/exynos/exynos_drm_gem.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address drivers/gpu/drm/exynos/exynos_drm_gem.c
--- a/drivers/gpu/drm/exynos/exynos_drm_gem.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address
+++ a/drivers/gpu/drm/exynos/exynos_drm_gem.c
@@ -455,8 +455,7 @@ int exynos_drm_gem_fault(struct vm_area_
 	pgoff_t page_offset;
 	int ret;
 
-	page_offset = ((unsigned long)vmf->virtual_address -
-			vma->vm_start) >> PAGE_SHIFT;
+	page_offset = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
 
 	if (page_offset >= (exynos_gem->size >> PAGE_SHIFT)) {
 		DRM_ERROR("invalid page offset\n");
@@ -465,8 +464,7 @@ int exynos_drm_gem_fault(struct vm_area_
 	}
 
 	pfn = page_to_pfn(exynos_gem->pages[page_offset]);
-	ret = vm_insert_mixed(vma, (unsigned long)vmf->virtual_address,
-			__pfn_to_pfn_t(pfn, PFN_DEV));
+	ret = vm_insert_mixed(vma, vmf->address, __pfn_to_pfn_t(pfn, PFN_DEV));
 
 out:
 	switch (ret) {
diff -puN drivers/gpu/drm/gma500/framebuffer.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address drivers/gpu/drm/gma500/framebuffer.c
--- a/drivers/gpu/drm/gma500/framebuffer.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address
+++ a/drivers/gpu/drm/gma500/framebuffer.c
@@ -125,7 +125,7 @@ static int psbfb_vm_fault(struct vm_area
 				  psbfb->gtt->offset;
 
 	page_num = vma_pages(vma);
-	address = (unsigned long)vmf->virtual_address - (vmf->pgoff << PAGE_SHIFT);
+	address = vmf->address - (vmf->pgoff << PAGE_SHIFT);
 
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
diff -puN drivers/gpu/drm/gma500/gem.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address drivers/gpu/drm/gma500/gem.c
--- a/drivers/gpu/drm/gma500/gem.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address
+++ a/drivers/gpu/drm/gma500/gem.c
@@ -197,15 +197,14 @@ int psb_gem_fault(struct vm_area_struct
 
 	/* Page relative to the VMA start - we must calculate this ourselves
 	   because vmf->pgoff is the fake GEM offset */
-	page_offset = ((unsigned long) vmf->virtual_address - vma->vm_start)
-				>> PAGE_SHIFT;
+	page_offset = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
 
 	/* CPU view of the page, don't go via the GART for CPU writes */
 	if (r->stolen)
 		pfn = (dev_priv->stolen_base + r->offset) >> PAGE_SHIFT;
 	else
 		pfn = page_to_pfn(r->pages[page_offset]);
-	ret = vm_insert_pfn(vma, (unsigned long)vmf->virtual_address, pfn);
+	ret = vm_insert_pfn(vma, vmf->address, pfn);
 
 fail:
 	mutex_unlock(&dev_priv->mmap_mutex);
diff -puN drivers/gpu/drm/i915/i915_gem.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address drivers/gpu/drm/i915/i915_gem.c
--- a/drivers/gpu/drm/i915/i915_gem.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address
+++ a/drivers/gpu/drm/i915/i915_gem.c
@@ -1796,8 +1796,7 @@ int i915_gem_fault(struct vm_area_struct
 	int ret;
 
 	/* We don't use vmf->pgoff since that has the fake offset */
-	page_offset = ((unsigned long)vmf->virtual_address - area->vm_start) >>
-		PAGE_SHIFT;
+	page_offset = (vmf->address - area->vm_start) >> PAGE_SHIFT;
 
 	trace_i915_gem_object_fault(obj, page_offset, true, write);
 
diff -puN drivers/gpu/drm/msm/msm_gem.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address drivers/gpu/drm/msm/msm_gem.c
--- a/drivers/gpu/drm/msm/msm_gem.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address
+++ a/drivers/gpu/drm/msm/msm_gem.c
@@ -225,16 +225,14 @@ int msm_gem_fault(struct vm_area_struct
 	}
 
 	/* We don't use vmf->pgoff since that has the fake offset: */
-	pgoff = ((unsigned long)vmf->virtual_address -
-			vma->vm_start) >> PAGE_SHIFT;
+	pgoff = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
 
 	pfn = page_to_pfn(pages[pgoff]);
 
-	VERB("Inserting %p pfn %lx, pa %lx", vmf->virtual_address,
+	VERB("Inserting %p pfn %lx, pa %lx", (void *)vmf->address,
 			pfn, pfn << PAGE_SHIFT);
 
-	ret = vm_insert_mixed(vma, (unsigned long)vmf->virtual_address,
-			__pfn_to_pfn_t(pfn, PFN_DEV));
+	ret = vm_insert_mixed(vma, vmf->address, __pfn_to_pfn_t(pfn, PFN_DEV));
 
 out_unlock:
 	mutex_unlock(&dev->struct_mutex);
diff -puN drivers/gpu/drm/omapdrm/omap_gem.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address drivers/gpu/drm/omapdrm/omap_gem.c
--- a/drivers/gpu/drm/omapdrm/omap_gem.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address
+++ a/drivers/gpu/drm/omapdrm/omap_gem.c
@@ -398,8 +398,7 @@ static int fault_1d(struct drm_gem_objec
 	pgoff_t pgoff;
 
 	/* We don't use vmf->pgoff since that has the fake offset: */
-	pgoff = ((unsigned long)vmf->virtual_address -
-			vma->vm_start) >> PAGE_SHIFT;
+	pgoff = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
 
 	if (omap_obj->pages) {
 		omap_gem_cpu_sync(obj, pgoff);
@@ -409,11 +408,10 @@ static int fault_1d(struct drm_gem_objec
 		pfn = (omap_obj->paddr >> PAGE_SHIFT) + pgoff;
 	}
 
-	VERB("Inserting %p pfn %lx, pa %lx", vmf->virtual_address,
+	VERB("Inserting %p pfn %lx, pa %lx", (void *)vmf->address,
 			pfn, pfn << PAGE_SHIFT);
 
-	return vm_insert_mixed(vma, (unsigned long)vmf->virtual_address,
-			__pfn_to_pfn_t(pfn, PFN_DEV));
+	return vm_insert_mixed(vma, vmf->address, __pfn_to_pfn_t(pfn, PFN_DEV));
 }
 
 /* Special handling for the case of faulting in 2d tiled buffers */
@@ -427,7 +425,7 @@ static int fault_2d(struct drm_gem_objec
 	struct page *pages[64];  /* XXX is this too much to have on stack? */
 	unsigned long pfn;
 	pgoff_t pgoff, base_pgoff;
-	void __user *vaddr;
+	unsigned long vaddr;
 	int i, ret, slots;
 
 	/*
@@ -447,8 +445,7 @@ static int fault_2d(struct drm_gem_objec
 	const int m = 1 + ((omap_obj->width << fmt) / PAGE_SIZE);
 
 	/* We don't use vmf->pgoff since that has the fake offset: */
-	pgoff = ((unsigned long)vmf->virtual_address -
-			vma->vm_start) >> PAGE_SHIFT;
+	pgoff = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
 
 	/*
 	 * Actual address we start mapping at is rounded down to previous slot
@@ -459,7 +456,7 @@ static int fault_2d(struct drm_gem_objec
 	/* figure out buffer width in slots */
 	slots = omap_obj->width >> priv->usergart[fmt].slot_shift;
 
-	vaddr = vmf->virtual_address - ((pgoff - base_pgoff) << PAGE_SHIFT);
+	vaddr = vmf->address - ((pgoff - base_pgoff) << PAGE_SHIFT);
 
 	entry = &priv->usergart[fmt].entry[priv->usergart[fmt].last];
 
@@ -503,12 +500,11 @@ static int fault_2d(struct drm_gem_objec
 
 	pfn = entry->paddr >> PAGE_SHIFT;
 
-	VERB("Inserting %p pfn %lx, pa %lx", vmf->virtual_address,
+	VERB("Inserting %p pfn %lx, pa %lx", (void *)vmf->address,
 			pfn, pfn << PAGE_SHIFT);
 
 	for (i = n; i > 0; i--) {
-		vm_insert_mixed(vma, (unsigned long)vaddr,
-				__pfn_to_pfn_t(pfn, PFN_DEV));
+		vm_insert_mixed(vma, vaddr, __pfn_to_pfn_t(pfn, PFN_DEV));
 		pfn += priv->usergart[fmt].stride_pfn;
 		vaddr += PAGE_SIZE * m;
 	}
diff -puN drivers/gpu/drm/tegra/gem.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address drivers/gpu/drm/tegra/gem.c
--- a/drivers/gpu/drm/tegra/gem.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address
+++ a/drivers/gpu/drm/tegra/gem.c
@@ -452,10 +452,10 @@ static int tegra_bo_fault(struct vm_area
 	if (!bo->pages)
 		return VM_FAULT_SIGBUS;
 
-	offset = ((unsigned long)vmf->virtual_address - vma->vm_start) >> PAGE_SHIFT;
+	offset = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
 	page = bo->pages[offset];
 
-	err = vm_insert_page(vma, (unsigned long)vmf->virtual_address, page);
+	err = vm_insert_page(vma, vmf->address, page);
 	switch (err) {
 	case -EAGAIN:
 	case 0:
diff -puN drivers/gpu/drm/ttm/ttm_bo_vm.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address drivers/gpu/drm/ttm/ttm_bo_vm.c
--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address
+++ a/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -101,7 +101,7 @@ static int ttm_bo_vm_fault(struct vm_are
 	struct page *page;
 	int ret;
 	int i;
-	unsigned long address = (unsigned long)vmf->virtual_address;
+	unsigned long address = vmf->address;
 	int retval = VM_FAULT_NOPAGE;
 	struct ttm_mem_type_manager *man =
 		&bdev->man[bo->mem.mem_type];
diff -puN drivers/gpu/drm/udl/udl_gem.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address drivers/gpu/drm/udl/udl_gem.c
--- a/drivers/gpu/drm/udl/udl_gem.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address
+++ a/drivers/gpu/drm/udl/udl_gem.c
@@ -107,14 +107,13 @@ int udl_gem_fault(struct vm_area_struct
 	unsigned int page_offset;
 	int ret = 0;
 
-	page_offset = ((unsigned long)vmf->virtual_address - vma->vm_start) >>
-		PAGE_SHIFT;
+	page_offset = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
 
 	if (!obj->pages)
 		return VM_FAULT_SIGBUS;
 
 	page = obj->pages[page_offset];
-	ret = vm_insert_page(vma, (unsigned long)vmf->virtual_address, page);
+	ret = vm_insert_page(vma, vmf->address, page);
 	switch (ret) {
 	case -EAGAIN:
 	case 0:
diff -puN drivers/gpu/drm/vgem/vgem_drv.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address drivers/gpu/drm/vgem/vgem_drv.c
--- a/drivers/gpu/drm/vgem/vgem_drv.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address
+++ a/drivers/gpu/drm/vgem/vgem_drv.c
@@ -54,7 +54,7 @@ static int vgem_gem_fault(struct vm_area
 {
 	struct drm_vgem_gem_object *obj = vma->vm_private_data;
 	/* We don't use vmf->pgoff since that has the fake offset */
-	unsigned long vaddr = (unsigned long)vmf->virtual_address;
+	unsigned long vaddr = vmf->address;
 	struct page *page;
 
 	page = shmem_read_mapping_page(file_inode(obj->base.filp)->i_mapping,
diff -puN drivers/media/v4l2-core/videobuf-dma-sg.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address drivers/media/v4l2-core/videobuf-dma-sg.c
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address
+++ a/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -439,13 +439,12 @@ static int videobuf_vm_fault(struct vm_a
 	struct page *page;
 
 	dprintk(3, "fault: fault @ %08lx [vma %08lx-%08lx]\n",
-		(unsigned long)vmf->virtual_address,
-		vma->vm_start, vma->vm_end);
+		vmf->address, vma->vm_start, vma->vm_end);
 
 	page = alloc_page(GFP_USER | __GFP_DMA32);
 	if (!page)
 		return VM_FAULT_OOM;
-	clear_user_highpage(page, (unsigned long)vmf->virtual_address);
+	clear_user_highpage(page, vmf->address);
 	vmf->page = page;
 
 	return 0;
diff -puN drivers/misc/cxl/context.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address drivers/misc/cxl/context.c
--- a/drivers/misc/cxl/context.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address
+++ a/drivers/misc/cxl/context.c
@@ -117,13 +117,12 @@ int cxl_context_init(struct cxl_context
 static int cxl_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct cxl_context *ctx = vma->vm_file->private_data;
-	unsigned long address = (unsigned long)vmf->virtual_address;
 	u64 area, offset;
 
 	offset = vmf->pgoff << PAGE_SHIFT;
 
 	pr_devel("%s: pe: %i address: 0x%lx offset: 0x%llx\n",
-			__func__, ctx->pe, address, offset);
+			__func__, ctx->pe, vmf->address, offset);
 
 	if (ctx->afu->current_mode == CXL_MODE_DEDICATED) {
 		area = ctx->afu->psn_phys;
@@ -155,7 +154,7 @@ static int cxl_mmap_fault(struct vm_area
 		return VM_FAULT_SIGBUS;
 	}
 
-	vm_insert_pfn(vma, address, (area + offset) >> PAGE_SHIFT);
+	vm_insert_pfn(vma, vmf->address, (area + offset) >> PAGE_SHIFT);
 
 	mutex_unlock(&ctx->status_mutex);
 
diff -puN drivers/misc/sgi-gru/grumain.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -932,7 +932,7 @@ int gru_fault(struct vm_area_struct *vma
 	unsigned long paddr, vaddr;
 	unsigned long expires;
 
-	vaddr = (unsigned long)vmf->virtual_address;
+	vaddr = vmf->address;
 	gru_dbg(grudev, "vma %p, vaddr 0x%lx (0x%lx)\n",
 		vma, vaddr, GSEG_BASE(vaddr));
 	STAT(nopfn);
diff -puN drivers/staging/android/ion/ion.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address drivers/staging/android/ion/ion.c
--- a/drivers/staging/android/ion/ion.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address
+++ a/drivers/staging/android/ion/ion.c
@@ -882,7 +882,7 @@ static int ion_vm_fault(struct vm_area_s
 	BUG_ON(!buffer->pages || !buffer->pages[vmf->pgoff]);
 
 	pfn = page_to_pfn(ion_buffer_page(buffer->pages[vmf->pgoff]));
-	ret = vm_insert_pfn(vma, (unsigned long)vmf->virtual_address, pfn);
+	ret = vm_insert_pfn(vma, vmf->address, pfn);
 	mutex_unlock(&buffer->lock);
 	if (ret)
 		return VM_FAULT_ERROR;
diff -puN drivers/staging/lustre/lustre/llite/vvp_io.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address drivers/staging/lustre/lustre/llite/vvp_io.c
--- a/drivers/staging/lustre/lustre/llite/vvp_io.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address
+++ a/drivers/staging/lustre/lustre/llite/vvp_io.c
@@ -1014,7 +1014,7 @@ static int vvp_io_kernel_fault(struct vv
 		       "page %p map %p index %lu flags %lx count %u priv %0lx: got addr %p type NOPAGE\n",
 		       vmf->page, vmf->page->mapping, vmf->page->index,
 		       (long)vmf->page->flags, page_count(vmf->page),
-		       page_private(vmf->page), vmf->virtual_address);
+		       page_private(vmf->page), (void *)vmf->address);
 		if (unlikely(!(cfio->ft_flags & VM_FAULT_LOCKED))) {
 			lock_page(vmf->page);
 			cfio->ft_flags |= VM_FAULT_LOCKED;
@@ -1025,12 +1025,12 @@ static int vvp_io_kernel_fault(struct vv
 	}
 
 	if (cfio->ft_flags & (VM_FAULT_SIGBUS | VM_FAULT_SIGSEGV)) {
-		CDEBUG(D_PAGE, "got addr %p - SIGBUS\n", vmf->virtual_address);
+		CDEBUG(D_PAGE, "got addr %p - SIGBUS\n", (void *)vmf->address);
 		return -EFAULT;
 	}
 
 	if (cfio->ft_flags & VM_FAULT_OOM) {
-		CDEBUG(D_PAGE, "got addr %p - OOM\n", vmf->virtual_address);
+		CDEBUG(D_PAGE, "got addr %p - OOM\n", (void *)vmf->address);
 		return -ENOMEM;
 	}
 
diff -puN drivers/xen/privcmd.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address drivers/xen/privcmd.c
--- a/drivers/xen/privcmd.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address
+++ a/drivers/xen/privcmd.c
@@ -602,7 +602,7 @@ static int privcmd_fault(struct vm_area_
 {
 	printk(KERN_DEBUG "privcmd_fault: vma=%p %lx-%lx, pgoff=%lx, uv=%p\n",
 	       vma, vma->vm_start, vma->vm_end,
-	       vmf->pgoff, vmf->virtual_address);
+	       vmf->pgoff, (void *)vmf->address);
 
 	return VM_FAULT_SIGBUS;
 }
diff -puN fs/dax.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address fs/dax.c
--- a/fs/dax.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address
+++ a/fs/dax.c
@@ -738,7 +738,7 @@ static int dax_insert_mapping(struct add
 		struct block_device *bdev, sector_t sector, size_t size,
 		void **entryp, struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	unsigned long vaddr = (unsigned long)vmf->virtual_address;
+	unsigned long vaddr = vmf->address;
 	struct blk_dax_ctl dax = {
 		.sector = sector,
 		.size = size,
@@ -948,7 +948,7 @@ int dax_iomap_fault(struct vm_area_struc
 {
 	struct address_space *mapping = vma->vm_file->f_mapping;
 	struct inode *inode = mapping->host;
-	unsigned long vaddr = (unsigned long)vmf->virtual_address;
+	unsigned long vaddr = vmf->address;
 	loff_t pos = (loff_t)vmf->pgoff << PAGE_SHIFT;
 	sector_t sector;
 	struct iomap iomap = { 0 };
diff -puN include/linux/mm.h~mm-use-vmf-address-instead-of-of-vmf-virtual_address include/linux/mm.h
--- a/include/linux/mm.h~mm-use-vmf-address-instead-of-of-vmf-virtual_address
+++ a/include/linux/mm.h
@@ -297,8 +297,6 @@ struct vm_fault {
 	gfp_t gfp_mask;			/* gfp mask to be used for allocations */
 	pgoff_t pgoff;			/* Logical page offset based on vma */
 	unsigned long address;		/* Faulting virtual address */
-	void __user *virtual_address;	/* Faulting virtual address masked by
-					 * PAGE_MASK */
 	pmd_t *pmd;			/* Pointer to pmd entry matching
 					 * the 'address'
 					 */
diff -puN mm/memory.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address mm/memory.c
--- a/mm/memory.c~mm-use-vmf-address-instead-of-of-vmf-virtual_address
+++ a/mm/memory.c
@@ -2040,7 +2040,7 @@ static int do_page_mkwrite(struct vm_are
 	struct vm_fault vmf;
 	int ret;
 
-	vmf.virtual_address = (void __user *)(address & PAGE_MASK);
+	vmf.address = address & PAGE_MASK;
 	vmf.pgoff = page->index;
 	vmf.flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
 	vmf.gfp_mask = __get_fault_gfp_mask(vma);
@@ -2276,8 +2276,7 @@ static int wp_pfn_shared(struct vm_fault
 		struct vm_fault vmf2 = {
 			.page = NULL,
 			.pgoff = linear_page_index(vma, vmf->address),
-			.virtual_address =
-				(void __user *)(vmf->address & PAGE_MASK),
+			.address = vmf->address,
 			.flags = FAULT_FLAG_WRITE | FAULT_FLAG_MKWRITE,
 		};
 		int ret;
@@ -2852,7 +2851,7 @@ static int __do_fault(struct vm_fault *v
 	struct vm_fault vmf2;
 	int ret;
 
-	vmf2.virtual_address = (void __user *)(vmf->address & PAGE_MASK);
+	vmf2.address = vmf->address;
 	vmf2.pgoff = pgoff;
 	vmf2.flags = vmf->flags;
 	vmf2.page = NULL;
@@ -3612,7 +3611,7 @@ static int __handle_mm_fault(struct vm_a
 {
 	struct vm_fault vmf = {
 		.vma = vma,
-		.address = address,
+		.address = address & PAGE_MASK,
 		.flags = flags,
 	};
 	struct mm_struct *mm = vma->vm_mm;
_
