From: akpm@linux-foundation.org
Subject: [merged] spi_mpc83xx-add-small-delay-after-asserting-chip-select-line.patch removed from -mm tree
Date: Mon, 22 Jun 2009 10:00:08 -0700
Message-ID: <200906221700.n5MH08qH009405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751994AbZFVRKL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jun 2009 13:10:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, benh@kernel.crashing.org, david-b@pacbell.net, galak@gate.crashing.org, mm-commits@vger.kernel.org


The patch titled
     spi_mpc83xx: add small delay after asserting chip-select line
has been removed from the -mm tree.  Its filename was
     spi_mpc83xx-add-small-delay-after-asserting-chip-select-line.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi_mpc83xx: add small delay after asserting chip-select line
From: Anton Vorontsov <avorontsov@ru.mvista.com>

This is needed for some underlaying GPIO controllers that may be a bit
slow, or if chip-select signal need some time to stabilize.

For what it's worth, we already have the similar delay for chip-select
de-assertion case.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_mpc83xx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/spi/spi_mpc83xx.c~spi_mpc83xx-add-small-delay-after-asserting-chip-select-line drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi_mpc83xx-add-small-delay-after-asserting-chip-select-line
+++ a/drivers/spi/spi_mpc83xx.c
@@ -383,8 +383,10 @@ static void mpc83xx_spi_work(struct work
 					break;
 			}
 
-			if (cs_change)
+			if (cs_change) {
 				mpc83xx_spi_chipselect(spi, BITBANG_CS_ACTIVE);
+				ndelay(nsecs);
+			}
 			cs_change = t->cs_change;
 			if (t->len)
 				status = mpc83xx_spi_bufs(spi, t);
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
linux-next.patch
usb-mutually-exclusive-port_status.patch

