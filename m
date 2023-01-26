Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 852ADC61D97
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 22:32:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbjAZWcl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 17:32:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbjAZWcd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 17:32:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6238B65F15
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 14:32:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEF9D6192D
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 22:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27288C4339B;
        Thu, 26 Jan 2023 22:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674772334;
        bh=Wo0ti4vi+2U2QOuWQDYquf5zcp6y9Nxvz39nlgT5jZY=;
        h=Date:To:From:Subject:From;
        b=Tg36ClzNu8oV2RQnjnL0abR2LGOW0eW8j1PuL8t/FDXQLzfwFYfzngQqcaHGtSc7H
         cfY/mOEJGX3Q+H4ilZRJxjg5KckkUU4L3LCF4erN1Z+UqnUj6CcI7+PdtzhGawr4ic
         /7HeTi0T02o22Woq/dJwLG+LZ8l5jmT+GU+MZ284=
Date:   Thu, 26 Jan 2023 14:32:13 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tonyb@cybernetics.com, hch@lst.de, kbusch@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + dmapool-create-destroy-cleanup.patch added to mm-unstable branch
Message-Id: <20230126223214.27288C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dmapool: create/destroy cleanup
has been added to the -mm mm-unstable branch.  Its filename is
     dmapool-create-destroy-cleanup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dmapool-create-destroy-cleanup.patch

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
Subject: dmapool: create/destroy cleanup
Date: Thu, 26 Jan 2023 13:51:25 -0800

Set the 'empty' bool directly from the result of the function that
determines its value instead of adding additional logic.

Link: https://lkml.kernel.org/r/20230126215125.4069751-13-kbusch@meta.com
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
@@ -350,7 +349,7 @@ static struct dma_page *pool_alloc_page(
 void dma_pool_destroy(struct dma_pool *pool)
 {
 	struct dma_page *page, *tmp;
-	bool empty = false, busy = false;
+	bool empty, busy = false;
 
 	if (unlikely(!pool))
 		return;
@@ -358,8 +357,7 @@ void dma_pool_destroy(struct dma_pool *p
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

dmapool-add-alloc-free-performance-test.patch
dmapool-move-debug-code-to-own-functions.patch
dmapool-rearrange-page-alloc-failure-handling.patch
dmapool-consolidate-page-initialization.patch
dmapool-simplify-freeing.patch
dmapool-dont-memset-on-free-twice.patch
dmapool-link-blocks-across-pages.patch
dmapool-create-destroy-cleanup.patch

