From: akpm@linux-foundation.org
Subject: + spi_bitbang-always-grab-lock-with-irqs-blocked.patch added to -mm tree
Date: Fri, 04 Jan 2008 22:49:06 -0800
Message-ID: <200801050649.m056nqWe032427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39600 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752148AbYAEGuG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 5 Jan 2008 01:50:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net


The patch titled
     spi_bitbang: always grab lock with irqs blocked
has been added to the -mm tree.  Its filename is
     spi_bitbang-always-grab-lock-with-irqs-blocked.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi_bitbang: always grab lock with irqs blocked
From: David Brownell <dbrownell@users.sourceforge.net>

Fix a glitch reported by lockdep in the spi_bitbang code: it needs to
consistently block IRQs when holding that spinlock.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bitbang.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/spi/spi_bitbang.c~spi_bitbang-always-grab-lock-with-irqs-blocked drivers/spi/spi_bitbang.c
--- a/drivers/spi/spi_bitbang.c~spi_bitbang-always-grab-lock-with-irqs-blocked
+++ a/drivers/spi/spi_bitbang.c
@@ -184,6 +184,7 @@ int spi_bitbang_setup(struct spi_device 
 	struct spi_bitbang_cs	*cs = spi->controller_state;
 	struct spi_bitbang	*bitbang;
 	int			retval;
+	unsigned long		flags;
 
 	bitbang = spi_master_get_devdata(spi->master);
 
@@ -222,12 +223,12 @@ int spi_bitbang_setup(struct spi_device 
 	 */
 
 	/* deselect chip (low or high) */
-	spin_lock(&bitbang->lock);
+	spin_lock_irqsave(&bitbang->lock, flags);
 	if (!bitbang->busy) {
 		bitbang->chipselect(spi, BITBANG_CS_INACTIVE);
 		ndelay(cs->nsecs);
 	}
-	spin_unlock(&bitbang->lock);
+	spin_unlock_irqrestore(&bitbang->lock, flags);
 
 	return 0;
 }
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

pcmcia-remove-pxa2xx_lubbock-build-warning.patch
spi_bitbang-always-grab-lock-with-irqs-blocked.patch
git-arm.patch
git-input.patch
backlight-omap1-backlight-driver.patch
pcmcia-stop-updating-dev-powerpower_state.patch
at91_cf-use-generic-gpio-calls.patch
spi-core-stop-updating-dev-powerpower_state.patch
atmel_spi-throughput-improvement.patch
atmel_spi-chain-dma-transfers.patch
atmel_spi-chain-dma-transfers-update.patch
atmel_spi-fix-dmachain-oops-with-debug-enabled.patch
rtc-cmos-exports-nvram-in-sysfs.patch
rtc-cmos-alarm-acts-as-oneshot.patch
generic-gpio-gpio_chip-support.patch
generic-gpio-gpio_chip-support-fix.patch
generic-gpio-gpio_chip-support-gpiolib-locking-simplified.patch
avr32-uses-gpio_chip.patch
mcp23s08-spi-gpio-expander.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
arm-pxa-gpiolib-support.patch
arm-pxa-gpiolib-support-make-pxa_gpio_chip-static.patch
usb-net2280-cant-have-a-function-called-show_registers.patch
