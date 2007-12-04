From: akpm@linux-foundation.org
Subject: + ads7846-stop-updating-dev-powerpower_state.patch added to -mm tree
Date: Tue, 04 Dec 2007 13:09:43 -0800
Message-ID: <200712042109.lB4L9hM5005312@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47213 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755423AbXLDVK1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 16:10:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, dtor@mail.ru


The patch titled
     ads7846: stop updating dev->power.power_state
has been added to the -mm tree.  Its filename is
     ads7846-stop-updating-dev-powerpower_state.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ads7846: stop updating dev->power.power_state
From: David Brownell <david-b@pacbell.net>

This stops the ads7846 driver from using dev->power.power_state; that field is
deprecated (overdue for removal) and the only reason to update it was to make
the /sys/devices/.../power/state files (now removed) work better.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/ads7846.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/input/touchscreen/ads7846.c~ads7846-stop-updating-dev-powerpower_state drivers/input/touchscreen/ads7846.c
--- a/drivers/input/touchscreen/ads7846.c~ads7846-stop-updating-dev-powerpower_state
+++ a/drivers/input/touchscreen/ads7846.c
@@ -116,6 +116,7 @@ struct ads7846 {
 // FIXME remove "irq_disabled"
 	unsigned		irq_disabled:1;	/* P: lock */
 	unsigned		disabled:1;
+	unsigned		is_suspended:1;
 
 	int			(*filter)(void *data, int data_idx, int *val);
 	void			*filter_data;
@@ -203,7 +204,7 @@ static void ads7846_disable(struct ads78
 static int device_suspended(struct device *dev)
 {
 	struct ads7846 *ts = dev_get_drvdata(dev);
-	return dev->power.power_state.event != PM_EVENT_ON || ts->disabled;
+	return ts->is_suspended || ts->disabled;
 }
 
 static int ads7846_read12_ser(struct device *dev, unsigned command)
@@ -794,7 +795,7 @@ static int ads7846_suspend(struct spi_de
 
 	spin_lock_irq(&ts->lock);
 
-	spi->dev.power.power_state = message;
+	ts->is_suspended = 1;
 	ads7846_disable(ts);
 
 	spin_unlock_irq(&ts->lock);
@@ -809,7 +810,7 @@ static int ads7846_resume(struct spi_dev
 
 	spin_lock_irq(&ts->lock);
 
-	spi->dev.power.power_state = PMSG_ON;
+	ts->is_suspended = 0;
 	ads7846_enable(ts);
 
 	spin_unlock_irq(&ts->lock);
@@ -871,7 +872,6 @@ static int __devinit ads7846_probe(struc
 	}
 
 	dev_set_drvdata(&spi->dev, ts);
-	spi->dev.power.power_state = PMSG_ON;
 
 	ts->spi = spi;
 	ts->input = input_dev;
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
pcmcia-stops-updating-dev-powerpower_state.patch
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
