From: akpm@linux-foundation.org
Subject: + nuc900-rtc-change-the-waiting-for-device-ready-implement.patch added to -mm tree
Date: Tue, 01 Jun 2010 15:43:41 -0700
Message-ID: <201006012243.o51MhfqL023248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757307Ab0FAWn6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jun 2010 18:43:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcuos.com@gmail.com, a.zummo@towertech.it


The patch titled
     NUC900/rtc: change the waiting for device ready implement
has been added to the -mm tree.  Its filename is
     nuc900-rtc-change-the-waiting-for-device-ready-implement.patch

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
Subject: NUC900/rtc: change the waiting for device ready implement
From: Wan ZongShun <mcuos.com@gmail.com>

-ENOCHANGELOG

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-nuc900.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/rtc-nuc900.c~nuc900-rtc-change-the-waiting-for-device-ready-implement drivers/rtc/rtc-nuc900.c
--- a/drivers/rtc/rtc-nuc900.c~nuc900-rtc-change-the-waiting-for-device-ready-implement
+++ a/drivers/rtc/rtc-nuc900.c
@@ -85,22 +85,21 @@ static irqreturn_t nuc900_rtc_interrupt(
 
 static int *check_rtc_access_enable(struct nuc900_rtc *nuc900_rtc)
 {
-	unsigned int i;
+	unsigned int i, timeout = 0x1000;
 	__raw_writel(INIRRESET, nuc900_rtc->rtc_reg + REG_RTC_INIR);
 
 	mdelay(10);
 
 	__raw_writel(AERPOWERON, nuc900_rtc->rtc_reg + REG_RTC_AER);
 
-	for (i = 0; i < 1000; i++) {
-		if (__raw_readl(nuc900_rtc->rtc_reg + REG_RTC_AER) & AERRWENB)
-			return 0;
-	}
+	while (!(__raw_readl(nuc900_rtc->rtc_reg + REG_RTC_AER) & AERRWENB)
+								&& timeout--)
+		mdelay(1);
 
-	if ((__raw_readl(nuc900_rtc->rtc_reg + REG_RTC_AER) & AERRWENB) == 0x0)
-		return ERR_PTR(-ENODEV);
+	if (!timeout)
+		return ERR_PTR(-EPERM);
 
-	return ERR_PTR(-EPERM);
+	return 0;
 }
 
 static void nuc900_rtc_bcd2bin(unsigned int timereg,
_

Patches currently in -mm which might be from mcuos.com@gmail.com are

nuc900-rtc-change-the-waiting-for-device-ready-implement.patch

