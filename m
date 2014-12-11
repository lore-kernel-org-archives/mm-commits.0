From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-snvs-fix-suspend-resume.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 11:07:50 -0800
Message-ID: <5489eb86.2boosCkxsVA+gfNA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46029 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919AbaLKTHv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:07:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maitysanchayan@gmail.com, a.zummo@towertech.it, shawn.guo@linaro.org, stefan@agner.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-snvs: fix suspend/resume
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-snvs-fix-suspend-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sanchayan Maity <maitysanchayan@gmail.com>
Subject: drivers/rtc/rtc-snvs: fix suspend/resume

The alarm interrupt handler also reads registers which are part of SNVS
and need clocks enabled.  However, the resume function is called after
IRQ's have been enabled, hence this leads to a abort:

[   90.755222] Unhandled fault: external abort on non-linefetch (0x1008)
at 0x908c604c
[   90.762892] Internal error: : 1008 [#1] ARM
[   90.767082] Modules linked in:
[   90.770174] CPU: 0 PID: 421 Comm: sh Not tainted 3.18.0-rc5-00135-g0689c67-dirty #1592
[   90.778100] task: 8e03e800 ti: 8cad8000 task.ti: 8cad8000
[   90.783530] PC is at snvs_rtc_irq_handler+0x14/0x74
[   90.788424] LR is at handle_irq_event_percpu+0x3c/0x144

Fix this by using the .{suspend/resume}_noirq callbacks instead of
.{suspend/resume} .

Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Stefan Agner <stefan@agner.ch>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-snvs.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-snvs.c~drivers-rtc-rtc-snvs-fix-suspend-resume drivers/rtc/rtc-snvs.c
--- a/drivers/rtc/rtc-snvs.c~drivers-rtc-rtc-snvs-fix-suspend-resume
+++ a/drivers/rtc/rtc-snvs.c
@@ -346,7 +346,10 @@ static int snvs_rtc_resume(struct device
 }
 #endif
 
-static SIMPLE_DEV_PM_OPS(snvs_rtc_pm_ops, snvs_rtc_suspend, snvs_rtc_resume);
+static const struct dev_pm_ops snvs_rtc_pm_ops = {
+	.suspend_noirq = snvs_rtc_suspend,
+	.resume_noirq = snvs_rtc_resume,
+};
 
 static const struct of_device_id snvs_dt_ids[] = {
 	{ .compatible = "fsl,sec-v4.0-mon-rtc-lp", },
_

Patches currently in -mm which might be from maitysanchayan@gmail.com are

origin.patch
linux-next.patch

