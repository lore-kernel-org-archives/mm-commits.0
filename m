From: akpm@linux-foundation.org
Subject: [folded-merged]
 drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 15:25:42 -0700
Message-ID: <51db3c66.05Iq/n96AdfZFnXq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53007 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab3GHWZn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 18:25:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, libo.chen@huawei.com, james.hogan@imgtec.com, dwmw2@infradead.org, davidb@codeaurora.org, clbchenlibo.chen@huawei.com, akpm@linux-foundation.org

Subject: [folded-merged] drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,clbchenlibo.chen@huawei.com,davidb@codeaurora.org,dwmw2@infradead.org,james.hogan@imgtec.com,libo.chen@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 15:25:42 -0700


The patch titled
     Subject: drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix
has been removed from the -mm tree.  Its filename was
     drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch

This patch was dropped because it was folded into drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix

remove now-unneeded initialization of ctx_drvdata, remove unneeded braces

Cc: David Brown <davidb@codeaurora.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: Libo Chen <libo.chen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/msm_iommu_dev.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN drivers/iommu/msm_iommu_dev.c~drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix drivers/iommu/msm_iommu_dev.c
--- a/drivers/iommu/msm_iommu_dev.c~drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix
+++ a/drivers/iommu/msm_iommu_dev.c
@@ -291,22 +291,19 @@ static int msm_iommu_ctx_probe(struct pl
 {
 	struct msm_iommu_ctx_dev *c = pdev->dev.platform_data;
 	struct msm_iommu_drvdata *drvdata;
-	struct msm_iommu_ctx_drvdata *ctx_drvdata = NULL;
+	struct msm_iommu_ctx_drvdata *ctx_drvdata;
 	int i, ret;
-	if (!c || !pdev->dev.parent) {
+
+	if (!c || !pdev->dev.parent)
 		return -EINVAL;
-	}
 
 	drvdata = dev_get_drvdata(pdev->dev.parent);
-
-	if (!drvdata) {
+	if (!drvdata)
 		return -ENODEV;
-	}
 
 	ctx_drvdata = kzalloc(sizeof(*ctx_drvdata), GFP_KERNEL);
-	if (!ctx_drvdata) {
+	if (!ctx_drvdata)
 		return -ENOMEM;
-	}
 
 	ctx_drvdata->num = c->num;
 	ctx_drvdata->pdev = pdev;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2-fix.patch
memcg-use-css_get-put-when-charging-uncharging-kmem-fix.patch
memcg-use-css_get-put-when-charging-uncharging-kmem-fix-fix-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation-checkpatch-fixes.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch

