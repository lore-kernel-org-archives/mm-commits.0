From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-max8925c-fix-alarm-enabled-mistake-in-max8925_rtc_read_alarm-max8925_rtc_set_alarm.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:31:41 -0700
Message-ID: <20120326193141.6B079A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:47661 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab2CZTbm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:31:42 -0400
Received: by mail-gy0-f202.google.com with SMTP id z15so831635ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:31:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kliu5@marvell.com, a.zummo@towertech.it, haojian.zhuang@marvell.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-max8925.c: fix alarm->enabled mistake in max8925_rtc_read_alarm/max8925_rtc_set_alarm
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-max8925c-fix-alarm-enabled-mistake-in-max8925_rtc_read_alarm-max8925_rtc_set_alarm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Kevin Liu <kliu5@marvell.com>
Subject: drivers/rtc/rtc-max8925.c: fix alarm->enabled mistake in max8925_rtc_read_alarm/max8925_rtc_set_alarm

max8925_rtc_read_alarm() should set alrm->enabled based on both
ALARM_IRQ_MASK and ALARM_CTRL setting.  max8925_rtc_set_alarm() should
enable/disable alarm according to ALARM_CTRL reg setting.

Signed-off-by: Kevin Liu <kliu5@marvell.com>
Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max8925.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-max8925.c~drivers-rtc-rtc-max8925c-fix-alarm-enabled-mistake-in-max8925_rtc_read_alarm-max8925_rtc_set_alarm drivers/rtc/rtc-max8925.c
--- a/drivers/rtc/rtc-max8925.c~drivers-rtc-rtc-max8925c-fix-alarm-enabled-mistake-in-max8925_rtc_read_alarm-max8925_rtc_set_alarm
+++ a/drivers/rtc/rtc-max8925.c
@@ -193,10 +193,17 @@ static int max8925_rtc_read_alarm(struct
 	ret = max8925_reg_read(info->rtc, MAX8925_RTC_IRQ_MASK);
 	if (ret < 0)
 		goto out;
-	if ((ret & ALARM0_IRQ) == 0)
-		alrm->enabled = 1;
-	else
+	if (ret & ALARM0_IRQ) {
 		alrm->enabled = 0;
+	} else {
+		ret = max8925_reg_read(info->rtc, MAX8925_ALARM0_CNTL);
+		if (ret < 0)
+			goto out;
+		if (!ret)
+			alrm->enabled = 0;
+		else
+			alrm->enabled = 1;
+	}
 	ret = max8925_reg_read(info->rtc, MAX8925_RTC_STATUS);
 	if (ret < 0)
 		goto out;
@@ -221,8 +228,11 @@ static int max8925_rtc_set_alarm(struct 
 	ret = max8925_bulk_write(info->rtc, MAX8925_ALARM0_SEC, TIME_NUM, buf);
 	if (ret < 0)
 		goto out;
-	/* only enable alarm on year/month/day/hour/min/sec */
-	ret = max8925_reg_write(info->rtc, MAX8925_ALARM0_CNTL, 0x77);
+	if (alrm->enabled)
+		/* only enable alarm on year/month/day/hour/min/sec */
+		ret = max8925_reg_write(info->rtc, MAX8925_ALARM0_CNTL, 0x77);
+	else
+		ret = max8925_reg_write(info->rtc, MAX8925_ALARM0_CNTL, 0x0);
 	if (ret < 0)
 		goto out;
 out:
_

Patches currently in -mm which might be from kliu5@marvell.com are

origin.patch

