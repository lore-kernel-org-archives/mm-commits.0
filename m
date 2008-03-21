From: akpm@linux-foundation.org
Subject: - rtc-at91sam9-fixes.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:30:12 -0700
Message-ID: <200803212030.m2LKUCeU008965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755724AbYCUUag (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:30:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, justin.waters@timesys.com, mm-commits@vger.kernel.org


The patch titled
     rtc-at91sam9 fixes
has been removed from the -mm tree.  Its filename was
     rtc-at91sam9-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-at91sam9 fixes
From: David Brownell <david-b@pacbell.net>

Updates to the at91sam9 rtt-as-rtc driver:

 - Bugfix:  IRQ enable bits need shifting before masking with status
 - Platform code to initialize wakeup bits didn't get merged; cope

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Justin Waters <justin.waters@timesys.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91sam9.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-at91sam9.c~rtc-at91sam9-fixes drivers/rtc/rtc-at91sam9.c
--- a/drivers/rtc/rtc-at91sam9.c~rtc-at91sam9-fixes
+++ a/drivers/rtc/rtc-at91sam9.c
@@ -274,7 +274,7 @@ static irqreturn_t at91_rtc_interrupt(in
 	 * SR clears it, so we must only read it in this irq handler!
 	 */
 	mr = rtt_readl(rtc, MR) & (AT91_RTT_ALMIEN | AT91_RTT_RTTINCIEN);
-	sr = rtt_readl(rtc, SR) & mr;
+	sr = rtt_readl(rtc, SR) & (mr >> 16);
 	if (!sr)
 		return IRQ_NONE;
 
@@ -321,6 +321,10 @@ static int __init at91_rtc_probe(struct 
 	if (!rtc)
 		return -ENOMEM;
 
+	/* platform setup code should have handled this; sigh */
+	if (!device_can_wakeup(&pdev->dev))
+		device_init_wakeup(&pdev->dev, 1);
+
 	platform_set_drvdata(pdev, rtc);
 	rtc->rtt = (void __force __iomem *) (AT91_VA_BASE_SYS - AT91_BASE_SYS);
 	rtc->rtt += r->start;
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
git-acpi.patch
git-avr32.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc-update.patch
usb-net-asix-does-not-really-need-10-100mbit.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
usb-gadget-dummy_hcdc-fix-nested-switch-statements.patch
spi-pxa2xx_spi-sparse-fixes.patch
rtc-avoid-legacy-drivers-with-generic-framework.patch
rtc-avoid-legacy-drivers-with-generic-framework-update.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
rtc-silence-section-mismatch-warning-in-rtc-test.patch
make-ds1511_rtc_readset_time-static.patch
kerneldoc-for-linux-clkh.patch
kerneldoc-for-linux-clkh-fix.patch
rtc-replace-remaining-__function__-occurrences.patch
remove-duplicated-unlikely-in-is_err.patch

