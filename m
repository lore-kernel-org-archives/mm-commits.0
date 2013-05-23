From: akpm@linux-foundation.org
Subject: +
 drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths.patch added
 to -mm tree
Date: Thu, 23 May 2013 16:27:26 -0700
Message-ID: <519ea5de.uNvpR1wwna+BHqrC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50928 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759888Ab3EWX11 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 May 2013 19:27:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, libo.chen@huawei.com, james.hogan@imgtec.com, dwmw2@infradead.org, davidb@codeaurora.org, clbchenlibo.chen@huawei.com

Subject: + drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths.patch added to -mm tree
To: clbchenlibo.chen@huawei.com,davidb@codeaurora.org,dwmw2@infradead.org,james.hogan@imgtec.com,libo.chen@huawei.com
From: akpm@linux-foundation.org
Date: Thu, 23 May 2013 16:27:26 -0700


The patch titled
     Subject: drivers/iommu/msm_iommu_dev.c: fix leak and clean up error paths
has been added to the -mm tree.  Its filename is
     drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Libo Chen <clbchenlibo.chen@huawei.com>
Subject: drivers/iommu/msm_iommu_dev.c: fix leak and clean up error paths

Fix two obvious problems:

1. We have registered msm_iommu_driver first, and need unregister it
   when registered msm_iommu_ctx_driver fail

2. We don`t need to kfree drvdata before kzalloc successful.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
Acked-by: David Brown <davidb@codeaurora.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/msm_iommu_dev.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/iommu/msm_iommu_dev.c~drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths drivers/iommu/msm_iommu_dev.c
--- a/drivers/iommu/msm_iommu_dev.c~drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths
+++ a/drivers/iommu/msm_iommu_dev.c
@@ -292,22 +292,20 @@ static int msm_iommu_ctx_probe(struct pl
 	struct msm_iommu_ctx_drvdata *ctx_drvdata = NULL;
 	int i, ret;
 	if (!c || !pdev->dev.parent) {
-		ret = -EINVAL;
-		goto fail;
+		return -EINVAL;
 	}
 
 	drvdata = dev_get_drvdata(pdev->dev.parent);
 
 	if (!drvdata) {
-		ret = -ENODEV;
-		goto fail;
+		return -ENODEV;
 	}
 
 	ctx_drvdata = kzalloc(sizeof(*ctx_drvdata), GFP_KERNEL);
 	if (!ctx_drvdata) {
-		ret = -ENOMEM;
-		goto fail;
+		return -ENOMEM;
 	}
+
 	ctx_drvdata->num = c->num;
 	ctx_drvdata->pdev = pdev;
 
@@ -401,6 +399,7 @@ static int __init msm_iommu_driver_init(
 
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
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
drivers-cdrom-gdromc-fix-device-number-leak.patch

