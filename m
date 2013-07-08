From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-pm8xxx-use-devm_-functions.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:33:30 -0700
Message-ID: <51db140a.NI7yK2LU5CdCFfUj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51236 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab3GHTdh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:33:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] rtc-rtc-pm8xxx-use-devm_-functions.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:33:30 -0700


The patch titled
     Subject: rtc: rtc-pm8xxx: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-pm8xxx-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-pm8xxx: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pm8xxx.c |   27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff -puN drivers/rtc/rtc-pm8xxx.c~rtc-rtc-pm8xxx-use-devm_-functions drivers/rtc/rtc-pm8xxx.c
--- a/drivers/rtc/rtc-pm8xxx.c~rtc-rtc-pm8xxx-use-devm_-functions
+++ a/drivers/rtc/rtc-pm8xxx.c
@@ -395,7 +395,7 @@ static int pm8xxx_rtc_probe(struct platf
 	if (pdata != NULL)
 		rtc_write_enable = pdata->rtc_write_enable;
 
-	rtc_dd = kzalloc(sizeof(*rtc_dd), GFP_KERNEL);
+	rtc_dd = devm_kzalloc(&pdev->dev, sizeof(*rtc_dd), GFP_KERNEL);
 	if (rtc_dd == NULL) {
 		dev_err(&pdev->dev, "Unable to allocate memory!\n");
 		return -ENOMEM;
@@ -407,16 +407,14 @@ static int pm8xxx_rtc_probe(struct platf
 	rtc_dd->rtc_alarm_irq = platform_get_irq(pdev, 0);
 	if (rtc_dd->rtc_alarm_irq < 0) {
 		dev_err(&pdev->dev, "Alarm IRQ resource absent!\n");
-		rc = -ENXIO;
-		goto fail_rtc_enable;
+		return -ENXIO;
 	}
 
 	rtc_resource = platform_get_resource_byname(pdev, IORESOURCE_IO,
 							"pmic_rtc_base");
 	if (!(rtc_resource && rtc_resource->start)) {
 		dev_err(&pdev->dev, "RTC IO resource absent!\n");
-		rc = -ENXIO;
-		goto fail_rtc_enable;
+		return -ENXIO;
 	}
 
 	rtc_dd->rtc_base = rtc_resource->start;
@@ -432,7 +430,7 @@ static int pm8xxx_rtc_probe(struct platf
 	rc = pm8xxx_read_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base, 1);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "RTC control register read failed!\n");
-		goto fail_rtc_enable;
+		return rc;
 	}
 
 	if (!(ctrl_reg & PM8xxx_RTC_ENABLE)) {
@@ -442,7 +440,7 @@ static int pm8xxx_rtc_probe(struct platf
 		if (rc < 0) {
 			dev_err(&pdev->dev, "Write to RTC control register "
 								"failed\n");
-			goto fail_rtc_enable;
+			return rc;
 		}
 	}
 
@@ -453,13 +451,12 @@ static int pm8xxx_rtc_probe(struct platf
 	platform_set_drvdata(pdev, rtc_dd);
 
 	/* Register the RTC device */
-	rtc_dd->rtc = rtc_device_register("pm8xxx_rtc", &pdev->dev,
+	rtc_dd->rtc = devm_rtc_device_register(&pdev->dev, "pm8xxx_rtc",
 				&pm8xxx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc_dd->rtc)) {
 		dev_err(&pdev->dev, "%s: RTC registration failed (%ld)\n",
 					__func__, PTR_ERR(rtc_dd->rtc));
-		rc = PTR_ERR(rtc_dd->rtc);
-		goto fail_rtc_enable;
+		return PTR_ERR(rtc_dd->rtc);
 	}
 
 	/* Request the alarm IRQ */
@@ -468,7 +465,7 @@ static int pm8xxx_rtc_probe(struct platf
 				 "pm8xxx_rtc_alarm", rtc_dd);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "Request IRQ failed (%d)\n", rc);
-		goto fail_req_irq;
+		return rc;
 	}
 
 	device_init_wakeup(&pdev->dev, 1);
@@ -476,12 +473,6 @@ static int pm8xxx_rtc_probe(struct platf
 	dev_dbg(&pdev->dev, "Probe success !!\n");
 
 	return 0;
