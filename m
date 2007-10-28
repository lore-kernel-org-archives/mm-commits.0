From: akpm@linux-foundation.org
Subject: + spi-simplify-spi_sync-calling-convention.patch added to -mm tree
Date: Sat, 27 Oct 2007 22:22:24 -0700
Message-ID: <200710280522.l9S5MOO4018572@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46505 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750841AbXJ1FWn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 28 Oct 2007 01:22:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marc.pignat@hevs.ch, dbrownell@users.sourceforge.net


The patch titled
     spi: simplify spi_sync() calling convention
has been added to the -mm tree.  Its filename is
     spi-simplify-spi_sync-calling-convention.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi: simplify spi_sync() calling convention
From: Marc Pignat <marc.pignat@hevs.ch>

Simplify spi_sync calling convention, eliminating the need to check both
the return value AND the message->status.  In consequence, this corrects
misbehaviours of spi_read and spi_write (which only checked the former) and
their callers.

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN drivers/spi/spi.c~spi-simplify-spi_sync-calling-convention drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-simplify-spi_sync-calling-convention
+++ a/drivers/spi/spi.c
@@ -538,10 +538,7 @@ static void spi_complete(void *arg)
  * Also, the caller is guaranteeing that the memory associated with the
  * message will not be freed before this call returns.
  *
- * The return value is a negative error code if the message could not be
- * submitted, else zero.  When the value is zero, then message->status is
- * also defined;  it's the completion code for the transfer, either zero
- * or a negative error code from the controller driver.
+ * It returns zero on success, else a negative error code.
  */
 int spi_sync(struct spi_device *spi, struct spi_message *message)
 {
@@ -551,8 +548,10 @@ int spi_sync(struct spi_device *spi, str
 	message->complete = spi_complete;
 	message->context = &done;
 	status = spi_async(spi, message);
-	if (status == 0)
+	if (status == 0) {
 		wait_for_completion(&done);
+		status = message->status;
+	}
 	message->context = NULL;
 	return status;
 }
@@ -625,10 +624,8 @@ int spi_write_then_read(struct spi_devic
 
 	/* do the i/o */
 	status = spi_sync(spi, &message);
-	if (status == 0) {
+	if (status == 0)
 		memcpy(rxbuf, x[1].rx_buf, n_rx);
-		status = message.status;
-	}
 
 	if (x[0].tx_buf == buf)
 		mutex_unlock(&lock);
_

Patches currently in -mm which might be from marc.pignat@hevs.ch are

spi-simplify-spi_sync-calling-convention.patch
spi-use-simplified-spi_sync-calling-convention.patch
