From: akpm@linux-foundation.org
Subject: + rtc-omap-use-dev_info.patch added to -mm tree
Date: Wed, 22 Oct 2014 12:04:32 -0700
Message-ID: <5447ffc0.rtFlAQgIUSkKQj7Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56427 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253AbaJVTEc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Oct 2014 15:04:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johan@kernel.org, a.zummo@towertech.it, balbi@ti.com, bcousson@baylibre.com, j-keerthy@ti.com, linux@roeck-us.net, lokeshvutla@ti.com, nsekhar@ti.com, t-kristo@ti.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: omap: use dev_info
has been added to the -mm tree.  Its filename is
     rtc-omap-use-dev_info.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-omap-use-dev_info.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-omap-use-dev_info.patch

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
Subject: rtc: omap: use dev_info

Use dev_info rather than pr_info.

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

 drivers/rtc/rtc-omap.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-use-dev_info drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-use-dev_info
+++ a/drivers/rtc/rtc-omap.c
@@ -427,8 +427,7 @@ static int __init omap_rtc_probe(struct
 	/* clear old status */
 	reg = rtc_read(OMAP_RTC_STATUS_REG);
 	if (reg & (u8) OMAP_RTC_STATUS_POWER_UP) {
-		pr_info("%s: RTC power up reset detected\n",
-			pdev->name);
+		dev_info(&pdev->dev, "RTC power up reset detected\n");
 		rtc_write(OMAP_RTC_STATUS_POWER_UP, OMAP_RTC_STATUS_REG);
 	}
 	if (reg & (u8) OMAP_RTC_STATUS_ALARM)
@@ -437,7 +436,7 @@ static int __init omap_rtc_probe(struct
 	/* On boards with split power, RTC_ON_NOFF won't reset the RTC */
 	reg = rtc_read(OMAP_RTC_CTRL_REG);
 	if (reg & (u8) OMAP_RTC_CTRL_STOP)
-		pr_info("%s: already running\n", pdev->name);
+		dev_info(&pdev->dev, "already running\n");
 
 	/* force to 24 hour mode */
 	new_ctrl = reg & (OMAP_RTC_CTRL_SPLIT|OMAP_RTC_CTRL_AUTO_COMP);
@@ -458,7 +457,7 @@ static int __init omap_rtc_probe(struct
 	 */
 
 	if (new_ctrl & (u8) OMAP_RTC_CTRL_SPLIT)
-		pr_info("%s: split power mode\n", pdev->name);
+		dev_info(&pdev->dev, "split power mode\n");
 
 	if (reg != new_ctrl)
 		rtc_write(new_ctrl, OMAP_RTC_CTRL_REG);
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

