Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE7637AA92
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 02:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783995979; cv=none; b=uS/7+h022vvrCKUNNWiYIiv3LAXEc4ys2h35wUsyBD2RfDOgb6H32e8DzHSIuRxJSIgz3pmOGgLQHAV6mRWYQHc1vOGUH22v30krm1TxMoL1eSRzrk2pjA4MnQAW4QeYkcZoUT+AzEGblTe/zD4EWaPBfAjo7B5KyRJkVJt6DI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783995979; c=relaxed/simple;
	bh=tpmxo/h/Isa3/9qP5HraFa3b/tDNyHqirgIp2KJ7PEY=;
	h=Date:To:From:Subject:Message-Id; b=ny4OdCNAgkAEq/JPuYZk2YNL+m4pM/nyj8L01CmmFWWkVf5n4nvrW1MosaWoMBuSetgH0tu3aZN8PAd8aWcXHR+vjixVSIOi7ujnCv+q/GhUd2O2xFuYUx5utTDLBzCtFDnMAnbrU0FhoDMCyxD789bKKd42EKlu7S630YYBJeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZL/WzXxE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZL/WzXxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614BF1F000E9;
	Tue, 14 Jul 2026 02:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783995977;
	bh=XYxAn1GbXVL0daYFYrXfQp46vACrVeMoVVIPHsTb3L8=;
	h=Date:To:From:Subject;
	b=ZL/WzXxEAX1abByK7jhwleJh061Oaqz5YlrmRRYSJDY+cdWyKBDmxnEzh1SDEQ4+m
	 trOBvoWrjoJnlZr4nouHukj6uynamzBEGb9pgNtMUWjo5/CS7pctAQfrpVHNChNyfC
	 F9lI1uYTnIl+UUr0yFdWCBxuL029gLjv+LLgjAj4=
Date: Mon, 13 Jul 2026 19:26:16 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-vma_get_page_prot-and-use-it.patch added to mm-new branch
Message-Id: <20260714022617.614BF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce vma_get_page_prot() and use it
has been added to the -mm mm-new branch.  Its filename is
     mm-introduce-vma_get_page_prot-and-use-it.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-vma_get_page_prot-and-use-it.patch

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
Subject: mm: introduce vma_get_page_prot() and use it
Date: Sat, 11 Jul 2026 19:45:05 +0100

There's a large number of vm_get_page_prot(vma->vm_flags) invocations. 
Make life easier by introducing vma_get_page_prot() parameterised by the
VMA.

This also makes converting vm_get_page_prot() to vma_flags_t easier.

Also update the userland VMA tests to reflect the change.

No functional change intended.

Link: https://lore.kernel.org/20260711-b4-vma-flags-mm-v2-8-0fa2357d5431@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Jani Nikula <jani.nikula@intel.com> # for i915
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de> # DRM
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_gem.c                   |    2 +-
 drivers/gpu/drm/drm_gem_dma_helper.c        |    2 +-
 drivers/gpu/drm/drm_gem_shmem_helper.c      |    2 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem.c       |    2 +-
 drivers/gpu/drm/exynos/exynos_drm_gem.c     |    6 +++---
 drivers/gpu/drm/i915/gem/i915_gem_mman.c    |   12 ++++++------
 drivers/gpu/drm/msm/msm_gem.c               |    2 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c       |    2 +-
 drivers/gpu/drm/omapdrm/omap_fbdev.c        |    2 +-
 drivers/gpu/drm/omapdrm/omap_gem.c          |    6 +++---
 drivers/gpu/drm/panthor/panthor_gem.c       |    2 +-
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c |    2 +-
 drivers/gpu/drm/tegra/gem.c                 |    2 +-
 drivers/gpu/drm/virtio/virtgpu_vram.c       |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c  |    2 +-
 drivers/gpu/drm/xe/xe_device.c              |    2 +-
 drivers/gpu/drm/xe/xe_mmio_gem.c            |    2 +-
 drivers/gpu/drm/xen/xen_drm_front_gem.c     |    2 +-
 drivers/video/fbdev/core/fb_io_fops.c       |    2 +-
 include/linux/mm.h                          |   11 ++++++++++-
 mm/vma.c                                    |    2 +-
 mm/vma_exec.c                               |    2 +-
 sound/core/memalloc.c                       |    2 +-
 tools/testing/vma/include/dup.h             |    5 +++++
 24 files changed, 46 insertions(+), 32 deletions(-)

--- a/drivers/gpu/drm/drm_gem.c~mm-introduce-vma_get_page_prot-and-use-it
+++ a/drivers/gpu/drm/drm_gem.c
@@ -1252,7 +1252,7 @@ int drm_gem_mmap_obj(struct drm_gem_obje
 		}
 
 		vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
-		vma->vm_page_prot = pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
+		vma->vm_page_prot = pgprot_writecombine(vma_get_page_prot(vma));
 		vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
 	}
 
--- a/drivers/gpu/drm/drm_gem_dma_helper.c~mm-introduce-vma_get_page_prot-and-use-it
+++ a/drivers/gpu/drm/drm_gem_dma_helper.c
@@ -540,7 +540,7 @@ int drm_gem_dma_mmap(struct drm_gem_dma_
 	vm_flags_mod(vma, VM_DONTDUMP | VM_DONTEXPAND, VM_PFNMAP);
 
 	if (dma_obj->map_noncoherent) {
-		vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+		vma->vm_page_prot = vma_get_page_prot(vma);
 
 		ret = dma_mmap_pages(drm_dev_dma_dev(dma_obj->base.dev),
 				     vma, vma->vm_end - vma->vm_start,
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c~mm-introduce-vma_get_page_prot-and-use-it
+++ a/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -764,7 +764,7 @@ int drm_gem_shmem_mmap(struct drm_gem_sh
 		return ret;
 
 	vm_flags_set(vma, VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
-	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+	vma->vm_page_prot = vma_get_page_prot(vma);
 	if (shmem->map_wc)
 		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c~mm-introduce-vma_get_page_prot-and-use-it
+++ a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
@@ -133,7 +133,7 @@ static int etnaviv_gem_mmap_obj(struct e
 
 	vm_flags_set(vma, VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
 
-	vm_page_prot = vm_get_page_prot(vma->vm_flags);
+	vm_page_prot = vma_get_page_prot(vma);
 
 	if (etnaviv_obj->flags & ETNA_BO_WC) {
 		vma->vm_page_prot = pgprot_writecombine(vm_page_prot);
--- a/drivers/gpu/drm/exynos/exynos_drm_gem.c~mm-introduce-vma_get_page_prot-and-use-it
+++ a/drivers/gpu/drm/exynos/exynos_drm_gem.c
@@ -377,13 +377,13 @@ static int exynos_drm_gem_mmap(struct dr
 
 	/* non-cachable as default. */
 	if (exynos_gem->flags & EXYNOS_BO_CACHABLE)
-		vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+		vma->vm_page_prot = vma_get_page_prot(vma);
 	else if (exynos_gem->flags & EXYNOS_BO_WC)
 		vma->vm_page_prot =
-			pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
+			pgprot_writecombine(vma_get_page_prot(vma));
 	else
 		vma->vm_page_prot =
-			pgprot_noncached(vm_get_page_prot(vma->vm_flags));
+			pgprot_noncached(vma_get_page_prot(vma));
 
 	ret = exynos_drm_gem_mmap_buffer(exynos_gem, vma);
 	if (ret)
--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c~mm-introduce-vma_get_page_prot-and-use-it
+++ a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -112,7 +112,7 @@ i915_gem_mmap_ioctl(struct drm_device *d
 		vma = find_vma(mm, addr);
 		if (vma && __vma_matches(vma, obj->base.filp, addr, args->size))
 			vma->vm_page_prot =
-				pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
+				pgprot_writecombine(vma_get_page_prot(vma));
 		else
 			addr = -ENOMEM;
 		mmap_write_unlock(mm);
@@ -1024,7 +1024,7 @@ i915_gem_object_mmap(struct drm_i915_gem
 	fput(anon);
 
 	if (obj->ops->mmap_ops) {
-		vma->vm_page_prot = pgprot_decrypted(vm_get_page_prot(vma->vm_flags));
+		vma->vm_page_prot = pgprot_decrypted(vma_get_page_prot(vma));
 		vma->vm_ops = obj->ops->mmap_ops;
 		vma->vm_private_data = obj->base.vma_node.driver_private;
 		return 0;
@@ -1035,7 +1035,7 @@ i915_gem_object_mmap(struct drm_i915_gem
 	switch (mmo->mmap_type) {
 	case I915_MMAP_TYPE_WC:
 		vma->vm_page_prot =
-			pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
+			pgprot_writecombine(vma_get_page_prot(vma));
 		vma->vm_ops = &vm_ops_cpu;
 		break;
 
@@ -1043,19 +1043,19 @@ i915_gem_object_mmap(struct drm_i915_gem
 		GEM_WARN_ON(1);
 		fallthrough;
 	case I915_MMAP_TYPE_WB:
-		vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+		vma->vm_page_prot = vma_get_page_prot(vma);
 		vma->vm_ops = &vm_ops_cpu;
 		break;
 
 	case I915_MMAP_TYPE_UC:
 		vma->vm_page_prot =
-			pgprot_noncached(vm_get_page_prot(vma->vm_flags));
+			pgprot_noncached(vma_get_page_prot(vma));
 		vma->vm_ops = &vm_ops_cpu;
 		break;
 
 	case I915_MMAP_TYPE_GTT:
 		vma->vm_page_prot =
-			pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
+			pgprot_writecombine(vma_get_page_prot(vma));
 		vma->vm_ops = &vm_ops_gtt;
 		break;
 	}
--- a/drivers/gpu/drm/msm/msm_gem.c~mm-introduce-vma_get_page_prot-and-use-it
+++ a/drivers/gpu/drm/msm/msm_gem.c
@@ -1125,7 +1125,7 @@ static int msm_gem_object_mmap(struct dr
 	struct msm_gem_object *msm_obj = to_msm_bo(obj);
 
 	vm_flags_set(vma, VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
-	vma->vm_page_prot = msm_gem_pgprot(msm_obj, vm_get_page_prot(vma->vm_flags));
+	vma->vm_page_prot = msm_gem_pgprot(msm_obj, vma_get_page_prot(vma));
 
 	return 0;
 }
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c~mm-introduce-vma_get_page_prot-and-use-it
+++ a/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -55,7 +55,7 @@ static vm_fault_t nouveau_ttm_fault(stru
 		goto error_unlock;
 
 	nouveau_bo_del_io_reserve_lru(bo);
-	prot = vm_get_page_prot(vma->vm_flags);
+	prot = vma_get_page_prot(vma);
 	ret = ttm_bo_vm_fault_reserved(vmf, prot, TTM_BO_VM_NUM_PREFAULT);
 	nouveau_bo_add_io_reserve_lru(bo);
 	if (ret == VM_FAULT_RETRY && !(vmf->flags & FAULT_FLAG_RETRY_NOWAIT))
--- a/drivers/gpu/drm/omapdrm/omap_fbdev.c~mm-introduce-vma_get_page_prot-and-use-it
+++ a/drivers/gpu/drm/omapdrm/omap_fbdev.c
@@ -84,7 +84,7 @@ fallback:
 
 static int omap_fbdev_fb_mmap(struct fb_info *info, struct vm_area_struct *vma)
 {
-	vma->vm_page_prot = pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
+	vma->vm_page_prot = pgprot_writecombine(vma_get_page_prot(vma));
 
 	return fb_deferred_io_mmap(info, vma);
 }
--- a/drivers/gpu/drm/omapdrm/omap_gem.c~mm-introduce-vma_get_page_prot-and-use-it
+++ a/drivers/gpu/drm/omapdrm/omap_gem.c
@@ -538,9 +538,9 @@ static int omap_gem_object_mmap(struct d
 	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP | VM_IO | VM_MIXEDMAP);
 
 	if (omap_obj->flags & OMAP_BO_WC) {
-		vma->vm_page_prot = pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
+		vma->vm_page_prot = pgprot_writecombine(vma_get_page_prot(vma));
 	} else if (omap_obj->flags & OMAP_BO_UNCACHED) {
-		vma->vm_page_prot = pgprot_noncached(vm_get_page_prot(vma->vm_flags));
+		vma->vm_page_prot = pgprot_noncached(vma_get_page_prot(vma));
 	} else {
 		/*
 		 * We do have some private objects, at least for scanout buffers
@@ -558,7 +558,7 @@ static int omap_gem_object_mmap(struct d
 		vma->vm_pgoff -= drm_vma_node_start(&obj->vma_node);
 		vma_set_file(vma, obj->filp);
 
-		vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+		vma->vm_page_prot = vma_get_page_prot(vma);
 	}
 
 	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
--- a/drivers/gpu/drm/panthor/panthor_gem.c~mm-introduce-vma_get_page_prot-and-use-it
+++ a/drivers/gpu/drm/panthor/panthor_gem.c
@@ -776,7 +776,7 @@ static int panthor_gem_mmap(struct drm_g
 	}
 
 	vm_flags_set(vma, VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
-	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+	vma->vm_page_prot = vma_get_page_prot(vma);
 	if (should_map_wc(bo))
 		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 
--- a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c~mm-introduce-vma_get_page_prot-and-use-it
+++ a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
@@ -255,7 +255,7 @@ static int rockchip_drm_gem_object_mmap(
 	 */
 	vm_flags_mod(vma, VM_IO | VM_DONTEXPAND | VM_DONTDUMP, VM_PFNMAP);
 
-	vma->vm_page_prot = pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
+	vma->vm_page_prot = pgprot_writecombine(vma_get_page_prot(vma));
 	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
 
 	if (rk_obj->pages)
--- a/drivers/gpu/drm/tegra/gem.c~mm-introduce-vma_get_page_prot-and-use-it
+++ a/drivers/gpu/drm/tegra/gem.c
@@ -602,7 +602,7 @@ int __tegra_gem_mmap(struct drm_gem_obje
 
 		vma->vm_pgoff = vm_pgoff;
 	} else {
-		pgprot_t prot = vm_get_page_prot(vma->vm_flags);
+		pgprot_t prot = vma_get_page_prot(vma);
 
 		vm_flags_mod(vma, VM_MIXEDMAP, VM_PFNMAP);
 
--- a/drivers/gpu/drm/virtio/virtgpu_vram.c~mm-introduce-vma_get_page_prot-and-use-it
+++ a/drivers/gpu/drm/virtio/virtgpu_vram.c
@@ -55,7 +55,7 @@ static int virtio_gpu_vram_mmap(struct d
 
 	vma->vm_pgoff -= drm_vma_node_start(&obj->vma_node);
 	vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND);
-	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+	vma->vm_page_prot = vma_get_page_prot(vma);
 	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
 	vma->vm_ops = &virtio_gpu_vram_vm_ops;
 
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c~mm-introduce-vma_get_page_prot-and-use-it
+++ a/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
@@ -481,7 +481,7 @@ vm_fault_t vmw_bo_vm_fault(struct vm_fau
 	if (vbo->dirty && vbo->dirty->method == VMW_BO_DIRTY_MKWRITE)
 		prot = vm_get_page_prot(vma->vm_flags & ~VM_SHARED);
 	else
-		prot = vm_get_page_prot(vma->vm_flags);
+		prot = vma_get_page_prot(vma);
 
 	ret = ttm_bo_vm_fault_reserved(vmf, prot, num_prefault);
 	if (ret == VM_FAULT_RETRY && !(vmf->flags & FAULT_FLAG_RETRY_NOWAIT))
--- a/drivers/gpu/drm/xen/xen_drm_front_gem.c~mm-introduce-vma_get_page_prot-and-use-it
+++ a/drivers/gpu/drm/xen/xen_drm_front_gem.c
@@ -80,7 +80,7 @@ static int xen_drm_front_gem_object_mmap
 	 * which is mapped as Normal Inner Write-Back Outer Write-Back
 	 * Inner-Shareable.
 	 */
-	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+	vma->vm_page_prot = vma_get_page_prot(vma);
 
 	/*
 	 * vm_operations_struct.fault handler will be called if CPU access
--- a/drivers/gpu/drm/xe/xe_device.c~mm-introduce-vma_get_page_prot-and-use-it
+++ a/drivers/gpu/drm/xe/xe_device.c
@@ -281,7 +281,7 @@ static vm_fault_t barrier_fault(struct v
 	pgprot_t prot;
 	int idx;
 
-	prot = vm_get_page_prot(vma->vm_flags);
+	prot = vma_get_page_prot(vma);
 
 	if (drm_dev_enter(dev, &idx)) {
 		unsigned long pfn;
--- a/drivers/gpu/drm/xe/xe_mmio_gem.c~mm-introduce-vma_get_page_prot-and-use-it
+++ a/drivers/gpu/drm/xe/xe_mmio_gem.c
@@ -149,7 +149,7 @@ static int xe_mmio_gem_mmap(struct drm_g
 
 	/* Set vm_pgoff (used as a fake buffer offset by DRM) to 0 */
 	vma->vm_pgoff = 0;
-	vma->vm_page_prot = pgprot_noncached(vm_get_page_prot(vma->vm_flags));
+	vma->vm_page_prot = pgprot_noncached(vma_get_page_prot(vma));
 	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP |
 		     VM_DONTCOPY | VM_NORESERVE);
 
--- a/drivers/video/fbdev/core/fb_io_fops.c~mm-introduce-vma_get_page_prot-and-use-it
+++ a/drivers/video/fbdev/core/fb_io_fops.c
@@ -161,7 +161,7 @@ int fb_io_mmap(struct fb_info *info, str
 		len = info->fix.mmio_len;
 	}
 
-	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+	vma->vm_page_prot = vma_get_page_prot(vma);
 	vma->vm_page_prot = pgprot_framebuffer(vma->vm_page_prot, vma->vm_start,
 					       vma->vm_end, start);
 
--- a/include/linux/mm.h~mm-introduce-vma_get_page_prot-and-use-it
+++ a/include/linux/mm.h
@@ -4610,6 +4610,11 @@ static inline pgprot_t vma_flags_to_page
 	return vm_get_page_prot(vm_flags);
 }
 
+static inline pgprot_t vma_get_page_prot(const struct vm_area_struct *vma)
+{
+	return vma_flags_to_page_prot(vma->flags);
+}
+
 void vma_set_page_prot(struct vm_area_struct *vma);
 #else
 static inline pgprot_t vm_get_page_prot(vm_flags_t vm_flags)
@@ -4620,9 +4625,13 @@ static inline pgprot_t vma_flags_to_page
 {
 	return __pgprot(0);
 }
+static inline pgprot_t vma_get_page_prot(const struct vm_area_struct *vma)
+{
+	return __pgprot(0);
+}
 static inline void vma_set_page_prot(struct vm_area_struct *vma)
 {
-	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+	vma->vm_page_prot = vma_get_page_prot(vma);
 }
 #endif
 
--- a/mm/vma.c~mm-introduce-vma_get_page_prot-and-use-it
+++ a/mm/vma.c
@@ -3430,7 +3430,7 @@ struct vm_area_struct *__install_special
 	if (pgtable_supports_soft_dirty())
 		vm_flags |= VM_SOFTDIRTY;
 	vm_flags_init(vma, vm_flags & ~VM_LOCKED_MASK);
-	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+	vma->vm_page_prot = vma_get_page_prot(vma);
 
 	vma->vm_ops = ops;
 	vma->vm_private_data = priv;
--- a/mm/vma_exec.c~mm-introduce-vma_get_page_prot-and-use-it
+++ a/mm/vma_exec.c
@@ -146,7 +146,7 @@ int create_init_stack_vma(struct mm_stru
 	if (pgtable_supports_soft_dirty())
 		flags |= VM_SOFTDIRTY;
 	vm_flags_init(vma, flags);
-	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+	vma->vm_page_prot = vma_get_page_prot(vma);
 
 	err = insert_vm_struct(mm, vma);
 	if (err)
--- a/sound/core/memalloc.c~mm-introduce-vma_get_page_prot-and-use-it
+++ a/sound/core/memalloc.c
@@ -851,7 +851,7 @@ static void snd_dma_noncoherent_free(str
 static int snd_dma_noncoherent_mmap(struct snd_dma_buffer *dmab,
 				    struct vm_area_struct *area)
 {
-	area->vm_page_prot = vm_get_page_prot(area->vm_flags);
+	area->vm_page_prot = vma_get_page_prot(area);
 	return dma_mmap_pages(dmab->dev.dev, area,
 			      area->vm_end - area->vm_start,
 			      virt_to_page(dmab->area));
--- a/tools/testing/vma/include/dup.h~mm-introduce-vma_get_page_prot-and-use-it
+++ a/tools/testing/vma/include/dup.h
@@ -1573,3 +1573,8 @@ static inline void vma_assert_can_modify
 	if (vma_is_attached(vma))
 		vma_assert_write_locked(vma);
 }
+
+static inline pgprot_t vma_get_page_prot(const struct vm_area_struct *vma)
+{
+	return vma_flags_to_page_prot(vma->flags);
+}
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf.patch
x86-mm-pat-acquire-mmap-lock-on-page-table-free-to-avoid-ptdump-uaf.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
arm64-remove-redundant-concurrent-ptdump-uaf-mitigation.patch
mm-move-alloc-tag-to-mm.patch
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

