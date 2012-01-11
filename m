From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:31:59 -0800
Message-ID: <20120111213159.A07E11E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:61363 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab2AKVcA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:32:00 -0500
Received: by mail-gx0-f202.google.com with SMTP id k3so134903ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:32:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jekhor@gmail.com, a.zummo@towertech.it, daniel@caiaq.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-mxc.c: fix setting time for MX1 SoC
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Yauhen Kharuzhy <jekhor@gmail.com>
Subject: drivers/rtc/rtc-mxc.c: fix setting time for MX1 SoC

There is no way to track year in the i.MX1 RTC: Days Counter register is
9-bit wide only.  Attempt to save date after 1970-01-01 plus 512 days
causes endless loop in mxc_rtc_set_mmss().  Fix this by resetting year to
1970.

[akpm@linux-foundation.org: use conventional comment layout]
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
+	/*
+	 * TTC_DAYR register is 9-bit in MX1 SoC, save time and day of year only
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

Patches currently in -mm which might be from jekhor@gmail.com are

origin.patch

