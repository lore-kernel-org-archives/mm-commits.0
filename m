From: akpm@linux-foundation.org
Subject: + rtc-initialize-rtc-name-early.patch added to -mm tree
Date: Tue, 31 Mar 2015 16:32:36 -0700
Message-ID: <551b2e94.sJjEBgPbm9kl9FEm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbbCaXch (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Mar 2015 19:32:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aaro.koskinen@iki.fi, a.zummo@towertech.it, alexandre.belloni@free-electrons.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/class.c: initialize rtc name early
has been added to the -mm tree.  Its filename is
     rtc-initialize-rtc-name-early.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-initialize-rtc-name-early.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-initialize-rtc-name-early.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/class.c~rtc-initialize-rtc-name-early drivers/rtc/class.c
--- a/drivers/rtc/class.c~rtc-initialize-rtc-name-early
+++ a/drivers/rtc/class.c
@@ -225,15 +225,15 @@ struct rtc_device *rtc_device_register(c
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
