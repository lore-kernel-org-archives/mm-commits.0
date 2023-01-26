Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6DF5C61D97
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 22:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjAZWcN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 17:32:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232324AbjAZWcL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 17:32:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF245EF91
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 14:31:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39461B81F2E
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 22:31:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FCBC433D2;
        Thu, 26 Jan 2023 22:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674772315;
        bh=ZEt3vnbeGTcXNrJI7fWRFYBLLYgkAOcMGpDiWI+grH8=;
        h=Date:To:From:Subject:From;
        b=KTAO6T1fMRGGXNiinn6BaBeBbjbtyfNEsfnkjQYRGrND6PULUgLYwwgu4jpUn9aWO
         nQ+b2Nm/f6deWH+o1+M1FfjWU7oV6MyS1yuIpfWqzS86A5pACn9QcaMMoCKUZzzbut
         CkgDiZykOTcu/aLUZv+KOHg6PgypPRW9TH9+U1Eg=
Date:   Thu, 26 Jan 2023 14:31:55 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, kbusch@kernel.org,
        hch@lst.de, tonyb@cybernetics.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + dmapool-remove-checks-for-dev-==-null.patch added to mm-unstable branch
Message-Id: <20230126223155.D2FCBC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dmapool: remove checks for dev == NULL
has been added to the -mm mm-unstable branch.  Its filename is
     dmapool-remove-checks-for-dev-==-null.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dmapool-remove-checks-for-dev-==-null.patch

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

dmapool-remove-checks-for-dev-==-null.patch
dmapool-use-sysfs_emit-instead-of-scnprintf.patch
dmapool-cleanup-integer-types.patch
dmapool-speedup-dmapool_debug-with-init_on_alloc.patch

