From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 10 Jan 2020 12:34:53 -0800
Message-ID: <20200110203453.LTPyHPHVU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbgAJUez (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Jan 2020 15:34:55 -0500
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

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/display/intel_display.c    |   17 ----------
 drivers/gpu/drm/i915/gt/intel_ring_submission.c |   22 --------------
 sound/soc/soc-topology.c                        |    4 --
 sound/usb/quirks.c                              |    6 ---
 4 files changed, 49 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_display.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/display/intel_display.c
@@ -4963,23 +4963,6 @@ static void icl_enable_trans_port_sync(c
 		   trans_ddi_func_ctl2_val);
 }
 
-<<<<<<< HEAD
-static void icl_disable_transcoder_port_sync(const struct intel_crtc_state *old_crtc_state)
-{
-	struct intel_crtc *crtc = to_intel_crtc(old_crtc_state->base.crtc);
-	struct drm_i915_private *dev_priv = to_i915(crtc->base.dev);
-
-	if (old_crtc_state->master_transcoder == INVALID_TRANSCODER)
-		return;
-
-	DRM_DEBUG_KMS("Disabling Transcoder Port Sync on Slave Transcoder %s\n",
-		      transcoder_name(old_crtc_state->cpu_transcoder));
-
-	I915_WRITE(TRANS_DDI_FUNC_CTL2(old_crtc_state->cpu_transcoder), 0);
-}
-
-=======
->>>>>>> linux-next/akpm-base
 static void intel_fdi_normal_train(struct intel_crtc *crtc)
 {
 	struct drm_device *dev = crtc->base.dev;
--- a/drivers/gpu/drm/i915/gt/intel_ring_submission.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/gt/intel_ring_submission.c
@@ -1559,10 +1559,6 @@ static int switch_mm(struct i915_request
 	if (ret)
 		return ret;
 
-<<<<<<< HEAD
-	if (ce->state) {
-		u32 flags;
-=======
 	/*
 	 * Not only do we need a full barrier (post-sync write) after
 	 * invalidating the TLBs, but we need to wait a little bit
@@ -1574,34 +1570,16 @@ static int switch_mm(struct i915_request
 	ret = load_pd_dir(rq, i915_vm_to_ppgtt(vm), PP_DIR_DCLV_2G);
 	if (ret)
 		return ret;
->>>>>>> linux-next/akpm-base
 
 	return rq->engine->emit_flush(rq, EMIT_INVALIDATE);
 }
 
-<<<<<<< HEAD
-		/* For resource streamer on HSW+ and power context elsewhere */
-		BUILD_BUG_ON(HSW_MI_RS_SAVE_STATE_EN != MI_SAVE_EXT_STATE_EN);
-		BUILD_BUG_ON(HSW_MI_RS_RESTORE_STATE_EN != MI_RESTORE_EXT_STATE_EN);
-
-		flags = MI_SAVE_EXT_STATE_EN | MI_MM_SPACE_GTT;
-		if (!i915_gem_context_is_kernel(rq->gem_context))
-			flags |= MI_RESTORE_EXT_STATE_EN;
-		else
-			flags |= MI_RESTORE_INHIBIT;
-
-		ret = mi_set_context(rq, flags);
-		if (ret)
-			return ret;
-	}
-=======
 static int switch_context(struct i915_request *rq)
 {
 	struct intel_context *ce = rq->context;
 	int ret;
 
 	GEM_BUG_ON(HAS_EXECLISTS(rq->i915));
->>>>>>> linux-next/akpm-base
 
 	ret = switch_mm(rq, vm_alias(ce));
 	if (ret)
--- a/sound/soc/soc-topology.c~linux-next-git-rejects
+++ a/sound/soc/soc-topology.c
@@ -549,12 +549,8 @@ static void remove_link(struct snd_soc_c
 		dobj->ops->link_unload(comp, dobj);
 
 	list_del(&dobj->list);
-<<<<<<< HEAD
-	snd_soc_remove_dai_link(comp->card, link);
-=======
 	snd_soc_remove_pcm_runtime(comp->card,
 			snd_soc_get_pcm_runtime(comp->card, link));
->>>>>>> linux-next/akpm-base
 
 	kfree(link->name);
 	kfree(link->stream_name);
--- a/sound/usb/quirks.c~linux-next-git-rejects
+++ a/sound/usb/quirks.c
@@ -1396,15 +1396,9 @@ bool snd_usb_get_sample_rate_quirk(struc
 	case USB_ID(0x041e, 0x4080): /* Creative Live Cam VF0610 */
 	case USB_ID(0x04d8, 0xfeea): /* Benchmark DAC1 Pre */
 	case USB_ID(0x0556, 0x0014): /* Phoenix Audio TMX320VC */
-<<<<<<< HEAD
-	case USB_ID(0x05A3, 0x9420): /* ELP HD USB Camera */
-	case USB_ID(0x05a7, 0x1020): /* Bose Companion 5 */
-	case USB_ID(0x074D, 0x3553): /* Outlaw RR2150 (Micronas UAC3553B) */
-=======
 	case USB_ID(0x05a3, 0x9420): /* ELP HD USB Camera */
 	case USB_ID(0x05a7, 0x1020): /* Bose Companion 5 */
 	case USB_ID(0x074d, 0x3553): /* Outlaw RR2150 (Micronas UAC3553B) */
->>>>>>> linux-next/akpm-base
 	case USB_ID(0x1395, 0x740a): /* Sennheiser DECT */
 	case USB_ID(0x1901, 0x0191): /* GE B850V3 CP2114 audio interface */
 	case USB_ID(0x21b4, 0x0081): /* AudioQuest DragonFly */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
drivers-base-memoryc-cache-blocks-in-radix-tree-to-accelerate-lookup-fix.patch
mm-oom-avoid-printk-iteration-under-rcu-fix.patch
linux-next-rejects.patch
linux-next-fix.patch
linux-next-fix-2.patch
drivers-block-null_blk_mainc-fix-layout.patch
drivers-block-null_blk_mainc-fix-uninitialized-var-warnings.patch
proc-convert-everything-to-struct-proc_ops-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch
