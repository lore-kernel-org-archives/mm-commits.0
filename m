From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-sirfsocc-fix-kernel-panic-of-backing-from-hibernation.patch added to -mm tree
Date: Tue, 18 Feb 2014 13:27:04 -0800
Message-ID: <5303d028.x3lCZ78QFAj0qgvz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50148 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaBRV1F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Feb 2014 16:27:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, robh+dt@kernel.org, grant.likely@linaro.org, Baohua.Song@csr.com, Xianglong.Du@csr.com

Subject: + drivers-rtc-rtc-sirfsocc-fix-kernel-panic-of-backing-from-hibernation.patch added to -mm tree
To: Xianglong.Du@csr.com,Baohua.Song@csr.com,grant.likely@linaro.org,robh+dt@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 18 Feb 2014 13:27:04 -0800


The patch titled
     Subject: drivers/rtc/rtc-sirfsoc.c: fix kernel panic of backing from hibernation
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-sirfsocc-fix-kernel-panic-of-backing-from-hibernation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-sirfsocc-fix-kernel-panic-of-backing-from-hibernation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-sirfsocc-fix-kernel-panic-of-backing-from-hibernation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xianglong Du <Xianglong.Du@csr.com>
Subject: drivers/rtc/rtc-sirfsoc.c: fix kernel panic of backing from hibernation

RTC settings will be lost if power supply is cut off after hibernation
finished, but the current "restore" function does not restore RTC related
settings, this causes rtc_read_time failure and kernel panic:

[   72.873363] rtc rtc0: **** DPM device timeout ****
[   72.875332] [<c00154e4>] (unwind_backtrace+0x0/0xf4) from [<c00120b4>] (show_stack+0x10/0x14)
[   72.883862] [<c00120b4>] (show_stack+0x10/0x14) from [<c02179b4>] (dpm_wd_handler+0x24/0x28)
[   72.892288] [<c02179b4>] (dpm_wd_handler+0x24/0x28) from [<c002d6f0>] (call_timer_fn.isra.33+0x24/0x88)
[   72.901663] [<c002d6f0>] (call_timer_fn.isra.33+0x24/0x88) from [<c002d8cc>] (run_timer_softirq+0x178/0x1f0)
[   72.911463] [<c002d8cc>] (run_timer_softirq+0x178/0x1f0) from [<c0027c8c>] (__do_softirq+0x120/0x200)
[   72.920658] [<c0027c8c>] (__do_softirq+0x120/0x200) from [<c0027e1c>] (do_softirq+0x54/0x5c)
[   72.929075] [<c0027e1c>] (do_softirq+0x54/0x5c) from [<c00280c4>] (irq_exit+0x9c/0xd0)
[   72.936971] [<c00280c4>] (irq_exit+0x9c/0xd0) from [<c000ef84>] (handle_IRQ+0x44/0x90)
[   72.944876] [<c000ef84>] (handle_IRQ+0x44/0x90) from [<c000dc80>] (__irq_svc+0x40/0x70)
[   72.952841] [<c000dc80>] (__irq_svc+0x40/0x70) from [<c03864b4>] (_raw_spin_unlock_irqrestore+0x10/0x48)
[   72.962325] [<c03864b4>] (_raw_spin_unlock_irqrestore+0x10/0x48) from [<c001ddc0>] (sirfsoc_rtc_iobrg_readl+0x34/0x3c)
[   72.973007] [<c001ddc0>] (sirfsoc_rtc_iobrg_readl+0x34/0x3c) from [<c027caf8>] (sirfsoc_rtc_read_time+0x24/0x48)
[   72.983147] [<c027caf8>] (sirfsoc_rtc_read_time+0x24/0x48) from [<c027a930>] (__rtc_read_time.isra.3+0x48/0x5c)
[   72.993229] [<c027a930>] (__rtc_read_time.isra.3+0x48/0x5c) from [<c027a974>] (rtc_read_time+0x30/0x44)
[   73.002592] [<c027a974>] (rtc_read_time+0x30/0x44) from [<c027a2f0>] (rtc_resume.part.9+0x20/0x104)
[   73.011620] [<c027a2f0>] (rtc_resume.part.9+0x20/0x104) from [<c027a430>] (rtc_resume+0x5c/0x64)
[   73.020388] [<c027a430>] (rtc_resume+0x5c/0x64) from [<c0217a4c>] (dpm_run_callback.isra.4+0x2c/0x74)
[   73.029597] [<c0217a4c>] (dpm_run_callback.isra.4+0x2c/0x74) from [<c0217f80>] (device_resume+0x9c/0x144)
[   73.039134] [<c0217f80>] (device_resume+0x9c/0x144) from [<c0218aec>] (dpm_resume+0x100/0x224)
[   73.047734] [<c0218aec>] (dpm_resume+0x100/0x224) from [<c0056f4c>] (hibernation_snapshot+0x170/0x398)
[   73.057019] [<c0056f4c>] (hibernation_snapshot+0x170/0x398) from [<c00575b4>] (hibernate+0x13c/0x1d8)
[   73.066212] [<c00575b4>] (hibernate+0x13c/0x1d8) from [<c00556f4>] (state_store+0xb4/0xb8)
[   73.074474] [<c00556f4>] (state_store+0xb4/0xb8) from [<c0197d50>] (kobj_attr_store+0x14/0x20)
[   73.083033] [<c0197d50>] (kobj_attr_store+0x14/0x20) from [<c0118c04>] (sysfs_write_file+0x160/0x190)
[   73.092271] [<c0118c04>] (sysfs_write_file+0x160/0x190) from [<c00c2b08>] (vfs_write+0xb4/0x194)
[   73.101027] [<c00c2b08>] (vfs_write+0xb4/0x194) from [<c00c3088>] (SyS_write+0x3c/0x78)
[   73.109016] [<c00c3088>] (SyS_write+0x3c/0x78) from [<c000e080>] (ret_fast_syscall+0x0/0x30)

this patch uses SIMPLE_DEV_PM_OPS() to make restore() execute the existing
resume() function which will restore the set of RTC.

Signed-off-by: Xianglong Du <Xianglong.Du@csr.com>
Signed-off-by: Barry Song <Baohua.Song@csr.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-sirfsoc.c |   62 +++++-------------------------------
 1 file changed, 9 insertions(+), 53 deletions(-)

diff -puN drivers/rtc/rtc-sirfsoc.c~drivers-rtc-rtc-sirfsocc-fix-kernel-panic-of-backing-from-hibernation drivers/rtc/rtc-sirfsoc.c
--- a/drivers/rtc/rtc-sirfsoc.c~drivers-rtc-rtc-sirfsocc-fix-kernel-panic-of-backing-from-hibernation
+++ a/drivers/rtc/rtc-sirfsoc.c
@@ -331,39 +331,29 @@ static int sirfsoc_rtc_remove(struct pla
 	return 0;
 }
 
-#ifdef CONFIG_PM
-
+#ifdef CONFIG_PM_SLEEP
 static int sirfsoc_rtc_suspend(struct device *dev)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct sirfsoc_rtc_drv *rtcdrv = platform_get_drvdata(pdev);
+	struct sirfsoc_rtc_drv *rtcdrv = dev_get_drvdata(dev);
 	rtcdrv->overflow_rtc =
 		sirfsoc_rtc_iobrg_readl(rtcdrv->rtc_base + RTC_SW_VALUE);
 
 	rtcdrv->saved_counter =
 		sirfsoc_rtc_iobrg_readl(rtcdrv->rtc_base + RTC_CN);
 	rtcdrv->saved_overflow_rtc = rtcdrv->overflow_rtc;
-	if (device_may_wakeup(&pdev->dev) && !enable_irq_wake(rtcdrv->irq))
+	if (device_may_wakeup(dev) && !enable_irq_wake(rtcdrv->irq))
 		rtcdrv->irq_wake = 1;
 
 	return 0;
 }
 
-static int sirfsoc_rtc_freeze(struct device *dev)
-{
-	sirfsoc_rtc_suspend(dev);
-
-	return 0;
-}
-
-static int sirfsoc_rtc_thaw(struct device *dev)
+static int sirfsoc_rtc_resume(struct device *dev)
 {
 	u32 tmp;
-	struct sirfsoc_rtc_drv *rtcdrv;
-	rtcdrv = dev_get_drvdata(dev);
+	struct sirfsoc_rtc_drv *rtcdrv = dev_get_drvdata(dev);
 
 	/*
-	 * if resume from snapshot and the rtc power is losed,
+	 * if resume from snapshot and the rtc power is lost,
 	 * restroe the rtc settings
 	 */
 	if (SIRFSOC_RTC_CLK != sirfsoc_rtc_iobrg_readl(
@@ -403,57 +393,23 @@ static int sirfsoc_rtc_thaw(struct devic
 	sirfsoc_rtc_iobrg_writel(rtcdrv->overflow_rtc,
 			rtcdrv->rtc_base + RTC_SW_VALUE);
 
-	return 0;
-}
-
-static int sirfsoc_rtc_resume(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct sirfsoc_rtc_drv *rtcdrv = platform_get_drvdata(pdev);
-	sirfsoc_rtc_thaw(dev);
-	if (device_may_wakeup(&pdev->dev) && rtcdrv->irq_wake) {
+	if (device_may_wakeup(dev) && rtcdrv->irq_wake) {
 		disable_irq_wake(rtcdrv->irq);
 		rtcdrv->irq_wake = 0;
 	}
 
 	return 0;
 }
-
-static int sirfsoc_rtc_restore(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct sirfsoc_rtc_drv *rtcdrv = platform_get_drvdata(pdev);
-
-	if (device_may_wakeup(&pdev->dev) && rtcdrv->irq_wake) {
-		disable_irq_wake(rtcdrv->irq);
-		rtcdrv->irq_wake = 0;
-	}
-	return 0;
-}
-
-#else
-#define sirfsoc_rtc_suspend	NULL
-#define sirfsoc_rtc_resume	NULL
-#define sirfsoc_rtc_freeze	NULL
-#define sirfsoc_rtc_thaw	NULL
-#define sirfsoc_rtc_restore	NULL
 #endif
 
-static const struct dev_pm_ops sirfsoc_rtc_pm_ops = {
-	.suspend = sirfsoc_rtc_suspend,
-	.resume = sirfsoc_rtc_resume,
-	.freeze = sirfsoc_rtc_freeze,
-	.thaw = sirfsoc_rtc_thaw,
-	.restore = sirfsoc_rtc_restore,
-};
+static SIMPLE_DEV_PM_OPS(sirfsoc_rtc_pm_ops,
+		sirfsoc_rtc_suspend, sirfsoc_rtc_resume);
 
 static struct platform_driver sirfsoc_rtc_driver = {
 	.driver = {
 		.name = "sirfsoc-rtc",
 		.owner = THIS_MODULE,
-#ifdef CONFIG_PM
 		.pm = &sirfsoc_rtc_pm_ops,
-#endif
 		.of_match_table = sirfsoc_rtc_of_match,
 	},
 	.probe = sirfsoc_rtc_probe,
_

Patches currently in -mm which might be from Xianglong.Du@csr.com are

drivers-rtc-rtc-sirfsocc-fix-kernel-panic-of-backing-from-hibernation.patch
linux-next.patch

