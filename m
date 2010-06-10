From: akpm@linux-foundation.org
Subject: + rtc-nuc900-fix-checking-of-args-during-time-setting.patch added to -mm tree
Date: Thu, 10 Jun 2010 13:48:24 -0700
Message-ID: <201006102048.o5AKmOA1022963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34517 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758518Ab0FJUsf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jun 2010 16:48:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcuos.com@gmail.com, a.zummo@towertech.it


The patch titled
     rtc/nuc900: fix checking of args during time-setting
has been added to the -mm tree.  Its filename is
     rtc-nuc900-fix-checking-of-args-during-time-setting.patch

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
Subject: rtc/nuc900: fix checking of args during time-setting
From: Wan ZongShun <mcuos.com@gmail.com>

When a user application wants to set the rtc time, the RTC subsystem takes
advantage of 'rtc_valid_tm(tm)' to check 'rtc_time *tm' value validity, it
make sure the 'tm->tm_year' is larger than 70,so if '70< tm_year < 100',
the '(settm->tm_year - 100)' will be negative.  ' Setting the negative
value to hardware register will be invalid, so I add the 'if' condition to
make sure set a valid value to register.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-nuc900.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-nuc900.c~rtc-nuc900-fix-checking-of-args-during-time-setting drivers/rtc/rtc-nuc900.c
--- a/drivers/rtc/rtc-nuc900.c~rtc-nuc900-fix-checking-of-args-during-time-setting
+++ a/drivers/rtc/rtc-nuc900.c
@@ -116,12 +116,18 @@ static void nuc900_rtc_bcd2bin(unsigned 
 	rtc_valid_tm(tm);
 }
 
-static void nuc900_rtc_bin2bcd(struct rtc_time *settm,
+static void nuc900_rtc_bin2bcd(struct device *dev, struct rtc_time *settm,
 						struct nuc900_bcd_time *gettm)
 {
 	gettm->bcd_mday = bin2bcd(settm->tm_mday) << 0;
 	gettm->bcd_mon  = bin2bcd(settm->tm_mon) << 8;
-	gettm->bcd_year = bin2bcd(settm->tm_year - 100) << 16;
+
+	if (settm->tm_year < 100) {
+		dev_warn(dev, "The year will be between 1970-1999, right?\n");
+		gettm->bcd_year = bin2bcd(settm->tm_year) << 16;
+	} else {
+		gettm->bcd_year = bin2bcd(settm->tm_year - 100) << 16;
+	}
 
 	gettm->bcd_sec  = bin2bcd(settm->tm_sec) << 0;
 	gettm->bcd_min  = bin2bcd(settm->tm_min) << 8;
@@ -176,7 +182,7 @@ static int nuc900_rtc_set_time(struct de
 	unsigned long val;
 	int *err;
 
-	nuc900_rtc_bin2bcd(tm, &gettm);
+	nuc900_rtc_bin2bcd(dev, tm, &gettm);
 
 	err = check_rtc_access_enable(rtc);
 	if (IS_ERR(err))
@@ -211,7 +217,7 @@ static int nuc900_rtc_set_alarm(struct d
 	unsigned long val;
 	int *err;
 
-	nuc900_rtc_bin2bcd(&alrm->time, &tm);
+	nuc900_rtc_bin2bcd(dev, &alrm->time, &tm);
 
 	err = check_rtc_access_enable(rtc);
 	if (IS_ERR(err))
_

Patches currently in -mm which might be from mcuos.com@gmail.com are

origin.patch
linux-next.patch
nuc900-rtc-change-the-waiting-for-device-ready-implement.patch
rtc-nuc900-fix-checking-of-args-during-time-setting.patch
drivers-rtc-rtc-pcf8563c-remove-unused-struct.patch
rtc-pxa-remove-unused-field.patch
rtc-m48t59-kfreenull-is-ok.patch
rtc-rtc-mxc-remove-six-unused-fields.patch
rtc-fixes-and-new-functionality-for-fm3130.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
rtc-pxa-remove-unnecessary-private-ops-ioctl.patch

