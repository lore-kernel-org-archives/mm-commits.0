From: akpm@linux-foundation.org
Subject: + rtc-add-driver-for-maxim-77802-pmic-real-time-clock-v10.patch
 added to -mm tree
Date: Fri, 19 Sep 2014 14:52:43 -0700
Message-ID: <541ca5ab.c32lWJJpYU+xPD7I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55547 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195AbaISVwo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Sep 2014 17:52:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: javier.martinez@collabora.co.uk, k.kozlowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-add-driver-for-maxim-77802-pmic-real-time-clock-v10
has been added to the -mm tree.  Its filename is
     rtc-add-driver-for-maxim-77802-pmic-real-time-clock-v10.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-add-driver-for-maxim-77802-pmic-real-time-clock-v10.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-add-driver-for-maxim-77802-pmic-real-time-clock-v10.patch

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
Subject: rtc-add-driver-for-maxim-77802-pmic-real-time-clock-v10

 - Use ffs() to calculate tm_wday instead of a custom function.
   Suggested by Andrew Morton.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max77802.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff -puN drivers/rtc/rtc-max77802.c~rtc-add-driver-for-maxim-77802-pmic-real-time-clock-v10 drivers/rtc/rtc-max77802.c
--- a/drivers/rtc/rtc-max77802.c~rtc-add-driver-for-maxim-77802-pmic-real-time-clock-v10
+++ a/drivers/rtc/rtc-max77802.c
@@ -75,18 +75,6 @@ enum MAX77802_RTC_OP {
 	MAX77802_RTC_READ,
 };
 
-static inline int max77802_rtc_calculate_wday(u8 shifted)
-{
-	int counter = -1;
-
-	while (shifted) {
-		shifted >>= 1;
-		counter++;
-	}
-
-	return counter;
-}
-
 static void max77802_rtc_data_to_tm(u8 *data, struct rtc_time *tm,
 				   int rtc_24hr_mode)
 {
@@ -100,7 +88,7 @@ static void max77802_rtc_data_to_tm(u8 *
 			tm->tm_hour += 12;
 	}
 
-	tm->tm_wday = max77802_rtc_calculate_wday(data[RTC_WEEKDAY] & 0xff);
+	tm->tm_wday = ffs(data[RTC_WEEKDAY] & 0xff) - 1;
 	tm->tm_mday = data[RTC_DATE] & 0x1f;
 	tm->tm_mon = (data[RTC_MONTH] & 0x0f) - 1;
 
_

Patches currently in -mm which might be from javier.martinez@collabora.co.uk are

rtc-rk808-add-rtc-driver-for-rk808.patch
clk-rk808-add-clkout-driver-for-rk808.patch
rtc-max77686-allow-the-max77686-rtc-to-wakeup-the-system.patch
rtc-max77686-remove-dead-code-for-smpl-and-wtsr.patch
rtc-max77686-fail-to-probe-if-no-rtc-regmap-irqchip-is-set.patch
rtc-max77686-remove-unneded-info-log.patch
rtc-max77686-use-ffs-to-calculate-tm_wday.patch
rtc-max77686-use-ffs-to-calculate-tm_wday-fix.patch
rtc-add-driver-for-maxim-77802-pmic-real-time-clock.patch
rtc-add-driver-for-maxim-77802-pmic-real-time-clock-v10.patch
linux-next.patch

