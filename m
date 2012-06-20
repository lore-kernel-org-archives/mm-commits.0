From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-ab8500c-use-uie-emulation.patch added to -mm tree
Date: Wed, 20 Jun 2012 15:52:35 -0700
Message-ID: <20120620225236.2A38CA01BD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:35945 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758095Ab2FTWwi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jun 2012 18:52:38 -0400
Received: by weyu7 with SMTP id u7so173wey.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Jun 2012 15:52:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ramesh.chandrasekaran@stericsson.com, a.zummo@towertech.it, linus.walleij@linaro.org


The patch titled
     Subject: drivers/rtc/rtc-ab8500.c: use UIE emulation
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ab8500c-use-uie-emulation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ramesh Chandrasekaran <ramesh.chandrasekaran@stericsson.com>
Subject: drivers/rtc/rtc-ab8500.c: use UIE emulation

RTC: Fix to correct improper implementation of clock update irq
(RTC_UIE) and enable UIE Emulation.

Signed-off-by: Ramesh Chandrasekaran <ramesh.chandrasekaran@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |    1 +
 drivers/rtc/rtc-ab8500.c |   15 ++++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/Kconfig~drivers-rtc-rtc-ab8500c-use-uie-emulation drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~drivers-rtc-rtc-ab8500c-use-uie-emulation
+++ a/drivers/rtc/Kconfig
@@ -694,6 +694,7 @@ config RTC_DRV_AB3100
 config RTC_DRV_AB8500
 	tristate "ST-Ericsson AB8500 RTC"
 	depends on AB8500_CORE
+	select RTC_INTF_DEV_UIE_EMUL
 	help
 	  Select this to enable the ST-Ericsson AB8500 power management IC RTC
 	  support. This chip contains a battery- and capacitor-backed RTC.
diff -puN drivers/rtc/rtc-ab8500.c~drivers-rtc-rtc-ab8500c-use-uie-emulation drivers/rtc/rtc-ab8500.c
--- a/drivers/rtc/rtc-ab8500.c~drivers-rtc-rtc-ab8500c-use-uie-emulation
+++ a/drivers/rtc/rtc-ab8500.c
@@ -224,7 +224,8 @@ static int ab8500_rtc_set_alarm(struct d
 {
 	int retval, i;
 	unsigned char buf[ARRAY_SIZE(ab8500_rtc_alarm_regs)];
-	unsigned long mins, secs = 0;
+	unsigned long mins, secs = 0, cursec=0;
+	struct rtc_time curtm;
 
 	if (alarm->time.tm_year < (AB8500_RTC_EPOCH - 1900)) {
 		dev_dbg(dev, "year should be equal to or greater than %d\n",
@@ -236,6 +237,18 @@ static int ab8500_rtc_set_alarm(struct d
 	rtc_tm_to_time(&alarm->time, &secs);
 
 	/*
+	 * Check whether alarm is set less than 1min.
+	 * Since our RTC doesn't support alarm resolution less than 1min,
+	 * return -EINVAL, so UIE EMUL can take it up, incase of UIE_ON
+	 */
+	ab8500_rtc_read_time(dev, &curtm); /* Read current time */
+	rtc_tm_to_time(&curtm, &cursec);
+	if ((secs - cursec) < 59 ){
+		dev_dbg(dev, "Alarm less than 1 minute not supported\r\n");
+		return -EINVAL;
+	}
+
+	/*
 	 * Convert it to the number of seconds since 01-01-2000 00:00:00, since
 	 * we only have a small counter in the RTC.
 	 */
_
Subject: Subject: drivers/rtc/rtc-ab8500.c: use UIE emulation

Patches currently in -mm which might be from ramesh.chandrasekaran@stericsson.com are

drivers-rtc-rtc-ab8500c-use-uie-emulation.patch

