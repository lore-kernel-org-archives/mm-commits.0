From: akpm@linux-foundation.org
Subject: [merged] rtc-initialize-rtc-name-early.patch removed from -mm
 tree
Date: Mon, 20 Apr 2015 12:18:06 -0700
Message-ID: <553550ee.987i1295x+Iyedvy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40219 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbbDTTLp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:11:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aaro.koskinen@iki.fi, a.zummo@towertech.it, alexandre.belloni@free-electrons.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/class.c: initialize rtc name early
has been removed from the -mm tree.  Its filename was
     rtc-initialize-rtc-name-early.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: drivers/rtc/class.c: initialize rtc name early

In some error cases RTC name is used before it is initialized:

	rtc-rs5c372 0-0032: clock needs to be set
	rtc-rs5c372 0-0032: rs5c372b found, 24hr, driver version 0.6
	rtc (null): read_time: fail to read
	rtc-rs5c372 0-0032: rtc core: registered rtc-rs5c372 as rtc0

Fix by initializing the name early.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/class.c~rtc-initialize-rtc-name-early drivers/rtc/class.c
--- a/drivers/rtc/class.c~rtc-initialize-rtc-name-early
+++ a/drivers/rtc/class.c
@@ -221,15 +221,15 @@ struct rtc_device *rtc_device_register(c
 	rtc->pie_timer.function = rtc_pie_update_irq;
 	rtc->pie_enabled = 0;
 
+	strlcpy(rtc->name, name, RTC_DEVICE_NAME_SIZE);
+	dev_set_name(&rtc->dev, "rtc%d", id);
+
 	/* Check to see if there is an ALARM already set in hw */
 	err = __rtc_read_alarm(rtc, &alrm);
 
 	if (!err && !rtc_valid_tm(&alrm.time))
 		rtc_initialize_alarm(rtc, &alrm);
 
-	strlcpy(rtc->name, name, RTC_DEVICE_NAME_SIZE);
-	dev_set_name(&rtc->dev, "rtc%d", id);
