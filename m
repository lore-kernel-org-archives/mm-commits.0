From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 19 Aug 2015 11:44:34 -0700
Message-ID: <55d4ce92.Vax6ln3OYi0GJZZU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36007 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbbHSSof (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Aug 2015 14:44:35 -0400
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

 drivers/gpu/drm/i915/intel_atomic.c  |  130 -------------------------
 drivers/gpu/drm/i915/intel_display.c |  113 ---------------------
 drivers/scsi/scsi_error.c            |   31 -----
 include/scsi/scsi_eh.h               |    5 
 4 files changed, 279 deletions(-)

diff -puN drivers/gpu/drm/i915/intel_atomic.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_atomic.c
--- a/drivers/gpu/drm/i915/intel_atomic.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_atomic.c
@@ -35,136 +35,6 @@
 #include <drm/drm_plane_helper.h>
 #include "intel_drv.h"
 
-<<<<<<< HEAD
-
-/**
- * intel_atomic_check - validate state object
- * @dev: drm device
- * @state: state to validate
- */
-int intel_atomic_check(struct drm_device *dev,
-		       struct drm_atomic_state *state)
-{
-	int nplanes = dev->mode_config.num_total_plane;
-	int ncrtcs = dev->mode_config.num_crtc;
-	int nconnectors = dev->mode_config.num_connector;
-	enum pipe nuclear_pipe = INVALID_PIPE;
-	struct intel_crtc *nuclear_crtc = NULL;
-	struct intel_crtc_state *crtc_state = NULL;
-	int ret;
-	int i;
-	bool not_nuclear = false;
-
-	/*
-	 * FIXME:  At the moment, we only support "nuclear pageflip" on a
-	 * single CRTC.  Cross-crtc updates will be added later.
-	 */
-	for (i = 0; i < nplanes; i++) {
-		struct intel_plane *plane = to_intel_plane(state->planes[i]);
-		if (!plane)
-			continue;
-
-		if (nuclear_pipe == INVALID_PIPE) {
-			nuclear_pipe = plane->pipe;
-		} else if (nuclear_pipe != plane->pipe) {
-			DRM_DEBUG_KMS("i915 only support atomic plane operations on a single CRTC at the moment\n");
-			return -EINVAL;
-		}
-	}
-
-	/*
-	 * FIXME:  We only handle planes for now; make sure there are no CRTC's
-	 * or connectors involved.
-	 */
-	state->allow_modeset = false;
-	for (i = 0; i < ncrtcs; i++) {
-		struct intel_crtc *crtc = to_intel_crtc(state->crtcs[i]);
-		if (crtc)
-			memset(&crtc->atomic, 0, sizeof(crtc->atomic));
-		if (crtc && crtc->pipe != nuclear_pipe)
-			not_nuclear = true;
-		if (crtc && crtc->pipe == nuclear_pipe) {
-			nuclear_crtc = crtc;
-			crtc_state = to_intel_crtc_state(state->crtc_states[i]);
-		}
-	}
-	for (i = 0; i < nconnectors; i++)
-		if (state->connectors[i] != NULL)
-			not_nuclear = true;
-
-	if (not_nuclear) {
-		DRM_DEBUG_KMS("i915 only supports atomic plane operations at the moment\n");
-		return -EINVAL;
-	}
-
-	ret = drm_atomic_helper_check_planes(dev, state);
-	if (ret)
-		return ret;
-
-	/* FIXME: move to crtc atomic check function once it is ready */
-	ret = intel_atomic_setup_scalers(dev, nuclear_crtc, crtc_state);
-	if (ret)
-		return ret;
-
-	return ret;
-}
-
-
-/**
- * intel_atomic_commit - commit validated state object
- * @dev: DRM device
- * @state: the top-level driver state object
- * @async: asynchronous commit
- *
- * This function commits a top-level state object that has been validated
- * with drm_atomic_helper_check().
- *
- * FIXME:  Atomic modeset support for i915 is not yet complete.  At the moment
- * we can only handle plane-related operations and do not yet support
- * asynchronous commit.
- *
- * RETURNS
- * Zero for success or -errno.
- */
-int intel_atomic_commit(struct drm_device *dev,
-			struct drm_atomic_state *state,
-			bool async)
-{
-	struct drm_crtc_state *crtc_state;
-	struct drm_crtc *crtc;
-	int ret, i;
-
-	if (async) {
-		DRM_DEBUG_KMS("i915 does not yet support async commit\n");
-		return -EINVAL;
-	}
-
-	ret = drm_atomic_helper_prepare_planes(dev, state);
-	if (ret)
-		return ret;
-
-	/* Point of no return */
-	drm_atomic_helper_swap_state(dev, state);
-
-	/* swap crtc_scaler_state */
-	for_each_crtc_in_state(state, crtc, crtc_state, i) {
-		to_intel_crtc(crtc)->config = to_intel_crtc_state(crtc->state);
-
-		if (INTEL_INFO(dev)->gen >= 9)
-			skl_detach_scalers(to_intel_crtc(crtc));
-
-		drm_atomic_helper_commit_planes_on_crtc(crtc_state);
-	}
-
-	drm_atomic_helper_wait_for_vblanks(dev, state);
-	drm_atomic_helper_cleanup_planes(dev, state);
-	drm_atomic_state_free(state);
-
-	return 0;
-}
-
-=======
->>>>>>> linux-next/akpm-base
 /**
  * intel_connector_atomic_get_property - fetch connector property value
  * @connector: connector to fetch property for
diff -puN drivers/gpu/drm/i915/intel_display.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_display.c
--- a/drivers/gpu/drm/i915/intel_display.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_display.c
@@ -12883,17 +12883,10 @@ static int haswell_mode_set_planes_worka
 		if (IS_ERR(pipe_config))
 			return PTR_ERR(pipe_config);
 
-<<<<<<< HEAD
-	/* Now enable the clocks, plane, pipe, and connectors that we set up. */
-	for_each_crtc_in_state(state, crtc, crtc_state, i) {
-		if (!needs_modeset(crtc->state) || !crtc->state->enable) {
-			drm_atomic_helper_commit_planes_on_crtc(crtc_state);
-=======
 		pipe_config->hsw_workaround_pipe = INVALID_PIPE;
 
 		if (!pipe_config->base.active ||
 		    needs_modeset(&pipe_config->base))
->>>>>>> linux-next/akpm-base
 			continue;
 		}
 
@@ -12901,12 +12894,7 @@ static int haswell_mode_set_planes_worka
 		if (enabled_pipe != INVALID_PIPE)
 			return 0;
 
-<<<<<<< HEAD
-		dev_priv->display.crtc_enable(crtc);
-		drm_atomic_helper_commit_planes_on_crtc(crtc_state);
-=======
 		enabled_pipe = intel_crtc->pipe;
->>>>>>> linux-next/akpm-base
 	}
 
 	if (enabled_pipe != INVALID_PIPE)
@@ -13111,14 +13099,6 @@ static int intel_atomic_commit(struct dr
 		any_ms = true;
 		intel_pre_plane_update(intel_crtc);
 
-<<<<<<< HEAD
-static int intel_crtc_set_config(struct drm_mode_set *set)
-{
-	struct drm_device *dev;
-	struct drm_atomic_state *state = NULL;
-	struct intel_crtc_state *pipe_config;
-	int ret;
-=======
 		if (crtc_state->active) {
 			intel_crtc_disable_planes(crtc, crtc_state->plane_mask);
 			dev_priv->display.crtc_disable(crtc);
@@ -13133,7 +13113,6 @@ static int intel_crtc_set_config(struct
 
 	if (any_ms) {
 		intel_shared_dpll_commit(state);
->>>>>>> linux-next/akpm-base
 
 		drm_atomic_helper_update_legacy_modeset_state(state->dev, state);
 		modeset_update_crtc_power_domains(state);
@@ -13166,13 +13145,6 @@ static int intel_crtc_set_config(struct
 
 	drm_atomic_state_free(state);
 
-<<<<<<< HEAD
-	ret = intel_set_mode_with_config(set->crtc, pipe_config, true);
-
-	if (ret) {
-		DRM_DEBUG_KMS("failed to set mode on [CRTC:%d], err = %d\n",
-			      set->crtc->base.id, ret);
-=======
 	return 0;
 }
 
@@ -13207,7 +13179,6 @@ retry:
 		drm_atomic_state_clear(state);
 		drm_modeset_backoff(state->acquire_ctx);
 		goto retry;
->>>>>>> linux-next/akpm-base
 	}
 
 	if (ret)
@@ -13449,90 +13420,11 @@ intel_check_primary_plane(struct drm_pla
 		can_position = true;
 	}
 
-<<<<<<< HEAD
-	ret = drm_plane_helper_check_update(plane, crtc, fb,
-					    src, dest, clip,
-					    min_scale,
-					    max_scale,
-					    can_position, true,
-					    &state->visible);
-	if (ret)
-		return ret;
-
-	if (crtc_state ? crtc_state->base.active : intel_crtc->active) {
-		struct intel_plane_state *old_state =
-			to_intel_plane_state(plane->state);
-
-		intel_crtc->atomic.wait_for_flips = true;
-
-		/*
-		 * FBC does not work on some platforms for rotated
-		 * planes, so disable it when rotation is not 0 and
-		 * update it when rotation is set back to 0.
-		 *
-		 * FIXME: This is redundant with the fbc update done in
-		 * the primary plane enable function except that that
-		 * one is done too late. We eventually need to unify
-		 * this.
-		 */
-		if (state->visible &&
-		    INTEL_INFO(dev)->gen <= 4 && !IS_G4X(dev) &&
-		    dev_priv->fbc.crtc == intel_crtc &&
-		    state->base.rotation != BIT(DRM_ROTATE_0)) {
-			intel_crtc->atomic.disable_fbc = true;
-		}
-
-		if (state->visible && !old_state->visible) {
-			/*
-			 * BDW signals flip done immediately if the plane
-			 * is disabled, even if the plane enable is already
-			 * armed to occur at the next vblank :(
-			 */
-			if (IS_BROADWELL(dev))
-				intel_crtc->atomic.wait_vblank = true;
-
-			if (crtc_state)
-				intel_crtc->atomic.post_enable_primary = true;
-		}
-
-		/*
-		 * FIXME: Actually if we will still have any other plane enabled
-		 * on the pipe we could let IPS enabled still, but for
-		 * now lets consider that when we make primary invisible
-		 * by setting DSPCNTR to 0 on update_primary_plane function
-		 * IPS needs to be disable.
-		 */
-		if (!state->visible || !fb)
-			intel_crtc->atomic.disable_ips = true;
-
-		if (!state->visible && old_state->visible &&
-		    crtc_state && !needs_modeset(&crtc_state->base))
-			intel_crtc->atomic.pre_disable_primary = true;
-
-		intel_crtc->atomic.fb_bits |=
-			INTEL_FRONTBUFFER_PRIMARY(intel_crtc->pipe);
-
-		intel_crtc->atomic.update_fbc = true;
-
-		if (intel_wm_need_update(plane, &state->base))
-			intel_crtc->atomic.update_wm = true;
-	}
-
-	if (INTEL_INFO(dev)->gen >= 9) {
-		ret = skl_update_scaler_users(intel_crtc, crtc_state,
-			to_intel_plane(plane), state, 0);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-=======
 	return drm_plane_helper_check_update(plane, crtc, fb, &state->src,
 					     &state->dst, &state->clip,
 					     min_scale, max_scale,
 					     can_position, true,
 					     &state->visible);
->>>>>>> linux-next/akpm-base
 }
 
 static void
@@ -15192,11 +15084,6 @@ static void intel_modeset_readout_hw_sta
 		__drm_atomic_helper_crtc_destroy_state(&crtc->base, crtc->base.state);
 		memset(crtc->config, 0, sizeof(*crtc->config));
 		crtc->config->base.crtc = &crtc->base;
-<<<<<<< HEAD
-
-		crtc->config->quirks |= PIPE_CONFIG_QUIRK_INHERITED_MODE;
-=======
->>>>>>> linux-next/akpm-base
 
 		crtc->active = dev_priv->display.get_pipe_config(crtc,
 								 crtc->config);
diff -puN drivers/scsi/scsi_error.c~linux-next-git-rejects drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c~linux-next-git-rejects
+++ a/drivers/scsi/scsi_error.c
@@ -2456,34 +2456,3 @@ int scsi_get_sense_info_fld(const u8 * s
 	}
 }
 EXPORT_SYMBOL(scsi_get_sense_info_fld);
-<<<<<<< HEAD
-
-/**
- * scsi_build_sense_buffer - build sense data in a buffer
- * @desc:	Sense format (non zero == descriptor format,
- * 		0 == fixed format)
- * @buf:	Where to build sense data
- * @key:	Sense key
- * @asc:	Additional sense code
- * @ascq:	Additional sense code qualifier
- *
- **/
-void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq)
-{
-	if (desc) {
-		buf[0] = 0x72;	/* descriptor, current */
-		buf[1] = key;
-		buf[2] = asc;
-		buf[3] = ascq;
-		buf[7] = 0;
-	} else {
-		buf[0] = 0x70;	/* fixed, current */
-		buf[2] = key;
-		buf[7] = 0xa;
-		buf[12] = asc;
-		buf[13] = ascq;
-	}
-}
-EXPORT_SYMBOL(scsi_build_sense_buffer);
-=======
->>>>>>> linux-next/akpm-base
diff -puN include/scsi/scsi_eh.h~linux-next-git-rejects include/scsi/scsi_eh.h
--- a/include/scsi/scsi_eh.h~linux-next-git-rejects
+++ a/include/scsi/scsi_eh.h
@@ -25,11 +25,6 @@ static inline bool scsi_sense_is_deferre
 extern int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
 				   u64 * info_out);
 
-<<<<<<< HEAD
-extern void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq);
-
-=======
->>>>>>> linux-next/akpm-base
 extern int scsi_ioctl_reset(struct scsi_device *, int __user *);
 
 struct scsi_eh_save {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
mm-make-page-pfmemalloc-check-more-robust-fix.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
ocfs2-sysfile-interfaces-for-online-file-check-fix.patch
fs-create-and-use-seq_show_option-for-escaping-fix.patch
watchdog-introduce-watchdog_suspend-and-watchdog_resume-fix.patch
watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix.patch
mm.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
genalloc-add-support-of-multiple-gen_pools-per-device-fix.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
dax-revert-userfaultfd-change.patch
thp-prepare-for-dax-huge-pages-fix.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.patch
pagemap-update-documentation-fix.patch
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch
mm-srcu-ify-shrinkers-fix-fix.patch
x86-use-generic-early-mem-copy-fix.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-fix-2.patch
mm-mmap-simplify-the-failure-return-working-flow-fix.patch
zswap-dynamic-pool-creation-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
proc-add-kpageidle-file-fix-6-fix.patch
proc-add-kpageidle-file-fix-6-fix-2-fix.patch
proc-export-idle-flag-via-kpageflags-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix-fix.patch
kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch
align-crash_notes-allocation-to-make-it-be-inside-one-physical-page-fix.patch
linux-next.patch
linux-next-rejects.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

