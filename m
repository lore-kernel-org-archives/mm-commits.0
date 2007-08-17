From: akpm@linux-foundation.org
Subject: + omap2-mcspi-code-cleanup.patch added to -mm tree
Date: Fri, 17 Aug 2007 14:44:18 -0700
Message-ID: <200708172144.l7HLiID9030845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56656 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755065AbXHQVof (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 17:44:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyungmin.park@samsung.com, dbrownell@users.sourceforge.net


The patch titled
     OMAP2 McSPI code cleanup
has been added to the -mm tree.  Its filename is
     omap2-mcspi-code-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: OMAP2 McSPI code cleanup
From: "Kyungmin Park" <kyungmin.park@samsung.com>

Remove unused variable & write space

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/omap2_mcspi.c |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/spi/omap2_mcspi.c~omap2-mcspi-code-cleanup drivers/spi/omap2_mcspi.c
--- a/drivers/spi/omap2_mcspi.c~omap2-mcspi-code-cleanup
+++ a/drivers/spi/omap2_mcspi.c
@@ -645,7 +645,7 @@ static int omap2_mcspi_setup(struct spi_
 
 	clk_enable(mcspi->ick);
 	clk_enable(mcspi->fck);
-	ret =  omap2_mcspi_setup_transfer(spi, NULL);
+	ret = omap2_mcspi_setup_transfer(spi, NULL);
 	clk_disable(mcspi->fck);
 	clk_disable(mcspi->ick);
 
@@ -693,7 +693,6 @@ static void omap2_mcspi_work(struct work
 		struct spi_device		*spi;
 		struct spi_transfer		*t = NULL;
 		int				cs_active = 0;
-		struct omap2_mcspi_device_config *conf;
 		struct omap2_mcspi_cs		*cs;
 		int				par_override = 0;
 		int				status = 0;
@@ -706,7 +705,6 @@ static void omap2_mcspi_work(struct work
 		spin_unlock_irq(&mcspi->lock);
 
 		spi = m->spi;
-		conf = spi->controller_data;
 		cs = spi->controller_state;
 
 		omap2_mcspi_set_enable(spi, 1);
_

Patches currently in -mm which might be from kyungmin.park@samsung.com are

mips-qemu-network-work-again.patch
git-mtd.patch
omap2-mcspi-code-cleanup.patch
