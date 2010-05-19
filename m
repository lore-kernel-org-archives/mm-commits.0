From: akpm@linux-foundation.org
Subject: [merged] mmc-at91_mci-modify-cache-flush-routines.patch removed from -mm tree
Date: Wed, 19 May 2010 10:30:36 -0400
Message-ID: <201005191732.o4JHW2Se025707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753807Ab0ESRcJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 13:32:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.ferre@atmel.com, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     mmc: at91_mci: modify cache flush routines
has been removed from the -mm tree.  Its filename was
     mmc-at91_mci-modify-cache-flush-routines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: at91_mci: modify cache flush routines
From: Nicolas Ferre <nicolas.ferre@atmel.com>

As we were using an internal dma flushing routine, this patch changes to
the DMA API flush_kernel_dcache_page().  Driver is able to compile now.

[akpm@linux-foundation.org: flush_kernel_dcache_page() comes before kunmap_atomic()]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/at91_mci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/at91_mci.c~mmc-at91_mci-modify-cache-flush-routines drivers/mmc/host/at91_mci.c
--- a/drivers/mmc/host/at91_mci.c~mmc-at91_mci-modify-cache-flush-routines
+++ a/drivers/mmc/host/at91_mci.c
@@ -314,8 +314,8 @@ static void at91_mci_post_dma_read(struc
 			dmabuf = (unsigned *)tmpv;
 		}
 
+		flush_kernel_dcache_page(sg_page(sg));
 		kunmap_atomic(sgbuffer, KM_BIO_SRC_IRQ);
-		dmac_flush_range((void *)sgbuffer, ((void *)sgbuffer) + amount);
 		data->bytes_xfered += amount;
 		if (size == 0)
 			break;
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

linux-next.patch
mmc-atmel-mci-enable-sd-high-speed-support.patch
mmc-atmel-mci-add-support-for-sdio-interrupts.patch

