Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BA5AC54EAA
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 22:32:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbjAZWcZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 17:32:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231837AbjAZWcO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 17:32:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A584159992
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 14:32:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33A1A61982
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 22:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC7AC433D2;
        Thu, 26 Jan 2023 22:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674772328;
        bh=oYowGKAwRxr40yCqnX7mK0xgVVP4/hNTaOierf4u5lY=;
        h=Date:To:From:Subject:From;
        b=1jTTpxI1sjeeByZyQq3eKWoJb3pgZCtYDDdXQLryCg3Q3cQ8LsNgeOAxxrhql6cNn
         cWgWKwxhLh9V5zv8sImR/wqLJk9pjwGuOFJMDSlf5c9JM+kEAphHQvXWu7ZtGDHaIK
         /T07ELTegijtE2EAI6QqcMugLoTDQ0PoEpGkwh4s=
Date:   Thu, 26 Jan 2023 14:32:08 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tonyb@cybernetics.com, hch@lst.de, kbusch@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + dmapool-simplify-freeing.patch added to mm-unstable branch
Message-Id: <20230126223208.8EC7AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dmapool: simplify freeing
has been added to the -mm mm-unstable branch.  Its filename is
     dmapool-simplify-freeing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dmapool-simplify-freeing.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Keith Busch <kbusch@kernel.org>
Subject: dmapool: simplify freeing
Date: Thu, 26 Jan 2023 13:51:22 -0800

The actions for busy and not busy are mostly the same, so combine these
and remove the unnecessary function.  Also, the pool is about to be freed
so there's no need to poison the page data since we only check for poison
on alloc, which can't be done on a freed pool.

Link: https://lkml.kernel.org/r/20230126215125.4069751-10-kbusch@meta.com
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

dmapool-add-alloc-free-performance-test.patch
dmapool-move-debug-code-to-own-functions.patch
dmapool-rearrange-page-alloc-failure-handling.patch
dmapool-consolidate-page-initialization.patch
dmapool-simplify-freeing.patch
dmapool-dont-memset-on-free-twice.patch
dmapool-link-blocks-across-pages.patch
dmapool-create-destroy-cleanup.patch

