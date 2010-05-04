From: akpm@linux-foundation.org
Subject: + s3c6410-enable-adma-feature-in-6410-sdhci-controller.patch added to -mm tree
Date: Tue, 04 May 2010 16:46:09 -0700
Message-ID: <201005042346.o44Nk99C025961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754259Ab0EDXqa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 May 2010 19:46:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcuelenaere@gmail.com, ben-linux@fluff.org, linux-mmc@vger.kernel.org, thomas.ab@samsung.com


The patch titled
     mmc: s3c6410: enable ADMA feature in 6410 sdhci controller.
has been added to the -mm tree.  Its filename is
     s3c6410-enable-adma-feature-in-6410-sdhci-controller.patch

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
Subject: mmc: s3c6410: enable ADMA feature in 6410 sdhci controller.
From: Maurus Cuelenaere <mcuelenaere@gmail.com>

Enable the ADMA feature in the 6410 SDHCI controller driver.

Signed-off-by: Maurus Cuelenaere <mcuelenaere@gmail.com>
Signed-off-by: Thomas Abraham <thomas.ab@samsung.com>
Acked-by: Ben Dooks <ben-linux@fluff.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-s3c.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN drivers/mmc/host/sdhci-s3c.c~s3c6410-enable-adma-feature-in-6410-sdhci-controller drivers/mmc/host/sdhci-s3c.c
--- a/drivers/mmc/host/sdhci-s3c.c~s3c6410-enable-adma-feature-in-6410-sdhci-controller
+++ a/drivers/mmc/host/sdhci-s3c.c
@@ -317,12 +317,7 @@ static int __devinit sdhci_s3c_probe(str
 	host->irq = irq;
 
 	/* Setup quirks for the controller */
