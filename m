Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C9E14B960
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248810; cv=none; b=pwzgNIncb/sjorz+vWZ91zv9KdW8oZ4Tp0chZViQZXLFFNdc8ibnAuXLZvgGay4DHZiDrm5j20oOInqXG41/NPGyYPjMQSRx5zzPNqSqMOncCh8GNxfapyMz0IcbRTJGXSGMhfWIm259g5HkrzNJSOu0YV/XPuvSkwfQeyq3rcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248810; c=relaxed/simple;
	bh=BBNwTqpi6bKR4xKaXvRksRk0SPUs+pfkqDb03cXLw+c=;
	h=Date:To:From:Subject:Message-Id; b=h1cNKMweJjeeBZqIV4TLoXGalx4uDYppoPP+cZv/Koa6hexqvnax2QiQ0Y93Uk+7p/CI50F4jFYemgEpjlsCKwTaQauAf4Bn2J6rNWNM6Bfh9iQ7rc/zx8wncop5tmRsY1faJfZACXajR5n37pyyESWHlBOIrVZ3kAdoDPN8FaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kR5ZnpvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kR5ZnpvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85A2C4CEC2;
	Mon,  2 Sep 2024 03:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248810;
	bh=BBNwTqpi6bKR4xKaXvRksRk0SPUs+pfkqDb03cXLw+c=;
	h=Date:To:From:Subject:From;
	b=kR5ZnpvEkZ5Pv8kb99Un2bFw2XOw2MZkh7rLBfnJyn92XNTd4dLmnXNmFM0e3j+hW
	 YLA8Qeqv5UnZfHkUG2DpcNmD7RoNtaaDI4FDuY8XLDFnjv4Kt+JZwKNSE4v8FCvQT2
	 6S32wPrke5PH67DbHWqb37P1x3kKK2I8voNQjaYs=
Date: Sun, 01 Sep 2024 20:46:50 -0700
To: mm-commits@vger.kernel.org,thomas.hellstrom@linux.intel.com,rodrigo.vivi@intel.com,robdclark@gmail.com,quic_abhinavk@quicinc.com,lucas.demarchi@intel.com,himal.prasad.ghimiray@intel.com,dmitry.baryshkov@linaro.org,akinobu.mita@gmail.com,jani.nikula@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] drm-msm-clean-up-fault-injection-usage.patch removed from -mm tree
Message-Id: <20240902034650.A85A2C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drm/msm: clean up fault injection usage
has been removed from the -mm tree.  Its filename was
     drm-msm-clean-up-fault-injection-usage.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Rob Clark <robdclark@gmail.com>
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
@@ -59,10 +59,8 @@ static bool modeset = true;
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


