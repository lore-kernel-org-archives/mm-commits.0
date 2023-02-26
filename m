Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1F2CC7EE30
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 23:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjBZXtD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Feb 2023 18:49:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjBZXtA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Feb 2023 18:49:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE8C8A77
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 15:48:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81A1BB80C9E
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 23:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9B1C4339B;
        Sun, 26 Feb 2023 23:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677455326;
        bh=6PeQnHz895Ghy4ErdjfczBEiVyeoEZO6xbDtuGK4cfI=;
        h=Date:To:From:Subject:From;
        b=BLky7Stmq9acOUqerXAv2icajWsbfYGM+oWPuF1qVuewI+YzOT0nrd317sB9N3+5Z
         B+smxEe/J4UmaM837eNwEOLxnKcPZ7QWniiLNmqgrApPplsuUdzJaZ5zDm6zazMe/Q
         Gpkzper6qHlgcbRFg5txNvfkm9jtBWv2DML/jBgo=
Date:   Sun, 26 Feb 2023 15:48:45 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tonyb@cybernetics.com, hch@lst.de, kbusch@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dmapool-move-debug-code-to-own-functions.patch removed from -mm tree
Message-Id: <20230226234846.1F9B1C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: dmapool: move debug code to own functions
has been removed from the -mm tree.  Its filename was
     dmapool-move-debug-code-to-own-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Keith Busch <kbusch@kernel.org>
Subject: dmapool: move debug code to own functions
Date: Thu, 26 Jan 2023 13:51:19 -0800

Clean up the normal path by moving the debug code outside it.

Link: https://lkml.kernel.org/r/20230126215125.4069751-7-kbusch@meta.com
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/dmapool.c~dmapool-move-debug-code-to-own-functions
+++ a/mm/dmapool.c
@@ -96,6 +96,78 @@ static ssize_t pools_show(struct device
 
 static DEVICE_ATTR_RO(pools);
 
+#ifdef DMAPOOL_DEBUG
+static void pool_check_block(struct dma_pool *pool, void *retval,
+			     unsigned int offset, gfp_t mem_flags)
+{
+	int i;
+	u8 *data = retval;
+	/* page->offset is stored in first 4 bytes */
+	for (i = sizeof(offset); i < pool->size; i++) {
+		if (data[i] == POOL_POISON_FREED)
+			continue;
+		dev_err(pool->dev, "%s %s, %p (corrupted)\n",
+			__func__, pool->name, retval);
+
+		/*
+		 * Dump the first 4 bytes even if they are not
+		 * POOL_POISON_FREED
+		 */
+		print_hex_dump(KERN_ERR, "", DUMP_PREFIX_OFFSET, 16, 1,
+				data, pool->size, 1);
+		break;
+	}
+	if (!want_init_on_alloc(mem_flags))
+		memset(retval, POOL_POISON_ALLOCATED, pool->size);
+}
+
+static bool pool_page_err(struct dma_pool *pool, struct dma_page *page,
+			  void *vaddr, dma_addr_t dma)
+{
+	unsigned int offset = vaddr - page->vaddr;
+	unsigned int chain = page->offset;
+
+	if ((dma - page->dma) != offset) {
+		dev_err(pool->dev, "%s %s, %p (bad vaddr)/%pad\n",
+			__func__, pool->name, vaddr, &dma);
+		return true;
+	}
+
+	while (chain < pool->allocation) {
+		if (chain != offset) {
+			chain = *(int *)(page->vaddr + chain);
+			continue;
+		}
+		dev_err(pool->dev, "%s %s, dma %pad already free\n",
+			__func__, pool->name, &dma);
+		return true;
+	}
+	memset(vaddr, POOL_POISON_FREED, pool->size);
+	return false;
+}
+
+static void pool_init_page(struct dma_pool *pool, struct dma_page *page)
+{
+	memset(page->vaddr, POOL_POISON_FREED, pool->allocation);
+}
+#else
+static void pool_check_block(struct dma_pool *pool, void *retval,
+			     unsigned int offset, gfp_t mem_flags)
+
+{
+}
+
+static bool pool_page_err(struct dma_pool *pool, struct dma_page *page,
+			  void *vaddr, dma_addr_t dma)
+{
+	return false;
+}
+
+static void pool_init_page(struct dma_pool *pool, struct dma_page *page)
+{
+}
+#endif
+
 /**
  * dma_pool_create - Creates a pool of consistent memory blocks, for dma.
  * @name: name of pool, for diagnostics
@@ -223,9 +295,7 @@ static struct dma_page *pool_alloc_page(
 	page->vaddr = dma_alloc_coherent(pool->dev, pool->allocation,
 					 &page->dma, mem_flags);
 	if (page->vaddr) {
-#ifdef	DMAPOOL_DEBUG
-		memset(page->vaddr, POOL_POISON_FREED, pool->allocation);
-#endif
+		pool_init_page(pool, page);
 		pool_initialise_page(pool, page);
 		page->in_use = 0;
 		page->offset = 0;
@@ -245,9 +315,7 @@ static void pool_free_page(struct dma_po
 {
 	dma_addr_t dma = page->dma;
 
-#ifdef	DMAPOOL_DEBUG
-	memset(page->vaddr, POOL_POISON_FREED, pool->allocation);
-#endif
+	pool_init_page(pool, page);
 	dma_free_coherent(pool->dev, pool->allocation, page->vaddr, dma);
 	list_del(&page->page_list);
 	kfree(page);
@@ -336,29 +404,7 @@ void *dma_pool_alloc(struct dma_pool *po
 	page->offset = *(int *)(page->vaddr + offset);
 	retval = offset + page->vaddr;
 	*handle = offset + page->dma;
-#ifdef	DMAPOOL_DEBUG
-	{
-		int i;
-		u8 *data = retval;
-		/* page->offset is stored in first 4 bytes */
-		for (i = sizeof(page->offset); i < pool->size; i++) {
-			if (data[i] == POOL_POISON_FREED)
-				continue;
-			dev_err(pool->dev, "%s %s, %p (corrupted)\n",
-				__func__, pool->name, retval);
-
-			/*
-			 * Dump the first 4 bytes even if they are not
-			 * POOL_POISON_FREED
-			 */
-			print_hex_dump(KERN_ERR, "", DUMP_PREFIX_OFFSET, 16, 1,
-					data, pool->size, 1);
-			break;
-		}
-	}
-	if (!want_init_on_alloc(mem_flags))
-		memset(retval, POOL_POISON_ALLOCATED, pool->size);
-#endif
+	pool_check_block(pool, retval, offset, mem_flags);
 	spin_unlock_irqrestore(&pool->lock, flags);
 
 	if (want_init_on_alloc(mem_flags))
@@ -394,7 +440,6 @@ void dma_pool_free(struct dma_pool *pool
 {
 	struct dma_page *page;
 	unsigned long flags;
-	unsigned int offset;
 
 	spin_lock_irqsave(&pool->lock, flags);
 	page = pool_find_page(pool, dma);
@@ -405,35 +450,16 @@ void dma_pool_free(struct dma_pool *pool
 		return;
 	}
 
-	offset = vaddr - page->vaddr;
 	if (want_init_on_free())
 		memset(vaddr, 0, pool->size);
-#ifdef	DMAPOOL_DEBUG
-	if ((dma - page->dma) != offset) {
+	if (pool_page_err(pool, page, vaddr, dma)) {
 		spin_unlock_irqrestore(&pool->lock, flags);
-		dev_err(pool->dev, "%s %s, %p (bad vaddr)/%pad\n",
-			__func__, pool->name, vaddr, &dma);
 		return;
 	}
-	{
-		unsigned int chain = page->offset;
-		while (chain < pool->allocation) {
-			if (chain != offset) {
-				chain = *(int *)(page->vaddr + chain);
-				continue;
-			}
-			spin_unlock_irqrestore(&pool->lock, flags);
-			dev_err(pool->dev, "%s %s, dma %pad already free\n",
-				__func__, pool->name, &dma);
-			return;
-		}
-	}
-	memset(vaddr, POOL_POISON_FREED, pool->size);
-#endif
 
 	page->in_use--;
 	*(int *)vaddr = page->offset;
-	page->offset = offset;
+	page->offset = vaddr - page->vaddr;
 	/*
 	 * Resist a temptation to do
 	 *    if (!is_page_busy(page)) pool_free_page(pool, page);
_

Patches currently in -mm which might be from kbusch@kernel.org are


