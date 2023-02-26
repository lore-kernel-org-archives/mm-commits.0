Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38671C6FA8E
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 05:31:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjBZFbv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Feb 2023 00:31:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjBZFbu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Feb 2023 00:31:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA99D302
        for <mm-commits@vger.kernel.org>; Sat, 25 Feb 2023 21:31:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD66260BEC
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 05:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C852C433EF;
        Sun, 26 Feb 2023 05:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677389508;
        bh=u7fAC/f0bPPRRusIpKre8tedWUSCsWCbZaN5MZxpl9k=;
        h=Date:To:From:Subject:From;
        b=WKhCNSTAH+HJUsLcYjRN832QCci1h4pvyZz6/H7FfEO++4UVgneaW6Jls4kfxYZX+
         PDY5BzjnOCz34xCWfbCXG6/UDuVwNN8xGLhuLTQo7qQ6P8NQ9JPADd7hA3s9CnHMJH
         lZng9wyBNRHSLSROcE4EagTuIl6XhVemgCpURdKM=
Date:   Sat, 25 Feb 2023 21:31:47 -0800
To:     mm-commits@vger.kernel.org, hch@infradead.org,
        bryan.odonoghue@linaro.org, kbusch@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + dmapool-link-blocks-across-pages-fix.patch added to mm-unstable branch
Message-Id: <20230226053148.1C852C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dmapool: push new blocks in ascending order
has been added to the -mm mm-unstable branch.  Its filename is
     dmapool-link-blocks-across-pages-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dmapool-link-blocks-across-pages-fix.patch

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
Subject: dmapool: push new blocks in ascending order
Date: Tue, 21 Feb 2023 08:54:00 -0800

Some users of the dmapool need their allocations to happen in ascending
order.  The recent optimizations pushed the blocks in reverse order, so
restore the previous behavior by linking the next available block from
low-to-high.

usb/chipidea/udc.c qh_pool called "ci_hw_qh".  My initial thought was
dmapool isn't the right API if you need a specific order when allocating
from it, but I can't readily test any changes to that driver.  Restoring
the previous behavior is easy enough.

Link: https://lkml.kernel.org/r/20230221165400.1595247-1-kbusch@meta.com
Fixes: ced6d06a81fb69 ("dmapool: link blocks across pages")
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reported-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/dmapool.c~dmapool-link-blocks-across-pages-fix
+++ b/mm/dmapool.c
@@ -301,7 +301,7 @@ EXPORT_SYMBOL(dma_pool_create);
 static void pool_initialise_page(struct dma_pool *pool, struct dma_page *page)
 {
 	unsigned int next_boundary = pool->boundary, offset = 0;
-	struct dma_block *block;
+	struct dma_block *block, *first = NULL, *last = NULL;
 
 	pool_init_page(pool, page);
 	while (offset + pool->size <= pool->allocation) {
@@ -312,11 +312,22 @@ static void pool_initialise_page(struct dma_pool *pool, struct dma_page *page)
 		}
 
 		block = page->vaddr + offset;
-		pool_block_push(pool, block, page->dma + offset);
+		block->dma = page->dma + offset;
+		block->next_block = NULL;
+
+		if (last)
+			last->next_block = block;
+		else
+			first = block;
+		last = block;
+
 		offset += pool->size;
 		pool->nr_blocks++;
 	}
 
+	last->next_block = pool->next_block;
+	pool->next_block = first;
+
 	list_add(&page->page_list, &pool->page_list);
 	pool->nr_pages++;
 }
_

Patches currently in -mm which might be from kbusch@kernel.org are

dmapool-add-alloc-free-performance-test.patch
dmapool-move-debug-code-to-own-functions.patch
dmapool-rearrange-page-alloc-failure-handling.patch
dmapool-consolidate-page-initialization.patch
dmapool-simplify-freeing.patch
dmapool-dont-memset-on-free-twice.patch
dmapool-link-blocks-across-pages.patch
dmapool-link-blocks-across-pages-fix.patch
dmapool-create-destroy-cleanup.patch

