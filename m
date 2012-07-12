From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-ab8500c-use-irqf_oneshot-when-requesting-a-threaded-irq.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:36:43 -0700
Message-ID: <20120712193643.BAC201E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:60493 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932899Ab2GLTgo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:36:44 -0400
Received: by mail-vc0-f202.google.com with SMTP id p1so16661vcq.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:36:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.jones@linaro.org, a.zummo@towertech.it, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-ab8500.c: use IRQF_ONESHOT when requesting a threaded IRQ
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-ab8500c-use-irqf_oneshot-when-requesting-a-threaded-irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lee Jones <lee.jones@linaro.org>
Subject: drivers/rtc/rtc-ab8500.c: use IRQF_ONESHOT when requesting a threaded IRQ

This driver's IRQ registration is failing because the kernel now forces
IRQs to be ONESHOT if no IRQ handler is passed.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ab8500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-ab8500.c~drivers-rtc-rtc-ab8500c-use-irqf_oneshot-when-requesting-a-threaded-irq drivers/rtc/rtc-ab8500.c
--- a/drivers/rtc/rtc-ab8500.c~drivers-rtc-rtc-ab8500c-use-irqf_oneshot-when-requesting-a-threaded-irq
+++ a/drivers/rtc/rtc-ab8500.c
@@ -422,7 +422,7 @@ static int __devinit ab8500_rtc_probe(st
 	}
 
 	err = request_threaded_irq(irq, NULL, rtc_alarm_handler,
-		IRQF_NO_SUSPEND, "ab8500-rtc", rtc);
+		IRQF_NO_SUSPEND | IRQF_ONESHOT, "ab8500-rtc", rtc);
 	if (err < 0) {
 		rtc_device_unregister(rtc);
 		return err;
_

Patches currently in -mm which might be from lee.jones@linaro.org are

origin.patch
linux-next.patch

