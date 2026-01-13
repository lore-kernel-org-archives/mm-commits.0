Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2301930CD87
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 05:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768280992; cv=none; b=WdpPPcCoCa2OFByHGcTtQ5C0q4tIPshShnG1Q5abtQVaao2QS3UgRQJ5OztmTBhnx/WLSRM6YyqIajmHRCqJ9Mv98qcGC1C4i+PXIVrDwpuo5VXYkI5JOPpy7d/Pth3qFQHqGVE4VZcB+SXeu6WoJgzI+P6jsSc9g6rLts/yV7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768280992; c=relaxed/simple;
	bh=tm46xQ+NVvrwXTybkJ++6FH6mwAaipC2OOCTG+qcKQE=;
	h=Date:To:From:Subject:Message-Id; b=UWAxZstMPqcvsNib+GDT9nwINf2djF1vJJ0HuMTak52QPnTIfM92Bqyth3rzWH2SLu3HUFaL65rSwxQnxvUMzSjcGSpAyCXVMN+Mavtc68pCLUPUf+nY0OiwSH5CXI+ssChgzRoeZ26uiRjCHoqz7/JUDlHf4lybxo2dNPb8474=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aHxv0BB6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aHxv0BB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5000C116C6;
	Tue, 13 Jan 2026 05:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768280991;
	bh=tm46xQ+NVvrwXTybkJ++6FH6mwAaipC2OOCTG+qcKQE=;
	h=Date:To:From:Subject:From;
	b=aHxv0BB6tL4fghBrqP5ZA9U1/aOVdQWdCtSE9btkUSXY9sfFQdFjsJ+OQd8bdS90m
	 SRWi0X0Ylx5gu7FCUYjVj3yjdyA5DiDdb3B11UDtVm2GMv3cU1FjX7yUEnof8jzq+H
	 bzmS9R7PIFKL+3HRW4US6PL4w47SOLHvdNUG2LGg=
Date: Mon, 12 Jan 2026 21:09:51 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vasant.hegde@amd.com,robin.murphy@arm.com,kevin.tian@intel.com,joro@8bytes.org,jgg@ziepe.ca,baolu.lu@linux.intel.com,cmllamas@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] iommu-sva-include-mmu_notifierh-header.patch removed from -mm tree
Message-Id: <20260113050951.C5000C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: iommu/sva: include mmu_notifier.h header
has been removed from the -mm tree.  Its filename was
     iommu-sva-include-mmu_notifierh-header.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Carlos Llamas <cmllamas@google.com>
Subject: iommu/sva: include mmu_notifier.h header
Date: Mon, 5 Jan 2026 19:07:46 +0000

A call to mmu_notifier_arch_invalidate_secondary_tlbs() was introduced in
commit e37d5a2d60a3 ("iommu/sva: invalidate stale IOTLB entries for kernel
address space") but without explicitly adding its corresponding header
file <linux/mmu_notifier.h>.  This was evidenced while trying to enable
compile testing support for IOMMU_SVA:

   config IOMMU_SVA
          select IOMMU_MM_DATA
  -       bool
  +       bool "Shared Virtual Addressing" if COMPILE_TEST

The thing is for certain architectures this header file is indirectly
included via <asm/tlbflush.h>.  However, for others such as 32-bit arm the
header is missing and it results in a build failure:

  $ make ARCH=arm allmodconfig
  [...]
  drivers/iommu/iommu-sva.c:340:3: error: call to undeclared function 'mmu_notifier_arch_invalidate_secondary_tlbs' [...]
    340 |  mmu_notifier_arch_invalidate_secondary_tlbs(iommu_mm->mm, start, end);
        |  ^

Fix this by including the appropriate header file.

Link: https://lkml.kernel.org/r/20260105190747.625082-1-cmllamas@google.com
Fixes: e37d5a2d60a3 ("iommu/sva: invalidate stale IOTLB entries for kernel address space")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Cc: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Vasant Hegde <vasant.hegde@amd.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/iommu-sva.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iommu/iommu-sva.c~iommu-sva-include-mmu_notifierh-header
+++ a/drivers/iommu/iommu-sva.c
@@ -3,6 +3,7 @@
  * Helpers for IOMMU drivers implementing SVA
  */
 #include <linux/mmu_context.h>
+#include <linux/mmu_notifier.h>
 #include <linux/mutex.h>
 #include <linux/sched/mm.h>
 #include <linux/iommu.h>
_

Patches currently in -mm which might be from cmllamas@google.com are


