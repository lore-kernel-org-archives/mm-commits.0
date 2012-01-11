From: akpm@linux-foundation.org
Subject: [merged] rtc-ab8500-set-can_wake-flag.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:32:09 -0800
Message-ID: <20120111213209.A237F1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:61363 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab2AKVcK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:32:10 -0500
Received: by mail-gx0-f202.google.com with SMTP id k3so134903ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:32:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrew.lynn@stericsson.com, a.zummo@towertech.it, jonas.aberg@stericsson.com, linus.walleij@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc/ab8500: set can_wake flag
has been removed from the -mm tree.  Its filename was
     rtc-ab8500-set-can_wake-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Lynn <andrew.lynn@stericsson.com>
Subject: rtc/ab8500: set can_wake flag

Set can_wake flag so wakealarm property is visible in sysfs.

Signed-off-by: Andrew Lynn <andrew.lynn@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ab8500.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/rtc/rtc-ab8500.c~rtc-ab8500-set-can_wake-flag drivers/rtc/rtc-ab8500.c
--- a/drivers/rtc/rtc-ab8500.c~rtc-ab8500-set-can_wake-flag
+++ a/drivers/rtc/rtc-ab8500.c
@@ -308,6 +308,8 @@ static int __devinit ab8500_rtc_probe(st
 		return -ENODEV;
 	}
 
+	device_init_wakeup(&pdev->dev, true);
+
 	rtc = rtc_device_register("ab8500-rtc", &pdev->dev, &ab8500_rtc_ops,
 			THIS_MODULE);
 	if (IS_ERR(rtc)) {
_

Patches currently in -mm which might be from andrew.lynn@stericsson.com are

origin.patch

