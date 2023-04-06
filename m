Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A16B7C7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:44:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234964AbjDFCoV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234954AbjDFCoH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8ED8690
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0E186421A
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F267CC433EF;
        Thu,  6 Apr 2023 02:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749046;
        bh=a+dxZnbKFmanV19UPxnhThgRyl8SOUY2yTvLVC0pOpE=;
        h=Date:To:From:Subject:From;
        b=sq0hLeBGFSQzK+AYlHakpxyxKlWqnQh1BmYG55IqkFwQWY2mQjZIc5ZbKCMmdP9h1
         CysPkz8DsKmnjnoNYeUhDF62YRkbIzncKZ+zuZ9aLQZtZ3I+C3e9r1xIQ5pOOyLVAi
         F5BMPzWKBq9Q9fDSAY7B+ZsP3PYxtvHq3b5mo9Bc=
Date:   Wed, 05 Apr 2023 19:44:05 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tonyb@cybernetics.com, hch@lst.de, kbusch@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dmapool-rearrange-page-alloc-failure-handling.patch removed from -mm tree
Message-Id: <20230406024405.F267CC433EF@smtp.kernel.org>
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


