From: akpm@linux-foundation.org
Subject: + spi-pxa2xx_spi-buildfix.patch added to -mm tree
Date: Tue, 23 Sep 2008 02:02:03 -0700
Message-ID: <200809230902.m8N923uU024456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750822AbYIWJCu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Sep 2008 05:02:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike@compulab.co.il, dbrownell@users.sourceforge.net, eric.miao@marvell.com


The patch titled
     spi: pxa2xx_spi buildfix
has been added to the -mm tree.  Its filename is
     spi-pxa2xx_spi-buildfix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: pxa2xx_spi buildfix
From: Mike Rapoport <mike@compulab.co.il>

Fix a build error in the pxa2xx-spi driver, introduced by commit
7e96445533ac3f4f7964646a202ff3620602fab4 ("pxa2xx_spi: dma bugfixes").


[dbrownell@users.sourceforge.net: fix sparse warning too]
Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Acked-by: Eric Miao <eric.miao@marvell.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/pxa2xx_spi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/spi/pxa2xx_spi.c~spi-pxa2xx_spi-buildfix drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~spi-pxa2xx_spi-buildfix
+++ a/drivers/spi/pxa2xx_spi.c
@@ -49,7 +49,7 @@ MODULE_ALIAS("platform:pxa2xx-spi");
 
 #define DMA_INT_MASK		(DCSR_ENDINTR | DCSR_STARTINTR | DCSR_BUSERR)
 #define RESET_DMA_CHANNEL	(DCSR_NODESC | DMA_INT_MASK)
-#define IS_DMA_ALIGNED(x)	(((x) & 0x07) == 0)
+#define IS_DMA_ALIGNED(x)	((((u32)(x)) & 0x07) == 0)
 #define MAX_DMA_LEN		8191
 
 /*
@@ -896,7 +896,7 @@ static void pump_transfers(unsigned long
 				|| transfer->rx_dma || transfer->tx_dma) {
 			dev_err(&drv_data->pdev->dev,
 				"pump_transfers: mapped transfer length "
-				"of %lu is greater than %d\n",
+				"of %u is greater than %d\n",
 				transfer->len, MAX_DMA_LEN);
 			message->status = -EINVAL;
 			giveback(drv_data);
_

Patches currently in -mm which might be from mike@compulab.co.il are

spi-pxa2xx_spi-buildfix.patch
linux-next.patch

