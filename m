From: akpm@linux-foundation.org
Subject: [merged] rtc-ab8500-change-to-msleep-to-usleep_range.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:32:12 -0800
Message-ID: <20120111213212.A44BB1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:43773 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab2AKVcN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:32:13 -0500
Received: by ghrr15 with SMTP id r15so137484ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:32:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linus.walleij@linaro.org, a.zummo@towertech.it, jonas.aberg@stericsson.com, plagnioj@jcrosoft.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-ab8500.c: change msleep() to usleep_range()
has been removed from the -mm tree.  Its filename was
     rtc-ab8500-change-to-msleep-to-usleep_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Linus Walleij <linus.walleij@linaro.org>
Subject: drivers/rtc/rtc-ab8500.c: change msleep() to usleep_range()

The resolution of msleep is related to HZ, so with HZ set to 100 any
msleep of less than 10ms will become ~10ms.  This is not what we want. 
Use the hrtimer-based usleep_range() and allow for some slack in the
non-critical path so we have more control of what is happening here.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Jonas Aaberg <jonas.aberg@stericsson.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ab8500.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-ab8500.c~rtc-ab8500-change-to-msleep-to-usleep_range drivers/rtc/rtc-ab8500.c
--- a/drivers/rtc/rtc-ab8500.c~rtc-ab8500-change-to-msleep-to-usleep_range
+++ a/drivers/rtc/rtc-ab8500.c
@@ -90,7 +90,7 @@ static int ab8500_rtc_read_time(struct d
 
 	/* Early AB8500 chips will not clear the rtc read request bit */
 	if (abx500_get_chip_id(dev) == 0) {
-		msleep(1);
+		usleep_range(1000, 1000);
 	} else {
 		/* Wait for some cycles after enabling the rtc read in ab8500 */
 		while (time_before(jiffies, timeout)) {
@@ -102,7 +102,7 @@ static int ab8500_rtc_read_time(struct d
 			if (!(value & RTC_READ_REQUEST))
 				break;
 
-			msleep(1);
+			usleep_range(1000, 5000);
 		}
 	}
 
@@ -295,7 +295,7 @@ static int __devinit ab8500_rtc_probe(st
 		return err;
 
 	/* Wait for reset by the PorRtc */
-	msleep(1);
+	usleep_range(1000, 5000);
 
 	err = abx500_get_register_interruptible(&pdev->dev, AB8500_RTC,
 		AB8500_RTC_STAT_REG, &rtc_ctrl);
_

Patches currently in -mm which might be from linus.walleij@linaro.org are

origin.patch
linux-next.patch

