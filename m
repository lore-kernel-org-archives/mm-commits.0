From: akpm@linux-foundation.org
Subject: + rtc-ds1286-fix-compiler-warning-while-doing-make-w=1.patch added to -mm tree
Date: Fri, 08 Mar 2013 13:05:29 -0800
Message-ID: <20130308210529.7443A5A4123@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:41775 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab3CHVFa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Mar 2013 16:05:30 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so201589yhr.4
        for <mm-commits@vger.kernel.org>; Fri, 08 Mar 2013 13:05:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: devendra.aaru@gmail.com, a.zummo@towertech.it, tsbogend@alpha.franken.de


The patch titled
     : fix compiler warning while doing make W=1
has been added to the -mm tree.  Its filename is
     rtc-ds1286-fix-compiler-warning-while-doing-make-w=1.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Devendra Naga <devendra.aaru@gmail.com>
: fix compiler warning while doing make W=1

below is the warning reported with the gcc (gcc (GCC) 4.7.2 20121109 (Red
Hat 4.7.2-8))

with make W=1

drivers/rtc/rtc-ds1286.c: In function `ds1286_read_alarm':
drivers/rtc/rtc-ds1286.c:273:16: warning: variable `cmd' set but not used [-Wunused-but-set-variable]

fixed by removing the variable

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1286.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-ds1286.c~rtc-ds1286-fix-compiler-warning-while-doing-make-w=1 drivers/rtc/rtc-ds1286.c
--- a/drivers/rtc/rtc-ds1286.c~rtc-ds1286-fix-compiler-warning-while-doing-make-w=1
+++ a/drivers/rtc/rtc-ds1286.c
@@ -270,7 +270,6 @@ static int ds1286_set_time(struct device
 static int ds1286_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
 	struct ds1286_priv *priv = dev_get_drvdata(dev);
-	unsigned char cmd;
 	unsigned long flags;
 
 	/*
@@ -281,7 +280,7 @@ static int ds1286_read_alarm(struct devi
 	alm->time.tm_min = ds1286_rtc_read(priv, RTC_MINUTES_ALARM) & 0x7f;
 	alm->time.tm_hour = ds1286_rtc_read(priv, RTC_HOURS_ALARM)  & 0x1f;
 	alm->time.tm_wday = ds1286_rtc_read(priv, RTC_DAY_ALARM)    & 0x07;
-	cmd = ds1286_rtc_read(priv, RTC_CMD);
+	ds1286_rtc_read(priv, RTC_CMD);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	alm->time.tm_min = bcd2bin(alm->time.tm_min);
_

Patches currently in -mm which might be from devendra.aaru@gmail.com are

drivers-video-console-fbcon_cwc-fix-compiler-warning-in-cw_update_attr.patch
drivers-video-backlight-lp855x_blc-fix-compiler-warning-in-lp855x_probe.patch
rtc-ds1286-fix-compiler-warning-while-doing-make-w=1.patch

