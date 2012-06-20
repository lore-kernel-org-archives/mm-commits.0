From: akpm@linux-foundation.org
Subject: + rtc-pl031-encapsulate-per-vendor-ops.patch added to -mm tree
Date: Tue, 19 Jun 2012 17:03:37 -0700
Message-ID: <20120620000338.3FFEFA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:47979 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab2FTADk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jun 2012 20:03:40 -0400
Received: by yhgm50 with SMTP id m50so699366yhg.1
        for <mm-commits@vger.kernel.org>; Tue, 19 Jun 2012 17:03:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linus.walleij@linaro.org, a.zummo@towertech.it


The patch titled
     Subject: rtc: pl031: encapsulate per-vendor ops
has been added to the -mm tree.  Its filename is
     rtc-pl031-encapsulate-per-vendor-ops.patch

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
Subject: rtc: pl031: encapsulate per-vendor ops

Move the per-vendor operations for this RTC into a encapsulating struct so
we can have more per-vendor variables than just the ops.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pl031.c |   61 ++++++++++++++++++++++++--------------
 1 file changed, 39 insertions(+), 22 deletions(-)

diff -puN drivers/rtc/rtc-pl031.c~rtc-pl031-encapsulate-per-vendor-ops drivers/rtc/rtc-pl031.c
--- a/drivers/rtc/rtc-pl031.c~rtc-pl031-encapsulate-per-vendor-ops
+++ a/drivers/rtc/rtc-pl031.c
@@ -68,7 +68,16 @@
 
 #define RTC_TIMER_FREQ 32768
 
+/**
+ * struct pl031_vendor_data - per-vendor variations
+ * @ops: the vendor-specific operations used on this silicon version
+ */
+struct pl031_vendor_data {
+	struct rtc_class_ops ops;
+};
+
 struct pl031_local {
+	struct pl031_vendor_data *vendor;
 	struct rtc_device *rtc;
 	void __iomem *base;
 	u8 hw_designer;
@@ -303,7 +312,8 @@ static int pl031_probe(struct amba_devic
 {
 	int ret;
 	struct pl031_local *ldata;
-	struct rtc_class_ops *ops = id->data;
+	struct pl031_vendor_data *vendor = id->data;
+	struct rtc_class_ops *ops = &vendor->ops;
 	unsigned long time;
 
 	ret = amba_request_regions(adev, NULL);
@@ -315,6 +325,7 @@ static int pl031_probe(struct amba_devic
 		ret = -ENOMEM;
 		goto out;
 	}
+	ldata->vendor = vendor;
 
 	ldata->base = ioremap(adev->res.start, resource_size(&adev->res));
 
@@ -383,48 +394,54 @@ err_req:
 }
 
 /* Operations for the original ARM version */
-static struct rtc_class_ops arm_pl031_ops = {
-	.read_time = pl031_read_time,
-	.set_time = pl031_set_time,
-	.read_alarm = pl031_read_alarm,
-	.set_alarm = pl031_set_alarm,
-	.alarm_irq_enable = pl031_alarm_irq_enable,
+static struct pl031_vendor_data arm_pl031 = {
+	.ops = {
+		.read_time = pl031_read_time,
+		.set_time = pl031_set_time,
+		.read_alarm = pl031_read_alarm,
+		.set_alarm = pl031_set_alarm,
+		.alarm_irq_enable = pl031_alarm_irq_enable,
+	},
 };
 
 /* The First ST derivative */
-static struct rtc_class_ops stv1_pl031_ops = {
-	.read_time = pl031_read_time,
-	.set_time = pl031_set_time,
-	.read_alarm = pl031_read_alarm,
-	.set_alarm = pl031_set_alarm,
-	.alarm_irq_enable = pl031_alarm_irq_enable,
+static struct pl031_vendor_data stv1_pl031 = {
+	.ops = {
+		.read_time = pl031_read_time,
+		.set_time = pl031_set_time,
+		.read_alarm = pl031_read_alarm,
+		.set_alarm = pl031_set_alarm,
+		.alarm_irq_enable = pl031_alarm_irq_enable,
+	},
 };
 
 /* And the second ST derivative */
-static struct rtc_class_ops stv2_pl031_ops = {
-	.read_time = pl031_stv2_read_time,
-	.set_time = pl031_stv2_set_time,
-	.read_alarm = pl031_stv2_read_alarm,
-	.set_alarm = pl031_stv2_set_alarm,
-	.alarm_irq_enable = pl031_alarm_irq_enable,
+static struct pl031_vendor_data stv2_pl031 = {
+	.ops = {
+		.read_time = pl031_stv2_read_time,
+		.set_time = pl031_stv2_set_time,
+		.read_alarm = pl031_stv2_read_alarm,
+		.set_alarm = pl031_stv2_set_alarm,
+		.alarm_irq_enable = pl031_alarm_irq_enable,
+	},
 };
 
 static struct amba_id pl031_ids[] = {
 	{
 		.id = 0x00041031,
 		.mask = 0x000fffff,
-		.data = &arm_pl031_ops,
+		.data = &arm_pl031,
 	},
 	/* ST Micro variants */
 	{
 		.id = 0x00180031,
 		.mask = 0x00ffffff,
-		.data = &stv1_pl031_ops,
+		.data = &stv1_pl031,
 	},
 	{
 		.id = 0x00280031,
 		.mask = 0x00ffffff,
-		.data = &stv2_pl031_ops,
+		.data = &stv2_pl031,
 	},
 	{0, 0},
 };
_
Subject: Subject: rtc: pl031: encapsulate per-vendor ops

Patches currently in -mm which might be from linus.walleij@linaro.org are

linux-next.patch
drivers-rtc-rtc-coh901331c-use-clk_prepare-unprepare.patch
drivers-rtc-rtc-coh901331c-use-devm-allocation.patch
rtc-pl031-encapsulate-per-vendor-ops.patch
rtc-pl031-use-per-vendor-variables-for-special-init.patch
rtc-pl031-fix-up-irq-flags.patch

