From: akpm@linux-foundation.org
Subject: [folded-merged]
 rtc-add-driver-for-maxim-77802-pmic-real-time-clock-v10.patch removed from
 -mm tree
Date: Mon, 13 Oct 2014 15:39:09 -0700
Message-ID: <543c548d.UMcG2LAjuJUzPhfs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34674 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaJMWjK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 18:39:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: javier.martinez@collabora.co.uk, k.kozlowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-add-driver-for-maxim-77802-pmic-real-time-clock-v10
has been removed from the -mm tree.  Its filename was
     rtc-add-driver-for-maxim-77802-pmic-real-time-clock-v10.patch

This patch was dropped because it was folded into rtc-add-driver-for-maxim-77802-pmic-real-time-clock.patch

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

origin.patch
rtc-rk808-add-rtc-driver-for-rk808.patch
clk-rk808-add-clkout-driver-for-rk808.patch
rtc-max77686-allow-the-max77686-rtc-to-wakeup-the-system.patch
rtc-max77686-remove-dead-code-for-smpl-and-wtsr.patch
rtc-max77686-fail-to-probe-if-no-rtc-regmap-irqchip-is-set.patch
rtc-max77686-remove-unneded-info-log.patch
rtc-max77686-use-ffs-to-calculate-tm_wday.patch
rtc-add-driver-for-maxim-77802-pmic-real-time-clock.patch
rtc-add-driver-for-maxim-77802-pmic-real-time-clock-v10-fix.patch

