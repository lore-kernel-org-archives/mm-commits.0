From: akpm@linux-foundation.org
Subject: + rtc-omap-fix-clock-source-configuration.patch added to -mm tree
Date: Wed, 22 Oct 2014 12:04:26 -0700
Message-ID: <5447ffba.LOp7pQZuh7MTUmil%akpm__48123.5300693244$1414004678$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbaJVTE1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Oct 2014 15:04:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johan@kernel.org, a.zummo@towertech.it, balbi@ti.com, bcousson@baylibre.com, j-keerthy@ti.com, linux@roeck-us.net, lokeshvutla@ti.com, nsekhar@ti.com, stable@vger.kernel.org, t-kristo@ti.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: omap: fix clock-source configuration
has been added to the -mm tree.  Its filename is
     rtc-omap-fix-clock-source-configuration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-omap-fix-clock-source-configuration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-omap-fix-clock-source-configuration.patch

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
Subject: rtc: omap: fix clock-source configuration

This series fixes a few issues with the omap rtc-driver, cleans up a bit,
adds device abstraction, and finally adds support for the PMIC control
feature found in some revisions of this RTC IP block.

Ultimately, this allows for powering off the Beaglebone and waking it up
again on RTC alarms.



This patch (of 20):

Make sure not to reset the clock-source configuration when enabling the
32kHz clock mux.

Until the clock source can be configured through device tree we must not
overwrite settings made by the bootloader (e.g.  clock-source selection).

Fixes: cd914bba03d8 ("drivers/rtc/rtc-omap.c: add support for enabling
32khz clock")
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Benot Cousson <bcousson@baylibre.com>
Cc: Lokesh Vutla <lokeshvutla@ti.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>
Cc: Keerthy J <j-keerthy@ti.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-omap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-fix-clock-source-configuration drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-fix-clock-source-configuration
+++ a/drivers/rtc/rtc-omap.c
@@ -431,8 +431,10 @@ static int __init omap_rtc_probe(struct
 	rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
 
 	/* enable RTC functional clock */
-	if (id_entry->driver_data & OMAP_RTC_HAS_32KCLK_EN)
-		rtc_writel(OMAP_RTC_OSC_32KCLK_EN, OMAP_RTC_OSC_REG);
+	if (id_entry->driver_data & OMAP_RTC_HAS_32KCLK_EN) {
+		reg = rtc_read(OMAP_RTC_OSC_REG);
+		rtc_writel(reg | OMAP_RTC_OSC_32KCLK_EN, OMAP_RTC_OSC_REG);
+	}
 
 	/* clear old status */
 	reg = rtc_read(OMAP_RTC_STATUS_REG);
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

