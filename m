Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C0E1BF53
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 18:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723575154; cv=none; b=Pw9M4T4Kia9f1/5EAam4Ud6ahEP7V0l0l+FwsHR5x9J1E5Ltr5Kkdfbi8wTFYaFK6BBvRsN+fTLSleHRTlDXuu1I0e240/Y2iG78sW6vzYBZGNw7UYZjAqLPxhQjWocIyxtpu/VocLM4WMx+7yFAQb5CeHK8EyuI2qwUNAXSgBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723575154; c=relaxed/simple;
	bh=zgaTP5jpBL8mPE4x7DScZIX+HRi1zIrdq0G6JIpP9b4=;
	h=Date:To:From:Subject:Message-Id; b=BSJIeoXbh0Qj6+UibC5YMh/afegswhyu1Brx92YubEhFMVOaD+gWeIssgnDKIl4faYqiSmsiMMfQTGJ5ELuwW6ZFZRRFexVHCicurJQh2ywGOMad2Y0V53JKfVGwzXzgp98hKDcVqWn6EDphw9W5fGUOjz5pvc3gm0SmoDklyic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1h3LoEUt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1h3LoEUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B935C32782;
	Tue, 13 Aug 2024 18:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723575153;
	bh=zgaTP5jpBL8mPE4x7DScZIX+HRi1zIrdq0G6JIpP9b4=;
	h=Date:To:From:Subject:From;
	b=1h3LoEUt/fFiIdlodg3CV93G1EgMshtSJ39COLHoKH1/y/Gv7rz1t0r4qk1YzC5Wu
	 PIEM6QmnhubhQ9bFlZbdId+CDRpmRk3si4RQO1A/ewD/Z5sYNJ6cuVAtJweQKv5yAs
	 XT9x+FmPolVqw6q6BQcKTxYvLC/KOZffKIKd8ZYQ=
Date: Tue, 13 Aug 2024 11:52:32 -0700
To: mm-commits@vger.kernel.org,thomas.hellstrom@linux.intel.com,rodrigo.vivi@intel.com,robdclark@gmail.com,quic_abhinavk@quicinc.com,lucas.demarchi@intel.com,himal.prasad.ghimiray@intel.com,dmitry.baryshkov@linaro.org,akinobu.mita@gmail.com,jani.nikula@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drm-msm-clean-up-fault-injection-usage.patch added to mm-nonmm-unstable branch
Message-Id: <20240813185233.8B935C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drm/msm: clean up fault injection usage
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     drm-msm-clean-up-fault-injection-usage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drm-msm-clean-up-fault-injection-usage.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jani Nikula <jani.nikula@intel.com>
Subject: drm/msm: clean up fault injection usage
Date: Tue, 13 Aug 2024 15:12:36 +0300

With the proper stubs in place in linux/fault-inject.h, we can remove a
bunch of conditional compilation for CONFIG_FAULT_INJECTION=n.

Link: https://lkml.kernel.org/r/20240813121237.2382534-2-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/msm/msm_debugfs.c |    2 --
 drivers/gpu/drm/msm/msm_drv.c     |    2 --
 drivers/gpu/drm/msm/msm_drv.h     |    4 ----
 3 files changed, 8 deletions(-)

--- a/drivers/gpu/drm/msm/msm_debugfs.c~drm-msm-clean-up-fault-injection-usage
+++ a/drivers/gpu/drm/msm/msm_debugfs.c
@@ -357,12 +357,10 @@ void msm_debugfs_init(struct drm_minor *
 	if (priv->kms && priv->kms->funcs->debugfs_init)
 		priv->kms->funcs->debugfs_init(priv->kms, minor);
 
-#ifdef CONFIG_FAULT_INJECTION
 	fault_create_debugfs_attr("fail_gem_alloc", minor->debugfs_root,
 				  &fail_gem_alloc);
 	fault_create_debugfs_attr("fail_gem_iova", minor->debugfs_root,
 				  &fail_gem_iova);
-#endif
 }
 #endif
 
--- a/drivers/gpu/drm/msm/msm_drv.c~drm-msm-clean-up-fault-injection-usage
+++ a/drivers/gpu/drm/msm/msm_drv.c
@@ -58,10 +58,8 @@ static bool modeset = true;
 MODULE_PARM_DESC(modeset, "Use kernel modesetting [KMS] (1=on (default), 0=disable)");
 module_param(modeset, bool, 0600);
 
-#ifdef CONFIG_FAULT_INJECTION
 DECLARE_FAULT_ATTR(fail_gem_alloc);
 DECLARE_FAULT_ATTR(fail_gem_iova);
-#endif
 
 static int msm_drm_uninit(struct device *dev)
 {
--- a/drivers/gpu/drm/msm/msm_drv.h~drm-msm-clean-up-fault-injection-usage
+++ a/drivers/gpu/drm/msm/msm_drv.h
@@ -33,12 +33,8 @@
 #include <drm/msm_drm.h>
 #include <drm/drm_gem.h>
 
-#ifdef CONFIG_FAULT_INJECTION
 extern struct fault_attr fail_gem_alloc;
 extern struct fault_attr fail_gem_iova;
-#else
-#  define should_fail(attr, size) 0
-#endif
 
 struct msm_kms;
 struct msm_gpu;
_

Patches currently in -mm which might be from jani.nikula@intel.com are

fault-inject-improve-build-for-config_fault_injection=n.patch
drm-msm-clean-up-fault-injection-usage.patch
drm-xe-clean-up-fault-injection-usage.patch

