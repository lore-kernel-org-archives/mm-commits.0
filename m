Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BE00C7EE24
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 22:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbjEEWjI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 18:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbjEEWjH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 18:39:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2315D4EC0
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 15:39:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AECD56415C
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 22:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0D6C433EF;
        Fri,  5 May 2023 22:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683326345;
        bh=CF88v0L62dn2uLKUbmDuaSCr+jhD6TBkHBQXLKeFAvs=;
        h=Date:To:From:Subject:From;
        b=nnJPnkz29vmPeZhbEOyMXTqE+P6n+uC2Eo2q4DJwuTRazBsJSn0lzM+4gP5dM8Ewn
         n+YW7WOETrJTddS7KpKvciMW3jmba67J0eGbfTD7mkL/Rarhbnlspuz94dAhHe9zcj
         ASXVWOGk4k458XbSE2a7W0OFfauPkdoh+XSJoPio=
Date:   Fri, 05 May 2023 15:39:04 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tonyb@cybernetics.com, hch@lst.de, kbusch@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dmapool-rearrange-page-alloc-failure-handling.patch removed from -mm tree
Message-Id: <20230505223905.0F0D6C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: dmapool: rearrange page alloc failure handling
has been removed from the -mm tree.  Its filename was
     dmapool-rearrange-page-alloc-failure-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Keith Busch <kbusch@kernel.org>
Subject: dmapool: rearrange page alloc failure handling
Date: Thu, 26 Jan 2023 13:51:20 -0800

Handle the error in a condition so the good path can be in the normal
flow.

Link: https://lkml.kernel.org/r/20230126215125.4069751-8-kbusch@meta.com
Fixes: 2d55c16c0c54 ("dmapool: create/destroy cleanup")
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/mm/dmapool.c~dmapool-rearrange-page-alloc-failure-handling
+++ a/mm/dmapool.c
@@ -292,17 +292,19 @@ static struct dma_page *pool_alloc_page(
 	page = kmalloc(sizeof(*page), mem_flags);
 	if (!page)
 		return NULL;
+
 	page->vaddr = dma_alloc_coherent(pool->dev, pool->allocation,
 					 &page->dma, mem_flags);
-	if (page->vaddr) {
-		pool_init_page(pool, page);
-		pool_initialise_page(pool, page);
-		page->in_use = 0;
-		page->offset = 0;
-	} else {
+	if (!page->vaddr) {
 		kfree(page);
-		page = NULL;
+		return NULL;
 	}
+
+	pool_init_page(pool, page);
+	pool_initialise_page(pool, page);
+	page->in_use = 0;
+	page->offset = 0;
+
 	return page;
 }
 
_

Patches currently in -mm which might be from kbusch@kernel.org are


