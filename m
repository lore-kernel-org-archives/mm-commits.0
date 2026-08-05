Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA153C0A1E
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896779; cv=none; b=SkiHg51kyuBezCVOrhv8oYXuX9UdgbKJqSEsqN16SrgAxqMbFzTU57w0j8wh2KdpEQGldVp+SPeU626NeXXDXj8Qrh10jYGtgOJYXQOFsX0svSs7Str5t0MDFVqkuREetYcaAPVqpSW4P75EXDAUbJwBfReIpWM9cSdxH7TQ3SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896779; c=relaxed/simple;
	bh=onnXDvGdmqmEKjvXgN3ZpCGGs65v/Vm34KorW2zz5D4=;
	h=Date:To:From:Subject:Message-Id; b=YAsRNEbMle1P5QdOIXW3RHf+w/ycnCnV3niWn0xV+xdw9WwRRZbb2zGCX0B+F0pK/ATtYPVzKSxVv6hGXhoDsPY+59KTPLMoXrhCazL4x6viF8yGq6W2/dBTZCPbi/OzUz3zIuhBaHntOiZzmivykaQ7GUVRlK3uLc3wNTEHpV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w5wCYT88; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w5wCYT88"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285D61F000E9;
	Wed,  5 Aug 2026 02:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896778;
	bh=OEU1hIzCGdvsuXb3AYb8TBjjK8+UJH0hEK2ov3+NZZo=;
	h=Date:To:From:Subject;
	b=w5wCYT880KI/GRVocA+/aXBhivjvWPBU7rxU7wsrooZdzfbdV9fqXI1GyCJBN4Gqa
	 oPmhVtvRmgui3at2Qi7Z2gHTP3WZ5UigxXWk3D4JlZQVkjxThnkbPiyuCIlI9CV0Bs
	 P7+qFez2ANyBeRd1xfp7LvRTmxRYopNA3ijjZPRU=
Date: Tue, 04 Aug 2026 19:26:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tzimmermann@suse.de,sj@kernel.org,pfalcato@suse.de,m.szyprowski@samsung.com,liam@infradead.org,kai.huang@intel.com,gourry@gourry.net,david@kernel.org,ackerleytng@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-linear_page_-consistently.patch removed from -mm tree
Message-Id: <20260805022618.285D61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use linear_page_[index, delta]() consistently
has been removed from the -mm tree.  Its filename was
     mm-use-linear_page_-consistently.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>	[DRM]
Acked-by: Kai Huang <kai.huang@intel.com> # for sgx
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Pedro Falcato <pfalcato@suse.de> # for mm
Reviewed-by: Ackerley Tng <ackerleytng@google.com>	[guest_memfd]
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: SJ Park <sj@kernel.org>
Cc: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
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

mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
arm64-remove-redundant-concurrent-ptdump-uaf-mitigation.patch
mm-huge_memory-fix-huge_zero_pfn-race.patch
mm-huge_memory-separate-out-config_persistent_huge_zero_folio-logic.patch
x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch
mm-introduce-vma_flags_can_grow-and-vma_can_grow.patch
mm-vma-update-do_mmap-to-use-vma_flags_t.patch
mm-convert-__get_unmapped_area-to-use-vma_flags_t.patch
mm-update-generic_get_unmapped_area-to-use-vma_flags_t.patch
mm-prefer-mm-def_vma_flags-in-mm-logic.patch
mm-vma-convert-vm_pgprot_modify-to-use-vma_flags_t-and-rename.patch
mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot.patch
mm-introduce-vma_get_page_prot-and-use-it.patch
mm-vma-update-create_init_stack_vma-to-use-vma_flags_t.patch
mm-vma-convert-miscellaneous-uses-of-vma-flags-in-core-mm.patch
mm-mlock-convert-mlock-code-to-use-vma_flags_t.patch
mm-mprotect-convert-mprotect-code-to-use-vma_flags_t.patch
mm-mremap-convert-mremap-code-to-use-vma_flags_t.patch
mm-mseal-remove-superfluous-comments-fix-confusion-around-mm.patch
mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero.patch
mm-mseal-remove-further-superfluous-comments-do_mseal.patch
mm-vma-introduce-vma-virtual-page-offset-field-and-add-helpers.patch
mm-introduce-linear_virt_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-virtual-page-index.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-propagate-vma-virtual-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-walk-is-anonymous.patch
mm-introduce-and-use-linear_folio_page_index.patch
mm-rmap-use-virt-pgoff-for-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-virt-pgoff.patch
tools-testing-selftests-mm-test-virtual-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-add-some-missing-includes-to-mm-local-headers.patch

