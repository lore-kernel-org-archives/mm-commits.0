From: akpm@linux-foundation.org
Subject: - spi-dynamic-busid-generation-bugfix.patch removed from -mm tree
Date: Tue, 05 Jun 2007 00:10:15 -0700
Message-ID: <200706050710.l557AErg031249@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55312 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761534AbXFEHKa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 03:10:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     SPI dynamic busid generation bugfix
has been removed from the -mm tree.  Its filename was
     spi-dynamic-busid-generation-bugfix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SPI dynamic busid generation bugfix
From: David Brownell <david-b@pacbell.net>

Fix SPI dynamic bus ID assignment to start at 2^15-1 rather than a negative
number.  Valid bus ids are supposed to be positive, and are (now) stored in
an 's16' value.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/spi.c~spi-dynamic-busid-generation-bugfix drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-dynamic-busid-generation-bugfix
+++ a/drivers/spi/spi.c
@@ -411,7 +411,7 @@ EXPORT_SYMBOL_GPL(spi_alloc_master);
  */
 int spi_register_master(struct spi_master *master)
 {
-	static atomic_t		dyn_bus_id = ATOMIC_INIT((1<<16) - 1);
+	static atomic_t		dyn_bus_id = ATOMIC_INIT((1<<15) - 1);
 	struct device		*dev = master->cdev.dev;
 	int			status = -ENODEV;
 	int			dynamic = 0;
_

Patches currently in -mm which might be from david-b@pacbell.net are

git-avr32.patch
thecus-n2100-register-rtc-rs5c372-i2c-device.patch
git-leds.patch
git-mmc.patch
git-backlight.patch
char-genrtc-use-wait_event_interruptible.patch
spi-controller-drivers-check-for-unsupported-modes.patch
spi-controller-drivers-check-for-unsupported-modes-update.patch
spi-add-3wire-mode-flag.patch
spi-add-3wire-mode-flag-fix.patch
spidev-compiler-warning-gone.patch
rtc-ds1307-cleanups.patch
rtc-rs5c372-becomes-a-new-style-i2c-driver.patch
