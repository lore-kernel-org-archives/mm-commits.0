From: akpm@linux-foundation.org
Subject: + rtc-m41t80-use-rtc_valid_tm-to-check-returned-tm.patch added to -mm tree
Date: Tue, 22 Jun 2010 14:17:14 -0700
Message-ID: <201006222117.o5MLHETC002559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755856Ab0FVVRd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jun 2010 17:17:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcuos.com@gmail.com, a.zummo@towertech.it


The patch titled
     rtc/m41t80: use rtc_valid_tm() to check returned tm
has been added to the -mm tree.  Its filename is
     rtc-m41t80-use-rtc_valid_tm-to-check-returned-tm.patch

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
Subject: rtc/m41t80: use rtc_valid_tm() to check returned tm
From: Wan ZongShun <mcuos.com@gmail.com>

Use rtc_valid_tm() to check returned struct rtc_time *tm - it can avoid
returning wrong tm value.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m41t80.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-m41t80.c~rtc-m41t80-use-rtc_valid_tm-to-check-returned-tm drivers/rtc/rtc-m41t80.c
--- a/drivers/rtc/rtc-m41t80.c~rtc-m41t80-use-rtc_valid_tm-to-check-returned-tm
+++ a/drivers/rtc/rtc-m41t80.c
@@ -121,7 +121,7 @@ static int m41t80_get_datetime(struct i2
 
 	/* assume 20YY not 19YY, and ignore the Century Bit */
 	tm->tm_year = bcd2bin(buf[M41T80_REG_YEAR]) + 100;
-	return 0;
+	return rtc_valid_tm(tm);
 }
 
 /* Sets the given date and time to the real time clock. */
@@ -364,7 +364,7 @@ static int m41t80_rtc_read_alarm(struct 
 	t->time.tm_isdst = -1;
 	t->enabled = !!(reg[M41T80_REG_ALARM_MON] & M41T80_ALMON_AFE);
 	t->pending = !!(reg[M41T80_REG_FLAGS] & M41T80_FLAGS_AF);
-	return 0;
+	return rtc_valid_tm(t);
 }
 
 static struct rtc_class_ops m41t80_rtc_ops = {
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

