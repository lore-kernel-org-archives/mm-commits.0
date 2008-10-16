From: akpm@linux-foundation.org
Subject: - rtc-bunch-of-drivers-fix-no-irq-case-handing.patch removed from -mm tree
Date: Wed, 15 Oct 2008 23:13:25 -0700
Message-ID: <200810160613.m9G6DPBB005640@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756461AbYJPGOf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 02:14:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, a.zummo@towertech.it, david-b@pacbell.net, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     rtc: bunch of drivers: fix 'no irq' case handing
has been removed from the -mm tree.  Its filename was
     rtc-bunch-of-drivers-fix-no-irq-case-handing.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: bunch of drivers: fix 'no irq' case handing
From: Anton Vorontsov <avorontsov@ru.mvista.com>

This patch fixes bunch of irq checking misuses.  Most drivers were getting
irq via platform_get_irq(), which returns -ENXIO or r->start.  Platforms
may specify r->start = 0 to emphasize 'no irq' case, and drivers should
handle this correctly.

rtc-cmos.c is special.  It is using PNP and platform bindings.  Hopefully
nobody is using PNP IRQ 0 for RTC.  So the changes should be safe.

Also, rtc-sh.c was using platform_get_irq, and stored a result into an
unsigned type, then was checking for < 0.  This is fixed now.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at32ap700x.c |    2 +-
 drivers/rtc/rtc-cmos.c       |    4 ++--
 drivers/rtc/rtc-ds1511.c     |   18 +++++++++---------
 drivers/rtc/rtc-ds1553.c     |   14 +++++++-------
 drivers/rtc/rtc-m48t59.c     |    2 +-
 drivers/rtc/rtc-sh.c         |   10 ++++++----
 drivers/rtc/rtc-stk17ta8.c   |   14 +++++++-------
 7 files changed, 33 insertions(+), 31 deletions(-)

diff -puN drivers/rtc/rtc-at32ap700x.c~rtc-bunch-of-drivers-fix-no-irq-case-handing drivers/rtc/rtc-at32ap700x.c
--- a/drivers/rtc/rtc-at32ap700x.c~rtc-bunch-of-drivers-fix-no-irq-case-handing
+++ a/drivers/rtc/rtc-at32ap700x.c
@@ -222,7 +222,7 @@ static int __init at32_rtc_probe(struct 
 	}
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
+	if (irq <= 0) {
 		dev_dbg(&pdev->dev, "could not get irq\n");
 		ret = -ENXIO;
 		goto out;
diff -puN drivers/rtc/rtc-cmos.c~rtc-bunch-of-drivers-fix-no-irq-case-handing drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-bunch-of-drivers-fix-no-irq-case-handing
+++ a/drivers/rtc/rtc-cmos.c
@@ -57,8 +57,8 @@ struct cmos_rtc {
 	u8			century;
 };
 
-/* both platform and pnp busses use negative numbers for invalid irqs */
-#define is_valid_irq(n)		((n) >= 0)
+/* both platform and pnp busses use positive numbers for valid irqs */
+#define is_valid_irq(n)		((n) > 0)
 
 static const char driver_name[] = "rtc_cmos";
 
diff -puN drivers/rtc/rtc-ds1511.c~rtc-bunch-of-drivers-fix-no-irq-case-handing drivers/rtc/rtc-ds1511.c
--- a/drivers/rtc/rtc-ds1511.c~rtc-bunch-of-drivers-fix-no-irq-case-handing
+++ a/drivers/rtc/rtc-ds1511.c
@@ -326,9 +326,9 @@ ds1511_rtc_set_alarm(struct device *dev,
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq < 0) {
+	if (pdata->irq <= 0)
 		return -EINVAL;
-	}
+
 	pdata->alrm_mday = alrm->time.tm_mday;
 	pdata->alrm_hour = alrm->time.tm_hour;
 	pdata->alrm_min = alrm->time.tm_min;
@@ -346,9 +346,9 @@ ds1511_rtc_read_alarm(struct device *dev
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq < 0) {
+	if (pdata->irq <= 0)
 		return -EINVAL;
-	}
+
 	alrm->time.tm_mday = pdata->alrm_mday < 0 ? 0 : pdata->alrm_mday;
 	alrm->time.tm_hour = pdata->alrm_hour < 0 ? 0 : pdata->alrm_hour;
 	alrm->time.tm_min = pdata->alrm_min < 0 ? 0 : pdata->alrm_min;
@@ -385,7 +385,7 @@ ds1511_rtc_release(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		pdata->irqen = 0;
 		ds1511_rtc_update_alarm(pdata);
 	}
@@ -397,7 +397,7 @@ ds1511_rtc_ioctl(struct device *dev, uns
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq < 0) {
+	if (pdata->irq <= 0) {
 		return -ENOIOCTLCMD; /* fall back into rtc-dev's emulation */
 	}
 	switch (cmd) {
@@ -559,7 +559,7 @@ ds1511_rtc_probe(struct platform_device 
 	 * if the platform has an interrupt in mind for this device,
 	 * then by all means, set it
 	 */
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		rtc_read(RTC_CMD1);
 		if (request_irq(pdata->irq, ds1511_interrupt,
 			IRQF_DISABLED | IRQF_SHARED, pdev->name, pdev) < 0) {
@@ -586,7 +586,7 @@ ds1511_rtc_probe(struct platform_device 
 	if (pdata->rtc) {
 		rtc_device_unregister(pdata->rtc);
 	}
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		free_irq(pdata->irq, pdev);
 	}
 	if (ds1511_base) {
@@ -609,7 +609,7 @@ ds1511_rtc_remove(struct platform_device
 	sysfs_remove_bin_file(&pdev->dev.kobj, &ds1511_nvram_attr);
 	rtc_device_unregister(pdata->rtc);
 	pdata->rtc = NULL;
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		/*
 		 * disable the alarm interrupt
 		 */
diff -puN drivers/rtc/rtc-ds1553.c~rtc-bunch-of-drivers-fix-no-irq-case-handing drivers/rtc/rtc-ds1553.c
--- a/drivers/rtc/rtc-ds1553.c~rtc-bunch-of-drivers-fix-no-irq-case-handing
+++ a/drivers/rtc/rtc-ds1553.c
@@ -162,7 +162,7 @@ static int ds1553_rtc_set_alarm(struct d
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq < 0)
+	if (pdata->irq <= 0)
 		return -EINVAL;
 	pdata->alrm_mday = alrm->time.tm_mday;
 	pdata->alrm_hour = alrm->time.tm_hour;
@@ -179,7 +179,7 @@ static int ds1553_rtc_read_alarm(struct 
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq < 0)
+	if (pdata->irq <= 0)
 		return -EINVAL;
 	alrm->time.tm_mday = pdata->alrm_mday < 0 ? 0 : pdata->alrm_mday;
 	alrm->time.tm_hour = pdata->alrm_hour < 0 ? 0 : pdata->alrm_hour;
@@ -212,7 +212,7 @@ static void ds1553_rtc_release(struct de
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		pdata->irqen = 0;
 		ds1553_rtc_update_alarm(pdata);
 	}
@@ -224,7 +224,7 @@ static int ds1553_rtc_ioctl(struct devic
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq < 0)
+	if (pdata->irq <= 0)
 		return -ENOIOCTLCMD; /* fall back into rtc-dev's emulation */
 	switch (cmd) {
 	case RTC_AIE_OFF:
@@ -339,7 +339,7 @@ static int __devinit ds1553_rtc_probe(st
 	if (readb(ioaddr + RTC_FLAGS) & RTC_FLAGS_BLF)
 		dev_warn(&pdev->dev, "voltage-low detected.\n");
 
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		writeb(0, ioaddr + RTC_INTERRUPTS);
 		if (request_irq(pdata->irq, ds1553_rtc_interrupt,
 				IRQF_DISABLED | IRQF_SHARED,
@@ -365,7 +365,7 @@ static int __devinit ds1553_rtc_probe(st
  out:
 	if (pdata->rtc)
 		rtc_device_unregister(pdata->rtc);
-	if (pdata->irq >= 0)
+	if (pdata->irq > 0)
 		free_irq(pdata->irq, pdev);
 	if (ioaddr)
 		iounmap(ioaddr);
@@ -381,7 +381,7 @@ static int __devexit ds1553_rtc_remove(s
 
 	sysfs_remove_bin_file(&pdev->dev.kobj, &ds1553_nvram_attr);
 	rtc_device_unregister(pdata->rtc);
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		writeb(0, pdata->ioaddr + RTC_INTERRUPTS);
 		free_irq(pdata->irq, pdev);
 	}
diff -puN drivers/rtc/rtc-m48t59.c~rtc-bunch-of-drivers-fix-no-irq-case-handing drivers/rtc/rtc-m48t59.c
--- a/drivers/rtc/rtc-m48t59.c~rtc-bunch-of-drivers-fix-no-irq-case-handing
+++ a/drivers/rtc/rtc-m48t59.c
@@ -425,7 +425,7 @@ static int __devinit m48t59_rtc_probe(st
 	 * the mode without IRQ.
 	 */
 	m48t59->irq = platform_get_irq(pdev, 0);
-	if (m48t59->irq < 0)
+	if (m48t59->irq <= 0)
 		m48t59->irq = NO_IRQ;
 
 	if (m48t59->irq != NO_IRQ) {
diff -puN drivers/rtc/rtc-sh.c~rtc-bunch-of-drivers-fix-no-irq-case-handing drivers/rtc/rtc-sh.c
--- a/drivers/rtc/rtc-sh.c~rtc-bunch-of-drivers-fix-no-irq-case-handing
+++ a/drivers/rtc/rtc-sh.c
@@ -89,7 +89,9 @@ struct sh_rtc {
 	void __iomem *regbase;
 	unsigned long regsize;
 	struct resource *res;
-	unsigned int alarm_irq, periodic_irq, carry_irq;
+	int alarm_irq;
+	int periodic_irq;
+	int carry_irq;
 	struct rtc_device *rtc_dev;
 	spinlock_t lock;
 	unsigned long capabilities;	/* See asm-sh/rtc.h for cap bits */
@@ -585,7 +587,7 @@ static int __devinit sh_rtc_probe(struct
 
 	/* get periodic/carry/alarm irqs */
 	ret = platform_get_irq(pdev, 0);
-	if (unlikely(ret < 0)) {
+	if (unlikely(ret <= 0)) {
 		ret = -ENOENT;
 		dev_err(&pdev->dev, "No IRQ for period\n");
 		goto err_badres;
@@ -593,7 +595,7 @@ static int __devinit sh_rtc_probe(struct
 	rtc->periodic_irq = ret;
 
 	ret = platform_get_irq(pdev, 1);
-	if (unlikely(ret < 0)) {
+	if (unlikely(ret <= 0)) {
 		ret = -ENOENT;
 		dev_err(&pdev->dev, "No IRQ for carry\n");
 		goto err_badres;
@@ -601,7 +603,7 @@ static int __devinit sh_rtc_probe(struct
 	rtc->carry_irq = ret;
 
 	ret = platform_get_irq(pdev, 2);
-	if (unlikely(ret < 0)) {
+	if (unlikely(ret <= 0)) {
 		ret = -ENOENT;
 		dev_err(&pdev->dev, "No IRQ for alarm\n");
 		goto err_badres;
diff -puN drivers/rtc/rtc-stk17ta8.c~rtc-bunch-of-drivers-fix-no-irq-case-handing drivers/rtc/rtc-stk17ta8.c
--- a/drivers/rtc/rtc-stk17ta8.c~rtc-bunch-of-drivers-fix-no-irq-case-handing
+++ a/drivers/rtc/rtc-stk17ta8.c
@@ -170,7 +170,7 @@ static int stk17ta8_rtc_set_alarm(struct
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq < 0)
+	if (pdata->irq <= 0)
 		return -EINVAL;
 	pdata->alrm_mday = alrm->time.tm_mday;
 	pdata->alrm_hour = alrm->time.tm_hour;
@@ -187,7 +187,7 @@ static int stk17ta8_rtc_read_alarm(struc
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq < 0)
+	if (pdata->irq <= 0)
 		return -EINVAL;
 	alrm->time.tm_mday = pdata->alrm_mday < 0 ? 0 : pdata->alrm_mday;
 	alrm->time.tm_hour = pdata->alrm_hour < 0 ? 0 : pdata->alrm_hour;
@@ -220,7 +220,7 @@ static void stk17ta8_rtc_release(struct 
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		pdata->irqen = 0;
 		stk17ta8_rtc_update_alarm(pdata);
 	}
@@ -232,7 +232,7 @@ static int stk17ta8_rtc_ioctl(struct dev
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq < 0)
+	if (pdata->irq <= 0)
 		return -ENOIOCTLCMD; /* fall back into rtc-dev's emulation */
 	switch (cmd) {
 	case RTC_AIE_OFF:
@@ -342,7 +342,7 @@ static int __init stk17ta8_rtc_probe(str
 	if (readb(ioaddr + RTC_FLAGS) & RTC_FLAGS_PF)
 		dev_warn(&pdev->dev, "voltage-low detected.\n");
 
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		writeb(0, ioaddr + RTC_INTERRUPTS);
 		if (request_irq(pdata->irq, stk17ta8_rtc_interrupt,
 				IRQF_DISABLED | IRQF_SHARED,
@@ -368,7 +368,7 @@ static int __init stk17ta8_rtc_probe(str
  out:
 	if (pdata->rtc)
 		rtc_device_unregister(pdata->rtc);
-	if (pdata->irq >= 0)
+	if (pdata->irq > 0)
 		free_irq(pdata->irq, pdev);
 	if (ioaddr)
 		iounmap(ioaddr);
@@ -384,7 +384,7 @@ static int __devexit stk17ta8_rtc_remove
 
 	sysfs_remove_bin_file(&pdev->dev.kobj, &stk17ta8_nvram_attr);
 	rtc_device_unregister(pdata->rtc);
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		writeb(0, pdata->ioaddr + RTC_INTERRUPTS);
 		free_irq(pdata->irq, pdev);
 	}
diff -puN drivers/rtc/rtc-vr41xx.c~rtc-bunch-of-drivers-fix-no-irq-case-handing drivers/rtc/rtc-vr41xx.c
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
usb-protect-hcdh-from-multiple-inclusions.patch
rtc-bunch-of-drivers-fix-no-irq-case-handing.patch

