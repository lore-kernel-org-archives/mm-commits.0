From: akpm@linux-foundation.org
Subject: [to-be-updated] mmc_spi-use-eilseq-for-possible-transmission-errors.patch removed from -mm tree
Date: Thu, 11 Jun 2009 16:12:55 -0700
Message-ID: <200906112312.n5BNCuso012422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753321AbZFKXOG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jun 2009 19:14:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wolfgang.mues@auerswald.de, dbrownell@users.sourceforge.net, drzeus@drzeus.cx, matt@console-pimps.org, vapier.adi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mmc_spi: use EILSEQ for possible transmission errors
has been removed from the -mm tree.  Its filename was
     mmc_spi-use-eilseq-for-possible-transmission-errors.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc_spi: use EILSEQ for possible transmission errors
From: Wolfgang Muees <wolfgang.mues@auerswald.de>

Change the reported error code for the responses to a command from
EINVAL/EIO to EILSEQ, as EINVAL is reserved for non-recoverable host
errors, and the responses from the SD/MMC card may be because of
recoverable transmission errors in the command or in the response. 
Response codes are NOT protected by a checksum, so don't trust them.

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/mmc_spi.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff -puN drivers/mmc/host/mmc_spi.c~mmc_spi-use-eilseq-for-possible-transmission-errors drivers/mmc/host/mmc_spi.c
--- a/drivers/mmc/host/mmc_spi.c~mmc_spi-use-eilseq-for-possible-transmission-errors
+++ a/drivers/mmc/host/mmc_spi.c
@@ -334,17 +334,18 @@ checkstatus:
 	cmd->error = 0;
 
 	/* Status byte: the entire seven-bit R1 response.  */
-	if (cmd->resp[0] != 0) {
-		if ((R1_SPI_PARAMETER | R1_SPI_ADDRESS
-				      | R1_SPI_ILLEGAL_COMMAND)
-				& cmd->resp[0])
-			value = -EINVAL;
-		else if (R1_SPI_COM_CRC & cmd->resp[0])
-			value = -EILSEQ;
-		else if ((R1_SPI_ERASE_SEQ | R1_SPI_ERASE_RESET)
-				& cmd->resp[0])
-			value = -EIO;
-		/* else R1_SPI_IDLE, "it's resetting" */
+	/*
+	 * Note that we have a problem here: as the response is NOT protected
+	 * by a CRC or checksum, a transmission error in the response will
+	 * be interpreted as an error code. So we map all error codes to
+	 * EILSEQ here, to allow for the upper layer to retry the command.
+	 * If one of these error codes is a non-recoverable error, retries
+	 * will do no harm.
+	 */
+
+	/* Allow only 0 and R1_SPI_IDLE here */
+	if (cmd->resp[0] & ~R1_SPI_IDLE) {
+		value = -EILSEQ;
 	}
 
 	switch (mmc_spi_resp_type(cmd)) {
_

Patches currently in -mm which might be from wolfgang.mues@auerswald.de are

linux-next.patch
mmc_spi-use-eilseq-for-possible-transmission-errors.patch

