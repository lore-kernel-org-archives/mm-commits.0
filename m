From: akpm@linux-foundation.org
Subject: + rtc-pl031-use-per-vendor-variables-for-special-init.patch added to -mm tree
Date: Tue, 19 Jun 2012 17:03:40 -0700
Message-ID: <20120620000340.E0F23A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:46910 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab2FTADm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jun 2012 20:03:42 -0400
Received: by ghbz15 with SMTP id z15so603629ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 19 Jun 2012 17:03:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linus.walleij@linaro.org, a.zummo@towertech.it


The patch titled
     Subject: rtc: pl031: use per-vendor variables for special init
has been added to the -mm tree.  Its filename is
     rtc-pl031-use-per-vendor-variables-for-special-init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: rtc: pl031: use per-vendor variables for special init

Patches currently in -mm which might be from linus.walleij@linaro.org are

linux-next.patch
drivers-rtc-rtc-coh901331c-use-clk_prepare-unprepare.patch
drivers-rtc-rtc-coh901331c-use-devm-allocation.patch
rtc-pl031-encapsulate-per-vendor-ops.patch
rtc-pl031-use-per-vendor-variables-for-special-init.patch
rtc-pl031-fix-up-irq-flags.patch

