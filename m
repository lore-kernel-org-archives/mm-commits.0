From: akpm@linux-foundation.org
Subject: + spi-at25-do-not-use-pointer-before-assignment.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:48:07 -0800
Message-ID: <200703151848.l2FIm9rm023222@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35272 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbXCOSs1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:48:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, dbrownell@users.sourceforge.net


The patch titled
     SPI: at25: do not use pointer before assignment
has been added to the -mm tree.  Its filename is
     spi-at25-do-not-use-pointer-before-assignment.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

spi-at25-do-not-use-pointer-before-assignment.patch
git-netdev-all.patch
tc35815-fix-an-usage-of-streaming-dma-api.patch
tc35815-fix-an-usage-of-streaming-dma-api-tidy.patch
8139too-fix-irq-problem-with-napi-netpoll.patch
x86_64-fix-section-mismatch-warnings.patch
serial-allocate-minor-device-numbers-for.patch
