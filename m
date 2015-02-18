From: akpm@linux-foundation.org
Subject: +
 rtc-ds1685-remove-superfluous-checks-for-out-of-range-u8-values.patch added to -mm tree
Date: Wed, 18 Feb 2015 12:16:10 -0800
Message-ID: <54e4f30a.e6jgM2yUAsMaDpfS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46684 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbbBRUQL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 15:16:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, a.zummo@towertech.it, kumba@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: ds1685: remove superfluous checks for out-of-range u8 values
has been added to the -mm tree.  Its filename is
     rtc-ds1685-remove-superfluous-checks-for-out-of-range-u8-values.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-ds1685-remove-superfluous-checks-for-out-of-range-u8-values.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-ds1685-remove-superfluous-checks-for-out-of-range-u8-values.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: rtc: ds1685: remove superfluous checks for out-of-range u8 values

drivers/rtc/rtc-ds1685.c: In function `ds1685_rtc_read_alarm':
drivers/rtc/rtc-ds1685.c:402: warning: comparison is always true due to limited range of data type
drivers/rtc/rtc-ds1685.c:409: warning: comparison is always true due to limited range of data type
drivers/rtc/rtc-ds1685.c:416: warning: comparison is always true due to limited range of data type
drivers/rtc/rtc-ds1685.c: In function `ds1685_rtc_set_alarm':
drivers/rtc/rtc-ds1685.c:475: warning: comparison is always true due to limited range of data type
drivers/rtc/rtc-ds1685.c:478: warning: comparison is always true due to limited range of data type
drivers/rtc/rtc-ds1685.c:481: warning: comparison is always true due to limited range of data type

u8 cannot contain a value larger than 0xff, hence drop the checks. 
Wrapping the checks in unlikely() indicated some sense of humor, though ;-)

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Joshua Kinard <kumba@gentoo.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1685.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-ds1685.c~rtc-ds1685-remove-superfluous-checks-for-out-of-range-u8-values drivers/rtc/rtc-ds1685.c
--- a/drivers/rtc/rtc-ds1685.c~rtc-ds1685-remove-superfluous-checks-for-out-of-range-u8-values
+++ a/drivers/rtc/rtc-ds1685.c
@@ -399,21 +399,21 @@ ds1685_rtc_read_alarm(struct device *dev
 	 * of this RTC chip.  We check for it anyways in case support is
 	 * added in the future.
 	 */
-	if (unlikely((seconds >= 0xc0) && (seconds <= 0xff)))
+	if (unlikely(seconds >= 0xc0))
 		alrm->time.tm_sec = -1;
 	else
 		alrm->time.tm_sec = ds1685_rtc_bcd2bin(rtc, seconds,
 						       RTC_SECS_BCD_MASK,
 						       RTC_SECS_BIN_MASK);
 
-	if (unlikely((minutes >= 0xc0) && (minutes <= 0xff)))
+	if (unlikely(minutes >= 0xc0))
 		alrm->time.tm_min = -1;
 	else
 		alrm->time.tm_min = ds1685_rtc_bcd2bin(rtc, minutes,
 						       RTC_MINS_BCD_MASK,
 						       RTC_MINS_BIN_MASK);
 
-	if (unlikely((hours >= 0xc0) && (hours <= 0xff)))
+	if (unlikely(hours >= 0xc0))
 		alrm->time.tm_hour = -1;
 	else
 		alrm->time.tm_hour = ds1685_rtc_bcd2bin(rtc, hours,
@@ -472,13 +472,13 @@ ds1685_rtc_set_alarm(struct device *dev,
 	 * field, and we only support four fields.  We put the support
 	 * here anyways for the future.
 	 */
-	if (unlikely((seconds >= 0xc0) && (seconds <= 0xff)))
+	if (unlikely(seconds >= 0xc0))
 		seconds = 0xff;
 
-	if (unlikely((minutes >= 0xc0) && (minutes <= 0xff)))
+	if (unlikely(minutes >= 0xc0))
 		minutes = 0xff;
 
-	if (unlikely((hours >= 0xc0) && (hours <= 0xff)))
+	if (unlikely(hours >= 0xc0))
 		hours = 0xff;
 
 	alrm->time.tm_mon	= -1;
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
rtc-ds1685-remove-superfluous-checks-for-out-of-range-u8-values.patch
linux-next.patch

