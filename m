From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-coh901331-use-devm_ioremap_resource.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:35:04 -0700
Message-ID: <533f0968.AqTOYD+tBI3e065N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43506 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbaDDTfE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:35:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, linus.walleij@linaro.org, jg1.han@samsung.com

Subject: [merged] rtc-rtc-coh901331-use-devm_ioremap_resource.patch removed from -mm tree
To: jg1.han@samsung.com,linus.walleij@linaro.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:35:04 -0700


The patch titled
     Subject: rtc: rtc-coh901331: use devm_ioremap_resource()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-coh901331-use-devm_ioremap_resource.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-coh901331: use devm_ioremap_resource()

Use devm_ioremap_resource() in order to make the code simpler, and remove
redundant return value check of platform_get_resource() because the value
is checked by devm_ioremap_resource().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-coh901331.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff -puN drivers/rtc/rtc-coh901331.c~rtc-rtc-coh901331-use-devm_ioremap_resource drivers/rtc/rtc-coh901331.c
--- a/drivers/rtc/rtc-coh901331.c~rtc-rtc-coh901331-use-devm_ioremap_resource
+++ a/drivers/rtc/rtc-coh901331.c
@@ -43,8 +43,6 @@
 struct coh901331_port {
 	struct rtc_device *rtc;
 	struct clk *clk;
-	u32 phybase;
-	u32 physize;
 	void __iomem *virtbase;
 	int irq;
 #ifdef CONFIG_PM_SLEEP
@@ -173,19 +171,9 @@ static int __init coh901331_probe(struct
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENOENT;
-
-	rtap->phybase = res->start;
-	rtap->physize = resource_size(res);
-
-	if (devm_request_mem_region(&pdev->dev, rtap->phybase, rtap->physize,
-				    "rtc-coh901331") == NULL)
-		return -EBUSY;
