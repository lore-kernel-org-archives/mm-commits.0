From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-snvs-add-clock-support.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 11:07:48 -0800
Message-ID: <5489eb84.9FUuTp4pzBueqO6W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46022 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919AbaLKTHt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:07:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maitysanchayan@gmail.com, a.zummo@towertech.it, shawn.guo@linaro.org, stefan@agner.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-snvs: add clock support
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-snvs-add-clock-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sanchayan Maity <maitysanchayan@gmail.com>
Subject: drivers/rtc/rtc-snvs: add clock support

Add clock enable and disable support for the SNVS peripheral, which is
required for using the RTC within the SNVS block.

The clock is not strictly enforced, as this would break the i.MX devices. 
The clocking for the i.MX devices seems to be enabled elsewhere and
enabling RTC SNVS for Vybrid results in a crash.  This patch adds the
clock support but also makes it optional so Vybrid platform can use the
clock if defined while making sure not to break i.MX.

Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Acked-by: Stefan Agner <stefan@agner.ch>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-snvs.c |   34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-snvs.c~drivers-rtc-rtc-snvs-add-clock-support drivers/rtc/rtc-snvs.c
--- a/drivers/rtc/rtc-snvs.c~drivers-rtc-rtc-snvs-add-clock-support
+++ a/drivers/rtc/rtc-snvs.c
@@ -17,6 +17,7 @@
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/rtc.h>
+#include <linux/clk.h>
 
 /* These register offsets are relative to LP (Low Power) range */
 #define SNVS_LPCR		0x04
@@ -39,6 +40,7 @@ struct snvs_rtc_data {
 	void __iomem *ioaddr;
 	int irq;
 	spinlock_t lock;
+	struct clk *clk;
 };
 
 static u32 rtc_read_lp_counter(void __iomem *ioaddr)
@@ -260,6 +262,18 @@ static int snvs_rtc_probe(struct platfor
 	if (data->irq < 0)
 		return data->irq;
 
+	data->clk = devm_clk_get(&pdev->dev, "snvs-rtc");
+	if (IS_ERR(data->clk)) {
+		data->clk = NULL;
+	} else {
+		ret = clk_prepare_enable(data->clk);
+		if (ret) {
+			dev_err(&pdev->dev,
+				"Could not prepare or enable the snvs clock\n");
+			return ret;
+		}
+	}
+
 	platform_set_drvdata(pdev, data);
 
 	spin_lock_init(&data->lock);
@@ -280,7 +294,7 @@ static int snvs_rtc_probe(struct platfor
 	if (ret) {
 		dev_err(&pdev->dev, "failed to request irq %d: %d\n",
 			data->irq, ret);
-		return ret;
+		goto error_rtc_device_register;
 	}
 
 	data->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
@@ -288,10 +302,16 @@ static int snvs_rtc_probe(struct platfor
 	if (IS_ERR(data->rtc)) {
 		ret = PTR_ERR(data->rtc);
 		dev_err(&pdev->dev, "failed to register rtc: %d\n", ret);
-		return ret;
+		goto error_rtc_device_register;
 	}
 
 	return 0;
+
+error_rtc_device_register:
+	if (data->clk)
+		clk_disable_unprepare(data->clk);
+
+	return ret;
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -302,16 +322,26 @@ static int snvs_rtc_suspend(struct devic
 	if (device_may_wakeup(dev))
 		enable_irq_wake(data->irq);
 
+	if (data->clk)
+		clk_disable_unprepare(data->clk);
+
 	return 0;
 }
 
 static int snvs_rtc_resume(struct device *dev)
 {
 	struct snvs_rtc_data *data = dev_get_drvdata(dev);
+	int ret;
 
 	if (device_may_wakeup(dev))
 		disable_irq_wake(data->irq);
 
+	if (data->clk) {
+		ret = clk_prepare_enable(data->clk);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
 #endif
_

Patches currently in -mm which might be from maitysanchayan@gmail.com are

origin.patch
linux-next.patch

