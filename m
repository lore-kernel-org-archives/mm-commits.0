From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 06 Feb 2017 13:24:16 -0800
Message-ID: <5898e980.9KSTEPtcZFxCAHf3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57736 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751810AbdBFVYR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2017 16:24:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig                 |    3 ---
 arch/x86/kernel/cpu/microcode/amd.c  |   20 --------------------
 arch/x86/kernel/fpu/core.c           |    6 ------
 drivers/gpu/drm/i915/i915_drv.h      |   18 ------------------
 drivers/gpu/drm/i915/intel_display.c |    8 --------
 drivers/gpu/drm/i915/intel_fbc.c     |    4 ----
 drivers/gpu/drm/i915/intel_sprite.c  |   15 ---------------
 include/drm/drm_connector.h          |   19 -------------------
 8 files changed, 93 deletions(-)

diff -puN arch/powerpc/Kconfig~linux-next-git-rejects arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~linux-next-git-rejects
+++ a/arch/powerpc/Kconfig
@@ -164,11 +164,8 @@ config PPC
 	select ARCH_HAS_SCALED_CPUTIME if VIRT_CPU_ACCOUNTING_NATIVE
 	select HAVE_ARCH_HARDENED_USERCOPY
 	select HAVE_KERNEL_GZIP
-<<<<<<< HEAD
-=======
 	select HAVE_CONTEXT_TRACKING if PPC64
 	select ARCH_WEAK_RELEASE_ACQUIRE
->>>>>>> linux-next/akpm-base
 
 config GENERIC_CSUM
 	def_bool n
diff -puN arch/x86/kernel/cpu/microcode/amd.c~linux-next-git-rejects arch/x86/kernel/cpu/microcode/amd.c
--- a/arch/x86/kernel/cpu/microcode/amd.c~linux-next-git-rejects
+++ a/arch/x86/kernel/cpu/microcode/amd.c
@@ -302,27 +302,7 @@ void load_ucode_amd_ap(unsigned int cpui
 		new_rev = &ucode_new_rev;
 	}
 
-<<<<<<< HEAD
-reget:
-		if (!get_builtin_microcode(&cp, family)) {
-#ifdef CONFIG_BLK_DEV_INITRD
-			if (!initrd_gone)
-				cp = find_cpio_data(ucode_path, (void *)initrd_start,
-						    initrd_end - initrd_start, NULL);
-#endif
-			if (!(cp.data && cp.size)) {
-				/*
-				 * Mark it so that other APs do not scan again
-				 * for no real reason and slow down boot
-				 * needlessly.
-				 */
-				cont.size = -1;
-				return;
-			}
-		}
-=======
 	native_rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
->>>>>>> linux-next/akpm-base
 
 	/* Check whether we have saved a new patch already: */
 	if (*new_rev && rev < mc->hdr.patch_id) {
diff -puN arch/x86/kernel/fpu/core.c~linux-next-git-rejects arch/x86/kernel/fpu/core.c
--- a/arch/x86/kernel/fpu/core.c~linux-next-git-rejects
+++ a/arch/x86/kernel/fpu/core.c
@@ -180,13 +180,7 @@ void fpstate_init(union fpregs_state *st
 	memset(state, 0, fpu_kernel_xstate_size);
 
 	if (static_cpu_has(X86_FEATURE_XSAVES))
-<<<<<<< HEAD
-		state->xsave.header.xcomp_bv = XCOMP_BV_COMPACTED_FORMAT |
-					       xfeatures_mask;
-
-=======
 		fpstate_init_xstate(&state->xsave);
->>>>>>> linux-next/akpm-base
 	if (static_cpu_has(X86_FEATURE_FXSR))
 		fpstate_init_fxstate(&state->fxsave);
 	else
diff -puN drivers/gpu/drm/i915/i915_drv.h~linux-next-git-rejects drivers/gpu/drm/i915/i915_drv.h
--- a/drivers/gpu/drm/i915/i915_drv.h~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/i915_drv.h
@@ -1085,11 +1085,7 @@ struct intel_fbc {
 		} plane;
 
 		struct {
-<<<<<<< HEAD
-			uint32_t pixel_format;
-=======
 			const struct drm_format_info *format;
->>>>>>> linux-next/akpm-base
 			unsigned int stride;
 		} fb;
 	} state_cache;
@@ -1104,11 +1100,7 @@ struct intel_fbc {
 		} crtc;
 
 		struct {
-<<<<<<< HEAD
-			uint32_t pixel_format;
-=======
 			const struct drm_format_info *format;
->>>>>>> linux-next/akpm-base
 			unsigned int stride;
 		} fb;
 
@@ -3400,16 +3392,6 @@ i915_vm_to_ppgtt(struct i915_address_spa
 	return container_of(vm, struct i915_hw_ppgtt, base);
 }
 
-<<<<<<< HEAD
-static inline struct i915_vma *
-i915_gem_object_to_ggtt(struct drm_i915_gem_object *obj,
-			const struct i915_ggtt_view *view)
-{
-	return i915_gem_obj_to_vma(obj, &to_i915(obj->base.dev)->ggtt.base, view);
-}
-
-=======
->>>>>>> linux-next/akpm-base
 /* i915_gem_fence_reg.c */
 int __must_check i915_vma_get_fence(struct i915_vma *vma);
 int __must_check i915_vma_put_fence(struct i915_vma *vma);
diff -puN drivers/gpu/drm/i915/intel_display.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_display.c
--- a/drivers/gpu/drm/i915/intel_display.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_display.c
@@ -2242,11 +2242,7 @@ err:
 
 void intel_unpin_fb_vma(struct i915_vma *vma)
 {
-<<<<<<< HEAD
-	lockdep_assert_held(&vma->vm->dev->struct_mutex);
-=======
 	lockdep_assert_held(&vma->vm->i915->drm.struct_mutex);
->>>>>>> linux-next/akpm-base
 
 	if (WARN_ON_ONCE(!vma))
 		return;
@@ -3433,11 +3429,7 @@ static void skylake_update_primary_plane
 		I915_WRITE(PLANE_POS(pipe, plane_id), (dst_y << 16) | dst_x);
 	}
 
-<<<<<<< HEAD
-	I915_WRITE(PLANE_SURF(pipe, 0),
-=======
 	I915_WRITE(PLANE_SURF(pipe, plane_id),
->>>>>>> linux-next/akpm-base
 		   intel_plane_ggtt_offset(plane_state) + surf_addr);
 
 	POSTING_READ(PLANE_SURF(pipe, plane_id));
diff -puN drivers/gpu/drm/i915/intel_fbc.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_fbc.c
--- a/drivers/gpu/drm/i915/intel_fbc.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_fbc.c
@@ -754,11 +754,7 @@ static void intel_fbc_update_state_cache
 	if (!cache->plane.visible)
 		return;
 
-<<<<<<< HEAD
-	cache->fb.pixel_format = fb->pixel_format;
-=======
 	cache->fb.format = fb->format;
->>>>>>> linux-next/akpm-base
 	cache->fb.stride = fb->pitches[0];
 
 	cache->vma = plane_state->vma;
diff -puN drivers/gpu/drm/i915/intel_sprite.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_sprite.c
--- a/drivers/gpu/drm/i915/intel_sprite.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_sprite.c
@@ -271,17 +271,10 @@ skl_update_plane(struct drm_plane *drm_p
 		I915_WRITE(PLANE_POS(pipe, plane_id), (crtc_y << 16) | crtc_x);
 	}
 
-<<<<<<< HEAD
-	I915_WRITE(PLANE_CTL(pipe, plane), plane_ctl);
-	I915_WRITE(PLANE_SURF(pipe, plane),
-		   intel_plane_ggtt_offset(plane_state) + surf_addr);
-	POSTING_READ(PLANE_SURF(pipe, plane));
-=======
 	I915_WRITE(PLANE_CTL(pipe, plane_id), plane_ctl);
 	I915_WRITE(PLANE_SURF(pipe, plane_id),
 		   intel_plane_ggtt_offset(plane_state) + surf_addr);
 	POSTING_READ(PLANE_SURF(pipe, plane_id));
->>>>>>> linux-next/akpm-base
 }
 
 static void
@@ -462,19 +455,11 @@ vlv_update_plane(struct drm_plane *dplan
 
 	I915_WRITE(SPCONSTALPHA(pipe, plane_id), 0);
 
-<<<<<<< HEAD
-	I915_WRITE(SPSIZE(pipe, plane), (crtc_h << 16) | crtc_w);
-	I915_WRITE(SPCNTR(pipe, plane), sprctl);
-	I915_WRITE(SPSURF(pipe, plane),
-		   intel_plane_ggtt_offset(plane_state) + sprsurf_offset);
-	POSTING_READ(SPSURF(pipe, plane));
-=======
 	I915_WRITE(SPSIZE(pipe, plane_id), (crtc_h << 16) | crtc_w);
 	I915_WRITE(SPCNTR(pipe, plane_id), sprctl);
 	I915_WRITE(SPSURF(pipe, plane_id),
 		   intel_plane_ggtt_offset(plane_state) + sprsurf_offset);
 	POSTING_READ(SPSURF(pipe, plane_id));
->>>>>>> linux-next/akpm-base
 }
 
 static void
diff -puN include/drm/drm_connector.h~linux-next-git-rejects include/drm/drm_connector.h
--- a/include/drm/drm_connector.h~linux-next-git-rejects
+++ a/include/drm/drm_connector.h
@@ -381,11 +381,7 @@ struct drm_connector_funcs {
 	 * core drm connector interfaces. Everything added from this callback
 	 * should be unregistered in the early_unregister callback.
 	 *
-<<<<<<< HEAD
-	 * This is called while holding drm_connector->mutex.
-=======
 	 * This is called while holding &drm_connector.mutex.
->>>>>>> linux-next/akpm-base
 	 *
 	 * Returns:
 	 *
@@ -402,11 +398,7 @@ struct drm_connector_funcs {
 	 * early in the driver unload sequence to disable userspace access
 	 * before data structures are torndown.
 	 *
-<<<<<<< HEAD
-	 * This is called while holding drm_connector->mutex.
-=======
 	 * This is called while holding &drm_connector.mutex.
->>>>>>> linux-next/akpm-base
 	 */
 	void (*early_unregister)(struct drm_connector *connector);
 
@@ -571,12 +563,6 @@ struct drm_cmdline_mode {
  * @interlace_allowed: can this connector handle interlaced modes?
  * @doublescan_allowed: can this connector handle doublescan?
  * @stereo_allowed: can this connector handle stereo modes?
-<<<<<<< HEAD
- * @modes: modes available on this connector (from fill_modes() + user)
- * @status: one of the drm_connector_status enums (connected, not, or unknown)
- * @probed_modes: list of modes derived directly from the display
-=======
->>>>>>> linux-next/akpm-base
  * @funcs: connector control functions
  * @edid_blob_ptr: DRM property containing EDID if present
  * @properties: property tracking for this connector
@@ -623,13 +609,8 @@ struct drm_connector {
 
 	/**
 	 * @mutex: Lock for general connector state, but currently only protects
-<<<<<<< HEAD
-	 * @registered. Most of the connector state is still protected by the
-	 * mutex in &drm_mode_config.
-=======
 	 * @registered. Most of the connector state is still protected by
 	 * &drm_mode_config.mutex.
->>>>>>> linux-next/akpm-base
 	 */
 	struct mutex mutex;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix-fix.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes.patch
mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix.patch
mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix.patch
mm-track-active-portions-of-a-section-at-boot-fix.patch
mm-memory_hotplugc-unexport-__remove_pages.patch
z3fold-add-kref-refcounting-checkpatch-fixes.patch
mm-convert-remove_migration_pte-to-use-page_vma_mapped_walk-checkpatch-fixes.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

