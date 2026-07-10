Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33C03E6398
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 22:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783723621; cv=none; b=FBh4Lg7iJqhEh6U98wrOR9hCm2iD00xUToTBZ3elyYML79+ZRmu3JvL+uo8AligFVEMMydwwNRG4UU6yHo6aaLWhLMS5+cGEtLI83zmMaAa+iFVO5eiRNIX0Ml85ajVQel6hsWS4KgWOMUUi7iP8OYebIRKgVS//RF3dhnmqz0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783723621; c=relaxed/simple;
	bh=Vng//yw+Ei1Q6QU2JfUMVV+TAWlTrfAJxQ2sEsnPjAY=;
	h=Date:To:From:Subject:Message-Id; b=J61TG8q2AH1tKL/+Q7vzuksLvbeK94N1UbDAgL3T5+3M0LBNx+m2v9Pt7WOkERnGdYzbdeFC1OY5qKJVvgzpmtj7A03GYx/lDhvdPmIKerfPUE3VfJrgFZtFhJifGgAmHNlWAsAe5eXWgqXyARyrP2F+mF5zSBpqtyXjxHU4isQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=brsf1lJE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="brsf1lJE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25BED1F00A3A;
	Fri, 10 Jul 2026 22:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783723619;
	bh=Cou1hSTG89oseFiH4H5hMAErNxQhSAWyv3GdcKU21eI=;
	h=Date:To:From:Subject;
	b=brsf1lJEGjPQTByi3+m0a6UKTKVGfO/agzEmwOr/virHzFNwqopDSI5vkDEFTh0vv
	 iUulnxcG8wmXtuWm1PYqrMIunpbWZBtPcRH5UNZNAIAQU7Vpx5UBkWlVhX/kMbUKJs
	 Ykpz6DBxj8GvLpdkYEaMz9NYVWEbZdQrsaOOjF4g=
Date: Fri, 10 Jul 2026 15:46:58 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-linear_page_-consistently.patch added to mm-new branch
Message-Id: <20260710224659.25BED1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use linear_page_[index, delta]() consistently
has been added to the -mm mm-new branch.  Its filename is
     mm-use-linear_page_-consistently.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-linear_page_-consistently.patch

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
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm: use linear_page_[index, delta]() consistently
Date: Fri, 10 Jul 2026 21:17:02 +0100

There are a number of places where we open code what linear_page_index()
and linear_page_delta() calculate.

Replace this code with the appropriate functions for consistency.

No functional change intended.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-21-2a5aa403d977@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de> # for DRM
Acked-by: Kai Huang <kai.huang@intel.com> # for sgx
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Pedro Falcato <pfalcato@suse.de> # for mm
Reviewed-by: Ackerley Tng <ackerleytng@google.com> # for guest_memfd
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: SJ Park <sj@kernel.org>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/fault-armv.c              |    2 +-
 arch/x86/kernel/cpu/sgx/virt.c        |    3 ++-
 drivers/gpu/drm/etnaviv/etnaviv_gem.c |    3 ++-
 drivers/gpu/drm/gma500/gem.c          |    2 +-
 drivers/gpu/drm/msm/msm_gem.c         |    3 ++-
 drivers/gpu/drm/omapdrm/omap_gem.c    |    5 +++--
 drivers/gpu/drm/tegra/gem.c           |    3 ++-
 drivers/gpu/drm/ttm/ttm_bo_vm.c       |    7 ++++---
 drivers/vfio/pci/nvgrace-gpu/main.c   |    3 ++-
 drivers/vfio/pci/vfio_pci_core.c      |    3 ++-
 mm/nommu.c                            |    2 +-
 mm/vma.c                              |    2 +-
 virt/kvm/guest_memfd.c                |    2 +-
 13 files changed, 24 insertions(+), 16 deletions(-)

--- a/arch/arm/mm/fault-armv.c~mm-use-linear_page_-consistently
+++ a/arch/arm/mm/fault-armv.c
@@ -132,7 +132,7 @@ make_coherent(struct address_space *mapp
 	pgoff_t pgoff;
 	int aliases = 0;
 
-	pgoff = vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT);
+	pgoff = linear_page_index(vma, addr);
 
 	/*
 	 * If we have any shared mappings that are in the same mm
--- a/arch/x86/kernel/cpu/sgx/virt.c~mm-use-linear_page_-consistently
+++ a/arch/x86/kernel/cpu/sgx/virt.c
@@ -9,6 +9,7 @@
 #include <linux/miscdevice.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
+#include <linux/pagemap.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/signal.h>
 #include <linux/slab.h>
@@ -41,7 +42,7 @@ static int __sgx_vepc_fault(struct sgx_v
 	WARN_ON(!mutex_is_locked(&vepc->lock));
 
 	/* Calculate index of EPC page in virtual EPC's page_array */
-	index = vma->vm_pgoff + PFN_DOWN(addr - vma->vm_start);
+	index = linear_page_index(vma, addr);
 
 	epc_page = xa_load(&vepc->page_array, index);
 	if (epc_page)
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c~mm-use-linear_page_-consistently
+++ a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
@@ -6,6 +6,7 @@
 #include <drm/drm_prime.h>
 #include <drm/drm_print.h>
 #include <linux/dma-mapping.h>
+#include <linux/pagemap.h>
 #include <linux/shmem_fs.h>
 #include <linux/spinlock.h>
 #include <linux/vmalloc.h>
@@ -188,7 +189,7 @@ static vm_fault_t etnaviv_gem_fault(stru
 	}
 
 	/* We don't use vmf->pgoff since that has the fake offset: */
-	pgoff = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
+	pgoff = linear_page_delta(vma, vmf->address);
 
 	pfn = page_to_pfn(pages[pgoff]);
 
--- a/drivers/gpu/drm/gma500/gem.c~mm-use-linear_page_-consistently
+++ a/drivers/gpu/drm/gma500/gem.c
@@ -288,7 +288,7 @@ static vm_fault_t psb_gem_fault(struct v
 
 	/* Page relative to the VMA start - we must calculate this ourselves
 	   because vmf->pgoff is the fake GEM offset */
-	page_offset = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
+	page_offset = linear_page_delta(vma, vmf->address);
 
 	/* CPU view of the page, don't go via the GART for CPU writes */
 	if (pobj->stolen)
--- a/drivers/gpu/drm/msm/msm_gem.c~mm-use-linear_page_-consistently
+++ a/drivers/gpu/drm/msm/msm_gem.c
@@ -9,6 +9,7 @@
 #include <linux/spinlock.h>
 #include <linux/shmem_fs.h>
 #include <linux/dma-buf.h>
+#include <linux/pagemap.h>
 
 #include <drm/drm_dumb_buffers.h>
 #include <drm/drm_prime.h>
@@ -360,7 +361,7 @@ static vm_fault_t msm_gem_fault(struct v
 	}
 
 	/* We don't use vmf->pgoff since that has the fake offset: */
-	pgoff = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
+	pgoff = linear_page_delta(vma, vmf->address);
 
 	pfn = page_to_pfn(pages[pgoff]);
 
--- a/drivers/gpu/drm/omapdrm/omap_gem.c~mm-use-linear_page_-consistently
+++ a/drivers/gpu/drm/omapdrm/omap_gem.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/dma-mapping.h>
+#include <linux/pagemap.h>
 #include <linux/seq_file.h>
 #include <linux/shmem_fs.h>
 #include <linux/spinlock.h>
@@ -359,7 +360,7 @@ static vm_fault_t omap_gem_fault_1d(stru
 	pgoff_t pgoff;
 
 	/* We don't use vmf->pgoff since that has the fake offset: */
-	pgoff = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
+	pgoff = linear_page_delta(vma, vmf->address);
 
 	if (omap_obj->pages) {
 		omap_gem_cpu_sync_page(obj, pgoff);
@@ -407,7 +408,7 @@ static vm_fault_t omap_gem_fault_2d(stru
 	const int m = DIV_ROUND_UP(omap_obj->width << fmt, PAGE_SIZE);
 
 	/* We don't use vmf->pgoff since that has the fake offset: */
-	pgoff = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
+	pgoff = linear_page_delta(vma, vmf->address);
 
 	/*
 	 * Actual address we start mapping at is rounded down to previous slot
--- a/drivers/gpu/drm/tegra/gem.c~mm-use-linear_page_-consistently
+++ a/drivers/gpu/drm/tegra/gem.c
@@ -13,6 +13,7 @@
 #include <linux/dma-buf.h>
 #include <linux/iommu.h>
 #include <linux/module.h>
+#include <linux/pagemap.h>
 #include <linux/vmalloc.h>
 
 #include <drm/drm_drv.h>
@@ -564,7 +565,7 @@ static vm_fault_t tegra_bo_fault(struct
 	if (!bo->pages)
 		return VM_FAULT_SIGBUS;
 
-	offset = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
+	offset = linear_page_delta(vma, vmf->address);
 	page = bo->pages[offset];
 
 	return vmf_insert_page(vma, vmf->address, page);
--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c~mm-use-linear_page_-consistently
+++ a/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -32,6 +32,7 @@
 #define pr_fmt(fmt) "[TTM] " fmt
 
 #include <linux/export.h>
+#include <linux/pagemap.h>
 
 #include <drm/ttm/ttm_bo.h>
 #include <drm/ttm/ttm_placement.h>
@@ -208,9 +209,9 @@ vm_fault_t ttm_bo_vm_fault_reserved(stru
 	if (unlikely(err != 0))
 		return VM_FAULT_SIGBUS;
 
-	page_offset = ((address - vma->vm_start) >> PAGE_SHIFT) +
-		vma->vm_pgoff - drm_vma_node_start(&bo->base.vma_node);
-	page_last = vma_pages(vma) + vma->vm_pgoff -
+	page_offset = linear_page_index(vma, address) -
+		drm_vma_node_start(&bo->base.vma_node);
+	page_last = vma_end_pgoff(vma) -
 		drm_vma_node_start(&bo->base.vma_node);
 
 	if (unlikely(page_offset >= PFN_UP(bo->base.size)))
--- a/drivers/vfio/pci/nvgrace-gpu/main.c~mm-use-linear_page_-consistently
+++ a/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -11,6 +11,7 @@
 #include <linux/jiffies.h>
 #include <linux/sched.h>
 #include <linux/pci-p2pdma.h>
+#include <linux/pagemap.h>
 #include <linux/pm_runtime.h>
 #include <linux/memory-failure.h>
 
@@ -385,7 +386,7 @@ static unsigned long addr_to_pgoff(struc
 	u64 pgoff = vma->vm_pgoff &
 		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
 
-	return ((addr - vma->vm_start) >> PAGE_SHIFT) + pgoff;
+	return linear_page_delta(vma, addr) + pgoff;
 }
 
 static vm_fault_t nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf,
--- a/drivers/vfio/pci/vfio_pci_core.c~mm-use-linear_page_-consistently
+++ a/drivers/vfio/pci/vfio_pci_core.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/notifier.h>
+#include <linux/pagemap.h>
 #include <linux/pci.h>
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
@@ -1780,7 +1781,7 @@ static vm_fault_t vfio_pci_mmap_huge_fau
 	struct vm_area_struct *vma = vmf->vma;
 	struct vfio_pci_core_device *vdev = vma->vm_private_data;
 	unsigned long addr = vmf->address & ~((PAGE_SIZE << order) - 1);
-	unsigned long pgoff = (addr - vma->vm_start) >> PAGE_SHIFT;
+	unsigned long pgoff = linear_page_delta(vma, addr);
 	unsigned long pfn = vma_to_pfn(vma) + pgoff;
 	vm_fault_t ret = VM_FAULT_FALLBACK;
 
--- a/mm/nommu.c~mm-use-linear_page_-consistently
+++ a/mm/nommu.c
@@ -1355,7 +1355,7 @@ static int split_vma(struct vma_iterator
 	*region = *vma->vm_region;
 	new->vm_region = region;
 
-	npages = (addr - vma->vm_start) >> PAGE_SHIFT;
+	npages = linear_page_delta(vma, addr);
 
 	if (new_below) {
 		region->vm_top = region->vm_end = new->vm_end = addr;
--- a/mm/vma.c~mm-use-linear_page_-consistently
+++ a/mm/vma.c
@@ -517,7 +517,7 @@ __split_vma(struct vma_iterator *vmi, st
 		new->vm_end = addr;
 	} else {
 		new->vm_start = addr;
-		new->vm_pgoff += ((addr - vma->vm_start) >> PAGE_SHIFT);
+		new->vm_pgoff += linear_page_delta(vma, addr);
 	}
 
 	err = -ENOMEM;
--- a/virt/kvm/guest_memfd.c~mm-use-linear_page_-consistently
+++ a/virt/kvm/guest_memfd.c
@@ -440,7 +440,7 @@ static int kvm_gmem_set_policy(struct vm
 static struct mempolicy *kvm_gmem_get_policy(struct vm_area_struct *vma,
 					     unsigned long addr, pgoff_t *ilx)
 {
-	pgoff_t pgoff = vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT);
+	pgoff_t pgoff = linear_page_index(vma, addr);
 	struct inode *inode = file_inode(vma->vm_file);
 
 	*ilx = inode->i_ino;
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-move-alloc-tag-to-mm.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
mm-vmalloc-acquire-init_mm-read-lock-on-huge-vmap-promotion.patch
revert-arm64-enable-vmalloc-huge-with-ptdump.patch
mm-move-vma_start_pgoff-into-mmh-and-clean-up.patch
mm-add-kdoc-comments-for-vma_start-last_pgoff.patch
tools-testing-vma-use-vma_start_pgoff-in-merge-tests.patch
mm-introduce-and-use-vma_end_pgoff.patch
mm-rmap-update-mm-interval_treec-comments.patch
mm-rmap-parameterise-vma_interval_tree_-by-address_space.patch
mm-rmap-elide-unnecessary-static-inlines-in-interval_treec.patch
mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_.patch
mm-rmap-parameterise-anon_vma_interval_tree_-by-anon_vma.patch
mm-rmap-rename-anon_vma_interval_tree_-params-and-use-pgoff_t.patch
mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_.patch
maintainers-move-mm-interval_treec-to-rmap-section.patch
mm-vma-introduce-and-use-vmg_pages-vmg__pgoff.patch
mm-vma-clean-up-anon_vma_compatible.patch
mm-vma-refactor-vmg_adjust_set_range-for-clarity.patch
mm-vma-minor-cleanup-of-expand_.patch
mm-introduce-and-use-linear_page_delta.patch
mm-vma-use-vma_start_pgoff-linear_page_index-in-mm-code.patch
mm-prefer-vma__pgoff-to-vma-vm_pgoff-in-kernel.patch
mm-vma-remove-duplicative-vma_pgoff_offset-helper.patch
mm-use-linear_page_-consistently.patch
mm-vma-introduce-vma_assert_can_modify.patch
mm-vma-add-and-use-vma__pgoff.patch
mm-vma-move-__install_special_mapping-to-vmac.patch
mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl.patch
mm-vma-update-vma_shrink-to-not-pass-start-pgoff-parameters.patch
mm-vma-update-vmg_adjust_set_range-to-offset-pgoff-instead.patch
mm-vma-slightly-rework-the-anonymous-check-in-__mmap_new_vma.patch
mm-vma-introduce-and-use-vma_set_pgoff.patch
mm-vma-correct-incorrect-vmah-inclusion.patch
mm-vma-use-guard-clauses-in-can_vma_merge_.patch
tools-testing-vma-default-vma-mm-flag-bits-to-64-bit.patch
tools-testing-vma-output-compared-expression-on-assert_.patch

