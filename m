From: akpm@linux-foundation.org
Subject: - spi-add-3wire-mode-flag.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:02:54 -0700
Message-ID: <200707172302.l6HN2sWJ011634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54973 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936649AbXGQXQG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     SPI: add 3wire mode flag
has been removed from the -mm tree.  Its filename was
     spi-add-3wire-mode-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SPI: add 3wire mode flag
From: David Brownell <david-b@pacbell.net>

Add a new spi->mode bit: SPI_3WIRE, for chips where the SI and SO signals
are shared (and which are thus only half duplex).  Update the LM70 driver
to require support for that hardware mode from the controller.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lm70.c    |    4 ++++
 include/linux/spi/spi.h |    1 +
 2 files changed, 5 insertions(+)

diff -puN drivers/hwmon/lm70.c~spi-add-3wire-mode-flag drivers/hwmon/lm70.c
--- a/drivers/hwmon/lm70.c~spi-add-3wire-mode-flag
+++ a/drivers/hwmon/lm70.c
@@ -96,6 +96,10 @@ static int __devinit lm70_probe(struct s
 	struct lm70 *p_lm70;
 	int status;
 
+	/* signaling is SPI_MODE_0 on a 3-wire link (shared SI/SO) */
+	if ((spi->mode & (SPI_CPOL|SPI_CPHA)) || !(spi->mode & SPI_3WIRE))
+		return -EINVAL;
+
 	p_lm70 = kzalloc(sizeof *p_lm70, GFP_KERNEL);
 	if (!p_lm70)
 		return -ENOMEM;
diff -puN include/linux/spi/spi.h~spi-add-3wire-mode-flag include/linux/spi/spi.h
--- a/include/linux/spi/spi.h~spi-add-3wire-mode-flag
+++ a/include/linux/spi/spi.h
@@ -76,6 +76,7 @@ struct spi_device {
 #define	SPI_MODE_3	(SPI_CPOL|SPI_CPHA)
 #define	SPI_CS_HIGH	0x04			/* chipselect active high? */
 #define	SPI_LSB_FIRST	0x08			/* per-word bits-on-wire */
+#define	SPI_3WIRE	0x10			/* SI/SO signals shared */
 	u8			bits_per_word;
 	int			irq;
 	void			*controller_state;
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
git-leds.patch
git-mmc.patch
git-mtd.patch
git-backlight.patch
use-mutex-instead-of-semaphore-in-the-usb-gadget-serial-driver.patch
geode-basic-infrastructure-support-for-amd-geode-class.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
gpio-calls-dont-need-i-o-barriers.patch
dev_vdbg-available-with-dverbose_debug.patch
dev_vdbg-available-with-dverbose_debug-docs.patch
