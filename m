From: akpm@linux-foundation.org
Subject: + mmc-at91_mci-add-missing-linux-highmemh-include.patch added to -mm tree
Date: Fri, 27 Aug 2010 13:15:28 -0700
Message-ID: <201008272015.o7RKFSYK013640@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753358Ab0H0UP5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Aug 2010 16:15:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mkl@pengutronix.de, avictor.za@gmail.com, cjb@laptop.org, nicolas.ferre@atmel.com, wolfgang.mues@auerswald.de


The patch titled
     mmc: at91_mci: add missing linux/highmem.h include
has been added to the -mm tree.  Its filename is
     mmc-at91_mci-add-missing-linux-highmemh-include.patch

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
Subject: mmc: at91_mci: add missing linux/highmem.h include
From: Marc Kleine-Budde <mkl@pengutronix.de>

Fix the following error:

at91_mci.c: In function 'at91_mci_sg_to_dma':
at91_mci.c:236: error: implicit declaration of function 'kmap_atomic'
at91_mci.c:236: error: 'KM_BIO_SRC_IRQ' undeclared (first use in this function)
at91_mci.c:236: error: (Each undeclared identifier is reported only once
at91_mci.c:236: error: for each function it appears in.)
at91_mci.c:236: warning: assignment makes pointer from integer without a cast
at91_mci.c:252: error: implicit declaration of function 'kunmap_atomic'
at91_mci.c: In function 'at91_mci_post_dma_read':
at91_mci.c:302: error: 'KM_BIO_SRC_IRQ' undeclared (first use in this function)
at91_mci.c:302: warning: assignment makes pointer from integer without a cast
at91_mci.c:317: error: implicit declaration of function 'flush_kernel_dcache_page'

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Chris Ball <cjb@laptop.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Andrew Victor <avictor.za@gmail.com>
Cc: Wolfgang Muees <wolfgang.mues@auerswald.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/at91_mci.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/mmc/host/at91_mci.c~mmc-at91_mci-add-missing-linux-highmemh-include drivers/mmc/host/at91_mci.c
--- a/drivers/mmc/host/at91_mci.c~mmc-at91_mci-add-missing-linux-highmemh-include
+++ a/drivers/mmc/host/at91_mci.c
@@ -66,6 +66,7 @@
 #include <linux/clk.h>
 #include <linux/atmel_pdc.h>
 #include <linux/gfp.h>
+#include <linux/highmem.h>
 
 #include <linux/mmc/host.h>
 
_

Patches currently in -mm which might be from mkl@pengutronix.de are

linux-next.patch
mmc-at91_mci-add-missing-linux-highmemh-include.patch

