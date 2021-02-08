Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5200BC433E0
	for <mm-commits@archiver.kernel.org>; Mon,  8 Feb 2021 17:21:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1064E64E27
	for <mm-commits@archiver.kernel.org>; Mon,  8 Feb 2021 17:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbhBHRUr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Feb 2021 12:20:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:34352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234510AbhBHRTz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Feb 2021 12:19:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECA1364E60;
        Mon,  8 Feb 2021 17:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612804753;
        bh=Q8g8vU/UA6XnsgjlpxDUMHlJNJLsTCoNJfbS102NuVA=;
        h=Date:From:To:Subject:From;
        b=jw95A6BGaXqIkf32PSAS57x/7u8XFy2l6icIxiO19VAckJVlxXkENy+wV4w/EP5vo
         kAM6lrenrf4T5LVGUyzu+0MxRNjZBcaIYgAjb3ua5JyGSXSlDJ6y3EJnBMTiRQawSz
         lLDvb4SetVbUFySSm3YqF38+t99ZkZxfFIz63unI=
Date:   Mon, 08 Feb 2021 09:19:12 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20210208171912.LvwydiiOo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


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

 drivers/gpu/drm/i915/display/intel_display.c |  222 -----------------
 drivers/gpu/drm/i915/display/intel_dp.c      |    3 
 drivers/gpu/drm/i915/gt/intel_breadcrumbs.c  |   10 
 3 files changed, 235 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_display.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/display/intel_display.c
@@ -3697,228 +3697,6 @@ void intel_display_prepare_reset(struct
 		return;
 	}
 
-<<<<<<< HEAD
-	return 0;
-}
-
-u32 skl_plane_ctl_crtc(const struct intel_crtc_state *crtc_state)
-{
-	struct drm_i915_private *dev_priv = to_i915(crtc_state->uapi.crtc->dev);
-	u32 plane_ctl = 0;
-
-	if (crtc_state->uapi.async_flip)
-		plane_ctl |= PLANE_CTL_ASYNC_FLIP;
-
-	if (INTEL_GEN(dev_priv) >= 10 || IS_GEMINILAKE(dev_priv))
-		return plane_ctl;
-
-	if (crtc_state->gamma_enable)
-		plane_ctl |= PLANE_CTL_PIPE_GAMMA_ENABLE;
-
-	if (crtc_state->csc_enable)
-		plane_ctl |= PLANE_CTL_PIPE_CSC_ENABLE;
-
-	return plane_ctl;
-}
-
-u32 skl_plane_ctl(const struct intel_crtc_state *crtc_state,
-		  const struct intel_plane_state *plane_state)
-{
-	struct drm_i915_private *dev_priv =
-		to_i915(plane_state->uapi.plane->dev);
-	const struct drm_framebuffer *fb = plane_state->hw.fb;
-	unsigned int rotation = plane_state->hw.rotation;
-	const struct drm_intel_sprite_colorkey *key = &plane_state->ckey;
-	u32 plane_ctl;
-
-	plane_ctl = PLANE_CTL_ENABLE;
-
-	if (INTEL_GEN(dev_priv) < 10 && !IS_GEMINILAKE(dev_priv)) {
-		plane_ctl |= skl_plane_ctl_alpha(plane_state);
-		plane_ctl |= PLANE_CTL_PLANE_GAMMA_DISABLE;
-
-		if (plane_state->hw.color_encoding == DRM_COLOR_YCBCR_BT709)
-			plane_ctl |= PLANE_CTL_YUV_TO_RGB_CSC_FORMAT_BT709;
-
-		if (plane_state->hw.color_range == DRM_COLOR_YCBCR_FULL_RANGE)
-			plane_ctl |= PLANE_CTL_YUV_RANGE_CORRECTION_DISABLE;
-	}
-
-	plane_ctl |= skl_plane_ctl_format(fb->format->format);
-	plane_ctl |= skl_plane_ctl_tiling(fb->modifier);
-	plane_ctl |= skl_plane_ctl_rotate(rotation & DRM_MODE_ROTATE_MASK);
-
-	if (INTEL_GEN(dev_priv) >= 10)
-		plane_ctl |= cnl_plane_ctl_flip(rotation &
-						DRM_MODE_REFLECT_MASK);
-
-	if (key->flags & I915_SET_COLORKEY_DESTINATION)
-		plane_ctl |= PLANE_CTL_KEY_ENABLE_DESTINATION;
-	else if (key->flags & I915_SET_COLORKEY_SOURCE)
-		plane_ctl |= PLANE_CTL_KEY_ENABLE_SOURCE;
-
-	return plane_ctl;
-}
-
-u32 glk_plane_color_ctl_crtc(const struct intel_crtc_state *crtc_state)
-{
-	struct drm_i915_private *dev_priv = to_i915(crtc_state->uapi.crtc->dev);
-	u32 plane_color_ctl = 0;
-
-	if (INTEL_GEN(dev_priv) >= 11)
-		return plane_color_ctl;
-
-	if (crtc_state->gamma_enable)
-		plane_color_ctl |= PLANE_COLOR_PIPE_GAMMA_ENABLE;
-
-	if (crtc_state->csc_enable)
-		plane_color_ctl |= PLANE_COLOR_PIPE_CSC_ENABLE;
-
-	return plane_color_ctl;
-}
-
-u32 glk_plane_color_ctl(const struct intel_crtc_state *crtc_state,
-			const struct intel_plane_state *plane_state)
-{
-	struct drm_i915_private *dev_priv =
-		to_i915(plane_state->uapi.plane->dev);
-	const struct drm_framebuffer *fb = plane_state->hw.fb;
-	struct intel_plane *plane = to_intel_plane(plane_state->uapi.plane);
-	u32 plane_color_ctl = 0;
-
-	plane_color_ctl |= PLANE_COLOR_PLANE_GAMMA_DISABLE;
-	plane_color_ctl |= glk_plane_color_ctl_alpha(plane_state);
-
-	if (fb->format->is_yuv && !icl_is_hdr_plane(dev_priv, plane->id)) {
-		switch (plane_state->hw.color_encoding) {
-		case DRM_COLOR_YCBCR_BT709:
-			plane_color_ctl |= PLANE_COLOR_CSC_MODE_YUV709_TO_RGB709;
-			break;
-		case DRM_COLOR_YCBCR_BT2020:
-			plane_color_ctl |=
-				PLANE_COLOR_CSC_MODE_YUV2020_TO_RGB2020;
-			break;
-		default:
-			plane_color_ctl |=
-				PLANE_COLOR_CSC_MODE_YUV601_TO_RGB601;
-		}
-		if (plane_state->hw.color_range == DRM_COLOR_YCBCR_FULL_RANGE)
-			plane_color_ctl |= PLANE_COLOR_YUV_RANGE_CORRECTION_DISABLE;
-	} else if (fb->format->is_yuv) {
-		plane_color_ctl |= PLANE_COLOR_INPUT_CSC_ENABLE;
-		if (plane_state->hw.color_range == DRM_COLOR_YCBCR_FULL_RANGE)
-			plane_color_ctl |= PLANE_COLOR_YUV_RANGE_CORRECTION_DISABLE;
-	}
-
-	return plane_color_ctl;
-}
-
-static int
-__intel_display_resume(struct drm_device *dev,
-		       struct drm_atomic_state *state,
-		       struct drm_modeset_acquire_ctx *ctx)
-{
-	struct drm_crtc_state *crtc_state;
-	struct drm_crtc *crtc;
-	int i, ret;
-
-	intel_modeset_setup_hw_state(dev, ctx);
-	intel_vga_redisable(to_i915(dev));
-
-	if (!state)
-		return 0;
-
-	/*
-	 * We've duplicated the state, pointers to the old state are invalid.
-	 *
-	 * Don't attempt to use the old state until we commit the duplicated state.
-	 */
-	for_each_new_crtc_in_state(state, crtc, crtc_state, i) {
-		/*
-		 * Force recalculation even if we restore
-		 * current state. With fast modeset this may not result
-		 * in a modeset when the state is compatible.
-		 */
-		crtc_state->mode_changed = true;
-	}
-
-	/* ignore any reset values/BIOS leftovers in the WM registers */
-	if (!HAS_GMCH(to_i915(dev)))
-		to_intel_atomic_state(state)->skip_intermediate_wm = true;
-
-	ret = drm_atomic_helper_commit_duplicated_state(state, ctx);
-
-	drm_WARN_ON(dev, ret == -EDEADLK);
-	return ret;
-}
-
-static bool gpu_reset_clobbers_display(struct drm_i915_private *dev_priv)
-{
-	return (INTEL_INFO(dev_priv)->gpu_reset_clobbers_display &&
-		intel_has_gpu_reset(&dev_priv->gt));
-}
-
-void intel_display_prepare_reset(struct drm_i915_private *dev_priv)
-{
-	struct drm_device *dev = &dev_priv->drm;
-	struct drm_modeset_acquire_ctx *ctx = &dev_priv->reset_ctx;
-	struct drm_atomic_state *state;
-	int ret;
-
-	if (!HAS_DISPLAY(dev_priv))
-		return;
-
-	/* reset doesn't touch the display */
-	if (!dev_priv->params.force_reset_modeset_test &&
-	    !gpu_reset_clobbers_display(dev_priv))
-		return;
-
-	/* We have a modeset vs reset deadlock, defensively unbreak it. */
-	set_bit(I915_RESET_MODESET, &dev_priv->gt.reset.flags);
-	smp_mb__after_atomic();
-	wake_up_bit(&dev_priv->gt.reset.flags, I915_RESET_MODESET);
-
-	if (atomic_read(&dev_priv->gpu_error.pending_fb_pin)) {
-		drm_dbg_kms(&dev_priv->drm,
-			    "Modeset potentially stuck, unbreaking through wedging\n");
-		intel_gt_set_wedged(&dev_priv->gt);
-	}
-
-	/*
-	 * Need mode_config.mutex so that we don't
-	 * trample ongoing ->detect() and whatnot.
-	 */
-	mutex_lock(&dev->mode_config.mutex);
-	drm_modeset_acquire_init(ctx, 0);
-	while (1) {
-		ret = drm_modeset_lock_all_ctx(dev, ctx);
-		if (ret != -EDEADLK)
-			break;
-
-		drm_modeset_backoff(ctx);
-	}
-	/*
-	 * Disabling the crtcs gracefully seems nicer. Also the
-	 * g33 docs say we should at least disable all the planes.
-	 */
-	state = drm_atomic_helper_duplicate_state(dev, ctx);
-	if (IS_ERR(state)) {
-		ret = PTR_ERR(state);
-		drm_err(&dev_priv->drm, "Duplicating state failed with %i\n",
-			ret);
-		return;
-	}
-
-	ret = drm_atomic_helper_disable_all(dev, ctx);
-	if (ret) {
-		drm_err(&dev_priv->drm, "Suspending crtc's failed with %i\n",
-			ret);
-		drm_atomic_state_put(state);
-		return;
-	}
-
-=======
->>>>>>> linux-next/akpm-base
 	dev_priv->modeset_restore_state = state;
 	state->acquire_ctx = ctx;
 }
--- a/drivers/gpu/drm/i915/display/intel_dp.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/display/intel_dp.c
@@ -3362,8 +3362,6 @@ ivb_cpu_edp_set_signal_levels(struct int
 	intel_de_posting_read(dev_priv, intel_dp->output_reg);
 }
 
-<<<<<<< HEAD
-=======
 static char dp_training_pattern_name(u8 train_pat)
 {
 	switch (train_pat) {
@@ -3379,7 +3377,6 @@ static char dp_training_pattern_name(u8
 	}
 }
 
->>>>>>> linux-next/akpm-base
 void
 intel_dp_program_link_training_pattern(struct intel_dp *intel_dp,
 				       const struct intel_crtc_state *crtc_state,
--- a/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
@@ -257,16 +257,6 @@ static void signal_irq_work(struct irq_w
 			list_del_rcu(&rq->signal_link);
 			release = remove_signaling_context(b, ce);
 			spin_unlock(&ce->signal_lock);
-<<<<<<< HEAD
-
-			if (__dma_fence_signal(&rq->fence))
-				/* We own signal_node now, xfer to local list */
-				signal = slist_add(&rq->signal_node, signal);
-			else
-				i915_request_put(rq);
-
-=======
->>>>>>> linux-next/akpm-base
 			if (release) {
 				if (intel_timeline_is_last(ce->timeline, rq))
 					add_retire(b, ce->timeline);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
mm-memcg-add-swapcache-stat-for-memcg-v2-fix.patch
kasan-add-match-all-tag-tests-fix-fix.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
bdi-use-might_alloc-fix.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
lib-stackdepot-add-support-to-disable-stack-depot-fix.patch
seq_file-document-how-per-entry-resources-are-managed-fix.patch
initramfs-panic-with-memory-information-fix.patch
linux-next-rejects.patch
fs-ramfs-inodec-update-inode_operationstmpfile.patch
kernel-forkc-export-kernel_thread-to-modules.patch

