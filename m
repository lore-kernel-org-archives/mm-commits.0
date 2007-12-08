From: akpm@linux-foundation.org
Subject: - spi-use-mutex-not-semaphore.patch removed from -mm tree
Date: Fri, 07 Dec 2007 17:28:49 -0800
Message-ID: <200712080128.lB81Snut013356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49282 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753890AbXLHB3b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 20:29:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     SPI: use mutex not semaphore
has been removed from the -mm tree.  Its filename was
     spi-use-mutex-not-semaphore.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SPI: use mutex not semaphore
From: David Brownell <david-b@pacbell.net>

Make spi_write_then_read() use a mutex not a binary semaphore.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/spi/spi.c~spi-use-mutex-not-semaphore drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-use-mutex-not-semaphore
+++ a/drivers/spi/spi.c
@@ -589,7 +589,7 @@ int spi_write_then_read(struct spi_devic
 		const u8 *txbuf, unsigned n_tx,
 		u8 *rxbuf, unsigned n_rx)
 {
-	static DECLARE_MUTEX(lock);
+	static DEFINE_MUTEX(lock);
 
 	int			status;
 	struct spi_message	message;
@@ -615,7 +615,7 @@ int spi_write_then_read(struct spi_devic
 	}
 
 	/* ... unless someone else is using the pre-allocated buffer */
-	if (down_trylock(&lock)) {
+	if (!mutex_trylock(&lock)) {
 		local_buf = kmalloc(SPI_BUFSIZ, GFP_KERNEL);
 		if (!local_buf)
 			return -ENOMEM;
@@ -634,7 +634,7 @@ int spi_write_then_read(struct spi_devic
 	}
 
 	if (x[0].tx_buf == buf)
-		up(&lock);
+		mutex_unlock(&lock);
 	else
 		kfree(local_buf);
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
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
platform-real-time-clock-driver-for-dallas-1511-chip.patch
generic-gpio-gpio_chip-support.patch
generic-gpio-gpio_chip-support-fix.patch
generic-gpio-gpio_chip-support-gpiolib-locking-simplified.patch
avr32-uses-gpio_chip.patch
mcp23s08-spi-gpio-expander.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
arm-pxa-gpiolib-support-make-pxa_gpio_chip-static.patch
pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch
