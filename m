From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc.patch added to -mm tree
Date: Mon, 28 Nov 2011 14:56:26 -0800
Message-ID: <201111282256.pASMuRB3023240@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:35951 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab1K1W4f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 17:56:35 -0500
Received: by qyk15 with SMTP id 15so361829qyk.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 14:56:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jekhor@gmail.com, a.zummo@towertech.it, daniel@caiaq.de


The patch titled
     Subject: drivers/rtc/rtc-mxc.c: fix setting time for MX1 SoC
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc.patch

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
From: Yauhen Kharuzhy <jekhor@gmail.com>
Subject: drivers/rtc/rtc-mxc.c: fix setting time for MX1 SoC

There is no way to track year in the i.MX1 RTC: Days Counter register is
9-bit wide only.  Attempt to save date after 1970-01-01 plus 512 days
causes endless loop in mxc_rtc_set_mmss().  Fix this by resetting year to
1970.

Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>
Cc: Daniel Mack <daniel@caiaq.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mxc.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN drivers/rtc/rtc-mxc.c~drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc drivers/rtc/rtc-mxc.c
--- a/drivers/rtc/rtc-mxc.c~drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc
+++ a/drivers/rtc/rtc-mxc.c
@@ -290,6 +290,17 @@ static int mxc_rtc_read_time(struct devi
  */
 static int mxc_rtc_set_mmss(struct device *dev, unsigned long time)
 {
+	/* RTC_DAYR register is 9-bit in MX1 SoC,
+	 * save time and day of year only
+	 */
+	if (cpu_is_mx1()) {
+		struct rtc_time tm;
+
+		rtc_time_to_tm(time, &tm);
+		tm.tm_year = 70;
+		rtc_tm_to_time(&tm, &time);
+	}
+
 	/* Avoid roll-over from reading the different registers */
 	do {
 		set_alarm_or_time(dev, MXC_RTC_TIME, time);
_
Subject: Subject: drivers/rtc/rtc-mxc.c: fix setting time for MX1 SoC

Patches currently in -mm which might be from jekhor@gmail.com are

drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix.patch
drivers-rtc-rtc-mxcc-make-alarm-work.patch
drivers-rtc-rtc-mxcc-make-alarm-work-fix.patch

