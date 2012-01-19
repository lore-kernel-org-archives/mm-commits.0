From: akpm@linux-foundation.org
Subject: + rtc-rtc-spear-call-platform_set_drvdata-before-registering-rtc-device.patch added to -mm tree
Date: Thu, 19 Jan 2012 12:31:38 -0800
Message-ID: <20120119203139.24B6D100052@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:57006 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932705Ab2ASUbk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2012 15:31:40 -0500
Received: by ggnv2 with SMTP id v2so33434ggn.1
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2012 12:31:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viresh.kumar@st.com, deepak.sikri@st.com, rajeev-dlh.kumar@st.com, shiraz.hashim@st.com


The patch titled
     Subject: rtc/rtc-spear: call platform_set_drvdata() before registering rtc device
has been added to the -mm tree.  Its filename is
     rtc-rtc-spear-call-platform_set_drvdata-before-registering-rtc-device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Viresh Kumar <viresh.kumar@st.com>
Subject: rtc/rtc-spear: call platform_set_drvdata() before registering rtc device

rtc_device_register() calls rtc-spear routines internally.  These routines
call dev_get_drvdata() to get struct spear_rtc_config.  Currently,
platform_set_drvdata is called after rtc device is registered.  This
causes system to crash, as dev_get_drvdata returns NULL.

For this we need to call platform_set_drvdata() before registering rtc
device.  This requires further cleanup, that leads to removal of
dev_set_drvdata on rtc->dev, which was just not required at all.

Also, we change the parameter to request_irq and pass pointer to config
instead of pointer to rtc struct.

This patch brings all above changes.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Cc: Shiraz Hashim <shiraz.hashim@st.com>
Cc: Deepak Sikri <deepak.sikri@st.com>
Acked-by: Rajeev Kumar <rajeev-dlh.kumar@st.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-spear.c |   61 +++++++++++++-------------------------
 1 file changed, 21 insertions(+), 40 deletions(-)

diff -puN drivers/rtc/rtc-spear.c~rtc-rtc-spear-call-platform_set_drvdata-before-registering-rtc-device drivers/rtc/rtc-spear.c
--- a/drivers/rtc/rtc-spear.c~rtc-rtc-spear-call-platform_set_drvdata-before-registering-rtc-device
+++ a/drivers/rtc/rtc-spear.c
@@ -77,6 +77,7 @@
 #define STATUS_FAIL		(LOST_WR_TIME | LOST_WR_DATE)
 
 struct spear_rtc_config {
+	struct rtc_device *rtc;
 	struct clk *clk;
 	spinlock_t lock;
 	void __iomem *ioaddr;
@@ -150,8 +151,7 @@ static void rtc_wait_not_busy(struct spe
 
 static irqreturn_t spear_rtc_irq(int irq, void *dev_id)
 {
-	struct rtc_device *rtc = (struct rtc_device *)dev_id;
-	struct spear_rtc_config *config = dev_get_drvdata(&rtc->dev);
+	struct spear_rtc_config *config = dev_id;
 	unsigned long flags, events = 0;
 	unsigned int irq_data;
 
@@ -162,7 +162,7 @@ static irqreturn_t spear_rtc_irq(int irq
 	if ((irq_data & RTC_INT_MASK)) {
 		spear_rtc_clear_interrupt(config);
 		events = RTC_IRQF | RTC_AF;
-		rtc_update_irq(rtc, 1, events);
+		rtc_update_irq(config->rtc, 1, events);
 		return IRQ_HANDLED;
 	} else
 		return IRQ_NONE;
@@ -204,9 +204,7 @@ static void bcd2tm(struct rtc_time *tm)
  */
 static int spear_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
-	struct spear_rtc_config *config = dev_get_drvdata(&rtc->dev);
+	struct spear_rtc_config *config = dev_get_drvdata(dev);
 	unsigned int time, date;
 
 	/* we don't report wday/yday/isdst ... */
@@ -235,9 +233,7 @@ static int spear_rtc_read_time(struct de
  */
 static int spear_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
-	struct spear_rtc_config *config = dev_get_drvdata(&rtc->dev);
+	struct spear_rtc_config *config = dev_get_drvdata(dev);
 	unsigned int time, date, err = 0;
 
 	if (tm2bcd(tm) < 0)
@@ -267,9 +263,7 @@ static int spear_rtc_set_time(struct dev
  */
 static int spear_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
-	struct spear_rtc_config *config = dev_get_drvdata(&rtc->dev);
+	struct spear_rtc_config *config = dev_get_drvdata(dev);
 	unsigned int time, date;
 
 	rtc_wait_not_busy(config);
@@ -299,9 +293,7 @@ static int spear_rtc_read_alarm(struct d
  */
 static int spear_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
-	struct spear_rtc_config *config = dev_get_drvdata(&rtc->dev);
+	struct spear_rtc_config *config = dev_get_drvdata(dev);
 	unsigned int time, date, err = 0;
 
 	if (tm2bcd(&alm->time) < 0)
@@ -330,9 +322,7 @@ static int spear_rtc_set_alarm(struct de
 
 static int spear_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
-	struct spear_rtc_config *config = dev_get_drvdata(&rtc->dev);
+	struct spear_rtc_config *config = dev_get_drvdata(dev);
 	int ret = 0;
 
 	spear_rtc_clear_interrupt(config);
@@ -365,7 +355,6 @@ static struct rtc_class_ops spear_rtc_op
 static int __devinit spear_rtc_probe(struct platform_device *pdev)
 {
 	struct resource *res;
-	struct rtc_device *rtc;
 	struct spear_rtc_config *config;
 	unsigned int status = 0;
 	int irq;
@@ -405,19 +394,17 @@ static int __devinit spear_rtc_probe(str
 	}
 
 	spin_lock_init(&config->lock);
+	platform_set_drvdata(pdev, config);
 
-	rtc = rtc_device_register(pdev->name, &pdev->dev, &spear_rtc_ops,
-			THIS_MODULE);
-	if (IS_ERR(rtc)) {
+	config->rtc = rtc_device_register(pdev->name, &pdev->dev,
+			&spear_rtc_ops, THIS_MODULE);
+	if (IS_ERR(config->rtc)) {
 		dev_err(&pdev->dev, "can't register RTC device, err %ld\n",
-				PTR_ERR(rtc));
-		status = PTR_ERR(rtc);
+				PTR_ERR(config->rtc));
+		status = PTR_ERR(config->rtc);
 		goto err_iounmap;
 	}
 
-	platform_set_drvdata(pdev, rtc);
-	dev_set_drvdata(&rtc->dev, config);
-
 	/* alarm irqs */
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
@@ -426,7 +413,7 @@ static int __devinit spear_rtc_probe(str
 		goto err_clear_platdata;
 	}
 
-	status = request_irq(irq, spear_rtc_irq, 0, pdev->name, rtc);
+	status = request_irq(irq, spear_rtc_irq, 0, pdev->name, config);
 	if (status) {
 		dev_err(&pdev->dev, "Alarm interrupt IRQ%d already \
 				claimed\n", irq);
@@ -440,8 +427,7 @@ static int __devinit spear_rtc_probe(str
 
 err_clear_platdata:
 	platform_set_drvdata(pdev, NULL);
-	dev_set_drvdata(&rtc->dev, NULL);
-	rtc_device_unregister(rtc);
+	rtc_device_unregister(config->rtc);
 err_iounmap:
 	iounmap(config->ioaddr);
 err_disable_clock:
@@ -458,8 +444,7 @@ err_release_region:
 
 static int __devexit spear_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
-	struct spear_rtc_config *config = dev_get_drvdata(&rtc->dev);
+	struct spear_rtc_config *config = platform_get_drvdata(pdev);
 	int irq;
 	struct resource *res;
 
@@ -477,8 +462,7 @@ static int __devexit spear_rtc_remove(st
 	if (res)
 		release_mem_region(res->start, resource_size(res));
 	platform_set_drvdata(pdev, NULL);
-	dev_set_drvdata(&rtc->dev, NULL);
-	rtc_device_unregister(rtc);
+	rtc_device_unregister(config->rtc);
 
 	return 0;
 }
@@ -487,8 +471,7 @@ static int __devexit spear_rtc_remove(st
 
 static int spear_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
-	struct spear_rtc_config *config = dev_get_drvdata(&rtc->dev);
+	struct spear_rtc_config *config = platform_get_drvdata(pdev);
 	int irq;
 
 	irq = platform_get_irq(pdev, 0);
@@ -505,8 +488,7 @@ static int spear_rtc_suspend(struct plat
 
 static int spear_rtc_resume(struct platform_device *pdev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
-	struct spear_rtc_config *config = dev_get_drvdata(&rtc->dev);
+	struct spear_rtc_config *config = platform_get_drvdata(pdev);
 	int irq;
 
 	irq = platform_get_irq(pdev, 0);
@@ -531,8 +513,7 @@ static int spear_rtc_resume(struct platf
 
 static void spear_rtc_shutdown(struct platform_device *pdev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
-	struct spear_rtc_config *config = dev_get_drvdata(&rtc->dev);
+	struct spear_rtc_config *config = platform_get_drvdata(pdev);
 
 	spear_rtc_disable_interrupt(config);
 	clk_disable(config->clk);
_
Subject: Subject: rtc/rtc-spear: call platform_set_drvdata() before registering rtc device

Patches currently in -mm which might be from viresh.kumar@st.com are

origin.patch
rtc-spear-fix-for-balancing-the-enable_irq_wake-in-power-mgmt.patch
rtc-spear-fix-for-rtc_aie_on-and-rtc_aie_off-ioctl-errors.patch
rtc-rtc-spear-call-platform_set_drvdata-before-registering-rtc-device.patch

