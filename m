Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 388D6C7EE2A
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 22:39:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbjEEWjL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 18:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233312AbjEEWjJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 18:39:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D328149C5
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 15:39:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7004264155
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 22:39:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DC2C433EF;
        Fri,  5 May 2023 22:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683326347;
        bh=fYzkgyf5gHE0P/LnfgARjAbWm7cljr+iLMoIMggA4SA=;
        h=Date:To:From:Subject:From;
        b=Rsof7cKHEkDXts6GoX2BTEF+tWSxzMp6IHwqE8McCD8ouqocMsbgkpN+AXKxx/kwU
         AomXLSVg9mcWgPs1wY3DVPjTSSmJt8vPXHyYZf49MEIUd7led/0kLOvwB0wX5M/gAW
         5ecwBuGE5mNhp66ODpD9ghMaCVr5tMjk76OmPpo8=
Date:   Fri, 05 May 2023 15:39:07 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tonyb@cybernetics.com, hch@lst.de, kbusch@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dmapool-simplify-freeing.patch removed from -mm tree
Message-Id: <20230505223907.C1DC2C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: dmapool: simplify freeing
has been removed from the -mm tree.  Its filename was
     dmapool-simplify-freeing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Keith Busch <kbusch@kernel.org>
Subject: dmapool: simplify freeing
Date: Thu, 26 Jan 2023 13:51:22 -0800

The actions for busy and not busy are mostly the same, so combine these
and remove the unnecessary function.  Also, the pool is about to be freed
so there's no need to poison the page data since we only check for poison
on alloc, which can't be done on a freed pool.

Link: https://lkml.kernel.org/r/20230126215125.4069751-10-kbusch@meta.com
Fixes: 2d55c16c0c54 ("dmapool: create/destroy cleanup")
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

--- a/mm/dmapool.c~dmapool-simplify-freeing
+++ a/mm/dmapool.c
@@ -312,16 +312,6 @@ static inline bool is_page_busy(struct d
 	return page->in_use != 0;
 }
 
-static void pool_free_page(struct dma_pool *pool, struct dma_page *page)
-{
-	dma_addr_t dma = page->dma;
-
-	pool_init_page(pool, page);
-	dma_free_coherent(pool->dev, pool->allocation, page->vaddr, dma);
-	list_del(&page->page_list);
-	kfree(page);
-}
-
 /**
  * dma_pool_destroy - destroys a pool of dma memory blocks.
  * @pool: dma pool that will be destroyed
@@ -349,14 +339,14 @@ void dma_pool_destroy(struct dma_pool *p
 	mutex_unlock(&pools_reg_lock);
 
 	list_for_each_entry_safe(page, tmp, &pool->page_list, page_list) {
-		if (is_page_busy(page)) {
+		if (!is_page_busy(page))
+			dma_free_coherent(pool->dev, pool->allocation,
+					  page->vaddr, page->dma);
+		else
 			dev_err(pool->dev, "%s %s, %p busy\n", __func__,
 				pool->name, page->vaddr);
-			/* leak the still-in-use consistent memory */
-			list_del(&page->page_list);
-			kfree(page);
-		} else
-			pool_free_page(pool, page);
+		list_del(&page->page_list);
+		kfree(page);
 	}
 
 	kfree(pool);
_

Patches currently in -mm which might be from kbusch@kernel.org are


