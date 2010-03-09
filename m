From: akpm@linux-foundation.org
Subject: [merged] mmc-at91_mci-correct-kunmap_atomic.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:08:53 -0800
Message-ID: <201003091908.o29J8rJ3031479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755909Ab0CITKC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:10:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.ferre@atmel.com, avictor.za@gmail.com, linux-mmc@vger.kernel.org, wolfgang.mues@auerswald.de, mm-commits@vger.kernel.org


The patch titled
     mmc: at91_mci: correct kunmap_atomic()
has been removed from the -mm tree.  Its filename was
     mmc-at91_mci-correct-kunmap_atomic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


