From: akpm@linux-foundation.org
Subject: - atmel_spi-clean-up-baud-rate-divisor-calculation-fix.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:02:19 -0700
Message-ID: <200804300602.m3U62Kwn030661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756891AbYD3GDH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:03:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, haavard.skinnemoen@atmel.com, jramakrishnan@neuropace.com, mm-commits@vger.kernel.org


The patch titled
     atmel_spi-clean-up-baud-rate-divisor-calculation-fix
has been removed from the -mm tree.  Its filename was
     atmel_spi-clean-up-baud-rate-divisor-calculation-fix.patch

This patch was dropped because it was folded into atmel_spi-clean-up-baud-rate-divisor-calculation.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_spi-clean-up-baud-rate-divisor-calculation-fix
From: David Brownell <david-b@pacbell.net>

Patch should have the appended tweak.

Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: "Janesh Ramakrishnan" <jramakrishnan@neuropace.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/atmel_spi.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/spi/atmel_spi.c~atmel_spi-clean-up-baud-rate-divisor-calculation-fix drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~atmel_spi-clean-up-baud-rate-divisor-calculation-fix
+++ a/drivers/spi/atmel_spi.c
@@ -497,7 +497,7 @@ static int atmel_spi_setup(struct spi_de
 	struct atmel_spi	*as;
 	u32			scbr, csr;
 	unsigned int		bits = spi->bits_per_word;
-	unsigned long		bus_hz, sck_hz;
+	unsigned long		bus_hz;
 	unsigned int		npcs_pin;
 	int			ret;
 
@@ -598,10 +598,9 @@ static int atmel_spi_setup(struct spi_de
 		spin_unlock_irqrestore(&as->lock, flags);
 	}
 
-	sck_hz = bus_hz / scbr;
 	dev_dbg(&spi->dev,
 		"setup: %lu Hz bpw %u mode 0x%x -> csr%d %08x\n",
-		sck_hz, bits, spi->mode, spi->chip_select, csr);
+		bus_hz / scbr, bits, spi->mode, spi->chip_select, csr);
 
 	spi_writel(as, CSR0 + 4 * spi->chip_select, csr);
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
atmel_spi-clean-up-baud-rate-divisor-calculation.patch
atmel_spi-clean-up-baud-rate-divisor-calculation-fix.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
rtc-class-driver-for-ppc_md-rtc-functions.patch
rtc-class-driver-for-ppc_md-rtc-functions-fix.patch
gpio-pca953x-add-support-for-pca9555-i2c-i-o-expander.patch

