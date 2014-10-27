From: akpm@linux-foundation.org
Subject: + rtc-omap-add-support-for-pmic_power_en-v3.patch added to -mm
 tree
Date: Mon, 27 Oct 2014 15:40:47 -0700
Message-ID: <544ec9ef.FD2uq0ji6ruNvad7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaJ0Wkr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Oct 2014 18:40:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johan@kernel.org, a.zummo@towertech.it, anilkumar@ti.com, balbi@ti.com, bcousson@baylibre.com, colin.foeparker@logicpd.com, j-keerthy@ti.com, linux@roeck-us.net, lokeshvutla@ti.com, nsekhar@ti.com, t-kristo@ti.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: omap: add support for pmic_power_en
has been added to the -mm tree.  Its filename is
     rtc-omap-add-support-for-pmic_power_en-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-omap-add-support-for-pmic_power_en-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-omap-add-support-for-pmic_power_en-v3.patch

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
Subject: rtc: omap: add support for pmic_power_en

Signed-off-by: Johan Hovold <johan@kernel.org>
Tested-by: Felipe Balbi <balbi@ti.com>
Cc: Colin Foe-Parker <colin.foeparker@logicpd.com>
Cc: AnilKumar Ch <anilkumar@ti.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Benot Cousson <bcousson@baylibre.com>
Cc: Lokesh Vutla <lokeshvutla@ti.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>
Cc: Keerthy J <j-keerthy@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-omap.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-add-support-for-pmic_power_en-v3 drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-add-support-for-pmic_power_en-v3
+++ a/drivers/rtc/rtc-omap.c
@@ -416,6 +416,8 @@ static void omap_rtc_power_off(void)
 	val = rtc_read(rtc, OMAP_RTC_INTERRUPTS_REG);
 	rtc_writel(rtc, OMAP_RTC_INTERRUPTS_REG,
 			val | OMAP_RTC_INTERRUPTS_IT_ALARM2);
+
+	mdelay(2000);
 }
 
 static struct rtc_class_ops omap_rtc_ops = {
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
rtc-omap-add-support-for-pmic_power_en-v3.patch
rtc-omap-add-support-for-pmic_power_en-v3-fix.patch
rtc-omap-enable-wake-up-from-power-off.patch
rtc-omap-fix-minor-coding-style-issues.patch
rtc-omap-add-copyright-entry.patch
arm-dts-am33xx-update-rtc-node-compatible-property.patch
arm-dts-am335x-boneblack-enable-power-off-and-rtc-wake-up.patch
linux-next.patch

