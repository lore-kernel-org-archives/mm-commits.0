From: akpm@linux-foundation.org
Subject: + spi-at25-driver-is-for-eeprom-not-flash.patch added to -mm tree
Date: Wed, 24 Oct 2007 21:15:10 -0700
Message-ID: <200710250415.l9P4FAGf031327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39670 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761652AbXJYEP1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 00:15:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     spi: at25 driver is for EEPROM not FLASH
has been added to the -mm tree.  Its filename is
     spi-at25-driver-is-for-eeprom-not-flash.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi: at25 driver is for EEPROM not FLASH
From: David Brownell <david-b@pacbell.net>

Add comment to at25 driver that it's for EEPROM chips, not FLASH
chips ... the AT25 series has both types of chip, and sometimes
they're even pin-compatible.  The command sets are different, as
is the treatment of erasure.  (FLASH needs explicit erasure, but
with EEPROM it's implicit.)  Note that all vendors seem to have
this same confusion in their *25* series SPI memory parts.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/at25.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/spi/at25.c~spi-at25-driver-is-for-eeprom-not-flash drivers/spi/at25.c
--- a/drivers/spi/at25.c~spi-at25-driver-is-for-eeprom-not-flash
+++ a/drivers/spi/at25.c
@@ -21,6 +21,13 @@
 #include <linux/spi/eeprom.h>
 
 
+/*
+ * NOTE: this is an *EEPROM* driver.  The vagaries of product naming
+ * mean that some AT25 products are EEPROMs, and others are FLASH.
+ * Handle FLASH chips with the drivers/mtd/devices/m25p80.c driver,
+ * not this one!
+ */
+
 struct at25_data {
 	struct spi_device	*spi;
 	struct mutex		lock;
_

Patches currently in -mm which might be from david-b@pacbell.net are

acpi-fix-bdc-handling-in-drivers-acpi-sleep-procc.patch
rtc-release-correct-region-in-error-path.patch
rtc-fallback-to-requesting-only-the-ports-we-actually-use.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
spi-at25-driver-is-for-eeprom-not-flash.patch
cosmetic-fixes-to-rtc-subsystems-kconfig.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
