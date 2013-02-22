From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-lp8788-use-devm_request_threaded_irq.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:44:56 -0800
Message-ID: <20130222204456.979FD31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:38875 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874Ab3BVUo5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:44:57 -0500
Received: by mail-vb0-f73.google.com with SMTP id fj18so104023vbb.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:44:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-lp8788: use devm_request_threaded_irq()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-lp8788-use-devm_request_threaded_irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-lp8788: use devm_request_threaded_irq()

Use devm_request_threaded_irq() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-lp8788.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/rtc-lp8788.c~rtc-rtc-lp8788-use-devm_request_threaded_irq drivers/rtc/rtc-lp8788.c
--- a/drivers/rtc/rtc-lp8788.c~rtc-rtc-lp8788-use-devm_request_threaded_irq
+++ a/drivers/rtc/rtc-lp8788.c
@@ -278,16 +278,11 @@ static int lp8788_alarm_irq_register(str
 
 	rtc->irq = irq_create_mapping(irqdm, irq);
 
-	return request_threaded_irq(rtc->irq, NULL, lp8788_alarm_irq_handler,
+	return devm_request_threaded_irq(&pdev->dev, rtc->irq, NULL,
+				lp8788_alarm_irq_handler,
 				0, LP8788_ALM_IRQ, rtc);
 }
 
-static void lp8788_alarm_irq_unregister(struct lp8788_rtc *rtc)
-{
-	if (rtc->irq)
-		free_irq(rtc->irq, rtc);
-}
