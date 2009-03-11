From: akpm@linux-foundation.org
Subject: + s3cmci-fix-s3c2410_dma_config-arguments.patch added to -mm tree
Date: Wed, 11 Mar 2009 13:37:54 -0700
Message-ID: <200903112037.n2BKbsCJ001367@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751354AbZCKUro (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 16:47:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@simtec.co.uk, drzeus@drzeus.cx


The patch titled
     mmc: s3cmci: fix s3c2410_dma_config() arguments.
has been added to the -mm tree.  Its filename is
     s3cmci-fix-s3c2410_dma_config-arguments.patch

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
Subject: mmc: s3cmci: fix s3c2410_dma_config() arguments.
From: Ben Dooks <ben@simtec.co.uk>

The s3cmci driver is calling s3c2410_dma_config with incorrect data for
the DCON register.  The S3C2410_DCON_HWTRIG is implicit in the channel
configuration and the device selection of S3C2410_DCON_CH0_SDI is
incorrect as the DMA system may not select channel 0.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/s3cmci.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/mmc/host/s3cmci.c~s3cmci-fix-s3c2410_dma_config-arguments drivers/mmc/host/s3cmci.c
--- a/drivers/mmc/host/s3cmci.c~s3cmci-fix-s3c2410_dma_config-arguments
+++ a/drivers/mmc/host/s3cmci.c
@@ -793,8 +793,7 @@ static void s3cmci_dma_setup(struct s3cm
 			      host->mem->start + host->sdidata);
 
 	if (!setup_ok) {
-		s3c2410_dma_config(host->dma, 4,
-			(S3C2410_DCON_HWTRIG | S3C2410_DCON_CH0_SDI));
+		s3c2410_dma_config(host->dma, 4, 0);
 		s3c2410_dma_set_buffdone_fn(host->dma,
 					    s3cmci_dma_done_callback);
 		s3c2410_dma_setflags(host->dma, S3C2410_DMAF_AUTOSTART);
_

Patches currently in -mm which might be from ben@simtec.co.uk are

linux-next.patch
s3cmci-fix-s3c2410_dma_config-arguments.patch

