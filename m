From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Mon, 31 Jul 2017 12:18:25 -0700
Message-ID: <20170731191825.Y2pNCTatv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41782 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751775AbdGaTS0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jul 2017 15:18:26 -0400
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

 drivers/gpu/drm/i915/intel_display.c   |   33 -----------------------
 drivers/gpu/drm/i915/intel_pm.c        |    5 ---
 drivers/gpu/drm/nouveau/nv50_display.c |    5 ---
 3 files changed, 43 deletions(-)

diff -puN drivers/gpu/drm/i915/intel_display.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_display.c
--- a/drivers/gpu/drm/i915/intel_display.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_display.c
@@ -3400,17 +3400,6 @@ static void skylake_disable_primary_plan
 	spin_unlock_irqrestore(&dev_priv->uncore.lock, irqflags);
 }
 
-<<<<<<< HEAD
-static void intel_complete_page_flips(struct drm_i915_private *dev_priv)
-{
-	struct intel_crtc *crtc;
-
-	for_each_intel_crtc(&dev_priv->drm, crtc)
-		intel_finish_page_flip_cs(dev_priv, crtc->pipe);
-}
-
-=======
->>>>>>> linux-next/akpm-base
 static int
 __intel_display_resume(struct drm_device *dev,
 		       struct drm_atomic_state *state,
@@ -3518,16 +3507,6 @@ void intel_finish_reset(struct drm_i915_
 
 	if (!state)
 		goto unlock;
-<<<<<<< HEAD
-
-	/*
-	 * Flips in the rings will be nuked by the reset,
-	 * so complete all pending flips so that user space
-	 * will get its events and not get stuck.
-	 */
-	intel_complete_page_flips(dev_priv);
-=======
->>>>>>> linux-next/akpm-base
 
 	dev_priv->modeset_restore_state = NULL;
 
@@ -9030,16 +9009,7 @@ static bool haswell_get_pipe_config(stru
 	u64 power_domain_mask;
 	bool active;
 
-<<<<<<< HEAD
-	if (INTEL_GEN(dev_priv) >= 9) {
-		intel_crtc_init_scalers(crtc, pipe_config);
-
-		pipe_config->scaler_state.scaler_id = -1;
-		pipe_config->scaler_state.scaler_users &= ~(1 << SKL_CRTC_INDEX);
-	}
-=======
 	intel_crtc_init_scalers(crtc, pipe_config);
->>>>>>> linux-next/akpm-base
 
 	power_domain = POWER_DOMAIN_PIPE(crtc->pipe);
 	if (!intel_display_power_get_if_enabled(dev_priv, power_domain))
@@ -9069,8 +9039,6 @@ static bool haswell_get_pipe_config(stru
 	pipe_config->gamma_mode =
 		I915_READ(GAMMA_MODE(crtc->pipe)) & GAMMA_MODE_MODE_MASK;
 
-<<<<<<< HEAD
-=======
 	if (IS_BROADWELL(dev_priv) || dev_priv->info.gen >= 9) {
 		u32 tmp = I915_READ(PIPEMISC(crtc->pipe));
 		bool clrspace_yuv = tmp & PIPEMISC_OUTPUT_COLORSPACE_YUV;
@@ -9088,7 +9056,6 @@ static bool haswell_get_pipe_config(stru
 		}
 	}
 
->>>>>>> linux-next/akpm-base
 	power_domain = POWER_DOMAIN_PIPE_PANEL_FITTER(crtc->pipe);
 	if (intel_display_power_get_if_enabled(dev_priv, power_domain)) {
 		power_domain_mask |= BIT_ULL(power_domain);
diff -puN drivers/gpu/drm/i915/intel_pm.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_pm.c
--- a/drivers/gpu/drm/i915/intel_pm.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_pm.c
@@ -4460,13 +4460,8 @@ static int skl_compute_plane_wm(const st
 		    (plane_bytes_per_line / 512 < 1))
 			selected_result = method2;
 		else if (ddb_allocation >=
-<<<<<<< HEAD
-			 fixed_16_16_to_u32_round_up(plane_blocks_per_line))
-			selected_result = min_fixed_16_16(method1, method2);
-=======
 			 fixed16_to_u32_round_up(plane_blocks_per_line))
 			selected_result = min_fixed16(method1, method2);
->>>>>>> linux-next/akpm-base
 		else if (latency >= linetime_us)
 			selected_result = min_fixed16(method1, method2);
 		else
diff -puN drivers/gpu/drm/nouveau/nv50_display.c~linux-next-git-rejects drivers/gpu/drm/nouveau/nv50_display.c
--- a/drivers/gpu/drm/nouveau/nv50_display.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/nouveau/nv50_display.c
@@ -4081,12 +4081,7 @@ nv50_disp_atomic_commit_tail(struct drm_
 		if (crtc->state->event) {
 			unsigned long flags;
 			/* Get correct count/ts if racing with vblank irq */
-<<<<<<< HEAD
-			if (crtc->state->active)
-				drm_accurate_vblank_count(crtc);
-=======
 			drm_crtc_accurate_vblank_count(crtc);
->>>>>>> linux-next/akpm-base
 			spin_lock_irqsave(&crtc->dev->event_lock, flags);
 			drm_crtc_send_vblank_event(crtc, crtc->state->event);
 			spin_unlock_irqrestore(&crtc->dev->event_lock, flags);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-mprotect-flush-tlb-if-potentially-racing-with-a-parallel-reclaim-leaving-stale-tlb-entries-fix.patch
mm-mprotect-flush-tlb-if-potentially-racing-with-a-parallel-reclaim-leaving-stale-tlb-entries-fix-fix.patch
fortify-use-warn-instead-of-bug-for-now-fix.patch
swap-fix-oops-during-block-io-poll-in-swapin-path-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

