From: akpm@linux-foundation.org
Subject: [merged] rtc-pl031-use-per-vendor-variables-for-special-init.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:52:12 -0700
Message-ID: <20120731185213.12A6F20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:48151 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756337Ab2GaSwP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:52:15 -0400
Received: by weyr1 with SMTP id r1so292390wey.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:52:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linus.walleij@linaro.org, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: pl031: use per-vendor variables for special init
has been removed from the -mm tree.  Its filename was
     rtc-pl031-use-per-vendor-variables-for-special-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Linus Walleij <linus.walleij@linaro.org>
Subject: rtc: pl031: use per-vendor variables for special init

Instead of hard-checking for certain vendor codes, follow the pattern of
other AMBA (PrimeCell) drivers and use variables in the vendor data.  Get
rid of the locally cached vendor and hardware revision since we already
have the nice vendor data variable in the state.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pl031.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff -puN drivers/rtc/rtc-pl031.c~rtc-pl031-use-per-vendor-variables-for-special-init drivers/rtc/rtc-pl031.c
--- a/drivers/rtc/rtc-pl031.c~rtc-pl031-use-per-vendor-variables-for-special-init
+++ a/drivers/rtc/rtc-pl031.c
@@ -71,17 +71,21 @@
 /**
  * struct pl031_vendor_data - per-vendor variations
  * @ops: the vendor-specific operations used on this silicon version
+ * @clockwatch: if this is an ST Microelectronics silicon version with a
+ *	clockwatch function
+ * @st_weekday: if this is an ST Microelectronics silicon version that need
+ *	the weekday fix
  */
 struct pl031_vendor_data {
 	struct rtc_class_ops ops;
+	bool clockwatch;
+	bool st_weekday;
 };
 
 struct pl031_local {
 	struct pl031_vendor_data *vendor;
 	struct rtc_device *rtc;
 	void __iomem *base;
-	u8 hw_designer;
-	u8 hw_revision:4;
 };
 
 static int pl031_alarm_irq_enable(struct device *dev,
@@ -336,14 +340,11 @@ static int pl031_probe(struct amba_devic
 
 	amba_set_drvdata(adev, ldata);
 
-	ldata->hw_designer = amba_manf(adev);
-	ldata->hw_revision = amba_rev(adev);
-
-	dev_dbg(&adev->dev, "designer ID = 0x%02x\n", ldata->hw_designer);
-	dev_dbg(&adev->dev, "revision = 0x%01x\n", ldata->hw_revision);
+	dev_dbg(&adev->dev, "designer ID = 0x%02x\n", amba_manf(adev));
+	dev_dbg(&adev->dev, "revision = 0x%01x\n", amba_rev(adev));
 
 	/* Enable the clockwatch on ST Variants */
-	if (ldata->hw_designer == AMBA_VENDOR_ST)
+	if (vendor->clockwatch)
 		writel(readl(ldata->base + RTC_CR) | RTC_CR_CWEN,
 		       ldata->base + RTC_CR);
 
@@ -351,7 +352,7 @@ static int pl031_probe(struct amba_devic
 	 * On ST PL031 variants, the RTC reset value does not provide correct
 	 * weekday for 2000-01-01. Correct the erroneous sunday to saturday.
 	 */
-	if (ldata->hw_designer == AMBA_VENDOR_ST) {
+	if (vendor->st_weekday) {
 		if (readl(ldata->base + RTC_YDR) == 0x2000) {
 			time = readl(ldata->base + RTC_DR);
 			if ((time &
@@ -413,6 +414,8 @@ static struct pl031_vendor_data stv1_pl0
 		.set_alarm = pl031_set_alarm,
 		.alarm_irq_enable = pl031_alarm_irq_enable,
 	},
+	.clockwatch = true,
+	.st_weekday = true,
 };
 
 /* And the second ST derivative */
@@ -424,6 +427,8 @@ static struct pl031_vendor_data stv2_pl0
 		.set_alarm = pl031_stv2_set_alarm,
 		.alarm_irq_enable = pl031_alarm_irq_enable,
 	},
+	.clockwatch = true,
+	.st_weekday = true,
 };
 
 static struct amba_id pl031_ids[] = {
_

Patches currently in -mm which might be from linus.walleij@linaro.org are

origin.patch
linux-next.patch

