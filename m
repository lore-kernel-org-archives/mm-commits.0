From: akpm@linux-foundation.org
Subject: +
 drivers-dma-mmp_tdmac-use-gen_pool_dma_alloc-to-allocate-descriptor.patch
 added to -mm tree
Date: Mon, 04 Nov 2013 14:17:11 -0800
Message-ID: <52781ce7.JMfovjPZ7k17RF73%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3KDWRM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Nov 2013 17:17:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vinod.koul@intel.com, grant.likely@linaro.org, dan.j.williams@intel.com, b42378@freescale.com

Subject: + drivers-dma-mmp_tdmac-use-gen_pool_dma_alloc-to-allocate-descriptor.patch added to -mm tree
To: b42378@freescale.com,dan.j.williams@intel.com,grant.likely@linaro.org,vinod.koul@intel.com
From: akpm@linux-foundation.org
Date: Mon, 04 Nov 2013 14:17:11 -0800


The patch titled
     Subject: drivers/dma/mmp_tdma.c: use gen_pool_dma_alloc() to allocate descriptor
has been added to the -mm tree.  Its filename is
     drivers-dma-mmp_tdmac-use-gen_pool_dma_alloc-to-allocate-descriptor.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-dma-mmp_tdmac-use-gen_pool_dma_alloc-to-allocate-descriptor.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-dma-mmp_tdmac-use-gen_pool_dma_alloc-to-allocate-descriptor.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicolin Chen <b42378@freescale.com>
Subject: drivers/dma/mmp_tdma.c: use gen_pool_dma_alloc() to allocate descriptor

Since gen_pool_dma_alloc() is introduced, we implement it to simplify code.

Signed-off-by: Nicolin Chen <b42378@freescale.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/mmp_tdma.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN drivers/dma/mmp_tdma.c~drivers-dma-mmp_tdmac-use-gen_pool_dma_alloc-to-allocate-descriptor drivers/dma/mmp_tdma.c
--- a/drivers/dma/mmp_tdma.c~drivers-dma-mmp_tdmac-use-gen_pool_dma_alloc-to-allocate-descriptor
+++ a/drivers/dma/mmp_tdma.c
@@ -378,12 +378,7 @@ struct mmp_tdma_desc *mmp_tdma_alloc_des
 	if (!gpool)
 		return NULL;
 
-	tdmac->desc_arr = (void *)gen_pool_alloc(gpool, size);
-	if (!tdmac->desc_arr)
-		return NULL;
