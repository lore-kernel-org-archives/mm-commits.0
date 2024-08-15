Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D17154BEA
	for <mm-commits@vger.kernel.org>; Thu, 15 Aug 2024 22:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723762607; cv=none; b=XUBIxUkxehQyf01IS5O2aYF17FISVECvgEdoHIJbivCQmDLQhTQZ+ZC4QO8X5soEGSB5bVMBRDmVxWPSN+7NImIeIa3JlXpUoEdP26OU5402NSgs50q+lC1P0Wybuv0OlSijGrxrosuIsjFLZTlfsTQ3K4h94ExwgmoLP9Oa2dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723762607; c=relaxed/simple;
	bh=VBIcim/ntM8LSfSGwLEXNV/RajYV0x7HM/C9cnQywDQ=;
	h=Date:To:From:Subject:Message-Id; b=M06s+LLDOv9CLEPikO4Nq6MLViDY65Rl9w7nylUvslvmHZO8v0HPrU+cbE9eu0XB13v3Xybhkszt6KWQkUruk5vCBOmmBt5iF4+HCX9IwGcqt2j9xC+2+j1SqhMUG2jXXOJIlu2kQIbHtrFfkOcM3h60lyOuwoE0L0bNQasfHBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N5s1dL2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N5s1dL2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF60C4AF09;
	Thu, 15 Aug 2024 22:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723762607;
	bh=VBIcim/ntM8LSfSGwLEXNV/RajYV0x7HM/C9cnQywDQ=;
	h=Date:To:From:Subject:From;
	b=N5s1dL2CwGsEvuUwrtgBVngdeHMnrlxy8pDYLFvMFOGXFVEmw1CGIpDkb1Cq1ZWbx
	 bqE33lZxK5f0Yv4s1le7MgK58nCqgoPYDg8UhxCFCW6W7p/GbY96O6mJ0PREwZseqd
	 ZGQo4xayHj1H2QykfuCUBlS4NqeHOzrH4ZfHkqEQ=
Date: Thu, 15 Aug 2024 15:56:46 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,jani.nikula@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fault-inject-improve-build-for-config_fault_injection=n-fix-3.patch added to mm-nonmm-unstable branch
Message-Id: <20240815225647.6BF60C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fault-inject-improve-build-for-config_fault_injection=n-fix-3
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fault-inject-improve-build-for-config_fault_injection=n-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fault-inject-improve-build-for-config_fault_injection=n-fix-3.patch

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

include-linux-mmzoneh-clean-up-watermark-accessors.patch
mm-support-large-folios-swap-in-for-zram-like-devices-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-2.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-3.patch

