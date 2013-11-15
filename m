From: akpm@linux-foundation.org
Subject: [merged] iommu-arm-smmu-handle-pgtable_page_ctor-fail.patch
 removed from -mm tree
Date: Fri, 15 Nov 2013 12:08:44 -0800
Message-ID: <52867f4c.G0FppSJV5qz+Uy6F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35736 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab3KOUIp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:08:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, rob.herring@calxeda.com, grant.likely@linaro.org, kirill.shutemov@linux.intel.com

Subject: [merged] iommu-arm-smmu-handle-pgtable_page_ctor-fail.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,grant.likely@linaro.org,rob.herring@calxeda.com,will.deacon@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:08:44 -0800


The patch titled
     Subject: iommu/arm-smmu: handle pgtable_page_ctor() fail
has been removed from the -mm tree.  Its filename was
     iommu-arm-smmu-handle-pgtable_page_ctor-fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: iommu/arm-smmu: handle pgtable_page_ctor() fail

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/arm-smmu.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/iommu/arm-smmu.c~iommu-arm-smmu-handle-pgtable_page_ctor-fail drivers/iommu/arm-smmu.c
--- a/drivers/iommu/arm-smmu.c~iommu-arm-smmu-handle-pgtable_page_ctor-fail
+++ a/drivers/iommu/arm-smmu.c
@@ -1212,7 +1212,10 @@ static int arm_smmu_alloc_init_pte(struc
 
 		arm_smmu_flush_pgtable(smmu, page_address(table),
 				       ARM_SMMU_PTE_HWTABLE_SIZE);
-		pgtable_page_ctor(table);
+		if (!pgtable_page_ctor(table)) {
+			__free_page(table);
+			return -ENOMEM;
+		}
 		pmd_populate(NULL, pmd, table);
 		arm_smmu_flush_pgtable(smmu, pmd, sizeof(*pmd));
 	}
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

