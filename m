From: akpm@linux-foundation.org
Subject: + rtc-max77686-use-ffs-to-calculate-tm_wday.patch added to -mm
 tree
Date: Fri, 19 Sep 2014 14:51:18 -0700
Message-ID: <541ca556.ZZD1n8FBygOgKuEC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195AbaISVvT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Sep 2014 17:51:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: javier.martinez@collabora.co.uk, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: max77686: Use ffs() to calculate tm_wday
has been added to the -mm tree.  Its filename is
     rtc-max77686-use-ffs-to-calculate-tm_wday.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-max77686-use-ffs-to-calculate-tm_wday.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-max77686-use-ffs-to-calculate-tm_wday.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: rtc: max77686: Use ffs() to calculate tm_wday

max77686_rtc_calculate_wday() is used to calculate the day of the week to
be filled in struct rtc_time but that function only calculates the number
of bits shifted.  So the ffs() function can be used to find the first bit
set instead of a special function.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max77686.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff -puN drivers/rtc/rtc-max77686.c~rtc-max77686-use-ffs-to-calculate-tm_wday drivers/rtc/rtc-max77686.c
--- a/drivers/rtc/rtc-max77686.c~rtc-max77686-use-ffs-to-calculate-tm_wday
+++ a/drivers/rtc/rtc-max77686.c
@@ -70,16 +70,6 @@ enum MAX77686_RTC_OP {
 	MAX77686_RTC_READ,
 };
 
-static inline int max77686_rtc_calculate_wday(u8 shifted)
-{
-	int counter = -1;
-	while (shifted) {
-		shifted >>= 1;
-		counter++;
-	}
-	return counter;
-}
-
 static void max77686_rtc_data_to_tm(u8 *data, struct rtc_time *tm,
 				   int rtc_24hr_mode)
 {
@@ -93,7 +83,7 @@ static void max77686_rtc_data_to_tm(u8 *
 			tm->tm_hour += 12;
 	}
 
-	tm->tm_wday = max77686_rtc_calculate_wday(data[RTC_WEEKDAY] & 0x7f);
+	tm->tm_wday = ffs(data[RTC_WEEKDAY] & 0x7f) - 1;
 	tm->tm_mday = data[RTC_DATE] & 0x1f;
 	tm->tm_mon = (data[RTC_MONTH] & 0x0f) - 1;
 	tm->tm_year = (data[RTC_YEAR] & 0x7f) + 100;
_

Patches currently in -mm which might be from javier.martinez@collabora.co.uk are

rtc-rk808-add-rtc-driver-for-rk808.patch
clk-rk808-add-clkout-driver-for-rk808.patch
rtc-max77686-allow-the-max77686-rtc-to-wakeup-the-system.patch
rtc-max77686-remove-dead-code-for-smpl-and-wtsr.patch
rtc-max77686-fail-to-probe-if-no-rtc-regmap-irqchip-is-set.patch
rtc-max77686-remove-unneded-info-log.patch
rtc-max77686-use-ffs-to-calculate-tm_wday.patch
rtc-add-driver-for-maxim-77802-pmic-real-time-clock.patch
rtc-add-driver-for-maxim-77802-pmic-real-time-clock-v10.patch
linux-next.patch

