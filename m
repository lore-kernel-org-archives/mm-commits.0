Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE8C14A91
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248355; cv=none; b=bqUE30TSykAUHSUKS14orVE4tHWzDcHumcTw0VhZDWw1fOKE+kZgP9+ba+5SS0E62VbVyf16bZ1lq6K2NR6TMsYhtcn6HODjXcPJJexojZddmQGIir4BpN6njHY3CxZQbAwYtrkxgbJk3nna9x0KLnSWC5fu5ikXA9Lks6YnwZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248355; c=relaxed/simple;
	bh=qa2HKAnz5B0lRM9FFqlWZAFRrNg8ISPFmpni58gu1rY=;
	h=Date:To:From:Subject:Message-Id; b=plAEdjH/dBOUSVbQEsvzub2gdHvaIa46OV4you9I8WgRnSbLps5FKfU6j4ST3thrMaKNXS8GxNUCPFsQNe6XSTd4PnD0CxJQG6T1Zd910lQDIVw+HxrQN+Bh7jeK0GDdzyeUyRoH8bQaszFuH/D9+gsh5Kr8xTUs3q7xT+3mAbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pP+/RVCf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pP+/RVCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD35C4CEC2;
	Mon,  2 Sep 2024 03:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248354;
	bh=qa2HKAnz5B0lRM9FFqlWZAFRrNg8ISPFmpni58gu1rY=;
	h=Date:To:From:Subject:From;
	b=pP+/RVCf9OiF1I0nkXoMmwgr1Noum1djCaSqVs0r04j3dXbnYlkKbRx0IDhLe7LtW
	 lzlInXaT0luYm9wSw1Ey2/g3r94g1o81BoU7eoVyd6qYEin+PSN7bquavoKPz/SHVs
	 Cy4aYb2axOo/kOzRqe607VBr83v8tWiVrYLZTRyE=
Date: Sun, 01 Sep 2024 20:39:14 -0700
To: mm-commits@vger.kernel.org,thomas.hellstrom@linux.intel.com,rodrigo.vivi@intel.com,robdclark@gmail.com,quic_abhinavk@quicinc.com,lucas.demarchi@intel.com,jani.nikula@intel.com,himal.prasad.ghimiray@intel.com,dmitry.baryshkov@linaro.org,akinobu.mita@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fault-inject-improve-build-for-config_fault_injection=n-fix.patch removed from -mm tree
Message-Id: <20240902033914.AAD35C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fault-inject-improve-build-for-config_fault_injection=n-fix
has been removed from the -mm tree.  Its filename was
     fault-inject-improve-build-for-config_fault_injection=n-fix.patch

This patch was dropped because it was folded into fault-inject-improve-build-for-config_fault_injection=n.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fault-inject-improve-build-for-config_fault_injection=n-fix
Date: Tue Aug 13 07:20:23 PM PDT 2024

repair fallout from no longer including debugfs.h into fault-inject.h

Cc: Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/iommufd/selftest.c |    1 +
 drivers/nvme/host/fault_inject.c |    1 +
 kernel/futex/core.c              |    1 +
 lib/fault-inject.c               |    1 +
 mm/fail_page_alloc.c             |    1 +
 mm/failslab.c                    |    1 +
 6 files changed, 6 insertions(+)

--- a/drivers/iommu/iommufd/selftest.c~fault-inject-improve-build-for-config_fault_injection=n-fix
+++ a/drivers/iommu/iommufd/selftest.c
@@ -7,6 +7,7 @@
 #include <linux/iommu.h>
 #include <linux/xarray.h>
 #include <linux/file.h>
+#include <linux/debugfs.h>
 #include <linux/anon_inodes.h>
 #include <linux/fault-inject.h>
 #include <linux/platform_device.h>
--- a/drivers/nvme/host/fault_inject.c~fault-inject-improve-build-for-config_fault_injection=n-fix
+++ a/drivers/nvme/host/fault_inject.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/moduleparam.h>
+#include <linux/debugfs.h>
 #include "nvme.h"
 
 static DECLARE_FAULT_ATTR(fail_default_attr);
--- a/kernel/futex/core.c~fault-inject-improve-build-for-config_fault_injection=n-fix
+++ a/kernel/futex/core.c
@@ -34,6 +34,7 @@
 #include <linux/compat.h>
 #include <linux/jhash.h>
 #include <linux/pagemap.h>
+#include <linux/debugfs.h>
 #include <linux/plist.h>
 #include <linux/memblock.h>
 #include <linux/fault-inject.h>
--- a/lib/fault-inject.c~fault-inject-improve-build-for-config_fault_injection=n-fix
+++ a/lib/fault-inject.c
@@ -2,6 +2,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/random.h>
+#include <linux/debugfs.h>
 #include <linux/sched.h>
 #include <linux/stat.h>
 #include <linux/types.h>
--- a/mm/fail_page_alloc.c~fault-inject-improve-build-for-config_fault_injection=n-fix
+++ a/mm/fail_page_alloc.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/fault-inject.h>
+#include <linux/debugfs.h>
 #include <linux/error-injection.h>
 #include <linux/mm.h>
 
--- a/mm/failslab.c~fault-inject-improve-build-for-config_fault_injection=n-fix
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
fault-inject-improve-build-for-config_fault_injection=n-fix-2.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-3.patch

