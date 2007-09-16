From: akpm@linux-foundation.org
Subject: - spi_mpc83xx-hang-fix.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:25:18 -0700
Message-ID: <200709160925.l8G9PIVo009097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56839 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751787AbXIPJZt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:25:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan@gaisler.com, avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net, galak@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     spi_mpc83xx: hang fix
has been removed from the -mm tree.  Its filename was
     spi_mpc83xx-hang-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi_mpc83xx: hang fix
From: Jan Andersson <jan@gaisler.com>

When the spi_mpc83xx driver receives a tx_buf pointer which is NULL, it
only writes one zero filled word to the transmit register.  If the driver
expects to receive more than one word it will wait forever for a second
receive interrupt.  With this patch the controller will shift out zeroes
until all words have been received.

Signed-off-by: Jan Andersson <jan@gaisler.com>
Tested-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_mpc83xx.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/spi/spi_mpc83xx.c~spi_mpc83xx-hang-fix drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi_mpc83xx-hang-fix
+++ a/drivers/spi/spi_mpc83xx.c
@@ -384,11 +384,8 @@ irqreturn_t mpc83xx_spi_irq(s32 irq, voi
 
 	mpc83xx_spi->count -= 1;
 	if (mpc83xx_spi->count) {
-		if (mpc83xx_spi->tx) {
-			u32 word = mpc83xx_spi->get_tx(mpc83xx_spi);
-			mpc83xx_spi_write_reg(&mpc83xx_spi->base->transmit,
-					      word);
-		}
+		u32 word = mpc83xx_spi->get_tx(mpc83xx_spi);
+		mpc83xx_spi_write_reg(&mpc83xx_spi->base->transmit, word);
 	} else {
 		complete(&mpc83xx_spi->done);
 	}
_

Patches currently in -mm which might be from jan@gaisler.com are

origin.patch
