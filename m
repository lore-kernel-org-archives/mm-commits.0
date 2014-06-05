From: akpm@linux-foundation.org
Subject: [merged]
 mm-dmapoolc-remove-redundant-null-check-for-dev-in-dma_pool_create.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:51:06 -0700
Message-ID: <5390ca2a.kuGVWxME/HuRBdi0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56105 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbaFETvG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:51:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, daeseok.youn@gmail.com

Subject: [merged] mm-dmapoolc-remove-redundant-null-check-for-dev-in-dma_pool_create.patch removed from -mm tree
To: daeseok.youn@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:51:06 -0700


The patch titled
     Subject: mm/dmapool.c: remove redundant NULL check for dev in dma_pool_create()
has been removed from the -mm tree.  Its filename was
     mm-dmapoolc-remove-redundant-null-check-for-dev-in-dma_pool_create.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daeseok Youn <daeseok.youn@gmail.com>
Subject: mm/dmapool.c: remove redundant NULL check for dev in dma_pool_create()

"dev" cannot be NULL because it is already checked before calling
dma_pool_create().

If dev ever was NULL, the code would oops in dev_to_node() after enabling
CONFIG_NUMA.

It is possible that some driver is using dev==NULL and has never been run
on a NUMA machine.  Such a driver is probably outdated, possibly buggy and
will need some attention if it starts triggering NULL derefs.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |   24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff -puN mm/dmapool.c~mm-dmapoolc-remove-redundant-null-check-for-dev-in-dma_pool_create mm/dmapool.c
--- a/mm/dmapool.c~mm-dmapoolc-remove-redundant-null-check-for-dev-in-dma_pool_create
+++ a/mm/dmapool.c
@@ -170,24 +170,16 @@ struct dma_pool *dma_pool_create(const c
 	retval->boundary = boundary;
 	retval->allocation = allocation;
 
-	if (dev) {
-		int ret;
+	INIT_LIST_HEAD(&retval->pools);
 
-		mutex_lock(&pools_lock);
-		if (list_empty(&dev->dma_pools))
-			ret = device_create_file(dev, &dev_attr_pools);
-		else
-			ret = 0;
-		/* note:  not currently insisting "name" be unique */
-		if (!ret)
-			list_add(&retval->pools, &dev->dma_pools);
-		else {
-			kfree(retval);
-			retval = NULL;
-		}
-		mutex_unlock(&pools_lock);
+	mutex_lock(&pools_lock);
+	if (list_empty(&dev->dma_pools) &&
+	    device_create_file(dev, &dev_attr_pools)) {
+		kfree(retval);
+		return NULL;
 	} else
-		INIT_LIST_HEAD(&retval->pools);
+		list_add(&retval->pools, &dev->dma_pools);
+	mutex_unlock(&pools_lock);
 
 	return retval;
 }
_

Patches currently in -mm which might be from daeseok.youn@gmail.com are

origin.patch
linux-next.patch

