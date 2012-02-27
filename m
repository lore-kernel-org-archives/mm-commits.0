From: akpm@linux-foundation.org
Subject: + thermal-spear_thermal-replace-readl-writel-with-lighter-_relaxed-variants.patch added to -mm tree
Date: Mon, 27 Feb 2012 15:26:38 -0800
Message-ID: <20120227232638.E1B7CA00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:44275 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660Ab2B0X0k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2012 18:26:40 -0500
Received: by yenq2 with SMTP id q2so151353yen.1
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2012 15:26:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viresh.kumar@st.com, lenb@kernel.org


The patch titled
     Subject: thermal/spear_thermal: replace readl/writel with lighter _relaxed variants
has been added to the -mm tree.  Its filename is
     thermal-spear_thermal-replace-readl-writel-with-lighter-_relaxed-variants.patch

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
Subject: Subject: thermal/spear_thermal: replace readl/writel with lighter _relaxed variants

Patches currently in -mm which might be from viresh.kumar@st.com are

linux-next.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines-fix.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines-fix-fix.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines-add-compilation-dependency-on-plat_spear.patch
thermal-spear_thermal-replace-readl-writel-with-lighter-_relaxed-variants.patch
rtc-spear-fix-for-balancing-the-enable_irq_wake-in-power-mgmt.patch
rtc-spear-fix-for-rtc_aie_on-and-rtc_aie_off-ioctl-errors.patch
rtc-rtc-spear-call-platform_set_drvdata-before-registering-rtc-device.patch

