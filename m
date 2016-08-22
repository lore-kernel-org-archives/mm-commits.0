From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 22 Aug 2016 11:37:35 -0700
Message-ID: <57bb466f.AQiiimihEGIN7//K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51667 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932754AbcHVShh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2016 14:37:37 -0400
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

 drivers/gpu/drm/i915/i915_gem.c  |    5 ---
 drivers/gpu/drm/i915/intel_ddi.c |   45 -----------------------------
 2 files changed, 50 deletions(-)

diff -puN drivers/gpu/drm/i915/i915_gem.c~linux-next-git-rejects drivers/gpu/drm/i915/i915_gem.c
--- a/drivers/gpu/drm/i915/i915_gem.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/i915_gem.c
@@ -2469,11 +2469,6 @@ static void i915_gem_reset_engine_cleanu
 		intel_ring_update_space(ring);
 	}
 
-<<<<<<< HEAD
-	intel_ring_init_seqno(engine, engine->last_submitted_seqno);
-
-=======
->>>>>>> linux-next/akpm-base
 	engine->i915->gt.active_engines &= ~intel_engine_flag(engine);
 }
 
diff -puN drivers/gpu/drm/i915/intel_ddi.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_ddi.c
--- a/drivers/gpu/drm/i915/intel_ddi.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_ddi.c
@@ -420,34 +420,14 @@ void intel_prepare_dp_ddi_buffers(struct
 {
 	struct drm_i915_private *dev_priv = to_i915(encoder->base.dev);
 	u32 iboost_bit = 0;
-<<<<<<< HEAD
-	int i, n_hdmi_entries, n_dp_entries, n_edp_entries,
-	    size;
-	int hdmi_level;
-	enum port port;
-=======
 	int i, n_dp_entries, n_edp_entries, size;
 	enum port port = intel_ddi_get_encoder_port(encoder);
->>>>>>> linux-next/akpm-base
 	const struct ddi_buf_trans *ddi_translations_fdi;
 	const struct ddi_buf_trans *ddi_translations_dp;
 	const struct ddi_buf_trans *ddi_translations_edp;
 	const struct ddi_buf_trans *ddi_translations;
 
-<<<<<<< HEAD
-	port = intel_ddi_get_encoder_port(encoder);
-	hdmi_level = intel_ddi_hdmi_level(dev_priv, port);
-
-	if (IS_BROXTON(dev_priv)) {
-		if (encoder->type != INTEL_OUTPUT_HDMI)
-			return;
-
-		/* Vswing programming for HDMI */
-		bxt_ddi_vswing_sequence(dev_priv, hdmi_level, port,
-					INTEL_OUTPUT_HDMI);
-=======
 	if (IS_BROXTON(dev_priv))
->>>>>>> linux-next/akpm-base
 		return;
 
 	if (IS_SKYLAKE(dev_priv) || IS_KABYLAKE(dev_priv)) {
@@ -456,12 +436,7 @@ void intel_prepare_dp_ddi_buffers(struct
 				skl_get_buf_trans_dp(dev_priv, &n_dp_entries);
 		ddi_translations_edp =
 				skl_get_buf_trans_edp(dev_priv, &n_edp_entries);
-<<<<<<< HEAD
-		ddi_translations_hdmi =
-				skl_get_buf_trans_hdmi(dev_priv, &n_hdmi_entries);
-=======
 
->>>>>>> linux-next/akpm-base
 		/* If we're boosting the current, set bit 31 of trans1 */
 		if (dev_priv->vbt.ddi_port_info[port].dp_boost_level)
 			iboost_bit = DDI_BUF_BALANCE_LEG_ENABLE;
@@ -475,19 +450,11 @@ void intel_prepare_dp_ddi_buffers(struct
 		ddi_translations_dp = bdw_ddi_translations_dp;
 		ddi_translations_edp = bdw_get_buf_trans_edp(dev_priv, &n_edp_entries);
 		n_dp_entries = ARRAY_SIZE(bdw_ddi_translations_dp);
-<<<<<<< HEAD
-		n_hdmi_entries = ARRAY_SIZE(bdw_ddi_translations_hdmi);
-=======
->>>>>>> linux-next/akpm-base
 	} else if (IS_HASWELL(dev_priv)) {
 		ddi_translations_fdi = hsw_ddi_translations_fdi;
 		ddi_translations_dp = hsw_ddi_translations_dp;
 		ddi_translations_edp = hsw_ddi_translations_dp;
 		n_dp_entries = n_edp_entries = ARRAY_SIZE(hsw_ddi_translations_dp);
-<<<<<<< HEAD
-		n_hdmi_entries = ARRAY_SIZE(hsw_ddi_translations_hdmi);
-=======
->>>>>>> linux-next/akpm-base
 	} else {
 		WARN(1, "ddi translation table missing\n");
 		ddi_translations_edp = bdw_ddi_translations_dp;
@@ -495,10 +462,6 @@ void intel_prepare_dp_ddi_buffers(struct
 		ddi_translations_dp = bdw_ddi_translations_dp;
 		n_edp_entries = ARRAY_SIZE(bdw_ddi_translations_edp);
 		n_dp_entries = ARRAY_SIZE(bdw_ddi_translations_dp);
-<<<<<<< HEAD
-		n_hdmi_entries = ARRAY_SIZE(bdw_ddi_translations_hdmi);
-=======
->>>>>>> linux-next/akpm-base
 	}
 
 	switch (encoder->type) {
@@ -542,8 +505,6 @@ static void intel_prepare_hdmi_ddi_buffe
 	if (IS_BROXTON(dev_priv))
 		return;
 
-<<<<<<< HEAD
-=======
 	hdmi_level = intel_ddi_hdmi_level(dev_priv, port);
 
 	if (IS_SKYLAKE(dev_priv) || IS_KABYLAKE(dev_priv)) {
@@ -564,7 +525,6 @@ static void intel_prepare_hdmi_ddi_buffe
 		n_hdmi_entries = ARRAY_SIZE(bdw_ddi_translations_hdmi);
 	}
 
->>>>>>> linux-next/akpm-base
 	/* Entry 9 is for HDMI: */
 	I915_WRITE(DDI_BUF_TRANS_LO(port, 9),
 		   ddi_translations_hdmi[hdmi_level].trans1 | iboost_bit);
@@ -1689,10 +1649,6 @@ static void intel_ddi_pre_enable(struct
 		struct intel_hdmi *intel_hdmi = enc_to_intel_hdmi(encoder);
 		int level = intel_ddi_hdmi_level(dev_priv, port);
 
-<<<<<<< HEAD
-		if (IS_SKYLAKE(dev_priv) || IS_KABYLAKE(dev_priv))
-			skl_ddi_set_iboost(intel_encoder, level);
-=======
 		intel_prepare_hdmi_ddi_buffers(intel_encoder);
 
 		if (IS_SKYLAKE(dev_priv) || IS_KABYLAKE(dev_priv))
@@ -1700,7 +1656,6 @@ static void intel_ddi_pre_enable(struct
 		else if (IS_BROXTON(dev_priv))
 			bxt_ddi_vswing_sequence(dev_priv, level, port,
 						INTEL_OUTPUT_HDMI);
->>>>>>> linux-next/akpm-base
 
 		intel_hdmi->set_infoframes(encoder,
 					   crtc->config->has_hdmi_sink,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
sysctl-handle-error-writing-uint_max-to-u32-fields-checkpatch-fixes.patch
sysctl-handle-error-writing-uint_max-to-u32-fields-checkpatch-fixes-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-vmalloc-fix-align-value-calculation-error-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix.patch
mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

