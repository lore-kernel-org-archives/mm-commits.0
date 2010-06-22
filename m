From: akpm@linux-foundation.org
Subject: + rtc-m48t59-use-rtc_valid_tm-to-check-returned-tm.patch added to -mm tree
Date: Tue, 22 Jun 2010 14:28:54 -0700
Message-ID: <201006222128.o5MLSsC5003063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751039Ab0FVV3o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jun 2010 17:29:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcuos.com@gmail.com, a.zummo@towertech.it, p_gortmaker@yahoo.com


The patch titled
     rtc/m48t59: use rtc_valid_tm() to check returned tm
has been added to the -mm tree.  Its filename is
     rtc-m48t59-use-rtc_valid_tm-to-check-returned-tm.patch

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
Subject: rtc/m48t59: use rtc_valid_tm() to check returned tm
From: Wan ZongShun <mcuos.com@gmail.com>

Use rtc_valid_tm to check the returned struct rtc_time *tm, to avoid
returning a wrong tm value.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m48t59.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-m48t59.c~rtc-m48t59-use-rtc_valid_tm-to-check-returned-tm drivers/rtc/rtc-m48t59.c
--- a/drivers/rtc/rtc-m48t59.c~rtc-m48t59-use-rtc_valid_tm-to-check-returned-tm
+++ a/drivers/rtc/rtc-m48t59.c
@@ -105,7 +105,7 @@ static int m48t59_rtc_read_time(struct d
 	dev_dbg(dev, "RTC read time %04d-%02d-%02d %02d/%02d/%02d\n",
 		tm->tm_year + 1900, tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec);
-	return 0;
+	return rtc_valid_tm(tm);
 }
 
 static int m48t59_rtc_set_time(struct device *dev, struct rtc_time *tm)
@@ -196,7 +196,7 @@ static int m48t59_rtc_readalarm(struct d
 	dev_dbg(dev, "RTC read alarm time %04d-%02d-%02d %02d/%02d/%02d\n",
 		tm->tm_year + 1900, tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec);
-	return 0;
+	return rtc_valid_tm(tm);
 }
 
 /*
_

Patches currently in -mm which might be from mcuos.com@gmail.com are

linux-next.patch
rtc-fix-ds1388-time-corruption.patch
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

