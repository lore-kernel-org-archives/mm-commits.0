Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5849C77B7C
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 22:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbjEEWjB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 18:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjEEWjA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 18:39:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5929F4493
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 15:38:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E950D6412D
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 22:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F155C433D2;
        Fri,  5 May 2023 22:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683326338;
        bh=W8YVstQuZ9Y/I0o6Y8Kr5iHqH/B51PaNxbfCy/OHyC4=;
        h=Date:To:From:Subject:From;
        b=0X0TqEgiuZLdqiNvn8VchB2it1GgovKj56L1r+H5G46WNUinovUXVrdake49XKXsw
         aFXCftD28PmuiTz1+SA392xiU6JgsSmL6Oofe+74aoemMSz5OJlHK92st0oTbdITyj
         PcZY6phcSe613aRSYRONRLy8Ir5Ju1UkWXmDVyWs=
Date:   Fri, 05 May 2023 15:38:57 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, kbusch@kernel.org,
        hch@lst.de, tonyb@cybernetics.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dmapool-remove-checks-for-dev-==-null.patch removed from -mm tree
Message-Id: <20230505223858.3F155C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: dmapool: remove checks for dev == NULL
has been removed from the -mm tree.  Its filename was
     dmapool-remove-checks-for-dev-==-null.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tony Battersby <tonyb@cybernetics.com>
Subject: dmapool: remove checks for dev == NULL
Date: Thu, 26 Jan 2023 13:51:15 -0800

dmapool originally tried to support pools without a device because
dma_alloc_coherent() supports allocations without a device.  But nobody
ended up using dma pools without a device, and trying to do so will result
in an oops.  So remove the checks for pool->dev == NULL since they are
unneeded bloat.

[kbusch@kernel.org: add check for null dev on create]
Link: https://lkml.kernel.org/r/20230126215125.4069751-3-kbusch@meta.com
Fixes: 2d55c16c0c54 ("dmapool: create/destroy cleanup")
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |   45 ++++++++++++++-------------------------------
 1 file changed, 14 insertions(+), 31 deletions(-)

--- a/mm/dmapool.c~dmapool-remove-checks-for-dev-==-null
+++ a/mm/dmapool.c
@@ -134,6 +134,9 @@ struct dma_pool *dma_pool_create(const c
 	size_t allocation;
 	bool empty = false;
 
+	if (!dev)
+		return NULL;
+
 	if (align == 0)
 		align = 1;
 	else if (align & (align - 1))
@@ -275,7 +278,7 @@ void dma_pool_destroy(struct dma_pool *p
 	mutex_lock(&pools_reg_lock);
 	mutex_lock(&pools_lock);
 	list_del(&pool->pools);
-	if (pool->dev && list_empty(&pool->dev->dma_pools))
+	if (list_empty(&pool->dev->dma_pools))
 		empty = true;
 	mutex_unlock(&pools_lock);
 	if (empty)
@@ -284,12 +287,8 @@ void dma_pool_destroy(struct dma_pool *p
 
 	list_for_each_entry_safe(page, tmp, &pool->page_list, page_list) {
 		if (is_page_busy(page)) {
-			if (pool->dev)
-				dev_err(pool->dev, "%s %s, %p busy\n", __func__,
-					pool->name, page->vaddr);
-			else
-				pr_err("%s %s, %p busy\n", __func__,
-				       pool->name, page->vaddr);
+			dev_err(pool->dev, "%s %s, %p busy\n", __func__,
+				pool->name, page->vaddr);
 			/* leak the still-in-use consistent memory */
 			list_del(&page->page_list);
 			kfree(page);
@@ -351,12 +350,8 @@ void *dma_pool_alloc(struct dma_pool *po
 		for (i = sizeof(page->offset); i < pool->size; i++) {
 			if (data[i] == POOL_POISON_FREED)
 				continue;
-			if (pool->dev)
-				dev_err(pool->dev, "%s %s, %p (corrupted)\n",
-					__func__, pool->name, retval);
-			else
-				pr_err("%s %s, %p (corrupted)\n",
-					__func__, pool->name, retval);
+			dev_err(pool->dev, "%s %s, %p (corrupted)\n",
+				__func__, pool->name, retval);
 
 			/*
 			 * Dump the first 4 bytes even if they are not
@@ -411,12 +406,8 @@ void dma_pool_free(struct dma_pool *pool
 	page = pool_find_page(pool, dma);
 	if (!page) {
 		spin_unlock_irqrestore(&pool->lock, flags);
-		if (pool->dev)
-			dev_err(pool->dev, "%s %s, %p/%pad (bad dma)\n",
-				__func__, pool->name, vaddr, &dma);
-		else
-			pr_err("%s %s, %p/%pad (bad dma)\n",
-			       __func__, pool->name, vaddr, &dma);
+		dev_err(pool->dev, "%s %s, %p/%pad (bad dma)\n",
+			__func__, pool->name, vaddr, &dma);
 		return;
 	}
 
@@ -426,12 +417,8 @@ void dma_pool_free(struct dma_pool *pool
 #ifdef	DMAPOOL_DEBUG
 	if ((dma - page->dma) != offset) {
 		spin_unlock_irqrestore(&pool->lock, flags);
-		if (pool->dev)
-			dev_err(pool->dev, "%s %s, %p (bad vaddr)/%pad\n",
-				__func__, pool->name, vaddr, &dma);
-		else
-			pr_err("%s %s, %p (bad vaddr)/%pad\n",
-			       __func__, pool->name, vaddr, &dma);
+		dev_err(pool->dev, "%s %s, %p (bad vaddr)/%pad\n",
+			__func__, pool->name, vaddr, &dma);
 		return;
 	}
 	{
@@ -442,12 +429,8 @@ void dma_pool_free(struct dma_pool *pool
 				continue;
 			}
 			spin_unlock_irqrestore(&pool->lock, flags);
-			if (pool->dev)
-				dev_err(pool->dev, "%s %s, dma %pad already free\n",
-					__func__, pool->name, &dma);
-			else
-				pr_err("%s %s, dma %pad already free\n",
-				       __func__, pool->name, &dma);
+			dev_err(pool->dev, "%s %s, dma %pad already free\n",
+				__func__, pool->name, &dma);
 			return;
 		}
 	}
_

Patches currently in -mm which might be from tonyb@cybernetics.com are


