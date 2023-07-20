Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53314EB64DA
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jul 2023 17:09:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjGTRJD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jul 2023 13:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjGTRJC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jul 2023 13:09:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E652AA
        for <mm-commits@vger.kernel.org>; Thu, 20 Jul 2023 10:09:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C99561B8C
        for <mm-commits@vger.kernel.org>; Thu, 20 Jul 2023 17:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84603C433C8;
        Thu, 20 Jul 2023 17:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689872940;
        bh=MUchKfPM3Vw9Rd3n+WSJo5Uk7lU/ICAMm5UnaWFKYVE=;
        h=Date:To:From:Subject:From;
        b=paq76Ji2xqPEYZXjKHdl8ookukE5i2lqeOav0V+UgVHQ6/KqIo3QrswXC1gMguc1I
         sdFR/faC94l1SY+A3bwgTzvEeBZS2T8fzTesJU6D0dmhlamdxyYxoLRRHZKbVBe1u9
         TSgTJkjPaZ6FhZEtB0C3j3ghtWlZALBXKe7BJ9Yw=
Date:   Thu, 20 Jul 2023 10:08:59 -0700
To:     mm-commits@vger.kernel.org, zhi.wang.linux@gmail.com,
        will@kernel.org, sj@kernel.org, seanjc@google.com,
        robin.murphy@arm.com, npiggin@gmail.com, nicolinc@nvidia.com,
        mpe@ellerman.id.au, kevin.tian@intel.com, jhubbard@nvidia.com,
        jgg@ziepe.ca, jgg@nvidia.com, fbarrat@linux.ibm.com,
        catalin.marinas@arm.com, ajd@linux.ibm.com, apopple@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-smmu-use-tlbi-asid-when-invalidating-entire-range.patch added to mm-unstable branch
Message-Id: <20230720170900.84603C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64/smmu: use TLBI ASID when invalidating entire range
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-smmu-use-tlbi-asid-when-invalidating-entire-range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-smmu-use-tlbi-asid-when-invalidating-entire-range.patch

This patch will later appear in the mm-unstable branch at
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
From: Alistair Popple <apopple@nvidia.com>
Subject: arm64/smmu: use TLBI ASID when invalidating entire range
Date: Thu, 20 Jul 2023 18:39:23 +1000

Patch series "Invalidate secondary IOMMU TLB on permission upgrade", v3.

The main change is to move secondary TLB invalidation mmu notifier
callbacks into the architecture specific TLB flushing functions.  This
makes secondary TLB invalidation mostly match CPU invalidation while still
allowing efficient range based invalidations based on the existing TLB
batching code.


This patch (of 5):

The ARM SMMU has a specific command for invalidating the TLB for an entire
ASID.  Currently this is used for the IO_PGTABLE API but not for ATS when
called from the MMU notifier.

The current implementation of notifiers does not attempt to invalidate
such a large address range, instead walking each VMA and invalidating each
range individually during mmap removal.  However in future SMMU TLB
invalidations are going to be sent as part of the normal flush_tlb_*()
kernel calls.  To better deal with that add handling to use TLBI ASID when
invalidating the entire address space.

Link: https://lkml.kernel.org/r/cover.b24362332ec6099bc8db4e8e06a67545c653291d.1689842332.git-series.apopple@nvidia.com
Link: https://lkml.kernel.org/r/082390057ec33969c81d49d35aa3024d7082b0bd.1689842332.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Frederic Barrat <fbarrat@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Zhi Wang <zhi.wang.linux@gmail.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c |   16 +++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c~arm64-smmu-use-tlbi-asid-when-invalidating-entire-range
+++ a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -200,10 +200,20 @@ static void arm_smmu_mm_invalidate_range
 	 * range. So do a simple translation here by calculating size correctly.
 	 */
 	size = end - start;
+	if (size == ULONG_MAX)
+		size = 0;
+
+	if (!(smmu_domain->smmu->features & ARM_SMMU_FEAT_BTM)) {
+		if (!size)
+			arm_smmu_tlb_inv_asid(smmu_domain->smmu,
+					      smmu_mn->cd->asid);
+		else
+			arm_smmu_tlb_inv_range_asid(start, size,
+						    smmu_mn->cd->asid,
+						    PAGE_SIZE, false,
+						    smmu_domain);
+	}
 
-	if (!(smmu_domain->smmu->features & ARM_SMMU_FEAT_BTM))
-		arm_smmu_tlb_inv_range_asid(start, size, smmu_mn->cd->asid,
-					    PAGE_SIZE, false, smmu_domain);
 	arm_smmu_atc_inv_domain(smmu_domain, mm->pasid, start, size);
 }
 
_

Patches currently in -mm which might be from apopple@nvidia.com are

arm64-smmu-use-tlbi-asid-when-invalidating-entire-range.patch
mmu_notifiers-fixup-comment-in-mmu_interval_read_begin.patch
mmu_notifiers-call-invalidate_range-when-invalidating-tlbs.patch
mmu_notifiers-dont-invalidate-secondary-tlbs-as-part-of-mmu_notifier_invalidate_range_end.patch
mmu_notifiers-rename-invalidate_range-notifier.patch

