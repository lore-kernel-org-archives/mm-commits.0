From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-88pm860xc-fix-rtc-irq-enable-callback.patch removed from -mm tree
Date: Fri, 06 Apr 2012 11:48:52 -0700
Message-ID: <20120406184852.AF300A0443@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:46886 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790Ab2DFSsy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Apr 2012 14:48:54 -0400
Received: by wejx9 with SMTP id x9so128812wej.1
        for <mm-commits@vger.kernel.org>; Fri, 06 Apr 2012 11:48:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jtzhou@marvell.com, a.zummo@towertech.it, axel.lin@gmail.com, haojian.zhuang@marvell.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-88pm860x.c: fix rtc irq enable callback
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-88pm860xc-fix-rtc-irq-enable-callback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from jtzhou@marvell.com are

origin.patch
linux-next.patch

