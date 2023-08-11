Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5AF6C41513
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236631AbjHKXFo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236748AbjHKXD5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:03:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6BC4491
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B25363F1F
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC20C433CA;
        Fri, 11 Aug 2023 23:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794924;
        bh=2LpnUiSj2B/+lHOJEjUzDUa34CRPdj7I+F7stJKF100=;
        h=Date:To:From:Subject:From;
        b=KL8l4PK4Yi9CQhaA5mHZ52dAAG3Eyi8oLVpxj8c9aSqfyIqazJOJyClExZDkcmesx
         ol41+a2Bvaaci/yIMjzsXy6UJdOSsbH/O1Be1e8m4+kWCimtEITo3dH7+vbeeRqFIP
         /WRHgG0TKHsc9yXBIKP1D/p2HEQnGDhDFmwpZmc8=
Date:   Fri, 11 Aug 2023 16:02:04 -0700
To:     mm-commits@vger.kernel.org, zhi.wang.linux@gmail.com,
        will@kernel.org, tvrtko.ursulin@linux.intel.com, sj@kernel.org,
        seanjc@google.com, robin.murphy@arm.com, npiggin@gmail.com,
        nicolinc@nvidia.com, mpe@ellerman.id.au, kevin.tian@intel.com,
        jhubbard@nvidia.com, jgg@ziepe.ca, jgg@nvidia.com,
        fbarrat@linux.ibm.com, chaitanya.kumar.borah@intel.com,
        catalin.marinas@arm.com, ajd@linux.ibm.com, apopple@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-smmu-use-tlbi-asid-when-invalidating-entire-range.patch removed from -mm tree
Message-Id: <20230811230204.ACC20C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm64/smmu: use TLBI ASID when invalidating entire range
has been removed from the -mm tree.  Its filename was
     arm64-smmu-use-tlbi-asid-when-invalidating-entire-range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: arm64/smmu: use TLBI ASID when invalidating entire range
Date: Tue, 25 Jul 2023 23:42:03 +1000

Patch series "Invalidate secondary IOMMU TLB on permission upgrade", v4.

The main change is to move secondary TLB invalidation mmu notifier
callbacks into the architecture specific TLB flushing functions. This
makes secondary TLB invalidation mostly match CPU invalidation while
still allowing efficient range based invalidations based on the
existing TLB batching code.


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

Link: https://lkml.kernel.org/r/cover.1eca029b8603ef4eebe5b41eae51facfc5920c41.1690292440.git-series.apopple@nvidia.com
Link: https://lkml.kernel.org/r/ba5f0ec5fbc2ab188797524d3687e075e2412a2b.1690292440.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Cc: Frederic Barrat <fbarrat@linux.ibm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zhi Wang <zhi.wang.linux@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: SeongJae Park <sj@kernel.org>
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


