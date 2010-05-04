From: akpm@linux-foundation.org
Subject: + sdhci-enable-multiblock-transfers-in-sdhci-s3c.patch added to -mm tree
Date: Tue, 04 May 2010 16:46:11 -0700
Message-ID: <201005042346.o44NkBHa025965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754259Ab0EDXqd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 May 2010 19:46:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcuelenaere@gmail.com, ben-linux@fluff.org, linux-mmc@vger.kernel.org, thomas.ab@samsung.com


The patch titled
     sdhci: enable multiblock transfers in sdhci-s3c
has been added to the -mm tree.  Its filename is
     sdhci-enable-multiblock-transfers-in-sdhci-s3c.patch

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
Subject: sdhci: enable multiblock transfers in sdhci-s3c
From: Maurus Cuelenaere <mcuelenaere@gmail.com>

Wifi over SDIO doesn't work correctly without multiblock, so enable this. 
This patch depends on the following patches:

Signed-off-by: Maurus Cuelenaere <mcuelenaere@gmail.com>
Cc: Thomas Abraham <thomas.ab@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-s3c.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/mmc/host/sdhci-s3c.c~sdhci-enable-multiblock-transfers-in-sdhci-s3c drivers/mmc/host/sdhci-s3c.c
--- a/drivers/mmc/host/sdhci-s3c.c~sdhci-enable-multiblock-transfers-in-sdhci-s3c
+++ a/drivers/mmc/host/sdhci-s3c.c
@@ -325,9 +325,6 @@ static int __devinit sdhci_s3c_probe(str
 	 * support as well. */
 	host->quirks |= SDHCI_QUIRK_BROKEN_DMA;
 
-	/* PIO currently has problems with multi-block IO */
-	host->quirks |= SDHCI_QUIRK_NO_MULTIBLOCK;
