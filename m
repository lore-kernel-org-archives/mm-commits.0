From: akpm@linux-foundation.org
Subject: + rtc-omap-kicker-mechanism-support.patch added to -mm tree
Date: Mon, 22 Oct 2012 15:20:55 -0700
Message-ID: <20121022222056.38555100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:50985 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab2JVWU6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Oct 2012 18:20:58 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so404920vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 22 Oct 2012 15:20:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: afzal@ti.com, a.zummo@towertech.it, grant.likely@secretlab.ca, hvaibhav@ti.com, khilman@ti.com, linux@arm.linux.org.uk, nsekhar@ti.com, zonque@gmail.com


The patch titled
     Subject: rtc: omap: kicker mechanism support
has been added to the -mm tree.  Its filename is
     rtc-omap-kicker-mechanism-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Afzal Mohammed <afzal@ti.com>
Subject: rtc: omap: kicker mechanism support

OMAP RTC IP can have kicker feature.  This prevents spurious writes to
register.  To write to registers kicker lock has to be released. 
Procedure to do it as follows,

1. write to kick0 register, 0x83e70b13
2. write to kick1 register, 0x95a4f1e0

Writing value other than 0x83e70b13 to kick0 enables write locking, more
details about kicker mechanism can be found in section 20.3.3.5.3 of
AM335X TRM @www.ti.com/am335x

Here id table information is added and is used to distinguish those that
require kicker handling and the ones that doesn't need it.  There are more
features in the newer IP's compared to legacy ones other than kicker,
which driver currently doesn't handle, supporting additional features
would be easier with the addition of id table.

Older IP (of OMAP1) doesn't have revision register as per TRM, so revision
register can't be relied always to find features, hence id table is being
used.

While at it, replace __raw_writeb/__raw_readb with writeb/readb; this
driver is used on ARMv7 (AM335X SoC)

Signed-off-by: Afzal Mohammed <afzal@ti.com>
Acked-by: Sekhar Nori <nsekhar@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Daniel Mack <zonque@gmail.com>
Cc: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-omap.c |   44 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-kicker-mechanism-support drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-kicker-mechanism-support
+++ a/drivers/rtc/rtc-omap.c
@@ -38,6 +38,8 @@
  * the SoC). See the BOARD-SPECIFIC CUSTOMIZATION comment.
  */
 
+#define	DRIVER_NAME			"omap_rtc"
+
 #define OMAP_RTC_BASE			0xfffb4800
 
 /* RTC registers */
@@ -64,6 +66,9 @@
 #define OMAP_RTC_COMP_MSB_REG		0x50
 #define OMAP_RTC_OSC_REG		0x54
 
+#define OMAP_RTC_KICK0_REG		0x6c
+#define OMAP_RTC_KICK1_REG		0x70
+
 /* OMAP_RTC_CTRL_REG bit fields: */
 #define OMAP_RTC_CTRL_SPLIT		(1<<7)
 #define OMAP_RTC_CTRL_DISABLE		(1<<6)
@@ -88,10 +93,18 @@
 #define OMAP_RTC_INTERRUPTS_IT_ALARM    (1<<3)
 #define OMAP_RTC_INTERRUPTS_IT_TIMER    (1<<2)
 
+/* OMAP_RTC_KICKER values */
+#define	KICK0_VALUE			0x83e70b13
+#define	KICK1_VALUE			0x95a4f1e0
+
+#define	OMAP_RTC_HAS_KICKER		0x1
+
 static void __iomem	*rtc_base;
 
-#define rtc_read(addr)		__raw_readb(rtc_base + (addr))
-#define rtc_write(val, addr)	__raw_writeb(val, rtc_base + (addr))
+#define rtc_read(addr)		readb(rtc_base + (addr))
+#define rtc_write(val, addr)	writeb(val, rtc_base + (addr))
+
+#define rtc_writel(val, addr)	writel(val, rtc_base + (addr))
 
 
 /* we rely on the rtc framework to handle locking (rtc->ops_lock),
@@ -285,11 +298,23 @@ static struct rtc_class_ops omap_rtc_ops
 static int omap_rtc_alarm;
 static int omap_rtc_timer;
 
+static struct platform_device_id omap_rtc_devtype[] = {
+	{
+		.name	= DRIVER_NAME,
+	}, {
+		.name	= "da830-rtc",
+		.driver_data = OMAP_RTC_HAS_KICKER,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(platform, omap_rtc_devtype);
+
 static int __init omap_rtc_probe(struct platform_device *pdev)
 {
 	struct resource		*res, *mem;
 	struct rtc_device	*rtc;
 	u8			reg, new_ctrl;
+	const struct platform_device_id *id_entry;
 
 	omap_rtc_timer = platform_get_irq(pdev, 0);
 	if (omap_rtc_timer <= 0) {
@@ -322,6 +347,12 @@ static int __init omap_rtc_probe(struct 
 		goto fail;
 	}
 
+	id_entry = platform_get_device_id(pdev);
+	if (id_entry && (id_entry->driver_data & OMAP_RTC_HAS_KICKER)) {
+		rtc_writel(KICK0_VALUE, OMAP_RTC_KICK0_REG);
+		rtc_writel(KICK1_VALUE, OMAP_RTC_KICK1_REG);
+	}
+
 	rtc = rtc_device_register(pdev->name, &pdev->dev,
 			&omap_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
@@ -398,6 +429,8 @@ fail2:
 fail1:
 	rtc_device_unregister(rtc);
 fail0:
+	if (id_entry && (id_entry->driver_data & OMAP_RTC_HAS_KICKER))
+		rtc_writel(0, OMAP_RTC_KICK0_REG);
 	iounmap(rtc_base);
 fail:
 	release_mem_region(mem->start, resource_size(mem));
@@ -408,6 +441,8 @@ static int __exit omap_rtc_remove(struct
 {
 	struct rtc_device	*rtc = platform_get_drvdata(pdev);
 	struct resource		*mem = dev_get_drvdata(&rtc->dev);
+	const struct platform_device_id *id_entry =
+				platform_get_device_id(pdev);
 
 	device_init_wakeup(&pdev->dev, 0);
 
@@ -420,6 +455,8 @@ static int __exit omap_rtc_remove(struct
 		free_irq(omap_rtc_alarm, rtc);
 
 	rtc_device_unregister(rtc);
+	if (id_entry && (id_entry->driver_data & OMAP_RTC_HAS_KICKER))
+		rtc_writel(0, OMAP_RTC_KICK0_REG);
 	iounmap(rtc_base);
 	release_mem_region(mem->start, resource_size(mem));
 	return 0;
@@ -471,9 +508,10 @@ static struct platform_driver omap_rtc_d
 	.resume		= omap_rtc_resume,
 	.shutdown	= omap_rtc_shutdown,
 	.driver		= {
-		.name	= "omap_rtc",
+		.name	= DRIVER_NAME,
 		.owner	= THIS_MODULE,
 	},
+	.id_table	= omap_rtc_devtype,
 };
 
 static int __init rtc_init(void)
_

Patches currently in -mm which might be from afzal@ti.com are

rtc-omap-kicker-mechanism-support.patch
arm-davinci-remove-rtc-kicker-release.patch
rtc-omap-dt-support.patch
rtc-omap-depend-on-am33xx.patch
rtc-omap-add-runtime-pm-support.patch

