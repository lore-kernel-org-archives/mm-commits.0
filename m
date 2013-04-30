From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-pcap-add-__init-__exit-annotation.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:54:03 -0700
Message-ID: <20130430185403.6F8D25A425C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:35661 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933163Ab3D3SyE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:54:04 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so86471ggm.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:54:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-pcap: add __init/__exit annotation
has been removed from the -mm tree.  Its filename was
     rtc-rtc-pcap-add-__init-__exit-annotation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-pcap: add __init/__exit annotation

When platform_driver_probe() is used, bind/unbind via sysfs is disabled. 
Thus, __init/__exit annotations can be added to probe()/remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-pcap.c~rtc-rtc-pcap-add-__init-__exit-annotation drivers/rtc/rtc-pcap.c
--- a/drivers/rtc/rtc-pcap.c~rtc-rtc-pcap-add-__init-__exit-annotation
+++ a/drivers/rtc/rtc-pcap.c
@@ -139,7 +139,7 @@ static const struct rtc_class_ops pcap_r
 	.alarm_irq_enable = pcap_rtc_alarm_irq_enable,
 };
 
-static int pcap_rtc_probe(struct platform_device *pdev)
+static int __init pcap_rtc_probe(struct platform_device *pdev)
 {
 	struct pcap_rtc *pcap_rtc;
 	int timer_irq, alarm_irq;
@@ -183,7 +183,7 @@ fail_rtc:
 	return err;
 }
 
-static int pcap_rtc_remove(struct platform_device *pdev)
+static int __exit pcap_rtc_remove(struct platform_device *pdev)
 {
 	struct pcap_rtc *pcap_rtc = platform_get_drvdata(pdev);
 
@@ -196,7 +196,7 @@ static int pcap_rtc_remove(struct platfo
 }
 
 static struct platform_driver pcap_rtc_driver = {
-	.remove = pcap_rtc_remove,
+	.remove = __exit_p(pcap_rtc_remove),
 	.driver = {
 		.name  = "pcap-rtc",
 		.owner = THIS_MODULE,
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

