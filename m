Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94270339A0
	for <mm-commits@vger.kernel.org>; Wed, 14 Aug 2024 03:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723605085; cv=none; b=F1jvtqS739T2sV6/E8o5IQZ19n8jrzesi9tOb9wx6zLHuEp2UGRQlUq+PjJMLfHUnGIxQ2Ag0h+tLSekB3Ey7+RYTgUivbfPhXuJ1ZX0y/V+UzJk7dYMEi6ujfIR84nkvZ0oq/8in2Nr4+ngFEXG3a0Cpw/HTE5lHpzMq1QkaS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723605085; c=relaxed/simple;
	bh=AHYUYJ4dZKUoP4OMnVmCfVj0n8tYR6OQasscAtB2HbA=;
	h=Date:To:From:Subject:Message-Id; b=bP28AdBvejQdwPVsDkoLNjhsF4PV1jmkHx0P+aTOPttcQ1HWMUiFGf1PVOrOBGVUUt51A6ddrUWehL6fkkWtSeMJJ+oZ9DMa8AQ3IzhCKApi1IY3cAkxwQSyA4DmtZu21SRiE6/zHe0bj9M+oM8ZkgIWJnIiRh4wzDj3VxQK4qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XJMmMu3Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XJMmMu3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F666C32782;
	Wed, 14 Aug 2024 03:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723605084;
	bh=AHYUYJ4dZKUoP4OMnVmCfVj0n8tYR6OQasscAtB2HbA=;
	h=Date:To:From:Subject:From;
	b=XJMmMu3Y+nq863x4hGh6a0slZIErP7/iYg4ajaUF6+t6lnqyZYh2eJWi5UQSCKtTg
	 Hs0XgF1ZH5au09PsOWn0zvRnNVmjfg6CnYsebOaq6bj7U8oghl3BklB3q0XQ7LoWzE
	 UvGsj5rr1eQZAfudIVAXb4I0oP78ww+RRh04/GMo=
Date: Tue, 13 Aug 2024 20:11:23 -0700
To: mm-commits@vger.kernel.org,thomas.hellstrom@linux.intel.com,rodrigo.vivi@intel.com,robdclark@gmail.com,quic_abhinavk@quicinc.com,lucas.demarchi@intel.com,jani.nikula@intel.com,himal.prasad.ghimiray@intel.com,dmitry.baryshkov@linaro.org,akinobu.mita@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fault-inject-improve-build-for-config_fault_injection=n-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20240814031124.1F666C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fault-inject-improve-build-for-config_fault_injection=n-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fault-inject-improve-build-for-config_fault_injection=n-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fault-inject-improve-build-for-config_fault_injection=n-fix.patch

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
--- a/mm/fail_page_alloc.c~fault-inject-improve-build-for-config_fault_injection=n-fix
+++ a/mm/fail_page_alloc.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/fault-inject.h>
+#include <linux/debugfs.h>
 #include <linux/error-injection.h>
 #include <linux/mm.h>
 
--- a/drivers/nvme/host/fault_inject.c~fault-inject-improve-build-for-config_fault_injection=n-fix
+++ a/drivers/nvme/host/fault_inject.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/moduleparam.h>
+#include <linux/debugfs.h>
 #include "nvme.h"
 
 static DECLARE_FAULT_ATTR(fail_default_attr);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-mmzoneh-clean-up-watermark-accessors.patch
mm-support-large-folios-swap-in-for-zram-like-devices-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix.patch

