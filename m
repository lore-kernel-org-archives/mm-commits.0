From: akpm@linux-foundation.org
Subject: [merged]
 drivers-iommu-remove-unnecessary-platform_set_drvdata.patch removed from
 -mm tree
Date: Thu, 12 Sep 2013 12:41:17 -0700
Message-ID: <523218dd.xSxuS9XlDgHAczm5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57835 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab3ILTlS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:41:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sboyd@codeaurora.org, s-anna@ti.com, libo.chen@huawei.com, joro@8bytes.org, davidb@codeaurora.org, jg1.han@samsung.com

Subject: [merged] drivers-iommu-remove-unnecessary-platform_set_drvdata.patch removed from -mm tree
To: jg1.han@samsung.com,davidb@codeaurora.org,joro@8bytes.org,libo.chen@huawei.com,s-anna@ti.com,sboyd@codeaurora.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:41:17 -0700


The patch titled
     Subject: drivers/iommu: remove unnecessary platform_set_drvdata()
has been removed from the -mm tree.  Its filename was
     drivers-iommu-remove-unnecessary-platform_set_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/iommu: remove unnecessary platform_set_drvdata()

The driver core clears the driver data to NULL after device_release or on
probe failure.  Thus, it is not needed to manually clear the device driver
data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: David Brown <davidb@codeaurora.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Suman Anna <s-anna@ti.com>
Acked-by: Libo Chen <libo.chen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/msm_iommu_dev.c |    2 --
 drivers/iommu/omap-iommu.c    |    2 --
 2 files changed, 4 deletions(-)

diff -puN drivers/iommu/msm_iommu_dev.c~drivers-iommu-remove-unnecessary-platform_set_drvdata drivers/iommu/msm_iommu_dev.c
--- a/drivers/iommu/msm_iommu_dev.c~drivers-iommu-remove-unnecessary-platform_set_drvdata
+++ a/drivers/iommu/msm_iommu_dev.c
@@ -282,7 +282,6 @@ static int msm_iommu_remove(struct platf
 		clk_put(drv->pclk);
 		memset(drv, 0, sizeof(*drv));
 		kfree(drv);
-		platform_set_drvdata(pdev, NULL);
 	}
 	return 0;
 }
@@ -366,7 +365,6 @@ static int msm_iommu_ctx_remove(struct p
 	if (drv) {
 		memset(drv, 0, sizeof(struct msm_iommu_ctx_drvdata));
 		kfree(drv);
-		platform_set_drvdata(pdev, NULL);
 	}
 	return 0;
 }
diff -puN drivers/iommu/omap-iommu.c~drivers-iommu-remove-unnecessary-platform_set_drvdata drivers/iommu/omap-iommu.c
--- a/drivers/iommu/omap-iommu.c~drivers-iommu-remove-unnecessary-platform_set_drvdata
+++ a/drivers/iommu/omap-iommu.c
@@ -1008,8 +1008,6 @@ static int omap_iommu_remove(struct plat
 	struct resource *res;
 	struct omap_iommu *obj = platform_get_drvdata(pdev);
 
-	platform_set_drvdata(pdev, NULL);
