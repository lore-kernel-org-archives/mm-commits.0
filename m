From: akpm@linux-foundation.org
Subject: [merged] rtc-ds1286-fix-compiler-warning-while-doing-make-w=1.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:56:35 -0700
Message-ID: <20130430185635.7E34531C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:58413 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933327Ab3D3S4h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:56:37 -0400
Received: by mail-yh0-f73.google.com with SMTP id f35so86812yha.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:56:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: devendra.aaru@gmail.com, a.zummo@towertech.it, tsbogend@alpha.franken.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-ds1286.c: fix compiler warning while doing make W=1
has been removed from the -mm tree.  Its filename was
     rtc-ds1286-fix-compiler-warning-while-doing-make-w=1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Devendra Naga <devendra.aaru@gmail.com>
Subject: drivers/rtc/rtc-ds1286.c: fix compiler warning while doing make W=1

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

origin.patch
linux-next.patch

