From: akpm@linux-foundation.org
Subject: + spidev-supports-more-communications-modes.patch added to -mm tree
Date: Mon, 30 Jul 2007 21:50:01 -0700
Message-ID: <200707310450.l6V4o1nb016145@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42970 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760287AbXGaEut (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 00:50:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net


The patch titled
     spidev supports more communications modes
has been added to the -mm tree.  Its filename is
     spidev-supports-more-communications-modes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spidev supports more communications modes
From: Anton Vorontsov <avorontsov@ru.mvista.com>

The spidev driver doesn't currently expose all SPI communications modes to
userspace.  This passes them all through to the driver.

Two of them are potentially troublesome, in the sense that they could cause
hardware conflicts on shared busses.  It might be appropriate to add some
privilege checks for for those modes.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spidev.c       |   13 ++++++++++---
 include/linux/spi/spidev.h |    4 ++++
 2 files changed, 14 insertions(+), 3 deletions(-)

diff -puN drivers/spi/spidev.c~spidev-supports-more-communications-modes drivers/spi/spidev.c
--- a/drivers/spi/spidev.c~spidev-supports-more-communications-modes
+++ a/drivers/spi/spidev.c
@@ -55,9 +55,16 @@
 static unsigned long	minors[N_SPI_MINORS / BITS_PER_LONG];
 
 
-/* Bit masks for spi_device.mode management */
-#define SPI_MODE_MASK			(SPI_CPHA | SPI_CPOL)
-
+/* Bit masks for spi_device.mode management.  Note that incorrect
+ * settings for CS_HIGH and 3WIRE can cause *lots* of trouble for other
+ * devices on a shared bus:  CS_HIGH, because this device will be
+ * active when it shouldn't be;  3WIRE, because when active it won't
+ * behave as it should.
+ *
+ * REVISIT should changing those two modes be privileged?
+ */
+#define SPI_MODE_MASK		(SPI_CPHA | SPI_CPOL | SPI_CS_HIGH \
+				| SPI_LSB_FIRST | SPI_3WIRE | SPI_LOOP)
 
 struct spidev_data {
 	struct device		dev;
diff -puN include/linux/spi/spidev.h~spidev-supports-more-communications-modes include/linux/spi/spidev.h
--- a/include/linux/spi/spidev.h~spidev-supports-more-communications-modes
+++ a/include/linux/spi/spidev.h
@@ -35,6 +35,10 @@
 #define SPI_MODE_2		(SPI_CPOL|0)
 #define SPI_MODE_3		(SPI_CPOL|SPI_CPHA)
 
+#define SPI_CS_HIGH		0x04
+#define SPI_LSB_FIRST		0x08
+#define SPI_3WIRE		0x10
+#define SPI_LOOP		0x20
 
 /*---------------------------------------------------------------------------*/
 
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

spi_mpc83xx-turn-off-spi-unit-while-switching-mode.patch
spi_mpc83xx-get-rid-of-magic-numbers.patch
spi_mpc83xx-support-for-lsb-first-transfers.patch
spi_mpc83xx-fix-qelsb-mode-shifts.patch
spi-loopback-mode-definition.patch
spidev-supports-more-communications-modes.patch
spidev_test-utility.patch
spi_mpc83xx-support-loopback-mode.patch
