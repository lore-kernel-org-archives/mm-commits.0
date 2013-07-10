From: akpm@linux-foundation.org
Subject: [-] mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch removed
 from -mm tree
Date: Wed, 10 Jul 2013 13:25:07 -0700
Message-ID: <51ddc323.fXz8y1XxG1IsXFjO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54695 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab3GJUZH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Jul 2013 16:25:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, xi.wang@gmail.com

Subject: [-] mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch removed from -mm tree
To: xi.wang@gmail.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 10 Jul 2013 13:25:07 -0700


The patch titled
     Subject: mm/dmapool.c: fix null dev in dma_pool_create()
has been removed from the -mm tree.  Its filename was
     mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch

This patch was dropped because it has gone stale

------------------------------------------------------
From: Xi Wang <xi.wang@gmail.com>
Subject: mm/dmapool.c: fix null dev in dma_pool_create()

A few drivers invoke dma_pool_create() with a null dev.  Note that dev is
dereferenced in dev_to_node(dev), causing a null pointer dereference.

A long term solution is to disallow null dev.  Once the drivers are fixed,
we can simplify the core code here.  For now we add WARN_ON(!dev) to
notify the driver maintainers and avoid the null pointer dereference.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/dmapool.c~mm-dmapoolc-fix-null-dev-in-dma_pool_create mm/dmapool.c
--- a/mm/dmapool.c~mm-dmapoolc-fix-null-dev-in-dma_pool_create
+++ a/mm/dmapool.c
@@ -132,6 +132,7 @@ struct dma_pool *dma_pool_create(const c
 {
 	struct dma_pool *retval;
 	size_t allocation;
+	int node;
 
 	if (align == 0) {
 		align = 1;
@@ -156,7 +157,9 @@ struct dma_pool *dma_pool_create(const c
 		return NULL;
 	}
 
-	retval = kmalloc_node(sizeof(*retval), GFP_KERNEL, dev_to_node(dev));
+	node = WARN_ON(!dev) ? -1 : dev_to_node(dev);
+
+	retval = kmalloc_node(sizeof(*retval), GFP_KERNEL, node);
 	if (!retval)
 		return retval;
 
_

Patches currently in -mm which might be from xi.wang@gmail.com are


