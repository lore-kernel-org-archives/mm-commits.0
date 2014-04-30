From: akpm@linux-foundation.org
Subject: +
 mm-dmapoolc-remove-redundant-null-check-for-dev-in-dma_pool_create.patch
 added to -mm tree
Date: Wed, 30 Apr 2014 14:19:29 -0700
Message-ID: <536168e1.OGFfMuuJofo0Qhsg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50432 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbaD3VT3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Apr 2014 17:19:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, daeseok.youn@gmail.com

Subject: + mm-dmapoolc-remove-redundant-null-check-for-dev-in-dma_pool_create.patch added to -mm tree
To: daeseok.youn@gmail.com
From: akpm@linux-foundation.org
Date: Wed, 30 Apr 2014 14:19:29 -0700


The patch titled
     Subject: mm/dmapool.c: remove redundant NULL check for dev in dma_pool_create()
has been added to the -mm tree.  Its filename is
     mm-dmapoolc-remove-redundant-null-check-for-dev-in-dma_pool_create.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dmapoolc-remove-redundant-null-check-for-dev-in-dma_pool_create.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dmapoolc-remove-redundant-null-check-for-dev-in-dma_pool_create.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-dmapoolc-remove-redundant-null-check-for-dev-in-dma_pool_create.patch
linux-next.patch

