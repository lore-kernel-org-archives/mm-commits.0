From: akpm@linux-foundation.org
Subject: [merged] rtc-omap-enable-wake-up-from-power-off.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 11:06:51 -0800
Message-ID: <5489eb4b.qt4HvdZmKtAbayfP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420AbaLKTGw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:06:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johan@kernel.org, a.zummo@towertech.it, balbi@ti.com, bcousson@baylibre.com, j-keerthy@ti.com, linux@roeck-us.net, lokeshvutla@ti.com, nsekhar@ti.com, t-kristo@ti.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: omap: enable wake-up from power off
has been removed from the -mm tree.  Its filename was
     rtc-omap-enable-wake-up-from-power-off.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johan Hovold <johan@kernel.org>
Subject: rtc: omap: enable wake-up from power off

The ALARM interrupt must not be disabled during shutdown in order to be
able to power up the system using an RTC alarm.

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

 drivers/rtc/rtc-omap.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-enable-wake-up-from-power-off drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-enable-wake-up-from-power-off
+++ a/drivers/rtc/rtc-omap.c
@@ -694,8 +694,15 @@ static SIMPLE_DEV_PM_OPS(omap_rtc_pm_ops
 static void omap_rtc_shutdown(struct platform_device *pdev)
 {
 	struct omap_rtc *rtc = platform_get_drvdata(pdev);
+	u8 mask;
 
-	rtc_write(rtc, OMAP_RTC_INTERRUPTS_REG, 0);
+	/*
+	 * Keep the ALARM interrupt enabled to allow the system to power up on
+	 * alarm events.
+	 */
+	mask = rtc_read(rtc, OMAP_RTC_INTERRUPTS_REG);
+	mask &= OMAP_RTC_INTERRUPTS_IT_ALARM;
+	rtc_write(rtc, OMAP_RTC_INTERRUPTS_REG, mask);
 }
 
 static struct platform_driver omap_rtc_driver = {
_

Patches currently in -mm which might be from johan@kernel.org are

origin.patch
linux-next.patch

