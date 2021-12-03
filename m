Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0421C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Dec 2021 17:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382064AbhLCReP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Dec 2021 12:34:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35632 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358636AbhLCReO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Dec 2021 12:34:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8348B82893
        for <mm-commits@vger.kernel.org>; Fri,  3 Dec 2021 17:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62218C53FCD;
        Fri,  3 Dec 2021 17:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638552648;
        bh=1h1T6RlaxgWktx0B6lURlvX0LGjT3hUiMby1MBcITRE=;
        h=Date:From:To:Subject:From;
        b=UUnfCGyHM4tRTQ1sChW0Cb7CEiPAkrOrAvHpwWUWgf5EcnlQdfXUlbdnmYHnIk/Fn
         crRKngDwa8kMsDXju9frDXKmyRd7kTY1MdbAMTMTxmD5ooftDahB/4I9gZSjvFNTGB
         J5wJLi6rTTG7F/JrTAKH+/cIDFsmZfVQQa+Q0wU0=
Date:   Fri, 03 Dec 2021 09:30:47 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20211203173047.3Wsxxd-IO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c               |    5 -
 drivers/gpu/drm/amd/amdgpu/nv.c                       |    5 -
 drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c |   17 -----
 drivers/gpu/drm/msm/Makefile                          |    9 --
 drivers/gpu/drm/msm/msm_drv.c                         |    4 -
 drivers/gpu/drm/msm/msm_gpu_devfreq.c                 |   33 ----------
 drivers/gpu/drm/vc4/vc4_kms.c                         |   13 ---
 7 files changed, 86 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
@@ -134,11 +134,6 @@ int amdgpu_vcn_sw_init(struct amdgpu_dev
 			adev->vcn.indirect_sram = true;
 		break;
 	case IP_VERSION(3, 0, 0):
-<<<<<<< HEAD
-	case IP_VERSION(3, 0, 64):
-	case IP_VERSION(3, 0, 192):
-=======
->>>>>>> linux-next/akpm-base
 		if (adev->ip_versions[GC_HWIP][0] == IP_VERSION(10, 3, 0))
 			fw_name = FIRMWARE_SIENNA_CICHLID;
 		else
--- a/drivers/gpu/drm/amd/amdgpu/nv.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/amdgpu/nv.c
@@ -182,11 +182,6 @@ static int nv_query_video_codecs(struct
 {
 	switch (adev->ip_versions[UVD_HWIP][0]) {
 	case IP_VERSION(3, 0, 0):
-<<<<<<< HEAD
-	case IP_VERSION(3, 0, 64):
-	case IP_VERSION(3, 0, 192):
-=======
->>>>>>> linux-next/akpm-base
 		if (amdgpu_sriov_vf(adev)) {
 			if (encode)
 				*codecs = &sriov_sc_video_codecs_encode;
--- a/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
@@ -305,10 +305,6 @@ intel_dp_aux_vesa_enable_backlight(const
 	struct intel_dp *intel_dp = enc_to_intel_dp(connector->encoder);
 
 	if (!panel->backlight.edp.vesa.info.aux_enable) {
-<<<<<<< HEAD
-		u32 pwm_level = intel_backlight_invert_pwm_level(connector,
-								 panel->backlight.pwm_level_max);
-=======
 		u32 pwm_level;
 
 		if (!panel->backlight.edp.vesa.info.aux_set)
@@ -316,7 +312,6 @@ intel_dp_aux_vesa_enable_backlight(const
 		else
 			pwm_level = intel_backlight_invert_pwm_level(connector,
 								     panel->backlight.pwm_level_max);
->>>>>>> linux-next/akpm-base
 
 		panel->backlight.pwm_funcs->enable(crtc_state, conn_state, pwm_level);
 	}
@@ -353,11 +348,7 @@ static int intel_dp_aux_vesa_setup_backl
 	if (ret < 0)
 		return ret;
 
-<<<<<<< HEAD
-	if (!panel->backlight.edp.vesa.info.aux_enable) {
-=======
 	if (!panel->backlight.edp.vesa.info.aux_set || !panel->backlight.edp.vesa.info.aux_enable) {
->>>>>>> linux-next/akpm-base
 		ret = panel->backlight.pwm_funcs->setup(connector, pipe);
 		if (ret < 0) {
 			drm_err(&i915->drm,
@@ -366,13 +357,6 @@ static int intel_dp_aux_vesa_setup_backl
 			return ret;
 		}
 	}
-<<<<<<< HEAD
-	panel->backlight.max = panel->backlight.edp.vesa.info.max;
-	panel->backlight.min = 0;
-	if (current_mode == DP_EDP_BACKLIGHT_CONTROL_MODE_DPCD) {
-		panel->backlight.level = current_level;
-		panel->backlight.enabled = panel->backlight.level != 0;
-=======
 
 	if (panel->backlight.edp.vesa.info.aux_set) {
 		panel->backlight.max = panel->backlight.edp.vesa.info.max;
@@ -384,7 +368,6 @@ static int intel_dp_aux_vesa_setup_backl
 			panel->backlight.level = panel->backlight.max;
 			panel->backlight.enabled = false;
 		}
->>>>>>> linux-next/akpm-base
 	} else {
 		panel->backlight.max = panel->backlight.pwm_level_max;
 		panel->backlight.min = panel->backlight.pwm_level_min;
--- a/drivers/gpu/drm/msm/Makefile~linux-next-git-rejects
+++ a/drivers/gpu/drm/msm/Makefile
@@ -27,15 +27,6 @@ msm-y := \
 	hdmi/hdmi_phy_8x60.o \
 	hdmi/hdmi_phy_8x74.o \
 	hdmi/hdmi_pll_8960.o \
-<<<<<<< HEAD
-	edp/edp.o \
-	edp/edp_aux.o \
-	edp/edp_bridge.o \
-	edp/edp_connector.o \
-	edp/edp_ctrl.o \
-	edp/edp_phy.o \
-=======
->>>>>>> linux-next/akpm-base
 	disp/mdp_format.o \
 	disp/mdp_kms.o \
 	disp/mdp4/mdp4_crtc.o \
--- a/drivers/gpu/drm/msm/msm_drv.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/msm/msm_drv.c
@@ -967,11 +967,7 @@ static int wait_fence(struct msm_gpu_sub
 	struct dma_fence *fence;
 	int ret;
 
-<<<<<<< HEAD
-	if (fence_id > queue->last_fence) {
-=======
 	if (fence_after(fence_id, queue->last_fence)) {
->>>>>>> linux-next/akpm-base
 		DRM_ERROR_RATELIMITED("waiting on invalid fence: %u (of %u)\n",
 				      fence_id, queue->last_fence);
 		return -EINVAL;
--- a/drivers/gpu/drm/msm/msm_gpu_devfreq.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/msm/msm_gpu_devfreq.c
@@ -21,29 +21,11 @@ static int msm_devfreq_target(struct dev
 	struct msm_gpu *gpu = dev_to_gpu(dev);
 	struct dev_pm_opp *opp;
 
-<<<<<<< HEAD
 	/*
 	 * Note that devfreq_recommended_opp() can modify the freq
 	 * to something that actually is in the opp table:
 	 */
 	opp = devfreq_recommended_opp(dev, freq, flags);
-
-=======
->>>>>>> linux-next/akpm-base
-	/*
-	 * Note that devfreq_recommended_opp() can modify the freq
-	 * to something that actually is in the opp table:
-	 */
-<<<<<<< HEAD
-	if (gpu->devfreq.idle_freq) {
-		gpu->devfreq.idle_freq = *freq;
-		dev_pm_opp_put(opp);
-		return 0;
-	}
-
-=======
-	opp = devfreq_recommended_opp(dev, freq, flags);
->>>>>>> linux-next/akpm-base
 	if (IS_ERR(opp))
 		return PTR_ERR(opp);
 
@@ -243,21 +225,6 @@ static void msm_devfreq_idle_work(struct
 	struct msm_gpu_devfreq *df = container_of(work,
 			struct msm_gpu_devfreq, idle_work.work);
 	struct msm_gpu *gpu = container_of(df, struct msm_gpu, devfreq);
-<<<<<<< HEAD
-	unsigned long idle_freq, target_freq = 0;
-
-	/*
-	 * Hold devfreq lock to synchronize with get_dev_status()/
-	 * target() callbacks
-	 */
-	mutex_lock(&df->devfreq->lock);
-
-	idle_freq = get_freq(gpu);
-
-	if (gpu->clamp_to_idle)
-		msm_devfreq_target(&gpu->pdev->dev, &target_freq, 0);
-=======
->>>>>>> linux-next/akpm-base
 
 	df->idle_time = ktime_get();
 
--- a/drivers/gpu/drm/vc4/vc4_kms.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/vc4/vc4_kms.c
@@ -365,13 +365,6 @@ static void vc4_atomic_commit_tail(struc
 		vc4_hvs_mask_underrun(dev, vc4_crtc_state->assigned_channel);
 	}
 
-<<<<<<< HEAD
-	old_hvs_state = vc4_hvs_get_old_global_state(state);
-	if (IS_ERR(old_hvs_state))
-		return;
-
-=======
->>>>>>> linux-next/akpm-base
 	for (channel = 0; channel < HVS_NUM_CHANNELS; channel++) {
 		struct drm_crtc_commit *commit;
 		int ret;
@@ -389,8 +382,6 @@ static void vc4_atomic_commit_tail(struc
 
 		drm_crtc_commit_put(commit);
 		old_hvs_state->fifo_state[channel].pending_commit = NULL;
-<<<<<<< HEAD
-=======
 	}
 
 	if (vc4->hvs->hvs5) {
@@ -399,7 +390,6 @@ static void vc4_atomic_commit_tail(struc
 						new_hvs_state->core_clock_rate);
 
 		clk_set_min_rate(hvs->core_clk, core_rate);
->>>>>>> linux-next/akpm-base
 	}
 
 	if (vc4->hvs->hvs5)
@@ -690,10 +680,7 @@ vc4_hvs_channels_duplicate_state(struct
 
 	for (i = 0; i < HVS_NUM_CHANNELS; i++) {
 		state->fifo_state[i].in_use = old_state->fifo_state[i].in_use;
-<<<<<<< HEAD
-=======
 		state->fifo_state[i].fifo_load = old_state->fifo_state[i].fifo_load;
->>>>>>> linux-next/akpm-base
 	}
 
 	state->core_clock_rate = old_state->core_clock_rate;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch
device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-page-table-check-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix2.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
proc-remove-pde_data-completely-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-rejects.patch
linux-next-git-rejects.patch

