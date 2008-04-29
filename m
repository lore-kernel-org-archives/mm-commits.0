From: akpm@linux-foundation.org
Subject: + atmel_spi-clean-up-baud-rate-divisor-calculation-fix.patch added to -mm tree
Date: Tue, 29 Apr 2008 16:47:40 -0700
Message-ID: <200804292347.m3TNleAN016386@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752065AbYD2Xs0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 19:48:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, haavard.skinnemoen@atmel.com, jramakrishnan@neuropace.com


The patch titled
     atmel_spi-clean-up-baud-rate-divisor-calculation-fix
has been added to the -mm tree.  Its filename is
     atmel_spi-clean-up-baud-rate-divisor-calculation-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
remove-duplicated-unlikely-in-is_err.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
git-acpi.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
git-mmc.patch
jffs2-summary-allocation-dont-use-vmalloc.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
add-a-new-sysfs_streq-string-comparison-function.patch
atmel_spi-clean-up-baud-rate-divisor-calculation.patch
atmel_spi-clean-up-baud-rate-divisor-calculation-fix.patch

