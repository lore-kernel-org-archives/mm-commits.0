From: akpm@linux-foundation.org
Subject: + rtc-omap-fix-missing-wakealarm-attribute.patch added to -mm
 tree
Date: Wed, 22 Oct 2014 12:04:27 -0700
Message-ID: <5447ffbb.hhUGHHwB8Jbh6tqh%akpm__23145.8338247196$1414004685$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56390 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242AbaJVTE2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Oct 2014 15:04:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johan@kernel.org, a.zummo@towertech.it, balbi@ti.com, bcousson@baylibre.com, j-keerthy@ti.com, linux@roeck-us.net, lokeshvutla@ti.com, nsekhar@ti.com, stable@vger.kernel.org, t-kristo@ti.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: omap: fix missing wakealarm attribute
has been added to the -mm tree.  Its filename is
     rtc-omap-fix-missing-wakealarm-attribute.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-omap-fix-missing-wakealarm-attribute.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-omap-fix-missing-wakealarm-attribute.patch

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
Subject: rtc: omap: fix missing wakealarm attribute

The platform device must be registered as wakeup capable before
registering the class device, or the wakealarm attribute will not be
created.

Also make sure to unregister the wakeup source on probe errors.

Fixes: 1d2e2b65d098 ("rtc: omap: restore back (hard-code) wakeup support")
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

 drivers/rtc/rtc-omap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-fix-missing-wakealarm-attribute drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-fix-missing-wakealarm-attribute
+++ a/drivers/rtc/rtc-omap.c
@@ -416,6 +416,8 @@ static int __init omap_rtc_probe(struct
 		rtc_writel(KICK1_VALUE, OMAP_RTC_KICK1_REG);
 	}
 
+	device_init_wakeup(&pdev->dev, true);
+
 	rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 			&omap_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
@@ -484,8 +486,6 @@ static int __init omap_rtc_probe(struct
 	 *    is write-only, and always reads as zero...)
 	 */
 
-	device_init_wakeup(&pdev->dev, true);
-
 	if (new_ctrl & (u8) OMAP_RTC_CTRL_SPLIT)
 		pr_info("%s: split power mode\n", pdev->name);
 
@@ -495,6 +495,7 @@ static int __init omap_rtc_probe(struct
 	return 0;
 
 fail0:
+	device_init_wakeup(&pdev->dev, false);
 	if (id_entry->driver_data & OMAP_RTC_HAS_KICKER)
 		rtc_writel(0, OMAP_RTC_KICK0_REG);
 	pm_runtime_put_sync(&pdev->dev);
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

