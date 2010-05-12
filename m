From: akpm@linux-foundation.org
Subject: + mmc-at91_mci-modify-cache-flush-routines.patch added to -mm tree
Date: Wed, 12 May 2010 15:32:33 -0700
Message-ID: <201005122232.o4CMWX2q024624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758373Ab0ELWcj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 18:32:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas.ferre@atmel.com, James.Bottomley@HansenPartnership.com


The patch titled
     mmc: at91_mci: modify cache flush routines
has been added to the -mm tree.  Its filename is
     mmc-at91_mci-modify-cache-flush-routines.patch

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
Subject: mmc: at91_mci: modify cache flush routines
From: Nicolas Ferre <nicolas.ferre@atmel.com>

As we were using an internal dma flushing routine, this patch changes to
the DMA API flush_kernel_dcache_page().  Driver is able to compile now.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/at91_mci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/at91_mci.c~mmc-at91_mci-modify-cache-flush-routines drivers/mmc/host/at91_mci.c
--- a/drivers/mmc/host/at91_mci.c~mmc-at91_mci-modify-cache-flush-routines
+++ a/drivers/mmc/host/at91_mci.c
@@ -315,7 +315,7 @@ static void at91_mci_post_dma_read(struc
 		}
 
 		kunmap_atomic(sgbuffer, KM_BIO_SRC_IRQ);
-		dmac_flush_range((void *)sgbuffer, ((void *)sgbuffer) + amount);
+		flush_kernel_dcache_page(sg_page(sg));
 		data->bytes_xfered += amount;
 		if (size == 0)
 			break;
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

origin.patch
mmc-at91_mci-modify-cache-flush-routines.patch
mmc-at91_mci-modify-cache-flush-routines-fix.patch
linux-next.patch
mmc-atmel-mci-enable-sd-high-speed-support.patch
mmc-atmel-mci-add-support-for-sdio-interrupts.patch

