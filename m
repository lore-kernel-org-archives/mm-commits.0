From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-max8925c-fix-alarm-enabled-mistake-in-max8925_rtc_read_alarm-max8925_rtc_set_alarm.patch added to -mm tree
Date: Wed, 01 Feb 2012 16:05:06 -0800
Message-ID: <20120202000506.E85C5A0110@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:62598 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab2BBAFJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Feb 2012 19:05:09 -0500
Received: by wicr5 with SMTP id r5so77272wic.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Feb 2012 16:05:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kliu5@marvell.com, a.zummo@towertech.it, haojian.zhuang@marvell.com


The patch titled
     Subject: drivers/rtc/rtc-max8925.c: fix alarm->enabled mistake in max8925_rtc_read_alarm/max8925_rtc_set_alarm
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-max8925c-fix-alarm-enabled-mistake-in-max8925_rtc_read_alarm-max8925_rtc_set_alarm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: drivers/rtc/rtc-max8925.c: fix alarm->enabled mistake in max8925_rtc_read_alarm/max8925_rtc_set_alarm

Patches currently in -mm which might be from kliu5@marvell.com are

drivers-rtc-rtc-max8925c-fix-max8925_rtc_read_alarm-return-value-error.patch
drivers-rtc-rtc-max8925c-fix-alarm-enabled-mistake-in-max8925_rtc_read_alarm-max8925_rtc_set_alarm.patch

