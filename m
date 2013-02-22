From: akpm@linux-foundation.org
Subject: [merged] video-exynos_dp-add-missing-of_node_put.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:38:46 -0800
Message-ID: <20130222203846.AA1855A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:48969 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125Ab3BVUir (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:38:47 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so103720vbi.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:38:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, FlorianSchandinat@gmx.de, ajaykumar.rs@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: video: exynos_dp: add missing of_node_put()
has been removed from the -mm tree.  Its filename was
     video-exynos_dp-add-missing-of_node_put.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: video: exynos_dp: add missing of_node_put()

of_find_node_by_name() returns a node pointer with refcount incremented,
use of_node_put() on it when done.

of_find_node_by_name() will call of_node_put() against the node pass to
from parameter, thus we also need to call of_node_get(from) before calling
of_find_node_by_name().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Ajay Kumar <ajaykumar.rs@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/exynos/exynos_dp_core.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff -puN drivers/video/exynos/exynos_dp_core.c~video-exynos_dp-add-missing-of_node_put drivers/video/exynos/exynos_dp_core.c
--- a/drivers/video/exynos/exynos_dp_core.c~video-exynos_dp-add-missing-of_node_put
+++ a/drivers/video/exynos/exynos_dp_core.c
@@ -965,10 +965,11 @@ static struct exynos_dp_platdata *exynos
 
 static int exynos_dp_dt_parse_phydata(struct exynos_dp_device *dp)
 {
-	struct device_node *dp_phy_node;
+	struct device_node *dp_phy_node = of_node_get(dp->dev->of_node);
 	u32 phy_base;
+	int ret = 0;
 
-	dp_phy_node = of_find_node_by_name(dp->dev->of_node, "dptx-phy");
+	dp_phy_node = of_find_node_by_name(dp_phy_node, "dptx-phy");
 	if (!dp_phy_node) {
 		dev_err(dp->dev, "could not find dptx-phy node\n");
 		return -ENODEV;
@@ -976,22 +977,28 @@ static int exynos_dp_dt_parse_phydata(st
 
 	if (of_property_read_u32(dp_phy_node, "reg", &phy_base)) {
 		dev_err(dp->dev, "faild to get reg for dptx-phy\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
 	if (of_property_read_u32(dp_phy_node, "samsung,enable-mask",
 				&dp->enable_mask)) {
 		dev_err(dp->dev, "faild to get enable-mask for dptx-phy\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
 	dp->phy_addr = ioremap(phy_base, SZ_4);
 	if (!dp->phy_addr) {
 		dev_err(dp->dev, "failed to ioremap dp-phy\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err;
 	}
 
-	return 0;
+err:
+	of_node_put(dp_phy_node);
+
+	return ret;
 }
 
 static void exynos_dp_phy_init(struct exynos_dp_device *dp)
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

