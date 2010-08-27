From: akpm@linux-foundation.org
Subject: + arm-samsung-mmc-fix-build-error-when-both-dma-and-pio-mode-selected.patch added to -mm tree
Date: Fri, 27 Aug 2010 13:03:39 -0700
Message-ID: <201008272003.o7RK3d33013124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752758Ab0H0UD4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Aug 2010 16:03:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jiri.pinkava@vscht.cz, cjb@laptop.org, linux-mmc@vger.kernel.org, matt@console-pimps.org, rmk@arm.linux.org.uk


The patch titled
     ARM: SAMSUNG: MMC: fix build error when both DMA and PIO mode selected
has been added to the -mm tree.  Its filename is
     arm-samsung-mmc-fix-build-error-when-both-dma-and-pio-mode-selected.patch

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
Subject: ARM: SAMSUNG: MMC: fix build error when both DMA and PIO mode selected
From: Jiri Pinkava <jiri.pinkava@vscht.cz>

Date: Tue, 25 May 2010 09:48:58 +0200

[cjb: fix line-wrapped patch]
Signed-off-by: Jiri Pinkava <jiri.pinkava@vscht.cz>
Signed-off-by: Chris Ball <cjb@laptop.org>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/s3cmci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/s3cmci.c~arm-samsung-mmc-fix-build-error-when-both-dma-and-pio-mode-selected drivers/mmc/host/s3cmci.c
--- a/drivers/mmc/host/s3cmci.c~arm-samsung-mmc-fix-build-error-when-both-dma-and-pio-mode-selected
+++ a/drivers/mmc/host/s3cmci.c
@@ -1600,7 +1600,7 @@ static int __devinit s3cmci_probe(struct
 	host->pio_active 	= XFER_NONE;
 
 #ifdef CONFIG_MMC_S3C_PIODMA
-	host->dodma		= host->pdata->dma;
+	host->dodma		= host->pdata->use_dma;
 #endif
 
 	host->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
_

Patches currently in -mm which might be from jiri.pinkava@vscht.cz are

arm-samsung-mmc-fix-build-error-when-both-dma-and-pio-mode-selected.patch

