From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-jz4740-use-devm_ioremap_resource.patch removed
 from -mm tree
Date: Fri, 04 Apr 2014 12:35:10 -0700
Message-ID: <533f096e.uqPPCOUi20MRn/aS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbaDDTfK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:35:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lars@metafoo.de, jg1.han@samsung.com

Subject: [merged] rtc-rtc-jz4740-use-devm_ioremap_resource.patch removed from -mm tree
To: jg1.han@samsung.com,lars@metafoo.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:35:10 -0700


The patch titled
     Subject: rtc: rtc-jz4740: use devm_ioremap_resource()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-jz4740-use-devm_ioremap_resource.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-jz4740: use devm_ioremap_resource()

Use devm_ioremap_resource() in order to make the code simpler, and move
'struct resource *mem' from 'struct jz4740_rtc' to jz4740_rtc_probe()
because the 'mem' variable is used only in jz4740_rtc_probe().  Also the
redundant return value check of platform_get_resource() is removed,
because the value is checked by devm_ioremap_resource().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-jz4740.c |   25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff -puN drivers/rtc/rtc-jz4740.c~rtc-rtc-jz4740-use-devm_ioremap_resource drivers/rtc/rtc-jz4740.c
--- a/drivers/rtc/rtc-jz4740.c~rtc-rtc-jz4740-use-devm_ioremap_resource
+++ a/drivers/rtc/rtc-jz4740.c
@@ -38,7 +38,6 @@
 #define JZ_RTC_CTRL_ENABLE	BIT(0)
 
 struct jz4740_rtc {
-	struct resource *mem;
 	void __iomem *base;
 
 	struct rtc_device *rtc;
@@ -216,6 +215,7 @@ static int jz4740_rtc_probe(struct platf
 	int ret;
 	struct jz4740_rtc *rtc;
 	uint32_t scratchpad;
+	struct resource *mem;
 
 	rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
 	if (!rtc)
@@ -227,25 +227,10 @@ static int jz4740_rtc_probe(struct platf
 		return -ENOENT;
 	}
 
-	rtc->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!rtc->mem) {
-		dev_err(&pdev->dev, "Failed to get platform mmio memory\n");
-		return -ENOENT;
-	}
-
-	rtc->mem = devm_request_mem_region(&pdev->dev, rtc->mem->start,
-					resource_size(rtc->mem), pdev->name);
-	if (!rtc->mem) {
-		dev_err(&pdev->dev, "Failed to request mmio memory region\n");
-		return -EBUSY;
-	}
