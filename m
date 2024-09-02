Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072E8144D0A
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248812; cv=none; b=HLIswOZDKDfCRz1S2O6acn6OemfwE27dUjADc98WiramzhqJe7ruulUhFPf9JDx9dxo6JUCTZ6Zb8LeLhtd2J02cA+cY/gYnpqgM+xMRdYR6XtSBMOIh5CcQLf5DtHEH2zQOM/QDgiieNwnrVhEE58UDic0l++IA9UiNOvkSf98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248812; c=relaxed/simple;
	bh=68F1vtSvzTo4gRx0fCeQxrBUKv+Blf8jnNvROr9kfY0=;
	h=Date:To:From:Subject:Message-Id; b=mg5O5844JOt0IHA2T8IiwKExVAUFpHqJmCGh3teT8/thY9nIObuNqmVlv+tbhLPvkgXi1EVwHhlnrEChsRGX7syv3RGKmynLCiGW7NfTrZLU1taUuZfLbtpRqGX9spxdK2cHp7JuewyIqUMhbgUZJ2nlbREQRA/y8f4ip9BP7+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pTDtaB1U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pTDtaB1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D139FC4CEC2;
	Mon,  2 Sep 2024 03:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248811;
	bh=68F1vtSvzTo4gRx0fCeQxrBUKv+Blf8jnNvROr9kfY0=;
	h=Date:To:From:Subject:From;
	b=pTDtaB1UI2s6Zw+dgafnGPpAFzVRLcDc+uAzJGJNTZWPsNjv70QLxTC6GZtiIX1aC
	 jJ4xjAUGVbB2wMrzSEWWzPuVuTgSnYnO3XgS7OcNqamEz9W8rTgh+HvBZsXyS+Char
	 eG95YDpHlltrmZbpDHcuuwOuG3F0bFF8NQLEd76M=
Date: Sun, 01 Sep 2024 20:46:51 -0700
To: mm-commits@vger.kernel.org,thomas.hellstrom@linux.intel.com,rodrigo.vivi@intel.com,robdclark@gmail.com,quic_abhinavk@quicinc.com,lucas.demarchi@intel.com,himal.prasad.ghimiray@intel.com,dmitry.baryshkov@linaro.org,akinobu.mita@gmail.com,jani.nikula@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] drm-xe-clean-up-fault-injection-usage.patch removed from -mm tree
Message-Id: <20240902034651.D139FC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drm/xe: clean up fault injection usage
has been removed from the -mm tree.  Its filename was
     drm-xe-clean-up-fault-injection-usage.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jani Nikula <jani.nikula@intel.com>
Subject: drm/xe: clean up fault injection usage
Date: Tue, 13 Aug 2024 15:12:37 +0300

With the proper stubs in place in linux/fault-inject.h, we can remove a
bunch of conditional compilation for CONFIG_FAULT_INJECTION=n.

Link: https://lkml.kernel.org/r/20240813121237.2382534-3-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Rob Clark <robdclark@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/xe/xe_debugfs.c |    7 +------
 drivers/gpu/drm/xe/xe_gt.h      |   10 ++--------
 2 files changed, 3 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/xe/xe_debugfs.c~drm-xe-clean-up-fault-injection-usage
+++ a/drivers/gpu/drm/xe/xe_debugfs.c
@@ -6,6 +6,7 @@
 #include "xe_debugfs.h"
 
 #include <linux/debugfs.h>
+#include <linux/fault-inject.h>
 #include <linux/string_helpers.h>
 
 #include <drm/drm_debugfs.h>
@@ -26,10 +27,7 @@
 #include "xe_vm.h"
 #endif
 
-#ifdef CONFIG_FAULT_INJECTION
-#include <linux/fault-inject.h> /* XXX: fault-inject.h is broken */
 DECLARE_FAULT_ATTR(gt_reset_failure);
-#endif
 
 static struct xe_device *node_to_xe(struct drm_info_node *node)
 {
@@ -214,8 +212,5 @@ void xe_debugfs_register(struct xe_devic
 	for_each_gt(gt, xe, id)
 		xe_gt_debugfs_register(gt);
 
-#ifdef CONFIG_FAULT_INJECTION
 	fault_create_debugfs_attr("fail_gt_reset", root, &gt_reset_failure);
-#endif
-
 }
--- a/drivers/gpu/drm/xe/xe_gt.h~drm-xe-clean-up-fault-injection-usage
+++ a/drivers/gpu/drm/xe/xe_gt.h
@@ -6,6 +6,8 @@
 #ifndef _XE_GT_H_
 #define _XE_GT_H_
 
+#include <linux/fault-inject.h>
+
 #include <drm/drm_util.h>
 
 #include "xe_device.h"
@@ -19,19 +21,11 @@
 
 #define CCS_MASK(gt) (((gt)->info.engine_mask & XE_HW_ENGINE_CCS_MASK) >> XE_HW_ENGINE_CCS0)
 
-#ifdef CONFIG_FAULT_INJECTION
-#include <linux/fault-inject.h> /* XXX: fault-inject.h is broken */
 extern struct fault_attr gt_reset_failure;
 static inline bool xe_fault_inject_gt_reset(void)
 {
 	return should_fail(&gt_reset_failure, 1);
 }
-#else
-static inline bool xe_fault_inject_gt_reset(void)
-{
-	return false;
-}
-#endif
 
 struct xe_gt *xe_gt_alloc(struct xe_tile *tile);
 int xe_gt_init_hwconfig(struct xe_gt *gt);
_

Patches currently in -mm which might be from jani.nikula@intel.com are


