From: akpm@linux-foundation.org
Subject: [merged] pxa2xx_spi-restore-drcmr-on-resume.patch removed from -mm tree
Date: Wed, 22 Apr 2009 11:30:21 -0700
Message-ID: <200904221830.n3MIULhT006134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753231AbZDVScz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 14:32:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drwyrm@gmail.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     pxa2xx_spi: restore DRCMR on resume
has been removed from the -mm tree.  Its filename was
     pxa2xx_spi-restore-drcmr-on-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pxa2xx_spi: restore DRCMR on resume
From: Daniel Ribeiro <drwyrm@gmail.com>

If DMA is enabled, any spi_sync call after suspend/resume would block forever,
because DRCMR is lost on suspend. This patch restores DRCMR to the same values
set by probe.

Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/pxa2xx_spi.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/spi/pxa2xx_spi.c~pxa2xx_spi-restore-drcmr-on-resume drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~pxa2xx_spi-restore-drcmr-on-resume
+++ a/drivers/spi/pxa2xx_spi.c
@@ -1700,6 +1700,13 @@ static int pxa2xx_spi_resume(struct plat
 	struct ssp_device *ssp = drv_data->ssp;
 	int status = 0;
 
+	if (drv_data->rx_channel != -1)
+		DRCMR(drv_data->ssp->drcmr_rx) =
+			DRCMR_MAPVLD | drv_data->rx_channel;
+	if (drv_data->tx_channel != -1)
+		DRCMR(drv_data->ssp->drcmr_tx) =
+			DRCMR_MAPVLD | drv_data->tx_channel;
+
 	/* Enable the SSP clock */
 	clk_enable(ssp->clk);
 
_

Patches currently in -mm which might be from drwyrm@gmail.com are

linux-next.patch

