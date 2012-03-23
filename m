From: akpm@linux-foundation.org
Subject: [merged] thermal-spear_thermal-replace-readl-writel-with-lighter-_relaxed-variants.patch removed from -mm tree
Date: Fri, 23 Mar 2012 11:22:49 -0700
Message-ID: <20120323182249.59CD5A02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:60934 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759169Ab2CWSWu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 14:22:50 -0400
Received: by qabg24 with SMTP id g24so135850qab.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 11:22:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viresh.kumar@st.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: thermal/spear_thermal: replace readl/writel with lighter _relaxed variants
has been removed from the -mm tree.  Its filename was
     thermal-spear_thermal-replace-readl-writel-with-lighter-_relaxed-variants.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Viresh Kumar <viresh.kumar@st.com>
Subject: thermal/spear_thermal: replace readl/writel with lighter _relaxed variants

readl/writel versions for ARM contain memory barrier instruction for
synchronizing DMA buffers.  These are not required at least on this
module.  So use lighter _relaxed variants.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/spear_thermal.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/thermal/spear_thermal.c~thermal-spear_thermal-replace-readl-writel-with-lighter-_relaxed-variants drivers/thermal/spear_thermal.c
--- a/drivers/thermal/spear_thermal.c~thermal-spear_thermal-replace-readl-writel-with-lighter-_relaxed-variants
+++ a/drivers/thermal/spear_thermal.c
@@ -46,7 +46,7 @@ static inline int thermal_get_temp(struc
 	 * Data are ready to be read after 628 usec from POWERDOWN signal
 	 * (PDN) = 1
 	 */
-	*temp = (readl(stdev->thermal_base) & 0x7F) * MD_FACTOR;
+	*temp = (readl_relaxed(stdev->thermal_base) & 0x7F) * MD_FACTOR;
 	return 0;
 }
 
@@ -63,8 +63,8 @@ static int spear_thermal_suspend(struct 
 	unsigned int actual_mask = 0;
 
 	/* Disable SPEAr Thermal Sensor */
-	actual_mask = readl(stdev->thermal_base);
-	writel(actual_mask & ~stdev->flags, stdev->thermal_base);
+	actual_mask = readl_relaxed(stdev->thermal_base);
+	writel_relaxed(actual_mask & ~stdev->flags, stdev->thermal_base);
 
 	clk_disable(stdev->clk);
 	dev_info(dev, "Suspended.\n");
@@ -87,8 +87,8 @@ static int spear_thermal_resume(struct d
 	}
 
 	/* Enable SPEAr Thermal Sensor */
-	actual_mask = readl(stdev->thermal_base);
-	writel(actual_mask | stdev->flags, stdev->thermal_base);
+	actual_mask = readl_relaxed(stdev->thermal_base);
+	writel_relaxed(actual_mask | stdev->flags, stdev->thermal_base);
 
 	dev_info(dev, "Resumed.\n");
 
@@ -145,7 +145,7 @@ static int spear_thermal_probe(struct pl
 	}
 
 	stdev->flags = pdata->thermal_flags;
-	writel(stdev->flags, stdev->thermal_base);
+	writel_relaxed(stdev->flags, stdev->thermal_base);
 
 	spear_thermal = thermal_zone_device_register("spear_thermal", 0,
 				stdev, &ops, 0, 0, 0, 0);
@@ -180,8 +180,8 @@ static int spear_thermal_exit(struct pla
 	platform_set_drvdata(pdev, NULL);
 
 	/* Disable SPEAr Thermal Sensor */
-	actual_mask = readl(stdev->thermal_base);
-	writel(actual_mask & ~stdev->flags, stdev->thermal_base);
+	actual_mask = readl_relaxed(stdev->thermal_base);
+	writel_relaxed(actual_mask & ~stdev->flags, stdev->thermal_base);
 
 	clk_disable(stdev->clk);
 	clk_put(stdev->clk);
_

Patches currently in -mm which might be from viresh.kumar@st.com are

origin.patch
linux-next.patch
rtc-spear-fix-for-balancing-the-enable_irq_wake-in-power-mgmt.patch
rtc-spear-fix-for-rtc_aie_on-and-rtc_aie_off-ioctl-errors.patch
rtc-rtc-spear-call-platform_set_drvdata-before-registering-rtc-device.patch

