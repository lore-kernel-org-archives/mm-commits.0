From: akpm@linux-foundation.org
Subject: [merged] rtc-pl031-add-wake-up-support.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:43:56 -0800
Message-ID: <20130222204356.A6C5E5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:35853 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758302Ab3BVUn6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:43:58 -0500
Received: by mail-qc0-f202.google.com with SMTP id k26so103999qcs.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:43:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob.herring@calxeda.com, a.zummo@towertech.it, linus.walleij@linaro.org, srinidhi.kasagar@stericsson.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pl031.c: add wakeup support
has been removed from the -mm tree.  Its filename was
     rtc-pl031-add-wake-up-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rob Herring <rob.herring@calxeda.com>
Subject: drivers/rtc/rtc-pl031.c: add wakeup support

Mark the pl031 as wake-up capable so that rtcwake and suspend test can work.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pl031.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/rtc/rtc-pl031.c~rtc-pl031-add-wake-up-support drivers/rtc/rtc-pl031.c
--- a/drivers/rtc/rtc-pl031.c~rtc-pl031-add-wake-up-support
+++ a/drivers/rtc/rtc-pl031.c
@@ -384,6 +384,8 @@ static int pl031_probe(struct amba_devic
 		goto out_no_irq;
 	}
 
+	device_init_wakeup(&adev->dev, 1);
+
 	return 0;
 
 out_no_irq:
_

Patches currently in -mm which might be from rob.herring@calxeda.com are

origin.patch
linux-next.patch

