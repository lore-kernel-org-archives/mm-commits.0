From: akpm@linux-foundation.org
Subject: + spi-dynamic-busid-generation-bugfix.patch added to -mm tree
Date: Fri, 01 Jun 2007 16:34:05 -0700
Message-ID: <200706012334.l51NY5Ld021967@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752816AbXFAXep (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 19:34:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     SPI dynamic busid generation bugfix
has been added to the -mm tree.  Its filename is
     spi-dynamic-busid-generation-bugfix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 1 deletion(-)

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

origin.patch
spi-dynamic-busid-generation-bugfix.patch
git-avr32.patch
git-leds.patch
git-mmc.patch
git-backlight.patch
char-genrtc-use-wait_event_interruptible.patch
spi-controller-drivers-check-for-unsupported-modes.patch
spi-add-3wire-mode-flag.patch
spi-add-3wire-mode-flag-fix.patch
spidev-compiler-warning-gone.patch
rtc-ds1307-cleanups.patch
rtc-rs5c372-becomes-a-new-style-i2c-driver.patch
