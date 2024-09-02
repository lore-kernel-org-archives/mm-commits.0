Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B2723BE
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248808; cv=none; b=jkdM+/11kan6GuFxSOs76S55xQb2e4Tw4peevwl35P/0SqylYclbrebwemVOLCU64vk7hnRbnqXWXOcqtbIDY3W7KQh0D5hVyF4MQrA80i/YqgZQ2+RN8UU1jJCWUMGh6hTHZr2//+5Mk/A/sTWrOOg9FHp1a06BtFI6tppfWhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248808; c=relaxed/simple;
	bh=yQLf4S6kNBZN8Mo7wT1nGZOdB5tg+ubyDm/R979Gjjc=;
	h=Date:To:From:Subject:Message-Id; b=oE23yDnh56iTC/1PwnGtew+hx91KE+lpNbVm1ZRPoY6R7jH9cWPDMNw7HPcgBCHPWhE92rT18r3ZhnBHWVPf1FfxMcIg6kdB92JWp8FwJWm0lsnzK3Vju6zT9ItGTrZI/mKF92aOib9Xc0BUicaJtX2bZYHy7mJf5LCTa+PicP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DtLhRHBM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DtLhRHBM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD61C4CEC2;
	Mon,  2 Sep 2024 03:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248807;
	bh=yQLf4S6kNBZN8Mo7wT1nGZOdB5tg+ubyDm/R979Gjjc=;
	h=Date:To:From:Subject:From;
	b=DtLhRHBMKLpZnkGH0RTQPJTnTxXV9yJRkhpdrSwkF9Aq6ZfZ7oUZXtgcqit1XApXj
	 rqpLS4jjobPSoihC0faNWOrJSOY5a7ZRCXUtFhAK1hoxxj5jei/GQ1dXewustB9MHI
	 pxdLBtK7kYJiLWiFQq8IPdQwaugBcrZscOUfGkrU=
Date: Sun, 01 Sep 2024 20:46:47 -0700
To: mm-commits@vger.kernel.org,thomas.hellstrom@linux.intel.com,sfr@canb.auug.org.au,rodrigo.vivi@intel.com,robdclark@gmail.com,quic_abhinavk@quicinc.com,lucas.demarchi@intel.com,himal.prasad.ghimiray@intel.com,dmitry.baryshkov@linaro.org,akinobu.mita@gmail.com,jani.nikula@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fault-inject-improve-build-for-config_fault_injection=n.patch removed from -mm tree
Message-Id: <20240902034647.CDD61C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fault-inject: improve build for CONFIG_FAULT_INJECTION=n
has been removed from the -mm tree.  Its filename was
     fault-inject-improve-build-for-config_fault_injection=n.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jani Nikula <jani.nikula@intel.com>
Subject: fault-inject: improve build for CONFIG_FAULT_INJECTION=n
Date: Tue, 13 Aug 2024 15:12:35 +0300

The fault-inject.h users across the kernel need to add a lot of #ifdef
CONFIG_FAULT_INJECTION to cater for shortcomings in the header.  Make
fault-inject.h self-contained for CONFIG_FAULT_INJECTION=n, and add stubs
for DECLARE_FAULT_ATTR(), setup_fault_attr(), should_fail_ex(), and
should_fail() to allow removal of conditional compilation.

[akpm@linux-foundation.org: repair fallout from no longer including debugfs.h into fault-inject.h]
[akpm@linux-foundation.org: fix drivers/misc/xilinx_tmr_inject.c]
[akpm@linux-foundation.org: Add debugfs.h inclusion to more files, per Stephen]
Link: https://lkml.kernel.org/r/20240813121237.2382534-1-jani.nikula@intel.com
Fixes: 6ff1cb355e62 ("[PATCH] fault-injection capabilities infrastructure")
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/msm/msm_drv.c          |    1 
 drivers/iommu/iommufd/selftest.c       |    1 
 drivers/misc/xilinx_tmr_inject.c       |    1 
 drivers/nvme/host/fault_inject.c       |    1 
 drivers/ufs/core/ufs-fault-injection.c |    1 
 include/linux/fault-inject.h           |   36 ++++++++++++++++++-----
 include/linux/mmc/host.h               |    1 
 include/ufs/ufshcd.h                   |    1 
 kernel/futex/core.c                    |    1 
 lib/fault-inject.c                     |    1 
 mm/fail_page_alloc.c                   |    1 
 mm/failslab.c                          |    1 
 12 files changed, 40 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/msm/msm_drv.c~fault-inject-improve-build-for-config_fault_injection=n
+++ a/drivers/gpu/drm/msm/msm_drv.c
@@ -7,6 +7,7 @@
 
 #include <linux/dma-mapping.h>
 #include <linux/fault-inject.h>
+#include <linux/debugfs.h>
 #include <linux/of_address.h>
 #include <linux/uaccess.h>
 
--- a/drivers/iommu/iommufd/selftest.c~fault-inject-improve-build-for-config_fault_injection=n
+++ a/drivers/iommu/iommufd/selftest.c
@@ -7,6 +7,7 @@
 #include <linux/iommu.h>
 #include <linux/xarray.h>
 #include <linux/file.h>
+#include <linux/debugfs.h>
 #include <linux/anon_inodes.h>
 #include <linux/fault-inject.h>
 #include <linux/platform_device.h>
--- a/drivers/misc/xilinx_tmr_inject.c~fault-inject-improve-build-for-config_fault_injection=n
+++ a/drivers/misc/xilinx_tmr_inject.c
@@ -12,6 +12,7 @@
 #include <asm/xilinx_mb_manager.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/debugfs.h>
 #include <linux/platform_device.h>
 #include <linux/fault-inject.h>
 
--- a/drivers/nvme/host/fault_inject.c~fault-inject-improve-build-for-config_fault_injection=n
+++ a/drivers/nvme/host/fault_inject.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/moduleparam.h>
+#include <linux/debugfs.h>
 #include "nvme.h"
 
 static DECLARE_FAULT_ATTR(fail_default_attr);
--- a/drivers/ufs/core/ufs-fault-injection.c~fault-inject-improve-build-for-config_fault_injection=n
+++ a/drivers/ufs/core/ufs-fault-injection.c
@@ -3,6 +3,7 @@
 #include <linux/kconfig.h>
 #include <linux/types.h>
 #include <linux/fault-inject.h>
+#include <linux/debugfs.h>
 #include <linux/module.h>
 #include <ufs/ufshcd.h>
 #include "ufs-fault-injection.h"
--- a/include/linux/fault-inject.h~fault-inject-improve-build-for-config_fault_injection=n
+++ a/include/linux/fault-inject.h
@@ -2,13 +2,17 @@
 #ifndef _LINUX_FAULT_INJECT_H
 #define _LINUX_FAULT_INJECT_H
 
+#include <linux/err.h>
+#include <linux/types.h>
+
+struct dentry;
+struct kmem_cache;
+
 #ifdef CONFIG_FAULT_INJECTION
 
-#include <linux/types.h>
-#include <linux/debugfs.h>
+#include <linux/atomic.h>
 #include <linux/configfs.h>
 #include <linux/ratelimit.h>
-#include <linux/atomic.h>
 
 /*
  * For explanation of the elements of this struct, see
@@ -51,6 +55,28 @@ int setup_fault_attr(struct fault_attr *
 bool should_fail_ex(struct fault_attr *attr, ssize_t size, int flags);
 bool should_fail(struct fault_attr *attr, ssize_t size);
 
+#else /* CONFIG_FAULT_INJECTION */
+
+struct fault_attr {
+};
+
+#define DECLARE_FAULT_ATTR(name) struct fault_attr name = {}
+
+static inline int setup_fault_attr(struct fault_attr *attr, char *str)
+{
+	return 0; /* Note: 0 means error for __setup() handlers! */
+}
+static inline bool should_fail_ex(struct fault_attr *attr, ssize_t size, int flags)
+{
+	return false;
+}
+static inline bool should_fail(struct fault_attr *attr, ssize_t size)
+{
+	return false;
+}
+
+#endif /* CONFIG_FAULT_INJECTION */
+
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
 
 struct dentry *fault_create_debugfs_attr(const char *name,
@@ -87,10 +113,6 @@ static inline void fault_config_init(str
 
 #endif /* CONFIG_FAULT_INJECTION_CONFIGFS */
 
-#endif /* CONFIG_FAULT_INJECTION */
-
-struct kmem_cache;
-
 #ifdef CONFIG_FAIL_PAGE_ALLOC
 bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order);
 #else
--- a/include/linux/mmc/host.h~fault-inject-improve-build-for-config_fault_injection=n
+++ a/include/linux/mmc/host.h
@@ -10,6 +10,7 @@
 #include <linux/sched.h>
 #include <linux/device.h>
 #include <linux/fault-inject.h>
+#include <linux/debugfs.h>
 
 #include <linux/mmc/core.h>
 #include <linux/mmc/card.h>
--- a/include/ufs/ufshcd.h~fault-inject-improve-build-for-config_fault_injection=n
+++ a/include/ufs/ufshcd.h
@@ -17,6 +17,7 @@
 #include <linux/blk-mq.h>
 #include <linux/devfreq.h>
 #include <linux/fault-inject.h>
+#include <linux/debugfs.h>
 #include <linux/msi.h>
 #include <linux/pm_runtime.h>
 #include <linux/dma-direction.h>
--- a/kernel/futex/core.c~fault-inject-improve-build-for-config_fault_injection=n
+++ a/kernel/futex/core.c
@@ -34,6 +34,7 @@
 #include <linux/compat.h>
 #include <linux/jhash.h>
 #include <linux/pagemap.h>
+#include <linux/debugfs.h>
 #include <linux/plist.h>
 #include <linux/memblock.h>
 #include <linux/fault-inject.h>
--- a/lib/fault-inject.c~fault-inject-improve-build-for-config_fault_injection=n
+++ a/lib/fault-inject.c
@@ -2,6 +2,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/random.h>
+#include <linux/debugfs.h>
 #include <linux/sched.h>
 #include <linux/stat.h>
 #include <linux/types.h>
--- a/mm/fail_page_alloc.c~fault-inject-improve-build-for-config_fault_injection=n
+++ a/mm/fail_page_alloc.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/fault-inject.h>
+#include <linux/debugfs.h>
 #include <linux/error-injection.h>
 #include <linux/mm.h>
 
--- a/mm/failslab.c~fault-inject-improve-build-for-config_fault_injection=n
+++ a/mm/failslab.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/fault-inject.h>
 #include <linux/error-injection.h>
+#include <linux/debugfs.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include "slab.h"
_

Patches currently in -mm which might be from jani.nikula@intel.com are


