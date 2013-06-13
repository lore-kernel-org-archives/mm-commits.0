From: akpm@linux-foundation.org
Subject: [merged] rtc-tps6586x-device-wakeup-flags-correction.patch
 removed from -mm tree
Date: Thu, 13 Jun 2013 11:57:34 -0700
Message-ID: <51ba161e.lwdqUy9wP6Za4Aod%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757091Ab3FMS5f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jun 2013 14:57:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ldewangan@nvidia.com, jg1.han@samsung.com, digetx@gmail.com

Subject: [merged] rtc-tps6586x-device-wakeup-flags-correction.patch removed from -mm tree
To: digetx@gmail.com,jg1.han@samsung.com,ldewangan@nvidia.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Jun 2013 11:57:34 -0700


The patch titled
     Subject: drivers/rtc/rtc-tps6586x.c: device wakeup flags correction
has been removed from the -mm tree.  Its filename was
     rtc-tps6586x-device-wakeup-flags-correction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Osipenko <digetx@gmail.com>
Subject: drivers/rtc/rtc-tps6586x.c: device wakeup flags correction

Use device_init_wakeup() instead of device_set_wakeup_capable() and move
it before rtc dev registering.  This fixes alarmtimer not registered when
tps6586x rtc is the only wakeup compatible rtc in the system.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps6586x.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-tps6586x.c~rtc-tps6586x-device-wakeup-flags-correction drivers/rtc/rtc-tps6586x.c
--- a/drivers/rtc/rtc-tps6586x.c~rtc-tps6586x-device-wakeup-flags-correction
+++ a/drivers/rtc/rtc-tps6586x.c
@@ -273,6 +273,8 @@ static int tps6586x_rtc_probe(struct pla
 		return ret;
 	}
 
+	device_init_wakeup(&pdev->dev, 1);
+
 	platform_set_drvdata(pdev, rtc);
 	rtc->rtc = devm_rtc_device_register(&pdev->dev, dev_name(&pdev->dev),
 				       &tps6586x_rtc_ops, THIS_MODULE);
@@ -292,7 +294,6 @@ static int tps6586x_rtc_probe(struct pla
 		goto fail_rtc_register;
 	}
 	disable_irq(rtc->irq);
-	device_set_wakeup_capable(&pdev->dev, 1);
 	return 0;
 
 fail_rtc_register:
_

Patches currently in -mm which might be from digetx@gmail.com are

origin.patch
linux-next.patch

