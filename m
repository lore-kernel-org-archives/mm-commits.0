From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-tps65910c-rename-irq-to-match-device.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:08:02 -0800
Message-ID: <20121218200803.1C179200061@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:37867 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab2LRUIF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:08:05 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so63220fae.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:08:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sivaramn@nvidia.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-tps65910.c: rename irq to match device
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-tps65910c-rename-irq-to-match-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sivaram Nair <sivaramn@nvidia.com>
Subject: drivers/rtc/rtc-tps65910.c: rename irq to match device

A cosmetic change to rename the irq name to match the device name.

Signed-off-by: Sivaram Nair <sivaramn@nvidia.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps65910.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-tps65910.c~drivers-rtc-rtc-tps65910c-rename-irq-to-match-device drivers/rtc/rtc-tps65910.c
--- a/drivers/rtc/rtc-tps65910.c~drivers-rtc-rtc-tps65910c-rename-irq-to-match-device
+++ a/drivers/rtc/rtc-tps65910.c
@@ -261,7 +261,7 @@ static int __devinit tps65910_rtc_probe(
 
 	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
 		tps65910_rtc_interrupt, IRQF_TRIGGER_LOW,
-		"rtc-tps65910", &pdev->dev);
+		dev_name(&pdev->dev), &pdev->dev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "IRQ is not free.\n");
 		return ret;
_

Patches currently in -mm which might be from sivaramn@nvidia.com are

origin.patch
linux-next.patch

