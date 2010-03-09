From: akpm@linux-foundation.org
Subject: [merged] mmc-at91_mci-fix-pointer-errors.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:08:31 -0800
Message-ID: <201003091908.o29J8Vju031447__44751.9000772901$1268161822$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755909Ab0CITJ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:09:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wolfgang.mues@auerswald.de, avictor.za@gmail.com, linux-mmc@vger.kernel.org, nicolas.ferre@atmel.com, mm-commits@vger.kernel.org


The patch titled
     mmc: at91_mci: fix pointer errors
has been removed from the -mm tree.  Its filename was
     mmc-at91_mci-fix-pointer-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


