From: akpm@linux-foundation.org
Subject: [folded-merged] rtc-omap-add-support-for-pmic_power_en-v4.patch
 removed from -mm tree
Date: Wed, 10 Dec 2014 15:21:38 -0800
Message-ID: <5488d582.8qpxECLtyBPsQRqJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58347 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125AbaLJXVj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Dec 2014 18:21:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johan@kernel.org, a.zummo@towertech.it, balbi@ti.com, bcousson@baylibre.com, j-keerthy@ti.com, linux@roeck-us.net, lokeshvutla@ti.com, nsekhar@ti.com, t-kristo@ti.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: omap: add support for pmic_power_en v4
has been removed from the -mm tree.  Its filename was
     rtc-omap-add-support-for-pmic_power_en-v4.patch

This patch was dropped because it was folded into rtc-omap-add-support-for-pmic_power_en.patch

------------------------------------------------------
From: Johan Hovold <johan@kernel.org>
Subject: rtc: omap: add support for pmic_power_en v4

Here's an updated patch, which adds a comment on why there is a delay
after activating the alarm.

Note that I also increased the delay to include a margin for external
latencies. For example, on Beaglebone Black, the PMIC has a 50ms
deglitch time on the PWR_EN pin (which is connected to pmic_power_en).

Such margins should probably eventually be specified through device
tree, for instance, as an attribute to accompany the
system-power-controller attribute and be handled by the power-off call
chain infrastructure.

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

 drivers/rtc/rtc-omap.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-add-support-for-pmic_power_en-v4 drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-add-support-for-pmic_power_en-v4
+++ a/drivers/rtc/rtc-omap.c
@@ -373,7 +373,7 @@ static struct omap_rtc *omap_rtc_power_o
  * The two-second alarm offset is the shortest offset possible as the alarm
  * registers must be set before the next timer update and the offset
  * calculation is too heavy for everything to be done within a single access
- * period (~15us).
+ * period (~15 us).
  *
  * Called with local interrupts disabled.
  */
@@ -417,8 +417,12 @@ static void omap_rtc_power_off(void)
 	rtc_writel(rtc, OMAP_RTC_INTERRUPTS_REG,
 			val | OMAP_RTC_INTERRUPTS_IT_ALARM2);
 
-	/* Allow alarm to trigger before returning */
-	mdelay(2000);
+	/*
+	 * Wait for alarm to trigger (within two seconds) and external PMIC to
+	 * power off the system. Add a 500 ms margin for external latencies
+	 * (e.g. debounce circuits).
+	 */
+	mdelay(2500);
 }
 
 static struct rtc_class_ops omap_rtc_ops = {
_

Patches currently in -mm which might be from johan@kernel.org are

origin.patch
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
rtc-omap-drop-vendor-prefix-from-power-controller-dt-property.patch

