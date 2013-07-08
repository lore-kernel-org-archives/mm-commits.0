From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-coh901331-use-platform_getset_drvdata.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:33:38 -0700
Message-ID: <51db1412.qjhwQMVaxwsfNr16%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51238 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab3GHTdj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:33:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] rtc-rtc-coh901331-use-platform_getset_drvdata.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:33:38 -0700


The patch titled
     Subject: rtc: rtc-coh901331: use platform_{get,set}_drvdata()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-coh901331-use-platform_getset_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-coh901331: use platform_{get,set}_drvdata()

Use the wrapper functions for getting and setting the driver data using
platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
so we can directly pass a struct platform_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-coh901331.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-coh901331.c~rtc-rtc-coh901331-use-platform_getset_drvdata drivers/rtc/rtc-coh901331.c
--- a/drivers/rtc/rtc-coh901331.c~rtc-rtc-coh901331-use-platform_getset_drvdata
+++ a/drivers/rtc/rtc-coh901331.c
@@ -152,7 +152,7 @@ static struct rtc_class_ops coh901331_op
 
 static int __exit coh901331_remove(struct platform_device *pdev)
 {
-	struct coh901331_port *rtap = dev_get_drvdata(&pdev->dev);
+	struct coh901331_port *rtap = platform_get_drvdata(pdev);
 
 	if (rtap)
 		clk_unprepare(rtap->clk);
@@ -264,7 +264,7 @@ static SIMPLE_DEV_PM_OPS(coh901331_pm_op
 
 static void coh901331_shutdown(struct platform_device *pdev)
 {
-	struct coh901331_port *rtap = dev_get_drvdata(&pdev->dev);
+	struct coh901331_port *rtap = platform_get_drvdata(pdev);
 
 	clk_enable(rtap->clk);
 	writel(0, rtap->virtbase + COH901331_IRQ_MASK);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

