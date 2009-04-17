From: akpm@linux-foundation.org
Subject: + pxa2xx_spi-restore-drcmr-on-resume.patch added to -mm tree
Date: Fri, 17 Apr 2009 11:39:04 -0700
Message-ID: <200904171839.n3HId4LK031241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754846AbZDQSlM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Apr 2009 14:41:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drwyrm@gmail.com, dbrownell@users.sourceforge.net


The patch titled
     pxa2xx_spi: restore DRCMR on resume
has been added to the -mm tree.  Its filename is
     pxa2xx_spi-restore-drcmr-on-resume.patch

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

pxa2xx_spi-fix-kernel-freeze-regression.patch
pxa2xx_spi-restore-drcmr-on-resume.patch
linux-next.patch

