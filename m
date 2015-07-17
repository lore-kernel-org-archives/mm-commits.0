From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 17 Jul 2015 13:58:54 -0700
Message-ID: <55a96c8e.ywChBeBFEVgkIirR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39325 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbbGQU6y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jul 2015 16:58:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_drv.h         |    3 
 drivers/gpu/drm/i915/intel_display.c    |  113 ----------------------
 drivers/gpu/drm/i915/intel_ringbuffer.h |    9 -
 3 files changed, 1 insertion(+), 124 deletions(-)

diff -puN drivers/gpu/drm/i915/i915_drv.h~linux-next-git-rejects drivers/gpu/drm/i915/i915_drv.h
--- a/drivers/gpu/drm/i915/i915_drv.h~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/i915_drv.h
@@ -867,10 +867,7 @@ struct intel_context {
 	int user_handle;
 	uint8_t remap_slice;
 	struct drm_i915_private *i915;
-<<<<<<< HEAD
-=======
 	int flags;
->>>>>>> linux-next/akpm-base
 	struct drm_i915_file_private *file_priv;
 	struct i915_ctx_hang_stats hang_stats;
 	struct i915_hw_ppgtt *ppgtt;
diff -puN drivers/gpu/drm/i915/intel_display.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_display.c
--- a/drivers/gpu/drm/i915/intel_display.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_display.c
@@ -1053,7 +1053,7 @@ static void intel_wait_for_pipe_off(stru
 		/* Wait for the Pipe State to go off */
 		if (wait_for((I915_READ(reg) & I965_PIPECONF_ACTIVE) == 0,
 			     100))
-			WARN(1, "pipe_off wait timed out\n");
+			WARN(1, "pipe_qoff wait timed out\n");
 	} else {
 		/* Wait for the display line to settle */
 		if (wait_for(pipe_dsl_stopped(dev, pipe), 100))
@@ -6330,36 +6330,6 @@ void intel_crtc_update_dpms(struct drm_c
 		enable |= intel_encoder->connectors_active;
 
 	intel_crtc_control(crtc, enable);
-<<<<<<< HEAD
-
-	crtc->state->active = enable;
-}
-
-static void intel_crtc_disable(struct drm_crtc *crtc)
-{
-	struct drm_device *dev = crtc->dev;
-	struct drm_connector *connector;
-	struct drm_i915_private *dev_priv = dev->dev_private;
-
-	intel_crtc_disable_planes(crtc);
-	dev_priv->display.crtc_disable(crtc);
-	dev_priv->display.off(crtc);
-
-	drm_plane_helper_disable(crtc->primary);
-
-	/* Update computed state. */
-	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
-		if (!connector->encoder || !connector->encoder->crtc)
-			continue;
-
-		if (connector->encoder->crtc != crtc)
-			continue;
-
-		connector->dpms = DRM_MODE_DPMS_OFF;
-		to_intel_encoder(connector->encoder)->connectors_active = false;
-	}
-=======
->>>>>>> linux-next/akpm-base
 }
 
 void intel_encoder_destroy(struct drm_encoder *encoder)
@@ -13059,21 +13029,12 @@ static int haswell_mode_set_planes_worka
 		if (!crtc_state->active || !needs_modeset(crtc_state))
 			continue;
 
-<<<<<<< HEAD
-		if (!crtc_state->enable) {
-			if (crtc->state->enable)
-				intel_crtc_disable(crtc);
-		} else if (crtc->state->enable) {
-			intel_crtc_disable_planes(crtc);
-			dev_priv->display.crtc_disable(crtc);
-=======
 		if (first_crtc_state) {
 			other_crtc_state = to_intel_crtc_state(crtc_state);
 			break;
 		} else {
 			first_crtc_state = to_intel_crtc_state(crtc_state);
 			first_pipe = intel_crtc->pipe;
->>>>>>> linux-next/akpm-base
 		}
 	}
 
@@ -13622,83 +13583,11 @@ intel_check_primary_plane(struct drm_pla
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
diff -puN drivers/gpu/drm/i915/intel_ringbuffer.h~linux-next-git-rejects drivers/gpu/drm/i915/intel_ringbuffer.h
--- a/drivers/gpu/drm/i915/intel_ringbuffer.h~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_ringbuffer.h
@@ -297,15 +297,6 @@ struct  intel_engine_cs {
 	 * Used exclusively by hang checker to avoid grabbing lock while
 	 * inspecting request list.
 	 */
-<<<<<<< HEAD
-	struct drm_i915_gem_request *outstanding_lazy_request;
-	/**
-	 * Seqno of request most recently submitted to request_list.
-	 * Used exclusively by hang checker to avoid grabbing lock while
-	 * inspecting request list.
-	 */
-=======
->>>>>>> linux-next/akpm-base
 	u32 last_submitted_seqno;
 
 	bool gpu_caches_dirty;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
openrisc-fix-config_uid16-setting.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
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
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
define-kallsyms_cmp_symbol_t-as-function-type-to-simplify-the-code-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

