From: akpm@linux-foundation.org
Subject: + arm-nuc900-add-rtc-driver-support-for-nuc910-and-nuc920-v5.patch added to -mm tree
Date: Wed, 02 Dec 2009 16:41:28 -0800
Message-ID: <200912030041.nB30fSaS025248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752753AbZLCAlv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2009 19:41:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcuos.com@gmail.com, a.zummo@towertech.it, david-b@pacbell.net, jack_wang@usish.com, rmk@arm.linux.org.uk, specter118@gmail.com


The patch titled
     arm-nuc900-add-rtc-driver-support-for-nuc910-and-nuc920-v5.
has been added to the -mm tree.  Its filename is
     arm-nuc900-add-rtc-driver-support-for-nuc910-and-nuc920-v5.patch

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
Subject: arm-nuc900-add-rtc-driver-support-for-nuc910-and-nuc920-v5.
From: Wan ZongShun <mcuos.com@gmail.com>

Regarding your advice for 'check_rtc_power', I have modified some codes
and thanks for your comment.

This patch named v5,and I fixed 'check_rtc_power' function, maybe I can
make a patch relative to that patch v4?

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Hu Ruihuan <specter118@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: "jack wang" <jack_wang@usish.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-nuc900.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-nuc900.c~arm-nuc900-add-rtc-driver-support-for-nuc910-and-nuc920-v5 drivers/rtc/rtc-nuc900.c
--- a/drivers/rtc/rtc-nuc900.c~arm-nuc900-add-rtc-driver-support-for-nuc910-and-nuc920-v5
+++ a/drivers/rtc/rtc-nuc900.c
@@ -82,7 +82,7 @@ static irqreturn_t nuc900_rtc_interrupt(
 	return IRQ_HANDLED;
 }
 
-static void check_rtc_power(struct nuc900_rtc *nuc900_rtc)
+static int *check_rtc_access_enable(struct nuc900_rtc *nuc900_rtc)
 {
 	unsigned int i;
 	__raw_writel(INIRRESET, nuc900_rtc->rtc_reg + REG_RTC_INIR);
@@ -91,10 +91,15 @@ static void check_rtc_power(struct nuc90
 
 	__raw_writel(AERPOWERON, nuc900_rtc->rtc_reg + REG_RTC_AER);
 
-	for (i = 0; i < 1000000; i++) {
+	for (i = 0; i < 1000; i++) {
 		if (__raw_readl(nuc900_rtc->rtc_reg + REG_RTC_AER) & AERRWENB)
-			break;
+			return 0;
 	}
+
+	if ((__raw_readl(nuc900_rtc->rtc_reg + REG_RTC_AER) & AERRWENB) == 0x0)
+		return ERR_PTR(-ENODEV);
+
+	return ERR_PTR(-EPERM);
 }
 
 static void nuc900_rtc_bcd2bin(unsigned int timereg,
@@ -169,10 +174,13 @@ static int nuc900_rtc_set_time(struct de
 	struct nuc900_rtc *rtc = dev_get_drvdata(dev);
 	struct nuc900_bcd_time gettm;
 	unsigned long val;
+	int *err;
 
 	nuc900_rtc_bin2bcd(tm, &gettm);
 
-	check_rtc_power(rtc);
+	err = check_rtc_access_enable(rtc);
+	if (IS_ERR(err))
+		return PTR_ERR(err);
 
 	val = gettm.bcd_mday | gettm.bcd_mon | gettm.bcd_year;
 	__raw_writel(val, rtc->rtc_reg + REG_RTC_CLR);
@@ -201,10 +209,13 @@ static int nuc900_rtc_set_alarm(struct d
 	struct nuc900_rtc *rtc = dev_get_drvdata(dev);
 	struct nuc900_bcd_time tm;
 	unsigned long val;
+	int *err;
 
 	nuc900_rtc_bin2bcd(&alrm->time, &tm);
 
-	check_rtc_power(rtc);
+	err = check_rtc_access_enable(rtc);
+	if (IS_ERR(err))
+		return PTR_ERR(err);
 
 	val = tm.bcd_mday | tm.bcd_mon | tm.bcd_year;
 	__raw_writel(val, rtc->rtc_reg + REG_RTC_CAR);
_

Patches currently in -mm which might be from mcuos.com@gmail.com are

linux-next.patch
spi-nuc900-add-arm-driver-support-for-nuc900.patch
arm-nuc900-add-rtc-driver-support-for-nuc910-and-nuc920.patch
arm-nuc900-add-rtc-driver-support-for-nuc910-and-nuc920-v5.patch

