From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-pcap-use-devm_-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:00:34 -0700
Message-ID: <20130430190034.6EF2631C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:51778 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638Ab3D3TAg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:00:36 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so87574vcb.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:00:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-pcap: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-pcap-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-pcap: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcap.c |   34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff -puN drivers/rtc/rtc-pcap.c~rtc-rtc-pcap-use-devm_-functions drivers/rtc/rtc-pcap.c
--- a/drivers/rtc/rtc-pcap.c~rtc-rtc-pcap-use-devm_-functions
+++ a/drivers/rtc/rtc-pcap.c
@@ -145,7 +145,8 @@ static int __init pcap_rtc_probe(struct
 	int timer_irq, alarm_irq;
 	int err = -ENOMEM;
 
-	pcap_rtc = kmalloc(sizeof(struct pcap_rtc), GFP_KERNEL);
+	pcap_rtc = devm_kzalloc(&pdev->dev, sizeof(struct pcap_rtc),
+				GFP_KERNEL);
 	if (!pcap_rtc)
 		return err;
 
@@ -153,45 +154,34 @@ static int __init pcap_rtc_probe(struct
 
 	platform_set_drvdata(pdev, pcap_rtc);
 
-	pcap_rtc->rtc = rtc_device_register("pcap", &pdev->dev,
-				  &pcap_rtc_ops, THIS_MODULE);
+	pcap_rtc->rtc = devm_rtc_device_register(&pdev->dev, "pcap",
+					&pcap_rtc_ops, THIS_MODULE);
 	if (IS_ERR(pcap_rtc->rtc)) {
 		err = PTR_ERR(pcap_rtc->rtc);
-		goto fail_rtc;
+		goto fail;
 	}
 
-
 	timer_irq = pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_1HZ);
 	alarm_irq = pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_TODA);
 
-	err = request_irq(timer_irq, pcap_rtc_irq, 0, "RTC Timer", pcap_rtc);
+	err = devm_request_irq(&pdev->dev, timer_irq, pcap_rtc_irq, 0,
+				"RTC Timer", pcap_rtc);
 	if (err)
-		goto fail_timer;
+		goto fail;
 
-	err = request_irq(alarm_irq, pcap_rtc_irq, 0, "RTC Alarm", pcap_rtc);
+	err = devm_request_irq(&pdev->dev, alarm_irq, pcap_rtc_irq, 0,
+				"RTC Alarm", pcap_rtc);
 	if (err)
-		goto fail_alarm;
+		goto fail;
 
 	return 0;
-fail_alarm:
-	free_irq(timer_irq, pcap_rtc);
-fail_timer:
-	rtc_device_unregister(pcap_rtc->rtc);
-fail_rtc:
+fail:
 	platform_set_drvdata(pdev, NULL);
-	kfree(pcap_rtc);
 	return err;
 }
 
 static int __exit pcap_rtc_remove(struct platform_device *pdev)
 {
-	struct pcap_rtc *pcap_rtc = platform_get_drvdata(pdev);
-
-	free_irq(pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_1HZ), pcap_rtc);
-	free_irq(pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_TODA), pcap_rtc);
-	rtc_device_unregister(pcap_rtc->rtc);
-	kfree(pcap_rtc);
