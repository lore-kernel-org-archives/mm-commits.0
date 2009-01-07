From: akpm@linux-foundation.org
Subject: - rtc-bunch-of-drivers-fix-no-irq-case-handing.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:18:55 -0800
Message-ID: <200901072218.n07MItMb018328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752376AbZAGWnr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:43:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, a.zummo@towertech.it, dbrownell@users.sourceforge.net, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     rtc: bunch of drivers: fix 'no irq' case handing
has been removed from the -mm tree.  Its filename was
     rtc-bunch-of-drivers-fix-no-irq-case-handing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: bunch of drivers: fix 'no irq' case handing
From: Anton Vorontsov <avorontsov@ru.mvista.com>

This patch fixes a bunch of irq checking misuses.  Most drivers were
getting irq via platform_get_irq(), which returns -ENXIO or r->start. 

rtc-cmos.c is special.  It is using PNP and platform bindings.  Hopefully
nobody is using PNP IRQ 0 for RTC.  So the changes should be safe.

rtc-sh.c is using platform_get_irq, but was storing a result into an
unsigned type, then was checking for < 0.  This is fixed now.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at32ap700x.c |    4 ++--
 drivers/rtc/rtc-cmos.c       |    2 +-
 drivers/rtc/rtc-ds1511.c     |   19 +++++++++----------
 drivers/rtc/rtc-ds1553.c     |   15 +++++++--------
 drivers/rtc/rtc-m48t59.c     |    2 +-
 drivers/rtc/rtc-sh.c         |   10 ++++++----
 drivers/rtc/rtc-stk17ta8.c   |   15 +++++++--------
 drivers/rtc/rtc-twl4030.c    |    5 +++--
 drivers/rtc/rtc-vr41xx.c     |    8 ++++----
 9 files changed, 40 insertions(+), 40 deletions(-)

diff -puN drivers/rtc/rtc-at32ap700x.c~rtc-bunch-of-drivers-fix-no-irq-case-handing drivers/rtc/rtc-at32ap700x.c
--- a/drivers/rtc/rtc-at32ap700x.c~rtc-bunch-of-drivers-fix-no-irq-case-handing
+++ a/drivers/rtc/rtc-at32ap700x.c
@@ -205,7 +205,7 @@ static int __init at32_rtc_probe(struct 
 {
 	struct resource	*regs;
 	struct rtc_at32ap700x *rtc;
-	int irq = -1;
+	int irq;
 	int ret;
 
 	rtc = kzalloc(sizeof(struct rtc_at32ap700x), GFP_KERNEL);
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
@@ -58,7 +58,7 @@ struct cmos_rtc {
 };
 
 /* both platform and pnp busses use negative numbers for invalid irqs */
-#define is_valid_irq(n)		((n) >= 0)
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
@@ -385,7 +385,7 @@ ds1511_rtc_ioctl(struct device *dev, uns
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq < 0) {
+	if (pdata->irq <= 0) {
 		return -ENOIOCTLCMD; /* fall back into rtc-dev's emulation */
 	}
 	switch (cmd) {
@@ -503,7 +503,6 @@ ds1511_rtc_probe(struct platform_device 
 	if (!pdata) {
 		return -ENOMEM;
 	}
-	pdata->irq = -1;
 	pdata->size = res->end - res->start + 1;
 	if (!request_mem_region(res->start, pdata->size, pdev->name)) {
 		ret = -EBUSY;
@@ -545,13 +544,13 @@ ds1511_rtc_probe(struct platform_device 
 	 * if the platform has an interrupt in mind for this device,
 	 * then by all means, set it
 	 */
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		rtc_read(RTC_CMD1);
 		if (request_irq(pdata->irq, ds1511_interrupt,
 			IRQF_DISABLED | IRQF_SHARED, pdev->name, pdev) < 0) {
 
 			dev_warn(&pdev->dev, "interrupt not available.\n");
-			pdata->irq = -1;
+			pdata->irq = 0;
 		}
 	}
 
@@ -572,7 +571,7 @@ ds1511_rtc_probe(struct platform_device 
 	if (pdata->rtc) {
 		rtc_device_unregister(pdata->rtc);
 	}
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		free_irq(pdata->irq, pdev);
 	}
 	if (ds1511_base) {
@@ -595,7 +594,7 @@ ds1511_rtc_remove(struct platform_device
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
@@ -213,7 +213,7 @@ static int ds1553_rtc_ioctl(struct devic
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq < 0)
+	if (pdata->irq <= 0)
 		return -ENOIOCTLCMD; /* fall back into rtc-dev's emulation */
 	switch (cmd) {
 	case RTC_AIE_OFF:
@@ -301,7 +301,6 @@ static int __devinit ds1553_rtc_probe(st
 	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
-	pdata->irq = -1;
 	if (!request_mem_region(res->start, RTC_REG_SIZE, pdev->name)) {
 		ret = -EBUSY;
 		goto out;
@@ -327,13 +326,13 @@ static int __devinit ds1553_rtc_probe(st
 	if (readb(ioaddr + RTC_FLAGS) & RTC_FLAGS_BLF)
 		dev_warn(&pdev->dev, "voltage-low detected.\n");
 
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		writeb(0, ioaddr + RTC_INTERRUPTS);
 		if (request_irq(pdata->irq, ds1553_rtc_interrupt,
 				IRQF_DISABLED | IRQF_SHARED,
 				pdev->name, pdev) < 0) {
 			dev_warn(&pdev->dev, "interrupt not available.\n");
-			pdata->irq = -1;
+			pdata->irq = 0;
 		}
 	}
 
@@ -353,7 +352,7 @@ static int __devinit ds1553_rtc_probe(st
  out:
 	if (pdata->rtc)
 		rtc_device_unregister(pdata->rtc);
-	if (pdata->irq >= 0)
+	if (pdata->irq > 0)
 		free_irq(pdata->irq, pdev);
 	if (ioaddr)
 		iounmap(ioaddr);
@@ -369,7 +368,7 @@ static int __devexit ds1553_rtc_remove(s
 
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
@@ -450,7 +450,7 @@ static int __devinit m48t59_rtc_probe(st
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
@@ -578,7 +580,7 @@ static int __devinit sh_rtc_probe(struct
 
 	/* get periodic/carry/alarm irqs */
 	ret = platform_get_irq(pdev, 0);
-	if (unlikely(ret < 0)) {
+	if (unlikely(ret <= 0)) {
 		ret = -ENOENT;
 		dev_err(&pdev->dev, "No IRQ for period\n");
 		goto err_badres;
@@ -586,7 +588,7 @@ static int __devinit sh_rtc_probe(struct
 	rtc->periodic_irq = ret;
 
 	ret = platform_get_irq(pdev, 1);
-	if (unlikely(ret < 0)) {
+	if (unlikely(ret <= 0)) {
 		ret = -ENOENT;
 		dev_err(&pdev->dev, "No IRQ for carry\n");
 		goto err_badres;
@@ -594,7 +596,7 @@ static int __devinit sh_rtc_probe(struct
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
@@ -221,7 +221,7 @@ static int stk17ta8_rtc_ioctl(struct dev
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	if (pdata->irq < 0)
+	if (pdata->irq <= 0)
 		return -ENOIOCTLCMD; /* fall back into rtc-dev's emulation */
 	switch (cmd) {
 	case RTC_AIE_OFF:
@@ -303,7 +303,6 @@ static int __init stk17ta8_rtc_probe(str
 	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
-	pdata->irq = -1;
 	if (!request_mem_region(res->start, RTC_REG_SIZE, pdev->name)) {
 		ret = -EBUSY;
 		goto out;
@@ -329,13 +328,13 @@ static int __init stk17ta8_rtc_probe(str
 	if (readb(ioaddr + RTC_FLAGS) & RTC_FLAGS_PF)
 		dev_warn(&pdev->dev, "voltage-low detected.\n");
 
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		writeb(0, ioaddr + RTC_INTERRUPTS);
 		if (request_irq(pdata->irq, stk17ta8_rtc_interrupt,
 				IRQF_DISABLED | IRQF_SHARED,
 				pdev->name, pdev) < 0) {
 			dev_warn(&pdev->dev, "interrupt not available.\n");
-			pdata->irq = -1;
+			pdata->irq = 0;
 		}
 	}
 
@@ -355,7 +354,7 @@ static int __init stk17ta8_rtc_probe(str
  out:
 	if (pdata->rtc)
 		rtc_device_unregister(pdata->rtc);
-	if (pdata->irq >= 0)
+	if (pdata->irq > 0)
 		free_irq(pdata->irq, pdev);
 	if (ioaddr)
 		iounmap(ioaddr);
@@ -371,7 +370,7 @@ static int __devexit stk17ta8_rtc_remove
 
 	sysfs_remove_bin_file(&pdev->dev.kobj, &stk17ta8_nvram_attr);
 	rtc_device_unregister(pdata->rtc);
-	if (pdata->irq >= 0) {
+	if (pdata->irq > 0) {
 		writeb(0, pdata->ioaddr + RTC_INTERRUPTS);
 		free_irq(pdata->irq, pdev);
 	}
diff -puN drivers/rtc/rtc-twl4030.c~rtc-bunch-of-drivers-fix-no-irq-case-handing drivers/rtc/rtc-twl4030.c
--- a/drivers/rtc/rtc-twl4030.c~rtc-bunch-of-drivers-fix-no-irq-case-handing
+++ a/drivers/rtc/rtc-twl4030.c
@@ -19,6 +19,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/types.h>
@@ -415,8 +416,8 @@ static int __devinit twl4030_rtc_probe(s
 	int irq = platform_get_irq(pdev, 0);
 	u8 rd_reg;
 
-	if (irq < 0)
-		return irq;
+	if (irq <= 0)
+		return -EINVAL;
 
 	rtc = rtc_device_register(pdev->name,
 				  &pdev->dev, &twl4030_rtc_ops, THIS_MODULE);
diff -puN drivers/rtc/rtc-vr41xx.c~rtc-bunch-of-drivers-fix-no-irq-case-handing drivers/rtc/rtc-vr41xx.c
--- a/drivers/rtc/rtc-vr41xx.c~rtc-bunch-of-drivers-fix-no-irq-case-handing
+++ a/drivers/rtc/rtc-vr41xx.c
@@ -84,8 +84,8 @@ static DEFINE_SPINLOCK(rtc_lock);
 static char rtc_name[] = "RTC";
 static unsigned long periodic_count;
 static unsigned int alarm_enabled;
-static int aie_irq = -1;
-static int pie_irq = -1;
+static int aie_irq;
+static int pie_irq;
 
 static inline unsigned long read_elapsed_second(void)
 {
@@ -360,7 +360,7 @@ static int __devinit rtc_probe(struct pl
 	spin_unlock_irq(&rtc_lock);
 
 	aie_irq = platform_get_irq(pdev, 0);
-	if (aie_irq < 0 || aie_irq >= nr_irqs) {
+	if (aie_irq <= 0) {
 		retval = -EBUSY;
 		goto err_device_unregister;
 	}
@@ -371,7 +371,7 @@ static int __devinit rtc_probe(struct pl
 		goto err_device_unregister;
 
 	pie_irq = platform_get_irq(pdev, 1);
-	if (pie_irq < 0 || pie_irq >= nr_irqs)
+	if (pie_irq <= 0)
 		goto err_free_irq;
 
 	retval = request_irq(pie_irq, rtclong1_interrupt, IRQF_DISABLED,
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
linux-next.patch
usb-driver-for-freescale-quicc-engine-usb-host-controller.patch
usb-fsl_qe_udc-fix-oops-on-qe-udc-probe-failure.patch
usb-fsl_qe_udc-fix-recursive-locking-bug-in-ch9getstatus.patch
usb-fsl_qe_udc-fix-qe-usb-controller-initialization.patch
usb-fsl_qe_udc-fix-disconnects-reporting-during-bus-reset.patch
usb-fsl_qe_udc-fix-muram-corruption-by-disabled-endpoints.patch
usb-fsl_qe_udc-fix-stalled-tx-requests-bug.patch

