From: akpm@linux-foundation.org
Subject: [merged]
 mm-dmapool-allow-null-pool-pointer-in-dma_pool_destroy.patch removed from
 -mm tree
Date: Wed, 09 Sep 2015 12:45:40 -0700
Message-ID: <55f08c64.91/32FIgvD9E2Lnl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39029 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbbIITpl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:45:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, joe@perches.com, julia.lawall@lip6.fr, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/dmapool: allow NULL `pool' pointer in dma_pool_destroy()
has been removed from the -mm tree.  Its filename was
     mm-dmapool-allow-null-pool-pointer-in-dma_pool_destroy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: mm/dmapool: allow NULL `pool' pointer in dma_pool_destroy()

dma_pool_destroy() does not tolerate a NULL dma_pool pointer argument and
performs a NULL-pointer dereference.  This requires additional attention
and effort from developers/reviewers and forces all dma_pool_destroy()
callers to do a NULL check

	if (pool)
		dma_pool_destroy(pool);

Or, otherwise, be invalid dma_pool_destroy() users.

Tweak dma_pool_destroy() and NULL-check the pointer there.

Proposed by Andrew Morton.

Link: https://lkml.org/lkml/2015/6/8/583
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/dmapool.c~mm-dmapool-allow-null-pool-pointer-in-dma_pool_destroy mm/dmapool.c
--- a/mm/dmapool.c~mm-dmapool-allow-null-pool-pointer-in-dma_pool_destroy
+++ a/mm/dmapool.c
@@ -271,6 +271,9 @@ void dma_pool_destroy(struct dma_pool *p
 {
 	bool empty = false;
 
+	if (unlikely(!pool))
+		return;
+
 	mutex_lock(&pools_reg_lock);
 	mutex_lock(&pools_lock);
 	list_del(&pool->pools);
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are


