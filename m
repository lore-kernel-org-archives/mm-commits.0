From: akpm@linux-foundation.org
Subject: + rtc-omap-add-helper-to-read-raw-bcd-time.patch added to -mm
 tree
Date: Wed, 22 Oct 2014 12:04:40 -0700
Message-ID: <5447ffc8.MglyJI07tYMHWN6+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56458 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279AbaJVTEk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Oct 2014 15:04:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johan@kernel.org, a.zummo@towertech.it, balbi@ti.com, bcousson@baylibre.com, j-keerthy@ti.com, linux@roeck-us.net, lokeshvutla@ti.com, nsekhar@ti.com, t-kristo@ti.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: omap: add helper to read raw bcd time
has been added to the -mm tree.  Its filename is
     rtc-omap-add-helper-to-read-raw-bcd-time.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-omap-add-helper-to-read-raw-bcd-time.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-omap-add-helper-to-read-raw-bcd-time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Felipe Balbi <balbi@ti.com>
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

rtc-omap-fix-clock-source-configuration.patch
rtc-omap-fix-missing-wakealarm-attribute.patch
rtc-omap-fix-interrupt-disable-at-probe.patch
rtc-omap-clean-up-probe-error-handling.patch
rtc-omap-fix-class-device-registration.patch
rtc-omap-remove-unused-register-base-define.patch
rtc-omap-use-dev_info.patch
rtc-omap-make-platform-device-id-table-const.patch
rtc-omap-add-device-abstraction.patch
rtc-omap-remove-driver_name-macro.patch
rtc-omap-add-structured-device-type-info.patch
rtc-omap-silence-bogus-power-up-reset-message-at-probe.patch
rtc-omap-add-helper-to-read-raw-bcd-time.patch
rtc-omap-add-helper-to-read-32-bit-registers.patch
rtc-omap-add-support-for-pmic_power_en.patch
rtc-omap-enable-wake-up-from-power-off.patch
rtc-omap-fix-minor-coding-style-issues.patch
rtc-omap-add-copyright-entry.patch
arm-dts-am33xx-update-rtc-node-compatible-property.patch
arm-dts-am335x-boneblack-enable-power-off-and-rtc-wake-up.patch
linux-next.patch

