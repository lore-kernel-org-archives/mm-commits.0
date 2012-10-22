From: akpm@linux-foundation.org
Subject: + rtc-omap-add-runtime-pm-support.patch added to -mm tree
Date: Mon, 22 Oct 2012 15:21:08 -0700
Message-ID: <20121022222109.4804E100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:53107 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab2JVWVK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Oct 2012 18:21:10 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so404211qcq.1
        for <mm-commits@vger.kernel.org>; Mon, 22 Oct 2012 15:21:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hvaibhav@ti.com, a.zummo@towertech.it, afzal@ti.com, grant.likely@secretlab.ca, khilman@ti.com, linux@arm.linux.org.uk, nsekhar@ti.com, zonque@gmail.com


The patch titled
     Subject: rtc: omap: add runtime pm support
has been added to the -mm tree.  Its filename is
     rtc-omap-add-runtime-pm-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vaibhav Hiremath <hvaibhav@ti.com>
Subject: rtc: omap: add runtime pm support

OMAP1 RTC driver is used in multiple devices like, OMAPL138 and AM33XX. 
Driver currently doesn't handle any clocks, which may be right for OMAP1
architecture but in case of AM33XX, the clock/module needs to be enabled
in order to access the registers.

So convert this driver to runtime pm, which internally handles rest.

[afzal@ti.com: handle error path]
Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
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

 drivers/rtc/rtc-omap.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-add-runtime-pm-support drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-add-runtime-pm-support
+++ a/drivers/rtc/rtc-omap.c
@@ -22,6 +22,7 @@
 #include <linux/platform_device.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/pm_runtime.h>
 
 #include <asm/io.h>
 
@@ -364,6 +365,10 @@ static int __init omap_rtc_probe(struct 
 		goto fail;
 	}
 
+	/* Enable the clock/module so that we can access the registers */
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_get_sync(&pdev->dev);
+
 	id_entry = platform_get_device_id(pdev);
 	if (id_entry && (id_entry->driver_data & OMAP_RTC_HAS_KICKER)) {
 		rtc_writel(KICK0_VALUE, OMAP_RTC_KICK0_REG);
@@ -448,6 +453,8 @@ fail1:
 fail0:
 	if (id_entry && (id_entry->driver_data & OMAP_RTC_HAS_KICKER))
 		rtc_writel(0, OMAP_RTC_KICK0_REG);
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
 	iounmap(rtc_base);
 fail:
 	release_mem_region(mem->start, resource_size(mem));
@@ -474,6 +481,11 @@ static int __exit omap_rtc_remove(struct
 	rtc_device_unregister(rtc);
 	if (id_entry && (id_entry->driver_data & OMAP_RTC_HAS_KICKER))
 		rtc_writel(0, OMAP_RTC_KICK0_REG);
+
+	/* Disable the clock/module */
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
 	iounmap(rtc_base);
 	release_mem_region(mem->start, resource_size(mem));
 	return 0;
@@ -496,11 +508,17 @@ static int omap_rtc_suspend(struct platf
 	else
 		rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
 
+	/* Disable the clock/module */
+	pm_runtime_put_sync(&pdev->dev);
+
 	return 0;
 }
 
 static int omap_rtc_resume(struct platform_device *pdev)
 {
+	/* Enable the clock/module so that we can access the registers */
+	pm_runtime_get_sync(&pdev->dev);
+
 	if (device_may_wakeup(&pdev->dev))
 		disable_irq_wake(omap_rtc_alarm);
 	else
_

Patches currently in -mm which might be from hvaibhav@ti.com are

rtc-omap-kicker-mechanism-support.patch
arm-davinci-remove-rtc-kicker-release.patch
rtc-omap-dt-support.patch
rtc-omap-depend-on-am33xx.patch
rtc-omap-add-runtime-pm-support.patch

