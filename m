From: akpm@linux-foundation.org
Subject: + rtc-nuc900-make-returning-time-checking-function-valid.patch added to -mm tree
Date: Wed, 30 Jun 2010 12:40:49 -0700
Message-ID: <201006301940.o5UJenOL022480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755222Ab0F3Tl1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jun 2010 15:41:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcuos.com@gmail.com, a.zummo@towertech.it


The patch titled
     rtc/nuc900: make returning time checking function valid
has been added to the -mm tree.  Its filename is
     rtc-nuc900-make-returning-time-checking-function-valid.patch

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
Subject: rtc/nuc900: make returning time checking function valid
From: Wan ZongShun <mcuos.com@gmail.com>

Make returning time checking function valid.  In spite of using the
'rtc_valid_tm', nevertheless, the read time function omits its returning
value, that means the 'rtc_valid_tm' is useless here.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-nuc900.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/rtc-nuc900.c~rtc-nuc900-make-returning-time-checking-function-valid drivers/rtc/rtc-nuc900.c
--- a/drivers/rtc/rtc-nuc900.c~rtc-nuc900-make-returning-time-checking-function-valid
+++ a/drivers/rtc/rtc-nuc900.c
@@ -102,7 +102,7 @@ static int *check_rtc_access_enable(stru
 	return 0;
 }
 
-static void nuc900_rtc_bcd2bin(unsigned int timereg,
+static int nuc900_rtc_bcd2bin(unsigned int timereg,
 				unsigned int calreg, struct rtc_time *tm)
 {
 	tm->tm_mday	= bcd2bin(calreg >> 0);
@@ -113,7 +113,7 @@ static void nuc900_rtc_bcd2bin(unsigned 
 	tm->tm_min	= bcd2bin(timereg >> 8);
 	tm->tm_hour	= bcd2bin(timereg >> 16);
 
-	rtc_valid_tm(tm);
+	return rtc_valid_tm(tm);
 }
 
 static void nuc900_rtc_bin2bcd(struct device *dev, struct rtc_time *settm,
@@ -170,9 +170,7 @@ static int nuc900_rtc_read_time(struct d
 	timeval = __raw_readl(rtc->rtc_reg + REG_RTC_TLR);
 	clrval	= __raw_readl(rtc->rtc_reg + REG_RTC_CLR);
 
-	nuc900_rtc_bcd2bin(timeval, clrval, tm);
-
-	return 0;
+	return nuc900_rtc_bcd2bin(timeval, clrval, tm);
 }
 
 static int nuc900_rtc_set_time(struct device *dev, struct rtc_time *tm)
@@ -205,9 +203,7 @@ static int nuc900_rtc_read_alarm(struct 
 	timeval = __raw_readl(rtc->rtc_reg + REG_RTC_TAR);
 	carval	= __raw_readl(rtc->rtc_reg + REG_RTC_CAR);
 
-	nuc900_rtc_bcd2bin(timeval, carval, &alrm->time);
-
-	return 0;
+	return nuc900_rtc_bcd2bin(timeval, carval, &alrm->time);
 }
 
 static int nuc900_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
_

Patches currently in -mm which might be from mcuos.com@gmail.com are

rtc-fix-ds1388-time-corruption.patch
drivers-video-nuc900fbc-fix-lcd-build-error.patch
linux-next.patch
maintainers-update-arm-nuvoton-w90x900-arm-architecture-file-patterns.patch
nuc900-rtc-change-the-waiting-for-device-ready-implement.patch
rtc-nuc900-fix-checking-of-args-during-time-setting.patch
drivers-rtc-rtc-pcf8563c-remove-unused-struct.patch
rtc-pxa-remove-unused-field.patch
rtc-m48t59-kfreenull-is-ok.patch
rtc-rtc-mxc-remove-six-unused-fields.patch
rtc-fixes-and-new-functionality-for-fm3130.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
rtc-pxa-remove-unnecessary-private-ops-ioctl.patch
drivers-rtc-rtc-pl031c-remove-unused-include-linux-versionh.patch
rtc-driver-for-the-dryice-block-found-in-imx25-chips.patch
rtc-add-intersil-isl12022-rtc-driver.patch
rtc-m41t80-use-rtc_valid_tm-to-check-returned-tm.patch
rtc-max6900-use-rtc_valid_tm-to-check-returning-tm.patch
rtc-m48t59-use-rtc_valid_tm-to-check-returned-tm.patch
rtc-m48t86-use-rtc_valid_tm-to-check-returned-tm.patch
rtc-nuc900-make-returning-time-checking-function-valid.patch
rtc-nuc900-modify-enable-disable-irqs-and-driver-data-setting-location.patch
rtc-nuc900-fix-build-warning.patch

