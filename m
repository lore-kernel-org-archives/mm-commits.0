From: akpm@linux-foundation.org
Subject: + rtc-max77686-allow-the-max77686-rtc-to-wakeup-the-system.patch
 added to -mm tree
Date: Fri, 12 Sep 2014 15:13:46 -0700
Message-ID: <5413701a.64iM4MZqTYJM2fWc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbaILWNr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Sep 2014 18:13:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dianders@chromium.org, a.zummo@towertech.it, javier.martinez@collabora.co.uk, k.kozlowski@samsung.com, olof@lixom.net, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: max77686: Allow the max77686 rtc to wakeup the system
has been added to the -mm tree.  Its filename is
     rtc-max77686-allow-the-max77686-rtc-to-wakeup-the-system.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-max77686-allow-the-max77686-rtc-to-wakeup-the-system.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-max77686-allow-the-max77686-rtc-to-wakeup-the-system.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Doug Anderson <dianders@chromium.org>
Subject: rtc: max77686: Allow the max77686 rtc to wakeup the system

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

rtc-rk808-add-rtc-driver-for-rk808.patch
rtc-rk808-add-rtc-driver-for-rk808-fix-2.patch
clk-rk808-add-clkout-driver-for-rk808.patch
rtc-max77686-allow-the-max77686-rtc-to-wakeup-the-system.patch
rtc-max77686-remove-dead-code-for-smpl-and-wtsr.patch
rtc-max77686-fail-to-probe-if-no-rtc-regmap-irqchip-is-set.patch
rtc-max77686-remove-unneded-info-log.patch
rtc-add-driver-for-maxim-77802-pmic-real-time-clock.patch
linux-next.patch

