From: akpm@linux-foundation.org
Subject: + drivers-dma-iop-admac-fix-new-warnings.patch added to -mm tree
Date: Mon, 08 Jul 2013 14:11:56 -0700
Message-ID: <51db2b1c.SqRD8myaVzeGWquY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52555 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3GHVL5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 17:11:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sebastian.hesselbarth@gmail.com, kyungmin.park@samsung.com, b.zolnierkie@samsung.com, olof@lixom.net

Subject: + drivers-dma-iop-admac-fix-new-warnings.patch added to -mm tree
To: olof@lixom.net,b.zolnierkie@samsung.com,kyungmin.park@samsung.com,sebastian.hesselbarth@gmail.com
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 14:11:56 -0700


The patch titled
     Subject: drivers/dma/iop-adma.c: fix new warnings
has been added to the -mm tree.  Its filename is
     drivers-dma-iop-admac-fix-new-warnings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-dma-iop-admac-fix-new-warnings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-dma-iop-admac-fix-new-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Olof Johansson <olof@lixom.net>
Subject: drivers/dma/iop-adma.c: fix new warnings

The recent "drivers/dma: remove unused support for MEMSET operations"
change has fallout from lack of build testing by the author.  This fixes:

drivers/dma/iop-adma.c:1020:13: warning: unused variable 'dma_addr' [-Wunused-variable]
drivers/dma/iop-adma.c:1519:2: warning: format '%s' expects a matching 'char *' argument [-Wformat=]

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/iop-adma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/dma/iop-adma.c~drivers-dma-iop-admac-fix-new-warnings drivers/dma/iop-adma.c
--- a/drivers/dma/iop-adma.c~drivers-dma-iop-admac-fix-new-warnings
+++ a/drivers/dma/iop-adma.c
@@ -1017,7 +1017,7 @@ iop_adma_xor_val_self_test(struct iop_ad
 	struct page *xor_srcs[IOP_ADMA_NUM_SRC_TEST];
 	struct page *zero_sum_srcs[IOP_ADMA_NUM_SRC_TEST + 1];
 	dma_addr_t dma_srcs[IOP_ADMA_NUM_SRC_TEST + 1];
-	dma_addr_t dma_addr, dest_dma;
+	dma_addr_t dest_dma;
 	struct dma_async_tx_descriptor *tx;
 	struct dma_chan *dma_chan;
 	dma_cookie_t cookie;
@@ -1516,7 +1516,7 @@ static int iop_adma_probe(struct platfor
 			goto err_free_iop_chan;
 	}
 
-	dev_info(&pdev->dev, "Intel(R) IOP: ( %s%s%s%s%s%s%s)\n",
+	dev_info(&pdev->dev, "Intel(R) IOP: ( %s%s%s%s%s%s)\n",
 		 dma_has_cap(DMA_PQ, dma_dev->cap_mask) ? "pq " : "",
 		 dma_has_cap(DMA_PQ_VAL, dma_dev->cap_mask) ? "pq_val " : "",
 		 dma_has_cap(DMA_XOR, dma_dev->cap_mask) ? "xor " : "",
_

Patches currently in -mm which might be from olof@lixom.net are

origin.patch
drivers-dma-iop-admac-fix-new-warnings.patch
linux-next.patch

