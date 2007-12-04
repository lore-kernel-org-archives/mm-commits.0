From: akpm@linux-foundation.org
Subject: + pcmcia-stop-updating-dev-powerpower_state.patch added to -mm tree
Date: Tue, 04 Dec 2007 13:10:22 -0800
Message-ID: <200712042110.lB4LAM2t005339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33070 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755550AbXLDVKg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 16:10:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, linux@dominikbrodowski.net


The patch titled
     pcmcia: stop updating dev->power.power_state
has been added to the -mm tree.  Its filename is
     pcmcia-stop-updating-dev-powerpower_state.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1128,8 +1128,6 @@ static int runtime_suspend(struct device
 	down(&dev->sem);
 	rc = pcmcia_dev_suspend(dev, PMSG_SUSPEND);
 	up(&dev->sem);
-	if (!rc)
-		dev->power.power_state.event = PM_EVENT_SUSPEND;
 	return rc;
 }
 
@@ -1140,8 +1138,6 @@ static void runtime_resume(struct device
 	down(&dev->sem);
 	rc = pcmcia_dev_resume(dev);
 	up(&dev->sem);
-	if (!rc)
-		dev->power.power_state.event = PM_EVENT_ON;
 }
 
 /************************ per-device sysfs output ***************************/
@@ -1263,6 +1259,9 @@ static int pcmcia_dev_suspend(struct dev
 	struct pcmcia_driver *p_drv = NULL;
 	int ret = 0;
 
+	if (p_dev->suspended)
+		return 0;
+
 	ds_dbg(2, "suspending %s\n", dev->bus_id);
 
 	if (dev->driver)
@@ -1299,6 +1298,9 @@ static int pcmcia_dev_resume(struct devi
         struct pcmcia_driver *p_drv = NULL;
 	int ret = 0;
 
+	if (!p_dev->suspended)
+		return 0;
+
 	ds_dbg(2, "resuming %s\n", dev->bus_id);
 
 	if (dev->driver)
_

Patches currently in -mm which might be from david-b@pacbell.net are

rtc-assure-proper-memory-ordering-with-respect-to-rtc_dev_busy-flag.patch
spi-use-mutex-not-semaphore.patch
spi-at25-driver-is-for-eeprom-not-flash.patch
blackfin-spi-driver-use-cpu_relax-to-replace-continue-in-while-busywait.patch
blackfin-spi-driver-use-void-__iomem-for-regs_base.patch
blackfin-spi-driver-move-hard-coded-pin_req-to-board-file.patch
blackfin-spi-driver-reconfigure-speed_hz-and-bits_per_word-in-each-spi-transfer.patch
gpio_cs5535-disable-aux-on-output.patch
rtc-dont-write-rtc-century-when-setting-a-wake-alarm.patch
ads7846-stop-updating-dev-powerpower_state.patch
git-mmc.patch
git-mtd.patch
pcmcia-stop-updating-dev-powerpower_state.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
remove-pointless-casts-from-void-pointers.patch
spi-core-stop-updating-dev-powerpower_state.patch
cosmetic-fixes-to-rtc-subsystems-kconfig.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
rtc-cmos-exports-nvram-in-sysfs.patch
rtc-cmos-alarm-acts-as-oneshot.patch
generic-gpio-gpio_chip-support.patch
generic-gpio-gpio_chip-support-fix.patch
generic-gpio-gpio_chip-support-gpiolib-locking-simplified.patch
avr32-uses-gpio_chip.patch
mcp23s08-spi-gpio-expander.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
arm-pxa-gpiolib-support-make-pxa_gpio_chip-static.patch
pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch
