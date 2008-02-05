From: akpm@linux-foundation.org
Subject: - pcmcia-stop-updating-dev-powerpower_state.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:27:05 -0800
Message-ID: <200802052226.m15MQkF7011649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50593 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761571AbYBEW1R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:27:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, linux@dominikbrodowski.net, mm-commits@vger.kernel.org


The patch titled
     pcmcia: stop updating dev->power.power_state
has been removed from the -mm tree.  Its filename was
     pcmcia-stop-updating-dev-powerpower_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pcmcia: stop updating dev->power.power_state
From: David Brownell <david-b@pacbell.net>

This stops the pcmcia core from using dev->power.power_state; that field is
deprecated (overdue for removal) and the only reason to update it was to make
the /sys/devices/.../power/state files (now removed) work better.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/ds.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/pcmcia/ds.c~pcmcia-stop-updating-dev-powerpower_state drivers/pcmcia/ds.c
--- a/drivers/pcmcia/ds.c~pcmcia-stop-updating-dev-powerpower_state
+++ a/drivers/pcmcia/ds.c
@@ -1130,8 +1130,6 @@ static int runtime_suspend(struct device
 	down(&dev->sem);
 	rc = pcmcia_dev_suspend(dev, PMSG_SUSPEND);
 	up(&dev->sem);
-	if (!rc)
-		dev->power.power_state.event = PM_EVENT_SUSPEND;
 	return rc;
 }
 
@@ -1142,8 +1140,6 @@ static void runtime_resume(struct device
 	down(&dev->sem);
 	rc = pcmcia_dev_resume(dev);
 	up(&dev->sem);
-	if (!rc)
-		dev->power.power_state.event = PM_EVENT_ON;
 }
 
 /************************ per-device sysfs output ***************************/
@@ -1265,6 +1261,9 @@ static int pcmcia_dev_suspend(struct dev
 	struct pcmcia_driver *p_drv = NULL;
 	int ret = 0;
 
+	if (p_dev->suspended)
+		return 0;
+
 	ds_dbg(2, "suspending %s\n", dev->bus_id);
 
 	if (dev->driver)
@@ -1301,6 +1300,9 @@ static int pcmcia_dev_resume(struct devi
         struct pcmcia_driver *p_drv = NULL;
 	int ret = 0;
 
+	if (!p_dev->suspended)
+		return 0;
+
 	ds_dbg(2, "resuming %s\n", dev->bus_id);
 
 	if (dev->driver)
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
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
rtc-at91sam9-rtc-support-rtt-and-or-rtc.patch
rtc-at91sam9-rtc-support-rtt-and-or-rtc-fix.patch
w1-gpio-add-gpio-w1-bus-master-driver.patch
w1-gpio-add-gpio-w1-bus-master-driver-v3.patch
basic-pwm-driver-for-avr32-and-at91.patch
basic-pwm-driver-for-avr32-and-at91-fix.patch
pwm-led-driver.patch
