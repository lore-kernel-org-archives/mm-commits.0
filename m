From: akpm@linux-foundation.org
Subject: + sdio-recognize-io-card-without-powercycle.patch added to -mm tree
Date: Thu, 10 Sep 2009 20:40:13 -0700
Message-ID: <200909110340.n8B3eDt9003047@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753534AbZIKDkM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Sep 2009 23:40:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: albert_herranz@yahoo.es, linux-mmc@vger.kernel.org


The patch titled
     sdio: recognize io card without powercycle
has been added to the -mm tree.  Its filename is
     sdio-recognize-io-card-without-powercycle.patch

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
Subject: sdio: recognize io card without powercycle
From: Albert Herranz <albert_herranz@yahoo.es>

SDIO Simplified Specification V2.00 states that it is strongly recommended
that the host executes either a power reset or issues a CMD52 (I/O Reset)
to re-initialize an I/O only card or the I/O portion of a combo card. 
Additionally, the CMD52 must be issued first because it cannot be issued
after a CMD0.

With this patch the Nintendo Wii SDIO-based WLAN card is detected after a
system reset, without requiring a complete system powercycle.

Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c     |    1 
 drivers/mmc/core/sdio_ops.c |   36 ++++++++++++++++++++++++++++------
 drivers/mmc/core/sdio_ops.h |    1 
 3 files changed, 32 insertions(+), 6 deletions(-)

diff -puN drivers/mmc/core/core.c~sdio-recognize-io-card-without-powercycle drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~sdio-recognize-io-card-without-powercycle
+++ a/drivers/mmc/core/core.c
@@ -1073,6 +1073,7 @@ void mmc_rescan(struct work_struct *work
 	mmc_claim_host(host);
 
 	mmc_power_up(host);
+	sdio_go_idle(host);
 	mmc_go_idle(host);
 
 	mmc_send_if_cond(host, host->ocr_avail);
diff -puN drivers/mmc/core/sdio_ops.c~sdio-recognize-io-card-without-powercycle drivers/mmc/core/sdio_ops.c
--- a/drivers/mmc/core/sdio_ops.c~sdio-recognize-io-card-without-powercycle
+++ a/drivers/mmc/core/sdio_ops.c
@@ -67,13 +67,13 @@ int mmc_send_io_op_cond(struct mmc_host 
 	return err;
 }
 
-int mmc_io_rw_direct(struct mmc_card *card, int write, unsigned fn,
-	unsigned addr, u8 in, u8* out)
+static int mmc_io_rw_direct_host(struct mmc_host *host, int write, unsigned fn,
+	unsigned addr, u8 in, u8 *out)
 {
 	struct mmc_command cmd;
 	int err;
 
-	BUG_ON(!card);
+	BUG_ON(!host);
 	BUG_ON(fn > 7);
 
 	/* sanity check */
@@ -90,11 +90,11 @@ int mmc_io_rw_direct(struct mmc_card *ca
 	cmd.arg |= in;
 	cmd.flags = MMC_RSP_SPI_R5 | MMC_RSP_R5 | MMC_CMD_AC;
 
-	err = mmc_wait_for_cmd(card->host, &cmd, 0);
+	err = mmc_wait_for_cmd(host, &cmd, 0);
 	if (err)
 		return err;
 
-	if (mmc_host_is_spi(card->host)) {
+	if (mmc_host_is_spi(host)) {
 		/* host driver already reported errors */
 	} else {
 		if (cmd.resp[0] & R5_ERROR)
@@ -106,7 +106,7 @@ int mmc_io_rw_direct(struct mmc_card *ca
 	}
 
 	if (out) {
-		if (mmc_host_is_spi(card->host))
+		if (mmc_host_is_spi(host))
 			*out = (cmd.resp[0] >> 8) & 0xFF;
 		else
 			*out = cmd.resp[0] & 0xFF;
@@ -115,6 +115,13 @@ int mmc_io_rw_direct(struct mmc_card *ca
 	return 0;
 }
 
+int mmc_io_rw_direct(struct mmc_card *card, int write, unsigned fn,
+	unsigned addr, u8 in, u8 *out)
+{
+	BUG_ON(!card);
+	return mmc_io_rw_direct_host(card->host, write, fn, addr, in, out);
+}
+
 int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
 	unsigned addr, int incr_addr, u8 *buf, unsigned blocks, unsigned blksz)
 {
@@ -182,3 +189,20 @@ int mmc_io_rw_extended(struct mmc_card *
 	return 0;
 }
 
+int sdio_go_idle(struct mmc_host *host)
+{
+	int ret;
+	u8 abort;
+
+	/* SDIO Simplified Specification V2.0, 4.4 Reset for SDIO */
+
+	ret = mmc_io_rw_direct_host(host, 0, 0, SDIO_CCCR_ABORT, 0, &abort);
+	if (ret)
+		abort = 0x08;
+	else
+		abort |= 0x08;
+
+	ret = mmc_io_rw_direct_host(host, 1, 0, SDIO_CCCR_ABORT, abort, NULL);
+	return ret;
+}
+
diff -puN drivers/mmc/core/sdio_ops.h~sdio-recognize-io-card-without-powercycle drivers/mmc/core/sdio_ops.h
--- a/drivers/mmc/core/sdio_ops.h~sdio-recognize-io-card-without-powercycle
+++ a/drivers/mmc/core/sdio_ops.h
@@ -17,6 +17,7 @@ int mmc_io_rw_direct(struct mmc_card *ca
 	unsigned addr, u8 in, u8* out);
 int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
 	unsigned addr, int incr_addr, u8 *buf, unsigned blocks, unsigned blksz);
+int sdio_go_idle(struct mmc_host *host);
 
 #endif
 
_

Patches currently in -mm which might be from albert_herranz@yahoo.es are

linux-next.patch
sdio-recognize-io-card-without-powercycle.patch
sdio-pass-unknown-cis-tuples-to-sdio-drivers.patch

