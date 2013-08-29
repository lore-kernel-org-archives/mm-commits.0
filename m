From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-sirfsocc-fix-kernel-warning-during-wakeup.patch added to -mm tree
Date: Thu, 29 Aug 2013 14:49:11 -0700
Message-ID: <521fc1d7.Vu/abGr8fRPA/l9i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37463 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157Ab3H2VtM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Aug 2013 17:49:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, Baohua.Song@csr.com, Xianglong.Du@csr.com

Subject: + drivers-rtc-rtc-sirfsocc-fix-kernel-warning-during-wakeup.patch added to -mm tree
To: Xianglong.Du@csr.com,Baohua.Song@csr.com
From: akpm@linux-foundation.org
Date: Thu, 29 Aug 2013 14:49:11 -0700


The patch titled
     Subject: drivers/rtc/rtc-sirfsoc.c: fix kernel warning during wakeup
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-sirfsocc-fix-kernel-warning-during-wakeup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-sirfsocc-fix-kernel-warning-during-wakeup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-sirfsocc-fix-kernel-warning-during-wakeup.patch

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
Subject: drivers/rtc/rtc-sirfsoc.c: fix kernel warning during wakeup

enable_irq_wake() might fail, if so, we will see kernel warning in resume
entries due to it always calls disable_irq_wake().

[  200.659501] ------------[ cut here ]------------
[  200.661292] WARNING: at /home/ASIA/xd01/temp/atlas6-3.x/kernel/kernel/irq/manage.c:529 irq_set_irq_wake+0xc4/0xf0()
[  200.671686] Unbalanced IRQ 52 wake disable
[  200.675764] Modules linked in: ipv6 libcomposite configfs
[  200.681153] CPU: 0 PID: 1591 Comm: ash Tainted: G        W    3.10.0-00854-gdbd86d4-dirty #100
[  200.689761] [<c0014e28>] (unwind_backtrace+0x0/0xf8) from [<c0011ef4>] (show_stack+0x10/0x14)
[  200.698263] [<c0011ef4>] (show_stack+0x10/0x14) from [<c001fee4>] (warn_slowpath_common+0x54/0x68)
[  200.707198] [<c001fee4>] (warn_slowpath_common+0x54/0x68) from [<c001ff8c>] (warn_slowpath_fmt+0x30/0x40)
[  200.716749] [<c001ff8c>] (warn_slowpath_fmt+0x30/0x40) from [<c0074588>] (irq_set_irq_wake+0xc4/0xf0)
[  200.725951] [<c0074588>] (irq_set_irq_wake+0xc4/0xf0) from [<c027b31c>] (sirfsoc_rtc_restore+0x30/0x38)
[  200.735325] [<c027b31c>] (sirfsoc_rtc_restore+0x30/0x38) from [<c0211c0c>] (platform_pm_restore+0x2c/0x50)
[  200.744959] [<c0211c0c>] (platform_pm_restore+0x2c/0x50) from [<c02163e4>] (dpm_run_callback.clone.6+0x30/0xb0)
[  200.755024] [<c02163e4>] (dpm_run_callback.clone.6+0x30/0xb0) from [<c02169d0>] (device_resume+0x88/0x134)
[  200.764657] [<c02169d0>] (device_resume+0x88/0x134) from [<c0217698>] (dpm_resume+0x114/0x230)
[  200.773253] [<c0217698>] (dpm_resume+0x114/0x230) from [<c0057118>] (hibernation_snapshot+0x178/0x1d0)
[  200.782540] [<c0057118>] (hibernation_snapshot+0x178/0x1d0) from [<c0057820>] (hibernate+0x130/0x1dc)
[  200.791739] [<c0057820>] (hibernate+0x130/0x1dc) from [<c00556cc>] (state_store+0xb4/0xc0)
[  200.799990] [<c00556cc>] (state_store+0xb4/0xc0) from [<c019af68>] (kobj_attr_store+0x14/0x20)
[  200.808585] [<c019af68>] (kobj_attr_store+0x14/0x20) from [<c011b268>] (sysfs_write_file+0xfc/0x17c)
[  200.817696] [<c011b268>] (sysfs_write_file+0xfc/0x17c) from [<c00c4da8>] (vfs_write+0xc8/0x194)
[  200.826372] [<c00c4da8>] (vfs_write+0xc8/0x194) from [<c00c515c>] (SyS_write+0x40/0x6c)
[  200.834362] [<c00c515c>] (SyS_write+0x40/0x6c) from [<c000e280>] (ret_fast_syscall+0x0/0x30)
[  200.842771] ---[ end trace 10f52d38a3bc59c7 ]---

To avoid unbalanced "IRQ wake disable", ensure that disable_irq_wake() is
called only when enable_irq_wake() have been successfully enabled.

Signed-off-by: Xianglong Du <Xianglong.Du@csr.com>
Signed-off-by: Barry Song <Baohua.Song@csr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-sirfsoc.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-sirfsoc.c~drivers-rtc-rtc-sirfsocc-fix-kernel-warning-during-wakeup drivers/rtc/rtc-sirfsoc.c
--- a/drivers/rtc/rtc-sirfsoc.c~drivers-rtc-rtc-sirfsocc-fix-kernel-warning-during-wakeup
+++ a/drivers/rtc/rtc-sirfsoc.c
@@ -44,6 +44,7 @@ struct sirfsoc_rtc_drv {
 	struct rtc_device	*rtc;
 	u32			rtc_base;
 	u32			irq;
+	unsigned		irq_wake;
 	/* Overflow for every 8 years extra time */
 	u32			overflow_rtc;
 #ifdef CONFIG_PM
@@ -355,8 +356,8 @@ static int sirfsoc_rtc_suspend(struct de
 	rtcdrv->saved_counter =
 		sirfsoc_rtc_iobrg_readl(rtcdrv->rtc_base + RTC_CN);
 	rtcdrv->saved_overflow_rtc = rtcdrv->overflow_rtc;
-	if (device_may_wakeup(&pdev->dev))
-		enable_irq_wake(rtcdrv->irq);
+	if (device_may_wakeup(&pdev->dev) && !enable_irq_wake(rtcdrv->irq))
+		rtcdrv->irq_wake = 1;
 
 	return 0;
 }
@@ -423,8 +424,10 @@ static int sirfsoc_rtc_resume(struct dev
 	struct platform_device *pdev = to_platform_device(dev);
 	struct sirfsoc_rtc_drv *rtcdrv = platform_get_drvdata(pdev);
 	sirfsoc_rtc_thaw(dev);
-	if (device_may_wakeup(&pdev->dev))
+	if (device_may_wakeup(&pdev->dev) && rtcdrv->irq_wake) {
 		disable_irq_wake(rtcdrv->irq);
+		rtcdrv->irq_wake = 0;
+	}
 
 	return 0;
 }
@@ -434,8 +437,10 @@ static int sirfsoc_rtc_restore(struct de
 	struct platform_device *pdev = to_platform_device(dev);
 	struct sirfsoc_rtc_drv *rtcdrv = platform_get_drvdata(pdev);
 
-	if (device_may_wakeup(&pdev->dev))
+	if (device_may_wakeup(&pdev->dev) && rtcdrv->irq_wake) {
 		disable_irq_wake(rtcdrv->irq);
+		rtcdrv->irq_wake = 0;
+	}
 	return 0;
 }
 
_

Patches currently in -mm which might be from Xianglong.Du@csr.com are

drivers-rtc-rtc-sirfsocc-fix-kernel-warning-during-wakeup.patch
linux-next.patch

