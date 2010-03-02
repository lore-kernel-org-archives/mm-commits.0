From: akpm@linux-foundation.org
Subject: [merged] dmatest-correct-raid6-pq-test.patch removed from -mm tree
Date: Tue, 02 Mar 2010 11:11:18 -0800
Message-ID: <201003021911.o22JBIZ3024353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751331Ab0CBTM7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Mar 2010 14:12:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agust@denx.de, dan.j.williams@intel.com, maciej.sosnowski@intel.com, mm-commits@vger.kernel.org


The patch titled
     dmatest: correct raid6 PQ test
has been removed from the -mm tree.  Its filename was
     dmatest-correct-raid6-pq-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dmatest: correct raid6 PQ test
From: Anatolij Gustschin <agust@denx.de>

The number of PQ sources specified by module parameter "pq_sources" is
always forced odd to fit into dmatest's destination verificaton scheme. 
But number of PQ sources and coefficients as passed to the driver's
prep_dma_pq() is not adjusted accordingly.

Fix it now to get correct PQ testing results in the case passed
"pq_sources" parameter is even.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/dmatest.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/dma/dmatest.c~dmatest-correct-raid6-pq-test drivers/dma/dmatest.c
--- a/drivers/dma/dmatest.c~dmatest-correct-raid6-pq-test
+++ a/drivers/dma/dmatest.c
@@ -237,7 +237,7 @@ static int dmatest_func(void *data)
 	dma_cookie_t		cookie;
 	enum dma_status		status;
 	enum dma_ctrl_flags 	flags;
-	u8			pq_coefs[pq_sources];
+	u8			pq_coefs[pq_sources + 1];
 	int			ret;
 	int			src_cnt;
 	int			dst_cnt;
@@ -257,7 +257,7 @@ static int dmatest_func(void *data)
 	} else if (thread->type == DMA_PQ) {
 		src_cnt = pq_sources | 1; /* force odd to ensure dst = src */
 		dst_cnt = 2;
-		for (i = 0; i < pq_sources; i++)
+		for (i = 0; i < src_cnt; i++)
 			pq_coefs[i] = 1;
 	} else
 		goto err_srcs;
@@ -355,7 +355,7 @@ static int dmatest_func(void *data)
 			for (i = 0; i < dst_cnt; i++)
 				dma_pq[i] = dma_dsts[i] + dst_off;
 			tx = dev->device_prep_dma_pq(chan, dma_pq, dma_srcs,
-						     pq_sources, pq_coefs,
+						     src_cnt, pq_coefs,
 						     len, flags);
 		}
 
_

Patches currently in -mm which might be from agust@denx.de are

origin.patch
linux-next.patch

