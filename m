From: akpm@linux-foundation.org
Subject: + rtc-ab8500-rtc-driver-update.patch added to -mm tree
Date: Wed, 26 May 2010 12:09:10 -0700
Message-ID: <201005261909.o4QJ9AhQ008400@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754632Ab0EZTJv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 May 2010 15:09:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rabin.vincent@stericsson.com, a.zummo@towertech.it, linus.walleij@stericsson.com, sameo@linux.intel.com, srinidhi.kasagar@stericsson.com


The patch titled
     rtc-ab8500-rtc-driver-update
has been added to the -mm tree.  Its filename is
     rtc-ab8500-rtc-driver-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-ab8500-rtc-driver-update
From: Rabin VINCENT <rabin.vincent@stericsson.com>

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |    1 
 drivers/rtc/rtc-ab8500.c |   67 +++++++++++++++++--------------------
 2 files changed, 32 insertions(+), 36 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-ab8500-rtc-driver-update drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-ab8500-rtc-driver-update
+++ a/drivers/rtc/Kconfig
@@ -614,7 +614,6 @@ config RTC_DRV_AB3100
 config RTC_DRV_AB8500
 	tristate "ST-Ericsson AB8500 RTC"
 	depends on AB8500_CORE
-	default y
 	help
 	  Select this to enable the ST-Ericsson AB8500 power management IC RTC
 	  support. This chip contains a battery- and capacitor-backed RTC.
diff -puN drivers/rtc/rtc-ab8500.c~rtc-ab8500-rtc-driver-update drivers/rtc/rtc-ab8500.c
--- a/drivers/rtc/rtc-ab8500.c~rtc-ab8500-rtc-driver-update
+++ a/drivers/rtc/rtc-ab8500.c
@@ -46,16 +46,25 @@
 #define COUNTS_PER_SEC			(0xF000 / 60)
 #define AB8500_RTC_EPOCH		2000
 
+static const unsigned long ab8500_rtc_time_regs[] = {
+	AB8500_RTC_WATCH_TMIN_HI_REG, AB8500_RTC_WATCH_TMIN_MID_REG,
+	AB8500_RTC_WATCH_TMIN_LOW_REG, AB8500_RTC_WATCH_TSECHI_REG,
+	AB8500_RTC_WATCH_TSECMID_REG
+};
+
+static const unsigned long ab8500_rtc_alarm_regs[] = {
+	AB8500_RTC_ALRM_MIN_HI_REG, AB8500_RTC_ALRM_MIN_MID_REG,
+	AB8500_RTC_ALRM_MIN_LOW_REG
+};
+
 /* Calculate the seconds from 1970 to 01-01-2000 00:00:00 */
 static unsigned long get_elapsed_seconds(int year)
 {
 	unsigned long secs;
-	struct rtc_time tm;
-
-	memset(&tm, 0, sizeof(tm));
-	tm.tm_year = year - 1900;
-	tm.tm_mon  = 0;
-	tm.tm_mday  = 1;
+	struct rtc_time tm = {
+		.tm_year = year - 1900,
+		.tm_mday = 1,
+	};
 
 	/*
 	 * This function calculates secs from 1970 and not from
@@ -71,10 +80,7 @@ static int ab8500_rtc_read_time(struct d
 	unsigned long timeout = jiffies + HZ;
 	int retval, i;
 	unsigned long mins, secs;
-	unsigned char buf[5];
-	const unsigned long time_regs[] = {AB8500_RTC_WATCH_TMIN_HI_REG,
-		AB8500_RTC_WATCH_TMIN_MID_REG, AB8500_RTC_WATCH_TMIN_LOW_REG,
-		AB8500_RTC_WATCH_TSECHI_REG, AB8500_RTC_WATCH_TSECMID_REG};
+	unsigned char buf[ARRAY_SIZE(ab8500_rtc_time_regs)];
 
 	/* Request a data read */
 	retval = ab8500_write(ab8500, AB8500_RTC_READ_REQ_REG,
@@ -82,7 +88,8 @@ static int ab8500_rtc_read_time(struct d
 	if (retval < 0)
 		return retval;
 
-	if (!ab8500->revision) {
+	/* Early AB8500 chips will not clear the rtc read request bit */
+	if (ab8500->revision == 0) {
 		msleep(1);
 	} else {
 		/* Wait for some cycles after enabling the rtc read in ab8500 */
@@ -99,8 +106,8 @@ static int ab8500_rtc_read_time(struct d
 	}
 
 	/* Read the Watchtime registers */
-	for (i = 0; i < ARRAY_SIZE(time_regs); i++) {
-		retval = ab8500_read(ab8500, time_regs[i]);
+	for (i = 0; i < ARRAY_SIZE(ab8500_rtc_time_regs); i++) {
+		retval = ab8500_read(ab8500, ab8500_rtc_time_regs[i]);
 		if (retval < 0)
 			return retval;
 		buf[i] = retval;
@@ -123,15 +130,11 @@ static int ab8500_rtc_set_time(struct de
 {
 	struct ab8500 *ab8500 = dev_get_drvdata(dev->parent);
 	int retval, i;
-	unsigned char buf[5];
+	unsigned char buf[ARRAY_SIZE(ab8500_rtc_time_regs)];
 	unsigned long no_secs, no_mins, secs = 0;
-	const unsigned long time_regs[] = {AB8500_RTC_WATCH_TMIN_HI_REG,
-		AB8500_RTC_WATCH_TMIN_MID_REG,
-		AB8500_RTC_WATCH_TMIN_LOW_REG, AB8500_RTC_WATCH_TSECHI_REG,
-		AB8500_RTC_WATCH_TSECMID_REG};
 
 	if (tm->tm_year < (AB8500_RTC_EPOCH - 1900)) {
-		dev_err(dev, "year should be equal to or more than %d\n",
+		dev_dbg(dev, "year should be equal to or greater than %d\n",
 				AB8500_RTC_EPOCH);
 		return -EINVAL;
 	}
@@ -158,8 +161,8 @@ static int ab8500_rtc_set_time(struct de
 	buf[1] = (no_mins >> 8) & 0xFF;
 	buf[0] = (no_mins >> 16) & 0xFF;
 
-	for (i = 0; i < ARRAY_SIZE(time_regs); i++) {
-		retval = ab8500_write(ab8500, time_regs[i], buf[i]);
+	for (i = 0; i < ARRAY_SIZE(ab8500_rtc_time_regs); i++) {
+		retval = ab8500_write(ab8500, ab8500_rtc_time_regs[i], buf[i]);
 		if (retval < 0)
 			return retval;
 	}
@@ -173,10 +176,8 @@ static int ab8500_rtc_read_alarm(struct 
 	struct ab8500 *ab8500 = dev_get_drvdata(dev->parent);
 	int retval, i;
 	int rtc_ctrl;
-	unsigned char buf[3];
+	unsigned char buf[ARRAY_SIZE(ab8500_rtc_alarm_regs)];
 	unsigned long secs, mins;
-	const unsigned long alarm_regs[] = {AB8500_RTC_ALRM_MIN_HI_REG,
-		AB8500_RTC_ALRM_MIN_MID_REG, AB8500_RTC_ALRM_MIN_LOW_REG};
 
 	/* Check if the alarm is enabled or not */
 	rtc_ctrl = ab8500_read(ab8500, AB8500_RTC_STAT_REG);
@@ -190,8 +191,8 @@ static int ab8500_rtc_read_alarm(struct 
 
 	alarm->pending = 0;
 
-	for (i = 0; i < ARRAY_SIZE(alarm_regs); i++) {
-		retval = ab8500_read(ab8500, alarm_regs[i]);
+	for (i = 0; i < ARRAY_SIZE(ab8500_rtc_alarm_regs); i++) {
+		retval = ab8500_read(ab8500, ab8500_rtc_alarm_regs[i]);
 		if (retval < 0)
 			return retval;
 		buf[i] = retval;
@@ -220,13 +221,11 @@ static int ab8500_rtc_set_alarm(struct d
 {
 	struct ab8500 *ab8500 = dev_get_drvdata(dev->parent);
 	int retval, i;
-	unsigned char buf[3];
+	unsigned char buf[ARRAY_SIZE(ab8500_rtc_alarm_regs)];
 	unsigned long mins, secs = 0;
-	const unsigned long alarm_regs[] = {AB8500_RTC_ALRM_MIN_HI_REG,
-		AB8500_RTC_ALRM_MIN_MID_REG, AB8500_RTC_ALRM_MIN_LOW_REG};
 
 	if (alarm->time.tm_year < (AB8500_RTC_EPOCH - 1900)) {
-		dev_err(dev, "year should be equal to or more than %d\n",
+		dev_dbg(dev, "year should be equal to or greater than %d\n",
 				AB8500_RTC_EPOCH);
 		return -EINVAL;
 	}
@@ -247,8 +246,8 @@ static int ab8500_rtc_set_alarm(struct d
 	buf[0] = (mins >> 16) & 0xFF;
 
 	/* Set the alarm time */
-	for (i = 0; i < ARRAY_SIZE(alarm_regs); i++) {
-		retval = ab8500_write(ab8500, alarm_regs[i], buf[i]);
+	for (i = 0; i < ARRAY_SIZE(ab8500_rtc_alarm_regs); i++) {
+		retval = ab8500_write(ab8500, ab8500_rtc_alarm_regs[i], buf[i]);
 		if (retval < 0)
 			return retval;
 	}
@@ -331,9 +330,7 @@ static int __devexit ab8500_rtc_remove(s
 	struct rtc_device *rtc = platform_get_drvdata(pdev);
 	int irq = platform_get_irq_byname(pdev, "ALARM");
 
-	if (irq >= 0)
-		free_irq(irq, rtc);
