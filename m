From: akpm@linux-foundation.org
Subject: + spi-controller-build-warning-fixes.patch added to -mm tree
Date: Fri, 16 Feb 2007 13:24:39 -0800
Message-ID: <200702162124.l1GLOd6s010243@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36698 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946249AbXBPVYo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 16:24:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     SPI controller build/warning fixes
has been added to the -mm tree.  Its filename is
     spi-controller-build-warning-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SPI controller build/warning fixes
From: David Brownell <david-b@pacbell.net>

The signature of the per-device cleanup() routine changed to remove its
const-ness.  Three new SPI controller drivers now need that change, to
eliminate build warnings.

This also fixes a build bug with atmel_spi on AT91 systems.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/atmel_spi.c  |    6 +++++-
 drivers/spi/omap_uwire.c |    2 +-
 drivers/spi/spi_imx.c    |    5 ++---
 3 files changed, 8 insertions(+), 5 deletions(-)

diff -puN drivers/spi/atmel_spi.c~spi-controller-build-warning-fixes drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~spi-controller-build-warning-fixes
+++ a/drivers/spi/atmel_spi.c
@@ -23,6 +23,10 @@
 #include <asm/arch/board.h>
 #include <asm/arch/gpio.h>
 
+#ifdef CONFIG_ARCH_AT91
+#include <asm/arch/cpu.h>
+#endif
+
 #include "atmel_spi.h"
 
 /*
@@ -491,7 +495,7 @@ static int atmel_spi_transfer(struct spi
 	return 0;
 }
 
-static void atmel_spi_cleanup(const struct spi_device *spi)
+static void atmel_spi_cleanup(struct spi_device *spi)
 {
 	if (spi->controller_state)
 		gpio_free((unsigned int)spi->controller_data);
diff -puN drivers/spi/omap_uwire.c~spi-controller-build-warning-fixes drivers/spi/omap_uwire.c
--- a/drivers/spi/omap_uwire.c~spi-controller-build-warning-fixes
+++ a/drivers/spi/omap_uwire.c
@@ -459,7 +459,7 @@ static int uwire_setup(struct spi_device
 	return uwire_setup_transfer(spi, NULL);
 }
 
-static void uwire_cleanup(const struct spi_device *spi)
+static void uwire_cleanup(struct spi_device *spi)
 {
 	kfree(spi->controller_state);
 }
diff -puN drivers/spi/spi_imx.c~spi-controller-build-warning-fixes drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi-controller-build-warning-fixes
+++ a/drivers/spi/spi_imx.c
@@ -1361,10 +1361,9 @@ err_first_setup:
 	return status;
 }
 
-static void cleanup(const struct spi_device *spi)
+static void cleanup(struct spi_device *spi)
 {
-	struct chip_data *chip = spi_get_ctldata((struct spi_device *)spi);
-	kfree(chip);
+	kfree(spi_get_ctldata(spi));
 }
 
 static int init_queue(struct driver_data *drv_data)
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
gpio-core-documentation.patch
git-acpi.patch
git-avr32.patch
git-md-accel.patch
8250-make-probing-for-txen-bug-a-config-option.patch
loosen-dependancy-on-rtc-cmos.patch
rtc-sa1100-rtc_wklarmenabled-bugfixes.patch
remove-modpost-false-warnings-on-arm.patch
spi-controller-build-warning-fixes.patch
