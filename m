Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DAC9C433C1
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:27:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D61B76191C
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:27:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhC1W0r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 18:26:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229656AbhC1W0k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 18:26:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A257961927;
        Sun, 28 Mar 2021 22:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616970399;
        bh=FDzHX535cA77p6rj390zWrBvynBHrEvqxQPV/dkROeo=;
        h=Date:From:To:Subject:From;
        b=yvY8VwSqh1i+9YYF0oyDIHgZ0gP12kGrHSYGqQutxVyB0nYmJV1B/W85I5uJRaiDg
         wp7z+ye+fR5pS1moyy+poGJTzh3Du3X9iXS6TYju0v8tkuiR4/OLUKbqrZKPmnfkN9
         6X768PIHqAkvvSII8O5W7sqQBP78U+hvYwx8itT4=
Date:   Sun, 28 Mar 2021 15:26:39 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20210328222639.7VArY6KIh%akpm@linux-foundation.org>
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

 arch/arm/mach-omap2/sr_device.c                       |    6 ------
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                   |    3 ---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c            |    3 ---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c               |   10 ----------
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c   |    4 ----
 drivers/gpu/drm/i915/display/intel_dp_link_training.c |    4 ----
 6 files changed, 30 deletions(-)

--- a/arch/arm/mach-omap2/sr_device.c~linux-next-git-rejects
+++ a/arch/arm/mach-omap2/sr_device.c
@@ -152,10 +152,7 @@ exit:
 	return 0;
 }
 
-<<<<<<< HEAD
-=======
 #ifdef CONFIG_OMAP_HWMOD
->>>>>>> linux-next/akpm-base
 static int __init sr_dev_init(struct omap_hwmod *oh, void *user)
 {
 	struct omap_smartreflex_dev_attr *sr_dev_attr;
@@ -169,15 +166,12 @@ static int __init sr_dev_init(struct oma
 
 	return sr_init_by_name(oh->name, sr_dev_attr->sensor_voltdm_name);
 }
-<<<<<<< HEAD
-=======
 #else
 static int __init sr_dev_init(struct omap_hwmod *oh, void *user)
 {
 	return -EINVAL;
 }
 #endif
->>>>>>> linux-next/akpm-base
 
 /*
  * API to be called from board files to enable smartreflex
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2750,8 +2750,6 @@ static int amdgpu_device_ip_suspend_phas
 			continue;
 		}
 
-<<<<<<< HEAD
-=======
 		/* skip unnecessary suspend if we do not initialize them yet */
 		if (adev->gmc.xgmi.pending_reset &&
 		    !(adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GMC ||
@@ -2762,7 +2760,6 @@ static int amdgpu_device_ip_suspend_phas
 			continue;
 		}
 
->>>>>>> linux-next/akpm-base
 		/* skip suspend of gfx and psp for S0ix
 		 * gfx is in gfxoff state, so on resume it will exit gfxoff just
 		 * like at runtime. PSP is also part of the always on hardware
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1426,7 +1426,6 @@ static int amdgpu_pmops_suspend(struct d
 	struct drm_device *drm_dev = dev_get_drvdata(dev);
 	struct amdgpu_device *adev = drm_to_adev(drm_dev);
 	int r;
-<<<<<<< HEAD
 
 	if (amdgpu_acpi_is_s0ix_supported(adev))
 		adev->in_s0ix = true;
@@ -1434,15 +1433,6 @@ static int amdgpu_pmops_suspend(struct d
 	r = amdgpu_device_suspend(drm_dev, true);
 	adev->in_s3 = false;
 
-=======
-
-	if (amdgpu_acpi_is_s0ix_supported(adev))
-		adev->in_s0ix = true;
-	adev->in_s3 = true;
-	r = amdgpu_device_suspend(drm_dev, true);
-	adev->in_s3 = false;
-
->>>>>>> linux-next/akpm-base
 	return r;
 }
 
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1032,15 +1032,12 @@ struct amdgpu_device {
 	bool				in_s3;
 	bool				in_s4;
 	bool				in_s0ix;
-<<<<<<< HEAD
-=======
 
 	/*
 	 * The combination flag in_poweroff_reboot_com used to identify the poweroff
 	 * and reboot opt in the s0i3 system-wide suspend.
 	 */
 	bool 				in_poweroff_reboot_com;
->>>>>>> linux-next/akpm-base
 
 	atomic_t 			in_gpu_reset;
 	enum pp_mp1_state               mp1_state;
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
@@ -1300,11 +1300,7 @@ static int smu7_start_dpm(struct pp_hwmg
 				(0 == smum_send_msg_to_smc(hwmgr,
 						PPSMC_MSG_PCIeDPM_Disable,
 						NULL)),
-<<<<<<< HEAD
-				"Failed to disble pcie DPM during DPM Start Function!",
-=======
 				"Failed to disable pcie DPM during DPM Start Function!",
->>>>>>> linux-next/akpm-base
 				return -EINVAL);
 	}
 
--- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
@@ -101,11 +101,7 @@ static bool intel_dp_read_lttpr_common_c
 	 * Detecting LTTPRs must be avoided on platforms with an AUX timeout
 	 * period < 3.2ms. (see DP Standard v2.0, 2.11.2, 3.6.6.1).
 	 */
-<<<<<<< HEAD
-	if (INTEL_GEN(i915) < 10)
-=======
 	if (DISPLAY_VER(i915) < 10)
->>>>>>> linux-next/akpm-base
 		return false;
 
 	if (drm_dp_read_lttpr_common_caps(&intel_dp->aux,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-gup-check-page-posion-status-for-coredump-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
kasan-remove-redundant-config-option-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch

