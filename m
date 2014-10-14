From: akpm@linux-foundation.org
Subject: [merged]
 rtc-max77686-allow-the-max77686-rtc-to-wakeup-the-system.patch removed from -mm tree
Date: Tue, 14 Oct 2014 11:20:38 -0700
Message-ID: <543d6976.180O0llENUbNDm7H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaJNSUh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:20:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dianders@chromium.org, a.zummo@towertech.it, javier.martinez@collabora.co.uk, k.kozlowski@samsung.com, olof@lixom.net, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: max77686: Allow the max77686 rtc to wakeup the system
has been removed from the -mm tree.  Its filename was
     rtc-max77686-allow-the-max77686-rtc-to-wakeup-the-system.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Doug Anderson <dianders@chromium.org>
Subject: rtc: max77686: Allow the max77686 rtc to wakeup the system

This series add support for the Real Time clock present in the Maxim 77802
Power Managment IC.  The version number is quite high because it
previously was part of a bigger series [0] that aimed to add support for
all the devices in the max77802 PMIC.  But now that the max77802
dependencies were already merged for 3.17, the series were split but I
kept the version numbering.

While working on the max77802 rtc support a lot of feedback was given and
the issues pointed out also apply to a driver for a similar PMIC RTC
(max77686).  So patches 01/06 to 05/06 in the series are cleanups for the
max77686 driver and patch 06/06 adds the support for the max77802 RTC.

The series were tested on an Exynos5250 Snow (max77686) and
Exynos5420 Peach Pit (max77802) machines.


This patch (of 6):

The max77686 includes an RTC that keeps power during suspend.  It's
convenient to be able to use it as a wakeup source.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Olof Johansson <olof@lixom.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max77686.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff -puN drivers/rtc/rtc-max77686.c~rtc-max77686-allow-the-max77686-rtc-to-wakeup-the-system drivers/rtc/rtc-max77686.c
--- a/drivers/rtc/rtc-max77686.c~rtc-max77686-allow-the-max77686-rtc-to-wakeup-the-system
+++ a/drivers/rtc/rtc-max77686.c
@@ -583,6 +583,33 @@ static void max77686_rtc_shutdown(struct
 #endif /* MAX77686_RTC_WTSR_SMPL */
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int max77686_rtc_suspend(struct device *dev)
+{
+	if (device_may_wakeup(dev)) {
+		struct max77686_rtc_info *info = dev_get_drvdata(dev);
+
+		return enable_irq_wake(info->virq);
+	}
+
+	return 0;
+}
+
+static int max77686_rtc_resume(struct device *dev)
+{
+	if (device_may_wakeup(dev)) {
+		struct max77686_rtc_info *info = dev_get_drvdata(dev);
+
+		return disable_irq_wake(info->virq);
+	}
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(max77686_rtc_pm_ops,
+			 max77686_rtc_suspend, max77686_rtc_resume);
+
 static const struct platform_device_id rtc_id[] = {
 	{ "max77686-rtc", 0 },
 	{},
@@ -592,6 +619,7 @@ static struct platform_driver max77686_r
 	.driver		= {
 		.name	= "max77686-rtc",
 		.owner	= THIS_MODULE,
+		.pm	= &max77686_rtc_pm_ops,
 	},
 	.probe		= max77686_rtc_probe,
 	.shutdown	= max77686_rtc_shutdown,
_

Patches currently in -mm which might be from dianders@chromium.org are

origin.patch
linux-next.patch

