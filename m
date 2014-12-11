From: akpm@linux-foundation.org
Subject: [merged]
 rtc-omap-silence-bogus-power-up-reset-message-at-probe.patch removed from
 -mm tree
Date: Thu, 11 Dec 2014 11:06:39 -0800
Message-ID: <5489eb3f.t59D2LQxcDIP3pbN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45831 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758476AbaLKTGk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:06:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johan@kernel.org, a.zummo@towertech.it, balbi@ti.com, bcousson@baylibre.com, j-keerthy@ti.com, linux@roeck-us.net, lokeshvutla@ti.com, nsekhar@ti.com, t-kristo@ti.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: omap: silence bogus power-up reset message at probe
has been removed from the -mm tree.  Its filename was
     rtc-omap-silence-bogus-power-up-reset-message-at-probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johan Hovold <johan@kernel.org>
Subject: rtc: omap: silence bogus power-up reset message at probe

Some legacy RTC IP revisions has a power-up reset flag in the status
register that later revisions lack.

As this flag is always read back as set on later revisions (or is
overloaded with a different flag), make sure to only clear the flag and
print the info message on legacy platforms.

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

 drivers/rtc/rtc-omap.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-silence-bogus-power-up-reset-message-at-probe drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-silence-bogus-power-up-reset-message-at-probe
+++ a/drivers/rtc/rtc-omap.c
@@ -106,6 +106,7 @@ struct omap_rtc_device_type {
 	bool has_32kclk_en;
 	bool has_kicker;
 	bool has_irqwakeen;
+	bool has_power_up_reset;
 };
 
 struct omap_rtc {
@@ -346,6 +347,7 @@ static struct rtc_class_ops omap_rtc_ops
 };
 
 static const struct omap_rtc_device_type omap_rtc_default_type = {
+	.has_power_up_reset = true,
 };
 
 static const struct omap_rtc_device_type omap_rtc_am3352_type = {
@@ -391,7 +393,7 @@ static int __init omap_rtc_probe(struct
 {
 	struct omap_rtc		*rtc;
 	struct resource		*res;
-	u8			reg, new_ctrl;
+	u8			reg, mask, new_ctrl;
 	const struct platform_device_id *id_entry;
 	const struct of_device_id *of_id;
 	int ret;
@@ -448,12 +450,17 @@ static int __init omap_rtc_probe(struct
 
 	/* clear old status */
 	reg = rtc_read(rtc, OMAP_RTC_STATUS_REG);
-	if (reg & (u8) OMAP_RTC_STATUS_POWER_UP) {
-		dev_info(&pdev->dev, "RTC power up reset detected\n");
-		rtc_write(rtc, OMAP_RTC_STATUS_REG, OMAP_RTC_STATUS_POWER_UP);
+
+	mask = OMAP_RTC_STATUS_ALARM;
+
+	if (rtc->type->has_power_up_reset) {
+		mask |= OMAP_RTC_STATUS_POWER_UP;
+		if (reg & OMAP_RTC_STATUS_POWER_UP)
+			dev_info(&pdev->dev, "RTC power up reset detected\n");
 	}
-	if (reg & (u8) OMAP_RTC_STATUS_ALARM)
-		rtc_write(rtc, OMAP_RTC_STATUS_REG, OMAP_RTC_STATUS_ALARM);
+
+	if (reg & mask)
+		rtc_write(rtc, OMAP_RTC_STATUS_REG, reg & mask);
 
 	/* On boards with split power, RTC_ON_NOFF won't reset the RTC */
 	reg = rtc_read(rtc, OMAP_RTC_CTRL_REG);
_

Patches currently in -mm which might be from johan@kernel.org are

origin.patch
linux-next.patch

