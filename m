From: akpm@linux-foundation.org
Subject: - rtc-remove-more-dev-powerpower_state-usage.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:27:49 -0800
Message-ID: <200802070027.m170RUUY007050@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56939 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935148AbYBGAqA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:46:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     rtc: remove more dev->power.power_state usage
has been removed from the -mm tree.  Its filename was
     rtc-remove-more-dev-powerpower_state-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: remove more dev->power.power_state usage
From: David Brownell <david-b@pacbell.net>

Remove some more references to dev->power.power_state.  That field is overdue
for removal, but we can't do that while it's still referenced in the kernel. 
The only reason to update it was to make the /sys/devices/.../power/state
files (now removed) work better.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-sa1100.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-sa1100.c~rtc-remove-more-dev-powerpower_state-usage drivers/rtc/rtc-sa1100.c
--- a/drivers/rtc/rtc-sa1100.c~rtc-remove-more-dev-powerpower_state-usage
+++ a/drivers/rtc/rtc-sa1100.c
@@ -357,23 +357,15 @@ static int sa1100_rtc_remove(struct plat
 #ifdef CONFIG_PM
 static int sa1100_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	if (pdev->dev.power.power_state.event != state.event) {
-		if (state.event == PM_EVENT_SUSPEND &&
-		    device_may_wakeup(&pdev->dev))
-			enable_irq_wake(IRQ_RTCAlrm);
-
-		pdev->dev.power.power_state = state;
-	}
+	if (device_may_wakeup(&pdev->dev))
+		enable_irq_wake(IRQ_RTCAlrm);
 	return 0;
 }
 
 static int sa1100_rtc_resume(struct platform_device *pdev)
 {
-	if (pdev->dev.power.power_state.event != PM_EVENT_ON) {
-		if (device_may_wakeup(&pdev->dev))
-			disable_irq_wake(IRQ_RTCAlrm);
-		pdev->dev.power.power_state = PMSG_ON;
-	}
+	if (device_may_wakeup(&pdev->dev))
+		disable_irq_wake(IRQ_RTCAlrm);
 	return 0;
 }
 #else
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
at91-correct-at91sam9263ek-lcd-power-gpio-pin.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch
git-input.patch
git-mmc.patch
git-mtd.patch
basic-pwm-driver-for-avr32-and-at91.patch
basic-pwm-driver-for-avr32-and-at91-fix.patch
pwm-led-driver.patch
