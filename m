From: akpm@linux-foundation.org
Subject: + rtc-omap-add-external-32k-clock-feature.patch added to -mm tree
Date: Tue, 24 Mar 2015 15:59:40 -0700
Message-ID: <5511ec5c.awiySZJvVZpmmV3o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38398 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbbCXW7l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Mar 2015 18:59:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: j-keerthy@ti.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-omap.c: add external 32k clock feature
has been added to the -mm tree.  Its filename is
     rtc-omap-add-external-32k-clock-feature.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-omap-add-external-32k-clock-feature.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-omap-add-external-32k-clock-feature.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Keerthy <j-keerthy@ti.com>
Subject: drivers/rtc/rtc-omap.c: add external 32k clock feature

Add external 32k clock feature.  The internal clock will be gated during
suspend.  Hence make use of the external 32k clock so that rtc is
functional accross suspend/resume.

Signed-off-by: Keerthy <j-keerthy@ti.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
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
@@ -120,6 +122,7 @@
 
 struct omap_rtc_device_type {
 	bool has_32kclk_en;
+	bool has_osc_ext_32k;
 	bool has_kicker;
 	bool has_irqwakeen;
 	bool has_pmic_mode;
@@ -446,6 +449,7 @@ static const struct omap_rtc_device_type
 
 static const struct omap_rtc_device_type omap_rtc_am3352_type = {
 	.has_32kclk_en	= true,
+	.has_osc_ext_32k = true,
 	.has_kicker	= true,
 	.has_irqwakeen	= true,
 	.has_pmic_mode	= true,
@@ -543,7 +547,16 @@ static int __init omap_rtc_probe(struct
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

rtc-omap-add-external-32k-clock-feature.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
linux-next.patch

