From: akpm@linux-foundation.org
Subject: - omap2-mcspi-code-cleanup.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:39:41 -0700
Message-ID: <200710162039.l9GKdfuw015566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49749 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936127AbXJPVHl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kyungmin.park@samsung.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     OMAP2 McSPI code cleanup
has been removed from the -mm tree.  Its filename was
     omap2-mcspi-code-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: OMAP2 McSPI code cleanup
From: "Kyungmin Park" <kyungmin.park@samsung.com>

Remove unused variable & write space

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/omap2_mcspi.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

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

origin.patch
