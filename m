From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-mpc5121c-use-platform_getset_drvdata.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:34:52 -0700
Message-ID: <51db145c./nMmR/U13a0t8JZg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab3GHTew (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:34:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rob.herring@calxeda.com, grant.likely@linaro.org, jg1.han@samsung.com

Subject: [merged] drivers-rtc-rtc-mpc5121c-use-platform_getset_drvdata.patch removed from -mm tree
To: jg1.han@samsung.com,grant.likely@linaro.org,rob.herring@calxeda.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:34:52 -0700


The patch titled
     Subject: drivers/rtc/rtc-mpc5121.c: use platform_{get,set}_drvdata()
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-mpc5121c-use-platform_getset_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/rtc/rtc-mpc5121.c: use platform_{get,set}_drvdata()

Use the wrapper functions for getting and setting the driver data using
platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
so we can directly pass a struct platform_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mpc5121.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-mpc5121.c~drivers-rtc-rtc-mpc5121c-use-platform_getset_drvdata drivers/rtc/rtc-mpc5121.c
--- a/drivers/rtc/rtc-mpc5121.c~drivers-rtc-rtc-mpc5121c-use-platform_getset_drvdata
+++ a/drivers/rtc/rtc-mpc5121.c
@@ -324,7 +324,7 @@ static int mpc5121_rtc_probe(struct plat
 
 	device_init_wakeup(&op->dev, 1);
 
-	dev_set_drvdata(&op->dev, rtc);
+	platform_set_drvdata(op, rtc);
 
 	rtc->irq = irq_of_parse_and_map(op->dev.of_node, 1);
 	err = request_irq(rtc->irq, mpc5121_rtc_handler, 0,
@@ -382,7 +382,7 @@ out_dispose:
 
 static int mpc5121_rtc_remove(struct platform_device *op)
 {
-	struct mpc5121_rtc_data *rtc = dev_get_drvdata(&op->dev);
+	struct mpc5121_rtc_data *rtc = platform_get_drvdata(op);
 	struct mpc5121_rtc_regs __iomem *regs = rtc->regs;
 
 	/* disable interrupt, so there are no nasty surprises */
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

