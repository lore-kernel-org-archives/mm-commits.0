From: akpm@linux-foundation.org
Subject: [merged]
 rtc-s5m-re-add-support-for-devices-without-irq-specified.patch removed from -mm tree
Date: Wed, 03 Sep 2014 10:57:41 -0700
Message-ID: <54075695.V31BSYcc0bjSeoNs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbaICR5m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2014 13:57:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: b.zolnierkie@samsung.com, k.kozlowski@samsung.com, kyungmin.park@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-s5m.c: re-add support for devices without irq specified
has been removed from the -mm tree.  Its filename was
     rtc-s5m-re-add-support-for-devices-without-irq-specified.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: drivers/rtc/rtc-s5m.c: re-add support for devices without irq specified

The rtc-s5m driver used to support devices without irq specified in the
past.  Re-add this support.

The patch fixes boot for Insignal's Exynos4412 based Origen board.

Error messages before the patch:
...
[    2.095991] Unable to handle kernel NULL pointer dereference at virtual address 00000094
[    2.103299] pgd = c0004000
[    2.105944] [00000094] *pgd=00000000
[    2.109510] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
[    2.114796] Modules linked in:
[    2.117840] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.16.0-next-20140804-00008-ga59480f-dirty #701
[    2.126950] task: ea80f000 ti: ea882000 task.ti: ea882000
[    2.132348] PC is at regmap_irq_get_virq+0x0/0x28
[    2.137033] LR is at s5m_rtc_probe+0xdc/0x310
[    2.141360] pc : [<c02574fc>]    lr : [<c02de75c>]    psr: 80000153
[    2.141360] sp : ea883e48  ip : 00000000  fp : 00000000
[    2.152815] r10: 0000000c  r9 : c05de7ac  r8 : eaabc600
[    2.158024] r7 : eaa6b4d0  r6 : c0439e8c  r5 : eaabc610  r4 : eab30e50
[    2.164533] r3 : 00000000  r2 : 00000000  r1 : 0000000c  r0 : 00000000
[    2.171045] Flags: Nzcv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
[    2.178423] Control: 10c5387d  Table: 4000404a  DAC: 00000015
[    2.184150] Process swapper/0 (pid: 1, stack limit = 0xea882240)
[    2.190139] Stack: (0xea883e48 to 0xea884000)
[    2.194483] 3e40:                   eab32910 00000001 c05de7ac eab329b0 00000000 eaabc610
[    2.202642] 3e60: c0618c68 eaabc610 c0618c68 00000000 00000000 c0618c68 0000008f c02429cc
[    2.210801] 3e80: c02429a0 eaabc610 c06628a8 c02415f0 eaabc610 c0618c68 eaabc644 00000000
[    2.218960] 3ea0: eab30d00 c024179c c0618c68 00000000 c0241710 c023ffb4 ea805478 eaadefc0
[    2.227119] 3ec0: c0618c68 ea115e80 c0610b10 c0240df8 c0518984 c0618c68 00000000 c0618c68
[    2.235278] 3ee0: 00000000 c05ecc18 c05ecc18 c0241db8 c02426a0 c05b480c 00000000 c00088a4
[    2.243437] 3f00: 0000009f c040f134 ea92a300 c0649fe0 ea80f000 60000153 c05efe54 00000000
[    2.251596] 3f20: 00000000 c05efe54 60000153 00000000 eb7ff916 eb7ff908 c0573048 c00376dc
[    2.259756] 3f40: c05288f0 c0572758 00000006 00000006 c05efdf4 c05c2da4 00000006 c05c2d84
[    2.267914] 3f60: c0626900 c059a508 c05de7ac 0000008f 00000000 c059ac94 00000006 00000006
[    2.276074] 3f80: c059a508 c003c3fc 00000000 c0401330 00000000 00000000 00000000 00000000
[    2.284233] 3fa0: 00000000 c0401338 00000000 c000e538 00000000 00000000 00000000 00000000
[    2.292392] 3fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    2.300551] 3fe0: 00000000 00000000 00000000 00000000 00000013 00000000 c0c0c0c0 c0c0c0c0
[    2.308729] [<c02574fc>] (regmap_irq_get_virq) from [<c02de75c>] (s5m_rtc_probe+0xdc/0x310)
[    2.317057] [<c02de75c>] (s5m_rtc_probe) from [<c02429cc>] (platform_drv_probe+0x2c/0x5c)
[    2.325209] [<c02429cc>] (platform_drv_probe) from [<c02415f0>] (driver_probe_device+0x114/0x234)
[    2.334060] [<c02415f0>] (driver_probe_device) from [<c024179c>] (__driver_attach+0x8c/0x90)
[    2.342479] [<c024179c>] (__driver_attach) from [<c023ffb4>] (bus_for_each_dev+0x54/0x88)
[    2.350637] [<c023ffb4>] (bus_for_each_dev) from [<c0240df8>] (bus_add_driver+0xd8/0x1cc)
[    2.358796] [<c0240df8>] (bus_add_driver) from [<c0241db8>] (driver_register+0x78/0xf4)
[    2.366785] [<c0241db8>] (driver_register) from [<c00088a4>] (do_one_initcall+0x80/0x1d0)
[    2.374947] [<c00088a4>] (do_one_initcall) from [<c059ac94>] (kernel_init_freeable+0x108/0x1d4)
[    2.383634] [<c059ac94>] (kernel_init_freeable) from [<c0401338>] (kernel_init+0x8/0xe4)
[    2.391704] [<c0401338>] (kernel_init) from [<c000e538>] (ret_from_fork+0x14/0x3c)
[    2.399246] Code: e8bd8070 e3500000 1590009c e12fff1e (e5903094)
[    2.405391] ---[ end trace a954d7f019122700 ]---
[    2.409987] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
...

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Tested-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s5m.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-s5m.c~rtc-s5m-re-add-support-for-devices-without-irq-specified drivers/rtc/rtc-s5m.c
--- a/drivers/rtc/rtc-s5m.c~rtc-s5m-re-add-support-for-devices-without-irq-specified
+++ a/drivers/rtc/rtc-s5m.c
@@ -717,12 +717,14 @@ static int s5m_rtc_probe(struct platform
 	info->device_type = s5m87xx->device_type;
 	info->wtsr_smpl = s5m87xx->wtsr_smpl;
 
-	info->irq = regmap_irq_get_virq(s5m87xx->irq_data, alarm_irq);
-	if (info->irq <= 0) {
-		ret = -EINVAL;
-		dev_err(&pdev->dev, "Failed to get virtual IRQ %d\n",
+	if (s5m87xx->irq_data) {
+		info->irq = regmap_irq_get_virq(s5m87xx->irq_data, alarm_irq);
+		if (info->irq <= 0) {
+			ret = -EINVAL;
+			dev_err(&pdev->dev, "Failed to get virtual IRQ %d\n",
 				alarm_irq);
-		goto err;
+			goto err;
+		}
 	}
 
 	platform_set_drvdata(pdev, info);
@@ -744,6 +746,11 @@ static int s5m_rtc_probe(struct platform
 		goto err;
 	}
 
+	if (!info->irq) {
+		dev_info(&pdev->dev, "Alarm IRQ not available\n");
+		return 0;
+	}
+
 	ret = devm_request_threaded_irq(&pdev->dev, info->irq, NULL,
 					s5m_rtc_alarm_irq, 0, "rtc-alarm0",
 					info);
@@ -802,7 +809,7 @@ static int s5m_rtc_resume(struct device
 	struct s5m_rtc_info *info = dev_get_drvdata(dev);
 	int ret = 0;
 
-	if (device_may_wakeup(dev))
+	if (info->irq && device_may_wakeup(dev))
 		ret = disable_irq_wake(info->irq);
 
 	return ret;
@@ -813,7 +820,7 @@ static int s5m_rtc_suspend(struct device
 	struct s5m_rtc_info *info = dev_get_drvdata(dev);
 	int ret = 0;
 
-	if (device_may_wakeup(dev))
+	if (info->irq && device_may_wakeup(dev))
 		ret = enable_irq_wake(info->irq);
 
 	return ret;
_

Patches currently in -mm which might be from b.zolnierkie@samsung.com are

linux-next.patch

