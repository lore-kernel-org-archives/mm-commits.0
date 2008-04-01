From: akpm@linux-foundation.org
Subject: + atmel_spi-support-zero-length-transfer.patch added to -mm tree
Date: Tue, 01 Apr 2008 11:26:37 -0700
Message-ID: <200804011826.m31IQblj007069@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757079AbYDAS1W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 14:27:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, david-b@pacbell.net, hskinnemoen@atmel.com


The patch titled
     atmel_spi: support zero length transfer
has been added to the -mm tree.  Its filename is
     atmel_spi-support-zero-length-transfer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_spi: support zero length transfer
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

A spi transfer with zero length is not invalid.  For example, such
transfer (len == 0 && delay_usecs != 0) can be used to achieve delay
before first CLK edge after chipselect assertion.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/atmel_spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/atmel_spi.c~atmel_spi-support-zero-length-transfer drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~atmel_spi-support-zero-length-transfer
+++ a/drivers/spi/atmel_spi.c
@@ -616,7 +616,7 @@ static int atmel_spi_transfer(struct spi
 		return -ESHUTDOWN;
 
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
-		if (!(xfer->tx_buf || xfer->rx_buf)) {
+		if (!(xfer->tx_buf || xfer->rx_buf) && xfer->len) {
 			dev_dbg(&spi->dev, "missing rx or tx buf\n");
 			return -EINVAL;
 		}
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
git-alsa-tiwai.patch
atmel_spi-support-zero-length-transfer.patch

