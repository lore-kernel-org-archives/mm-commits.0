From: akpm@linux-foundation.org
Subject: + pxa2xx_spi-set-spi_masterdma_alignment-=-8.patch added to -mm tree
Date: Tue, 24 Feb 2009 12:40:35 -0800
Message-ID: <200902242040.n1OKeZOg009366@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756165AbZBXUkt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 15:40:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike@compulab.co.il, bryan.wu@analog.com, david-b@pacbell.net


The patch titled
     pxa2xx_spi: set spi_master.dma_alignment = 8
has been added to the -mm tree.  Its filename is
     pxa2xx_spi-set-spi_masterdma_alignment-=-8.patch

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
Subject: pxa2xx_spi: set spi_master.dma_alignment = 8
From: Mike Rapoport <mike@compulab.co.il>

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Cc: Bryan Wu <bryan.wu@analog.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/pxa2xx_spi.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/spi/pxa2xx_spi.c~pxa2xx_spi-set-spi_masterdma_alignment-=-8 drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~pxa2xx_spi-set-spi_masterdma_alignment-=-8
+++ a/drivers/spi/pxa2xx_spi.c
@@ -54,6 +54,7 @@ MODULE_ALIAS("platform:pxa2xx-spi");
 #define RESET_DMA_CHANNEL	(DCSR_NODESC | DMA_INT_MASK)
 #define IS_DMA_ALIGNED(x)	((((u32)(x)) & 0x07) == 0)
 #define MAX_DMA_LEN		8191
+#define DMA_ALIGNMENT		8
 
 /*
  * for testing SSCR1 changes that require SSP restart, basically
@@ -1498,6 +1499,7 @@ static int __init pxa2xx_spi_probe(struc
 
 	master->bus_num = pdev->id;
 	master->num_chipselect = platform_info->num_chipselect;
+	master->dma_alignment = DMA_ALIGNMENT;
 	master->cleanup = cleanup;
 	master->setup = setup;
 	master->transfer = transfer;
_

Patches currently in -mm which might be from mike@compulab.co.il are

linux-next.patch
spi_bfin5xx-remove-unused-is_dma_aligned-macro.patch
spi-add-dma_alignment-field-to-spi_master.patch
pxa2xx_spi-set-spi_masterdma_alignment-=-8.patch
spi_imx-set-spi_masterdma_alignment-=-4.patch

