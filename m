From: akpm@linux-foundation.org
Subject: + spi-use-mutex-not-semaphore.patch added to -mm tree
Date: Wed, 24 Oct 2007 21:15:33 -0700
Message-ID: <200710250415.l9P4FXXp031337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38084 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755825AbXJYEPn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 00:15:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     SPI: use mutex not semaphore
has been added to the -mm tree.  Its filename is
     spi-use-mutex-not-semaphore.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -586,7 +586,7 @@ int spi_write_then_read(struct spi_devic
 		const u8 *txbuf, unsigned n_tx,
 		u8 *rxbuf, unsigned n_rx)
 {
-	static DECLARE_MUTEX(lock);
+	static DEFINE_MUTEX(lock);
 
 	int			status;
 	struct spi_message	message;
@@ -612,7 +612,7 @@ int spi_write_then_read(struct spi_devic
 	}
 
 	/* ... unless someone else is using the pre-allocated buffer */
-	if (down_trylock(&lock)) {
+	if (!mutex_trylock(&lock)) {
 		local_buf = kmalloc(SPI_BUFSIZ, GFP_KERNEL);
 		if (!local_buf)
 			return -ENOMEM;
@@ -631,7 +631,7 @@ int spi_write_then_read(struct spi_devic
 	}
 
 	if (x[0].tx_buf == buf)
-		up(&lock);
+		mutex_unlock(&lock);
 	else
 		kfree(local_buf);
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

acpi-fix-bdc-handling-in-drivers-acpi-sleep-procc.patch
rtc-release-correct-region-in-error-path.patch
rtc-fallback-to-requesting-only-the-ports-we-actually-use.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
spi-at25-driver-is-for-eeprom-not-flash.patch
spi-use-mutex-not-semaphore.patch
cosmetic-fixes-to-rtc-subsystems-kconfig.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
