From: akpm@linux-foundation.org
Subject: - spi-simplify-spi_sync-calling-convention.patch removed from -mm tree
Date: Fri, 07 Dec 2007 17:28:55 -0800
Message-ID: <200712080128.lB81Stxe013362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50823 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753891AbXLHB3i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 20:29:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marc.pignat@hevs.ch, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: simplify spi_sync() calling convention
has been removed from the -mm tree.  Its filename was
     spi-simplify-spi_sync-calling-convention.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -541,10 +541,7 @@ static void spi_complete(void *arg)
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
@@ -554,8 +551,10 @@ int spi_sync(struct spi_device *spi, str
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
@@ -628,10 +627,8 @@ int spi_write_then_read(struct spi_devic
 
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

origin.patch
