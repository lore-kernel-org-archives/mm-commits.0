Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 468D5C77B7D
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 22:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbjEEWjV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 18:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233468AbjEEWjQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 18:39:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0568F5FDC
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 15:39:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96D1D6416B
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 22:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5F3C433D2;
        Fri,  5 May 2023 22:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683326352;
        bh=HocBjoGz3gKZdyLumS53Y2Iu/TrrnD47VPlsQJ65pOo=;
        h=Date:To:From:Subject:From;
        b=RK00q9JHtDueC+TduPFSzjitd9eleTkgZEFvpjRn6ndJBsuev6aueOQTqRv8C4etw
         N/6nt5rch5J9TBIugVaJiedCIecAY3zHtwwIerpBDv492P9wUQ7alzzH8Pt1osqrBV
         BZiWwne55CknC0wHCgvcGaguggKr9MxHPnhyBGI4=
Date:   Fri, 05 May 2023 15:39:11 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tonyb@cybernetics.com, hch@lst.de, kbusch@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dmapool-create-destroy-cleanup.patch removed from -mm tree
Message-Id: <20230505223911.ED5F3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: dmapool: create/destroy cleanup
has been removed from the -mm tree.  Its filename was
     dmapool-create-destroy-cleanup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Keith Busch <kbusch@kernel.org>
Subject: dmapool: create/destroy cleanup
Date: Thu, 26 Jan 2023 13:51:25 -0800

Set the 'empty' bool directly from the result of the function that
determines its value instead of adding additional logic.

Link: https://lkml.kernel.org/r/20230126215125.4069751-13-kbusch@meta.com
Fixes: 2d55c16c0c54 ("dmapool: create/destroy cleanup")
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/dmapool.c~dmapool-create-destroy-cleanup
+++ a/mm/dmapool.c
@@ -226,7 +226,7 @@ struct dma_pool *dma_pool_create(const c
 {
 	struct dma_pool *retval;
 	size_t allocation;
-	bool empty = false;
+	bool empty;
 
 	if (!dev)
 		return NULL;
@@ -276,8 +276,7 @@ struct dma_pool *dma_pool_create(const c
 	 */
 	mutex_lock(&pools_reg_lock);
 	mutex_lock(&pools_lock);
-	if (list_empty(&dev->dma_pools))
-		empty = true;
+	empty = list_empty(&dev->dma_pools);
 	list_add(&retval->pools, &dev->dma_pools);
 	mutex_unlock(&pools_lock);
 	if (empty) {
@@ -361,7 +360,7 @@ static struct dma_page *pool_alloc_page(
 void dma_pool_destroy(struct dma_pool *pool)
 {
 	struct dma_page *page, *tmp;
-	bool empty = false, busy = false;
+	bool empty, busy = false;
 
 	if (unlikely(!pool))
 		return;
@@ -369,8 +368,7 @@ void dma_pool_destroy(struct dma_pool *p
 	mutex_lock(&pools_reg_lock);
 	mutex_lock(&pools_lock);
 	list_del(&pool->pools);
-	if (list_empty(&pool->dev->dma_pools))
-		empty = true;
+	empty = list_empty(&pool->dev->dma_pools);
 	mutex_unlock(&pools_lock);
 	if (empty)
 		device_remove_file(pool->dev, &dev_attr_pools);
_

Patches currently in -mm which might be from kbusch@kernel.org are


