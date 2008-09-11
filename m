From: akpm@linux-foundation.org
Subject: + spi-simplify-spi_write_then_read.patch added to -mm tree
Date: Wed, 10 Sep 2008 17:45:55 -0700
Message-ID: <200809110045.m8B0jtsm002837@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752230AbYIKAqF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Sep 2008 20:46:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vernoninhand@gmail.com, Vernon.Sauder@gmail.com, dbrownell@users.sourceforge.net


The patch titled
     spi: simplify spi_write_then_read()
has been added to the -mm tree.  Its filename is
     spi-simplify-spi_write_then_read.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: simplify spi_write_then_read()
From: Vernon Sauder <vernoninhand@gmail.com>

Modify spi_write_then_read() to use one transfer.  This speeds up all
callers, and is a minor code shrink.

Signed-off-by: Vernon Sauder <Vernon.Sauder@gmail.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff -puN drivers/spi/spi.c~spi-simplify-spi_write_then_read drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-simplify-spi_write_then_read
+++ a/drivers/spi/spi.c
@@ -660,7 +660,7 @@ int spi_write_then_read(struct spi_devic
 
 	int			status;
 	struct spi_message	message;
-	struct spi_transfer	x[2];
+	struct spi_transfer	x;
 	u8			*local_buf;
 
 	/* Use preallocated DMA-safe buffer.  We can't avoid copying here,
@@ -671,15 +671,9 @@ int spi_write_then_read(struct spi_devic
 		return -EINVAL;
 
 	spi_message_init(&message);
-	memset(x, 0, sizeof x);
-	if (n_tx) {
-		x[0].len = n_tx;
-		spi_message_add_tail(&x[0], &message);
-	}
-	if (n_rx) {
-		x[1].len = n_rx;
-		spi_message_add_tail(&x[1], &message);
-	}
+	memset(&x, 0, sizeof x);
+	x.len = n_tx + n_rx;
+	spi_message_add_tail(&x, &message);
 
 	/* ... unless someone else is using the pre-allocated buffer */
 	if (!mutex_trylock(&lock)) {
@@ -690,15 +684,15 @@ int spi_write_then_read(struct spi_devic
 		local_buf = buf;
 
 	memcpy(local_buf, txbuf, n_tx);
-	x[0].tx_buf = local_buf;
-	x[1].rx_buf = local_buf + n_tx;
+	x.tx_buf = local_buf;
+	x.rx_buf = local_buf;
 
 	/* do the i/o */
 	status = spi_sync(spi, &message);
 	if (status == 0)
-		memcpy(rxbuf, x[1].rx_buf, n_rx);
+		memcpy(rxbuf, x.rx_buf + n_tx, n_rx);
 
-	if (x[0].tx_buf == buf)
+	if (x.tx_buf == buf)
 		mutex_unlock(&lock);
 	else
 		kfree(local_buf);
_

Patches currently in -mm which might be from vernoninhand@gmail.com are

spi-simplify-spi_write_then_read.patch

