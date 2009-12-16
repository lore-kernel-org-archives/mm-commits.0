From: akpm@linux-foundation.org
Subject: [merged] rtc-make-rtc-omap-driver-ioremap-its-register-space.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:34:53 -0800
Message-ID: <200912162034.nBGKYrSD013051@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935274AbZLPUf2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:35:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgreer@mvista.com, a.zummo@towertech.it, dbrownell@users.sourceforge.net, khilman@deeprootsystems.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     rtc: make rtc-omap driver ioremap its register space
has been removed from the -mm tree.  Its filename was
     rtc-make-rtc-omap-driver-ioremap-its-register-space.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: make rtc-omap driver ioremap its register space
From: Mark A. Greer <mgreer@mvista.com>

The rtc-omap driver currently assumes that the rtc's registers are at a
fixed address and already mapped into virtual memory space.  Remove those
assumptions so the same driver can be used for similar devices that reside
at different physical addresses (e.g., TI's DA8xx/OMAP-L13x SoC's).

Also allow the possibility for the timer and alarm interrupts to use the
same IRQ.

Signed-off-by: Mark A. Greer <mgreer@mvista.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Kevin Hilman <khilman@deeprootsystems.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig    |    7 +++--
 drivers/rtc/rtc-omap.c |   47 +++++++++++++++++++++------------------
 2 files changed, 30 insertions(+), 24 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-make-rtc-omap-driver-ioremap-its-register-space drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-make-rtc-omap-driver-ioremap-its-register-space
+++ a/drivers/rtc/Kconfig
@@ -597,10 +597,11 @@ comment "on-CPU RTC drivers"
 
 config RTC_DRV_OMAP
 	tristate "TI OMAP1"
-	depends on ARCH_OMAP15XX || ARCH_OMAP16XX || ARCH_OMAP730
+	depends on ARCH_OMAP15XX || ARCH_OMAP16XX || ARCH_OMAP730 || ARCH_DAVINCI_DA8XX
 	help
-	  Say "yes" here to support the real time clock on TI OMAP1 chips.
-	  This driver can also be built as a module called rtc-omap.
+	  Say "yes" here to support the real time clock on TI OMAP1 and
+	  DA8xx/OMAP-L13x chips.  This driver can also be built as a
+	  module called rtc-omap.
 
 config RTC_DRV_S3C
 	tristate "Samsung S3C series SoC RTC"
diff -puN drivers/rtc/rtc-omap.c~rtc-make-rtc-omap-driver-ioremap-its-register-space drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-make-rtc-omap-driver-ioremap-its-register-space
+++ a/drivers/rtc/rtc-omap.c
@@ -87,9 +87,10 @@
 #define OMAP_RTC_INTERRUPTS_IT_ALARM    (1<<3)
 #define OMAP_RTC_INTERRUPTS_IT_TIMER    (1<<2)
 
+static void __iomem	*rtc_base;
 
-#define rtc_read(addr)		omap_readb(OMAP_RTC_BASE + (addr))
-#define rtc_write(val, addr)	omap_writeb(val, OMAP_RTC_BASE + (addr))
+#define rtc_read(addr)		__raw_readb(rtc_base + (addr))
+#define rtc_write(val, addr)	__raw_writeb(val, rtc_base + (addr))
 
 
 /* we rely on the rtc framework to handle locking (rtc->ops_lock),
@@ -330,32 +331,31 @@ static int __init omap_rtc_probe(struct 
 		return -ENOENT;
 	}
 
-	/* NOTE:  using static mapping for RTC registers */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res && res->start != OMAP_RTC_BASE) {
-		pr_debug("%s: RTC registers at %08x, expected %08x\n",
-			pdev->name, (unsigned) res->start, OMAP_RTC_BASE);
+	if (!res) {
+		pr_debug("%s: RTC resource data missing\n", pdev->name);
 		return -ENOENT;
 	}
 
-	if (res)
-		mem = request_mem_region(res->start,
-				res->end - res->start + 1,
-				pdev->name);
-	else
-		mem = NULL;
+	mem = request_mem_region(res->start, resource_size(res), pdev->name);
 	if (!mem) {
 		pr_debug("%s: RTC registers at %08x are not free\n",
-			pdev->name, OMAP_RTC_BASE);
+			pdev->name, res->start);
 		return -EBUSY;
 	}
 
+	rtc_base = ioremap(res->start, resource_size(res));
+	if (!rtc_base) {
+		pr_debug("%s: RTC registers can't be mapped\n", pdev->name);
+		goto fail;
+	}
+
 	rtc = rtc_device_register(pdev->name, &pdev->dev,
 			&omap_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		pr_debug("%s: can't register RTC device, err %ld\n",
 			pdev->name, PTR_ERR(rtc));
-		goto fail;
+		goto fail0;
 	}
 	platform_set_drvdata(pdev, rtc);
 	dev_set_drvdata(&rtc->dev, mem);
@@ -380,13 +380,14 @@ static int __init omap_rtc_probe(struct 
 			dev_name(&rtc->dev), rtc)) {
 		pr_debug("%s: RTC timer interrupt IRQ%d already claimed\n",
 			pdev->name, omap_rtc_timer);
-		goto fail0;
+		goto fail1;
 	}
-	if (request_irq(omap_rtc_alarm, rtc_irq, IRQF_DISABLED,
-			dev_name(&rtc->dev), rtc)) {
+	if ((omap_rtc_timer != omap_rtc_alarm) &&
+		(request_irq(omap_rtc_alarm, rtc_irq, IRQF_DISABLED,
+			dev_name(&rtc->dev), rtc))) {
 		pr_debug("%s: RTC alarm interrupt IRQ%d already claimed\n",
 			pdev->name, omap_rtc_alarm);
-		goto fail1;
+		goto fail2;
 	}
 
 	/* On boards with split power, RTC_ON_NOFF won't reset the RTC */
@@ -419,10 +420,12 @@ static int __init omap_rtc_probe(struct 
 
 	return 0;
 
-fail1:
+fail2:
 	free_irq(omap_rtc_timer, NULL);
-fail0:
+fail1:
 	rtc_device_unregister(rtc);
+fail0:
+	iounmap(rtc_base);
 fail:
 	release_resource(mem);
 	return -EIO;
@@ -438,7 +441,9 @@ static int __exit omap_rtc_remove(struct
 	rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
 
 	free_irq(omap_rtc_timer, rtc);
-	free_irq(omap_rtc_alarm, rtc);
+
+	if (omap_rtc_timer != omap_rtc_alarm)
+		free_irq(omap_rtc_alarm, rtc);
 
 	release_resource(dev_get_drvdata(&rtc->dev));
 	rtc_device_unregister(rtc);
_

Patches currently in -mm which might be from mgreer@mvista.com are

origin.patch

