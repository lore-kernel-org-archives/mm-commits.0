From: akpm@linux-foundation.org
Subject: + mmc-at91_mci-fix-pointer-errors.patch added to -mm tree
Date: Tue, 02 Mar 2010 13:34:57 -0800
Message-ID: <201003022134.o22LYvq6030817__36025.9156128906$1267565792$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752552Ab0CBVfe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Mar 2010 16:35:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wolfgang.mues@auerswald.de, avictor.za@gmail.com, linux-mmc@vger.kernel.org, nicolas.ferre@atmel.com


The patch titled
     mmc: at91_mci: fix pointer errors
has been added to the -mm tree.  Its filename is
     mmc-at91_mci-fix-pointer-errors.patch

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
Subject: mmc: at91_mci: fix pointer errors
From: Wolfgang Muees <wolfgang.mues@auerswald.de>

Fixes two pointer errors, one which leads to memory overwrites if used
with large chunks of data.

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Andrew Victor <avictor.za@gmail.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/at91_mci.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/mmc/host/at91_mci.c~mmc-at91_mci-fix-pointer-errors drivers/mmc/host/at91_mci.c
--- a/drivers/mmc/host/at91_mci.c~mmc-at91_mci-fix-pointer-errors
+++ a/drivers/mmc/host/at91_mci.c
@@ -227,11 +227,13 @@ static inline void at91_mci_sg_to_dma(st
 			for (index = 0; index < (amount / 4); index++)
 				*dmabuf++ = swab32(sgbuffer[index]);
 		} else {
-			memcpy(dmabuf, sgbuffer, amount);
-			dmabuf += amount;
+			char *tmpv = (char *)dmabuf;
+			memcpy(tmpv, sgbuffer, amount);
+			tmpv += amount;
+			dmabuf = (unsigned *)tmpv;
 		}
 
-		kunmap_atomic(sgbuffer, KM_BIO_SRC_IRQ);
+		kunmap_atomic(((void *)sgbuffer) - sg->offset, KM_BIO_SRC_IRQ);
 
 		if (size == 0)
 			break;
_

Patches currently in -mm which might be from wolfgang.mues@auerswald.de are

mmc-at91_mci-fix-pointer-errors.patch
mmc-at91_mci-fix-timeout-errors.patch
mmc-at91_mci-use-one-coherent-dma-buffer.patch
mmc-at91_mci-use-dma-buffer-for-read.patch
mmc-at91_mci-enable-large-data-blocks.patch
mmc-at91_mci-enable-mmc_cap_sdio_irq-only-when-it-actually-works.patch
mmc-at91_mci-introduce-per-mci-revision-conditional-code.patch

