From: akpm@linux-foundation.org
Subject: [merged] spi-spi_write_then_read-bugfixes.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:49:19 -0700
Message-ID: <200904141949.n3EJnJbR019570@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753839AbZDNTwa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:52:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     spi: spi_write_then_read() bugfixes
has been removed from the -mm tree.  Its filename was
     spi-spi_write_then_read-bugfixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: spi_write_then_read() bugfixes
From: David Brownell <dbrownell@users.sourceforge.net>

The "simplify spi_write_then_read()" patch included two regressions from
the 2.6.27 behaviors:

 - The data it wrote out during the (full duplex) read side
   of the transfer was not zeroed.

 - It fails completely on half duplex hardware, such as
   Microwire and most "3-wire" SPI variants.

So, revert that patch.  A revised version should be submitted at some
point, which can get the speedup on standard hardware (full duplex)
without breaking on less-capable half-duplex stuff.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: <stable@kernel.org>		[2.6.28.x, 2.6.29.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff -puN drivers/spi/spi.c~spi-spi_write_then_read-bugfixes drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-spi_write_then_read-bugfixes
+++ a/drivers/spi/spi.c
@@ -658,7 +658,7 @@ int spi_write_then_read(struct spi_devic
 
 	int			status;
 	struct spi_message	message;
-	struct spi_transfer	x;
+	struct spi_transfer	x[2];
 	u8			*local_buf;
 
 	/* Use preallocated DMA-safe buffer.  We can't avoid copying here,
@@ -669,9 +669,15 @@ int spi_write_then_read(struct spi_devic
 		return -EINVAL;
 
 	spi_message_init(&message);
-	memset(&x, 0, sizeof x);
-	x.len = n_tx + n_rx;
-	spi_message_add_tail(&x, &message);
+	memset(x, 0, sizeof x);
+	if (n_tx) {
+		x[0].len = n_tx;
+		spi_message_add_tail(&x[0], &message);
+	}
+	if (n_rx) {
+		x[1].len = n_rx;
+		spi_message_add_tail(&x[1], &message);
+	}
 
 	/* ... unless someone else is using the pre-allocated buffer */
 	if (!mutex_trylock(&lock)) {
@@ -682,15 +688,15 @@ int spi_write_then_read(struct spi_devic
 		local_buf = buf;
 
 	memcpy(local_buf, txbuf, n_tx);
-	x.tx_buf = local_buf;
-	x.rx_buf = local_buf;
+	x[0].tx_buf = local_buf;
+	x[1].rx_buf = local_buf + n_tx;
 
 	/* do the i/o */
 	status = spi_sync(spi, &message);
 	if (status == 0)
-		memcpy(rxbuf, x.rx_buf + n_tx, n_rx);
+		memcpy(rxbuf, x[1].rx_buf, n_rx);
 
-	if (x.tx_buf == buf)
+	if (x[0].tx_buf == buf)
 		mutex_unlock(&lock);
 	else
 		kfree(local_buf);
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
linux-next.patch
rtc-rtc-ds1307-add-ds3231.patch

