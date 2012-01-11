From: akpm@linux-foundation.org
Subject: [merged] rtc-ab8500-dont-disable-irq-s-when-suspending.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:32:06 -0800
Message-ID: <20120111213206.98E5B10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:51256 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab2AKVcH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:32:07 -0500
Received: by yhpp56 with SMTP id p56so154293yhp.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:32:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robert.marklund@stericsson.com, a.zummo@towertech.it, linus.walleij@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc/ab8500: don't disable IRQ:s when suspending
has been removed from the -mm tree.  Its filename was
     rtc-ab8500-dont-disable-irq-s-when-suspending.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Robert Marklund <robert.marklund@stericsson.com>
Subject: rtc/ab8500: don't disable IRQ:s when suspending

We want this driver to be able to wake up the system.

Signed-off-by: Robert Marklund <robert.marklund@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ab8500.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-ab8500.c~rtc-ab8500-dont-disable-irq-s-when-suspending drivers/rtc/rtc-ab8500.c
--- a/drivers/rtc/rtc-ab8500.c~rtc-ab8500-dont-disable-irq-s-when-suspending
+++ a/drivers/rtc/rtc-ab8500.c
@@ -316,8 +316,8 @@ static int __devinit ab8500_rtc_probe(st
 		return err;
 	}
 
-	err = request_threaded_irq(irq, NULL, rtc_alarm_handler, 0,
-				   "ab8500-rtc", rtc);
+	err = request_threaded_irq(irq, NULL, rtc_alarm_handler,
+		IRQF_NO_SUSPEND, "ab8500-rtc", rtc);
 	if (err < 0) {
 		rtc_device_unregister(rtc);
 		return err;
_

Patches currently in -mm which might be from robert.marklund@stericsson.com are

origin.patch

