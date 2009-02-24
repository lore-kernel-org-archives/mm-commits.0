From: akpm@linux-foundation.org
Subject: + spi_imx-set-spi_masterdma_alignment-=-4.patch added to -mm tree
Date: Tue, 24 Feb 2009 12:40:37 -0800
Message-ID: <200902242040.n1OKeb9p009369@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757984AbZBXUkt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 15:40:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike@compulab.co.il, bryan.wu@analog.com, david-b@pacbell.net


The patch titled
     spi_imx: set spi_master.dma_alignment = 4
has been added to the -mm tree.  Its filename is
     spi_imx-set-spi_masterdma_alignment-=-4.patch

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
Subject: spi_imx: set spi_master.dma_alignment = 4
From: Mike Rapoport <mike@compulab.co.il>

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Cc: Bryan Wu <bryan.wu@analog.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_imx.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/spi/spi_imx.c~spi_imx-set-spi_masterdma_alignment-=-4 drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi_imx-set-spi_masterdma_alignment-=-4
+++ a/drivers/spi/spi_imx.c
@@ -186,6 +186,7 @@
 #define QUEUE_STOPPED			(1)
 
 #define IS_DMA_ALIGNED(x) 		(((u32)(x) & 0x03) == 0)
+#define DMA_ALIGNMENT			4
 /*-------------------------------------------------------------------------*/
 
 
@@ -1482,6 +1483,7 @@ static int __init spi_imx_probe(struct p
 
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

