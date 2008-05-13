From: akpm@linux-foundation.org
Subject: - spi-pxa2xx_spi-clock-resume-bugfix.patch removed from -mm tree
Date: Tue, 13 May 2008 14:32:57 -0700
Message-ID: <200805132132.m4DLWvkc000765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761638AbYEMVdY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:33:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebenard@free.fr, dbrownell@users.sourceforge.net, nforrester@whoi.edu, stephen@streetfiresound.com, mm-commits@vger.kernel.org


The patch titled
     spi: pxa2xx_spi clock resume bugfix
has been removed from the -mm tree.  Its filename was
     spi-pxa2xx_spi-clock-resume-bugfix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: pxa2xx_spi clock resume bugfix
From: Eric BENARD <ebenard@free.fr>

There is a typo in pxa2xx_spi.c, comment says "Enable the SSP clock", code
says: clk_disable ...  so after resume, the SSP is dead.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Ned Forrester <nforrester@whoi.edu>
Cc: Stephen Street <stephen@streetfiresound.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/pxa2xx_spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/pxa2xx_spi.c~spi-pxa2xx_spi-clock-resume-bugfix drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~spi-pxa2xx_spi-clock-resume-bugfix
+++ a/drivers/spi/pxa2xx_spi.c
@@ -1567,7 +1567,7 @@ static int pxa2xx_spi_resume(struct plat
 	int status = 0;
 
 	/* Enable the SSP clock */
-	clk_disable(ssp->clk);
+	clk_enable(ssp->clk);
 
 	/* Start the queue running */
 	status = start_queue(drv_data);
_

Patches currently in -mm which might be from ebenard@free.fr are

origin.patch

