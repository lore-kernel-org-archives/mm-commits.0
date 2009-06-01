From: akpm@linux-foundation.org
Subject: + spi-fix-spi_write_then_read-comment.patch added to -mm tree
Date: Mon, 01 Jun 2009 16:48:22 -0700
Message-ID: <200906012348.n51NmMsT028234@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698AbZFAXsk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2009 19:48:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jpirko@redhat.com, david-b@pacbell.net


The patch titled
     spi: fix spi_write_then_read() comment
has been added to the -mm tree.  Its filename is
     spi-fix-spi_write_then_read-comment.patch

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
Subject: spi: fix spi_write_then_read() comment
From: Jiri Pirko <jpirko@redhat.com>

Buffer needs not be dma-safe, not rx data length.

Signed-off-by: Jiri Pirko <jpirko@redhat.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/spi/spi.c~spi-fix-spi_write_then_read-comment drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-fix-spi_write_then_read-comment
+++ a/drivers/spi/spi.c
@@ -636,8 +636,8 @@ static u8	*buf;
  * @spi: device with which data will be exchanged
  * @txbuf: data to be written (need not be dma-safe)
  * @n_tx: size of txbuf, in bytes
- * @rxbuf: buffer into which data will be read
- * @n_rx: size of rxbuf, in bytes (need not be dma-safe)
+ * @rxbuf: buffer into which data will be read (need not be dma-safe)
+ * @n_rx: size of rxbuf, in bytes
  * Context: can sleep
  *
  * This performs a half duplex MicroWire style transaction with the
_

Patches currently in -mm which might be from jpirko@redhat.com are

linux-next.patch
getrusage-fill-ru_maxrss-value.patch
spi-fix-spi_write_then_read-comment.patch

