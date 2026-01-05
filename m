Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7821280A52
	for <mm-commits@vger.kernel.org>; Mon,  5 Jan 2026 21:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767647911; cv=none; b=chph2iaW1Q8JOBuVmyB8CmtW35IfXenAA7Jb7QeNCkcOS/G8DkRTdoaJfi3UNMc3fT3zhaRg+/QeCVtg351aWdmvlv+Li+8lCnw4XpYxnpvov1YDBywTI0UiwBgbIVpwPYkfNb10uYwSPTLV3gQAHNtoOHfh6gHBNZU4MyCjJeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767647911; c=relaxed/simple;
	bh=XxdWaB1UM/lhbz0xqeSlC30mUYtcZ3ru5Va5ZhG5tnQ=;
	h=Date:To:From:Subject:Message-Id; b=cBv+0mAUE/4VowsNvPv7i4h3RwAy0tWLfXbK+IVN2qEpZGVntXtX4wKRvp5w9zac2X024TZL52ofdluKQ4OJlaS/N4hFgluPJnQ6JqWoBDGdVjleo5IFX3YVI3FjcpuVLvVf7ontdWKwVMNIu6CJ1Lhw9gche3IVkaDzXpDaPJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1hnG8wkv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1hnG8wkv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432C0C116D0;
	Mon,  5 Jan 2026 21:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767647911;
	bh=XxdWaB1UM/lhbz0xqeSlC30mUYtcZ3ru5Va5ZhG5tnQ=;
	h=Date:To:From:Subject:From;
	b=1hnG8wkvA4KPtDkzpvGxKim7CI25zWLI0mvz9HfebXvQHHGW5cwOnuX2H/rztT6Li
	 nLjNgKEstlHS0CsEZedSr3aGYOPJ7KOtq5VXdqLhiEnEmlEVscaSgJYQU88D0mKmQy
	 S8s66W3ayxBBd4er8nMXKqzgmc3td7LDjjXJ979E=
Date: Mon, 05 Jan 2026 13:18:30 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vasant.hegde@amd.com,robin.murphy@arm.com,kevin.tian@intel.com,joro@8bytes.org,jgg@ziepe.ca,baolu.lu@linux.intel.com,cmllamas@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + iommu-sva-include-mmu_notifierh-header.patch added to mm-hotfixes-unstable branch
Message-Id: <20260105211831.432C0C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: iommu/sva: include mmu_notifier.h header
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     iommu-sva-include-mmu_notifierh-header.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/iommu-sva-include-mmu_notifierh-header.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

iommu-sva-include-mmu_notifierh-header.patch

