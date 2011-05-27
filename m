From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-stmp3xxxc-port-stmp-functions-to-mxs-equivalents.patch added to -mm tree
Date: Fri, 27 May 2011 16:48:05 -0700
Message-ID: <201105272348.p4RNm537029240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757046Ab1E0XtI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 19:49:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: w.sang@pengutronix.de, a.zummo@towertech.it, johnstul@us.ibm.com, shawn.guo@freescale.com


The patch titled
     drivers/rtc/rtc-stmp3xxx.c: port stmp-functions to mxs-equivalents
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-stmp3xxxc-port-stmp-functions-to-mxs-equivalents.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/rtc-stmp3xxx.c: port stmp-functions to mxs-equivalents
From: Wolfram Sang <w.sang@pengutronix.de>

plat-stmp has been removed meanwhile since it is compatible to mach-mxs. 
Use the apropriate mxs-functions for transition.  The accessors will be
converted to readl/writel in a later patch.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Tested-by: Shawn Guo <shawn.guo@freescale.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig        |    6 +++---
 drivers/rtc/rtc-stmp3xxx.c |   28 ++++++++++++++--------------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff -puN drivers/rtc/Kconfig~drivers-rtc-rtc-stmp3xxxc-port-stmp-functions-to-mxs-equivalents drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~drivers-rtc-rtc-stmp3xxxc-port-stmp-functions-to-mxs-equivalents
+++ a/drivers/rtc/Kconfig
@@ -990,11 +990,11 @@ config RTC_DRV_COH901331
 
 
 config RTC_DRV_STMP
-	tristate "Freescale STMP3xxx RTC"
-	depends on ARCH_STMP3XXX
+	tristate "Freescale STMP3xxx/i.MX23/i.MX28 RTC"
+	depends on ARCH_MXS
 	help
 	  If you say yes here you will get support for the onboard
-	  STMP3xxx RTC.
+	  STMP3xxx/i.MX23/i.MX28 RTC.
 
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-stmp3xxx.
diff -puN drivers/rtc/rtc-stmp3xxx.c~drivers-rtc-rtc-stmp3xxxc-port-stmp-functions-to-mxs-equivalents drivers/rtc/rtc-stmp3xxx.c
--- a/drivers/rtc/rtc-stmp3xxx.c~drivers-rtc-rtc-stmp3xxxc-port-stmp-functions-to-mxs-equivalents
+++ a/drivers/rtc/rtc-stmp3xxx.c
@@ -24,8 +24,8 @@
 #include <linux/rtc.h>
 #include <linux/slab.h>
 
-#include <mach/platform.h>
-#include <mach/stmp3xxx.h>
+#include <mach/common.h>
+#include <mach/mxs.h>
 
 #define STMP3XXX_RTC_CTRL		0x0
 #define STMP3XXX_RTC_CTRL_ALARM_IRQ_EN		0x00000001
@@ -95,13 +95,13 @@ static irqreturn_t stmp3xxx_rtc_interrup
 			(STMP3XXX_RTC_CTRL_ALARM_IRQ | STMP3XXX_RTC_CTRL_ONEMSEC_IRQ);
 
 	if (status & STMP3XXX_RTC_CTRL_ALARM_IRQ) {
-		stmp3xxx_clearl(STMP3XXX_RTC_CTRL_ALARM_IRQ,
+		__mxs_clrl(STMP3XXX_RTC_CTRL_ALARM_IRQ,
 				rtc_data->io + STMP3XXX_RTC_CTRL);
 		events |= RTC_AF | RTC_IRQF;
 	}
 
 	if (status & STMP3XXX_RTC_CTRL_ONEMSEC_IRQ) {
-		stmp3xxx_clearl(STMP3XXX_RTC_CTRL_ONEMSEC_IRQ,
+		__mxs_clrl(STMP3XXX_RTC_CTRL_ONEMSEC_IRQ,
 				rtc_data->io + STMP3XXX_RTC_CTRL);
 		if (++rtc_data->irq_count % 1000 == 0) {
 			events |= RTC_UF | RTC_IRQF;
@@ -122,13 +122,13 @@ static int stmp3xxx_alarm_irq_enable(str
 		     *ctl = rtc_data->io + STMP3XXX_RTC_CTRL;
 
 	if (enabled) {
-		stmp3xxx_setl(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
+		__mxs_setl(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
 			      STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN, p);
-		stmp3xxx_setl(STMP3XXX_RTC_CTRL_ALARM_IRQ_EN, ctl);
+		__mxs_setl(STMP3XXX_RTC_CTRL_ALARM_IRQ_EN, ctl);
 	} else {
-		stmp3xxx_clearl(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
+		__mxs_clrl(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
 			      STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN, p);
-		stmp3xxx_clearl(STMP3XXX_RTC_CTRL_ALARM_IRQ_EN, ctl);
+		__mxs_clrl(STMP3XXX_RTC_CTRL_ALARM_IRQ_EN, ctl);
 	}
 	return 0;
 }
@@ -167,7 +167,7 @@ static int stmp3xxx_rtc_remove(struct pl
 	if (!rtc_data)
 		return 0;
 
-	stmp3xxx_clearl(STMP3XXX_RTC_CTRL_ONEMSEC_IRQ_EN | STMP3XXX_RTC_CTRL_ALARM_IRQ_EN,
+	__mxs_clrl(STMP3XXX_RTC_CTRL_ONEMSEC_IRQ_EN | STMP3XXX_RTC_CTRL_ALARM_IRQ_EN,
 			rtc_data->io + STMP3XXX_RTC_CTRL);
 	free_irq(rtc_data->irq_alarm, &pdev->dev);
 	free_irq(rtc_data->irq_1msec, &pdev->dev);
@@ -212,8 +212,8 @@ static int stmp3xxx_rtc_probe(struct pla
 		goto out_remap;
 	}
 
-	stmp3xxx_reset_block(rtc_data->io, true);
-	stmp3xxx_clearl(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
+	mxs_reset_block(rtc_data->io);
+	__mxs_clrl(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
 			STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN |
 			STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE,
 			rtc_data->io + STMP3XXX_RTC_PERSISTENT0);
@@ -247,7 +247,7 @@ static int stmp3xxx_rtc_probe(struct pla
 out_irq1:
 	free_irq(rtc_data->irq_alarm, &pdev->dev);
 out_irq_alarm:
-	stmp3xxx_clearl(STMP3XXX_RTC_CTRL_ONEMSEC_IRQ_EN | STMP3XXX_RTC_CTRL_ALARM_IRQ_EN,
+	__mxs_clrl(STMP3XXX_RTC_CTRL_ONEMSEC_IRQ_EN | STMP3XXX_RTC_CTRL_ALARM_IRQ_EN,
 			rtc_data->io + STMP3XXX_RTC_CTRL);
 	rtc_device_unregister(rtc_data->rtc);
 out_remap:
@@ -267,8 +267,8 @@ static int stmp3xxx_rtc_resume(struct pl
 {
 	struct stmp3xxx_rtc_data *rtc_data = platform_get_drvdata(dev);
 
-	stmp3xxx_reset_block(rtc_data->io, true);
-	stmp3xxx_clearl(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
+	mxs_reset_block(rtc_data->io);
+	__mxs_clrl(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
 			STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN |
 			STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE,
 			rtc_data->io + STMP3XXX_RTC_PERSISTENT0);
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

origin.patch
linux-next.patch
rtc-driver-for-pt7c4338-chip.patch
drivers-rtc-rtc-stmp3xxxc-get-rid-of-platform-specific-include-for-register-names.patch
drivers-rtc-rtc-stmp3xxxc-port-stmp-functions-to-mxs-equivalents.patch
drivers-rtc-rtc-stmp3xxxc-initialize-drvdata-before-registering-device.patch
drivers-rtc-rtc-stmp3xxxc-get-rid-of-mach-specific-accessors.patch
drivers-rtc-rtc-stmp3xxxc-remove-uie-handlers.patch
gpio-make-gpio_requestfree_array-gpio-array-parameter-const.patch

