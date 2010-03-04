From: akpm@linux-foundation.org
Subject: + mmc-at91_mci-correct-kunmap_atomic.patch added to -mm tree
Date: Thu, 04 Mar 2010 12:42:15 -0800
Message-ID: <201003042042.o24KgFGL028715__27727.171048946$1267744752$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756378Ab0CDUm0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Mar 2010 15:42:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas.ferre@atmel.com, avictor.za@gmail.com, linux-mmc@vger.kernel.org, wolfgang.mues@auerswald.de


The patch titled
     mmc: at91_mci: correct kunmap_atomic()
has been added to the -mm tree.  Its filename is
     mmc-at91_mci-correct-kunmap_atomic.patch

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
Subject: mmc: at91_mci: correct kunmap_atomic()
From: Nicolas Ferre <nicolas.ferre@atmel.com>

kunmap_atomic() accepts a pointer to any location in the page so we do not
need the subtraction and cast.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Wolfgang Muees <wolfgang.mues@auerswald.de>
Cc: Andrew Victor <avictor.za@gmail.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/at91_mci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/host/at91_mci.c~mmc-at91_mci-correct-kunmap_atomic drivers/mmc/host/at91_mci.c
--- a/drivers/mmc/host/at91_mci.c~mmc-at91_mci-correct-kunmap_atomic
+++ a/drivers/mmc/host/at91_mci.c
@@ -248,7 +248,7 @@ static inline void at91_mci_sg_to_dma(st
 			dmabuf = (unsigned *)tmpv;
 		}
 
-		kunmap_atomic(((void *)sgbuffer) - sg->offset, KM_BIO_SRC_IRQ);
+		kunmap_atomic(sgbuffer, KM_BIO_SRC_IRQ);
 
 		if (size == 0)
 			break;
@@ -313,7 +313,7 @@ static void at91_mci_post_dma_read(struc
 			dmabuf = (unsigned *)tmpv;
 		}
 
-		kunmap_atomic(((void *)sgbuffer)-sg->offset, KM_BIO_SRC_IRQ);
+		kunmap_atomic(sgbuffer, KM_BIO_SRC_IRQ);
 		dmac_flush_range((void *)sgbuffer, ((void *)sgbuffer) + amount);
 		data->bytes_xfered += amount;
 		if (size == 0)
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

mmc-atmel-host-kconfig-cleanup-for-everyone-else.patch
mmc-at91_mci-fix-pointer-errors.patch
mmc-at91_mci-fix-timeout-errors.patch
mmc-at91_mci-use-one-coherent-dma-buffer.patch
mmc-at91_mci-use-dma-buffer-for-read.patch
mmc-at91_mci-enable-large-data-blocks.patch
mmc-at91_mci-enable-mmc_cap_sdio_irq-only-when-it-actually-works.patch
mmc-at91_mci-introduce-per-mci-revision-conditional-code.patch
mmc-at91_mci-correct-kunmap_atomic.patch

