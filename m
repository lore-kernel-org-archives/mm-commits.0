From: akpm@linux-foundation.org
Subject: [merged]
 drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths.patch
 removed from -mm tree
Date: Tue, 09 Jul 2013 16:19:20 -0700
Message-ID: <51dc9a78.GAo8AyLaIx4H0kMG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38787 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab3GIXTV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:19:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, libo.chen@huawei.com, james.hogan@imgtec.com, dwmw2@infradead.org, davidb@codeaurora.org, clbchenlibo.chen@huawei.com

Subject: [merged] drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths.patch removed from -mm tree
To: clbchenlibo.chen@huawei.com,davidb@codeaurora.org,dwmw2@infradead.org,james.hogan@imgtec.com,libo.chen@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:19:20 -0700


The patch titled
     Subject: drivers/iommu/msm_iommu_dev.c: fix leak and clean up error paths
has been removed from the -mm tree.  Its filename was
     drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Libo Chen <clbchenlibo.chen@huawei.com>
Subject: drivers/iommu/msm_iommu_dev.c: fix leak and clean up error paths

Fix two obvious problems:

1. We have registered msm_iommu_driver first, and need unregister it
   when registered msm_iommu_ctx_driver fail

2. We don't need to kfree drvdata before kzalloc was successful.

[akpm@linux-foundation.org: remove now-unneeded initialization of ctx_drvdata, remove unneeded braces]
Signed-off-by: Libo Chen <libo.chen@huawei.com>
Acked-by: David Brown <davidb@codeaurora.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/msm_iommu_dev.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff -puN drivers/iommu/msm_iommu_dev.c~drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths drivers/iommu/msm_iommu_dev.c
--- a/drivers/iommu/msm_iommu_dev.c~drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths
+++ a/drivers/iommu/msm_iommu_dev.c
@@ -291,25 +291,20 @@ static int msm_iommu_ctx_probe(struct pl
 {
 	struct msm_iommu_ctx_dev *c = pdev->dev.platform_data;
 	struct msm_iommu_drvdata *drvdata;
-	struct msm_iommu_ctx_drvdata *ctx_drvdata = NULL;
+	struct msm_iommu_ctx_drvdata *ctx_drvdata;
 	int i, ret;
-	if (!c || !pdev->dev.parent) {
-		ret = -EINVAL;
-		goto fail;
-	}
 
-	drvdata = dev_get_drvdata(pdev->dev.parent);
+	if (!c || !pdev->dev.parent)
+		return -EINVAL;
 
-	if (!drvdata) {
-		ret = -ENODEV;
-		goto fail;
-	}
+	drvdata = dev_get_drvdata(pdev->dev.parent);
+	if (!drvdata)
+		return -ENODEV;
 
 	ctx_drvdata = kzalloc(sizeof(*ctx_drvdata), GFP_KERNEL);
-	if (!ctx_drvdata) {
-		ret = -ENOMEM;
-		goto fail;
-	}
+	if (!ctx_drvdata)
+		return -ENOMEM;
+
 	ctx_drvdata->num = c->num;
 	ctx_drvdata->pdev = pdev;
 
@@ -403,6 +398,7 @@ static int __init msm_iommu_driver_init(
 
 	ret = platform_driver_register(&msm_iommu_ctx_driver);
 	if (ret != 0) {
+		platform_driver_unregister(&msm_iommu_driver);
 		pr_err("Failed to register IOMMU context driver\n");
 		goto error;
 	}
_

Patches currently in -mm which might be from clbchenlibo.chen@huawei.com are

origin.patch
linux-next.patch
drivers-ide-delkin_cb-convert-to-module_pci_driver.patch
drivers-atm-he-convert-to-module_pci_driver.patch
drivers-scsi-a100u2w-convert-to-module_pci_driver.patch
drivers-scsi-dc395x-convert-to-module_pci_driver.patch
drivers-scsi-dmx3191d-convert-to-module_pci_driver.patch
drivers-scsi-initio-convert-to-module_pci_driver.patch
drivers-scsi-mvumi-convert-to-module_pci_driver.patch
drivers-net-irda-donauboe-convert-to-module_pci_driver.patch

