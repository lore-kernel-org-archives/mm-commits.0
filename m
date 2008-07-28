From: akpm@linux-foundation.org
Subject: + mpc52xx_psc_spi-fix-block-transfer.patch added to -mm tree
Date: Sun, 27 Jul 2008 19:41:02 -0700
Message-ID: <200807280241.m6S2f2do016261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753146AbYG1ClY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jul 2008 22:41:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: l.fu@pengutronix.de, dbrownell@users.sourceforge.net


The patch titled
     mpc52xx_psc_spi: fix block transfer
has been added to the -mm tree.  Its filename is
     mpc52xx_psc_spi-fix-block-transfer.patch

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
Subject: mpc52xx_psc_spi: fix block transfer
From: Luotao Fu <l.fu@pengutronix.de>

The block transfer routine in the mpc52xx psc spi driver misinterpret the
datasheet.  According to the processor datasheet the chipselect is held as
long as the EOF is not written.  Theoretically block of any sizes can be
transferred in this way.  The old routine however writes an EOF after
every word, which has the size of size_of_word.  This makes the transfer
slow.  Also fixed some duplicate code.

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/mpc52xx_psc_spi.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff -puN drivers/spi/mpc52xx_psc_spi.c~mpc52xx_psc_spi-fix-block-transfer drivers/spi/mpc52xx_psc_spi.c
--- a/drivers/spi/mpc52xx_psc_spi.c~mpc52xx_psc_spi-fix-block-transfer
+++ a/drivers/spi/mpc52xx_psc_spi.c
@@ -148,7 +148,6 @@ static int mpc52xx_psc_spi_transfer_rxtx
 	unsigned rfalarm;
 	unsigned send_at_once = MPC52xx_PSC_BUFSIZE;
 	unsigned recv_at_once;
-	unsigned bpw = mps->bits_per_word / 8;
 
 	if (!t->tx_buf && !t->rx_buf && t->len)
 		return -EINVAL;
@@ -164,22 +163,15 @@ static int mpc52xx_psc_spi_transfer_rxtx
 		}
 
 		dev_dbg(&spi->dev, "send %d bytes...\n", send_at_once);
-		if (tx_buf) {
-			for (; send_at_once; sb++, send_at_once--) {
-				/* set EOF flag */
-				if (mps->bits_per_word
-						&& (sb + 1) % bpw == 0)
-					out_8(&psc->ircr2, 0x01);
+		for (; send_at_once; sb++, send_at_once--) {
+			/* set EOF flag before the last word is sent */
+			if (send_at_once == 1)
+				out_8(&psc->ircr2, 0x01);
+
+			if (tx_buf)
 				out_8(&psc->mpc52xx_psc_buffer_8, tx_buf[sb]);
-			}
-		} else {
-			for (; send_at_once; sb++, send_at_once--) {
-				/* set EOF flag */
-				if (mps->bits_per_word
-						&& ((sb + 1) % bpw) == 0)
-					out_8(&psc->ircr2, 0x01);
+			else
 				out_8(&psc->mpc52xx_psc_buffer_8, 0);
-			}
 		}
 
 
_

Patches currently in -mm which might be from l.fu@pengutronix.de are

mpc52xx_psc_spi-fix-block-transfer.patch

