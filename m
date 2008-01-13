From: akpm@linux-foundation.org
Subject: - spi_bitbang-always-grab-lock-with-irqs-blocked.patch removed from -mm tree
Date: Sun, 13 Jan 2008 03:32:51 -0800
Message-ID: <200801131132.m0DBWVVI009777@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46737 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751341AbYAMLcl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jan 2008 06:32:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi_bitbang: always grab lock with irqs blocked
has been removed from the -mm tree.  Its filename was
     spi_bitbang-always-grab-lock-with-irqs-blocked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-input.patch
backlight-omap1-backlight-driver.patch
pcmcia-stop-updating-dev-powerpower_state.patch
at91_cf-use-generic-gpio-calls.patch
remove-obsolete-sys-devices-power-state-docs.patch
spi-core-stop-updating-dev-powerpower_state.patch
atmel_spi-throughput-improvement.patch
atmel_spi-chain-dma-transfers.patch
atmel_spi-chain-dma-transfers-update.patch
atmel_spi-fix-dmachain-oops-with-debug-enabled.patch
rtc-cmos-exports-nvram-in-sysfs.patch
rtc-cmos-alarm-acts-as-oneshot.patch
gpiolib-add-drivers-gpio-directory.patch
gpiolib-add-gpio-provider-infrastructure.patch
gpiolib-update-documentation-gpiotxt.patch
gpiolib-pxa-platform-support.patch
gpiolib-pcf857x-i2c-gpio-expander-support.patch
gpiolib-mcp23s08-spi-gpio-expander-support.patch
gpiolib-pca9539-i2c-gpio-expander-support.patch
gpiolib-deprecate-obsolete-pca9539-driver.patch
usb-net2280-cant-have-a-function-called-show_registers.patch
