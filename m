Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CA97E107
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248358; cv=none; b=LnzVQla9g/HDXv49mkAaSOYkou56eBbCiIuXy2jjgzzmiSBS20wVpQxpkzynvu5NEBA1yfE8XvRFbsHyu8ZDPY0wOAxd3fvicv161MKCHHhUpudD8gNMXjVREqqo6PliJybXu5sUFjXfOi0tUiqPelF8pSKxN+nBAS740Eqjbxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248358; c=relaxed/simple;
	bh=HEVzNDxqhUmr6I627IS9l3f+tMjvO/ABmxrSorFYUHs=;
	h=Date:To:From:Subject:Message-Id; b=IRWjd4MViOPRx4r2vkyQ8k7JZTqRsQQztvCwDzCRv4Lk6V3BWy6ByAMb5kXunQ+uP254BsXEARU6rpvF4jLjiwybK3NQ6OPmP6a884gx/Pa1ZPKjpxM9NpktkXlytR19jMTk9AV1eN11kq1OuyZIkFITFML0/0XG5Op22Oqd29s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DJd6hDAR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DJd6hDAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B982C4CEC2;
	Mon,  2 Sep 2024 03:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248358;
	bh=HEVzNDxqhUmr6I627IS9l3f+tMjvO/ABmxrSorFYUHs=;
	h=Date:To:From:Subject:From;
	b=DJd6hDARVnXZoLkvrdbwfGFi+V6AvCZ5l5yP0gAPiFMm3xuR4M72CWw69aRka8XZN
	 R1XknSZ/3pAIhjQCBz3ybBJxSZDpXhBFWaaCMWliBsymFvkfKpP0kQmKBN5AqihGwv
	 rYmcvggwnEMkjtEGEEfW7feea9JSbIANTkSCkcCE=
Date: Sun, 01 Sep 2024 20:39:18 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,jani.nikula@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fault-inject-improve-build-for-config_fault_injection=n-fix-3.patch removed from -mm tree
Message-Id: <20240902033918.9B982C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fault-inject-improve-build-for-config_fault_injection=n-fix-3
has been removed from the -mm tree.  Its filename was
     fault-inject-improve-build-for-config_fault_injection=n-fix-3.patch

This patch was dropped because it was folded into fault-inject-improve-build-for-config_fault_injection=n.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fault-inject-improve-build-for-config_fault_injection=n-fix-3
Date: Thu Aug 15 03:54:55 PM PDT 2024

Add debugfs.h inclusion to more files, per Stephen

Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/msm/msm_drv.c          |    1 +
 drivers/ufs/core/ufs-fault-injection.c |    1 +
 include/linux/mmc/host.h               |    1 +
 include/ufs/ufshcd.h                   |    1 +
 4 files changed, 4 insertions(+)

--- a/drivers/gpu/drm/msm/msm_drv.c~fault-inject-improve-build-for-config_fault_injection=n-fix-3
+++ a/drivers/gpu/drm/msm/msm_drv.c
@@ -7,6 +7,7 @@
 
 #include <linux/dma-mapping.h>
 #include <linux/fault-inject.h>
+#include <linux/debugfs.h>
 #include <linux/of_address.h>
 #include <linux/uaccess.h>
 
--- a/drivers/ufs/core/ufs-fault-injection.c~fault-inject-improve-build-for-config_fault_injection=n-fix-3
+++ a/drivers/ufs/core/ufs-fault-injection.c
@@ -3,6 +3,7 @@
 #include <linux/kconfig.h>
 #include <linux/types.h>
 #include <linux/fault-inject.h>
+#include <linux/debugfs.h>
 #include <linux/module.h>
 #include <ufs/ufshcd.h>
 #include "ufs-fault-injection.h"
--- a/include/linux/mmc/host.h~fault-inject-improve-build-for-config_fault_injection=n-fix-3
+++ a/include/linux/mmc/host.h
@@ -10,6 +10,7 @@
 #include <linux/sched.h>
 #include <linux/device.h>
 #include <linux/fault-inject.h>
+#include <linux/debugfs.h>
 
 #include <linux/mmc/core.h>
 #include <linux/mmc/card.h>
--- a/include/ufs/ufshcd.h~fault-inject-improve-build-for-config_fault_injection=n-fix-3
+++ a/include/ufs/ufshcd.h
@@ -17,6 +17,7 @@
 #include <linux/blk-mq.h>
 #include <linux/devfreq.h>
 #include <linux/fault-inject.h>
+#include <linux/debugfs.h>
 #include <linux/msi.h>
 #include <linux/pm_runtime.h>
 #include <linux/dma-direction.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-contig_alloc-support-__gfp_comp-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix-fix.patch
mm-remove-pageactive-fix.patch
selftests-test_zswap-add-test-for-hierarchical-zswapwriteback-fix.patch
mm-count-the-number-of-anonymous-thps-per-size-fix.patch
mm-memory-failure-add-unmap_poisoned_folio-fix.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix-fix.patch
lib-maple_treec-remove-unused-functions.patch
fault-inject-improve-build-for-config_fault_injection=n.patch

