From: akpm@linux-foundation.org
Subject: + mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch added to -mm tree
Date: Tue, 13 Nov 2012 17:00:18 -0800
Message-ID: <20121114010019.2F5A1100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:35994 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052Ab2KNBAU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Nov 2012 20:00:20 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so931931qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Nov 2012 17:00:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xi.wang@gmail.com, rientjes@google.com


The patch titled
     Subject: mm/dmapool.c: fix null dev in dma_pool_create()
has been added to the -mm tree.  Its filename is
     mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -133,6 +133,7 @@ struct dma_pool *dma_pool_create(const c
 {
 	struct dma_pool *retval;
 	size_t allocation;
+	int node;
 
 	if (align == 0) {
 		align = 1;
@@ -157,7 +158,9 @@ struct dma_pool *dma_pool_create(const c
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

linux-next.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch

