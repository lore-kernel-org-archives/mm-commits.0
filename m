From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-remove-irqf_disabled.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:31:35 -0700
Message-ID: <20120326193135.74DB9A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:58916 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab2CZTbh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:31:37 -0400
Received: by mail-ee0-f74.google.com with SMTP id c41so293942eek.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:31:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yong.zhang0@gmail.com, a.zummo@towertech.it, linus.walleij@linaro.org, mcuos.com@gmail.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc: remove IRQF_DISABLED
has been removed from the -mm tree.  Its filename was
     drivers-rtc-remove-irqf_disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Yong Zhang <yong.zhang0@gmail.com>
Subject: drivers/rtc: remove IRQF_DISABLED

Since commit e58aa3d2d0cc01 ("genirq: run irq handlers with interrupts
disabled") we run all interrupt handlers with interrupts disabled and we
even check and yell when an interrupt handler returns with interrupts
enabled - see commit b738a50a ("genirq: warn when handler enables
interrupts").

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91sam9.c  |    2 +-
 drivers/rtc/rtc-cmos.c      |    2 +-
 drivers/rtc/rtc-coh901331.c |    2 +-
 drivers/rtc/rtc-davinci.c   |    2 +-
 drivers/rtc/rtc-ds1511.c    |    2 +-
 drivers/rtc/rtc-ds1553.c    |    2 +-
 drivers/rtc/rtc-lpc32xx.c   |    2 +-
 drivers/rtc/rtc-mpc5121.c   |    4 ++--
 drivers/rtc/rtc-mrst.c      |    2 +-
 drivers/rtc/rtc-mv.c        |    2 +-
 drivers/rtc/rtc-nuc900.c    |    2 +-
 drivers/rtc/rtc-omap.c      |    4 ++--
 drivers/rtc/rtc-pl030.c     |    2 +-
 drivers/rtc/rtc-pl031.c     |    2 +-
 drivers/rtc/rtc-pxa.c       |    4 ++--
 drivers/rtc/rtc-s3c.c       |    4 ++--
 drivers/rtc/rtc-sa1100.c    |    7 +++----
 drivers/rtc/rtc-sh.c        |    8 ++++----
 drivers/rtc/rtc-stk17ta8.c  |    2 +-
 drivers/rtc/rtc-tx4939.c    |    2 +-
 drivers/rtc/rtc-vr41xx.c    |    4 ++--
 21 files changed, 31 insertions(+), 32 deletions(-)

diff -puN drivers/rtc/rtc-at91sam9.c~drivers-rtc-remove-irqf_disabled drivers/rtc/rtc-at91sam9.c
--- a/drivers/rtc/rtc-at91sam9.c~drivers-rtc-remove-irqf_disabled
+++ a/drivers/rtc/rtc-at91sam9.c
@@ -335,7 +335,7 @@ static int __init at91_rtc_probe(struct 
 
 	/* register irq handler after we know what name we'll use */
 	ret = request_irq(AT91_ID_SYS, at91_rtc_interrupt,
-				IRQF_DISABLED | IRQF_SHARED,
+				IRQF_SHARED,
 				dev_name(&rtc->rtcdev->dev), rtc);
 	if (ret) {
 		dev_dbg(&pdev->dev, "can't share IRQ %d?\n", AT91_ID_SYS);
diff -puN drivers/rtc/rtc-cmos.c~drivers-rtc-remove-irqf_disabled drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~drivers-rtc-remove-irqf_disabled
+++ a/drivers/rtc/rtc-cmos.c
@@ -714,7 +714,7 @@ cmos_do_probe(struct device *dev, struct
 			rtc_cmos_int_handler = cmos_interrupt;
 
 		retval = request_irq(rtc_irq, rtc_cmos_int_handler,
-				IRQF_DISABLED, dev_name(&cmos_rtc.rtc->dev),
+				0, dev_name(&cmos_rtc.rtc->dev),
 				cmos_rtc.rtc);
 		if (retval < 0) {
 			dev_dbg(dev, "IRQ %d is already in use\n", rtc_irq);
diff -puN drivers/rtc/rtc-coh901331.c~drivers-rtc-remove-irqf_disabled drivers/rtc/rtc-coh901331.c
--- a/drivers/rtc/rtc-coh901331.c~drivers-rtc-remove-irqf_disabled
+++ a/drivers/rtc/rtc-coh901331.c
@@ -199,7 +199,7 @@ static int __init coh901331_probe(struct
 	}
 
 	rtap->irq = platform_get_irq(pdev, 0);
-	if (request_irq(rtap->irq, coh901331_interrupt, IRQF_DISABLED,
+	if (request_irq(rtap->irq, coh901331_interrupt, 0,
 			"RTC COH 901 331 Alarm", rtap)) {
 		ret = -EIO;
 		goto out_no_irq;
diff -puN drivers/rtc/rtc-davinci.c~drivers-rtc-remove-irqf_disabled drivers/rtc/rtc-davinci.c
--- a/drivers/rtc/rtc-davinci.c~drivers-rtc-remove-irqf_disabled
+++ a/drivers/rtc/rtc-davinci.c
@@ -542,7 +542,7 @@ static int __init davinci_rtc_probe(stru
 	rtcss_write(davinci_rtc, 0, PRTCSS_RTC_CCTRL);
 
 	ret = request_irq(davinci_rtc->irq, davinci_rtc_interrupt,
-			  IRQF_DISABLED, "davinci_rtc", davinci_rtc);
+			  0, "davinci_rtc", davinci_rtc);
 	if (ret < 0) {
 		dev_err(dev, "unable to register davinci RTC interrupt\n");
 		goto fail4;
diff -puN drivers/rtc/rtc-ds1511.c~drivers-rtc-remove-irqf_disabled drivers/rtc/rtc-ds1511.c
--- a/drivers/rtc/rtc-ds1511.c~drivers-rtc-remove-irqf_disabled
+++ a/drivers/rtc/rtc-ds1511.c
@@ -532,7 +532,7 @@ ds1511_rtc_probe(struct platform_device 
 	if (pdata->irq > 0) {
 		rtc_read(RTC_CMD1);
 		if (devm_request_irq(&pdev->dev, pdata->irq, ds1511_interrupt,
-			IRQF_DISABLED | IRQF_SHARED, pdev->name, pdev) < 0) {
+			IRQF_SHARED, pdev->name, pdev) < 0) {
 
 			dev_warn(&pdev->dev, "interrupt not available.\n");
 			pdata->irq = 0;
diff -puN drivers/rtc/rtc-ds1553.c~drivers-rtc-remove-irqf_disabled drivers/rtc/rtc-ds1553.c
--- a/drivers/rtc/rtc-ds1553.c~drivers-rtc-remove-irqf_disabled
+++ a/drivers/rtc/rtc-ds1553.c
@@ -320,7 +320,7 @@ static int __devinit ds1553_rtc_probe(st
 		writeb(0, ioaddr + RTC_INTERRUPTS);
 		if (devm_request_irq(&pdev->dev, pdata->irq,
 				ds1553_rtc_interrupt,
-				IRQF_DISABLED, pdev->name, pdev) < 0) {
+				0, pdev->name, pdev) < 0) {
 			dev_warn(&pdev->dev, "interrupt not available.\n");
 			pdata->irq = 0;
 		}
diff -puN drivers/rtc/rtc-lpc32xx.c~drivers-rtc-remove-irqf_disabled drivers/rtc/rtc-lpc32xx.c
--- a/drivers/rtc/rtc-lpc32xx.c~drivers-rtc-remove-irqf_disabled
+++ a/drivers/rtc/rtc-lpc32xx.c
@@ -287,7 +287,7 @@ static int __devinit lpc32xx_rtc_probe(s
 	if (rtc->irq >= 0) {
 		if (devm_request_irq(&pdev->dev, rtc->irq,
 				     lpc32xx_rtc_alarm_interrupt,
-				     IRQF_DISABLED, pdev->name, rtc) < 0) {
+				     0, pdev->name, rtc) < 0) {
 			dev_warn(&pdev->dev, "Can't request interrupt.\n");
 			rtc->irq = -1;
 		} else {
diff -puN drivers/rtc/rtc-mpc5121.c~drivers-rtc-remove-irqf_disabled drivers/rtc/rtc-mpc5121.c
--- a/drivers/rtc/rtc-mpc5121.c~drivers-rtc-remove-irqf_disabled
+++ a/drivers/rtc/rtc-mpc5121.c
@@ -327,7 +327,7 @@ static int __devinit mpc5121_rtc_probe(s
 	dev_set_drvdata(&op->dev, rtc);
 
 	rtc->irq = irq_of_parse_and_map(op->dev.of_node, 1);
-	err = request_irq(rtc->irq, mpc5121_rtc_handler, IRQF_DISABLED,
+	err = request_irq(rtc->irq, mpc5121_rtc_handler, 0,
 						"mpc5121-rtc", &op->dev);
 	if (err) {
 		dev_err(&op->dev, "%s: could not request irq: %i\n",
@@ -337,7 +337,7 @@ static int __devinit mpc5121_rtc_probe(s
 
 	rtc->irq_periodic = irq_of_parse_and_map(op->dev.of_node, 0);
 	err = request_irq(rtc->irq_periodic, mpc5121_rtc_handler_upd,
-				IRQF_DISABLED, "mpc5121-rtc_upd", &op->dev);
+				0, "mpc5121-rtc_upd", &op->dev);
 	if (err) {
 		dev_err(&op->dev, "%s: could not request irq: %i\n",
 						__func__, rtc->irq_periodic);
diff -puN drivers/rtc/rtc-mrst.c~drivers-rtc-remove-irqf_disabled drivers/rtc/rtc-mrst.c
--- a/drivers/rtc/rtc-mrst.c~drivers-rtc-remove-irqf_disabled
+++ a/drivers/rtc/rtc-mrst.c
@@ -366,7 +366,7 @@ vrtc_mrst_do_probe(struct device *dev, s
 
 	if (rtc_irq) {
 		retval = request_irq(rtc_irq, mrst_rtc_irq,
-				IRQF_DISABLED, dev_name(&mrst_rtc.rtc->dev),
+				0, dev_name(&mrst_rtc.rtc->dev),
 				mrst_rtc.rtc);
 		if (retval < 0) {
 			dev_dbg(dev, "IRQ %d is already in use, err %d\n",
diff -puN drivers/rtc/rtc-mv.c~drivers-rtc-remove-irqf_disabled drivers/rtc/rtc-mv.c
--- a/drivers/rtc/rtc-mv.c~drivers-rtc-remove-irqf_disabled
+++ a/drivers/rtc/rtc-mv.c
@@ -273,7 +273,7 @@ static int __devinit mv_rtc_probe(struct
 	if (pdata->irq >= 0) {
 		writel(0, pdata->ioaddr + RTC_ALARM_INTERRUPT_MASK_REG_OFFS);
 		if (devm_request_irq(&pdev->dev, pdata->irq, mv_rtc_interrupt,
-				     IRQF_DISABLED | IRQF_SHARED,
+				     IRQF_SHARED,
 				     pdev->name, pdata) < 0) {
 			dev_warn(&pdev->dev, "interrupt not available.\n");
 			pdata->irq = -1;
diff -puN drivers/rtc/rtc-nuc900.c~drivers-rtc-remove-irqf_disabled drivers/rtc/rtc-nuc900.c
--- a/drivers/rtc/rtc-nuc900.c~drivers-rtc-remove-irqf_disabled
+++ a/drivers/rtc/rtc-nuc900.c
@@ -269,7 +269,7 @@ static int __devinit nuc900_rtc_probe(st
 
 	nuc900_rtc->irq_num = platform_get_irq(pdev, 0);
 	if (request_irq(nuc900_rtc->irq_num, nuc900_rtc_interrupt,
-				IRQF_DISABLED, "nuc900rtc", nuc900_rtc)) {
+				0, "nuc900rtc", nuc900_rtc)) {
 		dev_err(&pdev->dev, "NUC900 RTC request irq failed\n");
 		err = -EBUSY;
 		goto fail4;
diff -puN drivers/rtc/rtc-omap.c~drivers-rtc-remove-irqf_disabled drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~drivers-rtc-remove-irqf_disabled
+++ a/drivers/rtc/rtc-omap.c
@@ -348,14 +348,14 @@ static int __init omap_rtc_probe(struct 
 		rtc_write(OMAP_RTC_STATUS_ALARM, OMAP_RTC_STATUS_REG);
 
 	/* handle periodic and alarm irqs */
-	if (request_irq(omap_rtc_timer, rtc_irq, IRQF_DISABLED,
+	if (request_irq(omap_rtc_timer, rtc_irq, 0,
 			dev_name(&rtc->dev), rtc)) {
 		pr_debug("%s: RTC timer interrupt IRQ%d already claimed\n",
 			pdev->name, omap_rtc_timer);
 		goto fail1;
 	}
 	if ((omap_rtc_timer != omap_rtc_alarm) &&
-		(request_irq(omap_rtc_alarm, rtc_irq, IRQF_DISABLED,
+		(request_irq(omap_rtc_alarm, rtc_irq, 0,
 			dev_name(&rtc->dev), rtc))) {
 		pr_debug("%s: RTC alarm interrupt IRQ%d already claimed\n",
 			pdev->name, omap_rtc_alarm);
diff -puN drivers/rtc/rtc-pl030.c~drivers-rtc-remove-irqf_disabled drivers/rtc/rtc-pl030.c
--- a/drivers/rtc/rtc-pl030.c~drivers-rtc-remove-irqf_disabled
+++ a/drivers/rtc/rtc-pl030.c
@@ -123,7 +123,7 @@ static int pl030_probe(struct amba_devic
 
 	amba_set_drvdata(dev, rtc);
 
-	ret = request_irq(dev->irq[0], pl030_interrupt, IRQF_DISABLED,
+	ret = request_irq(dev->irq[0], pl030_interrupt, 0,
 			  "rtc-pl030", rtc);
 	if (ret)
 		goto err_irq;
diff -puN drivers/rtc/rtc-pl031.c~drivers-rtc-remove-irqf_disabled drivers/rtc/rtc-pl031.c
--- a/drivers/rtc/rtc-pl031.c~drivers-rtc-remove-irqf_disabled
+++ a/drivers/rtc/rtc-pl031.c
@@ -352,7 +352,7 @@ static int pl031_probe(struct amba_devic
 	}
 
 	if (request_irq(adev->irq[0], pl031_interrupt,
-			IRQF_DISABLED, "rtc-pl031", ldata)) {
+			0, "rtc-pl031", ldata)) {
 		ret = -EIO;
 		goto out_no_irq;
 	}
diff -puN drivers/rtc/rtc-pxa.c~drivers-rtc-remove-irqf_disabled drivers/rtc/rtc-pxa.c
--- a/drivers/rtc/rtc-pxa.c~drivers-rtc-remove-irqf_disabled
+++ a/drivers/rtc/rtc-pxa.c
@@ -174,14 +174,14 @@ static int pxa_rtc_open(struct device *d
 	struct pxa_rtc *pxa_rtc = dev_get_drvdata(dev);
 	int ret;
 
-	ret = request_irq(pxa_rtc->irq_1Hz, pxa_rtc_irq, IRQF_DISABLED,
+	ret = request_irq(pxa_rtc->irq_1Hz, pxa_rtc_irq, 0,
 			  "rtc 1Hz", dev);
 	if (ret < 0) {
 		dev_err(dev, "can't get irq %i, err %d\n", pxa_rtc->irq_1Hz,
 			ret);
 		goto err_irq_1Hz;
 	}
-	ret = request_irq(pxa_rtc->irq_Alrm, pxa_rtc_irq, IRQF_DISABLED,
+	ret = request_irq(pxa_rtc->irq_Alrm, pxa_rtc_irq, 0,
 			  "rtc Alrm", dev);
 	if (ret < 0) {
 		dev_err(dev, "can't get irq %i, err %d\n", pxa_rtc->irq_Alrm,
diff -puN drivers/rtc/rtc-s3c.c~drivers-rtc-remove-irqf_disabled drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~drivers-rtc-remove-irqf_disabled
+++ a/drivers/rtc/rtc-s3c.c
@@ -543,14 +543,14 @@ static int __devinit s3c_rtc_probe(struc
 	s3c_rtc_setfreq(&pdev->dev, 1);
 
 	ret = request_irq(s3c_rtc_alarmno, s3c_rtc_alarmirq,
-			  IRQF_DISABLED,  "s3c2410-rtc alarm", rtc);
+			  0,  "s3c2410-rtc alarm", rtc);
 	if (ret) {
 		dev_err(&pdev->dev, "IRQ%d error %d\n", s3c_rtc_alarmno, ret);
 		goto err_alarm_irq;
 	}
 
 	ret = request_irq(s3c_rtc_tickno, s3c_rtc_tickirq,
-			  IRQF_DISABLED,  "s3c2410-rtc tick", rtc);
+			  0,  "s3c2410-rtc tick", rtc);
 	if (ret) {
 		dev_err(&pdev->dev, "IRQ%d error %d\n", s3c_rtc_tickno, ret);
 		free_irq(s3c_rtc_alarmno, rtc);
diff -puN drivers/rtc/rtc-sa1100.c~drivers-rtc-remove-irqf_disabled drivers/rtc/rtc-sa1100.c
--- a/drivers/rtc/rtc-sa1100.c~drivers-rtc-remove-irqf_disabled
+++ a/drivers/rtc/rtc-sa1100.c
@@ -160,14 +160,13 @@ static int sa1100_rtc_open(struct device
 	struct platform_device *plat_dev = to_platform_device(dev);
 	struct rtc_device *rtc = platform_get_drvdata(plat_dev);
 
-	ret = request_irq(IRQ_RTC1Hz, sa1100_rtc_interrupt, IRQF_DISABLED,
-		"rtc 1Hz", dev);
+	ret = request_irq(IRQ_RTC1Hz, sa1100_rtc_interrupt, 0, "rtc 1Hz", dev);
 	if (ret) {
 		dev_err(dev, "IRQ %d already in use.\n", IRQ_RTC1Hz);
 		goto fail_ui;
 	}
-	ret = request_irq(IRQ_RTCAlrm, sa1100_rtc_interrupt, IRQF_DISABLED,
-		"rtc Alrm", dev);
+	ret = request_irq(IRQ_RTCAlrm, sa1100_rtc_interrupt, 0,
+			  "rtc Alrm", dev);
 	if (ret) {
 		dev_err(dev, "IRQ %d already in use.\n", IRQ_RTCAlrm);
 		goto fail_ai;
diff -puN drivers/rtc/rtc-sh.c~drivers-rtc-remove-irqf_disabled drivers/rtc/rtc-sh.c
--- a/drivers/rtc/rtc-sh.c~drivers-rtc-remove-irqf_disabled
+++ a/drivers/rtc/rtc-sh.c
@@ -666,7 +666,7 @@ static int __init sh_rtc_probe(struct pl
 	if (rtc->carry_irq <= 0) {
 		/* register shared periodic/carry/alarm irq */
 		ret = request_irq(rtc->periodic_irq, sh_rtc_shared,
-				  IRQF_DISABLED, "sh-rtc", rtc);
+				  0, "sh-rtc", rtc);
 		if (unlikely(ret)) {
 			dev_err(&pdev->dev,
 				"request IRQ failed with %d, IRQ %d\n", ret,
@@ -676,7 +676,7 @@ static int __init sh_rtc_probe(struct pl
 	} else {
 		/* register periodic/carry/alarm irqs */
 		ret = request_irq(rtc->periodic_irq, sh_rtc_periodic,
-				  IRQF_DISABLED, "sh-rtc period", rtc);
+				  0, "sh-rtc period", rtc);
 		if (unlikely(ret)) {
 			dev_err(&pdev->dev,
 				"request period IRQ failed with %d, IRQ %d\n",
@@ -685,7 +685,7 @@ static int __init sh_rtc_probe(struct pl
 		}
 
 		ret = request_irq(rtc->carry_irq, sh_rtc_interrupt,
-				  IRQF_DISABLED, "sh-rtc carry", rtc);
+				  0, "sh-rtc carry", rtc);
 		if (unlikely(ret)) {
 			dev_err(&pdev->dev,
 				"request carry IRQ failed with %d, IRQ %d\n",
@@ -695,7 +695,7 @@ static int __init sh_rtc_probe(struct pl
 		}
 
 		ret = request_irq(rtc->alarm_irq, sh_rtc_alarm,
-				  IRQF_DISABLED, "sh-rtc alarm", rtc);
+				  0, "sh-rtc alarm", rtc);
 		if (unlikely(ret)) {
 			dev_err(&pdev->dev,
 				"request alarm IRQ failed with %d, IRQ %d\n",
diff -puN drivers/rtc/rtc-stk17ta8.c~drivers-rtc-remove-irqf_disabled drivers/rtc/rtc-stk17ta8.c
--- a/drivers/rtc/rtc-stk17ta8.c~drivers-rtc-remove-irqf_disabled
+++ a/drivers/rtc/rtc-stk17ta8.c
@@ -329,7 +329,7 @@ static int __devinit stk17ta8_rtc_probe(
 		writeb(0, ioaddr + RTC_INTERRUPTS);
 		if (devm_request_irq(&pdev->dev, pdata->irq,
 				stk17ta8_rtc_interrupt,
-				IRQF_DISABLED | IRQF_SHARED,
+				IRQF_SHARED,
 				pdev->name, pdev) < 0) {
 			dev_warn(&pdev->dev, "interrupt not available.\n");
 			pdata->irq = 0;
diff -puN drivers/rtc/rtc-tx4939.c~drivers-rtc-remove-irqf_disabled drivers/rtc/rtc-tx4939.c
--- a/drivers/rtc/rtc-tx4939.c~drivers-rtc-remove-irqf_disabled
+++ a/drivers/rtc/rtc-tx4939.c
@@ -266,7 +266,7 @@ static int __init tx4939_rtc_probe(struc
 	spin_lock_init(&pdata->lock);
 	tx4939_rtc_cmd(pdata->rtcreg, TX4939_RTCCTL_COMMAND_NOP);
 	if (devm_request_irq(&pdev->dev, irq, tx4939_rtc_interrupt,
-			     IRQF_DISABLED, pdev->name, &pdev->dev) < 0)
+			     0, pdev->name, &pdev->dev) < 0)
 		return -EBUSY;
 	rtc = rtc_device_register(pdev->name, &pdev->dev,
 				  &tx4939_rtc_ops, THIS_MODULE);
diff -puN drivers/rtc/rtc-vr41xx.c~drivers-rtc-remove-irqf_disabled drivers/rtc/rtc-vr41xx.c
--- a/drivers/rtc/rtc-vr41xx.c~drivers-rtc-remove-irqf_disabled
+++ a/drivers/rtc/rtc-vr41xx.c
@@ -333,7 +333,7 @@ static int __devinit rtc_probe(struct pl
 		goto err_device_unregister;
 	}
 
-	retval = request_irq(aie_irq, elapsedtime_interrupt, IRQF_DISABLED,
+	retval = request_irq(aie_irq, elapsedtime_interrupt, 0,
 	                     "elapsed_time", pdev);
 	if (retval < 0)
 		goto err_device_unregister;
@@ -342,7 +342,7 @@ static int __devinit rtc_probe(struct pl
 	if (pie_irq <= 0)
 		goto err_free_irq;
 
-	retval = request_irq(pie_irq, rtclong1_interrupt, IRQF_DISABLED,
+	retval = request_irq(pie_irq, rtclong1_interrupt, 0,
 		             "rtclong1", pdev);
 	if (retval < 0)
 		goto err_free_irq;
_

Patches currently in -mm which might be from yong.zhang0@gmail.com are

origin.patch
linux-next.patch

