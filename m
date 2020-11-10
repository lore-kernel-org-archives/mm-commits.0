Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94807C388F7
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 18:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29F6420797
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 18:14:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="P5bbkOm1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgKJSO1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 13:14:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:58370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgKJSO1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 13:14:27 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FC8020781;
        Tue, 10 Nov 2020 18:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605032066;
        bh=JSqyiG1T30qeCJc4J9pFjnlY5Dxwp3kr9vJZ6lHdxUY=;
        h=Date:From:To:Subject:From;
        b=P5bbkOm1w7bKZz/ATr5bkaygHXFCEK1ULf0shzirJfNiheA4i4efkzuGzNQkZc0eA
         r3+ImuQ7+zfDQpOeLYDFzQEycwbPOhXZmQLFkqq3zLyqo06YfS90+Drn59o5QI8025
         R8zmmW8bW2Oq/PXiG5dmQ/NPRqJL1ZaV7VInBfOA=
Date:   Tue, 10 Nov 2020 10:14:25 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20201110181425.7IOzCFGzR%akpm@linux-foundation.org>
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

 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c        |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c           |   11 ---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    6 -
 drivers/gpu/drm/amd/include/amd_shared.h          |    3 
 drivers/gpu/drm/i915/display/intel_psr.c          |   40 ------------
 drivers/net/ethernet/ibm/ibmvnic.c                |   11 ---
 6 files changed, 74 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -80,10 +80,7 @@ MODULE_FIRMWARE("amdgpu/renoir_gpu_info.
 MODULE_FIRMWARE("amdgpu/navi10_gpu_info.bin");
 MODULE_FIRMWARE("amdgpu/navi14_gpu_info.bin");
 MODULE_FIRMWARE("amdgpu/navi12_gpu_info.bin");
-<<<<<<< HEAD
-=======
 MODULE_FIRMWARE("amdgpu/vangogh_gpu_info.bin");
->>>>>>> linux-next/akpm-base
 MODULE_FIRMWARE("amdgpu/green_sardine_gpu_info.bin");
 
 #define AMDGPU_RESUME_MS		2000
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
@@ -37,16 +37,6 @@
 #define FIRMWARE_RAVEN		"amdgpu/raven_vcn.bin"
 #define FIRMWARE_PICASSO	"amdgpu/picasso_vcn.bin"
 #define FIRMWARE_RAVEN2		"amdgpu/raven2_vcn.bin"
-<<<<<<< HEAD
-#define FIRMWARE_ARCTURUS 	"amdgpu/arcturus_vcn.bin"
-#define FIRMWARE_RENOIR 	"amdgpu/renoir_vcn.bin"
-#define FIRMWARE_GREEN_SARDINE 	"amdgpu/green_sardine_vcn.bin"
-#define FIRMWARE_NAVI10 	"amdgpu/navi10_vcn.bin"
-#define FIRMWARE_NAVI14 	"amdgpu/navi14_vcn.bin"
-#define FIRMWARE_NAVI12 	"amdgpu/navi12_vcn.bin"
-#define FIRMWARE_SIENNA_CICHLID 	"amdgpu/sienna_cichlid_vcn.bin"
-#define FIRMWARE_NAVY_FLOUNDER 	"amdgpu/navy_flounder_vcn.bin"
-=======
 #define FIRMWARE_ARCTURUS	"amdgpu/arcturus_vcn.bin"
 #define FIRMWARE_RENOIR		"amdgpu/renoir_vcn.bin"
 #define FIRMWARE_GREEN_SARDINE	"amdgpu/green_sardine_vcn.bin"
@@ -57,7 +47,6 @@
 #define FIRMWARE_NAVY_FLOUNDER	"amdgpu/navy_flounder_vcn.bin"
 #define FIRMWARE_VANGOGH	"amdgpu/vangogh_vcn.bin"
 #define FIRMWARE_DIMGREY_CAVEFISH	"amdgpu/dimgrey_cavefish_vcn.bin"
->>>>>>> linux-next/akpm-base
 
 MODULE_FIRMWARE(FIRMWARE_RAVEN);
 MODULE_FIRMWARE(FIRMWARE_PICASSO);
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -99,18 +99,12 @@ MODULE_FIRMWARE(FIRMWARE_RENOIR_DMUB);
 MODULE_FIRMWARE(FIRMWARE_SIENNA_CICHLID_DMUB);
 #define FIRMWARE_NAVY_FLOUNDER_DMUB "amdgpu/navy_flounder_dmcub.bin"
 MODULE_FIRMWARE(FIRMWARE_NAVY_FLOUNDER_DMUB);
-<<<<<<< HEAD
-#endif
-#define FIRMWARE_GREEN_SARDINE_DMUB "amdgpu/green_sardine_dmcub.bin"
-MODULE_FIRMWARE(FIRMWARE_GREEN_SARDINE_DMUB);
-=======
 #define FIRMWARE_GREEN_SARDINE_DMUB "amdgpu/green_sardine_dmcub.bin"
 MODULE_FIRMWARE(FIRMWARE_GREEN_SARDINE_DMUB);
 #define FIRMWARE_VANGOGH_DMUB "amdgpu/vangogh_dmcub.bin"
 MODULE_FIRMWARE(FIRMWARE_VANGOGH_DMUB);
 #define FIRMWARE_DIMGREY_CAVEFISH_DMUB "amdgpu/dimgrey_cavefish_dmcub.bin"
 MODULE_FIRMWARE(FIRMWARE_DIMGREY_CAVEFISH_DMUB);
->>>>>>> linux-next/akpm-base
 
 #define FIRMWARE_RAVEN_DMCU		"amdgpu/raven_dmcu.bin"
 MODULE_FIRMWARE(FIRMWARE_RAVEN_DMCU);
--- a/drivers/gpu/drm/amd/include/amd_shared.h~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/include/amd_shared.h
@@ -46,10 +46,7 @@ enum amd_apu_flags {
 	AMD_APU_IS_PICASSO = 0x00000004UL,
 	AMD_APU_IS_RENOIR = 0x00000008UL,
 	AMD_APU_IS_GREEN_SARDINE = 0x00000010UL,
-<<<<<<< HEAD
-=======
 	AMD_APU_IS_VANGOGH = 0x00000020UL,
->>>>>>> linux-next/akpm-base
 };
 
 /**
--- a/drivers/gpu/drm/i915/display/intel_psr.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/display/intel_psr.c
@@ -1865,43 +1865,3 @@ bool intel_psr_enabled(struct intel_dp *
 
 	return ret;
 }
-<<<<<<< HEAD
-
-void intel_psr_atomic_check(struct drm_connector *connector,
-			    struct drm_connector_state *old_state,
-			    struct drm_connector_state *new_state)
-{
-	struct drm_i915_private *dev_priv = to_i915(connector->dev);
-	struct intel_connector *intel_connector;
-	struct intel_digital_port *dig_port;
-	struct drm_crtc_state *crtc_state;
-
-	if (!CAN_PSR(dev_priv) || !new_state->crtc ||
-	    !dev_priv->psr.force_mode_changed)
-		return;
-
-	intel_connector = to_intel_connector(connector);
-	dig_port = enc_to_dig_port(to_intel_encoder(new_state->best_encoder));
-	if (dev_priv->psr.dp != &dig_port->dp)
-		return;
-
-	crtc_state = drm_atomic_get_new_crtc_state(new_state->state,
-						   new_state->crtc);
-	crtc_state->mode_changed = true;
-}
-
-void intel_psr_set_force_mode_changed(struct intel_dp *intel_dp)
-{
-	struct drm_i915_private *dev_priv;
-
-	if (!intel_dp)
-		return;
-
-	dev_priv = dp_to_i915(intel_dp);
-	if (!CAN_PSR(dev_priv) || intel_dp != dev_priv->psr.dp)
-		return;
-
-	dev_priv->psr.force_mode_changed = true;
-}
-=======
->>>>>>> linux-next/akpm-base
--- a/drivers/net/ethernet/ibm/ibmvnic.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1850,15 +1850,11 @@ static int do_reset(struct ibmvnic_adapt
 	netdev_dbg(adapter->netdev, "Re-setting driver (%d)\n",
 		   rwi->reset_reason);
 
-<<<<<<< HEAD
-	rtnl_lock();
-=======
 	adapter->reset_reason = rwi->reset_reason;
 	/* requestor of VNIC_RESET_CHANGE_PARAM already has the rtnl lock */
 	if (!(adapter->reset_reason == VNIC_RESET_CHANGE_PARAM))
 		rtnl_lock();
 
->>>>>>> linux-next/akpm-base
 	/*
 	 * Now that we have the rtnl lock, clear any pending failover.
 	 * This will ensure ibmvnic_open() has either completed or will
@@ -2161,14 +2157,7 @@ static void __ibmvnic_reset(struct work_
 		}
 		spin_unlock_irqrestore(&adapter->state_lock, flags);
 
-<<<<<<< HEAD
-		if (rwi->reset_reason == VNIC_RESET_CHANGE_PARAM) {
-			/* CHANGE_PARAM requestor holds rtnl_lock */
-			rc = do_change_param_reset(adapter, rwi, reset_state);
-		} else if (adapter->force_reset_recovery) {
-=======
 		if (adapter->force_reset_recovery) {
->>>>>>> linux-next/akpm-base
 			/*
 			 * Since we are doing a hard reset now, clear the
 			 * failover_pending flag so we don't ignore any
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

