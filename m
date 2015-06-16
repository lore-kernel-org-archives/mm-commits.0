From: akpm@linux-foundation.org
Subject: [-] rtc-omap-add-external-32k-clock-feature.patch removed from
 -mm tree
Date: Tue, 16 Jun 2015 13:04:48 -0700
Message-ID: <55808160.hRkJk5FUPPG+VH/8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35743 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757187AbbFPUEs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jun 2015 16:04:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: j-keerthy@ti.com, a.zummo@towertech.it, alexandre.belloni@free-electrons.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-omap.c: add external 32k clock feature
has been removed from the -mm tree.  Its filename was
     rtc-omap-add-external-32k-clock-feature.patch

This patch was dropped because Alexandre is taking care of it

------------------------------------------------------
From: Keerthy <j-keerthy@ti.com>
Subject: drivers/rtc/rtc-omap.c: add external 32k clock feature

Add external 32k clock feature.  The internal clock will be gated during
suspend.  Hence make use of the external 32k clock so that rtc is
functional accross suspend/resume.

Signed-off-by: Keerthy <j-keerthy@ti.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-omap.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-add-external-32k-clock-feature drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-add-external-32k-clock-feature
+++ a/drivers/rtc/rtc-omap.c
@@ -107,6 +107,8 @@
 
 /* OMAP_RTC_OSC_REG bit fields: */
 #define OMAP_RTC_OSC_32KCLK_EN		BIT(6)
+#define OMAP_RTC_OSC_OSC32K_GZ		BIT(4)
+#define OMAP_RTC_OSC_EXT_32K		BIT(3)
 
 /* OMAP_RTC_IRQWAKEEN bit fields: */
 #define OMAP_RTC_IRQWAKEEN_ALARM_WAKEEN	BIT(1)
@@ -122,6 +124,7 @@ struct omap_rtc;
 
 struct omap_rtc_device_type {
 	bool has_32kclk_en;
+	bool has_osc_ext_32k;
 	bool has_irqwakeen;
 	bool has_pmic_mode;
 	bool has_power_up_reset;
@@ -481,6 +484,7 @@ static const struct omap_rtc_device_type
 
 static const struct omap_rtc_device_type omap_rtc_am3352_type = {
 	.has_32kclk_en	= true,
+	.has_osc_ext_32k = true,
 	.has_irqwakeen	= true,
 	.has_pmic_mode	= true,
 	.lock		= am3352_rtc_lock,
@@ -577,7 +581,16 @@ static int omap_rtc_probe(struct platfor
 	if (rtc->type->has_32kclk_en) {
 		reg = rtc_read(rtc, OMAP_RTC_OSC_REG);
 		rtc_writel(rtc, OMAP_RTC_OSC_REG,
-				reg | OMAP_RTC_OSC_32KCLK_EN);
+			   reg | OMAP_RTC_OSC_32KCLK_EN);
+	}
+
+	/* Enable External clock as the source */
+
+	if (rtc->type->has_osc_ext_32k) {
+		rtc_writel(rtc, OMAP_RTC_OSC_REG,
+			   (OMAP_RTC_OSC_EXT_32K |
+			   rtc_read(rtc, OMAP_RTC_OSC_REG)) &
+			   (~OMAP_RTC_OSC_OSC32K_GZ));
 	}
 
 	/* clear old status */
_

Patches currently in -mm which might be from j-keerthy@ti.com are

rtc-omap-add-external-32k-clock-feature-fix.patch
linux-next.patch

