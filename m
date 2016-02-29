From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 29 Feb 2016 12:23:57 -0800
Message-ID: <56d4a8dd.ghFnVCK+FPbVfMhD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbcB2UX6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Feb 2016 15:23:58 -0500
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

 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c |   12 ------------
 drivers/gpu/drm/i915/intel_csr.c            |    3 ---
 drivers/gpu/drm/i915/intel_ddi.c            |   10 ----------
 sound/pci/hda/patch_realtek.c               |   13 -------------
 4 files changed, 38 deletions(-)

diff -puN drivers/gpu/drm/amd/amdgpu/amdgpu_display.c~linux-next-git-rejects drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -124,18 +124,6 @@ static void amdgpu_flip_work_func(struct
 		spin_lock_irqsave(&crtc->dev->event_lock, flags);
 	};
 
-<<<<<<< HEAD
-	if (!repcnt)
-		DRM_DEBUG_DRIVER("Delay problem on crtc %d: min_udelay %d, "
-				 "framedur %d, linedur %d, stat %d, vpos %d, "
-				 "hpos %d\n", work->crtc_id, min_udelay,
-				 vblank->framedur_ns / 1000,
-				 vblank->linedur_ns / 1000, stat, vpos, hpos);
-
-	/* do the flip (mmio) */
-	adev->mode_info.funcs->page_flip(adev, work->crtc_id, work->base);
-=======
->>>>>>> linux-next/akpm-base
 	/* set the flip status */
 	amdgpuCrtc->pflip_status = AMDGPU_FLIP_SUBMITTED;
 	spin_unlock_irqrestore(&crtc->dev->event_lock, flags);
diff -puN drivers/gpu/drm/i915/intel_csr.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_csr.c
--- a/drivers/gpu/drm/i915/intel_csr.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_csr.c
@@ -245,11 +245,8 @@ bool intel_csr_load_program(struct drm_i
 	}
 
 	dev_priv->csr.dc_state = 0;
-<<<<<<< HEAD
-=======
 
 	return true;
->>>>>>> linux-next/akpm-base
 }
 
 static uint32_t *parse_csr_fw(struct drm_i915_private *dev_priv,
diff -puN drivers/gpu/drm/i915/intel_ddi.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_ddi.c
--- a/drivers/gpu/drm/i915/intel_ddi.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_ddi.c
@@ -2002,7 +2002,6 @@ bool intel_ddi_get_hw_state(struct intel
 		}
 
 		ret = true;
-<<<<<<< HEAD
 
 		goto out;
 	}
@@ -2010,15 +2009,6 @@ bool intel_ddi_get_hw_state(struct intel
 	for (i = TRANSCODER_A; i <= TRANSCODER_C; i++) {
 		tmp = I915_READ(TRANS_DDI_FUNC_CTL(i));
 
-=======
-
-		goto out;
-	}
-
-	for (i = TRANSCODER_A; i <= TRANSCODER_C; i++) {
-		tmp = I915_READ(TRANS_DDI_FUNC_CTL(i));
-
->>>>>>> linux-next/akpm-base
 		if ((tmp & TRANS_DDI_PORT_MASK) == TRANS_DDI_SELECT_PORT(port)) {
 			if ((tmp & TRANS_DDI_MODE_SELECT_MASK) ==
 			    TRANS_DDI_MODE_SELECT_DP_MST)
diff -puN sound/pci/hda/patch_realtek.c~linux-next-git-rejects sound/pci/hda/patch_realtek.c
--- a/sound/pci/hda/patch_realtek.c~linux-next-git-rejects
+++ a/sound/pci/hda/patch_realtek.c
@@ -4758,10 +4758,6 @@ enum {
 	ALC233_FIXUP_LENOVO_LINE2_MIC_HOTKEY,
 	ALC255_FIXUP_DELL_SPK_NOISE,
 	ALC225_FIXUP_DELL1_MIC_NO_PRESENCE,
-<<<<<<< HEAD
-	ALC280_FIXUP_HP_HEADSET_MIC,
-=======
->>>>>>> linux-next/akpm-base
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -5398,15 +5394,6 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC269_FIXUP_DELL1_MIC_NO_PRESENCE
 	},
-<<<<<<< HEAD
-	[ALC280_FIXUP_HP_HEADSET_MIC] = {
-		.type = HDA_FIXUP_FUNC,
-		.v.func = alc_fixup_disable_aamix,
-		.chained = true,
-		.chain_id = ALC269_FIXUP_HEADSET_MIC,
-	},
-=======
->>>>>>> linux-next/akpm-base
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-code-clean-up-for-direct-io-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
mm.patch
mm-slab-clean-up-debug_pagealloc-processing-code-fix.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page-fix.patch
slub-drop-lock-at-the-end-of-free_debug_processing-fix.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option-fix.patch
mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes.patch
mm-madvise-update-comment-on-sys_madvise-fix.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix.patch
mm-simplify-lock_page_memcg-fix.patch
sched-add-schedule_timeout_idle.patch
mm-oom_reaper-report-success-failure-fix.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix.patch
proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix-fix.patch
mm-vmalloc-query-dynamic-debug_pagealloc-setting-fix.patch
mm-slub-query-dynamic-debug_pagealloc-setting-fix.patch
sound-query-dynamic-debug_pagealloc-setting-fix.patch
mm-config_nr_zones_extended-fix.patch
mm-add-a-new-vector-based-madvise-syscall-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
btrfs-use-radix_tree_iter_retry-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch
rapidio-add-mport-char-device-driver-fix.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
kernel-add-kcov-code-coverage-fix.patch
kernel-add-kcov-code-coverage-fix-2.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
net-sched-sch_mqprioc-fix-build-with-older-gcc.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

