Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1235EB64DC
	for <mm-commits@archiver.kernel.org>; Tue, 18 Jul 2023 18:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjGRSXr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Jul 2023 14:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjGRSXc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jul 2023 14:23:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DAD610FE
        for <mm-commits@vger.kernel.org>; Tue, 18 Jul 2023 11:23:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C63F61522
        for <mm-commits@vger.kernel.org>; Tue, 18 Jul 2023 18:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68B5C433C8;
        Tue, 18 Jul 2023 18:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689704588;
        bh=4ibUp2zRektvGvUIQePTFrcvrGkjDtUc5ThmCWe7SuY=;
        h=Date:To:From:Subject:From;
        b=CfIKs1DYliK34nQuQaImoCU4KQHfHqktGmFlMKr5m8yxHXTxqdVz8U2KE+jP2Lfz8
         Hg83kzGaqDmucydZW+xaYFMNW2GpEHY/xuBAPzwUfulufGXI1l0ErbzgeLD9F7rNRB
         20QIVHrhegWqCIH4DWW603iI6HKOyONDP+L5//5U=
Date:   Tue, 18 Jul 2023 11:23:08 -0700
To:     mm-commits@vger.kernel.org, zhi.wang.linux@gmail.com,
        will@kernel.org, seanjc@google.com, robin.murphy@arm.com,
        npiggin@gmail.com, nicolinc@nvidia.com, mpe@ellerman.id.au,
        kevin.tian@intel.com, jhubbard@nvidia.com, jgg@ziepe.ca,
        jgg@nvidia.com, fbarrat@linux.ibm.com, catalin.marinas@arm.com,
        ajd@linux.ibm.com, apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-smmu-use-tlbi-asid-when-invalidating-entire-range.patch added to mm-unstable branch
Message-Id: <20230718182308.C68B5C433C8@smtp.kernel.org>
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
Date: Tue, 18 Jul 2023 17:56:16 +1000

The ARM SMMU has a specific command for invalidating the TLB for an entire
ASID.  Currently this is used for the IO_PGTABLE API but not for ATS when
called from the MMU notifier.

The current implementation of notifiers does not attempt to invalidate
such a large address range, instead walking each VMA and invalidating each
range individually during mmap removal.  However in future SMMU TLB
invalidations are going to be sent as part of the normal flush_tlb_*()
kernel calls.  To better deal with that add handling to use TLBI ASID when
invalidating the entire address space.

Link: https://lkml.kernel.org/r/b29f31c8cbdb2b7d90443eae522a88218eb639ee.1689666760.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Frederic Barrat <fbarrat@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zhi Wang <zhi.wang.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c |   16 +++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c~arm64-smmu-use-tlbi-asid-when-invalidating-entire-range
+++ a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -201,10 +201,20 @@ static void arm_smmu_mm_arch_invalidate_
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

mm_notifiers-rename-invalidate_range-notifier.patch
arm64-smmu-use-tlbi-asid-when-invalidating-entire-range.patch
mmu_notifiers-call-arch_invalidate_secondary_tlbs-when-invalidating-tlbs.patch
mmu_notifiers-dont-invalidate-secondary-tlbs-as-part-of-mmu_notifier_invalidate_range_end.patch

