From: akpm@linux-foundation.org
Subject: - spi-at25-do-not-use-pointer-before-assignment.patch removed from -mm tree
Date: Sun, 18 Mar 2007 01:09:31 -0800
Message-ID: <200703180909.l2I99V7i020013@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60430 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139AbXCRJJk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 05:09:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     SPI: at25: do not use pointer before assignment
has been removed from the -mm tree.  Its filename was
     spi-at25-do-not-use-pointer-before-assignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SPI: at25: do not use pointer before assignment
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Prevents a potential oops with CONFIG_SPI_DEBUG given flakey hardware or
incorrect configuration.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/at25.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/at25.c~spi-at25-do-not-use-pointer-before-assignment drivers/spi/at25.c
--- a/drivers/spi/at25.c~spi-at25-do-not-use-pointer-before-assignment
+++ a/drivers/spi/at25.c
@@ -291,7 +291,7 @@ static int at25_probe(struct spi_device 
 	 */
 	sr = spi_w8r8(spi, AT25_RDSR);
 	if (sr < 0 || sr & AT25_SR_nRDY) {
-		dev_dbg(&at25->spi->dev, "rdsr --> %d (%02x)\n", sr, sr);
+		dev_dbg(&spi->dev, "rdsr --> %d (%02x)\n", sr, sr);
 		err = -ENXIO;
 		goto fail;
 	}
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
git-kbuild.patch
git-netdev-all.patch
8139too-fix-irq-problem-with-napi-netpoll.patch
serial-allocate-minor-device-numbers-for.patch
