From: akpm@osdl.org
Subject: + spi-define-null-tx_buf-to-mean-shift-out-zeroes.patch added to -mm tree
Date: Wed, 27 Dec 2006 01:10:24 -0800
Message-ID: <200612270910.kBR9AOC0006463@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:42797 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660AbWL0JKh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 04:10:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, galak@kernel.crashing.org


The patch titled
     SPI: define null tx_buf to mean "shift out zeroes"
has been added to the -mm tree.  Its filename is
     spi-define-null-tx_buf-to-mean-shift-out-zeroes.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SPI: define null tx_buf to mean "shift out zeroes"
From: David Brownell <david-b@pacbell.net>

Some issues were recently turned up with the current specification of what
it means for spi_transfer.tx_buf to be null, as part of transfers which are
(from the SPI protocol driver perspective) pure reads.

Specifically, that it seems better to change the TX behaviour there from
"undefined" to "will shift zeroes".  This lets protocol drivers (like the
ads7846 driver) depend on that behavior.  It's what most controller drivers
in the tree are already doing (with one exception and one case of driver
wanting-to-oops), it's what Microwire hardware will necessarily be doing,
and it removes an issue whereby certain security audits would need to
define such a value anyway as part of removing covert channels.

This patch changes the specification to require shifting zeroes, and
updates all currently merged SPI controller drivers to do so.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/spi/spi_mpc83xx.c |    2 ++
 drivers/spi/spi_s3c24xx.c |    2 +-
 include/linux/spi/spi.h   |    2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/spi/spi_mpc83xx.c~spi-define-null-tx_buf-to-mean-shift-out-zeroes drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi-define-null-tx_buf-to-mean-shift-out-zeroes
+++ a/drivers/spi/spi_mpc83xx.c
@@ -112,6 +112,8 @@ u32 mpc83xx_spi_tx_buf_##type(struct mpc
 {								\
 	u32 data;						\
 	const type * tx = mpc83xx_spi->tx;			\
+	if (!tx)						\
+		return 0;					\
 	data = *tx++;						\
 	mpc83xx_spi->tx = tx;					\
 	return data;						\
diff -puN drivers/spi/spi_s3c24xx.c~spi-define-null-tx_buf-to-mean-shift-out-zeroes drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~spi-define-null-tx_buf-to-mean-shift-out-zeroes
+++ a/drivers/spi/spi_s3c24xx.c
@@ -174,7 +174,7 @@ static int s3c24xx_spi_setup(struct spi_
 
 static inline unsigned int hw_txbyte(struct s3c24xx_spi *hw, int count)
 {
-	return hw->tx ? hw->tx[count] : 0xff;
+	return hw->tx ? hw->tx[count] : 0;
 }
 
 static int s3c24xx_spi_txrx(struct spi_device *spi, struct spi_transfer *t)
diff -puN include/linux/spi/spi.h~spi-define-null-tx_buf-to-mean-shift-out-zeroes include/linux/spi/spi.h
--- a/include/linux/spi/spi.h~spi-define-null-tx_buf-to-mean-shift-out-zeroes
+++ a/include/linux/spi/spi.h
@@ -289,7 +289,7 @@ extern struct spi_master *spi_busnum_to_
  * the data being transferred; that may reduce overhead, when the
  * underlying driver uses dma.
  *
- * If the transmit buffer is null, undefined data will be shifted out
+ * If the transmit buffer is null, zeroes will be shifted out
  * while filling rx_buf.  If the receive buffer is null, the data
  * shifted in will be discarded.  Only "len" bytes shift out (or in).
  * It's an error to try to shift out a partial word.  (For example, by
_

Patches currently in -mm which might be from david-b@pacbell.net are

spi-define-null-tx_buf-to-mean-shift-out-zeroes.patch
spi-kconfig-fix.patch
spi-controller-driver-for-omap-microwire.patch
gpio-core.patch
omap-gpio-wrappers.patch
at91-gpio-wrappers.patch

