From: akpm@linux-foundation.org
Subject: + rtc-max8907-weekday-encoding-fixes.patch added to -mm tree
Date: Mon, 13 Jan 2014 16:07:19 -0800
Message-ID: <52d47fb7.b7BsEYI+i3NETcTd%akpm__24940.6085153625$1389658049$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53683 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaANAHT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jan 2014 19:07:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, swarren@nvidia.com

Subject: + rtc-max8907-weekday-encoding-fixes.patch added to -mm tree
To: swarren@nvidia.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 13 Jan 2014 16:07:19 -0800


The patch titled
     Subject: rtc: max8907: weekday encoding fixes
has been added to the -mm tree.  Its filename is
     rtc-max8907-weekday-encoding-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-max8907-weekday-encoding-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-max8907-weekday-encoding-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Warren <swarren@nvidia.com>
Subject: rtc: max8907: weekday encoding fixes

The current MAX8907 driver has two issues related to weekday value
handling:

1)

The HW WEEKDAY register has range 0..6 rather than 1..7 as documented,
hence we should write Linux's tm_wday value to the register without
modifying it.  Fix the driver not to add/subtract 1 when handling this
register.

Note that I validated the actual HW range by observing the HW register
roll from 6->0 rather than 6->7->1 as would otherwise be expected.  This
also matches the fact that when the CMOS RAM content is lost and reads all
zeroes, the date returned from the device is 2007-01-01, which is a
Monday, and the WEEKDAY register reads 0 in this case.

2)

There's no need to make alarms match on the WEEKDAY register, since the
other fields together uniquely define the alarm date/time.  Ignoring the
WEEKDAY value in the match isolates the driver from any incorrect value in
the current time copy of the WEEKDAY register.

Each change individually, or both together, solves an issue that I
observed; "hwclock -r" would time out waiting for its alarm to fire if the
CMOS RAM content had been lost, and hence the WEEKDAY register value
mismatched what the driver expected it to be.  "hwclock -w" would solve
this by over-writing the HW default WEEKDAY register value with what the
driver expected.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max8907.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-max8907.c~rtc-max8907-weekday-encoding-fixes drivers/rtc/rtc-max8907.c
--- a/drivers/rtc/rtc-max8907.c~rtc-max8907-weekday-encoding-fixes
+++ a/drivers/rtc/rtc-max8907.c
@@ -51,7 +51,7 @@ static irqreturn_t max8907_irq_handler(i
 {
 	struct max8907_rtc *rtc = data;
 
-	regmap_update_bits(rtc->regmap, MAX8907_REG_ALARM0_CNTL, 0x7f, 0);
+	regmap_write(rtc->regmap, MAX8907_REG_ALARM0_CNTL, 0);
 
 	rtc_update_irq(rtc->rtc_dev, 1, RTC_IRQF | RTC_AF);
 
@@ -64,7 +64,7 @@ static void regs_to_tm(u8 *regs, struct
 		bcd2bin(regs[RTC_YEAR1]) - 1900;
 	tm->tm_mon = bcd2bin(regs[RTC_MONTH] & 0x1f) - 1;
 	tm->tm_mday = bcd2bin(regs[RTC_DATE] & 0x3f);
-	tm->tm_wday = (regs[RTC_WEEKDAY] & 0x07) - 1;
+	tm->tm_wday = (regs[RTC_WEEKDAY] & 0x07);
 	if (regs[RTC_HOUR] & HOUR_12) {
 		tm->tm_hour = bcd2bin(regs[RTC_HOUR] & 0x01f);
 		if (tm->tm_hour == 12)
@@ -88,7 +88,7 @@ static void tm_to_regs(struct rtc_time *
 	regs[RTC_YEAR1] = bin2bcd(low);
 	regs[RTC_MONTH] = bin2bcd(tm->tm_mon + 1);
 	regs[RTC_DATE] = bin2bcd(tm->tm_mday);
-	regs[RTC_WEEKDAY] = tm->tm_wday + 1;
+	regs[RTC_WEEKDAY] = tm->tm_wday;
 	regs[RTC_HOUR] = bin2bcd(tm->tm_hour);
 	regs[RTC_MIN] = bin2bcd(tm->tm_min);
 	regs[RTC_SEC] = bin2bcd(tm->tm_sec);
@@ -153,7 +153,7 @@ static int max8907_rtc_set_alarm(struct
 	tm_to_regs(&alrm->time, regs);
 
 	/* Disable alarm while we update the target time */
-	ret = regmap_update_bits(rtc->regmap, MAX8907_REG_ALARM0_CNTL, 0x7f, 0);
+	ret = regmap_write(rtc->regmap, MAX8907_REG_ALARM0_CNTL, 0);
 	if (ret < 0)
 		return ret;
 
@@ -163,8 +163,7 @@ static int max8907_rtc_set_alarm(struct
 		return ret;
 
 	if (alrm->enabled)
-		ret = regmap_update_bits(rtc->regmap, MAX8907_REG_ALARM0_CNTL,
-					 0x7f, 0x7f);
+		ret = regmap_write(rtc->regmap, MAX8907_REG_ALARM0_CNTL, 0x77);
 
 	return ret;
 }
_

Patches currently in -mm which might be from swarren@nvidia.com are

rtc-honor-device-tree-alias-entries-when-assigning-ids.patch
rtc-honor-device-tree-alias-entries-when-assigning-ids-v2.patch
rtc-max8907-weekday-encoding-fixes.patch
linux-next.patch

