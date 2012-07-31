From: akpm@linux-foundation.org
Subject: [merged] rtc-pl031-fix-up-irq-flags.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:52:16 -0700
Message-ID: <20120731185216.DE75F1E007E@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab2GaSwV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:52:21 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:52:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mattias.wallin@stericsson.com, a.zummo@towertech.it, jonas.aberg@stericsson.com, linus.walleij@linaro.org, rickard.andersson@stericsson.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: pl031: fix up IRQ flags
has been removed from the -mm tree.  Its filename was
     rtc-pl031-fix-up-irq-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mattias Wallin <mattias.wallin@stericsson.com>
Subject: rtc: pl031: fix up IRQ flags

The pl031 interrupt is shared between the timer part and the clockwatch
part of the same HW block on the ux500, so mark it IRQF_SHARED on this
variant.

This patch also adds the IRQF_NO_SUSPEND flag to the rtc irq on all
variants as we don't want this pretty important IRQ to be disabled in
suspend.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Rickard Andersson <rickard.andersson@stericsson.com>
Reviewed-by: Jonas Aberg <jonas.aberg@stericsson.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pl031.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-pl031.c~rtc-pl031-fix-up-irq-flags drivers/rtc/rtc-pl031.c
--- a/drivers/rtc/rtc-pl031.c~rtc-pl031-fix-up-irq-flags
+++ a/drivers/rtc/rtc-pl031.c
@@ -75,11 +75,13 @@
  *	clockwatch function
  * @st_weekday: if this is an ST Microelectronics silicon version that need
  *	the weekday fix
+ * @irqflags: special IRQ flags per variant
  */
 struct pl031_vendor_data {
 	struct rtc_class_ops ops;
 	bool clockwatch;
 	bool st_weekday;
+	unsigned long irqflags;
 };
 
 struct pl031_local {
@@ -373,7 +375,7 @@ static int pl031_probe(struct amba_devic
 	}
 
 	if (request_irq(adev->irq[0], pl031_interrupt,
-			0, "rtc-pl031", ldata)) {
+			vendor->irqflags, "rtc-pl031", ldata)) {
 		ret = -EIO;
 		goto out_no_irq;
 	}
@@ -403,6 +405,7 @@ static struct pl031_vendor_data arm_pl03
 		.set_alarm = pl031_set_alarm,
 		.alarm_irq_enable = pl031_alarm_irq_enable,
 	},
+	.irqflags = IRQF_NO_SUSPEND,
 };
 
 /* The First ST derivative */
@@ -416,6 +419,7 @@ static struct pl031_vendor_data stv1_pl0
 	},
 	.clockwatch = true,
 	.st_weekday = true,
+	.irqflags = IRQF_NO_SUSPEND,
 };
 
 /* And the second ST derivative */
@@ -429,6 +433,11 @@ static struct pl031_vendor_data stv2_pl0
 	},
 	.clockwatch = true,
 	.st_weekday = true,
+	/*
+	 * This variant shares the IRQ with another block and must not
+	 * suspend that IRQ line.
+	 */
+	.irqflags = IRQF_SHARED | IRQF_NO_SUSPEND,
 };
 
 static struct amba_id pl031_ids[] = {
_

Patches currently in -mm which might be from mattias.wallin@stericsson.com are

origin.patch

