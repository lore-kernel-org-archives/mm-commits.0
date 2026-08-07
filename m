Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84CB27144B
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068058; cv=none; b=tHY28scbwP4f5jtCq5xyeayCQ9VneSBTW8p1fNB8qO2xVBtT0WyudUtwsjPEJrdYVCIAqNJtHFabUBqdGax7Y0v+qH4fPpd8NKDrktPleq/zB/EK0ZRQh/ciiYYmpjT42vVSW7urufW2zrCetGMqo5RxFU6C68jk9hCvA8960oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068058; c=relaxed/simple;
	bh=EFhY8Eg2GJjQqrk2V9xCu85t3L8LEgCVrSG39J4JySQ=;
	h=Date:To:From:Subject:Message-Id; b=QGmPs/qGrnCLP48V5BvokQcYRYLIXtnMYEg2AKUISw3Bj2JQpVrRCQLUWpaZ9g8IUEawIROGfJMGRjO4DlQ+kw404v7Nv4wHIKuPYwwuYbGxbybs3RJ4Aqk3kOSpz7pLspzOOmKPmR9MAeXHPZylcHPLUjt40zZilwfEx9edojg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MGvVlL/C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MGvVlL/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2751A1F00AC4;
	Fri,  7 Aug 2026 02:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068052;
	bh=2WOj3MTfsQAcN2xmSyQbS54A995lnQCa7scnhFkB0WQ=;
	h=Date:To:From:Subject;
	b=MGvVlL/CJN7yxNDR+6hQ26mU3FiCQnEJ0eS5Cj1zkMusjssQmODw/5Zf+NKVDSt69
	 rczEy4KvIyaCYPf2+ermnFYDkHZMMOJC2SPLYH3JSMLYTPnAdvDokFukmyxbFbPvfs
	 ehyss1c/9anIO7+J4S+RK3NSVndgChyhsgIGGHmU=
Date: Thu, 06 Aug 2026 19:00:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tzimmermann@suse.de,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,osalvador@suse.de,npache@redhat.com,muchun.song@linux.dev,lance.yang@linux.dev,jannh@google.com,jani.nikula@intel.com,jack@suse.cz,dev.jain@arm.com,david@kernel.org,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,airlied@gmail.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-vma_get_page_prot-and-use-it.patch removed from -mm tree
Message-Id: <20260807020052.2751A1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce vma_get_page_prot() and use it
has been removed from the -mm tree.  Its filename was
     mm-introduce-vma_get_page_prot-and-use-it.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>	[DRM]
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
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
@@ -1575,3 +1575,8 @@ static inline void vma_assert_can_modify
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

x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch
mm-vma-introduce-vma-anon-page-offset-field-and-add-helpers.patch
mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping.patch
mm-introduce-linear_anon_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-anon-index-if-appropriate.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-vma-fix-self-merge-check-in-copy_vma.patch
tools-testing-vma-add-tests-for-copy_vma-self-merge.patch
mm-propagate-vma-anonymous-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-pgoff-is-anonymous.patch
mm-clean-up-vma_address_end.patch
mm-huge_memory-update-remove_migration_pmd-to-accept-a-folio.patch
mm-migrate-calculate-large-folio-page-index-using-pfn.patch
mm-rmap-use-anon-pgoff-to-track-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-anon-pgoff.patch
tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-add-some-missing-includes-to-mm-local-headers.patch

