From: akpm@linux-foundation.org
Subject: + rtc-remove-more-dev-powerpower_state-usage.patch added to -mm tree
Date: Mon, 04 Feb 2008 14:47:08 -0800
Message-ID: <200802042247.m14Ml8I6021757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55216 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755691AbYBDWrl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 17:47:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, rmk@arm.linux.org.uk


The patch titled
     rtc: remove more dev->power.power_state usage
has been added to the -mm tree.  Its filename is
     rtc-remove-more-dev-powerpower_state-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
pcmcia-stop-updating-dev-powerpower_state.patch
git-arm.patch
at91-correct-at91sam9263ek-lcd-power-gpio-pin.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch
git-input.patch
git-mmc.patch
git-mtd.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
remove-pointless-casts-from-void-pointers.patch
spi-core-stop-updating-dev-powerpower_state.patch
spi-s3c-drivers-shouldnt-care-about-spi_board_info.patch
spi-remove-more-dev-powerpower_state-usage.patch
cosmetic-fixes-to-rtc-subsystems-kconfig.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
rtc-cmos-exports-nvram-in-sysfs.patch
rtc-cmos-alarm-acts-as-oneshot.patch
platform-real-time-clock-driver-for-dallas-1511-chip.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos-fix.patch
rtc-add-support-for-epson-rtc-9701je-v2.patch
rtc-add-support-for-epson-rtc-9701je-v4.patch
rtc-update-documentation-wrt-irq_set_freq.patch
rtc-cleanup-example-code.patch
rtc-remove-more-dev-powerpower_state-usage.patch
w1-gpio-add-gpio-w1-bus-master-driver.patch
w1-gpio-add-gpio-w1-bus-master-driver-v3.patch
basic-pwm-driver-for-avr32-and-at91.patch
basic-pwm-driver-for-avr32-and-at91-fix.patch
pwm-led-driver.patch
