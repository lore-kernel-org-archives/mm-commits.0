From: akpm@linux-foundation.org
Subject: [merged] rtc-s5m-enable-irq-wake-during-suspend.patch removed
 from -mm tree
Date: Mon, 16 Dec 2013 12:39:36 -0800
Message-ID: <52af6508.dUQs9hXZ6lmaqei7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab3LPUjh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 15:39:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sbkim73@samsung.com, sameo@linux.intel.com, m.szyprowski@samsung.com, lgirdwood@gmail.com, lee.jones@linaro.org, kyungmin.park@samsung.com, geert@linux-m68k.org, broonie@linaro.org, a.zummo@towertech.it, k.kozlowski@samsung.com

Subject: [merged] rtc-s5m-enable-irq-wake-during-suspend.patch removed from -mm tree
To: k.kozlowski@samsung.com,a.zummo@towertech.it,broonie@linaro.org,geert@linux-m68k.org,kyungmin.park@samsung.com,lee.jones@linaro.org,lgirdwood@gmail.com,m.szyprowski@samsung.com,sameo@linux.intel.com,sbkim73@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 12:39:36 -0800


The patch titled
     Subject: rtc: s5m: enable IRQ wake during suspend
has been removed from the -mm tree.  Its filename was
     rtc-s5m-enable-irq-wake-during-suspend.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: rtc: s5m: enable IRQ wake during suspend

Add PM suspend/resume ops to rtc-s5m driver and enable IRQ wake during
suspend so the RTC would act like a wake up source.  This allows waking up
from suspend to RAM on RTC alarm interrupt.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mark Brown <broonie@linaro.org>
Acked-by: Sangbeom Kim <sbkim73@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s5m.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff -puN drivers/rtc/rtc-s5m.c~rtc-s5m-enable-irq-wake-during-suspend drivers/rtc/rtc-s5m.c
--- a/drivers/rtc/rtc-s5m.c~rtc-s5m-enable-irq-wake-during-suspend
+++ a/drivers/rtc/rtc-s5m.c
@@ -639,6 +639,30 @@ static void s5m_rtc_shutdown(struct plat
 	s5m_rtc_enable_smpl(info, false);
 }
 
+static int s5m_rtc_resume(struct device *dev)
+{
+	struct s5m_rtc_info *info = dev_get_drvdata(dev);
+	int ret = 0;
+
+	if (device_may_wakeup(dev))
+		ret = disable_irq_wake(info->irq);
+
+	return ret;
+}
+
+static int s5m_rtc_suspend(struct device *dev)
+{
+	struct s5m_rtc_info *info = dev_get_drvdata(dev);
+	int ret = 0;
+
+	if (device_may_wakeup(dev))
+		ret = enable_irq_wake(info->irq);
+
+	return ret;
+}
+
+static SIMPLE_DEV_PM_OPS(s5m_rtc_pm_ops, s5m_rtc_suspend, s5m_rtc_resume);
+
 static const struct platform_device_id s5m_rtc_id[] = {
 	{ "s5m-rtc", 0 },
 };
@@ -647,6 +671,7 @@ static struct platform_driver s5m_rtc_dr
 	.driver		= {
 		.name	= "s5m-rtc",
 		.owner	= THIS_MODULE,
+		.pm	= &s5m_rtc_pm_ops,
 	},
 	.probe		= s5m_rtc_probe,
 	.shutdown	= s5m_rtc_shutdown,
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

swap-fix-setting-page_size-blocksize-during-swapoff-swapon-race.patch
linux-next.patch

