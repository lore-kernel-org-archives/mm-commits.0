From: akpm@linux-foundation.org
Subject: [merged] rtc-omap-add-helper-to-read-raw-bcd-time.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 11:06:42 -0800
Message-ID: <5489eb42.bVfPBE066ZMbz37y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758483AbaLKTGn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:06:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johan@kernel.org, a.zummo@towertech.it, balbi@ti.com, bcousson@baylibre.com, j-keerthy@ti.com, linux@roeck-us.net, lokeshvutla@ti.com, nsekhar@ti.com, t-kristo@ti.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: omap: add helper to read raw bcd time
has been removed from the -mm tree.  Its filename was
     rtc-omap-add-helper-to-read-raw-bcd-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johan Hovold <johan@kernel.org>
Subject: rtc: omap: add helper to read raw bcd time

Add helper to read raw BCD time that can be used in interrupt context.

Signed-off-by: Johan Hovold <johan@kernel.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Benot Cousson <bcousson@baylibre.com>
Cc: Lokesh Vutla <lokeshvutla@ti.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>
Cc: Keerthy J <j-keerthy@ti.com>
Tested-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-omap.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-add-helper-to-read-raw-bcd-time drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-add-helper-to-read-raw-bcd-time
+++ a/drivers/rtc/rtc-omap.c
@@ -234,22 +234,24 @@ static void bcd2tm(struct rtc_time *tm)
 	tm->tm_year = bcd2bin(tm->tm_year) + 100;
 }
 
-
-static int omap_rtc_read_time(struct device *dev, struct rtc_time *tm)
+static void omap_rtc_read_time_raw(struct omap_rtc *rtc, struct rtc_time *tm)
 {
-	struct omap_rtc *rtc = dev_get_drvdata(dev);
-
-	/* we don't report wday/yday/isdst ... */
-	local_irq_disable();
-	rtc_wait_not_busy(rtc);
-
 	tm->tm_sec = rtc_read(rtc, OMAP_RTC_SECONDS_REG);
 	tm->tm_min = rtc_read(rtc, OMAP_RTC_MINUTES_REG);
 	tm->tm_hour = rtc_read(rtc, OMAP_RTC_HOURS_REG);
 	tm->tm_mday = rtc_read(rtc, OMAP_RTC_DAYS_REG);
 	tm->tm_mon = rtc_read(rtc, OMAP_RTC_MONTHS_REG);
 	tm->tm_year = rtc_read(rtc, OMAP_RTC_YEARS_REG);
+}
+
+static int omap_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct omap_rtc *rtc = dev_get_drvdata(dev);
 
+	/* we don't report wday/yday/isdst ... */
+	local_irq_disable();
+	rtc_wait_not_busy(rtc);
+	omap_rtc_read_time_raw(rtc, tm);
 	local_irq_enable();
 
 	bcd2tm(tm);
_

Patches currently in -mm which might be from johan@kernel.org are

origin.patch
linux-next.patch

