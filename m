From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-davinci-use-devm_ioremap_resource.patch removed
 from -mm tree
Date: Fri, 04 Apr 2014 12:35:06 -0700
Message-ID: <533f096a.xphvFze6NAMl1vlJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43509 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbaDDTfG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:35:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, khilman@linaro.org, jg1.han@samsung.com

Subject: [merged] rtc-rtc-davinci-use-devm_ioremap_resource.patch removed from -mm tree
To: jg1.han@samsung.com,khilman@linaro.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:35:06 -0700


The patch titled
     Subject: rtc: rtc-davinci: use devm_ioremap_resource()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-davinci-use-devm_ioremap_resource.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-davinci: use devm_ioremap_resource()

Use devm_ioremap_resource() in order to make the code simpler, and remove
redundant return value check of platform_get_resource() because the value
is checked by devm_ioremap_resource().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-davinci.c |   29 ++++-------------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

diff -puN drivers/rtc/rtc-davinci.c~rtc-rtc-davinci-use-devm_ioremap_resource drivers/rtc/rtc-davinci.c
--- a/drivers/rtc/rtc-davinci.c~rtc-rtc-davinci-use-devm_ioremap_resource
+++ a/drivers/rtc/rtc-davinci.c
@@ -119,8 +119,6 @@ static DEFINE_SPINLOCK(davinci_rtc_lock)
 struct davinci_rtc {
 	struct rtc_device		*rtc;
 	void __iomem			*base;
-	resource_size_t			pbase;
-	size_t				base_size;
 	int				irq;
 };
 
@@ -482,7 +480,7 @@ static int __init davinci_rtc_probe(stru
 {
 	struct device *dev = &pdev->dev;
 	struct davinci_rtc *davinci_rtc;
-	struct resource *res, *mem;
+	struct resource *res;
 	int ret = 0;
 
 	davinci_rtc = devm_kzalloc(&pdev->dev, sizeof(struct davinci_rtc), GFP_KERNEL);
@@ -496,28 +494,9 @@ static int __init davinci_rtc_probe(stru
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(dev, "no mem resource\n");
-		return -EINVAL;
-	}
-
-	davinci_rtc->pbase = res->start;
-	davinci_rtc->base_size = resource_size(res);
-
-	mem = devm_request_mem_region(dev, davinci_rtc->pbase,
-				davinci_rtc->base_size, pdev->name);
-	if (!mem) {
-		dev_err(dev, "RTC registers at %08x are not free\n",
-			davinci_rtc->pbase);
-		return -EBUSY;
-	}
