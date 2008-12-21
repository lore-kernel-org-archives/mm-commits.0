From: akpm@linux-foundation.org
Subject: + spi-spi_write_then_read-regression-fix.patch added to -mm tree
Date: Sat, 20 Dec 2008 23:43:10 -0800
Message-ID: <200812210743.mBL7hAcO021570@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751195AbYLUHnS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Dec 2008 02:43:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, vernoninhand@gmail.com


The patch titled
     spi: spi_write_then_read() regression fix
has been added to the -mm tree.  Its filename is
     spi-spi_write_then_read-regression-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: spi_write_then_read() regression fix
From: David Brownell <dbrownell@users.sourceforge.net>

The recent "simplify spi_write_then_read()" patch included a small
regression from the 2.6.27 behavior with its performance win.

All SPI transfers are full duplex, and are packaged as half duplex
by either discarding the data that's read ("write only"), or else
by writing zeroes ("read only").  That patch wasn't ensuring that
zeroes were getting written out during the "half duplex read" part
of the transaction; instead, old RX bits were getting sent.

The fix is trivial:  zero the buffer before using it.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Vernon Sauder <vernoninhand@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/spi/spi.c~spi-spi_write_then_read-regression-fix drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-spi_write_then_read-regression-fix
+++ a/drivers/spi/spi.c
@@ -677,11 +677,13 @@ int spi_write_then_read(struct spi_devic
 
 	/* ... unless someone else is using the pre-allocated buffer */
 	if (!mutex_trylock(&lock)) {
-		local_buf = kmalloc(SPI_BUFSIZ, GFP_KERNEL);
+		local_buf = kzalloc(SPI_BUFSIZ, GFP_KERNEL);
 		if (!local_buf)
 			return -ENOMEM;
-	} else
+	} else {
 		local_buf = buf;
+		memset(local_buf, 0, x.len);
+	}
 
 	memcpy(local_buf, txbuf, n_tx);
 	x.tx_buf = local_buf;
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

spi-spi_write_then_read-regression-fix.patch
linux-next.patch
acpi-fix-acpi_fadt_s4_rtc_wake-comment.patch
documentation-when-to-bug-and-when-to-not-bug.patch
spi_gpio-driver.patch
spi_gpio-driver-cleanups.patch
atmel_spi-clean-up-spiv1-quirk-handling.patch
spi-atmel_spi-update-chipselect-handling.patch
spi-use-generic-gpio-calls-in-spi_s3c24xx_gpio.patch
drivers-spi-move-a-dereference-below-a-null-test.patch
mfd-da903x-section-fix.patch
rtc-ds1307-remove-legacy-probe-checks.patch
rtc-bunch-of-drivers-fix-no-irq-case-handing.patch
twl4030-gpio-cleanup-debounce.patch
gpio-pca953x-handles-more-chips-i2c-fault-codes.patch

