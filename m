From: akpm@linux-foundation.org
Subject: + spi-mpc52xx_psc_spi-chipselect-bugfix.patch added to -mm tree
Date: Fri, 21 Nov 2008 15:15:06 -0800
Message-ID: <200811212315.mALNF6N3017495@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752818AbYKUXPU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 18:15:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sbabic@denx.de, dbrownell@users.sourceforge.net, grant.likely@secretlab.ca


The patch titled
     spi: mpc52xx_psc_spi chipselect bugfix
has been added to the -mm tree.  Its filename is
     spi-mpc52xx_psc_spi-chipselect-bugfix.patch

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
Subject: spi: mpc52xx_psc_spi chipselect bugfix
From: Stefano Babic <sbabic@denx.de>

According to the manual the "tdfOnExit" flag must be set on the last byte
we want to send.  The PSC controller holds SS low until the flag is set.

However, the flag was set always on the last byte of the FIFO,
independently if it is the last byte of the transfer.  This generates
spurious toggling of the SS signals that breaks the protocol of some
peripherals.  Fix.

Signed-off-by: Stefano Babic <sbabic@denx.de>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/mpc52xx_psc_spi.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/spi/mpc52xx_psc_spi.c~spi-mpc52xx_psc_spi-chipselect-bugfix drivers/spi/mpc52xx_psc_spi.c
--- a/drivers/spi/mpc52xx_psc_spi.c~spi-mpc52xx_psc_spi-chipselect-bugfix
+++ a/drivers/spi/mpc52xx_psc_spi.c
@@ -142,6 +142,7 @@ static int mpc52xx_psc_spi_transfer_rxtx
 	unsigned rfalarm;
 	unsigned send_at_once = MPC52xx_PSC_BUFSIZE;
 	unsigned recv_at_once;
+	int last_block = 0;
 
 	if (!t->tx_buf && !t->rx_buf && t->len)
 		return -EINVAL;
@@ -151,15 +152,17 @@ static int mpc52xx_psc_spi_transfer_rxtx
 	while (rb < t->len) {
 		if (t->len - rb > MPC52xx_PSC_BUFSIZE) {
 			rfalarm = MPC52xx_PSC_RFALARM;
+			last_block = 0;
 		} else {
 			send_at_once = t->len - sb;
 			rfalarm = MPC52xx_PSC_BUFSIZE - (t->len - rb);
+			last_block = 1;
 		}
 
 		dev_dbg(&spi->dev, "send %d bytes...\n", send_at_once);
 		for (; send_at_once; sb++, send_at_once--) {
 			/* set EOF flag before the last word is sent */
-			if (send_at_once == 1)
+			if (send_at_once == 1 && last_block)
 				out_8(&psc->ircr2, 0x01);
 
 			if (tx_buf)
_

Patches currently in -mm which might be from sbabic@denx.de are

spi-mpc52xx_psc_spi-chipselect-bugfix.patch

