From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-mc13xxx-use-devm_-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:00:26 -0700
Message-ID: <20130430190026.70A235A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:53997 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933303Ab3D3TA1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:00:27 -0400
Received: by mail-vb0-f74.google.com with SMTP id w8so87318vbf.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:00:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-mc13xxx: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-mc13xxx-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-mc13xxx: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mc13xxx.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/rtc-mc13xxx.c~rtc-rtc-mc13xxx-use-devm_-functions drivers/rtc/rtc-mc13xxx.c
--- a/drivers/rtc/rtc-mc13xxx.c~rtc-rtc-mc13xxx-use-devm_-functions
+++ a/drivers/rtc/rtc-mc13xxx.c
@@ -316,7 +316,7 @@ static int __init mc13xxx_rtc_probe(stru
 	struct mc13xxx *mc13xxx;
 	int rtcrst_pending;
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
@@ -351,8 +351,8 @@ static int __init mc13xxx_rtc_probe(stru
 
 	mc13xxx_unlock(mc13xxx);
 
-	priv->rtc = rtc_device_register(pdev->name,
-			&pdev->dev, &mc13xxx_rtc_ops, THIS_MODULE);
+	priv->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
+					&mc13xxx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(priv->rtc)) {
 		ret = PTR_ERR(priv->rtc);
 
@@ -372,7 +372,6 @@ err_reset_irq_request:
 		mc13xxx_unlock(mc13xxx);
 
 		platform_set_drvdata(pdev, NULL);
-		kfree(priv);
 	}
 
 	return ret;
@@ -384,8 +383,6 @@ static int __exit mc13xxx_rtc_remove(str
 
 	mc13xxx_lock(priv->mc13xxx);
 
-	rtc_device_unregister(priv->rtc);
-
 	mc13xxx_irq_free(priv->mc13xxx, MC13XXX_IRQ_TODA, priv);
 	mc13xxx_irq_free(priv->mc13xxx, MC13XXX_IRQ_1HZ, priv);
 	mc13xxx_irq_free(priv->mc13xxx, MC13XXX_IRQ_RTCRST, priv);
@@ -394,8 +391,6 @@ static int __exit mc13xxx_rtc_remove(str
 
 	platform_set_drvdata(pdev, NULL);
 
-	kfree(priv);
