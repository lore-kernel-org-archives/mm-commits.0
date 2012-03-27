From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-88pm860xc-fix-rtc-irq-enable-callback.patch added to -mm tree
Date: Tue, 27 Mar 2012 16:48:12 -0700
Message-ID: <20120327234812.C64C2A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:40899 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab2C0XsP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Mar 2012 19:48:15 -0400
Received: by eekc41 with SMTP id c41so18997eek.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Mar 2012 16:48:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jtzhou@marvell.com, a.zummo@towertech.it, axel.lin@gmail.com, haojian.zhuang@marvell.com


The patch titled
     Subject: drivers/rtc/rtc-88pm860x.c: fix rtc irq enable callback
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-88pm860xc-fix-rtc-irq-enable-callback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Jett.Zhou" <jtzhou@marvell.com>
Subject: drivers/rtc/rtc-88pm860x.c: fix rtc irq enable callback

According to 88pm860x spec, rtc alarm irq enable control is bit3 for
RTC_ALARM_EN, so fix it.

Signed-off-by: Jett.Zhou <jtzhou@marvell.com>
Cc: Axel Lin <axel.lin@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-88pm860x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-88pm860x.c~drivers-rtc-rtc-88pm860xc-fix-rtc-irq-enable-callback drivers/rtc/rtc-88pm860x.c
--- a/drivers/rtc/rtc-88pm860x.c~drivers-rtc-rtc-88pm860xc-fix-rtc-irq-enable-callback
+++ a/drivers/rtc/rtc-88pm860x.c
@@ -72,9 +72,9 @@ static int pm860x_rtc_alarm_irq_enable(s
 	struct pm860x_rtc_info *info = dev_get_drvdata(dev);
 
 	if (enabled)
-		pm860x_set_bits(info->i2c, PM8607_RTC1, ALARM, ALARM);
+		pm860x_set_bits(info->i2c, PM8607_RTC1, ALARM_EN, ALARM_EN);
 	else
-		pm860x_set_bits(info->i2c, PM8607_RTC1, ALARM, 0);
+		pm860x_set_bits(info->i2c, PM8607_RTC1, ALARM_EN, 0);
 	return 0;
 }
 
_
Subject: Subject: drivers/rtc/rtc-88pm860x.c: fix rtc irq enable callback

Patches currently in -mm which might be from jtzhou@marvell.com are

linux-next.patch
drivers-rtc-rtc-88pm860xc-fix-rtc-irq-enable-callback.patch

